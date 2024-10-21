<?php
require_once 'inc/connect.php';

require_once 'inc/config.php';

$page['name'] = 'Connexion';
?>
<?php include 'inc/page-top.php'; ?>
<script type="text/javascript">
    $(document).ready(function() {
        $('#userLogin').ajaxForm(function(error) {
            console.log(error);
            error = JSON.parse(error);
            if (error['msg'] === "") {
                toastr.success('Connecté(e)... Redirection', 'Système :', {
                    timeOut: 10000
                })
                window.location.href = "index.php";
            } else {
                toastr.error(error['msg'], 'Système :', {
                    timeOut: 10000
                })
            }
        });
    });
</script>

<body>
    <?php
        if (isset($_GET['error']) && strip_tags($_GET['error']) === 'banned') {
            throwError('Votre compte a été banni. Si vous avez des questions, veuillez faire appel à un staff.');
        } elseif (isset($_GET['error']) && strip_tags($_GET['error']) === 'access') {
            throwError('Vous devez être connecté pour accéder à cette page.');
        }
        ?>
    <div class="account-pages"></div>
    <div class="clearfix"></div>
    <div class="tel">
        <p>Cet appareil n'est pas adapté à cette partie du site</p>
    </div>
    <div class="wrapper-page">
        <div class="text-center">
            <a href="<?php echo $url['html']; ?>" class="logo" title="Page d'accueil"> <img src="../image/Logo.png" width="45%" ></a><!--<span>Panel de jeu DriveRP</span></a>-->
        </div>
        <div class="m-t-40 card-box2">
            <div class="text-center">
                <h4 class="text-uppercase font-bold mb-0">Connexion au panel</h4>
            </div>
            <div class="p-20">
                <form class="form-horizontal m-t-20" id="userLogin" action="inc/backend/user/auth/userLogin.php" method="POST">
                    <div class="form-group">
                        <div class="col-xs-12">
                            <input style="color:grey;" class="form-control" type="text" required="" name="username" placeholder="Prénom et nom RP">
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-xs-12">
                            <input style="color:grey;" class="form-control" type="password" required="" name="password" placeholder="Mot de passe">
                        </div>
                    </div>
                    <div class="form-group text-center m-t-30">
                        <div class="col-xs-12">
                            <button style="color:grey;" class="btn btn-custom btn-bordred btn-block waves-effect waves-light" type="submit">Se connecter</button>
                        </div>
                    </div>
                    <div class="col-sm-12 text-center">
                        <p class="text-muted">Vous n'avez pas de compte ? <a href="<?php echo $url['register']; ?>" class="text-primary m-l-5"><b>S'inscrire</b></a></p>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <?php include 'inc/page-bottom.php'; ?>
