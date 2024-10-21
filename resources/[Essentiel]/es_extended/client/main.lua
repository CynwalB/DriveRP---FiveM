local isLoadoutLoaded, isPaused, isPlayerSpawned, isDead, pickups = false, false, false, false, {}
SneakyEvent = TriggerServerEvent

local Pickups = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	print("Spawn Player Es_extended")
	ESX.PlayerLoaded = true
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setMaxWeight')
AddEventHandler('esx:setMaxWeight', function(newMaxWeight)
	ESX.PlayerData.maxWeight = newMaxWeight
end)

AddEventHandler('playerSpawned', function(spawn, isFirstSpawn)
	print("Spawn Es_extended")
	while not ESX.PlayerLoaded do
		Citizen.Wait(10)
	end

	TriggerEvent('esx:restoreLoadout')

	if isFirstSpawn then
		SneakyEvent('esx:positionSaveReady')
	end

	isLoadoutLoaded, isPlayerSpawned, isDead = true, true, false
	SetCanAttackFriendly(PlayerPedId(), true, true)
	NetworkSetFriendlyFireOption(true)
end)

AddEventHandler('esx:onPlayerDeath', function() isDead = true end)
AddEventHandler('Sneakyskinchanger:loadDefaultModel', function() isLoadoutLoaded = false end)

AddEventHandler('Sneakyskinchanger:modelLoaded', function()
	while not ESX.PlayerLoaded do
		Citizen.Wait(1)
	end

	TriggerEvent('esx:restoreLoadout')
end)

AddEventHandler('esx:restoreLoadout', function()
	local playerPed = PlayerPedId()
	local ammoTypes = {}

	RemoveAllPedWeapons(playerPed, true)

	for i = 1, #ESX.PlayerData.loadout, 1 do
		local weaponName = ESX.PlayerData.loadout[i].name
		local weaponHash = GetHashKey(weaponName)

		GiveWeaponToPed(playerPed, weaponHash, 0, false, false)
		local ammoType = GetPedAmmoTypeFromWeapon(playerPed, weaponHash)

		for j = 1, #ESX.PlayerData.loadout[i].components, 1 do
			local weaponComponent = ESX.PlayerData.loadout[i].components[j]
			local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash
			GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
		end

		if not ammoTypes[ammoType] then
			AddAmmoToPed(playerPed, weaponHash, ESX.PlayerData.loadout[i].ammo)
			ammoTypes[ammoType] = true
		end
	end

	isLoadoutLoaded = true
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for i = 1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == account.name then
			ESX.PlayerData.accounts[i] = account
			break
		end
	end
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item)
	table.insert(ESX.PlayerData.inventory, item)
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, identifier)
	for i = 1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].name == item.name and (not identifier or (item.unique and ESX.PlayerData.inventory[i].extra.identifier and ESX.PlayerData.inventory[i].extra.identifier == identifier)) then
			table.remove(ESX.PlayerData.inventory, i)
			break
		end
	end
end)

RegisterNetEvent('esx:updateItemCount')
AddEventHandler('esx:updateItemCount', function(add, itemName, count)
	for i = 1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].name == itemName then
			ESX.PlayerData.inventory[i].count = count
			break
		end
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	ESX.PlayerData.job2 = job2
end)

RegisterNetEvent('esx:setGroup')
AddEventHandler('esx:setGroup', function(group, lastGroup)
	ESX.PlayerData.group = group
end)

RegisterNetEvent('esx:addWeapon')
AddEventHandler('esx:addWeapon', function(weaponName, weaponAmmo)
	local found = false

	for i = 1, #ESX.PlayerData.loadout, 1 do
		if ESX.PlayerData.loadout[i].name == weaponName then
			found = true
			break
		end
	end

	if not found then
		local playerPed = PlayerPedId()
		local weaponHash = GetHashKey(weaponName)
		local weaponLabel = ESX.GetWeaponLabel(weaponName)

		table.insert(ESX.PlayerData.loadout, {
			name = weaponName,
			ammo = weaponAmmo,
			label = weaponLabel,
			components = {}
		})

		GiveWeaponToPed(playerPed, weaponHash, weaponAmmo, false, false)
	end
end)

