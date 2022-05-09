const express = require('express');
const auth = require("../middleware/auth")
const { driverMiddleware, serviceMiddleware, userMiddleware } = require("../middleware/role")
const { profile, signIn, signOut, updateName, updateNumber, setNewPassword, addDriver, updateAmbulance, worksFor, saveToken, getToken, driverExists } 
= require('../controller/driverController');
const { deleteAccount } = require('../controller/driverController');
const router = express.Router();

router.get('/me', auth, profile);
router.get('/worksFor/:id', auth, worksFor)
router.get('/token/:id', auth, getToken)
router.put('/savetoken', auth, driverMiddleware, saveToken)
router.get('/exists/:id', auth, serviceMiddleware, driverExists);

router.post('/signin', signIn);
router.post('/signout', auth, driverMiddleware, signOut);

router.post('/add', auth, serviceMiddleware, addDriver);
router.put('/updateAmbulance', auth, driverMiddleware, updateAmbulance);
router.put('/update/name', auth, driverMiddleware, updateName);
router.put('/update/phone', auth, driverMiddleware, updateNumber);
router.put('/update/password', setNewPassword);

// router.delete('/delete', auth, driverMiddleware, deleteAccount);
router.delete('/delete/:id', auth, serviceMiddleware, deleteAccount);

module.exports = router;