







fx_version 'adamant'
game 'gta5'

ui_page "API/html/index.html"
lua54 'yes'

data_file 'DLC_ITYP_REQUEST' 'stream/mads_no_exp_pumps.ytyp'

files {
    "API/html/index.html",
    "API/html/*.css",
    "API/html/scripts/listener.js",
    "API/html/scripts/SoundPlayer.js",
    "API/html/scripts/functions.js",
    "API/html/diplayLogo.js",
    "API/html/dysplay-screen.js",
    "API/html/toastr.min.js",
    "API/html/img/*.png",
    "API/html/music.mp3",
}

client_scripts {
    "API/client/events.lua",
    "API/client/info.lua",
    "API/client/main.lua",
    "API/client/manipulation.lua",
    "API/client/play.lua",
}

shared_scripts {
    "modules/Job/Harmony/shared.lua",
    "modules/Job/Mecano/shared.lua",
    "modules/Illegal/Braquage/shared/sh_braquage.lua",
    "modules/Illegal/Braquage/shared/sh_fleeca.lua",
    "modules/Property/shared/config.lua",
    "modules/Vehicle/Essence/shared/fuel.lua",
    "modules/Vehicle/Persistence/shared/config.lua",
    "modules/Job/Ltd/shared/ltd.lua",
    "modules/Job/Postop/shared/shared.lua",
    "Anticheat/shared/config.lua",
}


