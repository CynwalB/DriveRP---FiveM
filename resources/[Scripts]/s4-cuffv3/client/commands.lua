RegisterCommand("silyakindakinpc", function(source, args, rawCommand)
	local ped, dist = GetClosestAliveNPC() -- You can pass coords, or leave blank for player coords
 
	DeleteEntity(ped)
end)

RegisterCommand("bant", function(source, args, rawCommand)
	while DoesEntityExist(elrope) do 
		DeleteEntity(ped)
		DeleteObject(rope)
		DeleteObject(elrope)
		DeleteEntity(tped)
		
		Citizen.Wait(0)
	 end
	loadModel("prop_cash_pile_02")
	elrope = CreateObject(GetHashKey("prop_cash_pile_02"), GetPlayerPed(PlayerId()), true, true, true);
	AttachEntityToEntity(elrope, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 20178), 0.020, 0.0, -0.01, 0.0, 0.0, 90.0, true, false, false, false, 0, true);

end)

RegisterCommand("bant2", function(source, args, rawCommand)
	loadModel("prop_anim_cash_note_b")
	elrope = CreateObject(GetHashKey("prop_anim_cash_note_b"), GetPlayerPed(PlayerId()), true, true, true);
	AttachEntityToEntity(elrope, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 20178), 0.082, 0.0, -0.01, 0.0, 90.0, 0.0, true, false, false, false, 0, true);

end)

RegisterCommand("coz", function(source, args, rawCommand)
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
	setIMG(Config.HandcuffDefaultIMG) 
	disableControls()
	
end, true)

RegisterCommand("halatbagla", function(source, args, rawCommand)
	loadModel("mp_m_freemode_01")
	ped = CreatePed(1, GetHashKey("mp_m_freemode_01"), vector3(-1732.141, -661.345, 10.39124), 0.0)
	loadModel("prop_trevor_rope_01")
   
	loadDict("anim@heists@fleeca_bank@scope_out@return_case")
	loadDict("anim@amb@business@bgen@bgen_no_work@")
	TaskPlayAnim(ped, "anim@amb@business@bgen@bgen_no_work@", "sit_phone_phoneputdown_idle_nowork", 2.0, 2.0, 1.5, 2, 0, false, false, false)
	TaskPlayAnim(GetPlayerPed(PlayerId()), "anim@heists@fleeca_bank@scope_out@return_case", "trevor_action", 2.0, 2.0, 1.5, 2, 0, false, false, false)
  
	Wait(2000)
	  
	FreezeEntityPosition(ped, true)
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
	rope = CreateObject(GetHashKey("prop_trevor_rope_01"), ped, true, true, true);
  
	networkId = ObjToNet(rope)
	SetNetworkIdExistsOnAllMachines(networkId, true)
	SetNetworkIdCanMigrate(networkId, false)
	NetworkSetNetworkIdDynamic(networkId, true)
  
	AttachEntityToEntity(rope, ped, GetPedBoneIndex(GetPlayerPed(PlayerId()), 36864), 0.50, 0.09, 0.06, 265.0, -10.0, 100.0, true, false, false, false, 0, true);
	ClearPedTasks(PlayerPedId()) 
   
	DeleteObject(elrope)
  
	FreezeEntityPosition(GetPlayerPed(PlayerId()), false)
end, true)