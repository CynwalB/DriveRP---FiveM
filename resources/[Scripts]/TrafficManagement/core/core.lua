ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

function ShowNotification( text )
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(false, false)
end

local sz = nil


RegisterNetEvent('slowtraffic')
AddEventHandler('slowtraffic', function()

--if sz ~= nil then 
--RemoveSpeedZone(sz)
--ESX.ShowNotification("Traffic ~g~repris")
--sz = nil
--RemoveBlip(tcblip)
--else
ESX.ShowNotification("Traffic ~y~ralenti")
tcblip = AddBlipForRadius(GetEntityCoords(GetPlayerPed(-1)),70.0)
SetBlipAlpha(tcblip,80)
SetBlipColour(tcblip,5)
sz = AddSpeedZoneForCoord(GetEntityCoords(GetPlayerPed(-1)),70.0,5.0,false)

--end

end)
RegisterNetEvent('resumetraffic')
AddEventHandler('resumetraffic', function()
if sz ~= nil then 
RemoveSpeedZone(sz)
ESX.ShowNotification("Traffic ~g~repris")
sz = nil
RemoveBlip(tcblip)

end
end)
RegisterNetEvent('stoptraffic')
AddEventHandler('stoptraffic', function()

--if sz ~= nil then 
--RemoveSpeedZone(sz)
--ESX.ShowNotification("Traffic ~g~repris")
--sz = nil
--RemoveBlip(tcblip)
--else
ESX.ShowNotification("Traffic ~r~stoppé")
tcblip = AddBlipForRadius(GetEntityCoords(GetPlayerPed(-1)),70.0)
sz = AddSpeedZoneForCoord(GetEntityCoords(GetPlayerPed(-1)),70.0,0.0,false)
SetBlipAlpha(tcblip,80)
SetBlipColour(tcblip,1)

--end

end)
AddSpeedZoneForCoord(1447.4,754.4,77.59,75.0,10.0,false)
AddSpeedZoneForCoord(161.2,6544.5,31.8,40.0,10.0,false)