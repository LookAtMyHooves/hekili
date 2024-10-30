-- DeathKnightFrost.lua
-- July 2024

if UnitClassBase( "player" ) ~= "DEATHKNIGHT" then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State

local PTR = ns.PTR

local strformat = string.format

local spec = Hekili:NewSpecialization( 251 )

spec:RegisterResource( Enum.PowerType.Runes, {
    rune_regen = {
        last = function ()
            return state.query_time
        end,

        interval = function( time, val )
            local r = state.runes
            val = math.floor( val )

            if val == 6 then return -1 end
            return r.expiry[ val + 1 ] - time
        end,

        stop = function( x )
            return x == 6
        end,

        value = 1
    },

    empower_rune = {
        aura = "empower_rune_weapon",

        last = function ()
            return state.buff.empower_rune_weapon.applied + floor( ( state.query_time - state.buff.empower_rune_weapon.applied ) / 5 ) * 5
        end,

        stop = function ( x )
            return x == 6
        end,

        interval = 5,
        value = 1
    },
}, setmetatable( {
    expiry = { 0, 0, 0, 0, 0, 0 },
    cooldown = 10,
    regen = 0,
    max = 6,
    forecast = {},
    fcount = 0,
    times = {},
    values = {},
    resource = "runes",

    reset = function()
        local t = state.runes

        for i = 1, 6 do
            local start, duration, ready = GetRuneCooldown( i )

            start = start or 0
            duration = duration or ( 10 * state.haste )

            t.expiry[ i ] = ready and 0 or start + duration
            t.cooldown = duration
        end

        table.sort( t.expiry )

        t.actual = nil
    end,

    gain = function( amount )
        local t = state.runes

        for i = 1, amount do
            t.expiry[ 7 - i ] = 0
        end
        table.sort( t.expiry )

        t.actual = nil
    end,

    spend = function( amount )
        local t = state.runes

        for i = 1, amount do
            t.expiry[ 1 ] = ( t.expiry[ 4 ] > 0 and t.expiry[ 4 ] or state.query_time ) + t.cooldown
            table.sort( t.expiry )
        end

        state.gain( amount * 10, "runic_power" )

        if state.talent.gathering_storm.enabled and state.buff.remorseless_winter.up then
            state.buff.remorseless_winter.expires = state.buff.remorseless_winter.expires + ( 0.5 * amount )
        end

        t.actual = nil
    end,

    timeTo = function( x )
        return state:TimeToResource( state.runes, x )
    end,
}, {
    __index = function( t, k, v )
        if k == "actual" then
            local amount = 0

            for i = 1, 6 do
                if t.expiry[ i ] <= state.query_time then
                    amount = amount + 1
                end
            end

            return amount

        elseif k == "current" then
            -- If this is a modeled resource, use our lookup system.
            if t.forecast and t.fcount > 0 then
                local q = state.query_time
                local index, slice

                if t.values[ q ] then return t.values[ q ] end

                for i = 1, t.fcount do
                    local v = t.forecast[ i ]
                    if v.t <= q then
                        index = i
                        slice = v
                    else
                        break
                    end
                end

                -- We have a slice.
                if index and slice then
                    t.values[ q ] = max( 0, min( t.max, slice.v ) )
                    return t.values[ q ]
                end
            end

            return t.actual

        elseif k == "deficit" then
            return t.max - t.current

        elseif k == "time_to_next" then
            return t[ "time_to_" .. t.current + 1 ]

        elseif k == "time_to_max" then
            return t.current == 6 and 0 or max( 0, t.expiry[6] - state.query_time )

        elseif k == "add" then
            return t.gain

        else
            local amount = k:match( "time_to_(%d+)" )
            amount = amount and tonumber( amount )

            if amount then return state:TimeToResource( t, amount ) end
        end
    end
} ) )

spec:RegisterResource( Enum.PowerType.RunicPower, {
    breath = {
        talent = "breath_of_sindragosa",
        aura = "breath_of_sindragosa",

        last = function ()
            return state.buff.breath_of_sindragosa.applied + floor( state.query_time - state.buff.breath_of_sindragosa.applied )
        end,

        stop = function ( x ) return x < 16 end,

        interval = 1,
        value = -16
    },

    empower_rp = {
        aura = "empower_rune_weapon",

        last = function ()
            return state.buff.empower_rune_weapon.applied + floor( ( state.query_time - state.buff.empower_rune_weapon.applied ) / 5 ) * 5
        end,

        interval = 5,
        value = 5
    },

    swarming_mist = {
        aura = "swarming_mist",

        last = function ()
            return state.buff.swarming_mist.applied + floor( state.query_time - state.buff.swarming_mist.applied )
        end,

        interval = 1,
        value = function () return min( 15, state.true_active_enemies * 3 ) end,
    },
} )

