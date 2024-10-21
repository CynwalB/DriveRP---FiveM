local AeroEvent = TriggerServerEvent
local lift = {
    teleport = {
        [0] =  {pos = vector3(-1309.58303223,-559.33419189453,20.8052307129), name = "-1 - Garage"},
        [1] =  {pos = vector3(-1309.38303223,-563.719189453,30.58052307129), name = "1 - RDC"},
        [2] =  {pos = vector3(-1309.3303223,-563.7419189453,34.38052307129), name = "2 - Bureaux"},
        [3] =  {pos = vector3(-1309.18303223,-563.873419189453,41.19052307129), name = "3 - Bureau Gouverneur"},
    },
}

local function openMenu(select)
    local mainMenu = RageUI.CreateMenu("", "Ascenseur gouvernement", 0, 0, "root_cause","gouvernement")

    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

    while mainMenu do
        Wait(1)
        RageUI.IsVisible(mainMenu, true, true, false, function()
            for k,v in pairs(lift.teleport) do
                RageUI.Button(v.name, nil, {}, v.pos ~= select.pos, function(h, a, s)
                    if s then
                        SetEntityCoordsNoOffset(PlayerPedId(), v.pos)
                        SetEntityHeading(PlayerPedId(), 33.0)
                        ESX.ShowNotification("Vous êtes bien arrivé a l'étage ~g~"..v.name.."~s~.")
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
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~g~choisir votre étage~s~.")
                if IsControlJustReleased(0, 54) then
                    openMenu(v)
                end
            end
        end

        Wait(waiting)
    end
end)