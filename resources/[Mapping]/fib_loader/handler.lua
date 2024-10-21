last_ipl = 'qnx_ms_fib'

local allowed_IPL = {
	['fib'] = true,
	['g6'] = true,
	['ms'] = true,
	['ms2'] = true,
	['mw'] = true,
	['ch'] = true,
	['dea'] = true,
	['homeland'] = true,
	['iaa'] = true,
	['justice'] = true,
	['lspd'] = true,
	['ns'] = true,
	['sahp'] = true,
	['statep'] = true,
}

function enableIPL(ipl)
	if allowed_IPL[ipl] == nil then return false end

	last_ipl = ('qnx_ms_%s') : format(ipl)
	-- FIB uj_marshall: 22.983, -925.455, 29.905
	int_qnx_ms = GetInteriorAtCoordsWithType(22.983, -925.455, 29.905,"qnx_ms")
	while int_qnx_ms == nil or int_qnx_ms == 0 do
		Citizen.Wait(100)
		int_qnx_ms = GetInteriorAtCoordsWithType(22.983, -925.455, 29.905,"qnx_ms")
	end
	-- Citizen.Wait(1000)
	RequestIpl(last_ipl)
	EnableInteriorProp(int_qnx_ms, last_ipl)
	RefreshInterior(int_qnx_ms)

	return true
end

function disableAllIPL()
	for k, v in pairs(allowed_IPL) do
		last_ipl = ('qnx_ms_%s') : format(k)
		-- FIB uj_marshall: 22.983, -925.455, 29.905
		int_qnx_ms = GetInteriorAtCoordsWithType(22.983, -925.455, 29.905,"qnx_ms")
		while int_qnx_ms == nil or int_qnx_ms == 0 do
			Citizen.Wait(100)
			int_qnx_ms = GetInteriorAtCoordsWithType(22.983, -925.455, 29.905,"qnx_ms")
		end
		-- Citizen.Wait(1000)
		RemoveIpl(last_ipl)
		DisableInteriorProp(int_qnx_ms, last_ipl)
		RefreshInterior(int_qnx_ms)
	end
end


function disableLastIPL()
	-- FIB uj_marshall: 22.983, -925.455, 29.905
	int_qnx_ms = GetInteriorAtCoordsWithType(22.983, -925.455, 29.905,"qnx_ms")
	while int_qnx_ms == nil or int_qnx_ms == 0 do
		Citizen.Wait(100)
		int_qnx_ms = GetInteriorAtCoordsWithType(22.983, -925.455, 29.905,"qnx_ms")
	end
	-- Citizen.Wait(1000)
	RemoveIpl(last_ipl)
	DisableInteriorProp(int_qnx_ms, last_ipl)
	RefreshInterior(int_qnx_ms)
end

CreateThread(function()
	disableAllIPL()

	enableIPL('fib')
end)

RegisterCommand('marshal', function(source, args, raw)

	disableLastIPL()

	enableIPL('ms')
		

end, false)

RegisterCommand('marshal2', function(source, args, raw)

	disableLastIPL()

	enableIPL('ms2')
		

end, false)

RegisterCommand('fib', function(source, args, raw)

	disableLastIPL()

	enableIPL('fib')
		

end, false)


RegisterCommand('g6', function(source, args, raw)

	disableLastIPL()

	enableIPL('g6')

end, false)


RegisterCommand('mw', function(source, args, raw)

	disableLastIPL()

	enableIPL('mw')

end, false)

RegisterCommand('ch', function(source, args, raw)

	disableLastIPL()

	enableIPL('ch')

end, false)

RegisterCommand('dea', function(source, args, raw)

	disableLastIPL()

	enableIPL('dea')

end, false)

RegisterCommand('homesec', function(source, args, raw)

	disableLastIPL()

	enableIPL('homeland')

end, false)

RegisterCommand('iaa', function(source, args, raw)

	disableLastIPL()

	enableIPL('iaa')

end, false)

RegisterCommand('justdept', function(source, args, raw)

	disableLastIPL()

	enableIPL('justice')

end, false)

RegisterCommand('lspd', function(source, args, raw)

	disableLastIPL()

	enableIPL('lspd')

end, false)

RegisterCommand('ns', function(source, args, raw)

	disableLastIPL()

	enableIPL('ns')

end, false)

RegisterCommand('sahp', function(source, args, raw)

	disableLastIPL()

	enableIPL('sahp')

end, false)

RegisterCommand('statep', function(source, args, raw)

	disableLastIPL()

	enableIPL('statep')

end, false)