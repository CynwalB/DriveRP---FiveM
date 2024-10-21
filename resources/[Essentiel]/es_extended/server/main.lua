function LoadUser(source, identifier)
	local tasks = {}

	local userData = {
		name = GetPlayerName(source),
		accounts = {},
		job = {},
		job2 = {},
		inventory = {},
		loadout = {}
	}
	if ESX.GetPlayerFromIdentifier(identifier) ~= nil  then
		DropPlayer(source, ('there was an error loading your character!\nError code: identifier-active-ingame\n\nThis error is caused by a player on this server who has the same identifier as you have. Make sure you are not playing on the same Rockstar account.\n\nYour Rockstar identifier: %s'):format(identifier))
	end

	table.insert(tasks, function(cb)
		MySQL.Async.fetchAll('SELECT character_id, permission_group, permission_level, accounts, job, job_grade, job2, job2_grade, inventory, loadout, position FROM users WHERE identifier = @identifier', {
			['@identifier'] = identifier
		}, function(result)
			local job, grade = result[1].job, tostring(result[1].job_grade)
			local job2, grade2 = result[1].job2, tostring(result[1].job2_grade)

			if result[1].character_id then
				userData.character_id = result[1].character_id
			else
				userData.character_id = 0
			end

			if result[1].permission_group then
				userData.permission_group = result[1].permission_group
			else
				userData.permission_group = Config.DefaultGroup
			end

			if result[1].permission_level ~= nil then
				userData.permission_level = result[1].permission_level
			else
				userData.permission_level = Config.DefaultLevel
			end

			if result[1].accounts and result[1].accounts ~= '' then
				local formattedAccounts = json.decode(result[1].accounts) or {}

				for i = 1, #formattedAccounts, 1 do
					if Config.Accounts[formattedAccounts[i].name] == nil then
						print(('[^3WARNING^7] Ignoring invalid account "%s" for "%s"'):format(formattedAccounts[i].name, identifier))
						table.remove(formattedAccounts, i)
					else
						formattedAccounts[i] = {
							name = formattedAccounts[i].name,
							money = formattedAccounts[i].money or 0
						}
					end
				end

				userData.accounts = formattedAccounts
			else
				userData.accounts = {}
			end

			for name, account in pairs(Config.Accounts) do
				local found = false

				for i = 1, #userData.accounts, 1 do
					if userData.accounts[i].name == name then
						found = true
					end
				end

				if not found then
					table.insert(userData.accounts, {
						name = name,
						money = account.starting or 0
					})
				end
			end

			table.sort(userData.accounts, function(a, b)
				return Config.Accounts[a.name].priority < Config.Accounts[b.name].priority
			end)

			if not ESX.DoesJobExist(job, grade) then
				print(('[^3WARNING^7] Ignoring invalid job for %s [job: %s, grade: %s]'):format(identifier, job, grade))
				job, grade = 'unemployed', '0'
			end

			if not ESX.DoesJobExist(job2, grade2) then
				print(('[^3WARNING^7] Ignoring invalid job2 for %s [job: %s, grade: %s]'):format(identifier, job2, grade2))
				job2, grade2 = 'unemployed2', '0'
			end

			local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]
			local job2Object, grade2Object = ESX.Jobs[job2], ESX.Jobs[job2].grades[grade2]

			userData.job.id = jobObject.id
			userData.job.name = jobObject.name
			userData.job.label = jobObject.label

			userData.job.grade = tonumber(grade)
			userData.job.grade_name = gradeObject.name
			userData.job.grade_label = gradeObject.label
			userData.job.grade_salary = gradeObject.salary

			userData.job.skin_male = {}
			userData.job.skin_female = {}

			if gradeObject.skin_male then
				userData.job.skin_male = json.decode(gradeObject.skin_male)
			end

			if gradeObject.skin_female then
				userData.job.skin_female = json.decode(gradeObject.skin_female)
			end

			userData.job2.id = job2Object.id
			userData.job2.name = job2Object.name
			userData.job2.label = job2Object.label

			userData.job2.grade = tonumber(grade2)
			userData.job2.grade_name = grade2Object.name
			userData.job2.grade_label = grade2Object.label
			userData.job2.grade_salary = grade2Object.salary

			userData.job2.skin_male = {}
			userData.job2.skin_female = {}

			if grade2Object.skin_male then
				userData.job2.skin_male = json.decode(grade2Object.skin_male)
			end

			if grade2Object.skin_female then
				userData.job2.skin_female = json.decode(grade2Object.skin_female)
			end

			if result[1].inventory and result[1].inventory ~= '' then
				local formattedInventory = json.decode(result[1].inventory) or {}

				for i = 1, #formattedInventory, 1 do
					if ESX.Items[formattedInventory[i].name] == nil then
						print(('[^3WARNING^7] Ignoring invalid item "%s" for "%s"'):format(formattedInventory[i].name, identifier))
						table.remove(formattedInventory, i)
					else
						formattedInventory[i] = {
							name = formattedInventory[i].name,
							count = formattedInventory[i].count,
							label = ESX.Items[formattedInventory[i].name].label or 'Undefined',
							weight = ESX.Items[formattedInventory[i].name].weight or 1.0,
							canRemove = ESX.Items[formattedInventory[i].name].canRemove or false,
							unique = ESX.Items[formattedInventory[i].name].unique or false,
							extra = ESX.Items[formattedInventory[i].name].unique and (formattedInventory[i].extra or {}) or nil
						}
					end
				end

				userData.inventory = formattedInventory
			else
				userData.inventory = {}
			end

			table.sort(userData.inventory, function(a, b)
				return ESX.Items[a.name].label <  ESX.Items[b.name].label
			end)

			if result[1].loadout and result[1].loadout ~= '' then
				local formattedLoadout = json.decode(result[1].loadout) or {}

				for i = 1, #formattedLoadout, 1 do
					if formattedLoadout[i].components == nil then
						formattedLoadout[i].components = {}
					end
				end

				userData.loadout = formattedLoadout
			else
				userData.loadout = {}
			end

			table.sort(userData.loadout, function(a, b)
				return ESX.GetWeaponLabel(a.name) < ESX.GetWeaponLabel(b.name)
			end)

			if result[1].position and result[1].position ~= '' then
				local formattedPosition = json.decode(result[1].position)
				userData.lastPosition = ESX.Vector(formattedPosition)
			else
				userData.lastPosition = Config.DefaultPosition
			end

			cb()
		end)
	end)
	-- Run Tasks
	Async.parallel(tasks, function(results)
		local xPlayer = CreatePlayer(source, identifier, userData)
		ESX.Players[source] = xPlayer

		TriggerEvent('esx:playerLoaded', source, xPlayer)

		xPlayer.triggerEvent('esx:playerLoaded', {
			character_id = xPlayer.character_id,
			identifier = xPlayer.identifier,
			accounts = xPlayer.getAccounts(),
			level = xPlayer.getLevel(),
			group = xPlayer.getGroup(),
			job = xPlayer.getJob(),
			job2 = xPlayer.getJob2(),
			inventory = xPlayer.getInventory(),
			loadout = xPlayer.getLoadout(),
			lastPosition = xPlayer.getLastPosition(),
			maxWeight = xPlayer.maxWeight
		})

		xPlayer.triggerEvent('esx:createMissingPickups', ESX.Pickups)
		xPlayer.triggerEvent('chat:addSuggestions', ESX.CommandsSuggestions)
	end)
