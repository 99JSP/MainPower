TriggerEvent('MP-Base:addGroupCommand', 'setgroup', 'admin', function(source,args,user)
    local target = tonumber(args[1]) -- player id in game
    local group = tostring(args[2]) -- group [admin,mod,dev]
    local player = MP.Functions.GetPlayer(target)
    if target ~= nil then
        if player then
            if MP.UserGroups[group] then
                MP.Functions.setGroup(player, group)
                TriggerClientEvent('MP-Elements:SendNotification', target, 1, "Set Group Correctly to" .. group .. "" )
            else
                TriggerClientEvent('MP-Elements:SendNotification', source,  2, "Incorrect Group" )
                -- Add log for people trying to edit someones perms
            end
        else
            TriggerClientEvent('MP-Elements:SendNotification', source,  2, "No Player Found." )
        end
    end
end, function(source, args,user)
    TriggerClientEvent('MP-Elements:SendNotification', source,  2, "No Permissions!" )
end)

TriggerEvent('MP-Base:addGroupCommand', 'console', 'admin', function(source, args, user)
    local msg = args[1] -- "fsjsdjfhjksdh kfdshdkfsh"
    TriggerClientEvent("chatMessage", -1, "CONSOLE: " .. message, 3 )
end, function(source, args, user)
    TriggerClientEvent('MP-Elements:SendNotification', source,  2, "No Permissions!" )
end)


-- Dev Coords
-- MP-Admin:Client:SaveCoords
TriggerEvent('MP-Base:addGroupCommand', 'sc', 'admin', function(source,args, user)
    local src = source
    TriggerClientEvent('MP-Admin:Client:SaveCoords', src)
end)

-- /amoney id type[cash/bank] amount change[del/add]



TriggerEvent('MP-Base:addGroupCommand', 'aMoney', 'admin', function(source,args, user)
    local Player = MP.Functions.GetPlayer(tonumber(args[1]))
    local bankingType = tostring(args[2]) -- # amount
	local amount = tonumber(args[3])
	local changer = tostring(args[4])
    if Player ~= nil then
		exports['MP-Base']:changeMoney(source, bankingType, amount, changer)

        -- Player.Functions.UpdateMoney(bankingType, amount, changer)
    else
        TriggerClientEvent('MP-Elements:SendNotification', source,  2, "No Player Found." )
    end
end)
-- prio

TriggerEvent('MP-Base:addGroupCommand', 'EditPrio', 'admin', function(source,args, user)
    local Player = MP.Functions.GetPlayer(tonumber(args[1]))
    local level = tonumber(args[2]) -- # amount
    if Player ~= nil then
        UpdatePriority(tonumber(args[1]), level)
        TriggerClientEvent('MP-Elements:SendNotification', source,  1, "Prio Updated to: " .. level .. "" )
        TriggerClientEvent('MP-Elements:SendNotification', player,  3, "Prio Updated to: " .. level .. "" )
    else
        TriggerClientEvent('MP-Elements:SendNotification', source,  2, "No Player Found." )
    end
end)



TriggerEvent('MP-Base:addGroupCommand', 'CheckPrio', 'admin', function(source,args,user)
    local src = source
    local Player = MP.Functions.GetPlayer(tonumber(args[1]))
    MySQL.query.await("SELECT * FROM `queue` WHERE `steam` = '"..GetPlayerIdentifiers(tonumber(args[1]))[1].."'", function(result)
		if result[1] ~= nil then
			local prio = result[1].priority
			TriggerClientEvent("chatMessage", source, "Their Priortiy = ", 3, prio )
		end
	end)
end)

function UpdatePriority(source, level)
    local Player = MP.Functions.GetPlayer(source)
    if Player ~= nil then
        MySQL.query("DELETE FROM `queue` WHERE `steam` = '"..GetPlayerIdentifiers(source)[1].."'")
		Citizen.Wait(100)
		MySQL.query("INSERT INTO `queue` (`steam`, `priority`) VALUES ('"..GetPlayerIdentifiers(source)[1].."', '"..level.."')")
    end
end

TriggerEvent('MP-Base:addCommand', 'ooc', function(source, args)
    local msg = table.concat(args, ' ')
    local Player = MP.Functions.GetPlayer(source)
    local id = Player.Data.PlayerId
    local first = Player.Data.firstname
    local last = Player.Data.lastname
    local full = ('|' .. id .. '| ' .. first .. ' ' .. last .. ' ')
    TriggerClientEvent('chatMessage', -1, 'OOC: ' .. full .. ' ',2, msg)
end)