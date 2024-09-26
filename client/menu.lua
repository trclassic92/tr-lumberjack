local QBCore = exports['qb-core']:GetCoreObject()
-- QBCore Menu Configuration
if Config.menu == "qbcore" then
    RegisterNetEvent('tr-lumberjack:client:depo', function()
        exports['qb-menu']:openMenu({
            {
                header = Lang.depo1,
                icon = 'fa-solid fa-truck',
                params = {
                    event = 'tr-lumberjack:client:deliverytruck',
                }
            },
            {
                header = string.format(Lang.depo2, Config.workVanPrice),
                icon = 'fa-solid fa-car',
                params = {
                    event = 'tr-lumberjack:client:workvan',
                }
            },
            {
                header = Lang.depo3,
                icon = 'fa-solid fa-shop',
                params = {
                    event = 'tr-lumberjack:client:contractorshop',
                }
            },
            {
                header = Lang.depo4,
                icon = 'fa-solid fa-car',
                params = {
                    event = 'tr-lumberjack:client:returnworkvan',
                }
            },
        })
    end)
    RegisterNetEvent('tr-lumberjack:client:deliverysuper', function()
        if IsDeliveryTruckSelected then
            exports['qb-menu']:openMenu({
                {
                    header = Lang.delivery1,
                    icon = 'fa-solid fa-trailer',
                    params = {
                        event = 'tr-lumberjack:client:starttask',
                    }
                }
            })
        else
            NotifyPlayer(Lang.selectDeliveryTruck, 'error')
        end
    end)
    RegisterNetEvent('tr-lumberjack:client:trailerInteract', function()
        exports['qb-menu']:openMenu({
            {
                header = Lang.delivery2,
                icon = 'fa-solid fa-trailer',
                params = {
                    event = 'tr-lumberjack:client:loadtrailer',
                }
            },
            {
                header = Lang.delivery3,
                icon = 'fa-solid fa-truck',
                params = {
                    event = 'tr-lumberjack:client:unloadtrailer',
                }
            }
        })
    end)
    RegisterNetEvent('tr-lumberjack:client:crafting', function()
        if HasPlayerGotChoppedLogs() then
            exports['qb-menu']:openMenu({
                {
                    header = string.format(Lang.craftingMenu, ChoppedLogs),
                    icon = 'fa-solid fa-tree',
                },
                {
                    header = Lang.craftPlanks,
                    txt = Lang.craftPlanksAmount,
                    icon = 'fa-solid fa-gear',
                    params = {
                        event = 'tr-lumberjack:client:craftinginput',
                        args = {
                            number = 1,
                        }
                    }
                },
                {
                    header = Lang.craftHandles,
                    txt = Lang.craftHandlesAmount,
                    icon = 'fa-solid fa-gear',
                    params = {
                        event = 'tr-lumberjack:client:craftinginput',
                        args = {
                            number = 2,
                        }
                    }
                },
                {
                    header = Lang.craftFirewood,
                    txt = Lang.craftFirewoodAmount,
                    icon = 'fa-solid fa-gear',
                    params = {
                        event = 'tr-lumberjack:client:craftinginput',
                        args = {
                            number = 3,
                        }
                    }
                },
                {
                    header = Lang.craftWoodenToySets,
                    txt = Lang.craftWoodenToySetsAmount,
                    icon = 'fa-solid fa-gear',
                    params = {
                        event = 'tr-lumberjack:client:craftinginput',
                        args = {
                            number = 4,
                        }
                    }
                }
            })
        end
    end)
    local function openSellMenu(itemList, eventPrefix)
        local menuItems = {}

        for _, item in pairs(itemList) do
            local itemCount = exports.ox_inventory:Search('count', item.name)
            local itemAvailable = itemCount > 0
            table.insert(menuItems, {
                header = string.format(item.header, itemCount),
                icon = 'fa-solid fa-gear',
                params = {
                    event = eventPrefix .. ':server:sellitem',
                    isServer = true,
                    args = {
                        number = itemCount,
                        itemType = item.name
                    }
                },
                disabled = not itemAvailable
            })
        end

        exports['qb-menu']:openMenu(menuItems)
    end
    RegisterNetEvent('tr-lumberjack:client:sell1', function()
        openSellMenu({
            {name = 'tr_woodplank', header = Lang.sellPlanks},
            {name = 'tr_firewood', header = Lang.sellFirewood}
        }, 'tr-lumberjack')
    end)

    RegisterNetEvent('tr-lumberjack:client:sell2', function()
        openSellMenu({
            {name = 'tr_woodhandles', header = Lang.sellHandles},
            {name = 'tr_toyset', header = Lang.sellToy}
        }, 'tr-lumberjack')
    end)


