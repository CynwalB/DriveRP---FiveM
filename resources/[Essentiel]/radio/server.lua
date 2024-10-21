ESX = nil
TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

ESX.RegisterUsableItem('radio', function(source)
	TriggerClientEvent('Sneaky:useradio', source)
end)

RegisterNetEvent('getRadioCount')
AddEventHandler('getRadioCount', function(id)
	local xPlayer = ESX.GetPlayerFromId(id)
	if xPlayer ~= nil then
		TriggerClientEvent('radioCount', id, xPlayer.getInventoryItem("radio").count)
	end
end)