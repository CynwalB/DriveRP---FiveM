ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("pFourriere:listevehiculefourriere", function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local vehicules = {}

    MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE `parked` = @parked", {['@parked'] = false}, function(data)
        for _, v in pairs(data) do
            local props = json.decode(v.props)
            local ownerCharname = GetCharName(v.owner)
            table.insert(vehicules, { props = props, etat = v.etat, plate = v.plate, Nomdumec = ownerCharname})
        end
        cb(vehicules)
    end)
end)


function GetCharName(identifier)
  local doing = true

  MySQL.Async.fetchAll(
  'SELECT firstname, lastname FROM users WHERE identifier = @identifier LIMIT 1',
  {
    ['@identifier'] = identifier,
  },
    function(res)
      if res[1] then
      charname = res[1].firstname .. ' ' .. res[1].lastname
      doing = false
      else
      charname = "Inconnu"
      doing = false
    end
  end
  )

  while doing do
      Citizen.Wait(0)
  end

  return charname
end

local function GetTime()
    local date = os.date('*t')
    if date.day < 10 then date.day = '0' .. tostring(date.day) end
    if date.month < 10 then date.month = '0' .. tostring(date.month) end
    if (date.hour + 1) < 10 then date.hour = '0' .. tostring(date.hour) end
    if date.min < 10 then date.min = '0' .. tostring(date.min) end
    if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    local date = date.day .. "/" .. date.month .. "/" .. date.year .. " à " .. (date.hour + 1) .. "h" .. date.min
    return date
end

local function getDate()
    return os.date("*t", os.time()).day.."/"..os.date("*t", os.time()).month.."/"..os.date("*t", os.time()).year.." à "..os.date("*t", os.time()).hour.."h"..os.date("*t", os.time()).min.." (+1h)"
end

RegisterServerEvent('pFourriere:ajoutreport')
AddEventHandler('pFourriere:ajoutreport', function(motif, agent, plaque, numeroreport, nomvoituretexte)
    MySQL.Async.execute('INSERT INTO police_report (motif, agent, numeroreport, plaque, date, vehicle) VALUES (@motif, @agent, @numeroreport, @plaque, @date, @vehicle)', {
        ['@motif'] = motif,
        ['@agent'] = agent,
		['@numeroreport'] = numeroreport,
        ['@plaque'] = plaque,
		['@date'] = GetTime(),
		['@vehicle'] = nomvoituretexte
    })
end)


ESX.RegisterServerCallback('pFourriere:affichereport', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local keys = {}

    MySQL.Async.fetchAll('SELECT * FROM police_report', {}, 
        function(result)
        for numreport = 1, #result, 1 do
            table.insert(keys, {
                id = result[numreport].id,
                agent = result[numreport].agent,
                plaque = result[numreport].plaque,
				numeroreport = result[numreport].numeroreport,
                date = result[numreport].date,
                motif = result[numreport].motif,
                vehicle = result[numreport].vehicle
            })
        end
        cb(keys)

    end)
end)

RegisterServerEvent('pFourriere:supprimereport')
AddEventHandler('pFourriere:supprimereport', function(supprimer)
    MySQL.Async.execute('DELETE FROM police_report WHERE id = @id', {
            ['@id'] = supprimer
    })
end)


ESX.RegisterServerCallback('pPermisPoint:getAllLicenses', function(source, cb, target)
    local xPlayer = ESX.GetPlayerFromId(target)
	local allLicenses = {}
	MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @owner', {['owner'] = xPlayer.identifier}, function(result)
		for k,v in pairs(result) do
			table.insert(allLicenses, {
				Name = xPlayer.getName(),
				Type = v.type,
				Point = v.point,
				Owner = v.owner
			})
		end
		cb(allLicenses)
	end)
end)

ESX.RegisterServerCallback('pPermisPoint:getLicenses', function(source, cb)
    local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
    local mylicense = {}
    MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @owner', {
        ['@owner'] = xPlayer.identifier
    }, function(result)
        for k,v in pairs(result) do
                table.insert(mylicense, {
                    Name = xPlayer.getName(),
                    Type = v.type,
                    Point = v.point,
                    Owner = v.owner
                })
        end
        cb(mylicense)
    end)
end)

