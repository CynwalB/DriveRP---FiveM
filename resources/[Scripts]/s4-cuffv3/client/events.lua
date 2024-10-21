local AeroEvent = TriggerServerEvent
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        player = ESX.GetPlayerData()
        Citizen.Wait(10)
    end
end)

local mylicenseClient = {}
local lSelected = {}

animName = "" 
animDict = "" 
cuffed = false
cuffs = nil
ped = nil
rope = nil 
elrope = nil
bagliyim = false
HaveBagOnHead = false
cuval = nil
zatenbantli = false
dragStatus = {
	isDragged = false,
	carry_status = false,
	copId = 0
}
pped = nil 
tped = nil
bagliyorum = false
trackedPlayers = {}

RegisterNetEvent("cuff:client:shock")
AddEventHandler("cuff:client:shock", function()
	local dict = "stungun@standing"
	RequestAnimDict(dict) 

	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end

    TaskPlayAnim(GetPlayerPed(-1), dict, "damage", 8.0, 1.0, 1500, 1, 0, false, false, false)

	for i = 0, 15, 1 do 
		SetEntityHealth(GetPlayerPed(-1), GetEntityHealth(GetPlayerPed(-1)) - 1)
		Citizen.Wait(100)
	end

	SetPedToRagdoll(GetPlayerPed(-1), 4000, 4000, 0, 0, 0, 0)
end)

RegisterNetEvent('s4-cuff:drag')
AddEventHandler('s4-cuff:drag', function(cop)


    if not cop  then 
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        
        if closestPlayer ~= -1 and closestDistance <= 2.0 then
            TriggerServerEvent('s4-cuff:drag', GetPlayerServerId(closestPlayer))
        else
			ESX.ShowNotification(Config.Lang["no_one_nearby_cuff"], "error")
        end 

        return
    end
 
    dragStatus.isDragged = not dragStatus.isDragged
    dragStatus.CopId = cop
	dragStatus.carry_status = true
end)

RegisterNetEvent('s4-cuff:client:halat')
AddEventHandler('s4-cuff:client:halat', function()
   local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

   if closestPlayer ~= -1 and closestDistance <= 2.0 then

	bagliyorum = true

	local dict = "amb@prop_human_bum_bin@idle_a"
	RequestAnimDict(dict) 
   
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end
   
	TaskPlayAnim(GetPlayerPed(-1), dict, "idle_a", 8.0, 1.0, 3000, 1, 0, false, false, false)

	TriggerServerEvent('s4-cuff:client:halat_baglanan', GetPlayerServerId(closestPlayer))
	TriggerEvent("s4-cuff:client:halat_baglayan")

	Wait(3000)

	bagliyorum = false
   	else
		ESX.ShowNotification(Config.Lang["no_one_nearby_cuff"], "error")
   	end 
end)
 
RegisterNetEvent('s4-cuff:client:halat_baglayan')
AddEventHandler('s4-cuff:client:halat_baglayan', function()
	if not IsPedSittingInAnyVehicle(PlayerPedId()) then
		return
	end

	if bagliyim == true then 
		return
	end

	local dict = "amb@prop_human_bum_bin@idle_a"
	RequestAnimDict(dict) 

	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end

    TaskPlayAnim(GetPlayerPed(-1), dict, "idle_a", 8.0, 1.0, 1500, 1, 0, false, false, false)

	ped = GetPlayerPed(PlayerId())
	loadModel("prop_trevor_rope_01")
	loadDict("anim@heists@fleeca_bank@scope_out@return_case")
	TaskPlayAnim(GetPlayerPed(PlayerId()), "anim@heists@fleeca_bank@scope_out@return_case", "trevor_action", 2.0, 2.0, 1.5, 2, 0, false, false, false)
	Wait(2000)
	FreezeEntityPosition(GetPlayerPed(PlayerId()), true)
	elrope = CreateObject(GetHashKey("prop_trevor_rope_01"), GetPlayerPed(PlayerId()), true, true, true);

	networkId = ObjToNet(elrope)
	SetNetworkIdExistsOnAllMachines(networkId, true)
	SetNetworkIdCanMigrate(networkId, false)
	NetworkSetNetworkIdDynamic(networkId, true)

	AttachEntityToEntity(elrope, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 60309), 0.20, 0.0, 0.0, 265.0, -10.0, 100.0, true, false, false, false, 0, true);
 
	SetPedUsingActionMode(GetPlayerPed(PlayerId()), false, -1, "DEFAULT_ACTION")
	SetPedMovementClipset(GetPlayerPed(PlayerId()), 'move_ped_crouched', 0.55)
	SetPedStrafeClipset(GetPlayerPed(PlayerId()), 'move_ped_crouched_strafing')
	TaskPlayAnim(GetPlayerPed(PlayerId()), "mp_arresting", "a_uncuff", 2.0, 2.0, 1.5, 16, 0, false, false, false)
	Wait(2000)

	DeleteObject(elrope)
	FreezeEntityPosition(GetPlayerPed(PlayerId()), false)
