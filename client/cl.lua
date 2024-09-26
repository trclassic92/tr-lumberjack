local QBCore = exports['qb-core']:GetCoreObject()
local PlayerWorkVans = {}
local waypointCoords = vector3(-603.707, 5305.513, 70.331)
local waypointCoords2 = vector(-555.627, 5314.729, 74.302)
local cameraCoords = Config.deliverySupervisorCam
local timmyCoords = Config.deliveryTaskerCam
local logPropModel = GetHashKey("prop_logpile_03")
local logPropEntity = nil
local outlineColor = Config.outLine
local highlightDistance = Config.outLineDistance
local carryingLog = false
local logModel = 'prop_log_01'
local groundLogProp = nil
local maxLogs = Config.maxLogs
local trailer = nil
local loadedLogs = {}
local bumperBone = Config.trailerBone
local trailerOffsets = Config.logTrailerOffsets
local lumberDespawn = Config.coolDowns.lumberDespawn * 60 * 1000
local timmyTaskStarted = false
local choppedTrees = {}
local chopRadius = 5.0
local cooldownTime = Config.coolDowns.chopping * 60 * 1000
LogProp = nil
ChoppingEffect = nil
TrailerFull = false
TaskInProgress = false
IsDeliveryTruckSelected = false

-- Notification function to handle both qbcore and ox notification systems
function NotifyPlayer(message, type)
    if Config.notification == "qbcore" then
        QBCore.Functions.Notify(message, type, 5000)
    elseif Config.notification == "ox" then
        lib.notify({ title = message, type = type })
    end
end

-- Depo Vehicles
RegisterNetEvent('tr-lumberjack:client:deliverytruck', function()
    local truck = Config.deliveryTruck
    local trailer = Config.deliveryTrailer
    local coords = Config.deliverySpawn
    local player = PlayerPedId()
    local playerData = QBCore.Functions.GetPlayerData()
    local lastname = playerData.charinfo.lastname

    local function GeneratePlate()
        return "TRLUM" .. math.random(100, 999)
    end

    RequestModel(truck)
    while not HasModelLoaded(truck) do Wait(0) end

    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 10.0) then
        NotifyPlayer(Lang.vehicleToClose, 'error')
    else
        local JobVehicle = CreateVehicle(truck, coords, 45.0, true, false)
        local truckPlate = GeneratePlate()
        SetVehicleNumberPlateText(JobVehicle, truckPlate)
        SetVehicleHasBeenOwnedByPlayer(JobVehicle, true)
        SetEntityAsMissionEntity(JobVehicle, true, true)
        exports[Config.fuel]:SetFuel(JobVehicle, 100.0)
        local id = NetworkGetNetworkIdFromEntity(JobVehicle)

        DoScreenFadeOut(1500)
        Wait(1500)
        SetNetworkIdCanMigrate(id, true)
        TaskWarpPedIntoVehicle(player, JobVehicle, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", truckPlate)
        DoScreenFadeIn(1500)

        SetNewWaypoint(waypointCoords.x, waypointCoords.y)
        IsDeliveryTruckSelected = true

        RequestModel(trailer)
        while not HasModelLoaded(trailer) do Wait(0) end

        local heading = GetEntityHeading(JobVehicle)

        -- Calculate offsets for behind and to the left
        local offsetX = -5.0 * math.cos(math.rad(heading)) + 3.0 * math.sin(math.rad(heading)) -- Negative for behind, positive for left
        local offsetY = -5.0 * math.sin(math.rad(heading)) - 3.0 * math.cos(math.rad(heading))

        local trailerCoords = vector3(coords.x + offsetX, coords.y + offsetY, coords.z)
        local JobTrailer = CreateVehicle(trailer, trailerCoords, heading, true, false)
        local trailerPlate = GeneratePlate()
        SetVehicleNumberPlateText(JobTrailer, trailerPlate)
        SetEntityAsMissionEntity(JobTrailer, true, true)

        Wait(2000)
        local depoMessage = string.format(
            "Hello %s,\n\nYour delivery truck License Plate (%s) and flatbed trailer License Plate (%s) have been successfully loaned. Please proceed to the lumbermill in Paleto for your next task.\n\nThank you!",
            lastname, truckPlate, trailerPlate
        )
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = Lang.interact1,
            subject = Lang.depoInvoice,
            message = depoMessage
        })
    end
