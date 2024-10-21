local display = false

local table = {label = "Information", submitLabel = "Valider les Informations", placeHolders = {
	{label = "Test"},
	{label = "Test"},
	{label = "Test"},
}}

local result = {}



RegisterCommand("nui", function(source, args)
	local yo = NeoInput(table)
    print(yo["0"], yo["1"], yo["2"], yo["3"])
end)   

--very important cb 
RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)


RegisterNUICallback("sendInformation", function(data)
	result = data
	SetDisplay(false) 
end)

RegisterNUICallback("main", function(data)
    SetDisplay(false)
end)

function NeoInput(data)    
	SetDisplay(not display, data)
 
	while display and json.encode(result) == "[]" do 
		Citizen.Wait(600)
		if not display and json.encode(result) == "[]" then 
			print('annulated')
			return "nil"
		end   
		if not display and json.encode(result) ~= "[]" then 
			
			return result
		end 
	end 
end


function SetDisplay(bool, information)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
		data = information
    })
end
