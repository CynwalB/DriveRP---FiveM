<?php
session_name('hydrid');
session_start();
require '../../../connect.php';

require '../../../config.php';

require '../../../backend/user/auth/userIsLoggedIn.php';

if (staff_access === 'true' && staff_siteSettings === 'true') {
    $id = strip_tags($_GET['id']);
    $result = $pdo->prepare("UPDATE `user` SET `usergroup`= ? WHERE `user_id` = ?")
        ->execute(['User', $id]);

    logAction('Approuvé un nouvel identifiant d\'utilisateur :' . $id, $user['username']);
}
else {
    logAction('Tentative d\'approbation d\'un nouvel identifiant utilisateur :' . $id, $user['username']);
    $error['msg'] = "Vous n'avez pas la permission";
    echo json_encode($error);
    exit();
}
