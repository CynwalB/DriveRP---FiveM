Config = {}

Config.CuffItem = 'cuff'
Config.CuffKeysItem = 'cuff_keys'
Config.RopeItem = 'rope'
Config.BagToHeadItem = 'headbag'
Config.ElectronicCuffItem = 'electrocuff'
Config.ElectronicCuffTrackerItem = 'electrocufftracker'

Config.OpenMenuKey = 288  --f1
Config.InventoryOpenKey = 289 -- Disables this input when user is cuffed
Config.DisableWhenUserCuffed = {289, 37, 192, 204, 211, 349} -- Disables these input when user is cuffed

Config.HandcuffIMG = 'https://raw.githubusercontent.com/0resmon/db/main/img/black.png'
Config.HandcuffDefaultIMG = 'https://raw.githubusercontent.com/0resmon/db/main/img/prop_chrome_03.png'
Config.HandcuffSound = 'https://raw.githubusercontent.com/0resmon/db/main/sound/handcuff.mp3'

Config.RealtimeGPS = true -- WARNING: Enabling this option will enable realtime gps isntead of just marking gps location on tablet but it may cause a lot of cps/ram usage on both client and server side.
Config.RealtimeGPSRefreshMS = 1000 -- WARNING: This option directly affect cpu/ram usage, so be carefull when changing it! It controls how fast the gps will refresh itself

Config.TestMode = false

Config.GetClosestPlayer = function()
   return ESX.Game.GetClosestPlayer()
end

Config.Lang = {
    ["no_one_nearby"] = "Il n'y a personne autour",
    ["no_one_nearby_cuff"] = "Il n'y a personne autour pour menotter",
    ["no_one_nearby_cuff2"] = "La personne doit lever les mains",
    ["menu_title"] = "Menu Actions",
    ["put_bag"] = "Retirez le sac sur la tête",
    ["arac_bin"] = "Mettez le joueur dans la voiture",
    ["arac_in"] = "Sortez le joueur dans la voiture",
    ["bacak_coz"] = "Détachez la corde sur la jambe",
    ["bant_cikar"] = "Mettez/enlevez le ruban adhésif dans votre bouche",
    ["tasi"] = "Déplacer le joueur",
    ["birak"] = "Libérer le joueur",
    ["tape_type"] = "Sélectionnez le type de bande",
    ["bant"] = "Ruban noir",
    ["money"] = "Espèces",
}

Config.MenuElements = {
  
    { value = "arac_bin", label = Config.Lang["arac_bin"] },
    { value = "arac_in", label = Config.Lang["arac_in"] },
    { value = "bacak_coz", label = Config.Lang["bacak_coz"] },
    { value = "bant_cikar", label = Config.Lang["bant_cikar"] },
    { value = "tasi", label = Config.Lang["tasi"] },
    { value = "birak", label = Config.Lang["birak"] }
}
