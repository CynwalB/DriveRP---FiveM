local AeroEvent = TriggerServerEvent
ESX = nil

SneakyEvent = AeroEvent
local Vehicles = {}
local PlayerData = {}
local onService = false
local ActionsAnnonceHarmony = {
	"~g~Ouverture~s~",
	"~r~Fermeture~s~"
}
local ActionsAnnonceHarmonyIndex = 1

HarmonyMenu = {

    PositionRepair = {
        {coords = vector(1190.79520263672,2659.6819335938,37.853856658936-0.9)},
    },
    PositionVestiaire = {
        {coords = vector3(1180.9520263672,2635.9819335938,37.753856658936-0.9)},
    },
	PositionKitRepa = {
        {coords = vector3(1169.0207519531,2644.55078125,37.609593200684-0.9)},
    },
	PositionGarage = {
        {coords = vector3(1171.3159179688,2632.0949707031,37.809593200684-0.9)},
    },
	PositionDeleteGarage = {
        {coords = vector3(1167.3920898438,2639.7668457031,37.777549743652-0.9)},
    },
}

local Clothesharmony = {


    clothsvert = {
        men = {
            {
                grade = "Mécanicien (VERT)",
                cloths = {
                    ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                    ['torso_1'] = 65,   ['torso_2'] = 2,
                    ['decals_1'] = 0,   ['decals_2'] = 0,
                    ['arms'] = 4,
                    ['pants_1'] = 38,   ['pants_2'] = 2,
                    ['shoes_1'] = 51,   ['shoes_2'] = 0,
                    ['chain_1'] = 0,    ['chain_2'] = 0,
                    ['ears_1'] = -1,     ['ears_2'] = 0,
                    ['mask_1'] = 0,     ['mask_2'] = 0,
                    ['bproof_1'] = 0,     ['bproof_2'] = 0
                },
            },
        },
        women = {

            {
                grade = "Mécaniciene (VERT)",
                cloths = {
                    ['tshirt_1'] = 14,  ['tshirt_2'] = 0,
                    ['torso_1'] = 59,   ['torso_2'] = 2,
                    ['decals_1'] = 0,   ['decals_2'] = 0,
                    ['arms'] = 3,
                    ['pants_1'] = 38,   ['pants_2'] = 2,
                    ['shoes_1'] = 52,   ['shoes_2'] = 0,
                    ['chain_1'] = 0,    ['chain_2'] = 0,
                    ['ears_1'] = -1,     ['ears_2'] = 0,
                    ['mask_1'] = 0,     ['mask_2'] = 0,
                    ['bproof_1'] = 0,     ['bproof_2'] = 0
                },
            },
        },
    },
    clothsgris = {
        men = {
            {
                grade = "Mécanicien (GRIS)",
                cloths = {
                    ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                    ['torso_1'] = 65,   ['torso_2'] = 3,
                    ['decals_1'] = 0,   ['decals_2'] = 0,
                    ['arms'] = 4,
                    ['pants_1'] = 38,   ['pants_2'] = 3,
                    ['shoes_1'] = 51,   ['shoes_2'] = 0,
                    ['chain_1'] = 0,    ['chain_2'] = 0,
                    ['ears_1'] = -1,     ['ears_2'] = 0,
                    ['mask_1'] = 0,     ['mask_2'] = 0,
                    ['bproof_1'] = 0,     ['bproof_2'] = 0
                },
            },
        },
        women = {

            {
                grade = "Mécaniciene (GRIS)",
                cloths = {
                    ['tshirt_1'] = 14,  ['tshirt_2'] = 0,
                    ['torso_1'] = 59,   ['torso_2'] = 3,
                    ['decals_1'] = 0,   ['decals_2'] = 0,
                    ['arms'] = 3,
                    ['pants_1'] = 38,   ['pants_2'] = 3,
                    ['shoes_1'] = 52,   ['shoes_2'] = 0,
                    ['chain_1'] = 0,    ['chain_2'] = 0,
                    ['ears_1'] = -1,     ['ears_2'] = 0,
                    ['mask_1'] = 0,     ['mask_2'] = 0,
                    ['bproof_1'] = 0,     ['bproof_2'] = 0
                },
            },
        },
    },
}

local function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() 
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        local result = GetOnscreenKeyboardResult() 
        Citizen.Wait(500) 
        blockinput = false
        return result 
    end
end

HarmonyVestiaire = {}
RMenu.Add('harmonyvestiaire', 'main', RageUI.CreateMenu("", "",10, 200,"root_cause","harmony"))
RMenu:Get('harmonyvestiaire', 'main'):SetSubtitle("~q~Actions disponibles")
RMenu:Get('harmonyvestiaire', 'main').EnableMouse = false
RMenu:Get('harmonyvestiaire', 'main').Closed = function()
    HarmonyVestiaire.Menu = false
