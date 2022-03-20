local QBCore = exports['qb-core']:GetCoreObject()
local ClassicMan = LumberDepo.coords
local LumberTR = LumberProcessor.coords
local sellClassic = LumberSeller.coords

CreateThread(function()
    RequestModel( GetHashKey( "s_m_y_construct_01" ) )
    while ( not HasModelLoaded( GetHashKey( "s_m_y_construct_01" ) ) ) do
        Wait(1)
    end
    lumberjack1 = CreatePed(1, 0xD7DA9E99, ClassicMan, false, true)
    lumberjack2 = CreatePed(1, 0xD7DA9E99, LumberTR, false, true)
    lumberjack3 = CreatePed(1, 0xD7DA9E99, sellClassic, false, true)
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