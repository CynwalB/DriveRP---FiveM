ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

ESX.RegisterServerCallback("esx_inventoryhud:getPlayerInventory", function(source, cb, target)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if targetXPlayer ~= nil then
		cb({inventory = targetXPlayer.inventory, money = targetXPlayer.getAccount("cash").money, dirtycash = targetXPlayer.getAccount("dirtycash").money, weapons = targetXPlayer.loadout})
	else
		cb(nil)
	end
end)

RegisterServerEvent('Neo:deleteitem')
AddEventHandler('Neo:deleteitem', function(supprimer)
    MySQL.Async.execute('DELETE FROM players_clothesitem WHERE id = @id', { 
        ['@id'] = supprimer 
    }) 
end)

RegisterServerEvent('SneakyLife:ChangeName')
AddEventHandler('SneakyLife:ChangeName', function(id, Actif)   
	MySQL.Sync.execute('UPDATE players_clothesitem SET nom = @nom WHERE id = @id', {
		['@id'] = id,   
		['@nom'] = Actif        
	})
end) 

RegisterServerEvent("esx_inventoryhud:tradePlayerItem")
AddEventHandler("esx_inventoryhud:tradePlayerItem",	function(from, target, type, itemName, itemCount)
	local _source = from

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if type == "item_standard" then
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)
		local targetItem = targetXPlayer.getInventoryItem(itemName)

		if itemCount > 0 and sourceItem.count >= itemCount then
			if targetXPlayer.canCarryItem(itemName, itemCount) then
				local xItem = xPlayer.getInventoryItem(itemName)

				sourceXPlayer.removeInventoryItem(itemName, itemCount)
				targetXPlayer.addInventoryItem(itemName, itemCount)
				sourceXPlayer.showNotification("On vous a confisqué ~p~x"..itemCount.."~s~ ~p~"..xItem.label.."~s~.")
				targetXPlayer.showNotification("Vous avez confisqué ~p~x"..itemCount.."~s~ ~p~"..xItem.label.."~s~.")
				exports.sCore:SendLogs(1752220,"Fouiller item","**"..GetPlayerName(_source).."** vient de confisquer/prendre ***"..type.."*** de ***"..item.label.."*** : ***"..itemCount.."*** \n **License de la source** : "..sourceXPlayer.identifier.."\n **License du joueur** : "..targetXPlayer.identifier,"https://discord.com/api/webhooks/1151182751144353855/l9AMvIAWRN-VKwnqciyUTqSuorNvsIt47ct3r3GnEQpXlbFbBps1Ttv3InC05339u1vM")
			else
				TriggerClientEvent('esx:showNotification', targetXPlayer.source, "~r~Vous n'avez pas assez de place sur vous.")
				TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "~r~La personne n'a pas assez de place.")
			end
		end
	elseif type == "item_money" then
		if itemCount > 0 and sourceXPlayer.getAccount(itemName).money >= itemCount then
			local accountLabel = ESX.GetAccountLabel(itemName)
			sourceXPlayer.removeAccountMoney(itemCount)
			targetXPlayer.addAccountMoney(itemCount)
			sourceXPlayer.showNotification("On vous a confisqué ~p~"..ESX.Math.GroupDigits(itemCount).."~p~$~s~ ("..accountLabel..").")
			targetXPlayer.showNotification("Vous avez confisqué ~p~"..ESX.Math.GroupDigits(itemCount).."~p~$~s~ ("..accountLabel..").")
			exports.sCore:SendLogs(1752220,"Fouiller argent","**"..GetPlayerName(_source).."** vient de confisquer/prendre ***"..type.."*** de ***"..item.label.."*** : ***"..itemCount.."*** \n **License de la source** : "..sourceXPlayer.identifier.."\n **License du joueur** : "..targetXPlayer.identifier,"https://discord.com/api/webhooks/1151182751144353855/l9AMvIAWRN-VKwnqciyUTqSuorNvsIt47ct3r3GnEQpXlbFbBps1Ttv3InC05339u1vM")
		end
	elseif type == "item_account" then
		if itemCount > 0 and sourceXPlayer.getAccount(itemName).money >= itemCount then
			local accountLabel = ESX.GetAccountLabel(itemName)
			sourceXPlayer.removeAccountMoney(itemName, itemCount)
			targetXPlayer.addAccountMoney(itemName, itemCount)
			sourceXPlayer.showNotification("On vous a confisqué ~p~"..ESX.Math.GroupDigits(itemCount).."~p~$~s~ ("..accountLabel..").")
			targetXPlayer.showNotification("Vous avez confisqué ~p~"..ESX.Math.GroupDigits(itemCount).."~p~$~s~ ("..accountLabel..").")
			exports.sCore:SendLogs(1752220,"Fouiller argent","**"..GetPlayerName(_source).."** vient de confisquer/prendre ***"..type.."*** de ***"..item.label.."*** : ***"..itemCount.."*** \n **License de la source** : "..sourceXPlayer.identifier.."\n **License du joueur** : "..targetXPlayer.identifier,"https://discord.com/api/webhooks/1151182751144353855/l9AMvIAWRN-VKwnqciyUTqSuorNvsIt47ct3r3GnEQpXlbFbBps1Ttv3InC05339u1vM")
		end
	elseif type == "item_weapon" then
		local weaponLabel = ESX.GetWeaponLabel(itemName)
		if sourceXPlayer.hasWeapon(itemName) then
			if not targetXPlayer.hasWeapon(itemName) then
				sourceXPlayer.removeWeapon(itemName)
				targetXPlayer.addWeapon(itemName, itemCount)
				sourceXPlayer.showNotification("On vous a confisqué ~p~x1~s~ ~p~"..weaponLabel.."~s~.")
				targetXPlayer.showNotification("Vous avez confisqué ~p~x1~s~ ~p~"..weaponLabel.."~s~.")
				exports.sCore:SendLogs(1752220,"Fouiller armes","**"..GetPlayerName(_source).."** vient de confisquer/prendre ***"..type.."*** de ***"..weaponLabel.."*** : ***"..itemCount.."*** \n **License de la source** : "..sourceXPlayer.identifier.."\n **License du joueur** : "..targetXPlayer.identifier,"https://discord.com/api/webhooks/1151182751144353855/l9AMvIAWRN-VKwnqciyUTqSuorNvsIt47ct3r3GnEQpXlbFbBps1Ttv3InC05339u1vM")
			else
				TriggerClientEvent('esx:showNotification', targetXPlayer.source, "~r~Vous avez déjà cette arme sur vous.")
			end
		end
	end
