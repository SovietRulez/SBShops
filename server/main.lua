QBCore.Functions.CreateCallback('check', function(source, cb)
    if not owned then
    TriggerClientEvent('QBCore:Notify', source, "Shop owned", 'error', 10000)
    cb(true)
    else 
        TriggerClientEvent('QBCore:Notify', source, "Shop available", 'success', 10000)
        cb(false)
    end
end)
