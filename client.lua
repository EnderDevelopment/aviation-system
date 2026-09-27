local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

-- Aviation System Client Functions
function OpenAviationMenu()
    local elements = {}

    table.insert(elements, {label = 'Licenses', value = 'licenses'})
    table.insert(elements, {label = 'Jobs', value = 'jobs'})
    table.insert(elements, {label = 'Vehicles', value = 'vehicles'})
    table.insert(elements, {label = 'Emergencies', value = 'emergencies'})

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'aviation_menu', {
        title    = 'Aviation System',
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'licenses' then
            OpenLicensesMenu()
        elseif data.current.value == 'jobs' then
            OpenJobsMenu()
        elseif data.current.value == 'vehicles' then
            OpenVehiclesMenu()
        elseif data.current.value == 'emergencies' then
            OpenEmergenciesMenu()
        end
    end, function(data, menu)
        menu.close()
    end)
end

function OpenLicensesMenu()
    local elements = {}

    for k, v in pairs(Config.AviationLicenses) do
        table.insert(elements, {label = v.label .. ' - $' .. v.price, value = k})
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'licenses_menu', {
        title    = 'Aviation Licenses',
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        TriggerServerEvent('aviation:buyLicense', data.current.value)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

function OpenJobsMenu()
    local elements = {}

    for k, v in pairs(Config.AviationJobs) do
        table.insert(elements, {label = v.label, value = k})
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'jobs_menu', {
        title    = 'Aviation Jobs',
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        TriggerServerEvent('aviation:applyJob', data.current.value)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

function OpenVehiclesMenu()
    local elements = {}

    for k, v in pairs(Config.AviationVehicles) do
        table.insert(elements, {label = v.label .. ' - $' .. v.price, value = k})
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicles_menu', {
        title    = 'Aviation Vehicles',
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        TriggerServerEvent('aviation:buyVehicle', data.current.value)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

function OpenEmergenciesMenu()
    local elements = {}

    table.insert(elements, {label = 'Request Emergency Landing', value = 'emergency_landing'})
    table.insert(elements, {label = 'Request Medical Assistance', value = 'medical_assistance'})

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'emergencies_menu', {
        title    = 'Aviation Emergencies',
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'emergency_landing' then
            TriggerServerEvent('aviation:requestEmergencyLanding')
        elseif data.current.value == 'medical_assistance' then
            TriggerServerEvent('aviation:requestMedicalAssistance')
        end
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

-- Key Controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 344) then -- F5
            OpenAviationMenu()
        end
    end
end)