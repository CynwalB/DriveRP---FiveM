local DoorInfo = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('SneakylockedDoors:updateState')
AddEventHandler('SneakylockedDoors:updateState', function(doorID, state, doorJob)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerEvent("ratelimit", source, "SneakylockedDoors:updateState")

	if xPlayer.job.name ~= doorJob and xPlayer.job2.name ~= doorJob then
		return
	end

	DoorInfo[doorID] = {}
	DoorInfo[doorID].state = state
	DoorInfo[doorID].doorID = doorID

	TriggerClientEvent('SneakylockedDoors:setState', -1, doorID, state)
end)

ESX.RegisterServerCallback('SneakylockedDoors:getDoorInfo', function(source, cb)
	local amount = 0

	for i = 1, #Config.DoorList, 1 do
		amount = amount + 1
	end

	cb(DoorInfo, amount)
end)