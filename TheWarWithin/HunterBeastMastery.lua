-- HunterBeastMastery.lua
-- October 2024

if UnitClassBase( "player" ) ~= "HUNTER" then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State

local FindUnitBuffByID, FindUnitDebuffByID = ns.FindUnitBuffByID, ns.FindUnitDebuffByID
local PTR = ns.PTR

local strformat = string.format

local GetSpellCount = C_Spell.GetSpellCastCount

local spec = Hekili:NewSpecialization( 253, true )


spec:RegisterResource( Enum.PowerType.Focus, {
    barbed_shot = {
        resource = "focus",
        aura = "barbed_shot",

        last = function ()
            local app = state.buff.barbed_shot.applied
            local t = state.query_time

            return app + floor( ( t - app ) / 2 ) * 2
        end,

        interval = 2,
        value = 5,
    },

    barbed_shot_2 = {
        resource = "focus",
        aura = "barbed_shot_2",

        last = function ()
            local app = state.buff.barbed_shot_2.applied
            local t = state.query_time

            return app + floor( ( t - app ) / 2 ) * 2
        end,

        interval = 2,
        value = 5,
    },

    barbed_shot_3 = {
        resource = "focus",
        aura = "barbed_shot_3",

        last = function ()
            local app = state.buff.barbed_shot_3.applied
            local t = state.query_time

            return app + floor( ( t - app ) / 2 ) * 2
        end,

        interval = 2,
        value = 5,
    },

    barbed_shot_4 = {
        resource = "focus",
        aura = "barbed_shot_4",

        last = function ()
            local app = state.buff.barbed_shot_4.applied
            local t = state.query_time

            return app + floor( ( t - app ) / 2 ) * 2
        end,

        interval = 2,
        value = 5,
    },

    barbed_shot_5 = {
        resource = "focus",
        aura = "barbed_shot_5",

        last = function ()
            local app = state.buff.barbed_shot_5.applied
            local t = state.query_time

            return app + floor( ( t - app ) / 2 ) * 2
        end,

        interval = 2,
        value = 5,
    },

    barbed_shot_6 = {
        resource = "focus",
        aura = "barbed_shot_6",

        last = function ()
            local app = state.buff.barbed_shot_6.applied
            local t = state.query_time

            return app + floor( ( t - app ) / 2 ) * 2
        end,

        interval = 2,
        value = 5,
    },

    barbed_shot_7 = {
        resource = "focus",
        aura = "barbed_shot_7",

        last = function ()
            local app = state.buff.barbed_shot_7.applied
            local t = state.query_time

            return app + floor( ( t - app ) / 2 ) * 2
        end,

        interval = 2,
        value = 5,
    },

    barbed_shot_8 = {
        resource = "focus",
        aura = "barbed_shot_8",

        last = function ()
            local app = state.buff.barbed_shot_8.applied
            local t = state.query_time

            return app + floor( ( t - app ) / 2 ) * 2
        end,

        interval = 2,
        value = 5,
    },

    death_chakram = {
        resource = "focus",
        aura = "death_chakram",

        last = function ()
            return state.buff.death_chakram.applied + floor( ( state.query_time - state.buff.death_chakram.applied ) / class.auras.death_chakram.tick_time ) * class.auras.death_chakram.tick_time
        end,

        interval = function () return class.auras.death_chakram.tick_time end,
        value = function () return state.conduit.necrotic_barrage.enabled and 5 or 3 end,
    }
} )

