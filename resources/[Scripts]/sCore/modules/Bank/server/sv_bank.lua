ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('SneakyLife:solde')
AddEventHandler('SneakyLife:solde', function(action , amount)
    local _src = source
    --TriggerEvent("ratelimit", _src, "SneakyLife:solde")
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local bankMoney = xPlayer.getAccount('bank').money
    TriggerClientEvent("SneakyLife:GetSoldAccount",source,bankMoney)
end)

RegisterServerEvent('SneakyLife:deposit')
AddEventHandler('SneakyLife:deposit', function(money)
    local _src = source
    --TriggerEvent("ratelimit", _src, "SneakyLife:deposit")
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xMoney = xPlayer.getAccount('cash').money
    if xMoney >= money then
        xPlayer.addAccountMoney('bank',money)
        SendLogs(3066993,"Banque - Dépot","**"..GetPlayerName(_source).."** vient de déposer ***"..money.."$ ***\n **License** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1151181518279028906/HBwt4d76IltS48bo-IH_Y6Fl6oE289c4s6dA5_Cit7pTlOf6QjTlh3wmEnBJ0MwMJkJE")
        xPlayer.removeAccountMoney('cash', money)
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Banque', '~q~Compte bancaire', "Vous avez deposé ~q~"..money.."$~s~ sur votre compte", 'CHAR_BANK_FLEECA', 9)
    else
        TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez d\'argent~s~ !")
    end
end)

RegisterServerEvent('SneakyLife:withdraw')
AddEventHandler('SneakyLife:withdraw', function(money)
    local _src = source
    --TriggerEvent("ratelimit", _src, "SneakyLife:withdraw")
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xMoney = xPlayer.getAccount('bank').money
    if xMoney >= money then
        xPlayer.removeAccountMoney('bank', money)
        xPlayer.addAccountMoney('cash',money)
        SendLogs(3066993,"Banque - Retrait","**"..GetPlayerName(_source).."** vient de retirer ***"..money.."$ ***\n **License** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1151181518279028906/HBwt4d76IltS48bo-IH_Y6Fl6oE289c4s6dA5_Cit7pTlOf6QjTlh3wmEnBJ0MwMJkJE")
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Banque', '~q~Compte bancaire', "Vous avez retiré ~q~"..money.."$~s~ de votre compte", 'CHAR_BANK_FLEECA', 9)
    else
        TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez d\'argent~s~ !")
    end
end)