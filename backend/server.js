const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

const connection = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    multipleStatements: true
});

// Create DB and table if not exists
connection.query(`
CREATE DATABASE IF NOT EXISTS formdb;
USE formdb;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15),
    gender VARCHAR(10)
);
`, (err) => {
    if (err) throw err;
    console.log("DB & table ready");
});

app.post('/addUser', (req, res) => {
    const { name, email, phone, gender } = req.body;

    connection.query(
        "INSERT INTO formdb.users (name, email, phone, gender) VALUES (?, ?, ?, ?)",
        [name, email, phone, gender],
        () => res.send("Inserted")
    );
});

app.listen(3000, () => console.log("Backend running"));

