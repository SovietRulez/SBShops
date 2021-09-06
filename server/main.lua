QBCore.Functions.CreateCallback('sellShop', function(source, cb, target, shopInfo)
    local src = source
    local Player = QBCore.Functions.GetPlayer(target)
    local Player2 = QBCore.Functions.GetPlayer(src)
    local targetPlayer = QBCore.Functions.GetPlayer(target).PlayerData
    local targetCID = targetPlayer.citizenid
    local result = exports.ghmattimysql:executeSync('SELECT * FROM sbshops WHERE shopName=@shopName', {
        ['@shopName'] = shopInfo.name
    })
    if result[1] and Player.PlayerData.money.bank >= shopInfo.price then
        if not result[1].citizenid then
            local targetPed = QBCore.Functions.GetPlayerByCitizenId(targetPlayer.citizenid)
            local targetFn = targetPed.PlayerData.charinfo.firstname
            local targetLn = targetPed.PlayerData.charinfo.lastname
            Player.Functions.RemoveMoney('bank', shopInfo.price)
            TriggerEvent('qb-bossmenu:server:addAccountMoney', Config.Job, shopInfo.price)

            TriggerClientEvent("QBCore:Notify", src, string.format(shopInfo.name .. " has been sold to %s %s and money deposited with %s", targetFn, targetLn, Config.Job),"success", 5000)
            TriggerClientEvent("QBCore:Notify", target, "You now own the shop " .. shopInfo.name, "success", 5000)
            exports['ghmattimysql']:execute('UPDATE sbshops SET citizenid = @citizenid WHERE shopName = @shopName', {
                ['@citizenid'] = targetCID,
                ['@shopName'] = shopInfo.name
            })
        else
            local player = QBCore.Functions.GetPlayerByCitizenId(result[1].citizenid)
            local firstname = player.PlayerData.charinfo.firstname
            local lastname = player.PlayerData.charinfo.lastname
            TriggerClientEvent("QBCore:Notify", src, string.format("Shop owned by %s %s", firstname, lastname), "error",
                5000)
        end
    elseif Player.PlayerData.money.bank < shopInfo.price then
        TriggerClientEvent("QBCore:Notify", src, string.format("Client is to broke to pay"), "error", 5000)
    end
end)

QBCore.Functions.CreateCallback('repoShop', function(source, cb, target, shopInfo)
    local src = source
    local result = exports.ghmattimysql:executeSync('SELECT * FROM sbshops WHERE shopName=@shopName', {
        ['@shopName'] = shopInfo.name
    })
    if result[1] then
        if result[1].citizenid then
            exports.ghmattimysql:execute('UPDATE sbshops SET citizenid = NULL WHERE shopName=@shopName', {
                ['@shopName'] = shopInfo.name
            }, function()
                TriggerClientEvent("QBCore:Notify", src, string.format("%s has been reposessed", shopInfo.name),"success", 5000)
            end)
        else
            TriggerClientEvent("QBCore:Notify", src,
                string.format("%s could not be reposessed, beause it's not owned!", shopInfo.name), "error", 5000)
        end
    end
end)