end)

RegisterNetEvent("sPolice:OpenPlayerInventory")
AddEventHandler("sPolice:OpenPlayerInventory", function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "police" or xPlayer.job.name == "lssd" then
		local targetxPlayer = ESX.GetPlayerFromId(target)
		if targetxPlayer then
			TriggerClientEvent("esx_inventoryhud:openPlayerInventory", source, target, targetxPlayer.name)
			exports.sCore:SendLogs(1752220,"Fouiller","**"..GetPlayerName(source).."** vient d'ouvir l'inventaire de ***"..targetxPlayer.name.."*** \n **License de la source** : "..xPlayer.identifier.."\n **License du joueur** : "..targetxPlayer.identifier,"https://discord.com/api/webhooks/1151182751144353855/l9AMvIAWRN-VKwnqciyUTqSuorNvsIt47ct3r3GnEQpXlbFbBps1Ttv3InC05339u1vM")
		end
	else
		exports.sCore:banPlayerAC(xPlayer.source, {
            name = "changestateuser",
            title = "Anticheat : Try to access inventory",
            description = "Anticheat : Try to access inventory"
        })
        return
	end
end)

RegisterNetEvent("sStaff:OpenPlayerInventory")
AddEventHandler("sStaff:OpenPlayerInventory", function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getGroup() ~= "user" then
		local targetxPlayer = ESX.GetPlayerFromId(target)
		if targetxPlayer then
			TriggerClientEvent("esx_inventoryhud:openPlayerInventory", source, target, targetxPlayer.name)
			exports.sCore:SendLogs(1752220,"Fouiller","**"..GetPlayerName(source).."** vient d'ouvir l'inventaire de ***"..targetxPlayer.name.."*** \n **License de la source** : "..xPlayer.identifier.."\n **License du joueur** : "..targetxPlayer.identifier,"https://discord.com/api/webhooks/1151182751144353855/l9AMvIAWRN-VKwnqciyUTqSuorNvsIt47ct3r3GnEQpXlbFbBps1Ttv3InC05339u1vM")
		end
	else
		exports.sCore:banPlayerAC(xPlayer.source, {
            name = "changestateuser",
            title = "Anticheat : Try to access inventory",
            description = "Anticheat : Try to access inventory"
        })
        return
	end
end)

