<?php
session_name('hydrid');
session_start();
require_once 'inc/connect.php';
require_once 'inc/config.php';
require_once 'inc/backend/user/auth/userIsLoggedIn.php';

$page['name'] = 'Panel staff';

$sql3 = "SELECT * FROM user WHERE root_user = 'true'";
$stmt3 = $pdo->prepare($sql3);
$stmt3->execute();
$countRoot = $stmt3->fetch(PDO::FETCH_ASSOC);

if (staff_access === 'true' && staff_editUsers === 'true') {
  if (isset($_POST['editUserBtn'])) {
    $updateUsername    = !empty($_POST['username']) ? trim($_POST['username']) : null;
    $updateEmail       = !empty($_POST['email']) ? trim($_POST['email']) : null;
    $updateUsergroup   = !empty($_POST['usergroup']) ? trim($_POST['usergroup']) : null;

    $updateUsername    = strip_tags($updateUsername);
    $updateEmail       = strip_tags($updateEmail);
    $updateUsergroup   = strip_tags($updateUsergroup);

    if ($updateUsergroup == '6') {
        if ($user['root'] == 'true') {
          $sql = "UPDATE user SET username=?, email=?, usergroup=? WHERE user_id=?";
          $stmt = $pdo->prepare($sql);
          $stmt->execute([$updateUsername, $updateEmail, $updateUsergroup, $_SESSION['editing_user_id']]);
        } else {
          echo "<script> location.replace('staff.php?m=users&error=root'); </script>";
          exit();
        }
    } else {
        $sql = "UPDATE user SET username=?, email=?, usergroup=? WHERE user_id=?";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([$updateUsername, $updateEmail, $updateUsergroup, $_SESSION['editing_user_id']]);
    }

    echo "<script> location.replace('staff.php?m=users&user=edited'); </script>";
    exit();
  } elseif (isset($_POST['banUserBtn'])) {
    if (staff_banUsers === 'true') {
      $banReason    = !empty($_POST['reason']) ? trim($_POST['reason']) : null;
      $banReason    = strip_tags($banReason);

      $sql = "UPDATE user SET usergroup=?, ban_reason=? WHERE user_id=?";
      $stmt = $pdo->prepare($sql);
      $stmt->execute(['Banned', $banReason, $_SESSION['editing_user_id']]);

      echo "<script> location.replace('staff.php?m=users&user=banned'); </script>";
      exit();
    } else {
      echo "<script> location.replace('staff.php?m=users'); </script>";
      exit();
    }
  } elseif (isset($_POST['unbanUserBtn'])) {
    if (staff_banUsers === 'true') {
      $sql = "UPDATE user SET usergroup=?, ban_reason=? WHERE user_id=?";
      $stmt = $pdo->prepare($sql);
      $stmt->execute(['User', NULL, $_SESSION['editing_user_id']]);

      echo "<script> location.replace('staff.php?m=users&user=unbanned'); </script>";
      exit();
    } else {
      echo "<script> location.replace('staff.php?m=users'); </script>";
      exit();
    }
  }
}

