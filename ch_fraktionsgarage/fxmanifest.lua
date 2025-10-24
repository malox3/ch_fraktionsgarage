fx_version 'cerulean'
game 'gta5'

author 'SinistiSkyRP'
description 'Fraktionsgarage Script mit getrennten Menüs für Fahrzeuge und Helikopter'
version '1.0.1'

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua',
    'vehicle_config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}

lua54 'yes'
