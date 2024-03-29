const Joi = require("joi");
Joi.objectId = require("joi-objectid")(Joi);
const mongoose = require("mongoose");

const ambulanceSchema = new mongoose.Schema({
    registrationNumber: {
        type: String,
        trim: true,
        required: true,
        unique: true
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
            },
        }),
        required: true,
    },
    isAvailable: {
        type: Boolean,
        default: false,
    },
    type: {
        type: String,
        enum: ['Mobile ICU', 'Basic Life Support', 'Multiple Victim', "Neonatal", "Isolation"],
        default: 'Basic Life Support Ambulance'
    },
    farePerKm: {
        type: Number,
        required: true
    },
    driver: {
        type: mongoose.Schema({
            _id: {
                type: mongoose.Schema.Types.ObjectId,
            },
            name: {
                type: String,
                trim: true,
                min: 2,
                max: 255, 
            },
            phoneNumber: {
                type: Number,
            }
        }),
        default: null
    },
    ownedBy: {
        type: mongoose.Schema({
            _id: {
                type: mongoose.Schema.Types.ObjectId,
                required: true
            },
            ambulanceService: {
                type: String,
                required: true,
                trim: true,
            },
            phoneNumber: {
                type: Number,
                required: true
            }
        }),
    }
});

function validateAmbulance(ambulance) {
    const schema = Joi.object({
        registrationNumber: Joi.string().required(),

        location: Joi.object({
            longitude: Joi.number().required(),
            latitude: Joi.number().required()
        }).required(),

        isAvailable: Joi.boolean(),
        // type: Joi.string().required(),
        // farePerKm: Joi.number().required(),

        ambulanceType: Joi.object({
            type: Joi.string().required(),
            farePerKm: Joi.number().required(),
        }),
    });

    return schema.validate(ambulance);
}

exports.Ambulance = mongoose.model("Ambulance", ambulanceSchema);
exports.validate = validateAmbulance;