Config = {}
Config.Job = 'realestate'
Config.QBTarget = false -- CHANGE IF YOU USE qb-Target
Config.RobTime = 10
Config.Shops = {
    taco = {
        name = 'Taco Party',
        locations = {
            boss = vector3(376.54, 325.46, 103.57),
            customer = vector3(373.77, 326.09, 103.57),
            robLocation = vector3(373.1, 329.05, 103.57),
            realEstate = vector3(379.66, 332.57, 103.57)
        },
        price = 1,
        allowedItems = {
            [1] = {
                name = 'sandwich',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 1
            },
            [2] = {
                name = 'lockpick',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 2
            }
        },
        robbed = false,
        cooldown = 10,
        onC = false
    },
    nacho = {
        name = 'Nacho Party',
        locations = {
            boss = vector3(24.78, -1339.12, 29.5),
            customer = vector3(25.65, -1346.05, 29.5),
            robLocation = vector3(24.4, -1344.09, 29.5),
            realEstate = vector3(30.33, -1339.35, 29.5)
        },
        price = 1000,
        allowedItems = {
            [1] = {
                name = 'sandwich',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 1
            },
            [2] = {
                name = 'lockpick',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 2
            }
        },
        robbed = false,
        cooldown = 10,
        onC = false
    },
    savage = {
        name = 'T Party',
        locations = {
            boss = vector3(-705.08, -905.35, 19.22),
            customer = vector3(-707.42, -912.79, 19.22),
            robLocation = vector3(-705.93, -911.11, 19.22),
            realEstate = vector3(-709.57, -905.75, 19.22)
        },
        price = 1,
        allowedItems = {
            [1] = {
                name = 'sandwich',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 1
            },
            [2] = {
                name = 'lockpick',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 2
            }
        },
        robbed = false,
        cooldown = 10,
        onC = false
    },
    lips = {
        name = 'Lip Party',
        locations = {
            boss = vector3(-1483.71, -376.06, 40.16),
            customer = vector3(-1487.05, -379.34, 40.16),
            robLocation = vector3(-1484.69, -379.05, 40.16),
            realEstate = vector3(-1479.43, -372.66, 39.16)
        },
        price = 1,
        allowedItems = {
            [1] = {
                name = 'sandwich',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 1
            },
            [2] = {
                name = 'lockpick',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 2
            }
        },
        robbed = false,
        cooldown = 10,
        onC = false
    },
    llcooljay = {
        name = 'LL Party',
        locations = {
            boss = vector3(1164.15, -313.47, 69.21),
            customer = vector3(1163.57, -323.95, 69.21),
            robLocation = vector3(1164.9, -320.19, 69.21),
            realEstate = vector3(1160.01, -315.98, 69.21)
        },
        price = 1,
        allowedItems = {
            [1] = {
                name = 'sandwich',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 1
            },
            [2] = {
                name = 'lockpick',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 2
            }
        },
        robbed = false,
        cooldown = 10,
        onC = false
    },
    testr = {
        name = 'Testing Party',
        locations = {
            boss = vector3(1731.6, 6422.14, 35.04),
            customer = vector3(1728.6, 6414.07, 35.04),
            robLocation = vector3(1729.09, 6418.04, 35.04),
            realEstate = vector3(1735.79, 6419.77, 35.04)
        },
        price = 1,
        allowedItems = {
            [1] = {
                name = 'sandwich',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 1
            },
            [2] = {
                name = 'lockpick',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 2
            }
        },
        robbed = false,
        cooldown = 10,
        onC = false
    },
    eat = {
        name = 'Eat Party',
        locations = {
            boss = vector3(1704.45, 4918.23, 42.06),
            customer = vector3(1698.08, 4924.41, 42.06),
            robLocation = vector3(1699.63, 4921.04, 42.06),
            realEstate = vector3(1706.38, 4920.83, 42.08)
        },
        price = 1,
        allowedItems = {
            [1] = {
                name = 'sandwich',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 1
            },
            [2] = {
                name = 'lockpick',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 2
            }
        },
        robbed = false,
        cooldown = 10,
        onC = false
    },
    xrated = {
        name = 'Xrated Party',
        locations = {
            boss = vector3(2671.55, 3283.67, 55.24),
            customer = vector3(2679.31, 3280.12, 55.24),
            robLocation = vector3(2675.75, 3280.53, 55.24),
            realEstate = vector3(2674.17, 3287.4, 55.24)
        },
        price = 1,
        allowedItems = {
            [1] = {
                name = 'sandwich',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 1
            },
            [2] = {
                name = 'lockpick',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 2
            }
        },
        robbed = false,
        cooldown = 10,
        onC = false
    },
    sorry = {
        name = 'Sorry Party',
        locations = {
            boss = vector3(1956.12, 3747.44, 32.34),
            customer = vector3(1961.51, 3740.1, 32.34),
            robLocation = vector3(1958.59, 3742.34, 32.34),
            realEstate = vector3(1960.45, 3749.04, 32.34)
        },
        price = 1,
        allowedItems = {
            [1] = {
                name = 'sandwich',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 1
            },
            [2] = {
                name = 'lockpick',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 2
            }
        },
        robbed = false,
        cooldown = 10,
        onC = false
    },
    stupid = {
        name = 'Stupid Party',
        locations = {
            boss = vector3(549.89, 2662.96, 42.16),
            customer = vector3(547.64, 2671.73, 42.16),
            robLocation = vector3(549.59, 2668.41, 42.16),
            realEstate = vector3(544.32, 2662.76, 42.21)
        },
        price = 1,
        allowedItems = {
            [1] = {
                name = 'sandwich',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 1
            },
            [2] = {
                name = 'lockpick',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 2
            }
        },
        robbed = false,
        cooldown = 10,
        onC = false
    },
    testing = {
        name = 'Test Party',
        locations = {
            boss = vector3(-3249.85, 1001.74, 12.83),
            customer = vector3(-3241.47, 1001.14, 12.83),
            robLocation = vector3(-3245.41, 1000.13, 12.83),
            realEstate = vector3(-3249.29, 1005.8, 12.83)
        },
        price = 1,
        allowedItems = {
            [1] = {
                name = 'sandwich',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 1
            },
            [2] = {
                name = 'lockpick',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 2
            }
        },
        robbed = false,
        cooldown = 10,
        onC = false
    },
    hewasnt = {
        name = 'Fasho Party',
        locations = {
            boss = vector3(-3046.1, 582.59, 7.91),
            customer = vector3(-3038.78, 585.97, 7.91),
            robLocation = vector3(-3041.59, 583.55, 7.91),
            realEstate = vector3(-3047.76, 586.82, 7.91)
        },
        price = 1,
        allowedItems = {
            [1] = {
                name = 'sandwich',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 1
            },
            [2] = {
                name = 'lockpick',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 2
            }
        },
        robbed = false,
        cooldown = 10,
        onC = false
    },
    james = {
        name = 'James Party',
        locations = {
            boss = vector3(-2962.87, 390.68, 15.04),
            customer = vector3(-2967.79, 391.67, 15.04),
            robLocation = vector3(-2966.17, 388.53, 15.04),
            realEstate = vector3(-2958.28, 389.07, 14.04)
        },
        price = 1,
        allowedItems = {
            [1] = {
                name = 'sandwich',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 1
            },
            [2] = {
                name = 'lockpick',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 2
            }
        },
        robbed = false,
        cooldown = 10,
        onC = false
    },
    wheels = {
        name = 'Wheels Party',
        locations = {
            boss = vector3(2549.09, 381.42, 108.62),
            customer = vector3(2557.98, 382.05, 108.62),
            robLocation = vector3(2554.12, 380.81, 108.62),
            realEstate = vector3(2549.63, 385.79, 108.62)
        },
        price = 1,
        allowedItems = {
            [1] = {
                name = 'sandwich',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 1
            },
            [2] = {
                name = 'lockpick',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 2
            }
        },
        robbed = false,
        cooldown = 10,
        onC = false
    },
    loose = {
        name = 'Tea Party',
        locations = {
            boss = vector3(-1221.63, -911.41, 12.33),
            customer = vector3(-1222.83, -907.18, 12.33),
            robLocation = vector3(-1223.81, -909.97, 12.33),
            realEstate = vector3(-1218.56, -916.18, 11.33)
        },
        price = 1,
        allowedItems = {
            [1] = {
                name = 'sandwich',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 1
            },
            [2] = {
                name = 'lockpick',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 2
            }
        },
        robbed = false,
        cooldown = 10,
        onC = false
    },
    rico = {
        name = 'Rico Party',
        locations = {
            boss = vector3(1130.78, -982.92, 46.42),
            customer = vector3(1135.7, -982.77, 46.42),
            robLocation = vector3(1135.56, -980.47, 46.42),
            realEstate = vector3(1125.72, -983.01, 45.42)
        },
        price = 1,
        allowedItems = {
            [1] = {
                name = 'sandwich',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 1
            },
            [2] = {
                name = 'lockpick',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 2
            }
        },
        robbed = false,
        cooldown = 10,
        onC = false
    },
    burrito = {
        name = 'Burrito Party',
        locations = {
            boss = vector3(-45.03, -1756.44, 29.42),
            customer = vector3(-48.09, -1757.62, 29.42),
            robLocation = vector3(-42.19, -1749.16, 29.42),
            realEstate = vector3(-44.17, -1749.51, 29.42)
        },
        price = 1,
        allowedItems = {
            [1] = {
                name = 'sandwich',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 1
            },
            [2] = {
                name = 'lockpick',
                price = 0,
                amount = 10,
                -- type = 'item',
                -- info = {},
                slot = 2
            }
        },
        robbed = false,
        cooldown = 10,
        onC = false
    }
}
