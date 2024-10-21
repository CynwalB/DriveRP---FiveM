ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local items = {
    ["viande_1"] = {price = 56, sell = true},
    ["viande_2"] = {price = 50, sell = true},
    ["morviande_1"] = {price = 10, sell = false},
    ["morviande_2"] = {price = 15, sell = false}
}

RegisterServerEvent("sBoucherie:buyItem")
AddEventHandler("sBoucherie:buyItem", function(item, count)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    if xPlayer == nil then return end

    local verifItem = items[item]
    if verifItem == nil then return end

    if (xPlayer.getWeight()+(xPlayer.getInventoryItem(item).weight*1)) > ESX.GetConfig().MaxWeight then return TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez pas assez de place sur vous !") end        
    if #(GetEntityCoords(GetPlayerPed(source))-vector3(-502.68362426758,-2859.462890625,7.2959361076355)) > 2.0 then 
        banPlayerAC(xPlayer.source, {
			name = "createentity",
			title = "Give d'item : ("..item..")",
			description = "Give d'item : ("..item..")"
		})
        return
    end
    local totalPrice = verifItem.price*count
    if xPlayer.getAccount('cash').money >= totalPrice then
        xPlayer.addInventoryItem(item, count)
        xPlayer.removeAccountMoney('cash', totalPrice)
        TriggerClientEvent("esx:showNotification", _src, "Vous avez acheté ~q~x"..count.." "..ESX.GetItemLabel(item).."~s~ pour "..totalPrice.."~q~$~s~ !")
    elseif xPlayer.getAccount('bank').money >= totalPrice then
        xPlayer.addInventoryItem(item, count)
        xPlayer.removeAccountMoney('bank', totalPrice)
        TriggerClientEvent("esx:showNotification", _src, "Vous avez acheté ~q~x"..count.." "..ESX.GetItemLabel(item).."~s~ pour "..totalPrice.."~q~$~s~ !")
    else
        TriggerClientEvent("esx:showNotification", _src, "~r~Vous n'avez pas assez d'argent !")
    end
end)

RegisterServerEvent("sBoucherie:sellItem2")
AddEventHandler("sBoucherie:sellItem2", function(item, selectCount)
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
    if #(GetEntityCoords(GetPlayerPed(source))-vector3(-502.68362426758,-2859.462890625,7.2959361076355)) > 2.0 then 
        banPlayerAC(xPlayer.source, {
			name = "createentity",
			title = "Give d'item : ("..item..")",
			description = "Give d'item : ("..item..")"
		})
        return
    end
    xPlayer.removeInventoryItem(item, selectCount)
    xPlayer.addAccountMoney('cash', totalPrice)
    TriggerClientEvent("esx:showNotification", _src, "Vous avez vendue ~q~x"..selectCount.." "..ESX.GetItemLabel(item).."~s~ pour "..totalPrice.."~q~$~s~ !")
end)