end)

RegisterNetEvent('tr-lumberjack:client:workvan', function()
    local workVan = Config.workVan
    local trailer = Config.WorkVanTrailer
    local coords = Config.lumberVan
    local player = PlayerPedId()
    local playerData = QBCore.Functions.GetPlayerData()
    local playerId = playerData.citizenid
    local lastname = playerData.charinfo.lastname
    local workVanPrice = Config.workVanPrice
    local cash = playerData.money['cash']

    local function GeneratePlate()
        local randomNum = math.random(100, 999)
        return "TRVAN" .. randomNum
    end

    if cash < workVanPrice then
        NotifyPlayer(Lang.notEnoughCash, 'error')
        return
    end

    RequestModel(workVan)
    while not HasModelLoaded(workVan) do
        Wait(0)
    end

    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        NotifyPlayer(Lang.vehicleToClose, 'error')
    else
        TriggerServerEvent('tr-lumberjack:server:workvan', workVanPrice)

        local JobVehicle = CreateVehicle(workVan, coords, 45.0, true, false)
        local vanPlate = GeneratePlate()
        SetVehicleNumberPlateText(JobVehicle, vanPlate)
        SetVehicleHasBeenOwnedByPlayer(JobVehicle, true)
        SetEntityAsMissionEntity(JobVehicle, true, true)
        exports[Config.fuel]:SetFuel(JobVehicle, 100.0)
        local id = NetworkGetNetworkIdFromEntity(JobVehicle)

        DoScreenFadeOut(1500)
        Wait(1500)
        SetNetworkIdCanMigrate(id, true)
        TaskWarpPedIntoVehicle(player, JobVehicle, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", vanPlate)
        DoScreenFadeIn(1500)

        PlayerWorkVans[playerId] = PlayerWorkVans[playerId] or {}
        PlayerWorkVans[playerId][vanPlate] = { vehicle = JobVehicle, trailer = nil }

        RequestModel(trailer)
        if not IsModelInCdimage(trailer) or not IsModelAVehicle(trailer) then
            NotifyPlayer("Trailer model not found!", 'error')
            return
        end

        while not HasModelLoaded(trailer) do
            Wait(0)
        end

        local heading = GetEntityHeading(JobVehicle)
        local offsetX = 3.0 * math.cos(math.rad(heading)) + 0.0 * math.sin(math.rad(heading))
        local offsetY = 3.0 * math.sin(math.rad(heading)) - 0.0 * math.cos(math.rad(heading))

        local trailerCoords = vector3(coords.x + offsetX, coords.y + offsetY, coords.z)
        local JobTrailer = CreateVehicle(trailer, trailerCoords, heading, true, false)
        local trailerPlate = GeneratePlate()
        SetVehicleNumberPlateText(JobTrailer, trailerPlate)
        SetEntityAsMissionEntity(JobTrailer, true, true)

        PlayerWorkVans[playerId][vanPlate].trailer = JobTrailer

        SetNewWaypoint(waypointCoords2.x, waypointCoords2.y)

        Wait(2000)
        local depoMessage = string.format(
            "Hello %s,\n\nYour work van License Plate (%s) and trailer License Plate (%s) have been successfully loaned. The loan price of $%d has been deducted from your account. Please proceed to the lumbermill in Paleto for your next task.\n\nThank you!",
            lastname,
            vanPlate,
            trailerPlate,
            workVanPrice
        )
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = Lang.interact1,
            subject = Lang.depoInvoice,
            message = depoMessage,
        })
    end
