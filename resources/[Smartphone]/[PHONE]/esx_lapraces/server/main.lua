ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Races = {}

AvailableRaces = {}

LastRaces = {}
NotFinished = {}

Citizen.CreateThread(function()
    MySQL.Async.fetchAll("SELECT * FROM `gksphone_lapraces`", {}, function(races)
        if races[1] ~= nil then
            for k, v in pairs(races) do
                local Records = {}
                if v.records ~= nil then
                    Records = json.decode(v.records)
                end
                Races[v.raceid] = {
                    RaceName = v.name,
                    Checkpoints = json.decode(v.checkpoints),
                    Records = Records,
                    Creator = v.creator,
                    RaceId = v.raceid,
                    Started = false,
                    Waiting = false,
                    Distance = v.distance,
                    LastLeaderboard = {},
                    Racers = {},
                }
            end
        end
    end)
end)

ESX.RegisterServerCallback('esx_lapraces:server:GetRacingLeaderboards', function(source, cb)
    cb(Races)
end)

function SecondsToClock(seconds)
    local seconds = tonumber(seconds)
    local retval = 0
    if seconds <= 0 then
        retval = "00:00:00";
    else
        hours = string.format("%02.f", math.floor(seconds/3600));
        mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
        secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
        retval = hours..":"..mins..":"..secs
    end
    return retval
end

RegisterServerEvent('esx_lapraces:server:FinishPlayer')
AddEventHandler('esx_lapraces:server:FinishPlayer', function(RaceData, TotalTime, TotalLaps, BestLap)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local esxChar = GetCharacterName(src)

    local AvailableKey = GetOpenedRaceKey(RaceData.RaceId)
    local PlayersFinished = 0
    local AmountOfRacers = 0 
    for k, v in pairs(Races[RaceData.RaceId].Racers) do
        if v.Finished then
            PlayersFinished = PlayersFinished + 1
            if PlayersFinished == 1 then
                local zPlayer = ESX.GetPlayerFromIdentifier(k)
                zPlayer.addAccountMoney('bank', tonumber(AvailableRaces[AvailableKey].First))
                TriggerClientEvent('esx_lapraces:client:finishh', -1,  RaceData, RaceData.RaceId, BestLap)
                TriggerEvent('esx_lapraces:server:LeaveRaces', src, RaceData)
            end
            if PlayersFinished == 2 then
                local zPlayer = ESX.GetPlayerFromIdentifier(k)
                zPlayer.addAccountMoney('bank', tonumber(AvailableRaces[AvailableKey].Second))
            end
            if PlayersFinished == 3 then
                local zPlayer = ESX.GetPlayerFromIdentifier(k) 
                zPlayer.addAccountMoney('bank', tonumber(AvailableRaces[AvailableKey].Third))
            end
        end
        AmountOfRacers = AmountOfRacers + 1
    end
    local BLap = 0
    if TotalLaps < 2 then
        BLap = TotalTime
    else
        BLap = BestLap
    end
    if LastRaces[RaceData.RaceId] ~= nil then
        table.insert(LastRaces[RaceData.RaceId], {
            TotalTime = TotalTime,
            BestLap = BLap,
            Holder = {
                [1] = esxChar            
            }
        })
    else
        LastRaces[RaceData.RaceId] = {}
        table.insert(LastRaces[RaceData.RaceId], {
            TotalTime = TotalTime,
            BestLap = BLap,
            Holder = {
                [1] = esxChar
            }
        })
    end
    if Races[RaceData.RaceId].Records ~= nil and next(Races[RaceData.RaceId].Records) ~= nil then
        if BLap < Races[RaceData.RaceId].Records.Time then
            Races[RaceData.RaceId].Records = {
                Time = BLap,
                Holder = {
                    [1] = esxChar
                }
            }

            MySQL.Sync.execute("UPDATE `gksphone_lapraces` SET `records` = '"..json.encode(Races[RaceData.RaceId].Records).."' WHERE `raceid` = '"..RaceData.RaceId.."'", {})
           -- TriggerClientEvent('phone:client:RaceNotify', src, 'Je hebt het WR van '..RaceData.RaceName..' verbroken met een tijd van: '..SecondsToClock(BLap)..'!')
        end
    else
        Races[RaceData.RaceId].Records = {
            Time = BLap,
            Holder = {
                [1] = esxChar
            }
        }

        MySQL.Sync.execute("UPDATE `gksphone_lapraces` SET `records` = '"..json.encode(Races[RaceData.RaceId].Records).."' WHERE `raceid` = '"..RaceData.RaceId.."'", {})
       -- TriggerClientEvent('phone:client:RaceNotify', src, 'Je hebt het WR van '..RaceData.RaceName..' neergezet met een tijd van: '..SecondsToClock(BLap)..'!')
    end
    AvailableRaces[AvailableKey].RaceData = Races[RaceData.RaceId]
    TriggerClientEvent('esx_lapraces:client:PlayerFinishs', -1, RaceData.RaceId, PlayersFinished, esxChar)
    if PlayersFinished == AmountOfRacers then
        if NotFinished ~= nil and next(NotFinished) ~= nil and NotFinished[RaceData.RaceId] ~= nil and next(NotFinished[RaceData.RaceId]) ~= nil then
            for k, v in pairs(NotFinished[RaceData.RaceId]) do
                table.insert(LastRaces[RaceData.RaceId], {
                    TotalTime = v.TotalTime,
                    BestLap = v.BestLap,
                    Holder = {
                        [1] = v.Holder[1],
                        [2] = v.Holder[2]
                    }
                })
            end
        end
        Races[RaceData.RaceId].LastLeaderboard = LastRaces[RaceData.RaceId]
        Races[RaceData.RaceId].Racers = {}
        Races[RaceData.RaceId].Started = false
        Races[RaceData.RaceId].Waiting = false
        table.remove(AvailableRaces, AvailableKey)
        LastRaces[RaceData.RaceId] = nil
        NotFinished[RaceData.RaceId] = nil
    end
    TriggerClientEvent('gksphone:UpdateLapraces', -1)
end)