RegisterNetEvent('esx:addWeaponComponent')
AddEventHandler('esx:addWeaponComponent', function(weaponName, weaponComponent)
	for i = 1, #ESX.PlayerData.loadout, 1 do
		if ESX.PlayerData.loadout[i].name == weaponName then
			local component = ESX.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				local found = false

				for j = 1, #ESX.PlayerData.loadout[i].components, 1 do
					if ESX.PlayerData.loadout[i].components[j] == weaponComponent then
						found = true
						break
					end
				end

				if not found then
					local playerPed = PlayerPedId()
					local weaponHash = GetHashKey(weaponName)
					table.insert(ESX.PlayerData.loadout[i].components, weaponComponent)
					GiveWeaponComponentToPed(playerPed, weaponHash, component.hash)
				end
			end
		end
	end
end)

RegisterNetEvent('esx:setWeaponAmmo')
AddEventHandler('esx:setWeaponAmmo', function(weaponName, weaponAmmo)
	for i = 1, #ESX.PlayerData.loadout, 1 do
		if ESX.PlayerData.loadout[i].name == weaponName then
			local playerPed = PlayerPedId()
			local weaponHash = GetHashKey(weaponName)

			ESX.PlayerData.loadout[i].ammo = weaponAmmo
			SetPedAmmo(playerPed, weaponHash, weaponAmmo)
			break
		end
	end
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(weaponName, ammo)
	for i = 1, #ESX.PlayerData.loadout, 1 do
		if ESX.PlayerData.loadout[i].name == weaponName then
			local playerPed = PlayerPedId()
			local weaponHash = GetHashKey(weaponName)
			local weaponLabel = ESX.GetWeaponLabel(weaponName)
			table.remove(ESX.PlayerData.loadout, i)
			RemoveWeaponFromPed(playerPed, weaponHash)

			if ammo then
				local pedAmmo = GetAmmoInPedWeapon(playerPed, weaponHash)
				local finalAmmo = math.floor(pedAmmo - ammo)
				SetPedAmmo(playerPed, weaponHash, finalAmmo)
			else
				SetPedAmmo(playerPed, weaponHash, 0)
			end

			break
		end
	end
end)

RegisterNetEvent('esx:removeWeaponComponent')
AddEventHandler('esx:removeWeaponComponent', function(weaponName, weaponComponent)
	for i = 1, #ESX.PlayerData.loadout, 1 do
		if ESX.PlayerData.loadout[i].name == weaponName then
			local component = ESX.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				for j = 1, #ESX.PlayerData.loadout[i].components, 1 do
					if ESX.PlayerData.loadout[i].components[j] == weaponComponent then
						local playerPed = PlayerPedId()
						local weaponHash = GetHashKey(weaponName)
						table.insert(ESX.PlayerData.loadout[i].components, j)
						RemoveWeaponComponentFromPed(playerPed, weaponHash, component.hash)
						break
					end
				end
			end
		end
	end
end)

-- Commands
RegisterNetEvent('esx:teleport')
AddEventHandler('esx:teleport', function(coords)
	ESX.Game.Teleport(PlayerPedId(), coords)
end)

