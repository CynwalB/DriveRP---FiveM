fx_version('bodacious')
game('gta5')

dependency('es_extended')

server_scripts {
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'server/main.lua'
}

--client_script('@korioz/lib.lua')
client_scripts {
	'@sCore/Anticheat/shared/config.lua',
	'@sCore/Anticheat/client/checkResource.lua',
	
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'client/main.lua'
}







