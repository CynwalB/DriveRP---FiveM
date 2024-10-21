Config              = {}
Config.Locale = 'en'
Config.ESXVersion = "1.2" -- 1.1 OR 1.2

--Blip

Config.EnableBlips = true
Config.BlipSprite   = 512
Config.ZDiff        = 2.0
Config.GOTURLocations = {
	{ ['x'] = 288.36,  ['y'] = -1267.04,  ['z'] = 29.44}
}

--warehouse location
Config.DrawDistance = 10
Config.MarkerColor  = { r = 120, g = 120, b = 240 }
Config.Zones = {

	OfficeActions = {
		Pos   = { x = 288.36, y = -1267.04, z = 29.44 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Type  = -1
	}
}

Config.deliverytime = 3 -- delivery time setting place