RegisterNetEvent('esx:spawnVehicle')
AddEventHandler('esx:spawnVehicle', function(model)
	model = (type(model) == 'number' and model or GetHashKey(model))

	if IsModelInCdimage(model) then
		local playerPed = PlayerPedId()
		local plyCoords = GetEntityCoords(playerPed)
		local plyHeading = GetEntityHeading(playerPed)
		ESX.Game.SpawnVehicle(model, plyCoords, plyHeading, function(vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			TriggerEvent('persistent-vehicles/register-vehicle', vehicle)
		end)
	else
		TriggerEvent('chat:addMessage', { args = { '^1SYSTEM', 'Invalid vehicle model.' } })
	end
end)

--[[ RegisterNetEvent('esx:createPickup')
AddEventHandler('esx:createPickup', function(pickupId, label, coords, type, name, components)
	local pickupObject

	ESX.Game.SpawnLocalObject('prop_cs_package_01', coords, function(obj)
		pickupObject = obj
	end)

	while not pickupObject do
		Citizen.Wait(10)
	end

	SetEntityAsMissionEntity(pickupObject, false, false)
	PlaceObjectOnGroundProperly(pickupObject)
	FreezeEntityPosition(pickupObject, true)

	pickups[pickupId] = {
		id = pickupId,
		obj = pickupObject,
		label = label,
		inRange = false,
		coords = coords
	}
end)

RegisterNetEvent('esx:createMissingPickups')
AddEventHandler('esx:createMissingPickups', function(missingPickups)
	for pickupId, pickup in pairs(missingPickups) do
		local pickupObject = nil

		ESX.Game.SpawnLocalObject('prop_cs_package_01', pickup.coords, function(obj)
			pickupObject = obj
		end)

		while pickupObject == nil do
			Citizen.Wait(10)
		end

		SetEntityAsMissionEntity(pickupObject, false, false)
		PlaceObjectOnGroundProperly(pickupObject)
		FreezeEntityPosition(pickupObject, true)

		pickups[pickupId] = {
			id = pickupId,
			obj = pickupObject,
			label = pickup.label,
			inRange = false,
			coords = pickup.coords
		}
	end
end)

RegisterNetEvent('esx:removePickup')
AddEventHandler('esx:removePickup', function(id)
	ESX.Game.DeleteObject(pickups[id].obj)
	pickups[id] = nil
end)

RegisterNetEvent('esx:spawnObject')
AddEventHandler('esx:spawnObject', function(model)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(coords + forward * 1.0)

	ESX.Game.SpawnObject(model, {
		x = x,
		y = y,
		z = z
	}, function(obj)
		SetEntityHeading(obj, GetEntityHeading(playerPed))
		PlaceObjectOnGroundProperly(obj)
	end)
end) ---]]

RegisterNetEvent('esx:pickup')
AddEventHandler('esx:pickup', function(id, label, player)
	local ped     = GetPlayerPed(GetPlayerFromServerId(player))
	local coords  = GetEntityCoords(ped)
	local forward = GetEntityForwardVector(ped)
	local x, y, z = table.unpack(coords + forward * 1.0)

	ESX.Game.SpawnLocalObject('bkr_prop_duffel_bag_01a', {
		x = x,
		y = y,
		z = z - 2.0,
	}, function(obj)
		SetEntityAsMissionEntity(obj, true, false)
		PlaceObjectOnGroundProperly(obj)

		Pickups[id] = {
			id = id,
			obj = obj,
			label = label,
			inRange = false,
			coords = {
				x = x,
				y = y,
				z = z
			}
		}
	end)
end)

-- RegisterNetEvent('esx:pickup')
-- AddEventHandler('esx:pickup', function(id, label, name, player)
-- 	local ped     = GetPlayerPed(GetPlayerFromServerId(player))
-- 	local playerPed = GetPlayerPed(-1)
-- 	local coords  = GetEntityCoords(ped)
-- 	local forward = GetEntityForwardVector(ped)
-- 	local x, y, z = table.unpack(coords + forward * 1.0)
-- 	local itemobject = 'bkr_prop_duffel_bag_01a'

-- 	-- for k,v in pairs(Config.ItemDrop) do
-- 	-- 	local found = false

-- 	-- 	if v.ItemName == name then
-- 	-- 		found = true
-- 	-- 		itemobject = v.ItemObject
-- 	-- 		break
-- 	-- 	end

-- 	-- end

-- 	ESX.Game.SpawnLocalObject(itemobject, {
-- 		x = x,
-- 		y = y,
-- 		z = z - 2.0,
-- 	}, function(obj)
-- 		-- if playerPed == ped then
-- 		-- 	if IsPedInAnyVehicle(playerPed, true) == false then
-- 		-- 		ClearPedTasks(GetPlayerPed(-1))
-- 		-- 		if not IsPedSwimming(playerPed) then
-- 		-- 			local dict = "weapons@first_person@aim_rng@generic@projectile@sticky_bomb@"
-- 		-- 			local anim = "plant_floor"
-- 		-- 			RequestAnimDict(dict)
-- 		-- 			while not HasAnimDictLoaded(dict) do
-- 		-- 				Citizen.Wait(1)
-- 		-- 			end
-- 		-- 			TaskPlayAnim(playerPed, dict, anim, 8.0, 1.0, -1, 2, 0, 0, 0, 0)
-- 		-- 			Wait(1000)
-- 		-- 		end
-- 		-- 		ClearPedTasks(GetPlayerPed(-1))
-- 		-- 	end
-- 		-- end
-- 		SetEntityAsMissionEntity(obj, true, false)
-- 		PlaceObjectOnGroundProperly(obj)
-- 		pickups[id] = {
-- 			id = id,
-- 			obj = obj,
-- 			label = label,
-- 			inRange = false,
-- 			coords = {
-- 				x = x,
-- 				y = y,
-- 				z = z
-- 			}
-- 		}
-- 	end)
-- end)

RegisterNetEvent('esx:removePickup')
AddEventHandler('esx:removePickup', function(id)
	ESX.Game.DeleteObject(Pickups[id].obj)
	Pickups[id] = nil
end)

RegisterNetEvent('esx:pickupWeapon')
AddEventHandler('esx:pickupWeapon', function(weaponPickup, weaponName, ammo)
	local playerPed = PlayerPedId()
	local pickupCoords = GetOffsetFromEntityInWorldCoords(playerPed, 2.0, 0.0, 0.5)
	local weaponHash = GetHashKey(weaponPickup)

	CreateAmbientPickup(weaponHash, pickupCoords, 0, ammo, 1, false, true)
end)

RegisterNetEvent('esx:deleteVehicle')
AddEventHandler('esx:deleteVehicle', function(radius)
	local playerPed = PlayerPedId()

	if radius and tonumber(radius) then
		radius = tonumber(radius) + 0.01
		local vehicles = ESX.Game.GetVehiclesInArea(GetEntityCoords(playerPed, false), radius)

		for i = 1, #vehicles, 1 do
			local attempt = 0

			while not NetworkHasControlOfEntity(vehicles[i]) and attempt < 100 and DoesEntityExist(vehicles[i]) do
				Citizen.Wait(100)
				NetworkRequestControlOfEntity(vehicles[i])
				attempt = attempt + 1
			end

			if DoesEntityExist(vehicles[i]) and NetworkHasControlOfEntity(vehicles[i]) then
				TriggerEvent('persistent-vehicles/forget-vehicle', vehicles[i])
				ESX.Game.DeleteVehicle(vehicles[i])
			end
		end
	else
		local vehicle, attempt = ESX.Game.GetVehicleInDirection(), 0

		if IsPedInAnyVehicle(playerPed, true) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		end

		while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
			Citizen.Wait(100)
			NetworkRequestControlOfEntity(vehicle)
			attempt = attempt + 1
		end

		if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
			TriggerEvent('persistent-vehicles/forget-vehicle', vehicle)
			ESX.Game.DeleteVehicle(vehicle)
		end
	end
end)

-- Pickups
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		local playerPed = GetPlayerPed(-1)
		local coords    = GetEntityCoords(playerPed)
		
		-- if there's no nearby pickups we can wait a bit to save performance
		if next(Pickups) == nil then
			Citizen.Wait(500)
		end

		for k,v in pairs(Pickups) do

			local distance = GetDistanceBetweenCoords(coords, v.coords.x, v.coords.y, v.coords.z, true)
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

			if distance <= 5.0 then
				ESX.Game.Utils.DrawText3D({
					x = v.coords.x,
					y = v.coords.y,
					z = v.coords.z + 0.25
				}, v.label)
			end

			--if (closestPlayer == -1 or closestDistance > 3) and 
			if distance <= 1.5 and not v.inRange and not IsPedSittingInAnyVehicle(playerPed) then
				if IsControlJustPressed(0, 38) then
--			if (closestDistance == -1 or closestDistance > 3) and distance <= 1.0 and not v.inRange and not IsPedSittingInAnyVehicle(playerPed) then
					if TriggerServerEvent('esx:onPickup', v.id, playerPed) then
						PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
						v.inRange = true
					end
				end
			end
		end
	end
end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)
-- 		-- local playerCoords, letSleep = GetEntityCoords(ESX.PlayerData.ped), true
-- 		-- local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer(playerCoords)
-- 		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

