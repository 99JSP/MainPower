local MP = exports['MP-Base']:GetObject()

MP.Functions.RegisterServerCallback('MP-Elements:Server:getMoney', function(source, cb)
    local src = source
    local player = MP.Functions.GetPlayer(src)

    if player ~= nil then
        local identifier    = player.Data.identifier
        local cid          = player.Data.cid


        MySQL.query('SELECT * FROM players WHERE identifier = @identifier AND cid = @cid', {['@identifier'] = identifier, ['@cid'] = cid}, function(result)
            cb(result[1].cash, result[1].bank)
        end)
    end
end)

RegisterServerEvent('MP-Elements:Server:UpdateMoney')
AddEventHandler('MP-Elements:Server:UpdateMoney', function(source, change, amount)
	print(amount)
    local src = source
	local player = MP.Players[source]

    if change == 'add' then
        player.Functions.GiveCash(amount)
    elseif change == 'remove' then
        player.Functions.removeCash(amount)
    else
        print('Error - Cannot find player')
    end
end)

RegisterServerEvent('MP-Elements:Server:UpdateBank')
AddEventHandler('MP-Elements:Server:UpdateBank', function(source, change, amount)
    local src = source
    local player = MP.Functions.GetPlayer(src)

    if change == 'add' then
        MP.Functions.addBank(amount)
    elseif change == 'remove' then
        MP.Functions.removeBank(amount)
    else
        print('Error - Cannot find player')
    end
end)


-- RegisterCommand("new", function(source, args, rawCommand)
-- 	local Player = tonumber(args[1])
--     local bankingType = tostring(args[2]) -- # amount
-- 	local amount = tonumber(args[3])
-- 	local changer = tostring(args[4])
-- 	exports['MP-Base']:changeMoney(source, bankingType, amount, changer)
-- end, false)