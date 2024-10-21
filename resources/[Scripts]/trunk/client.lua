ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local plyPos = GetEntityCoords(PlayerPedId())
        local vehicle = VehicleInFront(plyPos)
        local trunk = GetEntityBoneIndexByName(vehicle, 'boot')

        local vehi = ESX.Game.GetClosestVehicle()
        local lockStatus = GetVehicleDoorLockStatus(vehi)

        if trunk ~= -1 then
            local coords = GetWorldPositionOfEntityBone(vehicle, trunk)
            if #(plyPos - coords) <= 1.5 then
                if not inTrunk then
                    if GetVehicleDoorAngleRatio(vehicle, 5) < 1.0 then
                        DrawText3D(coords.x, coords.y, coords.z, '[H] Ouvrir\n[E] Se cacher')
                        if IsControlJustReleased(0, 74) then
                            if lockStatus == 1 then
                                SetCarBootOpen(vehicle)
                            elseif lockStatus == 2 then
                                ESX.ShowNotification('~r~Le coffre est fermé.')
                            end
                        end
                    else
                        DrawText3D(coords.x, coords.y, coords.z, '[H] Fermer\n[E] Se cacher')
                        if IsControlJustReleased(0, 74) then
                            if lockStatus == 1 then
                                SetVehicleDoorShut(vehicle, 5)
                            elseif lockStatus == 2 then
                                ESX.ShowNotification('~r~Le coffre est fermé.')
                            end
                        end
                    end
                end

                local vehi = ESX.Game.GetClosestVehicle()
                local lockStatus = GetVehicleDoorLockStatus(vehi)

                if IsControlJustReleased(0, 38) and not inTrunk then
                    if lockStatus == 1 then
                        getInTrunk(vehicle)
                    elseif lockStatus == 2 then
                        ESX.ShowNotification('~r~Le coffre est fermé.')
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

local cam = nil
function trunkCam()
    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        local plyPed = PlayerPedId()
        SetCamCoord(cam, GetEntityCoords(plyPed))
        SetCamRot(cam, 0.0, 0.0, 0.0)
        SetCamActive(cam,  true)
        RenderScriptCams(true,  false,  0,  true,  true)
        SetCamCoord(cam, GetEntityCoords(plyPed))
    end
    AttachCamToEntity(cam, PlayerPedId(), 0.0, -2.5, 1.0, true)
    SetCamRot(cam, -30.0, 0.0, GetEntityHeading(PlayerPedId()))
end

function disableCam()
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
end

local trunkNotif = "TRNK_NOTIF"
function getInTrunk(veh)
local plyPed = PlayerPedId()
local model = GetEntityModel(veh)
local vl = GetEntityAttachedTo(playerPed)

local lockStatus = GetVehicleDoorLockStatus(vl)

local d1,d2 = GetModelDimensions(model)
local vehicle = VehicleInFront(plyPos)

