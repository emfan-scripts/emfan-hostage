local IsBagged = false

if Config.Framework == "QBCore" then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == "ESX" then 
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
else
    print("The Framework '", Config.Framework, "' is not support, please change in config.lua")
end

RegisterNetEvent('emfan-hostage:client:UseItem')
AddEventHandler('emfan-hostage:client:UseItem', function()
    IsBagged = false
    local players = GetActivePlayers()
    local closestDistance
    local closestPlayer 
    local xPlayer = PlayerPedId()
    local xPlayerCoords = GetEntityCoords(xPlayer)
    for k, playerId in ipairs(players) do
        local targetPed = GetPlayerPed(playerId)
        if targetPed ~= xPlayer then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(targetCoords-xPlayerCoords)
            closestPlayer = playerId
            closestDistance = distance
            local limiter = 0
            if distance < 3.0 and limiter == 0 then
                limiter = 1
                local animModel = "oddjobs@assassinate@vice@hooker"
                if not HasModelLoaded(animModel) then
                    loadAnimDict(animModel)
                end

                local model = 'prop_food_bag2' --  w_am_flare
                local hash = GetHashKey(model)
                if not HasModelLoaded(model) then
                    LoadPropDict(model)
                end
               
                local x,y,z = table.unpack(GetEntityCoords(xPlayer))
                local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
                local PaperBag = CreateObject(hash, plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
                
                local netid = ObjToNet(PaperBag)
                SetNetworkIdExistsOnAllMachines(netid, true)
                NetworkSetNetworkIdDynamic(netid, true)
                SetNetworkIdCanMigrate(netid, false)
                AttachEntityToEntity(PaperBag, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), 0.05, 0.05, 0.0, 260.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
                Wait(100)
                TaskPlayAnim(xPlayer, "oddjobs@assassinate@vice@hooker", "argue_a", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
                TriggerServerEvent('emfan-hostage:server:BagPlayerSync', GetPlayerServerId(closestPlayer))
                if Config.Framework == "QBCore" then
                    QBCore.Functions.Notify('Putting bag over head...', "success", 3000) 
                elseif Config.Framework == "ESX" then
                    notif('Putting bag over head...')
                end
                Wait(500)
                DeleteObject(PaperBag)
                ClearPedTasks(xPlayer)
            else
                if Config.Framework == "QBCore" then
                    QBCore.Functions.Notify("You're not close enough", "error", 3000)
                elseif Config.Framework == "ESX" then
                    notif("You're not close enough")
                end
            end
        end
    end
end)

RegisterNetEvent('emfan-hostage:client:BagPlayer')
AddEventHandler('emfan-hostage:client:BagPlayer', function()
    if Config.Framework == "QBCore" then
        QBCore.Functions.Notify("You're being kidnapped...", "error", 5000)
    elseif Config.Framework == "ESX" then
        notif("You're being kidnapped")
    end
    IsBagged = true
    local KidnappedPlayer = PlayerPedId()
    local KidnappedCoords = GetEntityCoords(KidnappedPlayer)
    
    SetTimecycleModifier("drunk")
    SetTimecycleModifierStrength(5.0)
    

    local animModel = "random@arrests@busted"
    if not HasModelLoaded(animModel) then
        loadAnimDict(animModel)
    end
    TaskPlayAnim(KidnappedPlayer, "random@arrests@busted", "idle_b", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    local xPlayer = PlayerPedId()
    loop = 1
    local model = 'prop_food_bag2' --  w_am_flare
    local hash = GetHashKey(model)
    if not HasModelLoaded(model) then
        LoadPropDict(model)
    end

    local x,y,z = table.unpack(GetEntityCoords(xPlayer))
    local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
    local BagHead = CreateObject(hash, plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
    
    local netid = ObjToNet(BagHead)
    SetNetworkIdExistsOnAllMachines(netid, true)
    NetworkSetNetworkIdDynamic(netid, true)
    SetNetworkIdCanMigrate(netid, false)
    Wait(500)
    AttachEntityToEntity(BagHead, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 12844), 0.3, 0.005, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 1, 0, 1)
    TriggerServerEvent('emfan-hostage:server:SyncRemove', KidnappedPlayer, KidnappedCoords, BagHead)
    
    while IsBagged == true do
        Wait(0)
        DisableControlAction(0, 30, true)
        DisableControlAction(0, 31, true)
        DisableControlAction(0, 32, true)
        DisableControlAction(0, 33, true)
        DisableControlAction(0, 34, true)
        DisableControlAction(0, 35, true)
        DisableControlAction(0, 24, true)
    end   
end)

RegisterNetEvent('emfan-hostage:client:SyncRemove')
AddEventHandler('emfan-hostage:client:SyncRemove', function(KidnappedPlayer, KidnappedCoords, BagHead)
    local beingCarried = false
    local xPlayer = PlayerPedId()
    local EndLoop = 0
    while KidnappedPlayer ~= xPlayer and EndLoop ~= 1 do
        Wait(1000)
        local xPlayerCoords = GetEntityCoords(xPlayer)
        local xDist = #(xPlayerCoords - KidnappedCoords)
        if xDist < 30.0 then
            while EndLoop ~= 1 do
                Wait(0)     
                if xDist < 3.0 then
                    if beingCarried == false then
                        DrawText3Ds(KidnappedCoords.x, KidnappedCoords.y, KidnappedCoords.z+1.1, '~r~E~g~ - Take off bag')
                        DrawText3Ds(KidnappedCoords.x, KidnappedCoords.y, KidnappedCoords.z+1.0, '~r~G~g~ - Carry')
                    else 
                        local newPos = GetEntityCoords(xPlayer)
                        DrawText3Ds(newPos.x, newPos.y, newPos.z+1.0, '~r~G~g~ - Stop Carry')
                    end
                    if IsControlJustPressed(0, 38) and beingCarried == false then                                                                  
                        EndLoop = 1
                        TaskPlayAnim(xPlayer, "oddjobs@assassinate@vice@hooker", "argue_a", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
                        TriggerServerEvent('emfan-hostage:server:FinishRemove', BagHead)
                        Wait(500)
                        ClearPedTasks(xPlayer)
                    elseif IsControlJustPressed(0, 47) and beingCarried == false then
                        TriggerEvent('carry:Event', KidnappedPlayer)
                        beingCarried = true 
                    elseif IsControlJustPressed(0, 47) and beingCarried == true then
                        TriggerEvent('carry:Event', KidnappedPlayer)
                        KidnappedCoords = GetEntityCoords(xPlayer)
                        beingCarried = false
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('emfan-hostage:client:FinishRemove')
AddEventHandler('emfan-hostage:client:FinishRemove', function(BagHead)
    IsBagged = false
    DeleteObject(BagHead)
    SetTimecycleModifier("drunk")
    SetExtraTimecycleModifierStrength(0.0)
    ClearTimecycleModifier()
    
end)

RegisterNetEvent('carry:Event')
AddEventHandler('carry:Event', function(KidnappedPlayer)
    loadAnimDict('anim@gangops@hostage@')
    local t, distance
    if Config.Framework == "QBCore" then
         t, distance = QBCore.Functions.GetClosestPlayer()
    elseif Config.Framework == "ESX" then
         t, distance = ESX.Game.GetClosestPlayer()
    end
    if(distance ~= -1 and distance < 3 and not beingCarried and HasEntityClearLosToEntity(GetPlayerPed(t), PlayerPedId(), 17) and not IsPedInAnyVehicle(GetPlayerPed(t)) and not IsPedInAnyVehicle(PlayerPedId())) then
        if isCarrying then
            isCarrying = false
            TriggerServerEvent('undragTarget', GetPlayerServerId(t))
            ClearPedTasksImmediately(PlayerPedId())
        else
            isCarrying = true
            TriggerServerEvent('dragTarget', GetPlayerServerId(t))
            TaskPlayAnim(GetPlayerPed(PlayerId()), 'anim@gangops@hostage@', 'perp_idle', 1.0, 1.0, -1, 49, 0, 0, 0, 0)
        end
    end
end)

RegisterNetEvent('dragPlayer')
AddEventHandler('dragPlayer', function(closestID)
    local tPed = GetPlayerPed(GetPlayerFromServerId(closestID))
    local pP = PlayerPedId()
    loadAnimDict("anim@gangops@hostage@")
    TaskPlayAnim(pP, "anim@gangops@hostage@", "victim_idle", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
    AttachEntityToEntity(pP, tPed, 0, -0.24, 0.11, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    beingCarried = true
end)


RegisterNetEvent('undragPlayer')
AddEventHandler('undragPlayer', function(closestID)
 ClearPedTasksImmediately(PlayerPedId())
 beingCarried = false
 DetachEntity(PlayerPedId(), true, false)
end)


function notif(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    ClearDrawOrigin()
end

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(0)
    end
end

function LoadPropDict(model)
    local hash = GetHashKey(model)
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(0)
    end
end