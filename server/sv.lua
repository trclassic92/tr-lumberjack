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
        local playerCoords = GetEntityCoords(GetPlayerPed(source))
        local depoCoords = vector3(Config.lumberDepo.x, Config.lumberDepo.y, Config.lumberDepo.z)

        if #(playerCoords - depoCoords) > 10.0 then
            notifyPlayer(source, Lang.tooFarFromDepo, 'error')
            return
        end
        if exports.ox_inventory:AddItem(source, 'cash', Config.returnPrice) then
            notifyPlayer(source, Lang.storedVehicle, 'success')
        else
            notifyPlayer(source, Lang.incorrectVehicle, 'error')
        end
    else
        notifyPlayer(source, Lang.invalidPlayer, 'error')
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
        local playerCoords = GetEntityCoords(GetPlayerPed(source))
        local taskerCoords = vector3(Config.deliveryTasker.x, Config.deliveryTasker.y, Config.deliveryTasker.z)

        if #(playerCoords - taskerCoords) > 10.0 then
            notifyPlayer(source, Lang.tooFarFromTasker, 'error')
            return
        end

        if exports.ox_inventory:Search(source, 'count', 'tr_deliverypaper') > 0 then
            notifyPlayer(source, Lang.alreadyHaveDeliveryPaper, 'error')
            return
        end

        if exports.ox_inventory:AddItem(source, 'tr_deliverypaper', 1) then
            notifyPlayer(source, Lang.timmyDialLog1, 'success')
        else
            notifyPlayer(source, Lang.deliveryPaperFailed, 'error')
        end
    else
        notifyPlayer(source, Lang.invalidPlayer, 'error')
    end
end)


RegisterServerEvent('tr-lumberjack:server:sellinglog', function()
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)

    if Player then
        local playerCoords = GetEntityCoords(GetPlayerPed(source))
        local dropOffCoords = Config.deliverDropOff

        if #(playerCoords - dropOffCoords) > 10.0 then
            notifyPlayer(source, Lang.tooFarFromDropOff, 'error')
            return
        end

        if exports.ox_inventory:Search(source, 'count', 'tr_log') < 1 then
            notifyPlayer(source, Lang.noLogsToSell, 'error')
            return
        end

        local minSell, maxSell = table.unpack(Config.sell.deliveryPerLog)
        local cashReward = math.random(minSell, maxSell)

        if not playerLogSales[source] then
            playerLogSales[source] = 0
        end
        playerLogSales[source] = playerLogSales[source] + 1

        if exports.ox_inventory:RemoveItem(source, 'tr_log', 1) then
            exports.ox_inventory:AddItem(source, 'cash', cashReward)

            if playerLogSales[source] >= Config.maxLogs then
                if exports.ox_inventory:RemoveItem(source, 'tr_deliverypaper', 1) then
                    TriggerClientEvent('tr-lumberjack:client:resetTimmyTask', source)
                end
                playerLogSales[source] = 0
            end
            notifyPlayer(source, string.format(Lang.soldLog, cashReward), 'success')
        else
            notifyPlayer(source, Lang.logRemovalFailed, 'error')
        end
    else
        notifyPlayer(source, Lang.invalidPlayer, 'error')
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
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)

    local craftingBenchCoords = vector3(Config.craftingBench.x, Config.craftingBench.y, Config.craftingBench.z)
    local distance = #(playerCoords - craftingBenchCoords)

    if distance > 5.0 then
        notifyPlayer(source, Lang.tooFarFromCraftingBench, 'error')
        return
    end

    if itemCount < 0 then
        if Config.debug then
            print("Invalid item count:", itemCount)
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
        if Config.debug then
            print("Invalid crafting type.")
        end
        return
    end

    if exports.ox_inventory:CanCarryItem(source, itemToReceive, totalItems) then
        if exports.ox_inventory:RemoveItem(source, 'tr_choppedlog', 1) then
            Wait(7)
            exports.ox_inventory:AddItem(source, itemToReceive, totalItems)
            notifyPlayer(source, string.format(Lang.craftedItems, totalItems, itemToReceive), 'success')
        else
            notifyPlayer(source, Lang.noItemsToCraft, 'error')
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
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)

    local sellingLocation = nil
    if itemType == 'tr_firewood' or itemType == 'tr_woodplank' then
        sellingLocation = vector3(Config.seller1.x, Config.seller1.y, Config.seller1.z)
    elseif itemType == 'tr_toyset' or itemType == 'tr_woodhandles' then
        sellingLocation = vector3(Config.seller2.x, Config.seller2.y, Config.seller2.z)
    else
        notifyPlayer(source, Lang.invalidItem, 'error')
        return
    end

    if #(playerCoords - sellingLocation) > 10 then
        notifyPlayer(source, Lang.tooFarFromSellPoint, 'error')
        return
    end

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