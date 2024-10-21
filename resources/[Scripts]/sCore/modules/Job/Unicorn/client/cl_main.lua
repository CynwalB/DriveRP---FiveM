local AeroEvent = TriggerServerEvent
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
         Citizen.Wait(10)
   end
   if ESX.IsPlayerLoaded() then
         ESX.PlayerData = ESX.GetPlayerData()
   end
end)
SneakyEvent = AeroEvent
local onService = false
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('announce:unicorn')
AddEventHandler('announce:unicorn', function(announce)
    if announce == 'ouvert' then
        ESX.ShowAdvancedNotification('Unicorn', '~q~Informations', "- Unicorn ~g~ouvert~s~~n~- Horaire : ~q~Maintenant", "CHAR_UNICORN", 1)
    elseif announce == 'fermeture' then
        ESX.ShowAdvancedNotification('Unicorn', '~q~Informations', "- Unicorn ~r~fermé~s~~n~- Horaire : ~q~Maintenant", "CHAR_UNICORN", 1)
    end
end)


function ShowHelpNotification(msg)
    AddTextEntry('HelpNotification', msg)
	BeginTextCommandDisplayHelp('HelpNotification')
    EndTextCommandDisplayHelp(0, false, true, -1)
end

local garageunicorn = {

	garageunicorn = {
        vehs = {
            {label = "Limousine", veh = "stretch", stock = 2},
            {label = "Limousine Hummer", veh = "patriot2", stock = 1},
        },
        pos  = {
            {pos = vector3(107.8231689453,-1277.31027832031,29.020877532959), heading = 95.760},
        },
    },
}

local Unicorn = {
	PositionGarage = {
        {coords = vector3(106.24003906,-1280.1651855469,29.242715835571-0.9)},
    },
	PositionDeleteGarage = {
        {coords = vector3(102.64231689453,-1278.491003417969,29.0736579895-0.9)},
    },
}

GarageUnicorn = {}
RMenu.Add('garageunicorn', 'main', RageUI.CreateMenu("", "",nil,nil,"root_cause","shopui_title_vanillaunicorn"))
RMenu:Get('garageunicorn', 'main'):SetSubtitle("Unicorn")
RMenu:Get('garageunicorn', 'main').EnableMouse = false
RMenu:Get('garageunicorn', 'main').Closed = function()
    GarageUnicorn.Menu = false
end

