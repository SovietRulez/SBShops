QBCore.Functions.CreateCallback('sellShop', function(source, cb, target, shopName)
    local src = source
    local targetPlayer = QBCore.Functions.GetPlayer(target).PlayerData
    local targetCID = targetPlayer.citizenid
    local result = exports.ghmattimysql:executeSync('SELECT * FROM sbshops WHERE citizenid=@citizenid', {['@citizenid'] = targetCID})
    print(target)
    print(json.encode(result[1]))
    print(shopName)
    print(targetCID)
    if not result[1] then
        TriggerClientEvent("QBCore:Notify", src, "Shop has been sold", "success", 5000)
        exports['ghmattimysql']:execute('INSERT INTO sbshops (citizenid, shopName) VALUES (@citizenid, @shopName)', {
            ['citizenid'] = targetCID,
            ['shopName'] = shopName
        })
    elseif result[1] then
        TriggerClientEvent("QBCore:Notify", src, "Shop is already owned!", "error", 5000)
    end
end)

------------SELL SHOP----------------^^^^^^^^^^^^^^^^^^^
RegisterCommand('testprint', function(source)
    print(json.encode(Config.Shops))
end, false)
