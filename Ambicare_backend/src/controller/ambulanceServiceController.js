const env = require('dotenv');
const bcrypt = require("bcrypt");
const { Ambulance } = require('../models/ambulance');
const {Request} = require('../models/request');
const { AmbulanceService, validate } = require('../models/ambulanceService');
env.config();


exports.profile = async (req, res) => {
    const ambulanceService = await AmbulanceService.findById({ _id: req.auth._id }).select('phoneNumber name email role');
    res.status(200).json(ambulanceService);
}

exports.signUp = async (req, res) => {
    const { error } = validate(req.body);
    if (error) return res.status(400).json({ message: error.details[0].message });

    // const ambulanceService = await AmbulanceService.findOne({ phoneNumber: req.body.phoneNumber })
    // if (ambulanceService) return res.status(400).json({ message: "Ambulance Service already exists" })
    const { phoneNumber, name, address } = req.body;
    const password = await bcrypt.hash(req.body.password, 10)
    const newAmbulanceService = new AmbulanceService({
        phoneNumber,
        name,
        password,
        address,
        role: 'service',
    });
    await newAmbulanceService.save();
    const token = newAmbulanceService.getAuthenticationToken();
    res.cookie('token', token, { expiresIn: '500hr' });
    res.status(201).json({ token: token, id:  newAmbulanceService._id });
}

exports.signIn = async (req, res) => {
    const ambulanceService = await AmbulanceService.findOne({ phoneNumber: req.body.phoneNumber })
    if (!ambulanceService) return res.status(400).json({ message: "Ambulance Service doesn't exist!" })

    const validPassword = await ambulanceService.isPasswordValid(req.body.password);
    if (!validPassword) return res.status(400).json({ message: "Invalid phone number or password" });
    if (validPassword && ambulanceService.role === 'service') {
        const token = ambulanceService.getAuthenticationToken();
        res.cookie('token', token, { expiresIn: '500hr' });

        res.status(200).json({ token: token, id:  ambulanceService._id });
    }
}

exports.updateName = async (req, res) => {
    const { name } = req.body;
    const updateService = await AmbulanceService.updateOne({ "_id": req.auth._id }, {
        $set: {
            name: name
        }
    });
    const updateAmbulance = await Ambulance.updateMany({ "ownedBy._id": req.auth._id }, {
        $set: {
            "ownedBy.ambulanceService": name
        }
    });
    const updateRequest = await Request.updateMany({ "requestedTo.serviceId": req.auth._id }, {
        $set: {
            "requestedTo.ambulanceService": name
        }
    });
    if (updateService.acknowledged !== true || 
        updateAmbulance.acknowledged !== true ||
        updateRequest.acknowledged !== true)
        return res.status(404).json({ message: 'something went wrong' });
    res.status(200).json('Service name updated!');
}

exports.updateNumber = async (req, res) => {
    const { phoneNumber } = req.body;
    const updateService = await AmbulanceService.updateOne({ "_id": req.auth._id }, {
        $set: {
            phoneNumber: phoneNumber
        }
    });
    const updateAmbulance = await Ambulance.updateMany({ "ownedBy._id": req.auth._id }, {
        $set: {
            "ownedBy.phoneNumber": phoneNumber
        }
    });
    const updateRequest = await Request.updateMany({"requestedTo.serviceId": req.auth._id}, {
        $set: {
            "requestedTo.servicePhoneNumber":phoneNumber
        }
    });
    if (updateService.acknowledged !== true || 
        updateAmbulance.acknowledged !== true ||
        updateRequest.acknowledged !== true)
        return res.status(404).json({ message: 'something went wrong' });
    res.status(200).json('Service phoneNumber updated!');
}

exports.setNewPassword = async (req, res) => {
    const { newPassword, phoneNumber } = req.body;
    const hash_new_password = await bcrypt.hash(newPassword, 10);
    const ambulanceService = await AmbulanceService.findOneAndUpdate({ "phoneNumber": phoneNumber }, {
        $set: {
            password: hash_new_password,
        }
    })
    if(!ambulanceService) return res.status(404).json({ message: 'Something went wrong' });
    res.status(200).json('User password Updated!');
}

exports.signOut = (req, res) => {
    res.clearCookie('token');
    res.status(200).json({
        messsage: 'Signout Successful...!'
    });
}

exports.deleteAccount = async (req, res) => {
    const requestData = await Request.deleteMany({ "requestedTo.serviceId": req.auth._id });
    const serviceData = await User.findByIdAndRemove(req.auth._id);
    if(requestData.deletedCount == 0 || !serviceData)
        return res.status(404).json({message: 'something went wrong'});
    res.status(200).json('Service account deleted!');
}

exports.serviceExists = async (req, res) => {
    const phoneNumber = req.params.id;
    const service = await AmbulanceService.findOne({ "phoneNumber": phoneNumber })
    if (service) return res.status(400).json({ message: "Service exist" })
    res.status(200).json({message: "Service doesnot exist"})
}