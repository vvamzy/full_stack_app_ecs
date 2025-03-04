const express = require('express');
const mysql = require('mysql2');
const cors = require('cors'); // Import the cors package
const app = express();
const port = 80;

// Enable CORS for all routes
app.use(cors());

const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

db.connect();

app.get('/api/user', (req, res) => {
  db.query('SELECT * FROM users LIMIT 1', (err, results) => {
    if (err) throw err;
    res.json(results[0]);
  });
});

app.listen(port, () => {
  console.log(`Backend running on port ${port}`);
});