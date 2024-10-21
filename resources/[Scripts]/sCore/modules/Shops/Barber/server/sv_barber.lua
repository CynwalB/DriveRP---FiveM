ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('BarberShop:Buy')
AddEventHandler('BarberShop:Buy', function(type, price)
	local _src = source
	--TriggerEvent("ratelimit", _src, "BarberShop:Buy")
	local price = 100
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getAccount('cash').money >= price then
		xPlayer.removeAccountMoney('cash', price)
		SendLogs(15105570,"Barbier - Achat","**"..GetPlayerName(source).."** vient de payer ***"..price.."$ ***\n **License** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1151183786466361495/Ix2w7IkTlZ5jO9UNNxvTLCukWayQH6rix86avlurXBweTUF40j9gOUFiCrGlbeDeR_5S")
		xPlayer.showNotification('Vous avez payé ~q~'..price..' $~s~ au barbier')
		TriggerClientEvent('BarberShop:CheckBuy', xPlayer.source, 'yes')
	else
		xPlayer.showNotification('~r~Vous n\'avez pas assez d\'argent pour payer le barbier') 
	end
end)