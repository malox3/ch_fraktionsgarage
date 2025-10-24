ESX = exports["es_extended"]:getSharedObject()

-- 🚗 Fahrzeug-Menü (Standard ESX)
function OpenVehicleMenu(faction)
    local playerData = ESX.GetPlayerData()
    if playerData.job.name ~= faction.job then
        ESX.ShowNotification("❌ Du hast keinen Zugriff auf diese Garage!")
        return
    end

    local elements = {}

    local list = VehicleConfig.Vehicles[faction.job]
    if list and #list > 0 then
        for _, v in pairs(list) do
            table.insert(elements, {label = v.label, value = v.model})
        end
    else
        ESX.ShowNotification("⚠️ Keine Fahrzeuge für diesen Job verfügbar!")
        return
    end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_menu', {
        title = faction.name .. " - Fahrzeuggarage",
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        ESX.Game.SpawnVehicle(data.current.value, faction.vehicleSpawnCoords.xyz, faction.vehicleSpawnCoords.w, function(vehicle)
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            ESX.ShowNotification("✅ Fahrzeug ausgeparkt: " .. data.current.label)
            TriggerEvent("kleinloa:vehicleSpawned", vehicle)
        end)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

-- 🚁 Heli-Menü (Standard ESX)
function OpenHeliMenu(faction)
    local playerData = ESX.GetPlayerData()
    if playerData.job.name ~= faction.job then
        ESX.ShowNotification("❌ Du hast keinen Zugriff auf diese Garage!")
        return
    end

    local elements = {}

    local list = VehicleConfig.Helicopters[faction.job]
    if list and #list > 0 then
        for _, v in pairs(list) do
            table.insert(elements, {label = v.label, value = v.model})
        end
    else
        ESX.ShowNotification("⚠️ Keine Helikopter für diesen Job verfügbar!")
        return
    end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'heli_menu', {
        title = faction.name .. " - Helikoptergarage",
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        ESX.Game.SpawnVehicle(data.current.value, faction.heliSpawnCoords.xyz, faction.heliSpawnCoords.w, function(vehicle)
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            ESX.ShowNotification("✅ Helikopter ausgeparkt: " .. data.current.label)
            TriggerEvent("kleinloa:heliSpawned", vehicle)
        end)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

-- 🚙 Fahrzeug oder Heli einparken über Marker
function StoreVehicle()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    local vehicles = ESX.Game.GetVehiclesInArea(playerCoords, 5.0)
    if #vehicles > 0 then
        local vehicle = vehicles[1]
        ESX.Game.DeleteVehicle(vehicle)
        ESX.ShowNotification("🚗 Fahrzeug/Helikopter wurde eingeparkt.")
        TriggerEvent("kleinloa:vehicleStored", vehicle)
    else
        ESX.ShowNotification("❌ Kein Fahrzeug in der Nähe zum Einparken.")
    end
end

-- 🧭 Marker & Interaktion
CreateThread(function()
    while true do
        local sleep = 1000
        local playerCoords = GetEntityCoords(PlayerPedId())

        for _, faction in pairs(Config.Fraktionen) do
            -- Fahrzeug-Menü
            local distVehMenu = #(playerCoords - faction.vehicleMenuCoords)
            if distVehMenu < 10.0 then
                sleep = 0
                DrawMarker(faction.vehicleMarker.type, faction.vehicleMenuCoords.x, faction.vehicleMenuCoords.y, faction.vehicleMenuCoords.z - 0.95,
                    0,0,0,0,0,0,
                    faction.vehicleMarker.size.x, faction.vehicleMarker.size.y, faction.vehicleMarker.size.z,
                    faction.vehicleMarker.color.r, faction.vehicleMarker.color.g, faction.vehicleMarker.color.b, faction.vehicleMarker.color.a,
                    false, true, 2, false, nil, nil, false)
                if distVehMenu < 2.0 then
                    ESX.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um die ~b~Fahrzeuggarage~s~ zu öffnen")
                    if IsControlJustPressed(0, 38) then -- Taste [E]
                        OpenVehicleMenu(faction)
                    end
                end
            end

            -- Fahrzeug einparken
            local distVehStore = #(playerCoords - faction.vehicleStoreCoords)
            if distVehStore < 10.0 then
                sleep = 0
                DrawMarker(faction.vehicleStoreMarker.type, faction.vehicleStoreCoords.x, faction.vehicleStoreCoords.y, faction.vehicleStoreCoords.z - 0.95,
                    0,0,0,0,0,0,
                    faction.vehicleStoreMarker.size.x, faction.vehicleStoreMarker.size.y, faction.vehicleStoreMarker.size.z,
                    faction.vehicleStoreMarker.color.r, faction.vehicleStoreMarker.color.g, faction.vehicleStoreMarker.color.b, faction.vehicleStoreMarker.color.a,
                    false, true, 2, false, nil, nil, false)
                if distVehStore < 2.0 then
                    ESX.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um dein Fahrzeug ~g~einzuparken")
                    if IsControlJustPressed(0, 38) then
                        StoreVehicle()
                    end
                end
            end

            -- Heli-Menü
            local distHeliMenu = #(playerCoords - faction.heliMenuCoords)
            if distHeliMenu < 10.0 then
                sleep = 0
                DrawMarker(faction.heliMarker.type, faction.heliMenuCoords.x, faction.heliMenuCoords.y, faction.heliMenuCoords.z - 0.95,
                    0,0,0,0,0,0,
                    faction.heliMarker.size.x, faction.heliMarker.size.y, faction.heliMarker.size.z,
                    faction.heliMarker.color.r, faction.heliMarker.color.g, faction.heliMarker.color.b, faction.heliMarker.color.a,
                    false, true, 2, false, nil, nil, false)
                if distHeliMenu < 2.0 then
                    ESX.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um die ~b~Heli-Garage~s~ zu öffnen")
                    if IsControlJustPressed(0, 38) then
                        OpenHeliMenu(faction)
                    end
                end
            end

            -- Heli einparken
            local distHeliStore = #(playerCoords - faction.heliStoreCoords)
            if distHeliStore < 10.0 then
                sleep = 0
                DrawMarker(faction.heliStoreMarker.type, faction.heliStoreCoords.x, faction.heliStoreCoords.y, faction.heliStoreCoords.z - 0.95,
                    0,0,0,0,0,0,
                    faction.heliStoreMarker.size.x, faction.heliStoreMarker.size.y, faction.heliStoreMarker.size.z,
                    faction.heliStoreMarker.color.r, faction.heliStoreMarker.color.g, faction.heliStoreMarker.color.b, faction.heliStoreMarker.color.a,
                    false, true, 2, false, nil, nil, false)
                if distHeliStore < 2.0 then
                    ESX.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um deinen Helikopter ~g~einzuparken")
                    if IsControlJustPressed(0, 38) then
                        StoreVehicle()
                    end
                end
            end
        end
        Wait(sleep)
    end
end)