end)

RegisterNetEvent('tr-lumberjack:client:returnworkvan', function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, true)

    if vehicle == 0 then
        NotifyPlayer(Lang.incorrectVehicle, 'error')
        return
    end

    local plate = GetVehicleNumberPlateText(vehicle)
    local playerId = QBCore.Functions.GetPlayerData().citizenid

    if PlayerWorkVans[playerId] and PlayerWorkVans[playerId][plate] then
        local playerData = PlayerWorkVans[playerId][plate]
        PlayerWorkVans[playerId][plate] = nil

        if next(PlayerWorkVans[playerId]) == nil then
            PlayerWorkVans[playerId] = nil
        end

        if playerData.trailer then
            DeleteVehicle(playerData.trailer)
        end

        TriggerServerEvent('tr-lumberjack:server:returnworkvan')
        DeleteVehicle(vehicle)
        NotifyPlayer(Lang.storedVehicle, 'success')
    else
        NotifyPlayer(Lang.incorrectVehicle, 'error')
    end
end)


local function startCameraTask(targetPos, targetRot, dialogMessages)
    local player = PlayerPedId()
    local playerPos = GetEntityCoords(player)
    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    local transitionDuration = Config.camTransition * 1000
    local startTime = GetGameTimer()
    local initialCamPos = vector3(playerPos.x, playerPos.y, playerPos.z + 0.5)

    SetCamCoord(cam, initialCamPos.x, initialCamPos.y, initialCamPos.z)
    SetCamRot(cam, GetGameplayCamRot(0).x, GetGameplayCamRot(0).y, GetGameplayCamRot(0).z, 2)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, true)

    CreateThread(function()
        while true do
            local elapsedTime = GetGameTimer() - startTime
            local progress = math.min(elapsedTime / transitionDuration, 1.0)
            local newPos = CamVector(initialCamPos, targetPos, progress)
            local newRot = CamVector(GetGameplayCamRot(0), targetRot, progress)

            SetCamCoord(cam, newPos.x, newPos.y, newPos.z)
            SetCamRot(cam, newRot.x, newRot.y, newRot.z, 2)

            if progress >= 1.0 then
                NotifyPlayer(dialogMessages[1], 'primary')
                Wait(2500)
                NotifyPlayer(dialogMessages[2], 'primary')
                Wait(3500)

                local returnStartTime = GetGameTimer()
                while true do
                    local returnElapsedTime = GetGameTimer() - returnStartTime
                    local returnProgress = math.min(returnElapsedTime / transitionDuration, 1.0)
                    local returnPos = CamVector(targetPos, initialCamPos, returnProgress)
                    local returnRot = CamVector(targetRot, GetGameplayCamRot(0), returnProgress)

                    SetCamCoord(cam, returnPos.x, returnPos.y, returnPos.z)
                    SetCamRot(cam, returnRot.x, returnRot.y, returnRot.z, 2)

                    if returnProgress >= 1.0 then
                        break
                    end

                    Wait(0)
                end
                RenderScriptCams(false, false, 0, true, true)
                DestroyCam(cam, false)
                Wait(2000)
                if TaskInProgress and not timmyTaskStarted then
                    SetNewWaypoint(-815.161, 5425.259)
                    NotifyPlayer(dialogMessages[3], 'success')
                else
                    TriggerServerEvent('tr-lumberjack:server:deliverypaper')
                    SetNewWaypoint(1239.432, -3148.982)
                    NotifyPlayer(dialogMessages[3], 'success')
                end
                break
            end

            Wait(7)
        end
    end)
end

RegisterNetEvent('tr-lumberjack:client:starttask', function()
    if TaskInProgress then
        NotifyPlayer(Lang.alreadyTasked1, 'error')
        return
    end
    TaskInProgress = true
    startCameraTask(vector3(cameraCoords.x, cameraCoords.y, cameraCoords.z), vector3(0.0, 0.0, cameraCoords.w), {Lang.dialLog1, Lang.dialLog2, Lang.dialLog3})
end)

