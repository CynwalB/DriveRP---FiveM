local AeroEvent = TriggerServerEvent
local scenarios = {
    'WORLD_VEHICLE_ATTRACTOR',
    'WORLD_VEHICLE_AMBULANCE',
    'WORLD_VEHICLE_BICYCLE_BMX',
    'WORLD_VEHICLE_BICYCLE_BMX_BALLAS',
    'WORLD_VEHICLE_BICYCLE_BMX_FAMILY',
    'WORLD_VEHICLE_BICYCLE_BMX_HARMONY',
    'WORLD_VEHICLE_BICYCLE_BMX_VAGOS',
    'WORLD_VEHICLE_BICYCLE_MOUNTAIN',
    'WORLD_VEHICLE_BICYCLE_ROAD',
    'WORLD_VEHICLE_BIKE_OFF_ROAD_RACE',
    'WORLD_VEHICLE_BIKER',
    'WORLD_VEHICLE_BOAT_IDLE',
    'WORLD_VEHICLE_BOAT_IDLE_ALAMO',
    'WORLD_VEHICLE_BOAT_IDLE_MARQUIS',
    'WORLD_VEHICLE_BOAT_IDLE_MARQUIS',
    'WORLD_VEHICLE_BROKEN_DOWN',
    'WORLD_VEHICLE_BUSINESSMEN',
    'WORLD_VEHICLE_HELI_LIFEGUARD',
    'WORLD_VEHICLE_CLUCKIN_BELL_TRAILER',
    'WORLD_VEHICLE_CONSTRUCTION_SOLO',
    'WORLD_VEHICLE_CONSTRUCTION_PASSENGERS',
    'WORLD_VEHICLE_DRIVE_PASSENGERS',
    'WORLD_VEHICLE_DRIVE_PASSENGERS_LIMITED',
    'WORLD_VEHICLE_DRIVE_SOLO',
    'WORLD_VEHICLE_FIRE_TRUCK',
    'WORLD_VEHICLE_EMPTY',
    'WORLD_VEHICLE_MARIACHI',
    'WORLD_VEHICLE_MECHANIC',
    'WORLD_VEHICLE_MILITARY_PLANES_BIG',
    'WORLD_VEHICLE_MILITARY_PLANES_SMALL',
    'WORLD_VEHICLE_PARK_PARALLEL',
    'WORLD_VEHICLE_PARK_PERPENDICULAR_NOSE_IN',
    'WORLD_VEHICLE_PASSENGER_EXIT',
    'WORLD_VEHICLE_POLICE_BIKE',
    'WORLD_VEHICLE_POLICE_CAR',
    'WORLD_VEHICLE_POLICE',
    'WORLD_VEHICLE_POLICE_NEXT_TO_CAR',
    'WORLD_VEHICLE_QUARRY',
    'WORLD_VEHICLE_SALTON',
    'WORLD_VEHICLE_SALTON_DIRT_BIKE',
    'WORLD_VEHICLE_SECURITY_CAR',
    'WORLD_VEHICLE_STREETRACE',
    'WORLD_VEHICLE_TOURBUS',
    'WORLD_VEHICLE_TOURIST',
    'WORLD_VEHICLE_TANDL',
    'WORLD_VEHICLE_TRACTOR',
    'WORLD_VEHICLE_TRACTOR_BEACH',
    'WORLD_VEHICLE_TRUCK_LOGS',
    'WORLD_VEHICLE_TRUCKS_TRAILERS',
    'WORLD_VEHICLE_DISTANT_EMPTY_GROUND'
}
  
for i, v in ipairs(scenarios) do
    SetScenarioTypeEnabled(v, false)
end

