RegisterServerEvent('MP-Base:Char:Joined')
AddEventHandler('MP-Base:Char:Joined', function()
    local src = source
    local id
    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len('steam:')) == 'steam:' then
            id = v
            break
        end
    end

    if not id then
        DropPlayer(src, 'Identifier was not found please make sure you have steam open!')
    else
        TriggerClientEvent('MP-Base:Char:setupCharacters', src)
    end
end)

RegisterServerEvent('MP-Base:Char:ServerSelect')
AddEventHandler('MP-Base:Char:ServerSelect', function(cid) -- CID is for character slot from ui
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]        -- will get steam id
    local license = GetPlayerIdentifiers(src)[2]           -- will get a fivem license.

    MP.DB.LoadCharacter(src, license, identifier, cid)     -- ensure we get the correct player.
end)

MP.Functions.RegisterServerCallback('MP-Base:getChar', function(source, cb)
    local id = GetPlayerIdentifiers(source)[1]

    MySQL.query('SELECT * FROM players WHERE identifier = @identifier', { ['@identifier'] = id }, function(result)
        if result then
            cb(result)
        end
    end)
end)
-- deleting
local tables = {
    { table = 'players' },
    { table = 'playerskins' },
    { table = 'player_outfits' }
}


RegisterServerEvent('MP-Base:deleteChar')
AddEventHandler('MP-Base:deleteChar', function(chardata)
    local cid          = chardata.cid -- passing right player slot
    local name         = 'First: ' .. chardata.firstname .. ' Last: ' .. chardata.lastname .. ''
    local src          = source
    local identifier   = GetPlayerIdentifiers(src)[1]
    local charname     = 'First: ' .. chardata.firstname .. ' Last: ' .. chardata.lastname .. ''

    local citizenid    = '' .. cid .. '-' .. identifier .. '' -- 1-SteamID
    local numbertables = #tables
    for i = 1, numbertables do
        local v = tables[i]
        MySQL.query('DELETE FROM ' .. v.table .. ' WHERE citizenid = @citizenid', { ['@citizenid'] = citizenid })
    end


    --  This should remove everything connected where citizenid
    -- MySQL.query('DELETE FROM * WHERE citizenid = @citizenid', {['@citizenid'] = citizenid})

    -- Add Discord Logs here.

    TriggerClientEvent('MP-Base:Char:setupCharacters', src) -- refresh the menu
end)

function generateBankingID()
    return math.random(000000, 999999)
end

function generatePhoneNumber()
    return math.random(0000000000, 9999999999)
end

function isUniqueBankingID(bankingID)
    local result = MySQL.query("SELECT * FROM players WHERE bankingId = @bankingId", { ["@bankingId"] = bankingId })
    if result == nil then
        return 0
    end
end

function isUniquePhone(phone)
    local result = MySQL.query("SELECT * FROM players WHERE phone = @phone", { ["@phone"] = phone })
    if result == nil then
        return 0
    end
end

RegisterServerEvent('MP-Base:server:createCharacter')
AddEventHandler('MP-Base:server:createCharacter', function(charData)
    local bankingId = generateBankingID()
    local phone = generatePhoneNumber()
    while not isUniqueBankingID(bankingId) do
        bankingId = generateBankingID()
    end

    while not isUniquePhone(phone) do
        phone = generatePhoneNumber()
    end

    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    local license = GetPlayerIdentifiers(src)[2]
    local name = GetPlayerName(src)
    local cid = charData.cid
    local citizenid = "" .. charData.cid .. "-" .. identifier .. ""

    local metadata = json.encode({})

    MySQL.query(
    'INSERT INTO players (`identifier`, `license`, `name`, `cid`, `cash`, `bank`, `firstname`, `lastname`, `sex`, `dob`, `phone`, `metadata`, `bankingID`, `citizenid`) VALUES (@identifier, @license, @name, @cid, @cash, @bank, @firstname, @lastname, @sex, @dob, @phone, @metadata, @bankingId, @citizenid)',
        {
            ['identifier'] = identifier,
            ['license'] = license,
            ['name'] = name,
            ['cid'] = cid,
            ['cash'] = MP.NewCharacter.Cash,
            ['bank'] = MP.NewCharacter.Bank,
            ['firstname'] = charData.firstname,
            ['lastname'] = charData.lastname,
            ['sex'] = charData.sex,
            ['dob'] = charData.dob,
            ['phone'] = phone,
            ['metadata'] = metadata,
            ['bankingId'] = bankingId,
            ['citizenid'] = citizenid
        })
    TriggerClientEvent('MP-Base:Char:setupCharacters', src)
end)
