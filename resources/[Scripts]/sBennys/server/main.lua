ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local Vehicles = nil
local societylabel = ""
RegisterServerEvent('sCustom:buyModBennys')
AddEventHandler('sCustom:buyModBennys', function(price)
	local _src = source
	--TriggerEvent("ratelimit", _src, "sCustom:buyModBennys")
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	price = tonumber(price)
	if xPlayer.job.name ~= "mecano" then print("Le joueur "..GetPlayerName(_source).." à essayé de acheter des customs !")
		exports.sCore:banPlayerAC(xPlayer.source, {
            name = "changestateuser",
            title = "Anticheat : try to custom",
            description = "Anticheat : try to custom"
        })
        return
	end
	local societyAccount = nil
	TriggerEvent('esx_addonaccount:getSharedAccount', "society_mecano", function(account)
		societyAccount = account
	end)
	if price < societyAccount.money then
		TriggerClientEvent('sCustom:installMod', _source)
		TriggerClientEvent('esx:showNotification', _source, 'Vous venez de payer '..price.."~g~$ pour customiser ce véhicule")
		exports.sCore:SendLogs(1752220,"Bennys Customisation",""..GetPlayerName(source).." vient de payer "..price.." \n License : "..xPlayer.identifier,"https://discord.com/api/webhooks/1003401223971545088/ORUpxTiZS0vdh629tErCnsXHwzNZeBL4k3TIHsaFk8uI1y3Rgm3kXKL2D4-JfaAv_MDr")
		societyAccount.removeMoney(price)
	else
		TriggerClientEvent('sCustom:cancelInstallMod', _source)
		TriggerClientEvent('esx:showNotification', _source, '~r~Vous n\'avez pas assez d\'argent!')
	end
end)

RegisterServerEvent('sCustom:refreshOwnedVehicle')
AddEventHandler('sCustom:refreshOwnedVehicle', function(myCar)
	local _src = source
	--TriggerEvent("ratelimit", _src, "sCustom:refreshOwnedVehicle")
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE @plate = plate', {
        ['@plate'] = myCar.plate
    }, function(result)
        if result[1] then
            local props = json.decode(result[1].props)

            if props.model == myCar.model then

                MySQL.Async.execute('UPDATE `owned_vehicles` SET `props` = @props WHERE `plate` = @plate',
                    {
                        ['@plate'] = myCar.plate,
                        ['@props'] = json.encode(myCar)
                    })

            else
				print(('sCustom: %s a tenté de mettre à niveau un véhicule dont le modèle n\'était pas assorti !'):format(xPlayer.identifier))
			end
        end
    end)
end)

ESX.RegisterServerCallback('sCustom:getVehiclesPrices', function(source, cb)
	if Vehicles == nil then
		MySQL.Async.fetchAll('SELECT * FROM vehicles', {}, function(result)
			local vehicles = {}

			for i=1, #result, 1 do
				table.insert(vehicles, {
					model = result[i].model,
					price = result[i].price
				})
			end

			Vehicles = vehicles
			cb(Vehicles)
		end)
	else
		cb(Vehicles)
	end
end)