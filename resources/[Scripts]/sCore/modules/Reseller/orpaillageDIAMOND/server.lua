ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local items = {
    ["ors"] = {price = 80, sell = true}
}

RegisterServerEvent("sOrpaillage:sellItem2")
AddEventHandler("sOrpaillage:sellItem2", function(item, selectCount)
    local vip = exports.sCore:GetVIP()
    if vip == 0 then
        return
        ShowNotification("Drive~q~RP~s~\n-Vous n'avez pas accès à cette fonctionnalité.~n~-Vous devez être VIP.")
    end
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    if xPlayer == nil then return end

    local verifItem = items[item]
    if verifItem == nil then return end
    if verifItem.sell ~= true then return end

    local itemCount = xPlayer.getInventoryItem(item).count
    if selectCount > itemCount then return TriggerClientEvent("esx:showNotification", _src, "~r~Vous n'avez pas cela sur vous !") end
    local totalPrice = verifItem.price*selectCount*1.30
    if #(GetEntityCoords(GetPlayerPed(source))-vector3(-494.12451171875,-2851.3898925781,7.2959370613098)) > 15.0 then 
        banPlayerAC(xPlayer.source, {
			name = "createentity",
			title = "Give d'item : ("..item..")",
			description = "Give d'item : ("..item..")"
		})
        return
    end
    xPlayer.removeInventoryItem(item, selectCount)
    xPlayer.addAccountMoney('cash', totalPrice)
    TriggerClientEvent("esx:showNotification", _src, "Vous avez vendu ~q~x"..selectCount.." "..ESX.GetItemLabel(item).."~s~ pour "..totalPrice.."~q~$~s~.")
end)