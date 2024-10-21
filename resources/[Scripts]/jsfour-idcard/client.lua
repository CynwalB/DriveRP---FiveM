local open = false

-- Open ID card
RegisterNetEvent('jsfour-idcard:open')
AddEventHandler('jsfour-idcard:open', function( data, type )
	open = true
	SendNUIMessage({
		action = "open",
		array  = data,
		type   = type
	})
end)

RegisterNetEvent('jsfour-idcard:shot')
AddEventHandler('jsfour-idcard:shot', function(playerID)

	local posx, posy = 0.777, 0.26
	local width, height = 0.07, 0.14
	local x, y = GetActiveScreenResolution()
	--print('x: '..x..' y: '..y) DEV SHIT
		if x == 1920 and y == 1080 then
			posx, posy = 0.7755, 0.2935
	 		width, height = 0.07, 0.15
		elseif x == 1366 and y == 768 then
			posx, posy = 0.686, 0.366
			width, height = 0.086, 0.196
		elseif x == 1360 and y == 768 then
			posx, posy = 0.685, 0.366
			width, height = 0.087, 0.196
		elseif x == 1600 and y == 900 then
			posx, posy = 0.732, 0.3122
			width, height = 0.073, 0.168
		elseif x == 1400 and y == 1050 then
			posx, posy = 0.694, 0.267
			width, height = 0.083, 0.145
		elseif x == 1440 and y == 900 then
			posx, posy = 0.702, 0.312
			width, height = 0.082, 0.169
		elseif x == 1680 and y == 1050 then
			posx, posy = 0.745, 0.268
			width, height = 0.068, 0.1435
		elseif x == 1280 and y == 720 then
			posx, posy = 0.665, 0.3905
			width, height = 0.09, 0.2105
		elseif x == 1280 and y == 768 then
			posx, posy = 0.665, 0.366
			width, height = 0.091, 0.196
		elseif x == 1280 and y == 800 then
			posx, posy = 0.665, 0.3515
			width, height = 0.091, 0.1895
		elseif x == 1280 and y == 960 then
			posx, posy = 0.665, 0.2925
			width, height = 0.091, 0.1585
		elseif x == 1280 and y == 1024 then
			posx, posy = 0.665, 0.2745
			width, height = 0.091, 0.1475
		elseif x == 1024 and y == 768 then
			posx, posy = 0.5810, 0.366
			width, height = 0.115, 0.1965
		elseif x == 800 and y == 600 then
			posx, posy = 0.4635, 0.4685
			width, height = 0.1455, 0.251
		elseif x == 1152 and y == 864 then
			posx, posy = 0.6275, 0.325
			width, height = 0.1005, 0.175
		elseif x == 1280 and y == 600 then
			posx, posy = 0.665, 0.468
			width, height = 0.0905, 0.251
		end
		--posx, posy = newPosX(x), 0.338 -- (0.686, 0.388) cambiar a otra por el tamaño de la wea....677 338 F(X) = x*(91/554000) + (127869/277000)
		--function not working, if somebody finds a relation between resolution and the fucking coords of the sprite, then tell me :v
		--print(posx)

	local playerPed = GetPlayerPed(GetPlayerFromServerId( playerID ))
	--print(playerPed)
	--local handle = RegisterPedheadshotTransparent(playerPed)
	local handle = RegisterPedheadshot(playerPed)

	if not IsPedheadshotValid(handle) then
		print('hay un error aqui')
		print(handle)
	end

	while not IsPedheadshotReady (handle) do
		Wait (100)
		--print('test1')
	end
	--drawText() DEV SHIT
	local headshot = GetPedheadshotTxdString (handle)
	while open do
		--print('test2')
		Wait (5)
		DrawSprite (headshot, headshot, posx, posy, width, height, 0.0, 255, 255, 255, 1000)
	end
	if not open then
		UnregisterPedheadshot(handle)
	end
end)

-- Key events
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustReleased(0, 322) and open or IsControlJustReleased(0, 177) and open then
			SendNUIMessage({
				action = "close"
			})
			open = false
		end
	end
end)
