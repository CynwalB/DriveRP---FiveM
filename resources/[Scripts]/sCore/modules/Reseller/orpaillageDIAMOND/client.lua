local config = {
    label = "~b~[DIAMOND]~s~ ~q~Fonderie~s~",
    color = "~q~",
    dict = "root_cause",
    banner = "mine",
    ped = {pos = vector3(1072.2493896484,-2009.5870361328,32.084251403809-1.0), heading = 102.15, model = "s_m_y_construct_01"},
    menu = {pos = vector3(-494.12451171875,-2851.3898925781,7.2959370613098), message = "~b~[DIAMOND]~s~ Appuyez sur ~INPUT_CONTEXT~ pour vendre vos ~q~pépites d'or~s~."},
    items = {
        {
            itemReseller = "ors",
            label = "Pépites d'or",
            priceReseller = 104,
        }
    },
}

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
   end
   if ESX.IsPlayerLoaded() then
        ESX.PlayerData = ESX.GetPlayerData()
   end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

local function OrpaillageInput(TextEntry, ExampleText, MaxStringLength)
	AddTextEntry("FMMC_KEY_TIP1", TextEntry)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end
function RageUI.Info1(Title, RightText, LeftText)
    local LineCount = #RightText >= #LeftText and #RightText or #LeftText
    if Title ~= nil then
        RenderText("~h~" .. Title .. "~h~", 380 + 20 + 100, 24, 0, 0.34, 255, 255, 255, 255, 0)
    end
    if RightText ~= nil then
        RenderText(table.concat(RightText, "\n"), 380 + 20 + 100, Title ~= nil and 55 or 7, 0, 0.28, 255, 255, 255, 255, 0)
    end
    if LeftText ~= nil then
        RenderText(table.concat(LeftText, "\n"), 380 + 432 + 100, Title ~= nil and 55 or 7, 0, 0.28, 255, 255, 255, 255, 2)
    end
    RenderRectangle(380 + 10 + 100, 20, 430, Title ~= nil and 50 + (LineCount * 20) or ((LineCount + 1) * 20), 0, 0, 0, 160)
end
local function openMenu()
    local mainMenu = RageUI.CreateMenu("", config.color..config.label.."~s~ : Vente", 0, 0, config.dict, config.banner)
    local resellerMenu = RageUI.CreateSubMenu(mainMenu, "", config.color..config.label.."~s~ : Vente", 0, 0, config.dict, config.banner)

    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

    FreezeEntityPosition(PlayerPedId(), true)

    while mainMenu do
        Wait(1)

        RageUI.IsVisible(mainMenu, true, false, true, function()

            RageUI.Button("~b~[DIAMOND]~s~ Vente (+30%)", nil, {RightLabel = "→"}, true, function(h, a, s)

            end, resellerMenu)
        end)
        RageUI.Info1("~q~Tarification~s~", {"[Sans Diamond] | Pepite d'or", "~b~[DIAMOND]~s~ | Pepite d'or"}, {"~q~80$~s~", "~b~104$~s~"})
        RageUI.IsVisible(resellerMenu, true, false, true, function()
            for k,v in pairs(config.items) do
                RageUI.Button("Vendre des "..config.color..""..v.label, nil, {RightLabel = v.priceReseller.."~q~$~s~"}, true, function(h, a, s)
                    if s then
                        local count = tonumber(OrpaillageInput("Veuillez saisir une "..config.color.."quantité~s~ :", "", 3))
                        local vip = exports.sCore:GetVIP()
                        if count == "" or count == nil then return ESX.ShowNotification("~r~Erreur~s~\nCette quantité est invalide !") end
                        if vip == 0 or vip == nil then return  ESX.ShowNotification("Drive~q~RP~s~\n-Vous n'avez pas accès à cette fonctionnalité.~n~-Vous devez être ~b~DIAMOND.") end
                        TriggerServerEvent("sOrpaillage:sellItem2", v.itemReseller, count)
                    end
                end)
            end
        end)

        if not RageUI.Visible(mainMenu) and not RageUI.Visible(resellerMenu) then
            mainMenu = RMenu:DeleteType("menu", true)
        end
    end

    FreezeEntityPosition(PlayerPedId(), false)
end 

CreateThread(function()
    while true do
        local waiting = 250
        local pedCoords = GetEntityCoords(PlayerPedId())

        if #(pedCoords-config.menu.pos) < 1.0 then
            waiting = 1
            ESX.ShowHelpNotification(config.menu.message)
            if IsControlJustReleased(0, 54) then
                openMenu()
            end
        end

        Wait(waiting)
    end
end)