end

function OpenHarmonyVestiaireRageUIMenu()

    if HarmonyVestiaire.Menu then
        HarmonyVestiaire.Menu = false
    else
        HarmonyVestiaire.Menu = true
        RageUI.Visible(RMenu:Get('harmonyvestiaire', 'main'), true)

        Citizen.CreateThread(function()
            while HarmonyVestiaire.Menu do
                RageUI.IsVisible(RMenu:Get('harmonyvestiaire', 'main'), true, false, true, function()
					ESX.PlayerData = ESX.GetPlayerData()
                    pGrade = ESX.GetPlayerData().job.grade_label
                    RageUI.Button("Tenue Civil", nil, {RightLabel = "~q~Se changer →"}, true, function(h,a,s)
                        if s then
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                TriggerEvent('Sneakyskinchanger:loadSkin', skin)
								onService = false
                            end)
                        end
                    end)
                    RageUI.Separator("~q~↓~s~ Tenues de service ~q~↓~s~")
                    if GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01") then
						for k,v in pairs(Clothesharmony.clothsvert.men) do
							RageUI.Button("Tenue de ~y~"..v.grade, nil, {RightLabel = "~q~Se changer →"}, true, function(h,a,s)
								if s then
									TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
										TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
										onService = true
									end)
								end
							end)
						end
						for k,v in pairs(Clothesharmony.clothsgris.men) do
							RageUI.Button("Tenue de ~y~"..v.grade, nil, {RightLabel = "~q~Se changer →"}, true, function(h,a,s)
								if s then
									TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
										TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
										onService = true
									end)
								end
							end)
						end
                    else
						for k,v in pairs(Clothesharmony.clothsvert.women) do
							RageUI.Button("Tenue de ~y~"..v.grade, nil, {RightLabel = "~q~Se changer →"}, true, function(h,a,s)
								if s then
									TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
										TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
										onService = true
									end)
								end
							end)
						end
						for k,v in pairs(Clothesharmony.clothsgris.women) do
							RageUI.Button("Tenue de ~y~"..v.grade, nil, {RightLabel = "~q~Se changer →"}, true, function(h,a,s)
								if s then
									TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
										TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
										onService = true
									end)
								end
							end)
						end
                    end
                end)
				Wait(0)
			end
		end)
	end

end
local MecanoKitRepa = {}
RMenu.Add('harmonyshop', 'main', RageUI.CreateMenu("", "",10, 200,"root_cause","harmony"))
RMenu:Get('harmonyshop', 'main'):SetSubtitle("~q~Produits disponibles")
RMenu:Get('harmonyshop', 'main').EnableMouse = false
RMenu:Get('harmonyshop', 'main').Closed = function()
    MecanoKitRepa.Menu = false
    FreezeEntityPosition(PlayerPedId(), false)
end

function OpenHarmonyKitRepa()
	if MecanoKitRepa.Menu then
        MecanoKitRepa.Menu = false
    else
	MecanoKitRepa.Menu = true
	RageUI.Visible(RMenu:Get('harmonyshop', 'main'), true)
	FreezeEntityPosition(PlayerPedId(), true)

        Citizen.CreateThread(function()
			while MecanoKitRepa.Menu do
                RageUI.IsVisible(RMenu:Get('harmonyshop', 'main'), true, false, true, function()
                    RageUI.Button("Kit de réparation", false, {RightLabel = "→ Acheter 2300~q~$"}, true, function(h,a,s)
                        if s then
                            SneakyEvent('Sneakyharmony:giveItem', "fixkit",2300)
                        end
                    end)
                    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'harmony' then
                        RageUI.Button("Kit moteur", false, {RightLabel = "→ Acheter 2300~q~$"}, true, function(h,a,s)
                            if s then
                                SneakyEvent('Sneakyharmony:giveItem', "kit_moteur", 400)
                            end
                        end)
                        RageUI.Button("Kit de carosserie", false, {RightLabel = "→ Acheter 2300~q~$"}, true, function(h,a,s)
                            if s then
                                SneakyEvent('Sneakyharmony:giveItem', "kit_caross", 400)
                            end
                        end)
                        RageUI.Button("Kit de lavage", false, {RightLabel = "→ Acheter 2300~q~$"}, true, function(h,a,s)
                            if s then
                                SneakyEvent('Sneakyharmony:giveItem', "kit_de_lavage", 200)
                            end
                        end)
                    end
                end)
				Wait(0)
			end
		end)
	end