end

function RegisterUser(source, identifier)
	ESX.DB.DoesUserExist(identifier, function(exists)
		if exists then
			LoadUser(source, identifier)
		else
			ESX.DB.CreateUser(identifier, function()
				LoadUser(source, identifier)
			end)
		end
	end)
end

AddEventHandler('playerDropped', function(reason)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer then
		ESX.SyncPosition()
		TriggerEvent('esx:playerDropped', _source, xPlayer, reason)
		ESX.SavePlayer(xPlayer, function()
			ESX.Players[_source] = nil
		end)
	end
end)

RegisterServerEvent('esx:firstJoinProper')
AddEventHandler('esx:firstJoinProper', function()
	local _source = source

	Citizen.CreateThread(function()
		local identifier = ESX.GetIdentifierFromId(_source)

		if identifier then
			RegisterUser(_source, identifier)
		else
			DropPlayer(_source, "Impossible de vous identifier, merci de réouvrir FiveM.")
		end
	end)
end)

RegisterServerEvent('esx:giveInventoryItem')
AddEventHandler('esx:giveInventoryItem', function(target, type, itemName, itemCount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	TriggerEvent("ratelimit", source, "esx:giveInventoryItem")

	if type == 'item_standard' then
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		if itemCount > 0 and sourceItem.count >= itemCount then
			if targetXPlayer.canCarryItem(itemName, itemCount) then
				sourceXPlayer.removeInventoryItem(itemName, itemCount)
				targetXPlayer.addInventoryItem(itemName, itemCount)

--				sourceXPlayer.TriggerClientEvent('give:animation', _source)
--				targetXPlayer.TriggerClientEvent('givetarget:animation', _source)

				sourceXPlayer.showNotification("Vous avez donné ~p~x"..itemCount.."~s~ ~p~"..ESX.Items[itemName].label.."~s~.")
				targetXPlayer.showNotification("Vous avez reçu ~p~x"..itemCount.."~s~ ~p~"..ESX.Items[itemName].label.."~s~.")
				exports.sCore:SendLogs(1752220,"Transaction - Item","**"..sourceXPlayer.name.."** vient de donné ***"..itemCount.." "..ESX.Items[itemName].label.." à "..targetXPlayer.name.."***\n **License** : "..sourceXPlayer.identifier.."\n**License du receveur** :"..targetXPlayer.identifier,"https://discord.com/api/webhooks/1003399345070166176/Gujg_NxLphn0lr075_xT2NieVKWtyTk_hpfRP2nUv0LNCTFi5C8ggHHROyv4DYuSHWS-")
				exports.sCore:SendLogs(1752220,"Transaction - Item","**"..targetXPlayer.name.."** vient de recevoir ***"..itemCount.." "..ESX.Items[itemName].label.." de "..sourceXPlayer.name.."***\n **License** : "..targetXPlayer.identifier.."\n**License du donneur** :"..sourceXPlayer.identifier,"https://discord.com/api/webhooks/1003399345070166176/Gujg_NxLphn0lr075_xT2NieVKWtyTk_hpfRP2nUv0LNCTFi5C8ggHHROyv4DYuSHWS-")
			else
				TriggerClientEvent('esx:showNotification', targetXPlayer.source, "~r~Vous n'avez pas assez de place sur vous.")
				TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "~r~La personne n'a pas assez de place.")
				return targetXPlayer.canCarryItem(itemName, itemCount)
				--TriggerClientEvent('esx:showNotification', targetXPlayer.source, "~r~Vous n'avez pas assez de place sur vous.")
				--TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "~r~La personne n'a pas assez de place.")
			end
		else
			sourceXPlayer.showNotification("~r~Erreur !\n~s~Quantité invalide.")
		end
	elseif type == 'item_account' then
		if itemCount > 0 and sourceXPlayer.getAccount(itemName).money >= itemCount then
			local accountLabel = ESX.GetAccountLabel(itemName)

			sourceXPlayer.removeAccountMoney(itemName, itemCount)
			targetXPlayer.addAccountMoney(itemName, itemCount)

