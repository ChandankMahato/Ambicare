const express = require('express');
const { allAmbulances, addAmbulance, updateAmbulance, deleteAmbulance, particularAmbulance, ownedBy, changeAvailability, updateType, updateAmbulanceLocation } 
= require("../controller/ambulanceController");
const auth = require("../middleware/auth")
const { serviceMiddleware, driverMiddleware } = require("../middleware/role")
const router = express.Router();

router.get('/', auth, allAmbulances);
router.get('/:id', auth, particularAmbulance);
router.post('/add', auth, serviceMiddleware, addAmbulance);
router.put('/:id', auth, serviceMiddleware, updateAmbulance);
router.delete('/delete/:id', auth, serviceMiddleware, deleteAmbulance);
router.get('/ownedby/:id', auth, serviceMiddleware, ownedBy);
router.put('/update/availability', auth, changeAvailability);
router.put('/update/type', auth, serviceMiddleware, updateType);
router.put('/update/location', auth, driverMiddleware, updateAmbulanceLocation);

module.exports = router; 