function IsNameAvailable(RaceName)
    local retval = true
    for RaceId,_ in pairs(Races) do
        if Races[RaceId].RaceName == RaceName then
            retval = false
            break
        end
    end
    return retval
end

RegisterServerEvent('esx_lapraces:server:CreateLapRace')
AddEventHandler('esx_lapraces:server:CreateLapRace', function(RaceName)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    
    if IsNameAvailable(RaceName) then
         TriggerClientEvent('esx_lapraces:client:StartRaceEditor', source, RaceName)
    else
        TriggerClientEvent('esx:showNotification', source, 'There is already a race with this name.', 2)
    end
end)

ESX.RegisterServerCallback('esx_lapraces:server:GetRaces', function(source, cb)
    cb(AvailableRaces)
end)

ESX.RegisterServerCallback('esx_lapraces:server:GetListedRaces', function(source, cb)
    cb(Races)
end)

ESX.RegisterServerCallback('esx_lapraces:server:LapDelete', function(source, cb, RaceId)

    MySQL.Async.execute("DELETE FROM gksphone_lapraces WHERE `raceid` = @raceid", {
        ['@raceid'] = RaceId
    })
 
    Races = {}

    Citizen.Wait(500)
    MySQL.Async.fetchAll("SELECT * FROM `gksphone_lapraces`", {}, function(races)
        if races[1] ~= nil then
            for k, v in pairs(races) do
                local Records = {}
                if v.records ~= nil then
                    Records = json.decode(v.records)
                end
                Races[v.raceid] = {
                    RaceName = v.name,
                    Checkpoints = json.decode(v.checkpoints),
                    Records = Records,
                    Creator = v.creator,
                    RaceId = v.raceid,
                    Started = false,
                    Waiting = false,
                    Distance = v.distance,
                    LastLeaderboard = {},
                    Racers = {},
                }
                
            end
            
        end
    end)
  
    Citizen.Wait(10000)
  
    cb(Races)
end)

