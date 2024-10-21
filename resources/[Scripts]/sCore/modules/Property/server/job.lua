ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local cbAttribute = nil
local lastRequest = nil

-- Announce

local annonceList = {
    ["open"] = {
        title = "Agence immobilière",
        subtitle = "~q~Information",
        message = "L'~q~agence immobilière~s~ est actuellement ~q~ouverte~s~ !\nN'hésiter pas à venir.",
        banner = "CHAR_DYNASTY8"
    },
    ["close"] = {
        title = "Agence immobilière",
        subtitle = "~q~Information",
        message = "L'~q~agence immobilière~s~ est actuellement ~r~fermer~s~ !\nRepassez plus tard.",
        banner = "CHAR_DYNASTY8"
    }
}

RegisterNetEvent("sProperty:sendAnnounce")
AddEventHandler("sProperty:sendAnnounce", function(type)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if xPlayer.job.name ~= ConfigImmo.job then return end
        local annonceInfo = annonceList[type]
        if annonceInfo == nil then return end
        TriggerClientEvent("esx:showAdvancedNotification", -1, annonceInfo.title, annonceInfo.subtitle, annonceInfo.message, annonceInfo.banner, 1)
    end
end)

-- Attribute ↓

RegisterNetEvent("sProperty:returnCbAtribute", function(request, cb)
    if request ~= lastRequest then return end
    cbAttribute = cb
end)