RegisterServerEvent('pPermisPoint:addPoint')
AddEventHandler('pPermisPoint:addPoint', function(permis, qty, owner)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE type = @type AND owner = @owner', {['type'] = permis, ['owner'] = owner}, function(result)

--        if result[1].point + qty < 13 then

            MySQL.Async.fetchAll("UPDATE user_licenses SET point = @point WHERE owner = @owner AND type = @type",
            {
            ['point'] = result[1].point + qty,
            ['owner'] = owner,
            ['type'] = permis
            },
            function(result)
                TriggerClientEvent('esx:showNotification', _src, "Vous avez ajouté "..qty.." point(s) à ~y~"..ESX.GetPlayerFromIdentifier(owner).getName())
            end)
--        else
--            TriggerClientEvent('esx:showNotification', _src, "Vous pouvez pas mettre plus que 12 point ~r~!")
--        end
    end)
end)


RegisterServerEvent('pPermisPoint:removePoint')
AddEventHandler('pPermisPoint:removePoint', function(permis, qty, owner)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE type = @type AND owner = @owner', {['type'] = permis, ['owner'] = owner}, function(result)

--        if result[1].point - qty > -1 then

            MySQL.Async.fetchAll("UPDATE user_licenses SET point = @point WHERE owner = @owner AND type = @type",
            {
            ['point'] = result[1].point - qty,
            ['owner'] = owner,
            ['type'] = permis
            },
            function(R)
                TriggerClientEvent('esx:showNotification', _src, "Vous avez retier "..qty.." point(s) à ~y~"..ESX.GetPlayerFromIdentifier(owner).getName())
                if result[1].point - qty == 0 then
                    MySQL.Async.execute('DELETE FROM user_licenses WHERE owner = @owner AND type = @type', {['type'] = permis, ['owner'] = owner})
                    TriggerClientEvent('esx:showNotification', _src, "La licence de "..ESX.GetPlayerFromIdentifier(owner).getName().." a été retiré car il avait 0 point")
                end
            end)
--        else
--            TriggerClientEvent('esx:showNotification', _src, "Vous pouvez pas mettre moins que 0 point ~r~!")
--        end
    end)
end)

RegisterServerEvent('pPermisPoint:zeroPoint')
AddEventHandler('pPermisPoint:zeroPoint', function(permis, qty, owner)
	local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)

	MySQL.Async.execute('DELETE FROM user_licenses WHERE owner = @owner AND type = @type', {['type'] = permis, ['owner'] = owner})
	TriggerClientEvent('esx:showNotification', _src, "La licence de "..ESX.GetPlayerFromIdentifier(owner).getName().." a été retiré car il avait 0 point")
end)



local authorizeJob = {
    ["police"] = {label = "Police"},
    ["lssd"] = {label = "Lssd"},
    ["gouvernement"] = {label = "Gouvernement"},
	["fbi"] = {label = "Federal Bureau of Investigation"}
}

Citizen.CreateThread(function()
    for k,v in pairs(authorizeJob) do
        TriggerEvent('esx_phone:registerNumber', k, 'Alerte '..v.label, true, true)
        TriggerEvent('esx_society:registerSociety', k, v.label, 'society_'..k, 'society_'..k, 'society_'..k, {type = 'public'})
    end
end)

RegisterServerEvent("sPolice:addLicense")
AddEventHandler("sPolice:addLicense", function(target, license)
	local _src = source
	--TriggerEvent("ratelimit", _src, "sPolice:addLicense")
	if source then
		local xPlayer, tPlayer = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(target)
		if authorizeJob[xPlayer.job.name] == nil then
			banPlayerAC(xPlayer.source, {
				name = "changestateuser",
				title = "Anticheat : add license police",
				description = "Anticheat : add license police"
			})
			return 
		end
		TriggerEvent('esx_license:addLicense', target, license, function()
			TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous avez donné le ~q~permis port d'armes~s~ à ~q~"..tPlayer.getName())
			TriggerClientEvent("esx:showNotification", tPlayer.source, "~q~"..xPlayer.getName().."~s~ vous a attribué le ~q~permis port d'armes~s~ !")
		end)
	end
end)

RegisterServerEvent("sPolice:removeLicense")
AddEventHandler("sPolice:removeLicense", function(target, license)
	local _src = source
	--TriggerEvent("ratelimit", _src, "sPolice:addLicense")
	if source then
		local xPlayer, tPlayer = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(target)
		if authorizeJob[xPlayer.job.name] == nil then
			banPlayerAC(xPlayer.source, {
				name = "changestateuser",
				title = "Anticheat : remove license police",
				description = "Anticheat : remove license police"
			})
			return 
		end
		TriggerEvent('esx_license:removeLicense', target, license, function()
			TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous avez retiré le ~q~permis port d'armes~s~ à ~q~"..tPlayer.getName())
			TriggerClientEvent("esx:showNotification", tPlayer.source, "~q~"..xPlayer.getName().."~s~ vous a retiré le ~q~permis port d'armes~s~ !")
		end)
	end
end)

