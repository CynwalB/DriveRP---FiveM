
 


ESX = nil
ENP = {}

Citizen.CreateThread(function()
    while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Citizen.Wait(0)
    end
end)

Config = {}
------- TOUCHES 
--Config.balle = 37  --[[ TAB ]]
Config.coupdepied1 = 91 --[[ CLIQUE DROIT ]]
Config.coupdepied2 = 38 --[[ E ]]
Config.pousser = 52 --[[ Q ]]
Config.balayer = 55 --[[ ESPACE ]]
Config.soulever = 49 --[[ F ]]

local football = false

RegisterCommand('football', function()
	football = not football
	if football then
		ESX.ShowNotification("Mode FootBall: ~g~Activé~s~")
	else 
		ESX.ShowNotification("Mode FootBall: ~r~Désactivé~s~")
	end
end)

function loadAnim( dict )
    while ( not HasAnimDictLoaded(dict) ) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

-------------  CRÉER LA BALLE 

function balle()
    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local forwardx = GetEntityForwardX(ped)
    local forwardy = GetEntityForwardY(ped)
    local prop = CreateObject(GetHashKey("p_ld_soc_ball_01"), coords.x + (forwardx * 1), coords.y + (forwardy * 1), coords.z - 0.88, (heading - 180), true, false, true)
    SetEntityLodDist(prop, 500)
    SetEntityDynamic(prop, true)
    SetEntityRecordsCollisions(prop, true)
    SetEntityHasGravity(prop, true)
    FreezeEntityPosition(prop, false)
    SetEntityVelocity(prop, 0, 0, 0)
    SetModelAsNoLongerNeeded(GetHashKey("p_ld_soc_ball_01"))
end

RegisterCommand('balle', function(source, args)
    local vip = exports.sCore:GetVIP()
    if vip == 0 then
        return
        ESX.ShowNotification("~g~ Online~s~RP~n~-Vous n'avez pas accès à cette fonctionnalité.~n~-Vous devez être VIP.")
    end
	local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local forwardx = GetEntityForwardX(ped)
    local forwardy = GetEntityForwardY(ped)
    local prop = CreateObject(GetHashKey("p_ld_soc_ball_01"), coords.x + (forwardx * 1), coords.y + (forwardy * 1), coords.z - 0.88, (heading - 180), true, false, true)
    SetEntityLodDist(prop, 500)
    SetEntityDynamic(prop, true)
    SetEntityRecordsCollisions(prop, true)
    SetEntityHasGravity(prop, true)
    FreezeEntityPosition(prop, false)
    SetEntityVelocity(prop, 0, 0, 0)
    SetModelAsNoLongerNeeded(GetHashKey("p_ld_soc_ball_01"))
end)
------------------ 


---------------- COUP DE PIED COURT

function coupdepied() 
	if football then
--		print('1')
		local ped = GetPlayerPed(-1)
		local coords = GetEntityCoords(ped)
		local heading = GetEntityHeading(ped)
		local forwardx = GetEntityForwardX(ped)
		local forwardy = GetEntityForwardY(ped)
		local prop = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1.5, GetHashKey("p_ld_soc_ball_01"), false, false, false)
		if prop then
			NetworkRequestControlOfEntity(prop)
			while not NetworkHasControlOfEntity(prop) do
				Citizen.Wait(100)
				return
			end
			loadAnim("misstrevor3_beatup")
			TaskPlayAnim(ped, "misstrevor3_beatup", "guard_beatup_kickidle_guard1", 8.0, -8.0, -1, 0, false, false, false)
			Citizen.Wait(750)
			ClearPedTasksImmediately(ped)
			SetEntityVelocity(prop, forwardx * 10, forwardy * 10, 0)
		end
	end
end

-------------- 



----------------COUP DE PIED MOYEN