function OpenGarageUnicornRageUIMenu()

    if GarageUnicorn.Menu then
        GarageUnicorn.Menu = false
    else
        GarageUnicorn.Menu = true
        RageUI.Visible(RMenu:Get('garageunicorn', 'main'), true)

        Citizen.CreateThread(function()
            while GarageUnicorn.Menu do
                RageUI.IsVisible(RMenu:Get('garageunicorn', 'main'), true, false, true, function()
                    RageUI.Separator("~q~↓~s~ Véhicule de service ~q~↓~s~")
                    for k,v in pairs(garageunicorn.garageunicorn.vehs) do
                        RageUI.Button(v.label, nil, {RightLabel = "Stock: [~q~"..v.stock.."~s~]"}, v.stock > 0, function(h,a,s)
                            if s then
                                local pos = FoundClearSpawnPoint(garageunicorn.garageunicorn.pos)
                                if pos ~= false then
                                    LoadModel(v.veh)
                                    local veh = CreateVehicle(GetHashKey(v.veh), pos.pos, pos.heading, true, false)
                                    SetVehicleLivery(veh, 14)
                                    local chance = math.random(1,2)
                                    if chance == 1 then
                                        SetVehicleColours(veh,111,111)
                                    else
                                        SetVehicleColours(veh,145,145)
                                    end
                                    SetEntityAsMissionEntity(veh, 1, 1)
                                    SetVehicleDirtLevel(veh, 0.0)
                                    ShowLoadingMessageUnicorn("Véhicule de service sortie.", 2, 2000)
                                    SneakyEvent('esx_vehiclelock:givekey', 'no', GetVehicleNumberPlateText(veh))
                                    TriggerEvent('persistent-vehicles/register-vehicle', veh)
                                    garageunicorn.garageunicorn.vehs[k].stock = garageunicorn.garageunicorn.vehs[k].stock - 1
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

function ShowLoadingMessageUnicorn(text, spinnerType, timeMs)
	Citizen.CreateThread(function()
		BeginTextCommandBusyspinnerOn("STRING")
		AddTextComponentSubstringPlayerName(text)
		EndTextCommandBusyspinnerOn(spinnerType)
		Wait(timeMs)
		RemoveLoadingPrompt()
	end)
end

function DelVehUnicorn()
	local pPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(pPed, false) then
		local pVeh = GetVehiclePedIsIn(pPed, false)
		local model = GetEntityModel(pVeh)
		Citizen.CreateThread(function()
			ShowLoadingMessageUnicorn("Rangement du véhicule ...", 1, 2500)
		end)
		local vehicle = GetVehiclePedIsIn(PlayerPedId(),  false)
        local plate = GetVehicleNumberPlateText(vehicle)
        SneakyEvent('esx_vehiclelock:deletekeyjobs', 'no', plate)
		TaskLeaveAnyVehicle(pPed, 1, 1)
		Wait(2500)
		while IsPedInAnyVehicle(pPed, false) do
			TaskLeaveAnyVehicle(pPed, 1, 1)
			ShowLoadingMessageUnicorn("Rangement du véhicule ...", 1, 300)
			Wait(200)
		end
        TriggerEvent('persistent-vehicles/forget-vehicle', pVeh)
	    DeleteEntity(pVeh)
		for k,v in pairs(garageunicorn.garageunicorn.vehs) do
			if model == GetHashKey(v.veh) then
				garageunicorn.garageunicorn.vehs[k].stock = garageunicorn.garageunicorn.vehs[k].stock + 1
			end
		end
	else
		ShowNotification("Vous devez être dans un véhicule.")
	end
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while true do
        att = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(Unicorn.PositionGarage) do
            local mPos = #(v.coords-pCoords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'unicorn' then
                if not GarageUnicorn.Menu then
                    if mPos <= 10.0 then
                        att = 1
                        
                        if mPos <= 1.5 then
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au Garage")
                            if IsControlJustPressed(0, 51) then
                                if onService then
                                    OpenGarageUnicornRageUIMenu()
                                else
                                    ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
                                end
                            end
                        end
                    end
                end
            end
        end
		for k,v in pairs(Unicorn.PositionDeleteGarage) do
            local mPos = #(v.coords-pCoords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'unicorn' then
                if not GarageUnicorn.Menu then
                    if IsPedInAnyVehicle(PlayerPedId(), true) then
                        if mPos <= 10.0 then
                            att = 1
                            if mPos <= 3.5 then
                                DrawMarker(20, v.coords.x, v.coords.y, v.coords.z+0.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
                                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule de service")
                                if IsControlJustPressed(0, 51) then
                                    if onService then
                                        DelVehUnicorn()
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

local ActionsAnnonce = {
    "~g~Ouverture~s~",
    "~r~Fermeture~s~"
}
local ActionsAnnonceIndex = 1

local MenuUnicorn = {}
RMenu.Add('unicornmenu', 'main', RageUI.CreateMenu("", "~q~Unicorn", nil, nil,"root_cause","shopui_title_vanillaunicorn"))
RMenu:Get('unicornmenu', 'main').EnableMouse = false
RMenu:Get('unicornmenu', 'main').Closed = function() MenuUnicorn.Menu = false end

function OpenUnicornMenuRageUIMenu()

    if MenuUnicorn.Menu then
        MenuUnicorn.Menu = false
    else
        MenuUnicorn.Menu = true
        RageUI.Visible(RMenu:Get('unicornmenu', 'main'), true)

        Citizen.CreateThread(function()
			while MenuUnicorn.Menu do
                RageUI.IsVisible(RMenu:Get('unicornmenu', 'main'), true, false, true, function()
                    if onService then
                        RageUI.Button("Stopper son ~r~service~s~", nil, {RightLabel = "→"}, onService, function(h,a,s)
                            if s then
                                onService = false
                            end
                        end)
                        RageUI.List("Annonce", ActionsAnnonce, ActionsAnnonceIndex, nil, {}, true, function(Hovered, Active, Selected, Index) 
                            if (Selected) then 
                                if Index == 1 then 
                                    local announce = 'ouvert'
                                    SneakyEvent('unicorn:announce', announce)
                                elseif Index == 2 then
                                    local announce = 'fermeture'
                                    SneakyEvent('unicorn:announce', announce)
                                end 
                            end 
                            ActionsAnnonceIndex = Index 
                        end)
                    else
                        RageUI.Button("Prendre son ~q~service~s~", nil, {RightLabel = "→"}, not onService, function(h,a,s)
                            if s then
                                onService = true
                            end
                        end)
                    end
                end)
				Wait(0)
			end
		end)
	end
end

function OpenUnicornActionMenuRageUIMenu()
    local mainMenu = RageUI.CreateMenu("", "~q~Unicorn", 0, 0,"root_cause","shopui_title_vanillaunicorn")

    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

    while mainMenu do
       Wait(1)
       RageUI.IsVisible(mainMenu, true, true, false, function()
            RageUI.Button("Attribuer une facture", nil, {RightLabel = "→"}, true,function(h,a,s)
                if s then
                    RageUI.CloseAll()
                    TriggerEvent("sBill:CreateBill","society_unicorn")
                end
            end)
       end)

       if not RageUI.Visible(mainMenu) then
           mainMenu = RMenu:DeleteType("menu", true)
       end
    end
end




local Unicornpos = {

    PositionAnnonce = {
        {coords = vector3(108.813148498535,-1304.541455078,28.76354598999-0.9)},
    },
}


Citizen.CreateThread(function()
    while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
    while true do
        att = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(Unicornpos.PositionAnnonce) do
            local mPos = #(pCoords-v.coords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'unicorn' then
                if not MenuUnicorn.Menu then
                    if mPos <= 10.0 then
                        att = 1
                        if mPos <= 3.5 then
                            DrawMarker(1, v.coords.x, v.coords.y, v.coords.z-0.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 136, 0, 255, 255, 0, false, false, 2, false, false, false, false)
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au annonce")
                            if IsControlJustPressed(0, 51) then
                                OpenUnicornMenuRageUIMenu()
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(att)
    end
end)

function CheckServiceUnicorn()
    return onService
end

