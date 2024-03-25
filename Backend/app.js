const express = require('express');
const mongoose = require('mongoose');
const authRoutes = require('./routes/authRoutes');
const postRoutes = require('./routes/postRoutes');
const profileRoutes = require('./routes/profileRoutes');
const friendRoutes = require('./routes/friendRoutes');
const groupRoutes = require('./routes/groupRoutes');
const userRoutes = require('./routes/userRoutes');
const cors = require('cors'); 


const cookieParser = require('cookie-parser');
const { requireAuth, requireAdmin } = require('./middleware/authmiddleware');
const { checkUser } = require('./middleware/authmiddleware');

const app = express();

// middleware
app.use(cors()); 
app.use(express.static('public'));
app.use(express.json());
app.use(cookieParser());

// If you want to allow only specific origins, replace the above app.use(cors()); with the following:
// const corsOptions = {
//   origin: 'http://localhost:53460', // Replace with the URL your Flutter app is served from
//   optionsSuccessStatus: 200
// };
// app.use(cors(corsOptions));



// view engine
app.set('view engine', 'ejs');

// database connection
const dbURI = 'mongodb+srv://fullstack:fullstack@cluster0.413sbvx.mongodb.net/Aagah?retryWrites=true&w=majority&appName=Cluster0';

mongoose.connect(dbURI, { useNewUrlParser: true, useUnifiedTopology: true, useCreateIndex: true })
  .then((result) => {
    // Listen on all available network interfaces
    app.listen(3000, '0.0.0.0', () => {
      console.log('Server is listening on port 3000');
    });
  })
  .catch((err) => console.log(err));

// routes
app.get('*', checkUser);
app.get('/', (req, res) => res.render('home'));

app.use('/users', userRoutes);
app.use(postRoutes);
app.use(authRoutes);
app.use(profileRoutes);
app.use(friendRoutes);
app.use(groupRoutes);


