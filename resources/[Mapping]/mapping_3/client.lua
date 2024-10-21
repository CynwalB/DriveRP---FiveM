Citizen.CreateThread(function()
	-- ====================================================================
	-- =--------------------- [GTA V: Single player] ---------------------=
	-- ====================================================================

	-- Michael: -802.311, 175.056, 72.8446
	Michael.LoadDefault()

	-- Simeon: -47.16170 -1115.3327 26.5
	Simeon.LoadDefault()

	-- Franklin's aunt: -9.96562, -1438.54, 31.1015
	FranklinAunt.LoadDefault()
	
	-- Franklin
	Franklin.LoadDefault()
		
	--Floyd: -1150.703, -1520.713, 10.633
	Floyd.LoadDefault()
	
	-- Trevor: 1985.48132, 3828.76757, 32.5
	TrevorsTrailer.LoadDefault()

	-- Other
	Ammunations.LoadDefault()
	LesterFactory.LoadDefault()
	StripClub.LoadDefault()

	Graffitis.Enable(true)

	-- Zancudo Gates (GTAO like): -1600.30100000, 2806.73100000, 18.79683000
	ZancudoGates.LoadDefault()

	-- UFO
	UFO.Hippie.Enable(false) -- 2490.47729, 3774.84351, 2414.035
	UFO.Chiliad.Enable(false) -- 501.52880000, 5593.86500000, 796.23250000
	UFO.Zancudo.Enable(false) -- -2051.99463, 3237.05835, 1456.97021
	
	-- Red Carpet: 300.5927, 199.7589, 104.3776
	RedCarpet.Enable(false)
	
	-- North Yankton: 3217.697, -4834.826, 111.8152
	NorthYankton.Enable(false)

	-- ====================================================================
	-- =-------------------------- [GTA Online] --------------------------=
	-- ====================================================================
	GTAOApartmentHi1.LoadDefault() -- -35.31277 -580.4199 88.71221 (4 Integrity Way, Apt 30)
	GTAOApartmentHi2.LoadDefault() -- -1477.14 -538.7499 55.5264 (Dell Perro Heights, Apt 7)
	GTAOHouseHi1.LoadDefault() -- -169.286 486.4938 137.4436 (3655 Wild Oats Drive)
	GTAOHouseHi2.LoadDefault() -- 340.9412 437.1798 149.3925 (2044 North Conker Avenue)
	GTAOHouseHi3.LoadDefault() -- 373.023 416.105 145.7006 (2045 North Conker Avenue)
	GTAOHouseHi4.LoadDefault() -- -676.127 588.612 145.1698 (2862 Hillcrest Avenue)
	GTAOHouseHi5.LoadDefault() -- -763.107 615.906 144.1401 (2868 Hillcrest Avenue)
	GTAOHouseHi6.LoadDefault() -- -857.798 682.563 152.6529 (2874 Hillcrest Avenue)
	GTAOHouseHi7.LoadDefault() -- 120.5 549.952 184.097 (2677 Whispymound Drive)
	GTAOHouseHi8.LoadDefault() -- -1288 440.748 97.69459 (2133 Mad Wayne Thunder)
	GTAOHouseMid1.LoadDefault() -- 347.2686 -999.2955 -99.19622
	GTAOHouseLow1.LoadDefault() -- 261.4586 -998.8196 -99.00863

	-- ====================================================================
	-- =------------------------ [DLC: High life] ------------------------=
	-- ====================================================================
	HLApartment1.LoadDefault() -- -1468.14 -541.815 73.4442 (Dell Perro Heights, Apt 4)
	HLApartment2.LoadDefault() -- -915.811 -379.432 113.6748 (Richard Majestic, Apt 2)
	HLApartment3.LoadDefault() -- -614.86 40.6783 97.60007 (Tinsel Towers, Apt 42)
	HLApartment4.LoadDefault() -- -773.407 341.766 211.397 (EclipseTowers, Apt 3)
	HLApartment5.LoadDefault() -- -18.07856 -583.6725 79.46569 (4 Integrity Way, Apt 28)
	HLApartment6.LoadDefault() -- -609.56690000 51.28212000 -183.98080

	-- ====================================================================
	-- =-------------------------- [DLC: Heists] -------------------------=
	-- ====================================================================
	HeistCarrier.Enable(false) -- 3082.3117, -4717.1191, 15.2622
	HeistYacht.Enable(true) -- -2043.974,-1031.582, 11.981

	-- ====================================================================
	-- =--------------- [DLC: Executives & Other Criminals] --------------=
	-- ====================================================================
	ExecApartment1.LoadDefault() -- -787.7805 334.9232 215.8384 (EclipseTowers, Penthouse Suite 1)
	ExecApartment2.LoadDefault() -- -773.2258 322.8252 194.8862 (EclipseTowers, Penthouse Suite 2)
	ExecApartment3.LoadDefault() -- -787.7805 334.9232 186.1134 (EclipseTowers, Penthouse Suite 3)
	
	-- ====================================================================
	-- =-------------------- [DLC: Finance  & Felony] --------------------=
	-- ====================================================================
	FinanceOffice1.LoadDefault() -- -141.1987, -620.913, 168.8205 (Arcadius Business Centre)
	FinanceOffice2.LoadDefault() -- -75.8466, -826.9893, 243.3859 (Maze Bank Building)
	FinanceOffice3.LoadDefault() -- -1579.756, -565.0661, 108.523 (Lom Bank)
	FinanceOffice4.LoadDefault() -- -1392.667, -480.4736, 72.04217 (Maze Bank West)

	-- ====================================================================
	-- =-------------------------- [DLC: Bikers] -------------------------=
	-- ====================================================================
	BikerCocaine.LoadDefault() -- Cocaine lockup: 1093.6, -3196.6, -38.99841
	BikerCounterfeit.LoadDefault() -- Counterfeit cash factory: 1121.897, -3195.338, -40.4025
	BikerDocumentForgery.LoadDefault() -- Document forgery: 1165, -3196.6, -39.01306
	BikerMethLab.LoadDefault() -- Meth lab: 1009.5, -3196.6, -38.99682
	BikerWeedFarm.LoadDefault() -- Weed farm: 1051.491, -3196.536, -39.14842
	BikerClubhouse1.LoadDefault() -- 1107.04, -3157.399, -37.51859
	BikerClubhouse2.LoadDefault() -- 998.4809, -3164.711, -38.90733

	-- ====================================================================
	-- =---------------------- [DLC: Import/Export] ----------------------=
	-- ====================================================================
	ImportCEOGarage1.LoadDefault() -- Arcadius Business Centre
	ImportCEOGarage2.LoadDefault() -- Maze Bank Building /!\ Do not load parts Garage1, Garage2 and Garage3 at the same time (overlaping issues)
	ImportCEOGarage3.LoadDefault() -- Lom Bank /!\ Do not load parts Garage1, Garage2 and Garage3 at the same time (overlaping issues)
	ImportCEOGarage4.LoadDefault() -- Maze Bank West /!\ Do not load parts Garage1, Garage2 and Garage3 at the same time (overlaping issues)
	ImportVehicleWarehouse.LoadDefault() -- Vehicle warehouse: 994.5925, -3002.594, -39.64699

	-- ====================================================================
	-- =------------------------ [DLC: Gunrunning] -----------------------=
	-- ====================================================================
	GunrunningBunker.LoadDefault() -- 892.6384, -3245.8664, -98.2645
	GunrunningYacht.Enable(true) -- -1363.724, 6734.108, 2.44598
	
	-- ====================================================================
	-- =---------------------- [DLC: Smuggler's Run] ---------------------=
	-- ====================================================================
	SmugglerHangar.LoadDefault() -- -1267.0 -3013.135 -49.5

	-- ====================================================================
	-- =-------------------- [DLC: The Doomsday Heist] -------------------=
	-- ====================================================================
	DoomsdayFacility.LoadDefault()

	-- ====================================================================
	-- =----------------------- [DLC: After Hours] -----------------------=
	-- ====================================================================
	AfterHoursNightclubs.LoadDefault() -- -1604.664, -3012.583, -78.000
end)

Citizen.CreateThread(function()
	SetZoneEnabled(59,false)
    SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0) -- Level 0
    SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0) -- Level 1
    SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0) -- Level 2
    SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0) -- Level 3
    SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0) -- Level 4
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(1)
		if IsPedOnFoot(GetPlayerPed(-1)) then 
			SetRadarZoom(1100)
		elseif IsPedInAnyVehicle(GetPlayerPed(-1), true) then
			SetRadarZoom(1100)
		end
    end
