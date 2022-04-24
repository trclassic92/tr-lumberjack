if Config.UseBlips then
    CreateThread(function()
        for k,v in pairs(Config.Blips) do 
            local Blip = AddBlipForCoord(v.coords)
            SetBlipSprite (Blip, v.SetBlipSprite)
            SetBlipDisplay(Blip, v.SetBlipDisplay)
            SetBlipScale  (Blip, v.SetBlipScale)
            SetBlipAsShortRange(Blip, true)
            SetBlipColour(Blip, v.SetBlipColour)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(v.BlipLabel)
            EndTextCommandSetBlipName(Blip)
            Config.Blips[k].blip = Blip
        end
        for k,v in pairs(Config.TreeLocations) do 
            local Blip = AddBlipForCoord(v.coords)
            SetBlipSprite (Blip, 79)
            SetBlipDisplay(Blip, 6)
            SetBlipScale  (Blip, 0.8)
            SetBlipAsShortRange(Blip, true)
            SetBlipColour(Blip, 2)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName("Tree Field")
            EndTextCommandSetBlipName(Blip)
            Config.TreeLocations[k].blip = Blip
        end
    end)
end
