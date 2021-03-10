const jwt = require('jsonwebtoken');

module.exports = (req, res, next) => {
	const token = req.cookies["Auth-Token"];
		if (!token) {
		return res.status(401).json({
			error: 'Access denied!'
		});
	}

	try {
		const verified = jwt.verify(
			token,
			process.env.TOKEN_SECRET
		);

		req.user = verified;

		next();
	} catch (err) {
		res.status(400).json({
			error: 'Invalid Token!'
		});
	}
};
