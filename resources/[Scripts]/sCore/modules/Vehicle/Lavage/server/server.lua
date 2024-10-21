ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('Lavage:buy', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 100
    if xPlayer.getAccount('cash').money >= price then
		xPlayer.removeAccountMoney('cash', price)
        SendLogs(15105570,"Lavage - Achat","**"..GetPlayerName(source).."** vient d'acheter pour ***"..price.."$ ***\n **License** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1003431096509272184/DJQcTaoETXhR_8iIriYmSj9en2got0IYPA2rD-gBY1Fm80BudA8rwXGs987TSsTs5Ggh")
		cb(true)
	else
		cb(false)
	end
end)