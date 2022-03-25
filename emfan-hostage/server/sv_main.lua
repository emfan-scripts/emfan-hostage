if Config.Framework == "QBCore" then
    QBCore = exports['qb-core']:GetCoreObject()
    
    QBCore.Functions.CreateUseableItem(Config.ItemName, function(source, item)
        local src = source
        
        TriggerClientEvent('emfan-hostage:client:UseItem', src)
    end)
elseif Config.Framework == "ESX" then 
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    ESX.RegisterUsableItem(Config.ItemName, function(source, item)
        local src = source
        TriggerClientEvent('emfan-hostage:client:UseItem', src)
    end)
else
    print("The Framework '", Config.Framework, "' is not supported, please change in config.lua")
end

RegisterServerEvent('emfan-hostage:server:BagPlayerSync')
AddEventHandler('emfan-hostage:server:BagPlayerSync', function(closestPlayer)
    local src = source
    if Config.Framework == "QBCore" then
        local xPlayer = QBCore.Functions.GetPlayer(src)
        xPlayer.Functions.RemoveItem(Config.ItemName, 1)
    elseif Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.addInventoryItem(Config.ItemName, 1)
    end
    TriggerClientEvent('emfan-hostage:client:BagPlayer', closestPlayer)
end)

RegisterServerEvent('emfan-hostage:server:SyncRemove')
AddEventHandler('emfan-hostage:server:SyncRemove', function(KidnappedPlayer, KidnappedCoords, BagHead)
    
    TriggerClientEvent('emfan-hostage:client:SyncRemove', -1, KidnappedPlayer, KidnappedCoords, BagHead)
end)

RegisterServerEvent('emfan-hostage:server:FinishRemove')
AddEventHandler('emfan-hostage:server:FinishRemove', function(BagHead)
    local src = source
    if Config.Framework == "QBCore" then
        local xPlayer = QBCore.Functions.GetPlayer(src)
        xPlayer.Functions.AddItem(Config.ItemName, 1)
    elseif Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.removeInventoryItem(Config.ItemName, 1)
    end
    TriggerClientEvent('emfan-hostage:client:FinishRemove', -1, BagHead)
end)


RegisterServerEvent('undragTarget')
AddEventHandler('undragTarget', function(playerId)
	TriggerClientEvent("undragPlayer", playerId, source)
end)

RegisterServerEvent('dragTarget')
AddEventHandler('dragTarget', function(playerId)
	TriggerClientEvent("dragPlayer", playerId, source)
end)

