local sprops = {}

RegisterNetEvent("sProps:Open")
AddEventHandler("sProps:Open",function()
    OpenPropsRageUIMenu()
end)

function OpenPropsRageUIMenu()

    if sprops.Menu then 
        sprops.Menu = false 
        RageUI.Visible(RMenu:Get('sprops', 'main'), false)
        return
    else
        RMenu.Add('sprops', 'main', RageUI.CreateMenu("", "", 0, 0,"root_cause","sneakylife"))

        RMenu.Add('sprops', 'propscivil', RageUI.CreateSubMenu(RMenu:Get("sprops", "main"),"", "~g~Menu props"))
        RMenu.Add('sprops', 'props', RageUI.CreateSubMenu(RMenu:Get("sprops", "main"),"", "~g~Menu personnel"))
        RMenu.Add('sprops', 'object', RageUI.CreateSubMenu(RMenu:Get("sprops", "props"),"", "~g~Menu personnel"))
        RMenu.Add('sprops', 'object2', RageUI.CreateSubMenu(RMenu:Get("sprops", "props"),"", "~g~Menu personnel"))
        RMenu.Add('sprops', 'object3', RageUI.CreateSubMenu(RMenu:Get("sprops", "props"),"", "~g~Menu personnel"))
        RMenu.Add('sprops', 'object4', RageUI.CreateSubMenu(RMenu:Get("sprops", "props"),"", "~g~Menu personnel"))
        RMenu.Add('sprops', 'object5', RageUI.CreateSubMenu(RMenu:Get("sprops", "propscivil"),"", "~g~Menu personnel"))
        RMenu.Add('sprops', 'object6', RageUI.CreateSubMenu(RMenu:Get("sprops", "propscivil"),"", "~g~Menu personnel"))
        RMenu.Add('sprops', 'object7', RageUI.CreateSubMenu(RMenu:Get("sprops", "props"),"", "~g~Menu personnel"))
        RMenu.Add('sprops', 'objectlist', RageUI.CreateSubMenu(RMenu:Get("sprops", "props"),"", "~g~Menu personnel"))
        RMenu.Add('sprops', 'objectlistcivil', RageUI.CreateSubMenu(RMenu:Get("sprops", "propscivil"),"", "~g~Menu personnel"))
        sprops.Menu = false
    end
    sprops.Menu = true 
    RageUI.Visible(RMenu:Get('sprops', 'main'), true)
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj)
                ESX = obj
            end)
            ESX.PlayerData = ESX.GetPlayerData()
            Citizen.Wait(10)
        end
        if ESX.IsPlayerLoaded() then
            ESX.PlayerData = ESX.GetPlayerData()
        end        
        while sprops.Menu do
    RageUI.IsVisible(RMenu:Get('sprops', 'main'), true, false, true, function()
    end)
    
    RageUI.Button("Props Jobs", nil, { RightLabel = "→" }, true, function(h,a,s)
            TriggerEvent("sProps:Open")
        end, RMenu:Get('sprops', 'propscivil'))
    end)

    RageUI.IsVisible(RMenu:Get('sprops', 'propscivil'), true, false, true, function()
        if ESX.PlayerData.job.name == "police" or ESX.PlayerData.job.name == "lssd" or ESX.PlayerData.job.name == "ambulance" then
            RageUI.Button("EMS", "Poser des objets", { RightLabel = "→" }, true, function(h,a,s)
            end, RMenu:Get('sprops', 'object6'))
            RageUI.Button("LSPD/LSSD", "Poser des objets", { RightLabel = "→" }, true, function(h,a,s)
            end, RMenu:Get('sprops', 'object5'))
            RageUI.Button("~r~Mode suppression", "Supprimer les objets posées", { RightLabel = "" }, true, function(h,a,s)
            end, RMenu:Get('sprops', 'objectlistcivil'))
        end
    end)

    RageUI.IsVisible(RMenu:Get('sprops', 'props'), true, false, true, function()
    --					if vip == 1 or vip == 2 and not IsPedInAnyVehicle(PlayerPedId(),false) then
            if ESX.PlayerData.job.name ~= "unemployed" then
                RageUI.Button("Civil", "Poser des objets", { RightLabel = "→" }, true, function(h,a,s)
                end, RMenu:Get('sprops', 'object'))
            end 
            if ESX.PlayerData.job2.name ~= "unemployed" then
                RageUI.Button("Gang", "Poser des objets", { RightLabel = "→" }, true, function(h,a,s)
                end, RMenu:Get('sprops', 'object2'))
            end
            if ESX.PlayerData.job2.name ~= "unemployed" then
                RageUI.Button("Drogues", "Poser des objets", { RightLabel = "→" }, true, function(h,a,s)
                end, RMenu:Get('sprops', 'object3'))
            end
            if ESX.PlayerData.job2.name ~= "unemployed" then
                RageUI.Button("Armes", "Poser des objets", { RightLabel = "→" }, true, function(h,a,s)
                end, RMenu:Get('sprops', 'object4'))
            end
            RageUI.Button("~r~Mode suppression", "Supprimer les objets posées", { RightLabel = "" }, true, function(h,a,s)
            end, RMenu:Get('sprops', 'objectlist'))
    --                    end
    end)
    RageUI.IsVisible(RMenu:Get('sprops', 'objectlistcivil'), true, false, true, function()
        for k,v in pairs(object) do
            if GoodName(GetEntityModel(NetworkGetEntityFromNetworkId(v))) == 0 then table.remove(object, k) end
            RageUI.Button("Objet : "..GoodName(GetEntityModel(NetworkGetEntityFromNetworkId(v))).." ["..v.."]", nil, {}, true, function(h,a,s)
                if a then
                    local entity = NetworkGetEntityFromNetworkId(v)
                    local ObjCoords = GetEntityCoords(entity)
                    DrawMarker(2, ObjCoords.x, ObjCoords.y, ObjCoords.z+1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 170, 1, 0, 2, 1, nil, nil, 0)
                end
                if s then
                    RemoveObj(v, k)
                end
            end)
        end
    end, function()
    end)