--[[
Citizen.CreateThread(function()
    while true do
        local plyPed = PlayerPedId()
        if IsPedSittingInAnyVehicle(plyPed) then
            local plyVehicle = GetVehiclePedIsIn(plyPed, false)
            CarSpeed = GetEntitySpeed(plyVehicle) * 3.6
            if CarSpeed <= 10.0 then 
                if IsControlJustReleased(0, 164) then 
                    SetPedIntoVehicle(plyPed, plyVehicle, -1)
                    Citizen.Wait(10)
                end
                if IsControlJustReleased(0, 165) then 
                    SetPedIntoVehicle(plyPed, plyVehicle, 0)
                    Citizen.Wait(10)
                end
                if IsControlJustReleased(0, 159) then 
                    SetPedIntoVehicle(plyPed, plyVehicle, 1)
                    Citizen.Wait(10)
                end
                if IsControlJustReleased(0, 161) then 
                    SetPedIntoVehicle(plyPed, plyVehicle, 2)
                    Citizen.Wait(10)
                end
            end
            Citizen.Wait(10)
        else
            Citizen.Wait(850)
        end
    end
end) 
--]]

-- Activation trains

Citizen.CreateThread(function()
    SwitchTrainTrack(0, true)
    SwitchTrainTrack(3, true)
    N_0x21973bbf8d17edfa(0, 120000)
    SetRandomTrains(true)
 end)

-- DESACTIVER LE CHANGEMENT DE PLACE AUTO
local actionkey=21 --Lshift (or whatever your sprint key is bound to)
local allowshuffle = false
local playerped=nil
local currentvehicle=nil

--getting vars
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		--constantly getting the current 
		playerped=PlayerPedId()
		--constantly get player vehicle
		currentvehicle=GetVehiclePedIsIn(playerped, false)
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		if IsPedInAnyVehicle(playerped, false) and allowshuffle == false then
			--if they're trying to shuffle for whatever reason
			SetPedConfigFlag(playerped, 184, true)
			if GetIsTaskActive(playerped, 165) then
				--getting seat player is in 
				seat=0
				if GetPedInVehicleSeat(currentvehicle, -1) == playerped then
					seat=-1
				end
				--if the passenger doesn't shut the door, shut it manually
				--if GetVehicleDoorAngleRatio(currentvehicle,1) > 0.0 and seat == 0 then
					--SetVehicleDoorShut(currentvehicle,1,false)
				--end
				--move ped back into the seat right as the animation starts
				SetPedIntoVehicle(playerped, currentvehicle, seat)
			end
		elseif IsPedInAnyVehicle(playerped, false) and allowshuffle == true then
			SetPedConfigFlag(playerped, 184, false)
		end
	end
end)


RegisterNetEvent("SeatShuffle")
AddEventHandler("SeatShuffle", function()
	if IsPedInAnyVehicle(playerped, false) then
		--getting seat
		seat=0
		if GetPedInVehicleSeat(currentvehicle, -1) == playerped then
			seat=-1
		end
		--if they're a driver
		if GetPedInVehicleSeat(currentvehicle,-1) == playerped then
			TaskShuffleToNextVehicleSeat(playerped,currentvehicle)
		end
		--if they're a passenger
		--adding a block until they are actually in their new seat
		allowshuffle=true
		while GetPedInVehicleSeat(currentvehicle,seat) == playerped do
			Citizen.Wait(0)
		end
		allowshuffle=false
	else
		allowshuffle=false
		CancelEvent('SeatShuffle')
	end
end)


-- MONTER A L'ARRIERE DU VEHICULE

local doors = {
	{"seat_dside_f", -1},
	{"seat_pside_f", 0},
	{"seat_dside_r", 1},
	{"seat_pside_r", 2}
}

function VehicleInFront(ped)
    local pos = GetEntityCoords(ped)
    local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 5.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, ped, 0)
    local _, _, _, _, result = GetRaycastResult(rayHandle)
	
    return result
end

