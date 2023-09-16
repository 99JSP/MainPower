local selectingChar = false
local cam, cam2  = nil

local bannedNames = {}

CreateThread(function()
    while true do
        Wait(0)

        if NetworkIsSessionStarted() then
            TriggerServerEvent('MP-Base:Char:Joined')
            TriggerEvent('MP-Base:Char:StartCamera')
            TriggerEvent('MP-Elements:client:CloseCharUI')
            -- TriggerEvent('MP-Base:PlayerLogin')
            SelectChar(true)
            return
        end
    end
end)

RegisterNetEvent('MP-Base:Char:Selecting')
AddEventHandler('MP-Base:Char:Selecting', function()
    SelectChar(true)
end)

RegisterNUICallback('createCharacter', function(data)
    local charData = data.charData
    for theData, value in pairs(charData) do
		if theData == "firstname" or theData == "lastname" then
			reason = exports['MP-Base']:verifyName(value)
            print(reason)

			if reason ~= "" then
				break
            end
		end
	end

    if reason == "" then
        TriggerServerEvent('MP-Base:server:createCharacter', charData) -- creates character and makes data
    end
end)

-- use exports['MP-Base']:verifyName to verify name
exports('verifyName', function(name)
    for k, v in ipairs(bannedNames) do
        if name == v  then
            local reason = "Trying to use inappropriate name and ruin the fun for everyone. Please think about your choices or never come back to the server! "
            TriggerServerEvent("MP-Admin:Disconnect", reason)
        end
    end

    local nameLength = string.len(name)
    if nameLength > 25 or nameLength < 2 then
        return 'Your Name Is too short or long'
    end

    local count = 0
	for i in name:gmatch("[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-]") do
		count = count + 1
	end
	if count ~= nameLength then
		return "Your player name contains special characters that are not allowed on this server."
	end

	local spacesInName = 0
	local spacesWithUpper = 0
	for word in string.gmatch(name, "%S+") do
		if string.match(word, "%u") then
			spacesWithUpper = spacesWithUpper + 1
		end

		spacesInName = spacesInName + 1
	end

	if spacesInName > 1 then
		return "Your name contains more than two spaces"
	end

	if spacesWithUpper ~= spacesInName then
		return "your name must start with a capital letter."
	end

	return ""
end)

RegisterNUICallback('deleteCharacter', function(data)
    local charData = data
    TriggerServerEvent('MP-Base:deleteChar', charData)
end)

RegisterNetEvent('MP-Base:Char:setupCharacters')
AddEventHandler('MP-Base:Char:setupCharacters', function()
    MP.Functions.TriggerServerCallback('MP-Base:getChar', function(data) -- Gets all data from character
        SendNUIMessage({type = "setupCharacters", characters = data})
    end)
end)

-- EXPORT
exports('MP-Base:ChangeChar', function()
    TriggerEvent('MP-Base:Char:setupCharacters')
end)

-- use exports['MP-Base']:MP-Base:ChangeChar() to change character

RegisterNetEvent('MP-Base:PlayerLoaded')
AddEventHandler('MP-Base:PlayerLoaded', function(new)
    local source = GetPlayerPed(-1)
    SetPlayerInvincible(source, true)
    FreezeEntityPosition(source, true)
    SetEntityCoords(source, 0,2000,0)
	LocalPlayer.state:set('LoggedIn', true, false)
    -- In Air
    if new == 1 then
        -- New Player
        SetCamActive(cam, false)
        RenderScriptCams(false,false,1,true,true)
        ClearTimecycleModifier()
        SetEntityCoords(source, -1037.88, -2738.009, 20.17)
        FreezeEntityPosition(source, false)
        SetPlayerInvincible(source, false)



		--  Auto set model for freemode asap.
		TriggerEvent("qb-clothes:client:CreateFirstCharacter", source)
    elseif new == 0 then
		-- need to fix not saved clothing?
		TriggerServerEvent("qb-clothes:loadPlayerSkin", source)
        TriggerEvent('MP-Spawn:openMenu')
    end
end)

RegisterNetEvent('MP:Client:OnPlayerUnload', function()
    LocalPlayer.state:set('LoggedIn', false, false)
end)

RegisterNUICallback('selectCharacter', function(data)
    local cid = tonumber(data.cid)
    SelectChar(false)
    TriggerServerEvent('MP-Base:Char:ServerSelect', cid)
    SetTimecycleModifier('default')
    SetCamActive(cam, false)
    DestroyCam(cam, false)
end)

RegisterNUICallback('CloseChar', function()
    SelectChar(false)
end)

function SelectChar(value)
    SetNuiFocus(value, value)
    SendNUIMessage({
        type = 'charSelect',
        status = value
    })
    selectingChar = value
end

RegisterNetEvent('MP-Base:Char:StartCamera')
AddEventHandler('MP-Base:Char:StartCamera', function()
    DoScreenFadeIn(10)
    SetTimecycleModifier('hud_def_blur')
    SetTimecycleModifierStrength(1.0)
    FreezeEntityPosition(GetPlayerPed(-1), true)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -358.56, -981.96, 286.25, 320.00, 0.00, -50.00, 90.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true,false,1,true,true)
end)