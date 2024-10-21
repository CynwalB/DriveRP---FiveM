ESX = nil
Gotur = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'gotur', 'gotur', 'society_gotur', 'society_gotur', 'society_gotur', {type = 'private'})

AddEventHandler('playerDropped', function (reason)

    local xPlayer = ESX.GetPlayerFromId(source)

        if (xPlayer ~= nil) then
            
            local id = getNumberPhone(xPlayer.identifier)

            if (Gotur[id] ~= nil) then

                if (Gotur[id].durum == 'iptal' or Gotur[id].durum == 'teslimedildi') then

                else

            

                    local test = getSourceFromIdentifier()
                    local tutar = Gotur[id].total
                    if (json.encode(test) ~= '[]') then
                        for i=1, #test, 1 do
                            TriggerClientEvent('gksphone:sipariss', test[i].id, Gotur)
                            TriggerClientEvent('gksphone:notifi', test[i].id, {title = 'Gotur', message = Gotur[id].deneme .. _U('gotur_cancel'), img= '/html/static/img/icons/gotur.png' })
                        end
                    end


                    Gotur[id] = {
                        deneme = Gotur[id].deneme,
                        item = Gotur[id].item,
                        telno = id,
                        durum = 'iptal',
                    }

                    if Config.ESXVersion == '1.2' then

                        MySQL.Async.fetchAll("SELECT accounts FROM users WHERE identifier = @identifier", {
                            ['@identifier'] = xPlayer,
                        }, function(result)

                            g=json.decode(result[1].accounts)

                            g['bank']=g['bank']+(tonumber(tutar));
                    

                            MySQL.Async.execute('UPDATE users SET `accounts` = @bank WHERE `identifier` = @identifier', {
                            ['@identifier'] = xPlayer,
                            ['@bank'] = json.encode(g),
                            })
                        end)

                    end

                    if Config.ESXVersion == '1.1' then
                        
                        MySQL.Async.fetchAll("SELECT bank FROM users WHERE identifier = @identifier", {
                            ['@identifier'] = xPlayer,
                        }, function(result)
    
                            local offbankamount = result[1].bank
    
                            local total = offbankamount + tonumber(tutar)
                    
    
                            MySQL.Async.execute('UPDATE users SET `bank` = @bank WHERE `identifier` = @identifier', {
                            ['@identifier'] = xPlayer,
                            ['@bank'] = total
                            })
                        end)

                    end

                    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_gotur', function(account)
                        
                        account.removeMoney(tutar)

                    end)

                end
            end
        end

end)

ESX.RegisterServerCallback('gks_gotur:getInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory
  
	cb({items = items})
  
end)

ESX.RegisterServerCallback('gks_gotur:depoitemgotur', function(source, cb)
	local result = MySQL.Sync.fetchAll('SELECT * FROM gksphone_gotur',{})
	local valcik = {}
	for i=1, #result, 1 do
		table.insert(valcik, {label = result[i].label, count = result[i].count, item = result[i].item, price = result[i].price, kapat = result[i].kapat, adet = result[i].adet}) 
	end

	cb(valcik)

end)

function getSourceFromIdentifier()
    local Lawyers = {}
    for k, v in pairs(ESX.GetPlayers()) do
        local Player = ESX.GetPlayerFromId(v)

        if Player ~= nil then
            if Player.job.name == 'gotur' then
                table.insert(Lawyers, {
                    id = Player.source,
                })
            end
        end
    end
    return Lawyers
end