Citizen.CreateThread(function()
	while true do
    	Citizen.Wait(0)
			
		local ped = PlayerPedId()
			
   		if IsControlJustReleased(0, 23) and running ~= true and GetVehiclePedIsIn(ped, false) == 0 then
      		local vehicle = VehicleInFront(ped)
				
      		running = true
				
      		if vehicle ~= nil then
				local plyCoords = GetEntityCoords(ped, false)
        		local doorDistances = {}
					
        		for k, door in pairs(doors) do
          			local doorBone = GetEntityBoneIndexByName(vehicle, door[1])
          			local doorPos = GetWorldPositionOfEntityBone(vehicle, doorBone)
          			local distance = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, doorPos.x, doorPos.y, doorPos.z)
						
          			table.insert(doorDistances, distance)
        		end
					
        		local key, min = 1, doorDistances[1]
					
        		for k, v in ipairs(doorDistances) do
          			if doorDistances[k] < min then
           				key, min = k, v
          			end
        		end
					
        		TaskEnterVehicle(ped, vehicle, -1, doors[key][2], 1.5, 1, 0)
     		end
				
      		running = false
    	end
  	end
end)

-- KEYBIND CHANGEMENT PLACE VEHICLE

RegisterKeyMapping('vl4', 'Place arrière droite', 'keyboard', '7')
RegisterKeyMapping('vl3', 'Place arrière gauche', 'keyboard', '6')
RegisterKeyMapping('vl2', 'Place avant passager', 'keyboard', '5')
RegisterKeyMapping('vl1', 'Place conducteur', 'keyboard', '4')


RegisterCommand('vl1', function()
    local plyPed = PlayerPedId()
        if IsPedSittingInAnyVehicle(plyPed) then
            local plyVehicle = GetVehiclePedIsIn(plyPed, false)
			CarSpeed = GetEntitySpeed(plyVehicle) * 3.6 -- On définit la vitesse du véhicule en km/h
			if CarSpeed <= 30.0 then -- On ne peux pas changer de place si la vitesse du véhicule est au dessus ou égale à 50 km/h
                SetPedIntoVehicle(plyPed, plyVehicle, -1)
                Citizen.Wait(10)
			end
		end
		Citizen.Wait(10) -- anti crash
end)

RegisterCommand('vl2', function()
    local plyPed = PlayerPedId()
        if IsPedSittingInAnyVehicle(plyPed) then
            local plyVehicle = GetVehiclePedIsIn(plyPed, false)
			CarSpeed = GetEntitySpeed(plyVehicle) * 3.6 -- On définit la vitesse du véhicule en km/h
			if CarSpeed <= 30.0 then -- On ne peux pas changer de place si la vitesse du véhicule est au dessus ou égale à 50 km/h
                SetPedIntoVehicle(plyPed, plyVehicle, 0)
                Citizen.Wait(10)
			end
		end
		Citizen.Wait(10) -- anti crash
end)

RegisterCommand('vl3', function()
    local plyPed = PlayerPedId()
        if IsPedSittingInAnyVehicle(plyPed) then
            local plyVehicle = GetVehiclePedIsIn(plyPed, false)
			CarSpeed = GetEntitySpeed(plyVehicle) * 3.6 -- On définit la vitesse du véhicule en km/h
			if CarSpeed <= 30.0 then -- On ne peux pas changer de place si la vitesse du véhicule est au dessus ou égale à 50 km/h
                SetPedIntoVehicle(plyPed, plyVehicle, 1)
                Citizen.Wait(10)
			end
		end
		Citizen.Wait(10) -- anti crash
end)

RegisterCommand('vl4', function()
    local plyPed = PlayerPedId()
        if IsPedSittingInAnyVehicle(plyPed) then
            local plyVehicle = GetVehiclePedIsIn(plyPed, false)
			CarSpeed = GetEntitySpeed(plyVehicle) * 3.6 -- On définit la vitesse du véhicule en km/h
			if CarSpeed <= 30.0 then -- On ne peux pas changer de place si la vitesse du véhicule est au dessus ou égale à 50 km/h
                SetPedIntoVehicle(plyPed, plyVehicle, 2)
                Citizen.Wait(10)
			end
		end
		Citizen.Wait(10) -- anti crash
end)

