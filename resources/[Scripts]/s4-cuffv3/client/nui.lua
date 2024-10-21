RegisterNUICallback("close", function() 
	SendNUIMessage({
		action = "hide"
	})

	SetNuiFocus(false, false)
end)

RegisterNUICallback("shockPlayer", function(player) 
	TriggerServerEvent("cuff:server:shockPlayer", player.id)
end)

RegisterNUICallback("toggleGPS", function(player, cb) 
    if player.gpsEnabled then 
        table.insert(trackedPlayers, player)
    else
        for k,v in ipairs(trackedPlayers) do 
            if v.id == player.id then
                table.remove(trackedPlayers, k) 
                break
            end
        end
    end

    cb(true)
end)

RegisterNUICallback("markGPS", function(player)
    SetNewWaypoint(player.coords.x, player.coords.y)
end)

RegisterNUICallback("unlockPlayer", function(player) 
	TriggerServerEvent("cuff:server:disableElectroCuff", player)
end)