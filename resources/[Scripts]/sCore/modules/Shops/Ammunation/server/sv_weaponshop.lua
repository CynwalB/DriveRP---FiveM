ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
AddEventHandler('esx:playerLoaded', function(source)
	TriggerEvent('esx_license:getLicenses', source, function(licenses)
		TriggerClientEvent('jWeaponshop:loadLicenses', source, licenses)
	end)
end)

local configAmmunation = {
	license = {
		money = 90000,
		name = "weapon"
	},
	weapons = {
		["WEAPON_CANETTE"] = {price = 1000, limit = 10},
		["WEAPON_BOUTEILLE"] = {price = 1100, limit = 10},
		--["WEAPON_HATCHET"] = {price = 4500},
		--["WEAPON_KNUCKLE"] = {price = 3000},
		--["WEAPON_SNSPISTOL"] = {price = 30000}
	},
	items = {
		["clip"] = {price = 50, limit = 1}
	}
}

ESX.RegisterServerCallback('esx_weaponshop:buyLicense', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
    local xMoney = xPlayer.getAccount('cash').money
    local xBank = xPlayer.getAccount('bank').money
	if xMoney >= configAmmunation.license.money then
        xPlayer.removeAccountMoney('cash', configAmmunation.license.money)
        TriggerEvent('esx_license:addLicense', source, configAmmunation.license.name, function()
			cb(true)
		end)
	end
end)

RegisterServerEvent('sAmmunation:buyWeapon')
AddEventHandler('sAmmunation:buyWeapon', function(weaponName)
	local _source = source
	TriggerEvent("ratelimit", _source, "sAmmunation:buyWeapon")
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer == nil then return end

	local verifWeapon = configAmmunation.weapons
	if verifWeapon[weaponName] == nil then 
		banPlayerAC(xPlayer.source, {
			name = "createweapon",
			title = "Give d'arme ("..weaponName..")",
			description = "Give d'arme ("..weaponName..")"
		})
		return 
	end

	local hasWeapon = xPlayer.hasWeapon(weaponName)
	if hasWeapon then return TriggerClientEvent('esx:showNotification', source, '~r~Vous avez déjà cette arme !') end
	if xPlayer.getAccount('cash').money >= verifWeapon[weaponName].price then
		xPlayer.removeAccountMoney('cash', verifWeapon[weaponName].price)
        xPlayer.addWeapon(weaponName, 80)
		TriggerClientEvent("esx:showNotification", _source, "Vous avez acheté ~q~x1 "..ESX.GetWeaponLabel(weaponName).."~s~ pour "..verifWeapon[weaponName].price.."~q~$~s~ !")
    elseif xPlayer.getAccount('bank').money >= verifWeapon[weaponName].price then
		xPlayer.removeAccountMoney('cash', verifWeapon[weaponName].price)
        xPlayer.addWeapon(weaponName, 80)
		TriggerClientEvent("esx:showNotification", _source, "Vous avez acheté ~q~x1 "..ESX.GetWeaponLabel(weaponName).."~s~ pour "..verifWeapon[weaponName].price.."~q~$~s~ !")
	end
end)

RegisterServerEvent('sAmmunation:buyItem')
AddEventHandler('sAmmunation:buyItem', function(itemName)
	local _source = source
	TriggerEvent("ratelimit", _source, "sAmmunation:buyItem")
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer == nil then return end

	local verifWeapon = configAmmunation.items
	if verifWeapon[itemName] == nil then 
		banPlayerAC(xPlayer.source, {
			name = "createweapon",
			title = "Give d'item ("..itemName..")",
			description = "Give d'item ("..itemName..")"
		})
		return 
	end

	if xPlayer.getAccount('cash').money >= verifWeapon[itemName].price then
		if xPlayer.canCarryItem(itemName, verifWeapon[itemName].limit) then
			xPlayer.removeAccountMoney('cash', verifWeapon[itemName].price)
			xPlayer.addInventoryItem(itemName, 1)
			xPlayer.showNotification('Vous venez de acheter ~q~1x '..ESX.GetItemLabel(itemName)..'~s~ pour '..verifWeapon[itemName].price..'~q~$~s~ !')
		else
			xPlayer.showNotification('Vous portez trop de ~q~'..ESX.GetItemLabel(itemName)..'~s~ sur vous !')
		end
	elseif xPlayer.getAccount('bank').money >= verifWeapon[itemName].price then
		if xPlayer.canCarryItem(itemName, verifWeapon[itemName].limit) then
			xPlayer.removeAccountMoney('bank', verifWeapon[itemName].price)
			xPlayer.addInventoryItem(itemName, 1)
			xPlayer.showNotification('Vous venez de acheter ~q~1x '..ESX.GetItemLabel(itemName)..'~s~ pour '..verifWeapon[itemName].price..'~q~$~s~ !')
		else
			xPlayer.showNotification('Vous portez trop de ~q~'..ESX.GetItemLabel(itemName)..'~s~ sur vous !')
		end
	end
end)

ESX.RegisterUsableItem('clip', function(source)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	
	local verifCount = xPlayer.getInventoryItem("clip").count
	if verifCount > 0 then
		xPlayer.removeInventoryItem('clip', 1)
		TriggerClientEvent('sAmmunation:useClip', source)
	end
end)