--			sourceXPlayer.TriggerClientEvent('give:animation', _source)
--			targetXPlayer.TriggerClientEvent('givetarget:animation', _source)

			sourceXPlayer.showNotification("Vous avez donné ~p~"..ESX.Math.GroupDigits(itemCount).."~p~$~s~ ("..accountLabel..").")
			targetXPlayer.showNotification("Vous avez reçu ~p~"..ESX.Math.GroupDigits(itemCount).."~p~$~s~ ("..accountLabel..").")
			exports.sCore:SendLogs(1752220,"Transaction - Argent","**"..targetXPlayer.name.."** vient de recevoir ***"..ESX.Math.GroupDigits(itemCount).."$ "..accountLabel.." de "..sourceXPlayer.name.."***\n **License** : "..targetXPlayer.identifier.."\n**License du donneur** :"..sourceXPlayer.identifier,"https://discord.com/api/webhooks/1003399345070166176/Gujg_NxLphn0lr075_xT2NieVKWtyTk_hpfRP2nUv0LNCTFi5C8ggHHROyv4DYuSHWS-")
			exports.sCore:SendLogs(1752220,"Transaction - Argent","**"..sourceXPlayer.name.."** vient de donné ***"..ESX.Math.GroupDigits(itemCount).."$ "..accountLabel.." à "..targetXPlayer.name.."***\n **License** : "..sourceXPlayer.identifier.."\n**License du receveur** :"..targetXPlayer.identifier,"https://discord.com/api/webhooks/1003399345070166176/Gujg_NxLphn0lr075_xT2NieVKWtyTk_hpfRP2nUv0LNCTFi5C8ggHHROyv4DYuSHWS-")
		else
			sourceXPlayer.showNotification("~r~Erreur~s~\nMontant invalide.")
		end
	elseif type == 'item_weapon' then
		itemName = string.upper(itemName)

		if sourceXPlayer.hasWeapon(itemName) then
			local weaponLabel = ESX.GetWeaponLabel(itemName)

			if not targetXPlayer.hasWeapon(itemName) then
				local weaponNum, weapon = sourceXPlayer.getWeapon(itemName)
				itemCount = weapon.ammo

				sourceXPlayer.removeWeapon(itemName)
				targetXPlayer.addWeapon(itemName, itemCount)