RegisterServerEvent('Sneaky:putStockItems')
AddEventHandler('Sneaky:putStockItems', function(type,itemName, count, job, ammo)
    local xPlayer = ESX.GetPlayerFromId(source)
	if type == "item" then
		TriggerEvent('esx_addoninventory:getSharedInventory', "society_"..job.."", function(inventory)
			local item = inventory.getItem(itemName)
			local countitem = xPlayer.getInventoryItem(itemName).count
			if count <= countitem then
				if item.count >= 0 then
					xPlayer.removeInventoryItem(itemName, count)
					inventory.addItem(itemName, count)
					exports.sCore:SendLogs(1752220,"Déposer coffre item (entreprise/orga)","**"..GetPlayerName(source).."** vient de déposer ***"..type.."*** de ***"..item.label.."*** : ***"..count.."*** dans le coffre : ***"..job.."*** \n **License de la source** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1151182751144353855/l9AMvIAWRN-VKwnqciyUTqSuorNvsIt47ct3r3GnEQpXlbFbBps1Ttv3InC05339u1vM")
					TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez ajouter [~b~x' .. count .. '~s~] ~b~' .. item.label)
				else
					TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~La quantité et invalide.')
				end
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~La quantité et invalide.')
			end
		end)
	elseif type == "weapon" then
		xPlayer.removeWeapon(itemName)
		TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..job, function(store)
			local weapons = store.get('weapons') 
			if weapons == nil then weapons = {} end 
			local foundWeapon = false 
			for i=1, #weapons, 1 do 
				if weapons[i].name == itemName then 
					weapons[i].count = weapons[i].count + 1 foundWeapon = true 
				end 
			end
			if not foundWeapon then 
				table.insert(weapons, {name  = itemName, count = 1, ammo = ammo}) 
			end
			store.set('weapons', weapons)
			TriggerClientEvent("RageUI:Popup", source, {message="Vous avez déposer ~b~x1 "..ESX.GetWeaponLabel(itemName)})
			exports.sCore:SendLogs(1752220,"Déposer coffre weapon (entreprise/orga)","**"..GetPlayerName(source).."** vient de déposer ***"..type.."*** de ***"..ESX.GetWeaponLabel(itemName).."*** : ***"..count.."*** dans le coffre : ***"..job.."*** \n **License de la source** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1151182751144353855/l9AMvIAWRN-VKwnqciyUTqSuorNvsIt47ct3r3GnEQpXlbFbBps1Ttv3InC05339u1vM")
		end)
	elseif type == "dirtycash" then
		TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..job, function(store)
			local blackMoney = (store.get('dirtycash')) or 0 
			blackMoney = blackMoney + count 
			xPlayer.removeAccountMoney('dirtycash', count)
			store.set('dirtycash', blackMoney)
			exports.sCore:SendLogs(1752220,"Déposer coffre argent sale (entreprise/orga)","**"..GetPlayerName(source).."** vient de déposer ***"..type.."*** de ***"..item.label.."*** : ***"..count.."*** dans le coffre : ***"..job.."*** \n **License de la source** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1151182751144353855/l9AMvIAWRN-VKwnqciyUTqSuorNvsIt47ct3r3GnEQpXlbFbBps1Ttv3InC05339u1vM")
		end)
--[[	elseif type == "cash" then
		TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..job, function(store)
			local money = (store.get('cash')) or 0 
			money = money + count 
			xPlayer.removeAccountMoney('cash', count)
			store.set('cash', money)
			exports.sCore:SendLogs(1752220,"Déposer coffre argent sale (entreprise/orga)","**"..GetPlayerName(source).."** vient de déposer ***"..type.."*** de ***"..item.label.."*** : ***"..count.."*** dans le coffre : ***"..job.."*** \n **License de la source** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1151182751144353855/l9AMvIAWRN-VKwnqciyUTqSuorNvsIt47ct3r3GnEQpXlbFbBps1Ttv3InC05339u1vM")
		end) --]]
	end
end)

ESX.RegisterServerCallback('Sneaky:getStockItems', function(source, cb, job)
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..job..'', function(inventory)
        a = inventory.items
    end)   
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..job, function(store)
  
		local weapons = store.get('weapons')
		if weapons == nil then
		  weapons = {}
		end
		w = weapons
	end)
	TriggerEvent('esx_datastore:getSharedDataStore','society_'..job,function(store)
		b = 0
		b = (store.get('dirtycash')) or 0
	end) 
--	TriggerEvent('esx_datastore:getSharedDataStore','society_'..job,function(store)
--		b = 0
--		b = (store.get('cash')) or 0
--	end)
	cb(a,w,b)  
end)       