RegisterNetEvent('tr-lumberjack:client:timmytask', function()
    if not TrailerFull then
        NotifyPlayer(Lang.timmyTask, 'error')
        return
    end
    if timmyTaskStarted then
        NotifyPlayer(Lang.timmyTask, 'error')
        return
    end
    timmyTaskStarted = true
    startCameraTask(vector3(Config.deliveryTaskerCam.x, Config.deliveryTaskerCam.y, Config.deliveryTaskerCam.z), vector3(0.0, 0.0, Config.deliveryTaskerCam.w), {Lang.timmyDialLog1, Lang.timmyDialLog2, Lang.timmyDialLog3})
end)

function CamVector(startVec, endVec, t)
    return vector3(
        Cvec(startVec.x, endVec.x, t),
        Cvec(startVec.y, endVec.y, t),
        Cvec(startVec.z, endVec.z, t)
    )
end

function Cvec(start, stop, t)
    return start + (stop - start) * t
end

-- Item Counter
function HasPlayerGotLog()
    local logCount = exports.ox_inventory:Search('count', 'tr_log')
    return logCount > 0
end

function HasPlayerGotChoppedLogs()
    ChoppedLogs = exports.ox_inventory:Search('count', 'tr_choppedlog')
    return ChoppedLogs > 0
end

function StartCarryingLog(playerPed)
    local playerCoords = GetEntityCoords(playerPed)

    RequestModel(logModel)
    while not HasModelLoaded(logModel) do
        Wait(100)
    end

    LogProp = CreateObject(GetHashKey(logModel), playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
    SetEntityCollision(LogProp, false, true)
    NetworkRegisterEntityAsNetworked(LogProp)
    SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(LogProp), true)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(LogProp), true)

    AttachEntityToEntity(LogProp, playerPed, GetPedBoneIndex(playerPed, 57005), 0.3, 0.1, 0.1, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

    local animDict = "missfinale_c2mcs_1"
    local anim = "fin_c2_mcs_1_camman"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(100)
    end
    TaskPlayAnim(playerPed, animDict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)

    carryingLog = true
end

RegisterNetEvent('tr-lumberjack:client:loginteract', function()
    local playerPed = PlayerPedId()

    if carryingLog then
        NotifyPlayer(Lang.alreadyTasked2, 'error')
        return
    end

    if HasPlayerGotLog() then
        StartCarryingLog(playerPed)
    else
        if Config.progress == "qbcore" then
            QBCore.Functions.Progressbar('Picking up Log', Lang.pickingLog, Config.progressTime.collectLog * 1000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            }, {
                animDict = "amb@world_human_gardener_plant@male@base",
                anim = "base",
                flags = 16,
            }, {}, {}, function()
                ClearPedTasks(PlayerPedId())
                Wait(7)
                StartCarryingLog(playerPed)
                Wait(7)
                TriggerServerEvent('tr-lumberjack:server:addLog')
            end, function()
                ClearPedTasks(PlayerPedId())
            end)
        elseif Config.progress == "ox" then
            if lib.progressBar({
                duration = Config.progressTime.collectLog * 1000,
                label = Lang.pickingLog,
                useWhileDead = false,
                canCancel = true,
                disable = { move = true }
            }) then
                ClearPedTasks(PlayerPedId())
                Wait(7)
                StartCarryingLog(playerPed)
                Wait(7)
                TriggerServerEvent('tr-lumberjack:server:addLog')
            else
                ClearPedTasks(PlayerPedId())
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(0)

        local playerPed = PlayerPedId()

        if carryingLog then
            if not HasPlayerGotLog() then
                if LogProp and DoesEntityExist(LogProp) then
                    DetachEntity(LogProp, true, true)
                    PlaceObjectOnGroundProperly(LogProp)

                    groundLogProp = LogProp
                    LogProp = nil

                    ClearPedTasks(playerPed)
                    carryingLog = false

                    CreateThread(function()
                        Wait(lumberDespawn)
                        if groundLogProp and DoesEntityExist(groundLogProp) then
                            DeleteObject(groundLogProp)
                            groundLogProp = nil
                            if Config.debug then
                                print(Lang.debug2)
                            end
                        end
                    end)
                end
            end
        else
            if HasPlayerGotLog() then
                if groundLogProp and DoesEntityExist(groundLogProp) then
                    DeleteObject(groundLogProp)
                    groundLogProp = nil
                    if Config.debug then
                        print(Lang.debug1)
                    end
                end
                StartCarryingLog(playerPed)
                if Config.debug then
                    print('here mf')
                end
            end
        end
        Wait(500)
    end
end)

