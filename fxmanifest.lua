fx_version 'cerulean'
game 'gta5'

description 'Advanced Aviation System for ESX Legacy'
version '1.0.0'

author 'Your Name'

dependency 'es_extended'

client_scripts {
    'client.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}

shared_scripts {
    'config.lua'
}