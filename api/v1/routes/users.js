const router = require('express').Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const User = require('../model/User.js');

// Get all users
router.get('/', async (req, res) => {
	const user = await User.find({});
	res.send(user);
});

// Get a specific user by ID
router.get('/:id', async (req, res) => {
	const user = await User.findById(req.params.id);
	if (!user) {
		return res.status(400).json({
			error: 'There is no user with this ID'
		});
	}

	res.send(user);
});

// Create new user
router.post('/', async (req, res) => {
	const { username, email, password } = req.body;

	const usernameExist = await User.findOne({ username });
	if (usernameExist) {
		return res.status(400).json({
			error: 'This username is already taken!'
		});
	}

	const emailExist = await User.findOne({ email });
	if (emailExist) {
		return res.status(400).json({
			error: 'This email address is already taken!'
		});
	}

	const salt = await bcrypt.genSalt(10);
	const hashedPassword = await bcrypt.hash(password, salt);

	const user = new User({
		username,
		email,
		password: hashedPassword
	});

	try {
		const savedUser = await user.save();
		res.send({ user: user._id });
	} catch (err) {
		res.status(400).send(err);
	}
});

// Auth user
router.post('/auth', async (req, res) => {
	const { email, password } = req.body;

	const user = await User.findOne({ email });
	
	if (!user) {
		return res.status(400).json({
			error: 'There is no user with this email address!'
		});
	}

	const validatePassword = await bcrypt.compare(
		password,
		user.password
	);
	if (!validatePassword) {
		return res.status(400).json({
			error: 'Incorrect password!'
		});
	}

	const token = jwt.sign(
		{ _id: user._id },
		process.env.TOKEN_SECRET
	);

	res.header('Auth-Token', token).send(token);
});

module.exports = router;
