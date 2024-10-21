ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler("sneakylife:banPlayer", function(source, reason)
	local playerSrc = source
	if (not playerSrc) then return 

	banPlayerAC(source, reason)
    end
end)

local function getAllLicense(source)
    for k,v in pairs(GetPlayerIdentifiers(source))do
    end
end

local function getPlayerLicense(source)
    getAllLicense(source)
    for k,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            return v
        end
    end
end

AddEventHandler('playerDropped', function(raison)
    if raison == "Exiting" then
        raison = "F8 QUIT/ALT F4"
    end
    local name = GetPlayerName(source)
    local identifier = getPlayerLicense(source)
    SendLogs(15158332,"Serveur - Déconnexion","**"..name.."** vient de se déconnecter raison : ***"..raison.."***\n **License** : "..identifier,"https://discord.com/api/webhooks/1151184266852577290/tpzRe9OZIo-HouA_XuYq_szWxfBKH9tjezVzEWt0cpvufRfdPSFFNBhxVXJsufOES-D0")
    RconPrint("^2["..GetCurrentResourceName().."] ^0: ^1Déconnexion^0 du joueur : ^5"..name.."^0 raison : ^5"..raison.."\n")
end)
