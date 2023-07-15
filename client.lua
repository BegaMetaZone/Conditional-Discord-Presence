

local DebugDiscord = false --used for debugging , prints the process in the console
local DiscordAppId = "ApplicationId" -- The discord application id
local TurnedOn = true
local QBCore = exports['qb-core']:GetCoreObject()
local ConfigDiscord = {
    --["ApplicationId"] = 'DiscordAppID', -- The discord application id
    --["IconLarge"] = 'logo1', -- The name of the large icon
    --["IconLargeHoverText"] = 'Wake the F@$k up', -- The hover text of the large icon 
    --["IconSmall"] = 'vlogo'
    --["IconSmallHoverText"] = 'The Solo'
    ["UpdateRate"] = 9000, -- How often the player count should be updated 60000
    --["ShowPlayerCount"] = false, -- If set to true the player count will be displayed in the rich presence
    --["MaxPlayers"] = 48, -- Maximum amount of players
    ["Buttons"] = {
        {
            text = 'Enter NightCity',
            url = 'fivem://connect/5.42.223.112:30120'
        },
        {
            text = 'NCUG discord',
            url = 'https://discord.gg/YqF6nwYqqP'
        }
    }
}


local soloicon = {
    ['1'] = 'logo1',
    ['2'] = 'logo2',
    ['3'] = 'logo3',
    ['4'] = 'logo4',
    ['5'] = 'logo5',
    ['6'] = 'logo6',
    ['7'] = 'logo7',
    ['8'] = 'logo8',
    ['9'] = 'logo9',
    ['10'] = 'logo10'
}
local JobMappings = {
    ['unemployed'] = 'solo',
    ['police'] = 'police',
    ['army'] = 'maxtac',
    ['mechanic'] = 'mechanic',
    ['fbi'] = 'fbi',
    ['tuner'] = 'Tuner',
    ['batman'] = 'los',
    ['taxi'] = 'taxi'
}

local JobMappingsText = {
    ['unemployed'] = {
        [1] = 'I have the exciting job of doing absolutely nothing.',
        [2] = 'I specialize in the art of unemployment.',
        [3] = 'I am a professional couch potato.',
        [4] = 'I excel at avoiding any form of work.'
    },
    ['police'] = {
        [1] = 'I take joy in giving out speeding tickets and ruining your day.',
        [2] = 'I make sure you never have a moment of peace on the road.',
        [3] = 'I am the law, and I take pleasure in enforcing it.',
        [4] = 'I enjoy handcuffing people more than you can imagine.'
    },
    ['army'] = {
        [1] = 'I get to play with big guns and make things go boom.',
        [2] = 'I march around barking orders because I have a Napoleon complex.',
        [3] = 'I enjoy camouflage fashion more than regular clothes.',
        [4] = 'I am the one you dont want to mess with, unless you enjoy pain.'
    },
    ['mechanic'] = {
        [1] = 'I love ripping people off with exorbitant repair costs.',
        [2] = 'I fix your car just enough for it to break down again next week.',
        [3] = 'I make sure your vehicle stays in the shop longer than necessary.',
        [4] = 'I take pride in my ability to diagnose your cars problems incorrectly.'
    },
    ['fbi'] = {
        [1] = 'I spy on your online activities and judge your search history.',
        [2] = 'I wear sunglasses indoors because I think it makes me look cool.',
        [3] = 'I secretly enjoy invading your privacy for no reason at all.',
        [4] = 'I am the reason you constantly feel like someone is watching you.'
    },
    ['tuner'] = {
        [1] = 'I spend more time pimping my ride than actually driving it.',
        [2] = 'I make sure my cars engine is louder than my obnoxious personality.',
        [3] = 'I modify vehicles to compensate for my lack of personality.',
        [4] = 'I believe adding unnecessary spoilers makes me a professional racer.'
    },
    ['batman'] = {
        [1] = 'I prowl the city streets in my cape, because I have no life.',
        [2] = 'I have an unhealthy obsession with bats and a questionable fashion sense.',
        [3] = 'I fight crime while maintaining an absurdly deep voice.',
        [4] = 'I prefer spending time in my bat cave over socializing with humans.'
    },
    ['taxi'] = {
        [1] = 'I make sure to take the longest route to maximize your fare.',
        [2] = 'I provide subpar driving services with a smile on my face.',
        [3] = 'I excel at ignoring your destination preferences and taking detours.',
        [4] = 'I am the reason you develop trust issues with taxi drivers.'
    }
}

