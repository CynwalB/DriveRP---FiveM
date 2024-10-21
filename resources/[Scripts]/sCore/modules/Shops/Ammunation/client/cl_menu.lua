local AeroEvent = TriggerServerEvent
ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
end)
SneakyEvent = AeroEvent
local Weapon = {}
local LicenseOwned = 0
function ShowHelpNotification(msg)
    AddTextEntry('HelpNotification', msg)
	BeginTextCommandDisplayHelp('HelpNotification')
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function CheckLicense()
    ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
        if hasWeaponLicense then
            LicenseOwned = 1
        else
            LicenseOwned = 0
        end
    end, GetPlayerServerId(PlayerId()), 'weapon')
end

RMenu.Add('weapon', 'main', RageUI.CreateMenu("", "~r~Armurerie", 10, 200,'shopui_title_gunclub','shopui_title_gunclub'))
RMenu:Get('weapon', 'main').EnableMouse = false

RMenu.Add('weapon', 'whitearms', RageUI.CreateSubMenu(RMenu:Get('weapon', 'main'), "", "~r~Armes blanches"))
RMenu.Add('weapon', 'letalsarms', RageUI.CreateSubMenu(RMenu:Get('weapon', 'main'), "", "~r~Armes létales"))
RMenu.Add('weapon', 'accessories', RageUI.CreateSubMenu(RMenu:Get('weapon', 'main'), "", "~r~Accessoires"))

RMenu:Get('weapon', 'main').Closed = function() Weapon.Menu = false FreezeEntityPosition(GetPlayerPed(-1), false) end

function OpenWeaponRageUIMenu()

    if Weapon.Menu then
        Weapon.Menu = false
    else
        Weapon.Menu = true
        RageUI.Visible(RMenu:Get('weapon', 'main'), true)
        FreezeEntityPosition(GetPlayerPed(-1), true)

        Citizen.CreateThread(function()
			while Weapon.Menu do
                RageUI.IsVisible(RMenu:Get('weapon', 'main'), true, false, true, function()
                    --if XNL_GetCurrentPlayerXP() >= 600 then
                        if LicenseOwned == 1 then
                            RageUI.Separator("License : ~q~Valide")
                            RageUI.Button("Armes blanches", false, {RightLabel = "→"}, true, function(h,a,s)
                            end,RMenu:Get("weapon","whitearms"))

                            RageUI.Button("Armes létales", false, {RightLabel = "→"}, true, function(h,a,s)
                            end,RMenu:Get("weapon","letalsarms"))
                            RageUI.Button("Munition", false, {RightLabel = "→"}, true, function(h,a,s)
                            end,RMenu:Get("weapon","accessories"))
                        else
                            RageUI.Separator("License : ~r~Invalide")
                            RageUI.Button("Acheter le permis port d'armes", "Allez voir la ~q~L.S.P.D~s~ !", {}, true, function(h,a,s)
                            end)
                            RageUI.Button("Projectile", false, {RightLabel = "→"}, true, function(h,a,s)
                            end,RMenu:Get("weapon","whitearms"))
                            RageUI.Button("Munition", false, {RightLabel = "→"}, true, function(h,a,s)
                            end,RMenu:Get("weapon","accessories"))
                        end
                    --else
                        --RageUI.Separator("")
                        --RageUI.Separator("~r~Vous n'avez pas le niveau nécessaire.")
                        --RageUI.Separator("")
                    --end
                end)
                RageUI.IsVisible(RMenu:Get('weapon', 'whitearms'), true, false, true, function()
                    RageUI.Button("Boite de 10 canettes", false, {RightLabel = "→ 1000~q~$"}, true, function(h,a,s)
                        if s then
                            SneakyEvent('sAmmunation:buyWeapon', "WEAPON_CANETTE", 1000)
                        end
                    end)
                    RageUI.Button("Boite de 10 bouteille usagé", false, {RightLabel = "→ 1100~q~$"}, true, function(h,a,s)
                        if s then
                            SneakyEvent('sAmmunation:buyWeapon', "WEAPON_BOUTEILLE", 1100)
                        end
                    end)
                    --RageUI.Button("Hachete", false, {RightLabel = "→ 4500~q~$"}, true, function(h,a,s)
                        --if s then
                        --    SneakyEvent('sAmmunation:buyWeapon', "WEAPON_HATCHET", 4500)
                        --end
                    --end)
                    --RageUI.Button("Poing américain", false, {RightLabel = "→ 3000~q~$"}, true, function(h,a,s)
                        --if s then
                        --    SneakyEvent('sAmmunation:buyWeapon', "WEAPON_KNUCKLE", 3000)
                        --end
                    --end)
                end)
                --RageUI.IsVisible(RMenu:Get('weapon', 'letalsarms'), true, false, true, function()
                   -- RageUI.Button("Pétoire", false, {RightLabel = "→ 41000~q~$"}, true, function(h,a,s)
                     --   if s then
                           -- SneakyEvent('sAmmunation:buyWeapon', "WEAPON_SNSPISTOL", 41000)
                       -- end
                    --end)
               -- end)
                RageUI.IsVisible(RMenu:Get('weapon', 'accessories'), true, false, true, function()
                    RageUI.Button("Chargeur", false, {RightLabel = "→ 50~q~$"}, true, function(h,a,s)
                        if s then
                            SneakyEvent('sAmmunation:buyItem', 'clip')
                        end
                    end)
                end)
				Wait(0)
			end
		end)
	end
end

RegisterNetEvent('sAmmunation:useClip')
AddEventHandler('sAmmunation:useClip', function()
	local playerPed = PlayerPedId()

	if IsPedArmed(playerPed, 4) then
		local hash = GetSelectedPedWeapon(playerPed)

		if hash then
            AddAmmoToPed(playerPed, hash, 25)
            ESX.ShowNotification("Vous avez ~q~utilisé~s~ 1x chargeur")
		else
			ESX.ShowNotification("~r~Action Impossible~s~ : Vous n'avez pas d'arme en main !")
		end
	else
		ESX.ShowNotification("~r~Action Impossible~s~ : Ce type de munition ne convient pas !")
	end
end)

local WeaponShop = {

    {
        pos = vector3(22.243099594116,-1106.8218505859,29.797210693359),
        blip = {
            label = "Armurerie", 
            ID = 110, 
            Color = 40
        },
    },
}


Citizen.CreateThread(function()
    while true do
        att = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(WeaponShop) do
            local mPos = #(pCoords-v.pos)
            if not Weapon.Menu then
                if mPos <= 10.0 then
                    att = 1
                    DrawMarker(1, v.pos.x, v.pos.y, v.pos.z-0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 150, 200, 170, 0, 0, 0, 1, nil, nil, 0)
                
                    if mPos <= 1.5 then
                        ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour interagir avec l'armurerier")
                        if IsControlJustPressed(0, 51) then
                            CheckLicense()
                            OpenWeaponRageUIMenu()
                        end
                    end
                end
            end
        end
        Citizen.Wait(att)
    end
end)