ESX.RegisterServerCallback('esx_lapraces:server:GetRacingData', function(source, cb, RaceId)
    cb(Races[RaceId])
end)

ESX.RegisterServerCallback('esx_lapraces:server:HasCreatedRace', function(source, cb)
    cb(HasOpenedRace(ESX.GetPlayerFromId(source).identifier))
end)

ESX.RegisterServerCallback('esx_lapraces:server:IsAuthorizedToCreateRaces', function(source, cb, TrackName)
    cb(IsNameAvailable(TrackName))
end)

function HasOpenedRace(identifier)
    local retval = false
    for k, v in pairs(AvailableRaces) do
        if v.SetupSteam == identifier then
            retval = true
        end
    end
    return retval
end

ESX.RegisterServerCallback('esx_lapraces:server:GetTrackData', function(source, cb, RaceId)

    MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = '"..Races[RaceId].Creator.."'", {}, function(result)

        if result[1] ~= nil then
            charinfo = { firstname = result[1].firstname, lastname = result[1].lastname }
            cb(Races[RaceId], charinfo)
        else
            cb(Races[RaceId], {
                charinfo = {
                    firstname = "Unknown",
                    lastname = "Unknown",
                }
            })
        end
    end)
end)

function GetOpenedRaceKey(RaceId)
    local retval = nil
    for k, v in pairs(AvailableRaces) do
        if v.RaceId == RaceId then
            retval = k
            break
        end
    end
    return retval
end

function GetCurrentRace(identifier)
    local retval = nil
    for RaceId,_ in pairs(Races) do
        for cid,_ in pairs(Races[RaceId].Racers) do
            if cid == identifier then
                retval = RaceId
                break
            end
        end
    end
    return retval
end


RegisterServerEvent('esx_lapraces:server:JoinRace')
AddEventHandler('esx_lapraces:server:JoinRace', function(RaceData)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local esxChar = GetCharacterName(src)
    local RaceName = RaceData.RaceData.RaceName
    local RaceId = GetRaceId(RaceName)
    local AvailableKey = GetOpenedRaceKey(RaceData.RaceId)
    local CurrentRace = GetCurrentRace(Player.identifier)
    if CurrentRace ~= nil then
        local AmountOfRacers = 0
        PreviousRaceKey = GetOpenedRaceKey(CurrentRace)
        for k, v in pairs(Races[CurrentRace].Racers) do
            AmountOfRacers = AmountOfRacers + 1
        end
        Races[CurrentRace].Racers[Player.identifier] = nil
        if (AmountOfRacers - 1) == 0 then
            Races[CurrentRace].Racers = {}
            Races[CurrentRace].Started = false
            Races[CurrentRace].Waiting = false
            table.remove(AvailableRaces, PreviousRaceKey)
            TriggerClientEvent('esx:showNotification', src, 'You were the only one in the race. The race is over.', 2)
            TriggerClientEvent('esx_lapraces:client:LeaveRace', src, Races[CurrentRace])
        else
            AvailableRaces[PreviousRaceKey].RaceData = Races[CurrentRace]
            TriggerClientEvent('esx_lapraces:client:LeaveRace', src, Races[CurrentRace])
        end
        TriggerClientEvent('gksphone:UpdateLapraces', -1)
    end
    Races[RaceId].Waiting = true
    Races[RaceId].Racers[Player.identifier] = {
        Checkpoint = 0,
        Lap = 1,
        Finished = false,
    }
    AvailableRaces[AvailableKey].RaceData = Races[RaceId]
    TriggerClientEvent('esx_lapraces:client:JoinRace', src, Races[RaceId], RaceData.Laps)
    TriggerClientEvent('gksphone:UpdateLapraces', -1)
    local creatorsource = ESX.GetPlayerFromIdentifier(AvailableRaces[AvailableKey].SetupSteam).source
    if creatorsource ~= Player.source then
      --  TriggerClientEvent('phone:client:RaceNotify', creatorsource, string.sub(esxChar.firstname, 1, 1)..'. '..esxChar.lastname..' is de race gejoined!')
    end
end)

