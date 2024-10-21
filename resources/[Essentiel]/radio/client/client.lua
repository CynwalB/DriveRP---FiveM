Keys = {};
function Keys.Register(Controls, ControlName, Description, Action)
    local _Keys = {
        CONTROLS = Controls
    }
    RegisterKeyMapping(string.format('rageui-%s', ControlName), Description, "keyboard", Controls)
    RegisterCommand(string.format('rageui-%s', ControlName), function(source, args)
        if (Action ~= nil) then
            Action();
        end
    end, false)
    return setmetatable(_Keys, Keys)
end

function Keys:Exists(Controls)
    return self.CONTROLS == Controls and true or false
end

local currentChannel = 0
local hasRadio = false
local RadioOpen = false
local ESX = nil
local hasRadioNotif = false
local CryptedChannelsNotif = false
local CryptedChannelsNotif2 = false
local ConnexionChannelsNotif = false
local ConnexionChannelsNotifFailed = false
local ConnexionChannelsNotifFailed2 = false
local MutedRadioNotif = false
local DesactivatedRadio = false
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(10)
    end
end)

KEEP_FOCUS = false
local threadCreated = false
local controlDisabled = {1, 2, 3, 4, 5, 6, 18, 24, 25, 37, 44, 45, 52, 68, 69, 70, 80, 85, 91, 92, 106, 111, 114, 117, 118, 122, 135, 138, 140, 141, 142, 143, 144, 152, 176, 177, 182, 199, 200, 205, 222, 223, 225, 229, 237, 238, 250, 257, 263, 264, 310, 329, 330, 331, 346, 347}

function SetKeepInputMode(bool)
    if SetNuiFocusKeepInput then
        SetNuiFocusKeepInput(bool)
    end

    KEEP_FOCUS = bool

    if not threadCreated and bool then
        threadCreated = true

        Citizen.CreateThread(function()
            while KEEP_FOCUS do
                Wait(0)
                for _,v in pairs(controlDisabled) do
                    DisableControlAction(0, v, true)
                end
            end

            threadCreated = false
        end)
    end
end

local self = {
	Has = false,
	Open = false,
	On = false,
	Enabled = true,
	Handle = nil,
	Prop = 'prop_cs_hand_radio',
	Bone = 28422,
	Offset = vector3(0.0, 0.0, 0.0),
	Rotation = vector3(0.0, 0.0, 0.0),
	Dictionary = {
		"cellphone@",
		"cellphone@in_car@ds",
		"cellphone@str",    
		"random@arrests",  
	},
	Animation = {
		"cellphone_text_in",
		"cellphone_text_out",
		"cellphone_call_listen_a",
		"generic_radio_chatter",
	},
}

local openredouu = false
function SetDisplay() 
    -- if openredouu == true or IsPlayerDead(playerPed) then
	-- 	self.Open = false
	-- 	DetachEntity(self.Handle, true, false)
	-- 	DeleteEntity(self.Prop)
    --     DeleteObject(self.Handle)
	-- 	return
	-- end

    -- if self.Open == not self.Open then
	-- 	return
	-- end
    
    self.Open = not self.Open

    local playerPed = PlayerPedId()
    local dictionaryType = 1 + (IsPedInAnyVehicle(playerPed, false) and 1 or 0)
    local animationType = 1 + (self.Open and 0 or 1)
    local dictionary = self.Dictionary[dictionaryType]
    local animation = self.Animation[animationType]

    RequestAnimDict(dictionary)
    while not HasAnimDictLoaded(dictionary) do
        Citizen.Wait(150)
    end

    if not openredouu then
        RequestModel(self.Prop)
		while not HasModelLoaded(self.Prop) do
			Citizen.Wait(150)
		end
    
        self.Handle = CreateObject(self.Prop, 0.0, 0.0, 0.0, true, true, false)
        local bone = GetPedBoneIndex(playerPed, self.Bone)
        SetCurrentPedWeapon(playerPed, 'weapon_unarmed', true)
        AttachEntityToEntity(self.Handle, playerPed, bone, self.Offset.x, self.Offset.y, self.Offset.z, self.Rotation.x, self.Rotation.y, self.Rotation.z, true, false, false, false, 2, true)
        SetModelAsNoLongerNeeded(self.Handle)
        TaskPlayAnim(playerPed, dictionary, animation, 4.0, -1, -1, 50, 0, false, false, false)

        openredouu = true
        SetNuiFocus(true, true)
        SetKeepInputMode(true)
        RadioOpen = true
        SendNUIMessage({type="display", status=true})
    else
        openredouu = false
        SetNuiFocus(false, false)
        SetKeepInputMode(false)
        RadioOpen = false
        SendNUIMessage({type="display", status=false})

        TaskPlayAnim(playerPed, dictionary, animation, 4.0, -1, -1, 50, 0, false, false, false)
        Citizen.Wait(700)
        StopAnimTask(playerPed, dictionary, animation, 1.0)
        NetworkRequestControlOfEntity(self.Handle)
        while not NetworkHasControlOfEntity(self.Handle) and count < 5000 do
            Citizen.Wait(0)
            count = count + 1
        end
        ClearPedSecondaryTask(playerPed)
        DetachEntity(self.Handle, true, false)
        DeleteEntity(self.Handle)
        DeleteObject(self.Handle)
    end