local function getNearbyTrailers(coords, radius)
    local vehicles = {}
    local handle, vehicle = FindFirstVehicle()
    local success

    repeat
        local vehCoords = GetEntityCoords(vehicle)
        if GetDistanceBetweenCoords(coords, vehCoords, true) < radius then
            if GetEntityModel(vehicle) == GetHashKey(Config.deliveryTrailer) then
                table.insert(vehicles, vehicle)
            end
        end
        success, vehicle = FindNextVehicle(handle)
    until not success

    EndFindVehicle(handle)
    return vehicles
end

local function loadLogOntoTrailer(trailer, trailerBone, nextPositionID, playerPed)
    local offset = trailerOffsets[nextPositionID].offset
    AttachEntityToEntity(LogProp, trailer, trailerBone, offset.x, offset.y, offset.z, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
    loadedLogs[nextPositionID] = LogProp

    LogProp = nil
    carryingLog = false
    ClearPedTasks(playerPed)

    NotifyPlayer(Lang.task2, 'success')
    TriggerServerEvent('tr-lumberjack:server:removeLog')
end

local function unloadLogFromTrailer(trailer, playerPed)
    for logID = maxLogs, 1, -1 do
        local logEntity = loadedLogs[logID]
        if logEntity and DoesEntityExist(logEntity) then
            DetachEntity(logEntity, false, false)
            DeleteEntity(logEntity)
            loadedLogs[logID] = nil

            NotifyPlayer(Lang.task3, 'success')
            StartCarryingLog(playerPed)
            TriggerServerEvent('tr-lumberjack:server:addLog')
            return
        end
    end
    NotifyPlayer(Lang.noLog, 'error')
end

RegisterNetEvent('tr-lumberjack:client:loadtrailer', function()
    local playerPed = PlayerPedId()

    if not carryingLog or not LogProp or not DoesEntityExist(LogProp) then
        NotifyPlayer(Lang.notCarrying, 'error')
        return
    end

    local nearbyTrailers = getNearbyTrailers(GetEntityCoords(playerPed), 10.0)
    if #nearbyTrailers == 0 then
        NotifyPlayer(Lang.noTrailer, 'error')
        return
    end

    trailer = nearbyTrailers[1]
    local trailerBone = GetEntityBoneIndexByName(trailer, bumperBone)
    if trailerBone == -1 then
        NotifyPlayer(Lang.noTrailerBone, 'error')
        return
    end

    if #loadedLogs >= maxLogs then
        NotifyPlayer(Lang.trailerFull, 'error')
        Wait(1000)
        TrailerFull = true
        NotifyPlayer(Lang.task4, 'success')
        return
    end

    local nextPositionID = nil
    for _, offsetData in ipairs(trailerOffsets) do
        if not loadedLogs[offsetData.id] then
            nextPositionID = offsetData.id
            break
        end
    end

    if not nextPositionID then
        NotifyPlayer(Lang.noTrailer, 'error')
        return
    end

    if Config.progress == "qbcore" then
        QBCore.Functions.Progressbar('Loading Trailer', Lang.loadingTrailer, Config.progressTime.loadTruck_unload * 1000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true
        }, {}, {}, {}, function()
            loadLogOntoTrailer(trailer, trailerBone, nextPositionID, playerPed)
        end, function()
            NotifyPlayer(Lang.cancelledProgress, 'error')
        end)
    elseif Config.progress == "ox" then
        if lib.progressBar({
            duration = Config.progressTime.loadTruck_unload * 1000,
            label = Lang.loadingTrailer,
            useWhileDead = false,
            canCancel = true,
            disable = { move = true }
        }) then
            loadLogOntoTrailer(trailer, trailerBone, nextPositionID, playerPed)
        else
            NotifyPlayer(Lang.cancelledProgress, 'error')
        end
    end
end)

