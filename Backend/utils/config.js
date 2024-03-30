require('dotenv').config()

MONGODB_URI = process.env.MONGODB_URI
PORT = process.env.PORT
SECRET = process.env.SECRET

module.exports = {
    MONGODB_URI, PORT, SECRET
}