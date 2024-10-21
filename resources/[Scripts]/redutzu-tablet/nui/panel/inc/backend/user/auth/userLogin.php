<?php
session_name('hydrid');
session_start();
require_once '../../../connect.php';

require_once '../../../config.php';

$username = !empty($_POST['username']) ? trim($_POST['username']) : null;
$passwordAttempt = !empty($_POST['password']) ? trim($_POST['password']) : null;

$username = strip_tags($username);
$passwordAttempt = strip_tags($passwordAttempt);

$error = array();

$maxAttempts = 5;
$lockoutTime = 900;

$sql = "SELECT * FROM user WHERE username = :username";
$stmt = $pdo->prepare($sql);
$stmt->bindValue(':username', $username);
$stmt->execute();
$user = $stmt->fetch(PDO::FETCH_ASSOC);
if ($user === false) {
    $error['msg'] = "Ce compte est introuvable dans notre base de données.";
    echo json_encode($error);
    exit();
} else {
    if($user['failed_attempts'] >= $maxAttempts && time() - $user['last_failed_attempt'] >= $lockoutTime) {
        $pdo->prepare("UPDATE `user` SET `failed_attempts` = 0, `last_failed_attempt` = 0 WHERE `user_id` = ?")->execute([$user['user_id']]);
    }
    if ($user['failed_attempts'] >= $maxAttempts && time() - $user['last_failed_attempt'] < $lockoutTime) {
        $error['msg'] = "Votre compte est temporairement verrouillé. Veuillez réessayer plus tard.";
        echo json_encode($error);
        exit();
    }

    $validPassword = password_verify($passwordAttempt, $user['password']);
    if ($validPassword) {
        
        $pdo->prepare("UPDATE `user` SET `failed_attempts` = 0, `last_failed_attempt` = 0 WHERE `user_id` = ?")->execute([$user['user_id']]);

        if ($user['usergroup'] == 1) {
            $error['msg'] = "Votre compte a été banni. Si vous avez des questions, veuillez faire appel à un staff.";
            echo json_encode($error);
            exit();
        }
        if ($user['usergroup'] === NULL) {
            $sql2 = "UPDATE `user` SET `usergroup`= ? WHERE `user_id`= ?";
            $stmt2 = $pdo->prepare($sql2);
            $updateUserGroup = $stmt2->execute([$settings['unverifiedGroup'], $user['user_id']]);
        }
        if ($settings['account_validation'] === "Yes" && $user['usergroup'] === $settings['unverifiedGroup']) {
            $error['msg'] = "Votre compte est en attente de validation par un administrateur.";
            echo json_encode($error);
            exit();
        }

        $_SESSION['user_id'] = $user['user_id'];
        $_SESSION['logged_in'] = time();

        if ($user['usergroup'] != 2 AND $user['usergroup'] != NULL) {
            $_SESSION['verified'] = $user['user_id'];
        }

        logAction('S\'est connecté', $user['username']);

        //Successful login
        $result = $pdo->prepare("UPDATE `user` SET `last_ip`= ? WHERE `user_id` = ?")
        ->execute([$ip, $user['user_id']]);
        $error['msg'] = "";
        echo json_encode($error);
        exit();
    } else {
        
        $pdo->prepare("UPDATE `user` SET `failed_attempts` = `failed_attempts` + 1, `last_failed_attempt` = ? WHERE `user_id` = ?")->execute([time(), $user['user_id']]);

        $count = $maxAttempts - $user['failed_attempts'];

        if ($count <= 3) {
            $error['msg'] = "Votre mot de passe est incorrect. Attention il ne vous reste plus que " . $count . " tentative(s) avant que votre compte soit verrouillé pendant 15 mins";
            echo json_encode($error);
            exit();
        } else {
            $error['msg'] = "Votre mot de passe est incorrect. Veuillez réessayer.";
            echo json_encode($error);
            exit();
        }
    }
}
