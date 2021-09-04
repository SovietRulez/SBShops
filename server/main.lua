QBCore.Functions.CreateCallback('sellShop', function(source, cb, target, globalVar)
    local src = source
    local targetPlayer = QBCore.Functions.GetPlayer(target).PlayerData
    local targetCID = targetPlayer.citizenid
    local shopInfo = Config.Shops[globalVar]
    local result = exports.ghmattimysql:executeSync('SELECT * FROM sbshops WHERE citizenid=@citizenid', {['@citizenid'] = targetCID})
    if not result[1] then
        TriggerClientEvent("QBCore:Notify", src, "Shop has been sold", "success", 5000)
        exports['ghmattimysql']:execute('INSERT INTO sbshops (citizenid, shopName) VALUES (@citizenid, @shopName)', {
            ['citizenid'] = targetCID,
            ['shopName'] = globalVar
        })
    elseif result[1] then
        TriggerClientEvent("QBCore:Notify", src, "Shop is already owned!", "error", 5000)
    end
end)
------------SELL SHOP----------------^^^^^^^^^^^^^^^^^^^