RegisterNetEvent('tr-lumberjack:client:unloadtrailer', function()
    if not HasPlayerGotLog() then
        local playerPed = PlayerPedId()
        local nearbyTrailers = getNearbyTrailers(GetEntityCoords(playerPed), 10.0)

        if #nearbyTrailers == 0 then
            NotifyPlayer(Lang.noTrailer, 'error')
            return
        end

        if Config.progress == "qbcore" then
            QBCore.Functions.Progressbar('Unloading Trailer', Lang.unloadingTrailer, Config.progressTime.loadTruck_unload * 1000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            }, {}, {}, {}, function()
                trailer = nearbyTrailers[1]
                unloadLogFromTrailer(trailer, playerPed)
            end, function()
                NotifyPlayer(Lang.cancelledProgress, 'error')
            end)
        elseif Config.progress == "ox" then
            if lib.progressBar({
                duration = Config.progressTime.loadTruck_unload * 1000,
                label = Lang.unloadingTrailer,
                useWhileDead = false,
                canCancel = true,
                disable = { move = true }
            }) then
                trailer = nearbyTrailers[1]
                unloadLogFromTrailer(trailer, playerPed)
            else
                NotifyPlayer(Lang.cancelledProgress, 'error')
            end
        end
    else
        NotifyPlayer(Lang.alreadyTasked2, 'error')
    end
end)

-- Outline Function
function EnableLogPropOutline()
    if logPropEntity and DoesEntityExist(logPropEntity) then
        SetEntityDrawOutline(logPropEntity, true)
        SetEntityDrawOutlineColor(outlineColor.r, outlineColor.g, outlineColor.b, outlineColor.a)
    end
end

function DisableLogPropOutline()
    if logPropEntity and DoesEntityExist(logPropEntity) then
        SetEntityDrawOutline(logPropEntity, false)
    end
end

CreateThread(function()
    while true do
        if TaskInProgress then
            local playerCoords = GetEntityCoords(PlayerPedId())
            if not logPropEntity or not DoesEntityExist(logPropEntity) or not IsPlayerNearProp(playerCoords) then
                logPropEntity = GetClosestObjectOfType(playerCoords, highlightDistance, logPropModel, false, false, false)
            end

            if logPropEntity and IsPlayerNearProp(playerCoords) then
                EnableLogPropOutline()
            else
                DisableLogPropOutline()
            end
        else
            DisableLogPropOutline()
            logPropEntity = nil
        end
        Wait(1000)
    end
end)

function IsPlayerNearProp(playerCoords)
    if logPropEntity then
        local propCoords = GetEntityCoords(logPropEntity)
        local distance = #(playerCoords - propCoords)
        return distance <= highlightDistance
    end
    return false
end

