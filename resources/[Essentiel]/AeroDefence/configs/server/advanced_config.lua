aAD = {}

aAD.triggerProtection = {
    use = false,
    triggers = {
        {event = 'esx_taxijob:reward', log = {
            use = true, 
            message = 'Player took a taxi job reward!',
            webhook = 'YOUR-WEBHOOK-HERE'
        }, ban = {
            use = nil,
            action = true, -- true = ban, false = kick, nil = disable
            msg = 'You have been caught using a fake event: %s' 
        }, admin = {
            use = nil, -- need esx
            groupsAllowed = { -- name not label
                ['mod'] = true,
                ['admin'] = true,
                ['superadmin'] = true
            },
            action = {
                use = nil, -- true = ban, false = kick, nil = disable
                actionMsg = "You were caught using an event without the required group!",
            },
            log = { -- dont work if action is enabled
                use = true, 
                logMsg = "Player using admin event without being admin!"
            }
        }, job = {
            use = nil, -- need esx
            jobsAllowed = {
                ['taxi'] = true,
                ['admin'] = true,
                ['superadmin'] = true
            },
            action = {
                use = nil, -- true = ban, false = kick, nil = disable
                actionMsg = "You were caught using an event without the required group!",
            },
            log = { -- dont work if action is enabled
                use = true, 
                logMsg = "Player using admin event without being admin!"
            }
        }, job2 = {
            use = nil, -- need esx
            jobsAllowed = {
                ['taxi'] = true,
                ['admin'] = true,
                ['superadmin'] = true
            },
            action = {
                use = nil, -- true = ban, false = kick, nil = disable
                actionMsg = "You were caught using an event without the required group!",
            },
            log = { -- dont work if action is enabled
                use = true, 
                logMsg = "Player using admin event without being admin!"
            }
        }, arguments = {
            -- max arguments is 3 
            [1] = { 
                use = nil,
                limit = {
                    limitMin = {
                        use = true, 
                        min = 10000,
                        action = {
                            use = true,  -- true = ban, false = kick, nil = disable
                            actionMsg = "You have been banned for trying to spawn money : %s"
                        },
                        log = {
                            use = true, -- dont work if action is enabled
                            logMsg = "You have been banned for trying to spawn money : %s",
                            webhook = 'YOUR-WEBHOOK-HERE'
                        },
                    },
                    limitMax = {
                        use = true, 
                        max = 20000,
                        action = {
                            use = true,  -- true = ban, false = kick, nil = disable
                            actionMsg = "You have been banned for trying to spawn money : %s"
                        },
                        log = {
                            use = true, -- dont work if action is enabled
                            logMsg = "You have been banned for trying to spawn money : %s",
                            webhook = 'YOUR-WEBHOOK-HERE'
                        },
                    },
                },
            },

        }}
    },
}
