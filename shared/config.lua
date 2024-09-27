-- Configuration settings
Config = Config or {}
Config.debug = false

-- Notification System
Config.notification = "qbcore"  -- Options: qbcore, ox (If you have more this function can be found cl.lua line 21)

-- Progress Bar
Config.progress = "qbcore"  -- Options: qbcore, ox

-- Menu System
Config.menu = "qbcore"  -- Options: qbcore, ox

-- Fuel System
Config.fuel = "cdn-fuel" -- Export for fuel script

-- Blips
Config.useBlips = true  -- true = Enabled, false = Disabled
-- Blips configuration can be found in client/blips.lua

-- ProgressBar Timers
Config.progressTime = {
    collectLog = 1, -- Seconds
    loadTruck_unload = 1,
    sellingLog = 1,
    chopping = 10,
    crafting = 10
}

-- Cool Downs
Config.coolDowns = { -- In minutes
    lumberDespawn = 1,
    chopping = 10,
}

-- Ped Model
Config.lumberModel = 'a_m_m_hasjew_01'
Config.lumberMillModel = 's_m_y_construct_01'
-- Ped models can be found here: https://docs.fivem.net/docs/game-references/ped-models/
-- Crafting Models
Config.craftingTable = GetHashKey("prop_tool_bench02")
-- Find Crafting models here (Make sure they work because most objects and props dont spawn for whatever reason)
-- Website https://forge.plebmasters.de/objects

-- Coordinates
Config.lumberDepo = vector4(1167.59, -1347.38, 33.915, 267.685)
Config.deliverySuperPed = vector4(-606.472, 5311.273, 69.432, 255.341)
Config.deliveryTasker = vector4(-841.132, 5401.732, 33.615, 305.278)
Config.craftingBench = vector4(-556.287, 5326.222, 72.6, 160.741) --This is also the same as the Target.lua
Config.deliverDropOff = vector3(1239.427, -3149.191, 5.528) -- Drop Off Location for delivery task
Config.seller1 = vector4(906.558, -1514.62, 29.413, 178.657) -- First Sale point (Firewood and Planks)
Config.seller2 = vector4(925.812, -1560.319, 29.74, 95.023) -- Second Sale point (Toys and handles)
-- Camera Coords for NPC Diallog
Config.deliverySupervisorCam = vector4(-605.289, 5311.128, 71.00, 83.641)
Config.deliveryTaskerCam = vector4(-840.571, 5402.142, 35.315, 125.737)

-- Depo Area
Config.deliveryTruck = "phantom3" -- Truck
Config.deliveryTrailer = "trflat" -- Trailer
Config.workVan = "bison" -- Work truck
Config.WorkVanTrailer = "trailersmall" -- Bison Trailer
Config.workVanPrice = 100 -- cash
Config.returnPrice = 50 -- cash
Config.deliverySpawn = vector4(1158.62, -1330.271, 34.736, 264.758) -- Spawn point for above
Config.lumberVan = vector4(1164.155, -1317.344, 34.743, 173.472) -- Workvan Spawn

-- Depo Shop Items
Config.depoItems = {
	{ name = "weapon_battleaxe", price = 100 },
	{ name = "water", price = 100 },
	{ name = "burger", price = 100 },
}

-- Transition time in seconds
Config.camTransition = 2 -- 2 seconds

-- Outline Color / distance
Config.outLine = { r = 0, g = 255, b = 0, a = 255 }
Config.outLineDistance = 20.0

-- Delivery Truck Config
Config.trailerBone = "bumper_r"
Config.maxLogs = 9 -- Log limit on the trailer
Config.logTrailerOffsets = {
    {id = 1, offset = {x = 0.0, y = 6.0, z = 0.6}},
    {id = 2, offset = {x = -1.0, y = 6.0, z = 0.6}},
    {id = 3, offset = {x = 0.0, y = 9.0, z = 0.6}},
    {id = 4, offset = {x = -1.0, y = 9.0, z = 0.6}},
    {id = 5, offset = {x = 0.0, y = 3.0, z = 0.6}},
    {id = 6, offset = {x = -1.0, y = 3.0, z = 0.6}},
    {id = 7, offset = {x = -0.5, y = 6.0, z = 0.8}},
    {id = 8, offset = {x = -0.5, y = 3.0, z = 0.8}},
    {id = 9, offset = {x = -0.5, y = 9.0, z = 0.8}}
}

-- Crafting Amount (The amount you get back after crafting) IF YOU CHANGE THIS CHANGE THE LANG TXT SO NO ONE CRIES
Config.receive = {
    tr_woodplank = 4,         -- 1 = 4
    tr_woodhandles = 2,        -- 1 = 2
    tr_firewood = 6,       -- 1 = 6
    tr_toyset = 1,        -- 1 = 1
}

-- Selling Prices
Config.sell = {
    deliveryPerLog = {65, 80},
    tr_woodplank = {100, 120},
    tr_firewood  = {90, 110},
    tr_woodhandles  = {50, 65},
    tr_toyset  = {95, 100}
}
