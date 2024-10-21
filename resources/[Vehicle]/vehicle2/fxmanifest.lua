fx_version('bodacious')
game('gta5')

client_scripts({
	'client/main.lua'
})

files({
	'data/**/carcols.meta',
	'data/**/carvariations.meta',
	'data/**/contentunlocks.meta',
	'data/**/handling.meta',
	'data/**/vehiclelayouts.meta',
	'data/**/vehicles.meta',
	'data/**/peds.meta',
	'data/**/handlingmoto.meta',
	'data/**/handlingbase.meta',
})

data_file('CONTENT_UNLOCKING_META_FILE')('data/**/contentunlocks.meta')
data_file('HANDLING_FILE')('data/**/handling.meta')
data_file('VEHICLE_METADATA_FILE')('data/**/vehicles.meta')
data_file('CARCOLS_FILE')('data/**/carcols.meta')
data_file('VEHICLE_VARIATION_FILE')('data/**/carvariations.meta')
data_file('VEHICLE_LAYOUTS_FILE')('data/**/vehiclelayouts.meta')
data_file('PED_METADATA_FILE')('data/**/peds.meta')
data_file('HANDLING_FILE')('data/**/handlingmoto.meta')
data_file('HANDLING_FILE')('data/**/handlingbase.meta')