-- 		for PickupId,pickup in pairs(Pickups) do
-- 			-- local distance = #(playerCoords - pickup.coords)
-- 			local coords   = GetEntityCoords(PlayerPedId())
-- 			local distance = GetDistanceBetweenCoords(coords, pickup.coords.x, pickup.coords.y, pickup.coords.z, true)

-- 			if distance < 5 then
-- 				-- local label = pickup.label
-- 				-- letSleep = false

-- 				if distance < 1 then
-- 					if IsControlJustReleased(0, 38) then
-- 						if IsPedOnFoot(PlayerPedId()) and (closestDistance == -1 or closestDistance > 3) and not pickup.inRange then
-- 							pickup.inRange = true

-- 							-- local dict, anim = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@', 'plant_floor'
-- 							-- ESX.Streaming.RequestAnimDict(dict)
-- 							-- TaskPlayAnim(ESX.PlayerData.ped, dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
-- 							Citizen.Wait(1000)

-- 							TriggerServerEvent('esx:onPickup', pickupId)
-- 							PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
-- 						end
-- 					end
-- 				end

-- 				ESX.Game.Utils.DrawText3D({
-- 					x = pickup.coords.x,
-- 					y = pickup.coords.y,
-- 					z = pickup.coords.z + 0.25
-- 				}, pickup.label)
-- 		end
-- 	end
-- end)

