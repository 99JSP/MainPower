MP.Functions = MP.Functions or {}
MP.RequestID = MP.RequestID or {}
MP.ServerCallback = MP.ServerCallback or {}
MP.ServerCallbacks = {}
MP.CurrentRequestId = 0

MP.Functions.GetKey = function(key)
	local Keys = {
        ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
        ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
        ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
        ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
        ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
        ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
        ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
        ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
        ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
	}

    return Keys[key]
end

MP.Functions.GetPlayerData = function(source) -- gets player data from player
	return MP.PlayerData
end

MP.Functions.DeleteObject = function(object) -- Used for admin shit and some cop to remove an object
	SetEntityAsMissionEntity(object, false, true)
	DeleteObject(object)
end

-- usage exports['MP-Base']:MP-DeleteVehicle(vehicle);
exports('MP-DeleteVehicle', function(vehicle)
	SetEntityAsMissionEntity(vehicle, false, true)
    DeleteVehicle(vehicle)
end)


-- usage local veh = exports['MP-Base']:MP-GetVehicleInDirection();
exports('MP-GetVehicleInDirection', function()
	local playerPed    = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	local inDirection  = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 10.0, 0.0)
	local rayHandle    = StartShapeTestRay(playerCoords, inDirection, 10, playerPed, 0)
	local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

	if hit == 1 and GetEntityType(entityHit) == 2 then
		return entityHit
	end

	return nil
end)

RegisterNetEvent('MP:Player:UpdatePlayerData', function()
    TriggerServerEvent('MP:UpdatePlayer')
end)

-- MP.Functions.DeleteVehicle = function(vehicle) -- deletes vehicle
--     SetEntityAsMissionEntity(vehicle, false, true)
--     DeleteVehicle(vehicle)
-- end

-- MP.Functions.GetVehicleInDirection = function() -- gets vehicle where your player is facing
-- 	local playerPed    = PlayerPedId()
-- 	local playerCoords = GetEntityCoords(playerPed)
-- 	local inDirection  = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 10.0, 0.0)
-- 	local rayHandle    = StartShapeTestRay(playerCoords, inDirection, 10, playerPed, 0)
-- 	local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

-- 	if hit == 1 and GetEntityType(entityHit) == 2 then
-- 		return entityHit
-- 	end

-- 	return nil
-- end

-- Callbacks

MP.Functions.TriggerServerCallback = function(name, cb, ...) -- Callback a responce to function
	MP.ServerCallbacks[MP.CurrentRequestId] = cb

	TriggerServerEvent("MP-Base:server:triggerServerCallback", name, MP.CurrentRequestId, ...)

	if MP.CurrentRequestId < 65535 then
		MP.CurrentRequestId = MP.CurrentRequestId + 1
	else
		MP.CurrentRequestId = 0
	end
end

MP.Functions.GetPlayers = function() -- gets all players
	local maxPlayers = 120
	local players    = {}

	for i=0, maxPlayers, 1 do

		local ped = GetPlayerPed(i)

		if DoesEntityExist(ped) then
			table.insert(players, i)
		end
	end

	return players
end

MP.Functions.GetClosestPlayer = function(coords) -- used for cuffing and stuff
	local players         = MP.Functions.GetPlayers()
	local closestDistance = -1
	local closestPlayer   = -1
	local coords          = coords
	local usePlayerPed    = false
	local playerPed       = PlayerPedId()
	local playerId        = PlayerId()

	if coords == nil then
		usePlayerPed = true
		coords       = GetEntityCoords(playerPed)
	end

	for i=1, #players, 1 do
		local target = GetPlayerPed(players[i])

		if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then
			local targetCoords = GetEntityCoords(target)
			local distance     = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)

			if closestDistance == -1 or closestDistance > distance then
				closestPlayer   = players[i]
				closestDistance = distance
			end
		end
	end

	return closestPlayer, closestDistance
end

RegisterNetEvent("MP-Base:client:serverCallback") -- callback to server
AddEventHandler("MP-Base:client:serverCallback", function(requestId, ...)
	MP.ServerCallbacks[requestId](...)
	MP.ServerCallbacks[requestId] = nil
end)

RegisterNetEvent('MP-SetCharData')
AddEventHandler('MP-SetCharData', function(Player)
	-- TEST WITH SOMEONE LMAOOO
    MP.PlayerData = Player
end)

RegisterNetEvent('MP:Player:SetPlayerData', function(val)
    MP.PlayerData = val
end)


exports('GetPlayerData', function(dataType)
	local player = MP.Functions.GetPlayerData(GetPlayerPed(-1))
    if player ~= nil then
		print("test")
		return player[dataType]
	else
		print("player nil")
	end
end)
-- Drawing 3d Text export

exports('Draw3dText', function(x,y,z, text)
    local onScreen,x2,y2 = World3dToScreen2d(x,y,z)
	local posX,posY,PosZ = table.unpack(GetGameplayCamCoords())

	SetTextScale(0.4, 0.4)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 210)
	SetTextEntry("String")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(x2,y2)
	local factor = (string.len(text)) / 350
	DrawRect(x2, y2+0.015, 0.015+factor, 0.03, 0, 0, 0, 50)

end)

-- local MP = exports['MP-Base']:Draw3dText(x,y,z, text)