--				sourceXPlayer.TriggerClientEvent('give:animation', _source)
--				targetXPlayer.TriggerClientEvent('givetarget:animation', _source)

				if itemCount > 0 then
					sourceXPlayer.showNotification("Vous avez donné ~p~x1~s~ ~p~"..weaponLabel.."~s~ avec ~p~("..itemCount..")~s~ balles~s~.")
					targetXPlayer.showNotification("Vous avez reçu ~p~x1~s~ ~p~"..weaponLabel.."~s~ avec ~p~("..itemCount..")~s~ balles~s~.")
					exports.sCore:SendLogs(1752220,"Transaction - Arme","**"..sourceXPlayer.name.."** vient de donné ***"..ESX.GetWeaponLabel(itemName).." à "..targetXPlayer.name.."***\n **License** : "..sourceXPlayer.identifier.."\n**License du receveur** :"..targetXPlayer.identifier,"https://discord.com/api/webhooks/1003399345070166176/Gujg_NxLphn0lr075_xT2NieVKWtyTk_hpfRP2nUv0LNCTFi5C8ggHHROyv4DYuSHWS-")
					exports.sCore:SendLogs(1752220,"Transaction - Arme","**"..targetXPlayer.name.."** vient de recevoir ***"..ESX.GetWeaponLabel(itemName).." de "..sourceXPlayer.name.."***\n **License** : "..targetXPlayer.identifier.."\n**License du donneur** :"..sourceXPlayer..identifier,"https://discord.com/api/webhooks/1003399345070166176/Gujg_NxLphn0lr075_xT2NieVKWtyTk_hpfRP2nUv0LNCTFi5C8ggHHROyv4DYuSHWS-")
				else
					sourceXPlayer.showNotification("Vous avez donné ~p~x1~s~ ~p~"..weaponLabel.."~s~.")
					targetXPlayer.showNotification("Vous avez reçu ~p~x1~s~ ~p~"..weaponLabel.."~s~.")
					exports.sCore:SendLogs(1752220,"Transaction - Arme","**"..sourceXPlayer.name.."** vient de donné ***"..ESX.GetWeaponLabel(itemName).." à "..targetXPlayer.name.."***\n **License** : "..sourceXPlayer.identifier.."\n**License du receveur** :"..targetXPlayer.identifier,"https://discord.com/api/webhooks/1003399345070166176/Gujg_NxLphn0lr075_xT2NieVKWtyTk_hpfRP2nUv0LNCTFi5C8ggHHROyv4DYuSHWS-")
					exports.sCore:SendLogs(1752220,"Transaction - Arme","**"..targetXPlayer.name.."** vient de recevoir ***"..ESX.GetWeaponLabel(itemName).." de "..sourceXPlayer.name.."***\n **License** : "..targetXPlayer.identifier.."\n**License du donneur** :"..sourceXPlayer..identifier,"https://discord.com/api/webhooks/1003399345070166176/Gujg_NxLphn0lr075_xT2NieVKWtyTk_hpfRP2nUv0LNCTFi5C8ggHHROyv4DYuSHWS-")
				end
			else
				sourceXPlayer.showNotification("~r~Attention !\n~s~La personne possède déjà l'arme ~p~"..weaponLabel.."~s~.")
				targetXPlayer.showNotification("~r~Attention !\n~s~Vous possédez déjà l'arme ~p~"..weaponLabel.."~s~.")
			end
		end
	elseif type == 'item_ammo' then
		itemName = string.upper(itemName)

		if sourceXPlayer.hasWeapon(itemName) then
			local weaponNum, weapon = sourceXPlayer.getWeapon(itemName)

			if targetXPlayer.hasWeapon(itemName) then
				if weapon.ammo >= itemCount then
					sourceXPlayer.removeWeaponAmmo(itemName, itemCount)
					targetXPlayer.addWeaponAmmo(itemName, itemCount)
					sourceXPlayer.showNotification("Vous avez donné ~p~x"..itemCount.."~s~ balles pour ~p~"..weapon.label.."~s~.")
					targetXPlayer.showNotification("Vous avez reçu ~p~x"..itemCount.."~s~ balles pour ~p~"..weapon.label.."~s~.")
				end
			else
				sourceXPlayer.showNotification("~r~La personne ne possède pas cette arme.")
				targetXPlayer.showNotification("~r~Attention~s~\nUne personne tente de vous donner des munitions mais bous n'avez pas l'arme.")
			end
		end
	end
