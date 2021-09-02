Config = {}
Config.Job = 'realestate'
Config.QBTarget = true -- CHANGE IF YOU USE qb-Target
Config.Shops = {
    taco = {
            name = 'Taco Party',
            location = vector3(376.54, 325.46, 103.57),
            price = 1,
            allowedItems = { 'sandwich', 'lockpick'},
    },
    -- [2] = {
    --     name = 'test2',
    --     location = vector3(0, 0, 0),
    --     price = 1,
    --     allowedItems = { 'sandwich', 'lockpick'},
    -- },
    -- [3] = {
    --     name = 'test2',
    --     location = vector3(0, 0, 0),
    --     price = 1,
    --     allowedItems = { 'sandwich', 'lockpick'},
    --},
}

Config.ItemInfo = {
    sandwich = {
        label = "Sandwich",
        price = 1,
    },
    lockpick = {
        label = "LockPick",
        price = 1,
    },
}