RageUI.IsVisible(RMenu:Get('sprops', 'object2'), true, true, true, function()
    RageUI.Button("Chaise", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_weed_chair_01a")
        end
    end)

    RageUI.Button("Sac pour arme", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("prop_gun_case_01")
        end
    end)

    
    RageUI.Button("Prop meth", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_meth_pseudoephedrine")
        end
    end)
    
    RageUI.Button("Sac de meth ouvert", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_meth_openbag_01a")
        end
    end)
    
    RageUI.Button("Gros sac de meth", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_meth_bigbag_04a")
        end
    end)
    
    RageUI.Button("Gros sac de weed", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_weed_bigbag_03a")
        end
    end)
    
    RageUI.Button("Weed plante", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_weed_01_small_01a")
        end
    end)
    
    RageUI.Button("Weed", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_weed_dry_02b")
        end
    end)
    
    RageUI.Button("Table de weed", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_weed_table_01a")
        end
    end)
    
    RageUI.Button("Cash", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("hei_prop_cash_crate_half_full")
        end
    end)
    
    RageUI.Button("Valise de cash", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("prop_cash_case_02")
        end
    end)
    
    RageUI.Button("Petite pile de cash", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("prop_cash_crate_01")
        end
    end)
    
    RageUI.Button("Poubelle", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("prop_cs_dumpster_01a")
        end
    end)
    
    RageUI.Button("Canapé", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("v_tre_sofa_mess_c_s")
        end
    end)
    
    RageUI.Button("Canapé 2", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("v_res_tre_sofa_mess_a")
        end
    end)
    
    RageUI.Button("Pile de cash", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_bkr_cashpile_04")
        end
    end)
    
    RageUI.Button("Pile de cash 2", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_bkr_cashpile_05")
        end
    end)
    
    RageUI.Button("Block de coke", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_coke_block_01a")
        end
    end)
    
    RageUI.Button("Coke en bouteille", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_coke_bottle_01a")
        end
    end)
    
    RageUI.Button("Coke coupé", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_coke_cut_01")
        end
    end)

    RageUI.Button("Bol de coke", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_coke_fullmetalbowl_02")
        end
    end)
end)
RageUI.IsVisible(RMenu:Get('sprops', 'object3'), true, true, true, function()
    RageUI.Button("Cocaine Block", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_coke_block_01a")
        end
    end)

    RageUI.Button("Cocaine Pallet", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_coke_pallet_01a")
        end
    end)

    
    RageUI.Button("Balance Cocaine", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_coke_scale_01")
        end
    end)

    
    RageUI.Button("Spatule Cocaine", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_coke_spatula_04")
        end
    end)

    
    RageUI.Button("Table Cocaine", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_coke_table01a")
        end
    end)

    
    RageUI.Button("Caisse", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_crate_set_01a")
        end
    end)
    
    RageUI.Button("Palette Weed", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_fertiliser_pallet_01a")
        end
    end)
    
    RageUI.Button("Palette 1", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_fertiliser_pallet_01b")
        end
    end)
    
    RageUI.Button("Palette 2", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_fertiliser_pallet_01c")
        end
    end)
    
    RageUI.Button("Palette 3", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_fertiliser_pallet_01d")
        end
    end)
    
    RageUI.Button("Acetone Meth", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_meth_acetone")
        end
    end)
    
    RageUI.Button("Bidon Meth", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_meth_ammonia")
        end
    end)
    
    RageUI.Button("Bac Meth", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_meth_bigbag_01a")
        end
    end)
    
    RageUI.Button("Bac Meth 2", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_meth_bigbag_02a")
        end
    end)
    
    RageUI.Button("Bac Meth 3", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_meth_bigbag_03a")
        end
    end)
    
    RageUI.Button("Lithium Meth", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_meth_lithium")
        end
    end)
    
    RageUI.Button("Phosphorus Meth", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_meth_phosphorus")
        end
    end)
    
    RageUI.Button("Pseudoephedrine", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_meth_pseudoephedrine")
        end
    end)
    
    RageUI.Button("Meth Smash", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_meth_smashedtray_01")
        end
    end)
    
    RageUI.Button("Machine a sous", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_money_counter")
        end
    end)
    
    RageUI.Button("Acetone Meth", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_meth_acetone")
        end
    end)
    
    RageUI.Button("Pot Weed", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_weed_01_small_01b")
        end
    end)
    
    RageUI.Button("Packet Weed", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_weed_bigbag_03a")
        end
    end)
    
    RageUI.Button("Packet Weed Ouvert", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_weed_bigbag_open_01a")
        end
    end)
    
    RageUI.Button("Pot Weed 2", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_weed_bucket_01d")
        end
    end)
    
    RageUI.Button("Weed", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_weed_drying_01a")
        end
    end)
    
    RageUI.Button("Weed Plante", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_weed_lrg_01b")
        end
    end)
    
    RageUI.Button("Weed Plante 2", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_weed_med_01b")
        end
    end)
    
    RageUI.Button("Table Weed", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_weed_drying_01a")
        end
    end)
    
    RageUI.Button("Weed Pallet", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("hei_prop_heist_weed_pallet")
        end
    end)

    RageUI.Button("Coke", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("imp_prop_impexp_boxcoke_01")
        end
    end)
end)
RageUI.IsVisible(RMenu:Get('sprops', 'object4'), true, true, true, function()
    RageUI.Button("Malette Armes", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_biker_gcase_s")
        end
    end)
    RageUI.Button("Caisse Batteuses", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("ex_office_swag_guns04")
        end
    end)
    RageUI.Button("Caisse Armes", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("ex_prop_crate_ammo_bc")
        end
    end)
    RageUI.Button("Caisse Batteuses 2", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("ex_prop_crate_ammo_sc")
        end
    end)
    RageUI.Button("Caisse Fermé", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("ex_prop_adv_case_sm_03")
        end
    end)
    RageUI.Button("Petite Caisse", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("ex_prop_adv_case_sm_flash")
        end
    end)
    RageUI.Button("Caisse Explosif", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("ex_prop_crate_expl_bc")
        end
    end)
    RageUI.Button("Caisse Vetements", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("ex_prop_crate_expl_sc")
        end
    end)
    RageUI.Button("Caisse Chargeurs", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("gr_prop_gr_crate_mag_01a")
        end
    end)
    RageUI.Button("Grosse Caisse Armes", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("gr_prop_gr_crates_rifles_01a")
        end
    end)
    RageUI.Button("Grosse Caisse Armes 2", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("gr_prop_gr_crates_weapon_mix_01a")
        end
    end)
end)
RageUI.IsVisible(RMenu:Get('sprops', 'object5'), true, true, true, function()
    RageUI.Button("Cone", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("prop_roadcone02a")
        end
    end)

    RageUI.Button("Barrière", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("prop_barrier_work05")
        end
    end)

    RageUI.Button("Éclairage", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("prop_worklight_01a")
        end
    end)

    RageUI.Button("Gazebo", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("prop_gazebo_02")
        end
    end)
end)
RageUI.IsVisible(RMenu:Get('sprops', 'object6'), true, true, true, function()
    RageUI.Button("Sac mortuaire", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("xm_prop_body_bag")
        end
    end)

    RageUI.Button("Trousse médical 1", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("xm_prop_smug_crate_s_medical")
        end
    end)

    RageUI.Button("Trousse médical 2", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("xm_prop_x17_bag_med_01a")
        end
    end)
    RageUI.Button("Table", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("prop_table_04")
        end
    end)
    RageUI.Button("Chaise", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("prop_chair_08")
        end
    end)
    RageUI.Button("barriere EMS", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("prop_barrier_work06a")
        end
    end)
end)
RageUI.IsVisible(RMenu:Get('sprops', 'object7'), true, true, true, function()
    RageUI.Button("Balise maritime", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("prop_dock_bouy_1")
        end
    end)
    RageUI.Button("Décoration enterrement", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("prop_road_memorial_02")
        end
    end)
    RageUI.Button("Platine", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("v_club_vu_deckcase")
        end
    end)
    RageUI.Button("Lumière", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("prop_studio_light_01")
        end
    end)
    RageUI.Button("Panneau gauche", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("prop_offroad_bale03")
        end
    end)
    RageUI.Button("Panneau droite", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("prop_offroad_bale02")
        end
    end)
    RageUI.Button("Enceinte", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("prop_speaker_07")
        end
    end)
    RageUI.Button("Table de camping", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("prop_table_para_comb_05")
        end
    end)
end)