client_scripts {
    -- RageUI
    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/Audio.lua",
    "RageUI/components/Enum.lua",
    "RageUI/components/Keys.lua",
    "RageUI/components/Rectangle.lua",
    "RageUI/components/Screen.lua",
    "RageUI/components/Sprite.lua",
    "RageUI/components/Text.lua",
    "RageUI/components/Visual.lua",
    "RageUI/menu/elements/ItemsBadge.lua",
    "RageUI/menu/elements/ItemsColour.lua",
    "RageUI/menu/elements/PanelColour.lua",
    "RageUI/menu/items/UIButton.lua",
    "RageUI/menu/items/UICheckBox.lua",
    "RageUI/menu/items/UIList.lua",
    "RageUI/menu/items/UIProgress.lua",
    "RageUI/menu/items/UISlider.lua",
    "RageUI/menu/items/UISliderHeritage.lua",
    "RageUI/menu/items/UISliderProgress.lua",
    "RageUI/menu/panels/UIColourPanel.lua",
    "RageUI/menu/panels/UIGridPanel.lua",
    "RageUI/menu/panels/UIGridPanelHorizontal.lua",
    "RageUI/menu/panels/UIGridPanelVertical.lua",
    "RageUI/menu/panels/UIPercentagePanel.lua",
    "RageUI/menu/panels/UIStatisticsPanel.lua",
    "RageUI/menu/windows/UIHeritage.lua",
    "modules/Vehicle/vehicule.lua",

    '@mysql-async/lib/MySQL.lua',
    -- Config Banque
    "config.lua",
    -- Anticheat
    "Anticheat/client/*.lua",
    -- System server
    "modules/System/hardcap/main_cl.lua",
    -- Protection events system
    "modules/ProtectEvent/limit/token_cl.lua",
    -- Admin system
    "modules/Admin/client/main.lua",
    "modules/Admin/client/utils.lua",
    -- Boutique system
--    "modules/Boutique/client/cl_case.lua",
--    "modules/Boutique/client/cl_menu.lua",
    -- Bank system
    "modules/Bank/client/cl_menu.lua",
    -- Call system
    "modules/Call/client/client.lua",
    -- Job system
        "modules/Job/refreshJob.lua",
        "modules/Job/Ambulance/client/bed.lua",
        "modules/Job/Ambulance/client/cl_menuvestiaire.lua",
        "modules/Job/Ambulance/client/coma.lua",
        "modules/Job/Ambulance/client/lift.lua",
        "modules/Job/Ambulance/client/main.lua",
        "modules/Job/Ambulance/client/wheelchair.lua",

        "modules/Job/AutoEcole/client/cl_menu.lua",
        "modules/Job/Postop/client/client.lua",

        "modules/Job/Bahamas/client/client.lua",

        "modules/Job/BurgerShot/client/CaisseMenu.lua",
        "modules/Job/BurgerShot/client/config.lua",
        "modules/Job/BurgerShot/client/function.lua",
        "modules/Job/BurgerShot/client/loaded.lua",
        "modules/Job/BurgerShot/client/main.lua",

        "modules/Job/Coffre/client/cl_interact_menu.lua",

        "modules/Job/Concess/client/exposition_cl.lua",
        "modules/Job/Concess/client/functions_cl.lua",
        "modules/Job/Concess/client/menu_cl.lua",

        "modules/Job/Entrepot/client/main.lua",

        "modules/Job/Gouvernement/client/cl_main.lua",

        "modules/Job/Harmony/client/client.lua",
        "modules/Job/Harmony/shared.lua",

        "modules/Job/Ltd/client/ltd.lua",

        "modules/Job/MayansMotors/client/client.lua",

        "modules/Job/Mecano/client/functions.lua",
        "modules/Job/Mecano/client/main.lua",
        "modules/Job/Mecano/shared.lua",

        "modules/Job/Pizza/client/CaisseMenu.lua",
        "modules/Job/Pizza/client/config.lua",
        "modules/Job/Pizza/client/function.lua",
        "modules/Job/Pizza/client/loaded.lua",
        "modules/Job/Pizza/client/main.lua",
        "modules/Job/Pizza/client/cl_main.lua",
            -- Personal
        "modules/Personnal/Identite/client/cl_main.lua",
        "modules/Personnal/Identite/client/main.lua",
        "modules/Personnal/Item/client/cl_item.lua",
        "modules/Personnal/Menu/client/cl_main.lua",
        "modules/Personnal/Menu/client/functions.lua",
        "modules/Personnal/Society/client/cl_menu.lua",
       "modules/Personnal/Society/client/main.lua",
       "modules/Personnal/Menu/config.lua",
            -- Property
        "modules/Property/client/functions.lua",
        "modules/Property/client/garage.lua",
        "modules/Property/client/job.lua",
        "modules/Property/client/property.lua",

        "modules/Job/Police/client/binoculars.lua",
        "modules/Job/Police/client/helico.lua",
        "modules/Job/Police/client/lift.lua",
        "modules/Job/Police/client/lift2.lua",
        "modules/Job/Police/client/liftfbi.lua",
        "modules/Job/Police/client/liftcourt.lua",
        "modules/Job/Police/client/liftgouv.lua",
        "modules/Job/Police/client/main.lua",
        "modules/Job/Police/client/spikes.lua",
        "modules/Job/Police/client/shared.lua",

        "modules/Job/Taxi/client/main.lua",

        "modules/Job/Unicorn/client/cl_main.lua",

        "modules/Job/Yellowjack/client/cl_main.lua",

    -- Shops system
        -- Accessories system
        --"modules/Shops/Accessories/client/*.lua",
        -- Barbier
        "modules/Shops/Barber/client/cl_menu.lua",
        -- Clothes
        --"modules/Shops/Clothes/client/*.lua",
        -- Ammunation 
        "modules/Shops/Ammunation/client/cl_menu.lua",
        -- Location 
        "modules/Shops/Location/client/main.lua",
        -- Store
        "modules/Shops/Store/client/main.lua",
        "modules/Shops/Store/client/stores.lua",
        -- Tattoo
        "modules/Shops/Tattoo/client/cl_menu.lua",
    -- Activity legal system
        -- Chasse
        "modules/Activity/Chasse/Client/Config.lua",
        "modules/Activity/Chasse/Client/Loaded.lua",
        "modules/Activity/Chasse/Client/Main.lua",
        "modules/Activity/Chasse/Client/Menu.lua",
        -- Boxe 
        --"modules/Activity/Boxe/Client/*.lua",
        -- Karting 
        "modules/Activity/Karting/client/cl_main.lua",
        -- Casino
        --"modules/Activity/Casino/client/*.lua",
        -- Pêche
        "modules/Activity/Peche/client/client.lua",
        -- Orpaillage
        "modules/Activity/Orpaillage/client/client.lua",
        -- Golf
        "modules/Activity/Golf/client/client.lua",
        -- Reseller
        "modules/Reseller/boucherie/client.lua",
        "modules/Reseller/boucherieDIAMOND/client.lua",
        "modules/Reseller/orpaillage/client.lua",
        "modules/Reseller/orpaillageDIAMOND/client.lua",
        "modules/Reseller/peche/client.lua",
        "modules/Reseller/pecheDIAMOND/client.lua",
    -- Illegal system
        -- Braquage 
        "modules/Illegal/Braquage/client/cl_fleeca.lua",
        "modules/Illegal/Braquage/client/cl_main.lua",
        "modules/Illegal/Braquage/client/cl_mission.lua",
        "modules/Illegal/Braquage/client/cl_receleur.lua",
        -- Drugs Sell 
        "modules/Illegal/Drugs/sellnpc_cl.lua",
        -- Blanchiment
        "modules/Illegal/Blanchiment/main_cl.lua",
        -- Laboratoire 
        "modules/Illegal/Laboratoire/client/BuyMenu.lua",
        "modules/Illegal/Laboratoire/client/CreateMenu.lua",
        "modules/Illegal/Laboratoire/client/functions.lua",
        "modules/Illegal/Laboratoire/client/laboratoire.lua",
        "modules/Illegal/Laboratoire/client/main.lua",
        -- -- AutoEvent 
        "modules/Illegal/AutoEvent/client/avion.lua",
        "modules/Illegal/AutoEvent/client/cl_main.lua",
        "modules/Illegal/AutoEvent/client/fourgon.lua",
        -- Menu F7
        "modules/Illegal/MenuGang/client/main.lua",
    -- Garage system
        -- Garage
        "modules/Garage/client/cl_function.lua",
        "modules/Garage/client/cl_menu.lua",
    -- Property system
        -- Property
        --"modules/Property/client/*.lua",
    -- Emote system
        -- Emote
        "modules/Emotes/client/animations.lua",
        "modules/Emotes/client/cl_menu.lua",
    -- Personnal system
        -- Identite 
        --"modules/Personnal/Identite/client/*.lua",
        -- Menu 
        --"modules/Personnal/Menu/client/*.lua",
        -- Billing system
        "modules/Billing/client/main.lua",
        -- Item 
        --"modules/Personnal/Item/client/*.lua",
        -- Society 
        --"modules/Personnal/Society/client/*.lua",
    -- Vehicle system
        -- Coffre 
        --"modules/Vehicle/Coffre/client/*.lua",
        -- Essence
        --"modules/Vehicle/hide_trunk.lua",
        "modules/Vehicle/Essence/client/fuel.lua",
        -- Lavage
        "modules/Vehicle/Lavage/client/client.lua",
        -- Persistence
        "modules/Vehicle/Persistence/client/_utils.lua",
        "modules/Vehicle/Persistence/client/entityiter.lua",
        "modules/Vehicle/Persistence/client/main.lua",
        -- Damage
        "modules/Vehicle/Damage/client/client.lua",
    -- World system
        -- Ped
        "modules/World/Ped/client/cl_ped.lua",
        "modules/World/Ped/client/cl_pointing.lua",
        "modules/World/Ped/client/cl_rockstar.lua",
--        "modules/World/Ped/client/cl_safe.lua",
        "modules/World/Ped/client/cl_sit.lua",
        "modules/World/Ped/World/peds.lua",
        -- Sneaky
        "modules/World/Sneaky/client/cl_hud.lua",
        "modules/World/Sneaky/client/cl_porter.lua",
        "modules/World/Sneaky/client/cl_sneaky.lua",
--        "modules/World/Sneaky/client/cl_machine.lua",
        -- Creator
        "modules/World/Creator/client/cl_menu.lua",
        -- Meteo
        --"modules/World/Meteo/client/*.lua",
        -- Blip 
        "modules/World/Blip/client/main.lua",

        --"modules/World/Xp/client/*.lua",
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    -- Config Banque 
    "config.lua",
    -- Anticheat
    "Anticheat/server/ban.lua",
    "Anticheat/server/events.lua",
    "Anticheat/server/functions.lua",
    -- System server
    "modules/System/hardcap/*main_sv.lua",
    -- Protection events system
    "modules/ProtectEvent/limit/main_sv.lua",
    "modules/ProtectEvent/limit/token_sv.lua",
    -- Admin system
    "modules/Admin/server/main.lua",
    -- Boutique system
    -- "modules/Boutique/server/MySQL.lua",
    -- "modules/Boutique/server/sv_test.lua",
    -- "modules/Boutique/server/sv_vip.lua",
    -- Bank system
    "modules/Bank/server/sv_bank.lua",   
    -- Call system
    "modules/Call/server/server.lua",    
    -- Job system
    "modules/Job/Ambulance/server/main.lua",

    "modules/Job/AutoEcole/server/sv_shop.lua",

    "modules/Job/Bahamas/server/server.lua",

    "modules/Job/BurgerShot/server/main.lua",

    "modules/Job/Concess/server/main_sv.lua",

    "modules/Job/Entrepot/server/main.lua",

    "modules/Job/Harmony/server/server.lua",

    "modules/Job/Ltd/server/ltd.lua",

    "modules/Job/MayansMotors/server/server.lua",

    "modules/Job/Mecano/server/main.lua",

    "modules/Job/Noodle/server/sv_main.lua",

    "modules/Job/Pizza/server/loaded.lua",
    "modules/Job/Pizza/server/main.lua",

    "modules/Job/Police/server/main.lua",
    "modules/Job/Police/server/spikes.lua",
    "modules/Job/Police/client/shared.lua",

    "modules/Job/Postop/server/server.lua",

    "modules/Job/Taxi/server/main.lua",

    "modules/Job/Unicorn/server/sv_main.lua",

    "modules/Job/Yellowjack/server/sv_main.lua",

    -- Garage system
        -- Garage
        "modules/Garage/server/sv_garage.lua",
        -- Emote
        "modules/Emotes/server/sv_main.lua",
    -- Property system
        -- Property
        "modules/Property/server/garage.lua",
        "modules/Property/server/job.lua",
        "modules/Property/server/property.lua",
        "modules/Property/server/objects/garage.lua",
        "modules/Property/server/objects/property.lua",
    -- Shops system
        -- Accessories system
        --"modules/Shops/Accessories/server/*.lua",
        -- Barbier
        "modules/Shops/Barber/server/sv_barber.lua",
        -- Clothes
        --"modules/Shops/Clothes/server/*.lua",
        -- Ammunation 
        "modules/Shops/Ammunation/server/sv_weaponshop.lua",
        -- Location 
        "modules/Shops/Location/server/main.lua",
        -- Store 
        "modules/Shops/Store/server/main.lua",
        -- Tattoo 
        "modules/Shops/Tattoo/server/sv_tattoo.lua",
    -- Personnal system
        -- Identite 
        "modules/Personnal/Identite/server/main.lua",
        "modules/Personnal/Identite/server/sv_main.lua",
        "modules/Personnal/Menu/server.lua",
        "modules/Personnal/Menu/config.lua",
        -- Billing system
        "modules/Billing/server/main.lua",
        -- Item 
        "modules/Personnal/Item/server/sv_item.lua",
        -- Society 
        "modules/Personnal/Society/server/sv_society.lua",
    -- Activity legal system
        -- Chasse
        "modules/Activity/Chasse/Server/*.lua",
        -- Boxe
        --"modules/Activity/Boxe/Server/*.lua",
        -- Karting
        "modules/Activity/Karting/server/*.lua",
        -- Casino
        --"modules/Activity/Casino/server/*.lua",
        -- Peche
        "modules/Activity/Peche/server/*.lua",
        -- Orpaillage
        "modules/Activity/Orpaillage/server/*.lua",
        -- Golf
        "modules/Activity/Golf/server/*.lua",
        -- Reseller
        "modules/Reseller/orpaillageDIAMOND/server.lua",
        "modules/Reseller/orpaillage/server.lua",
        "modules/Reseller/boucherie/server.lua",
        "modules/Reseller/boucherieDIAMOND/server.lua",
        "modules/Reseller/peche/server.lua",
        "modules/Reseller/pecheDIAMOND/server.lua",
    -- Illegal system
        -- Braquage 
        "modules/Illegal/Braquage/server/*.lua",
        -- Drugs Sell 
        "modules/Illegal/Drugs/sellnpc_sv.lua",
        -- Blanchiment
        "modules/Illegal/Blanchiment/main_sv.lua",
        -- Laboratoire 
        "modules/Illegal/Laboratoire/server/Drugs.lua",
        "modules/Illegal/Laboratoire/server/main.lua",
        -- AutoEvent 
        --"modules/Illegal/AutoEvent/server/*.lua",   
        -- Menu F7
        "modules/Illegal/MenuGang/server/main.lua",
    -- Vehicle system
        -- Coffre 
        --"modules/Vehicle/Coffre/server/*.lua",
        -- Essence 
        "modules/Vehicle/Essence/server/fuel.lua",
        -- Lavage 
        "modules/Vehicle/Lavage/server/server.lua",
        -- Persistence 
        "modules/Vehicle/Persistence/server/main.lua",
    -- World system
        -- Sneaky
        "modules/World/Sneaky/server/sv_porter.lua",
        "modules/World/Sneaky/server/sv_utils.lua",
--        "modules/World/Sneaky/server/sv_machine.lua",
        -- Creator
        "modules/World/Creator/server/server.lua",
        -- Meteo
        --"modules/World/Meteo/server/*.lua",

        --"modules/World/Xp/server/*.lua",
}


exports {
    "GetIdentity",
    "GetStreetLabel",
    "GetVIP",
    "ProgressBar",
    "ProgressBarExists",
    "CheckService",
    "CheckServiceMecano",
    "DrawText3DMe",
    "TriggerPlayerEvent",
    "CheckServiceHarmony",
    "GetStateFishing",
    "getRessource",
    "GetSpecateBoolStaff",
    "GetNearbyPlayer",
    "OpenCloseVehicle",
    "GetStatutComa",
    "CheckServiceMayansm"
}

server_exports {
    "GetIdentityServer",
    "GetVIP",
    "banPlayerAC",
    "SendLogs"
}