end


local Garageharmony = {

	garageharmony = {
        vehicule = {
            {label = "Grande Dépanneuse", veh = "towtruck3", stock = 5},
            {label = "Plateau", veh = "flatbed", stock = 3},
        },
        pos  = {
            {pos = vector3(1166.6071777344,2637.9809570312,37.787792205811), heading = 359.62},
        },
    },
}


HarmonyGarage = {}
RMenu.Add('harmonygarage', 'main', RageUI.CreateMenu("", "",10, 200,"root_cause","harmony"))
RMenu:Get('harmonygarage', 'main'):SetSubtitle("~q~Actions disponibles")
RMenu:Get('harmonygarage', 'main').EnableMouse = false
RMenu:Get('harmonygarage', 'main').Closed = function()
    HarmonyGarage.Menu = false
end

function OpenHarmonyGarageRageUIMenu()

    if HarmonyGarage.Menu then
        HarmonyGarage.Menu = false
    else
        HarmonyGarage.Menu = true
        RageUI.Visible(RMenu:Get('harmonygarage', 'main'), true)

        Citizen.CreateThread(function()
            while HarmonyGarage.Menu do
                RageUI.IsVisible(RMenu:Get('harmonygarage', 'main'), true, false, true, function()
                    RageUI.Separator("~q~↓~s~ Véhicule de service ~q~↓~s~")
                    for k,v in pairs(Garageharmony.garageharmony.vehicule) do
                        RageUI.Button(v.label, nil, {RightLabel = "Stock: [~q~"..v.stock.."~s~]"}, v.stock > 0, function(h,a,s)
                            if s then
                                local pos = FoundClearSpawnPoint(Garageharmony.garageharmony.pos)
                                if pos ~= false then
                                    LoadModel(v.veh)
                                    local veh = CreateVehicle(GetHashKey(v.veh), pos.pos, pos.heading, true, false)
                                    SetEntityAsMissionEntity(veh, 1, 1)
                                    SetVehicleDirtLevel(veh, 0.0)
                                    ShowLoadingMessage("Véhicule de service sortie.", 2, 2000)
                                    SneakyEvent('esx_vehiclelock:givekey', 'no', GetVehicleNumberPlateText(veh))
									TriggerEvent('persistent-vehicles/register-vehicle', veh)
                                    Garageharmony.garageharmony.vehicule[k].stock = Garageharmony.garageharmony.vehicule[k].stock - 1
                                    Wait(350)
                                else
                                    ESX.ShowNotification("Aucun point de sortie disponible")
                                end
                            end
                        end)
                    end
                end)
				Wait(0)
			end
		end)
	end

end

function ShowLoadingMessage(text, spinnerType, timeMs)
	Citizen.CreateThread(function()
		BeginTextCommandBusyspinnerOn("STRING")
		AddTextComponentSubstringPlayerName(text)
		EndTextCommandBusyspinnerOn(spinnerType)
		Wait(timeMs)
		RemoveLoadingPrompt()
	end)
end

function DelVehMecano()
	local pPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(pPed, false) then
		local pVeh = GetVehiclePedIsIn(pPed, false)
		local model = GetEntityModel(pVeh)
		Citizen.CreateThread(function()
			ShowLoadingMessage("Rangement du véhicule ...", 1, 2500)
		end)
		local vehicle = GetVehiclePedIsIn(PlayerPedId(),  false)
        local plate = GetVehicleNumberPlateText(vehicle)
        SneakyEvent('esx_vehiclelock:deletekeyjobs', 'no', plate)
		TaskLeaveAnyVehicle(pPed, 1, 1)
		Wait(2500)
		while IsPedInAnyVehicle(pPed, false) do
			TaskLeaveAnyVehicle(pPed, 1, 1)
			ShowLoadingMessage("Rangement du véhicule ...", 1, 300)
			Wait(200)
		end
		TriggerEvent('persistent-vehicles/forget-vehicle', pVeh)
	    DeleteEntity(pVeh)
		for k,v in pairs(Garageharmony.garageharmony.vehicule) do
			if GetHashKey(v.veh) == model then
				Garageharmony.garageharmony.vehicule[k].stock = Garageharmony.garageharmony.vehicule[k].stock + 1
			end
		end
	else
		ESX.ShowNotification("Vous devez être dans un véhicule.")
	end
end

function LoadModel(model)
	local oldName = model
	local model = GetHashKey(model)
	if IsModelInCdimage(model) then
		RequestModel(model)
		while not HasModelLoaded(model) do Wait(1) end
	else
		ShowNotification("~r~ERREUR: ~s~Modèle inconnu.\nMerci de report le problème au dev. (Modèle: "..oldName.." #"..model..")")
	end