-- Selling at the docks
RegisterNetEvent('tr-lumberjack:client:logselling', function()
    if HasPlayerGotLog() and timmyTaskStarted then
        if Config.progress == "qbcore" then
            QBCore.Functions.Progressbar('Selling Log', Lang.sellingLog, Config.progressTime.sellingLog * 1000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            }, {}, {}, {}, function()
                DetachAndDeleteLogProp()
                TriggerServerEvent('tr-lumberjack:server:sellinglog')
            end, function()
                NotifyPlayer(Lang.cancelledProgress, 'error')
            end)
        elseif Config.progress == "ox" then
            if lib.progressBar({
                duration = Config.progressTime.sellingLog * 1000,
                label = Lang.sellingLog,
                useWhileDead = false,
                canCancel = true,
                disable = { move = true }
            }) then
                DetachAndDeleteLogProp()
                TriggerServerEvent('tr-lumberjack:server:sellinglog')
            else
                NotifyPlayer(Lang.cancelledProgress, 'error')
            end
        end
    else
        NotifyPlayer(Lang.sellingError, 'error')
    end
end)

function DetachAndDeleteLogProp()
    local playerPed = PlayerPedId()
    if LogProp and DoesEntityExist(LogProp) then
        if IsEntityAttachedToEntity(playerPed, LogProp) then
            DetachEntity(LogProp, true, true)
        end
        DeleteEntity(LogProp)
        LogProp = nil
    end
end
RegisterNetEvent('tr-lumberjack:client:resetTimmyTask', function()
    timmyTaskStarted = false
end)

-- Function to check if the tree is within the chopped radius and still on cooldown (Do not touch this at all! I warned you)
-- Start of tree chopping events
local function isTreeChopped(treeCoords)
    local currentTime = GetGameTimer()

    for index, treeData in pairs(choppedTrees) do
        local distance = #(vector3(treeData.coords.x, treeData.coords.y, treeData.coords.z) - vector3(treeCoords.x, treeCoords.y, treeCoords.z))
        if distance <= chopRadius then
            if currentTime - treeData.time < cooldownTime then
                if Config.debug then
                    print(json.encode({ currentTime = currentTime, choppedTime = treeData.time }))
                end
                return true
            else
                table.remove(choppedTrees, index)
            end
        end
    end
    return false
end

RegisterNetEvent('tr-lumberjack:client:choptreecheck', function()
    local playerPed = PlayerPedId()
    local treeCoords = GetEntityCoords(playerPed)

    local weaponHash = GetSelectedPedWeapon(playerPed)
    if weaponHash ~= GetHashKey('weapon_battleaxe') then
        NotifyPlayer(Lang.errorNoAxe, 'error')
        return
    end

    if isTreeChopped(treeCoords) then
        NotifyPlayer(Lang.alreadyChopped, 'error')
        return
    end

    local roundedCoords = { x = math.floor(treeCoords.x), y = math.floor(treeCoords.y), z = math.floor(treeCoords.z) }
    table.insert(choppedTrees, { coords = roundedCoords, time = GetGameTimer() })

    local choppingAnimation = {
        dict = "melee@hatchet@streamed_core",
        name = "plyr_rear_takedown_b"
    }

    RequestAnimDict(choppingAnimation.dict)
    while not HasAnimDictLoaded(choppingAnimation.dict) do
        Citizen.Wait(100)
    end

    TaskPlayAnim(playerPed, choppingAnimation.dict, choppingAnimation.name, 8.0, -8.0, -1, 1, 0, false, false, false)

    if Config.progress == "qbcore" then
        QBCore.Functions.Progressbar('chopping_tree', Lang.choppingDownTree, Config.progressTime.chopping * 1000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true
        }, {}, {}, {}, function()
            ClearPedTasks(playerPed)
            TriggerServerEvent('tr-lumberjack:server:choptree')
        end, function()
            ClearPedTasks(playerPed)
            NotifyPlayer(Lang.cancelledProgress, 'error')
        end)

    elseif Config.progress == "ox" then
        if lib.progressBar({
            duration = Config.progressTime.chopping * 1000,
            label = Lang.choppingDownTree,
            useWhileDead = false,
            canCancel = true,
            disable = { move = true }
        }) then
            ClearPedTasks(playerPed)
            TriggerServerEvent('tr-lumberjack:server:choptree')
        else
            ClearPedTasks(playerPed)
            NotifyPlayer(Lang.cancelledProgress, 'error')
        end
    end