RageUI.IsVisible(RMenu:Get('sprops', 'objectlist'), true, false, true, function()
    for k,v in pairs(object) do
        if GoodName(GetEntityModel(NetworkGetEntityFromNetworkId(v))) == 0 then table.remove(object, k) end
        RageUI.Button("Object: "..GoodName(GetEntityModel(NetworkGetEntityFromNetworkId(v))).." ["..v.."]", nil, {}, true, function(h,a,s)
            if a then
                local entity = NetworkGetEntityFromNetworkId(v)
                local ObjCoords = GetEntityCoords(entity)
                DrawMarker(2, ObjCoords.x, ObjCoords.y, ObjCoords.z+1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 170, 1, 0, 2, 1, nil, nil, 0)
            end
            if s then
                RemoveObj(v, k)
            end
        end)
    end
end)


RageUI.IsVisible(RMenu:Get('sprops', 'object'), true, false, true, function()
    RageUI.Button("Chaise", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("apa_mp_h_din_chair_12")
        end
    end)

    RageUI.Button("Outils", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("prop_cs_trolley_01")
        end
    end)

    RageUI.Button("Carton", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("prop_cardbordbox_04a")
        end
    end)
    RageUI.Button("Outils mecano", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("prop_carcreeper")
        end
    end)
    RageUI.Button("Sac", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("prop_cs_heist_bag_02")
        end
    end)
    RageUI.Button("Table", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("apa_mp_h_din_table_06")
        end
    end)
    RageUI.Button("Chaise", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_clubhouse_chair_01")
        end
    end)
    RageUI.Button("Ordinateur", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_clubhouse_laptop_01a")
        end
    end)
    RageUI.Button("Chaise Bureau", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("bkr_prop_clubhouse_offchair_01a")
        end
    end)
    RageUI.Button("Lit Bunker", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("gr_prop_bunker_bed_01")
        end
    end)
    RageUI.Button("Lit Biker", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("gr_prop_gr_campbed_01")
        end
    end)
    RageUI.Button("Chaise Peche", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("hei_prop_hei_skid_chair")
        end
    end)
    RageUI.Button("Fauteil", nil, {}, true, function(h,a,s)
        if s then
            SpawnObj("prop_sol_chair")
        end
    end)
end)