-- Ox Menu Configuration
elseif Config.menu == "ox" then
    RegisterNetEvent('tr-lumberjack:client:depo', function()
        lib.registerContext({
            id = 'lumberjack_depo',
            title = Lang.interact1,
            options = {
                {
                    title = Lang.depo1,
                    event = 'tr-lumberjack:client:deliverytruck',
                },
                {
                    title = string.format(Lang.depo2, Config.workVanPrice),
                    event = 'tr-lumberjack:client:workvan',
                },
                {
                    title = Lang.depo3,
                    event = 'tr-lumberjack:client:contractorshop',
                },
            }
        })
        lib.showContext('lumberjack_depo')
    end)
    RegisterNetEvent('tr-lumberjack:client:deliverysuper', function()
        if IsDeliveryTruckSelected then
            lib.registerContext({
                id = 'lumberjack_super',
                title = Lang.interact2,
                options = {
                    {
                        title = Lang.delivery1,
                        event = 'tr-lumberjack:client:starttask',
                    },
                }
            })
            lib.showContext('lumberjack_super')
        else
            NotifyPlayer(Lang.selectDeliveryTruck, 'error')
        end
    end)
    RegisterNetEvent('tr-lumberjack:client:trailerInteract', function()
        lib.registerContext({
            id = 'lumber_trailer',
            title = Lang.interact4,
            options = {
                {
                    title = Lang.delivery2,
                    event = 'tr-lumberjack:client:loadtrailer',
                },
                {
                    title = Lang.delivery3,
                    event = 'tr-lumberjack:client:unloadtrailer',
                },
            }
        })
        lib.showContext('lumber_trailer')
    end)
    RegisterNetEvent('tr-lumberjack:client:crafting', function()
        if HasPlayerGotChoppedLogs() then
            lib.registerContext({
                id = 'lumberjack_crafting',
                title = string.format(Lang.craftingMenu, ChoppedLogs),
                options = {
                    {
                        title = Lang.craftPlanks,
                        description = Lang.craftPlanksAmount,
                        event = 'tr-lumberjack:client:craftinginput',
                        args = {
                            number = 1,
                        }
                    },
                    {
                        title = Lang.craftHandles,
                        description = Lang.craftHandlesAmount,
                        event = 'tr-lumberjack:client:craftinginput',
                        args = {
                            number = 2,
                        }
                    },
                    {
                        title = Lang.craftFirewood,
                        description = Lang.craftFirewoodAmount,
                        event = 'tr-lumberjack:client:craftinginput',
                        args = {
                            number = 3,
                        }
                    },
                    {
                        title = Lang.craftWoodenToySets,
                        description = Lang.craftWoodenToySetsAmount,
                        event = 'tr-lumberjack:client:craftinginput',
                        args = {
                            number = 4,
                        }
                    },
                }
            })
            lib.showContext('lumberjack_crafting')
        end
    end)
    local function openSellMenu(itemList, eventPrefix)
        local menuItems = {}

        for _, item in pairs(itemList) do
            local itemCount = exports.ox_inventory:Search('count', item.name)
            local itemAvailable = itemCount > 0
            table.insert(menuItems, {
                title = string.format(item.header, itemCount), -- Title with item count
                serverEvent = eventPrefix .. ':server:sellitem',
                args = {
                    number = itemCount,
                    itemType = item.name
                },
                disabled = not itemAvailable -- Disable if no items available
            })
        end
        lib.registerContext({
            id = 'sell_menu',
            title = Lang.interact7,
            options = menuItems
        })

        lib.showContext('sell_menu')
    end
    RegisterNetEvent('tr-lumberjack:client:sell1', function()
        openSellMenu({
            {name = 'tr_woodplank', header = Lang.sellPlanks},
            {name = 'tr_firewood', header = Lang.sellFirewood}
        }, 'tr-lumberjack')
    end)
    RegisterNetEvent('tr-lumberjack:client:sell2', function()
        openSellMenu({
            {name = 'tr_woodhandles', header = Lang.sellHandles},
            {name = 'tr_toyset', header = Lang.sellToy}
        }, 'tr-lumberjack')
    end)
end