-- Talents
spec:RegisterTalents( {
    -- Hunter
    binding_shackles        = { 102388, 321468, 1 }, -- Targets stunned by Binding Shot, knocked back by High Explosive Trap, knocked up by Implosive Trap, incapacitated by Scatter Shot, or stunned by Intimidation deal 10% less damage to you for 8 sec after the effect ends.
    binding_shot            = { 102386, 109248, 1 }, -- Fires a magical projectile, tethering the enemy and any other enemies within 5 yds for 10 sec, stunning them for 3 sec if they move more than 5 yds from the arrow.
    blackrock_munitions     = { 102392, 462036, 1 }, -- The damage of Explosive Shot is increased by 8%.
    born_to_be_wild         = { 102416, 266921, 1 }, -- Reduces the cooldowns of Aspect of the Cheetah, and Aspect of the Turtle by 30 sec.
    bursting_shot           = { 102421, 186387, 1 }, -- Fires an explosion of bolts at all enemies in front of you, knocking them back, snaring them by 50% for 6 sec, and dealing 470 Physical damage.
    camouflage              = { 102414, 199483, 1 }, -- You and your pet blend into the surroundings and gain stealth for 1 min. While camouflaged, you will heal for 2% of maximum health every 1 sec.
    concussive_shot         = { 102407, 5116  , 1 }, -- Dazes the target, slowing movement speed by 50% for 6 sec. Steady Shot will increase the duration of Concussive Shot on the target by 3.0 sec.
    counter_shot            = { 102292, 147362, 1 }, -- Interrupts spellcasting, preventing any spell in that school from being cast for 3 sec.
    deathblow               = { 102410, 343248, 1 }, -- [378770] Your next Kill Shot can be used on any target, regardless of their current health.
    devilsaur_tranquilizer  = { 102415, 459991, 1 }, -- If Tranquilizing Shot removes only an Enrage effect, its cooldown is reduced by 5 sec.
    disruptive_rounds       = { 102395, 343244, 1 }, -- When Tranquilizing Shot successfully dispels an effect or Counter Shot interrupts a cast, gain 10 Focus.
    emergency_salve         = { 102389, 459517, 1 }, -- Feign Death and Aspect of the Turtle removes poison and disease effects from you.
    entrapment              = { 102403, 393344, 1 }, -- When Tar Trap is activated, all enemies in its area are rooted for 4 sec. Damage taken may break this root.
    explosive_shot          = { 102420, 212431, 1 }, -- Fires an explosive shot at your target. After 3 sec, the shot will explode, dealing 25,937 Fire damage to all enemies within 8 yds. Deals reduced damage beyond 5 targets.
    ghillie_suit            = { 102385, 459466, 1 }, -- You take 20% reduced damage while Camouflage is active. This effect persists for 3 sec after you leave Camouflage.
    high_explosive_trap     = { 102739, 236776, 1 }, -- Hurls a fire trap to the target location that explodes when an enemy approaches, causing 5,110 Fire damage and knocking all enemies away. Limit 1. Trap will exist for 1 min.
    hunters_avoidance       = { 102423, 384799, 1 }, -- Damage taken from area of effect attacks reduced by 5%.
    implosive_trap          = { 102739, 462031, 1 }, -- Hurls a fire trap to the target location that explodes when an enemy approaches, causing 5,110 Fire damage and knocking all enemies up. Limit 1. Trap will exist for 1 min.
    improved_kill_shot      = { 102410, 343248, 1 }, -- Kill Shot's critical damage is increased by $s1%.
    improved_traps          = { 102418, 343247, 1 }, -- The cooldown of Tar Trap, High Explosive Trap, Implosive Trap, and Freezing Trap is reduced by 5.0 sec.
    intimidation            = { 102397, 19577 , 1 }, -- Commands your pet to intimidate the target, stunning it for 5 sec.
    keen_eyesight           = { 102409, 378004, 2 }, -- Critical strike chance increased by 2%.
    kill_shot               = { 102378, 53351 , 1 }, -- You attempt to finish off a wounded target, dealing 28,522 Physical damage. Only usable on enemies with less than 20% health.
    kindling_flare          = { 102425, 459506, 1 }, -- Stealthed enemies revealed by Flare remain revealed for 3 sec after exiting the flare.
    kodo_tranquilizer       = { 102415, 459983, 1 }, -- Tranquilizing Shot removes up to 1 additional Magic effect from up to 2 nearby targets.
    lone_survivor           = { 102391, 388039, 1 }, -- Reduce the cooldown of Survival of the Fittest by 30 sec, and increase its duration by 2.0 sec. Reduce the cooldown of Counter Shot and Muzzle by 2 sec.
    misdirection            = { 102419, 34477 , 1 }, -- Misdirects all threat you cause to the targeted party or raid member, beginning with your next attack within 30 sec and lasting for 8 sec.
    moment_of_opportunity   = { 102426, 459488, 1 }, -- When a trap triggers, you gain 30% movement speed for 3 sec.; Can only occur every 1 min.
    natural_mending         = { 102401, 270581, 1 }, -- Every 10 Focus you spend reduces the remaining cooldown on Exhilaration by 1.0 sec.
    no_hard_feelings        = { 102412, 459546, 1 }, -- When Misdirection targets your pet, it reduces the damage they take by 50% for 5 sec.
    padded_armor            = { 102406, 459450, 1 }, -- Survival of the Fittest gains an additional charge.
    pathfinding             = { 102404, 378002, 1 }, -- Movement speed increased by 4%.
    posthaste               = { 102411, 109215, 1 }, -- Disengage also frees you from all movement impairing effects and increases your movement speed by 50% for 4 sec.
    quick_load              = { 102413, 378771, 1 }, -- When you fall below 40% health, Bursting Shot and Scatter Shot have their cooldown immediately reset. This can only occur once every 25 sec.
    rejuvenating_wind       = { 102381, 385539, 1 }, -- Maximum health increased by 8%, and Exhilaration now also heals you for an additional 12.0% of your maximum health over 8 sec.
    roar_of_sacrifice       = { 102405, 53480 , 1 }, -- Instructs your pet to protect a friendly target from critical strikes, making attacks against that target unable to be critical strikes, but 10% of all damage taken by that target is also taken by the pet. Lasts 12 sec.
    scare_beast             = { 102382, 1513  , 1 }, -- Scares a beast, causing it to run in fear for up to 20 sec. Damage caused may interrupt the effect. Only one beast can be feared at a time.
    scatter_shot            = { 102421, 213691, 1 }, -- A short-range shot that deals 397 damage, removes all harmful damage over time effects, and incapacitates the target for 4 sec. Any damage caused will remove the effect. Turns off your attack when used.
    scouts_instincts        = { 102424, 459455, 1 }, -- You cannot be slowed below 80% of your normal movement speed while Aspect of the Cheetah is active.
    scrappy                 = { 102408, 459533, 1 }, -- Casting Kill Command reduces the cooldown of Intimidation and Binding Shot by 0.5 sec.
    serrated_tips           = { 102384, 459502, 1 }, -- You gain 5% more critical strike from critical strike sources.
    specialized_arsenal     = { 102390, 459542, 1 }, -- Kill Command deals 10% increased damage.
    survival_of_the_fittest = { 102422, 264735, 1 }, -- Reduces all damage you and your pet take by 30% for 6 sec.
    tar_trap                = { 102393, 187698, 1 }, -- Hurls a tar trap to the target location that creates a 8 yd radius pool of tar around itself for 30 sec when the first enemy approaches. All enemies have 50% reduced movement speed while in the area of effect. Limit 1. Trap will exist for 1 min.
    tarcoated_bindings      = { 102417, 459460, 1 }, -- Binding Shot's stun duration is increased by 1 sec.
    territorial_instincts   = { 102394, 459507, 1 }, -- Casting Intimidation without a pet now summons one from your stables to intimidate the target. Additionally, the cooldown of Intimidation is reduced by 5 sec.
    trailblazer             = { 102400, 199921, 1 }, -- Your movement speed is increased by 30% anytime you have not attacked for 3 sec.
    tranquilizing_shot      = { 102380, 19801 , 1 }, -- Removes 1 Enrage and 1 Magic effect from an enemy target.
    trigger_finger          = { 102396, 459534, 2 }, -- You and your pet have 5.0% increased attack speed. This effect is increased by 100% if you do not have an active pet.
    unnatural_causes        = { 102387, 459527, 1 }, -- Your damage over time effects deal 10% increased damage. This effect is increased by 50% on targets below 20% health.
    wilderness_medicine     = { 102383, 343242, 1 }, -- Mend Pet heals for an additional 25% of your pet's health over its duration, and has a 25% chance to dispel a magic effect each time it heals your pet.

    -- Beast Mastery
    a_murder_of_crows       = { 102352, 459760, 1 }, -- [131894] Summons a flock of crows to attack your target, dealing ${$131900s1*$d} Physical damage over $d.
    alpha_predator          = { 102368, 269737, 1 }, -- Kill Command now has 2 charges, and deals 15% increased damage.
    animal_companion        = { 102361, 267116, 1 }, -- Your Call Pet additionally summons the pet from the bonus slot in your stable. This pet will obey your Kill Command, but cannot use pet family abilities.
    aspect_of_the_beast     = { 102351, 191384, 1 }, -- Increases the damage and healing of your pet's abilities by 30%. Increases the effectiveness of your pet's Predator's Thirst, Endurance Training, and Pathfinding passives by 50%.
    barbed_shot             = { 102377, 217200, 1 }, -- Fire a shot that tears through your enemy, causing them to bleed for 21,168 damage over 8 sec. Sends your pet into a frenzy, increasing attack speed by 30% for 8 sec, stacking up to 3 times. Generates 20 Focus over 8 sec.
    barbed_wrath            = { 102373, 231548, 1 }, -- Barbed Shot reduces the cooldown of Bestial Wrath by 12.0 sec.
    barbed_scales           = { 102356, 469880, 1 }, -- Casting Cobra Shot reduces the cooldown of Barbed Shot by ${$s1/1000} sec.
    barrage                 = { 102335, 120360, 1 }, -- Rapidly fires a spray of shots for 2.4 sec, dealing an average of 13,726 Physical damage to all nearby enemies in front of you. Usable while moving. Deals reduced damage beyond 8 targets. Grants Beast Cleave.
    basilisk_collar         = { 102367, 459571, 2 }, -- Each damage over time effect on a target increases the damage they receive from your pet's attacks by 5%.
    beast_cleave            = { 102341, 115939, 1 }, -- After you Multi-Shot, your pet's melee attacks also strike all nearby enemies for 80% of the damage for the next 6.0 sec. Deals reduced damage beyond 8 targets.
    bestial_wrath           = { 102340, 19574 , 1 }, -- Sends you and your pet into a rage, instantly dealing 18,639 Physical damage to its target, and increasing all damage you both deal by 25% for 15 sec. Removes all crowd control effects from your pet.
    bloodshed               = { 102362, 321530, 1 }, -- Command your pet to tear into your target, causing your target to bleed for $<damage> over $321538d and take $321538s2% increased damage from your pet for $321538d.
    bloody_frenzy           = { 102339, 407412, 1 }, -- While Call of the Wild is active, your pets have the effects of Beast Cleave, and each time Call of the Wild summons a pet, all of your pets Stomp.
    brutal_companion        = { 102350, 386870, 1 }, -- When Barbed Shot causes Frenzy to stack up to 3, your pet will immediately use its special attack and deal 50% bonus damage.
    call_of_the_wild        = { 102336, 359844, 1 }, -- You sound the call of the wild, summoning 2 of your active pets for 20 sec. During this time, a random pet from your stable will appear every 4 sec to assault your target for 6 sec. Each time Call of the Wild summons a pet, the cooldown of Barbed Shot and Kill Command are reduced by 50%.
    cobra_senses            = { 102344, 378244, 1 }, -- Cobra Shot Focus cost reduced by $s1. Cobra Shot damage increased by $s2%.; 
    cobra_shot              = { 102354, 193455, 1 }, -- A quick shot causing ${$s2*$<mult>} Physical damage.; Reduces the cooldown of Kill Command by $s3 sec.
    dire_beast              = { 102376, 120679, 1 }, -- Summons a powerful wild beast that attacks the target and roars, increasing your Haste by 5% for 8 sec. Generates 20 Focus.
    dire_command            = { 102365, 378743, 1 }, -- Kill Command has a 30% chance to also summon a Dire Beast to attack your target for 8 sec.
    dire_frenzy             = { 102337, 385810, 1 }, -- Dire Beast lasts an additional 2 sec and deals 60% increased damage.
    explosive_venom         = { 102370, 459693, 1 }, -- Every 5 casts of Explosive Shot or Multi-Shot will apply Serpent Sting to targets hit.
    go_for_the_throat       = { 102357, 459550, 1 }, -- Kill Command deals increased critical strike damage equal to 100% of your critical strike chance.
    hunters_prey            = { 102360, 378210, 1 }, -- Kill Shot will strike $468219s1 additional target and deal $468219s3% increased damage for each of your active pets. Stacks up to $468219u times.
    huntmasters_call        = { 102349, 459730, 1 }, -- Every 3 casts of Dire Beast sounds the Horn of Valor, summoning either Hati or Fenryr to battle. Hati Increases the damage of all your pets by 8%. Fenryr Pounces your primary target, inflicting a heavy bleed that deals 28,522 damage over 8 sec and grants you 10% Haste.
    kill_cleave             = { 102355, 378207, 1 }, -- While Beast Cleave is active, Kill Command now also strikes nearby enemies for 80% of damage dealt. Deals reduced damage beyond 8 targets.
    kill_command            = { 102346, 34026 , 1 }, -- Give the command to kill, causing your pet to savagely deal 13,358 Physical damage to the enemy.
    killer_cobra            = { 102375, 199532, 1 }, -- While Bestial Wrath is active, Cobra Shot resets the cooldown on Kill Command.
    killer_instinct         = { 102364, 273887, 2 }, -- Kill Command deals 50% increased damage against enemies below 35% health.
    laceration              = { 102369, 459552, 1 }, -- When your pet attacks critically strike, they cause their target to bleed for $459555s1% of the damage dealt over $459560d. 
    master_handler          = { 102372, 424558, 1 }, -- Each time Barbed Shot deals damage, the cooldown of Kill Command is reduced by 0.50 sec.
    multishot               = { 102363, 2643  , 1 }, -- Fires several missiles, hitting all nearby enemies within 8 yds of your current target for 1,123 Physical damage. Deals reduced damage beyond 5 targets.
    pack_tactics            = { 102374, 321014, 1 }, -- Passive Focus generation increased by 100%.
    piercing_fangs          = { 102371, 392053, 1 }, -- While Bestial Wrath is active, your pet's critical damage dealt is increased by 35%.
    savagery                = { 102353, 424557, 1 }, -- Kill Command damage is increased by 10%. Barbed Shot lasts 2.0 sec longer.
    scent_of_blood          = { 102342, 193532, 2 }, -- Activating Bestial Wrath grants 1 charge of Barbed Shot.
    serpentine_rhythm       = { 102359, 468701, 1 }, -- Casting Cobra Shot increases its damage by $468703s1%. Stacks up to $468703u times.; Upon reaching $468703u stacks, the bonus is removed and you gain $468704s1% increased pet damage for $468704d.
    shower_of_blood         = { 102366, 459729, 1 }, -- Bloodshed now hits 2 additional nearby targets.
    snakeskin_quiver        = { 102344, 468695, 1 }, -- Your auto shot has a $s1% chance to also fire a Cobra Shot at your target.
    stomp                   = { 102347, 199530, 1 }, -- When you cast Barbed Shot, your pet stomps the ground, dealing 7,046 Physical damage to all nearby enemies.
    thrill_of_the_hunt      = { 102345, 257944, 1 }, -- Barbed Shot increases your critical strike chance by 2% for 8 sec, stacking up to 3 times.
    training_expert         = { 102348, 378209, 1 }, -- All pet damage dealt increased by $s1%.
    venomous_bite           = { 102366, 459667, 1 }, -- Bloodshed's pet damage bonus increased by$s1% and Kill Command deals $459668s1% increased damage to the target.
    venoms_bite             = { 102358, 459565, 1 }, -- Kill Shot applies Serpent Sting for 18 sec.  Serpent Sting Fire a shot that poisons your target, causing them to take 1,836 Nature damage instantly and an additional 13,834 Nature damage over 18 sec.
    war_orders              = { 102343, 393933, 1 }, -- Barbed Shot deals 10% increased damage, and applying Barbed Shot has a 50% chance to reset the cooldown of Kill Command.
    wild_call               = { 102338, 185789, 1 }, -- Your auto shot critical strikes have a 20% chance to reset the cooldown of Barbed Shot.
    wild_instincts          = { 102339, 378442, 1 }, -- While Call of the Wild is active, each time you Kill Command, your Kill Command target takes 3% increased damage from all of your pets, stacking up to 10 times.

    -- Pack Leader
    beast_of_opportunity    = { 94979, 445700, 1 }, -- Bestial Wrath calls on the pack, summoning a pet from your stable for 6 sec.
    cornered_prey           = { 94984, 445702, 1 }, -- Disengage increases the range of all your attacks by 5 yds for 5 sec.
    covering_fire           = { 94969, 445715, 1 }, -- Kill Command increases the duration of Beast Cleave by 1 sec.
    cull_the_herd           = { 94967, 445717, 1 }, -- Kill Shot deals an additional 30% damage over 6 sec and increases the bleed damage you and your pet deal to the target by 25%.
    den_recovery            = { 94972, 445710, 1 }, -- Aspect of the Turtle, Survival of the Fittest, and Mend Pet heal the target for 20% of maximum health over 4 sec. Duration increased by 1 sec when healing a target under 50% maximum health.
    frenzied_tear           = { 94988, 445696, 1 }, -- Your pet's Basic Attack has a 20% chance to reset the cooldown and cause Kill Command to strike a second time for 30% of normal damage.
    furious_assault         = { 94979, 445699, 1 }, -- Consuming Frenzied Tear has a 50% chance to reset the cooldown of Barbed Shot and deal 30% more damage.
    howl_of_the_pack        = { 94992, 445707, 1 }, -- Your pet's Basic Attack critical strikes increase your critical strike damage by $462515s1% for $462515d stacking up to $462515u times.$?c1[][; Wildfire Bomb damage is increased by $s4%.]
    pack_assault            = { 94966, 445721, 1 }, -- Vicious Hunt and Pack Coordination now stack and apply twice, and are always active during Call of the Wild.
    pack_coordination       = { 94985, 445505, 1 }, -- Attacking with Vicious Hunt instructs your pet to strike with their Basic Attack along side your next Barbed Shot.
    scattered_prey          = { 94969, 445768, 1 }, -- Multi-Shot increases the damage of your next Multi-Shot by 25%.
    tireless_hunt           = { 94984, 445701, 1 }, -- Aspect of the Cheetah now increases movement speed by 15% for another 8 sec.
    vicious_hunt            = { 94991, 445404, 1, "pack_leader" }, -- Kill Command prepares you to viciously attack in coordination with your pet, dealing an additional 26,743 Physical damage with your next Kill Command.
    wild_attacks            = { 94962, 445708, 1 }, -- Every third pet Basic Attack is a guaranteed critical strike, with damage further increased by critical strike chance.$?s259387[; Mongoose Bite's damage is increased by $s2%.]?a137017[; Raptor Strike's damage is increased by $s2%.][]

    -- Dark Ranger
    banshees_mark           = { 94957, 467902, 1 }, -- [131894] Summons a flock of crows to attack your target, dealing ${$131900s1*$d} Physical damage over $d. 
    black_arrow             = { 94987, 466932, 1, "dark_ranger" }, -- [466930] You attempt to finish off a wounded target, dealing $s1 Shadow damage and $468572o1 Shadow damage over $468572d. Only usable on enemies above $s3% health or below $s2% health.
    bleak_arrows            = { 94961, 467749, 1 }, -- [378770] Your next Kill Shot can be used on any target, regardless of their current health.
    bleak_powder            = { 94974, 467911, 1 }, -- Casting Black Arrow while $?c1[Beast Cleave][Trick Shots] is active causes Black Arrow to explode upon hitting a target, dealing $467914s1 Shadow damage to nearby enemies.
    dark_chains             = { 94960, 430712, 1 }, -- While in combat, Disengage will chain the closest target to the ground, causing them to move $442396s1% slower until they move $s1 yards away.
    embrace_the_shadows     = { 94959, 430704, 1 }, -- You heal for 15% of all Shadow damage dealt by you or your pets.
    ebon_bowstring          = { 94986, 467897, 1 }, -- [378770] Your next Kill Shot can be used on any target, regardless of their current health.
    phantom_pain            = { 94986, 467941, 1 }, -- When $?c1[Kill Command][Aimed Shot] damages a target affected by Black Arrow, $s1% of the damage dealt is replicated to each other unit affected by Black Arrow.
    shadow_dagger           = { 94960, 467741, 1 }, -- While in combat, Disengage releases a fan of shadow daggers, dealing $467745s1 shadow damage per second and reducing affected target's movement speed by $467745s2% for $467745d.
    shadow_hounds           = { 94983, 430707, 1 }, -- Each time Black Arrow deals damage, you have a small chance to manifest a Dark Hound to charge to your target and deal Shadow damage for $442419d.$?c1[; Whenever you summon a Dire Beast, you have a $s1% chance to also summon a Shadow Hound.][]
    shadow_surge            = { 94982, 467936, 1 }, -- Periodic damage from Black Arrow has a small chance to erupt in a burst of darkness, dealing $444269s1 Shadow damage to all enemies near the target. Damage reduced beyond $s1 targets.
    soul_drinker            = { 94983, 469638, 1 }, -- [378770] Your next Kill Shot can be used on any target, regardless of their current health.
    smoke_screen            = { 94959, 430709, 1 }, -- Exhilaration grants you 3 sec of Survival of the Fittest. Survival of the Fittest activates Exhilaration at 50% effectiveness.
    the_bell_tolls          = { 94968, 467644, 1 }, -- Black Arrow is now usable on enemies with greater than 80% health or less than 20% health.
    withering_fire          = { 94993, 466990, 1 }, -- $?c1[Every $s1 casts of Bestial Wrath][While Trueshot is active], you surrender to darkness$?c2[.][ for $466991d]; If you would gain Deathblow while under the effects of Withering Fire, you instead instantly fire a Black Arrow at your target and $s3 additional Black Arrows at nearby targets at $s4% effectiveness.
} )