RegisterServerEvent("sPolice1:removeLicense")
AddEventHandler("sPolice1:removeLicense", function(target, license)
	local _src = source
	--TriggerEvent("ratelimit", _src, "sPolice:addLicense")
	if source then
		local xPlayer, tPlayer = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(target)
		if authorizeJob[xPlayer.job.name] == nil then
			banPlayerAC(xPlayer.source, {
				name = "changestateuser",
				title = "Anticheat : remove license police",
				description = "Anticheat : remove license police"
			})
			return 
		end
		TriggerEvent('esx_license:removeLicense', target, license, function()
			TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous avez retiré le ~q~permis voiture~s~ à ~q~"..tPlayer.getName())
			TriggerClientEvent("esx:showNotification", tPlayer.source, "~q~"..xPlayer.getName().."~s~ vous a retiré le ~q~permis voiture~s~ !")
		end)
	end
end)

RegisterServerEvent("sPolice2:removeLicense")
AddEventHandler("sPolice2:removeLicense", function(target, license)
	local _src = source
	--TriggerEvent("ratelimit", _src, "sPolice:addLicense")
	if source then
		local xPlayer, tPlayer = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(target)
		if authorizeJob[xPlayer.job.name] == nil then
			banPlayerAC(xPlayer.source, {
				name = "changestateuser",
				title = "Anticheat : remove license police",
				description = "Anticheat : remove license police"
			})
			return 
		end
		TriggerEvent('esx_license:removeLicense', target, license, function()
			TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous avez retiré le ~q~permis moto~s~ à ~q~"..tPlayer.getName())
			TriggerClientEvent("esx:showNotification", tPlayer.source, "~q~"..xPlayer.getName().."~s~ vous a retiré le ~q~permis moto~s~ !")
		end)
	end
end)

RegisterServerEvent("sPolice3:removeLicense")
AddEventHandler("sPolice3:removeLicense", function(target, license)
	local _src = source
	--TriggerEvent("ratelimit", _src, "sPolice:addLicense")
	if source then
		local xPlayer, tPlayer = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(target)
		if authorizeJob[xPlayer.job.name] == nil then
			banPlayerAC(xPlayer.source, {
				name = "changestateuser",
				title = "Anticheat : remove license police",
				description = "Anticheat : remove license police"
			})
			return 
		end
		TriggerEvent('esx_license:removeLicense', target, license, function()
			TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous avez retiré le ~q~permis camion~s~ à ~q~"..tPlayer.getName())
			TriggerClientEvent("esx:showNotification", tPlayer.source, "~q~"..xPlayer.getName().."~s~ vous a retiré le ~q~permis camion~s~ !")
		end)
	end
end)

RegisterServerEvent("Sneaky:Message")
AddEventHandler("Sneaky:Message", function(job,msg)
	local _src = source
	--TriggerEvent("ratelimit", _src, "Sneaky:Message")
	if source then
		local xPlayer, tPlayer = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(target)
		if authorizeJob[xPlayer.job.name] == nil then
			banPlayerAC(xPlayer.source, {
				name = "changestateuser",
				title = "Anticheat : message police",
				description = "Anticheat : message police"
			})
			return 
		end
		TriggerClientEvent("Sneaky:ClientMessage", -1, job, msg)
	end
end)

RegisterServerEvent('sPolice:addWeapon')
AddEventHandler('sPolice:addWeapon', function(weaponName)
	local _src = source
	--TriggerEvent("ratelimit", _src, "sPolice:addWeapon")
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if authorizeJob[xPlayer.job.name] == nil then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : add weapon police",
			description = "Anticheat : add weapon police"
		})
		return 
	end
	xPlayer.addWeapon(weaponName, 250)
	if weaponName == "WEAPON_COMBATPISTOL" or weaponName == "WEAPON_SHOTGUN" or weaponName == "WEAPON_COMBATPDW" or weaponName == "WEAPON_CARBINERIFLE" then
		xPlayer.addWeaponComponent(weaponName, 'flashlight')
	end
	TriggerClientEvent('esx:showNotification', _source, "Vous avez emprunté une arme : ~q~"..ESX.GetWeaponLabel(weaponName))
end)

