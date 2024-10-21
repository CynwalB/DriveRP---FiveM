fx_version 'cerulean'
game 'gta5'

this_is_a_map 'yes'

client_scripts {
    'client.lua',
    'BoxZone.lua',
    'EntityZone.lua',
    'CircleZone.lua',
    'ComboZone.lua',
    'creation/client/*.lua',
    "client/*.lua"
  }
  
server_scripts {
  'creation/server/*.lua',
  'server.lua'
}