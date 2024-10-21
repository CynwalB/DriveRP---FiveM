ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

---@class sBoutique
sBoutique = sBoutique or {};

---@class sBoutique.Cache
sBoutique.Cache = sBoutique.Cache or {}

---@class sBoutique.Cache.Case
sBoutique.Cache.Case = sBoutique.Cache.Case or {}

function sBoutique:HasValue(tab, val)
    for i = 1, #tab do
        if tab[i] == val then
            return true
        end
    end
    return false
end

local characters = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }

Server = {};

function Server:GetIdentifiers(source)
    if (source ~= nil) then
        local identifiers = {}
        local playerIdentifiers = GetPlayerIdentifiers(source)
        for _, v in pairs(playerIdentifiers) do
            local before, after = playerIdentifiers[_]:match("([^:]+):([^:]+)")
            identifiers[before] = playerIdentifiers[_]
        end
        return identifiers
    else
        error("source is nil")
    end
end

function CreateRandomPlateText()
    local plate = ""
    math.randomseed(GetGameTimer())
    for i = 1, 3 do
        plate = plate .. characters[math.random(1, #characters)]
    end
    plate = plate .. ""
    for i = 1, 3 do
        plate = plate .. math.random(1, 9)
    end
    return plate
end

function Server:OnProcessCheckout(source, price, transaction, onAccepted, onRefused)
    local identifier = Server:GetIdentifiers(source);
    if (identifier['fivem']) then
        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
        MySQL.Async.fetchAll("SELECT SUM(points) FROM tebex_players_wallet WHERE identifiers = @identifiers", {
            ['@identifiers'] = after
        }, function(result)
            local current = tonumber(result[1]["SUM(points)"]);
            if (current ~= nil) then
                if (current >= price) then
                    LiteMySQL:Insert('tebex_players_wallet', {
                        identifiers = after,
                        transaction = transaction,
                        price = '0',
                        currency = 'Points',
                        points = -price,
                    });
                    onAccepted();
                else
                    onRefused();
                    xPlayer.showNotification('Vous ne procédez pas les points nécessaires pour votre achat visité notre boutique.')
                end
            else
                onRefused();
                print('[Info] retrieve points nil')
            end
        end);
    else
        onRefused();
        --print('[Error] Failed to retrieve fivem identifier')
    end
end

function Server:Giving(xPlayer, identifier, item)
    local content = json.decode(item.action);

    if (content.vehicles) then
        for key, value in pairs(content.vehicles) do
        end
    end

    if (content.items) then
        for key, value in pairs(content.items) do
            xPlayer.addInventoryItem(value.name, value.count)
        end
    end
 
    if (content.roue) then
        for key, value in pairs(content.roue) do

        end
    end

    if (content.items) then
        for key, value in pairs(content.items) do
            xPlayer.addInventoryItem(value.name, value.count)
        end
    end

    if (content.bank) then
        for key, value in pairs(content.bank) do
            xPlayer.addAccountMoney('bank', value.count)
        end
    end
end

RegisterServerEvent('SneakyLife:process_checkout')
AddEventHandler('SneakyLife:process_checkout', function(itemId)
    local _src = source
    --TriggerEvent("ratelimit", _src, "SneakyLife:process_checkout")
    local source = source;
    if (source) then
        local identifier = Server:GetIdentifiers(source);
        local xPlayer = ESX.GetPlayerFromId(source)
        if (xPlayer) then
            local count, content = LiteMySQL:Select('tebex_boutique'):Where('id', '=', itemId):Get();
            local item = content[1];
            if (item) then
                Server:OnProcessCheckout(source, item.price, string.format("Achat package %s", item.name), function()
                    Server:Giving(xPlayer, identifier, item);
                    SendLogs(15105570,"Boutique - Achat","**"..GetPlayerName(source).."** vient d'acheter une ***"..item.name.."***\n **License** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1043185766999797850/JVRJsQe4a4hesmczljDlgknrBZUAzmFOtel_fDJ_aJE4APPGpaOLYBJzTbH-LVFKYzvm")
                end, function()
                    xPlayer.showNotification("~r~Vous ne posséder pas les points nécessaires")
                end)
            else
                print('[[Error] Failed to retrieve boutique item')
            end
        else
            print('[Error] Failed to retrieve ESX player')
        end
    else
        print('[Error] Failed to retrieve source')
    end
end)

local function random(x, y)
    local u = 0;
    u = u + 1
    if x ~= nil and y ~= nil then
        return math.floor(x + (math.random(math.randomseed(os.time() + u)) * 999999 % y))
    else
        return math.floor((math.random(math.randomseed(os.time() + u)) * 100))
    end
end

local function GenerateLootbox(source, box, list)
    local chance = random(1, 100)
    local gift = { category = 1, item = 1 }
    local minimalChance = 4

    local identifier = Server:GetIdentifiers(source);
    minimalChance = 3
    if (sBoutique.Cache.Case[source] == nil) then
        sBoutique.Cache.Case[source] = {};
        if (sBoutique.Cache.Case[source][box] == nil) then
            sBoutique.Cache.Case[source][box] = {};
        end
    end
    if chance <= minimalChance then
        local rand = random(1, #list[3])
        sBoutique.Cache.Case[source][box][3] = list[3][rand]
        gift.category = 3
        gift.item = list[3][rand]
    elseif (chance > minimalChance and chance <= 30) or (chance > 80 and chance <= 100) then
        local rand = random(1, #list[2])
        sBoutique.Cache.Case[source][box][2] = list[2][rand]
        gift.category = 2
        gift.item = list[2][rand]
    else
        local rand = random(1, #list[1])
        sBoutique.Cache.Case[source][box][1] = list[1][rand]
        gift.category = 1
        gift.item = list[1][rand]
    end
    local finalList = {}
    for _, category in pairs(list) do
        for _, item in pairs(category) do
            local result = { name = item, time = 150 }
            table.insert(finalList, result)
        end
    end
    table.insert(finalList, { name = gift.item, time = 5000 })
    return finalList, gift.item
end

local reward = {
    -- Caisse gold

    --["money_6000"] = { type = "money", message = "Félicitation, vous avez gagné 6000$." },
    ["sanchez2"] = { type = "vehicle", message = "Félicitation, vous avez gagné une Sanchez 2." },
    ["oracle"] = { type = "vehicle", message = "Félicitation, vous avez gagné une Oracle." },
    ["remusvert"] = { type = "vehicle", message = "Félicitation, vous avez gagné une Remus Cabrio." },
    ["vetog"] = { type = "vehicle", message = "Félicitation, vous avez gagné un Vetog." },
    --["weapon_battleaxe"] = { type = "weapon", message = "Félicitation, vous avez gagné une Hache de Guerre." },
    --["weapon_dagger"] = { type = "weapon", message = "Félicitation, vous avez gagné un Karambit." },
    ["blazer"] = { type = "vehicle", message = "Félicitation, vous avez gagné un Blazer." },
    ["youga"] = { type = "vehicle", message = "Félicitation, vous avez gagné un Youga." },
    ["seashark3"] = { type = "vehicle", message = "Félicitation, vous avez gagné un Jet-ski." },
    ["tropic"] = { type = "vehicle", message = "Félicitation, vous avez gagné un Tropic." },
    ["sneakycoins_800"] = { type = "SneakyCoins", message = "Félicitation, vous avez gagné 800 ULSCoins." },
    --["money_13500"] = { type = "money", message = "Félicitation, vous avez gagné 13500$." },
    ["casco"] = { type = "vehicle", message = "Félicitation, vous avez gagné une Casco." },

    -- Caisse Diamond
    ["journeys"] = { type = "vehicle", message = "Félicitation, vous avez gagné un Journeys." },
    ["penne"] = { type = "vehicle", message = "Félicitation, vous avez gagné une Penne." },
    ["primov12"] = { type = "vehicle", message = "Félicitation, vous avez gagné une Primo V12." },
    ["strombergsu"] = { type = "vehicle", message = "Félicitation, vous avez gagné une Stromberg Su." },
    ["rrocket"] = { type = "vehicle", message = "Félicitation, vous avez gagné un Rrocket." },
    ["sneakycoins_1000"] = { type = "SneakyCoins", message = "Félicitation, vous avez gagné 1000 ULSCoins." },
    --["weapon_bat"] = { type = "weapon", message = "Félicitation, vous avez gagné une Batte lucile." },
    --["weapon_knife"] = { type = "weapon", message = "Félicitation, vous avez gagné un Bayonett." },
    --["money_12500"] = { type = "money", message = "Félicitation, vous avez gagné 12500$." },
    ["stryder"] = { type = "vehicle", message = "Félicitation, vous avez gagné un Stryder." },
    ["mule3"] = { type = "vehicle", message = "Félicitation, vous avez gagné une Mule." },
    --["money_18500"] = { type = "money", message = "Félicitation, vous avez gagné 18500$." },
    ["longfin"] = { type = "vehicle", message = "Félicitation, vous avez gagné un Longfin." },
    ["dodo"] = { type = "vehicle", message = "Félicitation, vous avez gagné un Avion Dodo." },
    ["buzzard2"] = { type = "vehicle", message = "Félicitation, vous avez gagné un Buzzard." }, 

    -- Caisse Race

    ["2f2fgtr34"] = { type = "vehicle", message = "Félicitation, vous avez gagné une Voiture race." },
    ["2f2fgts"] = { type = "vehicle", message = "Félicitation, vous avez gagné une Voiture race." },
    ["2f2fmk4"] = { type = "vehicle", message = "Félicitation, vous avez gagné une Voiture race." },
    ["2f2fmle7"] = { type = "vehicle", message = "Félicitation, vous avez gagné une Voiture race." },
    ["ff4wrx"] = { type = "vehicle", message = "Félicitation, vous avez gagné une Voiture race." },
    ["fnf4r34"] = { type = "vehicle", message = "Félicitation, vous avez gagné une Voiture race." },
    ["fnflan"] = { type = "vehicle", message = "Félicitation, vous avez gagné une Voiture race." },
    ["fnfmits"] = { type = "vehicle", message = "Félicitation, vous avez gagné une Voiture race." },
    ["fnfrx7"] = { type = "vehicle", message = "Félicitation, vous avez gagné une Voiture race." },
    ["money_18500"] = { type = "money", message = "Félicitation, vous avez gagné 18500$." },
}

local box = {
    [1] = {
        [3] = {
            --"money_6000",
            "sanchez2",
            "oracle",
            "remusvert",
            "vetog",
            --"weapon_battleaxe",
            --"weapon_dagger",
            "blazer",
            "youga",
            "seashark3",
            "tropic",
            --"sneakycoins_800",
            --"money_13500",
            "casco",
        },
        [2] = {
            --"money_6000",
            "sanchez2",
            "oracle",
            "remusvert",
            "vetog",
            --"weapon_battleaxe",
            --"weapon_dagger",
            "blazer",
            "youga",
            "seashark3",
            "tropic",
            --"sneakycoins_800",
            --"money_13500",
            "casco",
        },
        [1] = {
            --"money_6000",
            "sanchez2",
            "oracle",
            "remusvert",
            "vetog",
            --"weapon_battleaxe",
            --"weapon_dagger",
            "blazer",
            "youga",
            "seashark3",
            "tropic",
            --"sneakycoins_800",
            --"money_13500",
            "casco",
        },
    }
}

local box2 = {
    [1] = {
        [3] = {
            "journeys",
            "buzzard2",
            "penne",
            "primov12",
            "strombergsu",
            "rrocket",
            --"sneakycoins_1000",
            --"weapon_bat",
            --"weapon_knife",
            --"money_12500",
            "stryder",
            "mule3",
            --"money_18500",
            "longfin",
            "dodo",
        },
        [2] = {
            "journeys",
            "buzzard2",
            "penne",
            "primov12",
            "strombergsu",
            "rrocket",
            --"sneakycoins_1000",
            --"weapon_bat",
            --"weapon_knife",
            --"money_12500",
            "stryder",
            "mule3",
            --"money_18500",
            "longfin",
            "dodo",
        },
        [1] = {
            "journeys",
            "buzzard2",
            "penne",
            "primov12",
            "strombergsu",
            "rrocket",
            --"sneakycoins_1000",
            --"weapon_bat",
            --"weapon_knife",
            --"money_12500",
            "stryder",
            "mule3",
            --"money_18500",
            "longfin",
            "dodo",
        },
    }
}

local box3 = {
    [1] = {
        [3] = {
            "2f2fgtr34",
            "2f2fgts",
            "2f2fmk4",
            "2f2fmle7",
            "ff4wrx",
            "fnf4r34",
            "fnflan",
            "fnfmits",
            "fnfrx7",
            --"money_18500"
        },
        [2] = {
            "2f2fgtr34",
            "2f2fgts",
            "2f2fmk4",
            "2f2fmle7",
            "ff4wrx",
            "fnf4r34",
            "fnflan",
            "fnfmits",
            "fnfrx7",
            --"money_18500"
        },
        [1] = {
            "2f2fgtr34",
            "2f2fgts",
            "2f2fmk4",
            "2f2fmle7",
            "ff4wrx",
            "fnf4r34",
            "fnflan",
            "fnfmits",
            "fnfrx7",
            "money_18500"
        },
    }
}
local labeltype = nil
RegisterServerEvent('SneakyLife:process_checkout_case')
AddEventHandler('SneakyLife:process_checkout_case', function(type)
    local _src = source
    --TriggerEvent("ratelimit", _src, "SneakyLife:process_checkout_case")
    local source = source;
    if (source) then
        local identifier = Server:GetIdentifiers(source);
        local xPlayer = ESX.GetPlayerFromId(source)
        if type == "case_1" then
            labeltype = "Caisse gold"
        elseif type == "case_2" then
            labeltype = "Caisse diamond"
        elseif type == "case_3" then
            labeltype = "Caisse race"
        end
        SendLogs(15105570,"Boutique - Achat","**"..GetPlayerName(source).."** vient d'acheter une ***"..labeltype.."***\n **License** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1043185766999797850/JVRJsQe4a4hesmczljDlgknrBZUAzmFOtel_fDJ_aJE4APPGpaOLYBJzTbH-LVFKYzvm")
        if (xPlayer) then
            if type == "case_1" then
                Server:OnProcessCheckout(source, 500, "Achat d'une caisse (ULS - Gold)", function()

                    local boxId = 1;
                    local lists, result = GenerateLootbox(source, boxId, box[boxId])
                    local giveReward = {
                        ["SneakyCoins"] = function(_s, license, player)
                            local before, after = result:match("([^_]+)_([^_]+)")
                            local quantity = tonumber(after)
                            if (identifier['fivem']) then
                                local _, fivemid = identifier['fivem']:match("([^:]+):([^:]+)")
                                LiteMySQL:Insert('tebex_players_wallet', {
                                    identifiers = fivemid,
                                    transaction = "Gain dans la boîte SneakyCoins",
                                    price = '0',
                                    currency = 'Points',
                                    points = quantity,
                                });
                            end
                        end,
                        ["weapon"] = function(_s, license, player)
                            xPlayer.addWeapon(result, 150)
                        end,
                        ["money"] = function(_s, license, player)
                            local before, after = result:match("([^_]+)_([^_]+)")
                            local quantity = tonumber(after)
                            player.addAccountMoney('bank', quantity)
                        end,
                        ["vehicle"] = function(_s, license, player)
                            local plate = CreateRandomPlateText()
                            LiteMySQL:Insert('owned_vehicles', {
                                owner = xPlayer.identifier,
                                plate = plate,
                                model = result,
                                props = '{"fuelLevel":100.0}',
                                parked = 1,
                                label = "",
                                donated = 1,
                                garage_private = 0
                            })
                            LiteMySQL:Insert('open_car', {
                                owner = xPlayer.identifier,
                                plate = plate,
                                NB = 1,
                                donated = 1
                            });
                        end,
                    }

                    local r = reward[result];
                    if (r ~= nil) then
                        if (giveReward[r.type]) then
                            giveReward[r.type](source, identifier['license'], xPlayer);
                        end
                    end
                    if (identifier['fivem']) then
                        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
                        LiteMySQL:Insert('tebex_players_wallet', {
                            identifiers = after,
                            transaction = r.message,
                            price = '0',
                            currency = 'Box',
                            points = 0,
                        });
                    end
                    print(result)
                    SendLogs(15105570,"Boutique - Achat","**"..GetPlayerName(source).."** vient de gagner : ***"..result.."***\n **License** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1043185766999797850/JVRJsQe4a4hesmczljDlgknrBZUAzmFOtel_fDJ_aJE4APPGpaOLYBJzTbH-LVFKYzvm")
                    TriggerClientEvent('tebex:on-open-case', source, lists, result, r.message)
                    end, function()
                    xPlayer.showNotification("~r~Vous ne posséder pas les points nécessaires")
                end)
            elseif type == "case_2" then
                Server:OnProcessCheckout(source, 1000, "Achat d'une caisse (ULS - Diamond)", function()

                    local boxId = 1;
                    local lists, result = GenerateLootbox(source, boxId, box2[boxId])
                    local giveReward = {
                        ["SneakyCoins"] = function(_s, license, player)
                            local before, after = result:match("([^_]+)_([^_]+)")
                            local quantity = tonumber(after)
                            if (identifier['fivem']) then
                                local _, fivemid = identifier['fivem']:match("([^:]+):([^:]+)")
                                LiteMySQL:Insert('tebex_players_wallet', {
                                    identifiers = fivemid,
                                    transaction = "Gain dans la boîte SneakyCoins",
                                    price = '0',
                                    currency = 'Points',
                                    points = quantity,
                                });
                            end
                        end,
                        ["weapon"] = function(_s, license, player)
                            xPlayer.addWeapon(result, 150)
                        end,
                        ["money"] = function(_s, license, player)
                            local before, after = result:match("([^_]+)_([^_]+)")
                            local quantity = tonumber(after)
                            player.addAccountMoney('bank', quantity)
                        end,
                        ["vehicle"] = function(_s, license, player)
                            local plate = CreateRandomPlateText()
                            LiteMySQL:Insert('owned_vehicles', {
                                owner = xPlayer.identifier,
                                plate = plate,
                                model = result,
                                props = '{"fuelLevel":100.0}',
                                parked = 1,
                                label = "",
                                donated = 1,
                                garage_private = 0
                            })
                            LiteMySQL:Insert('open_car', {
                                owner = xPlayer.identifier,
                                plate = plate,
                                NB = 1,
                                donated = 1
                            });
                        end,
                    }
                    local r = reward[result];
                    if (r ~= nil) then
                        if (giveReward[r.type]) then
                            giveReward[r.type](source, identifier['license'], xPlayer);
                        end
                    end
                    if (identifier['fivem']) then
                        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
                        LiteMySQL:Insert('tebex_players_wallet', {
                            identifiers = after,
                            transaction = r.message,
                            price = '0',
                            currency = 'Box',
                            points = 0,
                        });
                    end
                    print(result)
                    SendLogs(15105570,"Boutique - Achat","**"..GetPlayerName(source).."** vient de gagner : ***"..result.."***\n **License** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1003428841244610640/KkQtNX_tzu9p8EdZclnwVR3QLjkLMG-O8e4eNDKL5CsxtLV_ck86oBCIU7ZpEEVb6QjI")
                    TriggerClientEvent('tebex:on-open-case', source, lists, result, r.message)
                    end, function()
                    xPlayer.showNotification("~r~Vous ne posséder pas les points nécessaires")
                end)
            elseif type == "case_3" then
                Server:OnProcessCheckout(source, 2500, "Achat d'une caisse (ULS - Race)", function()

                    local boxId = 1;
                    local lists, result = GenerateLootbox(source, boxId, box3[boxId])
                    local giveReward = {
                        ["SneakyCoins"] = function(_s, license, player)
                            local before, after = result:match("([^_]+)_([^_]+)")
                            local quantity = tonumber(after)
                            if (identifier['fivem']) then
                                local _, fivemid = identifier['fivem']:match("([^:]+):([^:]+)")
                                LiteMySQL:Insert('tebex_players_wallet', {
                                    identifiers = fivemid,
                                    transaction = "Gain dans la boîte SneakyCoins",
                                    price = '0',
                                    currency = 'Points',
                                    points = quantity,
                                });
                            end
                        end,
                        ["weapon"] = function(_s, license, player)
                            xPlayer.addWeapon(result, 150)
                        end,
                        ["money"] = function(_s, license, player)
                            local before, after = result:match("([^_]+)_([^_]+)")
                            local quantity = tonumber(after)
                            player.addAccountMoney('bank', quantity)
                        end,
                        ["vehicle"] = function(_s, license, player)
                            local plate = CreateRandomPlateText()
                            LiteMySQL:Insert('owned_vehicles', {
                                owner = xPlayer.identifier,
                                plate = plate,
                                model = result,
                                props = '{"fuelLevel":100.0}',
                                parked = 1,
                                label = "",
                                donated = 1,
                                garage_private = 0
                            })
                            LiteMySQL:Insert('open_car', {
                                owner = xPlayer.identifier,
                                plate = plate,
                                NB = 1,
                                donated = 1
                            });
                        end,
                    }
                    local r = reward[result];
                    if (r ~= nil) then
                        if (giveReward[r.type]) then
                            giveReward[r.type](source, identifier['license'], xPlayer);
                        end
                    end
                    if (identifier['fivem']) then
                        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
                        LiteMySQL:Insert('tebex_players_wallet', {
                            identifiers = after,
                            transaction = r.message,
                            price = '0',
                            currency = 'Box',
                            points = 0,
                        });
                    end
                    SendLogs(15105570,"Boutique - Achat","**"..GetPlayerName(source).."** vient de gagner : ***"..result.."***\n **License** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1003428841244610640/KkQtNX_tzu9p8EdZclnwVR3QLjkLMG-O8e4eNDKL5CsxtLV_ck86oBCIU7ZpEEVb6QjI")
                    TriggerClientEvent('tebex:on-open-case', source, lists, result, r.message)
                    end, function()
                    xPlayer.showNotification("~r~Vous ne posséder pas les points nécessaires")
                end)
            end
        else
            print('[Error] Failed to retrieve ESX player')
        end
    else
        print('[Error] Failed to retrieve source')
    end
end)

ESX.RegisterServerCallback('tebex:retrieve-category', function(source, callback)
    local count, result = LiteMySQL:Select('tebex_boutique_category'):Where('is_enabled', '=', true):Get();
    if (result ~= nil) then
        callback(result)
    else
        print('[Error] retrieve category is nil')
        callback({ })
    end
end)

ESX.RegisterServerCallback('tebex:retrieve-items', function(source, callback, category)
    local count, result = LiteMySQL:Select('tebex_boutique'):Wheres({
        { column = 'is_enabled', operator = '=', value = true },
        { column = 'category', operator = '=', value = category },
    })                             :Get();
    if (result ~= nil) then
        callback(result)
    else
        print('[Error] retrieve category is nil')
        callback({ })
    end
end)

ESX.RegisterServerCallback('tebex:retrieve-history', function(source, callback)
    local identifier = Server:GetIdentifiers(source);
    if (identifier['fivem']) then
        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
        local count, result = LiteMySQL:Select('tebex_players_wallet'):Where('identifiers', '=', after):Get();
        if (result ~= nil) then
            callback(result)
        else
            print('[Error] retrieve category is nil')
            callback({ })
        end
    end
end)

ESX.RegisterServerCallback('tebex:retrieve-points', function(source, callback)

    local identifier = Server:GetIdentifiers(source);
    if (identifier['fivem']) then
        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")

        MySQL.Async.fetchAll("SELECT SUM(points) FROM tebex_players_wallet WHERE identifiers = @identifiers", {
            ['@identifiers'] = after
        }, function(result)
            if (result[1]["SUM(points)"] ~= nil) then
                callback(result[1]["SUM(points)"])
            else
                print('[Info] retrieve points nil')
                callback(0)
            end
        end);
    else
        callback(0)
    end

end)

AddEventHandler('playerSpawned', function()
    local source = source;
    local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer) then
        local fivem = Server:GetIdentifiers(source)['fivem'];
        if (fivem) then
            local license = Server:GetIdentifiers(source)['license'];
            if (license) then
                TriggerClientEvent("esx:showNotification",source,'~g~Vous pouvez faire des achats dans notre boutique pour nous soutenir. Votre compte FiveM attaché à votre jeux a été mis à jour.')
            end
        else
            TriggerClientEvent("esx:showNotification",source,'~r~Vous n\'avez pas d\'identifiant FiveM associé à votre compte, reliez votre profil à partir de votre jeux pour recevoir vos achats potentiel sur notre boutique.')
        end
    end 
end)

ESX.RegisterServerCallback('tebex:retrieve-id', function(source, callback)
    local source = source;
    local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer) then
        local identifier = Server:GetIdentifiers(source);
        if (identifier['fivem']) then
            local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
            if after ~= nil then
                local license = identifier['license']
                if (license) then
                    callback(after)
                else
                    callback(0)
                end
            else
                callback(0)
            end
        else
            callback(0)
        end
    end 
end)

RegisterCommand("fivemid", function(source)
    local source = source;
    local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer) then
        local fivem = Server:GetIdentifiers(source)['fivem'];
        if (fivem) then
            local license = Server:GetIdentifiers(source)['license'];
            if (license) then
				xPlayer.showNotification("Votre ID est : ~g~"..source)
                xPlayer.showNotification('Votre FiveM ID est : ~g~'..fivem)
            else
				xPlayer.showNotification("~r~Erreur~s~ vous n'avez pas d'identifiant")
            end
        else
            xPlayer.showNotification('~r~Vous n\'avez pas d\'identifiant FiveM associé à votre compte, reliez votre profil à partir de votre jeux pour recevoir vos achats potentiel sur notre boutique.')
        end
    else
        print('[Error] ESX Get players form ID not found.')
    end 
end)


RegisterCommand("givecoins", function(source, args) 
    if source ~= 0 then return end
    local id = args[1]
    local coins = args[2]
    if id then
        local tPlayer = ESX.GetPlayerFromId(id)
        if tPlayer then
            local _, fivemid = Server:GetIdentifiers(id)['fivem']:match("([^:]+):([^:]+)")
            if (fivemid) then
                local license = Server:GetIdentifiers(id)['license'];
                if (license) then
                    tPlayer.showNotification('Chargement de la requête...')
                    if tonumber(coins) then
                        LiteMySQL:Insert('tebex_players_wallet', {
                            identifiers = fivemid,
                            transaction = "Give point(s) : "..coins,
                            price = '0',
                            currency = 'Points',
                            points = coins,
                        }, function()
                            print("Coins envoyé à "..tPlayer.getName().." !")
                        end);    
                        tPlayer.showNotification('Coins reçu : ~g~'..coins)                  
                    end
                end
            end
        end
    end
end) 

RegisterNetEvent("sCore:deletecoins")
AddEventHandler("sCore:deletecoins", function(vehicle, price, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    local plate = CreateRandomPlateText()
    Server:OnProcessCheckout(source, price, string.format("Achat package %s", name), function()
        local plate = CreateRandomPlateText()
        LiteMySQL:Insert('owned_vehicles', {
            owner = xPlayer.identifier,
            plate = plate,
            model = vehicle,
            props = '{"fuelLevel":100.0}',
            parked = 1,
            label = name,
            donated = 1,
            garage_private = 0
        })
        LiteMySQL:Insert('open_car', {
            owner = xPlayer.identifier,
            plate = plate,
            NB = 1,
            donated = 1
        });
    end, function()
        xPlayer.showNotification("~r~Vous ne posséder pas les points nécessaires")
        return
    end)
    SendLogs(15105570,"Boutique - Achat","**"..GetPlayerName(source).."** vient d'acheter' : ***"..name.."*** pour ***"..price.."***\n **License** : "..xPlayer.identifier,"https://discord.com/api/webhooks/1043185766999797850/JVRJsQe4a4hesmczljDlgknrBZUAzmFOtel_fDJ_aJE4APPGpaOLYBJzTbH-LVFKYzvm")
    --SunriseLogs('https://discord.com/api/webhooks/862647433863626782/02a1fO8VCvtaGzzQM6Y_TS2BeFH-szbx1rffC0R-Q9CCctuXRag0Lfdr8mg4eZu7IWvn', "Boutique - Achat","**"..GetPlayerName(source).."** vient d'acheter une ***"..LERESULTAT3FDP.."***\n**License** : "..xPlayer.identifier.. '\nPrix de l\'achat : ['..LERESULTAT2FDP..'] SeaCoins', 56108)
end)