end

function FoundClearSpawnPoint(zones)
	local found = false
	local count = 0
	for k,v in pairs(zones) do
		local clear = IsSpawnPointClear(v.pos, 2.0)
		if clear then
			found = v
			break
		end
	end
	return found
end

function IsSpawnPointClear(coords, radius)
	local vehicles = GetVehiclesInArea(coords, radius)

	return #vehicles == 0
end

function GetVehiclesInArea (coords, area)
	local vehicles       = GetVehicles()
	local vehiclesInArea = {}

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if distance <= area then
			table.insert(vehiclesInArea, vehicles[i])
		end
	end

	return vehiclesInArea
end

function GetVehicles()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

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

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

local HarmonyClean = {}
RMenu.Add('harmonyclean', 'main', RageUI.CreateMenu("", "",10, 200,"root_cause","harmony"))
RMenu:Get('harmonyclean', 'main'):SetSubtitle("~r~Produits disponibles")
RMenu:Get('harmonyclean', 'main').EnableMouse = false
RMenu:Get('harmonyclean', 'main').Closed = function()
    HarmonyClean.Menu = false
end

function doorAction(door)
    if not IsPedInAnyVehicle(PlayerPedId(),false) then return end
    local veh = GetVehiclePedIsIn(PlayerPedId(),false)
    if door == -1 then
        if doorActionIndex == 1 then
            for i = 0, 7 do
                SetVehicleDoorOpen(veh,i,false,false)
            end
        else
            for i = 0, 7 do
                SetVehicleDoorShut(veh,i,false)
            end
        end
        doorCoolDown = true
        Citizen.SetTimeout(500, function()
            doorCoolDown = false
        end)
        return
    end
    if doorActionIndex == 1 then
        SetVehicleDoorOpen(veh,door,false,false)
        doorCoolDown = true
        Citizen.SetTimeout(500, function()
            doorCoolDown = false
        end)
    else
        SetVehicleDoorShut(veh,door,false)
        doorCoolDown = true
        Citizen.SetTimeout(500, function()
            doorCoolDown = false
        end)
    end
end

function isAllowedToManageVehicle()
    if IsPedInAnyVehicle(PlayerPedId(),false) then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
        if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
            return true
        end
        return false
    end
    return false
end

Citizen.CreateThread(function()
	while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(niceESX) ESX = niceESX end)
        Wait(500)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then
        ESX.PlayerData = ESX.GetPlayerData()
    end
    ESX.PlayerData = ESX.GetPlayerData()
    while true do
        att = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
		for k,v in pairs(HarmonyMenu.PositionVestiaire) do
            local mPos = #(pCoords-v.coords)
		  if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'harmony' then
			if not HarmonyVestiaire.Menu then
				if mPos <= 10.0 then
					att = 1
					
					if mPos <= 2.0 then
					DrawMarker(20, v.coords.x, v.coords.y, v.coords.z+0.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 0, 155, 255, 255, 0, false, false, 2, false, false, false, false)
					ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au ~q~vestiaire")
					if IsControlJustPressed(0, 51) then
						ESX.PlayerData = ESX.GetPlayerData()
							pGrade = ESX.GetPlayerData().job.grade_label
						OpenHarmonyVestiaireRageUIMenu()
					end
					end
				end
			end
		end
        end
		for k,v in pairs(HarmonyMenu.PositionKitRepa) do
            local mPos = #(pCoords-v.coords)

            if not MecanoKitRepa.Menu then
                if mPos <= 10.0 then
                    att = 1
                    DrawMarker(1, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 150, 200, 170, 0, 0, 0, 1, nil, nil, 0)
                   
                    if mPos <= 1.5 then
				    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder à ~q~l'armoire")
                        if IsControlJustPressed(0, 51) then
                            OpenHarmonyKitRepa()
                        end
                    end
                end
            end
        end
		for k,v in pairs(HarmonyMenu.PositionGarage) do
            local mPos = #(pCoords-v.coords)
            if not HarmonyGarage.Menu then
                if mPos <= 10.0 then
                    att = 1
                    
                    if mPos <= 1.5 then
						if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'harmony' then
							ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au ~q~garage")
							if IsControlJustPressed(0, 51) then
								if onService then
									OpenHarmonyGarageRageUIMenu()
								else
									ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
								end
							end
						end
                    end
                end
            end
        end
        for k,v in pairs(HarmonyMenu.PositionDeleteGarage) do
            local mPos = #(pCoords-v.coords)
            if not HarmonyGarage.Menu then
                if IsPedInAnyVehicle(PlayerPedId(), true) then
                    if mPos <= 10.0 then
                        att = 1
                        if mPos <= 3.5 then
						if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'harmony' then
							DrawMarker(20, v.coords.x, v.coords.y, v.coords.z+0.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
							ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule de service")
							if IsControlJustPressed(0, 51) then
								if onService then
									DelVehMecano()
								else
									ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
								end
							end
						end
                        end
                    end
                end
            end
        end
        for k,v in pairs(HarmonyMenu.PositionRepair) do
            local mPos = #(pCoords-v.coords)
            if not HarmonyGarage.Menu then
                if mPos <= 10.0 then
                    att = 1
                    if mPos <= 3.0 then
                        if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'harmony' then
                            DrawMarker(20, v.coords.x, v.coords.y, v.coords.z+0.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 0, 155, 255, 255, 0, false, false, 2, false, false, false, false)
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~q~réparer~s~ entièrement le véhicule")
                            if IsControlJustPressed(0, 51) then
                                if onService then
                                    local coords = GetEntityCoords(playerPed, false)
                                    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 2.0) then
                                        local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 2.0, 0, 2)
                                        if IsPedInAnyVehicle(PlayerPedId(), true) then
                                            ESX.ShowNotification("~r~Vous devez être en dehors du véhicule.")
                                        else
                                            if DoesEntityExist(vehicle) then
                                                TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
                                                Citizen.Wait(25 * 1000)
                                                local veh = ESX.Game.GetClosestVehicle(GetEntityCoords(GetPlayerPed(-1)), nil)
                                                local ServerID = GetPlayerServerId(NetworkGetEntityOwner(veh))
                                                SneakyEvent("SneakyLife:Repair", VehToNet(veh), ServerID)
                                                ESX.ShowNotification("Le véhicule a été ~q~réparé~s~.")
                                                ClearPedTasksImmediately(PlayerPedId())
                                            end
                                        end
                                    else
                                        ESX.ShowNotification("~r~Il n'y a pas de véhicule proche.~s~")
                                    end
                                else
                                    ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
                                end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(att)
    end