-- Talents
spec:RegisterTalents( {
    -- DeathKnight
    abomination_limb            = {  76049, 383269, 1 }, -- Sprout an additional limb, dealing 54,565 Shadow damage over 12 sec to all nearby enemies. Deals reduced damage beyond 5 targets. Every 1 sec, an enemy is pulled to your location if they are further than 8 yds from you. The same enemy can only be pulled once every 4 sec.
    antimagic_barrier           = {  76046, 205727, 1 }, -- Reduces the cooldown of Anti-Magic Shell by 20 sec and increases its duration and amount absorbed by 40%.
    antimagic_zone              = {  76065,  51052, 1 }, -- Places an Anti-Magic Zone that reduces spell damage taken by party or raid members by 20%. The Anti-Magic Zone lasts for 8 sec or until it absorbs 1.3 million damage.
    asphyxiate                  = {  76064, 221562, 1 }, -- Lifts the enemy target off the ground, crushing their throat with dark energy and stunning them for 5 sec.
    assimilation                = {  76048, 374383, 1 }, -- The amount absorbed by Anti-Magic Zone is increased by 10% and its cooldown is reduced by 30 sec.
    blinding_sleet              = {  76044, 207167, 1 }, -- Targets in a cone in front of you are blinded, causing them to wander disoriented for 5 sec. Damage may cancel the effect. When Blinding Sleet ends, enemies are slowed by 50% for 6 sec.
    blood_draw                  = {  76056, 374598, 1 }, -- When you fall below 30% health you drain 17,735 health from nearby enemies, the damage you take is reduced by 10% and your Death Strike cost is reduced by 10 for 8 sec. Can only occur every 2 min.
    blood_scent                 = {  76078, 374030, 1 }, -- Increases Leech by 3%.
    brittle                     = {  76061, 374504, 1 }, -- Your diseases have a chance to weaken your enemy causing your attacks against them to deal 6% increased damage for 5 sec.
    cleaving_strikes            = {  76073, 316916, 1 }, -- Obliterate hits up to 2 additional enemies while you remain in Death and Decay. When leaving your Death and Decay you retain its bonus effects for 4 sec.
    coldthirst                  = {  76083, 378848, 1 }, -- Successfully interrupting an enemy with Mind Freeze grants 10 Runic Power and reduces its cooldown by 3 sec.
    control_undead              = {  76059, 111673, 1 }, -- Dominates the target undead creature up to level 71, forcing it to do your bidding for 5 min.
    death_pact                  = {  76075,  48743, 1 }, -- Create a death pact that heals you for 50% of your maximum health, but absorbs incoming healing equal to 30% of your max health for 15 sec.
    death_strike                = {  76071,  49998, 1 }, -- Focuses dark power into a strike with both weapons, that deals a total of 8,500 Physical damage and heals you for 40.00% of all damage taken in the last 5 sec, minimum 11.2% of maximum health.
    deaths_echo                 = { 102007, 356367, 1 }, -- Death's Advance, Death and Decay, and Death Grip have 1 additional charge.
    deaths_reach                = { 102006, 276079, 1 }, -- Increases the range of Death Grip by 10 yds. Killing an enemy that yields experience or honor resets the cooldown of Death Grip.
    enfeeble                    = {  76060, 392566, 1 }, -- Your ghoul's attacks have a chance to apply Enfeeble, reducing the enemies movement speed by 30% and the damage they deal to you by 12% for 6 sec.
    gloom_ward                  = {  76052, 391571, 1 }, -- Absorbs are 15% more effective on you.
    grip_of_the_dead            = {  76057, 273952, 1 }, -- Death and Decay reduces the movement speed of enemies within its area by 90%, decaying by 10% every sec.
    ice_prison                  = {  76086, 454786, 1 }, -- Chains of Ice now also roots enemies for 4 sec but its cooldown is increased to 12 sec.
    icebound_fortitude          = {  76081,  48792, 1 }, -- Your blood freezes, granting immunity to Stun effects and reducing all damage you take by 30% for 8 sec.
    icy_talons                  = {  76085, 194878, 1 }, -- Your Runic Power spending abilities increase your melee attack speed by 6% for 10 sec, stacking up to 5 times.
    improved_death_strike       = {  76067, 374277, 1 }, -- Death Strike's cost is reduced by 10, and its healing is increased by 60%.
    insidious_chill             = {  76051, 391566, 1 }, -- Your auto-attacks reduce the target's auto-attack speed by 5% for 30 sec, stacking up to 4 times.
    march_of_darkness           = {  76074, 391546, 1 }, -- Death's Advance grants an additional 25% movement speed over the first 3 sec.
    mind_freeze                 = {  76084,  47528, 1 }, -- Smash the target's mind with cold, interrupting spellcasting and preventing any spell in that school from being cast for 3 sec.
    null_magic                  = { 102008, 454842, 1 }, -- Magic damage taken is reduced by 8% and the duration of harmful Magic effects against you are reduced by 35%.
    osmosis                     = {  76088, 454835, 1 }, -- Anti-Magic Shell increases healing received by 15%.
    permafrost                  = {  76066, 207200, 1 }, -- Your auto attack damage grants you an absorb shield equal to 40% of the damage dealt.
    proliferating_chill         = { 101708, 373930, 1 }, -- Chains of Ice affects 1 additional nearby enemy.
    raise_dead                  = {  76072,  46585, 1 }, -- Raises a ghoul to fight by your side. You can have a maximum of one ghoul at a time. Lasts 1 min.
    rune_mastery                = {  76079, 374574, 2 }, -- Consuming a Rune has a chance to increase your Strength by 3% for 8 sec.
    runic_attenuation           = {  76045, 207104, 1 }, -- Auto attacks have a chance to generate 3 Runic Power.
    runic_protection            = {  76055, 454788, 1 }, -- Your chance to be critically struck is reduced by 3% and your Armor is increased by 6%.
    sacrificial_pact            = {  76060, 327574, 1 }, -- Sacrifice your ghoul to deal 11,084 Shadow damage to all nearby enemies and heal for 25% of your maximum health. Deals reduced damage beyond 8 targets.
    soul_reaper                 = {  76063, 343294, 1 }, -- Strike an enemy for 9,914 Shadowfrost damage and afflict the enemy with Soul Reaper. After 5 sec, if the target is below 35% health this effect will explode dealing an additional 45,489 Shadowfrost damage to the target. If the enemy that yields experience or honor dies while afflicted by Soul Reaper, gain Runic Corruption.
    subduing_grasp              = {  76080, 454822, 1 }, -- When you pull an enemy, the damage they deal to you is reduced by 6% for 6 sec.
    suppression                 = {  76087, 374049, 1 }, -- Damage taken from area of effect attacks reduced by 3%. When suffering a loss of control effect, this bonus is increased by an additional 6% for 6 sec.
    unholy_bond                 = {  76076, 374261, 1 }, -- Increases the effectiveness of your Runeforge effects by 20%.
    unholy_endurance            = {  76058, 389682, 1 }, -- Increases Lichborne duration by 2 sec and while active damage taken is reduced by 15%.
    unholy_ground               = {  76069, 374265, 1 }, -- Gain 5% Haste while you remain within your Death and Decay.
    unyielding_will             = {  76050, 457574, 1 }, -- Anti-Magic shell now removes all harmful magical effects when activated, but it's cooldown is increased by 20 sec.
    vestigial_shell             = {  76053, 454851, 1 }, -- Casting Anti-Magic Shell grants 2 nearby allies a Lesser Anti-Magic Shell that Absorbs up to 55,050 magic damage and reduces the duration of harmful Magic effects against them by 50%.
    veteran_of_the_third_war    = {  76068,  48263, 1 }, -- Stamina increased by 20%.
    will_of_the_necropolis      = {  76054, 206967, 2 }, -- Damage taken below 30% Health is reduced by 20%.
    wraith_walk                 = {  76077, 212552, 1 }, -- Embrace the power of the Shadowlands, removing all root effects and increasing your movement speed by 70% for 4 sec. Taking any action cancels the effect. While active, your movement speed cannot be reduced below 170%.

    -- Deathbringer
    absolute_zero               = { 102009, 377047, 1 }, -- Frostwyrm's Fury has 50% reduced cooldown and Freezes all enemies hit for 3 sec.
    arctic_assault              = {  76091, 456230, 1 }, -- Consuming Killing Machine fires a Glacial Advance through your target at 80% effectiveness.
    avalanche                   = {  76105, 207142, 1 }, -- Casting Howling Blast with Rime active causes jagged icicles to fall on enemies nearby your target, applying Razorice and dealing 4,963 Frost damage.
    biting_cold                 = {  76111, 377056, 1 }, -- Remorseless Winter damage is increased by 35%. The first time Remorseless Winter deals damage to 3 different enemies, you gain Rime.
    bonegrinder                 = {  76122, 377098, 2 }, -- Consuming Killing Machine grants 1% critical strike chance for 10 sec, stacking up to 5 times. At 5 stacks your next Killing Machine consumes the stacks and grants you 10% increased Frost damage for 10 sec.
    breath_of_sindragosa        = {  76093, 152279, 1 }, -- Continuously deal 25,472 Frost damage every 1 sec to enemies in a cone in front of you, until your Runic Power is exhausted. Deals reduced damage to secondary targets. Generates 2 Runes at the start and end.
    chill_streak                = {  76098, 305392, 1 }, -- Deals 25,420 Frost damage to the target and reduces their movement speed by 70% for 4 sec. Chill Streak bounces up to 12 times between closest targets within 10 yards.
    cold_heart                  = {  76035, 281208, 1 }, -- Every 2 sec, gain a stack of Cold Heart, causing your next Chains of Ice to deal 2,481 Frost damage. Stacks up to 20 times.
    cryogenic_chamber           = {  76109, 456237, 1 }, -- Each time Frost Fever deals damage, 15% of the damage dealt is gathered into the next cast of Remorseless Winter, up to 20 times.
    empower_rune_weapon         = {  76110,  47568, 1 }, -- Empower your rune weapon, gaining 15% Haste and generating 1 Rune and 5 Runic Power instantly and every 5 sec for 20 sec.
    enduring_chill              = {  76097, 377376, 1 }, -- Chill Streak's bounce range is increased by 2 yds and each time Chill Streak bounces it has a 25% chance to increase the maximum number of bounces by 1.
    enduring_strength           = {  76100, 377190, 1 }, -- When Pillar of Frost expires, your Strength is increased by 15% for 6 sec. This effect lasts 2 sec longer for each Obliterate and Frostscythe critical strike during Pillar of Frost.
    everfrost                   = {  76113, 376938, 1 }, -- Remorseless Winter deals 6% increased damage to enemies it hits, stacking up to 10 times.
    frigid_executioner          = {  76120, 377073, 1 }, -- Obliterate deals 15% increased damage and has a 15% chance to refund 2 runes.
    frost_strike                = {  76115,  49143, 1 }, -- Chill your weapon with icy power and quickly strike the enemy, dealing 26,260 Frost damage.
    frostscythe                 = {  76096, 207230, 1 }, -- A sweeping attack that strikes all enemies in front of you for 18,880 Frost damage. This attack always critically strikes and critical strikes with Frostscythe deal 4 times normal damage. Deals reduced damage beyond 5 targets. Consuming Killing Machine reduces the cooldown of Frostscythe by 1.0 sec.
    frostwhelps_aid             = {  76106, 377226, 1 }, -- Pillar of Frost summons a Frostwhelp who breathes on all enemies within 40 yards in front of you for 9,278 Frost damage. Each unique enemy hit by Frostwhelp's Aid grants you 8% Mastery for 15 sec, up to 40%.
    frostwyrms_fury             = { 101931, 279302, 1 }, -- Summons a frostwyrm who breathes on all enemies within 40 yd in front of you, dealing 81,901 Frost damage and slowing movement speed by 50% for 10 sec.
    gathering_storm             = {  76099, 194912, 1 }, -- Each Rune spent during Remorseless Winter increases its damage by 10%, and extends its duration by 0.5 sec.
    glacial_advance             = {  76092, 194913, 1 }, -- Summon glacial spikes from the ground that advance forward, each dealing 10,985 Frost damage and applying Razorice to enemies near their eruption point.
    horn_of_winter              = {  76089,  57330, 1 }, -- Blow the Horn of Winter, gaining 2 Runes and generating 25 Runic Power.
    howling_blast               = {  76114,  49184, 1 }, -- Blast the target with a frigid wind, dealing 4,770 Frost damage to that foe, and reduced damage to all other enemies within 10 yards, infecting all targets with Frost Fever.  Frost Fever A disease that deals 57,047 Frost damage over 24 sec and has a chance to grant the Death Knight 5 Runic Power each time it deals damage.
    hyperpyrexia                = {  76108, 456238, 1 }, -- Your Runic Power spending abilities have a chance to additionally deal 45% of the damage dealt over 4 sec.
    icebreaker                  = {  76033, 392950, 2 }, -- When empowered by Rime, Howling Blast deals 30% increased damage to your primary target.
    icecap                      = { 101930, 207126, 1 }, -- Reduces Pillar of Frost cooldown by 15 sec.
    icy_death_torrent           = { 101933, 435010, 1 }, -- Your auto attack critical strikes have a chance to send out a torrent of ice dealing 24,555 Frost damage to enemies in front of you.
    improved_frost_strike       = {  76103, 316803, 2 }, -- Increases Frost Strike damage by 10%.
    improved_obliterate         = {  76119, 317198, 1 }, -- Increases Obliterate damage by 10%.
    improved_rime               = {  76112, 316838, 1 }, -- Increases Howling Blast damage done by an additional 75%.
    inexorable_assault          = {  76037, 253593, 1 }, -- Gain Inexorable Assault every 8 sec, stacking up to 5 times. Obliterate consumes a stack to deal an additional 5,815 Frost damage.
    killing_machine             = {  76117,  51128, 1 }, -- Your auto attack critical strikes have a chance to make your next Obliterate deal Frost damage and critically strike.
    murderous_efficiency        = {  76121, 207061, 1 }, -- Consuming the Killing Machine effect has a 25% chance to grant you 1 Rune.
    obliterate                  = {  76116,  49020, 1 }, -- A brutal attack that deals 28,347 Physical damage.
    obliteration                = {  76123, 281238, 1 }, -- While Pillar of Frost is active, Frost Strike Soul Reaper, and Howling Blast always grant Killing Machine and have a 30% chance to generate a Rune. to deal additional damage.
    piercing_chill              = {  76097, 377351, 1 }, -- Enemies suffer 12% increased damage from Chill Streak each time they are struck by it.
    pillar_of_frost             = { 101929,  51271, 1 }, -- The power of frost increases your Strength by 30% for 12 sec.
    rage_of_the_frozen_champion = {  76120, 377076, 1 }, -- Obliterate has a 15% increased chance to trigger Rime and Howling Blast generates 6 Runic Power while Rime is active.
    runic_command               = {  76102, 376251, 2 }, -- Increases your maximum Runic Power by 5.
    shattered_frost             = {  76094, 455993, 1 }, -- When Frost Strike consumes 5 Razorice stacks, it deals 60% of the damage dealt to nearby enemies. Deals reduced damage beyond 8 targets.
    shattering_blade            = {  76095, 207057, 1 }, -- When Frost Strike damages an enemy with 5 stacks of Razorice it will consume them to deal an additional 115% damage.
    smothering_offense          = {  76101, 435005, 1 }, -- Your auto attack damage is increased by 10%. This amount is increased for each stack of Icy Talons you have and it can stack up to 2 additional times.
    the_long_winter             = { 101932, 456240, 1 }, -- While Pillar of Frost is active your auto-attack critical strikes increase its duration by 2 sec, up to a maximum of 6 sec.
    unleashed_frenzy            = {  76118, 376905, 1 }, -- Damaging an enemy with a Runic Power ability increases your Strength by 2% for 10 sec, stacks up to 3 times.

    -- Rider of the Apocalypse
    a_feast_of_souls            = {  95042, 444072, 1 }, -- While you have 2 or more Horsemen aiding you, your Runic Power spending abilities deal 20% increased damage.
    apocalypse_now              = {  95041, 444040, 1 }, -- Army of the Dead and Frostwyrm's Fury call upon all 4 Horsemen to aid you for 20 sec.
    death_charge                = {  95060, 444010, 1 }, -- Call upon your Death Charger to break free of movement impairment effects. For 10 sec, while upon your Death Charger your movement speed is increased by 100%, you cannot be slowed below 100% of normal speed, and you are immune to forced movement effects and knockbacks.
    fury_of_the_horsemen        = {  95042, 444069, 1 }, -- Every 50 Runic Power you spend extends the duration of the Horsemen's aid in combat by 1 sec, up to 5 sec.
    horsemens_aid               = {  95037, 444074, 1 }, -- While at your aid, the Horsemen will occasionally cast Anti-Magic Shell on you and themselves at 80% effectiveness. You may only benefit from this effect every 45 sec.
    hungering_thirst            = {  95044, 444037, 1 }, -- The damage of your diseases and Frost Strike are increased by 10%.
    mawsworn_menace             = {  95054, 444099, 1 }, -- Obliterate deals 10% increased damage and the cooldown of your Death and Decay is reduced by 10 sec.
    mograines_might             = {  95067, 444047, 1 }, -- Your damage is increased by 5% and you gain the benefits of your Death and Decay while inside Mograine's Death and Decay.
    nazgrims_conquest           = {  95059, 444052, 1 }, -- If an enemy dies while Nazgrim is active, the strength of Apocalyptic Conquest is increased by 3%. Additionally, each Rune you spend increase its value by 1%.
    on_a_paler_horse            = {  95060, 444008, 1 }, -- While outdoors you are able to mount your Acherus Deathcharger in combat.
    pact_of_the_apocalypse      = {  95037, 444083, 1 }, -- When you take damage, 5% of the damage is redirected to each active horsemen.
    riders_champion             = {  95066, 444005, 1, "rider_of_the_apocalypse" }, -- Spending Runes has a chance to call forth the aid of a Horsemen for 10 sec. Mograine Casts Death and Decay at his location that follows his position. Whitemane Casts Undeath on your target dealing 2,608 Shadowfrost damage per stack every 3 sec, for 24 sec. Each time Undeath deals damage it gains a stack. Cannot be Refreshed. Trollbane Casts Chains of Ice on your target slowing their movement speed by 40% and increasing the damage they take from you by 5% for 8 sec. Nazgrim While Nazgrim is active you gain Apocalyptic Conquest, increasing your Strength by 5%.
    trollbanes_icy_fury         = {  95063, 444097, 1 }, -- Obliterate shatters Trollbane's Chains of Ice when hit, dealing 31,015 Shadowfrost damage to nearby enemies, and slowing them by 40% for 4 sec. Deals reduced damage beyond 8 targets.
    whitemanes_famine           = {  95047, 444033, 1 }, -- When Obliterate damages an enemy affected by Undeath it gains 1 stack and infects another nearby enemy.

    -- Deathbringer
    bind_in_darkness            = {  95043, 440031, 1 }, -- Rime empowered Howling Blast deals 30% increased damage to its main target, and is now Shadowfrost. Shadowfrost damage applies 2 stacks to Reaper's Mark and 4 stacks when it is a critical strike.
    dark_talons                 = {  95057, 436687, 1 }, -- Consuming Killing Machine or Rime has a 25% chance to grant 3 stacks of Icy Talons and increase its maximum stacks by the same amount for 6 sec. Runic Power spending abilities count as Shadowfrost while Icy Talons is active.
    deaths_messenger            = {  95049, 437122, 1 }, -- Reduces the cooldowns of Lichborne and Raise Dead by 30 sec.
    expelling_shield            = {  95049, 439948, 1 }, -- When an enemy deals direct damage to your Anti-Magic Shell, their cast speed is reduced by 10% for 6 sec.
    exterminate                 = {  95068, 441378, 1 }, -- After Reaper's Mark explodes, your next 2 Obliterates cost 1 Rune and summon 2 scythes to strike your enemies. The first scythe strikes your target for 74,146 Shadowfrost damage and has a 30% chance to apply Reaper's Mark, the second scythe strikes all enemies around your target for 25,308 Shadowfrost damage. Deals reduced damage beyond 8 targets.
    grim_reaper                 = {  95034, 434905, 1 }, -- Reaper's Mark initial strike grants Killing Machine. Reaper's Mark explosion deals up to 30% increased damage based on your target's missing health.
    pact_of_the_deathbringer    = {  95035, 440476, 1 }, -- When you suffer a damaging effect equal to 25% of your maximum health, you instantly cast Death Pact at 50% effectiveness. May only occur every 2 min. When a Reaper's Mark explodes, the cooldowns of this effect and Death Pact are reduced by 5 sec.
    reaper_of_souls             = {  95034, 440002, 1 }, -- When you apply Reaper's Mark, the cooldown of Soul Reaper is reset, your next Soul Reaper costs no runes, and it explodes on the target regardless of their health. Soul Reaper damage is increased by 20%.
    reapers_mark                = {  95062, 439843, 1, "deathbringer" }, -- Viciously slice into the soul of your enemy, dealing 55,138 Shadowfrost damage and applying Reaper's Mark. Each time you deal Shadow or Frost damage, add a stack of Reaper's Mark. After 12 sec or reaching 40 stacks, the mark explodes, dealing 4,233 damage per stack. Reaper's Mark travels to an unmarked enemy nearby if the target dies, or explodes below 35% health when there are no enemies to travel to. This explosion cannot occur again on a target for 3 min.
    reapers_onslaught           = {  95057, 469870, 1 }, -- Reduces the cooldown of Reaper's Mark by 15 sec, but the amount of Obliterates empowered by Exterminate is reduced by 1.
    rune_carved_plates          = {  95035, 440282, 1 }, -- Each Rune spent reduces the magic damage you take by 1.5% and each Rune generated reduces the physical damage you take by 1.5% for 5 sec, up to 5 times.
    soul_rupture                = {  95061, 437161, 1 }, -- When Reaper's Mark explodes, it deals 30% of the damage dealt to nearby enemies and causes them to deal 5% reduced Physical damage to you for 10 sec.
    swift_and_painful           = {  95032, 443560, 1 }, -- If no enemies are struck by Soul Rupture, you gain 10% Strength for 8 sec. Wave of Souls is 100% more effective on the main target of your Reaper's Mark.
    wave_of_souls               = {  95036, 439851, 1 }, -- Reaper's Mark sends forth bursts of Shadowfrost energy and back, dealing 17,091 Shadowfrost damage both ways to all enemies caught in its path. Wave of Souls critical strikes cause enemies to take 5% increased Shadowfrost damage for 15 sec, stacking up to 2 times, and it is always a critical strike on its way back.
    wither_away                 = {  95058, 441894, 1 }, -- Frost Fever deals its damage 100% faster, and the second scythe of Exterminate applies Frost Fever.
} )


-- PvP Talents
spec:RegisterPvpTalents( {
    bitter_chill      = 5435, -- (356470)
    bloodforged_armor = 5586, -- (410301)
    dark_simulacrum   = 3512, -- (77606) Places a dark ward on an enemy player that persists for 12 sec, triggering when the enemy next spends mana on a spell, and allowing the Death Knight to unleash an exact duplicate of that spell.
    dead_of_winter    = 3743, -- (287250)
    deathchill        =  701, -- (204080)
    delirium          =  702, -- (233396)
    rot_and_wither    = 5510, -- (202727)
    shroud_of_winter  = 3439, -- (199719)
    spellwarden       = 5591, -- (410320)
    strangulate       = 5429, -- (47476) Shadowy tendrils constrict an enemy's throat, silencing them for 4 sec.
} )


