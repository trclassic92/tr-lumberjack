local QBCore = exports['qb-core']:GetCoreObject()
local playerLogSales = {}

local function notifyPlayer(source, message, type)
    if Config.notification == "qbcore" then
        TriggerClientEvent('QBCore:Notify', source, message, type)
    elseif Config.notification == "ox" then
        TriggerClientEvent('ox_lib:notify', source, { type = type, description = message })
    end
end

RegisterServerEvent('tr-lumberjack:server:workvan', function(workVanPrice)
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)

    if Player and exports.ox_inventory:RemoveItem(source, 'cash', workVanPrice) then
        notifyPlayer(source, string.format(Lang.paidWorkVan, workVanPrice), 'success')
    end
end)

RegisterServerEvent('tr-lumberjack:server:returnworkvan', function()
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)

    if Player then
        exports.ox_inventory:AddItem(source, 'cash', Config.returnPrice)
    end
end)

RegisterServerEvent('tr-lumberjack:server:addLog', function()
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)

    local logCount = Player.Functions.GetItemByName('tr_log')

    if logCount then
        notifyPlayer(source, Lang.carryingItem, 'error')
        return
    end

    exports.ox_inventory:AddItem(source, 'tr_log', 1)
    notifyPlayer(source, Lang.addedLog, 'success')
end)

RegisterServerEvent('tr-lumberjack:server:removeLog', function()
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)

    if Player then
        exports.ox_inventory:RemoveItem(source, 'tr_log', 1)
    end
end)

RegisterServerEvent('tr-lumberjack:server:deliverypaper', function()
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)

    if Player then
        exports.ox_inventory:AddItem(source, 'tr_deliverypaper', 1)
    end
end)

RegisterServerEvent('tr-lumberjack:server:sellinglog', function()
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)

    if Player then
        local minSell, maxSell = table.unpack(Config.sell.deliveryPerLog)
        local cashReward = math.random(minSell, maxSell)

        if not playerLogSales[source] then
            playerLogSales[source] = 0
        end
        playerLogSales[source] = playerLogSales[source] + 1

        exports.ox_inventory:RemoveItem(source, 'tr_log', 1)
        exports.ox_inventory:AddItem(source, 'cash', cashReward)

        if playerLogSales[source] >= Config.maxLogs then
            if exports.ox_inventory:RemoveItem(source, 'tr_deliverypaper', 1) then
                TriggerClientEvent('tr-lumberjack:client:resetTimmyTask', source)
            end
            playerLogSales[source] = 0
        end

        notifyPlayer(source, string.format(Lang.soldLog, cashReward), 'success')
    end
end)

RegisterServerEvent('tr-lumberjack:server:choptree', function()
    local source = source

    -- Because you are going to be able to carry till your inventory is full (Don't ask why because Im stupid alright)
    if exports.ox_inventory:CanCarryItem(source, 'tr_choppedlog', 1) then
        if exports.ox_inventory:AddItem(source, 'tr_choppedlog', 1) then
            notifyPlayer(source, Lang.chopAdded, 'success')
        end
    else
        notifyPlayer(source, Lang.carryingWeight, 'error')
    end
end)

RegisterServerEvent('tr-lumberjack:server:craftinginput', function(argsNumber, logAmount)
    local source = source
    local slot = tonumber(argsNumber)
    local itemCount = tonumber(logAmount)

    if itemCount < 0 then
        if Config.debug then
            print(itemCount)
            print("Invalid item count.")
        end
        return
    end

    local itemToReceive
    local totalItems

    if slot == 1 then
        itemToReceive = 'tr_woodplank'
        totalItems = itemCount * Config.receive.tr_woodplank
    elseif slot == 2 then
        itemToReceive = 'tr_woodhandles'
        totalItems = itemCount * Config.receive.tr_woodhandles
    elseif slot == 3 then
        itemToReceive = 'tr_firewood'
        totalItems = itemCount * Config.receive.tr_firewood
    elseif slot == 4 then
        itemToReceive = 'tr_toyset'
        totalItems = itemCount * Config.receive.tr_toyset
    else
        print("Invalid crafting type.")
        return
    end

    if exports.ox_inventory:CanCarryItem(source, itemToReceive, totalItems) then
        if exports.ox_inventory:RemoveItem(source, 'tr_choppedlog', 1) then
            Wait(7)
            exports.ox_inventroy:AddItem(source, itemToReceive, totalItems)
        end
    else
        notifyPlayer(source, Lang.carryingWeight, 'error')
    end
    if Config.debug then
        print(string.format("Player %d crafted %d %s.", source, totalItems, itemToReceive))
    end
end)

RegisterServerEvent('tr-lumberjack:server:sellitem', function(args)
    local source = source
    local itemCount = tonumber(args.number)
    local itemType = args.itemType

    if itemCount > 0 then
        local sellPriceRange = Config.sell[itemType]
        if sellPriceRange then
            local sellPrice = math.random(sellPriceRange[1], sellPriceRange[2]) * itemCount
            if exports.ox_inventory:AddItem(source, 'cash', sellPrice) and exports.ox_inventory:RemoveItem(source, itemType, itemCount) then
                notifyPlayer(source, string.format(Lang.soldItems, itemCount, sellPrice), 'success')
            end
        else
            notifyPlayer(source, Lang.invalidItem, 'error')
        end
    else
        notifyPlayer(source, Lang.noItemsToSell, 'error')
    end
end)


AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
        exports.ox_inventory:RegisterShop("contractorshop", {
            name = Lang.depoShop,
            inventory = Config.depoItems
        })
    end
end)