end)

local HarmonyActionMenu = {}
function OpenHarmonyActionMenuRageUIMenu()

    if HarmonyActionMenu.Menu then 
        HarmonyActionMenu.Menu = false 
        RageUI.Visible(RMenu:Get('harmonyactionmenu', 'main'), false)
        return
    else
        RMenu.Add('harmonyactionmenu', 'main', RageUI.CreateMenu("", "Harmony and Repair's", 0, 0,"root_cause","harmony"))
		RMenu.Add('harmonyactionmenu', 'action', RageUI.CreateSubMenu(RMenu:Get("harmonyactionmenu", "main"),"", "Harmony and Repair's"))
        RMenu.Add('harmonyactionmenu', 'facture', RageUI.CreateSubMenu(RMenu:Get("harmonyactionmenu", "action"),"", "Harmony and Repair's"))
        RMenu:Get('harmonyactionmenu', 'main'):SetSubtitle("Harmony and Repair's")
        RMenu:Get('harmonyactionmenu', 'main').EnableMouse = false
        RMenu:Get('harmonyactionmenu', 'main').Closed = function()
            HarmonyActionMenu.Menu = false
        end
        HarmonyActionMenu.Menu = true 
        RageUI.Visible(RMenu:Get('harmonyactionmenu', 'main'), true)
        Citizen.CreateThread(function()
			while HarmonyActionMenu.Menu do
                RageUI.IsVisible(RMenu:Get('harmonyactionmenu', 'main'), true, false, true, function()
				RageUI.List("Annonce", ActionsAnnonceHarmony, ActionsAnnonceHarmonyIndex, nil, {}, true, function(Hovered, Active, Selected, Index) 
					if (Selected) then 
						if Index == 1 then
							local announce = 'ouvert'
							SneakyEvent('harmony:addAnnounce', announce)
						elseif Index == 2 then
							local announce = 'fermeture'
							SneakyEvent('harmony:addAnnounce', announce)
						end 
					end 
					ActionsAnnonceHarmonyIndex = Index 
				end)
                    -- RageUI.Button("Crocheter", nil, { RightLabel = "→" },true, function(h,a,s)
					-- 	if s then
					-- 		local playerPed = PlayerPedId()
					-- 		local vehicle = ESX.Game.GetVehicleInDirection()
					-- 		local coords = GetEntityCoords(playerPed, false)

					-- 		if IsPedSittingInAnyVehicle(playerPed) then
					-- 			ESX.ShowNotification("Vous ne pouvez pas crocheter de véhicule en étant dans un véhicule")
					-- 			return
					-- 		end

					-- 		if DoesEntityExist(vehicle) then
					-- 			TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
					-- 			Citizen.CreateThread(function()
					-- 				Citizen.Wait(10000)

					-- 				SetVehicleDoorsLocked(vehicle, 1)
					-- 				SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					-- 				ClearPedTasksImmediately(playerPed)

					-- 				ESX.ShowNotification("Harmony véhicule dévérouillé")
					-- 			end)
					-- 		else
					-- 			ESX.ShowNotification("Aucun véhicule à proximité")
					-- 		end
					-- 	end
                    -- end)
					RageUI.Button("Déployer la rampe", nil, { RightLabel = "→" },true, function(h,a,s)
						if s then
							ExecuteCommand("deployramp")
						end
					end)
					RageUI.Button("Ranger la rampe", nil, { RightLabel = "→" },true, function(h,a,s)
						if s then
							ExecuteCommand("ramprm")
						end
					end)
					RageUI.Button("Attacher le véhicule", nil, { RightLabel = "→" },true, function(h,a,s)
						if s then
							ExecuteCommand("attach")
						end
					end)
					RageUI.Button("Détacher le véhicule", nil, { RightLabel = "→" },true, function(h,a,s)
						if s then
							ExecuteCommand("detach")
						end
					end)
					-- 	if s then
					-- 		local playerPed = PlayerPedId()
					-- 		local vehicle = GetVehiclePedIsIn(playerPed, true)
				
					-- 		local towmodel = GetHashKey('flatbed')
					-- 		local isVehicleTow = IsVehicleModel(vehicle, towmodel)
				
					-- 		if isVehicleTow then
					-- 			local targetVehicle = ESX.Game.GetVehicleInDirection()
				
					-- 			if CurrentlyTowedVehicle == nil then
					-- 				if targetVehicle ~= 0 then
					-- 					if not IsPedInAnyVehicle(playerPed, true) then
					-- 						if vehicle ~= targetVehicle then
					-- 							AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
					-- 							CurrentlyTowedVehicle = targetVehicle
					-- 							ESX.ShowNotification("Véhicule ~b~attaché~s~ avec succès !")
					-- 						else
					-- 							ESX.ShowNotification("~r~Impossible~s~ d'attacher votre propre dépanneuse")
					-- 						end
					-- 					end
					-- 				else
					-- 					ESX.ShowNotification("Il n\'y a ~r~pas de véhicule~s~ à attacher")
					-- 				end
					-- 			else
					-- 				AttachEntityToEntity(CurrentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
					-- 				DetachEntity(CurrentlyTowedVehicle, true, true)
					-- 				CurrentlyTowedVehicle = nil
					-- 				ESX.ShowNotification("Véhicule ~b~détaché~s~ avec succès !")
					-- 			end
					-- 		else
					-- 			ESX.ShowNotification("~r~Action Impossible !\n ~s~Vous devez avoir un ~b~camion remorqueur ~s~pour ça")
					-- 		end
					-- 	end
					-- end)
					RageUI.Button("Attribuer une facture", nil, {RightLabel = "→"}, true,function(h,a,s)
						if s then
							RageUI.CloseAll()
							TriggerEvent("sBill:CreateBill","society_harmony")
						end
				    end)
					RageUI.Button("Rapports fourrière", nil, { RightLabel = "→" },true, function(h,a,s)
						if s then 
							ESX.TriggerServerCallback('hFourriere:affichereport', function(keys)
								reportlistesql = keys
							end)
							job = ESX.PlayerData.job.name
							Repportmenu2(job)
						end
					end)
                end)
				Wait(0)
			end
		end)
	end
