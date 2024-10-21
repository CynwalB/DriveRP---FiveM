fx_version 'adamant'
game 'gta5'

this_is_a_map 'yes'
client_scripts { 
	'client.lua',
	'client/client.lua',
	'client/mph4_gtxd.meta',
	'client/water.lua',
}
files {
	"stream/int3232302352.gfx",
	'interiorproxies.meta',
	'interiorproxiessheriff.meta',
	'gabzharmony.xml',
	'weapons/weaponsnowball.meta',
	'weapons/weapons.meta',
	'weapons/weaponpipebomb.meta',
	'weapons/weaponrailgun.meta',
	'weapons/weapons_spacerangers.meta',
	'weapons/weapons_pistol_mk2.meta',
	'weapons/weaponstonehatchet.meta',
	'weapons/weapons_doubleaction.meta',
	'weapons/weaponflaregun.meta',

	'weapons/loadouts.meta',
	'weapons/weaponarchetypes.meta',
	'weapons/weaponanimations.meta',
	'weapons/weaponanimations2.meta',
	'weapons/pedpersonality.meta',
	'weapons/pedpersonality2.meta',
	'weapons/weaponsgtalife.meta',
	'weapons/explosion.ymt',

	'weapons/recul/weaponautoshotgun.meta',
	'weapons/recul/weaponbullpuprifle.meta',
	'weapons/recul/weaponcombatpdw.meta',
	'weapons/recul/weaponcompactrifle.meta',
	'weapons/recul/weapondbshotgun.meta',
	'weapons/recul/weaponfirework.meta',
	'weapons/recul/weapongusenberg.meta',
	'weapons/recul/weaponheavypistol.meta',
	'weapons/recul/weaponheavyshotgun.meta',
	'weapons/recul/weaponmachinepistol.meta',
	'weapons/recul/weaponmarksmanpistol.meta',
	'weapons/recul/weaponmarksmanrifle.meta',
	'weapons/recul/weaponminismg.meta',
	'weapons/recul/weaponmusket.meta',
	'weapons/recul/weaponrevolver.meta',
	'weapons/recul/weapons_assaultrifle_mk2.meta',
	'weapons/recul/weapons_bullpuprifle_mk2.meta',
	'weapons/recul/weapons_carbinerifle_mk2.meta',
	'weapons/recul/weapons_combatmg_mk2.meta',
	'weapons/recul/weapons_heavysniper_mk2.meta',
	'weapons/recul/weapons_marksmanrifle_mk2.meta',
	'weapons/recul/weapons_pumpshotgun_mk2.meta',
	'weapons/recul/weapons_revolver_mk2.meta',
	'weapons/recul/weapons_smg_mk2.meta',
	'weapons/recul/weapons_snspistol_mk2.meta',
	'weapons/recul/weapons_specialcarbine_mk2.meta',
	'weapons/recul/weaponsnspistol.meta',
	'weapons/recul/weaponspecialcarbine.meta',
	'weapons/recul/weaponvintagepistol.meta',
	'weapons/recul/weapon_combatshotgun.meta',
	'weapons/recul/weapon_militaryrifle.meta',
	'weapons/melee/weaponknuckle.meta',
	'weapons/melee/weaponswitchblade.meta',
	'weapons/melee/weaponbottle.meta',
	'weapons/melee/weaponpoolcue.meta',

	'weapons/vehicles/*.meta',
}
data_file "SCALEFORM_DLC_FILE" "stream/int3232302352.gfx"
data_file 'DLC_ITYP_REQUEST' 'stream/vesp_props.ytyp'
data_file 'INTERIOR_PROXY_ORDER_FILE' 'interiorproxies.meta'
data_file 'INTERIOR_PROXY_ORDER_FILE' 'interiorproxiessheriff.meta'
data_file 'TIMECYCLEMOD_FILE' 'gabzharmony.xml'
data_file 'GTXD_PARENTING_DATA' 'client/mph4_gtxd.meta'

client_script('lib/common.lua')
client_script('client.lua')

-- GTA V
client_script('gtav/base.lua')
client_script('gtav/ammunations.lua')
client_script('gtav/floyd.lua')
client_script('gtav/franklin.lua')
client_script('gtav/franklin_aunt.lua')
client_script('gtav/graffitis.lua')
client_script('gtav/lester_factory.lua')
client_script('gtav/michael.lua')
client_script('gtav/north_yankton.lua')
client_script('gtav/red_carpet.lua')
client_script('gtav/simeon.lua')
client_script('gtav/stripclub.lua')
client_script('gtav/trevors_trailer.lua')
client_script('gtav/ufo.lua')
client_script('gtav/zancudo_gates.lua')

