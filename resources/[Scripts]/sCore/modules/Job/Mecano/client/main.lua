local AeroEvent = TriggerServerEvent
ESX = nil
SneakyEvent = AeroEvent
--local rgbArray = {}
local Vehicles = {}
local PlayerData = {}
local lsMenuIsShowed = false
local isInLSMarker = false
local myCar = {}
local vehicleClass = nil
local vehiclePrice = 50000

local shopProfitValue = 0
local shopProfit = 2
local shopCart = {}
local totalCartValue = 0
local canClose = false
local society = ""
local stop = false
local deleting = false
local onService = false
local ActionsAnnonce = {
	"~g~Ouverture~s~",
	"~r~Fermeture~s~"
}
local ActionsAnnonceIndex = 1

MecanoMenu = {

    PositionRepair = {
        {coords = vector(275.1420263672,-1806.319335938,26.93856658936-0.9)},
    },
    PositionVestiaire = {
        {coords = vector3(266.90708984375,-1795.579574584961,26.939736633301-0.9)},
    },
	PositionKitRepa = {
        {coords = vector3(270.7152685547,-1793.875344848633,27.11602081299-0.9)},
    },
	PositionGarage = {
        {coords = vector3(241.977344,-1798.608828125,27.72215881348-0.9)},
    },
	PositionDeleteGarage = {
        {coords = vector3(249.66295898438,-1794.94443969727,27.1166577148-0.9)},
    },
}