end)

RegisterNetEvent('s4-cuff:client:halat_baglanan')
AddEventHandler('s4-cuff:client:halat_baglanan', function()
	ped = GetPlayerPed(PlayerId())
    if bagliyim == false then 
		bagliyim = true
		loadModel("prop_trevor_rope_01")
		loadDict("anim@heists@fleeca_bank@scope_out@return_case")
		loadDict("anim@amb@business@bgen@bgen_no_work@")
		TaskPlayAnim(ped, "anim@amb@business@bgen@bgen_no_work@", "sit_phone_phoneputdown_idle_nowork", 2.0, 2.0, 1.5, 2, 0, false, false, false)
		Wait(2000)
		FreezeEntityPosition(ped, true)
		Wait(2000)
		rope = CreateObject(GetHashKey("prop_trevor_rope_01"), ped, true, true, true);
		networkId = ObjToNet(rope)
		SetNetworkIdExistsOnAllMachines(networkId, true)
		SetNetworkIdCanMigrate(networkId, false)
		NetworkSetNetworkIdDynamic(networkId, true)
		AttachEntityToEntity(rope, ped, GetPedBoneIndex(GetPlayerPed(PlayerId()), 36864), 0.55, 0.09, -0.13, 265.0, -10.0, 100.0, true, false, false, false, 0, true);
	else 
		ClearPedTasks(PlayerPedId()) 
		DeleteEntity(ped)
		DeleteObject(rope)
		DeleteObject(elrope)
		DeleteEntity(tped)
		bagliyim = false
		FreezeEntityPosition(GetPlayerPed(PlayerId()), false)
		ClearPedProp(GetPlayerPed(-1), "prop_trevor_rope_01")
	end
	
end)
 
RegisterNetEvent('s4-cuff:client:cuval')
AddEventHandler('s4-cuff:client:cuval', function(bag)
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

	if closestPlayer ~= -1 and closestDistance <= 2.0 then

		local dict = "amb@prop_human_bum_bin@idle_a"
		RequestAnimDict(dict) 
	
		while not HasAnimDictLoaded(dict) do
			RequestAnimDict(dict)
			Citizen.Wait(0)
		end

		TaskPlayAnim(GetPlayerPed(-1), dict, "idle_a", 8.0, 1.0, 1500, 1, 0, false, false, false)

	  	TriggerServerEvent('s4-cuff:client:cuval', GetPlayerServerId(closestPlayer))

		Wait(1500)

		if bag then 
			HaveBagOnHead = bag 
		end
	else
		ESX.ShowNotification(Config.Lang["no_one_nearby_cuff"], "error")
	end 
	
end)

RegisterNetEvent('s4-cuff:client:kafacuval') 
AddEventHandler('s4-cuff:client:kafacuval', function()
    local playerPed = GetPlayerPed(-1)

	if HaveBagOnHead == false then 
		cuval = CreateObject(GetHashKey("prop_money_bag_01"), 0, 0, 0, true, true, true) -- Create head bag object!
		AttachEntityToEntity(cuval, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 12844), 0.2, 0.04, 0, 0, 270.0, 60.0, true, true, false, true, 1, true) -- Attach object to head
		SetEntityCompletelyDisableCollision(cuval, false, true)
		SetNuiFocus(false,false)
		SendNUIMessage({action = 'open_headbag'})
		HaveBagOnHead = true
    else
		DeleteEntity(cuval)
		HaveBagOnHead = false
		SendNUIMessage({action = 'close_headbag'})
	end
