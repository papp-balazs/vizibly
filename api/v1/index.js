const express = require('express');
const dotenv = require('dotenv');
const mongoose = require('mongoose');
const cookieParser = require('cookie-parser');

const app = express();

dotenv.config();

mongoose.connect(
	process.env.DB_CONNECTION_STRING,
	{
		useNewUrlParser: true,
		useUnifiedTopology: true
	},
	() => console.log('Connected to the MongoDB database!')
);

const usersRoute = require('./routes/users.js');
const postsRoute = require('./routes/posts.js');

app.use(express.json());
app.use(cookieParser());

app.use('/api/v1/users', usersRoute);
app.use('/api/v1/posts', postsRoute);

app.listen(3000, () => console.log('The serves is running!'));
