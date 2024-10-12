<?php
// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Database configuration
$servername = "localhost";
$username = "u200853583_lucky_work";
$password = "Adarsh@Lucky@1010100";
$dbname = "u200853583_personal_work";

try {
    // Create a new PDO connection
    $pdo = new PDO("mysql:host=$servername;dbname=$dbname;charset=utf8", $username, $password);
    // Set the PDO error mode to exception
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Get the POST data
    $name = $_POST['name'] ?? '';
    $ip_address = $_POST['ip_address'] ?? '';
    $os_info = $_POST['os_info'] ?? '';
    $timestamp = $_POST['timestamp'] ?? '';
    $phone_number = $_POST['phone_number'] ?? '';

    // Validate phone number format (10 digits starting with 6, 7, 8, 9, or 0)
    if (!preg_match('/^[6-9][0-9]{9}$/', $phone_number)) {
        echo json_encode(["status" => "error", "message" => "Invalid phone number format!"]);
        exit();
    }

    // Prepare and execute the SQL statement
    $stmt = $pdo->prepare("INSERT INTO user_data (name, ip_address, os_info, timestamp, phone_number) VALUES (?, ?, ?, ?, ?)");
    $stmt->execute([$name, $ip_address, $os_info, $timestamp, $phone_number]);

    // Check if data was inserted
    if ($stmt->rowCount() > 0) {
        echo json_encode(["status" => "success", "message" => "Data inserted successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to insert data"]);
    }
} catch (PDOException $e) {
    echo json_encode(["status" => "error", "message" => "Database error: " . $e->getMessage()]);
}

// Close the connection
$pdo = null;
?>
