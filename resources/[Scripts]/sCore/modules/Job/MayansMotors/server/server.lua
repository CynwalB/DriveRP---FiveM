ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'mayansm', "mayansm and Repair's", true, true)
TriggerEvent('esx_society:registerSociety', 'mayansm', 'mayansm', 'society_mayansm', 'society_mayansm', 'society_mayansm', {type = 'public'})

RegisterServerEvent('Sneakymayansm:giveItem')
AddEventHandler('Sneakymayansm:giveItem', function(itemName,price)
	local _src = source
	--TriggerEvent("ratelimit", _src, "Sneakymayansm:giveItem")
	local xPlayer = ESX.GetPlayerFromId(source)
	if #(GetEntityCoords(GetPlayerPed(xPlayer.source))-vector3(79.82740020752,293.66064453125,109.95520019531)) > 1.5 then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : give d'item",
			description = "Anticheat : give d'item"
		})
		return 
	end
	if xPlayer.getAccount('cash').money >= price then
		if xPlayer.canCarryItem(itemName, 1) then
			xPlayer.addInventoryItem(itemName, 1)
			xPlayer.removeAccountMoney('cash', price)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "+1 ~q~"..ESX.GetItemLabel(itemName))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez déjà ~q~1x Kit de réparation~s~ !")
		end
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Vous n'avez pas assez d'argent !")
	end
end)

RegisterServerEvent('mayansm:addAnnounce')
AddEventHandler('mayansm:addAnnounce', function(announce)
	local _src = source
	--TriggerEvent("ratelimit", _src, "mayansm:addAnnounce")
    local _source = source
    local announce = announce
    local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name ~= "mayansm" then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : annonce",
			description = "Anticheat : annonce"
		})
		return  
	end
    TriggerClientEvent("mayansm:targetAnnounce",  -1, announce)
end)