ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('Faille:duBanquierLol',function(source, cb, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if xPlayer.getAccount("cash").money >= price then
            xPlayer.removeAccountMoney("cash", price)
            SendLogs(47103,"Location - Achat","**"..GetPlayerName(source).."** vient de louer un véhicule pour ***"..price.."$ ***\n **License** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1151183786466361495/Ix2w7IkTlZ5jO9UNNxvTLCukWayQH6rix86avlurXBweTUF40j9gOUFiCrGlbeDeR_5S")
            cb(true)
        else
            cb(false)
        end
    end
end)