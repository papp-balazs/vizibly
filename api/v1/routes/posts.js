const router = require('express').Router();
const verify = require('./verifyToken.js');

router.get('/', verify, (req, res) => {
	res.json({
		posts: [
			{
				title: 'This is my first post',
				content: 'This is my very very first post, I hope you really enjoyed it!'
			}
		]
	});
});

module.exports = router;
