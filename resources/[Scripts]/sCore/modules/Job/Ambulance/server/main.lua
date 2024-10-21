TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'ambulance', 'Alerte Ambulance', true, true)
TriggerEvent('esx_society:registerSociety', 'ambulance', 'ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})


RegisterServerEvent("sAmbulance:addLicense")
AddEventHandler("sAmbulance:addLicense", function(target, license)
	local _src = source
	--TriggerEvent("ratelimit", _src, "sPolice:addLicense")
	if source then
		local xPlayer, tPlayer = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(target)
		TriggerEvent('esx_license:addLicense', target, license, function()
			TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous avez donné une carte ~q~d'ambulancier~s~ à ~q~"..tPlayer.getName())
			TriggerClientEvent("esx:showNotification", tPlayer.source, "~q~"..xPlayer.getName().."~s~ vous a attribué votre carte ~q~d'ambulancier~s~ !")
		end)
	end
end)

RegisterServerEvent("sAmbulance:removeLicense")
AddEventHandler("sAmbulance:removeLicense", function(target, license)
	local _src = source
	--TriggerEvent("ratelimit", _src, "sPolice:addLicense")
	if source then
		local xPlayer, tPlayer = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(target)
		TriggerEvent('esx_license:removeLicense', target, license, function()
			TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous avez retiré une carte ~q~d'ambulancier~s~ à ~q~"..tPlayer.getName())
			TriggerClientEvent("esx:showNotification", tPlayer.source, "~q~"..xPlayer.getName().."~s~ vous a retiré votre carte ~q~d'ambulancier~s~ !")
		end)
	end
end)

RegisterServerEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function(target)
    TriggerEvent("ratelimit", source, "esx_ambulancejob:revive")
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'ambulance' then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : revive",
			description = "Anticheat : revive"
		})
		return
	end
	if target == -1 then
		return
	end
	local sourcePed = GetPlayerPed(source)
	local targetPed = GetPlayerPed(target)

	if #(GetEntityCoords(sourcePed) - GetEntityCoords(targetPed)) < 3.0 and GetEntityHealth(targetPed) <= 0.0 then
		TriggerClientEvent('SneakyLife:RevivePlayer', target)
	end
end)

RegisterServerEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(target, type)
	local _src = source
    --TriggerEvent("ratelimit", _src, "esx_ambulancejob:heal")
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "ambulance" then
		if target ~= -1 then
			TriggerClientEvent('esx_ambulancejob:heal', target, type)
		end
	end
end)

TriggerEvent('esx_society:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})

ESX.RegisterServerCallback('esx_ambulancejob:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local count = xPlayer.getInventoryItem(item).count
	cb(count)
end)

RegisterServerEvent('esx_ambulancejob:removeItem')
AddEventHandler('esx_ambulancejob:removeItem', function(item)
	local _src = source
    --TriggerEvent("ratelimit", _src, "esx_ambulancejob:removeItem")
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' and (item == 'medikit' or item == 'bandage') then
		xPlayer.removeInventoryItem(item, 1)
	end
end)

RestockItems = {
	{label = "Prendre medikit", rightlabel = {('medikit')}, value = 'medikit'},
	{label = "Prendre bandage", rightlabel = {('bandage')}, value = 'bandage'},
	{label = "Prendre perfusion", rightlabel = {('perfusion')}, value = 'perfusion'},
	{label = "Prendre fauteuil roulant", rightlabel = {('wheelchair')}, value = 'wheelchair'},
	{label = "Prendre lit", rightlabel = {('bed')}, value = 'bed'},
}

RegisterServerEvent('esx_ambulancejob:giveItem')
AddEventHandler('esx_ambulancejob:giveItem', function(itemName)
	local _src = source
    --TriggerEvent("ratelimit", _src, "esx_ambulancejob:giveItem")
	local xPlayer = ESX.GetPlayerFromId(source)
	local itemAvailable = false

	for i = 1, #RestockItems, 1 do
		if RestockItems[i].value == itemName then
			itemAvailable = true
		end
	end

	if itemAvailable and xPlayer.job.name == 'ambulance' then
		if xPlayer.canCarryItem(itemName, 1) then
			xPlayer.addInventoryItem(itemName, 1)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, 'vous en portez déjà assez sur vous.')
		end
	end
end)

ESX.RegisterUsableItem('medikit', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('medikit', 1)

	TriggerClientEvent('esx_ambulancejob:heal', xPlayer.source, 'big')
	TriggerClientEvent('esx:showNotification', xPlayer.source, 'vous avez utilisé 1x kit de soin')
end)

ESX.RegisterUsableItem('bandage', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bandage', 1)

	TriggerClientEvent('esx_ambulancejob:heal', xPlayer.source, 'small')
	TriggerClientEvent('esx:showNotification', xPlayer.source, 'vous avez utilisé 1x bandage')
end)
RegisterServerEvent("sComa:RequestDeadStatut")
AddEventHandler('sComa:RequestDeadStatut', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchScalar("SELECT dead FROM users WHERE identifier = @identifier", { 
        ['@identifier'] = xPlayer.identifier,
        },function(result)
		print(result)
        if result == 1 then
            TriggerClientEvent('SneakyLife:RequestDeath', xPlayer.source)
        end
    end)
end)