end)

local EntitySetsTuner = {
    ['entity_set_bedroom'] = true,
    ['entity_set_bedroom_empty'] = true,
    ['entity_set_bombs'] = true,
    ['entity_set_box_clutter'] = false,
    ['entity_set_cabinets'] = true,
    ['entity_set_car_lift_cutscene'] = true,
    ['entity_set_car_lift_default'] = true,
    ['entity_set_car_lift_purchase'] = true,
    ['entity_set_chalkboard'] = true,
    ['entity_set_container'] = true,
    ['entity_set_cut_seats'] = true,
    ['entity_set_def_table'] = true,
    ['entity_set_drive'] = true,
    ['entity_set_ecu'] = true,
    ['entity_set_IAA'] = true,
    ['entity_set_jammers'] = true,
    ['entity_set_laptop'] = true,
    ['entity_set_lightbox'] = true,
    ['entity_set_methLab'] = true,
    ['entity_set_plate'] = true,
    ['entity_set_scope'] = true,
    ['entity_set_style_1'] = false,
    ['entity_set_style_2'] = false,
    ['entity_set_style_3'] = true,
    ['entity_set_style_4'] = false,
    ['entity_set_style_5'] = false,
    ['entity_set_style_6'] = false,
    ['entity_set_style_7'] = false,
    ['entity_set_style_8'] = false,
    ['entity_set_style_9'] = false,
    ['entity_set_table'] = true,
    ['entity_set_thermal'] = true,
    ['entity_set_tints'] = true,
    ['entity_set_train'] = true,
    ['entity_set_virus'] = true,
}