end)

RegisterServerEvent('esx:dropInventoryItem')
AddEventHandler('esx:dropInventoryItem', function(type, itemName, itemCount)
--[[	local _src = source
	--TriggerEvent("ratelimit", _src, "esx:dropInventoryItem")
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if type == 'item_standard' then
		if itemCount == nil or itemCount < 1 then
			xPlayer.showNotification("~r~Quantité invalide.")
		else
			local xItem = xPlayer.getInventoryItem(itemName)

			if (itemCount > xItem.count or xItem.count < 1) then
				xPlayer.showNotification("~r~Quantité invalide.")
			else
				xPlayer.removeInventoryItem(itemName, itemCount)
				exports.sCore:SendLogs(1752220,"Suppression - Item","**"..GetPlayerName(source).."** vient de jeter ***"..ESX.GetItemLabel(itemName).." "..itemCount.."***\n **License** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1003399345070166176/Gujg_NxLphn0lr075_xT2NieVKWtyTk_hpfRP2nUv0LNCTFi5C8ggHHROyv4DYuSHWS-")
				xPlayer.showNotification("Vous avez jeter ~p~"..itemCount.. " " ..ESX.Items[itemName].label)
			end
		end
	elseif type == 'item_account' then
		if itemCount == nil or itemCount < 1 then
			xPlayer.showNotification("~r~Somme invalide.")
		else
			local account = xPlayer.getAccount(itemName)
			local accountLabel = ESX.GetAccountLabel(itemName)

			if (itemCount > account.money or account.money < 1) then
				xPlayer.showNotification("~r~Somme invalide.")
			else
				xPlayer.removeAccountMoney(itemName, itemCount)
				exports.sCore:SendLogs(1752220,"Suppression - Argent","**"..GetPlayerName(_source).."** vient de jeter ***"..ESX.Math.GroupDigits(itemCount).."$ de "..itemName.."***\n **License** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1003399345070166176/Gujg_NxLphn0lr075_xT2NieVKWtyTk_hpfRP2nUv0LNCTFi5C8ggHHROyv4DYuSHWS-")
			end
		end
	elseif type == 'item_weapon' then
		itemName = string.upper(itemName)

		if xPlayer.hasWeapon(itemName) then
			local weaponNum, weapon = xPlayer.getWeapon(itemName)
			xPlayer.removeWeapon(itemName)
			exports.sCore:SendLogs(1752220,"Suppression - Arme","**"..GetPlayerName(source).."** vient de jeter ***"..ESX.GetWeaponLabel(itemName).."***\n **License** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1003399345070166176/Gujg_NxLphn0lr075_xT2NieVKWtyTk_hpfRP2nUv0LNCTFi5C8ggHHROyv4DYuSHWS-")
			if weapon.ammo > 0 then
				xPlayer.showNotification("Vous avez jeté ~p~1x~s~ ~p~"..weapon.label.." avec ~p~("..weapon.ammo..").")
			else
				xPlayer.showNotification("Vous avez jeté ~p~1x~s~ ~p~"..weapon.label.."~s~.")
			end
		end
	end --]]
	local _source = source

	if type == 'item_standard' then

		if itemCount == nil or itemCount < 1 then
--			TriggerClientEvent('esx:showNotification', _source, _U('imp_invalid_quantity'))
			xPlayer.showNotification("~r~Quantité invalide.")
		else
			local xPlayer = ESX.GetPlayerFromId(source)
			local xItem = xPlayer.getInventoryItem(itemName)

			if (itemCount > xItem.count or xItem.count < 1) then
--				TriggerClientEvent('esx:showNotification', _source, _U('imp_invalid_quantity'))
				xPlayer.showNotification("~r~Quantité invalide.")
			else
				xPlayer.removeInventoryItem(itemName, itemCount)
				exports.sCore:SendLogs(1752220,"Drop - Item","**"..GetPlayerName(source).."** vient de jeter ***"..ESX.GetItemLabel(itemName).." "..itemCount.."***\n **License** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1003399345070166176/Gujg_NxLphn0lr075_xT2NieVKWtyTk_hpfRP2nUv0LNCTFi5C8ggHHROyv4DYuSHWS-")
				xPlayer.showNotification("Vous avez jeté ~p~x"..itemCount.. " " ..ESX.Items[itemName].label.."~s~.")
				TriggerClientEvent('drop:animation', _source)
				Citizen.Wait(1500)

				local pickupLabel = ('Appuyez sur ~g~E~s~ pour rammasser\n~g~%s~s~ [~s~%s~s~]'):format(xItem.label, itemCount)
				ESX.CreatePickup('item_standard', itemName, itemCount, pickupLabel, _source)
--				TriggerClientEvent('esx:showNotification', _source, _U('threw_standard', itemCount, xItem.label))
			end
		end

	elseif type == 'item_account' then

		if itemCount == nil or itemCount < 1 then
--			TriggerClientEvent('esx:showNotification', _source, _U('imp_invalid_amount'))
			xPlayer.showNotification("~r~Somme invalide.")
		else
			local xPlayer = ESX.GetPlayerFromId(source)
			local account = xPlayer.getAccount(itemName)

			if (itemCount > account.money or account.money < 1) then
--				TriggerClientEvent('esx:showNotification', _source, _U('imp_invalid_amount'))
				xPlayer.showNotification("~r~Somme invalide.")
			else
				xPlayer.removeAccountMoney(itemName, itemCount)
				exports.sCore:SendLogs(1752220,"Drop - Argent","**"..GetPlayerName(_source).."** vient de jeter ***"..ESX.Math.GroupDigits(itemCount).."$ de "..itemName.."***\n **License** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1003399345070166176/Gujg_NxLphn0lr075_xT2NieVKWtyTk_hpfRP2nUv0LNCTFi5C8ggHHROyv4DYuSHWS-")
				xPlayer.showNotification("Vous avez jeté ~p~"..itemCount.. "$~s~ d'~p~"..ESX.GetAccountLabel(itemName).."~s~.")
				TriggerClientEvent('drop:animation', _source)
				Citizen.Wait(1500)

				local pickupLabel = ('Appuyez sur ~g~E~s~ pour rammasser\n~g~%s~s~ [~s~%s~s~]'):format(ESX.GetAccountLabel(itemName), _U('locale_currency', ESX.Math.GroupDigits(itemCount)))
				ESX.CreatePickup('item_account', itemName, itemCount, pickupLabel, _source)
--				TriggerClientEvent('esx:showNotification', _source, _U('threw_account', ESX.Math.GroupDigits(itemCount), string.lower(account.label)))
			end
		end

	elseif type == 'item_weapon' then

		local xPlayer = ESX.GetPlayerFromId(source)
		local loadout = xPlayer.getLoadout()

		for i=1, #loadout, 1 do
			if loadout[i].name == itemName then
				itemCount = loadout[i].ammo
				break
			end
		end

		if xPlayer.hasWeapon(itemName) then
			local weaponLabel, weaponPickup = ESX.GetWeaponLabel(itemName), 'PICKUP_' .. string.upper(itemName)
			local weapon = xPlayer.getWeapon(itemName)

			TriggerClientEvent('drop:animation', _source)
			xPlayer.removeWeapon(itemName)

			if itemCount > 0 then
				-- TriggerClientEvent('esx:pickupWeapon', _source, weaponPickup, itemName, itemCount)
				local pickupLabel = ('Appuyez sur ~g~E~s~ pour rammasser\n~g~%s~s~ [~s~%s balles~s~]'):format(weaponLabel, itemCount)
				ESX.CreatePickup('item_weapon', itemName, itemCount, pickupLabel, _source)
				xPlayer.showNotification("Vous avez jeté ~p~x1 "..weaponLabel.."~s~ avec ~p~"..itemCount.."~s~ balles.")
			else
				-- TriggerClientEvent('esx:pickupWeapon', _source, weaponPickup, itemName, itemCount)
				local pickupLabel = ('Appuyez sur ~g~E~s~ pour rammasser\n~g~%s~s~'):format(weaponLabel)
				ESX.CreatePickup('item_weapon', itemName, itemCount, pickupLabel, _source)
				xPlayer.showNotification("Vous avez jeté ~p~x1 "..weaponLabel.."~s~ sans balles.")
			end
		end
	end
end)

