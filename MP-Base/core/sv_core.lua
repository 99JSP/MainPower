RegisterServerEvent('MP-Base:ServerStart')
AddEventHandler('MP-Base:ServerStart', function()
    local civ = source
    CreateThread(function()
        local Identifier = GetPlayerIdentifiers(civ)[1] -- This gets Steam:192913931
        if not Identifier then
            DropPlayer(Civ, "Identifier Not Located") -- Removes player if not found.
        end
        return
    end)
end)

-- CHANGE TO EXPORT
-- RegisterNetEvent('MP-Base:server:getObject')
-- AddEventHandler('MP-Base:server:getObject', function(callback)
--     callback(MP)
-- end)

exports('GetObject', function()
    return MP
end)

-- local MP = exports['MP-Base']:MP:GetObject()

-- Commands
AddEventHandler('MP-Base:addCommand', function(command, callback, suggestion, args)
    MP.Functions.addCommand(command, callback, suggestion, args)
end)

AddEventHandler('MP-Base:addGroupCommand', function(command, group, callback, callbackfailed, suggestion, args)
    MP.Functions.addGroupCommand(command, group, callback, callbackfailed, suggestion, args)
end)

-- Callback Server
RegisterServerEvent('MP-Base:server:triggerServerCallback')
AddEventHandler('MP-Base:server:triggerServerCallback', function(name, requestId, ...)
    local civ = source

    MP.Functions.TriggerServerCallback(name, requestId, civ, function(...)
        TriggerClientEvent('MP-Base:client:serverCallback', civ, requestId, ...)
    end, ...)
end)