end

function CheckServiceHarmony()
	return onService
end

function Repportmenu2()

    local reportmenu = RageUI.CreateMenu("", "Harmony and Repair's", nil, nil, "root_cause", 'harmony')
    local reportmenu2 = RageUI.CreateSubMenu(reportmenu, "", "Harmony and Repair's")
    
        RageUI.Visible(reportmenu, not RageUI.Visible(reportmenu))
            while reportmenu do
                Citizen.Wait(0)
                RageUI.IsVisible(reportmenu, true, true, true, function()
                    for numreport = 1, #reportlistesql, 1 do
                        RageUI.Button(reportlistesql[numreport].plaque.. " - "..reportlistesql[numreport].date,nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                agent = reportlistesql[numreport].agent
                                plaque = reportlistesql[numreport].plaque
                                date = reportlistesql[numreport].date
                                numeroreport = reportlistesql[numreport].numeroreport
                                motif = reportlistesql[numreport].motif
                                vehicle = reportlistesql[numreport].vehicle
                                supprimer = reportlistesql[numreport].id
                            end
                        end, reportmenu2)
                    end
                end, function()
                end)
            RageUI.IsVisible(reportmenu2, true, true, true, function()
                RageUI.Button("Numéro rapport : ",nil, {RightLabel = numeroreport}, true, function(Hovered, Active, Selected)
                    if Selected then
                    end
                end)
                RageUI.Button("Motif : ",nil, {RightLabel = motif}, true, function(Hovered, Active, Selected)
                    if Selected then
                    end
                end)
                RageUI.Button("Date : ",nil, {RightLabel = date}, true, function(Hovered, Active, Selected)
                    if Selected then
                    end
                end)
                RageUI.Button("Plaque : ",nil, {RightLabel = plaque}, true, function(Hovered, Active, Selected)
                    if Selected then
                    end
                end)
                RageUI.Button("Véhicule : ",nil, {RightLabel = vehicle}, true, function(Hovered, Active, Selected)
                    if Selected then
                    end
                end)
                RageUI.Button("Agent : ",nil, {RightLabel = agent}, true, function(Hovered, Active, Selected)
                    if Selected then
                    end
                end)
                RageUI.Button("~r~Supprimer le report~s~", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        TriggerServerEvent('hFourriere:supprimereport', supprimer)
                        ESX.ShowNotification("~r~Le rapport de fourrière a été supprimé !")
                        RageUI.CloseAll()
                    end
                end)
            end, function()
            end)
            if not RageUI.Visible(reportmenu) and not RageUI.Visible(reportmenu2) then
                reportmenu = RMenu:DeleteType("Rapports fourrière", true)
        end
    end