RegisterServerEvent('esx:useItem')
AddEventHandler('esx:useItem', function(itemName)
	local _src = source
	TriggerEvent("ratelimit", _src, "esx:useItem")
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(itemName)

	if xItem then
		if xItem.count > 0 then
			ESX.UseItem(xPlayer.source, itemName)
			exports.sCore:SendLogs(1752220,"Utilisation - Item","**"..GetPlayerName(source).."** vient d'utiliser ***"..ESX.GetItemLabel(itemName).."***\n **License** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1003399345070166176/Gujg_NxLphn0lr075_xT2NieVKWtyTk_hpfRP2nUv0LNCTFi5C8ggHHROyv4DYuSHWS-")
		else
			xPlayer.showNotification('~r~Erreur~s~\nAction impossible.')
		end
	else
		print('[es_extended] : ' .. xPlayer.source .. "à essayer d'utiliser "..itemName)
	end
end)

RegisterServerEvent('esx:onPickup')
AddEventHandler('esx:onPickup', function(pickupId, xplayer)
	local source 	= source
	local pickup  	= ESX.Pickups[pickupId]
	local xPlayer	= ESX.GetPlayerFromId(source)
	local success
	local money

	TriggerEvent("ratelimit", source, "esx:onPickup")

	if pickup then
		if pickup.type == 'item_standard' then
			if xPlayer.canCarryItem(pickup.name, pickup.count) then
				xPlayer.addInventoryItem(pickup.name, pickup.count)
				money = true
				success = true
			else
				success = false
				local item = xPlayer.getInventoryItem(pickup.name)
				xPlayer.showNotification("Vous n'avez pas assez de place pour ~p~x"..pickup.count.. " " ..item.label.."~s~.")
				return xPlayer.canCarryItem(pickup.name, pickup.count)
			end
		elseif pickup.type == 'item_account' then
			money = false
			success = true
			xPlayer.addAccountMoney(pickup.name, pickup.count)
			xPlayer.showNotification("Vous avez récupéré ~p~"..pickup.count.. "$~s~ d'~p~"..ESX.GetAccountLabel(pickup.name).."~s~.")
		elseif pickup.type == 'item_weapon' then
			local weapon = ESX.GetWeaponLabel(pickup.name)
			if xPlayer.hasWeapon(pickup.name) then
				money = false
				xPlayer.showNotification("Vous avez déjà ~p~x1"..weapon.. "~s~.")
			else
				money = false
				success = true
				xPlayer.showNotification("Vous avez récupéré ~p~x1 "..weapon.. "~s~ avec ~p~"..pickup.count.."~s~ balles.")
				xPlayer.addWeapon(pickup.name, pickup.count)

				--xPlayer.setWeaponTint(pickup.name, pickup.tintIndex)
				-- for k,v in ipairs(pickup.components) do
				-- 	xPlayer.addWeaponComponent(pickup.name, v)
				-- end
			end
		end

		if success then
			TriggerClientEvent('pickup:animation', source)
			ESX.Pickups[pickupId] = nil
			TriggerClientEvent('esx:removePickup', -1, pickupId)
			if money then
				local item = xPlayer.getInventoryItem(pickup.name)
				xPlayer.showNotification("Vous avez récupéré ~p~x"..pickup.count.. " " ..item.label.."~s~.")
			end
		end
	end
end)

