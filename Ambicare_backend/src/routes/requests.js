const express = require('express');
const auth = require("../middleware/auth")
const { userMiddleware, driverMiddleware, serviceMiddleware } = require("../middleware/role")
const { allRequests, addRequest, updateRequest, deleteRequest, particularRequest, driverNewRequest, onRequestComplete, userNewRequest, userHistory, driverHistory, serviceHistory } = require("../controller/requestController");
const router = express.Router();

router.get('/', auth, allRequests);
router.get('/:id', auth, particularRequest);
router.post('/add', auth, userMiddleware, addRequest);
router.put('/:id', auth, userMiddleware, updateRequest);
router.delete('/:id', auth, deleteRequest);
router.get('/new/:id', auth, driverMiddleware, driverNewRequest);
router.put('/requestcomplete/:id', auth, driverMiddleware, onRequestComplete);

router.get('/user/newrequest', auth, userMiddleware, userNewRequest);
router.get('/driver/history', auth, driverMiddleware, driverHistory);
router.get('/user/history', auth, userMiddleware, userHistory);
router.get('/service/history', auth, serviceMiddleware, serviceHistory);

module.exports = router; 