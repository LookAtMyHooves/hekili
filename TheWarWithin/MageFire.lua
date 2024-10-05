-- MageFire.lua
-- July 2024

if UnitClassBase( "player" ) ~= "MAGE" then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State

local strformat = string.format

local spec = Hekili:NewSpecialization( 63 )

spec:RegisterResource( Enum.PowerType.ArcaneCharges )
spec:RegisterResource( Enum.PowerType.Mana )

-- Talents
spec:RegisterTalents( {
    -- Mage
    accumulative_shielding    = {  62093, 382800, 1 }, -- Your barrier's cooldown recharges 30% faster while the shield persists.
    alter_time                = {  62115, 342245, 1 }, -- Alters the fabric of time, returning you to your current location and health when cast a second time, or after 10 sec. Effect negated by long distance or death.
    arcane_warding            = {  62114, 383092, 2 }, -- Reduces magic damage taken by 3%.
    barrier_diffusion         = {  62091, 455428, 1 }, -- Whenever one of your Barriers is removed, reduce its cooldown by 4 sec.
    blast_wave                = {  62103, 157981, 1 }, -- Causes an explosion around yourself, dealing 6,249 Fire damage to all enemies within 8 yds, knocking them back, and reducing movement speed by 80% for 6 sec.
    blazing_barrier           = {  62119, 235313, 1 }, -- Shields you in flame, absorbing 116,683 damage for 1 min. Melee attacks against you cause the attacker to take 1,653 Fire damage.
    cryofreeze                = {  62107, 382292, 2 }, -- While inside Ice Block, you heal for 40% of your maximum health over the duration.
    displacement              = {  62095, 389713, 1 }, -- Teleports you back to where you last Blinked and heals you for 106,028 health. Only usable within 8 sec of Blinking.
    diverted_energy           = {  62101, 382270, 2 }, -- Your Barriers heal you for 10% of the damage absorbed.
    dragons_breath            = { 101883,  31661, 1 }, -- Enemies in a cone in front of you take 7,704 Fire damage and are disoriented for 4 sec. Damage will cancel the effect.
    energized_barriers        = {  62100, 386828, 1 }, -- When your barrier receives melee attacks, you have a 10% chance to be granted 1 Fire Blast charge. Casting your barrier removes all snare effects.
    flow_of_time              = {  62096, 382268, 2 }, -- The cooldowns of Blink and Shimmer are reduced by 2 sec.
    freezing_cold             = {  62087, 386763, 1 }, -- Enemies hit by Cone of Cold are frozen in place for 5 sec instead of snared. When your roots expire or are dispelled, your target is snared by 90%, decaying over 3 sec.
    frigid_winds              = {  62128, 235224, 2 }, -- All of your snare effects reduce the target's movement speed by an additional 10%.
    greater_invisibility      = {  93524, 110959, 1 }, -- Makes you invisible and untargetable for 20 sec, removing all threat. Any action taken cancels this effect. You take 60% reduced damage while invisible and for 3 sec after reappearing.
    ice_block                 = {  62122,  45438, 1 }, -- Encases you in a block of ice, protecting you from all attacks and damage for 10 sec, but during that time you cannot attack, move, or cast spells. While inside Ice Block, you heal for 40% of your maximum health over the duration. Causes Hypothermia, preventing you from recasting Ice Block for 30 sec.
    ice_cold                  = {  62085, 414659, 1 }, -- Ice Block now reduces all damage taken by 70% for 6 sec but no longer grants Immunity, prevents movement, attacks, or casting spells. Does not incur the Global Cooldown.
    ice_floes                 = {  62105, 108839, 1 }, -- Makes your next Mage spell with a cast time shorter than 10 sec castable while moving. Unaffected by the global cooldown and castable while casting.
    ice_nova                  = {  62088, 157997, 1 }, -- Causes a whirl of icy wind around the enemy, dealing 15,870 Frost damage to the target and reduced damage to all other enemies within 8 yds, and freezing them in place for 2 sec.
    ice_ward                  = {  62086, 205036, 1 }, -- Frost Nova now has 2 charges.
    improved_frost_nova       = {  62108, 343183, 1 }, -- Frost Nova duration is increased by 2 sec.
    incantation_of_swiftness  = {  62112, 382293, 2 }, -- Greater Invisibility increases your movement speed by 40% for 6 sec.
    incanters_flow            = {  62118,   1463, 1 }, -- Magical energy flows through you while in combat, building up to 10% increased damage and then diminishing down to 2% increased damage, cycling every 10 sec.
    inspired_intellect        = {  62094, 458437, 1 }, -- Arcane Intellect grants you an additional 3% Intellect.
    mass_barrier              = {  62092, 414660, 1 }, -- Cast Blazing Barrier on yourself and 4 allies within 40 yds.
    mass_invisibility         = {  62092, 414664, 1 }, -- You and your allies within 40 yards instantly become invisible for 12 sec. Taking any action will cancel the effect. Does not affect allies in combat.
    mass_polymorph            = {  62106, 383121, 1 }, -- Transforms all enemies within 10 yards into sheep, wandering around incapacitated for 15 sec. While affected, the victims cannot take actions but will regenerate health very quickly. Damage will cancel the effect. Only works on Beasts, Humanoids and Critters.
    master_of_time            = {  62102, 342249, 1 }, -- Reduces the cooldown of Alter Time by 10 sec. Alter Time resets the cooldown of Blink and Shimmer when you return to your original location.
    mirror_image              = {  62124,  55342, 1 }, -- Creates 3 copies of you nearby for 40 sec, which cast spells and attack your enemies. While your images are active damage taken is reduced by 20%. Taking direct damage will cause one of your images to dissipate.
    overflowing_energy        = {  62120, 390218, 1 }, -- Your spell critical strike damage is increased by 10%. When your direct damage spells fail to critically strike a target, your spell critical strike chance is increased by 2%, up to 10% for 8 sec. When your spells critically strike Overflowing Energy is reset.
    quick_witted              = {  62104, 382297, 1 }, -- Successfully interrupting an enemy with Counterspell reduces its cooldown by 4 sec.
    reabsorption              = {  62125, 382820, 1 }, -- You are healed for 3% of your maximum health whenever a Mirror Image dissipates due to direct damage.
    reduplication             = {  62125, 382569, 1 }, -- Mirror Image's cooldown is reduced by 10 sec whenever a Mirror Image dissipates due to direct damage.
    remove_curse              = {  62116,    475, 1 }, -- Removes all Curses from a friendly target.
    rigid_ice                 = {  62110, 382481, 1 }, -- Frost Nova can withstand 80% more damage before breaking.
    ring_of_frost             = {  62088, 113724, 1 }, -- Summons a Ring of Frost for 10 sec at the target location. Enemies entering the ring are incapacitated for 10 sec. Limit 10 targets. When the incapacitate expires, enemies are slowed by 75% for 4 sec.
    shifting_power            = {  62113, 382440, 1 }, -- Draw power from within, dealing 28,050 Arcane damage over 3.4 sec to enemies within 18 yds. While channeling, your Mage ability cooldowns are reduced by 12 sec over 3.4 sec.
    shimmer                   = {  62105, 212653, 1 }, -- Teleports you 20 yds forward, unless something is in the way. Unaffected by the global cooldown and castable while casting.
    slow                      = {  62097,  31589, 1 }, -- Reduces the target's movement speed by 60% for 15 sec.
    spellsteal                = {  62084,  30449, 1 }, -- Steals a beneficial magic effect from the target. This effect lasts a maximum of 2 min.
    supernova                 = { 101883, 157980, 1 }, -- Pulses arcane energy around the target enemy or ally, dealing 3,967 Arcane damage to all enemies within 8 yds, and knocking them upward. A primary enemy target will take 100% increased damage.
    tempest_barrier           = {  62111, 382289, 2 }, -- Gain a shield that absorbs 3% of your maximum health for 15 sec after you Blink.
    temporal_velocity         = {  62099, 382826, 2 }, -- Increases your movement speed by 5% for 3 sec after casting Blink and 20% for 6 sec after returning from Alter Time.
    time_anomaly              = {  62094, 383243, 1 }, -- At any moment, you have a chance to gain Combustion for 5 sec, 1 Fire Blast charge, or Time Warp for 6 sec.
    time_manipulation         = {  62129, 387807, 1 }, -- Casting Fire Blast reduces the cooldown of your loss of control abilities by 2 sec.
    tome_of_antonidas         = {  62098, 382490, 1 }, -- Increases Haste by 2%.
    tome_of_rhonin            = {  62127, 382493, 1 }, -- Increases Critical Strike chance by 2%.
    volatile_detonation       = {  62089, 389627, 1 }, -- Greatly increases the effect of Blast Wave's knockback. Blast Wave's cooldown is reduced by 5 sec
    winters_protection        = {  62123, 382424, 2 }, -- The cooldown of Ice Block is reduced by 30 sec.

    -- Fire
    alexstraszas_fury         = { 101945, 235870, 1 }, -- Dragon's Breath always critically strikes, deals 50% increased critical strike damage, and contributes to Hot Streak.
    ashen_feather             = { 101945, 450813, 1 }, -- If Phoenix Flames only hits 1 target, it deals 25% increased damage and applies Ignite at 150% effectiveness.
    blast_zone                = { 101022, 451755, 1 }, -- Lit Fuse now turns up to 3 targets into Living Bombs. Living Bombs can now spread to 5 enemies.
    call_of_the_sun_king      = { 100991, 343222, 1 }, -- Phoenix Flames gains 1 additional charge and always critically strikes.
    combustion                = { 100995, 190319, 1 }, -- Engulfs you in flames for 12 sec, increasing your spells' critical strike chance by 100% and granting you Mastery equal to 75% of your Critical Strike stat. Castable while casting other spells. When you activate Combustion, you gain 2% Critical Strike damage, and up to 4 nearby allies gain 1% Critical Strike for 10 sec.
    controlled_destruction    = { 101002, 383669, 1 }, -- Damaging a target with Pyroblast increases the damage it receives from Ignite by 0.5%. Stacks up to 50 times.
    convection                = { 100992, 416715, 1 }, -- When a Living Bomb expires, if it did not spread to another target, it reapplies itself at 100% effectiveness. A Living Bomb can only benefit from this effect once.
    critical_mass             = { 101029, 117216, 1 }, -- Your spells have a 5% increased chance to deal a critical strike. You gain 10% more of the Critical Strike stat from all sources.
    deep_impact               = { 101000, 416719, 1 }, -- Meteor now turns 1 target hit into a Living Bomb. Additionally, its cooldown is reduced by 15 sec.
    explosive_ingenuity       = { 101013, 451760, 1 }, -- Your chance of gaining Lit Fuse when consuming Hot Streak is increased by 10%. Living Bomb damage increased by 25%.
    explosivo                 = { 100993, 451757, 1 }, -- Casting Combustion grants Lit Fuse and Living Bomb's damage is increased by 50% while under the effects of Combustion. Your chance of gaining Lit Fuse is increased by 30% while under the effects of Combustion.
    feel_the_burn             = { 101014, 383391, 1 }, -- Fire Blast and Phoenix Flames increase your mastery by 2% for 5 sec. This effect stacks up to 3 times.
    fervent_flickering        = { 101027, 387044, 1 }, -- Fire Blast's cooldown is reduced by 2 sec.
    fevered_incantation       = { 101019, 383810, 2 }, -- Each consecutive critical strike you deal increases critical strike damage you deal by 1%, up to 4% for 6 sec.
    fiery_rush                = { 101003, 383634, 1 }, -- While Combustion is active, your Fire Blast and Phoenix Flames recharge 50% faster.
    fire_blast                = { 100989, 108853, 1 }, -- Blasts the enemy for 15,127 Fire damage. Fire: Castable while casting other spells. Always deals a critical strike.
    firefall                  = { 100996, 384033, 1 }, -- Damaging an enemy with 15 Fireballs or Pyroblasts causes your next Fireball or Pyroblast to call down a Meteor on your target.
    fires_ire                 = { 101004, 450831, 2 }, -- When you're not under the effect of Combustion, your critical strike chance is increased by 2.5%. While you're under the effect of Combustion, your critical strike damage is increased by 2.5%.
    firestarter               = { 102014, 205026, 1 }, -- Your Fireball and Pyroblast spells always deal a critical strike when the target is above 90% health.
    flame_accelerant          = { 102012, 453282, 1 }, -- Every 12 seconds, your next non-instant Fireball, Flamestrike, or Pyroblast has a 40% reduced cast time.
    flame_on                  = { 101009, 205029, 1 }, -- Increases the maximum number of Fire Blast charges by 2.
    flame_patch               = { 101021, 205037, 1 }, -- Flamestrike leaves behind a patch of flames that burns enemies within it for 3,310 Fire damage over 8 sec. Deals reduced damage beyond 8 targets.
    from_the_ashes            = { 100999, 342344, 1 }, -- Phoenix Flames damage increased by 15% and your direct-damage spells reduce the cooldown of Phoenix Flames by 1 sec.
    heat_shimmer              = { 102010, 457735, 1 }, -- Damage from Ignite has a 5% chance to make your next Scorch have no cast time and deal damage as though your target was below 30% health.
    hyperthermia              = { 101942, 383860, 1 }, -- While Combustion is not active, consuming Hot Streak has a low chance to cause all Pyroblasts and Flamestrikes to have no cast time and be guaranteed critical strikes for 6 sec.
    improved_combustion       = { 101007, 383967, 1 }, -- Combustion grants mastery equal to 75% of your Critical Strike stat and lasts 2 sec longer.
    improved_scorch           = { 101011, 383604, 1 }, -- Casting Scorch on targets below 30% health increase the target's damage taken from you by 6% for 12 sec. This effect stacks up to 2 times.
    inflame                   = { 102013, 417467, 1 }, -- Hot Streak increases the amount of Ignite damage from Pyroblast or Flamestrike by an additional 10%.
    intensifying_flame        = { 101017, 416714, 1 }, -- While Ignite is on 3 or fewer enemies it flares up dealing an additional 20% of its damage to affected targets.
    kindling                  = { 101024, 155148, 1 }, -- Your Fireball, Pyroblast, Fire Blast, Scorch and Phoenix Flames critical strikes reduce the remaining cooldown on Combustion by 1.0 sec. Flamestrike critical strikes reduce the remaining cooldown of Combustion by 0.2 sec for each critical strike, up to 1 sec.
    lit_fuse                  = { 100994, 450716, 1 }, -- Consuming Hot Streak has a 15% chance to grant you Lit Fuse.  Lit Fuse: Your next Fire Blast turns up to 1 nearby target into a Living Bomb that explodes after 1.7 sec, dealing 5,750 Fire damage to the target and reduced damage to all other enemies within 10 yds. Up to 3 enemies hit by this explosion also become a Living Bomb, but this effect cannot spread further.
    majesty_of_the_phoenix    = { 101008, 451440, 1 }, -- When Phoenix Flames damages 3 or more targets, your next 2 Flamestrikes have their cast time reduced by 1.5 sec and their damage is increased by 20%.
    mark_of_the_fire_lord     = { 100988, 450325, 1 }, -- Flamestrike and Living Bomb apply Mastery: Ignite at 100% increased effectiveness.
    master_of_flame           = { 101006, 384174, 1 }, -- Ignite deals 15% more damage while Combustion is not active. Fire Blast spreads Ignite to 2 additional nearby targets during Combustion.
    meteor                    = { 101016, 153561, 1 }, -- Calls down a meteor which lands at the target location after 3 sec, dealing 34,041 Fire damage, split evenly between all targets within 8 yds, and burns the ground, dealing 7,855 Fire damage over 8.5 sec to all enemies in the area.
    molten_fury               = { 101015, 457803, 1 }, -- Damage dealt to targets below 35% health is increased by 7%.
    phoenix_flames            = { 101012, 257541, 1 }, -- Hurls a Phoenix that deals 8,050 Fire damage to the target and reduced damage to other nearby enemies. Always deals a critical strike.
    phoenix_reborn            = { 101943, 453123, 1 }, -- When your direct damage spells hit an enemy 25 times the damage of your next 2 Phoenix Flames is increased by 100% and they refund a charge on use.
    pyroblast                 = { 100998,  11366, 1 }, -- Hurls an immense fiery boulder that causes 21,807 Fire damage.
    pyromaniac                = { 101020, 451466, 1 }, -- Casting Pyroblast or Flamestrike while Hot Streak is active has an 6% chance to repeat the spell cast at 50% effectiveness. This effect counts as consuming Hot Streak.
    pyrotechnics              = { 100997, 157642, 1 }, -- Each time your Fireball fails to critically strike a target, it gains a stacking 10% increased critical strike chance. Effect ends when Fireball critically strikes.
    quickflame                = { 101021, 450807, 1 }, -- Flamestrike damage increased by 20%.
    scald                     = { 101011, 450746, 1 }, -- Scorch deals 300% damage to targets below 30% health.
    scorch                    = { 100987,   2948, 1 }, -- Scorches an enemy for 2,806 Fire damage. Scorch is a guaranteed critical strike, deals 300% increased damage, and increases your movement speed by 30% for 3 sec when cast on a target below 30% health. Castable while moving.
    sparking_cinders          = { 102011, 457728, 1 }, -- Living Bomb explosions have a small chance to increase the damage of your next Pyroblast by 10% or Flamestrike by 20% .
    spontaneous_combustion    = { 101007, 451875, 1 }, -- Casting Combustion refreshes up to 3 charges of Fire Blast and up to 3 charges of Phoenix Flames.
    sun_kings_blessing        = { 101025, 383886, 1 }, -- After consuming 10 Hot Streaks, your next non-instant Pyroblast or Flamestrike cast within 30 sec grants you Combustion for 6 sec and deals 260% additional damage.
    surging_blaze             = { 101023, 343230, 1 }, -- Pyroblast and Flamestrike's cast time is reduced by 0.5 sec and their damage dealt is increased by 5%.
    unleashed_inferno         = { 101025, 416506, 1 }, -- While Combustion is active your Fireball, Pyroblast, Fire Blast, Scorch, and Phoenix Flames deal 60% increased damage and reduce the cooldown of Combustion by 1.25 sec. While Combustion is active, Flamestrike deals 35% increased damage and reduces the cooldown of Combustion by 0.25 sec for each critical strike, up to 1.25 sec.
    wildfire                  = { 101001, 383489, 1 }, -- Your critical strike damage is increased by 3%. When you activate Combustion, you gain 2% additional critical strike damage, and up to 4 nearby allies gain 1% critical strike for 10 sec.

    -- Sunfury
    burden_of_power           = {  94644, 451035, 1 }, -- Conjuring a Spellfire Sphere increases the damage of your next Pyroblast by 15% or your next Flamestrike by 60%.
    codex_of_the_sunstriders  = {  94643, 449382, 1 }, -- Over its duration, your Arcane Phoenix will consume each of your Spellfire Spheres to cast an exceptional spell. Upon consuming a Spellfire Sphere, your Arcane Phoenix will grant you Lingering Embers.  Lingering Embers
    glorious_incandescence    = {  94645, 449394, 1 }, -- Consuming Burden of Power causes your next cast of Fire Blast to call down a storm of 4 Meteorites on its target. Each Meteorite's impact reduces the cooldown of Fire Blast by 1.0 sec.
    gravity_lapse             = {  94651, 458513, 1 }, -- Your Supernova becomes Gravity Lapse. Gravity Lapse
    ignite_the_future         = {  94648, 449558, 1 }, -- Generating a Spellfire Sphere while your Phoenix is active causes it to cast an exceptional spell.
    invocation_arcane_phoenix = {  94652, 448658, 1 }, -- When you cast Combustion, summon an Arcane Phoenix to aid you in battle.  Arcane Phoenix Your Arcane Phoenix aids you for the duration of your Combustion, casting random Arcane and Fire spells.
    lessons_in_debilitation   = {  94651, 449627, 1 }, -- Your Arcane Phoenix will Spellsteal when it is summoned and when it expires.
    mana_cascade              = {  94653, 449293, 1 }, -- Consuming Hot Streak grants you 0.5% Haste for 10 sec. Stacks up to 10 times. Multiple instances may overlap.
    memory_of_alar            = {  94646, 449619, 1 }, -- While under the effects of a casted Combustion, you gain twice as many stacks of Mana Addiction. When your Arcane Phoenix expires, it empowers you, granting Hyperthermia for 2 sec, plus an additional 0.5 sec for each exceptional spell it had cast.  Hyperthermia:
    merely_a_setback          = {  94649, 449330, 1 }, -- Your Blazing Barrier now grants 5% avoidance while active and 5% leech for 5 seconds when it breaks or expires.
    rondurmancy               = {  94648, 449596, 1 }, -- Spellfire Spheres can now stack up to 5 times.
    savor_the_moment          = {  94650, 449412, 1 }, -- When you cast Combustion, its duration is extended by 0.5 sec for each Spellfire Sphere you have, up to 2.5 sec.
    spellfire_spheres         = {  94647, 448601, 1, "sunfury" }, -- Every 6 times you consume Hot Streak, conjure a Spellfire Sphere. While you're out of combat, you will slowly conjure Spellfire Spheres over time.  Spellfire Sphere
    sunfury_execution         = {  94650, 449349, 1 }, -- Scorch's critical strike threshold is increased to 35%.  Scorch Scorches an enemy for 2,806 Fire damage. Scorch is a guaranteed critical strike, deals 300% increased damage, and increases your movement speed by 30% for 3 sec when cast on a target below 30% health. Castable while moving.

    -- Frostfire
    elemental_affinity        = {  94633, 431067, 1 }, -- The cooldown of Frost spells with a base cooldown shorter than 4 minutes is reduced by 30%.
    excess_fire               = {  94637, 438595, 1 }, -- Reaching maximum stacks of Fire Mastery causes your next Fire Blast to apply Living Bomb at 150% effectiveness. When this Living Bomb explodes, reduce the cooldown of Phoenix Flames by 10 sec.
    excess_frost              = {  94639, 438600, 1 }, -- Reaching maximum stacks of Frost Mastery causes your next Phoenix Flames to also cast Ice Nova at 200% effectiveness. When you consume Excess Frost, the cooldown of Meteor is reduced by 5 sec.
    flame_and_frost           = {  94633, 431112, 1 }, -- Cauterize resets the cooldown of your Frost spells with a base cooldown shorter than 4 minutes when it activates.
    flash_freezeburn          = {  94635, 431178, 1 }, -- Frostfire Empowerment grants you maximum benefit of Frostfire Mastery and refreshes its duration. Activating Combustion or Icy Veins grants you Frostfire Empowerment.
    frostfire_bolt            = {  94641, 431044, 1 }, -- Launches a bolt of frostfire at the enemy, causing 12,650 Frostfire damage, slowing movement speed by 60%, and causing an additional 4,600 Frostfire damage over 8 sec. Frostfire Bolt generates stacks for both Fire Mastery and Frost Mastery.
    frostfire_empowerment     = {  94632, 431176, 1 }, -- Your Frost and Fire spells have a chance to activate Frostfire Empowerment, causing your next Frostfire Bolt to be instant cast, deal 50% increased damage, explode for 80% of its damage to nearby enemies, and grant you maximum benefit of Frostfire Mastery and refresh its duration.
    frostfire_infusion        = {  94634, 431166, 1 }, -- Your Frost and Fire spells have a chance to trigger an additional bolt of Frostfire, dealing 3,450 damage. This effect generates Frostfire Mastery when activated.
    frostfire_mastery         = {  94636, 431038, 1, "frostfire" }, -- Your damaging Fire spells generate 1 stack of Fire Mastery and Frost spells generate 1 stack of Frost Mastery. Fire Mastery increases your haste by 1%, and Frost Mastery increases your Mastery by 1% for 14 sec, stacking up to 6 times each. Adding stacks does not refresh duration.
    imbued_warding            = {  94642, 431066, 1 }, -- Blazing Barrier also casts an Ice Barrier at 25% effectiveness.
    isothermic_core           = {  94638, 431095, 1 }, -- Comet Storm now also calls down a Meteor at 100% effectiveness onto your target's location. Meteor now also calls down a Comet Storm at 150% effectiveness onto your target location.
    meltdown                  = {  94642, 431131, 1 }, -- You melt slightly out of your Ice Block and Ice Cold, allowing you to move slowly during Ice Block and increasing your movement speed over time. Ice Block and Ice Cold trigger a Blazing Barrier when they end.
    severe_temperatures       = {  94640, 431189, 1 }, -- Casting damaging Frost or Fire spells has a high chance to increase the damage of your next Frostfire Bolt by 10%, stacking up to 5 times.
    thermal_conditioning      = {  94640, 431117, 1 }, -- Frostfire Bolt's cast time is reduced by 10%.
} )


