local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function GetTime()
    local date = os.date('*t')
    if date.day < 10 then date.day = '0' .. tostring(date.day) end
    if date.month < 10 then date.month = '0' .. tostring(date.month) end
    if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
    if date.min < 10 then date.min = '0' .. tostring(date.min) end
    if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    local date = date.day .. "/" .. date.month .. "/" .. date.year .. " - " .. date.hour .. " heures " .. date.min .. " minutes " .. date.sec .. " secondes"
    return date
end

function SendLogs(Color, Title, Description,webhook)
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
         username = "DriveRP - Logs", 
         embeds = {{
              ["color"] = Color, 
              ["author"] = {
                ["name"] = "DriveRP - Logs"
              },
              ["title"] = Title,
              ["description"] = "".. Description .."",
              ["footer"] = {
                   ["text"] = GetTime(),
                   ["icon_url"] = "https://cdn.discordapp.com/attachments/1186781950791401624/1186789454426419240/V8_-_Test_Logo.png?ex=659486cf&is=658211cf&hm=8acaae57f8730c0f61a733cb7a13ac8587cf0d4e9679faaee18a3c3b14bbdf57&",
              },
         }}, 
         avatar_url = "https://cdn.discordapp.com/attachments/1186781950791401624/1186789454426419240/V8_-_Test_Logo.png?ex=659486cf&is=658211cf&hm=8acaae57f8730c0f61a733cb7a13ac8587cf0d4e9679faaee18a3c3b14bbdf57&"
    }), { 
         ['Content-Type'] = 'application/json' 
    })
end


-- Maintenance

local maintenance = false

local function devStart(state)
     if state then
        maintenance = true
          local xPlayers = ESX.GetPlayers()
          for i = 1, #xPlayers, 1 do
                local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                if xPlayer == nil then return end
                if xPlayer.getGroup() == "user" then   
                    print("Le joueur ^4"..GetPlayerName(xPlayers[i]).."^0 connexion ^1refusé^0 (^5Dev^0)")
                    DropPlayer(xPlayers[i], "\nInformation\nLe serveur est actuellement en maintenance !")
               else
                    print("Le joueur ^4"..GetPlayerName(xPlayers[i]).."^0 connexion ^2accepté^0 (^5Dev^0)")
               end
          end
     else
        maintenance = false
     end
end

Citizen.CreateThread(function()
    devStart(maintenance)
end)


Citizen.CreateThread(function()
    while true do
        Wait(60*1000*4)
        if maintenance then
            print("Maintenance ^2détecté^0 !")
            local xPlayers = ESX.GetPlayers()
            for i = 1, #xPlayers, 1 do
                local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                if xPlayer == nil then return end
                if xPlayer.getGroup() == "user" then        
                    print("Le joueur ^4"..GetPlayerName(xPlayers[i]).."^0 est ^1refusé^0 dans la maintenance et je le kick .")
                    DropPlayer(xPlayers[i], "\nInformation\nLe serveur est actuellement en maintenance !")
                else
                    print("Le joueur ^4"..GetPlayerName(xPlayers[i]).."^0 est ^2accepté^0 dans la maintenance .")
                end
            end
        else
            print("Maintenance ^1non détecté^0 !")
        end
    end
end)

RegisterCommand("maintenance", function(source)
    if source == 0 then
         if not maintenance then
              print("Maintenance ^2actif^0 !")
              devStart(true)
         else
              print("Maintenance non ^1actif^0 !")
              devStart(false)
         end
    end
end)

-- Porter

local function onMeCommand(source, args)
    local text = 'La personne '..table.concat(args, " ")
    TriggerClientEvent('3dme:shareDisplay', -1, text, source)
end
RegisterCommand("me", onMeCommand)


RegisterCommand("id",function(source)
    RconPrint("^2["..GetCurrentResourceName().."] ^0: ^2ID^0 du joueur : ^5"..GetPlayerName(source).."^0 id : ^4"..source.."\n")
end)

RegisterCommand('getbucket',function(source)
    RconPrint("^2["..GetCurrentResourceName().."] ^0: ^6Bucket^0 du joueur : ^5"..GetPlayerName(source).."^0 bucket : ^4"..GetPlayerRoutingBucket(source).."\n")
end)

RegisterCommand('getping',function(source)
    RconPrint("^2["..GetCurrentResourceName().."] ^0: ^3Ping^0 du joueur : ^5"..GetPlayerName(source).."^0 ping : ^4"..GetPlayerPing(source).."\n")
end)

