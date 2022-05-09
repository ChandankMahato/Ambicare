const { Ambulance, validate } = require('../models/ambulance');
const { AmbulanceService } = require('../models/ambulanceService');


exports.allAmbulances = async (req, res) => {
    const ambulances = await Ambulance.find({ "isAvailable": true });
    res.status(200).json(ambulances);
}

exports.addAmbulance = async (req, res) => {
    const { error } = validate(req.body);
    if (error) return res.status(400).json({ message: error.details[0].message });

    const { registrationNumber, location, isAvailable, ambulanceType } = req.body;
    const ownedBy = req.auth._id;
    // console.log(ownedBy);


    const ambulanceService = await AmbulanceService.findById(ownedBy)
    if (!ambulanceService) return res.status(400).json({ message: "Invalid ambulance service" })

    const ambulance = new Ambulance({
        registrationNumber,
        location,
        isAvailable,
        type: ambulanceType.type,
        farePerKm: ambulanceType.farePerKm,
        ownedBy: {
            _id: ambulanceService._id,
            ambulanceService: ambulanceService.name,
            phoneNumber: ambulanceService.phoneNumber,
        }
        
    });
    await ambulance.save();
    res.status(200).json(ambulance);
}

exports.updateAmbulance = async (req, res) => {
    const { error } = validate(req.body);
    if (error) return res.status(400).send(error.details[0].message);

    const { registrationNumber, location, isAvailable, ambulanceType } = req.body;
    const ownedBy = req.auth._id;

    const ambulanceService = await AmbulanceService.findById(ownedBy)
    const ambulance = {
        registrationNumber,
        location,
        isAvailable,
        type: ambulanceType.type,
        farePerKm: ambulanceType.farePerKm,
        ownedBy: {
            _id: ambulanceService._id,
            ambulanceService: ambulanceService.name,
            phoneNumber: ambulanceService.phoneNumber,
        }
    }
    const updateAmbulance = await Ambulance.findOneAndUpdate({ "_id": req.params.id }, ambulance, { new: true });
    if (!updateAmbulance) return res.status(404).json({ message: 'The ambulances with the given registration was not found.' });
    res.status(200).json(updateAmbulance);
}

exports.updateType = async (req, res) => {
    const { id, type } = req.body;
    const ambulance = await Ambulance.findOneAndUpdate({ "_id": id }, {
        $set: {
            type: type
        }
    });
        
    if (!ambulance) return res.status(404).send('The ambulance was not found.');
    res.status(200).json('Ambulance type updated');
}

exports.deleteAmbulance = async (req, res) => {
    const ambulance = await Ambulance.findByIdAndRemove(req.params.id);
    if (!ambulance) return res.status(404).json({ message: 'Ambulance not found.' });
    return res.status(200).json({ message: 'The ambulance was deleted!' });
}

exports.particularAmbulance = async (req, res) => {
    const ambulance = await Ambulance.findOne({ "registrationNumber": req.params.id });
    if (!ambulance) return res.status(404).json({ message: 'The request with the given regsitration was not found.' });
    return res.status(200).json(ambulance);
}

exports.ownedBy = async (req, res) => {
    const ambulance = await Ambulance.find({ "ownedBy._id": req.params.id });
    console.log(ambulance);
    if (!ambulance) return res.status(404).json({ message: 'You currently donot own any ambulances' });
    return res.status(200).json(ambulance);
}

exports.changeAvailability = async (req, res) => {
    const { id, isAvailable } = req.body;
    const ambulance = await Ambulance.findOneAndUpdate({ "_id": id }, {
        $set: {
            isAvailable: isAvailable
        }
    });
        
    if (!ambulance) return res.status(404).send('The ambulance was not found.');
    res.status(200).json('Ambulance availability updated');
}

exports.updateAmbulanceLocation = async (req, res) => {
    const { regNo, latitude, longitude } = req.body;
    const ambulance = await Ambulance.findOneAndUpdate({ "registrationNumber": regNo }, {
        $set: {
            "location.latitude": latitude,
            "location.longitude": longitude,
        }
    });
    if (!ambulance) return res.status(404).send('The ambulance was not found.');
    res.status(200).json('Ambulance location updated');
}