RegisterServerEvent('esx_lapraces:server:LeaveRaces')
AddEventHandler('esx_lapraces:server:LeaveRaces', function(source, RaceData)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local esxChar = GetCharacterName(src)
    local RaceName
    if RaceData.RaceData ~= nil then
        RaceName = RaceData.RaceData.RaceName
    else
        RaceName = RaceData.RaceName
    end
    local RaceId = GetRaceId(RaceName)
    local AvailableKey = GetOpenedRaceKey(RaceData.RaceId)

    local AmountOfRacers = 0
    for k, v in pairs(Races[RaceData.RaceId].Racers) do
        AmountOfRacers = AmountOfRacers + 1
    end
    if NotFinished[RaceData.RaceId] ~= nil then
        table.insert(NotFinished[RaceData.RaceId], {
            TotalTime = "DNF",
            BestLap = "DNF",
            Holder = {
                [1] = esxChar
            }
        })
    else
        NotFinished[RaceData.RaceId] = {}
        table.insert(NotFinished[RaceData.RaceId], {
            TotalTime = "DNF",
            BestLap = "DNF",
            Holder = {
                [1] = esxChar
            }
        })
    end
    Races[RaceId].Racers[Player.identifier] = nil
    if (AmountOfRacers - 1) == 0 then
        if NotFinished ~= nil and next(NotFinished) ~= nil and NotFinished[RaceId] ~= nil and next(NotFinished[RaceId]) ~= nil then
            for k, v in pairs(NotFinished[RaceId]) do
                if LastRaces[RaceId] ~= nil then
                    table.insert(LastRaces[RaceId], {
                        TotalTime = v.TotalTime,
                        BestLap = v.BestLap,
                        Holder = {
                            [1] = v.Holder[1],
                            [2] = v.Holder[2]
                        }
                    })
                else
                    LastRaces[RaceId] = {}
                    table.insert(LastRaces[RaceId], {
                        TotalTime = v.TotalTime,
                        BestLap = v.BestLap,
                        Holder = {
                            [1] = v.Holder[1],
                            [2] = v.Holder[2]
                        }
                    })
                end
            end
        end
        Races[RaceId].LastLeaderboard = LastRaces[RaceId]
        Races[RaceId].Racers = {}
        Races[RaceId].Started = false
        Races[RaceId].Waiting = false
        table.remove(AvailableRaces, AvailableKey)
        TriggerClientEvent('esx:showNotification', src, 'You were the only one in the race. The race is over.', 2)
        TriggerClientEvent('esx_lapraces:client:LeaveRace', src, Races[RaceId])
        LastRaces[RaceId] = nil
        NotFinished[RaceId] = nil

    end
    TriggerClientEvent('gksphone:UpdateLapraces', -1)
end)

