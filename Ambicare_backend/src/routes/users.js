const express = require('express');
const { userMiddleware } = require('../middleware/role');
const auth = require("../middleware/auth");
const { profile, signUp, signIn, signOut, updateName, updateNumber, setNewPassword, deleteAccount, userExists } 
= require('../controller/userController');
const router = express.Router();

router.get('/me', auth, userMiddleware, profile);
router.get('/exists/:id', userExists);


router.post('/signup', signUp);
router.post('/signin', signIn);
router.post('/signout', auth, signOut);

router.put('/update/name', auth, userMiddleware, updateName);
router.put('/update/phone', auth, userMiddleware, updateNumber);
router.put('/update/password', setNewPassword);

router.delete('/delete', auth, userMiddleware, deleteAccount);
module.exports = router;