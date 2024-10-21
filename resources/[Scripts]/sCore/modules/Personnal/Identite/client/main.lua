local AeroEvent = TriggerServerEvent
ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
end)
SneakyEvent = AeroEvent
Citizen.CreateThread(function()
    --print("Checking your identity")
    SneakyEvent("sIdentity:requestIdentity")
end)

AddEventHandler("playerSpawned", function()
    --print("Checking your identity")
    SneakyEvent("sIdentity:requestIdentity")
end)

local identity = {}

RegisterNetEvent("sIdentity:resultRequest")
AddEventHandler("sIdentity:resultRequest", function(result)
    if result == nil then 
        return 
    end
    identity = result
end)

function GetIdentity()
    --print("GetThe identity "..identity.firstname)
    return identity
end

RegisterNetEvent("Sneakylife:ShowCard")
AddEventHandler("Sneakylife:ShowCard", function(identity,licenses)
    --print(ESX.DumpTable(identity))
    if identity.firstname == nil then
        identity.firstname = "Inconnue"
    end
    if identity.lastname == nil then
        identity.lastname = "Inconnue"
    end
    if identity.birthday == nil then
        identity.birthday = "Inconnue"
    end
    if identity.height == nil then
        identity.height = "Inconnue"
    end
    if licenses == nil or #licenses == 0 then
        ESX.ShowNotification("Vous n'avez aucune license !")
    else
      for i = 1, #licenses, 1 do
          ESX.ShowNotification("Vos licenses acquises ↓~n~~q~"..licenses[i].type)
      end
    end
    ESX.ShowNotification("Identité :\nPrénom : ~q~"..identity.firstname.."\n~s~Nom : ~q~"..identity.lastname.."\n~s~Date de naissance : ~q~"..identity.birthday.."\n~s~Taille : ~q~"..identity.height.."~s~")
end)

RegisterNetEvent("SneakyLife:RequestShowCard")
AddEventHandler("SneakyLife:RequestShowCard", function(type)
	if type == "me" then
		SneakyEvent("Sneakyjsfour-idcard:open", GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
	else
		local playerdst, distance = ESX.Game.GetClosestPlayer()
		if playerdst ~= -1 and distance <= 2.0 then
			SneakyEvent("Sneakyjsfour-idcard:open", GetPlayerServerId(PlayerId()), GetPlayerServerId(playerdst))
		else
			ESX.ShowNotification("Il n'y a personne à côté de vous")
		end
	end
end)