local gangMappingstext = {
    ['samurai'] = {
        [1] = 'The Samurai, rebels with a vintage beat. They are stuck in the 80s, rockin the style of a bygone era.',
        [2] = 'The Samurai, living in a time warp. They are all about rebellion and questionable fashion choices.',
        [3] = 'The Samurai, dedicated to reviving the spirit of the 80s. They may be a bit outdated, but they make some noise.',
        [4] = 'The Samurai, an edgy gang lost in nostalgia. They rock their old-school vibes and questionable hair gel.'
        },
    ['valentinos'] = {
        [1] = 'The Valentinos, tough guys with a romantic side. They will charm you with words or break your face.',
        [2] = 'The Valentinos, all about love and loyalty... until you mess with their business.',
        [3] = 'The Valentinos, passionate romantics of NightCity. Family and honor mean everything to them.',
        [4] = 'The Valentinos, a gang with a love for tradition and a flair for drama. Dont underestimate their ruthlessness.'
        },
    ['tygerclaws'] = {
        [1] = 'The Tygerclaws, flashy predators of NightCity. They are a walking fashion show with deadly weapons.',
        [2] = 'The Tygerclaws, taking fashion to the extreme. They slice and dice with style.',
        [3] = 'The Tygerclaws, masters of aesthetics and violence. They are as lethal as they are fashionable.',
        [4] = 'The Tygerclaws, a gang that combines killer looks with deadly skills. Dont underestimate their claws.'
        },
    ['sixthstreet'] = {
        [1] = 'The 6th Street gang, tough as nails and patriotic to the core. They are the muscle of NightCity, defending their version of the American dream.',
        [2] = 'The 6th Street gang, defenders of their own twisted idea of patriotism. They love guns, flags, and imposing their views on everyone else.',
        [3] = 'The 6th Street gang, a bunch of pseudo-patriots armed to the teeth. They may have their own version of the American dream, but it is far from reality.',
        [4] = 'The 6th Street gang, gun-toting self-proclaimed patriots. They are all about defending their version of freedom... by any means necessary.'
        },
    ['aldecaldos'] = {
        [1] = 'The Aldecaldos, nomads wandering the wastelands in search of a home. They are always on the move, with car troubles as their constant companions.',
        [2] = 'The Aldecaldos, the desert wanderers in constant need of a mechanic. They are more at home with sand in their boots than a permanent address.',
        [3] = 'The Aldecaldos, embracing the nomadic spirit of the desert. They may not have a fixed abode, but they have got plenty of dust in their engines.',
        [4] = 'The Aldecaldos, the gang that thrives on freedom, adventure, and perpetual car repairs. They are always on the move, but never too far from a breakdown.'
        },
    ['themox'] = {
        [1] = 'The Mox, guardians of the outcasts and rebels against injustice. They are the heroes of NightCitys underbelly, armed with compassion and style.',
        [2] = 'The Mox, rebels fighting for equality in a city ruled by corruption. They are not afraid to challenge the status quo and protect those who need it.',
        [3] = 'The Mox, the defenders of the marginalized, the voice of the voiceless. They are here to shake things up and give power back to the people.',
        [4] = 'The Mox, the gang that stands up for the downtrodden and fights against oppression. They are not just rebels, They are revolutionaries with style.'
        },
    ['scavs'] = {
        [1] = 'The Scavs, scavengers and survivors of NightCitys underbelly. They are always on the hunt for anything valuable, be it scraps or secrets.',
        [2] = 'The Scavs, the bottom feeders of NightCity. They are the ones who thrive in the shadows, finding value in the discarded and forgotten.',
        [3] = 'The Scavs, the resourceful bunch who can turn trash into treasure. They may not have much, but they know how to survive in this unforgiving city.',
        [4] = 'The Scavs, the gang that embraces the motto one mans trash is another mans treasure. They are the scavengers of NightCity, always looking for the next valuable find.'
        },
    ['wraiths'] = {
        [1] = 'The Wraiths, the ghost riders of the wasteland. They are the road warriors, tearing through the desert with their bikes and a thirst for chaos.',
        [2] = 'The Wraiths, the motorcycle-riding maniacs. They bring mayhem wherever they go, leaving a trail of dust and destruction in their wake.',
        [3] = 'The Wraiths, the gang that lives life on the edge, fueled by adrenaline and a love for the open road. They are the embodiment of chaos and freedom.',
        [4] = 'The Wraiths, the wild riders of NightCitys wasteland. They ride their bikes with reckless abandon, leaving a trail of burning rubber and shattered dreams.'
        },
    ['voodoo'] = {
        [1] = 'The Voodoo Boys, masters of the dark arts and guardians of cyberspace. They wield their hacking skills like voodoo spells, unraveling the mysteries of the net.',
        [2] = 'The Voodoo Boys, the hackers with a touch of magic. They navigate the digital realm, casting spells with lines of code and revealing the hidden truths of NightCity.',
        [3] = 'The Voodoo Boys, the gang that dances with the spirits of the net. They are the shamans of cyberspace, with a knack for bending reality and crashing servers.',
        [4] = 'The Voodoo Boys, the gang that weaves spells in the digital realm. They are the masters of cyberspace, hacking into your secrets and leaving you wondering if it was real or just a virtual illusion.'
        },
    ['maelstrom'] = {
        [1] = 'The Maelstrom, the chaos incarnate. They are a gang that is more machine than human, with a taste for cyberware and a love for causing mayhem.',
        [2] = 'The Maelstrom, a gang of cybernetic maniacs. They are all about augmenting themselves with the latest tech and spreading chaos in NightCity.',
        [3] = 'The Maelstrom, a gang that is lost touch with their humanity. They have replaced flesh with metal and embraced the dark side of technology.',
        [4] = 'The Maelstrom, the gang that is more machine than human. They haveve traded their souls for cyberware and their sanity for raw power.'
        },
    ['animals'] = {
        [1] = 'The Animals, the muscle-bound beasts of NightCity. They are all about strength, intimidation, and injecting themselves with more hormones than a livestock farm.',
        [2] = 'The Animals, the gang that is more brawn than brains. They are all about pumping iron, taking steroids, and flexing their muscles in your face.',
        [3] = 'The Animals, the living embodiment of brute force. They are all about being the biggest and strongest in NightCity, even if it means sacrificing their sanity.',
        [4] = 'The Animals, a gang that is taken bodybuilding to the extreme. They are pumped up on steroids and ready to crush anyone who gets in their way.'
    }

}