end)    

RegisterNetEvent('s4-cuff:client:agzaparaa')
AddEventHandler('s4-cuff:client:agzaparaa', function()
	loadDict("anim@heists@fleeca_bank@scope_out@return_case")
	TaskPlayAnim(GetPlayerPed(PlayerId()), "anim@heists@fleeca_bank@scope_out@return_case", "trevor_action", 2.0, 2.0, 1.5, 2, 0, false, false, false)
	Wait(2000)
	FreezeEntityPosition(GetPlayerPed(PlayerId()), false)
	ClearPedTasks(PlayerPedId()) 
end)

RegisterNetEvent('s4-cuff:client:agzapara')
AddEventHandler('s4-cuff:client:agzapara', function(tip)
	DeleteEntity(ped)
	DeleteObject(rope)
	DeleteObject(elrope)
	DeleteEntity(tped)

	if zatenbantli == true then zatenbantli = false return end 

	if tip == 0 then 
		loadModel("prop_anim_cash_note_b")
		elrope = CreateObject(GetHashKey("prop_anim_cash_note_b"), GetPlayerPed(PlayerId()), true, true, true);
		AttachEntityToEntity(elrope, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 20178), 0.082, 0.0, -0.01, 0.0, 90.0, 0.0, true, false, false, false, 0, true);
		zatenbantli = true
	else
		loadModel("prop_cash_pile_02")
		elrope = CreateObject(GetHashKey("prop_cash_pile_02"), GetPlayerPed(PlayerId()), true, true, true);
		AttachEntityToEntity(elrope, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 20178), 0.020, 0.0, -0.01, 0.0, 0.0, 90.0, true, false, false, false, 0, true);
		zatenbantli = true
	end
end)

RegisterNetEvent('s4-cuff:client:putVehicle')
AddEventHandler('s4-cuff:client:putVehicle', function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

	if closestPlayer ~= -1 and closestDistance <= 2.0 then
  
	  TriggerServerEvent('s4-cuff:client:cuval', GetPlayerServerId(closestPlayer))

	else
		ESX.ShowNotification(Config.Lang["no_one_nearby_cuff"], "error")
	end 
end)
 
RegisterNetEvent('s4-cuff:client:OutVehicle')
AddEventHandler('s4-cuff:client:OutVehicle', function()
	local playerPed = PlayerPedId()

	if not IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
end)

RegisterNetEvent('s4-cuff:client:putInVehicle')
AddEventHandler('s4-cuff:client:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
 
	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				dragStatus.isDragged = false
			end
		end
	end
end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
		return
	end
 
	DeleteEntity(ped)
	DeleteObject(rope)
	DeleteObject(elrope)
	DeleteEntity(tped)
		  
	DeleteEntity(cuval)
	Citizen.Wait(0)
end)

RegisterNetEvent('s4-cuff:client:use')
AddEventHandler('s4-cuff:client:use', function()
   	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

   	if closestPlayer ~= -1 and closestDistance <= 2.0 then
		local searchPlayerPed = GetPlayerPed(closestPlayer)
		if true then
			local dist = #(vector3(GetEntityHeading(PlayerPedId()),GetEntityHeading(PlayerPedId()),GetEntityHeading(PlayerPedId())) - vector3(GetEntityHeading(GetPlayerPed(closestPlayer)),GetEntityHeading(GetPlayerPed(closestPlayer)),GetEntityHeading(GetPlayerPed(closestPlayer))) )

			if dist < 200.0 then
				TriggerServerEvent('s4-cuff:server:ProcessCuffs', 0, GetPlayerServerId(closestPlayer))
			else 
				TriggerServerEvent('s4-cuff:server:ProcessCuffs', 1, GetPlayerServerId(closestPlayer))
			end

			AeroEvent("s4-cuff:IsCuff", GetPlayerServerId(closestPlayer))
			
			TriggerServerEvent("s4-sound:server:addQueue", "https://raw.githubusercontent.com/0resmon/db/main/sound/handcuff.mp3", 5, 3000)
			
			TaskPlayAnim(PlayerPedId(), "mp_arresting", "a_uncuff", 8.0, -8, -1, 49, 0, false, false, false) 
			Wait(2000)
			ClearPedTasks(PlayerPedId()) 
		else
			ESX.ShowNotification(Config.Lang["no_one_nearby_cuff2"], "error")
		end
   	else
		ESX.ShowNotification(Config.Lang["no_one_nearby_cuff"], "error")
   	end 
end)