-- Auras
spec:RegisterAuras( {
    -- Your Runic Power spending abilities deal $w1% increased damage.
    a_feast_of_souls = {
        id = 440861,
        duration = 3600,
        max_stack = 1,
    },
    -- Talent: Absorbing up to $w1 magic damage.  Immune to harmful magic effects.
    -- https://wowhead.com/beta/spell=48707
    antimagic_shell = {
        id = 48707,
        duration = function () return ( legendary.deaths_embrace.enabled and 2 or 1 ) * 5 + ( conduit.reinforced_shell.mod * 0.001 ) end,
        max_stack = 1
    },
    antimagic_zone = { -- TODO: Modify expiration based on last cast.
        id = 145629,
        duration = 8,
        max_stack = 1
    },
    asphyxiate = {
        id = 108194,
        duration = 4,
        mechanic = "stun",
        type = "Magic",
        max_stack = 1
    },
    -- Next Howling Blast deals Shadowfrost damage.
    bind_in_darkness = {
        id = 443532,
        duration = 3600,
        max_stack = 1,
    },
    -- Talent: Disoriented.
    -- https://wowhead.com/beta/spell=207167
    blinding_sleet = {
        id = 207167,
        duration = 5,
        mechanic = "disorient",
        type = "Magic",
        max_stack = 1
    },
    blood_draw = {
        id = 454871,
        duration = 8,
        max_stack = 1
    },
    -- You may not benefit from the effects of Blood Draw.
    -- https://wowhead.com/beta/spell=374609
    blood_draw_cd = {
        id = 374609,
        duration = 120,
        max_stack = 1
    },
    -- Draining $w1 health from the target every $t1 sec.
    -- https://wowhead.com/beta/spell=55078
    blood_plague = {
        id = 55078,
        duration = function() return 24 * ( talent.wither_away.enabled and 0.5 or 1 ) end,
        tick_time = function() return 3 * ( talent.wither_away.enabled and 0.5 or 1 ) end,
        max_stack = 1
    },
    -- Draining $s1 health from the target every $t1 sec.
    -- https://wowhead.com/beta/spell=206931
    blooddrinker = {
        id = 206931,
        duration = 3,
        type = "Magic",
        max_stack = 1
    },
    bonegrinder_crit = {
        id = 377101,
        duration = 10,
        max_stack = 5
    },
    -- Talent: Frost damage increased by $s1%.
    -- https://wowhead.com/beta/spell=377103
    bonegrinder_frost = {
        id = 377103,
        duration = 10,
        max_stack = 1
    },
    -- Talent: Continuously dealing Frost damage every $t1 sec to enemies in a cone in front of you.
    -- https://wowhead.com/beta/spell=152279
    breath_of_sindragosa = {
        id = 152279,
        duration = 10,
        tick_time = 1,
        max_stack = 1,
        meta = {
            remains = function( t )
                if not t.up then return 0 end
                return ( runic_power.current + ( runes.current * 10 ) ) / 16
            end,
        }
    },
    -- Talent: Movement slowed $w1% $?$w5!=0[and Haste reduced $w5% ][]by frozen chains.
    -- https://wowhead.com/beta/spell=45524
    chains_of_ice = {
        id = 45524,
        duration = 8,
        mechanic = "snare",
        type = "Magic",
        max_stack = 1
    },
    chilled = {
        id = 204206,
        duration = 4,
        mechanic = "snare",
        type = "Magic",
        max_stack = 1
    },
    cold_heart_item = {
        id = 235599,
        duration = 3600,
        max_stack = 20
    },
    -- Talent: Your next Chains of Ice will deal $281210s1 Frost damage.
    -- https://wowhead.com/beta/spell=281209
    cold_heart_talent = {
        id = 281209,
        duration = 3600,
        max_stack = 20,
    },
    cold_heart = {
        alias = { "cold_heart_item", "cold_heart_talent" },
        aliasMode = "first",
        aliasType = "buff",
        duration = 3600,
        max_stack = 20,
    },
    -- Talent: Controlled.
    -- https://wowhead.com/beta/spell=111673
    control_undead = {
        id = 111673,
        duration = 300,
        mechanic = "charm",
        type = "Magic",
        max_stack = 1
    },
    cryogenic_chamber = {
        id = 456370,
        duration = 30,
        max_stack = 20
    },
    -- Taunted.
    -- https://wowhead.com/beta/spell=56222
    dark_command = {
        id = 56222,
        duration = 3,
        mechanic = "taunt",
        max_stack = 1
    },
    dark_succor = {
        id = 101568,
        duration = 20,
        max_stack = 1
    },
    -- Reduces healing done by $m1%.
    -- https://wowhead.com/beta/spell=327095
    death = {
        id = 327095,
        duration = 6,
        type = "Magic",
        max_stack = 3
    },
    death_and_decay = { -- Buff.
        id = 188290,
        duration = 10,
        tick_time = 1,
        max_stack = 1
    },
    -- [444347] $@spelldesc444010
    death_charge = {
        id = 444347,
        duration = 10,
        max_stack = 1,
    },
    -- Talent: The next $w2 healing received will be absorbed.
    -- https://wowhead.com/beta/spell=48743
    death_pact = {
        id = 48743,
        duration = 15,
        max_stack = 1
    },
    -- Your movement speed is increased by $s1%, you cannot be slowed below $s2% of normal speed, and you are immune to forced movement effects and knockbacks.
    -- https://wowhead.com/beta/spell=48265
    deaths_advance = {
        id = 48265,
        duration = 10,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Haste increased by $s3%.  Generating $s1 $LRune:Runes; and ${$m2/10} Runic Power every $t1 sec.
    -- https://wowhead.com/beta/spell=47568
    empower_rune_weapon = {
        id = 47568,
        duration = 20,
        tick_time = 5,
        max_stack = 1
    },
    -- Talent: When Pillar of Frost expires, you will gain $s1% Strength for $<duration> sec.
    -- https://wowhead.com/beta/spell=377192
    enduring_strength = {
        id = 377192,
        duration = 20,
        max_stack = 20
    },
    -- Talent: Strength increased by $w1%.
    -- https://wowhead.com/beta/spell=377195
    enduring_strength_buff = {
        id = 377195,
        duration = 6,
        max_stack = 1
    },
    everfrost = {
        id = 376974,
        duration = 8,
        max_stack = 10
    },
    -- Casting speed reduced by $w1%.
    expelling_shield = {
        id = 440739,
        duration = 6.0,
        max_stack = 1,
    },
    -- Reduces damage dealt to $@auracaster by $m1%.
    -- https://wowhead.com/beta/spell=327092
    famine = {
        id = 327092,
        duration = 6,
        max_stack = 3
    },
    -- Suffering $w1 Frost damage every $t1 sec.
    -- https://wowhead.com/beta/spell=55095
    frost_fever = {
        id = 55095,
        duration = function() return 24 * ( talent.wither_away.enabled and 0.5 or 1 ) end,
        tick_time = function() return 3 * ( talent.wither_away.enabled and 0.5 or 1 ) end,
        max_stack = 1
    },
    -- Talent: Grants ${$s1*$mas}% Mastery.
    -- https://wowhead.com/beta/spell=377253
    frostwhelps_aid = {
        id = 377253,
        duration = 15,
        type = "Magic",
        max_stack = 5
    },
    -- Talent: Movement speed slowed by $s2%.
    -- https://wowhead.com/beta/spell=279303
    frostwyrms_fury = {
        id = 279303,
        duration = 10,
        type = "Magic",
        max_stack = 1
    },
    frozen_pulse = {
        -- Pseudo aura for legacy talent.
        name = "Frozen Pulse",
        meta = {
            up = function () return runes.current < 3 end,
            down = function () return runes.current >= 3 end,
            stack = function () return runes.current < 3 and 1 or 0 end,
            duration = 15,
            remains = function () return runes.time_to_3 end,
            applied = function () return runes.current < 3 and query_time or 0 end,
            expires = function () return runes.current < 3 and ( runes.time_to_3 + query_time ) or 0 end,
        }
    },
    -- Dealing $w1 Frost damage every $t1 sec.
    -- https://wowhead.com/beta/spell=274074
    glacial_contagion = {
        id = 274074,
        duration = 14,
        tick_time = 2,
        type = "Magic",
        max_stack = 1
    },
    -- Dealing $w1 Shadow damage every $t1 sec.
    -- https://wowhead.com/beta/spell=275931
    harrowing_decay = {
        id = 275931,
        duration = 4,
        tick_time = 1,
        type = "Magic",
        max_stack = 1
    },
    -- Deals $s1 Fire damage.
    -- https://wowhead.com/beta/spell=286979
    helchains = {
        id = 286979,
        duration = 15,
        tick_time = 1,
        type = "Magic",
        max_stack = 1
    },
    -- Rooted.
    ice_prison = {
        id = 454787,
        duration = 4.0,
        max_stack = 1,
    },
    -- Talent: Damage taken reduced by $w3%.  Immune to Stun effects.
    -- https://wowhead.com/beta/spell=48792
    icebound_fortitude = {
        id = 48792,
        duration = 8,
        tick_time = 1.0,
        max_stack = 1
    },
    icy_talons = {
        id = 194879,
        duration = 6,
        max_stack = function() return ( talent.smothering_offense.enabled and 5 or 3 ) + ( talent.dark_talons.enabled and 2 or 0 ) end,
    },
    inexorable_assault = {
        id = 253595,
        duration = 3600,
        max_stack = 5,
    },
    insidious_chill = {
        id = 391568,
        duration = 30,
        max_stack = 4
    },
    -- Talent: Guaranteed critical strike on your next Obliterate$?s207230[ or Frostscythe][].
    -- https://wowhead.com/beta/spell=51124
    killing_machine = {
        id = 51124,
        duration = 10,
        max_stack = function() return 1 + talent.fatal_fixation.rank end,
    },
    -- Absorbing up to $w1 magic damage.; Duration of harmful magic effects reduced by $s2%.
    lesser_antimagic_shell = {
        id = 454863,
        duration = function() return 5.0 * ( talent.antimagic_barrier.enabled and 1.4 or 1 ) end,
        max_stack = 1,

        -- Affected by:
        -- fatal_fixation[405166] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'modifies': MAX_STACKS, }
        -- antimagic_barrier[205727] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -20000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- antimagic_barrier[205727] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.5, 'points': 40.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- osmosis[454835] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_4_VALUE, }
        -- unyielding_will[457574] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 20000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- spellwarden[410320] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -10000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
    },
    -- Casting speed reduced by $w1%.
    -- https://wowhead.com/beta/spell=326868
    lethargy = {
        id = 326868,
        duration = 6,
        max_stack = 1
    },
    -- Leech increased by $s1%$?a389682[, damage taken reduced by $s8%][] and immune to Charm, Fear and Sleep. Undead.
    -- https://wowhead.com/beta/spell=49039
    lichborne = {
        id = 49039,
        duration = 10,
        tick_time = 1,
        max_stack = 1
    },
    march_of_darkness = {
        id = 391547,
        duration = 3,
        max_stack = 1
    },
    -- Talent: $@spellaura281238
    -- https://wowhead.com/beta/spell=207256
    obliteration = {
        id = 207256,
        duration = 3600,
        max_stack = 1
    },
    -- Grants the ability to walk across water.
    -- https://wowhead.com/beta/spell=3714
    path_of_frost = {
        id = 3714,
        duration = 600,
        tick_time = 0.5,
        max_stack = 1
    },
    -- Suffering $o1 shadow damage over $d and slowed by $m2%.
    -- https://wowhead.com/beta/spell=327093
    pestilence = {
        id = 327093,
        duration = 6,
        tick_time = 1,
        type = "Magic",
        max_stack = 3
    },
    -- Talent: Strength increased by $w1%.
    -- https://wowhead.com/beta/spell=51271
    pillar_of_frost = {
        id = 51271,
        duration = 12,
        type = "Magic",
        max_stack = 1
    },
    -- Frost damage taken from the Death Knight's abilities increased by $s1%.
    -- https://wowhead.com/beta/spell=51714
    razorice = {
        id = 51714,
        duration = 20,
        tick_time = 1,
        type = "Magic",
        max_stack = 5
    },
    -- You are a prey for the Deathbringer... This effect will explode for $436304s1 Shadowfrost damage for each stack.
    reapers_mark = {
        id = 434765,
        duration = 12.0,
        tick_time = 1.0,
        max_stack = 40,
    },
    -- Talent: Dealing $196771s1 Frost damage to enemies within $196771A1 yards each second.
    -- https://wowhead.com/beta/spell=196770
    remorseless_winter = {
        id = 196770,
        duration = 8,
        tick_time = 1,
        max_stack = 1
    },
    -- Talent: Movement speed reduced by $s1%.
    -- https://wowhead.com/beta/spell=211793
    remorseless_winter_snare = {
        id = 211793,
        duration = 3,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Your next Howling Blast will consume no Runes, generate no Runic Power, and deals $s2% additional damage.
    -- https://wowhead.com/beta/spell=59052
    rime = {
        id = 59052,
        duration = 15,
        type = "Magic",
        max_stack = 1
    },
    -- Magical damage taken reduced by $w1%.
    rune_carved_plates = {
        id = 440290,
        duration = 5.0,
        max_stack = 1,
    },
    -- Talent: Strength increased by $w1%
    -- https://wowhead.com/beta/spell=374585
    rune_mastery = {
        id = 374585,
        duration = 8,
        max_stack = 1
    },
    -- Runic Power generation increased by $s1%.
    -- https://wowhead.com/beta/spell=326918
    rune_of_hysteria = {
        id = 326918,
        duration = 8,
        max_stack = 1
    },
    -- Healing for $s1% of your maximum health every $t sec.
    -- https://wowhead.com/beta/spell=326808
    rune_of_sanguination = {
        id = 326808,
        duration = 8,
        max_stack = 1
    },
    -- Absorbs $w1 magic damage.    When an enemy damages the shield, their cast speed is reduced by $w2% for $326868d.
    -- https://wowhead.com/beta/spell=326867
    rune_of_spellwarding = {
        id = 326867,
        duration = 8,
        max_stack = 1
    },
    -- Haste and Movement Speed increased by $s1%.
    -- https://wowhead.com/beta/spell=326984
    rune_of_unending_thirst = {
        id = 326984,
        duration = 10,
        max_stack = 1
    },
    -- Talent: Afflicted by Soul Reaper, if the target is below $s3% health this effect will explode dealing an additional $343295s1 Shadowfrost damage.
    -- https://wowhead.com/beta/spell=448229
    soul_reaper = {
        id = 448229,
        duration = 5,
        tick_time = 5,
        max_stack = 1
    },
    -- Silenced.
    strangulate = {
        id = 47476,
        duration = 5.0,
        max_stack = 1,
    },
    -- Damage dealt to $@auracaster reduced by $w1%.
    subduing_grasp = {
        id = 454824,
        duration = 6.0,
        max_stack = 1,
    },
    -- Damage taken from area of effect attacks reduced by an additional $w1%.
    suppression = {
        id = 454886,
        duration = 6.0,
        max_stack = 1,
    },
    -- Deals $s1 Fire damage.
    -- https://wowhead.com/beta/spell=319245
    unholy_pact = {
        id = 319245,
        duration = 15,
        tick_time = 1,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Strength increased by 0%
    unleashed_frenzy = {
        id = 376907,
        duration = 10, -- 20230206 Hotfix
        max_stack = 3
    },
    -- The touch of the spirit realm lingers....
    -- https://wowhead.com/beta/spell=97821
    voidtouched = {
        id = 97821,
        duration = 300,
        max_stack = 1
    },
    -- Increases damage taken from $@auracaster by $m1%.
    -- https://wowhead.com/beta/spell=327096
    war = {
        id = 327096,
        duration = 6,
        type = "Magic",
        max_stack = 3
    },
    -- Talent: Movement speed increased by $w1%.  Cannot be slowed below $s2% of normal movement speed.  Cannot attack.
    -- https://wowhead.com/beta/spell=212552
    wraith_walk = {
        id = 212552,
        duration = 4,
        max_stack = 1
    },

    -- PvP Talents
    -- Your next spell with a mana cost will be copied by the Death Knight's runeblade.
    dark_simulacrum = {
        id = 77606,
        duration = 12,
        max_stack = 1,
    },
    -- Your runeblade contains trapped magical energies, ready to be unleashed.
    dark_simulacrum_buff = {
        id = 77616,
        duration = 12,
        max_stack = 1,
    },
    dead_of_winter = {
        id = 289959,
        duration = 4,
        max_stack = 5,
    },
    deathchill = {
        id = 204085,
        duration = 4,
        max_stack = 1
    },
    delirium = {
        id = 233396,
        duration = 15,
        max_stack = 1,
    },
    shroud_of_winter = {
        id = 199719,
        duration = 3600,
        max_stack = 1,
    },

    -- Legendary
    absolute_zero = {
        id = 334693,
        duration = 3,
        max_stack = 1,
    },

    -- Azerite Powers
    cold_hearted = {
        id = 288426,
        duration = 8,
        max_stack = 1
    },
    frostwhelps_indignation = {
        id = 287338,
        duration = 6,
        max_stack = 1,
    },
} )


spec:RegisterTotem( "ghoul", 1100170 )


-- Tier 29
spec:RegisterGear( "tier29", 200405, 200407, 200408, 200409, 200410 )

-- Tier 30
spec:RegisterGear( "tier30", 202464, 202462, 202461, 202460, 202459, 217223, 217225, 217221, 217222, 217224 )
-- 2 pieces (Frost) : Howling Blast damage increased by 20%. Consuming Rime increases the damage of your next Frostwyrm's Fury by 5%, stacking 10 times. Pillar of Frost calls a Frostwyrm's Fury at 40% effectiveness that cannot Freeze enemies.
spec:RegisterAura( "wrath_of_the_frostwyrm", {
    id = 408368,
    duration = 30,
    max_stack = 10
} )
-- 4 pieces (Frost) : Frostwyrm's Fury causes enemies hit to take 25% increased damage from your critical strikes for 12 sec.
spec:RegisterAura( "lingering_chill", {
    id = 410879,
    duration = 12,
    max_stack = 1
} )

spec:RegisterGear( "tier31", 207198, 207199, 207200, 207201, 207203 )
-- (2) Chill Streak's range is increased by $s1 yds and can bounce off of you. Each time Chill Streak bounces your damage is increased by $424165s2% for $424165d, stacking up to $424165u times.
-- (4) Chill Streak can bounce $s1 additional times and each time it bounces, you have a $s4% chance to gain a Rune, reduce Chill Streak cooldown by ${$s2/1000} sec, or reduce the cooldown of Empower Rune Weapon by ${$s3/1000} sec.
spec:RegisterAura( "chilling_rage", {
    id = 424165,
    duration = 12,
    max_stack = 5
} )



local TriggerERW = setfenv( function()
    gain( 1, "runes" )
    gain( 5, "runic_power" )
end, state )

local any_dnd_set = false

spec:RegisterHook( "reset_precast", function ()
    if state:IsKnown( "deaths_due" ) then
        class.abilities.any_dnd = class.abilities.deaths_due
        cooldown.any_dnd = cooldown.deaths_due
        setCooldown( "death_and_decay", cooldown.deaths_due.remains )
    elseif state:IsKnown( "defile" ) then
        class.abilities.any_dnd = class.abilities.defile
        cooldown.any_dnd = cooldown.defile
        setCooldown( "death_and_decay", cooldown.defile.remains )
    else
        class.abilities.any_dnd = class.abilities.death_and_decay
        cooldown.any_dnd = cooldown.death_and_decay
    end

    if not any_dnd_set then
        class.abilityList.any_dnd = "|T136144:0|t |cff00ccff[Any]|r " .. class.abilities.death_and_decay.name
        any_dnd_set = true
    end

    local control_expires = action.control_undead.lastCast + 300
    if control_expires > now and pet.up then
        summonPet( "controlled_undead", control_expires - now )
    end

    -- Reset CDs on any Rune abilities that do not have an actual cooldown.
    for action in pairs( class.abilityList ) do
        local data = class.abilities[ action ]
        if data and data.cooldown == 0 and data.spendType == "runes" then
            setCooldown( action, 0 )
        end
    end

    if buff.empower_rune_weapon.up then
        local expires = buff.empower_rune_weapon.expires

        while expires >= query_time do
            state:QueueAuraExpiration( "empower_rune_weapon", TriggerERW, expires )
            expires = expires - 5
        end
    end
end )


spec:RegisterHook( "recheck", function( times )
    if buff.breath_of_sindragosa.up then
        local applied = action.breath_of_sindragosa.lastCast
        local tick = applied + ceil( query_time - applied ) - query_time
        if tick > 0 then times[ #times + 1 ] = tick end
        times[ #times + 1 ] = tick + 1
        times[ #times + 1 ] = tick + 2
        times[ #times + 1 ] = tick + 3
        if Hekili.ActiveDebug then Hekili:Debug( "Queued BoS recheck times at %.2f, %.2f, %.2f, and %.2f.", tick, tick + 1, tick + 2, tick + 3 ) end
    end
end )


-- Abilities
spec:RegisterAbilities( {
    -- Talent: Surrounds you in an Anti-Magic Shell for $d, absorbing up to $<shield> magic damage and preventing application of harmful magical effects.$?s207188[][ Damage absorbed generates Runic Power.]
    antimagic_shell = {
        id = 48707,
        cast = 0,
        cooldown = function() return 60 - ( talent.antimagic_barrier.enabled and 15 or 0 ) - ( talent.unyielding_will.enabled and -20 or 0 ) - ( pvptalent.spellwarden.enabled and 10 or 0 ) end,
        gcd = "off",

        startsCombat = false,

        toggle = function()
            if settings.ams_usage == "defensives" or settings.ams_usage == "both" then return "defensives" end
        end,

        usable = function()
            if settings.ams_usage == "damage" or settings.ams_usage == "both" then return incoming_magic_3s > 0, "settings require magic damage taken in the past 3 seconds" end
        end,

        handler = function ()
            applyBuff( "antimagic_shell" )
            if talent.unyielding_will.enabled then removeBuff( "dispellable_magic" ) end
        end,
    },

    -- Talent: Places an Anti-Magic Zone that reduces spell damage taken by party or raid members by $145629m1%. The Anti-Magic Zone lasts for $d or until it absorbs $?a374383[${$<absorb>*1.1}][$<absorb>] damage.
    antimagic_zone = {
        id = 51052,
        cast = 0,
        cooldown = function() return 120 - ( talent.assimilation.enabled and 30 or 0 ) end,
        gcd = "spell",

        talent = "antimagic_zone",
        startsCombat = false,

        toggle = "defensives",

        handler = function ()
            applyBuff( "antimagic_zone" )
        end,
    },

    -- Talent: Lifts the enemy target off the ground, crushing their throat with dark energy and stunning them for $d.
    asphyxiate = {
        id = 221562,
        cast = 0,
        cooldown = 45,
        gcd = "spell",

        talent = "asphyxiate",
        startsCombat = false,

        toggle = "interrupts",

        debuff = "casting",
        readyTime = function () return state.timeToInterrupt( gcd.max ) end,

        handler = function ()
            applyDebuff( "target", "asphyxiate" )
            interrupt()
        end,
    },

    -- Talent: Targets in a cone in front of you are blinded, causing them to wander disoriented for $d. Damage may cancel the effect.    When Blinding Sleet ends, enemies are slowed by $317898s1% for $317898d.
    blinding_sleet = {
        id = 207167,
        cast = 0,
        cooldown = 60,
        gcd = "spell",

        talent = "blinding_sleet",
        startsCombat = false,

        toggle = "cooldowns",

        range = 12,
        handler = function ()
            applyDebuff( "target", "blinding_sleet" )
            active_dot.blinding_sleet = max( active_dot.blinding_sleet, active_enemies )
        end,
    },

    -- Talent: Continuously deal ${$155166s2*$<CAP>/$AP} Frost damage every $t1 sec to enemies in a cone in front of you, until your Runic Power is exhausted. Deals reduced damage to secondary targets.    |cFFFFFFFFGenerates $303753s1 $lRune:Runes; at the start and end.|r
    breath_of_sindragosa = {
        id = 152279,
        cast = 0,
        cooldown = 120,
        gcd = "off",

        spend = 18,
        spendType = "runic_power",
        readySpend = function () return settings.bos_rp end,

        talent = "breath_of_sindragosa",
        startsCombat = true,

        toggle = "cooldowns",

        range = 12,
        handler = function ()
            gain( 2, "runes" )
            applyBuff( "breath_of_sindragosa" )
            if talent.unleashed_frenzy.enabled then addStack( "unleashed_frenzy", nil, 3 ) end
        end,
    },

    -- Talent: Shackles the target $?a373930[and $373930s1 nearby enemy ][]with frozen chains, reducing movement speed by $s1% for $d.
    chains_of_ice = {
        id = 45524,
        cast = 0,
        cooldown = function() return 0 + ( talent.ice_prison.enabled and 12 or 0 ) end,
        gcd = "spell",

        spend = 1,
        spendType = "runes",

        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "chains_of_ice" )
            if talent.ice_prison.enabled then applyDebuff( "target", "ice_prison" ) end
            removeBuff( "cold_heart_item" )
            removeBuff( "cold_heart_talent" )
        end,
    },

    -- Talent: Deals $204167s4 Frost damage to the target and reduces their movement speed by $204206m2% for $204206d.    Chill Streak bounces up to $m1 times between closest targets within $204165A1 yards.
    chill_streak = {
        id = 305392,
        cast = 0,
        cooldown = 45,
        gcd = "spell",

        spend = 1,
        spendType = "runes",

        talent = "chill_streak",
        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "chilled" )
            if set_bonus.tier31_2pc > 0 then
                applyBuff( "chilling_rage", 5 ) -- TODO: Check if reliable.
            end
        end,
    },

    -- Talent: Dominates the target undead creature up to level $s1, forcing it to do your bidding for $d.
    control_undead = {
        id = 111673,
        cast = 1.5,
        cooldown = 0,
        gcd = "spell",

        spend = 1,
        spendType = "runes",

        talent = "control_undead",
        startsCombat = false,

        usable = function () return target.is_undead and target.level <= level + 1, "requires undead target up to 1 level above player" end,
        handler = function ()
            summonPet( "controlled_undead", 300 )
        end,
    },

    -- Command the target to attack you.
    dark_command = {
        id = 56222,
        cast = 0,
        cooldown = 8,
        gcd = "off",

        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "dark_command" )
        end,
    },


    dark_simulacrum = {
        id = 77606,
        cast = 0,
        cooldown = 20,
        gcd = "spell",

        startsCombat = true,
        texture = 135888,

        pvptalent = "dark_simulacrum",

        usable = function ()
            if not target.is_player then return false, "target is not a player" end
            return true
        end,
        handler = function ()
            applyDebuff( "target", "dark_simulacrum" )
        end,
    },

    -- Corrupts the targeted ground, causing ${$341340m1*11} Shadow damage over $d to targets within the area.$?!c2[; While you remain within the area, your ][]$?s223829&!c2[Necrotic Strike and ][]$?c1[Heart Strike will hit up to $188290m3 additional targets.]?s207311&!c2[Clawing Shadows will hit up to ${$55090s4-1} enemies near the target.]?!c2[Scourge Strike will hit up to ${$55090s4-1} enemies near the target.][; While you remain within the area, your Obliterate will hit up to $316916M2 additional $Ltarget:targets;.]
    death_and_decay = {
        id = 43265,
        noOverride = 324128,
        cast = 0,
        charges = function() if talent.deaths_echo.enabled then return 2 end end,
        cooldown = 30,
        recharge = function() if talent.deaths_echo.enabled then return 30 end end,
        gcd = "spell",

        spend = 1,
        spendType = "runes",

        startsCombat = true,

        usable = function ()
            return not moving and target.maxR < 8
        end,
        handler = function ()
            applyBuff( "death_and_decay" )
            applyDebuff( "target", "death_and_decay" )
        end,
    },

    -- Fires a blast of unholy energy at the target$?a377580[ and $377580s2 additional nearby target][], causing $47632s1 Shadow damage to an enemy or healing an Undead ally for $47633s1 health.$?s390268[    Increases the duration of Dark Transformation by $390268s1 sec.][]
    death_coil = {
        id = 47541,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 30,
        spendType = "runic_power",

        startsCombat = true,

        handler = function ()
            if buff.dark_transformation.up then buff.dark_transformation.up.expires = buff.dark_transformation.expires + 1 end
            if talent.unleashed_frenzy.enabled then addStack( "unleashed_frenzy", nil, 3 ) end
        end,
    },

    -- Opens a gate which you can use to return to Ebon Hold.    Using a Death Gate while in Ebon Hold will return you back to near your departure point.
    death_gate = {
        id = 50977,
        cast = 4,
        cooldown = 60,
        gcd = "spell",

        spend = 1,
        spendType = "runes",

        startsCombat = false,

        handler = function ()
        end,
    },

    -- Harnesses the energy that surrounds and binds all matter, drawing the target toward you$?a389679[ and slowing their movement speed by $389681s1% for $389681d][]$?s137008[ and forcing the enemy to attack you][].
    death_grip = {
        id = 49576,
        cast = 0,
        charges = function() if talent.deaths_echo.enabled then return 2 end end,
        cooldown = 25,
        recharge = function() if talent.deaths_echo.enabled then return 25 end end,

        gcd = "off",

        startsCombat = false,

        handler = function ()
            applyDebuff( "target", "death_grip" )
            setDistance( 5 )
            if conduit.unending_grip.enabled then applyDebuff( "target", "unending_grip" ) end
        end,
    },

    -- Talent: Create a death pact that heals you for $s1% of your maximum health, but absorbs incoming healing equal to $s3% of your max health for $d.
    death_pact = {
        id = 48743,
        cast = 0,
        cooldown = 120,
        gcd = "off",

        talent = "death_pact",
        startsCombat = false,

        toggle = "defensives",

        handler = function ()
            gain( health.max * 0.5, "health" )
            applyDebuff( "player", "death_pact" )
        end,
    },

    -- Talent: Focuses dark power into a strike$?s137006[ with both weapons, that deals a total of ${$s1+$66188s1}][ that deals $s1] Physical damage and heals you for ${$s2}.2% of all damage taken in the last $s4 sec, minimum ${$s3}.1% of maximum health.
    death_strike = {
        id = 49998,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = function ()
            if buff.dark_succor.up then return 0 end
            return ( talent.improved_death_strike.enabled and 40 or 50 ) - ( buff.blood_draw.up and 10 or 0 )
        end,
        spendType = "runic_power",

        talent = "death_strike",
        startsCombat = true,

        handler = function ()
            removeBuff( "dark_succor" )
            gain( health.max * 0.10, "health" )
            if talent.unleashed_frenzy.enabled then addStack( "unleashed_frenzy", nil, 3 ) end
        end,
    },

    -- For $d, your movement speed is increased by $s1%, you cannot be slowed below $s2% of normal speed, and you are immune to forced movement effects and knockbacks.    |cFFFFFFFFPassive:|r You cannot be slowed below $124285s1% of normal speed.
    deaths_advance = {
        id = 48265,
        cast = 0,
        charges = function() if talent.deaths_echo.enabled then return 2 end end,
        cooldown = 45,
        recharge = function() if talent.deaths_echo.enabled then return 45 end end,

        gcd = "off",

        startsCombat = false,

        handler = function ()
            applyBuff( "deaths_advance" )
            if conduit.fleeting_wind.enabled then applyBuff( "fleeting_wind" ) end
        end,
    },

    -- Talent: Empower your rune weapon, gaining $s3% Haste and generating $s1 $LRune:Runes; and ${$m2/10} Runic Power instantly and every $t1 sec for $d.  $?s137006[  If you already know $@spellname47568, instead gain $392714s1 additional $Lcharge:charges; of $@spellname47568.][]
    empower_rune_weapon = {
        id = 47568,
        cast = 0,
        charges = function()
            if talent.empower_rune_weapon.rank + talent.empower_rune_weapon_2.rank > 1 then return 2 end
        end,
        cooldown = function () return ( conduit.accelerated_cold.enabled and 0.9 or 1 ) * ( essence.vision_of_perfection.enabled and 0.87 or 1 ) * ( level > 55 and 105 or 120 ) end,
        recharge = function ()
            if talent.empower_rune_weapon.rank + talent.empower_rune_weapon_2.rank > 1 then return ( conduit.accelerated_cold.enabled and 0.9 or 1 ) * ( essence.vision_of_perfection.enabled and 0.87 or 1 ) * ( level > 55 and 105 or 120 ) end
        end,
        gcd = "off",

        talent = "empower_rune_weapon",
        startsCombat = false,

        range = 8,
        usable = function() return talent.empower_rune_weapon.rank + talent.empower_rune_weapon_2.rank > 0, "requires an empower_rune_weapon talent" end,

        handler = function ()
            stat.haste = state.haste + 0.15 + ( conduit.accelerated_cold.mod * 0.01 )
            gain( 1, "runes" )
            gain( 5, "runic_power" )
            applyBuff( "empower_rune_weapon" )
            state:QueueAuraExpiration( "empower_rune_weapon", TriggerERW, query_time + 5 )
            state:QueueAuraExpiration( "empower_rune_weapon", TriggerERW, query_time + 10 )
            state:QueueAuraExpiration( "empower_rune_weapon", TriggerERW, query_time + 15 )
            state:QueueAuraExpiration( "empower_rune_weapon", TriggerERW, query_time + 20 )
        end,

        copy = "empowered_rune_weapon"
    },

    -- Talent: Chill your $?$owb==0[weapon with icy power and quickly strike the enemy, dealing $<2hDamage> Frost damage.][weapons with icy power and quickly strike the enemy with both, dealing a total of $<dualWieldDamage> Frost damage.]
    frost_strike = {
        id = 49143,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 30,
        spendType = "runic_power",

        talent = "frost_strike",
        startsCombat = true,

        cycle = function ()
            if debuff.mark_of_fyralath.up then return "mark_of_fyralath" end
            if death_knight.runeforge.razorice and debuff.razorice.stack == 5 then return "razorice" end
        end,

        handler = function ()
            applyDebuff( "target", "razorice", 20, 2 )

            if talent.obliteration.enabled and buff.pillar_of_frost.up then addStack( "killing_machine" ) end
            removeBuff( "eradicating_blow" )

            if talent.shattering_blade.enabled then
                if debuff.razorice.stack == 5 then removeDebuff( "target", "razorice" )
                elseif debuff.razorice.stack > 5 then applyDebuff( "target", "razorice", nil, debuff.razorice.stack - 5 ) end
            end

            if talent.unleashed_frenzy.enabled then addStack( "unleashed_frenzy", nil, 3 ) end

            if pvptalent.bitter_chill.enabled and debuff.chains_of_ice.up then
                applyDebuff( "target", "chains_of_ice" )
            end
        end,

        auras = {
            unleashed_frenzy = {
                id = 338501,
                duration = 6,
                max_stack = 5,
            }
        }
    },

    -- A sweeping attack that strikes all enemies in front of you for $s2 Frost damage. This attack always critically strikes and critical strikes with Frostscythe deal $s3 times normal damage. Deals reduced damage beyond $s5 targets. ; Consuming Killing Machine reduces the cooldown of Frostscythe by ${$s1/1000}.1 sec.
    frostscythe = {
        id = 207230,
        cast = 0,
        cooldown = 30,
        gcd = "spell",

        spend = 2,
        spendType = "runes",

        talent = "frostscythe",
        startsCombat = true,

        range = 7,

        handler = function ()
            removeStack( "inexorable_assault" )

            if buff.killing_machine.up and talent.bonegrinder.enabled then
                if buff.bonegrinder_crit.stack_pct == 100 then
                    removeBuff( "bonegrinder_crit" )
                    applyBuff( "bonegrinder_frost" )
                else
                    addStack( "bonegrinder_crit" )
                end
                removeBuff( "killing_machine" )
            end
        end,
    },

    -- Talent: Summons a frostwyrm who breathes on all enemies within $s1 yd in front of you, dealing $279303s1 Frost damage and slowing movement speed by $279303s2% for $279303d.
    frostwyrms_fury = {
        id = 279302,
        cast = 0,
        cooldown = function () return legendary.absolute_zero.enabled and 90 or 180 end,
        gcd = "spell",

        talent = "frostwyrms_fury",
        startsCombat = true,

        toggle = "cooldowns",

        usable = function ()
            if talent.frostwyrms_fury.enabled and (boss or active_enemies > 5) then return true end
            return false
        end,
        handler = function ()
            applyDebuff( "target", "frostwyrms_fury" )
            if set_bonus.tier30_4pc > 0 then applyDebuff( "target", "lingering_chill" ) end
            if legendary.absolute_zero.enabled then applyDebuff( "target", "absolute_zero" ) end
        end,
    },

    -- Talent: Summon glacial spikes from the ground that advance forward, each dealing ${$195975s1*$<CAP>/$AP} Frost damage and applying Razorice to enemies near their eruption point.
    glacial_advance = {
        id = 194913,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 30,
        spendType = "runic_power",

        talent = "glacial_advance",
        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "razorice", nil, min( 5, buff.razorice.stack + 1 ) )
            if active_enemies > 1 then active_dot.razorice = active_enemies end
            if talent.obliteration.enabled and buff.pillar_of_frost.up then addStack( "killing_machine" ) end
            if talent.unleashed_frenzy.enabled then addStack( "unleashed_frenzy", nil, 3 ) end
        end,
    },

    -- Talent: Blow the Horn of Winter, gaining $s1 $LRune:Runes; and generating ${$s2/10} Runic Power.
    horn_of_winter = {
        id = 57330,
        cast = 0,
        cooldown = 45,
        gcd = "spell",

        talent = "horn_of_winter",
        startsCombat = false,

        handler = function ()
            gain( 2, "runes" )
            gain( 25, "runic_power" )
        end,
    },

    -- Talent: Blast the target with a frigid wind, dealing ${$s1*$<CAP>/$AP} $?s204088[Frost damage and applying Frost Fever to the target.][Frost damage to that foe, and reduced damage to all other enemies within $237680A1 yards, infecting all targets with Frost Fever.]    |Tinterface\icons\spell_deathknight_frostfever.blp:24|t |cFFFFFFFFFrost Fever|r  $@spelldesc55095
    howling_blast = {
        id = 49184,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = function() return talent.bind_in_darkness.enabled and "shadowfrost" or "frost" end,

        spend = function () return buff.rime.up and 0 or 1 end,
        spendType = "runes",

        talent = "howling_blast",
        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "frost_fever" )
            active_dot.frost_fever = max( active_dot.frost_fever, active_enemies )

            if talent.bind_in_darkness.enabled and debuff.reapers_mark.up then applyDebuff( "target", "reapers_mark", nil, debuff.reapers_mark.stack + 2 ) end

            if talent.obliteration.enabled and buff.pillar_of_frost.up then addStack( "killing_machine" ) end

            if buff.rime.up then
                removeBuff( "rime" )

                if legendary.rage_of_the_frozen_champion.enabled then
                    gain( 8, "runic_power" )
                end
                if set_bonus.tier30_2pc > 0 then
                    addStack( "wrath_of_the_frostwyrm" )
                end
            end

            if pvptalent.delirium.enabled then applyDebuff( "target", "delirium" ) end
        end,
    },

    -- Talent: Your blood freezes, granting immunity to Stun effects and reducing all damage you take by $s3% for $d.
    icebound_fortitude = {
        id = 48792,
        cast = 0,
        cooldown = function () return 120 - ( azerite.cold_hearted.enabled and 15 or 0 ) + ( conduit.chilled_resilience.mod * 0.001 ) end,
        gcd = "off",

        talent = "icebound_fortitude",
        startsCombat = false,

        toggle = "defensives",

        handler = function ()
            applyBuff( "icebound_fortitude" )
        end,
    },

    -- Draw upon unholy energy to become Undead for $d, increasing Leech by $s1%$?a389682[, reducing damage taken by $s8%][], and making you immune to Charm, Fear, and Sleep.
    lichborne = {
        id = 49039,
        cast = 0,
        cooldown = function() return 120 - ( talent.deaths_messenger.enabled and 30 or 0 ) end,
        gcd = "off",

        startsCombat = false,

        toggle = "defensives",

        handler = function ()
            applyBuff( "lichborne" )
            if conduit.hardened_bones.enabled then applyBuff( "hardened_bones" ) end
        end,
    },

    -- Talent: Smash the target's mind with cold, interrupting spellcasting and preventing any spell in that school from being cast for $d.
    mind_freeze = {
        id = 47528,
        cast = 0,
        cooldown = 15,
        gcd = "off",

        talent = "mind_freeze",
        startsCombat = true,

        toggle = "interrupts",

        debuff = "casting",
        readyTime = state.timeToInterrupt,

        handler = function ()
            if conduit.spirit_drain.enabled then gain( conduit.spirit_drain.mod * 0.1, "runic_power" ) end
            interrupt()
        end,
    },

    -- Talent: A brutal attack $?$owb==0[that deals $<2hDamage> Physical damage.][with both weapons that deals a total of $<dualWieldDamage> Physical damage.]
    obliterate = {
        id = 49020,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 2,
        spendType = "runes",

        talent = "obliterate",
        startsCombat = true,

        cycle = function ()
            if debuff.mark_of_fyralath.up then return "mark_of_fyralath" end
            if death_knight.runeforge.razorice and debuff.razorice.stack == 5 then return "razorice" end
        end,

        handler = function ()
            removeStack( "inexorable_assault" )

            if buff.exterminate.up then
                removeStack( "exterminate" )
                if talent.wither_away.enabled and buff.exterminate.down then applyDebuff( "target", "frost_fever" ) end
            end

            if buff.killing_machine.up and talent.bonegrinder.enabled then
                if buff.bonegrinder_crit.stack_pct == 100 then
                    removeBuff( "bonegrinder_crit" )
                    applyBuff( "bonegrinder_frost" )
                else
                    addStack( "bonegrinder_crit" )
                end
                removeBuff( "killing_machine" )
            end

            -- Koltira's Favor is not predictable.
            if conduit.eradicating_blow.enabled then addStack( "eradicating_blow", nil, 1 ) end
        end,

        auras = {
            -- Conduit
            eradicating_blow = {
                id = 337936,
                duration = 10,
                max_stack = 2
            }
        }
    },

    -- Activates a freezing aura for $d that creates ice beneath your feet, allowing party or raid members within $a1 yards to walk on water.    Usable while mounted, but being attacked or damaged will cancel the effect.
    path_of_frost = {
        id = 3714,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 1,
        spendType = "runes",

        startsCombat = false,

        handler = function ()
            applyBuff( "path_of_frost" )
        end,
    },

    -- The power of frost increases your Strength by $s1% for $d.
    pillar_of_frost = {
        id = 51271,
        cast = 0,
        cooldown = function() return 60 - ( talent.icecap.enabled and 15 or 0 ) end,
        gcd = "off",

        talent = "pillar_of_frost",
        startsCombat = false,

        range = 8,
        handler = function ()
            applyBuff( "pillar_of_frost" )
            if set_bonus.tier30_2pc > 0 then
                applyDebuff( "target", "frostwyrms_fury" )
                applyDebuff( "target", "lingering_chill" )
            end
            if azerite.frostwhelps_indignation.enabled then applyBuff( "frostwhelps_indignation" ) end
            virtual_rp_spent_since_pof = 0
        end,
    },

    --[[ Pours dark energy into a dead target, reuniting spirit and body to allow the target to reenter battle with $s2% health and at least $s1% mana.
    raise_ally = {
        id = 61999,
        cast = 0,
        cooldown = 600,
        gcd = "spell",

        spend = 30,
        spendType = "runic_power",

        startsCombat = false,

        toggle = "cooldowns",

        handler = function ()
            -- trigger voidtouched [97821]
        end,
    }, ]]

    -- Talent: Raises a $?s58640[geist][ghoul] to fight by your side.  You can have a maximum of one $?s58640[geist][ghoul] at a time.  Lasts $46585d.
    raise_dead = {
        id = 46585,
        cast = 0,
        cooldown = function() return 120 - ( talent.deaths_messenger.enabled and 30 or 0 ) end,
        gcd = "off",

        talent = "raise_dead",
        startsCombat = true,

        usable = function () return not pet.alive, "cannot have an active pet" end,

        handler = function ()
            summonPet( "ghoul" )
        end,
    },

    -- Viciously slice into the soul of your enemy, dealing $?a137008[$s1][$s4] Shadowfrost damage and applying Reaper's Mark.; Each time you deal Shadow or Frost damage,
    reapers_mark = {
        id = 439843,
        cast = 0.0,
        cooldown = function() return 60.0 - ( 15 * talent.reapers_onslaught.rank ) end,
        gcd = "spell",

        spend = function() return 2 - ( talent.swift_end.enabled and 1 or 0 ) end,
        spendType = 'runes',

        talent = "reapers_mark",
        startsCombat = true,

        handler = function()
            applyDebuff( "target", "reapers_mark" )

            if talent.grim_reaper.enabled then
                applyBuff( "killing_machine" )
            end

            if talent.reaper_of_souls.enabled then
                setCooldown( "soul_reaper", 0 )
                applyBuff( "reaper_of_souls" )
            end
        end,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'attributes': ['Chain from Initial Target', 'Enforce Line Of Sight To Chain Targets'], 'ap_bonus': 0.8, 'target':
        -- #1: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 434765, 'value': 10, 'schools': ['holy', 'nature'], 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': ENERGIZE, 'subtype': NONE, 'points': 200.0, 'target': TARGET_UNIT_CASTER, 'resource': runic_power, }
        -- #3: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'attributes': ['Chain from Initial Target', 'Enforce Line Of Sight To Chain Targets'], 'ap_bonus': 1.5, 'target':

        -- Affected by:
        -- swift_end[443560] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': -30000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- swift_end[443560] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': -1.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
    },

    -- Talent: Drain the warmth of life from all nearby enemies within $196771A1 yards, dealing ${9*$196771s1*$<CAP>/$AP} Frost damage over $d and reducing their movement speed by $211793s1%.
    remorseless_winter = {
        id = 196770,
        cast = 0,
        cooldown = function () return pvptalent.dead_of_winter.enabled and 45 or 20 end,
        gcd = "spell",

        spend = 1,
        spendType = "runes",

        startsCombat = true,

        range = 8,
        handler = function ()
            applyBuff( "remorseless_winter" )
            removeBuff( "cryogenic_chamber" )

            if active_enemies > 2 and legendary.biting_cold.enabled then
                applyBuff( "rime" )
            end

            if conduit.biting_cold.enabled then applyDebuff( "target", "biting_cold" ) end
            -- if pvptalent.deathchill.enabled then applyDebuff( "target", "deathchill" ) end
        end,

        auras = {
            -- Conduit
            biting_cold = {
                id = 337989,
                duration = 8,
                max_stack = 10
            }
        }
    },

    -- Talent: Sacrifice your ghoul to deal $327611s1 Shadow damage to all nearby enemies and heal for $s1% of your maximum health. Deals reduced damage beyond $327611s2 targets.
    sacrificial_pact = {
        id = 327574,
        cast = 0,
        cooldown = 120,
        gcd = "spell",

        spend = 20,
        spendType = "runic_power",

        talent = "sacrificial_pact",
        startsCombat = false,

        toggle = "defensives",

        usable = function () return pet.alive, "requires an undead pet" end,

        handler = function ()
            dismissPet( "ghoul" )
            gain( 0.25 * health.max, "health" )

            if talent.unleashed_frenzy.enabled then addStack( "unleashed_frenzy", nil, 3 ) end
        end,
    },

    -- Talent: Strike an enemy for $s1 Shadowfrost damage and afflict the enemy with Soul Reaper.     After $d, if the target is below $s3% health this effect will explode dealing an additional $343295s1 Shadowfrost damage to the target. If the enemy that yields experience or honor dies while afflicted by Soul Reaper, gain Runic Corruption.
    soul_reaper = {
        id = 343294,
        cast = 0,
        cooldown = 6,
        gcd = "spell",

        spend = 1,
        spendType = "runes",

        talent = "soul_reaper",
        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "soul_reaper" )
            if talent.obliteration.enabled and buff.pillar_of_frost.up then addStack( "killing_machine" ) end
        end,
    },


    strangulate = {
        id = 47476,
        cast = 0,
        cooldown = 45,
        gcd = "off",

        spend = 0,
        spendType = "runes",

        pvptalent = "strangulate",
        startsCombat = false,
        texture = 136214,

        toggle = "interrupts",

        debuff = "casting",
        readyTime = state.timeToInterrupt,

        handler = function ()
            interrupt()
            applyDebuff( "target", "strangulate" )
        end,
    },

    -- Talent: Embrace the power of the Shadowlands, removing all root effects and increasing your movement speed by $s1% for $d. Taking any action cancels the effect.    While active, your movement speed cannot be reduced below $m2%.
    wraith_walk = {
        id = 212552,
        cast = 4,
        fixedCast = true,
        channeled = true,
        cooldown = 60,
        gcd = "spell",

        talent = "wraith_walk",
        startsCombat = false,

        start = function ()
            applyBuff( "wraith_walk" )
        end,
    },
} )


