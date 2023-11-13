description 'A basic freeroam gametype that respawns a player at his last position'

--[[ 
    Original Author:    Cfx.re <root@cfx.re>
]]

files {
    "*.json",
}

server_script 'basic_server.lua'

client_script 'basic_client.lua'

shared_script 'config.lua'

game 'common'
fx_version 'adamant'
