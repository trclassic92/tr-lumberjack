fx_version 'cerulean'
game 'gta5'

author 'TRClassic#0001'
description 'LumberJack Job For QB-Core'
version '1.0.2'

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/*.lua'
}

server_scripts {'server/*.lua'}

shared_scripts {'config.lua'}

dependencies {
    'PolyZone',
    'qb-menu',
    'qb-target'
}

this_is_a_map 'yes'