local entitySetsMeet = {
['entity_set_meet_crew'] = true,
['entity_set_meet_lights'] = true,
['entity_set_meet_lights_cheap'] = true,
['entity_set_player'] = true,
['entity_set_test_crew'] = true,
['entity_set_test_lights'] = true,
['entity_set_test_lights_cheap'] = true,
['entity_set_time_trial'] = true,
}

local EntitySetMeth = {
    ['tintable_walls'] = true,
}
  
Citizen.CreateThread(function()
    local tuna_interior_id = GetInteriorAtCoords(vector3(-1350.0, 160.0, -100.0))
    local meetup_interior_id = GetInteriorAtCoords(vector3(-2000.0, 1113.211, -25.36243))
    local methlab_interior_id = GetInteriorAtCoords(vector3(981.9999, -143.0, -50.0))
    RequestIpl('tr_tuner_meetup')
    RequestIpl('tr_tuner_race_line')
    RequestIpl('tr_tuner_shop_burton')
    RequestIpl('tr_tuner_shop_mesa' )
    RequestIpl('tr_tuner_shop_mission' )
    RequestIpl('tr_tuner_shop_rancho')
    RequestIpl('tr_tuner_shop_strawberry')
    
    if IsValidInterior(tuna_interior_id) then
      RefreshInterior(tuna_interior_id)
    end

    if IsValidInterior(meetup_interior_id) then
        RefreshInterior(meetup_interior_id)
    end

    if IsValidInterior(methlab_interior_id) then
        RefreshInterior(methlab_interior_id)
    end

    for k, v in pairs(EntitySetsTuner) do
        if v then
            ActivateInteriorEntitySet(
                tuna_interior_id , 
                k 
            )
        else
            DeactivateInteriorEntitySet(
                tuna_interior_id , 
                k
            )
        end

    end

    for k, v in pairs(entitySetsMeet) do
        if v then
            ActivateInteriorEntitySet(
                meetup_interior_id , 
                k 
            )
        else
            DeactivateInteriorEntitySet(
                meetup_interior_id , 
                k 
            )
        end
    end

    for k, v in pairs(EntitySetMeth) do
        if v then
            ActivateInteriorEntitySet(
                methlab_interior_id , 
                k 
            )
        else
            DeactivateInteriorEntitySet(
                methlab_interior_id , 
                k 
            )
        end
    end

    SetInteriorEntitySetColor(284673, "tintable_walls", 2)
end)

CreateThread(function()
	LoadMpDlcMaps()
	EnableMpDlcMaps(true)
		--IPL B2D
        --RemoveIpl("po1_occl_01")
        --RemoveIpl("hei_po1_occl_01")
		RequestIpl("vw_casino_carpark");
		RequestIpl("vw_casino_garage");
end)


Citizen.CreateThread(function()
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.5) 
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_KNUCKLE"), 0.4) 
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HAMMER"), 0.6) 
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_FLASHLIGHT"), 0.6) 
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_GOLFCLUB"), 0.6) 
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BAT"), 0.6) 
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_NIGHTSTICK"), 0.6) 
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_WRENCH"), 0.6) 
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_POOLCUE"), 0.4) 
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_DAGGER"), 0.6) 
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BOTTLE"), 0.6) 
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_KATANA"), 0.6) 
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PELLE"), 0.6) 
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SLEDGEHAMMER"), 0.6) 
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HATCHET"), 0.6) 
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_KNIFE"), 0.6) 
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MACHETE"), 0.6) 
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SWITCHBLADE"), 0.6) 
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BATTLEAXE"), 0.6) 
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_STONE_HATCHET"), 0.6) 
    AddTextEntry('WT_FAKEGNADE_SMK', 'Grenade Fumigène M18')
    AddTextEntry('WT_PELLE', 'Pelle')
    AddTextEntry('WT_CANETTE', 'Canette')
    AddTextEntry('WT_BOUTEILLE', 'Bouteille Cassé Jetable')
    AddTextEntry('WT_SLEDGEHAMMER', 'Masse')
    AddTextEntry('WT_PICKAXE', 'Pioche')
    AddTextEntry('WT_KATANA', 'Katana')
    AddTextEntry('WT_PIST_FAKECBT', 'Pistolet de combat non létale')
    AddTextEntry('WT_FAKESMG', 'MP5 non létale')
    AddTextEntry('WT_BEAMBAG', 'Bean bag')
    AddTextEntry('WT_CHAINSAW', 'Tronçonneuse')
    AddTextEntry('WT_NAILGUN', 'Pistolet à clou')
    AddTextEntry('WT_FAKEAK', 'Ak47 non létale')
    AddTextEntry('WT_FAKEUZI', 'UZI non létale')
    AddTextEntry('WT_FAKEAKU', 'AKu non létale')
    AddTextEntry('WT_FAKESHOTGUN', 'Fusil à pompe non létale')
    AddTextEntry('WT_FAKESKORPION', 'Skorpion non létale')
    AddTextEntry('WT_FAKEM4', 'M4A1 non létale')
    Wait(0)
end)