RegisterServerEvent('sPolice:removeWeapons')
AddEventHandler('sPolice:removeWeapons', function()
	local _src = source
	--TriggerEvent("ratelimit", _src, "sPolice:removeWeapons")
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if authorizeJob[xPlayer.job.name] == nil then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : remove weapon police",
			description = "Anticheat : remove weapon police"
		})
		return 
	end
	local lamp = "flashlight"
	local lampweapon = xPlayer.getWeapon('WEAPON_FLASHLIGHT')
	local matraque = xPlayer.getWeapon('WEAPON_NIGHTSTICK')
	local tazer = xPlayer.getWeapon('WEAPON_STUNGUN')
	local combatpistol = xPlayer.getWeapon('WEAPON_COMBATPISTOL')
	local shotgun = xPlayer.getWeapon('WEAPON_PUMPSHOTGUN')
	local combatpdw = xPlayer.getWeapon('WEAPON_COMBATPDW')
	local carabinerifle = xPlayer.getWeapon('WEAPON_CARBINERIFLE')
	local carabinerifle = xPlayer.getWeapon('WEAPON_SNIPERRIFLE')
	if lampweapon then
		xPlayer.removeWeapon('WEAPON_FLASHLIGHT')
		TriggerClientEvent('esx:showNotification', _source, "Vous avez rendu une arme : ~q~"..ESX.GetWeaponLabel('WEAPON_FLASHLIGHT'))
	end
	if matraque then
		xPlayer.removeWeapon('WEAPON_NIGHTSTICK')
		TriggerClientEvent('esx:showNotification', _source, "Vous avez rendu une arme : ~q~"..ESX.GetWeaponLabel('WEAPON_NIGHTSTICK'))
	end
	if tazer then
		xPlayer.removeWeapon('WEAPON_STUNGUN')
		TriggerClientEvent('esx:showNotification', _source, "Vous avez rendu une arme : ~q~"..ESX.GetWeaponLabel('WEAPON_STUNGUN'))
	end
	if combatpistol then
		xPlayer.removeWeapon('WEAPON_COMBATPISTOL')
		if xPlayer.hasWeaponComponent("WEAPON_COMBATPISTOL", lamp) then
			xPlayer.removeWeaponComponent('WEAPON_COMBATPISTOL', lamp)
		end
		TriggerClientEvent('esx:showNotification', _source, "Vous avez rendu une arme : ~q~"..ESX.GetWeaponLabel('WEAPON_COMBATPISTOL'))
	end
	if shotgun then
		xPlayer.removeWeapon('WEAPON_PUMPSHOTGUN')
		if xPlayer.hasWeaponComponent("WEAPON_PUMPSHOTGUN", lamp) then
			xPlayer.removeWeaponComponent('WEAPON_PUMPSHOTGUN', lamp)
		end
		TriggerClientEvent('esx:showNotification', _source, "Vous avez rendu une arme : ~q~"..ESX.GetWeaponLabel('WEAPON_PUMPSHOTGUN'))
	end
	if combatpdw then
		xPlayer.removeWeapon("WEAPON_COMBATPDW")
		if xPlayer.hasWeaponComponent("WEAPON_COMBATPDW", lamp) then
			xPlayer.removeWeaponComponent('WEAPON_COMBATPDW', lamp)
		end
		TriggerClientEvent('esx:showNotification', _source, "Vous avez rendu une arme : ~q~"..ESX.GetWeaponLabel('WEAPON_COMBATPDW'))
	end
	if carabinerifle then
		xPlayer.removeWeapon('WEAPON_CARBINERIFLE')
		if xPlayer.hasWeaponComponent("WEAPON_CARBINERIFLE", lamp) then
			xPlayer.removeWeaponComponent('WEAPON_CARBINERIFLE', lamp)
		end
		TriggerClientEvent('esx:showNotification', _source, "Vous avez rendu une arme : ~q~"..ESX.GetWeaponLabel('WEAPON_CARBINERIFLE'))
	end
	if carabinerifle then
		xPlayer.removeWeapon('WEAPON_SNIPERRIFLE')
		if xPlayer.hasWeaponComponent("WEAPON_SNIPERRIFLE", lamp) then
			xPlayer.removeWeaponComponent('WEAPON_SNIPERRIFLE', lamp)
		end
		TriggerClientEvent('esx:showNotification', _source, "Vous avez rendu une arme : ~q~"..ESX.GetWeaponLabel('WEAPON_SNIPERRIFLE'))
	end
