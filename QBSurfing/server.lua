-- server.lua
local QBCore = exports['qb-core']:GetCoreObject()

-- Register the surfboard as a usable item
QBCore.Functions.CreateUseableItem('surfboard', function(source)
    TriggerClientEvent('surfboard:use', source)
end)

-- Event to give item to the player
RegisterNetEvent('surfboard:give', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddItem('surfboard', 1)
        TriggerClientEvent("inventory:client:ItemBox", QBCore.Shared.Items['surfboard'], "add")
        print("Surfboard given to player:", src)
    else
        print("Player not found when trying to give surfboard.")
    end
end)
