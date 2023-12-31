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

-- CHANGE TO EXPORT will edit for typescript later
-- RegisterNetEvent('MP-Base:server:getObject')
-- AddEventHandler('MP-Base:server:getObject', function(callback)
--     callback(MP)
-- end)

exports('GetObject', function()
    return MP
end)

-- exports['MP-Base']:changeMoney(source, bankingType, amount, changer)
exports('changeMoney', function(source, bankingType, amount, changer)
    local Player = MP.Functions.GetPlayer(source)
	if Player ~= nil then
        Player.Functions.UpdateMoney(bankingType, amount, changer)
    end
end)

-- Callback Server
RegisterServerEvent('MP-Base:server:triggerServerCallback')
AddEventHandler('MP-Base:server:triggerServerCallback', function(name, requestId, ...)
    local civ = source

    MP.Functions.TriggerServerCallback(name, requestId, civ, function(...)
        TriggerClientEvent('MP-Base:client:serverCallback', civ, requestId, ...)
    end, ...)
end)