RegisterNetEvent('s4-cuff:client:useLockpick')
AddEventHandler('s4-cuff:client:useLockpick', function()
   	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	local target = GetPlayerServerId(closestPlayer)

	if closestPlayer ~= -1 and closestDistance <= 2.0 then
		ESX.TriggerServerCallback("s4-cuff:PlayerIsCuff", function(cuff)
			if cuff then

					-- ESX.TriggerServerCallback('s4-cuff:getCuff', function(result)
					-- 	mylicenseClient = result
					-- 	for k,v in pairs(mylicenseClient) do
					-- 		lSelected = v
					-- 		if v.Cuff == 0 then
					-- 			return
					-- 		else
					-- 			TriggerServerEvent('s4-cuff:removeCuff', lSelected.Owner)

					local dist = #(vector3(GetEntityHeading(PlayerPedId()),GetEntityHeading(PlayerPedId()),GetEntityHeading(PlayerPedId())) - vector3(GetEntityHeading(GetPlayerPed(closestPlayer)),GetEntityHeading(GetPlayerPed(closestPlayer)),GetEntityHeading(GetPlayerPed(closestPlayer))) )

					AeroEvent("s4-cuff:NotCuff", GetPlayerServerId(closestPlayer))

					TriggerServerEvent('s4-cuff:server:RemoveCuffs', 1, GetPlayerServerId(closestPlayer))

					TriggerServerEvent("s4-sound:server:addQueue", Config.HandcuffSound, 5, 3000)

					TaskPlayAnim(PlayerPedId(), "mp_arresting", "a_uncuff", 8.0, -8, -1, 49, 0, false, false, false) 
					Wait(2000)
					ClearPedTasks(PlayerPedId()) 
					-- end
					-- 	end
					-- end, GetPlayerServerId(closestPlayer))
			else
				ESX.ShowNotification("~r~La personne n'est pas menottée.")
			end
		end, GetPlayerServerId(closestPlayer))
	else
		ESX.ShowNotification(Config.Lang["no_one_nearby_cuff"], "error")
	end
end)

RegisterNetEvent("cuff:client:useElectronicCuff")
AddEventHandler("cuff:client:useElectronicCuff", function() 
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

	if closestPlayer ~= -1 and closestDistance <= 2.0 then
	 	local dist = #(vector3(GetEntityHeading(PlayerPedId()),GetEntityHeading(PlayerPedId()),GetEntityHeading(PlayerPedId())) - vector3(GetEntityHeading(GetPlayerPed(closestPlayer)),GetEntityHeading(GetPlayerPed(closestPlayer)),GetEntityHeading(GetPlayerPed(closestPlayer))) )

		TriggerServerEvent("cuff:server:electroCuffPlayer", GetPlayerServerId(closestPlayer), GetPlayerPed(closestPlayer))

	 	TaskPlayAnim(PlayerPedId(), "mp_arresting", "a_uncuff", 8.0, -8, -1, 49, 0, false, false, false) 

     	Wait(2000)

     	ClearPedTasks(PlayerPedId()) 
   	else
		ESX.ShowNotification(Config.Lang["no_one_nearby_cuff"], "error")
   	end 
end)

RegisterNetEvent('s4-cuff:client:RemoveCuffs')
AddEventHandler('s4-cuff:client:RemoveCuffs', function()
    if cuffed == true then 
		cuffed = false
		startAnim()
	end

	player = PlayerPedId() 
    SetEnableHandcuffs(player, false) 
    SetPedCanPlayGestureAnims(player, true) 
    SetPedPathCanUseLadders(player, true) 
	ClearPedTasks(player) 
	DeleteEntity(cuffs)
	disableControls()
	setIMG(Config.HandcuffDefaultIMG) 
	TriggerEvent("inventory:setbool", false)
end)

