TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

electroCuffedPlayers = {}

ESX.RegisterUsableItem(Config.CuffItem, function(source, item) 
    local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('s4-cuff:client:use', source)
end)
ESX.RegisterUsableItem(Config.BagToHeadItem, function(source, item) 
    local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('s4-cuff:client:cuval', source)
end)

ESX.RegisterUsableItem(Config.RopeItem, function(source, item) 
    local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('s4-cuff:client:halat', source)
end)

ESX.RegisterUsableItem(Config.CuffKeysItem, function(source, item) 
    local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('s4-cuff:client:useLockpick', source)
end)

ESX.RegisterUsableItem(Config.ElectronicCuffItem, function(source, item) 
    local xPlayer = ESX.GetPlayerFromId(source)
    
	TriggerClientEvent('cuff:client:useElectronicCuff', source)
end) 

ESX.RegisterUsableItem(Config.ElectronicCuffTrackerItem, function(source, item) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.Functions.GetItemByName(Config.ElectronicCuffTrackerItem)  -- fonction get item

    if item and xPlayer then 
        if xPlayer.PlayerData.job.name == 'police' then 
           TriggerClientEvent('cuff:client:showElectronicCuffTrackMenu', source)
        end
    end
end) 

RegisterServerEvent('s4-cuff:server:ProcessCuffs')
AddEventHandler('s4-cuff:server:ProcessCuffs', function(p, id)
   TriggerClientEvent('s4-cuff:client:ProcessCuffs', id,  tonumber(id), p)
   local xPlayer = ESX.GetPlayerFromId(source)
   xPlayer.removeInventoryItem(Config.CuffItem, 1)
end)

RegisterServerEvent('s4-cuff:server:RemoveCuffs')
AddEventHandler('s4-cuff:server:RemoveCuffs', function(p, id)
   TriggerClientEvent('s4-cuff:client:RemoveCuffs', tonumber(id), p)
   local xPlayer = ESX.GetPlayerFromId(source)
   xPlayer.addInventoryItem(Config.CuffItem, 1)
end)



RegisterServerEvent("s4-cuff:IsCuff")
AddEventHandler('s4-cuff:IsCuff', function(target)
	local xPlayer = ESX.GetPlayerFromId(target)
	MySQL.Async.execute('UPDATE users SET cuff = @cuff WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier,
		['@cuff'] = 1
	})
end)

RegisterServerEvent("s4-cuff:NotCuff")
AddEventHandler('s4-cuff:NotCuff', function(target)
	local xPlayer = ESX.GetPlayerFromId(target)
	MySQL.Async.execute('UPDATE users SET cuff = @cuff WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier,
		['@cuff'] = 0
	})
end)

ESX.RegisterServerCallback("s4-cuff:PlayerIsCuff", function(source, cb, ply)
	local idd = ESX.GetPlayerFromId(ply).identifier

	MySQL.Async.fetchScalar('SELECT cuff FROM users WHERE identifier = @identifier', {
		['@identifier'] = idd
	}, function(cuff)
		if cuff == 1 then
			cb(true)
		elseif cuff == 0 then
			cb(false)
		end
	end)
end)



RegisterServerEvent('s4-cuff:drag')
AddEventHandler('s4-cuff:drag', function(target)
    TriggerClientEvent('s4-cuff:drag', target, source)
end)

RegisterServerEvent('s4-cuff:client:halat_baglanan')
AddEventHandler('s4-cuff:client:halat_baglanan', function(target)
    TriggerClientEvent('s4-cuff:client:halat_baglanan', target)
end)

RegisterServerEvent('s4-cuff:client:cuval')
AddEventHandler('s4-cuff:client:cuval', function(target, bag)
    TriggerClientEvent('s4-cuff:client:kafacuval', target, bag)
end)


RegisterServerEvent('s4-cuff:client:putInVehicle')
AddEventHandler('s4-cuff:client:putInVehicle', function(target)
    TriggerClientEvent('s4-cuff:client:putInVehicle', target)
end)

RegisterServerEvent('s4-cuff:client:OutVehicle')
AddEventHandler('s4-cuff:client:OutVehicle', function(target)
    TriggerClientEvent('s4-cuff:client:OutVehicle', target)
end)

RegisterServerEvent('s4-cuff:client:agzapara')
AddEventHandler('s4-cuff:client:agzapara', function(tip, target)
    TriggerClientEvent('s4-cuff:client:agzapara', target, tip)
end)

function SyncElectrocuffedPlayers() 
    MySQL.ready(function() 
        MySQL.Async.fetchAll("SELECT * FROM electrocuffed_players", {}, function(data) 
            local players = {}

            for k,v in ipairs(data) do 
                local xPlayer = ESX.GetPlayerFromId(v.id)
                local playerData = {}

                if xPlayer then 
                    playerData = {
                        identifier = xPlayer.PlayerData.citizenid ,
                        id = xPlayer.PlayerData.source,
                        name = xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname,
                        cuffDate = v.date,
                    }
                else
                    playerData = {
                        identifier = v.id,
                        id = nil,
                        name = nil,
                        cuffDate = v.date,
                    }
                end

                table.insert(players, playerData)
            end

            electroCuffedPlayers = players
        end)
    end)
end

AddEventHandler("onResourceStart", SyncElectrocuffedPlayers)

RegisterServerEvent("cuff:server:electroCuffPlayer")
AddEventHandler("cuff:server:electroCuffPlayer", function(player) 
    local source = source
    local xPlayer = ESX.GetPlayerFromId(player)
    local userExists = false

    for k,v in ipairs(electroCuffedPlayers) do 
        if v.id == player then 
            userExists = true
            break
        end
    end

    if xPlayer and not userExists then 
        local playerData = {
            identifier = xPlayer.PlayerData.citizenid ,
            id = player,
            cuffDate = os.date(),
            name = xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname,
        }

        MySQL.Async.execute("INSERT INTO electrocuffed_players (id, date) VALUES (@identifier, @date)", { 
            ["@identifier"] = xPlayer.PlayerData.citizenid,  
            ["@date"] = playerData.cuffDate 
        }, function() 
            table.insert(electroCuffedPlayers, playerData)
        end)
    end
end)

RegisterServerEvent("cuff:server:shockPlayer")
AddEventHandler("cuff:server:shockPlayer", function(player)
    local xPlayer = ESX.GetPlayerFromId(player)

    TriggerClientEvent("cuff:client:shock", player)
end)

ESX.RegisterServerCallback("cuff:server:getElectroCuffedPlayers", function(source, cb, data)
    if electroCuffedPlayers then 
        for k,v in ipairs(electroCuffedPlayers) do 
            if v.identifier  and not v.id then 
                local xPlayer = ESX.GetPlayerFromId(v.identifier)

                if xPlayer then 
                    electroCuffedPlayers[k] = {
                        identifier = xPlayer.PlayerData.citizenid ,
                        id = xPlayer.PlayerData.source,
                        name = xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname,
                        cuffDate = v.cuffDate,
                    }
                end
            end

            if v.id then 
                electroCuffedPlayers[k].coords = GetEntityCoords(GetPlayerPed(v.id))
            end
        end    
    end 

    cb(electroCuffedPlayers or {})
end)

RegisterServerEvent("cuff:server:disableElectroCuff")
AddEventHandler("cuff:server:disableElectroCuff", function(player) 
    for k,v in ipairs(electroCuffedPlayers) do 
        if v.id == player.id then 
            table.remove(electroCuffedPlayers, k)
        end
    end 

    MySQL.Sync.execute("DELETE FROM electrocuffed_players WHERE id = @identifier", { ["@identifier"] = player.identifier})
end)