end

function AddLongString(txt)
	local maxLen = 100
	for i = 0, string.len(txt), maxLen do
		local sub = string.sub(txt, i, math.min(i + maxLen, string.len(txt)))
		AddTextComponentString(sub)
	end
end

function ShowAboveRadarMessage(message, back)
	if back then ThefeedNextPostBackgroundColor(back) end
	SetNotificationTextEntry("jamyfafi")
	AddLongString(message)
	return DrawNotification(0, 1)
end

RegisterNetEvent("Sneaky:useradio")
AddEventHandler("Sneaky:useradio",function()
    if not exports.inventaire:GetStateInventory() and not exports.sCore:GetStateFishing() then
        if not IsPedSwimming(PlayerPedId()) and not IsPedSwimmingUnderWater(PlayerPedId()) then
            displayradio()
        end
	end
end)

function displayradio()
    if not hasRadio then
        if hasRadioNotif then 
            RemoveNotification(hasRadioNotif) 
        end
        hasRadioNotif = ShowAboveRadarMessage("Vous n'avez pas de ~r~radio~s~ sur vous.")
        return 
    end
    SetDisplay()
end

function GetDisplayRadio()
    return RadioOpen
end

Keys.Register('F11','Openradio', 'Ouvrir ou ranger la radio', function()
	if not exports.inventaire:GetStateInventory() and not exports.sCore:GetStateFishing() then
        if not IsPedSwimming(PlayerPedId()) and not IsPedSwimmingUnderWater(PlayerPedId()) then
            displayradio()
        end
	end
end)

RegisterNUICallback('joinChannel', function(data)
    local channel = tonumber(data.channel)
	local PlayerData = ESX.GetPlayerData(_source)
    local restricted = {}
	
	if channel > 200 then
        if CryptedChannelsNotif then 
            RemoveNotification(CryptedChannelsNotif) 
        end
        CryptedChannelsNotif = ShowAboveRadarMessage("Les fréquences inférieures à 6 sont ~g~cryptées~s~.")
		return
	end
	
    for i,v in pairs(Config.jobChannels) do
        if channel >= v.min and channel <= v.max then
            table.insert(restricted, v)
        end
    end

    if #restricted > 0 then
        if CryptedChannelsNotif2 then 
            RemoveNotification(CryptedChannelsNotif2) 
        end
        CryptedChannelsNotif2 = ShowAboveRadarMessage("Vous essayez de rejoindre une fréquence cryptées.")
        for i,v in pairs(restricted) do
            if PlayerData.job.name == v.job and channel >= v.min and channel <= v.max then
                exports["pma-voice"]:setRadioChannel(channel)
                if ConnexionChannelsNotif then 
                    RemoveNotification(ConnexionChannelsNotif) 
                end
                ConnexionChannelsNotif = ShowAboveRadarMessage("Connexion en cours sur la fréquence cryptées ~g~"..channel.." réussie~s~.")
                currentChannel = channel
                break
            elseif i == #restricted then
                if ConnexionChannelsNotifFailed then 
                    RemoveNotification(ConnexionChannelsNotifFailed) 
                end
                ConnexionChannelsNotifFailed = ShowAboveRadarMessage("Connexion en cours sur la fréquence cryptées ~r~"..channel.." échoué~s~.")
                break
            end
        end
    else
        if ConnexionChannelsNotifFailed2 then 
            RemoveNotification(ConnexionChannelsNotifFailed2) 
        end
        ConnexionChannelsNotifFailed2 = ShowAboveRadarMessage("Connexion en cours sur la fréquence ~g~"..channel.."~s~.")
        exports["pma-voice"]:setRadioChannel(channel)
        currentChannel = channel
    end
end)