end)

RegisterNetEvent('tr-lumberjack:client:craftinginput', function(args)
    local argsNumber = tonumber(args.number)
    local craftingItemName

    if argsNumber == 1 then
        craftingItemName = Lang.craftingPlanks or "Planks"
    elseif argsNumber == 2 then
        craftingItemName = Lang.craftingHandles or "Handles"
    elseif argsNumber == 3 then
        craftingItemName = Lang.craftingFirewood or "Firewood"
    elseif argsNumber == 4 then
        craftingItemName = Lang.craftingToysets or "Toy Sets"
    else
        NotifyPlayer(Lang.invalidCraftingItem, 'error')
        return
    end

    if Config.menu == "qbcore" then
        local dialog = exports['qb-input']:ShowInput({
            header = string.format(Lang.choppedLogAmount, ChoppedLogs),
            submitText = Lang.submit,
            inputs = {
                {
                    text = Lang.menuText,
                    name = "loginput",
                    type = "number",
                    isRequired = true,
                },
            },
        })

        if dialog then
            local logAmount = tonumber(dialog.loginput)
            if logAmount and (logAmount < 0 or logAmount > ChoppedLogs) then
                NotifyPlayer(Lang.invalidNumber, 'error')
                return
            end
            if Config.progress == "qbcore" then
                QBCore.Functions.Progressbar('crafting_progress', craftingItemName, Config.progressTime.crafting * 1000 * logAmount, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true
                }, {}, {}, {}, function()
                    TriggerServerEvent('tr-lumberjack:server:craftinginput', argsNumber, logAmount)
                end, function()
                    NotifyPlayer(Lang.cancelledProgress, 'error')
                end)

            elseif Config.progress == "ox" then
                if lib.progressBar({
                    duration = Config.progressTime.crafting * 1000 * logAmount,
                    label = craftingItemName,
                    useWhileDead = false,
                    canCancel = true,
                    disable = { move = true }
                }) then
                    TriggerServerEvent('tr-lumberjack:server:craftinginput', argsNumber, logAmount)
                else
                    NotifyPlayer(Lang.cancelledProgress, 'error')
                end
            end
        else
            return
        end

    elseif Config.menu == "ox" then
        local input = lib.inputDialog(string.format(Lang.choppedLogAmount, ChoppedLogs), {
            {type = 'number', label = Lang.menuText, icon = 'hashtag'}
        })

        if input then
            local logAmount = tonumber(input[1])
            if logAmount and (logAmount < 0 or logAmount > ChoppedLogs) then
                NotifyPlayer(Lang.invalidNumber, 'error')
                return
            end
            if Config.progress == "qbcore" then
                QBCore.Functions.Progressbar('crafting_progress', craftingItemName, Config.progressTime.crafting * 1000 * logAmount, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true
                }, {}, {}, {}, function()
                    TriggerServerEvent('tr-lumberjack:server:craftinginput', argsNumber, logAmount)
                end, function()
                    NotifyPlayer(Lang.cancelledProgress, 'error')
                end)

            elseif Config.progress == "ox" then
                if lib.progressBar({
                    duration = Config.progressTime.crafting * 1000 * logAmount,
                    label = craftingItemName,
                    useWhileDead = false,
                    canCancel = true,
                    disable = { move = true }
                }) then
                    TriggerServerEvent('tr-lumberjack:server:craftinginput', argsNumber, logAmount)
                else
                    NotifyPlayer(Lang.cancelledProgress, 'error')
                end
            end
        else
            return
        end
    end
end)

-- Shop
RegisterNetEvent('tr-lumberjack:client:contractorshop', function()
    exports.ox_inventory:openInventory("shop", {type = 'contractorshop'})
end)
