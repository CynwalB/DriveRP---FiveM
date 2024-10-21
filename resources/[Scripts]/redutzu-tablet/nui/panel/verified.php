<?php
require_once 'inc/connect.php';

require_once 'inc/config.php';

session_name('hydrid');
session_start();

$page['name'] = 'Vérification';

$user_id = $_SESSION['user_id'];
$fetchVerifKey = $pdo->prepare("SELECT verif_key FROM user WHERE user_id = '$user_id'");
$fetchVerifKey->execute();
$verifKey = $fetchVerifKey->fetchColumn();
?>
<?php include 'inc/page-top.php'; ?>

<body>

    <div class="verif">
        <h4>Liez votre compte à votre personnage</h4>
        <p>Vous devez lié votre compte à votre personnage pour continuer. Allez sur le serveur, ouvrez le chat et copiez cette commande :</p>
        <br>
        <p>/link <?php echo $verifKey?></p>
        <br>
        <p>Lorsque votre compte est lié, <a href="<?php echo $url['login']; ?>"><b> reconnectez-vous !</b></a></p>
    </div>
    <?php include 'inc/page-bottom.php'; ?>
