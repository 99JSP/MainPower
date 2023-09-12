MP.DB = MP.DB or {}
MP.AdminPlayer = {}


-- Add creating database


MP.DB.LoadCharacter = function(source, license, identifier, cid)
    local src = source
    local PlayerData = {
        identifier = identifier,
        license = license,
        cid = cid,
        name = GetPlayerName(src),
        cash = MP.NewCharacter.Cash,
        bank = MP.NewCharacter.Bank,
        citizenid = '' .. cid .. '-' .. identifier .. '',
    }

    MySQL.query('SELECT * FROM players WHERE identifier = @identifier AND cid = @cid', {['@identifier'] = identifier, ['@cid'] = cid}, function(result)
        if result[1].new == true then
            print('New Player')
            MP.Functions.LoadPlayer(source, PlayerData, cid, 1)
            MySQL.query('UPDATE players SET new = @new WHERE identifier = @identifier AND cid = @cid', {['@identifier'] = identifier, ['@cid'] = cid, ['@new'] = 0})
        elseif result[1].new == false then
            print('LOAD SPAWN')
            MP.Functions.LoadPlayer(source, PlayerData, cid, 0)
        end
    end)
end

MP.DB.doesUserExist = function(identifier, callback)
    TriggerEvent('MP-Base:server:doesUserExist', identifier, callback)
end

MP.DB.SavePlayer = function(source, identifier)
    print('[MP-Base] ' .. GetPlayerName(source) .. ' was saved successfully!' )
end

RegisterServerEvent('MP-Admin:Setup')
AddEventHandler('MP-Admin:Setup', function(source, identifier)
    MP.Admin.Setup(source, identifier)
end)

MP.Admin.Setup = function(source, identifier)
    MySQL.query('SELECT * FROM ranking WHERE identifier = @identifier', {['@identifier'] = identifier}, function(result)
        local slefA = {}
        slefA.Data = {}
        slefA.Functions = {}

        slefA.Data.identifier = result[1].identifier
        slefA.Data.usergroup = result[1].usergroup

        slefA.Functions.setGroup = function(group)
            slefA.Data.usergroup = group
            MP.Functions.setGroup(slefA, group)
        end

        MP.APlayers[source] = slefA
        print(slefA.Data.usergroup)
        ExecuteCommand('add_principal identifier.' .. result[1].identifier .. " group." .. slefA.Data.usergroup)
        print('[MP] '..result[1].identifier..', Updated To Group: '..slefA.Data.usergroup..' was successfull!')
    end)
end