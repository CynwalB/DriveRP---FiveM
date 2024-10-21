ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'harmony', "Harmony and Repair's", true, true)
TriggerEvent('esx_society:registerSociety', 'harmony', 'harmony', 'society_harmony', 'society_harmony', 'society_harmony', {type = 'public'})

ESX.RegisterServerCallback("hFourriere:listevehiculefourriere", function(source, cb)
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

RegisterServerEvent('hFourriere:ajoutreport')
AddEventHandler('hFourriere:ajoutreport', function(motif, agent, plaque, numeroreport, nomvoituretexte)
    MySQL.Async.execute('INSERT INTO hayes_report (motif, agent, numeroreport, plaque, date, vehicle) VALUES (@motif, @agent, @numeroreport, @plaque, @date, @vehicle)', {
        ['@motif'] = motif,
        ['@agent'] = agent,
		['@numeroreport'] = numeroreport,
        ['@plaque'] = plaque,
		['@date'] = GetTime(),
		['@vehicle'] = nomvoituretexte
    })
end)


ESX.RegisterServerCallback('hFourriere:affichereport', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local keys = {}

    MySQL.Async.fetchAll('SELECT * FROM hayes_report', {}, 
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

RegisterServerEvent('hFourriere:supprimereport')
AddEventHandler('hFourriere:supprimereport', function(supprimer)
    MySQL.Async.execute('DELETE FROM hayes_report WHERE id = @id', {
            ['@id'] = supprimer
    })
end)





RegisterServerEvent('Sneakyharmony:giveItem')
AddEventHandler('Sneakyharmony:giveItem', function(itemName,price)
	local _src = source
	--TriggerEvent("ratelimit", _src, "Sneakyharmony:giveItem")
	local xPlayer = ESX.GetPlayerFromId(source)
	if #(GetEntityCoords(GetPlayerPed(xPlayer.source))-vector3(1169.3200683594,2644.6003417969,37.809589385986)) > 1.5 then
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
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez déjà ~q~x1 " ..ESX.GetItemLabel(itemName).. "~s~ !")
		end
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Vous n'avez pas assez d'argent !")
	end
end)

RegisterServerEvent('harmony:addAnnounce')
AddEventHandler('harmony:addAnnounce', function(announce)
	local _src = source
	--TriggerEvent("ratelimit", _src, "harmony:addAnnounce")
    local _source = source
    local announce = announce
    local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name ~= "harmony" then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : annonce",
			description = "Anticheat : annonce"
		})
		return  
	end
    TriggerClientEvent("harmony:targetAnnounce",  -1, announce)
end)