-- GTA Online
client_script('gta_online/apartment_hi_1.lua')
client_script('gta_online/apartment_hi_2.lua')
client_script('gta_online/house_hi_1.lua')
client_script('gta_online/house_hi_2.lua')
client_script('gta_online/house_hi_3.lua')
client_script('gta_online/house_hi_4.lua')
client_script('gta_online/house_hi_5.lua')
client_script('gta_online/house_hi_6.lua')
client_script('gta_online/house_hi_7.lua')
client_script('gta_online/house_hi_8.lua')
client_script('gta_online/house_mid_1.lua')
client_script('gta_online/house_low_1.lua')

-- DLC High Life
client_script('dlc_high_life/apartment1.lua')
client_script('dlc_high_life/apartment2.lua')
client_script('dlc_high_life/apartment3.lua')
client_script('dlc_high_life/apartment4.lua')
client_script('dlc_high_life/apartment5.lua')
client_script('dlc_high_life/apartment6.lua')

-- DLC Heists
client_script('dlc_heists/carrier.lua')
client_script('dlc_heists/yacht.lua')

-- DLC Executives & Other Criminals
client_script('dlc_executive/apartment1.lua')
client_script('dlc_executive/apartment2.lua')
client_script('dlc_executive/apartment3.lua')

-- DLC Finance & Felony
client_script('dlc_finance/office1.lua')
client_script('dlc_finance/office2.lua')
client_script('dlc_finance/office3.lua')
client_script('dlc_finance/office4.lua')
client_script('dlc_finance/organization.lua')

-- DLC Bikers
client_script('dlc_bikers/cocaine.lua')
client_script('dlc_bikers/counterfeit_cash.lua')
client_script('dlc_bikers/document_forgery.lua')
client_script('dlc_bikers/meth.lua')
client_script('dlc_bikers/weed.lua')
client_script('dlc_bikers/clubhouse1.lua')
client_script('dlc_bikers/clubhouse2.lua')
client_script('dlc_bikers/gang.lua')

-- DLC Import/Export
client_script('dlc_import/garage1.lua')
client_script('dlc_import/garage2.lua')
client_script('dlc_import/garage3.lua')
client_script('dlc_import/garage4.lua')
client_script('dlc_import/vehicle_warehouse.lua')

-- DLC Gunrunning
client_script('dlc_gunrunning/bunkers.lua')
client_script('dlc_gunrunning/yacht.lua')

-- DLC Smuggler's Run
client_script('dlc_smuggler/hangar.lua')

-- DLC Doomsday Heist
client_script('dlc_doomsday/facility.lua')

-- DLC After Hours
client_script('dlc_afterhours/nightclubs.lua')

data_file 'WEAPONINFO_FILE_PATCH' 'weapons/weaponsnowball.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/weapons_doubleaction.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/weaponflaregun.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/weapons.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/weaponrailgun.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/weapons_spacerangers.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/weapons_pistol_mk2.meta'

data_file 'WEAPON_METADATA_FILE' 'weapons/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'weapons/weaponanimations.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'weapons/weaponanimations2.meta'
data_file 'LOADOUTS_FILE' 'weapons/loadouts.meta'
data_file 'WEAPONINFO_FILE' 'weapons/weaponsgtalife.meta'
data_file 'PED_PERSONALITY_FILE' 'weapons/pedpersonality.meta'
data_file 'PED_PERSONALITY_FILE' 'weapons/pedpersonality2.meta'
data_file 'EXPLOSION_INFO_FILE' 'weapons/explosion.ymt'

data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponautoshotgun.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponbullpuprifle.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponcombatpdw.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponcompactrifle.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapondbshotgun.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponfirework.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapongusenberg.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponheavypistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponheavyshotgun.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponmachinepistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponmarksmanpistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponmarksmanrifle.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponminismg.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponmusket.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponrevolver.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapons_assaultrifle_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapons_bullpuprifle_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapons_carbinerifle_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapons_combatmg_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapons_heavysniper_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapons_marksmanrifle_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapons_pumpshotgun_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapons_revolver_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapons_smg_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapons_snspistol_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapons_specialcarbine_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponsnspistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponspecialcarbine.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponvintagepistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapon_combatshotgun.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapon_militaryrifle.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/melee/weaponknuckle.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/melee/weaponswitchblade.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/melee/weaponbottle.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/melee/weaponpoolcue.meta'

data_file 'WEAPONINFO_FILE_PATCH' 'weapons/vehicles/*.meta'

client_script "client.lua"