RegisterServerEvent("Sneaky:DeadPlayer")
AddEventHandler('Sneaky:DeadPlayer', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute('UPDATE users SET dead = @dead WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier,
		['@dead'] = 1
	})
end)

RegisterServerEvent("Sneaky:StopDeadPlayer")
AddEventHandler('Sneaky:StopDeadPlayer', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute('UPDATE users SET dead = @dead WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier,
		['@dead'] = 0
	})
end)

RegisterServerEvent('Ems:DemandeRdv')
AddEventHandler('Ems:DemandeRdv', function(ginfo)
	local _src = source
    --TriggerEvent("ratelimit", _src, "Ems:DemandeRdv")
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'ambulance' then
			TriggerClientEvent('Ems:Rdv', xPlayers[i],ginfo)
		end
	end
end)

ESX.RegisterServerCallback("EMS:PlayerIsDead", function(source, cb, ply)
	local idd = ESX.GetPlayerFromId(ply).identifier

	MySQL.Async.fetchScalar('SELECT dead FROM users WHERE identifier = @identifier', {
		['@identifier'] = idd
	}, function(dead)
		if dead == 1 then
			cb(true)
		elseif dead == 0 then
			cb(false)
		end
	end)
end)

RegisterCommand("revive", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "user" then return TriggerClientEvent("esx:showNotification", xPlayer.source, "~r~Vous n'avez pas accès à cette commande !") end 
    if args[1] ~= nil then
            TriggerClientEvent('SneakyLife:RevivePlayerStaff', tonumber(args[1]))
        else
            TriggerClientEvent('SneakyLife:RevivePlayerStaff', source)
        end
		TriggerEvent('esx:restoreLoadout')
end, false)

RegisterServerEvent('EMS:RevivePLayer')
AddEventHandler('EMS:RevivePLayer', function(trg)
	local _src = source
    --TriggerEvent("ratelimit", _src, "EMS:RevivePLayer")
	if trg ~= -1 then
		TriggerClientEvent('SneakyLife:RevivePlayer', trg)
	end
end)

RegisterNetEvent('esx_ambulancejob:payrevive')
AddEventHandler('esx_ambulancejob:payrevive', function(money)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeAccountMoney('cash', money)
	TriggerEvent('esx_addonaccount:getSharedAccount', "society_ambulance", function(account)
		account.addMoney(money)
	end)
end)

ESX.RegisterUsableItem('wheelchair', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem("wheelchair", 1)
	TriggerClientEvent('sCore:useChair', _source)
end)

ESX.RegisterUsableItem('bed', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem("bed", 1)
	TriggerClientEvent('sCore:useBed', _source)
end)

RegisterServerEvent("sCore:wheelchair")
AddEventHandler('sCore:wheelchair', function(item_name)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name ~= "ambulance" then
		banPlayerAC(xPlayer.source, {
			name = "createentity",
			title = "Give d'item : ("..item_name..")",
			description = "Give d'item : ("..item_name..")"
		})
	else
		if item_name ~= "wheelchair" then
			banPlayerAC(xPlayer.source, {
				name = "createentity",
				title = "Give d'item : ("..item_name..")",
				description = "Give d'item : ("..item_name..")"
			})
		else
			if xPlayer.canCarryItem("wheelchair", 1) then
				local itemchair = xPlayer.getInventoryItem("wheelchair").count
				if itemchair == 0 then
					xPlayer.addInventoryItem("wheelchair", 1)
				end
			else
				TriggerClientEvent("esx:showNotification",source,"~r~Vous ne pouvez pas prendre ça sur vous.")
			end
		end	
	end
end)

RegisterNetEvent('sCore:bedSystem')
AddEventHandler('sCore:bedSystem', function(item_name)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name ~= "ambulance" then
		banPlayerAC(xPlayer.source, {
			name = "createentity",
			title = "Give d'item : ("..item_name..")",
			description = "Give d'item : ("..item_name..")"
		})
	else
		if item_name ~= "bed" then
			banPlayerAC(xPlayer.source, {
				name = "createentity",
				title = "Give d'item : ("..item_name..")",
				description = "Give d'item : ("..item_name..")"
			})
		else
			if xPlayer.canCarryItem("bed", 1) then
				local itemchair = xPlayer.getInventoryItem("bed").count
				if itemchair == 0 then
					xPlayer.addInventoryItem("bed", 1)
				end
			else
				TriggerClientEvent("esx:showNotification",source,"~r~Vous ne pouvez pas prendre ça sur vous.")
			end
		end	
	end
end)

ESX.RegisterServerCallback('sComa:CheckAmbulance', function(source, cb)
    local ambulance = 0
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'ambulance' then
            ambulance = ambulance + 1
        end
    end
    if ambulance < 5 then
        cb(true)
    else
        cb(false)
    end
end)