RegisterServerEvent('esx_lapraces:server:LeaveRace')
AddEventHandler('esx_lapraces:server:LeaveRace', function(RaceData)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local esxChar = GetCharacterName(src)
    local RaceName
    if RaceData.RaceData ~= nil then
        RaceName = RaceData.RaceData.RaceName
    else
        RaceName = RaceData.RaceName
    end
    local RaceId = GetRaceId(RaceName)
    local AvailableKey = GetOpenedRaceKey(RaceData.RaceId)

    local AmountOfRacers = 0
    for k, v in pairs(Races[RaceData.RaceId].Racers) do
        AmountOfRacers = AmountOfRacers + 1
    end
    if NotFinished[RaceData.RaceId] ~= nil then
        table.insert(NotFinished[RaceData.RaceId], {
            TotalTime = "DNF",
            BestLap = "DNF",
            Holder = {
                [1] = esxChar
            }
        })
    else
        NotFinished[RaceData.RaceId] = {}
        table.insert(NotFinished[RaceData.RaceId], {
            TotalTime = "DNF",
            BestLap = "DNF",
            Holder = {
                [1] = esxChar
            }
        })
    end
    Races[RaceId].Racers[Player.identifier] = nil
    if (AmountOfRacers - 1) == 0 then
        if NotFinished ~= nil and next(NotFinished) ~= nil and NotFinished[RaceId] ~= nil and next(NotFinished[RaceId]) ~= nil then
            for k, v in pairs(NotFinished[RaceId]) do
                if LastRaces[RaceId] ~= nil then
                    table.insert(LastRaces[RaceId], {
                        TotalTime = v.TotalTime,
                        BestLap = v.BestLap,
                        Holder = {
                            [1] = v.Holder[1],
                            [2] = v.Holder[2]
                        }
                    })
                else
                    LastRaces[RaceId] = {}
                    table.insert(LastRaces[RaceId], {
                        TotalTime = v.TotalTime,
                        BestLap = v.BestLap,
                        Holder = {
                            [1] = v.Holder[1],
                            [2] = v.Holder[2]
                        }
                    })
                end
            end
        end
        Races[RaceId].LastLeaderboard = LastRaces[RaceId]
        Races[RaceId].Racers = {}
        Races[RaceId].Started = false
        Races[RaceId].Waiting = false
        table.remove(AvailableRaces, AvailableKey)
        TriggerClientEvent('esx:showNotification', src, 'You were the only one in the race. The race is over.', 2)
        TriggerClientEvent('esx_lapraces:client:LeaveRace', src, Races[RaceId])
        LastRaces[RaceId] = nil
        NotFinished[RaceId] = nil

    end
    TriggerClientEvent('gksphone:UpdateLapraces', -1)
end)

RegisterServerEvent('esx_lapraces:server:SetupRace')
AddEventHandler('esx_lapraces:server:SetupRace', function(RaceId, Laps, PhoneNumber, Katilim, First, Second, Third)
    local Player = ESX.GetPlayerFromId(source)
    local d = First + Second + Third
    if Player.getAccount('bank').money >= d then
        if Races[RaceId] ~= nil then
            if not Races[RaceId].Waiting then
                if not Races[RaceId].Started then
                    Races[RaceId].Waiting = true
                    table.insert(AvailableRaces, {
                        RaceData = Races[RaceId],
                        Laps = Laps,
                        RaceId = RaceId,
                        SetupSteam = Player.identifier,
                        PhoneNumber = PhoneNumber,
                        Katilim = Katilim,
                        First = First, 
                        Second = Second,
                        Third = Third
                    })
                    
                    TriggerClientEvent('gksphone:UpdateLapraces', -1)
                    SetTimeout(5 * 60 * 1000, function()
                        if Races[RaceId].Waiting then
                            local AvailableKey = GetOpenedRaceKey(RaceId)
                            for cid,_ in pairs(Races[RaceId].Racers) do
                                local RacerData = ESX.GetPlayerFromIdentifier(cid)
                                if RacerData ~= nil then
                                    TriggerClientEvent('esx_lapraces:client:LeaveRace', RacerData.source, Races[RaceId])
                                end
                            end
                            table.remove(AvailableRaces, AvailableKey)
                            Races[RaceId].LastLeaderboard = {}
                            Races[RaceId].Racers = {}
                            Races[RaceId].Started = false
                            Races[RaceId].Waiting = false
                            LastRaces[RaceId] = nil
                            TriggerClientEvent('gksphone:UpdateLapraces', -1)
                        end
                    end)
                else
        
                    TriggerClientEvent('esx:showNotification', source, 'The race is already active.')
                end
            else
    
                TriggerClientEvent('esx:showNotification', source, 'The race is already active.')
            end
        else

            TriggerClientEvent("esx:showNotification", source, "This race does not exist.")
        end
    else
        TriggerClientEvent('gksphone:notifi', source, {title = 'Bourse', message = "You don't have enough money" , img= '/html/static/img/icons/race.png' })
    end
end)

RegisterServerEvent('esx_lapraces:server:UpdateRaceState')
AddEventHandler('esx_lapraces:server:UpdateRaceState', function(RaceId, Started, Waiting)
    Races[RaceId].Waiting = Waiting
    Races[RaceId].Started = Started
end)