spec:RegisterRanges( "frost_strike", "mind_freeze", "death_coil" )

spec:RegisterOptions( {
    enabled = true,

    aoe = 3,
    cycle = false,

    nameplates = true,
    nameplateRange = 10,
    rangeFilter = false,

    damage = true,
    damageDots = false,
    damageExpiration = 8,

    potion = "potion_of_spectral_strength",

    package = "Frost DK",
} )


spec:RegisterSetting( "bos_rp", 60, {
    name = strformat( "%s for %s", _G.RUNIC_POWER, Hekili:GetSpellLinkWithTexture( spec.abilities.breath_of_sindragosa.id ) ),
    desc = strformat( "%s will only be recommended when you have at least this much |W%s|w.", Hekili:GetSpellLinkWithTexture( spec.abilities.breath_of_sindragosa.id ), _G.RUNIC_POWER ),
    type = "range",
    min = 18,
    max = 100,
    step = 1,
    width = "full"
} )

spec:RegisterSetting( "ams_usage", "damage", {
    name = strformat( "%s Requirements", Hekili:GetSpellLinkWithTexture( spec.abilities.antimagic_shell.id ) ),
    desc = strformat( "The default priority uses |W%s|w to generate |W%s|w regardless of whether there is incoming magic damage. "
        .. "You can specify additional conditions for |W%s|w usage here.\n\n"
        .. "|cFFFFD100Damage|r:\nRequires incoming magic damage within the past 3 seconds.\n\n"
        .. "|cFFFFD100Defensives|r:\nRequires the Defensives toggle to be active.\n\n"
        .. "|cFFFFD100Defensives + Damage|r:\nRequires both of the above.\n\n"
        .. "|cFFFFD100None|r:\nUse on cooldown if priority conditions are met.",
        spec.abilities.antimagic_shell.name, _G.RUNIC_POWER, _G.RUNIC_POWER,
        spec.abilities.antimagic_shell.name ),
    type = "select",
    width = "full",
    values = {
        ["damage"] = "Damage",
        ["defensives"] = "Defensives",
        ["both"] = "Defensives + Damage",
        ["none"] = "None"
    },
    sorting = { "damage", "defensives", "both", "none" }
} )