local Clothesbennys = {


    clothsbleu = {
        men = {
            {
                grade = "Mécanicien (BLEU)",
                cloths = {
                    ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                    ['torso_1'] = 65,   ['torso_2'] = 1,
                    ['decals_1'] = 0,   ['decals_2'] = 0,
                    ['arms'] = 4,
                    ['pants_1'] = 38,   ['pants_2'] = 1,
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
                grade = "Mécaniciene (BLEU)",
                cloths = {
                    ['tshirt_1'] = 14,  ['tshirt_2'] = 0,
                    ['torso_1'] = 59,   ['torso_2'] = 1,
                    ['decals_1'] = 0,   ['decals_2'] = 0,
                    ['arms'] = 3,
                    ['pants_1'] = 38,   ['pants_2'] = 1,
                    ['shoes_1'] = 52,   ['shoes_2'] = 0,
                    ['chain_1'] = 0,    ['chain_2'] = 0,
                    ['ears_1'] = -1,     ['ears_2'] = 0,
                    ['mask_1'] = 0,     ['mask_2'] = 0,
                    ['bproof_1'] = 0,     ['bproof_2'] = 0
                },
            },
        },
    },




    clothsrouge = {
        men = {
            {
                grade = "Mécanicien (ROUGE)",
                cloths = {
                    ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                    ['torso_1'] = 65,   ['torso_2'] = 0,
                    ['decals_1'] = 0,   ['decals_2'] = 0,
                    ['arms'] = 4,
                    ['pants_1'] = 38,   ['pants_2'] = 0,
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
                grade = "Mécanicien (ROUGE)",
                cloths = {
                    ['tshirt_1'] = 14,  ['tshirt_2'] = 0,
                    ['torso_1'] = 59,   ['torso_2'] = 0,
                    ['decals_1'] = 0,   ['decals_2'] = 0,
                    ['arms'] = 3,
                    ['pants_1'] = 38,   ['pants_2'] = 0,
                    ['shoes_1'] = 52,   ['shoes_2'] = 0,
                    ['chain_1'] = 0,    ['chain_2'] = 0,
                    ['ears_1'] = -1,     ['ears_2'] = 0,
                    ['mask_1'] = 0,     ['mask_2'] = 0,
                    ['bproof_1'] = 0,     ['bproof_2'] = 0
                }
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

MecanoVestiaire = {}
RMenu.Add('mecanovestiaire', 'main', RageUI.CreateMenu("", "",10, 200,"root_cause","shopui_title_supermod"))
RMenu:Get('mecanovestiaire', 'main'):SetSubtitle("~q~Actions disponibles")
RMenu:Get('mecanovestiaire', 'main').EnableMouse = false
RMenu:Get('mecanovestiaire', 'main').Closed = function()
    MecanoVestiaire.Menu = false
end

function OpenMecanoVestiaireRageUIMenu()

    if MecanoVestiaire.Menu then
        MecanoVestiaire.Menu = false
    else
        MecanoVestiaire.Menu = true
        RageUI.Visible(RMenu:Get('mecanovestiaire', 'main'), true)

        Citizen.CreateThread(function()
            while MecanoVestiaire.Menu do
                RageUI.IsVisible(RMenu:Get('mecanovestiaire', 'main'), true, false, true, function()
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
						for k,v in pairs(Clothesbennys.clothsbleu.men) do
							RageUI.Button("Tenue de ~y~"..v.grade, nil, {RightLabel = "~q~Se changer →"}, true, function(h,a,s)
								if s then
									TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
										TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
										onService = true
									end)
								end
							end)
						end
						for k,v in pairs(Clothesbennys.clothsrouge.men) do
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
						for k,v in pairs(Clothesbennys.clothsbleu.women) do
							RageUI.Button("Tenue de ~y~"..v.grade, nil, {RightLabel = "~q~Se changer →"}, true, function(h,a,s)
								if s then
									TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
										TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
										onService = true
									end)
								end
							end)
						end
						for k,v in pairs(Clothesbennys.clothsrouge.women) do
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
RMenu.Add('mecanoshop', 'main', RageUI.CreateMenu("", "",10, 200,"root_cause","shopui_title_supermod"))
RMenu:Get('mecanoshop', 'main'):SetSubtitle("~q~Produits disponibles")
RMenu:Get('mecanoshop', 'main').EnableMouse = false
RMenu:Get('mecanoshop', 'main').Closed = function()
    MecanoKitRepa.Menu = false
    FreezeEntityPosition(PlayerPedId(), false)
end

function OpenMecanoKitRepaRageUI()
	if MecanoKitRepa.Menu then
        MecanoKitRepa.Menu = false
    else
	MecanoKitRepa.Menu = true
	RageUI.Visible(RMenu:Get('mecanoshop', 'main'), true)
	FreezeEntityPosition(PlayerPedId(), true)

        Citizen.CreateThread(function()
			while MecanoKitRepa.Menu do
                RageUI.IsVisible(RMenu:Get('mecanoshop', 'main'), true, false, true, function()
                    RageUI.Button("Kit de réparation", false, {RightLabel = "→ Acheter 2300~q~$"}, true, function(h,a,s)
					if s then
						SneakyEvent('Sneakymecano:giveItem', "fixkit",2300)
					end
                    end)
                end)
				Wait(0)
			end
		end)
	end
end


local Garagemecano = {

	garagebennys = {
        vehicule = {
            {label = "Grande Dépanneuse", veh = "towtruck3", stock = 5},
            {label = "Plateau", veh = "flatbed", stock = 3},
        },
        pos  = {
            {pos = vector3(238.3527832031,-1797.328231811523,27.86730957), heading = 139.83},
        },
    },
}


MecanoGarage = {}
RMenu.Add('mecanogarage', 'main', RageUI.CreateMenu("", "",10, 200,"root_cause","shopui_title_supermod"))
RMenu:Get('mecanogarage', 'main'):SetSubtitle("~q~Actions disponibles")
RMenu:Get('mecanogarage', 'main').EnableMouse = false
RMenu:Get('mecanogarage', 'main').Closed = function()
    MecanoGarage.Menu = false
end

function OpenMecanoGarageRageUIMenu()

    if MecanoGarage.Menu then
        MecanoGarage.Menu = false
    else
        MecanoGarage.Menu = true
        RageUI.Visible(RMenu:Get('mecanogarage', 'main'), true)

        Citizen.CreateThread(function()
            while MecanoGarage.Menu do
                RageUI.IsVisible(RMenu:Get('mecanogarage', 'main'), true, false, true, function()
                    RageUI.Separator("~q~↓~s~ Véhicule de service ~q~↓~s~")
                    for k,v in pairs(Garagemecano.garagebennys.vehicule) do
                        RageUI.Button(v.label, nil, {RightLabel = "Stock: [~q~"..v.stock.."~s~]"}, v.stock > 0, function(h,a,s)
                            if s then
                                local pos = FoundClearSpawnPoint(Garagemecano.garagebennys.pos)
                                if pos ~= false then
                                    LoadModel(v.veh)
                                    local veh = CreateVehicle(GetHashKey(v.veh), pos.pos, pos.heading, true, false)
                                    SetEntityAsMissionEntity(veh, 1, 1)
                                    SetVehicleDirtLevel(veh, 0.0)
                                    ShowLoadingMessage("Véhicule de service sortie.", 2, 2000)
                                    SneakyEvent('esx_vehiclelock:givekey', 'no', GetVehicleNumberPlateText(veh))
									TriggerEvent('persistent-vehicles/register-vehicle', veh)
                                    Garagemecano.garagebennys.vehicule[k].stock = Garagemecano.garagebennys.vehicule[k].stock - 1
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
		for k,v in pairs(Garagemecano.garagebennys.vehicule) do
			if GetHashKey(v.veh) == model then
				Garagemecano.garagebennys.vehicule[k].stock = Garagemecano.garagebennys.vehicule[k].stock + 1
			end
		end
	else
		ShowNotification("Vous devez être dans un véhicule.")
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

local MecanoClean = {}
RMenu.Add('mecanoclean', 'main', RageUI.CreateMenu("", "",10, 200,"root_cause","shopui_title_supermod"))
RMenu:Get('mecanoclean', 'main'):SetSubtitle("~r~Produits disponibles")
RMenu:Get('mecanoclean', 'main').EnableMouse = false
RMenu:Get('mecanoclean', 'main').Closed = function()
    MecanoClean.Menu = false
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
		for k,v in pairs(MecanoMenu.PositionVestiaire) do
            local mPos = #(pCoords-v.coords)
		  if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'mecano' then
			if not MecanoVestiaire.Menu then
				if mPos <= 10.0 then
					att = 1
					
					if mPos <= 2.0 then
					DrawMarker(20, v.coords.x, v.coords.y, v.coords.z+0.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 0, 155, 255, 255, 0, false, false, 2, false, false, false, false)
					ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au ~q~vestiaire")
					if IsControlJustPressed(0, 51) then
						ESX.PlayerData = ESX.GetPlayerData()
							pGrade = ESX.GetPlayerData().job.grade_label
						OpenMecanoVestiaireRageUIMenu()
					end
					end
				end
			end
		end
        end
		for k,v in pairs(MecanoMenu.PositionKitRepa) do
            local mPos = #(pCoords-v.coords)

            if not MecanoKitRepa.Menu then
                if mPos <= 10.0 then
                    att = 1
                    DrawMarker(1, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 150, 200, 170, 0, 0, 0, 1, nil, nil, 0)
                   
                    if mPos <= 1.5 then
				    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder à ~q~l'armoire")
                        if IsControlJustPressed(0, 51) then
                            OpenMecanoKitRepaRageUI()
                        end
                    end
                end
            end
        end
		for k,v in pairs(MecanoMenu.PositionGarage) do
            local mPos = #(pCoords-v.coords)
            if not MecanoGarage.Menu then
                if mPos <= 10.0 then
                    att = 1
                    
                    if mPos <= 1.5 then
						if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'mecano' then
							ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au ~q~garage")
							if IsControlJustPressed(0, 51) then
								if onService then
									OpenMecanoGarageRageUIMenu()
								else
									ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
								end
							end
						end
                    end
                end
            end
        end
        for k,v in pairs(MecanoMenu.PositionDeleteGarage) do
            local mPos = #(pCoords-v.coords)
            if not MecanoGarage.Menu then
                if IsPedInAnyVehicle(PlayerPedId(), true) then
                    if mPos <= 10.0 then
                        att = 1
                        if mPos <= 3.5 then
						if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'mecano' then
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
        for k,v in pairs(MecanoMenu.PositionRepair) do
            local mPos = #(pCoords-v.coords)
            if not MecanoMenu.Menu then
                if mPos <= 10.0 then
                    att = 1
                    if mPos <= 3.0 then
                        if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'mecano' then
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

local MecanoActionMenu = {}
function OpenMecanoActionMenuRageUIMenu()

    if MecanoActionMenu.Menu then 
        MecanoActionMenu.Menu = false 
        RageUI.Visible(RMenu:Get('mecanoactionmenu', 'main'), false)
        return
    else
        RMenu.Add('mecanoactionmenu', 'main', RageUI.CreateMenu("", "~b~Hayes Auto", 0, 0,"root_cause","shopui_title_supermod"))
		RMenu.Add('mecanoactionmenu', 'action', RageUI.CreateSubMenu(RMenu:Get("mecanoactionmenu", "main"),"", "~b~Hayes Auto"))
        RMenu.Add('mecanoactionmenu', 'facture', RageUI.CreateSubMenu(RMenu:Get("mecanoactionmenu", "action"),"", "~b~Hayes Auto"))
        RMenu:Get('mecanoactionmenu', 'main'):SetSubtitle("~b~Hayes Auto")
        RMenu:Get('mecanoactionmenu', 'main').EnableMouse = false
        RMenu:Get('mecanoactionmenu', 'main').Closed = function()
            MecanoActionMenu.Menu = false
        end
        MecanoActionMenu.Menu = true 
        RageUI.Visible(RMenu:Get('mecanoactionmenu', 'main'), true)
        Citizen.CreateThread(function()
			while MecanoActionMenu.Menu do
                RageUI.IsVisible(RMenu:Get('mecanoactionmenu', 'main'), true, false, true, function()
				RageUI.List("Annonce", ActionsAnnonce, ActionsAnnonceIndex, nil, {}, true, function(Hovered, Active, Selected, Index) 
					if (Selected) then 
						if Index == 1 then
							local announce = 'ouvert'
							SneakyEvent('mecano:addAnnounce', announce)
						elseif Index == 2 then
							local announce = 'fermeture'
							SneakyEvent('mecano:addAnnounce', announce)
						end 
					end 
					ActionsAnnonceIndex = Index 
				end)
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
				RageUI.Button("Attribuer une facture", nil, {RightLabel = "→"}, true,function(h,a,s)
					if s then
						RageUI.CloseAll()
						TriggerEvent("sBill:CreateBill","society_mecano")
					end
				end)
				RageUI.Button("Rapports fourrière", nil, { RightLabel = "→" },true, function(h,a,s)
					if s then 
						ESX.TriggerServerCallback('mFourriere:affichereport', function(keys)
							reportlistesql = keys
						end)
						job = ESX.PlayerData.job.name
						Repportmenu1(job)
					end
				end)
                end)
				Wait(0)
			end
		end)
	end
end

function Repportmenu1()

    local reportmenu = RageUI.CreateMenu("", "~b~Hayes Auto", 0, 0, "root_cause", "shopui_title_supermod")
    local reportmenu2 = RageUI.CreateSubMenu(reportmenu, "", "~b~Hayes Auto")
    
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
                        TriggerServerEvent('mFourriere:supprimereport', supprimer)
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

function reportfourriere2(veh, motif)
    local plaqueveh = GetVehicleNumberPlateText(veh)
    local numeroreport = "RAPPORT - "..math.random(1,9999)
    local vehicleModel = GetEntityModel(veh)
    local nomvoituremodelee = GetDisplayNameFromVehicleModel(vehicleModel)
    local nomvoituretexte  = GetLabelText(nomvoituremodelee)
    TriggerServerEvent('mFourriere:ajoutreport',motif,GetPlayerName(PlayerId()),plaqueveh,numeroreport,nomvoituretexte)
end

gFourriere = {
    listefourriere = {}
}

function OpenfourriereMenu1()

    if fourriere then 
        fourriere = false 
        RageUI.Visible(RMenu:Get('fourriere', 'main'), false)
        return
    else
        RMenu.Add('fourriere', 'main', RageUI.CreateMenu("", "Voici les véhicules en fourrière", nil, nil,"root_cause", "shopui_title_supermod"))
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
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mecano' then
        local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
        local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, 256.28, -1789.09, 27.11)
        if jobdist <= 10.0 and Config.jeveuxmarker then
            Timer = 0
            DrawMarker(20, 256.28, -1789.09, 27.11, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if jobdist <= 1.0 then
                Timer = 0
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour voir les ~q~véhicules en fourrière")
                    if IsControlJustPressed(1,51) then
						if onService then
							ESX.TriggerServerCallback('mFourriere:listevehiculefourriere', function(result)
								gFourriere.listefourriere = result
							end)
							OpenfourriereMenu1()   
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
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mecano' then
        local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
        local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, 263.93, -1782.54, 26.11)
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
									reportfourriere2(vehicle, motif)
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
    ped = CreatePed("PED_TYPE_CIVMALE", "s_m_m_security_01", 262.50, -1781.15, 26.1143, 209.55, false, true)
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

RegisterNetEvent('mecano:targetAnnounce')
AddEventHandler('mecano:targetAnnounce', function(announce)
    if announce == 'ouvert' then
        ESX.ShowAdvancedNotification('Hayes Auto', '~q~Informations', "- Mécano Sud ~g~ouvert~s~\n- Horaire : ~q~Maintenant", "CHAR_BENNYS", 1)
    elseif announce == 'fermeture' then
        ESX.ShowAdvancedNotification('Hayes Auto', '~q~Informations', "- Mécano Sud ~r~fermé~s~\n- Horaire : ~q~Maintenant", "CHAR_BENNYS", 1)
    end
end)

function CheckServiceMecano()
	return onService
end