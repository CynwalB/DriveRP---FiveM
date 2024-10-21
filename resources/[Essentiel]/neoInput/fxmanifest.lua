fx_version 'adamant'
games { 'gta5' };

server_script 	'@mysql-async/lib/MySQL.lua' 


client_script "client.lua"   


ui_page "html/index.html"
files {
    'html/index.html',
    'html/index.js',
    'html/index.css',
    'html/reset.css'
}

exports {
    "NeoInput"
}