RageUI.IsVisible(RMenu:Get('sprops', 'props'), true, false, true, function()
    RageUI.Button("Se transformer en ped", nil, { RightLabel = "→" },true, function(h,a,s)
    end,RMenu:Get("sprops","vipped"))
    RageUI.Button("Teintures armes", nil, { RightLabel = "→" },true, function(h,a,s)
    end,RMenu:Get("sprops","vipweapontint"))
--                    if vip == 1 or vip == 2 and not IsPedInAnyVehicle(PlayerPedId(),false) then
        RageUI.Button("Props", nil, { RightLabel = "→" },true, function(h,a,s)
        end, RMenu:Get('sprops', 'props'))
--                    else
--                        RageUI.Button("Props", nil, {RightBadge = RageUI.BadgeStyle.Lock},false, function()
--                        end)
--                    end
end)



object = {}
OtherItems = {}
local status = true

function SpawnObj(obj)
    local playerPed = PlayerPedId()
	local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
    local objectCoords = (coords + forward * 1.0)
    local Ent = nil

    SpawnObject(obj, objectCoords, function(obj)
        SetEntityCoords(obj, objectCoords, 0.0, 0.0, 0.0, 0)
        SetEntityHeading(obj, GetEntityHeading(playerPed))
        PlaceObjectOnGroundProperly(obj)
        Ent = obj
        Wait(1)
    end)
    Wait(1)
    while Ent == nil do Wait(1) end
    SetEntityHeading(Ent, GetEntityHeading(playerPed))
    PlaceObjectOnGroundProperly(Ent)
    local placed = false
    while not placed do
        Citizen.Wait(1)
        local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
        local objectCoords = (coords + forward * 2.0)
        SetEntityCoords(Ent, objectCoords, 0.0, 0.0, 0.0, 0)
        SetEntityHeading(Ent, GetEntityHeading(playerPed))
        PlaceObjectOnGroundProperly(Ent)
        SetEntityAlpha(Ent, 170, 170)

        if IsControlJustReleased(1, 38) then
            placed = true
        end
    end

    FreezeEntityPosition(Ent, true)
    SetEntityInvincible(Ent, true)
    ResetEntityAlpha(Ent)
    local NetId = NetworkGetNetworkIdFromEntity(Ent)
    table.insert(object, NetId)