function coupdepied2()
	if football then
		local ped = GetPlayerPed(-1)
		local coords = GetEntityCoords(ped)
		local heading = GetEntityHeading(ped)
		local forwardx = GetEntityForwardX(ped)
		local forwardy = GetEntityForwardY(ped)
		local prop = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1.5, GetHashKey("p_ld_soc_ball_01"), false, false, false)
		if prop then
			NetworkRequestControlOfEntity(prop)
			while not NetworkHasControlOfEntity(prop) do
				Citizen.Wait(100)
				return
			end
			loadAnim("misstrevor3_beatup")
			TaskPlayAnim(ped, "misstrevor3_beatup", "guard_beatup_kickidle_guard1", 8.0, -8.0, -1, 0, false, false, false)
			Citizen.Wait(750)
			ClearPedTasksImmediately(ped)
			local podbicie = math.floor((math.random() * 5) + 1)*2
			SetEntityVelocity(prop, forwardx * 40, forwardy * 40, podbicie)
		end
	end
end



-------------- 



---------------- POUSSER LA BALLE

function pousser() -- Pousser
	if football then
--		print('4')
		local ped = GetPlayerPed(-1)
		local coords = GetEntityCoords(ped)
		local heading = GetEntityHeading(ped)
		local forwardx = GetEntityForwardX(ped)
		local forwardy = GetEntityForwardY(ped)
		local prop = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1.5, GetHashKey("p_ld_soc_ball_01"), false, false, false)
		if prop then
			NetworkRequestControlOfEntity(prop)
			while not NetworkHasControlOfEntity(prop) do
				Citizen.Wait(100)
				return
			end
			loadAnim("misstrevor3_beatup")
			TaskPlayAnim(ped, "misstrevor3_beatup", "guard_beatup_kickidle_guard1", 8.0, -8.0, 750, 0, false, false, false)
			ClearPedTasksImmediately(ped)
			local podbicie = math.floor((math.random() * 3) + 1)*2
			SetEntityVelocity(prop, forwardx * 15, forwardy * 15, podbicie)
		end
	end
end

--------------




---------------- BALAYER POUR LA BALLE OU QQN
function balayer()
	if football then
--		print('5')
		local ped = GetPlayerPed(-1)
		local coords = GetEntityCoords(ped)
		local heading = GetEntityHeading(ped)
		local forwardx = GetEntityForwardX(ped)
		local forwardy = GetEntityForwardY(ped)
		local prop = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, GetHashKey("p_ld_soc_ball_01"), false, false, false)
		if prop then
			NetworkRequestControlOfEntity(prop)
			while not NetworkHasControlOfEntity(prop) do
				Citizen.Wait(100)
				return
			end
			loadAnim("missheistfbi3b_ig6_v2")
			TaskPlayAnim(ped, "missheistfbi3b_ig6_v2", "rubble_slide_alt_franklin", 8.0, -8.0, 2000, 0, false, false, false)
			Citizen.Wait(1000)
			local podbicie = math.floor((math.random() * 2) + 1)
			SetEntityVelocity(prop, forwardx * 40, forwardy * 40, podbicie)
			Citizen.Wait(100)
			ClearPedTasksImmediately(ped)
		end
	end
end



------------------ SOULEVER LA BALLE
function soulever()
	if football then
--		print('7')
		local ped = GetPlayerPed(-1)
		local coords = GetEntityCoords(ped)
		local heading = GetEntityHeading(ped)
		local forwardx = GetEntityForwardX(ped)
		local forwardy = GetEntityForwardY(ped)
		local prop = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, GetHashKey("p_ld_soc_ball_01"), false, false, false)
		if prop then
			NetworkRequestControlOfEntity(prop)
			while not NetworkHasControlOfEntity(prop) do
				Citizen.Wait(100)
				return
			end
			loadAnim("move_jump")
			TaskPlayAnim(ped, "move_jump", "jump_launch_long_l", 8.0, -8.0, -1, 0, false, false, false)
			Citizen.Wait(500)
			SetEntityVelocity(prop, forwardx * 12, forwardy * 12, 4.5)
			Citizen.Wait(350)
			ClearPedTasksImmediately(ped)
		end
	end
end


Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
		if IsControlJustReleased(0, Config.balle) and football then 
			balle()
		end
        if IsControlJustReleased(0, Config.coupdepied1) and football then 
			coupdepied()
		end
        if IsControlJustReleased(0, Config.coupdepied2) and football then 
			coupdepied2()
		end
        if IsControlJustReleased(0, Config.balayer) and football then 
			pousser()
		end
		if IsControlJustReleased(0, Config.balayer) and football then 
			balayer()
		end
        if IsControlJustReleased(0, Config.soulever) and football then 
			soulever()
		end
    end
end)

