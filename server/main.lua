QBCore.Functions.CreateCallback('sellShop', function(source, cb, target, globalVar)
    local src = source
    local targetPlayer = QBCore.Functions.GetPlayer(target).PlayerData
    local targetCID = targetPlayer.citizenid
    local result = exports.ghmattimysql:executeSync('SELECT * FROM sbshops WHERE shopName=@shopName', {
        ['@shopName'] = globalVar
    })
    if result[1] then
        if not result[1].citizenid then
            local targetPed = QBCore.Functions.GetPlayerByCitizenId(targetPlayer.citizenid)
            local targetFn = targetPed.PlayerData.charinfo.firstname
            local targetLn = targetPed.PlayerData.charinfo.lastname
            TriggerClientEvent("QBCore:Notify", src, string.format(globalVar.. " has been sold to %s %s", targetFn, targetLn), "success", 5000)
            TriggerClientEvent("QBCore:Notify", target, "You now own the shop " ..globalVar, "success", 5000)
            exports['ghmattimysql']:execute('UPDATE sbshops SET citizenid = @citizenid WHERE shopName = @shopName', {
                ['@citizenid'] = targetCID,
                ['@shopName'] = globalVar
            })
        else
            local player = QBCore.Functions.GetPlayerByCitizenId(result[1].citizenid)
            local firstname = player.PlayerData.charinfo.firstname
            local lastname = player.PlayerData.charinfo.lastname
            TriggerClientEvent("QBCore:Notify", src, string.format("Shop owned by %s %s", firstname, lastname), "error", 5000)
        end
    end
end)
------------SELL SHOP----------------^^^^^^^^^^^^^^^^^^^ DONT TOUCH ANYMORE THIS IS FINISHED


QBCore.Functions.CreateCallback('repoShop', function(source, cb, target, globalVar)
    local src = source
    local targetPlayer = QBCore.Functions.GetPlayer(target).PlayerData
    local targetCID = targetPlayer.citizenid
    local result = exports.ghmattimysql:executeSync('SELECT * FROM sbshops WHERE shopName=@shopName', {
        ['@shopName'] = globalVar
    })
    --if result[1] then
            --exports['ghmattimysql']:execute('DELETE citizenid FROM sbshops')
    --end
    if result1[1] then -- for test
            exports['ghmattimysql']:execute('DELETE citizenid FROM sbshops WHERE shopName=@shopName', {['@shopName'] = globalVar})
    end
end)

--^ Callback above is broken. Remember!
