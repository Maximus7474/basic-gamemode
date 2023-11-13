local json = require('json')

local playerPositions = {}
local actif_IDs = {}

-- Load saved positions from a jsonn file
function LoadPlayerPositions()
    local file = LoadResourceFile(GetCurrentResourceName(), 'positions.json') -- Load the JSON file
    if file then
        playerPositions = json.decode(file) -- Decode the JSON data into the table
    end
end

-- Initialize by loading saved positions
LoadPlayerPositions()

-- Save positions to the json file
function SavePlayerPositions()
    local file = json.encode(playerPositions) -- Encode the table as JSON
    SaveResourceFile(GetCurrentResourceName(), 'positions.json', file, -1) -- Save to the JSON file
end

function SavePosition(source, vector)
    local License = GetPlayerLicense(source)
    if License and License ~= nil then
        playerPositions[License] = {x=vector.x,y=vector.y,z=vector.z}
    end
end

function GetPlayerLicense(player)
    return GetPlayerIdentifierByType(player,Config.IdentifierType)
end

-- Event handler for when a player drops
AddEventHandler('playerDropped', function()
    local source = source
    local License = GetPlayerLicense(source)

    -- print("Saving last position, source:",source,"License",License,"lastPosition",json.encode(playerPositions[License]))

    -- Save last known position of the player and dump data to json file
    SavePosition(source, playerPositions[License])
    SavePlayerPositions()
end)

-- Event Handler to receive player positions
RegisterNetEvent("saveposition")
AddEventHandler("saveposition",function (vector)
    if not actif_IDs[source] then return end
    local source = source
    SavePosition(source,vector)
end)

-- Enable player position saving and TP player to previous position
RegisterNetEvent("GetPlayerSpawnPosition",function ()
    local source = source
    local License = GetPlayerLicense(source)
    if License and playerPositions[License] ~= nil then
        TriggerClientEvent("spawnmanga:placement",source,playerPositions[License])
    end
    actif_IDs[source] = true
end)

if Config.ManualRespawn then
    RegisterCommand("respawn", function(source, args, rawCommand)
        TriggerClientEvent("respawnPlayer", source)
    end, false)
end