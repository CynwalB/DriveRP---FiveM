<?php
// MySQL Settings
define("DB_HOST", "everlid1603.mysql.db");
define("DB_USER", "everlid1603");
define("DB_PASS", "WeshMaReuss1603");
define("DB_NAME", "everlid1603");
require_once 'functions.php';

// Do Not Edit Below --- SERIOUSLY DON'T TOUCH THIS STUFF.
$pdoOptions = array(
    PDO::ATTR_ERRMODE => PDO::ERRMODE_SILENT,
    PDO::ATTR_EMULATE_PREPARES => false
);
try {
    $pdo = new PDO("mysql:host=" . DB_HOST . ";dbname=" . DB_NAME, DB_USER, DB_PASS, $pdoOptions);
}

catch(Exception $e) {
    throwError('Unable to connect to database.', true);
    die('Unable to connect to database.');
}
?>