-- Last position
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local playerPed = PlayerPedId()

		if ESX.PlayerLoaded and isPlayerSpawned then
			if not IsEntityDead(playerPed) then
				ESX.PlayerData.lastPosition = GetEntityCoords(playerPed, false)
			end
		end

		if IsEntityDead(playerPed) and isPlayerSpawned then
			isPlayerSpawned = false
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		while not ESX.PlayerLoaded do
			Citizen.Wait(10)
		end

		local playerPed = PlayerPedId()
	
		if playerPed and playerPed ~= -1 then
			while GetResourceState('spawnmanager') ~= 'started' do
				Citizen.Wait(10)
			end

			TriggerEvent('spawnmanager:spawnPlayer', {model = `mp_m_freemode_01`, coords = ESX.PlayerData.lastPosition, heading = 0.0})
			return
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if NetworkIsSessionStarted() then
			SneakyEvent('esx:firstJoinProper')
			return
		end
	end
end)

Citizen.CreateThread(function()
    SetGarbageTrucks(0)
    SetRandomBoats(0)
    SetRandomTrains(0)
    SetRelationshipBetweenGroups(0, `COP`, `PLAYER`)
    SetRelationshipBetweenGroups(0, `MEDIC`, `PLAYER`)
    SetRelationshipBetweenGroups(0, `FIREMAN`, `PLAYER`)
    SetRelationshipBetweenGroups(0, `GANG_1`, `PLAYER`)
    SetRelationshipBetweenGroups(0, `GANG_2`, `PLAYER`)
    SetRelationshipBetweenGroups(0, `GANG_9`, `PLAYER`)
    SetRelationshipBetweenGroups(0, `GANG_10`, `PLAYER`)
    SetRelationshipBetweenGroups(0, `AMBIENT_GANG_LOST`, `PLAYER`)
    SetRelationshipBetweenGroups(0, `AMBIENT_GANG_MEXICAN`, `PLAYER`)
    SetRelationshipBetweenGroups(0, `AMBIENT_GANG_FAMILY`, `PLAYER`)
    SetRelationshipBetweenGroups(0, `AMBIENT_GANG_BALLAS`, `PLAYER`)
    SetRelationshipBetweenGroups(0, `AMBIENT_GANG_MARABUNTE`, `PLAYER`)
    SetRelationshipBetweenGroups(0, `AMBIENT_GANG_CULT`, `PLAYER`)
    SetRelationshipBetweenGroups(0, `AMBIENT_GANG_SALVA`, `PLAYER`)
    SetRelationshipBetweenGroups(0, `AMBIENT_GANG_WEICHENG`, `PLAYER`)
    SetRelationshipBetweenGroups(0, `AMBIENT_GANG_HILLBILLY`, `PLAYER`)

    for i = 1, 15 do
        EnableDispatchService(i, false)
    end
end)

--[[
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) 
        if (not IsPedArmed(PlayerPedId(), 1)) and (GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey('weapon_unarmed')) then
    
            DisableControlAction(0, 140, true) 
            DisableControlAction(0, 141, true) 
            DisableControlAction(0, 142, true) 
        
        end
    end
end)
--]]