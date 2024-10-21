local AeroEvent = TriggerServerEvent
local AmbulanceMenu = {}
local IsBusy = false
local count = 0
local AmbulancePharmacie = {}
local AmbulanceRdv = {}
local AppelerCooldown = false
SneakyEvent = AeroEvent
local Ambulance = {

    PositionPharmacie = {
        --{coords = vector3(305.96969604492,-580.40905761719,43.281585693359-0.9)},
		{coords = vector3(311.01016845703,-566.019775390625,43.2898637771606-0.9)},
		--{coords = vector3(320.37698364258,-571.20159912109,43.281627655029-0.9)},
    },
	PositionRdv = {
		{coords = vector3(349.5476074219,-587.48359375,28.808637771606-0.9)},
		{coords = vector3(308.376074219,-595.46359375,43.2808637771606-0.9)},
--        {coords = vector3(342.75476074219,-588.8359375,28.898637771606-0.9)},
--		{coords = vector3(345.00256347656,-582.27069091797,28.898637771606-0.9)},
--		{coords = vector3(303.50527954102,-597.88916015625,43.292797088623-0.9)},
--		{coords = vector3(309.68585205078,-595.18615722656,43.292762756348-0.9)},
    },
}

RegisterNetEvent('sCore:animation')
AddEventHandler('sCore:animation', function()
    Citizen.CreateThread(function()
        local ped = PlayerPedId()
--        RequestAnimDict('move_m@_idles@shake_off') paper_1_rcm_alt1-9
--        TaskPlayAnim(ped, 'move_m@_idles@shake_off', 'move_m@_idles@shake_off', 8.0, -8, 10.0, 49, 0, 0, 0, 0)
        RequestAnimDict('mp_common')
        TaskPlayAnim(ped, 'mp_common', 'givetake1_a', 8.0, -8, 10.0, 49, 0, 0, 0, 0)
        Citizen.Wait(3500)
        ClearPedSecondaryTask(ped)
    end)
end)

RegisterNetEvent('Ems:Rdv')
AddEventHandler('Ems:Rdv', function(pinfo)
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
        ESX.ShowNotification("~q~Pillbox Hill\n~s~Une personne demande un ~q~médecin.")
		Citizen.Wait(100)
    end
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
    while true do
        att = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
		for k,v in pairs(Ambulance.PositionPharmacie) do
            local mPos = #(pCoords-v.coords)

			if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
				if not AmbulancePharmacie.Menu then
					if mPos <= 4.0 then
--						DrawText3D(v.coords.x, v.coords.y, v.coords.z+1, "Appuyez sur ~q~E~s~ pour accéder à la ~q~pharmacie~s~.", 9)
						att = 1
						if mPos <= 1.5 then
							ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder à ~q~l'armoire~s~.")
							if IsControlJustPressed(0, 51) then
							OpenAmbulancePharmacieRageUIMenu()
							end
						end 
					end
				end
			end

        	end
		for k,v in pairs(Ambulance.PositionRdv) do
            local mPos = #(pCoords-v.coords)

			if not AmbulanceRdv.Menu then
				if mPos <= 3.0 then
					att = 1
					DrawText3D(v.coords.x, v.coords.y, v.coords.z+2, "Appuyez sur ~q~E~s~ pour demander un ~q~médecin~s~.", 9)
					if mPos <= 1.5 then
						--ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour demander un ~q~médecin~s~.")
						if IsControlJustPressed(0, 51) then
							OpenAmbulanceRdvRageUIMenu()
						end
					end 
				end
			end

		end
        Citizen.Wait(att)
    end
end)


RMenu.Add('ambulancerdv', 'main', RageUI.CreateMenu("", "",nil,nil,"root_cause","ambulance"))
RMenu:Get('ambulancerdv', 'main'):SetSubtitle("~q~Actions disponibles")
RMenu:Get('ambulancerdv', 'main').EnableMouse = false
RMenu:Get('ambulancerdv', 'main').Closed = function()
    AmbulanceRdv.Menu = false
end

