resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'GKS GOTUR'

version '1.0'

files {

    -- TEST
	'img/*.jpg',
	'img/*.png'

}

client_scripts {
	'config.lua',
	'client/main.lua',
	'@es_extended/locale.lua',
	"locales/en.lua"
}

server_scripts {
	'config.lua',
	'server/main.lua',
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	"locales/en.lua"
}
