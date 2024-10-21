local config = {
    label = "Poissonerie",
    color = "~q~",
    dict = "root_cause",
    banner = "peche",
    ped = {pos = vector3(-95.083213806152,-2767.8649902344,5.0821218490601), heading = 94.61, model = "a_m_o_beach_01"},
    menu = {pos = vector3(-510.68313598633,-2867.4338378906,7.2959361076355), message = "~b~[DIAMOND]~s~ Appuyez sur ~INPUT_CONTEXT~ pour ~q~ouvrir le menu~s~."},
    items = {

        {
            itemReseller = "fish",
            itemSeller = "mor_fish",
            label = "Poisson",
            priceSeller = 20,
            priceReseller = 44,
        },
        {
            itemReseller = "whitefish",
            label = "Poisson blanc",
            priceReseller = 58,
        },
        {
            itemReseller = "redfish",
            label = "Poisson rouge",
            priceReseller = 39,
        },
        {
            itemReseller = "fishd",
            label = "Poisson abattu",
            priceReseller = 65,
        },
        {
            itemReseller = "carpecuir",
            label = "Carpe cuir",
            priceReseller = 85,
        },
        {
            itemReseller = "pompom",
            label = "Poisson pompom",
            priceReseller = 39,
        },
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

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

function RageUI.Info3(Title, RightText, LeftText)
    local LineCount = #RightText >= #LeftText and #RightText or #LeftText
    if Title ~= nil then
        RenderText("~h~" .. Title .. "~h~", 440 + 20 + 100, 110, 0, 0.34, 255, 255, 255, 255, 0)
    end
    if RightText ~= nil then
        RenderText(table.concat(RightText, "\n"), 440 + 20 + 100, Title ~= nil and 140 or 7, 0, 0.28, 255, 255, 255, 255, 0)
    end
    if LeftText ~= nil then
        RenderText(table.concat(LeftText, "\n"), 440 + 430 + 100, Title ~= nil and 140 or 7, 0, 0.28, 255, 255, 255, 255, 2)
    end
    RenderRectangle(440 + 10 + 100, 110, 432, Title ~= nil and 50 + (LineCount * 20) or ((LineCount + 1) * 20), 0, 0, 0, 160)
end

local function BoucherieInput(TextEntry, ExampleText, MaxStringLength)
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

local function openMenu()
    local mainMenu = RageUI.CreateMenu("", config.color..config.label.."~s~ : ~b~[DIAMOND]~s~ Achat & Vente", 80, 90, config.dict, config.banner)
    local resellerMenu = RageUI.CreateSubMenu(mainMenu, "", config.color..config.label.."~s~ : Vente", 80, 90, config.dict, config.banner)
    local sellerMenu = RageUI.CreateSubMenu(mainMenu, "", config.color..config.label.."~s~ : Achat", 80, 90, config.dict, config.banner)

    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

    FreezeEntityPosition(PlayerPedId(), true)

    while mainMenu do
        Wait(1)
        --RageUI.Info3("~q~Tarification~s~", {"[Sans Diamond] | Poisson" , "~b~[DIAMOND]~s~ | Poisson" , "[Sans Diamond] | Poisson blanc" , "~b~[DIAMOND]~s~ | Poisson blanc" , "[Sans Diamond] | Poisson rouge" , "~b~[DIAMOND]~s~ | Poisson rouge" , "[Sans Diamond] | Poisson abattu" , "~b~[DIAMOND]~s~ | Poisson abattu" , "[Sans Diamond] | Carpe cuir" , "~b~[DIAMOND]~s~ | Carpe cuir" , "[Sans Diamond] | Poisson pompom" , "~b~[DIAMOND]~s~ | Poisson pompom"}, {"~q~56$~s~", "~q~73$~s~", "~q~50$~s~", "~q~65$~s~","27$","27+30","39","39+30","65","65+30","27","27+30"})
        RageUI.Info3("~q~Tarification~s~", {"[Sans Diamond] | Poisson" , "~b~[DIAMOND]~s~ | Poisson" , "[Sans Diamond] | Poisson blanc" , "~b~[DIAMOND]~s~ | Poisson blanc" , "[Sans Diamond] | Poisson rouge" , "~b~[DIAMOND]~s~ | Poisson rouge" , "[Sans Diamond] | Poisson abattu" , "~b~[DIAMOND]~s~ | Poisson abattu" , "[Sans Diamond] | Carpe cuir" , "~b~[DIAMOND]~s~ | Carpe cuir"}, {"~q~34$~s~", "~b~44$~s~", "~q~45$~s~", "~b~58$~s~","~q~27$~s~","~b~39$~s~","~q~39$~s~","~b~65$~s~","~q~65$~s~","~b~85$~s~"})
        --RageUI.Info2("~q~Tarification~s~", {"[Sans Diamond] | Viande Blanche", "~b~[DIAMOND]~s~ | Viande Blanche", "[Sans Diamond] | Viande Rouge","~b~[DIAMOND]~s~ | Viande Rouge"}, {"~q~56$~s~", "~q~73$~s~", "~q~50$~s~", "~q~65$~s~"})
        RageUI.IsVisible(mainMenu, true, true, true, function()
            if ESX.PlayerData.job.grade_name == "boss" then
                RageUI.Button("Achat", nil, {RightLabel = "→"}, true, function(h, a, s)
                end, sellerMenu)
            else
                RageUI.Button("Achat", nil, {RightBadge = RageUI.BadgeStyle.Lock}, false, function(h, a, s)
                end, sellerMenu)
            end

            RageUI.Button("~b~[DIAMOND]~s~ Vente (+30%)", nil, {RightLabel = "→"}, true, function(h, a, s)

            end, resellerMenu)
        end)

        RageUI.IsVisible(resellerMenu, true, true, true, function()
            for k,v in pairs(config.items) do
                RageUI.Button("Vendre de la "..config.color..""..v.label, nil, {RightLabel = v.priceReseller.."~q~$~s~"}, true, function(h, a, s)
                    if s then
                        local count = tonumber(BoucherieInput("Veuillez saisir une "..config.color.."quantité~s~ :", "", 3))
                        local vip = exports.sCore:GetVIP()
                        if count == "" or count == nil then return ESX.ShowNotification("~r~Erreur~s~\nCette quantité est invalide !") end
                        if vip == 0 or vip == nil then return  ESX.ShowNotification("Drive~q~RP~s~\n-Vous n'avez pas accès à cette fonctionnalité.~n~-Vous devez être ~b~DIAMOND.") end
                        TriggerServerEvent("sPeche:sellItem2", v.itemReseller, count)
                    end
                end)
            end
        end)

        RageUI.IsVisible(sellerMenu, true, true, true, function()
            for k,v in pairs(config.items) do
                if v.priceSeller ~= nil and v.itemSeller ~= nil then
                    RageUI.Button("Acheter des morceau de "..config.color..""..v.label, nil, {RightLabel = v.priceSeller.."~q~$~s~"}, true, function(h, a, s)
                        if s then
                            local count = tonumber(BoucherieInput("Veuillez saisir une "..config.color.."quantité~s~ :", "", 3))
                            if count == "" or count == nil then return ESX.ShowNotification("~r~Erreur~s~~n~Cette quantité est invalide !") end
                            TriggerServerEvent("sPeche:buyItem", v.itemSeller, count)
                        end
                    end)
                end
            end
        end)

        if not RageUI.Visible(mainMenu) and not RageUI.Visible(resellerMenu) and not RageUI.Visible(sellerMenu) then
            mainMenu = RMenu:DeleteType("menu", true)
        end
    end

    FreezeEntityPosition(PlayerPedId(), false)
end 

CreateThread(function()
    local model = GetHashKey(config.ped.model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(1)
    end
    local ped = CreatePed(9, model, config.ped.pos, config.ped.heading, false, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)

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