RegisterServerEvent('esx:positionSaveReady')
AddEventHandler('esx:positionSaveReady', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.positionSaveReady = true
end)

ESX.RegisterServerCallback('esx:getPlayerData', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	cb({
		identifier = xPlayer.identifier,
		accounts = xPlayer.getAccounts(),
		inventory = xPlayer.getInventory(),
		job = xPlayer.getJob(),
		job2 = xPlayer.getJob2(),
		loadout = xPlayer.getLoadout(),
		lastPosition = xPlayer.getLastPosition()
	})
end)

ESX.RegisterServerCallback('esx:getOtherPlayerData', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	cb({
		identifier = xPlayer.identifier,
		accounts = xPlayer.getAccounts(),
		inventory = xPlayer.getInventory(),
		job = xPlayer.getJob(),
		job2 = xPlayer.getJob2(),
		loadout = xPlayer.getLoadout(),
		lastPosition = xPlayer.getLastPosition()
	})
end)

ESX.RegisterServerCallback('esx:getActivePlayers', function(source, cb)
	local players = {}

	for k, v in pairs(ESX.Players) do
		table.insert(players, {id = k, name = GetPlayerName(k)})
	end

	cb(players)
end)

ESX.StartDBSync()
ESX.StartPositionSync()
ESX.StartPayCheck()


local Jobs = {}
local LastTime = nil

function GetCurrentWeight()
	local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end) 

    local currentWeight = 0
    for i = 1, #xPlayer.inventory, 1 do
        if xPlayer.inventory[i].count > 0 then
            currentWeight = currentWeight + (xPlayer.inventory[i].weight * xPlayer.inventory[i].count)
        end
    end
    return currentWeight
end

function RunAt(h, m, cb)
	table.insert(Jobs, {
		h = h,
		m = m,
		cb = cb
	})
end

function GetTime()
	local date = os.date('*t')
	return {d = date.wday, h = date.hour, m = date.min}
end

function OnTime(d, h, m)
	for i = 1, #Jobs, 1 do
		if Jobs[i].h == h and Jobs[i].m == m then
			Jobs[i].cb(d, h, m)
		end
	end
end

function Tick()
	local time = GetTime()

	if time.h ~= LastTime.h or time.m ~= LastTime.m then
		OnTime(time.d, time.h, time.m)
		LastTime = time
	end

	SetTimeout(60000, Tick)
end

RegisterServerEvent('Sneakycron:runAt')
AddEventHandler('Sneakycron:runAt', function(h, m, cb)
	RunAt(h, m, cb)
end)

LastTime = GetTime()
Tick()

