local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Aviation System Server Functions
ESX.RegisterServerCallback('aviation:getLicenses', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    MySQL.Async.fetchAll('SELECT license_type FROM aviation_licenses WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(result)
        local licenses = {}

        for i=1, #result, 1 do
            licenses[result[i].license_type] = true
        end

        cb(licenses)
    end)
end)

RegisterNetEvent('aviation:buyLicense')
AddEventHandler('aviation:buyLicense', function(licenseType)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local licensePrice = Config.AviationLicenses[licenseType].price

    if xPlayer.getMoney() >= licensePrice then
        xPlayer.removeMoney(licensePrice)

        MySQL.Async.execute('INSERT INTO aviation_licenses (identifier, license_type) VALUES (@identifier, @license_type)', {
            ['@identifier'] = identifier,
            ['@license_type'] = licenseType
        }, function(rowsChanged)
            if rowsChanged > 0 then
                xPlayer.showNotification('You have successfully purchased the ' .. Config.AviationLicenses[licenseType].label .. ' license.')
            else
                xPlayer.showNotification('Failed to purchase the license. Please try again.')
            end
        end)
    else
        xPlayer.showNotification('You do not have enough money to purchase this license.')
    end
end)

RegisterNetEvent('aviation:applyJob')
AddEventHandler('aviation:applyJob', function(jobName)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    MySQL.Async.execute('INSERT INTO aviation_jobs (identifier, job_name, grade) VALUES (@identifier, @job_name, @grade)', {
        ['@identifier'] = identifier,
        ['@job_name'] = jobName,
        ['@grade'] = Config.AviationJobs[jobName].grade
    }, function(rowsChanged)
        if rowsChanged > 0 then
            xPlayer.setJob(jobName, Config.AviationJobs[jobName].grade)
            xPlayer.showNotification('You have successfully applied for the ' .. Config.AviationJobs[jobName].label .. ' job.')
        else
            xPlayer.showNotification('Failed to apply for the job. Please try again.')
        end
    end)
end)

RegisterNetEvent('aviation:buyVehicle')
AddEventHandler('aviation:buyVehicle', function(vehicleModel)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local vehiclePrice = Config.AviationVehicles[vehicleModel].price

    if xPlayer.getMoney() >= vehiclePrice then
        xPlayer.removeMoney(vehiclePrice)

        local plate = GeneratePlate()

        MySQL.Async.execute('INSERT INTO aviation_vehicles (owner, model, plate) VALUES (@owner, @model, @plate)', {
            ['@owner'] = identifier,
            ['@model'] = vehicleModel,
            ['@plate'] = plate
        }, function(rowsChanged)
            if rowsChanged > 0 then
                xPlayer.showNotification('You have successfully purchased the ' .. Config.AviationVehicles[vehicleModel].label .. ' vehicle.')
            else
                xPlayer.showNotification('Failed to purchase the vehicle. Please try again.')
            end
        end)
    else
        xPlayer.showNotification('You do not have enough money to purchase this vehicle.')
    end
end)

function GeneratePlate()
    local plate = ''
    for i = 1, 3 do
        plate = plate .. string.char(math.random(65, 90))
    end
    for i = 1, 3 do
        plate = plate .. math.random(0, 9)
    end
    return plate
end

RegisterNetEvent('aviation:requestEmergencyLanding')
AddEventHandler('aviation:requestEmergencyLanding', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    -- Implement emergency landing logic here
    xPlayer.showNotification('Emergency landing request has been sent.')
end)

RegisterNetEvent('aviation:requestMedicalAssistance')
AddEventHandler('aviation:requestMedicalAssistance', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    -- Implement medical assistance logic here
    xPlayer.showNotification('Medical assistance request has been sent.')
end)