RegisterServerEvent('gks_gotur:siparis')
AddEventHandler('gks_gotur:siparis', function(deneme, a, b, c, d)
    local id = b
    local isim = a
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)


    
    if xPlayer ~= nil then
        
        if xPlayer.getAccount("bank").money > c then
            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_gotur', function(account)
                    local test = getSourceFromIdentifier()
                     if (json.encode(test) ~= '[]') then
                        Gotur[id] = {
                            deneme = isim,
                            item = deneme,
                            telno = id,
                            durum = d,
                            total = c
                        }
            
                        account.addMoney(c)
                        xPlayer.removeAccountMoney('bank', c)
                        for i=1, #test, 1 do
                            TriggerClientEvent('gks_gotur:blipp', test[i].id, Gotur[id].deneme, xPlayer, id)
                            TriggerClientEvent('gksphone:notifi', test[i].id, {title = 'Gotur', message = Gotur[id].deneme .._U('gotur_productbuy'), img= '/html/static/img/icons/gotur.png' })
                            TriggerClientEvent('gksphone:sipariss', test[i].id, Gotur)
                        end
               
                        TriggerClientEvent('gksphone:sipariss', src, Gotur)
                        TriggerClientEvent('gks_gotur:gerisayim', src, c, Gotur)
                    else
                        TriggerClientEvent('gksphone:notifi', src, {title = 'Gotur', message = _U('gotur_offline'), img= '/html/static/img/icons/gotur.png' })
                    end
                    
            end)
        else
            TriggerClientEvent('gksphone:notifi', src, {title = 'Gotur', message = _U('gotur_nomoney'), img= '/html/static/img/icons/gotur.png' })
        end
    end
end)

function getNumberPhone(identifier)
    local result = MySQL.Sync.fetchAll("SELECT phone_number FROM gksphone_settings WHERE identifier LIKE '%"..identifier.."%'", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].phone_number
    end
    return nil
end


RegisterServerEvent('gks_gotur:failed')
AddEventHandler('gks_gotur:failed', function(bilgi)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer ~= nil then
      
  
            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_gotur', function(account)
                    local test = getSourceFromIdentifier()
                    local id = getNumberPhone(xPlayer.identifier)
                    local tutar = Gotur[id].total

                        Gotur[id] = {
                            deneme = Gotur[id].deneme,
                            item = Gotur[id].item,
                            telno = id,
                            durum = 'iptal',
                            total = Gotur[id].total
                        }
                       
                        account.removeMoney(tutar)
                        xPlayer.addAccountMoney('bank', tutar)
                     
                        for i=1, #test, 1 do
                            TriggerClientEvent('gks_gotur:stopblipp', test[i].id, id)
                            TriggerClientEvent('gksphone:sipariss', test[i].id, Gotur)
                            TriggerClientEvent('gksphone:notifi', test[i].id, {title = 'Gotur', message = Gotur[id].deneme .._U('gotur_cancelorder'), img= '/html/static/img/icons/gotur.png' })
                        end
                        TriggerClientEvent('gksphone:notifi', src, {title = 'Gotur', message = _U('gotur_refund'), img= '/html/static/img/icons/gotur.png' })
                        TriggerClientEvent('gksphone:sipariss', src, Gotur)
                        
            end)

    end
end)

function getSourceFromIdentifiesr(identifier, cb)

	local xPlayers = ESX.GetPlayers()
	
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		
		if(xPlayer.identifier ~= nil and xPlayer.identifier == identifier) or (xPlayer.identifier == identifier) then
			return xPlayer.source
	
		end
	end
	return nil
end


function getIdentifierByPhoneNumber(phone_number) 
    local result = MySQL.Sync.fetchAll("SELECT identifier FROM gksphone_settings WHERE phone_number = @phone_number", {
        ['@phone_number'] = phone_number
    })
    if result[1] ~= nil then
        return result[1].identifier
    end
    return nil
end


RegisterServerEvent('gks_gotur:syold')
AddEventHandler('gks_gotur:syold', function(total, bilgi)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
 
    if xPlayer ~= nil then
   
           
                    local test = getSourceFromIdentifier()
                    local iden = getIdentifierByPhoneNumber(bilgi)
                    local srck = getSourceFromIdentifiesr(iden)
                

                        Gotur[bilgi] = {
                            deneme = total[bilgi].deneme,
                            item = total[bilgi].item,
                            telno = bilgi,
                            durum = 'yolda',
                        }



                        for i=1, #test, 1 do
                            TriggerClientEvent('gksphone:sipariss', test[i].id, Gotur)
                        end
                        TriggerClientEvent('gksphone:notifi', srck, {title = 'Gotur', message = _U('gotur_orderway'), img= '/html/static/img/icons/gotur.png' })

                        TriggerClientEvent('gksphone:sipariss', srck, Gotur)
                    
       

    end
end)