end)
RegisterServerEvent('sPolice:addHerse')
AddEventHandler('sPolice:addHerse', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if authorizeJob[xPlayer.job.name] == nil then print("Le joueur : "..GetPlayerName(xPlayer.source).." vient de se faire détecter") return DropPlayer(xPlayer.source, tokenMessage) end
	if xPlayer.getInventoryItem("spike").count < 1 then
		xPlayer.addInventoryItem("spike", 1)
		TriggerClientEvent('esx:showNotification', source, "Vous venez de récuperer une ~q~herse~s~.")
	else
		TriggerClientEvent('esx:showNotification', source, "~r~Vous ne pouvez prendre deux herses sur vous.")
	end
end)

ESX.RegisterServerCallback('sPolice:getBilling', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local tPlayer = ESX.GetPlayerFromId(target)
	if authorizeJob[xPlayer.job.name] == nil then print("Le joueur : "..GetPlayerName(xPlayer.source).." vient de se faire détecter") return DropPlayer(xPlayer.source, tokenMessage) end

	MySQL.Async.fetchAll("SELECT * FROM billing WHERE identifier = @identifier", {
		['@identifier'] = tPlayer.identifier
	}, function(result)
		cb(result)
	end)
end)

RegisterNetEvent('sPolice:confiscatePlayerItem')
AddEventHandler('sPolice:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if authorizeJob[sourceXPlayer.job.name] == nil then 
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : confiscate weapon",
			description = "Anticheat : confiscate weapon"
		})
		return
	end
	
	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)
		if targetItem.count > 0 and targetItem.count <= amount then
			if sourceXPlayer.canCarryItem(itemName, sourceItem.count) then
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem   (itemName, amount)
				sourceXPlayer.showNotification('Vous avez confisqué ~q~'..amount..'~s~ ~q~'..sourceItem.label..'~s~')
				targetXPlayer.showNotification('~q~'..sourceItem.label..'~s~ ~q~'..amount..'~s~ vous à été confisqué')
			else
				sourceXPlayer.showNotification("Debug 1")
			end
		end
	elseif itemType == 'item_account' then
		local targetAccount = targetXPlayer.getAccount(itemName)
		if targetAccount.money >= amount then
			targetXPlayer.removeAccountMoney(itemName, amount)
			sourceXPlayer.addAccountMoney   (itemName, amount)

			sourceXPlayer.showNotification('Vous avez confisqué ~q~$'..itemName..'~s~ ('..amount..')')
			targetXPlayer.showNotification('~q~$'..itemName..'~s~ ('..amount..') vous à été confisqué')
		end
	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end
		if targetXPlayer.hasWeapon(itemName) then
			targetXPlayer.removeWeapon(itemName, amount)
			sourceXPlayer.addWeapon(itemName, amount)
			sourceXPlayer.showNotification('Vous avez confisqué ~q~'..ESX.GetWeaponLabel(itemName)..'~s~ avec ~q~'..amount..'~s~ munitions')
			targetXPlayer.showNotification('Votre ~q~'..ESX.GetWeaponLabel(itemName)..'~s~ avec ~q~'..amount..'~s~ munitions vous à été confisqué')
		end
	end
end)

-- Intéractions
RegisterServerEvent('sPolice:requestarrest')
AddEventHandler('sPolice:requestarrest', function(targetid, playerheading, playerCoords,  playerlocation)
	local _src = source
	--TriggerEvent("ratelimit", _src, "sPolice:requestarrest")
	_source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if authorizeJob[xPlayer.job.name] == nil then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : request arrest",
			description = "Anticheat : request arrest"
		})
		return 
	end
	TriggerClientEvent('sPolice:getarrested', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('sPolice:doarrested', _source)
end)

RegisterServerEvent('sPolice:requestrelease')
AddEventHandler('sPolice:requestrelease', function(targetid, playerheading, playerCoords,  playerlocation)
	local _src = source
	--TriggerEvent("ratelimit", _src, "sPolice:requestrelease")
	_source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if authorizeJob[xPlayer.job.name] == nil then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : request release",
			description = "Anticheat : request release"
		})
		return  
	end
	TriggerClientEvent('sPolice:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('sPolice:douncuffing', _source)
end)

