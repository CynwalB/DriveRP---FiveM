TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('oxygen_mask', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('Sneakydix-oblivionpill:oxygen_mask', xPlayer.source)
	xPlayer.removeInventoryItem('oxygen_mask', 1)
end)

RegisterServerEvent('esx_armour:armorremove')
AddEventHandler('esx_armour:armorremove', function()
	local _src = source
	--TriggerEvent("ratelimit", _src, "esx_armour:armorremove")
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('armor', 1)
end)

ESX.RegisterUsableItem('armor', function(source)
	TriggerClientEvent('esx_armour:armor', source)
end)

ESX.RegisterUsableItem('kit_de_crochetage', function(source)
	TriggerClientEvent('Sneaky:Uselockpick', source)
end)

RegisterNetEvent("Sneakyremovelockpick")
AddEventHandler('Sneakyremovelockpick', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('kit_de_crochetage', 1)
end)

RegisterNetEvent('Sneakyremovelockpick212')
AddEventHandler('Sneakyremovelockpick212', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem('kit_de_crochetage', 1)
end)

ESX.RegisterUsableItem('jumelles', function(source)
	TriggerClientEvent('binoculars:Activate', source)
end)

AllowMecano = false
ESX.RegisterUsableItem('repairkit', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	TriggerClientEvent('esx_repairkit_moteur:onUse', _source)
end)

InfiniteRepairs = false

RegisterNetEvent('esx_repairkit:removeKit')
AddEventHandler('esx_repairkit:removeKit', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if not InfiniteRepairs then
		xPlayer.removeInventoryItem('repairkit', 1)
		TriggerClientEvent('esx:showNotification', _source, "Vous avez utilisé un ~q~kit fr réparation")
	end
end)

AllowMecano = false
ESX.RegisterUsableItem('kit_moteur', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	TriggerClientEvent('esx_repairkit_moteur:onUse', _source)
end)

InfiniteRepairs = false

RegisterNetEvent('esx_repairkit_moteur:removeKit')
AddEventHandler('esx_repairkit_moteur:removeKit', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if not InfiniteRepairs then
		xPlayer.removeInventoryItem('kit_moteur', 1)
		TriggerClientEvent('esx:showNotification', _source, "Vous avez utilisé un ~q~kit moteur")
	end
end)



AllowMecano = false
ESX.RegisterUsableItem('kit_caross', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	TriggerClientEvent('esx_repairkit_caross:onUse', _source)
end)

InfiniteRepairs = false

RegisterNetEvent('esx_repairkit_caross:removeKit')
AddEventHandler('esx_repairkit_caross:removeKit', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if not InfiniteRepairs then
		xPlayer.removeInventoryItem('kit_caross', 1)
		TriggerClientEvent('esx:showNotification', _source, "Vous avez utilisé un ~q~kit de carroserie")
	end
end)

ESX.RegisterUsableItem('bmx', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	TriggerClientEvent('clp_bmx:usebmx', _source)
end)


RegisterNetEvent('clp_bmx:removebmx')
AddEventHandler('clp_bmx:removebmx', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bmx', 1)
end)
RegisterNetEvent('clp_bmx:addbmx')
AddEventHandler('clp_bmx:addbmx', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	local itembmx = xPlayer.getInventoryItem("bmx").count
	if itembmx == 0 then
		xPlayer.addInventoryItem('bmx', 1)
	end
end)

ESX.RegisterUsableItem('diable', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem("diable", 1)
	TriggerClientEvent('sCore:useDiable', _source)
	xPlayer.setMaxWeight(90)
end)

RegisterNetEvent('sCore:diableSystem')
AddEventHandler('sCore:diableSystem', function(item_name)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.setMaxWeight(45)
	if item_name ~= "diable" then
		banPlayerAC(xPlayer.source, {
			name = "createentity",
			title = "Give d'item : ("..item_name..")",
			description = "Give d'item : ("..item_name..")"
		})
	else
		if xPlayer.canCarryItem("diable", 1) then
			local itemdiable = xPlayer.getInventoryItem("diable").count
			if itemdiable == 0 then
				xPlayer.addInventoryItem("diable", 1)
				TriggerClientEvent("esx:showNotification",source,"Vous venez de plier le ~q~<C>diable</C>~s~.")
			end
		else
			TriggerClientEvent("esx:showNotification",source,"Vous ne pouvez pas ranger le ~r~diable~s~.")
			TriggerClientEvent('sCore:useDiable', source)
		end
	end	
end)

ESX.RegisterUsableItem('engine', function(source)
	TriggerClientEvent('SneakyLife:UseItemMecano', source, "engine")
end)

ESX.RegisterUsableItem('outils', function(source)
	TriggerClientEvent('SneakyLife:UseItemMecano', source, "outils")
end)

ESX.RegisterUsableItem('pneu', function(source)
	TriggerClientEvent('SneakyLife:UseItemTires', source)
end)

ESX.RegisterUsableItem('kit_de_lavage', function(source)
	TriggerClientEvent('SneakyLife:UseItemWash', source)
end)

RegisterNetEvent('SneakyLife:UseItemFinish')
AddEventHandler('SneakyLife:UseItemFinish', function(item_name)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem(item_name, 1)
	TriggerClientEvent("esx:showNotification",source,"Vous venez d'utiliser un(e) ~q~"..ESX.GetItemLabel(item_name).."~s~.")
end)