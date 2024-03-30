const express = require('express');
require('express-async-errors')
const authRoutes = require('./routes/authRoutes');
const postRoutes = require('./routes/postRoutes');
const profileRoutes = require('./routes/profileRoutes');
const friendRoutes = require('./routes/friendRoutes');
const groupRoutes = require('./routes/groupRoutes');
const userRoutes = require('./routes/userRoutes');
const config = require('./utils/config')
const logger = require('./utils/logger')
const middleware = require('./utils/middleware')
const mongoose = require('mongoose');
const cors = require('cors'); 


const cookieParser = require('cookie-parser');
const { requireAuth, requireAdmin } = require('./middleware/authmiddleware');

const app = express();

// middleware
app.use(cors()); 
app.use(express.static('public'));
app.use(express.json());
app.use(middleware.requestLogger)
app.use(cookieParser());

// view engine
app.set('view engine', 'ejs');

mongoose.set('strictQuery', false)

logger.info('connecting to', config.MONGODB_URI)

mongoose.connect(config.MONGODB_URI)
  .then(() => {
    //console.log(result)
    logger.info('connected to MongoDB')
  })
  .catch(error => {
    logger.error('error connection to MongoDB:', error.message)
  })

// routes
app.get('/', (req, res) => res.render('home'));

app.use('/users', userRoutes);
app.use(postRoutes);
app.use(authRoutes);
app.use(profileRoutes);
app.use(friendRoutes);
app.use(groupRoutes);

app.use(middleware.unknownEndpoint)
app.use(middleware.errorHandler)


module.exports = app
