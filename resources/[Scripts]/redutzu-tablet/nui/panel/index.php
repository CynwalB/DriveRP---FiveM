<?php
session_name('hydrid');
session_start();
require_once 'inc/connect.php';

require_once 'inc/config.php';

require_once 'inc/backend/user/auth/userIsLoggedIn.php';

// if (!isset($_SESSION['verified'])) {
//     header('Location: ' . $url['verified']);
// }

$page['name'] = 'Panel';
?>
<?php include 'inc/page-top.php'; ?>

<body>
    <?php include 'inc/top-nav.php'; ?>
    <?php
        if (isset($_GET['notify']) && strip_tags($_GET['notify']) === 'steam-linked') {
            clientNotify('success', 'Your Steam Account Has Been Linked.');
        }
        $stats['users'] = null;
        $stats['staff'] = null;
        $stats['civ'] = null;
        $stats['ems'] = null;

        $stats['users'] = $pdo->query('select count(*) from user')->fetchColumn();
        $stats['staff'] = $pdo->query('select count(*) from user WHERE usergroup <> "1" AND usergroup <> "2" AND usergroup <> "3"')->fetchColumn();
        $stats['civ'] = $pdo->query('select count(*) from characters')->fetchColumn();
        $stats['ems'] = $pdo->query('select count(*) from identities')->fetchColumn();
        ?>
    <!-- CONTENT START -->
    <div class="wrapper m-b-15">
        <div class="container-fluid">
            <div class="row">
                <div class="col">
                    <h4 class="page-title"><?php echo $page['name']; ?></h4>
                </div>
            </div>
            <div class="alert alert-warning" role="alert">
                <strong>Attention <?php echo $user_id?>: </strong> Il s'agit d'une version PRE-BETA. Merci de signalez tout bug sur notre Discord. L'exploitation de bug sur le site est formellement interdit et sera puni.
            </div>
            <div class="row">
                <div class="col col-xs-6">
                    <div class="card-box">
                        <h4 class="header-title mt-0 m-b-30">Total Utilisateurs</h4>
                        <h2 class="p-t-10 mb-0"><?php echo $stats['users']; ?></h2>
                    </div>
                </div>
                <div class="col col-xs-6">
                    <div class="card-box">
                        <h4 class="header-title mt-0 m-b-30">Total Staffs</h4>
                        <h2 class="p-t-10 mb-0"><?php echo $stats['staff']; ?></h2>
                    </div>
                </div>
                <div class="col col-xs-6">
                    <div class="card-box">
                        <h4 class="header-title mt-0 m-b-30">Total Civils</h4>
                        <h2 class="p-t-10 mb-0"><?php echo $stats['civ']; ?></h2>
                    </div>
                </div>
                <div class="col col-xs-6">
                    <div class="card-box">
                        <h4 class="header-title mt-0 m-b-30">Total Service de Secours</h4>
                        <h2 class="p-t-10 mb-0"><?php echo $stats['ems']; ?></h2>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col">
                    <div class="card-box">
                        <h4 class="header-title mt-0 m-b-30">Bienvenue sur le panel de service de DriveRP</h4>
                        <p>Dans cette version, l'équipe de développement a pris en compte les problèmes de notre version originale, ainsi que les commentaires de la communauté ! Nous apprécions tout retour sur notre <a href="https://discord.gg/f3GDrJU9sQ">Discord</a>. Vous pouvez naviguer dans le panneau à l'aide de la barre de navigation en haut ! <i>Il s'agit d'une version BETA. Veuillez signaler tout bug au staff.</i></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- CONTENT END -->
    <?php include 'inc/copyright.php'; ?>
    <?php include 'inc/page-bottom.php'; ?>
