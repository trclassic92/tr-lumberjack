local QBCore = exports['qb-core']:GetCoreObject()
local chopping = false

RegisterNetEvent('tr-lumberjack:getLumberStage', function(stage, state, k)
    Config.TreeLocations[k][stage] = state
end)

local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(3)
    end
end

local function axe()
    local ped = PlayerPedId()
    local pedWeapon = GetSelectedPedWeapon(ped)

    for k, v in pairs(Config.Axe) do
        if pedWeapon == k then
            return true
        end
    end
    QBCore.Functions.Notify(Config.Alerts["error_axe"], 'error')
end

local function ChopLumber(k)
    local animDict = "melee@hatchet@streamed_core"
    local animName = "plyr_rear_takedown_b"
    local trClassic = PlayerPedId()
    local choptime = LumberJob.ChoppingTreeTimer
    chopping = true
    FreezeEntityPosition(trClassic, true)
    QBCore.Functions.Progressbar("Chopping_Tree", Config.Alerts["chopping_tree"], choptime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('tr-lumberjack:setLumberStage', "isChopped", true, k)
        TriggerServerEvent('tr-lumberjack:setLumberStage', "isOccupied", false, k)
        TriggerServerEvent('tr-lumberjack:recivelumber')
        TriggerServerEvent('tr-lumberjack:setChoppedTimer')
        chopping = false
        TaskPlayAnim(trClassic, animDict, "exit", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
        FreezeEntityPosition(trClassic, false)
    end, function()
        ClearPedTasks(trClassic)
        TriggerServerEvent('tr-lumberjack:setLumberStage', "isOccupied", false, k)
        chopping = false
        TaskPlayAnim(trClassic, animDict, "exit", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
        FreezeEntityPosition(trClassic, false)
    end)
    TriggerServerEvent('tr-lumberjack:setLumberStage', "isOccupied", true, k)
    CreateThread(function()
        while chopping do
            loadAnimDict(animDict)
            TaskPlayAnim(trClassic, animDict, animName, 3.0, 3.0, -1, 2, 0, 0, 0, 0 )
            Wait(3000)
        end
    end)
end

RegisterNetEvent('tr-lumberjack:StartChopping', function()
    for k, v in pairs(Config.TreeLocations) do
        if not Config.TreeLocations[k]["isChopped"] then
            if axe() then
                ChopLumber(k)
            end
        end
    end
end)

if Config.Job then
    CreateThread(function()
        for k, v in pairs(Config.TreeLocations) do
            exports["qb-target"]:AddBoxZone("trees" .. k, v.coords, 1.5, 1.5, {
                name = "trees" .. k,
                heading = 40,
                minZ = v.coords["z"] - 2,
                maxZ = v.coords["z"] + 2,
                debugPoly = false
            }, {
                options = {
                    {
                        action = function()
                            if axe() then
                                ChopLumber(k)
                            end
                        end,
                        type = "client",
                        event = "tr-lumberjack:StartChopping",
                        icon = "fa fa-hand",
                        label = Config.Alerts["Tree_label"],
                        job = "lumberjack",
                        canInteract = function()
                            if v["isChopped"] or v["isOccupied"] then
                                return false
                            end
                            return true
                        end,
                    }
                },
                distance = 1.0
            })

        end
    end)
    exports['qb-target']:AddBoxZone("lumberjackdepo", LumberDepo.targetZone, 1, 1, {
        name = "Lumberjackdepo",
        heading = LumberDepo.targetHeading,
        debugPoly = false,
        minZ = LumberDepo.minZ,
        maxZ = LumberDepo.maxZ,
    }, {
        options = {
        {
          type = "client",
          event = "tr-lumberjack:bossmenu",
          icon = "Fas Fa-hands",
          label = Config.Alerts["depo_label"],
          job = "lumberjack",
        },
        },
        distance = 1.0
    })
    exports['qb-target']:AddBoxZone("LumberProcessor", LumberProcessor.targetZone, 1, 1, {
        name = "LumberProcessor",
        heading = LumberProcessor.targetHeading,
        debugPoly = false,
        minZ = LumberProcessor.minZ,
        maxZ = LumberProcessor.maxZ,
    }, {
        options = {
        {
          type = "client",
          event = "tr-lumberjack:processormenu",
          icon = "Fas Fa-hands",
          label = Config.Alerts["mill_label"],
          job = "lumberjack",
        },
        },
        distance = 1.0
    })
    exports['qb-target']:AddBoxZone("LumberSeller", LumberSeller.targetZone, 1, 1, {
        name = "LumberProcessor",
        heading = LumberSeller.targetHeading,
        debugPoly = false,
        minZ = LumberSeller.minZ,
        maxZ = LumberSeller.maxZ,
    }, {
        options = {
        {
          type = "server",
          event = "tr-lumberjack:sellItems",
          icon = "fa fa-usd",
          label = Config.Alerts["Lumber_Seller"],
          job = "lumberjack",
        },
        },
        distance = 1.0
    })
else
    CreateThread(function()
        for k, v in pairs(Config.TreeLocations) do
            exports["qb-target"]:AddBoxZone("trees" .. k, v.coords, 1.5, 1.5, {
                name = "trees" .. k,
                heading = 40,
                minZ = v.coords["z"] - 2,
                maxZ = v.coords["z"] + 2,
                debugPoly = false
            }, {
                options = {
                    {
                        action = function()
                            if axe() then
                                ChopLumber(k)
                            end
                        end,
                        type = "client",
                        event = "tr-lumberjack:StartChopping",
                        icon = "fa fa-hand",
                        label = Config.Alerts["Tree_label"],
                        canInteract = function()
                            if v["isChopped"] or v["isOccupied"] then
                                return false
                            end
                            return true
                        end,
                    }
                },
                distance = 1.0
            })

        end
    end)
    exports['qb-target']:AddBoxZone("lumberjackdepo", LumberDepo.targetZone, 1, 1, {
        name = "Lumberjackdepo",
        heading = LumberDepo.targetHeading,
        debugPoly = false,
        minZ = LumberDepo.minZ,
        maxZ = LumberDepo.maxZ,
    }, {
        options = {
        {
          type = "client",
          event = "tr-lumberjack:bossmenu",
          icon = "Fas Fa-hands",
          label = Config.Alerts["depo_label"],
        },
        },
        distance = 1.0
    })
    exports['qb-target']:AddBoxZone("LumberProcessor", LumberProcessor.targetZone, 1, 1, {
        name = "LumberProcessor",
        heading = LumberProcessor.targetHeading,
        debugPoly = false,
        minZ = LumberProcessor.minZ,
        maxZ = LumberProcessor.maxZ,
    }, {
        options = {
        {
          type = "client",
          event = "tr-lumberjack:processormenu",
          icon = "Fas Fa-hands",
          label = Config.Alerts["mill_label"],
        },
        },
        distance = 1.0
    })
    exports['qb-target']:AddBoxZone("LumberSeller", LumberSeller.targetZone, 1, 1, {
        name = "LumberProcessor",
        heading = LumberSeller.targetHeading,
        debugPoly = false,
        minZ = LumberSeller.minZ,
        maxZ = LumberSeller.maxZ,
    }, {
        options = {
        {
          type = "server",
          event = "tr-lumberjack:sellItems",
          icon = "fa fa-usd",
          label = Config.Alerts["Lumber_Seller"],
        },
        },
        distance = 1.0
    })
end

RegisterNetEvent('tr-lumberjack:vehicle', function()
    local vehicle = LumberDepo.Vehicle
    local coords = LumberDepo.VehicleCoords
    local TR = PlayerPedId()
    RequestModel(vehicle)
    while not HasModelLoaded(vehicle) do
        Wait(0)
    end
    if not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        local JobVehicle = CreateVehicle(vehicle, coords, 45.0, true, false)
        SetVehicleHasBeenOwnedByPlayer(JobVehicle,  true)
        SetEntityAsMissionEntity(JobVehicle,  true,  true)
        exports['LegacyFuel']:SetFuel(JobVehicle, 100.0)
        local id = NetworkGetNetworkIdFromEntity(JobVehicle)
        DoScreenFadeOut(1500)
        Wait(1500)
        SetNetworkIdCanMigrate(id, true)
        TaskWarpPedIntoVehicle(TR, JobVehicle, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(JobVehicle))
        DoScreenFadeIn(1500)
        Wait(2000)
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = Config.Alerts["phone_sender"],
            subject = Config.Alerts["phone_subject"],
            message = Config.Alerts["phone_message"],
            })
    else
        QBCore.Functions.Notify(Config.Alerts["depo_blocked"], "error")
    end
end)

