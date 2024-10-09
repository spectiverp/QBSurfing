local QBCore = exports['qb-core']:GetCoreObject()

-- Configuration
Config = {}
Config.Locations = {
    { x = -1108.71, y = -1693.39, z = 4.58 }, -- Set your interaction location here
}
Config.ItemName = 'surfboard'  -- Name of the item given

-- Variable to hold the current surfboard entity
local currentSurfboard

-- Function to draw 3D text
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local distance = GetDistanceBetweenCoords(px, py, pz, x, y, z, true)

    local scale = (1 / distance) * 2
    if scale < 0.5 then
        scale = 0.5
    end

    SetTextScale(0.0, scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(_x, _y)
end

-- Function to request and load the vehicle model
local function loadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(500) -- Wait until the model is loaded
    end
end

-- Function to spawn the surfboard vehicle
local function spawnSurfboard()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    loadModel("surfboard") -- Change to the actual model name

    -- Check if the current surfboard exists and delete it
    if currentSurfboard and DoesEntityExist(currentSurfboard) then
        DeleteVehicle(currentSurfboard)
        QBCore.Functions.Notify("Previous surfboard removed.", "error") -- Notification for removing the previous surfboard
    end

    currentSurfboard = CreateVehicle("surfboard", coords.x, coords.y, coords.z, GetEntityHeading(playerPed), true, false)

    if currentSurfboard and DoesEntityExist(currentSurfboard) then
        TaskWarpPedIntoVehicle(playerPed, currentSurfboard, -1)

        QBCore.Functions.Notify("You got out your sufboard!", "success") -- Notification for successful spawn
    else
        QBCore.Functions.Notify("Failed to spawn surfboard. Check the vehicle name and availability.", "error") -- Notification for failure
    end
end

-- Function to despawn the surfboard vehicle
local function despawnSurfboard()
    if currentSurfboard and DoesEntityExist(currentSurfboard) then
        DeleteVehicle(currentSurfboard)
        currentSurfboard = nil -- Reset the current surfboard variable
        QBCore.Functions.Notify("You put away you surfboard!", "success") -- Notification for despawning
    end
end

-- Main interaction logic
Citizen.CreateThread(function()
    for _, loc in pairs(Config.Locations) do
        local blip = AddBlipForCoord(loc.x, loc.y, loc.z)
        SetBlipSprite(blip, 404) -- Change blip sprite as needed
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 2) -- Change color as needed
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Free Surf Board")
        EndTextCommandSetBlipName(blip)
    end

    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, loc in pairs(Config.Locations) do
            local distance = #(playerCoords - vector3(loc.x, loc.y, loc.z))
            if distance < 3.0 then
                DrawText3D(loc.x, loc.y, loc.z, "[E] Talk to Surfer Dude")

                if IsControlJustReleased(0, 38) then -- E key
                    QBCore.Functions.Progressbar("talk_to_surfer", "Talking to a surfer dude...", 5000, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {}, {}, {}, function() -- On success
                        QBCore.Functions.Notify("The surfer dude gave you a surfboard for free!", "success") -- Notify player about the surfboard
                        TriggerServerEvent('surfboard:give') -- Trigger server event to give the item
                    end, function() -- On cancel
                        QBCore.Functions.Notify("Canceled!", "error")
                    end)
                end
            end
        end
    end
end)

-- Handle surfboard item usage
RegisterNetEvent('surfboard:use')
AddEventHandler('surfboard:use', function()
    if currentSurfboard and DoesEntityExist(currentSurfboard) then
        despawnSurfboard() -- Remove the current surfboard if it exists
    else
        spawnSurfboard() -- Spawn a new surfboard
    end
end)

-- Function to stop vehicle audio
local function StopVehicleAudio(vehicle)
    if DoesEntityExist(vehicle) then
        SetVehicleHornEnabled(vehicle, false) -- Disable horn sounds
        StopSound(vehicle) -- Stop any ongoing sound
        SetAudioFlag("DisableFlightNoise", true) -- Disable flight noise if applicable
        SetAudioFlag("DisableVehicleCollision", true) -- Disable collision sounds
    end
end
