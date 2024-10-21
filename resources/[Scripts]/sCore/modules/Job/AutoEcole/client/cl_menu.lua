local AeroEvent = TriggerServerEvent
ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
end)
SneakyEvent = AeroEvent

local AutoecoleMenu = {

    {
        pos = vector3(222.86190185547,373.2500610352,106.39417388916),
        blip = {
            label = "Permis Chasse et Pêche", 
            ID = 267, 
            Color = 5
        },
    },
}

local AutoEcole = {}
local Licenses = {}
local question = 0
local question1 = false
local question2 = false
local question3 = false
local question4 = false
local question5 = false
local question6 = false
local question7 = false
local question8 = false
local question9 = false
local question10 = false
local question11 = false
local question12 = false
local question13 = false
local question14 = false
local question15 = false
local question16 = false

local pquestion = 0
local pquestion1 = false
local pquestion2 = false
local pquestion3 = false
local pquestion4 = false
local pquestion5 = false
local pquestion6 = false
local pquestion7 = false
local pquestion8 = false
local pquestion9 = false
local pquestion10 = false
local pquestion11 = false
local pquestion12 = false
local pquestion13 = false
local pquestion14 = false
local pquestion15 = false
local pquestion16 = false

local error = 0
local localpermistart = false
local MaxErrors = 5
local SpeedMultiplier = 3.6
local Prices = {
	dmv = 150,
	drive = 750,
	drive_bike = 600,
	drive_truck = 1000
}
local SpeedLimits = {
	residence = 50,
	town = 80,
	freeway = 120
}
local VehicleModels = {
	drive = 'blista',
	drive_bike = 'thrust',
	drive_truck = 'mule3'
}
local Zones = {
	VehicleSpawnPoint = {
		Pos = vector3(249.409, -1407.230, 30.4094),
		Size = vector3(1.5, 1.5, 1.0),
		Color = {r = 255, g = 119, b = 0},
		Type = -1
	}
}

