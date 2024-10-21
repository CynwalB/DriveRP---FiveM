sAD = {}

--#[[ Authenfication ]]#-- 


sAD.license = {
    licenseKey = 'Cracked',
    identifier = 'By',
    password   = 'BloodMoon#0265',
}

--#[[ Ban ]]#-- 

sAD.ban = {
    srvName = 'Paris Triomphe Rp',
    useBanCard = true, -- enable i want to use the ban card and you need to dont have a other one, = nil to disable
    banIp = true,
    banCardRelated = {
        timer = 5, -- in seconds
        name = 'Paris Triomphe Rp',
        icon = "https://cdn.discordapp.com/attachments/1014110126782828564/1014569641558954044/02020-removebg-preview.png",
        url = 'https://discord.gg/pWMrp4D7fk'
    },
    troll = {
        sound = 'https://youtu.be/dZLR6241kpM', 
    }
}

--#[[ Logs ]]#-- 

sAD.logs = {
    use = true, 
    general = "https://discord.com/api/webhooks/1015177465511034890/6LFPXoeWm4gTycIkZg-O6VfT3oTx-aH-DtHC5Cy3NZ7sB_57vGtfGlLWEn3GHC01GITi",
    weapon = "https://discord.com/api/webhooks/1015177465511034890/6LFPXoeWm4gTycIkZg-O6VfT3oTx-aH-DtHC5Cy3NZ7sB_57vGtfGlLWEn3GHC01GITi",
    entities = "https://discord.com/api/webhooks/1015177465511034890/6LFPXoeWm4gTycIkZg-O6VfT3oTx-aH-DtHC5Cy3NZ7sB_57vGtfGlLWEn3GHC01GITi",
    explosion = "https://discord.com/api/webhooks/1015177465511034890/6LFPXoeWm4gTycIkZg-O6VfT3oTx-aH-DtHC5Cy3NZ7sB_57vGtfGlLWEn3GHC01GITi",
    resource = "https://discord.com/api/webhooks/1015177465511034890/6LFPXoeWm4gTycIkZg-O6VfT3oTx-aH-DtHC5Cy3NZ7sB_57vGtfGlLWEn3GHC01GITi",
    admin = "https://discord.com/api/webhooks/1015177465511034890/6LFPXoeWm4gTycIkZg-O6VfT3oTx-aH-DtHC5Cy3NZ7sB_57vGtfGlLWEn3GHC01GITi",
    related = {
        ipInLog = true -- show ip in logs true pour les voirs ?
    }
}

sAD.screenshot = {
    use = true, 
    resource = 'screenshot-basic',
    webhook = 'https://discord.com/api/webhooks/1015177465511034890/6LFPXoeWm4gTycIkZg-O6VfT3oTx-aH-DtHC5Cy3NZ7sB_57vGtfGlLWEn3GHC01GITi' -- put here a screenshot where ban/kick images should be saved
}

--#[[ Connecting ]]#-- 

sAD.connecting = {
    vpn = {
        use = nil, -- anti vpn 
        whiteListedIps = {
            ['your-ip-here'] = true
        }
    },
    identifiers = {
        use = nil, -- need to activate this first
        forceDiscord = nil,
        forceSteam = nil,
        forceLicense = nil,
        forceXbox = nil,
        forceLive = nil,
        forceFiveM = nil,
    }
}

--#[[ ESX ]]#--

sAD.esx = 'nil' -- to disable replance with nil

sAD.antiGiveWeapon = 3 -- 4 = ban, 3 = kick, 2 = just remove all weapons, 1 = just remove gived weapon, nil = disable
sAD.esxBypass = {
    ['helper'] = 'aero-admin',
    ['mod'] = 'aero-bypass',
    ['admin'] = 'aero-bypass',
    ['superadmin'] = 'aero-admin',
    ['_dev'] = 'aero-admin',
}

sAD.esxTriggerProtection = true

--#[[ General ]]#-- 

sAD.antiBlackListedCrash = true
sAD.cleanWhenDetect = true -- deletes all what a cheater spawned (vehicles/props) after ban/kick
sAD.antiServerCrasher = true -- detects fivex...

sAD.antiClearPedTaskInmediately = nil 
sAD.antiClearPedTask = true

sAD.antiGodMode = {
    [1] = nil, 
    [2] = {use = true, maxHealth = 200}
}

sAD.antiInvisible = nil


--#[[ Trigger ]]#-- 

sAD.antiTrigger = true -- t_config and put triggers
sAD.antiBlackListedTrigger = true -- t_config and put triggers

--#[[ Weapon ]]#-- 

sAD.antiGivePlayerWeapon = true 
sAD.antiRemovePlayerWeapon = true 
sAD.antiRemovePlayerAllWeapons = true 

sAD.antiBlackListedWeapon = true

sAD.antiShoot = nil

sAD.antiMassShot = {
    use = true, 
    max = 30,
    timer = 1 -- in seconds
}

--#[[ Vehicles ]]#--

sAD.antiBlackListedVehicle = true

sAD.antiNotScriptVehicleSpawn = true 
sAD.spawnProtection = nil 

sAD.antiMassVehiclesSpawn = {
    use = true, 
    max = 10,
    timer = 1 -- in seconds
}

--#[[ Props ]]#--


sAD.antiBlackListedProp = nil

sAD.antiNotScriptPropSpawn = true 

sAD.antiMassPropsSpawn = {
    use = true, 
    max = 30,
    timer = 1 -- in seconds
}

--#[[ Peds ]]#--

sAD.antiBlackListedPed = nil

sAD.antiNotScriptPedSpawn = true
sAD.antiNotScriptPedAtackSpawn = true 
sAD.antiBlackListedPlayerPed = nil 

sAD.antiMassPedsSpawn = {
    use = true, 
    max = 30,
    timer = 1 -- in seconds
}

--#[[ Explosion ]]#--

sAD.antiBlackListedExplosion = true

sAD.antiMortalExplosion = true 
sAD.antiInvisibleExplosion = true 
sAD.antiSilentExplosion = true
sAD.antiCameraShakeExplosion = nil

sAD.antiMassExplosionsSpawn = {
    use = true, 
    max = 15,
    timer = 1 -- in seconds
}

--#[[ Fire ]]#--

sAD.antiFire = true -- Don't ban just cancel it

sAD.antiMassFireSpawn = {
    use = true, 
    max = 45,
    timer = 1 -- in seconds
}

--#[[ Particles ]]#--

   
sAD.antiBlackListedParticle = true
   
sAD.antiParticleOnEntity = true

sAD.antiMassParticlesSpawn = {
    use = true, 
    max = 15,
    timer = 1 -- in seconds
}

--#[[ Projectile ]]#--

sAD.antiProjectile = true -- Don't ban just cancel it

sAD.antiMassProjectileSpawn = {
    use = true, 
    max = 6,
    timer = 1 -- in seconds
}

--#[[ Chat ]]#--

sAD.antiBlackListedChatWord = true -- just kick

sAD.antiFakeChatMsg = true

sAD.antiMassChatMsg = {
    use = true, 
    max = 20,
    timer = 1 -- in seconds
}

--#[[ Trigger ]]#--


sAD.antiTriggerSpam = {
    use = true, 
    max = 8,
    timer = 1 -- in seconds
}