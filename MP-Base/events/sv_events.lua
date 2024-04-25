--  Call Mp.
MP.Functions = MP.Functions or {}
MP.Commands =  {}
MP.CommandsSuggestions =  {}
MP.ServerCallbacks = MP.ServerCallbacks or {}
MP.ServerCallback = {}


MP.Functions.RegisterServerCallback = function(name, cb)
	MP.ServerCallbacks[name] = cb
end

MP.Functions.TriggerServerCallback = function(name, requestId, source, cb, ...)
	if MP.ServerCallbacks[name] ~= nil then
		MP.ServerCallbacks[name](source, cb, ...)
	end
end

MP.Functions.GetPlayer = function(source)
	if MP.Players[source] ~= nil then
		return MP.Players[source]
	end
end

exports('GetPlayer', function(source)
    if MP.Players[source] ~= nil then
		return MP.Players[source]
	end
end)


exports('SetPlayersData', function(source, dataType, newData, newUtilityData)
	-- print("source = " .. source .. " datatype = " .. dataType .. " newData = " .. newData .. " newUtil =" .. newUtilityData .. "!")
    if MP.Players[source] ~= nil then
		local player = MP.Players[source]
		player.Functions.setNewData(dataType, newData, newUtilityData)
	end
end)

exports('GetPlayerData', function(source, dataType)
    if MP.Players[source] ~= nil then
		local player = MP.Players[source]
		return player.Data[dataType]
	end
end)

MP.Functions.AdminPlayer = function(source) -- Admin
    if MP.APlayers[source] ~= nil then
        return MP.APlayers[source]
    end
end

RegisterNetEvent('MP-Base:server:UpdatePlayer')
AddEventHandler('MP-Base:server:UpdatePlayer', function()
    local civ = source
    local player = MP.Functions.GetPlayer(civ)
    if player then
        Player.Functions.Save()
    end
end)

-- Character SQL Stuff
MP.Functions.CreatePlayer = function(source, Data)
	MySQL.query('INSERT INTO players (`identifier`, `license`, `name`, `cash`, `bank`) VALUES (@identifier, @license, @name, @cash, @bank)', {
		['identifier'] = Data.identifier,
		['license'] = Data.license,
		['name'] = Data.name,
		['cash'] = Data.cash,
		['bank'] = Data.bank
	})

    print('[MP-Base] '..Data.name..' was created successfully')

    MP.Functions.LoadPlayer(source, Data)
end

MP.Functions.LoadPlayer = function(source, pData, cid, new)
    local src 			= source
	local identifier 	= pData.identifier
	local player = MP.Functions.GetPlayer(source)

	Wait(7)
	MySQL.query('SELECT * FROM players WHERE identifier = @identifier AND cid = @cid', {['@identifier'] = identifier, ['@cid'] = cid}, function(result)

		--Server
		MySQL.query('UPDATE players SET name = @name WHERE identifier = @identifier AND cid = @cid', { ['@identifier'] = identifier, ['@name'] = pData.name, ['@cid'] = cid})

        MP.Player.LoadData(source, identifier, cid)
		Wait(7)
		local player = MP.Functions.GetPlayer(source)
        TriggerClientEvent('MP-SetCharData', source, {
			identifier = result[1].identifier,
			license = result[1].license,
			cid = result[1].cid,
			sex = result[1].sex,
			name = result[1].name,
			cash = result[1].cash,
			bank = result[1].bank,
			phone = result[1].phone,
			job = result[1].job,
			job_grade = result[1].job_grade,
			citizenid = result[1].citizenid,
			new = result[1].new
        })
		TriggerEvent("ox_inventory:setPlayerInventory", player.Data)
        TriggerClientEvent('MP-Base:PlayerLoaded', source, new)
		TriggerClientEvent('MP-Elements:client:OpenUI:Cash', source)

        -- TriggerClientEvent() come back to for ui
        -- Trigger for Admin
		TriggerEvent("MP-Admin:Setup", source, player.Data.identifier )

    end)
	-- exports['ox_inventory']:setPlayerInventory(player.Data)
end

-- Usergroups for admin
MP.Functions.setGroup = function(player, group)
    local identifier = player.Data.identifier
    local pCid = player.Data.cid
    MySQL.query('DELETE FROM ranking WHERE identifier = @identifier', {['@identifier'] = identifier})
	Wait(1000)


	MySQL.query('INSERT INTO ranking (`usergroup`, `identifier`) VALUES (@usergroup, @identifier)', {
		['@usergroup'] = group,
		['@identifier'] = identifier
	})
    print('Function Group : '..group)
    TriggerClientEvent('MP-Admin:updateGroup', player.Data.PlayerId, group)
	-- exports['MP-Base']:updateGroup(player.Data.PlayerId, group)
end

MP.Functions.BuildCommands = function(source)
    local src = source
    for k,v in pairs(MP.CommandsSuggestions) do
        TriggerClientEvent('chat:addSuggestion', src, '/'..k, v.help, v.params)
    end
end

MP.Functions.ClearCommands = function(source)
    for k,v in pairs(MP.CommandsSuggestions) do
        TriggerClientEvent('chat:removeSuggestion', src, '/'..k, v.help, v.params)
    end
end

RegisterNetEvent('MP:UpdatePlayer', function()
    local src = source
    local Player = MP.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.Save()
end)

function MP.Functions.GetPlayers()
    return MP.Players
end

-- logoff
AddEventHandler('playerDropped', function(reason)
    local src = source
    if not MP.Players[src] then return end
    local Player = MP.Players[src]
    Player.Functions.Save()
    MP.Players[src] = nil
end)