function OpenAmbulanceRdvRageUIMenu()
	if AmbulanceRdv.Menu then
        AmbulanceRdv.Menu = false
    else
        AmbulanceRdv.Menu = true
        RageUI.Visible(RMenu:Get('ambulancerdv', 'main'), true)

        Citizen.CreateThread(function()
			while AmbulanceRdv.Menu do
                RageUI.IsVisible(RMenu:Get('ambulancerdv', 'main'), true, false, true, function()
					if AppelerCooldown == false then
						RageUI.Button("Appeler un médecin", false, {RightLabel = "~q~→ Sonner"}, not AppelerCooldown, function(h,a,s)
							if s then
								SneakyEvent("Ems:DemandeRdv","Une personne demande un médecin.")
								AppelerCooldown = true
                                Citizen.SetTimeout(1200000, function()
                                    AppelerCooldown = false
                                end)
							end
						end)
					else
						RageUI.Button("Appeler un médecin", nil, {RightBadge = RageUI.BadgeStyle.Lock},false, function()
						end)
					end
                end)
				Wait(0)
			end
		end)
	end
end



RMenu.Add('ambulancepharmacie', 'main', RageUI.CreateMenu("", "",nil,nil,"root_cause","ambulance"))
RMenu:Get('ambulancepharmacie', 'main'):SetSubtitle("~q~Produits disponibles")
RMenu:Get('ambulancepharmacie', 'main').EnableMouse = false
RMenu:Get('ambulancepharmacie', 'main').Closed = function()
    AmbulancePharmacie.Menu = false
end

function OpenAmbulancePharmacieRageUIMenu()
	if AmbulancePharmacie.Menu then
        AmbulancePharmacie.Menu = false
    else
        AmbulancePharmacie.Menu = true
        RageUI.Visible(RMenu:Get('ambulancepharmacie', 'main'), true)

        Citizen.CreateThread(function()
			while AmbulancePharmacie.Menu do
                RageUI.IsVisible(RMenu:Get('ambulancepharmacie', 'main'), true, false, true, function()
                    RageUI.Button("Medikit", false, {RightLabel = "~q~→ Prendre"}, true, function(h,a,s)
						if s then
							SneakyEvent('esx_ambulancejob:giveItem', "medikit")
						end
                    end)
					RageUI.Button("Bandage", false, {RightLabel = "~q~→ Prendre"}, true, function(h,a,s)
						if s then
							SneakyEvent('esx_ambulancejob:giveItem', "bandage")
						end
                    end)
					RageUI.Button("Perfusion", false, {RightLabel = "~q~→ Prendre"}, true, function(h,a,s)
						if s then
							SneakyEvent('esx_ambulancejob:giveItem', "perfusion")
						end
                    end)
					RageUI.Button("Fauteuil Roulant", false, {RightLabel = "~q~→ Prendre"}, true, function(h,a,s)
						if s then
							SneakyEvent('esx_ambulancejob:giveItem', "wheelchair")
						end
                    end)
					RageUI.Button("Lit", false, {RightLabel = "~q~→ Prendre"}, true, function(h,a,s)
						if s then
							SneakyEvent('esx_ambulancejob:giveItem', "bed")
						end
                    end)
                end)
				Wait(0)
			end
		end)
	end
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(_type)
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)

	if _type == 'small' then
		local health = GetEntityHealth(playerPed)
		local newHealth = math.min(maxHealth , math.floor(health + maxHealth / 8))
		SetEntityHealth(playerPed, newHealth)
	elseif _type == 'big' then
		SetEntityHealth(playerPed, maxHealth)
	end

	ESX.ShowNotification('Vous avez été ~q~soigné~s~.')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local AmbulanceActionMenu = {}


function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)

    while (UpdateOnscreenKeyboard() ~= 1) and (UpdateOnscreenKeyboard() ~= 2) do
        DisableAllControlActions(0)
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        return GetOnscreenKeyboardResult()
    else
        return nil
    end
end