local gangMappings = {
    ['none']         = 'Make way for the Solo',
    ['solo']         = 'This is the Way',
    ['samurai']         = 'Blaze Way Down the Rebel Path',
    ['valentinos']      = 'Valentinos',
    ['tygerclaws']      = 'Tygerclaws',
    ['sixthstreet']       = '6thStreet',
    ['aldecaldos']      = 'Aldecaldos',
    ['themox']          = 'The MOX',
    ['scavs']           = 'Scavengers',
    ['wraiths']         = 'Wraiths',
    ['voodoo']          = 'Voodoo Boys',
    ['maelstrom']       = 'Maelstrom',
    ['animals']         = 'Animals'
}

local PresenceText  = "Hacked by BMZ just joking debug flag"
local AssetPic  = "samurai"
local AssetText  = "GG losers"
local smallAsset  = "sixstreet"
local smallAssetText  = "we own the streets"


local defaultText = 'The Solo'

local function isempty(s)
    return s == nil or s == ''
  end


RegisterNetEvent('SetDiscordSRP', function()
    local DiscordAppId = "DiscordAppID"

    SetDiscordAppId(DiscordAppId)
    SetRichPresence(PresenceText)
    SetDiscordRichPresenceAsset(AssetPic)
    SetDiscordRichPresenceAssetSmall(smallAsset)
    SetDiscordRichPresenceAssetSmallText(smallAssetText)
    SetDiscordRichPresenceAssetText(AssetText) -- Code goes here

end)


