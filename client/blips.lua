if Config.useBlips then
    CreateThread(function()
        local function CreateBlip(coords, sprite, display, scale, color, label)
            if Config.debug then
                print(coords)
            end
            local blip = AddBlipForCoord(coords)
            SetBlipSprite(blip, sprite)
            SetBlipDisplay(blip, display)
            SetBlipScale(blip, scale)
            SetBlipAsShortRange(blip, true)
            SetBlipColour(blip, color)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(label)
            EndTextCommandSetBlipName(blip)
        end

        CreateBlip(vector3(1167.403, -1347.203, 34.913), 632, 6, 0.85, 5, Lang.blip1)
        CreateBlip(vector3(-555.627, 5314.729, 74.302), 77, 6, 0.85, 5, Lang.blip2)
        CreateBlip(vector3(906.558, -1514.62, 30.413), 605, 6, 0.85, 5, Lang.blip3)
        CreateBlip(vector3(925.812, -1560.319, 30.74), 605, 6, 0.85, 5, Lang.blip3)
    end)
end