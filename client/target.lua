local oxTarget = exports['ox_target']

local boxZones = {
    {
        -- Lumberjack Depot Zone 1
        coords = vector3(1167.59, -1347.38, 33.915),
        length = 2,
        width = 2,
        heading = 267.685,
        name = 'zone1',
        label = Lang.interact1,
        icon = 'fa-solid fa-box',
        event = 'tr-lumberjack:client:depo'
    },
    {
        -- Lumbermill Supervisor for Delivery Truck
        coords = vector3(-606.472, 5311.273, 69.432),
        length = 2,
        width = 2,
        heading = 180.0,
        name = 'zone2',
        label = Lang.interact2,
        icon = 'fa-solid fa-cogs',
        event = 'tr-lumberjack:client:deliverysuper'
    },
    {
        -- Delivery Tasker
        coords = vector3(-841.132, 5401.732, 33.615),
        length = 2,
        width = 2,
        heading = 20.0,
        name = 'zone3',
        label = Lang.interact3,
        icon = 'fa-solid fa-cogs',
        event = 'tr-lumberjack:client:timmytask'
    },
    {
        -- Delivery Dropoff
        coords = vector3(1239.427, -3149.191, 5.528),
        length = 5,
        width = 5,
        heading = 20.0,
        name = 'zone4',
        label = Lang.interact5,
        icon = 'fa-solid fa-cogs',
        event = 'tr-lumberjack:client:logselling'
    },
    {
        --Log Crafting Menu Location
        coords = vector3(-556.287, 5326.222, 72.6),
        length = 2,
        width = 2,
        heading = 80,
        name = 'zone5',
        label = Lang.interact6,
        icon = 'fa-solid fa-hand',
        event = 'tr-lumberjack:client:crafting'
    },
    {
        --Seller 1
        coords = vector3(906.558, -1514.62, 29.413),
        length = 2,
        width = 2,
        heading = 80,
        name = 'zone5',
        label = Lang.interact7,
        icon = 'fa-solid fa-hand',
        event = 'tr-lumberjack:client:sell1'
    },
    {
        --Seller 2
        coords = vector3(925.812, -1560.319, 29.74),
        length = 2,
        width = 2,
        heading = 80,
        name = 'zone5',
        label = Lang.interact7,
        icon = 'fa-solid fa-hand',
        event = 'tr-lumberjack:client:sell2'
    }
}

local logProps = {
    'prop_logpile_03',
}

local treeZones = {
    { coords = vector3(-456.6101, 5408.726, 78.69884), length = 2, width = 2, heading = 0.0, name = 'tree1', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
    { coords = vector3(-457.2242, 5398.11, 80.54485), length = 2, width = 2, heading = 0.0, name = 'tree2', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
    { coords = vector3(-447.163, 5396.568, 80.69884), length = 2, width = 2, heading = 0.0, name = 'tree3', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
    { coords = vector3(-492.041, 5395.633, 80.48617), length = 2, width = 2, heading = 0.0, name = 'tree4', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
    { coords = vector3(-500.736, 5401.574, 75.01296), length = 2, width = 2, heading = 0.0, name = 'tree5', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
    { coords = vector3(-510.5032, 5389.506, 72.95892), length = 2, width = 2, heading = 0.0, name = 'tree6', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
    { coords = vector3(-504.5997, 5391.875, 75.36236), length = 2, width = 2, heading = 0.0, name = 'tree7', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
    { coords = vector3(-558.7664, 5419.209, 62.34554), length = 2, width = 2, heading = 0.0, name = 'tree8', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
    { coords = vector3(-561.658, 5420.319, 62.52522), length = 2, width = 2, heading = 0.0, name = 'tree9', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
    { coords = vector3(-476.1692, 5468.564, 86.10078), length = 2, width = 2, heading = 0.0, name = 'tree10', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
    { coords = vector3(-419.854, 5437.376, 76.01779), length = 2, width = 2, heading = 0.0, name = 'tree11', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
    { coords = vector3(-422.3033, 5447.007, 75.73431), length = 2, width = 2, heading = 0.0, name = 'tree12', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
    { coords = vector3(-421.3751, 5454.29, 78.03955), length = 2, width = 2, heading = 0.0, name = 'tree13', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
    { coords = vector3(-578.8257, 5427.048, 58.92018), length = 2, width = 2, heading = 0.0, name = 'tree14', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
    { coords = vector3(-586.3552, 5447.37, 60.59866), length = 2, width = 2, heading = 0.0, name = 'tree15', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
    { coords = vector3(-595.0001, 5451.043, 59.29848), length = 2, width = 2, heading = 0.0, name = 'tree16', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
    { coords = vector3(-591.8429, 5448.774, 60.37492), length = 2, width = 2, heading = 0.0, name = 'tree17', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
    { coords = vector3(-615.4167, 5432.851, 53.75421), length = 2, width = 2, heading = 0.0, name = 'tree18', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
    { coords = vector3(-616.3025, 5424.165, 48.93402), length = 2, width = 2, heading = 0.0, name = 'tree19', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
    { coords = vector3(-620.4484, 5428.12, 51.35571), length = 2, width = 2, heading = 0.0, name = 'tree20', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
    { coords = vector3(-600.2048, 5397.276, 53.69012), length = 2, width = 2, heading = 0.0, name = 'tree21', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
    { coords = vector3(-614.0487, 5399.306, 50.0063), length = 2, width = 2, heading = 0.0, name = 'tree22', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
    { coords = vector3(-616.1387, 5403.191, 48.84934), length = 2, width = 2, heading = 0.0, name = 'tree23', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
    { coords = vector3(-655.0473, 5424.245, 45.85096), length = 2, width = 2, heading = 0.0, name = 'tree24', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
    { coords = vector3(-661.5078, 5425.615, 45.43542), length = 2, width = 2, heading = 0.0, name = 'tree25', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
    { coords = vector3(-511.442, 5449.702, 75.19167), length = 2, width = 2, heading = 0.0, name = 'tree26', label = Lang.chopTree, icon = 'fa-solid fa-tree', event = 'tr-lumberjack:client:choptreecheck' },
}

CreateThread(function()
    for _, zone in ipairs(boxZones) do
        oxTarget:addBoxZone({
            coords = zone.coords,
            length = zone.length,
            width = zone.width,
            heading = zone.heading,
            debug = Config.debug,
            options = {
                {
                    name = zone.name,
                    event = zone.event,
                    icon = zone.icon,
                    label = zone.label,
                    canInteract = function()
                        return true
                    end
                }
            }
        })
    end

    for _, prop in ipairs(logProps) do
        oxTarget:addModel(prop, {
            {
                name = 'logProp',
                event = 'tr-lumberjack:client:loginteract',
                icon = 'fa-solid fa-tree',
                label = Lang.task1,
                canInteract = function()
                    return TaskInProgress == true
                end
            }
        })
    end
    for _, zone in ipairs(treeZones) do
        oxTarget:addBoxZone({
            coords = zone.coords,
            length = zone.length,
            width = zone.width,
            heading = zone.heading,
            debug = Config.debug,
            options = {
                {
                    name = zone.name,
                    event = zone.event,
                    icon = zone.icon,
                    label = zone.label,
                }
            }
        })
    end

    oxTarget:addModel(Config.deliveryTrailer, {
        {
            name = 'trailerInteraction',
            event = 'tr-lumberjack:client:trailerInteract',
            icon = 'fa-solid fa-trailer',
            label = Lang.interact4,
            distance = 10,
            bones = Config.trailerBone,
            canInteract = function(entity)
                return TaskInProgress == true
            end
        }
    })
end)