spec:RegisterPack( "Frost DK", 20241030, [[Hekili:S3ZFZTTnw(zjZnrXk)qwK2oPPxSNjTB7Snx3TDI3U9)SeTeTextrQJKkUktg9z)WdaKeaepaqrk50B35Unnre8H3VX79WdG34DZ)4MRNhueEZF3FS)5EJpB8iVZ9pBS)nxxSDD4nxVoy29bli)LKGvK)8hZsZl2n9V8)apzBCAWCac5PBYMrE6YII15F7PNUiQy5MBhnlD1P5rR2ehueLMmll4Uc4Fp70BU(2nrXf)uYn3QD6V56GnfltZU56RJw99e4gnFEiBWH5ZU5AyWVYB8R8F73UB67JJtFy30ISOK7dj42M8WDtFGGb7M(RP)4UPZJYdUnoC()n5VMM8mYiEiiVGmMpggSom7z57M(3cYUF3h29Hk4EgbU)y0FSB61PBIlhP0i8jJWZB04rxi9ZEKFgWzcASgimXh6bp83y)807YsxXgkbVwgKmpoKIVN(DPxtq0W8TjZYRE7XV9v(Fd5T)BrjPz7Mgm)FTjVyvysH0q8o)L7McdfflGbnUK2wNMghLSys2MKqb48nVY)1aCi)3VHbVXC4o(c()T83FlBEAonV5vNnMbdgor(VxWH554VdLT)pwsye)EaHk)DImmk5MRJJYlYPQzeSnoCsrq2IWcYp83PQVHjuX7nFhrRzgOODZ13bAPtYjQe3hY0zYIwZE01uyqMgkqiI20Ia2tiJPimlkGO5hetyTJcMCxirtzs6Dtik4X5J4Z0UPdaj0TBU7UrzbFonlAw4O8cIHYUPxUB6f0NZHr(YGcaQe28TXbZdLGbfcnMLnRVPGypOqA1yh9TUpkMk7wfmJWJeNE)Dt)Yx4Wo8piVZQOecFgaBf)j92yaAGHhzQodDQoz30Nurk3MfguSKINrjZZcwKMhutoWC(PaYBr(NJkY2eoHp(zeTS5PpKSB6v7Mw(pgrmUtaq9quczUgnFtgvkSB6RiMveo4qkdQA4RjKBqg8cur7OSWvbrjel33jmRuQAsPwDre4VQKILNpGQp3ev3zP7qghHakW6IIN(03SMFsGlWIUNq(1VgIombFVafFRyazesEcG45Ie(dXC8lVaGZRBNI1M1LOD10i53atP6nOtdcOIMreDpq8YYNU5uTN7tIwSKiVjt1DPel2krcDy4sQ3rLuGiqDaIQolMnF0QaIRWNVB6zsC)fXbZIcINem)tbjZOu030jk6eHXKTMjLQ0rEIdAudOQsLWC08W7IMfvW0Sgtv4mO88wZcDqXPus3sBE(ajpkegwXYqWe9ZHjtMTmy1Ac2ip(ktATGUs4m0GgS34ojjEcLgH5zcSU7i)LsuIbBAC(RN6krwrjClhpCx)wipd4hUpENK0m2gvxr7a14Lq)Aad05qKcxM9orGmzE4SGTsRxfKSDY8K5ukb3Vn40iTyeJ2Vl8teRKIOz3tysMuMW9RQGOAT(iRP5FX(y30NRvAAzopC)9UIUMO9XccPSzbjKOZsZYiW8g4)76zesyYYWGmJHRr8uqm6HPpAMA8AFpbc7M(xPGqa3VdwwyIwF5dASSlWVlvZqwFJj9KDkugHwnruU6YvKaboNbxNFLDt)MQWc6rmHc2wIiELRxymoZA1Jk)tsEZlNc1yZ40Hbwhm)mkvlaWwHMmEVDtFb9VWXm6l8W2Sv5tUBt2wjKRY(rDqeL95BzCabXXMKLPXBbFMHjlkwkrgQptlgoetH2yi2oWLrIe6UG4yyz2Sn5KLPYKCMIitShp9vmxkcshJIquoxfBf51pZm)YOtEB8l8Gh1XYStK9btv0rzdQfFjihivtOMfz45Dtg(wLi6mzhFMvE95g1ikeIscgGHvteIM66zBNvvWGC4vCmDNt0ManJEnS0ZZPl3muzjSFraX3n99e08tHcfEyVt2VkYe39IoqmlexYwe3Xv)Jz4rckJ4lcMSolIKnxXwJjSP6erF1HECOinQMACeydJ7CzkQhJXIDrNfDfQslvOgXPwdtBMH6bTAvf0R3kVCHf7C8SgOwY6Wc1kbGPdkxtjD6V6lrHunmgkIOpc1ePQif4vWqmwBg6gqDYnjmjCvuipSIYAuOJJQwFcBk(AcWhb36SjYWslzRfwqkdqfDb5K)uzpxszpnlcr4CUdMASrp)ZqjryKpRapMYd2TAP7CTiE05iQRP6GrQlKK(vH0IbQRD2rokYSGhQCLfYzglqGdfaXJs6sScaSMs(3sHhq96JPGs8QZQsXbl0pHTqrjaUVJoXTn0Tt0gRLtvJWum9UMsWTPjHlio0i55iaGHnLKxj7ANxlikgtCLwSmlmFjTimVsmZBNk4lzjKxlMO9EvHo8qqDSaDNnwWzelS(v0rrRd7Khcdwtq6YW7v1YBWywpzgDpWzb7)C9vaW((nTxrf1afBunoxcRSEAujU5BLKfK4csZYdJdZZfOeJg2QH6wfl1az1mIcW64GKKYNXvR45HUilDtYChkbPuw6gnnKIrqKCLKBcvAgFhSSW1AObJVZrQkBV2Olv32fhJ(qZOl(LBYj6TXPPZPvktXn4hPVlXn4TregCeSdgA4jLLdG4oiC29MDrI9s14sir9lJ6GWONaRaIZmxtYBXsbMScQyi678j)RnZxSIlyCWadfXiXGqcfGeqYSG4yZMxwb2DrzHuXNz9xxxcXuLDBwWibPwWc6sdKaUVp3SbGnRwllgEsFv8wwYovv8YPe8BSPXQ0Db05slwsJt0Kf3kYQ0Kjkm8ZQ7(Xpb(CZ2SUqw8bo3hXZSzgX2MyFmYwBJGTOX5m3NsPws0Ji(NdwLpbGoLQH2POzm923NlNg4GwTFybjeKjybHAYxgghlSHysoYLgKo3hifpqsa83iI9cY)B3uENV9JqulVC30FA2wOjIItbTcYYD7M(BjXHbKjBom2WKpVvDLrSQmOlF5lldQ5e3wzJpaOT3iX1e8qWwTph1iJnngkLlDltqTpQ3)x0axk3Wjh88kvGKbAtT3HaHDvZZI3UQ4PnSV3o2udx1mce9DRKMIz6WsmTIT5mB5rMUDy1q3OBxDA5GMLDngZfTWibJvItSQgOVYj2e)))jRM2uI2(Ll6mx6XIn026Q2s2WrXMslLr7TegFZyYmRtz)xLEkP8nLlxdhhvrbNcgLxEdxbHPkq4gyQhLoyjT4pE0fOKtzNrKMZK0n30t)lmhV5(lWLv4YdtMdk5ZMZWewKkKOCsjbAhgY2BTBHk3d5qlTH0z022pNegs29sHWFHleO3fcrtEBkDxGj)JjXrRU1C2O2cydH8mpDoe3u2dc2MwyGCeKKxmjo0jb55bBIlKvBmjHQ2vk77()vSgu15wf48sORisOnU0nwQnLdHjDy4h1igjK34yA6Mb3BocgBkjTW9Qr)sMSIf4OA8JyUocwxA7KMLt98XwkZAiOfxvQvYkulwW36LQY9QDSasxn6HwPkxkjHvUUdg6pXIdFr66c3nQiJ(nwYhZXLsSZQWl7OdeVRSs9MNTq7vHabe3WUI2n0AGZrTnOQiu8Ida15j5ZBhj1acMwnJPDW3aDZKRXMq)alRmJzg7YuRUru3Uk14GL3MQbA7)xvy8nJfwe7elMr2Th5BZKLbx23Pg13BQMF2yX(WGvjU3vTXhI7sRyXi1WqV56n5WU2D3KfZMBBBQfJEsjqzMjjRUs0Arc40KI0jZJ46QNvsNL9FHaWMW)TQteqVW(VaVvaWdDQ2Wllc2O0u2gAs88nliE76CwjplJnO6xNKK(GvlIMbxy1WY8Q4gntShpROZskKRBjAkxcp0PN4clan1XoMyLdlZ66kDcsKSGO5tc)eLMMppFu4FahYuURcLNfPu)zfMNq9NFrZxwO40YAk39WDIDeGgREZIlxoxhTqCjvXzBCsBQQyC3bnFuPlEn8835IL)R0)UA(z7scZmCJNOr7mCBR)2r2oZmbykSdbsXdP0)I9uxgO5SJyNV3kBoDk9pQMIML00CduwPSEzXGiYtiXPnxuBaEnRXjZweK68wFl2QoaXTX0qJjxJCWRnHbfA1zWdaUzY1L9dP0c6RNvm5SleYorZZhl86QUvE3LcDpgl2avVmMSiSOURLXiK7J91tT1U3vPVPCqaWmf1UrXdlJvYTOaoX2A9dAgo7fJLjABXj0IGsST67qC1pJjKGk8gyUAWswU5Z2scyJoz45yGLELWez7mhO2Us2RXO0HcrO0E1nyKVXki6eAb(14gXUyYyILxBqscHDdTtORAzcPiTmR3FLy1vTSSJyLouP0zlbhn5IxPf2xu6kdaS27VS(peVFCkHA5hVwrvF7ZOQGUI01vpzHqqBe(vvV5ZrlsAmbFIleIUpm3LG302hB0oA4oOAMv7ts5GK67eP1YuTLK2(K)s4DHj5eeqiGjO5LMW(htG7Rf2T2Ye2Lg086xqtDZL3AMLPPqwxVFgtwbqHWtsPE8CC6kToY1v2CNGa)UekxxfLDca1T9JMca7eeQ3Dld7jSriu2QFgl2zP2wA1zYtzLiBRY60QiIfAX4bYGBA6Y5CP2cg9GfinQGpfqCGpBj6ZrQ8VTeRVe5iaBw4wDS4nwFvtlLtwTfA0Sc5Gt3KGoPm44wDr3RMXZsShUHLsNYtZf1uRxqTSfJcJGuBx7gQteetB7NhcZq42RI6yEDw4S0v3gO92rifeXHfr3jjFyEMgv4nAzq(eijfGNRScUPmiBrKFaaRNV6vwRwj9PgwISEue2149jiyZLyxclmJMviG6jZ9hi(e2qcPNitdQasE9m)s42J7trZbC62T7MYOXDttVJEbULxqgaFttktWHTTjKFhUN2yioB81O(ZeMHr7M(tKhgva)iGnHWTbh5VNal5rDYqpO6zHfBYiKIhmJXWkKL)Y4rxmIUMN8Axt8MaxHC16MLRkc)nY0mbGYnxtEB(pCZ1E6w5xqluhKuNvF(SQrJ1)iRX6)NdnwTOPOgRrXLAWuCXfQyVHhKYjxJbVS4IYk(A6HdB88O8rWUUpdY3BtojJVGK8vrqh4P3aHwjkDbj2cUOVzUOQsVeg)1Wdv5I(TKl6xZfvJuULUo8MuQ)JSGNzeR2ir4vaCtaSLwoxOlS8wIU(MrxB8rnORVr0vnhGwIUcNvvXQmuvjbfRc5YmOiSr0YRnckZWgZvdxPZg8T6n)uTWqQq)87nOrxqljSjZa2i1apyfnryvEhejJErXFkMUVdIAS0FBifr9gZ9Ot))VQbe0g5Ioc0ZjcuJ3sec0Zjc0tdb6JsGYA4EvQY(6Yg1rn55bRGZCAxuO19CrDUgugKsHclWiPPMkxlwiH6FliMKBWscjVEZN)mjzHBt)JoVk3QGKnbXAZ7RfONVBONn3En9IkGEizazc94vaiao2lSQLLMTsUELLXVfvq3yEInw5ZfrOYENuBQG2reV3icS6(sboQWuqUhbQX30ixoO1c0PURvwj2qY8jrjtMhKDFsyEUoEroC82Nnr4ccQqtxuauqwikn0Kxu1Jo1vKeybGyjF0TP5KXOKF27)1FE30)jhO7M(l0F(B3n9Vcx43R2mJKA1hHncbU5SP5Gbfke6kEsQxqnJiVd)4XTB63jKl211DetHMoFWrktBNkkqBVzSJKZVLdcj2vwoAlncK28q2Uqb5zUmmbscKD1RdjWcul9MqpmjDZILS3GEzO)dLPO(rAkQ)EvN91Ojc2dkxajfO9Z6iPV(at46IMYbcNwDkgnZp8fc085osZmT3GKTm8IqcfWDEoD4pqYjfCNUvux(oOwc)QqTh4NfrgBt86fdkNa5br0ciuqRQXInbexWfHHVC3u4wJN9JPbXJOmcDlg7aJOuoPElriWoETRQ)VFv6MKcgLjBodKpOFW2pkmBygR6wcizaUs8)r4CXql0guJphV3qKr50FOEVi(5i57wk06IpyNt7Id991C1GPPkmLiQP75k0BwdD9expF30qPNoFvljvri0l8hyXm1kYYp2a6Pv82)JHV2U2eq3cOoEvcjgmElVtW0tOuV560PRXDdBM0Ek61JkgVYlcfAWcSJL(x33QY4Bzdo9udpD3uY8aI1Ey2kdzgjQASovc9fQXwN2G7xlxmanT4QXKUWZ4sEJ4TlDnxEvfu22(2XU)QK82)pkLbg8aZjcy)FItle)3swmIP1dxAISM2(kAzD1XtSLLAzACcLgXwYSu)hO9buB594t1W6zZuJzOHKKQZHVW2e)KgvQrU2scpuOrCe6mXgtwTZ1llBuETIE(3Fg(RvgIfn(myp9dH4Ni)r0kIF158DS5LLHTbHGSHgql9c0GFVqSoikRoi3gHXnY0YXC8Wht7Y3nTlFR1aXjTlV)ePD57M2LALjvQ1Y(ODXAehjVd(6cdXUhfvh7ARkUtkaTY9I9U2QnIwlDfGAqaoFaFoXbTIxRSUrZXA9e5m846wczCI(kHAsQSy2a26Cn6LQGKKqQGGvd4IkNCQ(RQQwchTn25t1oLuuYDrH9q4X6)OW6Gc7bYthQ)BNuy1SnC2Dl2T69Rgjv1aq2FbX7I2U6dqu2CI1Ge7B9w(Gu1vlVeeTAkvUOUbSwuZZCC)2Z84QDLFyRKJMW0znXse)Wv6G89RgXRyAs8w4pdH)Gx5ioktcEllf6)NCAvZa0)LLJacjmf22b2Rj0qp)c5NIiaojmI9C7q72uAzTeHJPu1R94A2wOvErD1wWxRTqRDVGzlOFbIV2Tf0G1gTf8(QWwOrqQfsnRTHkMYkBP2VWMIThUsP2GnDAs(MzZsZewCopnoL(3xggexSC06zSRCW3Yptlk)SpT4mAsrVEYA8gc1YH(O8cI9UUeVuq44OzlVnnt5UPg2In4(PDcjOPIOInZTCLIIrGxGrG1tvfcWeoL6rALn23sr1YMYAKvjP3)SAgK2qWQt)IogF7N4ROtC9eiCow0jvSpbIoVKoRosrNiDCzgkrHc3KbAKL2raQ6IY3rrbmszdv5(h7wNPpWEvIRjq5nZfPvTmqFCCPX9yHi2ugHBJbHDCzeVYvB8s10s9NHIQ94E7Kc6DVP25x4XUmZcdVEopHogwFWWUMVl3xIvPLnBajvhINo5VveAEdQxpv0vOrzQerRRfqinNMDbKPgP1sssf7tV)lUeL3y11NqoXGoVmw5S(191LMOqSCT86R)AdnUNMcXBU02xzpybf)5)yAg8byh2u1G1K4pdMX3GCHTuNglll0LYcbq(PC6gQYVQVH5fEEkuhH6O8kwguWF)6p07K)(Y0nqIVeZjPMYOAx7jrj)9e0b44aa8UGmbrjCiPC8qGE4iowPh3BU7oOMg8o1YoFJBi5KOq3EC5yFSX6HaL7UrD7FeZ3hBFWu21mBeZKW)yD4mAjQFh7AttKvCM4YMN0kO9IYYuDQ85B(0Y44ziA1WEUWVxtxVO8qIoSCqEJhRBF1CKLYLuoWtL2toVgfFs3MgQHb6RWaTaH9JPPYX8h3KFThD0xwJBrTMn1cLTyB5GwMsMfEKyotTqFSjDiReuRJi)TxUOlTBOzIDGlQeVRzUNIioJLP)MGITyMtEPuJBQVKLoo5xvD1vnyxZVEqx4KSEpfXvDNqXE1oNs8d0orzG6q03tl6IN48krJZtvJr5(S5RePP43UQI9Q5uvLMQkZg(k5WxnR6keXNQOibWtrbOgV(SV(kfiDOQv5S5OAftBGlT4zR0Xp4e1s)sRU6VxtK85sUVSwBLqv)3Zj8NInRvLLsxo5mKQVoI2sQ2g)8V9etjdRmaZNtBRMisgc1x9t82W5tHz5GQYF3FS)5EJ9F7iVBU(HGmOycKqePnhqejbIScEBz(mPJ17ZGyC)F3W2W)CAeZbBks5DlWSLbjlGGF)WptJ727BjHbNMqMt6JFwjfQ8H28zSqOXECjPrg2jE)XqBqxLZOaDmgNk0ptp01TGGYmyA5f1z58dknGa96oOxbUnBTEvi(nhu89ThfEoYSy4CiOmzoCIfAORo(GY48ooARExCCMMxFGNMDFqJFU67SI25KZxpYkgkQcsQlkvvEacuPl9vFBUPayLN2sxBDeJrC20rOIOXT3qvROxbATq4JGE9Kznc07P1pr8d2t4oc0vIssb4iXq5iSvsUqpIRM6rdNpiHv0liogW7iMRvPM5kSDQZhvFzh0fCrwcr6ZVPYSO9tZPJWDV5qAfD8Jyu7KDiHMjTSMiE18kXsLwrGyVTmSXzPxS3qGDvoyQEovZnZv4jLYMkq1Mpxdpdibi2VkwL1hiVDQwilTV3Srm41D2iYkMQ79AdlF9B6RJqVE)vvGBZTX1ri2CpyvGm(M064miSNTkGwZU56OtqLImPaxKnV0ryV32bpcq9qYhoKWwZghRaFdBTSfxLPR58s(gH(StoXwLXR2fKx4n8P8k8n8PNCcm5KF650)wznvFXfdho85EJhxIXTd(Nwc)tTcFSOq1qHg3JemQsCs9hRsu2aPwcrlipCl9ygS9C4dyHuFKMMUYKosypsi4DmVdNaExtK8p14(zw8riyz(oKDe65(pNBtpqEBLUs4LFkYlxI3918Ck28utYib31lXZJb89osuua29qrXaDNvT0gzp)Yq(zTkU(3Cq8PHKK0EdvT0B1fqD7OyeZ9E2D7XzwomLXfbQcF41vaQMpj7ocZoIPhMcoJa1Ew2DC2iLd9(O8iKBvVSQ)HXVhcu7zU9XPOCpQ7e7Elh0Usr1Dq(ZA1kfncmNFsOKV3jRqVmPJjMWJLJjqpb3lj1FKYKaLTuLUD5bJvdVr3yoOG))WD2hUtJ0uquVhCIzv0bpXbEibigWXN(u0Y4uoKlhp8lFXPjYCBDwpLMqiYSn0Iv)XGTC85kwzk4H)YFtFZUoB8yxIPUxCDECIxhNTy36v)yoOG))WD2hUdURt)dQpcn44JRRtniKwxNhF2YXNRyLPGNPSuuNLVmY6pcp2C63saDpdL1mqP9xDzdIJaz1X0ZGVdi(QGCssgBnH31dPFbEhWAYZYjQuKeKmI5YdR)NKoqblbwJjCVCa9jG7a(cNaptOl)59iyBpYIFD1RzkmoyPjSrzY4aX3SJQgpUfaDpdC0mqn7jr)y6zW3behZxI2H0VaVdyTjFiOdR)NKoqb69NOza9jG7a(Q1JsZN3JGT9iBlCuzzWstyJkTx5zCDw6Sr0VJSRZnv3eSX1ZtdWTM0EW3c2wB8V3O87vYj3Oh8X1ZtJr2go4BbBRnABn2dajJM9CzrmG2PKcWX09lH4dm4DaWUUERXLZ7o4X88Hdz4RUKoTo2p7eq80deVwce7YghQsDFdEhaSDzJdPC2DW3wrFVi16I(tJQv9eH(lKcOYlYVbnEa)UxuQylIoC(YxEcIROHF5l4qZCTB08ELpB4ZpXB0fVaXAK8unVl8HHdEVxinTaJ7vksJHp1B84HdhE1jMRlVg(hgc6zfb90IGEkiOVecwQi8vUK80hpj5PojjBIGhnjjhbRD81yp)5VqRm9XasRCc1yh7RbI2VEE6al2aDFICnYT2eWBZ2vUMj7gPzyGTyMCL2AtuPONPXaPpRGvZH2NIUN3yBTE93JqfaR5lvydGI0YyzhYZmi2K2H7lb0dMFK8xPWgCi9FedRbpTrxUlnoo9Hi4(SkG4Akh(6SdxUDBO359v33CSBhMDtzx2C3UPOCC0pHA3bh3rXrpFom45bfb3gKh(T7(a9tgeKRp6jNN57SLDF6JqZW8Nvy3RNmNdZH89O2JN9q7zJD267oKpQ9dzpVl8hNUlSV7qCJqTxSl77ov0iu7zU9J8bXQJ8OJ1jKcZtZ60zbXBxtITpj9bv)bspSTGUVPampA9afGa6EX0cd4DvV5GIZiEJ7dE9H8G)6H0J69bEFyAQEmWEqzh9dWXUNXibNfsFDDxEpkpfngUdZz2fdS9SRQh5PPRmjKqDdtMVHNUSsvIrEEBNaiv24ucayFNwvaVYtBlWv)soRaDSp0Z1GxBQH8Yv0pzg23QhQZsvjMQ(u3ubDHcfk8mZG7OI0DAdgDO5y53zcAaSMHCabogyBUtg6KzxnUz1VlllUUcMZ(6rn4KtA(WYYCt3xiTsWnRHcNBxeJxd9HmOJC)vCLHku)u)Hdo5jiI)V8fdCynyt5vP8LE17UW)wZDp9qXDR0UX6NpFd(M8X9nDCUEqpYnVSv3hAhYbe4yG1GVjFZwp(Owp(MSE8(k06XhZ3KhM1ttoSjRhFn(M(3rU7PhkUBL2nwl8TNXnDCQoYrUFLT6(WECt9lWRalwNeUNRSCCUidWB)XoSYcoqTYGTVYs)c8kWI3qJDqnghOwXv7QX9lWTc290j0Xz3vooiDVu9QJApNUFgfhuGBfS7P)YJZLeYXbP7OIM2cgfKcZE3RvuNlNLXeN68D4LlqVB3Xnh6DYD3h(jQGdaU3zYnzciDU561zP3fbFlI(V2n9hGVhrebyo9ldoxNlV(RJ1l3nDEe8PdNaTB3UBkt5b(CmsumaYKmaElou(1KJ1KdKFh0By4mB8cewU03TC4JHEub8J0Vos7MUeAzMKuqFdS6NtbEyXMmcD4bZym8nIS8xgp6ccDXOZ8rvxRmV4YQwf8LWhDNl5uhVN)Ez66lPFH)EjDsV07L1FO9UKaYxolnzEeaZlL9XA7irB8Oqx3lN6As1UFeOD(Op)ud4bC0NBdd1FFzO(9jdvxBj)yWqrol5THHYZKLZi1VeVOMKixSovsn9hV2hYppHAF2NQpTEAF(s4D1(eOV0gk(e82ISnSgFTSgFewJpcRrZPgr7dBWA8TWAupYGAFIcRXuhJ2gwtDDqBykEHOTyTir7z5sRJV(bd9BjgICAZ06jPFWWYcROIF(IONNac0L25hTB(3NM5VBNkdngeo3p)kTZp65YOBhldnEZCUH(v6NF5dMHlQhZdwbTT8bqlbFlwKX2RUuMyCbRRNlwvtBSEI((I)q40wlcG1y(9NRXShKxUGToVsd0xV(FD)V7cW5XdWVPLlDK9gxE18IaOHvZGRYzniygEpYxHS194Ua(l3D67(ajc)3)R)8UP)t(SVB6Vq)8StYb5VM(WUPR2aFv2)iCpsVB6VYIIhs5G9vtV8BYoK)jTz2)oHO5VUkgixi4AEvXYSW8Lew8l5FnDalia85JUnnNmcWOImKWcJO)VrBLE4oULKoaiM5ta0M1eTNflkjfHp38pSmmr4BbpjLhG6Ibgrys6Mf8pq9BGKl(HYKA(inPMFNMuJluQiYSUevQO13mUBK36VEioboDf5DMBuht3JSSoddiil9eoqh(dKa1Hmr3kQjsRbXVkK75pcbXxYG(fXMdIKoj5br58trbjR2fBciEnkcdjzo(V2KZ)X0GyNYAK25rsFKYRO2ZDJAF)Q0njfm8w2udaiiNz9FeQ9fLrCluUfkGReJFe(GD7ajukXaVnATaFTOwzfejWzf4r5USWWphsjX)si8nTj6terMWOMfehpH9pNaLzGVMPWyjV63Vmnfq63tg3)x3D0UBJBJ8zjyX6ALnjRLC822dog4WHROf4(cx7H7FRJIT8AFXXYqYPzdqqE2VzOiPiPMHKkXBV9kkqrwzrYzgoFZHJAV0liUa02WZMcJIyHLgpI4n1nR8WVQY1LiMvzlFp8l2(L(6SnRu6(BF4GHNiC35wGVhTlDhyfee1fNIPNiwtaNcj)qkF1eWfZaF(K1XA704)1px35(BFI1LVaCwfuJxpW6ti)0R(0ILjMeeyL7spAWMZWu)T4a4)equ8DwUbNpZIg0GcB(y6JZ9(9doj2vMERnVSWcpWxO9BE9SRYcpfWk2(9D2ZKDvkkZI6Fk)ZTIx)fu8sRBaahyD0iEHM02L3AatMyBOunSp5GwHLflYF0KwixK1LpSvMGvatw84cnou3a9NSSu(frD(Qcii6laUNBr1FotuZR0S6KZJ2ZzIp)(dyKagWKjyDUNCYI7tpztSNEzIFewryrLTeuhhXQ(JxTr8y8T0)PNir3Pt6aSTSahvYDxAs1ouQPPKxXHJQAMMnWymaV0Qnl2Cyw2eSWi4vOzf(B3pUsZ0rvAVQ6GmppTlDauALJ(VuwbHsEqcGeqMu0szy(pkygalVLhetD702au2czeursHUgEZmIjRdVv72FBSdGwDozzoTBuAcLA8i(A)NyUTnRfe48R48HHJJ50pKKGMJcPlWGu0dwQXJugpPU)LOb0E9H3j54Sp7SUTSzJiMFW0zzvDb4XtTbo7cQlFKMAjsz2ULn6BD0zlPXgQsaY)EWQ(o8PYToRp6QK04RshP9bWKrYqC1eiPOHDyVJg98j(o9du0ZaQPB8rfJ8)6FeD(QDgADidnvVg9Nb5dbTS4Sy7NdWVmyydFPhPYHNGV981WwYfzRBesn(QVkuhm7QlF6PiETVdD461SoFxultQ1jy4NKqXuWQjIb5bERHKdXGslYXNCTe)y7xy9bABco)am(8LpMOiAsUC9f)qbqUp3yvFDKbg3VxbEaIkhRUVgCgPsQlMGCXEEwQkqmDIKWrstzqAj1GyiJFDOlx4gU4lpe)YPeMAv9d68wdjwxwQ7L9N6(9p9ui0y6ywId6kQuTLBSP6mTJHxSVeFMW7bMdyLbxBlwwYbWzALBqQNtmox3SHaK4ak6amrp1OW98BkVBZoXwkeA1D307T7wBKf7wkYo8YAqXkMo65WwCrter3GrsGzI1OELW7lynOoU6w9E5eAGpThapPygfqspLb8QqLVCo0MmKFLLoI9Qbb)yVcIPrieCzInjdShrJFGTpiwAu4l)wlm71Hh0lgbJml)LN4B4f)Oy0zqCgyrm1mzXyG53F2PxoIXPyY0pl(uus)og5fUF0nV0iAZlE0d1aHtcZbo9BLkO7HcqgeZ5TErmduCS9ItGhiIE9g4VMxKqGYENZ3ODHJNC6hXnLzPXt(O327l(qVCud)mSwrkxTAo4PNmVhEfHmdmMimsDiXTrfyoIVBeMSwwMVqCUqyUEFj0txg(jBwPXyrqneRW0PGlxciLBpY0UgvGVdrovm)04Z0FRAxUb21hNOZkNXKmx(mCby85pkAXega2jaaegBzoR2SS5s9JzOOTFkOcc2UdleWOypvT7HRIXfhg5Dce8eA432hRRszl4ooNHOd3NthjqAQY3SCEXVkGLLlRVO4ZyvOccbopFJrw8CWhDA8EN7G0fks7gZQhwPYjMdh(XL2H(N2tIxxKUHymW9XOwLoKNPH4)pV7y68iFeSxl9HspDpPqdmsxXHhkf)bVpzdSYAriYJhU0U0IFZyCzuXMVbiQGDZL2wJOFBSDKmVrHQHP(k72vYad1U6hQZ2bz(ONMf16z7woE(kwk(3V4W8XtMs(8rWRBlwnf0jj8qOv6YMHILZHepeoW5xdmdQR8S8ZnLxr(b(SPBMAOavsC0EsmzKcW5Tq0BVL9zFSEXJGfWw3DisMihHKj0128pt7kOC(6EEIdiZkT)4QLPP)ugwwZKHhCvrjuj)mp)ghrsX12PLYWeIrRZlEu01gbJlCVynkvvFvwe(hXojkTrTSuoDSMGkxBP)jU2DtNaUb4y7CIwmPZzm3XkBtkUEZZx)JBWky6FipWt15CxlQuQNVEA(ZxdUAV6QVz9Hd7R)dV)9p8Wdx8q5dRbTOaVWDVVEFX2TxLoA0hg9EHq25B2T6(Ayo(MzYQX5NKpy67ZNH1t1MT9yMNKM9TPYiyoVC15ccem1IhyuZsntowEs3V)SNVUP3WIv8e(xXUyPtYY(2VxgadUAgxTMz0fruZ6ILrfwDaQDuaswf)Y2pCmh7ETXo1Vymkx3VCB4Pkw2WVO0dOlXhqpWMD)A5Ta3fQvFx(wHX(MATOjbckoIM4y4SBW7UlP3XbJoGrf)ltd)Bq2y4FxD)EJJWYKiyusxn(liSlldctwPNwQ1nhC(oWaE(Nadvqe)B36CWB6Jg8Yr2h0XQnvGY8CWXiCbMIobe6i)JkeF)LdGdWA62fqM(RG(Pd5yB)qwlH)aEa0Gi5pTauV8l5BfAxemX)lvkoW3fZXbnXPZjmYD62ubtqhAL8Hyzoc8N5pK)O(z2ogDI)0aWMHlwpNmpUptK0TawmZXQrfP0UhvTxvp7eWTxoC)GmNFurL6Qo5QrvtlhSkPYJkI7bj))hCXRojQDy(Dr5B7uWv0aCJqeFXj1jZg)UJ974rb(kIp8iGuhngs5zPAwl5(Q3lZ58DVWQbsgFHDuMUEqJf6qwc7ctxwlCH16lierXR0sG1Lxg7stOf51T4HdoZq5elyfIP6ldm(IbN(wOQYNNdUuGTfIsRm84(uFa2lILns(qQ6hLviGZnjEM(iQI2EwNSiuy6XAv3kJNUO6NoP7KAk6ogpzLHD0B1CsytZsC9fmnHhTdXkPpJjILRNSzjdcugYk9UoBfUfYXvPAhwDm03xvADkO6EsC(Fh(eb3QFG7OQ(lY64UZEcz13oMDaKvOzX0uZ8CoD8O4zc40FiTB)pf0yWI9n4nYFJX9e6c59XbM0B2wwUuFsgAcHY9M5lwxS4wYbwuvxuHkL65aLKH9GU4IEo0TOIO65)N7x(P7KKWEmAKtdyca2o82L0ZbdXRxiOv9CC3K)jKjbVQk3w3KDH4DaJR85IAHiRtaUfAiZkfS2ppDS)84k14lzj)5n4f4bZLak(r5ez9gJR4JRSBl5RJT(EQmpcFdCHedNd86YeM6zcNy5N4Uks(IF3pcN)A9AiqBMaxcTzXDP7ynXcog0yWwhet7D6oXhfKRO5P8z)fSXIX4szKOWZ0selGFBAFXC3k(nSyVOvTorn8eojmISGonZQM5dUnA6LtKzhTYxFciQG2pAKRtgAEE8Uoj1Y0hlNzV5a7f4YpngNv4lpFjN4vP1aLuFWqjdYZe((tfw)B1xl3mVoBfDCH0BYEirGrsBX)I7Dcx1UvqVjWQSay9UZP4)KxMCYMpccnbnR8bMkgZGOfxldY)zbfPO(0pqxxzOt4VbpYS)TOdsG3i)fL3TFBXHczFz4xQuKaXFRBalxFiV(2NV(tq8r7UW(y3mOUlfN(pfrCoo(UvCjJBBDpAz7D2RfDTs5cRAnec4ht5ybEepW)BJSDvk63kNPA3eyZvO5JZP4OQKN7Z(8MEDzZu15yoVWpZu92YdQErqtKxh0TvNVo)0mC8A75CFWl4(Im03pidXt5ZSO8FT245pEuEU25px)MVVTBEzV8iF3UcrRlbHoZghQR8KUhcjxLaAGTfA6OA44jbXxTn(3NowLdU3B34Sp8YQR7KVeYAe)AR49m7caCaAFj(D4m(D4xVK6V)3HpwY0KAF8Vd)MMU2B5UTpI))IMYks0vIKtby(SQe7CWnTwyKyCM6nqJYLyjnyxnsx881)9QMssAxXMMFp8SDtPO2GSMNO5aDsjApuG06fhtZbetv8lrAe3IhsRO71W5c)Sl)AZ9YNvqXQHuAagiliVNQH8kg8jpHViQcE)idTHMrVHgH(IWBOzMBOXl8zTHM91XgAwWn00VWBOcDiQULMHndfGG7WQ)w10e11dSSDjIJXUrifEwmQVxYzzwuZIHkz5Sq2nnm0SASUjXScD6nKInvD(HmwTC7wjPo3lHAvx0Pr2QPb5b82BbCYfW9YaQt1UZDe0iLDIchESUFm48InG04eJ2E5JqyJyX5jN72hWoRgVsZ8nC87gMDQkfv3vQAhOGNif7Qlsm(vSxAkhSvVILNYyFmj20hhPd(tO4qShNHsimDuRmOvnH(v5L4xi8)dLv3D)2CSFiMVhmVNVyDNUAPWvbrE41rsapQw0levh0hMUc0HcmqefXhFT8dYXxVbxhKAa)96Y7XM8cWiy1Rt1notWjK)eaoySl4eKor(XHtmtv2TzoS1OU1SnsYZvqLFm32hCuPXXSfdhs1SrhioQ5EwOjmgmT7zO4INddENSNx859flouS8DPjVv1eME7qX5Lap60HMxD93nbKmpnD0itsZydC36iNNOs)A0WWuZMnapEljS(rCdZSD5h4qwtCfpubxCnJgx1zbnDK)sMose0kr8smQYQna0S1lujiFz67fy0PcHiNYJcFEET7Coqg9b7ffgRiQ26ZjteT)n5oDBmtGQ7fZEWjrj5MWvx4V(8gpB8OKboIqH2bETeEJcDrj6WuVWSN5TRTOlt6E(D6jH9C96yrlkxamDhVvqPBR1OnVb29BoHkk9DLmBMXGFlZGJbS0xWvfn1NhfkVOaQM01SExUecfzyJfqYd22AbbFo3DRY9aQwoi3V4o7DVDzPS162tH7(T8Lb2jUovB8i3gGldZKQUqiAIYx02SKXtmraLThLPaBeoIwF)IfLvcpeRl3woyDr(wGMVFXHPFp4aOX)mZ0nERzV5LQpa0wCYTgdZqW6sa7dGZbY1HnhUFzlyTDZI13uw5uCOwJw)k4GCb7jUG9h)5Aq59h)Bzts)4b4)(4)9]] )
