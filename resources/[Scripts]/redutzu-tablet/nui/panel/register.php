<?php
require_once 'inc/connect.php';
require_once 'inc/config.php';
$page['name'] = 'S\'inscrire';
?>
<?php include 'inc/page-top.php'; ?>
<script type="text/javascript">
    $(document).ready(function() {
        $('#userRegister').ajaxForm(function(error) {
            console.log(error);
            if (error['msg'] == "") {
                toastr.success('Compte créé ! Vous allez bientôt être redirigé vers la page de connexion.', 'Système', {
                    timeOut: 10000
                })
                window.location.href = "<?php echo $url['login']; ?>";
            } else {
                toastr.error(error['msg'], 'Système', {
                    timeOut: 10000
                })
            }
        });
    });
</script>

<body>
    <div class="account-pages"></div>
    <div class="clearfix"></div>
    <div class="tel">
        <p>Cet appareil n'est pas adapté à cette partie du site</p>
    </div>
    <div class="wrapper-page">
        <div class="text-center">
            <a href="<?php echo $url['html']; ?>" title="Page d'accueil" class="logo"> <img src="../image/Logo.png" width="45%" ></a><!--<span>Panel de jeu DriveRP</span></a>-->
        </div>
        <div class="m-t-40 card-box2">
            <div class="text-center">
                <h4 class="text-uppercase font-bold mb-0">Inscription au panel</h4>
            </div>
            <div class="p-20">
                <form class="form-horizontal m-t-20" id="userRegister" action="inc/backend/user/auth/userRegister.php" method="POST">
                    <div class="form-group">
                        <div class="col-xs-12">
                            <input class="form-control" type="text" required="" name="username" placeholder="Prénom et nom RP">
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-xs-12">
                            <input class="form-control" type="email" required="" name="email" placeholder="Email">
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-xs-12">
                            <input class="form-control" type="password" required="" name="password" placeholder="Mot de passe">
                        </div>
                    </div>
                    <div class="form-group text-center m-t-30">
                        <div class="col-xs-12">
                            <button class="btn btn-custom btn-bordred btn-block waves-effect waves-light" type="submit">S'inscrire</button>
                        </div>
                    </div>
                    <div class="col-sm-12 text-center">
                        <p class="text-muted">Vous avez déjà un compte ? <a href="<?php echo $url['login']; ?>" class="text-primary m-l-5"><b>Se connecter</b></a></p>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <?php include 'inc/page-bottom.php'; ?>
