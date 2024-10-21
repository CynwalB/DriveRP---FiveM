Citizen.CreateThread(function()
	RequestAnimDict("anim@move_m@prisoner_cuffed") 
    RequestAnimDict("mp_arresting") 
	RequestAnimDict("anim@apt_trans@garage") 
	RequestModel(GetHashKey("p_cs_cuffs_02_s"))
end)

Citizen.CreateThread(function()
	while true do 
		if not cuffed then
			if IsControlJustPressed(1, 288) then 
				OpenGeneralMenu()
				
				Wait(1000)
			end
		end
		
		Citizen.Wait(0)
	end
end)

local carry_status = false
Citizen.CreateThread(function()
    local playerPed
    local targetPed

    while true do
        Citizen.Wait(1)
 
        playerPed = PlayerPedId()
            
        if dragStatus.isDragged then
            targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))
             
            if not IsPedSittingInAnyVehicle(targetPed) then
                AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            else
                dragStatus.isDragged = false
                DetachEntity(playerPed, true, false)
            end

            if IsPedDeadOrDying(targetPed, true) then
                dragStatus.isDragged = false
                DetachEntity(playerPed, true, false)
            end
        else
			if dragStatus.carry_status then 
            	dragStatus.carry_status = false
            	DetachEntity(playerPed, true, false)
			end
        end
         
    end
end)

if Config.RealtimeGPS then 
    Citizen.CreateThread(function() 
    	while true do 
            ESX.TriggerServerCallback("cuff:server:getElectroCuffedPlayers", function(electroCuffedPlayers)
                for k,v in ipairs(electroCuffedPlayers) do 
                    local gpsEnabled = false

                    for _,trackedPlayer in ipairs(trackedPlayers) do 
                        if trackedPlayer.id == v.id then 
                            gpsEnabled = true
                        end
                    end

    		    	if gpsEnabled then 
    		    		v.blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
          	    		SetBlipSprite(v.blip, 303)
          	    		SetBlipDisplay(v.blip, 4)
          	    		SetBlipScale(v.blip, 0.7)
          	    		SetBlipColour(v.blip, 1)
          	    		SetBlipAsShortRange(v.blip, true)
    	  	    		BeginTextCommandSetBlipName("STRING")
          	    		AddTextComponentString("GPS: " .. v.name)
          	    		EndTextCommandSetBlipName(v.blip)

    		    		Citizen.Wait(Config.RealtimeGPSRefreshMS)

    		    		RemoveBlip(v.blip)
    		    	end
    		    end
            end)

            Citizen.Wait(Config.RealtimeGPSRefreshMS)
    	end
    end)
end

Citizen.CreateThread(function() 
	while true do 
		if not bagliyim then 
			ClearPedProp(GetPlayerPed(-1), "prop_trevor_rope_01")
		end

		Citizen.Wait(500)
	end
end)