RegisterServerEvent('sPolice:handcuff')
AddEventHandler('sPolice:handcuff', function(target)
	local _src = source
	--TriggerEvent("ratelimit", _src, "sPolice:handcuff")
	local xPlayer = ESX.GetPlayerFromId(source)
	if authorizeJob[xPlayer.job.name] == nil then 
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : request handcuff",
			description = "Anticheat : request handcuff"
		})
		return
	end
	if xPlayer.job.name == 'police' then
		TriggerClientEvent('sPolice:handcuff', target)
	else
		TriggerClientEvent('sPolice:handcuff', target)
	end
end)

RegisterServerEvent('sPolice:handcuff2')
AddEventHandler('sPolice:handcuff2', function(target)
	local _src = source
	--TriggerEvent("ratelimit", _src, "sPolice:handcuff2")
	local xPlayer = ESX.GetPlayerFromId(source)
	if authorizeJob[xPlayer.job.name] == nil then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : request handcuff2",
			description = "Anticheat : request handcuff2"
		})
		return 
	end

	TriggerClientEvent('sPolice:handcuff2', target)

end)

RegisterServerEvent('sPolice:drag')
AddEventHandler('sPolice:drag', function(target)
	local _src = source
	--TriggerEvent("ratelimit", _src, "sPolice:drag")
	local xPlayer = ESX.GetPlayerFromId(source)
	if authorizeJob[xPlayer.job.name] == nil then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : request drag",
			description = "Anticheat : request drag"
		})
		return 
	end

	TriggerClientEvent('sPolice:drag', target, source)
end)

RegisterServerEvent('sPolice:putInVehicle')
AddEventHandler('sPolice:putInVehicle', function(target)
	local _src = source
	--TriggerEvent("ratelimit", _src, "sPolice:putInVehicle")
	local xPlayer = ESX.GetPlayerFromId(source)
	if authorizeJob[xPlayer.job.name] == nil then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : put in vehicle",
			description = "Anticheat : put in vehicle"
		})
		return  
	end

	TriggerClientEvent('sPolice:putInVehicle', target)
end)

RegisterServerEvent('sPolice:OutVehicle')
AddEventHandler('sPolice:OutVehicle', function(target)
	local _src = source
	--TriggerEvent("ratelimit", _src, "sPolice:OutVehicle")
	local xPlayer = ESX.GetPlayerFromId(source)
	if authorizeJob[xPlayer.job.name] == nil then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : out in vehicle",
			description = "Anticheat : out in vehicle"
		})
		return 
	end

	TriggerClientEvent('sPolice:OutVehicle', target)
end)

ESX.RegisterServerCallback('sPolice:getPlayerInformation', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)
	if authorizeJob[xPlayer.job.name] == nil then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : search information",
			description = "Anticheat : search information"
		})
		return 
	end
	MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
		['@identifier'] = xTarget.identifier
	}, function(result)
		local data = {
			name = GetPlayerName(target),
			inventory = xTarget.inventory,
			accounts = xTarget.accounts,
			weapons = xTarget.loadout,
			firstname = result[1]['firstname'],
			lastname = result[1]['lastname'],
			sex = result[1]['sex'],
			birthday = result[1]['birthday'],
			number = result[1]['phone_number'],
			height = result[1]['height'],
			travail = result[1]['job'],
		}
		cb(data)
	end)
end)

ESX.RegisterServerCallback("sPolice:getLicenses", function(source, cb, target)
	TriggerEvent('esx_license:getLicenses', target, function(licenses)
		cb(licenses)
	end)
end)

ESX.RegisterServerCallback('sPolice:getVehicleInfos', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE @plate = plate', {
		['@plate'] = plate
	}, function(result)
		local retrivedInfo = {
			plate = plate
		}
		if result[1] then
			MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)
				retrivedInfo.owner = result2[1].firstname .. ' ' .. result2[1].lastname
				cb(retrivedInfo)
			end)
		else
			cb(retrivedInfo)
		end
	end)
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'police')
	end
end)

-- Renfort
RegisterServerEvent('sPolice:renfortPolice')
AddEventHandler('sPolice:renfortPolice', function(coords, raison)
	local _src = source
	--TriggerEvent("ratelimit", _src, "sPolice:renfortPolice")
	local _source = source
	local _raison = raison
	local xPlayer = ESX.GetPlayerFromId(_source)
	if authorizeJob[xPlayer.job.name] == nil then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : renfort police",
			description = "Anticheat : renfort police"
		})
		return 
	end
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'lssd' or thePlayer.job.name == 'police' or thePlayer.job.name == "fbi" then
			local label = thePlayer.job.label
			TriggerClientEvent('renfortpolice:setBlip', xPlayers[i], label, coords, _raison)
		end
	end
end)