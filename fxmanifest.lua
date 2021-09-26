fx_version 'cerulean'
game 'gta5'
author 'SovietRulez#0001'
description 'SBShops'
version '1.0.0'

shared_scripts { 
	'@qb-core/import.lua',
	'config.lua'
}

client_scripts {
    '@menuv/menuv.lua',
    'client/menu.lua',
    'client/main.lua',
	'config.lua'
}

server_script 'server/main.lua'

dependencies {
	'qb-inventory',
	'linden_outlawalert'
}