RegisterCommand("link", function(source, args)
    local player = ESX.GetPlayerFromId(source)

    if #args ~= 1 then
        TriggerClientEvent('esx:showNotification', source, "~r~Utilisation incorrecte. Utilisez /link [verif_key]")
        return
    end

    local verifKey = args[1]

    MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
        ['@identifier'] = player.identifier
    }, function(name)
        if name[1] then
            fullName = name[1].firstname.." "..name[1].lastname
        else
            TriggerClientEvent('esx:showNotification', source, "~r~Votre personnage n'a pas de prénom/nom !")
            return
        end
        MySQL.Async.fetchAll("SELECT * FROM user WHERE username = @username", {
            ['@username'] = fullName
        }, function(result)
            if result[1] then
                if result[1].username == fullName then
                    if result[1].usergroup == 2 then 
                        if result[1].verif_key == verifKey then
                            TriggerClientEvent('esx:showNotification', source, "~g~Votre compte a bien été lié !")
                            MySQL.Async.execute('UPDATE user SET usergroup = @usergroup WHERE username = @username', {
                                ['@username'] = fullName,
                                ['@usergroup'] = 3
                            })
                        else
                            TriggerClientEvent('esx:showNotification', source, "~r~La clé que vous avez entré ne correspond pas à celle de ce compte !")
                        end
                    else
                        TriggerClientEvent('esx:showNotification', source, "~g~Votre compte est déjà lié à votre personnage !")
                    end
                else
                    TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez pas de compte sur le site du serveur !")
                end
            else
                TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez pas de compte sur le site du serveur !")
            end
        end)
    end)
end, false)

-- Demande de rdv job ↓

RegisterServerEvent('Job:DemandeRdv')
AddEventHandler('Job:DemandeRdv', function(job, ginfo)
    local _src = source
	--TriggerEvent("ratelimit", _src, "Job:DemandeRdv")
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == job then
			TriggerClientEvent('esx:showNotification', xPlayers[i], ginfo)
		end
	end
end)

RegisterServerEvent("sCore:PlayerEvent")
AddEventHandler("sCore:PlayerEvent",function(name, source, r, a, b, c)
    TriggerClientEvent(name, source, r, a, b, c)
end)

RegisterServerEvent("playerDied")
AddEventHandler('playerDied',function(id,player,killer,DeathReason, Weapon)
    local dead_logs = 0
    local xPlayer = ESX.GetPlayerFromId(source)
    local KillerPlayer = ESX.GetPlayerFromId(killer)
	if Weapon == nil then 
        _Weapon = "" 
    else 
        _Weapon = "`"..Weapon.."`" 
    end
	if id == 1 and dead_logs == 0 then 
        SendLogs(15158332,"Mort Seul","**"..GetPlayerName(source).."** vient de se suicider\n **License** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1151183551484678184/5M13IyJLbicXP58zQN8aP-ZmdgFl9wDKzTJ76esQpWBA7bDjnyqN2IBnZ2EmmGa7NURe")
        dead_logs = 1
    elseif id == 2 and dead_logs == 0 then
        SendLogs(15158332,"Mort par un autre joueur","**"..GetPlayerName(source).."** vient de mourir par ***"..GetPlayerName(killer).."*** de : ***"..DeathReason.."*** avec l'arme : ***".._Weapon.."***\n **Victime** : "..xPlayer.identifier.."\n **Coupable** : "..KillerPlayer.identifier,"https://discord.com/api/webhooks/1151183551484678184/5M13IyJLbicXP58zQN8aP-ZmdgFl9wDKzTJ76esQpWBA7bDjnyqN2IBnZ2EmmGa7NURe")
        dead_logs = 1
    else
        if dead_logs == 0 then
            SendLogs(15158332,"Mort Seul","**"..GetPlayerName(source).."** vient de mourir d'une : ***Raison inconnue***\n **License** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1151183551484678184/5M13IyJLbicXP58zQN8aP-ZmdgFl9wDKzTJ76esQpWBA7bDjnyqN2IBnZ2EmmGa7NURe")
            dead_logs = 1
        end
    end
end)

sqlReady = false

MySQL.ready(function()
	sqlReady = true
end)

