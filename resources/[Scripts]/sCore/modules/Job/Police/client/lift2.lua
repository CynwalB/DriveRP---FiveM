local AeroEvent = TriggerServerEvent
local lift = {
    teleport = {
        [0] =  {pos = vector3(-1065.927, -833.87149, 05.48121), name = "-1 - Parking et cellules"},
        [1] =  {pos = vector3(-1065.927, -833.8549, 11.030121), name = "-2 - Laboratoire et saisie"},
        [2] =  {pos = vector3(-1065.927, -833.7149, 14.88121), name = "-3 - Armurerie"},
        [3] =  {pos = vector3(-1065.97, -833.87149, 19.04121), name = " 1 - RDC"},
        [4] =  {pos = vector3(-1065.927, -833.65149, 27.04121), name = " 3 - Salle de dispatch et vestiaire"},
    },
}

local function openMenu(select)
    local mainMenu = RageUI.CreateMenu("", "Ascenseur police", 0, 0, "root_cause","police")

    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

    while mainMenu do
        Wait(1)
        RageUI.IsVisible(mainMenu, true, true, false, function()
            for k,v in pairs(lift.teleport) do
                RageUI.Button(v.name, nil, {}, v.pos ~= select.pos, function(h, a, s)
                    if s then
                        SetEntityCoordsNoOffset(PlayerPedId(), v.pos)
                        SetEntityHeading(PlayerPedId(), 33.0)
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
                    openMenu(v)
                end
            end
        end

        Wait(waiting)
    end
end)