function DrawMissionText(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end

local CheckPoints = {
	{
		Pos = vector3(258.25311279297,-1396.8686523438,30.347593307495-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage ! Vitesse limite : ~q~' ..SpeedLimits['residence'] .. 'km/h', 5000)
		end
	},
	{
		Pos = vector3(235.61381530762,-1345.3148193359,30.397048950195-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
	{
		Pos = vector3(217.00117492676,-1411.796875,29.082345962524-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			Citizen.CreateThread(function()
				DrawMissionText('Faite rapidement un ~r~stop~s~ pour le piéton qui ~q~traverse', 5000)
				PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
				FreezeEntityPosition(vehicle, true)
				Citizen.Wait(4000)
				FreezeEntityPosition(vehicle, false)
				DrawMissionText('~q~Bien!~s~ Continuons!', 5000)
			end)
		end
	},
	{
		Pos = vector3(183.71893310547,-1397.4123535156,29.292037963867-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			setCurrentZoneType('town')

			Citizen.CreateThread(function()
				DrawMissionText('Marquer rapidement un ~r~stop~s~ et regardez à votre ~q~gauche~s~. Vitesse limite : ~q~'..SpeedLimits['town'] .. 'km/h', 5000)
				PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
				FreezeEntityPosition(vehicle, true)
				Citizen.Wait(6000)
				FreezeEntityPosition(vehicle, false)
				DrawMissionText('~q~Bien!~s~ Prenez à ~q~droite~s~ et suivez votre file', 5000)
			end)
		end
	},
	{
		Pos = vector3(228.14575195312,-1230.6403808594,29.154365539551-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Observez le traffic ~q~allumez vos feux~s~ !', 5000)
		end
	},
	{
		Pos = vector3(253.48747253418,-967.94555664062,29.158140182495-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
	{
		Pos = vector3(353.87908935547,-685.41748046875,29.159255981445-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Marquez le stop pour laisser passer les véhicules !', 5000)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
			FreezeEntityPosition(vehicle, true)
			Citizen.Wait(6000)
			FreezeEntityPosition(vehicle, false)
		end
	},
	{
		Pos = vector3(510.83700561523,-438.96737670898,30.226638793945-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
	{
		Pos = vector3(745.14093017578,-63.286270141602,57.562614440918-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
	{
		Pos = vector3(1026.9334716797,310.44326782227,83.514839172363-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			setCurrentZoneType('freeway')

			DrawMissionText('Il est temps d\'aller sur la rocade ! Vitesse limite : ~q~' ..SpeedLimits['freeway'] .. 'km/h', 5000)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
		end
	},
	{
		Pos = vector3(1480.2329101562,793.15228271484,76.898742675781-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
	{
		Pos = vector3(1688.5865478516,1301.8911132812,86.272422790527-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
	{
		Pos = vector3(2014.5841064453,1507.8138427734,75.303894042969-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
    {
		Pos = vector3(2341.6530761719,1072.1314697266,80.61572265625-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
    {
		Pos = vector3(2528.7204589844,318.47537231445,109.53538513184-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
 {
		Pos = vector3(2397.8923339844,-238.69960021973,85.197975158691-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
     {
		Pos = vector3(2085.6977539062,-601.03179931641,95.456886291504-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
     {
		Pos = vector3(1341.7247314453,-1089.0533447266,51.871551513672-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
         {
		Pos = vector3(1035.0584716797,-1350.1417236328,33.638000488281-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
	{
		Pos = vector3(1060.4498291016,-1732.2159423828,35.434772491455-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			setCurrentZoneType('town')
			DrawMissionText('Entrée en ville, attention à votre vitesse ! Vitesse limite : ~q~' ..SpeedLimits['town'] .. 'km/h', 5000)
		end
	},
         {
		Pos = vector3(766.09649658203,-1734.90234375,29.307653427124-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
	{
		Pos = vector3(376.53546142578,-1547.0297851562,29.081115722656-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Bravo, restez vigiliant!', 5000)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
		end
	},
	{
		Pos = vector3(243.82214355469,-1401.1730957031,30.391017913818-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
            TriggerEvent('persistent-vehicles/forget-vehicle', vehicle)
			ESX.Game.DeleteVehicle(pVeh)
		end
	}
}
function ShowHelpNotification(msg)
    AddTextEntry('HelpNotification', msg)
	BeginTextCommandDisplayHelp('HelpNotification')
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function CheckLicenseChasse()
    ESX.TriggerServerCallback('esx_license:checkLicense', function(hasChasseLicense)
        if hasChasseLicense then
            LicenseChasseOwned = 1
        else
            LicenseChasseOwned = 0
        end
    end, GetPlayerServerId(PlayerId()), 'chasse')
end

function CheckLicensePeche()
    ESX.TriggerServerCallback('esx_license:checkLicense', function(hasPecheLicense)
        if hasPecheLicense then
            LicensePecheOwned = 1
        else
            LicensePecheOwned = 0
        end
    end, GetPlayerServerId(PlayerId()), 'peche')
end

--[[
function CheckLicensePermisMoto()
    ESX.TriggerServerCallback('esx_license:checkLicense', function(hasDrive_MotoLicense)
        if hasDrive_MotoLicense then
            LicenseMotoOwned = 1
        else
            LicenseMotoOwned = 0
        end
    end, GetPlayerServerId(PlayerId()), 'drive_bike')
end

function CheckLicensePermisVoiture()
    ESX.TriggerServerCallback('esx_license:checkLicense', function(hasDrive_CarLicense)
        if hasDrive_CarLicense then
            LicenseVoitureOwned = 1
        else
            LicenseVoitureOwned = 0
        end
    end, GetPlayerServerId(PlayerId()), 'drive')
end
--]]

function OpenAutoEcoleRageUIMenu()

    RMenu.Add('autoecole', 'main', RageUI.CreateMenu("", "", 10, 200,'root_cause',"chasseetpeche"))
    RMenu.Add('autoecole', 'question1', RageUI.CreateSubMenu(RMenu:Get('autoecole', 'main'), "", "~q~Examen pour le permis chasse"))
    RMenu.Add('autoecole', 'pquestion1', RageUI.CreateSubMenu(RMenu:Get('autoecole', 'main'), "", "~q~Examen pour le permis pêche"))
    RMenu:Get('autoecole', 'main').EnableMouse = false
    RMenu:Get('autoecole', 'question1').Closable = false
    RMenu:Get('autoecole', 'pquestion1').Closable = false
    RMenu:Get('autoecole', 'main'):SetSubtitle("~q~San Andreas Activities")
    RMenu:Get('autoecole', 'main').Closed = function() AutoEcole.Menu = false end

    if AutoEcole.Menu then
        AutoEcole.Menu = false
--        RageUI.Visible(RMenu:Get('autoecole', 'main'), false)
--        return
    else

        AutoEcole.Menu = true

        RageUI.Visible(RMenu:Get('autoecole', 'main'), true)

        Citizen.CreateThread(function()
            while AutoEcole.Menu do
                RageUI.IsVisible(RMenu:Get('autoecole', 'main'), true, false, true, function()
--                    if LicenseOwned == 1 then
                    if LicensePecheOwned == 1 and LicenseChasseOwned == 1  then
                        RageUI.Separator("~r~Vous possédez actuellement toutes les formations")
                    else
                        if LicenseChasseOwned ~= 1 then
                            RageUI.Button("Permis chasse", nil, { RightLabel = "~q~300$ ~s~" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    ESX.TriggerServerCallback('Dmv:buy', function(ok)
                                        if ok then
                                            RageUI.GoBack()
                                            question = 1
                                            RageUI.Visible(RMenu:Get('autoecole', 'question1'),true)
                                        else
                                            ESX.ShowNotification("~r~Erreur~s~\nVous n'avez pas assez d'argent")
                                        end
                                    end,300)
                                end
                            end)
                        end
                        if LicensePecheOwned ~= 1 then
                            RageUI.Button("Permis pêche", nil, { RightLabel = "~q~200$ ~s~" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    ESX.TriggerServerCallback('Dmv:buyPermis', function(ok)
                                        if ok then
                                            RageUI.GoBack()
                                            pquestion = 1
                                            RageUI.Visible(RMenu:Get('autoecole', 'pquestion1'),true)
                                        else
                                            ESX.ShowNotification("~r~Erreur~s~\nVous n'avez pas assez d'argent")
                                        end
                                    end,200)
                                end
                            end)
                        end
                    end
                end)

                RageUI.IsVisible(RMenu:Get('autoecole', 'question1'), true, false, true, function()
                    if question == 1 then
                        RageUI.Separator("Comment charge-t-on son fusil ?")
                        RageUI.Checkbox("1. Comme on peut", nil, question1,{},function(Hovered,Active,Selected,Checked)
                            question1 = Checked
                            if Checked then
                                question = 2
                                error = 1
                            else
                            end
                        end)
                        RageUI.Checkbox("2. En le pointant vers le sol", nil, question2,{},function(Hovered,Active,Selected,Checked)
                            question2 = Checked
                            if Checked then
                                question = 2
                                error = 1
                            else
                            end
                        end)
                        RageUI.Checkbox("3. En le pointant vers le ciel", nil, question3,{},function(Hovered,Active,Selected,Checked)
                            question3 = Checked
                            if Checked then
                                question = 2
                            else
                            end
                        end)
                        RageUI.Checkbox("4. En le tenir par l'extrémité", nil, question4,{},function(Hovered,Active,Selected,Checked)
                            question4 = Checked
                            if Checked then
                                question = 2
                                error = 1
                            else
                            end
                        end)
                    elseif question == 2 then
                        RageUI.Separator("Je vois quelque chose bouger...")
                        RageUI.Checkbox("1. J'analyse et m'assure que ce soit une bête", nil, question5,{},function(Hovered,Active,Selected,Checked)
                            question5 = Checked
                            if Checked then
                                question = 3
                            else
                            end
                        end)
                        RageUI.Checkbox("2. Je tire, je ne veux pas louper ma bête", nil, question6,{},function(Hovered,Active,Selected,Checked)
                            question6 = Checked
                            if Checked then
                                question = 3
                                error = error + 1
                            else
                            end
                        end)
--[[                        RageUI.Checkbox("3. ", nil, question7,{},function(Hovered,Active,Selected,Checked)
                            question7 = Checked
                            if Checked then
                                question = 3
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("Réponse 4 : Quand il est rouge", nil, question8,{},function(Hovered,Active,Selected,Checked)
                            question8 = Checked
                            if Checked then
                                question = 3
                                error = error + 1
                            else
                            end
                        end) --]]
                    elseif question == 3 then
                        RageUI.Separator("Vous approchez d'un lieu de résidence")
                        RageUI.Separator("que devez vous faire ?")
                        RageUI.Checkbox("1. Continuer à chasser", nil, question7,{},function(Hovered,Active,Selected,Checked)
                            question7 = Checked
                            if Checked then
                                question = 4
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("2. M'arrêtez boire un coup", nil, question8,{},function(Hovered,Active,Selected,Checked)
                            question8 = Checked
                            if Checked then
                                question = 4
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("3. Faire demi-tour", nil, question9,{},function(Hovered,Active,Selected,Checked)
                            question9 = Checked
                            if Checked then
                                question = 4
                            else
                            end
                        end)
                        RageUI.Checkbox("4. Chasser les habitants", nil, question10,{},function(Hovered,Active,Selected,Checked)
                            question10 = Checked
                            if Checked then
                                question = 4
                                error = error + 1
                            else
                            end
                        end)
                    elseif question == 4 then
                        RageUI.Separator("Avant d'aller chasser, j'ai bu quelques verres...")
--                        RageUI.Separator("mais vous voyez un piéton qui traverse ?")
                        RageUI.Checkbox("1. Je vois bien, je vais chasser", nil, question11,{},function(Hovered,Active,Selected,Checked)
                            question11 = Checked
                            if Checked then
                                question = 5
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("2. Personne ne me retiens donc je chasse", nil, question12,{},function(Hovered,Active,Selected,Checked)
                            question12 = Checked
                            if Checked then
                                question = 5
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("3. Je rentre chez moi, je chasserai plus tard", nil, question13,{},function(Hovered,Active,Selected,Checked)
                            question13 = Checked
                            if Checked then
                                question = 5
                            else
                            end
                        end)
                        RageUI.Checkbox("4. Tout le monde est bourré alors c'est parti", nil, question14,{},function(Hovered,Active,Selected,Checked)
                            question14 = Checked
                            if Checked then
                                question = 5
                                error = error + 1
                            else
                            end
                        end)
                    elseif question == 5 then
                        RageUI.Separator("Un homme surgit d'un buisson")
                        RageUI.Separator("dans une zone de chasse")
                        RageUI.Checkbox("1. Vous le braquez", nil, question15,{},function(Hovered,Active,Selected,Checked)
                            question15 = Checked
                            if Checked then
                                question = 6
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("2. Vous buvez un coup ensemble", nil, question16,{},function(Hovered,Active,Selected,Checked)
                            question16 = Checked
                            if Checked then
                                question = 6
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("3. Vous lui foutez un plomb dans le cul", nil, question17,{},function(Hovered,Active,Selected,Checked)
                            question17 = Checked
                            if Checked then
                                question = 6
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("4. Vous appelez le LSPD ou le LSSD", nil, question18,{},function(Hovered,Active,Selected,Checked)
                            question18 = Checked
                            if Checked then
                                question = 6
                            else
                            end
                        end)
                    elseif question == 6 then
                        if error > 2 then
                            local resultatexamen = "~r~Raté~s~"
                            RageUI.Button("Résultat de votre examen : "..resultatexamen, nil, { RightLabel = ">" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    question = 0
                                    question1 = false
                                    question2 = false
                                    question3 = false
                                    question4 = false
                                    question5 = false
                                    question6 = false
                                    question7 = false
                                    question8 = false
                                    question9 = false
                                    question10 = false
                                    question11 = false
                                    question12 = false
                                    question13 = false
                                    question14 = false
                                    question15 = false
                                    question16 = false
                                    question17 = false
                                    question18 = false
                                    error = 0
                                    RageUI.Visible(RMenu:Get('autoecole', 'main'),true)
                                end
                            end)
                        else
                            local resultatexamen = "~g~Réussi~s~"
                            RageUI.Button("Résultat de votre examen : "..resultatexamen, nil, { RightLabel = ">" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    SneakyEvent("esx_dmvschool:addLicense", GetEntityCoords(PlayerPedId()), 'chasse')
                                    ESX.SetTimeout(100, function()
                                        CheckLicenseChasse()
                                    end)
                                    RageUI.GoBack()
                                end
                            end)
                        end
                    end
                
                end)
                

                RageUI.IsVisible(RMenu:Get('autoecole', 'pquestion1'), true, false, true, function()
                    if pquestion == 1 then
                        RageUI.Separator("Je suis sur une plage publique...")
                        RageUI.Checkbox("1. Je peux pêcher", nil, pquestion1,{},function(Hovered,Active,Selected,Checked)
                            pquestion1 = Checked
                            if Checked then
                                pquestion = 2
                                error = 1
                            else
                            end
                        end)
                        RageUI.Checkbox("2. Je ne peux pas pêcher", nil, pquestion2,{},function(Hovered,Active,Selected,Checked)
                            pquestion2 = Checked
                            if Checked then
                                pquestion = 2
                            else
                            end
                        end)
--[[                        RageUI.Checkbox("Réponse 3 : 0.08%", nil, pquestion3,{},function(Hovered,Active,Selected,Checked)
                            pquestion3 = Checked
                            if Checked then
                                pquestion = 2
                            else
                            end
                        end)
                        RageUI.Checkbox("Réponse 4 : 0.10%", nil, pquestion4,{},function(Hovered,Active,Selected,Checked)
                            pquestion4 = Checked
                            if Checked then
                                pquestion = 2
                                error = 1
                            else
                            end
                        end) --]]
                    elseif pquestion == 2 then
                        RageUI.Separator("Par décret du gouvernement la pêche")
                        RageUI.Separator("est suspendu...")
                        RageUI.Checkbox("1. Je ne peux pêcher", nil, pquestion3,{},function(Hovered,Active,Selected,Checked)
                            pquestion3 = Checked
                            if Checked then
                                pquestion = 3
                            else
                            end
                        end)
                        RageUI.Checkbox("2. Je ne veux pas pêcher", nil, pquestion4,{},function(Hovered,Active,Selected,Checked)
                            pquestion4 = Checked
                            if Checked then
                                pquestion = 3
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("3. Je peux pêcher si je veux", nil, pquestion5,{},function(Hovered,Active,Selected,Checked)
                            pquestion5 = Checked
                            if Checked then
                                pquestion = 3
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("4. Le gouvernement ? On s'en fout", nil, pquestion6,{},function(Hovered,Active,Selected,Checked)
                            pquestion6 = Checked
                            if Checked then
                                pquestion = 3
                                error = error + 1
                            else
                            end
                        end)
                    elseif pquestion == 3 then
                        RageUI.Separator("J'ai bu quelques verres...")
--                        RageUI.Separator("que devez vous faire ?")
                        RageUI.Checkbox("1. Je peux aller pêcher", nil, pquestion7,{},function(Hovered,Active,Selected,Checked)
                            pquestion7 = Checked
                            if Checked then
                                pquestion = 4
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("2. Les copaines y vont donc j'y vais", nil, pquestion8,{},function(Hovered,Active,Selected,Checked)
                            pquestion8 = Checked
                            if Checked then
                                pquestion = 4
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("3. Je m'abstiens de pêcher", nil, pquestion9,{},function(Hovered,Active,Selected,Checked)
                            pquestion9 = Checked
                            if Checked then
                                pquestion = 4
                            else
                            end
                        end)
                        RageUI.Checkbox("4. J'ai rien manger, il me faut un poisson", nil, pquestion10,{},function(Hovered,Active,Selected,Checked)
                            pquestion10 = Checked
                            if Checked then
                                pquestion = 4
                                error = error + 1
                            else
                            end
                        end)
                    elseif pquestion == 4 then
                        RageUI.Separator("Je pêche dans une zone prévu à cet effet")
                        RageUI.Separator("et un beateau de plaisance arrive...")
                        RageUI.Checkbox("1. Je lui balance ma canne", nil, pquestion11,{},function(Hovered,Active,Selected,Checked)
                            pquestion11 = Checked
                            if Checked then
                                pquestion = 5
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("2. Je l'insulte", nil, pquestion12,{},function(Hovered,Active,Selected,Checked)
                            pquestion12 = Checked
                            if Checked then
                                pquestion = 5
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("3. J'appelle les autorités compétentes", nil, pquestion13,{},function(Hovered,Active,Selected,Checked)
                            pquestion13 = Checked
                            if Checked then
                                pquestion = 5
                            else
                            end
                        end)
                        RageUI.Checkbox("4. J'essaie de lui cracher dessus", nil, pquestion14,{},function(Hovered,Active,Selected,Checked)
                            pquestion14 = Checked
                            if Checked then
                                pquestion = 5
                                error = error + 1
                            else
                            end
                        end)
                    elseif pquestion == 5 then
                        RageUI.Separator("Si je loupe cet examen...")
                        RageUI.Checkbox("1. Je pourrai aller pêcher", nil, pquestion15,{},function(Hovered,Active,Selected,Checked)
                            pquestion15 = Checked
                            if Checked then
                                pquestion = 6
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("2. Je vais acheter une canne pour pêcher", nil, pquestion16,{},function(Hovered,Active,Selected,Checked)
                            pquestion16 = Checked
                            if Checked then
                                pquestion = 6
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("3. J'insulte l'examinateur/trice", nil, pquestion17,{},function(Hovered,Active,Selected,Checked)
                            pquestion17 = Checked
                            if Checked then
                                pquestion = 6
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("4. J'attends de le réussir pour pêcher", nil, pquestion18,{},function(Hovered,Active,Selected,Checked)
                            pquestion18 = Checked
                            if Checked then
                                pquestion = 6
                            else
                            end
                        end)
                    elseif pquestion == 6 then
                        if error > 2 then
                            local resultatexamen = "~r~Raté~s~"
                            RageUI.Button("Résultat de votre examen : "..resultatexamen, nil, { RightLabel = ">" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    pquestion = 0
                                    pquestion1 = false
                                    pquestion2 = false
                                    pquestion3 = false
                                    pquestion4 = false
                                    pquestion5 = false
                                    pquestion6 = false
                                    pquestion7 = false
                                    pquestion8 = false
                                    pquestion9 = false
                                    pquestion10 = false
                                    pquestion11 = false
                                    pquestion12 = false
                                    pquestion13 = false
                                    pquestion14 = false
                                    pquestion15 = false
                                    pquestion16 = false
                                    pquestion17 = false
                                    pquestion18 = false
                                    error = 0
                                    RageUI.Visible(RMenu:Get('autoecole', 'main'),true)
                                end
                            end)
                        else
                            local resultatexamen = "~g~Réussi~s~"
                            RageUI.Button("Résultat de votre examen : "..resultatexamen, nil, { RightLabel = ">" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    SneakyEvent("esx_dmvschool:addLicense", GetEntityCoords(PlayerPedId()), 'peche')
                                    ESX.SetTimeout(100, function()
                                        CheckLicensePeche()
                                    end)
                                    RageUI.GoBack()
                                end
                            end)
                        end
                    end
                
                end)
                Wait(0)

            end
        end)
    end
end

Citizen.CreateThread(function()
    while true do
        att = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(AutoecoleMenu) do
            local mPos = #(pCoords-v.pos)
            if not AutoEcole.Menu then
                if mPos <= 10.0 then
                    att = 1
                
                    if mPos <= 1.5 then
                        ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour ~q~intéragir ~s~avec l'examinatrice")
                        if IsControlJustPressed(0, 51) then
                            CheckLicensePeche()
                            CheckLicenseChasse()
                            OpenAutoEcoleRageUIMenu()
                        end
                    end
                end
            end
        end
        Citizen.Wait(att)
    end
end)

function StartDriveTest(type)
	ESX.Game.SpawnVehicle(VehicleModels[type], Zones.VehicleSpawnPoint.Pos, 317.0, function(vehicle)
        local veh = CreateVehicle(GetHashKey(VehicleModels[type]), Zones.VehicleSpawnPoint.Pos, 317.0, true, false)
		CurrentTest = 'drive'
		CurrentTestType = type
		CurrentCheckPoint = 0
		LastCheckPoint = -1
		CurrentZoneType = 'residence'
		DriveErrors = 0
		IsAboveSpeedLimit = false
		CurrentVehicle = vehicle
		LastVehicleHealth = GetEntityHealth(vehicle)
		local playerPed = PlayerPedId()
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		SetVehicleNumberPlateText(vehicle, "DMV1")
        local newPlate = GetVehicleNumberPlateText(vehicle)
		SneakyEvent('esx_vehiclelock:givekey', 'no', newPlate)
        typekodalegrosfdp = type
        localpermistart = true
        TriggerEvent('persistent-vehicles/register-vehicle', vehicle)
	end)
end

function StopDriveTest(success)
	if success then
        SneakyEvent("esx_dmvschool:addLicense", GetEntityCoords(PlayerPedId()), typekodalegrosfdp)
		ESX.ShowNotification('Vous avez ~q~réussi~s~ le test.')
	else
		ESX.ShowNotification('Vous avez ~r~raté~s~ le test.')
	end

	CurrentTest = nil
	CurrentTestType = nil
end

function SetCurrentZoneType(type)
	CurrentZoneType = type
end

-- Drive test
Citizen.CreateThread(function()
	while true do
        if CurrentTest == nil then
            Wait(850)
        else
            Wait(10)
            if CurrentTest == 'drive' then
                local playerPed = PlayerPedId()
                local coords = GetEntityCoords(playerPed, false)
                local nextCheckPoint = CurrentCheckPoint + 1

                if CheckPoints[nextCheckPoint] == nil then
                    if DoesBlipExist(CurrentBlip) then
                        RemoveBlip(CurrentBlip)
                    end

                    CurrentTest = nil

                    ESX.ShowNotification('Vous avez terminé le test de conduire')

                    if DriveErrors < MaxErrors then
                        StopDriveTest(true)
                        localpermistart = false
                    else
                        StopDriveTest(false)
                        localpermistart = false
                    end
                else
                    if CurrentCheckPoint ~= LastCheckPoint then
                        if DoesBlipExist(CurrentBlip) then
                            RemoveBlip(CurrentBlip)
                        end

                        CurrentBlip = AddBlipForCoord(CheckPoints[nextCheckPoint].Pos.x, CheckPoints[nextCheckPoint].Pos.y, CheckPoints[nextCheckPoint].Pos.z)
                        SetBlipRoute(CurrentBlip, 1)

                        LastCheckPoint = CurrentCheckPoint
                    end

                    local distance = GetDistanceBetweenCoords(coords, CheckPoints[nextCheckPoint].Pos.x, CheckPoints[nextCheckPoint].Pos.y, CheckPoints[nextCheckPoint].Pos.z, true)

                    if distance <= 100.0 then
                        DrawMarker(1, CheckPoints[nextCheckPoint].Pos.x, CheckPoints[nextCheckPoint].Pos.y, CheckPoints[nextCheckPoint].Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 119, 0, 255, false, false, 2, false, false, false, false)
                    end

                    if distance <= 3.0 then
                        CheckPoints[nextCheckPoint].Action(playerPed, CurrentVehicle, SetCurrentZoneType)
                        CurrentCheckPoint = CurrentCheckPoint + 1
                    end
                end
            end
        end
	end
end)

-- Speed / Damage control
Citizen.CreateThread(function()
	while true do
        if CurrentTest == nil then
            Wait(850)
        else
            Wait(10)
            if CurrentTest == 'drive' then
                local playerPed = PlayerPedId()

                if IsPedInAnyVehicle(playerPed, false) then
                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    local speed = GetEntitySpeed(vehicle) * SpeedMultiplier
                    local tooMuchSpeed = false

                    for k, v in pairs(SpeedLimits) do
                        if CurrentZoneType == k and speed > v then
                            tooMuchSpeed = true

                            if not IsAboveSpeedLimit then
                                DriveErrors = DriveErrors + 1
                                IsAboveSpeedLimit = true

                                ESX.ShowNotification('Vous roulez trop vite, vitesse limite: ~q~'..v..'~s~ km/h!')
                                ESX.ShowNotification('Erreurs : ~r~'..DriveErrors..'~s~/'..MaxErrors)
                            end
                        end
                    end

                    if not tooMuchSpeed then
                        IsAboveSpeedLimit = false
                    end

                    local health = GetEntityHealth(vehicle)

                    if health < LastVehicleHealth then
                        DriveErrors = DriveErrors + 1

                        ESX.ShowNotification('Vous avez endommagé votre véhicule')
                        ESX.ShowNotification('Erreurs : ~r~'..DriveErrors..'~s~/'..MaxErrors)
                        LastVehicleHealth = health
                    end
                end
            end
        end
	end
end)
