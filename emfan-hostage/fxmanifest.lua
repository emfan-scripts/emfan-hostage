fx_version 'cerulean'

game 'gta5'

author 'eMILSOMFAN'

description {
    'emfan-pepperspray',
    'Please join my discord for support.',
    'https://discord.com/invite/2QHF5mmFQ7',
    'A script to create the possibilty to put a bag över a players head and make them blind.',
}

shared_script 'config.lua'

client_scripts {
    'client/cl_main.lua',
}

server_scripts {
    'server/sv_main.lua',
}

escrow_ignore {
    '*/*.*'
}

lua54 'yes'