RegisterServerEvent('esx_lapraces:server:UpdateRacerData')
AddEventHandler('esx_lapraces:server:UpdateRacerData', function(RaceId, Checkpoint, Lap, Finished)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local steam = Player.identifier

    Races[RaceId].Racers[steam].Checkpoint = Checkpoint
    Races[RaceId].Racers[steam].Lap = Lap
    Races[RaceId].Racers[steam].Finished = Finished

    TriggerClientEvent('esx_lapraces:client:UpdateRaceRacerData', -1, RaceId, Races[RaceId])
end)

RegisterServerEvent('esx_lapraces:server:StartRace')
AddEventHandler('esx_lapraces:server:StartRace', function(RaceId)
    local src = source
    local MyPlayer = ESX.GetPlayerFromId(src)
    local AvailableKey = GetOpenedRaceKey(RaceId)
    
    if RaceId ~= nil then
        if AvailableRaces[AvailableKey].SetupSteam == MyPlayer.identifier then
            AvailableRaces[AvailableKey].RaceData.Started = true
            AvailableRaces[AvailableKey].RaceData.Waiting = false
            local miktar = (AvailableRaces[AvailableKey].First + AvailableRaces[AvailableKey].Second + AvailableRaces[AvailableKey].Third) / AvailableRaces[AvailableKey].Katilim
            for identifier,_ in pairs(Races[RaceId].Racers) do
                local Player = ESX.GetPlayerFromIdentifier(identifier)
                if Player ~= nil then
                    Player.removeAccountMoney('bank', tonumber(miktar))
                    TriggerClientEvent('esx_lapraces:client:RaceCountdown', Player.source)
                end
            end
            TriggerClientEvent('gksphone:UpdateLapraces', -1)
        else
            TriggerClientEvent('esx:showNotification', src, 'You are not the maker of the race.', 2)
        end
    else
        TriggerClientEvent('esx:showNotification', src, 'You are not in a race.', 2)
    end
end)

RegisterServerEvent('esx_lapraces:server:SaveRace')
AddEventHandler('esx_lapraces:server:SaveRace', function(RaceData)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local RaceId = GenerateRaceId()
    local Checkpoints = {}
    for k, v in pairs(RaceData.Checkpoints) do
        Checkpoints[k] = {
            offset = v.offset,
            coords = v.coords,
        }
    end
    Races[RaceId] = {
        RaceName = RaceData.RaceName,
        Checkpoints = Checkpoints,
        Records = {},
        Creator = Player.identifier,
        RaceId = RaceId,
        Started = false,
        Waiting = false,
        Distance = math.ceil(RaceData.RaceDistance),
        Racers = {},
        LastLeaderboard = {},
    }

    MySQL.Sync.execute("INSERT INTO `gksphone_lapraces` (`name`, `checkpoints`, `creator`, `distance`, `raceid`) VALUES ('"..RaceData.RaceName.."', '"..json.encode(Checkpoints).."', '"..Player.identifier.."', '"..RaceData.RaceDistance.."', '"..GenerateRaceId().."')", {})
end)

function GetRaceId(name)
    local retval = nil
    for k, v in pairs(Races) do
        if v.RaceName == name then
            retval = k
            break
        end
    end
    return retval
end

function GenerateRaceId()
    local RaceId = "LR-"..math.random(1111, 9999)
    while Races[RaceId] ~= nil do
        RaceId = "LR-"..math.random(1111, 9999)
    end
    return RaceId
end

RegisterCommand("togglesetup", function(source, args)
    local Player = ESX.GetPlayerFromId(source)

    Config.RaceSetupAllowed = not Config.RaceSetupAllowed
    if not Config.RaceSetupAllowed then
        TriggerClientEvent('esx:showNotification', source, 'No more races can be created!', 2)
    else
        TriggerClientEvent('esx:showNotification', source, "Race's can be created again!", 1)
    end
end)



ESX.RegisterServerCallback('esx_lapraces:server:CanRaceSetup', function(source, cb)
    cb(Config.RaceSetupAllowed)
end)

function GetCharacterName(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier
	local result = MySQL.Sync.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	})
    local name = result[1].firstname ..' ' ..result[1].lastname
	return name
end