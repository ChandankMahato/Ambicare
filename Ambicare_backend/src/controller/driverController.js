const {Driver, validate } = require('../models/driver');
const {Request} = require('../models/request');
const env = require('dotenv');
const bcrypt = require("bcrypt");
const { Ambulance } = require('../models/ambulance');
const { AmbulanceService } = require('../models/ambulanceService');
const mongoose = require('mongoose');
env.config();

exports.profile = async (req, res) => {
    const driver = await Driver.findById({ _id: req.auth._id }).select('phoneNumber name ambulance worksFor.ambulanceService role');
    res.status(200).json(driver);
}

exports.worksFor = async (req, res) => {
    const driver = await Driver.find({ "worksFor._id": req.params.id });
    if (!driver) return res.status(404).json({ message: 'You currently donot have any drivers' });
    return res.status(200).json(driver);
}

exports.signIn = async (req, res) => {
    console.log("abbs")
    const { registrationNumber, phoneNumber, password } = req.body;
    const session = await mongoose.startSession();
    session.startTransaction();
    try {
        console.log("hi");
        // update ambulance in driver
        const driver = await Driver.findOneAndUpdate({ "phoneNumber": phoneNumber }, {
            $set: {
                "ambulance": registrationNumber,
            }
        }, {session: session, new: true, upsert: true });

        if (!driver) throw Error("Error");

        // update driver in ambulance
        const driverData = {
            "_id": driver._id,
            "name": driver.name,
            "phoneNumber": driver.phoneNumber,
        }
        const ambulance = await Ambulance.findOneAndUpdate({ "registrationNumber": registrationNumber }, {
            $set: {
                driver: driverData,
                isAvailable: true,
            }
        }, {session: session, new: true, upsert: true });
        if (!ambulance) throw Error("Error");

        
        const validPassword = await driver.isPasswordValid(password);
        if (!validPassword) throw Error("Error");
        
        if (validPassword && driver.role === 'driver') {
            const token = driver.getAuthenticationToken();
            res.cookie('token', token, { expiresIn: '500hr' });
            await session.commitTransaction();
            session.endSession();
            return res.status(200).json({ token: token, id: driver._id, regNo: registrationNumber });
        } else throw Error("Error");
        
    } catch (ex) {
        console.log("hi1");
        await session.abortTransaction();
        session.endSession();
        return res.status(400).json({ message: "Invalid phone number or password" })
    }
}

exports.updateAmbulance = async (req, res) => {
    const { regNo } = req.body;
    const ambulance = await Ambulance.findOne({ "registrationNumber": regNo });
    if (!ambulance) return res.status(404).send('The ambulance was not found.');

    const driver = await Driver.updateOne({ "_id": id }, {
        $set: {
            ambulance: regNo
        }
    });
    if (!driver.acknowledged) return res.status(404).send('The driver was not found.');
    res.status(200).json("Driver's ambulance updated");
}

exports.addDriver = async (req, res) => {
    const { error } = validate(req.body);
    if (error) return res.status(400).json({ message: error.details[0].message });

    const { phoneNumber, password, name } = req.body;

    const worksFor = req.auth._id;
    const ambulanceService = await AmbulanceService.findById(worksFor)
    if (!ambulanceService) return res.status(400).json({ message: "Invalid ambulance service" })

    const hashedPassword = await bcrypt.hash(password, 10);

    const ambulance = new Driver({
        phoneNumber,
        password: hashedPassword,
        name,
        worksFor: {
            _id: ambulanceService._id,
            ambulanceService: ambulanceService.name,
            phoneNumber: ambulanceService.phoneNumber,
        }
        
    });
    await ambulance.save();
    res.status(200).json(ambulance);   
}