local trunkDic = "fin_ext_p1-7"
local trunkAnim = "cs_devin_dual-7"

    if not DoesVehicleHaveDoor(veh, 6) and DoesVehicleHaveDoor(veh, 5) and IsThisModelACar(model) then
        local vehi = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 10.0, 0, 70)
        local lockStatus = GetVehicleDoorLockStatus(vehi)

        SetVehicleDoorOpen(veh, 5, 1)

        LoadAnimDict(trunkDic)

        SetBlockingOfNonTemporaryEvents(plyPed, true)         
        
        Citizen.Wait(1000)
        SetVehicleDoorShut(vehicle, 5)

        DetachEntity(plyPed)
        ClearPedTasks(plyPed)
        SetTimecycleModifier("NG_blackout")
        SetTimecycleModifierStrength(1.0)
        ClearPedSecondaryTask(plyPed)
        ClearPedTasksImmediately(plyPed)
        ESX.Streaming.RequestAnimDict('timetable@floyd@cryingonbed@base')
        TaskPlayAnim(plyPed, 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
        --TaskPlayAnim(plyPed, trunkDic, trunkAnim, 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)

        AttachEntityToEntity(plyPed, veh, 0, -0.1,d1["y"]+0.85,d2["z"]-0.87, 0, 0, 40.0, 1, 1, 1, 1, 1, 1)
        inTrunk = true
        trunkVeh = veh

        while inTrunk do
            trunkCam()
            Citizen.Wait(0)
            local coords = GetEntityCoords(PlayerPedId())
            DrawText3D(coords.x, coords.y, coords.z, '[F] Sortir')
            SetEntityVisible(plyPed, false, false) 
            SetTimecycleModifier("NG_blackout")
            SetTimecycleModifierStrength(1.0)
            DrawText2D('Vous êtes dans un coffre', 0.5, 0.9, 1.0)

            if GetVehicleDoorAngleRatio(vl, 5) < 0.9 then
                SetEntityVisible(playerPed, false, false)
                SetTimecycleModifier("NG_blackout")
                SetTimecycleModifierStrength(1.0)
                DrawText2D('Vous êtes dans un coffre', 0.5, 0.9, 1.0)
            else
                --if not IsEntityPlayingAnim(plyPed, trunkDic, trunkAnim, 3) then
                if not IsEntityPlayingAnim(plyPed, 'timetable@floyd@cryingonbed@base', 3) then
                    --TaskPlayAnim(plyPed, trunkDic, trunkAnim, 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
                    ESX.Streaming.RequestAnimDict('timetable@floyd@cryingonbed@base')
                    TaskPlayAnim(plyPed, 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)

                    --SetTimecycleModifier("NG_blackout")
                end
                ClearTimecycleModifier()
            end

            if IsControlJustReleased(0, 23) then
--                if lockStatus == 1 then --unlocked
                    inTrunk = false
--                elseif lockStatus == 2 then -- locked
--                    ESX.ShowNotification('~r~Le coffre est fermé.')
--                end
            end

            if not DoesEntityExist(veh) then
                inTrunk = false
            end
        end
        RemoveAnimDict(trunkDic)
        SetEntityVisible(plyPed, true, false)   
        SetVehicleDoorOpen(veh, 5, 1)
        disableCam()
        DetachEntity(plyPed)
        Citizen.Wait(1000)
        if DoesEntityExist(veh) then 
            local dropPosition = GetOffsetFromEntityInWorldCoords(veh, 0.0,d1["y"]-0.6,0.0)
            SetEntityCoords(plyPed,dropPosition["x"],dropPosition["y"],dropPosition["z"])
        else
            ClearPedTasks(plyPed)
            local plyCoords = GetEntityCoords(plyPed)
            SetEntityCoords(plyped, plyCoords.x, plyCoords.y, plyCoords.x+2)
        end
        SetVehicleDoorShut(vehicle, 5)
        trunkVeh = nil
    end
end

function VehicleInFront()
    local plyPed = PlayerPedId()
    local pos = GetEntityCoords(plyPed)
    local entityWorld = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 3.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, plyPed, 0)
    local a, b, c, d, result = GetRaycastResult(rayHandle)
    return result
end

function DrawText3D(x, y, z, text, linecount)
    if not linecount or linecount == nil or linecount == 0 then
        linecount = 0.7
    end
	SetTextScale(0.4, 0.4)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(true)
	SetTextColour(255, 255, 255, 255)
	SetTextOutline()
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 470
--    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03 * linecount, 0, 0, 0, 68)
    ClearDrawOrigin()
end

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do RequestAnimDict(dict) Citizen.Wait(5); end
end

RegisterNetEvent("notify")
AddEventHandler("notify", function(s) Notify(s); end)

function Notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(false, true)
end

DrawText2D = function(text, x, y, size)
	SetTextScale(size, size)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 255)
	SetTextOutline()

	AddTextComponentString(text)
	DrawText(x, y)
end

