local MP = exports['MP-Base']:GetObject()

MP.Functions.RegisterServerCallback('MP-Elements:Server:getMoney', function(source, cb)
    local src = source
    local player = MP.Functions.getPlayer(src)

    if player ~= nil then
        local identifier    = player.Data.identifier
        local cid          = player.Data.cid


        MySQL.query.await('SELECT * FROM players WHERE identifier = @identifier AND cid = @cid', {['@identifier'] = identifier, ['@cid'] = cid}, function(result)
            cb(result[1].cash, result[1].bank)
        end)
    end
end)

RegisterServerEvent('MP-Elements:Server:UpdateMoney')
AddEventHandler('MP-Elements:Server:UpdateMoney', function(source, change, amount)
    local src = source
    local player = MP.Functions.getPlayer(src)

    if change == 'add' then
        MP.Functions.addCash(amount)
    elseif change == 'remove' then
        MP.Functions.removeCash(amount)
    else
        print('Error - Cannot find player')
    end
end)

RegisterServerEvent('MP-Elements:Server:UpdateBank')
AddEventHandler('MP-Elements:Server:UpdateBank', function(source, change, amount)
    local src = source
    local player = MP.Functions.getPlayer(src)

    if change == 'add' then
        MP.Functions.addBank(amount)
    elseif change == 'remove' then
        MP.Functions.removeBank(amount)
    else
        print('Error - Cannot find player')
    end
end)