function OpenAmbulanceActionMenuRageUIMenu()

	local Ambulance = {
		action = {
			"Regarder",
			"Montrer",
		},
		identite = 1,
	}

    if AmbulanceActionMenu.Menu then 
        AmbulanceActionMenu.Menu = false 
        RageUI.Visible(RMenu:Get('ambulanceactionmenu', 'main'), false)
        return
    else
        RMenu.Add('ambulanceactionmenu', 'main', RageUI.CreateMenu("", "",nil,nil,"root_cause","ambulance"))
        RMenu:Get('ambulanceactionmenu', 'main'):SetSubtitle("~q~Los Santos Medical Center")
        RMenu:Get('ambulanceactionmenu', 'main').EnableMouse = false
        RMenu:Get('ambulanceactionmenu', 'main').Closed = function()
            AmbulanceActionMenu.Menu = false
            ESX.PlayerData = ESX.GetPlayerData()
        end
        AmbulanceActionMenu.Menu = true 
        RageUI.Visible(RMenu:Get('ambulanceactionmenu', 'main'), true)
        Citizen.CreateThread(function()
			while AmbulanceActionMenu.Menu do
                RageUI.IsVisible(RMenu:Get('ambulanceactionmenu', 'main'), true, false, true, function()
                    ESX.PlayerData = ESX.GetPlayerData()
                    RageUI.Button("Réanimer", nil, { RightLabel = "→" },true, function(h,a,s)
						if s then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowAdvancedNotification('Ambulance', 'Message', 'aucun joueur à proximité', 'CHAR_CALL911', 1)
							else
								ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
									if qtty > 0 then
										local closestPed = GetPlayerPed(closestPlayer)

										ESX.TriggerServerCallback("EMS:PlayerIsDead", function(dead)
			
											if dead then
												local playerPed = PlayerPedId()
				
												IsBusy = true
												ESX.ShowAdvancedNotification('Ambulance', 'Message', 'Réanimation en cours...', 'CHAR_CALL911', 1)
												TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
												Wait(10000)
												ClearPedTasks(playerPed)
												SneakyEvent("EMS:RevivePLayer", GetPlayerServerId(closestPlayer))
												SneakyEvent('esx_ambulancejob:removeItem', 'medikit')
												IsBusy = false
												ESX.ShowNotification('Vous avez réanimer la personne')
											else
												ESX.ShowAdvancedNotification('Ambulance', 'Message', 'n\'est pas inconscient', 'CHAR_CALL911', 1)
											end
										end, GetPlayerServerId(closestPlayer))
									else
										ESX.ShowAdvancedNotification('Ambulance', 'Message', 'Vous n\'avez pas de ~q~kit de soin~w~.', 'CHAR_CALL911', 1)
									end
								end, 'medikit')
							end
						end
                    end)
                    RageUI.Button("Soigner petites blessures", nil, { RightLabel = "→" },true, function(h,a,s)
						if s then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowAdvancedNotification('Ambulance', 'Message', 'aucun joueur à proximité', 'CHAR_CALL911', 1)
							else
								ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
									if qtty > 0 then
										local closestPlayerPed = GetPlayerPed(closestPlayer)
										local idclosestped = GetPlayerServerId(closestPlayer)
										local health = GetEntityHealth(closestPlayerPed)
			
										if health > 0 then
											local playerPed = PlayerPedId()
			
											IsBusy = true
											ESX.ShowAdvancedNotification('Ambulance', 'Message', 'Vous êtes en train ~q~soigné~s~ la personne.', 'CHAR_CALL911', 1)
											TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
											Citizen.Wait(10000)
											ClearPedTasks(playerPed)
			
											SneakyEvent('esx_ambulancejob:removeItem', 'bandage')
											SneakyEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
											IsBusy = false
										else
											ESX.ShowAdvancedNotification('Ambulance', 'Message', 'Cette personne est inconsciente!', 'CHAR_CALL911', 1)
										end
									else
										ESX.ShowAdvancedNotification('Ambulance', 'Message', 'Vous n\'avez pas de ~q~bandage~w~.', 'CHAR_CALL911', 1)
									end
								end, 'bandage')
							end
						end
                    end)
					RageUI.Button("Soigner blessures graves", nil, { RightLabel = "→" },true, function(h,a,s)
						if s then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowAdvancedNotification('Ambulance', 'Message', 'aucun joueur à proximité', 'CHAR_CALL911', 1)
							else
								ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
									if qtty > 0 then
										local closestPlayerPed = GetPlayerPed(closestPlayer)
										local health = GetEntityHealth(closestPlayerPed)
			
										if health > 0 then
											local playerPed = PlayerPedId()
			
											IsBusy = true
											ESX.ShowAdvancedNotification('Ambulance', 'Message', 'Vous êtes en train de ~q~soigné~s~ la personne.', 'CHAR_CALL911', 1)
											TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
											Citizen.Wait(10000)
											ClearPedTasks(playerPed)
			
											SneakyEvent('esx_ambulancejob:removeItem', 'medikit')
											SneakyEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
											IsBusy = false
										else
											ESX.ShowAdvancedNotification('Ambulance', 'Message', 'Cette personne est inconsciente!', 'CHAR_CALL911', 1)
										end
									else
										ESX.ShowAdvancedNotification('Ambulance', 'Message', 'Vous n\'avez pas de ~q~kit de soin~w~.', 'CHAR_CALL911', 1)
									end
								end, 'medikit')
							end
						end
                    end)
					RageUI.Button("Attribuer une facture", nil, {RightLabel = "→"}, true,function(h,a,s)
						if s then
							RageUI.CloseAll()
							TriggerEvent("sBill:CreateBill","society_ambulance")
						end
					end)
					RageUI.Button("Gestion des appels", nil, { RightLabel = "→" },true, function(h,a,s)
						if s then
							RageUI.CloseAll()
							TriggerEvent("sCall:OpenCallMenu")
						end
                    end)
                    RageUI.List("Carte d'ambulancier", Ambulance.action, Ambulance.identite, nil, {}, true, function(h,a,s, Index)
                        if s then
							local player, distance = ESX.Game.GetClosestPlayer()          
                            if Index == 1 then
								ESX.TriggerServerCallback('esx_license:checkLicense', function(hasAmbulanceLicense)
									if hasAmbulanceLicense then
										ESX.ShowNotification("~r~Vous possèdez pas cette carte !")
									else
										TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'ambulance')
									end
								end, GetPlayerServerId(player), 'ambulance')
                            else
                                local player, distance = ESX.Game.GetClosestPlayer()

								ESX.TriggerServerCallback('esx_license:checkLicense', function(hasAmbulanceLicense)
									if hasAmbulanceLicense then
										ESX.ShowNotification("~r~Vous possèdez pas cette carte !")
									else
										if distance ~= -1 and distance <= 3.0 then
											TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'ambulance')
											TriggerEvent('sCore:animation')
										else
											ESX.ShowNotification('~r~Il n\'y a personne à côté de vous !')
										end
									end
								end, GetPlayerServerId(player), 'ambulance')
                            end
                        end
            
                        Ambulance.identite = Index
                    end)
					if ESX.PlayerData.job.grade_name == "boss"  then
						closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						RageUI.Button("Attribuer une carte d'ambulancier", nil, {RightLabel = "→"}, closestPlayer ~= -1 and closestDistance <= 3.0,function(h,a,s)
							if s then
								local player, distance = ESX.Game.GetClosestPlayer()  
								if distance <= 2.0 then
									ESX.TriggerServerCallback('esx_license:checkLicense', function(hasAmbulanceLicense)
										if not hasAmbulanceLicense then
											SneakyEvent("sAmbulance:addLicense", GetPlayerServerId(player), "ambulance")
										else
											ESX.ShowNotification("~r~La personne possède déjà une carte d'ambulancier !")
										end
									end, GetPlayerServerId(player), 'ambulance')
								else
									ESX.ShowNotification('~r~Erreur~s~ - Aucun joueur à proximité')
								end
							end
						end)
						RageUI.Button("Retirer une carte d'ambulancier", nil, {RightLabel = "→"}, closestPlayer ~= -1 and closestDistance <= 3.0,function(h,a,s)
							if s then
								local player, distance = ESX.Game.GetClosestPlayer()  
								if distance <= 2.0 then
									ESX.TriggerServerCallback('esx_license:checkLicense', function(hasAmbulanceLicense)
--										if not hasAmbulanceLicense then
										if hasAmbulanceLicense then
											SneakyEvent("sAmbulance:removeLicense", GetPlayerServerId(player), "ambulance")
										else
											ESX.ShowNotification("~r~La personne ne possède déjà pas de carte d'ambulancier !")
										end
									end, GetPlayerServerId(player), 'ambulance')
								else
									ESX.ShowNotification('~r~Erreur~s~ - Aucun joueur à proximité')
								end
							end
						end)
					end

                end)
				Wait(0)
			end
		end)
	end
end