-- PvP Talents
spec:RegisterPvpTalents( {
    chimaeral_sting     = 3604, -- (356719) Stings the target, dealing 13,370 Nature damage and initiating a series of venoms. Each lasts 3 sec and applies the next effect after the previous one ends.  Scorpid Venom: 90% reduced movement speed.  Spider Venom: Silenced.  Viper Venom: 20% reduced damage and healing.
    diamond_ice         = 5534, -- (203340) Victims of Freezing Trap can no longer be damaged or healed. Freezing Trap is now undispellable, but has a 5 sec duration.
    dire_beast_basilisk = 825 , -- (205691) Summons a slow moving basilisk near the target for 30 sec that attacks the target for heavy damage.
    dire_beast_hawk     = 824 , -- (208652) Summons a hawk to circle the target area, attacking all targets within 10 yards over the next 10 sec.
    hunting_pack        = 3730, -- (203235) Aspect of the Cheetah has 50% reduced cooldown and grants its effects to allies within 15 yds.
    interlope           = 1214, -- (248518) Misdirection now causes the next 3 hostile spells cast on your target within 10 sec to be redirected to your pet, but its cooldown is increased by 15 sec. Your pet must be within 20 yards of the target for spells to be redirected.
    kindred_beasts      = 5444, -- (356962) Command Pet's unique ability cooldown reduced by 50%, and gains additional effects. Ferocity: Primal Rage increases Haste by 12% for 20 sec, but no longer applies Sated.
    survival_tactics    = 3599, -- (202746) Feign Death reduces damage taken by 90% for 3 sec.
    the_beast_within    = 693 , -- (356976) Bestial Wrath now provides immunity to Fear and Horror effects for you and your pets for 8 sec. Nearby allied pets are also inspired, increasing their attack speed by 10%.
    wild_kingdom        = 5441, -- (356707) Call in help from one of your dismissed Cunning pets for 10 sec. Your current pet is dismissed to rest and heal 30% of maximum health.
} )