-- Citizen.CreateThread(function()
--     while true do
--         local plyPed = PlayerPedId()
--         if IsPedSittingInAnyVehicle(plyPed) then
--             local plyVehicle = GetVehiclePedIsIn(plyPed, false)
-- 			CarSpeed = GetEntitySpeed(plyVehicle) * 3.6 -- On définit la vitesse du véhicule en km/h
-- 			if CarSpeed <= 50.0 then -- On ne peux pas changer de place si la vitesse du véhicule est au dessus ou égale à 50 km/h
-- 				if IsControlJustReleased(0, 164) then -- conducteur
-- 					SetPedIntoVehicle(plyPed, plyVehicle, -1)
-- 					Citizen.Wait(10)
-- 				end
-- 				if IsControlJustReleased(0, 165) then -- avant droit
-- 					SetPedIntoVehicle(plyPed, plyVehicle, 0)
-- 					Citizen.Wait(10)
-- 				end
-- 				if IsControlJustReleased(0, 159) then -- arriere gauche
-- 					SetPedIntoVehicle(plyPed, plyVehicle, 1)
-- 					Citizen.Wait(10)
-- 				end
-- 				if IsControlJustReleased(0, 161) then -- arriere gauche
-- 					SetPedIntoVehicle(plyPed, plyVehicle, 2)
-- 					Citizen.Wait(10)
-- 				end
-- 			end
-- 		end
-- 		Citizen.Wait(10) -- anti crash
-- 	end
-- end)

-- Tirer vl hors conducteur

local passengerDriveBy = true

Citizen.CreateThread(function()
	while true do
		Wait(1)

		playerPed = GetPlayerPed(-1)
		car = GetVehiclePedIsIn(playerPed, false)
		if car then
			if GetPedInVehicleSeat(car, -1) == playerPed then
				SetPlayerCanDoDriveBy(PlayerId(), false)
			elseif passengerDriveBy then
				SetPlayerCanDoDriveBy(PlayerId(), true)
			else
				SetPlayerCanDoDriveBy(PlayerId(), false)
			end
		end
	end
end)

-- COUP DE CROSSE

--[[
Citizen.CreateThread(function()
    while true do
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.5)
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PISTOL"), 0.0) 
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MICROSMG"), 0.2) 
	Wait(0)
    end
end)
--]]

-- CLEAR NPC AREA

local pedindex = {}

ESX                           = nil
local PlayerData                = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
    for i = 1, 32 do
        Citizen.InvokeNative(0xDC0F817884CDD856, i, false)
    end
    while true do
        Citizen.Wait(0)
        if GetPlayerWantedLevel(PlayerId()) ~= 0 then
            ClearPlayerWantedLevel(PlayerId())
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = GetPlayerPed(-1)
        local playerLocalisation = GetEntityCoords(playerPed)
        ClearAreaOfCops(playerLocalisation.x, playerLocalisation.y, playerLocalisation.z, 400.0)
    end
end)

function SetWeaponDrops()
    local handle, ped = FindFirstPed()
    local finished = false
    repeat 
        if not IsEntityDead(ped) then
                pedindex[ped] = {}
        end
        finished, ped = FindNextPed(handle)
    until not finished
    EndFindPed(handle)

    for peds,_ in pairs(pedindex) do
        if peds ~= nil then
            SetPedDropsWeaponsWhenDead(peds, false) 
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        SetWeaponDrops()
    end
end)

local Players = GetPlayerPed(-1)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(750)
        local Players = GetPlayerPed(-1)
--        DisablePlayerVehicleRewards(Players.ID, 0)
        SetPlayerHealthRechargeMultiplier(Players.ID, 0.0)
        SetRunSprintMultiplierForPlayer(Players.ID, 1.0)
        SetSwimMultiplierForPlayer(Players.ID, 1.0)
--        if Player.IsDriver then
--            SetPlayerCanDoDriveBy(Player.ID, false)
--        else
--            SetPlayerCanDoDriveBy(Player.ID, true)
--        end
        if GetPlayerWantedLevel(Player.ID) ~= 0 then
            ClearPlayerWantedLevel(Player.ID)
        end
    end
end)
    
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        DisableReports()
    end
end)
    
function DisableReports()
    CancelCurrentPoliceReport()
    DisablePoliceReports()
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        HideHudComponentThisFrame(3)
        HideHudComponentThisFrame(4)
        HideHudComponentThisFrame(13)
    end
end)