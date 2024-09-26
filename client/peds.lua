local TRClassic = Config.lumberDepo
local ClassicTR = Config.deliveryTasker
local Swiper = Config.craftingBench
local classicSupervisorCoords = Config.deliverySuperPed
local lumberModelHash = GetHashKey(Config.lumberModel)
local constructionWorkerModel = GetHashKey(Config.lumberMillModel)
local bingBong = Config.seller1
local fuckYourLife = Config.seller2
local benchModelHash = Config.craftingTable
local benchProp = nil

local function LoadModel(modelHash)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(1)
    end
end

local function CreateLumberPed(coords, isConstructionWorker)
    local pedModel = isConstructionWorker and constructionWorkerModel or lumberModelHash
    LoadModel(pedModel)

    local ped = CreatePed(1, pedModel, coords, false, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    return ped
end

local function CreateBenchProp(coords)
    local modelHash = benchModelHash

if not HasModelLoaded(modelHash) then
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(1)
    end
end

local benchProp = CreateObject(modelHash, coords.x, coords.y, coords.z, false)
    SetEntityHeading(benchProp, coords.w)
    FreezeEntityPosition(benchProp, true)
    return benchProp
end

local function DeleteBenchProp()
    if benchProp and DoesEntityExist(benchProp) then
        DeleteObject(benchProp)
        benchProp = nil
    end
end

CreateThread(function()
    Wait(1000)
    local lumberjack1 = CreateLumberPed(TRClassic, false)
    local constructionWorker1 = CreateLumberPed(classicSupervisorCoords, true)
    local constructionWorker2 = CreateLumberPed(ClassicTR, true)
    local lumberjack2 = CreateLumberPed(bingBong, false)
    local lumberjack3 = CreateLumberPed(fuckYourLife, false)

    local benchCoords = Swiper
    LoadModel(benchModelHash)

    if HasModelLoaded(benchModelHash) then
        CreateBenchProp(benchCoords)
    else return end
end)



AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        DeleteBenchProp()
    end
end)
