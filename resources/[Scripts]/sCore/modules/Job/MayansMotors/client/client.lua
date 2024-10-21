local AeroEvent = TriggerServerEvent
ESX = nil

SneakyEvent = AeroEvent
local Vehicles = {}
local PlayerData = {}
local onService = false
local ActionsAnnonceMayansm = {
	"~g~Ouverture~s~",
	"~r~Fermeture~s~"
}
local ActionsAnnonceMayansmIndex = 1

mayansmMenu = {

    PositionVestiaire = {
        {coords = vector3(164.03091430664,269.99353027344,109.94777679443)},
    },
	PositionKitRepa = {
        {coords = vector3(80.343803405762,294.03244018555,109.95497894287-0.9)},
    },
	PositionGarage = {
        {coords = vector3(107.52518463135,280.41091918945,109.97380065918-0.9)},
    },
	PositionDeleteGarage = {
        {coords = vector3(80.806282043457,300.50512695313,109.97937011719-0.9)},
    },
}

local Clothesmayansm = {


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

mayansmVestiaire = {}
RMenu.Add('mayansmvestiaire', 'main', RageUI.CreateMenu("", "",10, 200,"root_cause","shopui_title_supermod"))
RMenu:Get('mayansmvestiaire', 'main'):SetSubtitle("~q~Actions disponibles")
RMenu:Get('mayansmvestiaire', 'main').EnableMouse = false
RMenu:Get('mayansmvestiaire', 'main').Closed = function()
    mayansmVestiaire.Menu = false
end

function OpenmayansmVestiaireRageUIMenu()

    if mayansmVestiaire.Menu then
        mayansmVestiaire.Menu = false
    else
        mayansmVestiaire.Menu = true
        RageUI.Visible(RMenu:Get('mayansmvestiaire', 'main'), true)

        Citizen.CreateThread(function()
            while mayansmVestiaire.Menu do
                RageUI.IsVisible(RMenu:Get('mayansmvestiaire', 'main'), true, false, true, function()
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
						for k,v in pairs(Clothesmayansm.clothsvert.men) do
							RageUI.Button("Tenue de ~y~"..v.grade, nil, {RightLabel = "~q~Se changer →"}, true, function(h,a,s)
								if s then
									TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
										TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
										onService = true
									end)
								end
							end)
						end
						for k,v in pairs(Clothesmayansm.clothsgris.men) do
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
						for k,v in pairs(Clothesmayansm.clothsvert.women) do
							RageUI.Button("Tenue de ~y~"..v.grade, nil, {RightLabel = "~q~Se changer →"}, true, function(h,a,s)
								if s then
									TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
										TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
										onService = true
									end)
								end
							end)
						end
						for k,v in pairs(Clothesmayansm.clothsgris.women) do
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
RMenu.Add('mayansmshop', 'main', RageUI.CreateMenu("", "",10, 200,"root_cause","shopui_title_supermod"))
RMenu:Get('mayansmshop', 'main'):SetSubtitle("~q~Produits disponibles")
RMenu:Get('mayansmshop', 'main').EnableMouse = false
RMenu:Get('mayansmshop', 'main').Closed = function()
    MecanoKitRepa.Menu = false
    FreezeEntityPosition(PlayerPedId(), false)
end

function OpenMayansmKitRepa()
	if MecanoKitRepa.Menu then
        MecanoKitRepa.Menu = false
    else
	MecanoKitRepa.Menu = true
	RageUI.Visible(RMenu:Get('mayansmshop', 'main'), true)
	FreezeEntityPosition(PlayerPedId(), true)

        Citizen.CreateThread(function()
			while MecanoKitRepa.Menu do
                RageUI.IsVisible(RMenu:Get('mayansmshop', 'main'), true, false, true, function()
                    RageUI.Button("Kit de réparation", false, {RightLabel = "→ Acheter 2300~q~$"}, true, function(h,a,s)
					if s then
						SneakyEvent('Sneakymayansm:giveItem', "fixkit",2300)
					end
                    end)
                end)
				Wait(0)
			end
		end)
	end
end


local Garagemayansm = {

	garagemayansm = {
        vehicule = {
            {label = "Grande Dépanneuse", veh = "towtruck3", stock = 5},
            {label = "Plateau", veh = "flatbed", stock = 3},
        },
        pos  = {
            {pos = vector3(111.13082885742,287.638671875,109.97380065918), heading = 359.62},
        },
    },
}


mayansmGarage = {}
RMenu.Add('mayansmgarage', 'main', RageUI.CreateMenu("", "",10, 200,"root_cause","shopui_title_supermod"))
RMenu:Get('mayansmgarage', 'main'):SetSubtitle("~q~Actions disponibles")
RMenu:Get('mayansmgarage', 'main').EnableMouse = false
RMenu:Get('mayansmgarage', 'main').Closed = function()
    mayansmGarage.Menu = false
end

function OpenmayansmGarageRageUIMenu()

    if mayansmGarage.Menu then
        mayansmGarage.Menu = false
    else
        mayansmGarage.Menu = true
        RageUI.Visible(RMenu:Get('mayansmgarage', 'main'), true)

        Citizen.CreateThread(function()
            while mayansmGarage.Menu do
                RageUI.IsVisible(RMenu:Get('mayansmgarage', 'main'), true, false, true, function()
                    RageUI.Separator("~q~↓~s~ Véhicule de service ~q~↓~s~")
                    for k,v in pairs(Garagemayansm.garagemayansm.vehicule) do
                        RageUI.Button(v.label, nil, {RightLabel = "Stock: [~q~"..v.stock.."~s~]"}, v.stock > 0, function(h,a,s)
                            if s then
                                local pos = FoundClearSpawnPoint(Garagemayansm.garagemayansm.pos)
                                if pos ~= false then
                                    LoadModel(v.veh)
                                    local veh = CreateVehicle(GetHashKey(v.veh), pos.pos, pos.heading, true, false)
                                    SetEntityAsMissionEntity(veh, 1, 1)
                                    SetVehicleDirtLevel(veh, 0.0)
                                    ShowLoadingMessage("Véhicule de service sortie.", 2, 2000)
                                    SneakyEvent('esx_vehiclelock:givekey', 'no', GetVehicleNumberPlateText(veh))
									TriggerEvent('persistent-vehicles/register-vehicle', veh)
                                    Garagemayansm.garagemayansm.vehicule[k].stock = Garagemayansm.garagemayansm.vehicule[k].stock - 1
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
		for k,v in pairs(Garagemayansm.garagemayansm.vehicule) do
			if GetHashKey(v.veh) == model then
				Garagemayansm.garagemayansm.vehicule[k].stock = Garagemayansm.garagemayansm.vehicule[k].stock + 1
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

local mayansmClean = {}
RMenu.Add('mayansmclean', 'main', RageUI.CreateMenu("", "",10, 200,"root_cause","shopui_title_supermod"))
RMenu:Get('mayansmclean', 'main'):SetSubtitle("~r~Produits disponibles")
RMenu:Get('mayansmclean', 'main').EnableMouse = false
RMenu:Get('mayansmclean', 'main').Closed = function()
    mayansmClean.Menu = false
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
		for k,v in pairs(mayansmMenu.PositionVestiaire) do
            local mPos = #(pCoords-v.coords)
		  if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'mayansm' then
			if not mayansmVestiaire.Menu then
				if mPos <= 10.0 then
					att = 1
					
					if mPos <= 2.0 then
					DrawMarker(20, v.coords.x, v.coords.y, v.coords.z+0.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 0, 155, 255, 255, 0, false, false, 2, false, false, false, false)
					ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au Vestiaire")
					if IsControlJustPressed(0, 51) then
						ESX.PlayerData = ESX.GetPlayerData()
							pGrade = ESX.GetPlayerData().job.grade_label
						OpenmayansmVestiaireRageUIMenu()
					end
					end
				end
			end
		end
        end
		for k,v in pairs(mayansmMenu.PositionKitRepa) do
            local mPos = #(pCoords-v.coords)

            if not MecanoKitRepa.Menu then
                if mPos <= 10.0 then
                    att = 1
                    DrawMarker(1, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 150, 200, 170, 0, 0, 0, 1, nil, nil, 0)
                   
                    if mPos <= 1.5 then
				    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder à l'armoire")
                        if IsControlJustPressed(0, 51) then
                            OpenMayansmKitRepa()
                        end
                    end
                end
            end
        end
		for k,v in pairs(mayansmMenu.PositionGarage) do
            local mPos = #(pCoords-v.coords)
            if not mayansmGarage.Menu then
                if mPos <= 10.0 then
                    att = 1
                    
                    if mPos <= 1.5 then
						if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'mayansm' then
							ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au Garage")
							if IsControlJustPressed(0, 51) then
								if onService then
									OpenmayansmGarageRageUIMenu()
								else
									ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
								end
							end
						end
                    end
                end
            end
        end
        for k,v in pairs(mayansmMenu.PositionDeleteGarage) do
            local mPos = #(pCoords-v.coords)
            if not mayansmGarage.Menu then
                if IsPedInAnyVehicle(PlayerPedId(), true) then
                    if mPos <= 10.0 then
                        att = 1
                        if mPos <= 3.5 then
						if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'mayansm' then
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
        Citizen.Wait(att)
    end
end)

local mayansmActionMenu = {}
function OpenMayansmActionMenuRageUIMenu()

    if mayansmActionMenu.Menu then 
        mayansmActionMenu.Menu = false 
        RageUI.Visible(RMenu:Get('mayansmactionmenu', 'main'), false)
        return
    else
        RMenu.Add('mayansmactionmenu', 'main', RageUI.CreateMenu("", "", 0, 0,"root_cause","shopui_title_supermod"))
		RMenu.Add('mayansmactionmenu', 'action', RageUI.CreateSubMenu(RMenu:Get("mayansmactionmenu", "main"),"", "Mayans Motors"))
        RMenu.Add('mayansmactionmenu', 'facture', RageUI.CreateSubMenu(RMenu:Get("mayansmactionmenu", "action"),"", "Mayans Motors"))
        RMenu:Get('mayansmactionmenu', 'main'):SetSubtitle("Mayans Motors")
        RMenu:Get('mayansmactionmenu', 'main').EnableMouse = false
        RMenu:Get('mayansmactionmenu', 'main').Closed = function()
            mayansmActionMenu.Menu = false
        end
        mayansmActionMenu.Menu = true 
        RageUI.Visible(RMenu:Get('mayansmactionmenu', 'main'), true)
        Citizen.CreateThread(function()
			while mayansmActionMenu.Menu do
                RageUI.IsVisible(RMenu:Get('mayansmactionmenu', 'main'), true, false, true, function()
				RageUI.List("Annonce", ActionsAnnonceMayansm, ActionsAnnonceMayansmIndex, nil, {}, true, function(Hovered, Active, Selected, Index) 
					if (Selected) then 
						if Index == 1 then
							local announce = 'ouvert'
							SneakyEvent('mayansm:addAnnounce', announce)
						elseif Index == 2 then
							local announce = 'fermeture'
							SneakyEvent('mayansm:addAnnounce', announce)
						end 
					end 
					ActionsAnnonceMayansmIndex = Index 
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
						TriggerEvent("sBill:CreateBill","society_mayansm")
					end
				end)
				end)
				Wait(0)
			end
		end)
	end
end

function CheckServiceMayansm()
	return onService
end

RegisterNetEvent('mayansm:targetAnnounce')
AddEventHandler('mayansm:targetAnnounce', function(announce)
    if announce == 'ouvert' then
        ESX.ShowAdvancedNotification("Mayans Motors", '~q~Informations', "- Mécano ~g~ouvert~s~\n- Horaire : ~q~Maintenant", "CHAR_BENNYS", 1)
    elseif announce == 'fermeture' then
        ESX.ShowAdvancedNotification("Mayans Motors", '~q~Informations', "- Mécano ~r~fermé~s~\n- Horaire : ~q~Maintenant", "CHAR_BENNYS", 1)
    end
end)