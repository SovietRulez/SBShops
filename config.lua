Config = {}
Config.Job = 'realestate'
Config.QBTarget = false -- CHANGE IF YOU USE qb-Target
Config.RobTime = 10
Config.Shops = {
    taco = {
            name = 'Taco Party',
            location = vector3(373.77, 326.09, 103.57),
            bossLocation = vector3(376.54, 325.46, 103.57),
            price = 1,
            allowedItems = { 'sandwich', 'lockpick'},
            robLocation = vector3(373.1, 329.05, 103.57),
            robbed = false,
            cooldown = 10,
            onC = false
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
