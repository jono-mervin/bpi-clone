<?php
// backend/config/database.php

define('DB_HOST', 'localhost');
define('DB_NAME', 'neobank_db');
define('DB_USER', 'root');
define('DB_PASS', ''); // Default XAMPP password is empty

try {
    $pdo = new PDO("mysql:host=" . DB_HOST . ";dbname=" . DB_NAME, DB_USER, DB_PASS);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    die("Connection failed: " . $e->getMessage());
}
?>