RegisterServerEvent('Sneaky:getStockItem')
AddEventHandler('Sneaky:getStockItem', function(type, itemName, count, job, ammo)
    local xPlayer = ESX.GetPlayerFromId(source)
--	if xPlayer.job.name == "police" then
	if xPlayer.job.grade_name == "boss" or xPlayer.job.grade_name == "lieutenant2" or xPlayer.job.grade_name == "big" or xPlayer.job.grade_name == "small" then
--		end
--	end
--	if xPlayer.job.name == "lssd" then
--		if xPlayer.job.grade_name ~= "sergent" or xPlayer.job.grade_name ~= "lieutenantsheriff" or xPlayer.job.grade_name ~= "ssheriff" or xPlayer.job.grade_name ~= "boss" then
--			return
--			TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez pas la permission de faire ça.")
--		end
--	end
		if type == "item" then
			TriggerEvent('esx_addoninventory:getSharedInventory', "society_"..job.."", function(inventory)
				local item = inventory.getItem(itemName)
				if item.count >= count then
					inventory.removeItem(itemName, count)
					xPlayer.addInventoryItem(itemName, count)
					exports.sCore:SendLogs(1752220,"Retirer coffre item (entreprise/orga)","**"..GetPlayerName(source).."** vient de retirer ***"..type.."*** de ***"..item.label.."*** : ***"..count.."*** dans le coffre : ***"..job.."*** \n **License de la source** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1151182751144353855/l9AMvIAWRN-VKwnqciyUTqSuorNvsIt47ct3r3GnEQpXlbFbBps1Ttv3InC05339u1vM")
					TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez retirer [~b~x' .. count .. '~s~] ~b~' .. item.label)
				else
					TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~La quantité est invalide')
				end
			end)
		elseif type == "weapon" then
			itemName = string.upper(itemName)
			if xPlayer.hasWeapon(itemName) then
				TriggerClientEvent("esx:showNotification",source,"Vous ne pouvez pas prendre deux fois la même ~r~arme~s~.")
			else
				xPlayer.addWeapon(itemName, ammo)
				TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..job, function(store)
					local weapons = store.get('weapons')
					if weapons == nil then weapons = {} end
					local foundWeapon = false
					for i=1, #weapons, 1 do 
						if weapons[i].name == itemName then 
							weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
							table.remove(weapons, i)
							foundWeapon = true 
							break 
						end 
					end 
					if not foundWeapon then 
						table.insert(weapons, {name  = itemName, count = 0})
					end
					store.set('weapons', weapons)
					TriggerClientEvent("RageUI:Popup", source, {message="Vous avez récupérer ~b~x1 "..ESX.GetWeaponLabel(itemName)})
					exports.sCore:SendLogs(1752220,"Retirer coffre weapon (entreprise/orga)","**"..GetPlayerName(source).."** vient de retirer ***"..type.."*** de ***"..ESX.GetWeaponLabel(itemName).."*** : ***"..count.."*** dans le coffre : ***"..job.."*** \n **License de la source** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1151182751144353855/l9AMvIAWRN-VKwnqciyUTqSuorNvsIt47ct3r3GnEQpXlbFbBps1Ttv3InC05339u1vM")
				end)
			end
		elseif type == "dirtycash" then
			TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..job, function(store)
				local blackMoney = (store.get('dirtycash')) or 0 
				if count <= blackMoney then 
					xPlayer.addAccountMoney('dirtycash', count) 
					blackMoney = blackMoney - count
					store.set('dirtycash', blackMoney) 
					TriggerClientEvent("RageUI:Popup", source, {message="Vous avez pris : "..count}) 
					exports.sCore:SendLogs(1752220,"Retirer coffre argent sale (entreprise/orga)","**"..GetPlayerName(source).."** vient de retirer ***"..type.."*** de ***"..item.label.."*** : ***"..count.."*** dans le coffre : ***"..job.."*** \n **License de la source** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1151182751144353855/l9AMvIAWRN-VKwnqciyUTqSuorNvsIt47ct3r3GnEQpXlbFbBps1Ttv3InC05339u1vM")
				else
					TriggerClientEvent("RageUI:Popup", source, {message="Il n'y a pas assez d'argent"}) 
				end
			end)
--[[		elseif type == "cash" then
			TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..job, function(store)
				local money = (store.get('cash')) or 0 
				if count <= money then 
					xPlayer.addAccountMoney('cash', count) 
					money = money - count
					store.set('cash', money) 
					TriggerClientEvent("RageUI:Popup", source, {message="Vous avez pris : "..count}) 
					exports.sCore:SendLogs(1752220,"Retirer coffre argent sale (entreprise/orga)","**"..GetPlayerName(source).."** vient de retirer ***"..type.."*** de ***"..item.label.."*** : ***"..count.."*** dans le coffre : ***"..job.."*** \n **License de la source** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1151182751144353855/l9AMvIAWRN-VKwnqciyUTqSuorNvsIt47ct3r3GnEQpXlbFbBps1Ttv3InC05339u1vM")
				else
					TriggerClientEvent("RageUI:Popup", source, {message="Il n'y a pas assez d'argent"}) 
				end
			end) --]]
		end
	else 
		TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez pas la permission de faire ça.")
	end 
end)   