end

gFourriere = {
    listefourriere = {}
}

reportlistesql = {}

function reportfourriere1(veh, motif)
    local plaqueveh = GetVehicleNumberPlateText(veh)
    local numeroreport = "RAPPORT - "..math.random(1,9999)
    local vehicleModel = GetEntityModel(veh)
    local nomvoituremodelee = GetDisplayNameFromVehicleModel(vehicleModel)
    local nomvoituretexte  = GetLabelText(nomvoituremodelee)
    TriggerServerEvent('hFourriere:ajoutreport',motif,GetPlayerName(PlayerId()),plaqueveh,numeroreport,nomvoituretexte)
end

gFourriere = {
    listefourriere = {}
}

function OpenfourriereMenu2()

    if fourriere then 
        fourriere = false 
        RageUI.Visible(RMenu:Get('fourriere', 'main'), false)
        return
    else
        RMenu.Add('fourriere', 'main', RageUI.CreateMenu("", "Voici les véhicules en fourrière", nil, nil,"root_cause", "harmony"))
--        RMenu:Get('fourriere', 'main'):SetSubtitle("~q~Menu personnel")
        RMenu:Get('fourriere', 'main').EnableMouse = false
        RMenu:Get('fourriere', 'main').Closed = function()
            fourriere = false
        end
        fourriere = true 
        RageUI.Visible(RMenu:Get('fourriere', 'main'), true)
        Citizen.CreateThread(function()
            while ESX == nil do
                TriggerEvent('esx:getSharedObject', function(obj)
                    ESX = obj
                end)
                ESX.PlayerData = ESX.GetPlayerData()
                Citizen.Wait(10)
            end       
--    local fourriere = RageUI.CreateMenu("", "Voici les véhicules saisies")
--    RageUI.Visible(fourriere, not RageUI.Visible(fourriere))
            while fourriere do
                Citizen.Wait(0)
--                RageUI.IsVisible(fourriere, true, true, true, function()
                RageUI.IsVisible(RMenu:Get('fourriere', 'main'), true, true, true, function()
                for i = 1, #gFourriere.listefourriere, 1 do
                    local hashvoiture = gFourriere.listefourriere[i].props.model
        	        local modelevoiturespawn = gFourriere.listefourriere[i].props
                    local nomvoituremodele = GetDisplayNameFromVehicleModel(hashvoiture)
                    local nomvoituretexte  = GetLabelText(nomvoituremodele)
                    local plaque = gFourriere.listefourriere[i].plate
                    local Nomdumec = gFourriere.listefourriere[i].Nomdumec
                    RageUI.Button(Nomdumec.." - "..nomvoituretexte.." | "..plaque, nil, {RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            sortirvoiture(modelevoiturespawn, plaque)
                            RageUI.CloseAll()
                        end
                    end)
                end
                end)
        
--                if not RageUI.Visible(fourriere) then
--                    fourriere = RMenu:DeleteType("Saisies", true)
--                end
            end
        end)
    end
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'harmony' then
        local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
        local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, 1179.054, 2626.672, 37.849)
        if jobdist <= 10.0 and Config.jeveuxmarker then
            Timer = 0
            DrawMarker(20, 1179.054, 2626.672, 37.849, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if jobdist <= 1.0 then
                Timer = 0
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour voir les ~q~véhicules en fourrière")
                    if IsControlJustPressed(1,51) then
						if onService then
							ESX.TriggerServerCallback('hFourriere:listevehiculefourriere', function(result)
								gFourriere.listefourriere = result
							end)
							OpenfourriereMenu2()
						else
							ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
						end
            		end
			end 
		end
		Citizen.Wait(Timer)   
	end
end)

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'harmony' then
        local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
        local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, 1193.1469, 2637.789, 37.84)
            if jobdist <= 2.0 then
                Timer = 0
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour mettre un ~q~véhicule en fourrière")
                if IsControlJustPressed(1,51) then
					if onService then
						local playerPed = PlayerPedId()

						if IsPedSittingInAnyVehicle(playerPed) then
							local vehicle = GetVehiclePedIsIn(playerPed, false)
			
							if GetPedInVehicleSeat(vehicle, -1) == playerPed then
								local motif = KeyboardInput("Motif", "", 25)
	--                            reportfourriere(vehicle, motif)
								motif = tostring(motif)
								if motif ~= nil and motif ~= '' and motif ~= 'nil' then
									reportfourriere1(vehicle, motif)
									TriggerEvent('persistent-vehicles/forget-vehicle', vehicle)
									ESX.Game.DeleteVehicle(vehicle)
									ESX.ShowNotification('Le véhicule est en fourrière.')
								else
									ESX.ShowNotification("~r~Merci d'écrire un motif correct.")
								end                           
							else
								ESX.ShowNotification('~r~Vous devez être conducteur !')
							end
	--[[                     else
						local vehicle = ESX.Game.GetVehicleInDirection()
	--                        local vehicle = GetVehiclePedIsIn(playerPed, false)
			
							if DoesEntityExist(vehicle) then
								TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_CLIPBOARD', 0, true)
								local motif = KeyboardInputAnnounce("Motif", "", 55)
								motif = tostring(motif)
								if motif ~= nil and motif ~= '' and motif ~= 'nil' then
									reportfourriere(vehicle, motif)
									Citizen.Wait(5000)
									ClearPedTasks(playerPed)
									ESX.Game.deleteVehicle(vehicle)
	--                                DeleteEntity(vehicle)
									ESX.ShowNotification('Le véhicule a été saisi.')
								else
									ESX.ShowNotification("~r~Merci d'écrire un motif correct.")
								end
	--]]         
						else
							ESX.ShowNotification('Vous devez être dans le véhicule')
						end
	--                    end
					else
						ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
					end
            end
        end 
    end
    Citizen.Wait(Timer)   
