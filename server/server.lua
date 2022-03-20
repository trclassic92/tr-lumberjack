local QBCore = exports['qb-core']:GetCoreObject()
local Chopped = false

RegisterNetEvent('tr-lumberjack:sellItems', function()
    local src = source
    local price = 0
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then
        for k, v in pairs(Player.PlayerData.items) do
            if Player.PlayerData.items[k] ~= nil then
                if Config.Sell[Player.PlayerData.items[k].name] ~= nil then
                    price = price + (Config.Sell[Player.PlayerData.items[k].name].price * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Player.PlayerData.items[k].name], "remove")
                end
            end
        end
        Player.Functions.AddMoney("cash", price)
        TriggerClientEvent('QBCore:Notify', src, Config.Alerts["successfully_sold"])
    else 
		TriggerClientEvent('QBCore:Notify', src, Config.Alerts["error_sold"])
	end
end)

RegisterNetEvent('tr-lumberjack:BuyAxe', function()
    local source = source
    local Player = QBCore.Functions.GetPlayer(tonumber(source))
    local TRAxeClassicPrice = LumberJob.AxePrice
    local axe = Player.Functions.GetItemByName('weapon_battleaxe')
    if not axe then
        Player.Functions.AddItem('weapon_battleaxe', 1)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['weapon_battleaxe'], "add")
        Player.Functions.RemoveMoney("cash", TRAxeClassicPrice)
        TriggerClientEvent('QBCore:Notify', source, Config.Alerts["axe_bought"])
    elseif axe then
        TriggerClientEvent('QBCore:Notify', source, Config.Alerts["axe_check"])
    end
end)

QBCore.Functions.CreateCallback('tr-lumberjack:axe', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player ~= nil then
        if Player.Functions.GetItemByName("weapon_battleaxe") ~= nil then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterNetEvent('tr-lumberjack:setLumberStage', function(stage, state, k)
    Config.TreeLocations[k][stage] = state
    TriggerClientEvent('tr-lumberjack:getLumberStage', -1, stage, state, k)
end)

RegisterNetEvent('tr-lumberjack:setChoppedTimer', function()
    if not Chopped then
        Chopped = true
        CreateThread(function()
            Wait(Config.Timeout)
            for k, v in pairs(Config.TreeLocations) do
                Config.TreeLocations[k]["isChopped"] = false
                TriggerClientEvent('tr-lumberjack:getLumberStage', -1, 'isChopped', false, k)
            end
            Chopped = false
        end)
    end
end)

RegisterServerEvent('tr-lumberjack:recivelumber', function()
    local source = source
    local Player = QBCore.Functions.GetPlayer(tonumber(source))
    local lumber = LumberJob.LumberAmount
    local bark = LumberJob.TreeBark
    Player.Functions.AddItem('tree_lumber', lumber)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['tree_lumber'], "add")
    Player.Functions.AddItem('tree_bark', bark)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['tree_bark'], "add")
end)

QBCore.Functions.CreateCallback('tr-lumberjack:lumber', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player ~= nil then
        if Player.Functions.GetItemByName("tree_lumber") ~= nil then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterServerEvent('tr-lumberjack:lumberprocessed', function()
    local source = source
    local Player = QBCore.Functions.GetPlayer(tonumber(source))
    local lumber = Player.Functions.GetItemByName('tree_lumber')
    if not lumber then 
        TriggerClientEvent('QBCore:Notify', source, Config.Alerts['error_lumber'])
        return false
    end

    local amount = lumber.amount
    if amount >= 1 then
        amount = LumberJob.TradeAmount
    else
      return false
    end
    
    if not Player.Functions.RemoveItem('tree_lumber', amount) then 
        TriggerClientEvent('QBCore:Notify', source, Config.Alerts['itemamount'])
        return false 
    end

    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['tree_lumber'], "remove")
    TriggerClientEvent('QBCore:Notify', source, Config.Alerts['lumber_processed'])
    local amount = LumberJob.TradeReceived
    Wait(750)
    Player.Functions.AddItem('wood_plank', amount)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['wood_plank'], "add")
end)