exports.updateName = async (req, res) => {
    const { name } = req.body;
    const updateDriver = await Driver.updateOne({ "_id": req.auth._id }, {
        $set: {
            name: name
        }
    });
    const updateRequest = await Request.updateMany({"requestedTo.driverId":req.auth._id},{
        $set: {
            "requestedTo.driverName":name
        }
    });

    const updateAmbulance = await Ambulance.updateMany({"driver._id":req.auth._id},{
        $set: {
            "driver.name":name
        }
    });

    if (updateDriver.acknowledged !== true || 
        updateRequest.acknowledged !== true ||
        updateAmbulance.acknowledged != true)
        return res.status(404).json({ message: 'something went wrong' });
    res.status(200).json('Driver name updated!');
}

exports.updateNumber = async (req, res) => {
    const { phoneNumber } = req.body;
    const updateDriver = await Driver.updateOne({ "_id": req.auth._id }, {
        $set: {
            phoneNumber: phoneNumber
        }
    });
    const updateRequest = await Request.updateMany({"requestedTo.driverId":req.auth._id},{
        $set: {
            "requestedTo.driverPhoneNumber":phoneNumber
        }
    });
    if (updateDriver.acknowledged !== true || 
        updateRequest.acknowledged !== true)
        return res.status(404).json({message: 'something went wrong'});
    res.status(200).json('Driver phoneNumber updated!');
}

exports.setNewPassword = async(req, res) => {
    const { newPassword, phoneNumber } = req.body;
    const hash_new_password = await bcrypt.hash(newPassword, 10);
    const driver = await Driver.findOneAndUpdate({ "phoneNumber": phoneNumber }, {
        $set: {
            password: hash_new_password,
        }
    })
    if(!driver) return res.status(404).json({ message: 'Something went wrong' });
    res.status(200).json('User password Updated!');
}

exports.signOut = async (req, res) => {
    const { registrationNumber } = req.body;
    const session = await mongoose.startSession();
    session.startTransaction();
    try {
        // update ambulance in driver
        const driver = await Driver.findByIdAndUpdate(req.auth._id, {
            $set: {
                "ambulance": null,
            }
        }, {session: session, new: true, upsert: true });

        if (!driver) throw Error("Error");

        // update driver in ambulance
        const ambulance = await Ambulance.findOneAndUpdate({ "registrationNumber": registrationNumber }, {
            $set: {
                driver: null,
                isAvailable: false,
            }
        }, {session: session, new: true, upsert: true });
        if (!ambulance) throw Error("Error");
        
        res.clearCookie('token');
        await session.commitTransaction();
        session.endSession();
        res.status(200).json({
            messsage: 'Signout Successful...!'
        });
    } catch (ex) {
        await session.abortTransaction();
        session.endSession();
        return res.status(400).json({ message: "Invalid phone number or password" })
    }
  
}

exports.deleteAccount = async (req, res) => {
    const requestData = await Request.deleteMany({ "requestedTo.driverId": req.params.id });
    const driverData = await Driver.findByIdAndRemove(req.params.id);
    if(!driverData) return res.status(400).json({ message: "Invalid driver" })
    // if(requestData.deletedCount == 0 || !driverData)
    //     return res.status(404).json({message: 'something went wrong'});
    res.status(200).json({ message: 'Driver account deleted!'});
}

exports.saveToken = async (req, res) => {
    const { token } = req.body;
    const driver = await Driver.findByIdAndUpdate( req.auth._id , {
        $set: {
            token: token
        }
    });
    if (!driver) return res.status(400).json({ message: "Invalid driver" });
    
    res.status(200).json({ message: 'Token saved' });
}

exports.getToken = async (req, res) => {
    const driver = await Driver.findById(req.params.id);
    if (!driver) return res.status(400).json({ message: "Invalid driver" });
    res.status(200).json({ token: driver["token"] });
}

exports.driverExists = async (req, res) => {
    const phoneNumber = req.params.id;
    const driver = await Driver.findOne({ "phoneNumber": phoneNumber })
    if (driver) return res.status(400).json({ message: "Driver exists" })
    res.status(200).json({message: "Driver doesnot exists"})
}