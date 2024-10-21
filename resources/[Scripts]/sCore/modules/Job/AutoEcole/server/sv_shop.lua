ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('Dmv:buy', function(source, cb, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getAccount('cash').money >= price then
		xPlayer.removeAccountMoney('cash', price)
		SendLogs(47103,"Permis Chasse - Achat","**"..GetPlayerName(source).."** vient d'acheter pour ***"..price.."$ ***\n **License** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1151183212857540608/IpV97byc5hAXJ4_3Ju1dWQgy3f21zJbnKTjx44ubwiiYYvq3geBoHRKSgXeU43c6RhRo")
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('Dmv:buyPermis', function(source, cb, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getAccount('cash').money >= price then
		xPlayer.removeAccountMoney('cash', price)
		SendLogs(47103,"Permis Pêche - Achat","**"..GetPlayerName(source).."** vient d'acheter pour ***"..price.."$ ***\n **License** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1151183212857540608/IpV97byc5hAXJ4_3Ju1dWQgy3f21zJbnKTjx44ubwiiYYvq3geBoHRKSgXeU43c6RhRo")
		cb(true)
		TriggerClientEvent('sCore:startPermis', source, type)
	else
		cb(false)
	end
end)

RegisterNetEvent('esx_dmvschool:addLicense')
AddEventHandler('esx_dmvschool:addLicense', function(kakakdakkfakdafkjiajdi, license)
	local xPlayer = ESX.GetPlayerFromId(source)
	if #(GetEntityCoords(GetPlayerPed(xPlayer.source))-kakakdakkfakdafkjiajdi) > 5.0 then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : give de license",
			description = "Anticheat : give de license"
		})
		return
	end
	TriggerEvent('esx_license:addLicense', xPlayer.source, license, function()
		TriggerClientEvent("esx:showNotification", xPlayer.source, "+1 ~q~"..license.."~s~ !")
	end)
end)