RegisterNUICallback('leaveChannel', function()
    exports["pma-voice"]:setRadioChannel(0)
    if DesactivatedRadio then 
        RemoveNotification(DesactivatedRadio) 
    end
    DesactivatedRadio = ShowAboveRadarMessage("Vous avez ~r~éteint~s~ votre radio.")
    currentChannel = 0

end)

function DrawMissionText(msg, time)
    ClearPrints()
    SetTextEntry_2('STRING')
    AddTextComponentString(msg)
    DrawSubtitleTimed(time, 1)
end

RegisterNUICallback('setVolume', function(data)
    if data.volume == 0.99 then
        data.volume = "100"
    elseif data.volume == 0.9 then
        data.volume = "90"
    elseif data.volume == 0.8 then
        data.volume = "80"
    elseif data.volume > 0.6 and data.volume < 0.8 then
        data.volume = "70"
    elseif data.volume == 0.6 then
        data.volume = "60"
    elseif data.volume == 0.5 then
        data.volume = "50"
    elseif data.volume == 0.4 then
        data.volume = "40"
    elseif data.volume == 0.3 then
        data.volume = "30"
    elseif data.volume == 0.2 then
        data.volume = "20"
    elseif data.volume == 0.1 then
        data.volume = "10"
    elseif data.volume == 0 then
        data.volume = "0"
    end
    exports["pma-voice"]:setRadioVolume(data.volume * 100, "radio")
    DrawMissionText("Vous avez changé le ~b~volume~s~ de la ~b~radio~s~ à ~b~"..data.volume.."%",2000)
end)

exports["pma-voice"]:setRadioVolume(100, "radio")
RegisterNetEvent("radioCount")
AddEventHandler("radioCount", function(count)
    if hasRadio and count ~= 0 or not hasRadio and count == 0 then return end
	
	if count == 0 then
	    exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
        exports["pma-voice"]:setRadioChannel(0)
		hasRadio = false
    else
	    exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
        exports["pma-voice"]:setRadioChannel(currentChannel)
		hasRadio = true
    end
end)

CreateThread(function()
	while true do
		Wait(5000)
		TriggerServerEvent('getRadioCount', GetPlayerServerId(PlayerId()))
	end
end)
local bool = false
RegisterCommand('+mute', function()
    bool = not bool
    if hasRadio then
        if not exports.inventaire:GetStateInventory() then 
            if bool then
                if MutedRadioNotif then 
                    RemoveNotification(MutedRadioNotif) 
                end
                MutedRadioNotif = ShowAboveRadarMessage("Vous avez ~g~activé~s~ le mode muet de votre radio.")
                exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
                exports["pma-voice"]:setRadioChannel(0)
            else
                if MutedRadioNotif then 
                    RemoveNotification(MutedRadioNotif) 
                end
                MutedRadioNotif = ShowAboveRadarMessage("Vous avez ~r~désactivé~s~ le mode muet de votre radio.")
                exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
                exports["pma-voice"]:setRadioChannel(currentChannel)
            end
        end
    end
end, false)
RegisterKeyMapping('+mute', 'Muter sa radio', 'keyboard', 'W')