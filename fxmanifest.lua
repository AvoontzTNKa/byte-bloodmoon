-- Resource Metadata
fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'


shared_scripts {
    'config/config.lua'
}

client_scripts {
    'client/client.lua',
    '@vorp_core/client/dataview.lua'
}

server_scripts {
    'server/server.lua',
    'server/usableItems.lua',
}

author 'Byte.py'
description 'A simple script about forms, cuz yes.'
version '1.0.0'