RegisterNetEvent('tr-lumberjack:removevehicle', function()
    local TR92 = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(TR92,true)
    DeleteVehicle(vehicle)
    QBCore.Functions.Notify(Config.Alerts["depo_stored"])
end)

RegisterNetEvent('tr-lumberjack:getaxe', function()
    TriggerServerEvent('tr-lumberjack:BuyAxe')
end)

RegisterNetEvent('tr-lumberjack:bossmenu', function()
    local vehicle = {
      {
        header = Config.Alerts["vehicle_header"],
        isMenuHeader = true,
      },
      {
          header = Config.Alerts["vehicle_get"],
          txt = Config.Alerts["vehicle_text"],
          params = {
              event = 'tr-lumberjack:vehicle',
            }
      },
      {
          header = Config.Alerts["vehicle_remove"],
          txt = Config.Alerts["remove_text"],
          params = {
              event = 'tr-lumberjack:removevehicle',
            }
      },
      {
          header = Config.Alerts["battleaxe_label"],
          txt = Config.Alerts["battleaxe_text"],
          params = {
              event = 'tr-lumberjack:getaxe',
            }
      },
      {
        header = Config.Alerts["goback"],
      },
    }
exports['qb-menu']:openMenu(vehicle)
end)

RegisterNetEvent('tr-lumberjack:processormenu', function()
    local processor = {
      {
        header = Config.Alerts["lumber_mill"],
        isMenuHeader = true,
      },
      {
          header = Config.Alerts["lumber_header"],
          txt = Config.Alerts["lumber_text"],
          params = {
              event = 'tr-lumberjack:processor',
            }
      },
      {
        header = Config.Alerts["goback"],
      },
    }
exports['qb-menu']:openMenu(processor)
end)

RegisterNetEvent('tr-lumberjack:processor', function()
    QBCore.Functions.TriggerCallback('tr-lumberjack:lumber', function(lumber)
      if lumber then
        TriggerEvent('animations:client:EmoteCommandStart', {"Clipboard"})
        QBCore.Functions.Progressbar('lumber_trader', Config.Alerts['lumber_progressbar'], LumberJob.ProcessingTime , false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
        }, {}, {}, {}, function()    
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            TriggerServerEvent("tr-lumberjack:lumberprocessed")
        end, function() 
          QBCore.Functions.Notify(Config.Alerts['cancel'], "error")
        end)
      elseif not lumber then
        QBCore.Functions.Notify(Config.Alerts['error_lumber'], "error", 3000)
      end
    end)
  end)