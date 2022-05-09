const Joi = require("joi");
Joi.objectId = require("joi-objectid")(Joi);
const mongoose = require('mongoose');

const requestSchema = new mongoose.Schema({
    isPending: {
        type: Boolean,
        default: true
    },
    pickupLocation: {
        type: mongoose.Schema({
            longitude: {
                type: Number,
                required: true
            },
            latitude: {
                type: Number,
                required: true
            }
        }),
        required: true,
    },
    destination: {
        type: mongoose.Schema({
            longitude: {
                type: Number,
                // required: true
                default: null
            },
            latitude: {
                type: Number,
                default: null,
                // required: true
            }
        }),
        // required: true,
        default: null
    },
    requestedBy: {
        type: mongoose.Schema({
            userId: {
                type: mongoose.Schema.Types.ObjectId,
                require: true
            },
            name: {
                type: String,
                required: true,
                minlength: 2,
                maxlength: 255,
                trim: true
            },
            phoneNumber: {
                type: Number,
                required: true
            },
        }),
        required: true
    },
    requestedTo: {
        type: mongoose.Schema({
            serviceId: {
                type: mongoose.Schema.Types.ObjectId,
                require: true
            },
            ambulanceService: {
                type: String,
                required: true,
            },
            servicePhoneNumber: {
                type: Number,
                required: true
            },
            driverId: {
                type: mongoose.Schema.Types.ObjectId,
                require: true
            },
            driverName: {
                type: String,
                required: true,
                minlength: 2,
                maxlength: 255,
                trim: true
            },
            driverImage: String,
            driverPhoneNumber: {
                type: Number,
                required: true
            },
        }),
        required: true
    },
    ambulance: mongoose.Schema({
        registrationNumber: {
            type: String,
            required: true,
        },
        location: {
            type: mongoose.Schema({
                longitude: {
                    type: Number,
                    required: true
                },
                latitude: {
                    type: Number,
                    required: true
                }
            }),
            required: true,
        },
        type: {
            type: String,
            required: true
        },
        farePerKm: {
            type: Number,
            required: true,
        }
    }),
}, {timestamps: true} );

function validateRequest(request) {
    const schema = Joi.object({
        isPending: Joi.boolean(),
        //   pickupLocation: Joi.object().pattern(/.*/, Joi.number().required()).required(),
        pickupLocation: Joi.object({
            longitude: Joi.number().required(),
            latitude: Joi.number().required()
        }).required(),

        destination: Joi.object({
            longitude: Joi.number(),
            latitude: Joi.number()
        }),
        // requestedBy: Joi.objectId().required(),
        requestedTo: Joi.object({
            ambulanceService: Joi.objectId().required(),
            driver: Joi.objectId().required()
        }),
        ambulanceRegNo: Joi.string().required(),

    });

    return schema.validate(request);
}

exports.Request = mongoose.model("Request", requestSchema);
exports.validate = validateRequest;