if (staff_access === 'true' && staff_siteSettings === 'true') {
  if (isset($_POST['enableAlertsBtn'])) {
    $webhook_url    = !empty($_POST['webhook_url']) ? trim($_POST['webhook_url']) : null;
    $webhook_url    = strip_tags($webhook_url);

    if (empty($webhook_url)) {
      echo "<script> location.replace('staff.php?m=settings&error=webhook-empty'); </script>";
      exit();
    }

    if (!filter_var($webhook_url, FILTER_VALIDATE_URL)) {
      echo "<script> location.replace('staff.php?m=settings&error=webhook-invalid'); </script>";
      exit();
    }

    $sql = "UPDATE settings SET discord_alerts=?, discord_webhook=? WHERE setting_id=?";
    $stmt = $pdo->prepare($sql);
    $result = $stmt->execute(['true', $webhook_url, '1']);

    if ($result) {
      discordAlert('This message is to verify that you have successfully setup Discord Alerts on **Hydrid**. If you would like to disable Discord Alerts, you can do so from the Admin Panel.
      - **Hydrid CAD System**');
    }
    echo "<script> location.replace('staff.php?m=settings&success=webhook-setup'); </script>";
    exit();
  }
  if (isset($_POST['disableAlertsBtn'])) {
    $sql = "UPDATE settings SET discord_alerts=? WHERE setting_id=?";
    $stmt = $pdo->prepare($sql);
    $stmt->execute(['false', '1']);
    echo "<script> location.replace('staff.php?m=settings&success=webhook-disabled'); </script>";
    exit();
  }
}

if (staff_siteSettings === 'true') {
  // Makes sure the user is actually Super Admin before allowing them to wipe anything
  if (isset($_POST['wipeLogsBtn'])) {
    sleep(6);
    $stmt       = $pdo->prepare("DELETE FROM logs");
    $stmt->execute();
    sleep(15);
    $sql2 = "INSERT INTO logs (action, username, timestamp) VALUES (?,?,?)";
    $pdo->prepare($sql2)->execute(['Wiped All Logs', $user['username'], $datetime]);

    header('Location: '.$url['staff'].'?m=settings&success=wiped-logs');
    exit();
  } elseif (isset($_POST['wipeCharactersBtn'])) {
    sleep(6);
    $stmt       = $pdo->prepare("DELETE FROM characters");
    $stmt->execute();
    sleep(6);
    //

    $stmt3       = $pdo->prepare("DELETE FROM arrest_reports");
    $stmt3->execute();
    sleep(6);
    //

    $stmt4       = $pdo->prepare("DELETE FROM tickets");
    $stmt4->execute();
    sleep(6);
    //

    $stmt5       = $pdo->prepare("DELETE FROM vehicles");
    $stmt5->execute();
    sleep(6);
    //

    $stmt6       = $pdo->prepare("DELETE FROM warrants");
    $stmt6->execute();
    sleep(6);
    //

    $stmt7       = $pdo->prepare("DELETE FROM weapons");
    $stmt7->execute();
    sleep(6);
    //

    $sql2 = "INSERT INTO logs (action, username, timestamp) VALUES (?,?,?)";
    $pdo->prepare($sql2)->execute(['Wiped All Characters', $user['username'], $datetime]);

    header('Location: '.$url['staff'].'?m=settings&success=wiped-characters');
    exit();
  } elseif (isset($_POST['wipeIdentitiesBtn'])) {
    sleep(6);
    $stmt       = $pdo->prepare("DELETE FROM identities");
    $stmt->execute();
    sleep(6);
    //

    $stmt3       = $pdo->prepare("DELETE FROM arrest_reports");
    $stmt3->execute();
    sleep(6);
    //

    $stmt4       = $pdo->prepare("DELETE FROM assigned_callunits");
    $stmt4->execute();
    sleep(6);
    //

    $stmt5       = $pdo->prepare("DELETE FROM bolos");
    $stmt5->execute();
    sleep(6);
    //

    $stmt6       = $pdo->prepare("DELETE FROM on_duty");
    $stmt6->execute();
    sleep(6);
    //

    $stmt7       = $pdo->prepare("DELETE FROM tickets");
    $stmt7->execute();
    sleep(6);
    //

    $sql2 = "INSERT INTO logs (action, username, timestamp) VALUES (?,?,?)";
    $pdo->prepare($sql2)->execute(['Wiped All Identities', $user['username'], $datetime]);

    header('Location: '.$url['staff'].'?m=settings&success=wiped-identities');
    exit();
  }
}

$view = strip_tags($_GET['m']);
?>
<?php include 'inc/page-top.php'; ?>
<script src="assets/js/pages/staff.js"></script>
<script type="text/javascript">
    $(document).ready(function() {
        $('#updateSiteName').ajaxForm(function(error) {
            error = JSON.parse(error);
            if (error['msg'] === "") {
                toastr.success('Site Name Updated', 'System:', {
                    timeOut: 10000
                })
            } else {
                toastr.error(error['msg'], 'System:', {
                    timeOut: 10000
                })
            }
        });
    });
</script>

<body>
    <?php include 'inc/top-nav.php'; ?>
    <?php
    if (isset($_GET['error']) && strip_tags($_GET['error']) === 'webhook-invalid') {
        throwError('Invalid Discord Webhook Entered');
    } elseif (isset($_GET['error']) && strip_tags($_GET['error']) === 'webhook-empty') {
        throwError('You must enter a Discord Webhook to enable this feature!.');
    } elseif (isset($_GET['success']) && strip_tags($_GET['success']) === 'webhook-setup') {
      clientNotify('success', 'You have now setup Discord Alerts. We will send a welcome alert to verify it is all working!');
    } elseif (isset($_GET['success']) && strip_tags($_GET['success']) === 'webhook-disabled') {
      clientNotify('success', 'Discord Alerts have been disabled!');
    } elseif (isset($_GET['success']) && strip_tags($_GET['success']) === 'wiped-logs') {
      clientNotify('success', 'All Logs Have Been Wiped!');
    } elseif (isset($_GET['success']) && strip_tags($_GET['success']) === 'wiped-characters') {
      clientNotify('success', 'All Characters Have Been Wiped!');
    } elseif (isset($_GET['success']) && strip_tags($_GET['success']) === 'wiped-identities') {
      clientNotify('success', 'All Characters Have Been Wiped!');
    } elseif (isset($_GET['error']) && strip_tags($_GET['error']) === 'perm') {
      clientNotify('error', 'You can not edit this user!');
    } elseif (isset($_GET['error']) && strip_tags($_GET['error']) === 'group-perm') {
      clientNotify('error', 'You can not set someones usergroup the same or higher of yours.');
    } elseif (isset($_GET['user']) && strip_tags($_GET['user']) === 'edited') {
      clientNotify('success', 'User edited.');
    } elseif (isset($_GET['error']) && strip_tags($_GET['error']) === 'root') {
      clientNotify('error', 'Only users set as ROOT can do this.');
    } elseif (isset($_GET['root']) && strip_tags($_GET['root']) === 'set') {
      clientNotify('success', 'Root user updated.');
    }
    ?>
    <!-- CONTENT START -->
    <div class="wrapper m-b-15">
        <div class="container-fluid">
            <div class="row">
                <div class="col">
                    <h4 class="page-title"><?php echo $page['name']; ?></h4>
                </div>
            </div>
            <?php
            if (empty($countRoot)) {
                throwError('No ROOT user is currently setup. Please set one up, or you will not be able to add new Super Admins and other site features will be disabled.');
                echo '<div class="alert alert-danger" role="alert"><strong>Please <a href="staff.php?m=root-setup">select</a> a user as root.</strong></div>';
            }
            ?>
            <!-- CONTENT HERE -->
            <?php if (staff_access === 'true'): ?>
            <?php switch($view):
			         case "settings": ?>
            <?php
               if (!staff_siteSettings === 'true') {
                exit('<div class="alert alert-danger" role="alert"><strong>You do not have permission to access this page.</strong></div>');
               }
               ?>
            <div class="row">
                <div class="col-12">
                    <div class="card-box">
                        <h4 class="m-t-0 header-title">Paramètre du site</h4>
                        <div class="row">
                            <div class="col">
                                <div class="form-group">
                                    <label for="IdentityVerification">Vérification d'identité</label>
                                    <select class="form-control" id="IdentityVerification" onchange="setIdentityVerification(this.value)">
                                        <option selected="true" disabled="disabled"><?php if ($settings['identity_validation'] === "no") {
                              echo 'No';
                            } else {
                              echo 'Yes';
                            } ?></option>
                                        <option value="no">Non</option>
                                        <option value="yes">Oui</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col">
                                <div class="form-group">
                                    <label for="SignUpVerification">Vérification de compte</label>
                                    <select class="form-control" id="SignUpVerification" onchange="setAccountVerification(this.value)">
                                        <option selected="true" disabled="disabled"><?php if ($settings['account_validation'] === "no") {
                              echo 'No';
                            } else {
                              echo 'Yes';
                            } ?></option>
                                        <option value="no">Non</option>
                                        <option value="yes">Oui</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col">
                                <form id="updateSiteName" action="inc/backend/staff/settings/setSiteName.php" method="post">
                                    <div class="form-group">
                                        <label for="site_name">Nom du site</label>
                                        <input class="form-control" type="text" required="" name="site_name" value="<?php echo $settings['name']; ?>" placeholder="<?php echo $settings['name']; ?>">
                                    </div>
                                    <div class="form-group">
                                        <button class="btn btn-success btn-block" onClick="disableClick()" type="submit">Enregistrer</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-6">
                    <div class="card-box">
                        <h4 class="m-t-0 header-title">Discord Alerts</h4>
                        <div class="alert alert-warning" role="alert"><strong>Comment installer - </strong>Pour configurer le système Discord Alert, veuillez suivre toutes les étapes.<br>
                            1 - Créez un channel Discord dans laquelle les alertes seront envoyées.<br>
                            2 - Clic droit sur le channel --> Paramètre du channel --> Intégration --> WebHooks<br>
                            3 - Appuyez sur "Créer un Webhook"<br>
                            4 - Nom (Alertes Hydrad CAD) : Channel (Le channel que vous configurez) : Copiez l'"URL WEBHOOK"
                        </div>
                        <form method="POST">
                            <div class="form-group">
                                <div class="col-12">
                                    <label for="webhook_url">Webhook URL</label>
                                    <input class="form-control" type="text" required="" name="webhook_url" id="webhook_url" value="<?php if ($discord_webhook === NULL || $discord_webhook === "") {
                            echo '';
                          } else {
                            echo $discord_webhook;
                          } ?>" placeholder="Discord Webhook URL">
                                </div>
                            </div>
                            <div class="form-group text-center">
                                <div class="col-12">
                                    <?php if($settings['discord_alerts'] === 'true'): ?>
                                    <button class="btn btn-danger btn-bordred btn-block waves-effect waves-light" type="submit" name="disableAlertsBtn">Désactiver les alertes</button>
                                    <?php else: ?>
                                    <button class="btn btn-success btn-bordred btn-block waves-effect waves-light" type="submit" name="enableAlertsBtn">Activer les alertes</button>
                                    <?php endif; ?>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="card-box">
                        <h4 class="m-t-0 header-title">Action sur le site</h4>
                        <div class="alert alert-danger" role="alert"><strong>Attention :</strong> Tout ce qui a été supprimé ne peut PAS être récupéré.</div>
                        <form method="POST">
                            <div class="row">
                                <div class="col-4">
                                    <div class="form-group">
                                        <button class="btn btn-danger btn-block waves-effect waves-light" type="submit" id="wipeLogs" onclick="return confirm('Êtes-vous sûr de ce que vous voulez supprimer ? Ces données ne pourront pas être récupérées.')" name="wipeLogsBtn">Supprimer Logs</button>
                                    </div>
                                </div>
                                <div class="col-4">
                                    <div class="form-group">
                                        <button class="btn btn-danger btn-block waves-effect waves-light" type="submit" id="wipeCharacters" onclick="return confirm('Êtes-vous sûr de ce que vous voulez supprimer ? Ces données ne pourront pas être récupérées.')" name="wipeCharactersBtn">Supprimer Utilisateurs</button>
                                    </div>
                                </div>
                                <div class="col-4">
                                    <div class="form-group">
                                        <button class="btn btn-danger btn-block waves-effect waves-light" type="submit" id="wipeIdentities" onclick="return confirm('Êtes-vous sûr de ce que vous voulez supprimer ? Ces données ne pourront pas être récupérées.')" name="wipeIdentitiesBtn">Supprimer Identités</button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="col-6">
                    <div class="card-box">
                        <h4 class="m-t-0 header-title">Intégration steam</h4>
                        <div class="alert alert-danger" role="alert"><strong>Désactiver pour le moment.</strong></div>
                    </div>
                    <div class="card-box">
                        <h4 class="m-t-0 header-title">Module de configuration</h4>
                        <div class="form-group">
                            <label for="darkmode">Avis de recherche visible par les civils</label>
                            <select class="form-control" id="steam_login" onchange="setCivSideWarrants(this.value)">
                                <option selected="true" disabled="disabled"><?php
                        if ($settings['civ_side_warrants'] === "true") {
                          echo 'Activer';
                        } elseif ($settings['civ_side_warrants'] === "false") {
                          echo 'Désactiver';
                        }
                        ?>
                                </option>
                                <option value="true">Activer</option>
                                <option value="false">Désactiver</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="darkmode">Qui peut ajouter des avis de recherches</label>
                            <select class="form-control" id="steam_login" onchange="setAddWarrantPerm(this.value)">
                                <option selected="true" disabled="disabled"><?php
                        if ($settings['add_warrant'] === "all") {
                          echo 'Toute la LSPD';
                        } elseif ($settings['add_warrant'] === "supervisor") {
                          echo 'Seulement les superviseurs';
                        }
                        ?>
                                </option>
                                <option value="all">Toute la LSPD</option>
                                <option value="supervisor">Seulement les superviseurs</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
            <?php break; ?>

            <?php case "pending-users":?>
            <?php
               if (!staff_approveUsers === 'true') {
                exit('<div class="alert alert-danger" role="alert"><strong>Vous n\'avez pas la permission d\'accéder à cette page.</strong></div>');
               }
              ?>
            <div class="row">
                <div class="col-lg-12">
                    <div class="card-box">
                        <h4 class="m-t-0 header-title">Utilisateurs en attente</h4>
                        <div id="getPendingUsers"></div>
                    </div>
                </div>
            </div>
            <?php break; ?>

            <?php case "": ?>

            <?php case "users":?>
            <?php
               if (!staff_viewUsers === 'true') {
                exit('<div class="alert alert-danger" role="alert"><strong>Vous n\'avez pas la permission d\'accéder à cette page.</strong></div>');
               }
              ?>
            <div class="row">
                <div class="col-lg-12">
                    <div class="card-box">
                        <h4 class="m-t-0 header-title">Tous les utilisateurs</h4>
                        <table id="datatable" class="table table-borderless">
                            <thead>
                                <tr>
                                    <th>ID Utilisateur</th>
                                    <th>Nom d'utilisateur</th>
                                    <th>Email</th>
                                    <th>Groupe</th>
                                    <th>Date de création</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>


                            <tbody>
                                <?php
                          $sql             = "SELECT * FROM user";
                          $stmt            = $pdo->prepare($sql);
                          $stmt->execute();
                          $usersRow = $stmt->fetchAll(PDO::FETCH_ASSOC);

                          foreach ($usersRow as $user) {
                            echo '
                            <tr>
                              <td>'. $user['user_id'] .'</td>
                              <td>'. $user['username'] .'</td>
                              <td>'. $user['email'] .'</td>';
                              $sql1_gugp             = "SELECT * FROM usergroups WHERE id = :usergroup";
                              $stmt1_gugp            = $pdo->prepare($sql1_gugp);
                              $stmt1_gugp->bindValue(':usergroup', $user['usergroup']);
                              $stmt1_gugp->execute();
                              $groupRow = $stmt1_gugp->fetch(PDO::FETCH_ASSOC);
                              echo '<td>'. $groupRow['name'] .'</td>
                              <td>'. $user['join_date'] .'</td>
                              <td><a href="staff.php?m=edit-user&user-id='. $user['user_id'] .'"><input type="button" class="btn btn-sm btn-success btn-block" value="Modifier"></a></td>
                          </tr>
                            ';
                          }
                          ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <?php break; ?>

            <?php case "edit-user": ?>
            <?php
               if (!staff_editUsers === 'true') {
                exit('<div class="alert alert-danger" role="alert"><strong>Vous n\'avez pas la permission d\'accéder à cette page.</strong></div>');
               }
              ?>
            <?php
                  if (isset($_GET['user-id']) && strip_tags($_GET['user-id'])) {
                    $id   = $_GET['user-id'];
                    $sql  = "SELECT * FROM user WHERE user_id = :user_id";
                    $stmt = $pdo->prepare($sql);
                    $stmt->bindValue(':user_id', $id);
                    $stmt->execute();
                    $userDB = $stmt->fetch(PDO::FETCH_ASSOC);
                    if ($userDB === false) {
                      echo "<script> location.replace('staff.php?m=users'); </script>";
                      exit();
                    } else {
                        $editing_user['user_id'] = $userDB['user_id'];
                        $_SESSION['editing_user_id'] = $editing_user['user_id'];
                        $editing_user['username'] = $userDB['username'];
                        $editing_user['email'] = $userDB['email'];
                        $editing_user['usergroup'] = $userDB['usergroup'];
                        $editing_user['join_date'] = $userDB['join_date'];
                        $editing_user['join_ip'] = $userDB['join_ip'];
                        $editing_user['steam_id'] = $userDB['steam_id'];
                        $editing_user['avatar'] = $userDB['avatar'];
                        $editing_user['root'] = $userDB['root_user'];

                        if ($editing_user['usergroup'] === $settings['banGroup']) {
                          $editing_user['isBanned'] = true;
                        } else {
                          $editing_user['isBanned'] = false;
                        }

                        if ($editing_user['root'] == 'true') {
                          if ($user['root'] == 'false') {
                            echo "<script> location.replace('staff.php?m=users&error=root'); </script>";
                            exit();
                          }
                        }

                        if ($editing_user['usergroup'] == '6') {
                          if ($user['root'] == 'false') {
                            echo "<script> location.replace('staff.php?m=users&error=root'); </script>";
                            exit();
                          }
                        }
                    }
                }
                ?>
            <div class="row">
                <div class="col-12">
                    <?php if($editing_user['isBanned']): ?>
                      <div class="alert alert-danger" role="alert">
                          <strong>CET UTILISATEUR EST INTERDIT. VOUS NE POUVEZ PAS MODIFIER CET UTILISATEUR À MOINS QU'IL SOIT DÉBANNI.</strong>
                      </div>
                    <?php endif; ?>
                </div>
                <div class="col-6">
                    <div class="bg-picture card-box">
                        <h4 class="m-t-0 header-title">Modifier utilisateur</h4>
                        <div class="profile-info-name">
                            <img src="<?php echo $editing_user['avatar']; ?>" class="img-thumbnail" alt="profile-image">
                            <div class="profile-info-detail">
                                <form method="POST">
                                    <div class="form-group">
                                        <div class="col-12">
                                            <label for="username">Nom d'utilisateur</label>
                                            <input class="form-control" type="text" required="" id="username" name="username" value="<?php echo $editing_user['username']; ?>" placeholder="Nom d'utilisateur">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="col-12">
                                            <label for="email">Email</label>
                                            <input class="form-control" type="email" required="" id="email" name="email" value="<?php echo $editing_user['email']; ?>" placeholder="Email">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="col-12">
                                            <label for="usergroup">Groupe</label>
                                            <select class="form-control custom-select my-1 mr-sm-2" id="usergroup" name="usergroup">
                                              <?php
                                              $sql2_gugp             = "SELECT * FROM usergroups WHERE id = :usergroup";
                                              $stmt2_gugp            = $pdo->prepare($sql2_gugp);
                                              $stmt2_gugp->bindValue(':usergroup', $editing_user['usergroup']);
                                              $stmt2_gugp->execute();
                                              $groupRow2 = $stmt2_gugp->fetch(PDO::FETCH_ASSOC);
                                              ?>
                                                <option selected value="<?php echo $editing_user['usergroup']; ?>"><?php echo $groupRow2['name'] ?> (Actuel)</option>
                                                <?php
                                                $sql_getAllGroups             = "SELECT * FROM usergroups where id <> ?";
                                                $stmt2_getAllGroups            = $pdo->prepare($sql_getAllGroups);
                                                $stmt2_getAllGroups->execute([$editing_user['usergroup']]);
                                                $groups = $stmt2_getAllGroups->fetchAll(PDO::FETCH_ASSOC);

                                                foreach ($groups as $groupDB) {
                                                ?>
                                                <option value="<?php echo $groupDB['id'] ?>"><?php echo $groupDB['name'] ?></option>

                                                <?php } ?>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group text-center">
                                        <div class="col-12">
                                          <?php if($editing_user['isBanned']): ?>
                                            <button class="btn btn-success btn-bordred btn-block waves-effect waves-light" disabled>Modifier utilisateur</button>
                                          <?php else: ?>
                                            <button class="btn btn-success btn-bordred btn-block waves-effect waves-light" type="submit" name="editUserBtn">Modifier utilisateur</button>
                                          <?php endif; ?>
                                        </div>
                                    </div>
                                </form>
                            </div>
                            <div class="clearfix"></div>
                        </div>
                    </div>
                </div>
                <div class="col-6">
                    <div class="bg-picture card-box">
                        <h4 class="m-t-0 header-title">Gestionnaire de ban</h4>
                        <form method="POST">
                          <?php if($editing_user['isBanned']): ?>
                          <div class="form-group text-center">
                              <div class="col-12">
                                  <button class="btn btn-danger btn-bordred btn-block waves-effect waves-light" type="submit" name="unbanUserBtn">Déban utilisateur</button>
                              </div>
                          </div>
                          <?php else: ?>
                          <div class="form-group">
                              <div class="col-12">
                                  <label for="reason">Raison</label>
                                  <input class="form-control" type="text" required="" id="reason" name="reason" placeholder="Raison">
                              </div>
                          </div>
                          <div class="form-group text-center">
                              <div class="col-12">
                                  <button class="btn btn-danger btn-bordred btn-block waves-effect waves-light" type="submit" name="banUserBtn">Ban utilisateur</button>
                              </div>
                          </div>
                        <?php endif; ?>
                        </form>
                        <div class="clearfix"></div>
                    </div>
                </div>
                <div class="col-12">
                    <div class="bg-picture card-box">
                        <h4 class="m-t-0 header-title">Logs utilisateur</h4>
                        <!-- CONTENT -->
                        <table id="datatable" class="table table-borderless">
                            <thead>
                                <tr>
                                    <th>ID Log</th>
                                    <th>Action</th>
                                    <th>Date/Heure</th>
                                </tr>
                            </thead>


                            <tbody>
                            <?php
                          $sql             = "SELECT * FROM logs WHERE username=?";
                          $stmt            = $pdo->prepare($sql);
                          $stmt->execute([$editing_user['username']]);
                          $logRow = $stmt->fetchAll(PDO::FETCH_ASSOC);

                          foreach ($logRow as $log) {
                          echo '
                          <tr>
                              <td>'. $log['log_id'] .'</td>
                              <td>'. $log['action'] .'</td>
                              <td>'. $log['timestamp'] .'</td>
                          </tr>
                          ';
                          }
                          ?>
                            </tbody>
                        </table>
                        <div class="clearfix"></div>
                    </div>
                </div>
            </div>
        </div>
        <?php break; ?>

        <?php case "usergroups": ?>
          <?php if (staff_siteSettings === 'false'): ?>
            <div class="alert alert-danger" role="alert">
              Vous ne pouvez pas modifier les groupes d'utilisateurs.
            </div>
          <?php endif; ?>
          <div class="row">
              <div class="col-lg-12">
                  <div class="card-box">
                      <h4 class="m-t-0 header-title">Groupes</h4>
                      <table id="datatable" class="table table-borderless">
                          <thead>
                              <tr>
                                  <th>ID</th>
                                  <th>Nom</th>
                                  <th># du groupe</th>
                                  <th><center>Actions</center></th>
                              </tr>
                          </thead>


                          <tbody>
                        <?php
                        $sql             = "SELECT * FROM usergroups";
                        $stmt            = $pdo->prepare($sql);
                        $stmt->execute();
                        $usergroupsRow = $stmt->fetchAll(PDO::FETCH_ASSOC);

                        foreach ($usergroupsRow as $userGroup) {
                          echo '
                          <tr>
                            <td>'. $userGroup['id'] .'</td>
                            <td>'. $userGroup['name'] .'</td>';
                            $sql_countGroupMembers = "SELECT count(*) FROM `user` WHERE usergroup = ?";
                            $result_countGroupMembers = $pdo->prepare($sql_countGroupMembers);
                            $result_countGroupMembers->execute([$userGroup['id']]);
                            $countUsergroupMembers = $result_countGroupMembers->fetchColumn();


                            echo '
                            <td>'. $countUsergroupMembers .'</td>
                            <td><input type="button" onClick="notReadyMsg();" class="btn btn-sm btn-success btn-block" value="Modifier"></td>
                            </tr>
                          ';
                        }
                        ?>
                          </tbody>
                      </table>
                  </div>
              </div>
          </div>
        <?php break; ?>

        <?php case "group-id": ?>
            <?php
                if (isset($_GET['group-id']) && strip_tags($_GET['group-id'])) {
                $id   = $_GET['group-id'];
                $sql  = "SELECT * FROM usergroups WHERE id = :id";
                $stmt = $pdo->prepare($sql);
                $stmt->bindValue(':id', $id);
                $stmt->execute();
                $groupDB = $stmt->fetch(PDO::FETCH_ASSOC);
                    if ($groupDB === false) {
                        echo "<script> location.replace('staff.php?m=users'); </script>";
                        exit();
                    } else {
                        $editing_group['id'] = $groupDB['id'];
                        $_SESSION['editing_group_id'] = $editing_group['id'];
                        $editing_group['perm_isBanned'] = $groupDB['isBanned'];
                        $editing_group['perm_panel_access'] = $groupDB['panel_access'];
                        $editing_group['perm_staff_approveUsers'] = $groupDB['staff_approveUsers'];
                        $editing_group['perm_staff_access'] = $groupDB['staff_access'];
                        $editing_group['perm_staff_viewUsers'] = $groupDB['staff_viewUsers'];
                        $editing_group['perm_staff_editAdmins'] = $groupDB['staff_editAdmins'];
                        $editing_group['perm_staff_siteSettings'] = $groupDB['staff_siteSettings'];
                        $editing_group['perm_staff_banUsers'] = $groupDB['staff_banUsers'];
                        $editing_group['default_group'] = $groupDB['default_group'];
                    }
                }
            ?>

        <?php break; ?>

        <?php case "root-setup": ?>
          <?php if (staff_SuperAdmin == 'false'): ?>
            <div class="alert alert-danger" role="alert">
                <strong>Seuls les Super-Admin peuvent y accéder.</strong>
            </div>
          <?php else: ?>
            <?php
            if (isset($_POST['setRootBtn'])) {
              $newRootUser    = !empty($_POST['newRootUser']) ? trim($_POST['newRootUser']) : null;
              $newRootUser    = strip_tags($newRootUser);

              $sql = "UPDATE user SET root_user=? WHERE user_id=?";
              $stmt = $pdo->prepare($sql);
              $stmt->execute(['true', $newRootUser]);

              echo "<script> location.replace('staff.php?m=settings&root=set'); </script>";
              exit();
            }
            ?>
            <div class="alert alert-info" role="alert">
                <strong>Veuillez noter que les utilisateurs root ont un accès COMPLET à l'ensemble du panel et à tous les paramètres.</strong>
            </div>
            <form method="POST">
              <div class="form-group">
                  <div class="col-12">
                      <label for="usergroup">Sélectionnez un nouvel utilisateur root...</label>
                      <select class="form-control custom-select my-1 mr-sm-2" id="newRootUser" name="newRootUser">
                        <?php
                        $sql_getAllUsers             = "SELECT * FROM user where usergroup = '6'";
                        $stmt2_getAllUsers            = $pdo->prepare($sql_getAllUsers);
                        $stmt2_getAllUsers->execute();
                        $usersList = $stmt2_getAllUsers->fetchAll(PDO::FETCH_ASSOC);
                        foreach ($usersList as $usersDB) {
                        ?>
                        <option value="<?php echo $usersDB['user_id'] ?>"><?php echo $usersDB['username'] ?></option>
                        <?php } ?>
                      </select>
                  </div>
              </div>
              <div class="form-group">
                <div class="col-12">
                    <button class="btn btn-info btn-bordred btn-block waves-effect waves-light" type="submit" name="setRootBtn">Confirmer</button>
                </div>
              </div>
            </form>
          <?php endif; ?>
        <?php break; ?>

        <?php endswitch; ?>
        <?php else: ?>
        <div class="alert alert-danger" role="alert">
            <strong>Vous n'avez pas la permission d'accéder à cette page.</strong>
        </div>
        <?php endif; ?>
    </div>
    <!-- CONTENT END -->
    <?php include 'inc/copyright.php'; ?>
    <?php include 'inc/page-bottom.php'; ?>
