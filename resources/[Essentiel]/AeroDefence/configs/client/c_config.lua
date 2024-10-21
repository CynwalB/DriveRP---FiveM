--[[
    antiFreeCam = true  -> Ban and log 
    antiFreeCam = false -> kick and log 
    antiFreeCam = nil   -> disable
]]--

cAD = {}

cAD.screenshotResource = 'screenshot-basic'

--#[[ Admin Menu ]]#--

cAD.openKey = 57 -- (f11) admin menu open key -> https://docs.fivem.net/docs/game-references/controls/

--#[[ shit ]]#--

cAD.antiEulen = 1 --(BETA), 3 = ban, 2 = kick, 1 = log, nil = disable 
cAD.antiResourceStop = true -- detects eulen, desudo, fivex, redEngine...
cAD.antiInjection = true -- anti injection detects eulen and some other execs...
cAD.antiNuiDevTools = nil -- just kick, cause normal can use it
cAD.spawnProtection = true -- detects if spawn vehicle / entities / peds / pickups using eulen...
cAD.antiSoundPlay = true -- stops sounds from playing, DON'T BAN

--#[[ Trigger ]]#--

cAD.clientTriggerProtection = true
cAD.antiBlackListedTrigger = true

--#[[ General ]]#--

cAD.antiFastRun = {
    use = true, 
    maxSpeed = 5 -- km/h
}
cAD.antiFastSwin = {
    use = true, 
    maxSpeed = 30 -- km/h
}

cAD.antiSuperJump = nil 
cAD.antiNightVision = true 
cAD.antiThermalVision = true
cAD.antiSpectate = nil
cAD.antiGodMode = {
    [1] = true, 
    [2] = true, -- may not work for everyone
    [3] = true
}
cAD.antiInvisible = {
    [1] = nil,
    [2] = {use = nil, maxAlpha = 150},
}
cAD.antiGiveArmor = {
    use = true, 
    maxArmor = 100
}
cAD.antiInfiniteStamina = true -- beta
cAD.antiNoClip = true
cAD.antiRadar = nil
cAD.antiPlayersBlips = true
cAD.antiAfkBypass = true
cAD.antiSmallPlayerPed = true
cAD.antiExplosionDamage = true -- disables all explosions damage

--#[[ Modmenu ]]#--

cAD.antiMenyoo = nil -- DON'T USE THIS IF YOU HAVE FREECAM IN YOUR SERVER
cAD.antiBlackListedTextures = true

cAD.antiBlackListedScreenWord = {
    use = true,
    timer = 10
}

--#[[ Weapon ]]#--

cAD.antiInfiniteAmmo = true

cAD.antiWeaponModifier = {
    [1] = {use = true, maxModifier = 1.0},
    [2] = {use = true, maxModifier = 1.0},
    [3] = {use = true},
    [4] = {use = true, maxModifier = 1.0}, -- detects eulen
    [5] = {use = true, maxModifier = 1.0},
    [6] = {use = true, maxModifier = 1.0},
    [7] = {use = true, maxModifier = 1.0},
}

cAD.antiExplosiveWeapons = nil -- bans if player has a explosive weapon
cAD.antiAimBot = true 
cAD.antiAimAssist = true -- it just disables it
cAD.antiPickUps = nil -- 3 = ban, 2 = kick, 1 = just deletes the pickup  (ENABLE THIS IF YOU HAVE ANTI GIVE WEAPON OR FALSE BAN)

--#[[ FreeCam ]]#--

cAD.antiFreeCam = nil -- 3 = ban, 2 = kick, 1 = stop cam, nil = disable 
cAD.checkCamCoords = nil -- 3 = ban, 2 = kick, 1 = stop cam, nil = disable (go to config table to add whitelisted coords)

--#[[ Vehicle ]]#--

cAD.antiCarKill = false
cAD.antiVehicleModifier = {
    [1] = {use = true, maxModifier = 1.0},
    [2] = {use = nil, maxModifier = 1.0},
    [3] = {use = nil, maxModifier = 1.0},
    [4] = {use = true, maxModifier = 1.0},
}
cAD.antiVehicleWeapons = true -- just disables them.
cAD.antiCheatEngine = true -- detects if vehicle hash changes
cAD.antiVehicleFly = true 

cAD.vehicleSpeed = {
    use = 3, -- 3 = ban, 2 = kick, 1 = just deteletes the vehicle, nil = to disable
    max = 500, -- in km/h
}