end

function RemoveObj(id, k)
    Citizen.CreateThread(function()
        SetNetworkIdCanMigrate(id, true)
        local entity = NetworkGetEntityFromNetworkId(id)
        NetworkRequestControlOfEntity(entity)
        local test = 0
        while test > 100 and not NetworkHasControlOfEntity(entity) do
            NetworkRequestControlOfEntity(entity)
            Wait(1)
            test = test + 1
        end
        SetEntityAsNoLongerNeeded(entity)

        local test = 0
        while test < 100 and DoesEntityExist(entity) do 
            SetEntityAsNoLongerNeeded(entity)
            TriggerServerEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(entity))
            DeleteEntity(entity)
            DeleteObject(entity)
            if not DoesEntityExist(entity) then 
                table.remove(object, k)
            end
            SetEntityCoords(entity, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0)
            Wait(1)
            test = test + 1
        end
    end)
end

function GoodName(hash)
    if hash == GetHashKey("prop_roadcone02a") then
        return "Cone"
    elseif hash == GetHashKey("prop_barrier_work05") then
        return "Barrière"
    else
        return hash
    end

end



function SpawnObject(model, coords, cb)
	local model = GetHashKey(model)

	Citizen.CreateThread(function()
		RequestModels(model)
        Wait(1)
		local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)

		if cb then
			cb(obj)
		end
	end)
end


function RequestModels(modelHash)
	if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
		RequestModel(modelHash)

        while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)
		end
	end
end


local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end