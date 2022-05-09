const { Request, validate } = require('../models/request');
const { User } = require('../models/user');
const { Ambulance } = require('../models/ambulance');
const { Driver } = require('../models/driver');
const { AmbulanceService } = require('../models/ambulanceService');
const  mongoose = require('mongoose');

exports.allRequests = async (req, res) => {
  const requests = await Request.find();
  res.status(200).json(requests);
}


exports.addRequest = async (req, res) => {
  const { error } = validate(req.body);
  if (error) return res.status(400).json(error.details[0].message);
  
  const request = await Request.findOne({ "requestedBy.userId": req.auth.id, isPending: true });
  if (request) return res.status(400).json({ message: 'User already has a pending request' });

  const { pickupLocation, destination, requestedTo, ambulanceRegNo } = req.body;

  const user = await User.findById(req.auth.id).select("name phoneNumber");
  if (!user) return res.status(404).json({ message: 'Invalid user' });

  const ambulanceService = await AmbulanceService.findById(requestedTo.ambulanceService).select("name phoneNumber");
  if (!ambulanceService) return res.status(404).json({ message: 'Invalid ambulance service' });

  const driver = await Driver.findById(requestedTo.driver).select("name phoneNumber");
  if (!driver) return res.status(404).json({ message: 'Driver not found' });

  const ambulance = await Ambulance.findOne({ registrationNumber: ambulanceRegNo }).select("registrationNumber type farePerKm isAvailable location");
  if (!ambulance || !ambulance.isAvailable) throw Error("Error");

  const session = await mongoose.startSession();
  session.startTransaction();
  try {
  const request = new Request({
    isPending: true,
    pickupLocation: pickupLocation,
    destination: destination,
    requestedBy: {
      userId: user._id,
      name: user.name,
      phoneNumber: user.phoneNumber,
    },
    requestedTo: {
      serviceId: ambulanceService._id,
      ambulanceService: ambulanceService.name,
      servicePhoneNumber: ambulanceService.phoneNumber,
      driverId: driver._id,
      driverName: driver.name,
      driverPhoneNumber: driver.phoneNumber,
    },
    ambulance: {
      location: {
        longitude: ambulance["location"]["longitude"],
        latitude: ambulance["location"]["latitude"],
      },
      registrationNumber: ambulance.registrationNumber,
      farePerKm: ambulance.farePerKm,
      type: ambulance.type,
    }
  });
    await request.save({ session: session });

  const updatedAmbulance = await Ambulance.findOneAndUpdate({ "registrationNumber": ambulanceRegNo }, {
    $set: {
      isAvailable: false,
    }
  }, { session: session, new: true });
    
    if (!updatedAmbulance) throw Error("Error")

    await session.commitTransaction();
    session.endSession();
    return res.status(200).json({ message: "Request sent" });

  } catch (ex) {
    await session.abortTransaction();
    session.endSession();
    // console.log(ex);
    return res.status(404).json({ message: 'Ambulance not found' });
  }
}

exports.onRequestComplete = async (req, res) => {
  const { longitude, latitude, ambulanceRegistration } = req.body;
  const session = await mongoose.startSession();
  session.startTransaction();
  try {
    const request = await Request.findByIdAndUpdate(req.params.id, {
      $set: {
        "isPending": false,
      }
    }, {session: session, new: true, upsert: true });
    if (!request) throw Error("Error");
    //TODO: transaction for request isCompleted true and 
    //ambulance location and isAvailable to true.
    const ambulance = await Ambulance.findOneAndUpdate({ "registrationNumber": ambulanceRegistration }, {
      $set: {
        "isAvailable": true,
        "location.latitude": latitude, 
        "location.longitude": longitude,
      }
    }, {session: session, new: true, upsert: true });
    if (!ambulance) throw Error("Error");

    await session.commitTransaction();
    session.endSession();
    return res.status(200).json({ message: "Transaction Successful" });

  } catch (ex) {
    await session.abortTransaction();
    session.endSession();
    return res.status(400).json({ message: "Transaction not completed" })
  }
  
}

const Message = 'The request with the given Id was not found';

exports.updateRequest = async (req, res) => {
  const { error } = validate(req.body);
  if (error) return res.status(400).send(error.details[0].message);

  const { isPending, pickupLocation, destination, requestedTo, ambulanceRegNo } = req.body;

  const user = await User.findById(req.auth.id).select("name phoneNumber");
  if (!user) return res.status(404).json({ message: 'Invalid user' });

  const ambulanceService = await AmbulanceService.findById(requestedTo.ambulanceService).select("name phoneNumber");
  if (!ambulanceService) return res.status(404).json({ message: 'Invalid ambulance service' });

  const driver = await Driver.findById(requestedTo.driver).select("name phoneNumber");
  if (!driver) return res.status(404).json({ message: 'Driver not found' });

  const ambulance = await Ambulance.findOne({ registrationNumber: ambulanceRegNo }).select("registrationNumber type farePerKm location");
  if (!ambulance) return res.status(404).json({ message: 'Ambulance not found' });


  const request = new Request({
    isPending: isPending,
    pickupLocation: pickupLocation,
    destination: destination,
    requestedBy: {
      userId: user._id,
      name: user.name,
      phoneNumber: user.phoneNumber,
    },
    requestedTo: {
      serviceId: ambulanceService._id,
      ambulanceService: ambulanceService.name,
      servicePhoneNumber: ambulanceService.phoneNumber,
      driverId: driver._id,
      driverName: driver.name,
      driverPhoneNumber: driver.phoneNumber,
    },
    ambulance: {
      location: {
        longitude: ambulance["location"]["longitude"],
        latitude: ambulance["location"]["latitude"],
      },
      registrationNumber: ambulance.registrationNumber,
      farePerKm: ambulance.farePerKm,
      type: ambulance.type,
    }
  });
  const updateRequest = await Request.findOneAndUpdate({ "_id": req.params.id }, request, { new: true });
  if (!updateRequest) return res.status(404).json({ message: Message });
  res.status(200).json(updateRequest);
}

exports.deleteRequest = async (req, res) => {
  const request = await Request.findByIdAndRemove(req.params.id);
  if (!request) return res.status(404).json({ message: Message });
  res.status(200).json({ message: 'Request Deleted!' });
}

exports.particularRequest = async (req, res) => {
  const request = await Request.findById(req.params.id);
  if (!request) return res.status(404).json({ message: Message });
  res.status(200).json(request);
}

exports.driverNewRequest = async (req, res) => {
  const request = await Request.findOne({ "requestedTo.driverId": req.auth._id, isPending: true },);
  // console.log(request);
  if (!request) {
    res.status(200).json({});
  } else {
    res.status(200).json(request);
  }
}

exports.userNewRequest = async (req, res) => {
  const request = await Request.findOne({ "requestedBy.userId": req.auth.id, isPending: true },);
  if (!request) {
    res.status(200).json({});
  } else { 
    res.status(200).json(request);
  }
}

exports.userHistory = async (req, res) => {
  const requests = await Request.find({ "requestedBy.userId": req.auth.id, isPending: false });
  res.status(200).json(requests);
}

exports.driverHistory = async (req, res) => {
  const requests = await Request.find({ "requestedTo.driverId": req.auth._id, isPending: false });
  res.status(200).json(requests);
}

exports.serviceHistory = async (req, res) => {
  const requests = await Request.find({ "requestedTo.serviceId": req.auth._id, isPending: false });
  res.status(200).json(requests);
}