CreateThread(function()
    while TurnedOn == true do
        local DiscordAppId = "DiscordAppID"

        local PlayerData = QBCore.Functions.GetPlayerData() 
        local citizenid = PlayerData.citizenid  -- Without PlayerData, it's fetched by default

        local playerPed = GetPlayerPed(-1) -- Get the player's ped handle
        local Vgender = IsPedModel(GetPlayerPed(-1), "mp_f_freemode_01") and "f" or "m"
        local PlayerName = GetPlayerName(PlayerId())
        GangName = "none"
        JobName = "unemployed"
        JobLabel = "solo"

        if (PlayerData.gang and (PlayerData.gang.name ~= "none")) then
            GangName = PlayerData.gang.name
            smallAssetText = gangMappings[GangName]
            if DebugDiscord then print("gang table not empty so") end
        else
                GangName = "solo"
                if DebugDiscord then print("gang table empty or player has no gang so") end
        end
        
        if DebugDiscord then print("gangname is " .. GangName .. ".") end

        if isempty(PlayerData.job) then
            if DebugDiscord then print("job table is empty so")end
            if PlayerData.job and (PlayerData.job.onduty == false) then
                if DebugDiscord then print("when a player is not on duty") end
                DiscordBigText = PlayerName .. "doesn't need a Job!"
                if DebugDiscord then print(DiscordBigText) end
            end
        else 
            if PlayerData.job.onduty then
                JobName = PlayerData.job.name
                JobLabel = PlayerData.job.label
                smallAssetText = JobMappings[JobName]
                DiscordBigText = PlayerName .. "sold their soul to" .. JobLabel
            end
        end

        if GangName then GangPic = Vgender .. GangName .. math.random(1, 4) end
        if JobName then JobPic = Vgender .. JobName .. math.random(1, 4) else JobPic = Vgender .. "anomaly picture in JobPic" .. math.random(1, 4) end

        VehiclePic = "logo" .. math.random(1, 10)
        SoloPic = Vgender .. "solo" .. math.random(1, 4)

        local vehicle = GetVehiclePedIsUsing(playerPed) -- Get the vehicle handle
        local LastVehicle = GetLastDrivenVehicle(playerPed)
        local vehicleBrand = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetLastDrivenVehicle(GetPlayerPed(-1)))))       
        
        local randomIndex = math.random(1, 20)
        local funnySentence = ""


        if GetVehiclePedIsIn(playerPed, false) ~= 0 then
            -- Select a funny sentence based on the random index
            if randomIndex == 1 then
                funnySentence = "Yo, peep their " .. vehicleBrand .. " flexin' like a boss, lettin' the streets know they roll with that punk swagger!"
            elseif randomIndex == 2 then
                funnySentence = "Rockin' their " .. vehicleBrand .. " like a true rebel, breakin' boundaries and leavin' tire marks on society's rules!"
            elseif randomIndex == 3 then
                funnySentence = "Watch out, 'cause when they step into their " .. vehicleBrand .. ", the streets turn into their personal slam pit of punk-infused mayhem!"
            elseif randomIndex == 4 then
                funnySentence = "Cruisin' in their " .. vehicleBrand .. ", they ain't just drivin', They are unleashing a mosh pit of punk rebellion on every damn road!"
            elseif randomIndex == 5 then
                funnySentence = "Check out that " .. vehicleBrand .. "! They are tearing up the streets in style."
            elseif randomIndex == 6 then
                funnySentence = "Nothin' can contain their wild spirit when they grip that " .. vehicleBrand .. " wheel tight, blastin' through the city like a punk rocket!"
            elseif randomIndex == 7 then
                funnySentence = "With a ride like that " .. vehicleBrand .. ", They are the definition of street cred."
            elseif randomIndex == 8 then
                funnySentence = "They've mastered the art of vehicular mayhem with their trusty " .. vehicleBrand .. "."
            elseif randomIndex == 9 then
                funnySentence = "Strapped in tight, they become the punk renegade behind the wheel of their " .. vehicleBrand .. ", defyin' gravity and societal norms with each screechin' turn!"
            elseif randomIndex == 10 then
                funnySentence = "With a smirk on their face and the pedal to the metal, they become the street punk legend, ownin' the night in their ferocious " .. vehicleBrand .. "!"
            elseif randomIndex == 11 then
                funnySentence = "They are the rap god of the asphalt, droppin' beats of horsepower and takin' down opponents with style and finesse!"
            elseif randomIndex == 12 then
                funnySentence = "If the streets could talk, they'd whisper tales of that legendary " .. vehicleBrand .. "."
            elseif randomIndex == 13 then
                funnySentence = "Is it a bird? Is it a plane? No, it's just them and their kickass " .. vehicleBrand .. "."
            elseif randomIndex == 14 then
                funnySentence = "That " .. vehicleBrand .. " screams power, and they know just how to harness it."
            elseif randomIndex == 15 then
                funnySentence = "Their " .. vehicleBrand .. " is their weapon of choice, makin' rivals tremble and fans scream for more!"
            elseif randomIndex == 16 then
                funnySentence = "They are the lyrical street assassin, takin' down challengers and makin' a statement with every race!"
            elseif randomIndex == 17 then
                funnySentence = "They are the untouchable rhyme-spitter, ridin' on beats of adrenaline and takin' the crown as the ultimate street hustler!"
            elseif randomIndex == 18 then
                funnySentence = "In their " .. vehicleBrand .. ", They are the undisputed king of the concrete jungle, burnin' rubber and leavin' haters in their dust!"
            elseif randomIndex == 19 then
                funnySentence = "Driving that " .. vehicleBrand .. " like they stole it, the streets are their playground."
            elseif randomIndex == 20 then
                funnySentence = "They are the street poet, poeticizin' their moves in their " .. vehicleBrand .. ", slippin' through traffic and showin' off their skills like a true NFS MVP!"
            end
        else
            -- Select a random sentence for when not driving
            if randomIndex == 1 then
                funnySentence = "Looks like someone's afraid to unleash their " .. vehicleBrand .. " onto the streets."
            elseif randomIndex == 2 then
                funnySentence = "They are missing out on the pure exhilaration of burning rubber and turning heads."
            elseif randomIndex == 3 then
                funnySentence = "Look, I'm all for taking a leisurely stroll, but this is Night City! We're meant to tear up the streets, not dawdle around like tourists."
            elseif randomIndex == 4 then
                funnySentence = "While others ignite the asphalt with their roaring engines, they prefer a sedate stroll."
            elseif randomIndex == 5 then
                funnySentence = "They might as well be driving a tricycle with training wheels, playing it safe and dull."
            elseif randomIndex == 6 then
                funnySentence = "The streets cry out for their presence, but they choose to be a wallflower instead."
            elseif randomIndex == 7 then
                funnySentence = "Vroom vroom! Oh, wait, They are walking... what a thrilling sight."
            elseif randomIndex == 8 then
                funnySentence = "Their " .. vehicleBrand .. " might be a phoenix, ready to rise from the ashes, but it's stuck in the garage."
            elseif randomIndex == 9 then
                funnySentence = "They might not be drivin' The " .. vehicleBrand .. " at the moment, but their punk heart beats with the rhythm of the asphalt. Get ready for their next rebellious ride!"
            elseif randomIndex == 10 then
                funnySentence = "The city's vibrant energy beckons, but they prefer to embrace the mundane with open arms."
            elseif randomIndex == 11 then
                funnySentence = "Their " .. vehicleBrand .. " custom street machine waits patiently, yearning for an adventure that never comes."
            elseif randomIndex == 12 then
                funnySentence = "In this city of dreams, They are living a nightmare by leaving their " .. vehicleBrand .. " at home."
            elseif randomIndex == 13 then
                funnySentence = "Oh, the tragedy of their's " .. vehicleBrand .. " dormant horsepower, silently weeping in the parking lot."
            elseif randomIndex == 14 then
                funnySentence = "Hey, choomba, you're just strolling around like a lost puppy. Where's your " .. vehicleBrand .. ", huh? Scared of a little action?"
            elseif randomIndex == 15 then
                funnySentence = "You're missing out, my friend. The city is alive with the sound of engines, but you choose to be a spectator."
            elseif randomIndex == 16 then
                funnySentence = "You know, the city has its own rhythm, and it's not a slow, monotonous walk. It's the pulse of engines and burning rubber."
            elseif randomIndex == 17 then
                funnySentence = "Well, well, look who's taking a leisurely stroll. If you're not careful, you'll become the city's next punchline."
            elseif randomIndex == 18 then
                funnySentence = "They might not be drivin' the " .. vehicleBrand .. " at the moment, but their punk heart beats with the rhythm of the asphalt. Get ready for their next rebellious ride!"
            elseif randomIndex == 19 then
                funnySentence = "Walking? Seriously? You're missing the whole damn point! The city is a playground, and you're sitting on the sidelines like a chump."
            elseif randomIndex == 20 then
                funnySentence = "I've seen jellyfish with more backbone than you. Get that " .. vehicleBrand .. " out of garage , hit the gas, and show this city what you're made of!"
            end
        end
        
        if GetVehiclePedIsIn(playerPed, false) == 0 then 
            --if DebugDiscord then print(GangName)
            if PlayerData.job then 
                if PlayerData.job.onduty == false then
                    -- player not on duty 
                    if DebugDiscord then print("Is unemployed and off duty!") end
                    if GangName ~= "solo" then
                        -- player is in a registred gang
                        
                        --if GangName and (GangName ~= "solo") then if DebugDiscord then print(gangMappingstext[GangName][math.random(1, 4)]) end
                        --SetDiscordRichPresenceAsset(GangPic)
                        if DebugDiscord then print("so counts as a member of " .. GangName) end

                        if DebugDiscord then print(GangPic) end
                        GangName = PlayerData.gang.name
                        GangPic = Vgender .. GangName .. math.random(1, 4)
                        GangText = gangMappingstext[GangName][math.random(1, 4)]
                        if DebugDiscord then print(GangText) end
                        --AssetText = "'" .. GangText .. "'"
                        DiscordBigPic = GangPic
                        PresenceText  = funnySentence
                        AssetPic  = GangPic
                        AssetText  = "One does not simply fuck with Nightcity gangs"
                        smallAsset  = GangName
                        smallAssetText  = GangName
                        if DebugDiscord then print("Pic is stored") end
                        SetDiscordAppId(DiscordAppId)
                        SetRichPresence(PresenceText)
                        SetDiscordRichPresenceAsset(AssetPic)
                        SetDiscordRichPresenceAssetText(AssetText) -- Code goes here
                        SetDiscordRichPresenceAssetSmall(smallAsset)
                        SetDiscordRichPresenceAssetSmallText(smallAssetText)
                        --TriggerClientEvent('SetDiscordSRP')
                        --- aux --- is gang ---gangMappingstext
                    else
                        -- player is without a gang and unemployed or off duty
                        if DebugDiscord then print("Is Solo") end
                        if DebugDiscord then print(SoloPic) end
                        DiscordBigPic = SoloPic
                        PresenceText  = funnySentence
                        AssetPic  = SoloPic
                        AssetText  = "This is the way"
                        smallAsset  = "vlogo"
                        smallAssetText  = "Storms the Arasaka tower for fun!"
                        if DebugDiscord then print("Pic is stored") end
                        SetDiscordAppId(DiscordAppId)
                        SetRichPresence(PresenceText)
                        SetDiscordRichPresenceAsset(AssetPic)
                        SetDiscordRichPresenceAssetText(AssetText) -- Code goes here 
                        SetDiscordRichPresenceAssetSmall(smallAsset)
                        SetDiscordRichPresenceAssetSmallText(smallAssetText)
                        --TriggerClientEvent('SetDiscordSRP')

                    end
                else
                    -- player is on duty on JobName civil job 
                    if JobName ~= "unemployed" then 
                        JobName = PlayerData.job.name
                        JobPic = Vgender .. JobName .. math.random(1, 4)
                        if DebugDiscord then print("Employed as " .. JobPic) end
                        DiscordBigPic = JobPic
                        PresenceText  = funnySentence
                        AssetPic  = JobPic
                        AssetText  = JobMappingsText[JobName][math.random(1, 4)]
                        smallAsset  = "samurai"
                        smallAssetText  = JobName
                        if DebugDiscord then print("Pic is stored") end
                        SetDiscordAppId(DiscordAppId)
                        SetRichPresence(PresenceText)
                        SetDiscordRichPresenceAsset(AssetPic)
                        SetDiscordRichPresenceAssetText(AssetText) -- Code goes here
                        SetDiscordRichPresenceAssetSmall(smallAsset)
                        SetDiscordRichPresenceAssetSmallText(smallAssetText)
                        --TriggerClientEvent('SetDiscordSRP')

                        -- job aux -- JobMappingsText.JobName.math.random(1, 4)
                        
                    else
                        ---
                        if GangName ~= "solo" then
                            -- player is in a registred gang
                            if DebugDiscord then print("on civil duty but still counts as a member of " .. GangName) end
    
                            if DebugDiscord then print(GangPic) end
    
                            -- if GangName and (GangName ~= "solo") then if DebugDiscord then print(gangMappingstext[GangName][math.random(1, 4)]) end
                            --SetDiscordRichPresenceAsset(GangPic)
                            GangName = PlayerData.gang.name
                            GangPic = Vgender .. GangName .. math.random(1, 4)
                            DiscordBigPic = GangPic
                            PresenceText  = funnySentence
                            AssetPic  = GangPic
                            GangText = gangMappingstext[GangName][math.random(1, 4)]
                            --AssetText = "'" .. GangText .. "'"
                            AssetText  = "One does not simply fuck with Nightcity gangs"
                            smallAsset  = GangName
                            smallAssetText  = GangName
                            if DebugDiscord then print("Pic is stored") end
                            SetDiscordAppId(DiscordAppId)
                            SetRichPresence(PresenceText)
                            SetDiscordRichPresenceAsset(AssetPic)
                            SetDiscordRichPresenceAssetText(AssetText) -- Code goes here
                            SetDiscordRichPresenceAssetSmall(smallAsset)
                            SetDiscordRichPresenceAssetSmallText(smallAssetText)
                            -- TriggerClientEvent('SetDiscordSRP')

                            --- aux --- is gang ---gangMappingstext
                        else
                            -- player is without a gang and unemployed or off duty
                            if DebugDiscord then print("Is Solo") end
                            if DebugDiscord then print(SoloPic) end
                            DiscordBigPic = SoloPic
                            PresenceText  = funnySentence
                            AssetPic  = SoloPic
                            AssetText  = "Storms the Arasaka tower for fun!"
                            smallAsset  = "vlogo"
                            smallAssetText  = "This is the way"
                            if DebugDiscord then print("Pic is stored") end
                            -- TriggerClientEvent('SetDiscordSRP')
                            SetDiscordAppId(DiscordAppId)
                            SetRichPresence(PresenceText)
                            SetDiscordRichPresenceAsset(AssetPic)
                            SetDiscordRichPresenceAssetText(AssetText) 
                            SetDiscordRichPresenceAssetSmall(smallAsset)
                            SetDiscordRichPresenceAssetSmallText(smallAssetText)

                        end
                        --if DebugDiscord then print("how did you get here ??")
                        --print ("<<anomaly>>")
                    end
                end 
            else
                PresenceText  = funnySentence
                AssetPic  = "logo4"
                AssetText  = "Entering NightCity"
                smallAsset  = "samurai"
                smallAssetText  = "Blaze way down the rebel path"
                if DebugDiscord then print("<<anomaly2>> player data table nil") end
                SetDiscordAppId(DiscordAppId)
                SetRichPresence(PresenceText)
                SetDiscordRichPresenceAsset(AssetPic)
                SetDiscordRichPresenceAssetText(AssetText) -- Code goes here
                SetDiscordRichPresenceAssetSmall(smallAsset)
                SetDiscordRichPresenceAssetSmallText(smallAssetText)
                --TriggerClientEvent('SetDiscordSRP')
            end
        else
            if DebugDiscord then print("Is driving" .. VehiclePic) end
            DiscordBigPic = VehiclePic
            PresenceText  = funnySentence
            AssetPic  = VehiclePic
            AssetText  = "Smell's like burnt rubber on petrol"
            smallAsset  = "samurai"
            smallAssetText  = "Blaze way down the rebel path"
            SetDiscordAppId(DiscordAppId)
            SetRichPresence(PresenceText)
            SetDiscordRichPresenceAsset(AssetPic)
            SetDiscordRichPresenceAssetSmall(smallAsset)
            SetDiscordRichPresenceAssetSmallText(smallAssetText)
            SetDiscordRichPresenceAssetText(AssetText) -- Code goes here
            --TriggerClientEvent('SetDiscordSRP')
        end

        -- debug 
        if DiscordBigPic then 
            if DebugDiscord then print("DiscordBigPic >>" .. DiscordBigPic) end
        else
            if DebugDiscord then print("no DiscordBigPic >>") end
        end

        --SetDiscordRichPresenceAssetText(DiscordBigText)

        ---------------------------------------------------------------
   
        -- Display the selected funny sentence
        
        
        --[[if conf.ShowPlayerCount then
            QBCore.Functions.TriggerCallback('smallresources:server:GetCurrentPlayers', function(result)
                SetRichPresence('Chooms: ' .. result .. '/' .. conf.MaxPlayers)
            end)
        end]]--

        if ConfigDiscord.Buttons and type(ConfigDiscord.Buttons) == "table" then
            for i,v in pairs(ConfigDiscord.Buttons) do
                SetDiscordRichPresenceAction(i - 1,
                    v.text,
                    v.url
                )
            end
        end
        -- dubug
    

        
        if DebugDiscord then print("SoloPic >>" .. SoloPic) end
        if DebugDiscord then print("VehiclePic >>" .. VehiclePic) end
        if GangPic then 
            if DebugDiscord then print("GangPic >>" .. GangPic) end
        else 
            if DebugDiscord then print("no gangpic :( >>") end
        end
        if JobPic then 
            if DebugDiscord then print("JobPic >>" .. JobPic) end
        else 
            if DebugDiscord then print("no jobpic :( >>") end
        end
        
        if DiscordBigText then 
            if DebugDiscord then print("DiscordBigText " .. DiscordBigText) end
        else 
            if DebugDiscord then print("no big text :/ >>") end
        end

        Wait(ConfigDiscord.UpdateRate)

    end
end)
