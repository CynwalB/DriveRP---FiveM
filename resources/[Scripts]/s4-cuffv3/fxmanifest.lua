fx_version 'adamant'
game 'gta5'

escrow_ignore {
	'config.lua',
}

lua54 'yes'

client_scripts { 'config.lua', 'client/*.lua' }

server_scripts { 'config.lua', 'server/*.lua', '@mysql-async/lib/MySQL.lua'}
 
ui_page "ui/index.html"
  
files { 
	"ui/index.html",
	"ui/style.css",
	'ui/script.js',
	'ui/avatar.png'
}