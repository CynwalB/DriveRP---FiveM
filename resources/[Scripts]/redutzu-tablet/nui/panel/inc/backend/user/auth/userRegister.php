<?php
require '../../../connect.php';
require '../../../config.php';
header('Content-Type: application/json');
$username = !empty($_POST['username']) ? trim($_POST['username']) : null;
$email = !empty($_POST['email']) ? trim($_POST['email']) : null;
$pass = !empty($_POST['password']) ? trim($_POST['password']) : null;

$username = strip_tags($username);
$email = strip_tags($email);
$pass = strip_tags($pass);

$error = array();

if (strlen($pass) < 6) {
    $error['msg'] = "Veuillez utiliser un mot de passe plus long.";
    echo json_encode($error);
    exit();
}
elseif (strlen($pass) > 120) {
    $error['msg'] = "Veuillez utiliser un mot de passe plus court.";
    echo json_encode($error);
    exit();
}
elseif (strlen($username) > 36) {
    $error['msg'] = "Veuillez utiliser un nom d'utilisateur plus court.";
    echo json_encode($error);
    exit();
}

// Check if email is taken
$sql = "SELECT COUNT(email) AS num FROM user WHERE email = ?";
$stmt = $pdo->prepare($sql);
$stmt->execute([$email]);
$row = $stmt->fetch(PDO::FETCH_ASSOC);
if ($row['num'] > 0) {
    $error['msg'] = "Cette email est déja pris.";
    echo json_encode($error);
    exit();
}

// $sql5 = "SELECT CONCAT(firstname, ' ', lastname) AS full_name FROM users";
// $stmt5 = $pdo->prepare($sql5);
// $stmt5->execute([$username]);
// $row = $stmt5->fetch(PDO::FETCH_ASSOC);
// if ($row === false) {
//     $error['msg'] = "Erreur lors de l'exécution de la requête.";
//     echo json_encode($error);
//     exit();
// }
// if (empty($row['full_name'])) {
//     $error['msg'] = "Votre personnage n'existe pas sur le serveur.";
//     echo json_encode($error);
//     exit();
// }

$sql5 = $pdo->prepare("SELECT count(CONCAT(firstname, ' ', lastname)) as full_name FROM users WHERE CONCAT(firstname, ' ', lastname) = ?");
$sql5->execute(array($username));
while($verification = $sql5->fetch()) {
    if($verification['full_name'] == 0) {
        $error['msg'] = "Votre personnage n'existe pas sur le serveur.";
        echo json_encode($error);
        exit();
    }
}

$sql2 = "SELECT COUNT(username) AS num FROM user WHERE username = ?";
$stmt2 = $pdo->prepare($sql2);
$stmt2->execute([$username]);
$row = $stmt2->fetch(PDO::FETCH_ASSOC);
if ($row['num'] > 0) {
    $error['msg'] = "Ce nom d'utilisateur est déjà pris.";
    echo json_encode($error);
    exit();
}

$passwordHash = password_hash($pass, PASSWORD_BCRYPT, array(
    "cost" => 12
));

$sql4 = "SELECT COUNT(join_ip) AS num FROM user WHERE join_ip = ?";
$stmt4 = $pdo->prepare($sql4);
$stmt4->execute([$ip]);
$row = $stmt4->fetch(PDO::FETCH_ASSOC);
if ($row['num'] > 0) {
    $error['msg'] = "Vous avez déjà créé un compte.";
    echo json_encode($error);
    exit();
}

$sql42 = "SELECT COUNT(last_ip) AS num FROM user WHERE last_ip = ?";
$stmt42 = $pdo->prepare($sql42);
$stmt42->execute([$ip]);
$row = $stmt42->fetch(PDO::FETCH_ASSOC);
if ($row['num'] > 0) {
    $error['msg'] = "Vous avez déjà créé un compte.";
    echo json_encode($error);
    exit();
}

function generateRandomKey($length) {
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $randomKey = '';
    
    for ($i = 0; $i < $length; $i++) {
        $randomKey .= $characters[rand(0, strlen($characters) - 1)];
    }

    return $randomKey;
}

function keyExistsInDatabase($pdo, $verificationKey) {
    $sql6 = "SELECT COUNT(*) AS count FROM `user` WHERE `verif_key` = ?";
    $stmt6 = $pdo->prepare($sql6);
    $stmt6->execute([$verificationKey]);
    $count = $stmt6->fetch(PDO::FETCH_ASSOC);
    if ($count["count"] > 0) {
        return ($count > 0);
    } else {
        return ($count = 0);
    }
}

$verificationKey = generateRandomKey(30);
while (keyExistsInDatabase($pdo, $verificationKey));
$sql3 = "INSERT INTO user (username, email, password, join_date, join_ip, verif_key) VALUES (?,?,?,?,?,?)";
$stmt3= $pdo->prepare($sql3);
$result = $stmt3->execute([$username, $email, $passwordHash, $us_date, $ip, $verificationKey]);

if ($result) {
    $error['msg'] = "";
    echo json_encode($error);
    exit();
}
