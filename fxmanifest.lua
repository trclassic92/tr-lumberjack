fx_version 'cerulean'
game 'gta5'

author 'TRClassic#0001, Mycroft, Benzo'
description 'LumberJack Job For QB-Core, Converted to ESX'
version '2.0.2'

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/*.lua'
}

server_scripts {'server/*.lua'}

shared_scripts {'@es_extended/imports.lua','config.lua'}

dependencies {
    'PolyZone',
    'mythic_progbar',
    'es_extended',
    'qtarget'
}