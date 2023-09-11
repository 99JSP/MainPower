CurrentWeather = "EXTRASUNNY"
local lastWeather = CurrentWeather;
local time = 0
local timeOffSet = 0
local timer = 0
local freeze = false 
local disable = false

RegisterNetEvent('MP-Base:LoginPlayer')
AddEventHandler('MP-Base:LoginPlayer', function()
    disable = false 
    TriggerServerEvent('MP-Weather:Server:Sync')
end)

RegisterNetEvent('MP-Weather:EnableSync')
AddEventHandler('MP-Weather:EnableSync', function()
    disable = false
    TriggerServerEvent('MP-Weather:Server:Sync')
    setRainFxIntensity(-1.5)
end)


RegisterNetEvent('MP-Weather:Client:DisableSync')
AddEventHandler('MP-Weather:Client:DisableSync', function()
    disable = true

    CreateThread(function()
        while disable do 
            setRainFxIntensity(0)
            SetWeatherTypePersist("EXTRASUNNY")
            SetWeatherTypeNow("EXTRASUNNY")
            SetWeatherTypeNowPersist("EXTRASUNNY")
            NetworkOverrideClockTime(23, 0 ,0)
            Wait(5000)
        end
    end)
end)
-- comment for testing

RegisterNetEvent('MP-Weather:Client:TimeSync')
AddEventHandler('MP-Weather:Client:TimeSync', function(default_time, offset, freeze) 
    time_frozen = freeze
    timeOffSet = offset
    time = freeze
end)

RegisterNetEvent('MP-Weather:Client:WeatherSync')
AddEventHandler('MP-Weather:Client:WeatherSync', function(new_weather) 
    CurrentWeather = new_weather
end)

CreateThread(function()
    local hour = 0
    local min = 0 
    while true do
        if not disable then 
            local new_time = default_time
            if GetGameTimer() - 500 > timer then
                new_time = new_time + 0.25
                timer = GetGameTimer()
            end
            if freeze then 
                timeOffSet = timeOffSet + time - new_time
            end
            time = new_time
            hour = math.floor(((time+timeOffSet)/60)%24)
            min = math.floor(((time+timeOffSet)%60))
            NetworkOverrideClockTime(hour, min, 0)

            Wait(2000)
        else 
            Wait(2000)
        end
    end
end)

CreateThread(function()
    while true do 
        if not disable then 
            if lastWeather ~= CurrentWeather then 
                lastWeather = CurrentWeather
                SetWeatherTypeOverTime(CurrentWeather, 15)
                Wait(15000)
            end
            Wait(100)
            ClearOverrideWeather()
            ClearWeatherTypePersist()
            SetWeatherTypePersist(lastWeather)
            SetWeatherTypeNow(lastWeather)
            SetWeatherTypeNowPersist(lastWeather)
            if lastWeather == "Christmas" then 
                SetForceVehicleTrails(true)
                SetForcedPedFootstepsTracks(true)
            else
                SetForceVehicleTrails(false)
                SetForcedPedFootstepsTracks(false)
            end
        else
            Wait(2000)
        end
end)