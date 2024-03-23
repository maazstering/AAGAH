const express = require('express');
const mongoose = require('mongoose');
const authRoutes = require('./routes/authRoutes');
const postRoutes = require('./routes/postRoutes');
const profileRoutes = require('./routes/profileRoutes');
const friendRoutes = require('./routes/friendRoutes');
const groupRoutes = require('./routes/groupRoutes'); 
const userRoutes = require('./routes/userRoutes');


const cookieParser = require('cookie-parser');
const { requireAuth, requireAdmin } = require('./middleware/authmiddleware');
const { checkUser } = require('./middleware/authmiddleware');

const app = express();

// middleware
app.use(express.static('public'));
app.use(express.json());
app.use(cookieParser());


// view engine
app.set('view engine', 'ejs');

// database connection
const dbURI = 'mongodb+srv://hasanjawaid:091200@hasan.mg8eu13.mongodb.net/node-authnode?retryWrites=true&w=majority';

mongoose.connect(dbURI, { useNewUrlParser: true, useUnifiedTopology: true, useCreateIndex:true })
  .then((result) => app.listen(3000, () => {
    console.log('Server is listening on port 3000');
  }))
  .catch((err) => console.log(err));

// routes

app.get('*', checkUser);
app.get('/', (req, res) => res.render('home'));
// app.get('/social', requireAuth, (req, res) => res.render('social'));

app.use('/users', userRoutes);


app.use(postRoutes);

app.use(authRoutes);

app.use(profileRoutes);

app.use(friendRoutes);

app.use(groupRoutes);