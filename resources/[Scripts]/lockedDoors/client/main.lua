_NetworkExplodeVehicle = NetworkExplodeVehicle
_AddExplosion = AddExplosion
SneakyEvent = TriggerServerEvent
local PlayerData = {}

local displayText = _U('unlocked')

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job2 == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

	ESX.TriggerServerCallback('SneakylockedDoors:getDoorInfo', function(doorInfo, doorCount)
		for localID = 1, doorCount do
			if doorInfo[localID] ~= nil then
				Config.DoorList[doorInfo[localID].doorID].locked = doorInfo[localID].state
			end
		end
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	PlayerData.job2 = job2
end)

Citizen.CreateThread(function()
	PinInteriorInMemory(GetInteriorAtCoords(440.84, -983.14, 30.69))

	while true do
		Citizen.Wait(0)
		local plyCoords = GetEntityCoords(PlayerPedId(), false)

		for i = 1, #Config.DoorList do
			local theDoor = Config.DoorList[i]

			if GetDistanceBetweenCoords(plyCoords, theDoor.objCoords, true) < theDoor.distance then
				if PlayerData.job ~= nil or PlayerData.job2 ~= nil then

					if IsControlJustReleased(0, 38) then
						if (PlayerData.job.name == theDoor.job) or (PlayerData.job2.name == theDoor.job) then
							theDoor.locked = not theDoor.locked
							if theDoor.locked == true then
								ESX.ShowNotification("Vous avez ~r~fermer~s~ la porte.")
							else
								ESX.ShowNotification("Vous avez ~g~ouvert~s~ la porte.")
							end
							SneakyEvent('SneakylockedDoors:updateState', i, theDoor.locked, theDoor.job)
						else
							ESX.ShowNotification("~r~Vous n'avez pas les clés de cette porte.")
						end
					end
				end

				FreezeEntityPosition(GetClosestObjectOfType(theDoor.objCoords, 1.0, theDoor.objName, false, false, false), theDoor.locked)
			end
		end
	end
end)

RegisterNetEvent('SneakylockedDoors:setState')
AddEventHandler('SneakylockedDoors:setState', function(doorID, state)
	if type(Config.DoorList[id]) ~= nil then
		Config.DoorList[doorID].locked = state
	end
end)