-- Property ↓
RegisterServerEvent("sProperty:attributeProperty")
AddEventHandler("sProperty:attributeProperty", function(target, propertyId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name ~= ConfigImmo.job then return end
    local tPlayer = ESX.GetPlayerFromId(target)
    if tPlayer then
        local property = sPropertyManager.list[propertyId]
        local price = tonumber(property.info.price)

        cbAttribute = nil
        lastRequest = math.random(0, 2500)

        TriggerClientEvent("sProperty:addRequestAttribute", target, lastRequest, price)

        while cbAttribute == nil do
            Wait(50)
        end

        if cbAttribute then
            if tPlayer.getAccount('bank').money >= price then
                TriggerEvent('esx_addonaccount:getSharedAccount', 'society_agentimmo', function(account)
                    tPlayer.removeAccountMoney('bank', price)
                    account.addMoney(price)
                end)
                MySQL.Async.execute("UPDATE property SET owner = @owner, ownerInfo = @ownerInfo WHERE id = @propertyId", {
                    ['owner'] = tPlayer.identifier,
                    ['ownerInfo'] = tPlayer.name,
                    ['propertyId'] = propertyId
                }, function(done)
                    sPropertyManager.list[propertyId].ownerLicense = tPlayer.identifier
                    sPropertyManager.list[propertyId].ownerInfo = tPlayer.name
                    TriggerClientEvent("sProperty:propertyNoLongerAvailable", -1, propertyId)
                    TriggerClientEvent("sProperty:addOwnedProperty", tPlayer.source, {id = propertyId, coords = property.info.pos})
                    TriggerClientEvent("sProperty:returnProperty", -1, sPropertyManager.list)
                    TriggerClientEvent("esx:showNotification", tPlayer.source, "Vous avez payer la propriété pour "..price.."~q~$~s~ !")
                    TriggerClientEvent("esx:showNotification", xPlayer.source, "La personne à payer la propriété pour "..price.."~q~$~s~ !")
                    exports.sCore:SendLogs(1752220,"Attribution de propriété",""..GetPlayerName(source).." vient d'attribuer la propriété : **"..propertyId.."** d'une valeur de : **"..price.."** à "..tPlayer.name.."\n License de la source : "..xPlayer.identifier,"https://discord.com/api/webhooks/1151182249740488715/VZdmX95bja4Sh0b6F5_EGAlRE-ka1O-_G3ot-ZW73qNka3h39ZjTA4UnjnNwE9iRl3JP")
                end)
            else
                TriggerClientEvent("esx:showNotification", xPlayer.source, "~r~La personne n'a pas assez d'argent !")
            end
        else
            TriggerClientEvent("esx:showNotification", xPlayer.source, "~r~La personne n'a pas poursuivie le paiement !")
        end

    end
end)

RegisterServerEvent("sProperty:distitueProperty")
AddEventHandler("sProperty:distitueProperty", function(target, propertyId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name ~= ConfigImmo.job then return end
    local tPlayer = ESX.GetPlayerFromIdentifier(target)
    local property = sPropertyManager.list[propertyId]
    MySQL.Async.execute("UPDATE property SET owner = @owner, ownerInfo = @ownerInfo WHERE id = @propertyId", {
        ['owner'] = "none",
        ['ownerInfo'] = "none",
        ['propertyId'] = propertyId
    }, function(done)
        if tPlayer then
            sPropertyManager.list[propertyId].ownerLicense = "none"
            sPropertyManager.list[propertyId].ownerInfo = "none"
            TriggerClientEvent("sProperty:propertyNoLongerOwner", tPlayer.source, {id = propertyId, coords = property.info.pos})
            TriggerClientEvent("sProperty:addAvailableProperty", -1, {id = propertyId, coords = property.info.pos})
            TriggerClientEvent("sProperty:returnProperty", -1, sPropertyManager.list) 
        else
            sPropertyManager.list[propertyId].ownerLicense = "none"
            sPropertyManager.list[propertyId].ownerInfo = "none"
            TriggerClientEvent("sProperty:addAvailableProperty", -1, {id = propertyId, coords = property.info.pos})
            TriggerClientEvent("sProperty:returnProperty", -1, sPropertyManager.list) 
        end
    end)
    exports.sCore:SendLogs(1752220,"Destituer propriété",""..GetPlayerName(source).." vient de destituer la propriété : **"..propertyId.."** qui appartenait à "..tPlayer.name.." \n License de la source : "..xPlayer.identifier,"https://discord.com/api/webhooks/1151182249740488715/VZdmX95bja4Sh0b6F5_EGAlRE-ka1O-_G3ot-ZW73qNka3h39ZjTA4UnjnNwE9iRl3JP")
end)

RegisterServerEvent("sProperty:deleteProperty")
AddEventHandler("sProperty:deleteProperty", function(propertyId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name ~= ConfigImmo.job then return end
    local property = sPropertyManager.list[propertyId]
    local player = ESX.GetPlayerFromIdentifier(property.ownerLicense)
    MySQL.Async.execute("DELETE FROM property WHERE id = @propertyId", {
        ['propertyId'] = propertyId
    }, function(done)
        if property.ownerLicense == "none" then
            TriggerClientEvent("sProperty:propertyNoLongerAvailable",  -1, propertyId)
        else
            TriggerClientEvent("sProperty:propertyNoLongerOwner", player.source, {id = propertyId})
        end

        for id in pairs (sPropertyManager.list) do
            if id == propertyId then
                sPropertyManager.list[id] = nil
            end
        end
        exports.sCore:SendLogs(1752220,"Suppression de propriété",""..GetPlayerName(source).." vient de supprimer : **"..propertyId.."\n License de la source : "..xPlayer.identifier,"https://discord.com/api/webhooks/1151182249740488715/VZdmX95bja4Sh0b6F5_EGAlRE-ka1O-_G3ot-ZW73qNka3h39ZjTA4UnjnNwE9iRl3JP")
        TriggerClientEvent("esx:showNotification", xPlayer.source, "~q~Information : ~s~~n~Le ~o~"..property.info.Selected.label.."~s~ a été supprimé avec succès !")
        TriggerClientEvent("sProperty:returnProperty", -1, sPropertyManager.list) 
    end)
end)

-- Garage ↓
RegisterServerEvent("sGarage:attributeGarage")
AddEventHandler("sGarage:attributeGarage", function(target, garageId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name ~= ConfigImmo.job then return end
    local tPlayer = ESX.GetPlayerFromId(target)
    if tPlayer then
        local garage = sGarageManager.list[garageId]
        local price = tonumber(garage.info.price)

        cbAttribute = nil
        lastRequest = math.random(0, 2500)

        TriggerClientEvent("sProperty:addRequestAttribute", target, lastRequest, price)

        while cbAttribute == nil do
            Wait(50)
        end

        if cbAttribute then
            if tPlayer.getAccount('bank').money >= price then
                TriggerEvent('esx_addonaccount:getSharedAccount', 'society_agentimmo', function(account)
                    tPlayer.removeAccountMoney('bank', price)
                    account.addMoney(price)
                end)
                MySQL.Async.execute("UPDATE garage SET owner = @owner, ownerInfo = @ownerInfo WHERE id = @garageId", {
                    ['owner'] = tPlayer.identifier,
                    ['ownerInfo'] = tPlayer.name,
                    ['garageId'] = garageId
                }, function(done)
                    sGarageManager.list[garageId].ownerLicense = tPlayer.identifier
                    sGarageManager.list[garageId].ownerInfo = tPlayer.name
                    TriggerClientEvent("sGarage:garageNoLongerAvailable", -1, garageId)
                    TriggerClientEvent("sGarage:addOwnedGarage", tPlayer.source, {id = garageId, coords = garage.info.pos})
                    TriggerClientEvent("sGarage:returnGarage", -1, sGarageManager.list)
                    TriggerClientEvent("esx:showNotification", tPlayer.source, "Vous avez payer le garage pour "..price.."~q~$~s~ !")
                    TriggerClientEvent("esx:showNotification", xPlayer.source, "La personne à payer le garage pour "..price.."~q~$~s~ !")
                    exports.sCore:SendLogs(1752220,"Attribution de propriété",""..GetPlayerName(source).." vient d'attribuer le garage : **"..garageId.."** d'une valeur de : **"..price.."** à "..tPlayer.name.."\n License de la source : "..xPlayer.identifier,"https://discord.com/api/webhooks/1151182249740488715/VZdmX95bja4Sh0b6F5_EGAlRE-ka1O-_G3ot-ZW73qNka3h39ZjTA4UnjnNwE9iRl3JP")
                end)
            else
                TriggerClientEvent("esx:showNotification", xPlayer.source, "~r~La personne n'a pas assez d'argent !")
            end
        else
            TriggerClientEvent("esx:showNotification", xPlayer.source, "~r~La personne n'a pas poursuivie le paiement !")
        end

    end
end)

RegisterServerEvent("sGarage:distitueGarage")
AddEventHandler("sGarage:distitueGarage", function(target, garageId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name ~= ConfigImmo.job then return end
    local tPlayer = ESX.GetPlayerFromIdentifier(target)
    local garage = sGarageManager.list[garageId]
    MySQL.Async.execute("UPDATE garage SET owner = @owner, ownerInfo = @ownerInfo WHERE id = @garageId", {
        ['owner'] = "none",
        ['ownerInfo'] = "none",
        ['garageId'] = garageId
    }, function(done)
        if tPlayer then
            sGarageManager.list[garageId].ownerLicense = "none"
            sGarageManager.list[garageId].ownerInfo = "none"
            TriggerClientEvent("sGarage:garageNoLongerOwner", tPlayer.source, {id = garageId, coords = garage.info.pos})
            TriggerClientEvent("sGarage:addAvailableGarage", -1, {id = garageId, coords = garage.info.pos})
            TriggerClientEvent("sGarage:returnGarage", -1, sGarageManager.list) 
        else
            sGarageManager.list[garageId].ownerLicense = "none"
            sGarageManager.list[garageId].ownerInfo = "none"
            TriggerClientEvent("sGarage:addAvailableGarage", -1, {id = garageId, coords = garage.info.pos})
            TriggerClientEvent("sGarage:returnGarage", -1, sGarageManager.list) 
        end
    end)
    exports.sCore:SendLogs(1752220,"Destituer propriété",""..GetPlayerName(source).." vient de destituer la propriété : **"..garageId.."** qui appartenait à "..tPlayer.name.." \n License de la source : "..xPlayer.identifier,"https://discord.com/api/webhooks/1151182249740488715/VZdmX95bja4Sh0b6F5_EGAlRE-ka1O-_G3ot-ZW73qNka3h39ZjTA4UnjnNwE9iRl3JP")
end)

RegisterServerEvent("sGarage:deleteGarage")
AddEventHandler("sGarage:deleteGarage", function(garageId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name ~= ConfigImmo.job then return end
    local garage = sGarageManager.list[garageId]
    local player = ESX.GetPlayerFromIdentifier(garage.ownerLicense)
    MySQL.Async.execute("DELETE FROM garage WHERE id = @garageId", {
        ['garageId'] = garageId
    }, function(done)
        if garage.ownerLicense == "none" then
            TriggerClientEvent("sGarage:garageNoLongerAvailable",  -1, garageId)
        else
            TriggerClientEvent("sGarage:garageNoLongerOwner", player.source, {id = garageId})
        end

        for id in pairs (sGarageManager.list) do
            if id == garageId then
                sGarageManager.list[id] = nil
            end
        end
        exports.sCore:SendLogs(1752220,"Suppression de propriété",""..GetPlayerName(source).." vient de supprimer : **"..garageId.."\n License de la source : "..xPlayer.identifier,"https://discord.com/api/webhooks/1151182249740488715/VZdmX95bja4Sh0b6F5_EGAlRE-ka1O-_G3ot-ZW73qNka3h39ZjTA4UnjnNwE9iRl3JP")
        TriggerClientEvent("esx:showNotification", xPlayer.source, "~q~Information~s~~n~Le ~o~"..garage.info.Selected.label.."~s~ a été supprimé avec succès !")
        TriggerClientEvent("sGarage:returnGarage", -1, sGarageManager.list) 
    end)
end)
