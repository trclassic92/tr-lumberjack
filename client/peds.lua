local ClassicMan = Config.Blips.LumberDepo.coords
local LumberTR = Config.Blips.LumberProcessor.coords
local sellClassic = Config.Blips.LumberSeller.coords
local ClassicPed = LumberJob.LumberModel
local ClassicHash = LumberJob.LumberHash

CreateThread(function()
    RequestModel(ClassicPed)
    while ( not HasModelLoaded(ClassicPed ) ) do
        Wait(1)
    end
    lumberjack1 = CreatePed(1, ClassicPed, ClassicMan, false, true)
    lumberjack2 = CreatePed(1, ClassicPed, LumberTR, false, true)
    lumberjack3 = CreatePed(1, ClassicPed, sellClassic, false, true)
    SetEntityInvincible(lumberjack1, true)
    SetBlockingOfNonTemporaryEvents(lumberjack1, true)
    FreezeEntityPosition(lumberjack1, true)
    SetEntityInvincible(lumberjack2, true)
    SetBlockingOfNonTemporaryEvents(lumberjack2, true)
    FreezeEntityPosition(lumberjack2, true)
    SetEntityInvincible(lumberjack3, true)
    SetBlockingOfNonTemporaryEvents(lumberjack3, true)
    FreezeEntityPosition(lumberjack3, true)
end)