-- PvP Talents
spec:RegisterPvpTalents( {
    ethereal_blink             = 5602, -- (410939)
    fireheart                  = 5656, -- (460942)
    glass_cannon               = 5495, -- (390428)
    greater_pyroblast          =  648, -- (203286) Hurls an immense fiery boulder that deals up to 35% of the target's total health in Fire damage.
    ice_wall                   = 5489, -- (352278) Conjures an Ice Wall 30 yards long that obstructs line of sight. The wall has 40% of your maximum health and lasts up to 15 sec.
    improved_mass_invisibility = 5621, -- (415945)
    master_shepherd            = 5588, -- (410248)
    ring_of_fire               = 5389, -- (353082) Summons a Ring of Fire for 8 sec at the target location. Enemies entering the ring burn for 18% of their total health over 6 sec.
    world_in_flames            =  644, -- (203280)
} )


-- Auras
spec:RegisterAuras( {
    -- Talent: Altering Time. Returning to past location and health when duration expires.
    -- https://wowhead.com/beta/spell=342246
    alter_time = {
        id = 110909,
        duration = 10,
        type = "Magic",
        max_stack = 1,
        copy = 342246
    },
    arcane_intellect = {
        id = 1459,
        duration = 3600,
        type = "Magic",
        max_stack = 1,
        shared = "player", -- use anyone's buff on the player, not just player's.
    },
    -- Talent: Movement speed reduced by $s2%.
    -- https://wowhead.com/beta/spell=157981
    blast_wave = {
        id = 157981,
        duration = 6,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Absorbs $w1 damage.  Melee attackers take $235314s1 Fire damage.
    -- https://wowhead.com/beta/spell=235313
    blazing_barrier = {
        id = 235313,
        duration = 60,
        type = "Magic",
        max_stack = 1
    },
    -- $s1% increased movement speed and unaffected by movement speed slowing effects.
    -- https://wowhead.com/beta/spell=108843
    blazing_speed = {
        id = 108843,
        duration = 6,
        max_stack = 1
    },
    -- Blinking.
    -- https://wowhead.com/beta/spell=1953
    blink = {
        id = 1953,
        duration = 0.3,
        type = "Magic",
        max_stack = 1
    },
    -- Movement speed reduced by $w1%.
    -- https://wowhead.com/beta/spell=12486
    blizzard = {
        id = 12486,
        duration = 3,
        mechanic = "snare",
        type = "Magic",
        max_stack = 1
    },
    calefaction = {
        id = 408673,
        duration = 60,
        max_stack = 25
    },
    -- Talent: Burning away $s1% of maximum health every $t1 sec.
    -- https://wowhead.com/beta/spell=87023
    cauterize = {
        id = 87023,
        duration = 6,
        max_stack = 1
    },
    -- You have recently benefited from Cauterize and cannot benefit from it again.
    -- https://wowhead.com/beta/spell=87024
    cauterized = {
        id = 87024,
        duration = 300,
        max_stack = 1
    },
    -- Movement speed reduced by $w1%.
    -- https://wowhead.com/beta/spell=205708
    chilled = {
        id = 205708,
        duration = 8,
        max_stack = 1
    },
    -- Talent: Critical Strike chance of your spells increased by $w1%.$?a383967[  Mastery increased by $w2.][]
    -- https://wowhead.com/beta/spell=190319
    combustion = {
        id = 190319,
        duration = function()
            return talent.improved_combustion.enabled and 12 or 10
        end,
        type = "Magic",
        max_stack = 1
    },
    -- Movement speed reduced by $s1%.
    -- https://wowhead.com/beta/spell=212792
    cone_of_cold = {
        id = 212792,
        duration = 5,
        max_stack = 1
    },
    controlled_destruction = {
        id = 453268,
        duration = 180,
        max_stack = 50
    },
    -- Able to teleport back to where last Blinked from.
    -- https://wowhead.com/beta/spell=389714
    displacement_beacon = {
        id = 389714,
        duration = 8,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Disoriented.
    -- https://wowhead.com/beta/spell=31661
    dragons_breath = {
        id = 31661,
        duration = 4,
        type = "Magic",
        max_stack = 1
    },
    -- Time Warp also increases the rate at which time passes by $s1%.
    -- https://wowhead.com/beta/spell=320919
    echoes_of_elisande = {
        id = 320919,
        duration = 3600,
        max_stack = 3
    },
    excess_fire = {
        id = 438624,
        duration = 30,
        max_stack = 1
    },
    excess_frost = {
        id = 438611,
        duration = 30,
        max_stack = 1
    },
    -- Talent: Mastery increased by ${$w1*$mas}%.
    -- https://wowhead.com/beta/spell=383395
    feel_the_burn = {
        id = 383395,
        duration = 5,
        max_stack = 3,
        copy = { "infernal_cascade", 336832 }
    },
    -- Talent: Your spells deal an additional $w1% critical hit damage.
    -- https://wowhead.com/beta/spell=383811
    fevered_incantation = {
        id = 383811,
        duration = 6,
        type = "Magic",
        max_stack = 4,
        copy = 333049
    },
    -- Talent: Your Fire Blast and Phoenix Flames recharge $s1% faster.
    -- https://wowhead.com/beta/spell=383637
    fiery_rush = {
        id = 383637,
        duration = 3600,
        type = "Magic",
        max_stack = 1
    },
    fire_mastery = {
        id = 431040,
        duration = 14,
        max_stack = 6
    },
    firefall = {
        id = 384035,
        duration = 30,
        max_stack = 15
    },
    firefall_ready = {
        id = 384038,
        duration = 30,
        max_stack = 1
    },
    fires_ire = {
        id = 453385,
        duration = 3600,
        max_stack = 1
    },
    -- Your next Fireball, Flamestrike, or Pyroblast has a 40% reduced cast time.
    flame_accelerant = {
        id = 203277,
        duration = 3600,
        max_stack = 1
    },
    -- Talent: Burning
    -- https://wowhead.com/beta/spell=205470
    flame_patch = {
        id = 205470,
        duration = 8,
        type = "Magic",
        max_stack = 1
    },
    flames_fury = {
        id = 409964,
        duration = 30,
        max_stack = 1
    },
    -- Talent: Movement speed slowed by $s2%.
    -- https://wowhead.com/beta/spell=2120
    flamestrike = {
        id = 2120,
        duration = 8,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Frozen in place.
    -- https://wowhead.com/beta/spell=386770
    freezing_cold = {
        id = 386770,
        duration = 5,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Movement speed reduced by $w1%
    -- https://wowhead.com/beta/spell=394255
    freezing_cold_snare = {
        id = 394255,
        duration = 3,
        mechanic = "snare",
        type = "Magic",
        max_stack = 1
    },
    -- Movement speed increased by $s1%.
    -- https://wowhead.com/beta/spell=236060
    frenetic_speed = {
        id = 236060,
        duration = 3,
        max_stack = 1
    },
    frost_mastery = {
        id = 431039,
        duration = 14,
        max_stack = 6
    },
    -- Frozen in place.
    -- https://wowhead.com/beta/spell=122
    frost_nova = {
        id = 122,
        duration = function() return talent.improved_frost_nova.enabled and 8 or 6 end,
        type = "Magic",
        max_stack = 1
    },
    frostfire_bolt = {
        id = 431044,
        duration = 8,
        max_stack = 1
    },
    frostfire_empowerment = {
        id = 431177,
        duration = 20,
        max_stack = 1
    },
    -- Movement speed reduced by $w1%.
    -- https://wowhead.com/beta/spell=289308
    frozen_orb = {
        id = 289308,
        duration = 3,
        mechanic = "snare",
        max_stack = 1
    },
    -- Frozen in place.
    -- https://wowhead.com/beta/spell=228600
    glacial_spike = {
        id = 228600,
        duration = 4,
        type = "Magic",
        max_stack = 1
    },
    heat_shimmer = {
        id = 458964,
        duration = 10,
        max_stack = 1
    },
    heating_up = {
        id = 48107,
        duration = 10,
        max_stack = 1,
    },
    hot_streak = {
        id = 48108,
        duration = 15,
        type = "Magic",
        max_stack = 1,
    },
    -- Talent: Pyroblast and Flamestrike have no cast time and are guaranteed to critically strike.
    -- https://wowhead.com/beta/spell=383874
    hyperthermia = {
        id = 383874,
        duration = 6,
        max_stack = 1
    },
    -- Cannot be made invulnerable by Ice Block.
    -- https://wowhead.com/beta/spell=41425
    hypothermia = {
        id = 41425,
        duration = 30,
        max_stack = 1
    },
    -- Talent: Frozen.
    -- https://wowhead.com/beta/spell=157997
    ice_nova = {
        id = 157997,
        duration = 2,
        type = "Magic",
        max_stack = 1
    },
    -- Deals $w1 Fire damage every $t1 sec.$?$w3>0[  Movement speed reduced by $w3%.][]
    -- https://wowhead.com/beta/spell=12654
    ignite = {
        id = 12654,
        duration = 9,
        tick_time = 1,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Taking $383604s3% increased damage from $@auracaster's spells and abilities.
    -- https://wowhead.com/beta/spell=383608
    improved_scorch = {
        id = 383608,
        duration = 12,
        type = "Magic",
        max_stack = 2
    },
    incantation_of_swiftness = {
        id = 382294,
        duration = 6,
        max_stack = 1,
        copy = 337278,
    },
    -- Talent: Increases spell damage by $w1%.
    -- https://wowhead.com/beta/spell=116267
    incanters_flow = {
        id = 116267,
        duration = 25,
        max_stack = 5,
        meta = {
            stack = function() return state.incanters_flow_stacks end,
            stacks = function() return state.incanters_flow_stacks end,
        }
    },
    -- Spell damage increased by $w1%.
    -- https://wowhead.com/beta/spell=384280
    invigorating_powder = {
        id = 384280,
        duration = 12,
        type = "Magic",
        max_stack = 1
    },
    lit_fuse = {
        id = 453207,
        duration = 10,
        max_stack = 1
    },
    -- Talent: Causes $w1 Fire damage every $t1 sec. After $d, the target explodes, causing $w2 Fire damage to the target and all other enemies within $44461A2 yards, and spreading Living Bomb.
    -- https://wowhead.com/beta/spell=217694
    living_bomb = {
        id = 217694,
        duration = 4,
        tick_time = 1,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Causes $w1 Fire damage every $t1 sec. After $d, the target explodes, causing $w2 Fire damage to the target and all other enemies within $44461A2 yards.
    -- https://wowhead.com/beta/spell=244813
    living_bomb_spread = { -- TODO: Check for differentiation in SimC.
        id = 244813,
        duration = 4,
        tick_time = 1,
        type = "Magic",
        max_stack = 1
    },
    majesty_of_the_phoenix = {
        id = 453329,
        duration = 20,
        max_stack = 2
    },
    -- Talent: Incapacitated. Cannot attack or cast spells.  Increased health regeneration.
    -- https://wowhead.com/beta/spell=383121
    mass_polymorph = {
        id = 383121,
        duration = 60,
        mechanic = "polymorph",
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Movement speed reduced by $w1%.
    -- https://wowhead.com/beta/spell=391104
    mass_slow = {
        id = 391104,
        duration = 15,
        mechanic = "snare",
        type = "Magic",
        max_stack = 1
    },
    -- Burning for $w1 Fire damage every $t1 sec.
    -- https://wowhead.com/beta/spell=155158
    meteor_burn = {
        id = 155158,
        duration = 10,
        tick_time = 1,
        type = "Magic",
        max_stack = 3
    },
    --[[ Burning for $w1 Fire damage every $t1 sec.
    -- https://wowhead.com/beta/spell=175396
    meteor_burn = { -- AOE ground effect?
        id = 175396,
        duration = 8.5,
        type = "Magic",
        max_stack = 1
    }, ]]
    -- Talent: Damage taken is reduced by $s3% while your images are active.
    -- https://wowhead.com/beta/spell=55342
    mirror_image = {
        id = 55342,
        duration = 40,
        max_stack = 3,
        generate = function( mi )
            if action.mirror_image.lastCast > 0 and query_time < action.mirror_image.lastCast + 40 then
                mi.count = 1
                mi.applied = action.mirror_image.lastCast
                mi.expires = mi.applied + 40
                mi.caster = "player"
                return
            end

            mi.count = 0
            mi.applied = 0
            mi.expires = 0
            mi.caster = "nobody"
        end,
    },
    -- Covenant: Attacking, casting a spell or ability, consumes a mirror to inflict Shadow damage and reduce cast and movement speed by $320035s3%.     Your final mirror will instead Root and Silence you for $317589d.
    -- https://wowhead.com/beta/spell=314793
    mirrors_of_torment = {
        id = 314793,
        duration = 25,
        type = "Magic",
        max_stack = 3
    },
    -- Absorbs $w1 damage.  Magic damage taken reduced by $s3%.  Duration of all harmful Magic effects reduced by $w4%.
    -- https://wowhead.com/beta/spell=235450
    prismatic_barrier = {
        id = 235450,
        duration = 60,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Suffering $w1 Fire damage every $t2 sec.
    -- https://wowhead.com/beta/spell=321712
    pyroblast = {
        id = 321712,
        duration = 6,
        tick_time = 2,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Increases critical strike chance of Fireball by $s1%$?a337224[ and your Mastery by ${$s2}.1%][].
    -- https://wowhead.com/beta/spell=157644
    pyrotechnics = {
        id = 157644,
        duration = 15,
        max_stack = 10,
        copy = "fireball"
    },
    -- Talent: Incapacitated.
    -- https://wowhead.com/beta/spell=82691
    ring_of_frost = {
        id = 82691,
        duration = 10,
        mechanic = "freeze",
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Movement speed slowed by $s1%.
    -- https://wowhead.com/beta/spell=321329
    ring_of_frost_snare = {
        id = 321329,
        duration = 4,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Every $t1 sec, deal $382445s1 Nature damage to enemies within $382445A1 yds and reduce the remaining cooldown of your abilities by ${-$s2/1000} sec.
    -- https://wowhead.com/beta/spell=382440
    shifting_power = {
        id = 382440,
        duration = 4,
        tick_time = 1,
        type = "Magic",
        max_stack = 1,
        copy = 314791
    },
    -- Talent: Shimmering.
    -- https://wowhead.com/beta/spell=212653
    shimmer = {
        id = 212653,
        duration = 0.65,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Movement speed reduced by $w1%.
    -- https://wowhead.com/beta/spell=31589
    slow = {
        id = 31589,
        duration = 15,
        mechanic = "snare",
        type = "Magic",
        max_stack = 1
    },
    sparking_cinders = {
        id = 457729,
        duration = 20,
        max_stack = 1
    },
    sun_kings_blessing = {
        id = 383882,
        duration = 30,
        max_stack = 10,
        copy = 333314
    },
    -- Talent: Your next non-instant Pyroblast will grant you Combustion.
    -- https://wowhead.com/beta/spell=383883
    sun_kings_blessing_ready = {
        id = 383883,
        duration = 15,
        max_stack = 1,
        copy = { 333315, "fury_of_the_sun_king" },
        meta = {
            expiration_delay_remains = function()
                return buff.sun_kings_blessing_ready_expiration_delay.remains
            end,
        },
    },
    sun_kings_blessing_ready_expiration_delay = {
        duration = 0.03,
    },
    -- Talent: Absorbs $w1 damage.
    -- https://wowhead.com/beta/spell=382290
    tempest_barrier = {
        id = 382290,
        duration = 15,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Movement speed increased by $w1%.
    -- https://wowhead.com/beta/spell=382824
    temporal_velocity_alter_time = {
        id = 382824,
        duration = 5,
        max_stack = 1
    },
    -- Talent: Movement speed increased by $w1%.
    -- https://wowhead.com/beta/spell=384360
    temporal_velocity_blink = {
        id = 384360,
        duration = 2,
        max_stack = 1
    },
    -- Talent: Haste increased by $w1%.
    -- https://wowhead.com/beta/spell=386540
    temporal_warp = {
        id = 386540,
        duration = 40,
        max_stack = 1
    },
    -- Frozen in time for $d.
    -- https://wowhead.com/beta/spell=356346
    timebreakers_paradox = {
        id = 356346,
        duration = 8,
        mechanic = "stun",
        max_stack = 1
    },
    -- Rooted and Silenced.
    -- https://wowhead.com/beta/spell=317589
    tormenting_backlash = {
        id = 317589,
        duration = 4,
        type = "Magic",
        max_stack = 1
    },
    -- Suffering $w1 Fire damage every $t1 sec.
    -- https://wowhead.com/beta/spell=277703
    trailing_embers = {
        id = 277703,
        duration = 6,
        tick_time = 2,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Critical Strike increased by $w1%.
    -- https://wowhead.com/beta/spell=383493
    wildfire = {
        id = 383493,
        duration = 10,
        max_stack = 1
    },


    -- Legendaries
    expanded_potential = {
        id = 327495,
        duration = 300,
        max_stack = 1
    },
    firestorm = {
        id = 333100,
        duration = 4,
        max_stack = 1
    },
    molten_skyfall = {
        id = 333170,
        duration = 30,
        max_stack = 18
    },
    molten_skyfall_ready = {
        id = 333182,
        duration = 30,
        max_stack = 1
    },
} )


spec:RegisterCombatLogEvent( function( _, subtype, _,  sourceGUID, sourceName, _, _, destGUID, destName, destFlags, _, spellID, spellName )
    if sourceGUID == state.GUID and subtype == "SPELL_AURA_APPLIED" and ( spellID == spec.auras.heating_up.id or spellID == spec.auras.hot_streak.id ) then
        Hekili:ForceUpdate( spellName, true )
    end
end )


spec:RegisterStateTable( "firestarter", setmetatable( {}, {
    __index = setfenv( function( t, k )
        if k == "active" then return talent.firestarter.enabled and target.health.pct > 90
        elseif k == "remains" then
            if not talent.firestarter.enabled or target.health.pct <= 90 then return 0 end
            return target.time_to_pct_90
        end
    end, state )
} ) )

spec:RegisterStateTable( "scorch_execute", setmetatable( {}, {
    __index = setfenv( function( t, k )
        if k == "active" then
            return buff.heat_shimmer.up or target.health.pct < 30
        elseif k == "remains" then
            if target.health.pct < 30 then return target.time_to_die end
            if buff.heat_shimmer.up then return buff.heat_shimmer.remains end
            return 0
        end
    end, state )
} ) )

spec:RegisterStateTable( "improved_scorch", setmetatable( {}, {
    __index = setfenv( function( t, k )
        if k == "active" then return debuff.improved_scorch.up
        elseif k == "remains" then
            return debuff.improved_scorch.remains
        end
    end, state )
} ) )


spec:RegisterGear( "tier31", 207288, 207289, 207290, 207291, 207293 )
spec:RegisterAura( "searing_rage", {
    id = 424285,
    duration = 12,
    max_stack = 5
} )

spec:RegisterGear( "tier30", 202554, 202552, 202551, 202550, 202549, 217232, 217234, 217235, 217231, 217233 )
spec:RegisterAuras( {
    charring_embers = {
        id = 408665,
        duration = 14,
        max_stack = 1,
        copy = 453122
    },
    calefaction = {
        id = 408673,
        duration = 60,
        max_stack = 20
    },
    flames_fury = {
        id = 409964,
        duration = 30,
        max_stack = 2
    }
} )


spec:RegisterGear( "tier29", 200318, 200320, 200315, 200317, 200319 )


spec:RegisterHook( "reset_precast", function ()
    if pet.rune_of_power.up then applyBuff( "rune_of_power", pet.rune_of_power.remains )
    else removeBuff( "rune_of_power" ) end

    incanters_flow.reset()
end )

spec:RegisterHook( "runHandler", function( action )
    local ability = class.abilities[ action ]

    if buff.ice_floes.up then
        if ability and ability.cast > 0 and ability.cast < 10 then removeStack( "ice_floes" ) end
    end

    if talent.frostfire_mastery.enabled and ability then
        if ability.school == "fire" or ability.school == "frostfire" then
            if buff.fire_mastery.up then buff.fire_mastery.stack = buff.fire_mastery.stack + 1
            else applyBuff( "fire_mastery" ) end
            if talent.excess_fire.enabled and buff.fire_mastery.stack_pct == 100 then applyBufF( "excess_fire" ) end
        end
        if ability.school == "frost" or ability.school == "frostfire" then
            if buff.frost_mastery.up then buff.frost_mastery.stack = buff.frost_mastery.stack + 1
            else applyBuff( "frost_mastery" ) end
            if talent.excess_frost.enabled and buff.frost_mastery.stack_pct == 100 then applyBufF( "excess_frost" ) end
        end

    end
end )

spec:RegisterHook( "advance", function ( time )
    if Hekili.ActiveDebug then Hekili:Debug( "\n*** Hot Streak (Advance) ***\n    Heating Up:  %.2f\n    Hot Streak:  %.2f\n", state.buff.heating_up.remains, state.buff.hot_streak.remains ) end
end )

spec:RegisterStateFunction( "hot_streak", function( willCrit )
    willCrit = willCrit or buff.combustion.up or stat.crit >= 100

    if Hekili.ActiveDebug then Hekili:Debug( "*** HOT STREAK (Cast/Impact) ***\n    Heating Up: %s, %.2f\n    Hot Streak: %s, %.2f\n    Crit: %s, %.2f", buff.heating_up.up and "Yes" or "No", buff.heating_up.remains, buff.hot_streak.up and "Yes" or "No", buff.hot_streak.remains, willCrit and "Yes" or "No", stat.crit ) end

    if willCrit then
        if buff.heating_up.up then removeBuff( "heating_up" ); applyBuff( "hot_streak" )
        elseif buff.hot_streak.down then applyBuff( "heating_up" ) end

        if talent.fevered_incantation.enabled then addStack( "fevered_incantation" ) end

        if Hekili.ActiveDebug then Hekili:Debug( "*** HOT STREAK END ***\nHeating Up: %s, %.2f\nHot Streak: %s, %.2f", buff.heating_up.up and "Yes" or "No", buff.heating_up.remains, buff.hot_streak.up and "Yes" or "No", buff.hot_streak.remains ) end
        return true
    end

    -- Apparently it's safe to not crit within 0.2 seconds.
    if buff.heating_up.up then
        if query_time - buff.heating_up.applied > 0.2 then
            if Hekili.ActiveDebug then Hekili:Debug( "May not crit; Heating Up was applied %.2f ago, so removing Heating Up..", query_time - buff.heating_up.applied ) end
            removeBuff( "heating_up" )
        else
            if Hekili.ActiveDebug then Hekili:Debug( "May not crit; Heating Up was applied %.2f ago, so ignoring the non-crit impact.", query_time - buff.heating_up.applied ) end
        end
    end

    if Hekili.ActiveDebug then Hekili:Debug( "*** HOT STREAK END ***\nHeating Up: %s, %.2f\nHot Streak: %s, %.2f\n***", buff.heating_up.up and "Yes" or "No", buff.heating_up.remains, buff.hot_streak.up and "Yes" or "No", buff.hot_streak.remains ) end
end )


local hot_streak_spells = {
    -- "dragons_breath",
    "fireball",
    -- "fire_blast",
    "phoenix_flames",
    "pyroblast",
    "scorch",
}
spec:RegisterStateExpr( "hot_streak_spells_in_flight", function ()
    local count = 0

    for i, spell in ipairs( hot_streak_spells ) do
        if state:IsInFlight( spell ) then count = count + 1 end
    end

    return count
end )

spec:RegisterStateExpr( "expected_kindling_reduction", function ()
    -- This only really works well in combat; we'll use the old APL value instead of dynamically updating for now.
    return 0.4
end )


Hekili:EmbedDisciplinaryCommand( spec )


local ExpireSKB = setfenv( function()
    removeBuff( "sun_kings_blessing_ready" )
end, state )


spec:RegisterStateTable( "incanters_flow", {
    changed = 0,
    count = 0,
    direction = 0,

    startCount = 0,
    startTime = 0,
    startIndex = 0,

    values = {
        [0] = { 0, 1 },
        { 1, 1 },
        { 2, 1 },
        { 3, 1 },
        { 4, 1 },
        { 5, 0 },
        { 5, -1 },
        { 4, -1 },
        { 3, -1 },
        { 2, -1 },
        { 1, 0 }
    },

    f = CreateFrame( "Frame" ),
    fRegistered = false,

    reset = setfenv( function ()
        if talent.incanters_flow.enabled then
            if not incanters_flow.fRegistered then
                Hekili:ProfileFrame( "Incanters_Flow_Arcane", incanters_flow.f )
                -- One-time setup.
                incanters_flow.f:RegisterUnitEvent( "UNIT_AURA", "player" )
                incanters_flow.f:SetScript( "OnEvent", function ()
                    -- Check to see if IF changed.
                    if state.talent.incanters_flow.enabled then
                        local flow = state.incanters_flow
                        local name, _, count = FindUnitBuffByID( "player", 116267, "PLAYER" )
                        local now = GetTime()

                        if name then
                            if count ~= flow.count then
                                if count == 1 then flow.direction = 0
                                elseif count == 5 then flow.direction = 0
                                else flow.direction = ( count > flow.count ) and 1 or -1 end

                                flow.changed = GetTime()
                                flow.count = count
                            end
                        else
                            flow.count = 0
                            flow.changed = GetTime()
                            flow.direction = 0
                        end
                    end
                end )

                incanters_flow.fRegistered = true
            end

            if now - incanters_flow.changed >= 1 then
                if incanters_flow.count == 1 and incanters_flow.direction == 0 then
                    incanters_flow.direction = 1
                    incanters_flow.changed = incanters_flow.changed + 1
                elseif incanters_flow.count == 5 and incanters_flow.direction == 0 then
                    incanters_flow.direction = -1
                    incanters_flow.changed = incanters_flow.changed + 1
                end
            end

            if incanters_flow.count == 0 then
                incanters_flow.startCount = 0
                incanters_flow.startTime = incanters_flow.changed + floor( now - incanters_flow.changed )
                incanters_flow.startIndex = 0
            else
                incanters_flow.startCount = incanters_flow.count
                incanters_flow.startTime = incanters_flow.changed + floor( now - incanters_flow.changed )
                incanters_flow.startIndex = 0

                for i, val in ipairs( incanters_flow.values ) do
                    if val[1] == incanters_flow.count and val[2] == incanters_flow.direction then incanters_flow.startIndex = i; break end
                end
            end
        else
            incanters_flow.count = 0
            incanters_flow.changed = 0
            incanters_flow.direction = 0
        end
    end, state ),
} )

spec:RegisterStateExpr( "incanters_flow_stacks", function ()
    if not talent.incanters_flow.enabled then return 0 end

    local index = incanters_flow.startIndex + floor( query_time - incanters_flow.startTime )
    if index > 10 then index = index % 10 end

    return incanters_flow.values[ index ][ 1 ]
end )

spec:RegisterStateExpr( "incanters_flow_dir", function()
    if not talent.incanters_flow.enabled then return 0 end

    local index = incanters_flow.startIndex + floor( query_time - incanters_flow.startTime )
    if index > 10 then index = index % 10 end

    return incanters_flow.values[ index ][ 2 ]
end )

-- Seemingly, a very silly way to track Incanter's Flow...
local incanters_flow_time_obj = setmetatable( { __stack = 0 }, {
    __index = function( t, k )
        if not state.talent.incanters_flow.enabled then return 0 end

        local stack = t.__stack
        local ticks = #state.incanters_flow.values

        local start = state.incanters_flow.startIndex + floor( state.offset + state.delay )

        local low_pos, high_pos

        if k == "up" then low_pos = 5
        elseif k == "down" then high_pos = 6 end

        local time_since = ( state.query_time - state.incanters_flow.changed ) % 1

        for i = 0, 10 do
            local index = ( start + i )
            if index > 10 then index = index % 10 end

            local values = state.incanters_flow.values[ index ]

            if values[ 1 ] == stack and ( not low_pos or index <= low_pos ) and ( not high_pos or index >= high_pos ) then
                return max( 0, i - time_since )
            end
        end

        return 0
    end
} )

spec:RegisterStateTable( "incanters_flow_time_to", setmetatable( {}, {
    __index = function( t, k )
        incanters_flow_time_obj.__stack = tonumber( k ) or 0
        return incanters_flow_time_obj
    end
} ) )


-- Abilities
spec:RegisterAbilities( {
    -- Talent: Alters the fabric of time, returning you to your current location and health when cast a second time, or after 10 seconds. Effect negated by long distance or death.
    alter_time = {
        id = function () return buff.alter_time.down and 342247 or 342245 end,
        cast = 0,
        cooldown = function () return talent.master_of_time.enabled and 50 or 60 end,
        gcd = "off",
        school = "arcane",

        spend = 0.01,
        spendType = "mana",

        talent = "alter_time",
        startsCombat = false,

        handler = function ()
            if buff.alter_time.down then
                applyBuff( "alter_time" )
            else
                removeBuff( "alter_time" )
                if talent.master_of_time.enabled then setCooldown( "blink", 0 ) end
            end
        end,

        copy = { 342247, 342245 }
    },

    -- Causes an explosion of magic around the caster, dealing 513 Arcane damage to all enemies within 10 yards.
    arcane_explosion = {
        id = 1449,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "arcane",

        spend = 0.1,
        spendType = "mana",

        startsCombat = false,

        handler = function ()
        end,
    },

    -- Infuses the target with brilliance, increasing their Intellect by 5% for 1 |4hour:hrs;. If the target is in your party or raid, all party and raid members will be affected.
    arcane_intellect = {
        id = 1459,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "arcane",

        spend = 0.04,
        spendType = "mana",

        startsCombat = false,
        nobuff = "arcane_intellect",
        essential = true,

        handler = function ()
            applyBuff( "arcane_intellect" )
        end,
    },

    -- Talent: Causes an explosion around yourself, dealing 482 Fire damage to all enemies within 8 yards, knocking them back, and reducing movement speed by 70% for 6 sec.
    blast_wave = {
        id = 157981,
        cast = 0,
        cooldown = function() return talent.volatile_detonation.enabled and 25 or 30 end,
        gcd = "spell",
        school = "fire",

        talent = "blast_wave",
        startsCombat = true,

        usable = function () return target.maxR < 8, "target must be in range" end,
        handler = function ()
            applyDebuff( "target", "blast_wave" )
        end,
    },

    -- Talent: Shields you in flame, absorbing 4,240 damage for 1 min. Melee attacks against you cause the attacker to take 127 Fire damage.
    blazing_barrier = {
        id = 235313,
        cast = 0,
        cooldown = 25,
        gcd = "spell",
        school = "fire",

        spend = 0.03,
        spendType = "mana",

        talent = "blazing_barrier",
        startsCombat = false,

        handler = function ()
            applyBuff( "blazing_barrier" )
            if legendary.triune_ward.enabled then
                applyBuff( "ice_barrier" )
                applyBuff( "prismatic_barrier" )
            end
        end,
    },

    -- Talent: Engulfs you in flames for 10 sec, increasing your spells' critical strike chance by 100% . Castable while casting other spells.
    combustion = {
        id = 190319,
        cast = 0,
        cooldown = 120,
        gcd = "off",
        dual_cast = true,
        school = "fire",

        spend = 0.1,
        spendType = "mana",

        talent = "combustion",
        startsCombat = false,

        toggle = "cooldowns",

        usable = function () return time > 0 and not moving, "must already be in combat" end,
        handler = function ()
            applyBuff( "combustion" )
            stat.crit = stat.crit + 100

            removeBuff( "fires_ire" )

            if talent.explosivo.enabled then applyBuff( "lit_fuse" ) end
            if talent.rune_of_power.enabled then applyBuff( "rune_of_power" ) end
            if talent.spontaneous_combustion.enabled then gainCharges( "fire_blast", min( 3, action.fire_blast.charges ) ) end
            if talent.wildfire.enabled or azerite.wildfire.enabled then applyBuff( "wildfire" ) end
        end,
    },

    -- Talent: Enemies in a cone in front of you take 595 Fire damage and are disoriented for 4 sec. Damage will cancel the effect. Always deals a critical strike and contributes to Hot Streak.
    dragons_breath = {
        id = 31661,
        cast = 0,
        cooldown = 45,
        gcd = "spell",
        school = "fire",

        spend = 0.04,
        spendType = "mana",

        talent = "dragons_breath",
        startsCombat = true,

        usable = function () return target.maxR < 12, "target must be within 12 yds" end,
        handler = function ()
            applyDebuff( "target", "dragons_breath" )
            if talent.alexstraszas_fury.enabled then
                hot_streak( true )
                applyDebuff( "target", "ignite" )
            end
        end,
    },

    -- Talent: Blasts the enemy for 962 Fire damage. Fire: Castable while casting other spells. Always deals a critical strike.
    fire_blast = {
        id = 108853,
        cast = 0,
        charges = function () return 1 + 2 * talent.flame_on.rank end,
        cooldown = function ()
            return ( ( talent.flame_on.enabled and 10 or 12 ) - ( 2 * talent.fervent_flickering.rank ) )
            * ( talent.fiery_rush.enabled and buff.combustion.up and 0.5 or 1 )
            * ( buff.memory_of_lucid_dreams.up and 0.5 or 1 ) * haste
        end,
        recharge = function ()
            return ( ( talent.flame_on.enabled and 10 or 12 ) - ( 2 * talent.fervent_flickering.rank ) )
            * ( talent.fiery_rush.enabled and buff.combustion.up and 0.5 or 1 )
            * ( buff.memory_of_lucid_dreams.up and 0.5 or 1 ) * haste
        end,
        icd = 0.5,
        gcd = "off",
        dual_cast = function() return state.spec.fire end,
        school = "fire",

        spend = 0.01,
        spendType = "mana",

        talent = "fire_blast",
        startsCombat = true,

        usable = function ()
            if time == 0 then return false, "no fire_blast out of combat" end
            return true
        end,

        handler = function ()
            hot_streak( true )
            applyDebuff( "target", "ignite" )

            if buff.excess_fire.up then
                applyDebuff( "target", "living_bomb" )
                removeBuff( "excess_fire" )
            end

            if buff.lit_fuse.up then
                removeBuff( "lit_fuse" )
                active_dot.living_bomb = min( active_dot.living_bomb + ( talent.blast_zone.enabled and 3 or 1 ), true_active_enemies )
            end

            if talent.unleashed_inferno.enabled and buff.combustion.up then reduceCooldown( "combustion", 1.25 ) end

            if talent.feel_the_burn.enabled then addStack( "feel_the_burn" ) end
            if talent.kindling.enabled then setCooldown( "combustion", max( 0, cooldown.combustion.remains - 1 ) ) end
            if talent.master_of_flame.enabled and buff.combustion.up then active_dot.ignite = min( active_enemies, active_dot.ignite + 4 ) end

            if talent.phoenix_reborn.enabled or set_bonus.tier30_4pc > 0 and debuff.charring_embers.up then
                if buff.calefaction.stack == 24 then
                    removeBuff( "calefaction" )
                    applyBuff( "flames_fury", nil, 2 )
                else
                    addStack( "calefaction" )
                end
            end


            if talent.from_the_ashes.enabled then reduceCooldown( "phoenix_flames", 1 ) end
            if azerite.blaster_master.enabled then addStack( "blaster_master" ) end
            if conduit.infernal_cascade.enabled and buff.combustion.up then addStack( "infernal_cascade" ) end
            if legendary.sinful_delight.enabled then gainChargeTime( "mirrors_of_torment", 4 ) end
        end,
    },

    -- Throws a fiery ball that causes 749 Fire damage. Each time your Fireball fails to critically strike a target, it gains a stacking 10% increased critical strike chance. Effect ends when Fireball critically strikes.
    fireball = {
        id = function() return talent.frostfire_bolt.enabled and 431044 or 133 end,
        cast = function() 
            if buff.frostfire_empowerment.up then return 0 end
            return 2.25 * ( buff.flame_accelerant.up and 0.6 or 1 ) * haste
        end,
        cooldown = 0,
        gcd = "spell",
        school = "fire",

        spend = 0.02,
        spendType = "mana",

        startsCombat = false,
        notalent = "frostfire_bolt",
        velocity = 45,

        usable = function ()
            if moving and settings.prevent_hardcasts and action.fireball.cast_time > buff.ice_floes.remains then return false, "prevent_hardcasts during movement and ice_floes is down" end
            return true
        end,

        handler = function ()
            removeBuff( "molten_skyfall_ready" )

            if buff.frostfire_empowerment.up then
                applyBuff( "frost_mastery", nil, 6 )
                if talent.excess_frost.enabled then applyBuff( "excess_frost" ) end
                applyBuff( "fire_mastery", nil, 6 )
                if talent.excess_fire.enabled then applyBuff( "excess_fire" ) end
                removeBuff( "frostfire_empowerment" )
            end

            if buff.flame_accelerant.up and ( hardcast or cast_time > 0 ) then
                removeBuff( "flame_accelerant" )
            end
        end,

        impact = function ()
            if hot_streak( firestarter.active or stat.crit + buff.fireball.stack * 10 >= 100 ) then
                removeBuff( "fireball" )
                if talent.kindling.enabled then setCooldown( "combustion", max( 0, cooldown.combustion.remains - 1 ) ) end
            else
                addStack( "fireball" )
                if conduit.flame_accretion.enabled then addStack( "flame_accretion" ) end
            end

            if buff.firefall_ready.up then
                class.abilities.meteor.impact()
                removeBuff( "firefall_ready" )
            end

            if talent.unleashed_inferno.enabled and buff.combustion.up then reduceCooldown( "combustion", 1.25 ) end

            if talent.firefall.enabled then
                addStack( "firefall" )
                if buff.firefall.stack == buff.firefall.max_stack then
                    applyBuff( "firefall_ready" )
                    removeBuff( "firefall" )
                end
            end
            if talent.flame_accelerant.enabled then
                applyBuff( "flame_accelerant" )
                buff.flame_accelerant.applied = query_time + 8
                buff.flame_accelerant.expires = query_time + 8 + 3600
            end
            if talent.from_the_ashes.enabled then reduceCooldown( "phoenix_flames", 1 ) end

            if talent.frostfire_bolt.enabled then
                applyDebuff( "target", "frostfire_bolt" )
            end

            if set_bonus.tier30_4pc > 0 and debuff.charring_embers.up then
                if buff.calefaction.stack == 19 then
                    removeBuff( "calefaction" )
                    applyBuff( "flames_fury", nil, 2 )
                else
                    addStack( "calefaction" )
                end
            end

            if legendary.molten_skyfall.enabled and buff.molten_skyfall_ready.down then
                addStack( "molten_skyfall" )
                if buff.molten_skyfall.stack == 18 then
                    removeBuff( "molten_skyfall" )
                    applyBuff( "molten_skyfall_ready" )
                end
            end

            applyDebuff( "target", "ignite" )
        end,

        copy = { 133, "frostfire_bolt", 431044 }
    },

    -- Talent: Calls down a pillar of fire, burning all enemies within the area for 526 Fire damage and reducing their movement speed by 20% for 8 sec.
    flamestrike = {
        id = 2120,
        cast = function ()
            if ( buff.hot_streak.up or buff.firestorm.up or buff.hyperthermia.up ) then return 0 end
            return ( 4 - ( 0.5 * talent.surging_blaze.rank ) - ( buff.majesty_of_the_phoenix.up and 1.5 or 0 ) ) * ( buff.flame_accelerant.up and 0.6 or 1 ) * haste end,
        cooldown = 0,
        gcd = "spell",
        school = "fire",

        spend = 0.025,
        spendType = "mana",

        startsCombat = true,

        usable = function () return not moving or action.flamestrike.cast_time > buff.ice_floes.remains or buff.hot_streak.up or buff.firestorm.up or buff.hyperthermia.up end,
        handler = function ()
            removeStack( "sparking_cinders" )
            if buff.majesty_of_the_phoenix.up then removeBuff( "majesty_of_the_phoenix" ) end

            if hardcast or cast_time > 0 then
                removeBuff( "flame_accelerant" )
                if buff.sun_kings_blessing_ready.up then
                    applyBuff( "combustion", 6 )
                    if Hekili.ActiveDebug then Hekili:Debug( "Applied Combustion." ) end
                    buff.sun_kings_blessing_ready.expires = query_time + 0.03
                    applyBuff( "sun_kings_blessing_ready_expiration_delay" )
                    state:QueueAuraExpiration( "sun_kings_blessing_ready_expiration_delay", ExpireSKB, buff.sun_kings_blessing_ready_expiration_delay.expires )
                end

            else
                if buff.expanded_potential.up then removeBuff( "expanded_potential" )
                else
                    if buff.hot_streak.up then
                        removeBuff( "hot_streak" )
                    end
                    if buff.majesty_of_the_phoenix.up then removeStack( "majesty_of_the_phoenix" ) end -- Consumed on instant cast?
                    if talent.sun_kings_blessing.enabled then
                        addStack( "sun_kings_blessing" )
                        if buff.sun_kings_blessing.stack == 8 then
                            removeBuff( "sun_kings_blessing" )
                            applyBuff( "sun_kings_blessing_ready" )
                        end
                    end
                end
            end

            if buff.hyperthermia.up then applyBuff( "hot_streak" ) end
            applyDebuff( "target", "ignite" )
            applyDebuff( "target", "flamestrike" )
        end,
    },

    frostbolt = {
        id = 116,
        cast = 1.874,
        cooldown = 0,
        gcd = "spell",
        school = "frost",

        spend = 0.02,
        spendType = "mana",

        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "chilled" )
            if debuff.radiant_spark.up and buff.radiant_spark_consumed.down then handle_radiant_spark() end
            if talent.from_the_ashes.enabled then reduceCooldown( "phoenix_flames", 1 ) end

            if talent.phoenix_reborn.enabled or set_bonus.tier30_4pc > 0 and debuff.charring_embers.up then
                if buff.calefaction.stack == 24 then
                    removeBuff( "calefaction" )
                    applyBuff( "flames_fury", nil, 2 )
                else
                    addStack( "calefaction" )
                end
            end

        end,
    },


    invisibility = {
        id = 66,
        cast = 0,
        cooldown = 300,
        gcd = "spell",

        discipline = "arcane",

        spend = 0.03,
        spendType = "mana",

        notalent = "greater_invisibility",
        toggle = "defensives",
        startsCombat = false,

        handler = function ()
            applyBuff( "preinvisibility" )
            applyBuff( "invisibility", 23 )
            if talent.incantation_of_swiftness.enabled or conduit.incantation_of_swiftness.enabled then applyBuff( "incantation_of_swiftness" ) end
        end,
    },

    -- Talent: The target becomes a Living Bomb, taking 245 Fire damage over 3.6 sec, and then exploding to deal an additional 143 Fire damage to the target and reduced damage to all other enemies within 10 yards. Other enemies hit by this explosion also become a Living Bomb, but this effect cannot spread further.
    living_bomb = {
        id = 44457,
        cast = 0,
        cooldown = 30,
        gcd = "spell",
        school = "fire",

        spend = 0.015,
        spendType = "mana",

        talent = "living_bomb",
        startsCombat = true,

        -- TODO:  Living Bomb applications are slightly desynced to minimize overlapping.
        handler = function ()
            applyDebuff( "target", "living_bomb" )
            applyDebuff( "target", "ignite" )
        end,
    },

    -- Talent: Transforms all enemies within 10 yards into sheep, wandering around incapacitated for 1 min. While affected, the victims cannot take actions but will regenerate health very quickly. Damage will cancel the effect. Only works on Beasts, Humanoids and Critters.
    mass_polymorph = {
        id = 383121,
        cast = 1.7,
        cooldown = 60,
        gcd = "spell",
        school = "arcane",

        spend = 0.04,
        spendType = "mana",

        talent = "mass_polymorph",
        startsCombat = false,

        handler = function ()
            applyDebuff( "target", "mass_polymorph" )
        end,
    },

    -- Talent: Calls down a meteor which lands at the target location after 3 sec, dealing 2,657 Fire damage, split evenly between all targets within 8 yards, and burns the ground, dealing 675 Fire damage over 8.5 sec to all enemies in the area.
    meteor = {
        id = 153561,
        cast = 0,
        cooldown = function() return talent.deep_impact.enabled and 35 or 45 end,
        gcd = "spell",
        school = "fire",

        spend = 0.01,
        spendType = "mana",

        talent = "meteor",
        startsCombat = false,

        flightTime = 3,

        impact = function ()
            applyDebuff( "target", "meteor_burn" )
            if talent.deep_impact.enabled then active_dot.living_bomb = min( active_dot.living_bomb + 1, true_active_enemies ) end
        end,
    },

    -- Talent: Creates 3 copies of you nearby for 40 sec, which cast spells and attack your enemies. While your images are active damage taken is reduced by 20%. Taking direct damage will cause one of your images to dissipate.
    mirror_image = {
        id = 55342,
        cast = 0,
        cooldown = 120,
        gcd = "spell",
        school = "arcane",

        spend = 0.02,
        spendType = "mana",

        talent = "mirror_image",
        startsCombat = false,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "mirror_image" )
        end,
    },

    -- Talent: Hurls a Phoenix that deals 864 Fire damage to the target and reduced damage to other nearby enemies. Always deals a critical strike.
    phoenix_flames = {
        id = 257541,
        cast = 0,
        charges = function() return talent.call_of_the_sun_king.enabled and 3 or 2 end,
        cooldown = function() return 25 * ( talent.fiery_rush.enabled and buff.combustion.up and 0.5 or 1 ) end,
        recharge = function() return 25 * ( talent.fiery_rush.enabled and buff.combustion.up and 0.5 or 1 ) end,
        gcd = "spell",
        school = "fire",

        talent = "phoenix_flames",
        startsCombat = true,
        velocity = 50,

        handler = function()
            if buff.flames_fury.up then
                removeStack( "flames_fury" )
                gainCharges( "phoenix_flames", 1 )
            end

            if buff.excess_frost.up then
                removeBuff( "excess_frost" )
                class.abilities.ice_nova.handler()
            end
        end,

        impact = function ()
            if hot_streak( firestarter.active or talent.call_of_the_sun_king.enabled ) and talent.kindling.enabled then
                setCooldown( "combustion", max( 0, cooldown.combustion.remains - 1 ) )
            end

            applyDebuff( "target", "ignite" )
            if active_dot.ignite < active_enemies then active_dot.ignite = active_enemies end

            if talent.feel_the_burn.enabled then
                addStack( "feel_the_burn" )
            end

            if talent.majesty_of_the_phoenix.enabled and true_active_enemies > 2 then
                applyBuff( "majesty_of_the_phoenix", nil, 2 )
            end

            if talent.unleashed_inferno.enabled and buff.combustion.up then reduceCooldown( "combustion", 1.25 ) end

            if set_bonus.tier30_4pc > 0 and debuff.charring_embers.up then
                if buff.calefaction.stack == 19 then
                    removeBuff( "calefaction" )
                    applyBuff( "flames_fury", nil, 2 )
                else
                    addStack( "calefaction" )
                end
            end

            if set_bonus.tier30_2pc > 0 then
                applyDebuff( "target", "charring_embers" )
            end
        end,
    },


    polymorph = {
        id = 118,
        cast = 1.7,
        cooldown = 0,
        gcd = "spell",

        discipline = "arcane",

        spend = 0.04,
        spendType = "mana",

        startsCombat = false,
        texture = 136071,

        handler = function ()
            applyDebuff( "target", "polymorph" )
        end,
    },

    -- Talent: Hurls an immense fiery boulder that causes 1,311 Fire damage. Pyroblast's initial damage is increased by 5% when the target is above 70% health or below 30% health.
    pyroblast = {
        id = 11366,
        cast = function ()
            if ( buff.hot_streak.up or buff.firestorm.up or buff.hyperthermia.up ) then return 0 end
            return ( 4.5 - ( talent.surging_blaze.enabled and 0.5 or 0 ) ) * ( buff.flame_accelerant.up and 0.6 or 1 ) * haste end,
        cooldown = 0,
        gcd = "spell",
        school = "fire",

        spend = 0.02,
        spendType = "mana",

        talent = "pyroblast",
        startsCombat = true,

        usable = function ()
            if action.pyroblast.cast > 0 then
                if moving and settings.prevent_hardcasts and action.fireball.cast_time > buff.ice_floes.remains then return false, "prevent_hardcasts during movement and ice_floes is down" end
                if combat == 0 and not boss and not settings.pyroblast_pull then return false, "opener pyroblast disabled and/or target is not a boss" end
            end
            return true
        end,

        handler = function ()
            removeStack( "sparking_cinders" )

            if hardcast or cast_time > 0 then
                removeBuff( "flame_accelerant" )
                if buff.sun_kings_blessing_ready.up then
                    applyBuff( "combustion", 6 )
                    buff.sun_kings_blessing_ready.expires = query_time + 0.03
                    applyBuff( "sun_kings_blessing_ready_expiration_delay" )
                    state:QueueAuraExpiration( "sun_kings_blessing_ready_expiration_delay", ExpireSKB, buff.sun_kings_blessing_ready_expiration_delay.expires )
                end
            else
                if buff.hot_streak.up then
                    if buff.expanded_potential.up then removeBuff( "expanded_potential" )
                    else
                        removeBuff( "hot_streak" )
                        if talent.sun_kings_blessing.enabled then
                            if buff.sun_kings_blessing.stack == 9 then
                                removeBuff( "sun_kings_blessing" )
                                applyBuff( "sun_kings_blessing_ready" )
                            else
                                addStack( "sun_kings_blessing" )
                            end
                        end
                    end
                end
            end

            removeBuff( "molten_skyfall_ready" )

            if talent.firefall.enabled then
                addStack( "firefall" )
                if buff.firefall.stack == buff.firefall.max_stack then
                    applyBuff( "firefall_ready" )
                    removeBuff( "firefall" )
                end
            end

            if talent.unleashed_inferno.enabled and buff.combustion.up then reduceCooldown( "combustion", 1.25 ) end

            if set_bonus.tier30_4pc > 0 and debuff.charring_embers.up then
                if buff.calefaction.stack == 19 then
                    removeBuff( "calefaction" )
                    applyBuff( "flames_fury", nil, 2 )
                else
                    addStack( "calefaction" )
                end
            end
        end,

        velocity = 35,

        impact = function ()
            if hot_streak( firestarter.active or buff.firestorm.up or buff.hyperthermia.up ) then
                if talent.kindling.enabled then
                    reduceCooldown( "combustion", 1 )
                end
            end

            if legendary.molten_skyfall.enabled and buff.molten_skyfall_ready.down then
                addStack( "molten_skyfall" )
                if buff.molten_skyfall.stack == 18 then
                    removeBuff( "molten_skyfall" )
                    applyBuff( "molten_skyfall_ready" )
                end
            end

            applyDebuff( "target", "ignite" )

            if talent.controlled_destruction.enabled then
                applyDebuff( "target", "controlled_destruction", nil, debuff.controlled_destruction.stack + 1 )
            end

            if talent.from_the_ashes.enabled then reduceCooldown( "phoenix_flames", 1 ) end
        end,
    },

    -- Talent: Removes all Curses from a friendly target.
    remove_curse = {
        id = 475,
        cast = 0,
        cooldown = 8,
        gcd = "spell",
        school = "arcane",

        spend = 0.013,
        spendType = "mana",

        talent = "remove_curse",
        startsCombat = false,
        debuff = "dispellable_curse",
        handler = function ()
            removeDebuff( "player", "dispellable_curse" )
        end,
    },

    -- Talent: Scorches an enemy for 170 Fire damage. Castable while moving.
    scorch = {
        id = 2948,
        cast = function() return buff.heat_shimmer.up and 0 or 1.5 end,
        cooldown = 0,
        gcd = "spell",
        school = "fire",

        spend = 0.01,
        spendType = "mana",

        talent = "scorch",
        startsCombat = true,

        handler = function ()
            hot_streak( buff.heat_shimmer.up or target.health_pct < 30 )
            applyDebuff( "target", "ignite" )

            if talent.frenetic_speed.enabled then applyBuff( "frenetic_speed" ) end
            if talent.from_the_ashes.enabled then reduceCooldown( "phoenix_flames", 1 ) end
            if talent.improved_scorch.enabled and ( target.health.pct < 30 or buff.heat_shimmer.up ) then applyDebuff( "target", "improved_scorch", nil, debuff.improved_scorch.stack + 1 ) end
            removeBuff( "heat_shimmer" )
            if talent.unleashed_inferno.enabled and buff.combustion.up then reduceCooldown( "combustion", 1.25 ) end
        end,
    },

    -- Talent: Draw power from the Night Fae, dealing 2,168 Nature damage over 3.6 sec to enemies within 18 yds. While channeling, your Mage ability cooldowns are reduced by 12 sec over 3.6 sec.
    shifting_power = {
        id = function() return talent.shifting_power.enabled and 382440 or 314791 end,
        cast = function() return 4 * haste end,
        channeled = true,
        cooldown = 60,
        gcd = "spell",
        school = "nature",

        spend = 0.05,
        spendType = "mana",

        startsCombat = true,

        usable = function () return not moving end,

        cdr = function ()
            return - action.shifting_power.execute_time / action.shifting_power.tick_time * ( -3 + conduit.discipline_of_the_grove.time_value )
        end,

        full_reduction = function ()
            return - action.shifting_power.execute_time / action.shifting_power.tick_time * ( -3 + conduit.discipline_of_the_grove.time_value )
        end,

        tick_reduction = 3,

        start = function ()
            applyBuff( "shifting_power" )
        end,

        tick  = function ()
            local seen = {}
            for _, a in pairs( spec.abilities ) do
                if not seen[ a.key ] then
                    reduceCooldown( a.key, 3 )
                    seen[ a.key ] = true
                end
            end
        end,

        finish = function ()
            removeBuff( "shifting_power" )
        end,

        copy = { 382440, 314791 }
    },

    -- Talent: Reduces the target's movement speed by 50% for 15 sec.
    slow = {
        id = 31589,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "arcane",

        spend = 0.01,
        spendType = "mana",

        talent = "slow",
        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "slow" )
        end,
    },
} )

spec:RegisterRanges( "fireball", "polymorph", "phoenix_flames" )

spec:RegisterOptions( {
    enabled = true,

    aoe = 3,
    cycle = false,

    nameplates = false,
    nameplateRange = 40,
    rangeFilter = false,

    damage = true,
    damageExpiration = 6,

    potion = "spectral_intellect",

    package = "Fire",
} )


spec:RegisterSetting( "pyroblast_pull", false, {
    name = strformat( "%s: Non-Instant Opener", Hekili:GetSpellLinkWithTexture( spec.abilities.pyroblast.id ) ),
    desc = strformat( "If checked, a non-instant %s may be recommended as an opener against bosses.", Hekili:GetSpellLinkWithTexture( spec.abilities.pyroblast.id ) ),
    type = "toggle",
    width = "full"
} )


spec:RegisterSetting( "prevent_hardcasts", false, {
    name = strformat( "%s and %s: Instant-Only When Moving", Hekili:GetSpellLinkWithTexture( spec.abilities.pyroblast.id ),
        Hekili:GetSpellLinkWithTexture( spec.abilities.fireball.id ) ),
    desc = function()
        return strformat( "If checked, non-instant %s and %s casts will not be recommended while you are moving.\n\nAn exception is made if %s is talented and active and your cast "
        .. "would be complete before |W%s|w expires.", Hekili:GetSpellLinkWithTexture( spec.abilities.pyroblast.id ), Hekili:GetSpellLinkWithTexture( spec.abilities.fireball.id ),
        Hekili:GetSpellLinkWithTexture( class.auras.ice_floes.id ), class.auras.ice_floes.name )
    end,
    type = "toggle",
    width = "full"
} )

spec:RegisterStateExpr( "fireball_hardcast_prevented", function()
    return settings.prevent_hardcasts and moving and action.fireball.cast_time > 0 and buff.ice_floes.down
end )

spec:RegisterSetting( "check_explosion_range", true, {
    name = strformat( "%s: Range Check", Hekili:GetSpellLinkWithTexture( 1449 ) ),
    desc = strformat( "If checked, %s will not be recommended when you are more than 10 yards from your target.", Hekili:GetSpellLinkWithTexture( 1449 ) ),
    type = "toggle",
    width = "full"
} )


spec:RegisterPack( "Fire", 20241006, [[Hekili:T336YnUXXc)SOYL5sUsIMKsYzxxu6u(UJZ5446i7J)NOGibfreibdaO2vPuXN9VUN7x6zaOeLSD(Yps8kIb9mt39037bxn8QF5QlNLuNE1pnAWOthoyWN3FWWHF(GtV6Y6hwNE1LRtMExYTW)yvYs4))7Ykz)4d5fjZWxUQyt5u4NwuxVU6l(Sp72S6fBUP)0ILFwv2Yn5j1zfRMwMmVg)7PF2vxEZMS86)6QRUHEMp5Qlt2uVOO8QlVmB5xdqoB2Su(WtRME1L4WpEW7oE4zhT96bV)4bVN)Fhoq8Ff)(OrI)77(ITxJGA71BwJZ42FC7pYbYF54rVhE4VSiD71)wsj8)bR(SvxDzEwvDfU9G9XnBQW9WK6SLzRUf(XFIH1sxLCtE6SR(QRUSynGhsRHf(uCKxD59jLz4t5l5YS18F(hsZxNcZI8XBVUErs92RNwSQojBvf(3Wpcqzts(2RtH5DjSENb)E2s1OzJzv6hH)5xRwDBV(dz5W7Cd8SY0Kzp0hxf5BsXTqr(SIpSQVEV0VmDjoHts)460PWmC1LBQsNumF(KBNod3G4wycNKBGcyqgreP8x4dlYYtNmnbEkGzGxRgOMprKdJiGGsUBlMl2RvRtXTgF3R3MRlt5dpBvDHjUqV15tz)5at7nj559XXpHd93U96UmuD29PtsxLUmlfW)J1ehd01K55aMOQUm7o4n7T96d5VjcA9tAg6xCE7a)X0dJbFbLRLemboQbs2jTNK5pRmen1Y1KzrV4W)EsDXe9adVUo1zDrooBUOVjnp5b7dgZlGJCG8h8Khk(QQoPK9hBwLNwvzGRNRFQX6dyWGbb4J(CmZYKpc44YmyuzjWgkjpDvT572xSK3EDNTxFqJWxHenbrqYSpjjkUfWINTxWIBwvNbh8U8V9vC8bJ6U96zBkbiyHyJHLQ2SAYDWlun5ge3d)llKLjgGF4H9Z3Sz(8(Z3u(aGjMaIeMibtFuUMc)1vmsIjbwntaap9o2HRqJsmIEYZVNW(haMhFF433huJpFVqny80FFEYSSK6IsGC8vjZUn9inpDgkQSyt(mUSYziiqKCEXQBrEFqykaMrdqgBq9ZSkAM70)5MS1RtN1)w1Cn5gCQy0fLMf3NkzFzyBCsmLRsjbWvvviaUpOa)fcPDSTDBK2ftmwtenXriZFc0)IS8a9AosZEtfAJs)qCfcSeJ91xzoU3E3UZD9)MKb8fF79WXZkWwOGcqNnd1eN8bKQIQMHdh4VVSOmL90kBn05mvZ2SBdptZUXS6Qkf5lGnf8YjLPREtnAzZuGdgib5WYOynAcuoQJhgbcxyFKgGzTe2jtsXnsFC90p9JOvCmov3hnTaigCfYNqoaqUwcF3FbUUv4E3XLTAFWs((wr28HRsrnjs4(n5RslzN5mqfXvvZoQsddQTQpwX6fyYppiea3SooR4xM)HKhWteiBITPU1lGnIasz5z1pWNd4af7LbbHf3NwwMnd5nx9Gqaial0WEuoyYnfOYf0WXLjOzxvBq(yuS5TP18jfg2I0Y0(nt)goy)raBI(COHCxdHaAgwUURHmzVW)yq)tzV0G(JyplM9k9mhbOCCwULgA4XJppQK8Tx)4JnmGlq183UqzjRqhXt20sloOFTknOds4)tI5KcCvkjxvuZ1uk9iIZBmJlnK7gY0fPZ2WqefRs5s)iFGaKlsanNWmXvi7PWfNU5mHNmGWWjW0Zvf3adxTLr(YnvLY3ujJ26c()vZzkDqtoIBYlkMnbTTYzuU(eOzqDv)GhJvGlTSkTenRsz)U8rmNWWzZzIoZCqjRMIocLKdNBYZDgPRPtCeKRPcAG59egIt4ugNjVIYD(yBvod((Yst4SWPT4idEOBaFCb09ZafG3UpnxiMah8bQZYny3DxdzkltRtlknKNe32nHD7whOB6n6XSLwsM4tivOdKJywzYTfRG1oCUVEHZr(FJPm4lZt)iY4u9VsqJO(oGHgoiUap)91oEYXoQZ5ca9eFdd2478vmOdNpxOTBMRfaLeaNzbnkWB(dWOyU88RR5pjb(neKxwda4U(eE9KOxCvSZAUiFxQkxef37r2ZwuudCvm4J8G9SEX5PivhCl6MnLAEuoBWfCRUuVaaWSLRlbLFZMunTOC6cLJw94NpMLopztETNSeMjtWXBmymusumOBogcppDvfmdvgWcoCpH)htqnY8aUjK4nt)crLdPmxzq)Zme5TOiDv2hfXuHkkcerDsllLhKpz4D42lOLWRIq3Aaf(rwW5KiAFEnF(OKvOn0GajfGwTz5nO9XOb1k9cc)eQzqenIkYHP(TeP6TfPImGJGpU2dBtHJEU(qcozXl7PtIqEEKWo5AlqadlucXQwKnhpLozDXhmJMIfT))ZjmSY4TwXOMa6himxka02R)zesMXFKttTuI7A0HLMC710e(l2cFtJJs62KUdJNdeF0iRPBQb7SAwFI69QU7MjAUaUyjfQgyzwoz6SjdhE6q9RRe40f1lLT6U06(1d7VaeaQTbRJ1ZuqKupIZANhewtGpkcWhTZa)cMf09mPF8nkBit4YmP84wsOQw)WsW0FqG5KpKEJ5zlc59My9HdcOs9DdylibZKn4j8H0xmNrgoagBy793xDmZGzCNvjDRceWpndD5M52fxyrLCArvqGSWYInvtafARQwMvZc5hH)lb4ghkTKPOQkWoDKH88qZiLxxY3b0WLwohmJFss1uWIAWQYhMa2LUz5USqprUPJaoCv4A(yqZpB7CFHu9Jb3myl5zbT4fxfU6G1ZLzeOj4HvRx8eaJtGbVDiNawCA)mSKH1Ff6xn64ngyyW2kmCqv8FFnq4ZyIDzbwIkVnbThIp5mNxblzby2F6IKYBtbZQk5pd5C5sgAsvLawoQkMVb0IwcA7fga8wt5GnibNj54ZmKnASo1YppMjAzm9Wq3heBj2IulIcS(Cn8ct0dUQDtgL9LQN3iaGD02R)u2sUtZQASolhl(P65AcURqdscMgOHUwW1YZrrCBsAKCt7hQGpyMtn7WGtjrVfaz3nHBnOQJFSVDj3X)mlrGNCZuLn5HRqTjVjdgfhUVgts)yki9j1m5o(hPfhb5hdMO8JXkBmosD(Yz)JnvYCJFVJDDy61llYRSegH63sW8yGUWvLGlgBrvmSiONmnHNHRFPyZ0fCpiLREUcZl3a8k)nymmNiLiKgy2rANR9VHJ7Gs(xCp4qo6zPSx2DiMwyyW9AigKpoBo7dIL7nTJOb8svM5Ufpa6prZPxMLyTvuhCSDARVsaiEcEiFF10HSrdScQGTOAg6ENSTws6KRmLqkRZlT48qupo0CM)mFEaMqgkWI7e8gweCA43v4Me8NWLf6fIJMuP7ORstNLoRpAPhMnfMfDEZuXM6kwGYrNq9HbEA0yANIHXeD)P4gSMvWjxMd4WUa1kpvI49i3(hgDwWU6WXqjY4WWmywW9LWoGDvvPiKnnXozCGRPqlXy5Bx6a3jvanz56aLq9Gv(cqKMXlMfRcFHVVcucaHfXinVzbpUCt2Sw(ePMfJs0rO)XYBJb9ptiIHWusCHpkAQ)14j3atYo(8dWMvGSLh5ylLJC13qh2XBtXCCHHzYigJvIqjXeo8X6u8F)DPP5IJGFfggqg931NWwOHja(VrYElnIXSeymSKLffX2LenB9(3xGz9BAY61zYYqrPGxjZsOkh(7vRs5CYoX1HMCQrx0Yi4CtYtgD5YkDfdnoKeM6SP3zkHPLsa6qZV3JHcdNkJgjGAi7WwaAjbo2P1wC9rjYabg8sgoKxwuZJ(hU2cfD)SPPtwvCFIdP9VofqE)e87g6C4NlK6Bwcg4SmfZJpxtfLPAgb7VVJKostszR02N7lo(rz0bdI8WOJg4dJlXpq6jLW(bC1EvDAEEkGxJhmDLzkYaZF5XdjjSHQETXStN2wJsvfA2hS(5)7TxRnx5VZ(zwPYIyvTf2SOfnpZkMPXdcorfJ1ps8nB8ebvscALPDAvjM6HirT0dD71NZqTpxeNxMaQrXhSWLW4TZqMzdX)w6rIzaNlYxBl2PYYeqGE)NBaHrSTMwqJH8i2tMSoPg8qW0ueWeR3)(3lH1bXhVLDlutypQS10osjLff0usABpEnjKWkaitmnupr6ipoAZZaXhLAAkqjOsQtRqGgXwOjmi9qFDrHHplW8kYwqdLVi)XL)FNskMk1s3DtJ0nNX8QsWSPrbtWE1g0GjEU7vv)Vk8kAQ3j)HL69KIXGWGG0pUoVOIBDLp5ZDqVQ0VVKn5BV(B1ZERfw5jGY1PuehbMcSRyPjltwLyyv0P7lKX60YParMf(fCZHZdUDYl(qmecpXWQ6iJV1jYlxRyjmeY6ejRgejBp6DKjPfCcE5dNzBEZcCf0EVu21sIVXo0UlyuK)b9pzx2NCFZ4GHTOrsyISbK8lMdhxqWmOQkCEQKa2Y9fvwDm3uTEl1(Z3QYmb)dl)L5XK088Rm8IRtubxxS2aK1sSGG6tM8XMlBHpNkb16WYHRTKaHwpCbwyuMc7AomfllyNyaWa5EEIY3ogZizkQAiD5YfqSSBVtgYXw9r6wduDO6XbMvNrTSOyvEwnSBZQw68SmS0Q3Wcv2TCxWTEC16IS8kmJbRsZb2QYnvUlb483nSLbkScuRkJaIAelkkxHqa2ByVG6gAnURMjSaLZ45XuxBApb6QUFX)PaFaPl8kbHm9mTsWTvLK0KWAXKzV3(bund23e6AlIs9QO2wQKhBH)(2BfOKkaJNYclwD6TfO1u6cjGD6IJ80GWsR1)LIFA0aDItKB6LzLLfLtYwYAkyRix4fUz74NfoEWbCexfsoJFufvt5dx)qzHiCDMlM6WHAKOIFBrKg)nrmevHYnJ3tP86a)NLRIJAFLIEqtbDSfrJpAyXfHDu19REb)(cE6uTYbH4LuOvZGC2ly0hbtPnOISAeTAsg6HiVS2pxwabDJvKESok0is8YYWsLbF7kD1k9FUTQhrK02jmR7UuuX27Ygv6oH1I20HIg2tE0MgWCCYJkF5eTubf)MDqxNlegO4Ztw9awWy3EKi9H2wmuyi4XK1gLZGzCe7YcNmtWLdZXnQIIv0Ye82HBRDrv(9F93W7lc(rneKEwHYYk)9jz5ms6vUDibVEjio4BT5)7CXIQ2PGYIiU(fEI)PelZ32UJenEmr0v)2wvIyrggGH1fJoOHpRllMgTIFdhP6wuyNnvvEdcvok6gqH4ux4fRbWe6hKnLbriDPug4Z76QUhxvhzCvbuvSmLXoR5XytTqqDwD)MI2VXb3qffr0beOqmI(oSJfmI0ewdjPjlNltCttLhH9ufvDSBWKick7VxOOUphSKwlcl(ojtNMMNcw)wlYFgHjfeHtTfB9NhTGRmRt0c9H)uTkMgYxOvCTm23gXUYs1aATavSi3N7DISM5f9mV1eLYkJt3FiXunWrm)Gz5gVSOQEotZY3UKPYK7ZsvHueV2Aohh9zqunf7I0b5CojvpLyVYrebSMklJMS4iCUBBo39JvVV2Irb3MD6TPEwkDpFfiAnwgy6yvQZSe2M1DDEinKTtWh)mMj)6mXDt5nGNXSjAtpdgHobF2oolrk2LG5loE6Q4XtJhDv1T2dEYkFzb(VNNTkRAbos0cp(O)FyBcX4UPyJWCZCWAPDpUQnDriP6mbIZrETPUrv8XAr4ASYgzn(RiBhwfHsXQzz47HBdzYPS7W3e5bsYiKQ0kz3yB2lPl5c6eIAqePxz(HI5waCdP4QADzwrjRT5XizAkpqqQuMNZVCLa7rzfxMPujPUhuIetqx1ASD5ROu9ix8WP6ckNGmC0cdkuTufNRZT6hQ1KlQ7nUOvVaX2KS1U2xrpAIrRlihvj51KlLnx8UbL)2Yk79uhVGB2OjUsIMKx2lWbJqKjXtIQ36WG(yZZhNL3V8cuQh36ONGFTuf(n)AnbBitE1kzEoGmQ2nXkrYe1owdYspe2QyPj(F4C(JkNZV8LM8mhjfEMGjw62n5jL2IwzxJyf4)cfPoVipV4d9jtuHsDlEFiKpb3TEwEgW3k(tL1fJrL37QWMb6eW5)Tx)d)IiSkwxUxK51iPr3WfQISlxv)udQviP1g13rWCaMdxpMA71QhYRQGQzpj8CG7XkDewG0W1kQC54qlDwnbCfTPggjq7x4ykdnODD9sdAWGT7XJl9hkKUqQ1oakmG9MwyWDADgQDBBKFmuvLWdQwfAOJUEgmwkT9CNHrj7wmnIY15v0orNK4rarN7KWSq77n3tETst(9krC3LFaNUBqBJ8jPFeV6XMWGIfpOzqrIuJ17UXUTj3jQacrzYBi3dQjk4A9cnsCL62S5cJdyUWUF4Nkiqnv91i2dlZLLltlns2L0q9Pj5ZiRcm3TJJ977PfFi9Lr9E7xj7llwAbUuiYfDtZu5jAbXI081H7qeUTioTFn(h8sIxgLmUl3yJIjsBEkVu8slVN5NQRNscSjlA(ENPnD8Z8YiASViERyA0T9WniCgRUlLydj8LUemW3XO60PZSLj6JzojsXBq1(UlskGyN2hm2WIJn(lunJQxAjyKTs6VoaS6falhB(D6r07tRO66cvK9goI4i6wrS9SMRhTLbrtkCdkhIsi9xfQOVEqJ5TTZ2w0jSY8khQXvKp0WCnnvd8ZeCAD2vxo6TE08abxN39ALP873DPSdWJLJWW1vTq4fKPmN(u5TJWGExILMmgU5(mdbK(aVWZtVOfZzX71eOJEahFvJsiXYB72kSs6zCaIA8fyaYCOevfohD7rlmB0uW2AwNZPYWcrJyQslStrsauHMWqc4HSwk20mM2S1pWnwlkwgkXOni0(LfhBXE46GxtbZkCR42T5iAzg5014h3GvPyTgAOJYX6RWBwZ7lGUrkRPmDqwdjvWKXq10Vh0K)7nhJlRznEcLytBqtpyAUuwefwmFZHdmWrdHTnNhCag3ELm5F09Z6jUbi0pqaEhtCcjzZoJfSFUjZo5bninNJZFkTX93yE7gOJvS0GNJK18JB1rvzK2Rhmn9(MuEyhmV6gSQP5Tx)REvAvAwnR4KKbslrNZ6ptv8HBTkFDRYp08AlPWaocUl1DzIvl02)PKS6)ik4iadvtg4RQKpdJQS1LZxXeHiRN5j5U6fb7gWnFtLYYXar(FOqqbcHyjhqz)q4YiujQJ608BTUPO56dBUmdhtAXR5DgviPBT6air2D3xgeeXLhVmV(S9KZ6jTk4sEPV8ptb)i(Dq3t0mCZJH0U34eyFndNDb5ym18h0Z5uAtlJGbHZ2MCV4Wfj7o7ufrg5AqZZcFjstq(tcElXOwmo3XYXtAryRt0(Z4YP2JKLjSbYE7jtVw87gYo8g1R)AS(aIowrJdkxmEDFjv6quNvdMMb(1qD6QInygTeTo3r87yEMYxq2tsMiYDC10FNPBx6o6MLkIAqwRUfTyMXkBZl8)nDtzjqyr7owLEpVzo2aqbr04emCGDTQffzs398QST4jNYniqgxyZer)r(6adrE9IQ6IvUOoZBiA9sMpEo9Cm7obnA0B8goxW2T3wwOxd4vncObE6DXJureyX(xvf5ga9w8etAjiT4(SQm(NJI4oK7a)ZgyVcNcQFJ7uShaSm0rcdIQYu9iZyeQ8)12Fi1yDvwyJtTAiOOU8(76QgwZMkDxMuH9gxzzgVB7cN)Ziely5akvNahgRiVlGdcK3zuPzGjp)luHLyXyCxNgGFZ5fyNbHtHGuaM4l2NtXbVF07U6YpKuIn3ALO9kbJakW(sI5XXBm0RxZUKFFdgUV)5Mmw5JHfkpSe2uxi(ceIxEsGrO93(J)3SAD70Va9zH1Pt4JFJSgJ1M()gUOiINiPnWi6o8J9uW8mAy6hkFhqhU6SCNHHdEbw2Ha6DIpGkoq8oNVRkAWT9hJtNyTXYUrME5rPbMb3In3fTgOw0BlU1RQdDx)HQkX2ob2jX1b60z41d0dFXr(ddCm00XmhGtfMlxWokWkFpGugDsaKc67IlEW0FM2cihxDCazahH8aEa8kve)DMHyjf4vFAiLOy7AXUjp5LNLEe9mK46cJZe498wIme3Nb7gw4V4UgfFObS)ahOwH0F)dC34HbQ7hVacatmKxqG3iyhfhr494wTw9)koqa4NkI4PbC95chPrfRt5rdRIx7gVHzRNrCmrW0HBsx8RZ(d7gP)DouaHOxETVvNSVgU4A79PXUm4pE4yQhBCL1FOAMOUytId8UEyiXtI(A9(0pDyNiiOXw9XQKK(NdIXN9ssmId8GeJOVwVDIwOp78YBK6qVJ9)70uSh0nk09gYA79XEGu9R6Q0z3uahWiH9Y6KpdbSUuFZV5az)ReUwcrUNqSBBU3q5JK19q3VJW8zSZdC(E)dXN1((veMpJD(N)AbXN1((veMpPDoPSiJq9yQPCVizYk9SU7DQliMgwR6yUVBlVamKYOM6SYCdMAljj7m0i3IE1w6UTtdigBV5ADa3j4GGU4fCMN4v4qlNPNzKEE3R26py0W21a)ecq7La)ekGAjpFtS2(J)vg)nc23lRMj(xyuKRf70QI5z5QuRx1xzC0HN)zU3A8B)Xpz71pH7dYNXT0(2FKAHjNLJW8wFUPmunpXrIOSC(XdpI1m(Nlj0E2JDu28ZTkriFOnEWtDZx3MR409YnTEBWv0f8UfcGEiNpqGfp9TD9u294J(Qu7D47F)7FB3d8FsNd8aqVxwS7E(6pVviAQeCBJNPgHcnJ3s0VO4KN69zEB2801VJ1UNEi)zMlB)CHJ3g0Rt9ZBHxDEMcHEYF(qOpRBa82GhDldhleP7d3BNm3J313pLnjRuKukhpDWrfRpNDRr3WMQfeSD8I6UnREdXe2XUmKWe7rTden4V2Jxq374EZ8YqsrBg0)K2sCA)bT98vXDB2NuHcwVjT3Ip17K72SomV5jfSfFEBEpujzZxj3cioCeni3i(shhfKmuWE4IMUn7kdUVc2DcTyde8c9(XhB6Y82yewxK3g)U7L4TXJiUaVnNs)lVBJNADXDZWI)(FLw3gIqH5v3TGamAqizB8rtdxZsIJEeowmiYiVO8mVOj7)PHPQZJqxnfda(5POSH0swbXWOg6YT0AyofJmhNmZySFYNiDAfhpl9oFiPCTjqSl(zCNHdBm2ybkbkg4qEDNz7kmwzXlsNTjxjXmzn4y8hZwY6XDUAbFX)e(iGTpFfCKjUOxa5KXVEIxX1Aejbw9BgH5V7mrpfmXDaAHLEn(FQYE2frM5ddLpogE19ZklWMWqxvgU77zpa3ggn(Y6ox27R4Q52WrsEdPXuCskYM7IWnCcVCpdo3zEFo7fZwS00ow9mRt8p(Olowm9xyzpVeX35aD5PYwfZMmC4PdLVuVoD7sxviDcx6fbwz9oSlDDv0jCXlecuxmSNj60wty16hwcYpaHft(q6niFQxEGL4KHd6yLn3XVBqp9z8FdV6RWkIhpqD5q87p8XSEAdNRkzZMXmncBMjwRZXpUufE1fqrNLaAcQ9WbaLTOQYz9o6mxjAZkMeY6I6KQ7oYOXLoFO6qSbUzZ6hF0zsgeE7KTeC(yE606jjvGpiZswn9HjvPLBw20o6KWa11oHgaL6K3XNrbtMe8duVV)Pngf)NbyWdjd4nZdEx5ivOTRGrIm5toFNQPfRyJO963q43uHACIv)dko8)NJQ74FZl1MDsvjRWMBIT)8b(IOXJCTsuV5KXVbAznazh1g2xgxJVm3pWz)JnkpYU3rrS(77o11ii68qvc21uUTnm7tnc1NZwXXoz36s5k2lZzkY29I4qLFpMEXjY7CeBPj(tvNGjfWCl5h6bYZ7DpGUrrF8X4Dj6fkYR6ap)5AEMd49ai9D3qpXJT60XoeDllBrQy)OVIqgF(WhFmgl6iHwxxla1mEExRugmFGP9BkzALR2Q)MRWc5Sv3PBAOn30B8(Ic9TfuSR69DVzkyac5WazvmMwvaCkUPg2BMXPAxnjvImLSWiFx4eo1SfJbT((4ZglysCOF(hdomePwbR9R(L2lPwf5zFCtpvCM9YVPm8iR(97tCVjdGwAsle11KCOywmnOdxocLZ6ujrQZbMDqKqUjLiIUUTVm8Bs5RAW5ERIG(wdIi8mL5IZh1RzvWbQ4LGcvj2krXvCnK7PVr)ri3eey6ttQlnKoD9pIoM(DS)o9h50shFkylObEL5YriLEAnFBeNvKIiXW57)pE(MBe5xSF2bj6gb3uHnBaH4PmcwL4DLnMcgin23aGq(AXpXqusNQBXMJdnc2tV404gpszWP0kbJR3WhFmSYfdn8IpkdsX9JJmZoUQgzK94Q)5nF(xQLrJgeYtRPFOYCOSGu6VH17)mJizD)FKmMI1ftJFz76hHKAFpdWcryanmD8DtbLbri7SNyO2fshYIWmaD4z9cAoypt(pd78LKnDy7ACySR2fHUXMgAAj4P)DcBt85TBeaO8p2814iXR5BeTMpbf)yfZJqVs2Q7lUdZsjiMhuLWU(XfgwXS1iB18nYu0kcKP5plLc9CMi55h0a7Qn4DiHAY8FKycByYIhOeKnawW)j5tah5ML5eDB82wT7Oy(Ig0t6iPn4jSCSLlW1zTx((TfDT4K2fs5lXCUlYd9CFmYydDb(D(GOXJqdAb2Z3eu3BZXyidv(IE5rfDFk4cHYxEvVy91ARxCICg)Ekj426PGJhpQtaniDoOBy1)wvUJEpeFde3GP2T8vNOEL)aP98OmCcEO7zlCl96(DMkUGn1p1oxoJC)sDoTP8r9HhENU8vN3nIyhQFp13EstDcjvgbeq8(s6LpKDEYta2e3KMDc8ONa099y2CXhXD6wpdUFJ16e43BnK9cKxXt8BlwuMw7aLP)qfjIcwmzld9zsfhkFT(6JfxDMFThiel7EvGiLkBFHv459oMlWAF3n4)Sw1K(AGdrf76hAQgLxUlb1QRoQwAkB8W7flmyHdHEa5ongB9tLPcOxmtcqgWyYj6rWhsgsTisCp0LAZIiWB7A8TJ6Ib9gpQrI6(4Ba1ELjGGfiozMi4HJ6F2)H6lP(n)LYQb)FuFdV4cDntdKYsOq3e4gIxFsFrT2f3H6sGetc5PHb4matpzu5CUK)3v4CSqMLjyIB0SV3mUFNb2X32p)Dok(Al48UDGjItSR3gnGEAqr8t9BD1UWSS38nmiNHJVSpj)PBpvAVTF27ltpVMc5GePuq(V5C5d)0mKQb7L2S(WiICbhOjTzkYcr7hCapV7gxHZydfo725RwUSuyaJl62oQObG9WQY4lNL4UVG(eXTc)Fi)mrTJ8tQoAIQtR7yKALXUY5uEH1ngec8wJpvesPqjeA8761ZJTM9K4C2VChF3fgr)nSHuj1)6IZLxCQTzrlcl(paSqyCXVx7DQQmtWjswP2I4BlR)4zY61wup)uLXHzHiZmMIMzQMvDOhU7v0KbmyGNHeA2BxShTsNIBbDHRZm)NVHu6w5LvVydQ3j6OpXCGLS5y2Z7oZkttS)egrRcwJ65VT7Uj(PNSwOmdDsqO1O1D9oUPGHSFXs(rpZTO0j5seDlbOP2MHL763CShHm7pESxcqXjoFIl87FDHxGPbIw6(CBwS(CSW747wZQ3qGNn0UB8uh)fj2bbWmIMPWX7iQltGx3D(ZTsb692UQQySNzOL8J4prjYe2Iqv9AeIl77vPPe0oZkOBnxgEZY)bDeWzMuIICXgTI1lulWi1pAavJq(AG0vsxDZ1QjZxWoCRtJV(XJgeR0iAGh18NygMJ2sHU2NvJjCfu8)6ITcOcNTl(FtWcO6BVhtv6xerK0SzOcPewERrnuNWTABjppPZMvzROIhplB2LHNzWUG69qBozRqUDHREtnQdh9MaqayIUlwJk7Z52EkYquv6RnZwjGIMKEpRqsGnA)mw1j4(RPFeVSv64(ZSwK7IZpX7bQwZA4zueIVm)djpujk)vBtAWK4F)MC0MB(xeaqyi7Lzqh)WqGLTFjZlCwxtWo(wX7bowE1UP4ErwawMGFGiKLQlAkFDLmJxyaTF5r1E4y5wdo5LT6Thq)KnRDObgptqjIRaECOzu7ouaBkzvwHqaI8yTsAPQ1qv24js2c7yf3SorpiYkNdHZpKpqaYfjGqmyM4sM9K860DDZ5FtzsFvKj3glDSIBm5ioKYwz5XJ32D4XDh0)0dh0F0B9nNON83UtCZ33BCS6AmAr5DHvTNCmw7jIkrMx(OC0Hz(QrsN6lK2rTVi2oqtzcuMS(bNFxl0yY6a21QDNuuEHrqQBrCYBDaAoFOrXks9L)svMXxmuwAguFZXgR(gZ2ZOieQnOnG8own8C0wVpAECcHQXVTihIcRcpm7uj4CJn1znKfseXjtUUDNdGF)x)n8JFC2dwe9D7p2mZsLO)tGzWQxbJYgSZHCaPvYZzM0GorilwSnrj096GN7UyGzPr6vLY(reoOtG0nXEhI0ni4RCICFpJEnOCN(Ge3W63nYmurony0A8xPSs24GOO2on1Wpd7qxq1DoG4lF2rIVRZNRoYfFdBfWBY80ijauDMGzkW5SuHKuHSp9ObveMAS5zD9Dsf)uY48jf(rIkPxaKi3E7h(82NWIOPuOnPjGAz2y4YBiA5EQsub45WZK8xX3thiaHaW6pFETNR8faNHUb()h)nCTzzG7s1fq1ntDJPCtx(jK3wO9Ai6iD62nGbrOaGMSvI3DuhqLm5OfIw3apZcWe5ka0v94JDPfGVZnKkZkGZB6d1mi10VrMoPhz7K5C(0OYncN5qYgsZRGdpiIC9EytQa6VtLXDy5MvYsz7gXPmjR8pywBecd52i8ZBPkORaba4KehvQ4rEW76G8pNC7e48yPEcSdCDOVnXp(OxLh0dzp7YNeZVeXu1a0qGdNSZchHNPIyOj7mNpt5Bz(iE2BJB65ycZQK3)auh3S7ZKgvV0QAXG(8RTA)XnyD7lRQ6wzT3ZkXJnv3aX3vkK6RqIXJs79s9mPh3nCcJY0BvDoz)5gUJl4XFSh7y3oxBenyvA76RMyqWVv8SX9xmSt4U)UDmc06cLwMBZG0W(L6cc1z9g(cdTJ8BdCKXWUmonANY)i9T8D)4GczdQ3oHiIWSrC3X1xFhXbJ34R8lUu0F3tzx4sKVI6JYR3l0H)jqL(1O(S7gacDWpGQrMD8JsGZRE2GaJ38U9Z7De6VT(u2QD539Zy7fcX4AluLJOx0DU53U2xWLa7lMBGLqPXx(22I5UX(7wRZR9or3fCdXNdxdQ4vxI3Ayx9tF(jSV6Tx9)7]] )