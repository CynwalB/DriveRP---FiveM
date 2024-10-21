local AeroEvent = TriggerServerEvent
local lift = {
    teleport = {
        [0] =  {pos = vector3(338.80844116211,-583.875396484375,74.162901124954224), name = "4 - Toit", heading = 250.02},
        [1] =  {pos = vector3(332.380844116211,-595.75396484375,43.2901124954224), name = "1 - RDC", heading = 69.83},
        [2] =  {pos = vector3(344.22741821289,-586.38271484375,28.90969848633), name = "-1 - Entrée arrière", heading = 247.74},
    },
}

local function openMenuLift(select)
    local mainMenu = RageUI.CreateMenu("", "Ascenseur pillbox hill", 0, 0, "root_cause","ambulance")

    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

    while mainMenu do
        Wait(1)
        RageUI.IsVisible(mainMenu, true, true, false, function()
            for k,v in pairs(lift.teleport) do
                RageUI.Button(v.name, nil, {}, v.pos ~= select.pos, function(h, a, s)
                    if s then
                        SetEntityCoordsNoOffset(PlayerPedId(), v.pos)
                        SetEntityHeading(PlayerPedId(), v.heading)
                        ESX.ShowNotification("Vous êtes bien arrivé a l'étage ~q~"..v.name.."~s~.")
                        RageUI.CloseAll()
                    end
                end)
            end
        end)

        if not RageUI.Visible(mainMenu) then
            mainMenu = RMenu:DeleteType("menu", true)
        end
    end
end

CreateThread(function()
    while true do
        local waiting = 250
        local myCoords = GetEntityCoords(PlayerPedId())
        for k,v in pairs(lift.teleport) do
            if #(myCoords-v.pos) < 1.0 then
                waiting = 1
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~q~choisir votre étage~s~.")
                if IsControlJustReleased(0, 54) then
                    openMenuLift(v)
                end
            end
        end
        Wait(waiting)
    end
end)