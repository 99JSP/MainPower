RegisterServerEvent('MP-Admin:RemovePlayer')
AddEventHandler('MP-Admin:RemovePlayer', function(playerId, reason)
    DropPlayer(playerId, reason)
end)

RegisterServerEvent('MP-Admin:SaveCoords')
AddEventHandler('MP-Admin:SaveCoords', function(blank, x, y, z)
    file = io.open('coords.txt', 'a')
    if file then
        file:write('[' .. blank .. ']' .. ' = ' .. x .. ',' .. y .. ',' .. z .. '')
		-- [1] = x,y,z
    end
    file:close()
end)

RegisterServerEvent('MP-Admin:DeleteCoords')
AddEventHandler('MP-Admin:DeleteCoords', function()
    os.remove('coords.txt')
end)