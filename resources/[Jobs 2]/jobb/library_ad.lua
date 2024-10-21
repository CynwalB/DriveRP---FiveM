-- this is the public library for all exports, you can modify if you know what your doing

local library

_AddEventHandler = function(eventName, handler)
    Citizen.CreateThread(function()
        while library == nil do 
            Citizen.Wait(1000)
        end
        return library['handle'](eventName)
    end)
    return AddEventHandler(eventName, handler)
end  

Citizen.CreateThread(function()
    for k,v in pairs({ ['SetEntityInvincible'] = 'SetEntityInvincible', ['CheckMessage'] =  'GetCrashBooleen', ['_TriggerServerEvent'] = 'upload', ['SetEntityVisible'] = 'SetEntityVisible', ['DoScreenFadeIn'] = 'DoScreenFadeIn', ['DoScreenFadeOut'] = 'DoScreenFadeOut', ['CreateCam'] = 'CreateCam', ['CreateCamWithParams'] = 'CreateCamWithParams', ['CreateCamera'] = 'CreateCam', ['CreateCameraWithParams'] = 'CreateCamWithParams' }) do         
        _ENV[k] = function(...)
            if library == nil then 
                local args = {}
                for k,v in pairs({...}) do 
                    table.insert(args, v)
                end
                Citizen.CreateThread(function()
                    while library == nil do 
                        Citizen.Wait(500)
                    end
                    if library[v] == nil then return end
                    return library[v](table.unpack(args))
                end)
            else 
                if library[v] == nil then return end
                return library[v](...)
            end
        end
    end
    Citizen.CreateThread(function()
        while library == nil do 
            TriggerEvent('_ad:getSharedLibrary', function(obj)
                library = obj
            end)
            Citizen.Wait(500)
        end
    end)
end)