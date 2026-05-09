-- BPI Clone Database Schema

CREATE DATABASE IF NOT EXISTS neobank_db;
USE neobank_db;

-- Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Accounts Table
CREATE TABLE IF NOT EXISTS accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    account_number VARCHAR(20) UNIQUE NOT NULL,
    account_type VARCHAR(50) DEFAULT 'Savings',
    balance DECIMAL(15, 2) DEFAULT 0.00,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Transactions Table
CREATE TABLE IF NOT EXISTS transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT,
    type ENUM('transfer', 'payment', 'load', 'topup') NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    description TEXT,
    reference_no VARCHAR(50) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(id)
);

-- Seed Data
INSERT INTO users (username, password, full_name) VALUES ('juan_dela_cruz', '$2y$10$abcdefghijklmnopqrstuv', 'Juan dela Cruz');
INSERT INTO accounts (user_id, account_number, account_type, balance) VALUES (1, '0001-2345-6789', 'Savings', 25000.00);