end
end)

Citizen.CreateThread(function()
    local hash = GetHashKey("s_m_m_security_01")
    while not HasModelLoaded(hash) do
    RequestModel(hash)
    Wait(20)
    end
    ped = CreatePed("PED_TYPE_CIVMALE", "s_m_m_security_01", 1191.04, 2637.9, 36.8530, 286.21, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
end)

function sortirvoiture(props, plate)
	x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))

	ESX.Game.SpawnVehicle(props.model, {
		x = x,
		y = y,
		z = z 
	}, GetEntityHeading(PlayerPedId()), function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, props)
        SetVehicleNumberPlateText(vehicle, plate)
		SetVehRadioStation(callback_vehicle, "OFF")
		SetVehicleFixed(callback_vehicle)
		SetVehicleDeformationFixed(callback_vehicle)
		SetVehicleUndriveable(callback_vehicle, false)
		SetVehicleEngineOn(callback_vehicle, true, true)
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
        TriggerEvent('persistent-vehicles/register-vehicle', callback_vehicle)
	end)
end

RegisterNetEvent('harmony:targetAnnounce')
AddEventHandler('harmony:targetAnnounce', function(announce)
    if announce == 'ouvert' then
        ESX.ShowAdvancedNotification("Harmony Repair's and Custom's", '~q~Informations', "- Mécano Nord ~g~ouvert~s~\n- Horaire : ~q~Maintenant", "CHAR_HARMONY", 1)
    elseif announce == 'fermeture' then
        ESX.ShowAdvancedNotification("Harmony Repair's and Custom's", '~q~Informations', "- Mécano Nord ~r~fermé~s~\n- Horaire : ~q~Maintenant", "CHAR_HARMONY", 1)
    end
end)