-- Auras
spec:RegisterAuras( {
    -- Talent: Under attack by a flock of crows.
    -- https://wowhead.com/beta/spell=131894
    a_murder_of_crows = {
        id = 131894,
        duration = 15,
        tick_time = 1,
        max_stack = 1
    },
    a_murder_of_crows_stack = {
        id = 459759,
        duration = 15,
        max_stack = 5
    },

    -- Movement speed reduced by $s1%.
    -- https://wowhead.com/beta/spell=263446
    acid_spit = {
        id = 263446,
        duration = 6,
        mechanic = "snare",
        type = "Ranged",
        max_stack = 1
    },
    -- Dodge chance increased by $s1%.
    -- https://wowhead.com/beta/spell=160011
    agile_reflexes = {
        id = 160011,
        duration = 20,
        max_stack = 1
    },
    -- Movement speed reduced by $s1%.
    -- https://wowhead.com/beta/spell=50433
    ankle_crack = {
        id = 50433,
        duration = 6,
        mechanic = "snare",
        max_stack = 1
    },
    -- Movement speed increased by $w1%.
    -- https://wowhead.com/beta/spell=186257
    aspect_of_the_cheetah_sprint = {
        id = 186257,
        duration = 3,
        max_stack = 1,
    },
    -- Movement speed increased by $w1%.
    -- https://wowhead.com/beta/spell=186258

    aspect_of_the_cheetah = {
        id = 186258,
        duration = function () return conduit.cheetahs_vigor.enabled and 12 or 9 end,
        max_stack = 1,
    },
    -- The range of $?s259387[Mongoose Bite][Raptor Strike] is increased to $265189r yds.
    -- https://wowhead.com/beta/spell=186289
    aspect_of_the_eagle = {
        id = 186289,
        duration = 15,
        max_stack = 1
    },
    -- Deflecting all attacks.  Damage taken reduced by $w4%.
    -- https://wowhead.com/beta/spell=186265
    aspect_of_the_turtle = {
        id = 186265,
        duration = 8,
        max_stack = 1
    },
    -- Talent: Suffering $w1 damage every $t1 sec.
    -- https://wowhead.com/beta/spell=217200
    barbed_shot = {
        id = 246152,
        duration = function() return 12 + ( talent.savagery.enabled and 2 or 0 ) end,
        tick_time = 2,
        mechanic = "bleed",
        type = "Ranged",
        max_stack = 1,
    },
    barbed_shot_2 = {
        id = 246851,
        duration = function () return spec.auras.barbed_shot.duration end,
        tick_time = 2,
        mechanic = "bleed",
        type = "Ranged",
        max_stack = 1,
    },
    barbed_shot_3 = {
        id = 246852,
        duration = function () return spec.auras.barbed_shot.duration end,
        tick_time = 2,
        mechanic = "bleed",
        type = "Ranged",
        max_stack = 1,
    },
    barbed_shot_4 = {
        id = 246853,
        duration = function () return spec.auras.barbed_shot.duration end,
        tick_time = 2,
        mechanic = "bleed",
        type = "Ranged",
        max_stack = 1,
    },
    barbed_shot_5 = {
        id = 246854,
        duration = function () return spec.auras.barbed_shot.duration end,
        tick_time = 2,
        mechanic = "bleed",
        type = "Ranged",
        max_stack = 1,
    },
    barbed_shot_6 = {
        id = 284255,
        duration = function () return spec.auras.barbed_shot.duration end,
        tick_time = 2,
        mechanic = "bleed",
        type = "Ranged",
        max_stack = 1,
    },
    barbed_shot_7 = {
        id = 284257,
        duration = function () return spec.auras.barbed_shot.duration end,
        tick_time = 2,
        mechanic = "bleed",
        type = "Ranged",
        max_stack = 1,
    },
    barbed_shot_8 = {
        id = 284258,
        duration = function () return spec.auras.barbed_shot.duration end,
        tick_time = 2,
        mechanic = "bleed",
        type = "Ranged",
        max_stack = 1,
    },
    barbed_shot_dot = {
        id = 217200,
        duration = function () return spec.auras.barbed_shot.duration end,
        tick_time = 2,
        mechanic = "bleed",
        type = "Ranged",
        max_stack = 1,
    },
    -- Talent:
    -- https://wowhead.com/beta/spell=120360
    barrage = {
        id = 120360,
        duration = 3,
        tick_time = 0.2,
        max_stack = 1
    },
    beast_cleave = {
        id = 268877,
        duration = 6,
        max_stack = 1,
    },
    -- Talent: Damage dealt increased by $w1%.
    -- https://wowhead.com/beta/spell=19574
    bestial_wrath = {
        id = 19574,
        duration = 15,
        type = "Ranged",
        max_stack = 1
    },
    binding_shackles = {
        id = 321469,
        duration = 8,
        max_stack = 1,
    },
    binding_shot = {
        id = 117405,
        duration = 10,
        max_stack = 1,
    },
    -- Stunned.
    binding_shot_stun = {
        id = 117526,
        duration = function() return 3.0 + ( 1 * talent.tarcoated_bindings.rank ) end,
        max_stack = 1,
    },
    black_arrow = {
        id = 468572,
        duration = 10,
        tick_time = 2,
        max_stack = 1
    },
    --[[ This probably isn't needed? We'll see. Keep it here in case.
    bleak_arrows = {
            id = 467718,
            duration = 60.0,
            max_stack = 1   
    },--]]
    -- Talent: Bleeding for $w1 Physical damage every $t1 sec.  Taking $s2% increased damage from the Hunter's pet.
    -- https://wowhead.com/beta/spell=321538
    bloodshed = {
        id = 321538,
        duration = 18,
        tick_time = 3,
        max_stack = 1,
        generate = function ( t )
            local name, count, duration, expires, caster, _

            for i = 1, 40 do
                name, _, count, _, duration, expires, caster = UnitDebuff( "target", 321538 )

                if not name then break end
                if name and UnitIsUnit( caster, "pet" ) then break end
            end

            if name then
                t.name = name
                t.count = count
                t.expires = expires
                t.applied = expires - duration
                t.caster = "player"
                return
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },
    -- Damage reduced by $s1%.
    -- https://wowhead.com/beta/spell=263869
    bristle = {
        id = 263869,
        duration = 12,
        max_stack = 1
    },
    -- Burrowed into the ground, dealing damage to enemies above.
    -- https://wowhead.com/beta/spell=93433
    burrow_attack = {
        id = 93433,
        duration = 8,
        tick_time = 1,
        type = "Magic",
        max_stack = 1
    },
    -- Disoriented.
    bursting_shot = {
        id = 224729,
        duration = 4.0,
        max_stack = 1,
    },
    -- Summoning 1 of your active pets every 4 sec. Each pet summoned lasts for 6 sec.
    -- https://wowhead.com/beta/spell=359844
    call_of_the_wild = {
        id = 359844,
        duration = 20,
        max_stack = 1
    },
    call_of_the_wild_summon = {
        id = 361582,
        duration = 6,
        max_stack = 1
    },
    -- Talent: Stealthed.
    -- https://wowhead.com/beta/spell=199483
    camouflage = {
        id = 199483,
        duration = 60,
        max_stack = 1
    },
    -- Dodge chance increased by $s1%.
    -- https://wowhead.com/beta/spell=263892
    catlike_reflexes = {
        id = 263892,
        duration = 20,
        max_stack = 1
    },
    -- Talent: Movement slowed by $s1%.
    -- https://wowhead.com/beta/spell=5116
    concussive_shot = {
        id = 5116,
        duration = 6,
        mechanic = "snare",
        type = "Ranged",
        max_stack = 1
    },
    -- Bleeding for $w1 damage every $t1 sec.
    cull_the_herd = {
        id = 449233,
        duration = 6.0,
        tick_time = 2.0,
        max_stack = 1,
    },

    deathblow = {
        id = 378770,
        duration = 12,
        max_stack = 1
    },
    -- Talent: Taking $w2% increased Physical damage from $@auracaster.
    -- https://wowhead.com/beta/spell=325037
    death_chakram_vulnerability = {
        id = 375893,
        duration = 10,
        mechanic = "bleed",
        type = "Ranged",
        max_stack = 1,
        copy = { 325037, 361756, "death_chakram_debuff" }
    },
    death_chakram = {
        duration = 3.5,
        tick_time = 0.5,
        max_stack = 1,
        generate = function( t, auraType )
            local cast = action.death_chakram.lastCast or 0

            if cast + class.auras.death_chakram.duration >= query_time then
                t.name = class.abilities.death_chakram.name
                t.count = 1
                t.applied = cast
                t.expires = cast + 3.5
                t.caster = "player"
                return
            end
            t.count = 0
            t.applied = 0
            t.expires = 0
            t.caster = "nobody"
        end,
    },
    -- Talent: Haste increased by $s1%.
    -- https://wowhead.com/beta/spell=281036
    dire_beast = {
        id = 281036,
        duration = function() return 8 + 2 * talent.dire_frenzy.rank end,
        max_stack = 1
    },
    dire_beast_basilisk = {
        id = 209967,
        duration = 30,
        max_stack = 1,
    },
    dire_beast_hawk = {
        id = 208684,
        duration = 3600,
        max_stack = 1,
    },
    -- Dodge chance increased by $s1%.
    -- https://wowhead.com/beta/spell=263887
    dragons_guile = {
        id = 263887,
        duration = 20,
        max_stack = 1
    },
    -- Movement slowed by $s1%.
    -- https://wowhead.com/beta/spell=50285
    dust_cloud = {
        id = 50285,
        duration = 6,
        mechanic = "snare",
        type = "Magic",
        max_stack = 1
    },
    -- Vision is enhanced.
    -- https://wowhead.com/beta/spell=6197
    eagle_eye = {
        id = 6197,
        duration = 60,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Exploding for $212680s1 Fire damage after $t1 sec.
    -- https://wowhead.com/beta/spell=212431
    explosive_shot = {
        id = 212431,
        duration = 3,
        tick_time = 3,
        type = "Ranged",
        max_stack = 1
    },
    -- Explosive Shot and Multi-Shot will apply Serpent Sting at $u stacks.
    explosive_venom = {
        id = 459689,
        duration = 15.0,
        max_stack = 1,
    },
    -- Directly controlling pet.
    -- https://wowhead.com/beta/spell=321297
    eyes_of_the_beast = {
        id = 321297,
        duration = 60,
        type = "Magic",
        max_stack = 1
    },
    -- Feigning death.
    -- https://wowhead.com/beta/spell=5384
    feign_death = {
        id = 5384,
        duration = 360,
        max_stack = 1
    },
    -- Covenant: Bleeding for $s1 Shadow damage every $t1 sec.
    -- https://wowhead.com/beta/spell=324149
    flayed_shot = {
        id = 324149,
        duration = 18,
        tick_time = 2,
        mechanic = "bleed",
        type = "Ranged",
        max_stack = 1
    },
    -- Maximum health increased by $s1%.
    -- https://wowhead.com/beta/spell=388035
    fortitude_of_the_bear = {
        id = 388035,
        duration = 10,
        max_stack = 1,
        copy = 392956
    },
    freezing_trap = {
        id = 3355,
        duration = 60,
        type = "Magic",
        max_stack = 1,
    },
    -- Attack speed increased by $s1%.
    -- https://wowhead.com/beta/spell=272790
    frenzy = {
        id = 272790,
        duration = function () return azerite.feeding_frenzy.enabled and 9 or spec.auras.barbed_shot.duration end,
        max_stack = 3,
        generate = function ()
            local fr = buff.frenzy
            local name, _, count, _, duration, expires, caster = FindUnitBuffByID( "pet", 272790 )

            if name then
                fr.name = name
                fr.count = count
                fr.expires = expires
                fr.applied = expires - duration
                fr.caster = caster
                return
            end

            fr.count = 0
            fr.expires = 0
            fr.applied = 0
            fr.caster = "nobody"
        end,
    },
    -- Movement speed reduced by $s1%.
    -- https://wowhead.com/beta/spell=54644
    frost_breath = {
        id = 54644,
        duration = 6,
        mechanic = "snare",
        type = "Magic",
        max_stack = 1
    },
    -- Causing Froststorm damage to all targets within $95725A1 yards.
    -- https://wowhead.com/beta/spell=92380
    froststorm_breath = {
        id = 92380,
        duration = 8,
        tick_time = 2,
        max_stack = 1
    },
    -- Movement speed reduced by $s1%.
    -- https://wowhead.com/beta/spell=263840
    furious_bite = {
        id = 263840,
        duration = 6,
        mechanic = "snare",
        max_stack = 1
    },
    growl = {
        id = 2649,
        duration = 3,
        max_stack = 1,
    },
    -- Critical damage dealt increased by $s1%.
    howl_of_the_pack = {
        id = 462515,
        duration = 8.0,
        max_stack = 3,
    },
    -- Talent: Your Kill Shot strikes $s1 more targets and deals $s3% more damage.
    --[[hunters_prey = {
        id = 468219,
        duration = 3600,
        max_stack = 1
    },--]]
    -- Dire Beast will summon Hati or Fenryr at $u stacks.
    huntmasters_call = {
        id = 459731,
        duration = 3600,
        max_stack = 1,
    },
    intimidation = {
        id = 24394,
        duration = 5,
        max_stack = 1,
    },
    -- Talent: Bleeding for $w2 damage every $t2 sec.
    -- https://wowhead.com/beta/spell=259277
    kill_command = {
        id = 259277,
        duration = 8,
        max_stack = 1
    },
    -- Movement speed reduced by $s1%.
    -- https://wowhead.com/beta/spell=263423
    lock_jaw = {
        id = 263423,
        duration = 6,
        mechanic = "snare",
        max_stack = 1
    },
    masters_call = {
        id = 54216,
        duration = 4,
        type = "Magic",
        max_stack = 1,
    },
    -- Heals $w1% of the pet's health every $t1 sec.$?s343242[  Each time Mend Pet heals your pet, you have a $343242s2% chance to dispel a harmful magic effect from your pet.][]
    -- https://wowhead.com/beta/spell=136
    mend_pet = {
        id = 136,
        duration = 10,
        type = "Magic",
        max_stack = 1,
        generate = function( t )
            local name, _, count, _, duration, expires, caster = FindUnitBuffByID( "pet", 136 )

            if name then
                t.name = name
                t.count = count
                t.expires = expires
                t.applied = expires - duration
                t.caster = caster
                return
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },
    -- Talent: Threat redirected from Hunter.
    -- https://wowhead.com/beta/spell=35079
    misdirection = {
        id = 35079,
        duration = 8,
        max_stack = 1,
    },
    -- Damage taken reduced by $w1%
    no_hard_feelings = {
        id = 459547,
        duration = 5.0,
        max_stack = 1,
    },
    -- Damage reduced by $s1%.
    -- https://wowhead.com/beta/spell=263867
    obsidian_skin = {
        id = 263867,
        duration = 12,
        max_stack = 1
    },
    parsels_tongue = {
        id = 248085,
        duration = 8,
        max_stack = 4,
    },
    -- Pinned in place.
    -- https://wowhead.com/beta/spell=50245
    pin = {
        id = 50245,
        duration = 6,
        mechanic = "root",
        max_stack = 1
    },
    -- "When you're the best of friends..."
    -- https://wowhead.com/beta/spell=90347
    play = {
        id = 90347,
        duration = 15,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Increased movement speed by $s1%.
    -- https://wowhead.com/beta/spell=118922
    posthaste = {
        id = 118922,
        duration = 4,
        max_stack = 1
    },
    predators_thirst = {
        id = 264663,
        duration = 3600,
        max_stack = 1,
    },
    -- Stealthed.  Movement speed slowed by $s2%.
    -- https://wowhead.com/beta/spell=24450
    prowl = {
        id = 24450,
        duration = 3600,
        max_stack = 1
    },
    -- Recently benefitted from Quick Load.
    quick_load = {
        id = 385646,
        duration = 25.0,
        max_stack = 1,
        copy = "quick_load_icd"
    },
    rejuvenating_wind = {
        id = 339400,
        duration = 8,
        max_stack = 1
    },
    -- Zzzzzz...
    -- https://wowhead.com/beta/spell=94019
    rest = {
        id = 94019,
        duration = 12,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Feared.
    -- https://wowhead.com/beta/spell=1513
    scare_beast = {
        id = 1513,
        duration = 20,
        mechanic = "flee",
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Disoriented.
    -- https://wowhead.com/beta/spell=213691
    scatter_shot = {
        id = 213691,
        duration = 4,
        type = "Ranged",
        max_stack = 1
    },

    scattered_prey = {
        id = 461886,
        duration = 20,
        max_stack = 1
    },

    serpentine_rhythm = {
        id = 468703,
        duration = 30,
        max_stack = 3
    },

    serpentine_blessing = {
        id = 468704,
        duration = 8,
        max_stack = 1
    },

    -- Dodge chance increased by $s1%.
    -- https://wowhead.com/beta/spell=263904
    serpents_swiftness = {
        id = 263904,
        duration = 20,
        max_stack = 1
    },
    -- Damage taken reduced by $s1%.
    -- https://wowhead.com/beta/spell=263938
    silverback = {
        id = 263938,
        duration = 15,
        max_stack = 1
    },
    -- Heals $w2 every $t2 sec for $d.
    -- https://wowhead.com/beta/spell=90361
    spirit_mend = {
        id = 90361,
        duration = 10,
        type = "Magic",
        max_stack = 1
    },
    -- Stealthed.  Movement speed slowed by $s2%.
    -- https://wowhead.com/beta/spell=90328
    spirit_walk = {
        id = 90328,
        duration = 3600,
        max_stack = 1
    },
    -- Talent: Slowed by $s2%.  $s3% increased chance suffer a critical strike from $@auracaster.
    -- https://wowhead.com/beta/spell=201594
    stampede = {
        id = 201594,
        duration = 5,
        type = "Ranged",
        max_stack = 1
    },
    -- Talent: Bleeding for $w1 damage every $t1 seconds.
    -- https://wowhead.com/beta/spell=162487
    steel_trap = {
        id = 162487,
        duration = 20,
        tick_time = 2,
        mechanic = "bleed",
        type = "Ranged",
        max_stack = 1
    },
    -- All damage taken reduced by $s1%.
    survival_of_the_fittest = {
        id = 264735,
        duration = function() return 6.0 + 2 * talent.lone_survivor.rank end,
        max_stack = 1,
    },
    -- Reduces damage taken by $202746s1%, up to a maximum of $w1.
    survival_tactics = {
        id = 202748,
        duration = 2.0,
        max_stack = 1,
    },
    -- Movement speed reduced by $s1%.
    -- https://wowhead.com/beta/spell=263852
    talon_rend = {
        id = 263852,
        duration = 6,
        mechanic = "snare",
        max_stack = 1
    },
    tar_trap = {
        id = 135299,
        duration = 30,
        max_stack = 1,
    },
    -- Movement speed reduced by $s1%.
    -- https://wowhead.com/beta/spell=160065
    tendon_rip = {
        id = 160065,
        duration = 6,
        mechanic = "snare",
        max_stack = 1
    },
    -- Damage taken reduced by $s1%.
    -- https://wowhead.com/beta/spell=263926
    thick_fur = {
        id = 263926,
        duration = 15,
        max_stack = 1
    },
    -- Damage taken reduced by $s1%.
    -- https://wowhead.com/beta/spell=160058
    thick_hide = {
        id = 160058,
        duration = 15,
        max_stack = 1
    },
    -- Talent: Critical strike chance increased by $s1%.
    -- https://wowhead.com/beta/spell=257946
    thrill_of_the_hunt = {
        id = 257946,
        duration = function () return spec.auras.barbed_shot.duration end,
        max_stack = 3,
        copy = 312365
    },
    trailblazer = {
        id = 231390,
        duration = 3600,
        max_stack = 1,
    },
    -- Damage taken from $@auracaster's Kill Command is increased by $w1%.
    venomous_bite = {
        id = 459668,
        duration = 3600,
        max_stack = 1,
    },
    -- Suffering $w1 Fire damage every $t1 sec.
    -- https://wowhead.com/beta/spell=271049
    -- Talent: Silenced.
    -- https://wowhead.com/beta/spell=355596
    wailing_arrow = {
        id = 355596,
        duration = 5,
        mechanic = "silence",
        type = "Magic",
        max_stack = 1,
        copy = 392061
    },
    -- Movement slowed by $s1%.
    -- https://wowhead.com/beta/spell=35346
    warp_time = {
        id = 35346,
        duration = 6,
        type = "Magic",
        max_stack = 1
    },
    -- Movement speed reduced by $s1%.
    -- https://wowhead.com/beta/spell=160067
    web_spray = {
        id = 160067,
        duration = 6,
        mechanic = "snare",
        max_stack = 1
    },
    -- Talent: The cooldown of $?s217200[Barbed Shot][Dire Beast] is reset.
    -- https://wowhead.com/beta/spell=185791
    wild_call = {
        id = 185791,
        duration = 4,
        max_stack = 1
    },
    -- Damage taken from $@auracaster's Pets increased by $s1%.
    wild_instincts = {
        id = 424567,
        duration = 8,
        max_stack = 10,
    },
    -- Suffering $w1 Fire damage every $t1 sec.
    -- https://wowhead.com/beta/spell=269747
    -- Movement speed reduced by $s1%.
    -- https://wowhead.com/beta/spell=195645
    wing_clip = {
        id = 195645,
        duration = 15,
        max_stack = 1
    },
    -- Dodge chance increased by $s1%.
    -- https://wowhead.com/beta/spell=264360
    winged_agility = {
        id = 264360,
        duration = 20,
        max_stack = 1
    },

    withering_fire_counter = {
        id = 468074,
        duration = 180,
        max_stack = 2
    },

    withering_fire = {
        id = 466991,
        duration = 12,
        max_stack = 1

    },

    -- PvP Talents
    high_explosive_trap = {
        id = 236777,
        duration = 0.1,
        max_stack = 1,
    },
    interlope = {
        id = 248518,
        duration = 45,
        max_stack = 1,
    },
    roar_of_sacrifice = {
        id = 53480,
        duration = 12,
        max_stack = 1,
    },
    the_beast_within = {
        id = 212704,
        duration = 15,
        max_stack = 1,
    },

    -- Azerite Powers
    dance_of_death = {
        id = 274443,
        duration = 8,
        max_stack = 1
    },
    primal_instincts = {
        id = 279810,
        duration = 20,
        max_stack = 1
    },

    -- Conduits
    resilience_of_the_hunter = {
        id = 339461,
        duration = 8,
        max_stack = 1
    },
    tactical_retreat = {
        id = 339654,
        duration = 3,
        max_stack = 1
    },

    -- Legendaries
    flamewakers_cobra_sting = {
        id = 336826,
        duration = 15,
        max_stack = 1,
    },
    nessingwarys_trapping_apparatus = {
        id = 336744,
        duration = 5,
        max_stack = 1,
        copy = { "nesingwarys_trapping_apparatus", "nesingwarys_apparatus", "nessingwarys_apparatus" }
    },
    soulforge_embers = {
        id = 336746,
        duration = 12,
        max_stack = 1
    }
} )

--- Shadowlands
local ExpireNesingwarysTrappingApparatus = setfenv( function()
    focus.regen = focus.regen * 0.5
    forecastResources( "focus" )
end, state )

--- Dragonflight
spec:RegisterGear( "tier31", 207216, 207217, 207218, 207219, 207221, 217183, 217185, 217181, 217182, 217184 )
spec:RegisterGear( "tier29", 200390, 200392, 200387, 200389, 200391 )
spec:RegisterAura( "lethal_command", {
    id = 394298,
    duration = 15,
    max_stack = 1
} )

--- The War Within
spec:RegisterGear( "tww1", 212018, 212019, 212020, 212021, 212023 )

spec:RegisterStateExpr( "barbed_shot_grace_period", function ()
    return ( settings.barbed_shot_grace_period or 0 ) * gcd.max
end )

spec:RegisterHook( "spend", function( amt, resource )
    if amt < 0 and resource == "focus" and buff.nessingwarys_trapping_apparatus.up then
        amt = amt * 2
    end

    return amt, resource
end )

local CallOfTheWildCDR = setfenv( function()
    gainChargeTime( "kill_command", spec.abilities.kill_command.recharge/2)
    gainChargeTime( "barbed_shot", spec.abilities.barbed_shot.recharge/2)
end, state )


spec:RegisterHook( "reset_precast", function()
    if debuff.tar_trap.up then
        debuff.tar_trap.expires = debuff.tar_trap.applied + 30
    end

    if legendary.nessingwarys_trapping_apparatus.enabled then
        if buff.nesingwarys_apparatus.up then
            state:QueueAuraExpiration( "nesingwarys_apparatus", ExpireNesingwarysTrappingApparatus, buff.nesingwarys_apparatus.expires )
        end
    end

    if buff.call_of_the_wild.up then
        local tick, expires = buff.call_of_the_wild.applied, buff.call_of_the_wild.expires

        for i = 1, 5 do
            tick = tick + 4
            if tick > query_time and tick < expires then
                state:QueueAuraEvent( "call_of_the_wild_cdr", CallOfTheWildCDR, tick, "AURA_TICK" )
            end
        end
    end

    if covenant.kyrian and now - action.resonating_arrow.lastCast < 6 then applyBuff( "resonating_arrow", 10 - ( now - action.resonating_arrow.lastCast ) ) end

    -- if barbed_shot_grace_period > 0 and cooldown.barbed_shot.remains > 0 then reduceCooldown( "barbed_shot", barbed_shot_grace_period ) end
end )


local trapUnits = { "target", "focus" }
local trappableClassifications = {
    rare = true,
    elite = true,
    normal = true,
    trivial = true,
    minus = true
}

for i = 1, 5 do
    trapUnits[ #trapUnits + 1 ] = "boss" .. i
end

for i = 1, 40 do
    trapUnits[ #trapUnits + 1 ] = "nameplate" .. i
end

spec:RegisterHook( "COMBAT_LOG_EVENT_UNFILTERED", function( _, subtype, _, sourceGUID, sourceName, _, _, destGUID, destName, destFlags, _, spellID, spellName )
    if subtype == "SPELL_CAST_SUCCESS" and sourceGUID == GUID and spellID == 187698 and legendary.soulforge_embers.enabled then
        -- Capture all boss/elite targets present at this time as valid trapped targets.
        table.wipe( tar_trap_targets )

        for _, unit in ipairs( trapUnits ) do
            if UnitExists( unit ) and UnitCanAttack( "player", unit ) and not trappableClassifications[ UnitClassification( unit ) ] then
                tar_trap_targets[ UnitGUID( unit ) ] = true
            end
        end
    end
end, false )


spec:RegisterStateTable( "tar_trap", setmetatable( {}, {
    __index = function( t, k )
        return state.debuff.tar_trap[ k ]
    end
} ) )


-- Abilities
spec:RegisterAbilities( {
    -- Increases your movement speed by $s1% for $d, and then by $186258s1% for another $186258d$?a445701[, and then by $445701s1% for another $445701s2 sec][].$?a459455[; You cannot be slowed below $s2% of your normal movement speed.][]
    aspect_of_the_cheetah = {
        id = 186257,
        cast = 0,
        cooldown = function () return 180 * ( pvptalent.hunting_pack.enabled and 0.5 or 1 ) * ( legendary.call_of_the_wild.enabled and 0.75 or 1 ) - ( 30 * talent.born_to_be_wild.rank ) + ( conduit.cheetahs_vigor.mod * 0.001 ) end,
        gcd = "off",
        school = "physical",

        startsCombat = false,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "aspect_of_the_cheetah" )
            applyBuff( "aspect_of_the_cheetah_sprint" )
        end,
    },

    -- Deflects all attacks and reduces all damage you take by $s4% for $d, but you cannot attack.$?s83495[  Additionally, you have a $83495s1% chance to reflect spells back at the attacker.][]
    aspect_of_the_turtle = {
        id = 186265,
        cast = 8,
        channeled = true,
        cooldown = function () return 180 * ( pvptalent.hunting_pack.enabled and 0.5 or 1 ) * ( legendary.call_of_the_wild.enabled and 0.75 or 1 ) - ( 30 * talent.born_to_be_wild.rank ) + ( conduit.cheetahs_vigor.mod * 0.001 ) end,
        gcd = "off",
        school = "physical",

        startsCombat = false,

        toggle = "cooldowns",

        start = function ()
            applyBuff( "aspect_of_the_turtle" )
        end,
    },

    -- Talent: Fire a shot that tears through your enemy, causing them to bleed for ${$s1*$s2} damage over $d$?s257944[ and  increases your critical strike chance by $257946s1% for $257946d, stacking up to $257946u $Ltime:times;][].    Sends your pet into a frenzy, increasing attack speed by $272790s1% for $272790d, stacking up to $272790u times.    |cFFFFFFFFGenerates ${$246152s1*$246152d/$246152t1} Focus over $246152d.|r
    barbed_shot = {
        id = 217200,
        cast = 0,
        charges = 2,
        cooldown = function () return ( ( conduit.bloodletting.enabled and 17 or 18 ) * haste ) - barbed_shot_grace_period end,
        recharge = function () return ( ( conduit.bloodletting.enabled and 17 or 18 ) * haste ) - barbed_shot_grace_period end,
        gcd = "spell",
        school = "physical",

        talent = "barbed_shot",
        startsCombat = true,

        velocity = 50,
        cycle = "barbed_shot_dot",

        handler = function ()
            if buff.barbed_shot.down then applyBuff( "barbed_shot" )
            else
                for i = 2, 8 do
                    if buff[ "barbed_shot_" .. i ].down then applyBuff( "barbed_shot_" .. i ); break end
                end
            end

            applyDebuff( "target", "barbed_shot_dot" )
            addStack( "frenzy", spec.auras.barbed_shot.duration, 1 )

            if talent.barbed_wrath.enabled then reduceCooldown( "bestial_wrath", 12 ) end
            if talent.thrill_of_the_hunt.enabled then addStack( "thrill_of_the_hunt", nil, 1 ) end

            --- Legacy / PvP Stuff
            if set_bonus.tier29_4pc > 0 then applyBuff( "lethal_command" ) end
            if legendary.qapla_eredun_war_order.enabled then
                setCooldown( "kill_command", 0 )
            end
            if legendary.latent_poison_injectors.enabled then
                removeDebuff( "target", "latent_poison" )
            end
        end,
    },

    -- Rapidly fires a spray of shots for $120360d, dealing an average of $<damageSec> Physical damage to all nearby enemies in front of you. Usable while moving. Deals reduced damage beyond $120361s1 targets.; $?c1[Grants Beast Cleave.][]
    barrage = {
        id = 120360,
        cast = function () return 3 * haste end,
        channeled = true,
        cooldown = 20,
        gcd = "spell",
        school = "physical",

        spend = 60,
        spendType = "focus",

        talent = "barrage",
        startsCombat = true,

        start = function ()
            applyBuff( "barrage" )
        end,
    },

    -- Talent: Sends you and your pet into a rage, instantly dealing $<damage> Physical damage to its target, and increasing all damage you both deal by $s1% for $d. Removes all crowd control effects from your pet. $?s231548[    Bestial Wrath's remaining cooldown is reduced by $s3 sec each time you use Barbed Shot][]$?s193532[ and activating Bestial Wrath grants $s2 $Lcharge:charges; of Barbed Shot.][]$?s231548&!s193532[.][]
    bestial_wrath = {
        id = 19574,
        cast = 0,
        cooldown = 90,
        gcd = "spell",
        school = "physical",

        talent = "bestial_wrath",
        startsCombat = false,

        toggle = "cooldowns",
        nobuff = function () return settings.avoid_bw_overlap and "bestial_wrath" or nil, "avoid_bw_overlap is checked and bestial_wrath is up" end,

        handler = function ()
            applyBuff( "bestial_wrath" )
            if talent.withering_fire.enabled then
                if buff.withering_fire_counter.stacks < 2 then
                    addStack( "withering_fire_counter" )
                else
                    removeBuff ( "withering_fire_counter" )
                    applyBuff ( "withering_fire" )
                end
            end

            if talent.scent_of_blood.enabled then 
                gainCharges( "barbed_shot", talent.scent_of_blood.rank ) 
            end
            -- Legacy / PvP Stuff
            if set_bonus.tier31_2pc > 0 then
                applyBuff( "dire_beast", 15 )
                summonPet( "dire_beast", 15 )
            end
            if pvptalent.the_beast_within.enabled then applyBuff( "the_beast_within" ) end
        end,
    },

    -- Talent: Fires a magical projectile, tethering the enemy and any other enemies within $s2 yards for $d, stunning them for $117526d if they move more than $s2 yards from the arrow.$?s321468[    Targets stunned by Binding Shot deal $321469s1% less damage to you for $321469d after the effect ends.][]
    binding_shot = {
        id = 109248,
        cast = 0,
        cooldown = 45,
        gcd = "spell",
        school = "nature",

        talent = "binding_shot",
        startsCombat = false,

        handler = function ()
            applyDebuff( "target", "binding_shot" )
        end,
    },

    -- Fire a Black Arrow into your target, dealing $o1 Shadow damage over $d.; Each time Black Arrow deals damage, you have a $s2% chance to generate a charge of $?a137015[Barbed Shot]?a137016[Aimed Shot and reduce its cast time by $439659s2%][Barbed Shot or Aimed Shot].
    black_arrow = {
        id = 466930,
        cast = 0.0,
        cooldown = 10.0,
        gcd = "spell",

        spend = 10,
        spendType = 'focus',

        talent = "black_arrow",
        startsCombat = true,

        usable = function () return buff.deathblow.up or buff.flayers_mark.up or ( talent.the_bell_tolls.enabled and target.health_pct > 80 ) or target.health_pct < 20, "requires flayers_mark/hunters_prey or target health below 20 percent or above 80 percent with The Bell Tolls talent" end,
        handler = function ()
            applyDebuff( "target", "black_arrow" )
            spec.abilities.kill_shot.handler()
        end,
        bind = "kill_shot"
    },

    -- Command your pet to tear into your target, causing your target to bleed for $<damage> over $321538d and take $321538s2% increased damage from your pet by for $321538d.
    bloodshed = {
        id = 321530,
        cast = 0,
        cooldown = 60,
        gcd = "spell",
        school = "physical",

        talent = "bloodshed",
        startsCombat = true,

        usable = function() return pet.alive, "requires a living pet" end,

        handler = function ()
            applyDebuff( "target", "bloodshed" )
        end,
    },

    -- Fires an explosion of bolts at all enemies in front of you, knocking them back, snaring them by $s4% for $d, and dealing $s1 Physical damage.$?s378771[; When you fall below $378771s1% heath, Bursting Shot's cooldown is immediately reset. This can only occur once every $385646d.][]
    bursting_shot = {
        id = 186387,
        cast = 0.0,
        cooldown = 30.0,
        gcd = "spell",

        spend = 10,
        spendType = 'focus',

        talent = "bursting_shot",
        startsCombat = true,
    },

    -- Talent: You sound the call of the wild, summoning $s1 of your active pets for $d. During this time, a random pet from your stable will appear every $t2 sec to assault your target for $361582d.$?s378442[    While Call of the Wild is active, Barbed Shot has a $378442h% chance to gain a charge any time Focus is spent.][]$?s378739[    While Call of the Wild is active, Barbed Shot affects all of your summoned pets.][]
    call_of_the_wild = {
        id = 359844,
        cast = 0,
        cooldown = 120,
        gcd = "spell",
        school = "nature",

        talent = "call_of_the_wild",
        startsCombat = false,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "call_of_the_wild" )
            gainCharges( "kill_command", 1 )
            gainCharges( "barbed_shot", 1 )
            -- Queue the pet summons for CDR calculation
            for i = 4, 20, 4 do
                state:QueueAuraEvent( "call_of_the_wild_cdr", CallOfTheWildCDR, query_time + i, "AURA_TICK" )
            end
            if talent.bloody_frenzy.enabled then applyBuff( "beast_cleave", 20 ) end
        end,
    },

    -- Talent: You and your pet blend into the surroundings and gain stealth for $d. While camouflaged, you will heal for $s4% of maximum health every $T4 sec.
    camouflage = {
        id = 199483,
        cast = 0,
        cooldown = 60,
        gcd = "off",
        school = "physical",

        talent = "camouflage",
        startsCombat = false,

        handler = function ()
            applyBuff( "camouflage" )
        end,
    },

    -- Talent: A quick shot causing ${$s2*$<mult>} Physical damage.    Reduces the cooldown of Kill Command by $?s378244[${$s3+($378244s1/-1000)}][$s3] sec.
    cobra_shot = {
        id = 193455,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "physical",

        spend = function () return talent.cobra_senses.enabled and 30 or 35 end,
        spendType = "focus",

        talent = "cobra_shot",
        startsCombat = true,

        handler = function ()

            if talent.serpentine_rhythm.enabled then
                if buff.serpentine_rhythm.stacks == 3 then
                    removeBuff( "serpentine_rhythm" )
                    applyBuff( "serpentine_blessing" )
                else addStack( "serpentine_rhythm" )
                end
            end

            if talent.barbed_scales.enabled then
                gainChargeTime( "barbed_shot", 2 )
            end

            if talent.killer_cobra.enabled and buff.bestial_wrath.up then setCooldown( "kill_command", 0 ) end

            -- Legacy / PvP Stuff
            if debuff.concussive_shot.up then debuff.concussive_shot.expires = debuff.concussive_shot.expires + 3 end
            if set_bonus.tier30_4pc > 0 then reduceCooldown( "bestial_wrath", 1 ) end
        end,
    },

    -- Talent: Dazes the target, slowing movement speed by $s1% for $d.    $?s193455[Cobra Shot][Steady Shot] will increase the duration of Concussive Shot on the target by ${$56641m3/10}.1 sec.
    concussive_shot = {
        id = 5116,
        cast = 0,
        cooldown = 5,
        gcd = "spell",
        school = "physical",

        talent = "concussive_shot",
        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "concussive_shot" )
        end,
    },

    -- Talent: Interrupts spellcasting, preventing any spell in that school from being cast for $d.
    counter_shot = {
        id = 147362,
        cast = 0,
        cooldown = function() return 24 - 2 * talent.lone_survivor.rank end,
        gcd = "off",
        school = "physical",

        talent = "counter_shot",
        startsCombat = true,

        toggle = "interrupts",

        debuff = "casting",
        readyTime = state.timeToInterrupt,

        handler = function ()
            if conduit.reversal_of_fortune.enabled then
                gain( conduit.reversal_of_fortune.mod, "focus" )
            end

            interrupt()
        end,
    },

    -- Summons a powerful wild beast that attacks the target and roars, increasing your Haste by $281036s1% for $d.; Generates $281036s2 Focus.
    dire_beast = {
        id = 120679,
        cast = 0,
        cooldown = 20,
        gcd = "spell",
        school = "nature",

        spend = -20,
        spendType = "focus",

        talent = "dire_beast",
        startsCombat = true,

        handler = function ()
            applyBuff( "dire_beast" )
            summonPet( "dire_beast", 8 )
        end,
    },

    dire_beast_basilisk = {
        id = 205691,
        cast = 0,
        cooldown = 120,
        gcd = "spell",

        spend = 60,
        spendType = "focus",

        toggle = "cooldowns",
        pvptalent = "dire_beast_basilisk",

        startsCombat = true,
        texture = 1412204,

        handler = function ()
            applyDebuff( "target", "dire_beast_basilisk" )
        end,
    },

    dire_beast_hawk = {
        id = 208652,
        cast = 0,
        cooldown = 30,
        gcd = "spell",

        spend = 30,
        spendType = "focus",

        pvptalent = "dire_beast_hawk",

        startsCombat = true,
        texture = 612363,

        handler = function ()
            applyDebuff( "target", "dire_beast_hawk" )
        end,
    },

    -- Leap backwards$?s109215[, clearing movement impairing effects, and increasing your movement speed by $118922s1% for $118922d][]$?s109298[, and activating a web trap which encases all targets within $115928A1 yards in sticky webs, preventing movement for $136634d][].
    disengage = {
        id = 781,
        cast = 0,
        cooldown = 20,
        gcd = "off",
        school = "physical",
        icd = 0.5,

        startsCombat = false,

        handler = function ()
            if talent.posthaste.enabled then applyBuff( "posthaste" ) end
            if conduit.tactical_retreat.enabled then applyDebuff( "target", "tactical_retreat" ) end
        end,
    },

    -- Changes your viewpoint to the targeted location for $d. Only usable outdoors.
    eagle_eye = {
        id = 6197,
        cast = 60,
        channeled = true,
        cooldown = 0,
        gcd = "spell",
        school = "arcane",

        startsCombat = false,

        start = function ()
            applyBuff( "eagle_eye" )
        end,
    },

    exhilaration = {
        id = 109304,
        cast = 0,
        cooldown = 120,
        gcd = "spell",

        startsCombat = false,
        texture = 461117,

        toggle = "defensives",

        handler = function ()
            if talent.rejuvenating_wind.enabled or conduit.rejuvenating_wind.enabled then applyBuff( "rejuvenating_wind" ) end
        end,
    },

    -- Talent: Fires an explosive shot at your target. After $t1 sec, the shot will explode, dealing $212680s1 Fire damage to all enemies within $212680A1 yards. Deals reduced damage beyond $s2 targets.
    explosive_shot = {
        id = 212431,
        cast = 0,
        cooldown = 30,
        gcd = "spell",
        school = "fire",

        spend = 20,
        spendType = "focus",

        talent = "explosive_shot",
        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "explosive_shot" )
        end,
    },

    -- Take direct control of your pet and see through its eyes for $d.
    eyes_of_the_beast = {
        id = 321297,
        cast = 2,
        cooldown = 0,
        gcd = "spell",
        school = "nature",

        startsCombat = false,

        handler = function ()
            applyBuff( "eyes_of_the_beast" )
        end,
    },

    -- Feign death, tricking enemies into ignoring you. Lasts up to $d.
    feign_death = {
        id = 5384,
        cast = 0,
        cooldown = function () return legendary.craven_stategem.enabled and 15 or 30 end,
        gcd = "off",
        school = "physical",

        startsCombat = false,

        handler = function ()
            applyBuff( "feign_death" )

            if pvptalent.survival_tactics.enabled then
                applyBuff( "survival_tactics" )
            end

            if talent.emergency_salve.enabled then
                removeDebuff( "player", "dispellable_disease" )
                removeDebuff( "player", "dispellable_poison" )
            end

            if legendary.craven_strategem.enabled then
                removeDebuff( "player", "dispellable_curse" )
                removeDebuff( "player", "dispellable_disease" )
                removeDebuff( "player", "dispellable_magic" )
                removeDebuff( "player", "dispellable_poison" )
            end
        end,
    },

    -- Exposes all hidden and invisible enemies within the targeted area for $m1 sec.
    flare = {
        id = 1543,
        cast = 0,
        cooldown = 20,
        gcd = "spell",
        school = "arcane",

        startsCombat = false,

        handler = function ()
            if legendary.soulforge_embers.enabled and debuff.tar_trap.up then
                applyDebuff( "target", "soulforge_embers" )
                active_dot.soulforge_embers = max( 1, min( 5, active_dot.tar_trap ) )
            end
        end,
    },

    -- Increase the maximum health of you and your pet by 20% for 10 sec, and instantly heals you for that amount.
    fortitude_of_the_bear = {
        id = 272679,
        cast = 0,
        cooldown = function() return pvptalent.kindred_beasts.enabled and 60 or 120 end,
        gcd = "off",

        startsCombat = false,
        texture = off,

        handler = function ()
            local hp = health.max * 0.2
            health.max = health.max + hp
            gain( hp, "health" )

            applyBuff( "fortitude_of_the_bear" )
        end,

        copy = { 388035, 392956 }, -- Pet's version?

        auras = {
            fortitude_of_the_bear = {
                id = 388035,
                duration = 10,
                max_stack = 1,
                copy = 392956
            }
        }
    },

    -- Hurls a frost trap to the target location that incapacitates the first enemy that approaches for $3355d. Damage will break the effect. Limit 1. Trap will exist for $3355d.
    freezing_trap = {
        id = 187650,
        cast = 0,
        cooldown = function() return 30 - 5 * talent.improved_traps.rank end,
        gcd = "spell",
        school = "physical",

        spend = function ()
            if legendary.nessingwarys_trapping_apparatus.enabled then
                return -45, "focus"
            end
        end,

        startsCombat = false,

        handler = function ()
        end,
    },

    -- Talent: Hurls a fire trap to the target location that explodes when an enemy approaches, causing $236777s2 Fire damage and knocking all enemies away.  Trap will exist for $236775d.$?s321468[    Targets knocked back by High Explosive Trap deal $321469s1% less damage to you for $321469d after being knocked back.][]
    high_explosive_trap = {
        id = 236776,
        cast = 0,
        cooldown = function() return 40 - 5 * talent.improved_traps.rank end,
        gcd = "spell",
        school = "fire",

        spend = function ()
            if legendary.nessingwarys_trapping_apparatus.enabled then
                return -45, "focus"
            end
        end,

        talent = "high_explosive_trap",
        startsCombat = false,

        handler = function ()
        end,
    },

    -- Apply Hunter's Mark to the target, causing the target to always be seen and tracked by the Hunter.; Hunter's Mark increases all damage dealt to targets above $s3% health by $428402s1%. Only one Hunter's Mark damage increase can be applied to a target at a time.; Hunter's Mark can only be applied to one target at a time. When applying Hunter's Mark in combat, the ability goes on cooldown for ${$s5/1000} sec.
    hunters_mark = {
        id = 257284,
        cast = 0,
        cooldown = function () return time > 0 and 20 or 0 end,
        gcd = "totem",
        school = "nature",

        startsCombat = false,

        handler = function ()
            applyDebuff( "target", "hunters_mark" )
        end,
    },

    -- Hurls a fire trap to the target location that explodes when an enemy approaches, causing $236777s2 Fire damage and knocking all enemies up. Limit $s2. Trap will exist for $236775d.$?s321468[; Targets knocked up by Implosive Trap deal $321469s1% less damage to you for $321469d after being knocked up.][]
    implosive_trap = {
        id = 462031,
        cast = 0.0,
        cooldown = function() return 60.0 - 5 * talent.improved_traps.rank end,
        gcd = "spell",

        talent = "implosive_trap",
        startsCombat = false,

        handler = function()
        end,
    },

    interlope = {
        id = 248518,
        cast = 0,
        cooldown = 45,
        gcd = "spell",

        pvptalent = "interlope",

        startsCombat = false,
        texture = 132180,

        handler = function ()
        end,
    },

    -- Talent: Commands your pet to intimidate the target, stunning it for $24394d.$?s321468[    Targets stunned by Intimidation deal $321469s1% less damage to you for $321469d after the effect ends.][]
    intimidation = {
        id = 19577,
        cast = 0,
        cooldown = function() return 60 - 5 * talent.territorial_instincts.rank end,
        gcd = "spell",
        school = "nature",

        talent = "intimidation",
        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "intimidation" )
        end,
    },

    -- Talent: Give the command to kill, causing your pet to savagely deal $<damage> Physical damage to the enemy.
    kill_command = {
        id = 34026,
        cast = 0,
        charges = function() return talent.alpha_predator.enabled and 2 or nil end,
        cooldown = function () return 7.5 * haste end,
        recharge = function() return talent.alpha_predator.enabled and ( 7.5 * haste ) or nil end,
        icd = 0.5,
        gcd = "spell",
        school = "physical",

        cycle = function() -- todo: excecute cycling?
            -- if talent.killer_instinct.enabled and target.health_pct > 35 then return 1
                if talent.a_murder_of_crows.enabled then return "a_murder_of_crows"
                    else return nil
                    end
            end,


        spend = 30,
        spendType = "focus",

        talent = "kill_command",
        startsCombat = true,

        disabled = function()
            if settings.check_pet_range and settings.petbased and Hekili:PetBasedTargetDetectionIsReady( true ) and not Hekili:TargetIsNearPet( "target" ) then return true, "not in-range of pet" end
        end,

        handler = function ()


            if talent.a_murder_of_crows.enabled then
                if buff.a_murder_of_crows_stack.stack == 4 then
                    applyDebuff( "target", "a_murder_of_crows" )
                    removeBuff( "a_murder_of_crows" )
                else
                    addStack( "a_murder_of_crows_stack" )
                end
            end

            if talent.wild_instincts.enabled and buff.call_of_the_wild.up then
                applyDebuff( "target", "wild_instincts", nil, buff.wild_instincts.stack + 1 )
            end

            if talent.covering_fire.enabled and buff.beast_cleave.up then buff.beast_cleave.expires = buff.beast_cleave.expires + 1 end

            --- Legacy / PvP Stuff
            if legendary.flamewakers_cobra_sting.enabled then removeBuff( "flamewakers_cobra_sting" ) end
            if set_bonus.tier29_4pc > 0 then removeBuff( "lethal_command" ) end
            if set_bonus.tier30_4pc > 0 then reduceCooldown( "bestial_wrath", 1 ) end
        end,
    },

    -- Talent: You attempt to finish off a wounded target, dealing $s1 Physical damage. Only usable on enemies with less than $s2% health.$?s343248[    Kill Shot deals $343248s1% increased critical damage.][]
    kill_shot = {
        id = 53351,
        cast = 0,
        cooldown = 10,
        gcd = "spell",
        school = "physical",

        spend = function () return ( buff.flayers_mark.up ) and 0 or 10 end,
        spendType = "focus",

        talent = "kill_shot",
        notalent = "black_arrow",
        startsCombat = true,

        cycle = function() return talent.venoms_bite.enabled and "serpent_sting" or nil end,

        usable = function () return buff.deathblow.up or ( talent.the_bell_tolls.enabled and target.health_pct > 80 ) or target.health_pct < 20 or buff.flayers_mark.up, "requires flayers_mark or target health below 20 percent" end,
        
        handler = function ()
            removeBuff( "deathblow" )
            if talent.venoms_bite.enabled then applyDebuff( "target", "serpent_sting" ) end

            --- Legacy / PvP Stuff
            if covenant.venthyr then
                if buff.flayers_mark.up and legendary.pouch_of_razor_fragments.enabled then
                    applyDebuff( "target", "pouch_of_razor_fragments" )
                    removeBuff( "flayers_mark" )
                end
            end

        end,
        bind = "black_arrow",
        copy = { 53351, 320976 }
    },

    -- Your pet removes all root and movement impairing effects from itself and a friendly target, and grants immunity to all such effects for 4 sec.
    masters_call = {
        id = 272682,
        cast = 0,
        cooldown = function() return pvptalent.kindred_beasts.enabled and 22.5 or 45 end,
        gcd = "spell",

        startsCombat = false,
        texture = off,

        handler = function ()
            applyBuff( "masters_call" )
        end,

        copy = 53271, -- Pet's version.

        auras = {
            masters_call = {
                id = 62305,
                duration = 4,
                max_stack = 1
            }
        }
    },

    -- Talent: Misdirects all threat you cause to the targeted party or raid member, beginning with your next attack within $d and lasting for $35079d.
    misdirection = {
        id = 34477,
        cast = 0,
        cooldown = 30,
        gcd = "off",
        school = "physical",

        talent = "misdirection",
        nopvptalent = "interlope",
        startsCombat = false,

        handler = function ()
            applyBuff( "misdirection" )
        end,
    },

    -- Talent: Fires several missiles, hitting all nearby enemies within $A2 yards of your current target for $s2 Physical damage$?s115939[ and triggering Beast Cleave][]. Deals reduced damage beyond $s1 targets.$?s19434[    |cFFFFFFFFGenerates $213363s1 Focus per target hit.|r][]
    multishot = {
        id = 2643,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "physical",

        spend = 40,
        spendType = "focus",

        talent = "multishot",
        startsCombat = true,

        handler = function ()
            applyBuff( "beast_cleave" )

            if talent.scattered_prey.enabled then
                if buff.scattered_prey.up then
                    removeBuff( "scattered_prey" )
                else applyBuff( "scattered_prey" )
                end
            end

            -- Legacy / PvP Stuff
            if set_bonus.tier30_4pc > 0 then reduceCooldown( "bestial_wrath", 1 ) end
    end,
    },

    -- Talent: Interrupts spellcasting, preventing any spell in that school from being cast for $d.
    muzzle = {
        id = 187707,
        cast = 0,
        cooldown = function() return 15 - 2 * talent.lone_survivor.rank end,
        gcd = "off",
        school = "physical",

        startsCombat = true,
        toggle = "interrupts",

        debuff = "casting",
        readyTime = state.timeToInterrupt,

        handler = function ()
            if conduit.reversal_of_fortune.enabled then gain( conduit.reversal_of_fortune.mod, "focus" ) end
            interrupt()
        end,
    },

    primal_rage = {
        id = 272678,
        cast = 0,
        cooldown = 360,
        gcd = "spell",

        toggle = "cooldowns",

        startsCombat = true,
        texture = 136224,

        usable = function () return pet.alive and pet.ferocity, "requires a living ferocity pet" end,
        handler = function ()
            applyBuff( "primal_rage" )
            stat.haste = stat.haste + 0.4
            applyDebuff( "player", "exhaustion" )
        end,
    },

    roar_of_sacrifice = {
        id = 53480,
        cast = 0,
        cooldown = 60,
        gcd = "spell",

        talent = "roar_of_sacrifice",

        startsCombat = false,
        texture = 464604,

        handler = function ()
            applyBuff( "roar_of_sacrifice" )
        end,
    },

    --[[ Talent: Scares a beast, causing it to run in fear for up to $d.  Damage caused may interrupt the effect.  Only one beast can be feared at a time.
    scare_beast = {
        id = 1513,
        cast = 1.5,
        cooldown = 0,
        gcd = "spell",
        school = "nature",

        spend = 25,
        spendType = "focus",

        talent = "scare_beast",
        startsCombat = false,

        usable = function() return target.is_beast, "requires a beast target" end,

        handler = function ()
            applyDebuff( "tagret", "scare_beast" )
        end,
    }, ]]

    -- Talent: A short-range shot that deals $s1 damage, removes all harmful damage over time effects, and incapacitates the target for $d.  Any damage caused will remove the effect. Turns off your attack when used.$?s321468[    Targets incapacitated by Scatter Shot deal $321469s1% less damage to you for $321469d after the effect ends.][]
    scatter_shot = {
        id = 213691,
        cast = 0,
        cooldown = 30,
        gcd = "spell",
        school = "physical",

        talent = "scatter_shot",
        startsCombat = false,

        handler = function ()
            -- trigger scatter_shot [37506]
            applyDebuff( "target", "scatter_shot" )
        end,
    },

    spirit_mend = {
        id = 90361,
        cast = 0,
        cooldown = 30,
        gcd = "spell",

        startsCombat = false,
        texture = 237586,

        handler = function ()
            applyBuff( "spirit_mend" )
        end,
    },

    -- A steady shot that causes $s1 Physical damage.; Usable while moving.$?s321018[; Generates $s2 Focus.][]
    steady_shot = {
        id = 56641,
        cast = 1.7,
        spend = -10,
        spendType = "focus",
        cooldown = 0.0,
        gcd = "spell",

        startsCombat = true,
    },

    -- Reduces all damage you and your pet take by $s1% for $d.
    survival_of_the_fittest = {
        id = 264735,
        cast = 0,
        cooldown = function () return ( talent.lone_survivor.enabled and 150 or 180 ) * ( pvptalent.hunting_pack.enabled and 0.5 or 1 ) * ( legendary.call_of_the_wild.enabled and 0.75 or 1 ) * ( 1 - 0.075 * talent.born_to_be_wild.rank ) + ( conduit.cheetahs_vigor.mod * 0.001 ) end,
        charges = function() return talent.padded_armor.enabled and ( ( talent.lone_survivor.enabled and 150 or 180 ) * ( pvptalent.hunting_pack.enabled and 0.5 or 1 ) * ( legendary.call_of_the_wild.enabled and 0.75 or 1 ) * ( 1 - 0.075 * talent.born_to_be_wild.rank ) + ( conduit.cheetahs_vigor.mod * 0.001 ) ) or nil end,
        recharge = function() return talent.padded_armor.enabled and 2 or nil end,
        gcd = "off",

        startsCombat = false,

        handler = function()
            applyBuff( "survival_of_the_fittest" )
        end,
    },

    summon_pet = {
        id = 883,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0,
        spendType = "focus",

        startsCombat = false,
        texture = 'Interface\\ICONS\\Ability_Hunter_BeastCall',

        essential = true,
        nomounted = true,

        usable = function () return not pet.exists, "requires no active pet" end,

        handler = function ()
            summonPet( "made_up_pet", 3600, "ferocity" )
        end,
    },

    -- Hurls a tar trap to the target location that creates a $187699s1 yd radius pool of tar around itself for $13810d when the first enemy approaches. All enemies have $135299s1% reduced movement speed while in the area of effect. Limit $s2. Trap will exist for $13809d.
    tar_trap = {
        id = 187698,
        cast = 0,
        cooldown = function() return 30 - 5 * talent.improved_traps.rank end,
        gcd = "spell",
        school = "physical",

        spend = function ()
            if legendary.nessingwarys_trapping_apparatus.enabled then
                return -45, "focus"
            end
        end,

        talent = "tar_trap",
        startsCombat = false,

        -- Let's not recommend Tar Trap if Flare is on CD.
        timeToReady = function () return max( 0, cooldown.flare.remains - gcd.max ) end,

        handler = function ()
            applyDebuff( "target", "tar_trap" )
        end,
    },

    -- Talent: Removes $s1 Enrage and $s2 Magic effect from an enemy target.$?s343244[    Successfully dispelling an effect generates $343244s1 Focus.][]
    tranquilizing_shot = {
        id = 19801,
        cast = 0,
        cooldown = 10,
        gcd = "totem",
        school = "nature",

        talent = "tranquilizing_shot",
        startsCombat = true,

        toggle = "interrupts",

        usable = function () return buff.dispellable_enrage.up or buff.dispellable_magic.up, "requires enrage or magic effect" end,

        handler = function ()
            if talent.devilsaur_tranquilizer.enabled and buff.dispellable_enrage.up and buff.dispellable_magic.up then reduceCooldown( "tranquilizing_shot", 5 ) end
            removeBuff( "dispellable_enrage" )
            removeBuff( "dispellable_magic" )
            if state.spec.survival or talent.improved_tranquilizing_shot.enabled then gain( 10, "focus" ) end
        end,
    },

    -- Sylvanas Legendary / Talent: Fire an enchanted arrow, dealing $354831s1 Shadow damage to your target and an additional $354831s2 Shadow damage to all enemies within $354831A2 yds of your target. Targets struck by a Wailing Arrow are silenced for $355596d.
    wailing_arrow = {
        id = 355589,
        cast = function()
            if buff.lock_and_load.up then return 0 end
            return ( buff.trueshot.up and 1 or 2 ) * haste
        end,
        cooldown = 60,
        gcd = "spell",

        spend = function()
            if buff.lock_and_load.up then return 0 end
            return 15 * ( buff.trueshot.up and 0.5 or 1 )
        end, -- TODO: Does game match spell data?
        spendType = "focus",

        toggle = "cooldowns",
        startsCombat = true,

        usable = function ()
            if moving and settings.prevent_hardcasts then return false, "prevent_hardcasts is checked and player is moving" end
            return true
        end,

        handler = function ()
            removeStack( "lock_and_load" )
            interrupt()
            applyDebuff( "target", "wailing_arrow" )
            if talent.readiness.enabled then
                setCooldown( "rapid_fire", 0 )
                gainCharges( "aimed_shot", 2 )
            end
        end,

        copy = { 392060, 355589 }
    },

    -- Maims the target, reducing movement speed by $s1% for $d.
    wing_clip = {
        id = 195645,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "physical",

        spend = 20,
        spendType = "focus",

        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "wing_clip" )
        end,
    },

    -- Utility
    mend_pet = {
        id = 136,
        cast = 0,
        cooldown = 10,
        gcd = "spell",

        startsCombat = false,

        usable = function ()
            if not pet.alive then return false, "requires a living pet" end
            return true
        end,
    },
} )


spec:RegisterRanges( "arcane_shot", "kill_command", "wing_clip" )

spec:RegisterOptions( {
    enabled = true,

    aoe = 3,
    cycle = false,

    nameplates = false,
    nameplateRange = 40,
    rangeFilter = false,

    damage = true,
    damageExpiration = 3,

    potion = "tempered_potion",
    package = "Beast Mastery",
} )


spec:RegisterSetting( "barbed_shot_grace_period", 1, {
    name = strformat( "%s Grace Period", Hekili:GetSpellLinkWithTexture( spec.abilities.barbed_shot.id ) ),
    desc = strformat( "If set above zero, %s's cooldown will be reduced by this number of global cooldowns.  This feature helps to ensure that you maintain %s stacks by recommending %s with time remaining on %s.",
        Hekili:GetSpellLinkWithTexture( spec.abilities.barbed_shot.id ), Hekili:GetSpellLinkWithTexture( spec.auras.frenzy.id ), spec.abilities.barbed_shot.name, spec.auras.frenzy.name ),
    icon = 2058007,
    iconCoords = { 0.1, 0.9, 0.1, 0.9 },
    type = "range",
    min = 0,
    max = 2,
    step = 0.01,
    width = 1.5
} )

spec:RegisterStateExpr( "barbed_shot_grace_period", function()
    return settings.barbed_shot_grace_period or 0.5
end )

spec:RegisterSetting( "pet_healing", 0, {
    name = strformat( "%s Below Health %%", Hekili:GetSpellLinkWithTexture( spec.abilities.mend_pet.id ) ),
    desc = strformat( "If set above zero, %s may be recommended when your pet falls below this health percentage.  Setting to |cFFFFd1000|r disables this feature.",
        Hekili:GetSpellLinkWithTexture( spec.abilities.mend_pet.id ) ),
    icon = 132179,
    iconCoords = { 0.1, 0.9, 0.1, 0.9 },
    type = "range",
    min = 0,
    max = 100,
    step = 1,
    width = 1.5
} )

spec:RegisterSetting( "avoid_bw_overlap", false, {
    name = strformat( "Avoid %s Overlap", Hekili:GetSpellLinkWithTexture( spec.abilities.bestial_wrath.id ) ),
    desc = strformat( "If checked, %s will not be recommended if the buff is already active.", Hekili:GetSpellLinkWithTexture( spec.abilities.bestial_wrath.id ) ),
    type = "toggle",
    width = "full"
} )

spec:RegisterSetting( "mark_any", false, {
    name = strformat( "%s Any Target", Hekili:GetSpellLinkWithTexture( spec.abilities.hunters_mark.id ) ),
    desc = strformat( "If checked, %s may be recommended for any target rather than only bosses.", Hekili:GetSpellLinkWithTexture( spec.abilities.hunters_mark.id ) ),
    type = "toggle",
    width = "full"
} )

spec:RegisterSetting( "check_pet_range", false, {
    name = "Check Pet Range for |T132176:0|t Kill Command",
    desc = function ()
        return "If checked, |T132176:0|t Kill Command will be recommended if your pet is not in range of your target.\n\n" ..
            "Requires |c" .. ( state.settings.petbased and "FF00FF00" or "FFFF0000" ) .. "Pet-Based Target Detection|r"
    end,
    type = "toggle",
    width = "full"
} )


spec:RegisterPack( "Beast Mastery", 20241022, [[Hekili:T31AVTnow7FlffRB8KuhB542MzTdWoDXl2PyN5dRhG3Vzzzz5yTXwYJKCtZGa)BFphQBKIhkrjl3MwyGbttejF4Z5qEUqkgXzdM9hZMU0kYz2VB034Mb9nm61V)qJrZMg90oNzt3zz)G19Wp4zTf())IJvy0H5)g8)DcEcl(Pn(wlruc93hydv51hMVokAx4pF9137gTE)IE2(BVo0D7(nwrU(E2bwRIWF3(6ztxS3Dt0V6nBbjlU52ztT2hT2py20PUB)4SPRDxU0jU6oH2ZMIv)T9V9Tgg)8H5yvomF)oePdF6WNIl8dLxy)bqH)hNWDo2GG9V27bc2Bcrrm4HdZdDIIC9UpVbV)TgVhAW)y5YdZ)O1MnhM7V6W8O1ohM))7UbEyK1ghpaj71o2pe(3HUmek7J(mGbAS2pk9Hf6m((yi0h)bduRae5O1UEZMUXnmkKnI5SYA)Mi4h)D2iOLnQzNn1oUBmdHEz2uhpRfBCwo7xMfbkw(6ffy59NGQ39VaHJQ2dXAN)KP2bUaUUwWiUtuV1owBIwBUd1yJpmhEKj(iaR8UyRJ3stOeeTBkGwgDbfOz8VyIYwSeAgpvZEzi22rnPTrbUEp4eXa4DkfLlYgFd7TfgbmT8E6W8NFghedUhKt3qZf(HW4t3dZ7Cyo2BF2XCPpOby65qZTSzjtomVpRgjTlYDRJzKpQGm)auYDhMB0pN68ngz47vYWKE0XZzRRtitzBeZWxLotR3c0K00EJJ1ND6LGcpD5B8qWmf0n2r48g9uLHSrWpOnfVlJI1LFqlhuF(fd8mKLt3f4a(AwyjByeUF7wO148rcZcobZFhuzSwPT8ZwGycLI)0M9W)GA(4Px9Im6T2k0023FZs)h9se70chWkeS0nxSF1kMiFr8aNyZZRr6aBocUWmt3Ga)at)vMRcasTpWzjm3ARp80hdtrLdYQBIaln6Ls)El3hW8qZMQWrcIkuecCigN1l108cu3KjQAsNQ45KQ4zx2)jRxR7iJKw(hDLwCa2a3DXwb)thWCFRRNtsSoWk137EmGwcuWp4dp(jp7dZFecxbbataoS3H5)kGkIhetaJMoFxGRp4b5jikxS(1z1ki(BStGLwBHmoYE2vhMVjPVGcHyvbSaPzWRQCwIkOkbjae2Y21Ad7XoXC123l0Djw1FJzUehj))l1GbI)MBX8OJ1dmHDTfij(GkiqI5HUE2a0U4pVZ)rSgU4J3TXfiYcNOhDC8suFl3EFAlb)GEltEmpI9yUEeJNzoWmvXtfKwlFxPpRhbMe9OHqpwmq(lVyPJ496VWjmcg1nFeMzVw0XFuwKJ0qfe5ySWkyb46mo)OCzfhM6TkWX7VEQ3(DmYY)OaNTwUEyaxqwU3EjOp(YH5xcvkhoZ7H5zoq8iWqyzSEIhIWiiT74i2P(EYStfekOZSw(eNhSICJlqmA(fHbfwSX3FzEO4Uc1IfSfQemH08riJwHq2zKqQwj8a8By)eOynJh9crDBXKpxSbeotl00s7SozILqMe5AzyctpJrmnCM2o3JEssiOi)KzIIjtKq5UmzkPl6YLwlK2TlBcrQ5Ggt2eNvwSFku33jQRaEhU2PyLkMYyA9FWfWgYbAl4uHEOOyMCcTmzMorZUTbMisk00jKXocGXOvU3VoYKFO8wHjJyRmryeNfUgPwyCYnalq)6yYJ9et8m06ZqCKGSHBAbBq)QM0XBULyUN0dOodwTLT)IaR8EjBCgFSz6CLbc5JYPTfgxhiyP48LDB8dr)KuvTsRfEIZLFQOF1LUX5FmkVB3GJkHM)39lVhwfxm7v75FLV9(Wm4ywFJ5Se)jWFTsDsXf31AIWcR7zZ8G1s8aBvGdkDzGmzG5bjwAcCUhJvd)(W(mhKJtlbKP8EXkW2YdPqqqSEkkEzReHu0104v65iwXuZkmUGPmCURccDcEaxZoXYGEzq33vWrO5Q9bpPrGIV901cYfesCcAo2rLN603qkFBoJx5g4WuYuB6YlcYoKBlb25Z(xMfxO8Y9xccJjlDHkwUFUGjL7ejAeZ90js45KfRrYI3O1iP6POhl3YNXXpEG5yQipl5K2uLG77RrEGFqN8aVv3mqJtZHonrXkQAXq8jiwux)zhp)TWc8GhlOMXL3brz2HZLcXfhcQxy(w4ASkkYhROjAf2xnltXB4mJu6nB1EOGaNyqY3Pg(fzO0qlzsKgwuvyXYfFXqCnoDlnB3kDNERc9)qTYtTIWzTwwZJ0pFy1z4DKjtsLpSOLCoNlWj17B(rYj5eClUcTwRRsYYD3(nHoSyOQxXuPPspyuntLo7T4qKpD171LoHbUa3ksNpBI2udKQQWEhRhALKzt5w4M3V3jm2WCelYy(wXHBQQjlKjvgmTJI40LwNKKG8K9cBuT)LUROfMc6dMARqgCvWYevIPdotEAL5aKPb1zOJkh)uPizIm(2T24hX)74ByWF1kCci7vEXfxR8xwr224Mp7qQi5D4nXKN41dKVxxzd5nTlOjyc83DOIx(W1PPXwiIvLn8sCJHLeqjDxPc)Dk59BJ9FvfaVLz(owjmDuwcq)BgXyqbbpzarsLBiPYlLzAuLMt(7MqQ8v1fy1v3hh9KhbwqwVXsA5s73lRcpYrT839iTkj1EsTWA0VSkmMg4IAJU17TGs)sfJFRmKogI9NN(ED069O2kEOQOpuYZk14vsGK6LRvljlBJrTKqtTM3cXxmkeFXqR4lvmePHZFdvcYGwl(ISZonCruIrr5XxiBiv8fctOsf(AfFHcGM7IU2XxKdPxkZ0OknN8KXxu3fTr8LsM8OYyTvIVqINUXxgCQIVus0wLXxQ(m0C8XxQi54JXdvf9rlfFrHxI2i(s9e6zjl6(ZobHyqf2jXT)TgqqKhTc8Wd2XSPSJKQ72D(br4Q4bGFtYrr9nhMh48N7DzNCMqFCm1AFK)wRi8b2RTaEe27WN(3SZqeEeA)OVh0xSIFdXrfeaepLoufLUCoOkxm4lDZq9dTmQh(eH8MDgdRNeBuKBjdgINGWm6jAdXvSGaRcuXzSsGkvSwGAuoOsfRfOvFchjyVgnrRoV6ZkjHuQrt0SZL8Os0Bu15KcFLatejGyiQX8UPWxjWCHBOueCLPlpvc3G6d3lE2v5GY55QAdVga)9I)7Mo0DIHVsGB6qNM8UPWxjWV49t8YMDvoOCEUQ2WRkb5KgHjcvJ8JhqN7EXxnZBeZFx1l6POSFArxsZ(De6dpPOFZPiaNkqL320YS)YRYje8kHTPgFAY6Mc)jd4V18(OscQDNBCsb)eb7zoFMZVm5Ct9yOjRBk8NmGpZ7MXBH5wwlFQ8jFXvqlgxFGRdK1Aff1NX1c(kb(KKDxdxm45ebQe2ZkIJa2VjC2FNtSTyiS4Bp12wDUG4mwW9WKMX9Q(F(5s4t3NF(v1fqzkWG6oEB3IEy(Bd7i8IolTYxA0xG0cYFjcZDK86TdgvwJE7OXKnRd5tV8Mr3jiiGcSK3sBNlkPNlTW6rR7MuqLjd3DtOXRrdMC9fr5Jf0qk6HlldHc64UDvjC4CvAbWOpDbJPakxYy91RuA8Xt604tt6lzefFWb625IxPAA8XyXQetswOu)uA3aLJAc8ykiA5o2y0rq(kYC47uVBxF272poE3U(hwVBxF272j27ww2DJofPMRc0bsmPSfwNxLti4vclX0tTwPQMSUPWFYa(BnVpQfW3UZnoPGFIG9mNpZ5xMCUPEm0K1nf(tgWN5DZ4TWClQnZMOcAX46dCDGuPsGUo1LX1c(kb(KKDNrZobwNteOsypRiocy)MWz17sUYfGw62(yqTWoz(O)(izO)(ir4fx9UKtuzX9rAGI9rswy0yFKKBu92WgT2hPbu7JKCpxAH1Jwf2hjk4A6(iroysVzbnCFKiqOS9rQyq3gVpsebcL2L8IgF8KUE7JKYTdU(wSkXSX7JeHTu92hjDjFfzo8DQ3n17s(zVBTaT(66D76Fy9UjTl5N9U1YE36P4pZa7LyYHVy(lm4hQtPFRIUuY(Te6KZkcpY)SSXB3iCIxp0(i)tJAk5KEAPJsNEWsSsOqmVO6dl7lklfOPfuFiBQyt(XZSWCf6VSMAI8rpp80olpX3LcNxCF3vlGmXxKvjqv4Zcjc7tPAbiZEEDbSfg8ucDYx90IGw4JHQeCkC5X)PjTaKuF1sRWzu2NCIA4qQ4a9rzmPfy13hIwWwpFiAbztf7wCA4j1kxHhkH7UKcqtEVMue3BBz7Cf41uBX(TUT4VYmdrWEx8nne(1kID5jcfJxtC(RCXVPOXff2l7B6YLtUo)MI7WNE9H5NV4R(QFXxD4tuJlPRG4k8Ja7e5voFf7B16KS1pj(LZjFrgslbsSbPfWTMUQ)GZKVmVQ)(WKZeQfcN3NsLj0W0LsY3G0NrwXjevStjmzsjmryfVAQp5vrF3k21zMPH0mZs22hAG5VBZUYD1KlKUH1azw42vRBN4LWlDVQnPFhY7tnyv709TWx6y0NAsLGI4VKz5FU8LklFPP3hSOGiEhYoM7(JvOFWWMX)k7A)mw)cR7V6kLOHfQ5xzTPsUb)lmS7AhnzasJKUi5wqDSbAALeBN7JtwNcvBy19tCdlPVUZaf4Q6Q7gGJ(V(1Pbsd7bJaqN669z)hGA9fqR4btuqJ84oMfdW01B1E8djh2VS01KYcA)UCzTyHDUG1MIFmXF(5mRsYpf3Jh2NEpOg8U8P5X8p)(pQHmubbP68HsDE2Tz0PVZLKCX7MOVbei7Qg6K333wSRJV3Go597WbCUm7fBxHd75xHjxjC3BeBEQyrpDkBzBJNCV9YlvDzb98ZQxB24HDUqP1e7v68kfekZTH4IM6M9Cjnxw)iPWzDvxkDv(LOdrPzxdJzdLuxoKJXlTNlbfeMwcXcM4CNqqS4nGMIAIXgLkViwKsxY95drz8xopfNMOQ6utPQ)eq12eu2wzd3zlySJ89TZDd6LhMjDPGu6SSRqfUrurlToeR(Rm9rEzHygn53Kuens8MLHOcfUdyuqYKLAiDLQmEuLIS01O4yyE7pzqoiYD1V0ger8UxHLBeJnxYDdUCjezDC292cV3TckxS5QCCuOrNDhwP7qLZCzfi4Pa0ynP)IvBOwJDl6wyeIYjmRe1(4sAOK)TqILvOuAOks18KePMBhV7u69ow9MfQNpUBaxKkDEkFpIH67oLNkRIzvLmjnjDldmGxxjFUvLFKOEU4O9X6DMHIkNSScBphSfyS0WD749Kbg)vJvlHv5EHhmsHx40v8EzX9Ji)m6KSpekxXvj3ewDB9vQfFPjnEuxDfbSwWYzlxgARK61LujcZv(7MWU4QsONoI(v5xfvtQ0)8v2(ElDrgnrLGqszC33a)HBVc)HK7beWTgElHKUhjXo5uSzE6DsVO(lE04io5y6)3xn55nuXbhJOUcNBmf)XvllivFQXKBt9oDwADOXO(tRwUJlRS6rkXJmgfAn8eJroiYVH9Y7xCToVyeauYXfZOLoTyKhY3ULU15rY7vTwhvSg93tnPbQkeB65eJW4PEhtmnzEtD(zW78R9o3SFDo2S15VjGQo0SkoZSn5iZEShnvTC(rDIzl7aZESKs05xlECzR4VfGJ(WYwVZkBBDuzjDPl68RKxpyTC(1OJjBPNs226qYEsoJSemF20WDo2Z(DJrdzxHpZ(Fp)]] )