RegisterServerEvent('gks_gotur:teslimyapildi')
AddEventHandler('gks_gotur:teslimyapildi', function(total, bilgi)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer ~= nil then
   
           
                    local test = getSourceFromIdentifier()
                    local iden = getIdentifierByPhoneNumber(bilgi)
                    local srck = getSourceFromIdentifiesr(iden)
                 

                        Gotur[bilgi] = {
                            deneme = total[bilgi].deneme,
                            item = total[bilgi].item,
                            telno = bilgi,
                            durum = 'teslimedildi',
                        }



                        for i=1, #test, 1 do
                            TriggerClientEvent('gksphone:sipariss', test[i].id, Gotur)
                            TriggerClientEvent('gks_gotur:stopblipp', test[i].id, bilgi)
                        end
                        TriggerClientEvent('gksphone:notifi', srck, {title = 'Gotur', message = _U('gotur_orderdelivered'), img= '/html/static/img/icons/gotur.png' })
                        TriggerClientEvent('gks_gotur:gerisaybitir', srck)
                        TriggerClientEvent('gksphone:sipariss', srck, Gotur)
                    
       

    end
end)


RegisterServerEvent('gks_gotur:depoitem')
AddEventHandler('gks_gotur:depoitem', function(Item, ItemCount, price)
  local xPlayer = ESX.GetPlayerFromId(source)
  local GetItem = xPlayer.getInventoryItem(Item)


  MySQL.Async.fetchAll(
    'SELECT label, name FROM items WHERE name = @item',
    {
        ['@item'] = Item,
    },
    function(items)
    
      MySQL.Async.fetchAll(
        'SELECT item, count FROM gksphone_gotur WHERE item = @items',
        {
            ['@items'] = Item
        },
        function(data)
	
        if data[1] == nil then

            MySQL.Async.execute('INSERT INTO gksphone_gotur (label, price, count, item) VALUES (@label, @price, @count, @item)',
            {
                ['@label']         = items[1].label,
                ['@price']         = price,
                ['@count']         = ItemCount,
                ['@item']          = items[1].name
            })

            xPlayer.removeInventoryItem(Item, ItemCount)

            elseif data[1].item == Item then
            
                MySQL.Async.fetchAll("UPDATE gksphone_gotur SET count = @count WHERE item = @name",
                {
                    ['@name'] = Item,
                    ['@count'] = data[1].count + ItemCount
                }
                )
                xPlayer.removeInventoryItem(Item, ItemCount)


            elseif data ~= nil and data[1].item ~= Item then
                Wait(250)
                TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~You already have a same item in your shop, ~r~but for ' .. data[1].Item .. '. you put the price ' .. Item)
                Wait(250)
                TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Remove the item and put a new price or put the same price')
            end
        end)  
    end)
end)


RegisterServerEvent('gks_gotur:depoitemdelete')
AddEventHandler('gks_gotur:depoitemdelete', function(item, count)
  local src = source
  local xPlayer = ESX.GetPlayerFromId(src)
  local identifier =  ESX.GetPlayerFromId(src).identifier

        MySQL.Async.fetchAll(
        'SELECT count, item FROM gksphone_gotur WHERE item = @item',
        {
            ['@item'] = item
        },
        function(data)

            if count > data[1].count then

                TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~You can\' t take out more than you own')
                else

                if data[1].count ~= count then

                    MySQL.Async.fetchAll("UPDATE gksphone_gotur SET count = @count WHERE item = @item",
                    {
                        ['@item'] = item,
                        ['@count'] = data[1].count - count
                    }, function(result)
                    
                    xPlayer.addInventoryItem(data[1].item, count)
                end)
    
                elseif data[1].count == count then

                    MySQL.Async.fetchAll("DELETE FROM gksphone_gotur WHERE item = @name",
                    {
                        ['@name'] = data[1].item
                    })

                    xPlayer.addInventoryItem(data[1].item, count)
            end
        end
    end)
end)