RegisterNetEvent('s4-cuff:client:ProcessCuffs')
AddEventHandler('s4-cuff:client:ProcessCuffs', function(x)
    ProcessCuffs(x)

	if cuffs then 
	   DeleteEntity(cuffs)
	   cuffs = nil
	end

	cuffs = CreateObject(GetHashKey("p_cs_cuffs_02_s"), GetEntityCoords(PlayerPedId()), true, true, true);
	local networkId = ObjToNet(cuffs)
	SetNetworkIdExistsOnAllMachines(networkId, true)
    SetNetworkIdCanMigrate(networkId, false)
    NetworkSetNetworkIdDynamic(networkId, true)
	
	if x == 0 then 
	   AttachEntityToEntity(cuffs, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 60309), -0.055, 0.06, 0.04, 265.0, 155.0, 80.0, true, false, false, false, 0, true);
	else 
       AttachEntityToEntity(cuffs, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 60309), -0.058, 0.005, 0.090, 290.0, 95.0, 120.0, true, false, false, false, 0, true);
	end
	
    setIMG(Config.HandcuffIMG) 
	TriggerEvent("inventory:setbool", true)
	disableControls()
end)

AddEventHandler('onResourceStop', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  DeleteEntity(cuffs)
  setIMG(Config.HandcuffDefaultIMG) 
end)

RegisterNetEvent("cuff:client:action")
AddEventHandler("cuff:client:action", function(data) 
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

	x = {
		["arac_bin"] = function()
			if closestPlayer ~= -1 and closestDistance <= 3.0 then
				TriggerServerEvent('s4-cuff:client:putInVehicle', GetPlayerServerId(closestPlayer))
		    end
		end,
		["arac_in"] = function()
			if closestPlayer ~= -1 and closestDistance <= 3.0 then
				TriggerServerEvent('s4-cuff:client:OutVehicle', GetPlayerServerId(closestPlayer))
			end
		end,
		["bacak_coz"] = function()
			TriggerEvent('s4-cuff:client:halat')
		end,
		["bant"] = function()
			TriggerServerEvent('s4-cuff:client:agzapara', 0, GetPlayerServerId(closestPlayer))
		end,
		["money"] = function()
			TriggerServerEvent('s4-cuff:client:agzapara', 1, GetPlayerServerId(closestPlayer))
		end,
		["tasi"] = function()
			TriggerEvent('s4-cuff:drag')
		end,
		["birak"] = function()
			TriggerEvent('s4-cuff:drag')
		end,
		["close"] = function() end,
	}

	if closestPlayer ~= -1 then 
		local data = data.action
		if data == "bant_cikar" then 
			OpenRemoveBandMenu()
			return
		end
		x[data]()
	else
		ESX.ShowNotification(Config.Lang["no_one_nearby_cuff"], "error")
	end
end)

RegisterNetEvent("cuff:client:showElectronicCuffTrackMenu")
AddEventHandler("cuff:client:showElectronicCuffTrackMenu", function() 
	ESX.TriggerServerCallback("cuff:server:getElectroCuffedPlayers", function(electroCuffedPlayers) 

		for k,v in ipairs(electroCuffedPlayers) do 
			local gpsEnabled = false

			for _, trackedPlayer in ipairs(trackedPlayers) do 
				if trackedPlayer.id == v.id then 
					gpsEnabled = true
				end
			end

			electroCuffedPlayers[k].gpsEnabled = gpsEnabled
		end

	    SendNUIMessage({
	    	action = "show",
	    	players = electroCuffedPlayers,
	    	realtimeGPS = Config.RealtimeGPS
	    })

	    SetNuiFocus(true, true)
    end)
end)

RegisterNetEvent("cuff:client:hideElectronicCuffTrackMenu")
AddEventHandler("cuff:client:hideElectronicCuffTrackMenu", function() 
	SendNUIMessage({
		action = "hide"
	})
end)