AddEventHandler('playerConnecting', function()
	local _source = source
	local loadedToken = {}
	local license, steam, xbl, discord, live, fivem = '', '', '', '', '', ''
	local name, ip, guid = GetPlayerName(_source), GetPlayerEP(_source), GetPlayerGuid(_source)

	local playerTokens = {}
	for i = 1, GetNumPlayerTokens(_source) do
		playerTokens[i] = GetPlayerToken(_source, i)
		loadedToken[i] = true
	end

	while not loadedToken[GetNumPlayerTokens(_source)] do
		Wait(50)
	end

	while not sqlReady do
		Citizen.Wait(100)
	end

	for k, v in pairs(GetPlayerIdentifiers(_source)) do
		if string.sub(v, 1, string.len('license:')) == 'license:' then
			license = v
		elseif string.sub(v, 1, string.len('steam:')) == 'steam:' then
			steam = v
		elseif string.sub(v, 1, string.len('xbl:')) == 'xbl:' then
			xbl = v
		elseif string.sub(v, 1, string.len('discord:')) == 'discord:' then
			discord = v
		elseif string.sub(v, 1, string.len('live:')) == 'live:' then
			live = v
		elseif string.sub(v, 1, string.len('fivem:')) == 'fivem:' then
			fivem = v
		end
	end

	if license ~= nil then
		MySQL.Async.fetchAll('SELECT * FROM account_info WHERE license = @license', {['@license'] = license}, function(result)
			
			if result[1] ~= nil then
				MySQL.Async.execute('UPDATE account_info SET steam = @steam, xbl = @xbl, discord = @discord, live = @live, fivem = @fivem, `name` = @name, ip = @ip, tokens = @tokens, guid = @guid WHERE license = @license', {
					['@license'] = license,
					['@steam'] = steam,
					['@xbl'] = xbl,
					['@discord'] = discord,
					['@live'] = live,
					['@fivem'] = fivem,
					['@name'] = name,
					['@ip'] = ip,
					['@tokens'] = json.encode(playerTokens),
					['@guid'] = guid
				})
			else
				MySQL.Async.execute('INSERT INTO account_info (license, steam, xbl, discord, live, fivem, `name`, ip, tokens, guid) VALUES (@license, @steam, @xbl, @discord, @live, @fivem, @name, @ip, @tokens, @guid)', {
					['@license'] = license,
					['@steam'] = steam,
					['@xbl'] = xbl,
					['@discord'] = discord,
					['@live'] = live,
					['@fivem'] = fivem,
					['@name'] = name,
					['@ip'] = ip,
					['@tokens'] = json.encode(playerTokens),
					['@guid'] = guid
				})
			end
		end)
	end
end)

Citizen.CreateThread(function()
    Wait(1000)
    RconPrint("^2["..GetCurrentResourceName().."] ^0: ^2Callback ready to use.^7\n")
    RconPrint("^2["..GetCurrentResourceName().."] ^0: Module : Accessories ^5INITIALIZED^0\n")
    RconPrint("^2["..GetCurrentResourceName().."] ^0: Module : Admin ^5INITIALIZED^0\n")
    RconPrint("^2["..GetCurrentResourceName().."] ^0: Module : Ambulance ^5INITIALIZED^0\n")
    RconPrint("^2["..GetCurrentResourceName().."] ^0: Module : Anticheat ^5INITIALIZED^0\n")
    RconPrint("^2["..GetCurrentResourceName().."] ^0: Module : Bank ^5INITIALIZED^0\n")
    RconPrint("^2["..GetCurrentResourceName().."] ^0: Module : Boat ^5INITIALIZED^0\n")
    RconPrint("^2["..GetCurrentResourceName().."] ^0: Module : Clothes ^5INITIALIZED^0\n")
    RconPrint("^2["..GetCurrentResourceName().."] ^0: Module : Concess ^5INITIALIZED^0\n")
    RconPrint("^2["..GetCurrentResourceName().."] ^0: Module : Bike ^5INITIALIZED^0\n")
    RconPrint("^2["..GetCurrentResourceName().."] ^0: Module : Digitalden ^5INITIALIZED^0\n")
    RconPrint("^2["..GetCurrentResourceName().."] ^0: Module : Driveschool ^5INITIALIZED^0\n")
    RconPrint("^2["..GetCurrentResourceName().."] ^0: Module : Fuel ^5INITIALIZED^0\n")
    RconPrint("^2["..GetCurrentResourceName().."] ^0: Module : Garage ^5INITIALIZED^0\n")
    RconPrint("^2["..GetCurrentResourceName().."] ^0: Module : Boat ^5INITIALIZED^0\n")
    RconPrint("^2["..GetCurrentResourceName().."] ^0: Module : Mecano ^5INITIALIZED^0\n")
    RconPrint("^2["..GetCurrentResourceName().."] ^0: Module : Police ^5INITIALIZED^0\n")
    RconPrint("^2["..GetCurrentResourceName().."] ^0: Module : Drive^6RP ^5INITIALIZED^0\n")
    RconPrint("^2["..GetCurrentResourceName().."] ^0: Module : Society ^5INITIALIZED^0\n")
    RconPrint("^2["..GetCurrentResourceName().."] ^0: Module : Shops ^5INITIALIZED^0\n")
    RconPrint("^2["..GetCurrentResourceName().."] ^0: Module : Tattoos ^5INITIALIZED^0\n")
    RconPrint("^2["..GetCurrentResourceName().."] ^0: Module : Weaponshop ^5INITIALIZED^0\n")
end)

SetMapName('Los Santos')
SetGameType('DriveRP')


RegisterServerEvent('sContext:drag')
AddEventHandler('sContext:drag', function(target)
	if target ~= -1 then
		TriggerClientEvent('sContext:dragclient', target, source)
	end
end)
