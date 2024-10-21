local AeroEvent = TriggerServerEvent
local lastSpawned = {}
local spawned = {}

local vehiclesExposition = {
    -- Vehicles
    {name = "neon", pos = vector3(-1268.5767578125,-364.5743164063,36.91078948975-0.9), heading = 113.46},
    {name = "caracara2", pos = vector3(-1269.4767578125,-358.75743164063,36.91078948975-0.9), heading = 65.62},
    {name = "comet6", pos = vector3(-1265.1767578125,-355.15743164063,36.91078948975-0.9), heading = 27.06},
    -- Motos
    {name = "nightblade", pos = vector3(1764.1767578125,3336.1743164063,40.891078948975-0.9), heading = 338.96},
    {name = "bagger", pos = vector3(1763.0854492188,3337.4523925781,40.755184173584-0.9), heading = 332.98},
    {name = "cliffhanger", pos = vector3(1762.068359375,3338.6079101563,40.642902374268-0.9), heading = 337.98},
}

Citizen.CreateThread(function()
    for k,v in pairs(vehiclesExposition) do
        if not spawned[v.name] then
            local model = GetHashKey(v.name)
            RequestModel(model)
            while not HasModelLoaded(model) do Wait(1) end
            local expoVehicle = CreateVehicle(model, v.pos, v.heading, 0, 0)
            SetVehicleNumberPlateText(expoVehicle, "CONCESS")
            SetVehicleDoorsLocked(expoVehicle, 2)
            SetEntityInvincible(expoVehicle, true)
            spawned[v.name] = true
            table.insert(lastSpawned, expoVehicle)
            TriggerEvent('persistent-vehicles/register-vehicle', expoVehicle)
        end
    end
end)

AddEventHandler("onResourceStop", function(name)
    if name == "sCore" then
        for k,v in pairs(lastSpawned) do
            if DoesEntityExist(v) then
                DeleteEntity(v)
            end
        end
    end
end)