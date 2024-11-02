
-- MageFire.lua
-- October 2024

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
    blast_wave                = {  62103, 157981, 1 }, -- Causes an explosion around yourself, dealing 6,521 Fire damage to all enemies within 8 yds, knocking them back, and reducing movement speed by 80% for 6 sec.
    blazing_barrier           = {  62119, 235313, 1 }, -- Shields you in flame, absorbing 127,971 damage for 1 min. Melee attacks against you cause the attacker to take 1,725 Fire damage.
    cryofreeze                = {  62107, 382292, 2 }, -- While inside Ice Block, you heal for 40% of your maximum health over the duration.
    displacement              = {  62095, 389713, 1 }, -- Teleports you back to where you last Blinked and heals you for 119,072 health. Only usable within 8 sec of Blinking.
    diverted_energy           = {  62101, 382270, 2 }, -- Your Barriers heal you for 10% of the damage absorbed.
    dragons_breath            = { 101883,  31661, 1 }, -- Enemies in a cone in front of you take 8,040 Fire damage and are disoriented for 4 sec. Damage will cancel the effect.
    energized_barriers        = {  62100, 386828, 1 }, -- When your barrier receives melee attacks, you have a 10% chance to be granted 1 Fire Blast charge. Casting your barrier removes all snare effects.
    flow_of_time              = {  62096, 382268, 2 }, -- The cooldowns of Blink and Shimmer are reduced by 2 sec.
    freezing_cold             = {  62087, 386763, 1 }, -- Enemies hit by Cone of Cold are frozen in place for 5 sec instead of snared. When your roots expire or are dispelled, your target is snared by 90%, decaying over 3 sec.
    frigid_winds              = {  62128, 235224, 2 }, -- All of your snare effects reduce the target's movement speed by an additional 10%.
    greater_invisibility      = {  93524, 110959, 1 }, -- Makes you invisible and untargetable for 20 sec, removing all threat. Any action taken cancels this effect. You take 60% reduced damage while invisible and for 3 sec after reappearing.
    ice_block                 = {  62122,  45438, 1 }, -- Encases you in a block of ice, protecting you from all attacks and damage for 10 sec, but during that time you cannot attack, move, or cast spells. While inside Ice Block, you heal for 40% of your maximum health over the duration. Causes Hypothermia, preventing you from recasting Ice Block for 30 sec.
    ice_cold                  = {  62085, 414659, 1 }, -- Ice Block now reduces all damage taken by 70% for 6 sec but no longer grants Immunity, prevents movement, attacks, or casting spells. Does not incur the Global Cooldown.
    ice_floes                 = {  62105, 108839, 1 }, -- Makes your next Mage spell with a cast time shorter than 10 sec castable while moving. Unaffected by the global cooldown and castable while casting.
    ice_nova                  = {  62088, 157997, 1 }, -- Causes a whirl of icy wind around the enemy, dealing 16,562 Frost damage to the target and all other enemies within 8 yds, freezing them in place for 2 sec. Damage reduced beyond 8 targets.
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
    shifting_power            = {  62113, 382440, 1 }, -- Draw power from within, dealing 29,282 Arcane damage over 3.4 sec to enemies within 18 yds. While channeling, your Mage ability cooldowns are reduced by 12 sec over 3.4 sec.
    shimmer                   = {  62105, 212653, 1 }, -- Teleports you 20 yds forward, unless something is in the way. Unaffected by the global cooldown and castable while casting.
    slow                      = {  62097,  31589, 1 }, -- Reduces the target's movement speed by 60% for 15 sec.
    spellsteal                = {  62084,  30449, 1 }, -- Steals a beneficial magic effect from the target. This effect lasts a maximum of 2 min.
    supernova                 = { 101883, 157980, 1 }, -- Pulses arcane energy around the target enemy or ally, dealing 4,141 Arcane damage to all enemies within 8 yds, and knocking them upward. A primary enemy target will take 100% increased damage.
    tempest_barrier           = {  62111, 382289, 2 }, -- Gain a shield that absorbs 3% of your maximum health for 15 sec after you Blink.
    temporal_velocity         = {  62099, 382826, 2 }, -- Increases your movement speed by 5% for 3 sec after casting Blink and 20% for 6 sec after returning from Alter Time.
    time_anomaly              = {  62094, 383243, 1 }, -- At any moment, you have a chance to gain Combustion for 5 sec, 1 Fire Blast charge, or Time Warp for 6 sec.
    time_manipulation         = {  62129, 387807, 1 }, -- Casting Fire Blast reduces the cooldown of your loss of control abilities by 2 sec.
    tome_of_antonidas         = {  62098, 382490, 1 }, -- Increases Haste by 2%.
    tome_of_rhonin            = {  62127, 382493, 1 }, -- Increases Critical Strike chance by 2%.
    volatile_detonation       = {  62089, 389627, 1 }, -- Greatly increases the effect of Blast Wave's knockback. Blast Wave's cooldown is reduced by 5 sec
    winters_protection        = {  62123, 382424, 2 }, -- The cooldown of Ice Block is reduced by 30 sec.

    -- Spellslinger
    alexstraszas_fury         = { 101945, 235870, 1 }, -- Dragon's Breath always critically strikes, deals 50% increased critical strike damage, and contributes to Hot Streak.
    ashen_feather             = { 101945, 450813, 1 }, -- If Phoenix Flames only hits 1 target, it deals 25% increased damage and applies Ignite at 150% effectiveness.
    blast_zone                = { 101022, 451755, 1 }, -- Lit Fuse now turns up to 3 targets into Living Bombs. Living Bombs can now spread to 5 enemies.
    call_of_the_sun_king      = { 100991, 343222, 1 }, -- Phoenix Flames gains 1 additional charge and always critically strikes.
    combustion                = { 100995, 190319, 1 }, -- Engulfs you in flames for 12 sec, increasing your spells' critical strike chance by 100% and granting you Mastery equal to 75% of your Critical Strike stat. Castable while casting other spells. When you activate Combustion, you gain 2% Critical Strike damage, and up to 4 nearby allies gain 1% Critical Strike for 10 sec.
    controlled_destruction    = { 101002, 383669, 1 }, -- Damaging a target with Pyroblast increases the damage it receives from Ignite by 0.5%. Stacks up to 50 times.
    convection                = { 100992, 416715, 1 }, -- When a Living Bomb expires, if it did not spread to another target, it reapplies itself at 100% effectiveness. A Living Bomb can only benefit from this effect once.
    critical_mass             = { 101029, 117216, 1 }, -- Your spells have a 5% increased chance to deal a critical strike. You gain 10% more of the Critical Strike stat from all sources.
    deep_impact               = { 101000, 416719, 1 }, -- Meteor now turns 1 target hit into a Living Bomb. Additionally, its cooldown is reduced by 10 sec.
    explosive_ingenuity       = { 101013, 451760, 1 }, -- Your chance of gaining Lit Fuse when consuming Hot Streak is increased by 4%. Living Bomb damage increased by 50%.
    explosivo                 = { 100993, 451757, 1 }, -- Casting Combustion grants Lit Fuse and Living Bomb's damage is increased by 30% while under the effects of Combustion. Your chance of gaining Lit Fuse is increased by 15% while under the effects of Combustion.
    feel_the_burn             = { 101014, 383391, 1 }, -- Fire Blast and Phoenix Flames increase your mastery by 2% for 5 sec. This effect stacks up to 3 times.
    fervent_flickering        = { 101027, 387044, 1 }, -- Fire Blast's cooldown is reduced by 2 sec.
    fevered_incantation       = { 101019, 383810, 2 }, -- Each consecutive critical strike you deal increases critical strike damage you deal by 1%, up to 4% for 6 sec.
    fiery_rush                = { 101003, 383634, 1 }, -- While Combustion is active, your Fire Blast and Phoenix Flames recharge 50% faster.
    fire_blast                = { 100989, 108853, 1 }, -- Blasts the enemy for 15,787 Fire damage. Fire: Castable while casting other spells. Always deals a critical strike.
    firefall                  = { 100996, 384033, 1 }, -- Damaging an enemy with 15 Fireballs or Pyroblasts causes your next Fireball or Pyroblast to call down a Meteor on your target.
    fires_ire                 = { 101004, 450831, 2 }, -- When you're not under the effect of Combustion, your critical strike chance is increased by 2.5%. While you're under the effect of Combustion, your critical strike damage is increased by 2.5%.
    firestarter               = { 102014, 205026, 1 }, -- Your Fireball and Pyroblast spells always deal a critical strike when the target is above 90% health.
    flame_accelerant          = { 102012, 453282, 1 }, -- Every 12 seconds, your next non-instant Fireball, Flamestrike, or Pyroblast has a 40% reduced cast time.
    flame_on                  = { 101009, 205029, 1 }, -- Increases the maximum number of Fire Blast charges by 2.
    flame_patch               = { 101021, 205037, 1 }, -- Flamestrike leaves behind a patch of flames that burns enemies within it for 4,493 Fire damage over 8 sec. Deals reduced damage beyond 8 targets.
    from_the_ashes            = { 100999, 342344, 1 }, -- Phoenix Flames damage increased by 15% and your direct-damage spells reduce the cooldown of Phoenix Flames by 1 sec.
    heat_shimmer              = { 102010, 457735, 1 }, -- Damage from Ignite has a 5% chance to make your next Scorch have no cast time and deal damage as though your target was below 30% health.
    hyperthermia              = { 101942, 383860, 1 }, -- While Combustion is not active, consuming Hot Streak has a low chance to cause all Pyroblasts and Flamestrikes to have no cast time and be guaranteed critical strikes for 6 sec.
    improved_combustion       = { 101007, 383967, 1 }, -- Combustion grants mastery equal to 75% of your Critical Strike stat and lasts 2 sec longer.
    improved_scorch           = { 101011, 383604, 1 }, -- Casting Scorch on targets below 30% health increase the target's damage taken from you by 7% for 12 sec. This effect stacks up to 2 times.
    inflame                   = { 102013, 417467, 1 }, -- Hot Streak increases the amount of Ignite damage from Pyroblast or Flamestrike by an additional 10%.
    intensifying_flame        = { 101017, 416714, 1 }, -- While Ignite is on 3 or fewer enemies it flares up dealing an additional 20% of its damage to affected targets.
    kindling                  = { 101024, 155148, 1 }, -- Your Fireball, Pyroblast, Fire Blast, Scorch and Phoenix Flames critical strikes reduce the remaining cooldown on Combustion by 1.0 sec. Flamestrike critical strikes reduce the remaining cooldown of Combustion by 0.2 sec for each critical strike, up to 1 sec.
    lit_fuse                  = { 100994, 450716, 1 }, -- Consuming Hot Streak has a 6% chance to grant you Lit Fuse.  Lit Fuse: Your next Fire Blast turns up to 1 nearby target into a Living Bomb that explodes after 1.7 sec, dealing 4,825 Fire damage to the target and reduced damage to all other enemies within 10 yds. Up to 3 enemies hit by this explosion also become a Living Bomb, but this effect cannot spread further.
    majesty_of_the_phoenix    = { 101008, 451440, 1 }, -- Casting Phoenix Flames causes your next Flamestrike to have its critical strike chance increased by 20% and critical strike damage increased by 20%. Stacks up to 3 times.
    mark_of_the_firelord      = { 100988, 450325, 1 }, -- Flamestrike and Living Bomb apply Mastery: Ignite at 100% increased effectiveness.
    master_of_flame           = { 101006, 384174, 1 }, -- Ignite deals 15% more damage while Combustion is not active. Fire Blast spreads Ignite to 2 additional nearby targets during Combustion.
    meteor                    = { 101016, 153561, 1 }, -- Calls down a meteor which lands at the target location after 3 sec, dealing 35,527 Fire damage, split evenly between all targets within 8 yds, and burns the ground, dealing 8,198 Fire damage over 8.5 sec to all enemies in the area.
    molten_fury               = { 101015, 457803, 1 }, -- Damage dealt to targets below 35% health is increased by 7%.
    phoenix_flames            = { 101012, 257541, 1 }, -- Hurls a Phoenix that deals 9,241 Fire damage to the target and reduced damage to other nearby enemies. Always deals a critical strike.
    phoenix_reborn            = { 101943, 453123, 1 }, -- When your direct damage spells hit an enemy 25 times the damage of your next 2 Phoenix Flames is increased by 100% and they refund a charge on use.
    pyroblast                 = { 100998,  11366, 1 }, -- Hurls an immense fiery boulder that causes 25,008 Fire damage.
    pyromaniac                = { 101020, 451466, 1 }, -- Casting Pyroblast or Flamestrike while Hot Streak is active has an 6% chance to repeat the spell cast at 50% effectiveness. This effect counts as consuming Hot Streak.
    pyrotechnics              = { 100997, 157642, 1 }, -- Each time your Fireball fails to critically strike a target, it gains a stacking 10% increased critical strike chance. Effect ends when Fireball critically strikes.
    quickflame                = { 101021, 450807, 1 }, -- Flamestrike damage increased by 25%.
    scald                     = { 101011, 450746, 1 }, -- Scorch deals 300% increased damage to targets below 30% health.
    scorch                    = { 100987,   2948, 1 }, -- Scorches an enemy for 3,600 Fire damage. Scorch is a guaranteed critical strike, deals 300% increased damage, and increases your movement speed by 30% for 3 sec when cast on a target below 30% health. Castable while moving.
    sparking_cinders          = { 102011, 457728, 1 }, -- Living Bomb explosions have a small chance to increase the damage of your next Pyroblast by 15% or Flamestrike by 15%.
    spontaneous_combustion    = { 101007, 451875, 1 }, -- Casting Combustion refreshes up to 3 charges of Fire Blast and up to 3 charges of Phoenix Flames.
    sun_kings_blessing        = { 101025, 383886, 1 }, -- After consuming 10 Hot Streaks, your next non-instant Pyroblast or Flamestrike cast within 30 sec grants you Combustion for 6 sec and deals 260% additional damage.
    surging_blaze             = { 101023, 343230, 1 }, -- Pyroblast and Flamestrike's cast time is reduced by 0.5 sec and their damage dealt is increased by 5%.
    unleashed_inferno         = { 101025, 416506, 1 }, -- While Combustion is active your Fireball, Pyroblast, Fire Blast, Scorch, and Phoenix Flames deal 60% increased damage and reduce the cooldown of Combustion by 1.25 sec. While Combustion is active, Flamestrike deals 35% increased damage and reduces the cooldown of Combustion by 0.25 sec for each critical strike, up to 1.25 sec.
    wildfire                  = { 101001, 383489, 1 }, -- Your critical strike damage is increased by 3%. When you activate Combustion, you gain 2% additional critical strike damage, and up to 4 nearby allies gain 1% critical strike for 10 sec.

    -- Sunfury
    burden_of_power           = {  94644, 451035, 1 }, -- Conjuring a Spellfire Sphere increases the damage of your next Pyroblast by 20% or your next Flamestrike by 30%.
    codex_of_the_sunstriders  = {  94643, 449382, 1 }, -- Over its duration, your Arcane Phoenix will consume each of your Spellfire Spheres to cast an exceptional spell. Upon consuming a Spellfire Sphere, your Arcane Phoenix will grant you Lingering Embers.  Lingering Embers Increases your spell damage by 1%.
    glorious_incandescence    = {  94645, 449394, 1 }, -- Consuming Burden of Power causes your next cast of Fire Blast to strike up to 2 additional targets, and call down a storm of 4 Meteorites on its target. Each Meteorite's impact reduces the cooldown of Fire Blast by 1.0 sec.
    gravity_lapse             = {  94651, 458513, 1 }, -- Your Supernova becomes Gravity Lapse. Gravity Lapse The snap of your fingers warps the gravity around your target and 4 other nearby enemies, suspending them in the air for until canceled. Upon landing, nearby enemies take 5,826 Arcane damage.
    ignite_the_future         = {  94648, 449558, 1 }, -- Generating a Spellfire Sphere while your Phoenix is active causes it to cast an exceptional spell. Mana Cascade can now stack up to 15 times.
    invocation_arcane_phoenix = {  94652, 448658, 1 }, -- When you cast Combustion, summon an Arcane Phoenix to aid you in battle.  Arcane Phoenix Your Arcane Phoenix aids you for the duration of your Combustion, casting random Arcane and Fire spells.
    lessons_in_debilitation   = {  94651, 449627, 1 }, -- Your Arcane Phoenix will Spellsteal when it is summoned and when it expires.
    mana_cascade              = {  94653, 449293, 1 }, -- Consuming Hot Streak grants you 0.5% Haste for 10 sec. Stacks up to 10 times. Multiple instances may overlap.
    memory_of_alar            = {  94646, 449619, 1 }, -- While under the effects of a casted Combustion, you gain twice as many stacks of Mana Cascade. When your Arcane Phoenix expires, it empowers you, granting Hyperthermia for 2 sec, plus an additional 1.0 sec for each exceptional spell it had cast.  Hyperthermia: Pyroblast and Flamestrike have no cast time and are guaranteed to critically strike.
    merely_a_setback          = {  94649, 449330, 1 }, -- Your Blazing Barrier now grants 5% avoidance while active and 3% leech for 5 sec when it breaks or expires.
    rondurmancy               = {  94648, 449596, 1 }, -- Spellfire Spheres can now stack up to 5 times.
    savor_the_moment          = {  94650, 449412, 1 }, -- When you cast Combustion, its duration is extended by 0.5 sec for each Spellfire Sphere you have, up to 2.5 sec.
    spellfire_spheres         = {  94647, 448601, 1, "sunfury" }, -- Every 6 times you consume Hot Streak, conjure a Spellfire Sphere. While you're out of combat, you will slowly conjure Spellfire Spheres over time.  Spellfire Sphere Increases your spell damage by 1%. Stacks up to 3 times.
    sunfury_execution         = {  94650, 449349, 1 }, -- Scorch's critical strike threshold is increased to 35%.  Scorch Scorches an enemy for 3,600 Fire damage. Scorch is a guaranteed critical strike, deals 300% increased damage, and increases your movement speed by 30% for 3 sec when cast on a target below 30% health. Castable while moving.

    -- Frostfire
    elemental_affinity        = {  94633, 431067, 1 }, -- The cooldown of Frost spells with a base cooldown shorter than 4 minutes is reduced by 30%.
    excess_fire               = {  94637, 438595, 1 }, -- Reaching maximum stacks of Fire Mastery causes your next Fire Blast to explode in a Frostfire Burst, dealing 15,002 Frostfire damage to nearby enemies. Damage reduced beyond 8 targets. Frostfire Burst, reduces the cooldown of Phoenix Flames by 10 sec.
    excess_frost              = {  94639, 438600, 1 }, -- Reaching maximum stacks of Frost Mastery causes your next Phoenix Flames to also cast Ice Nova at 125% effectiveness. When you consume Excess Frost, the cooldown of Meteor is reduced by 5 sec.
    flame_and_frost           = {  94633, 431112, 1 }, -- Cauterize resets the cooldown of your Frost spells with a base cooldown shorter than 4 minutes when it activates.
    flash_freezeburn          = {  94635, 431178, 1 }, -- Frostfire Empowerment grants you maximum benefit of Frostfire Mastery and refreshes its duration. Activating Combustion or Icy Veins grants you Frostfire Empowerment.
    frostfire_bolt            = {  94641, 431044, 1 }, -- Launches a bolt of frostfire at the enemy, causing 16,503 Frostfire damage, slowing movement speed by 60%, and causing an additional 5,608 Frostfire damage over until canceled. Frostfire Bolt generates stacks for both Fire Mastery and Frost Mastery.
    frostfire_empowerment     = {  94632, 431176, 1 }, -- Your Frost and Fire spells have a chance to activate Frostfire Empowerment, causing your next Frostfire Bolt to be instant cast, deal 60% increased damage, explode for 80% of its damage to nearby enemies, and grant you maximum benefit of Frostfire Mastery and refresh its duration.
    frostfire_infusion        = {  94634, 431166, 1 }, -- Your Frost and Fire spells have a chance to trigger an additional bolt of Frostfire, dealing 5,400 damage. This effect generates Frostfire Mastery when activated.
    frostfire_mastery         = {  94636, 431038, 1, "frostfire" }, -- Your damaging Fire spells generate 1 stack of Fire Mastery and Frost spells generate 1 stack of Frost Mastery. Fire Mastery increases your haste by 1%, and Frost Mastery increases your Mastery by 2% for 14 sec, stacking up to 6 times each. Adding stacks does not refresh duration.
    imbued_warding            = {  94642, 431066, 1 }, -- Blazing Barrier also casts an Ice Barrier at 25% effectiveness.
    isothermic_core           = {  94638, 431095, 1 }, -- Comet Storm now also calls down a Meteor at 100% effectiveness onto your target's location. Meteor now also calls down a Comet Storm at 150% effectiveness onto your target location.
    meltdown                  = {  94642, 431131, 1 }, -- You melt slightly out of your Ice Block and Ice Cold, allowing you to move slowly during Ice Block and increasing your movement speed over time. Ice Block and Ice Cold trigger a Blazing Barrier when they end.
    severe_temperatures       = {  94640, 431189, 1 }, -- Casting damaging Frost or Fire spells has a high chance to increase the damage of your next Frostfire Bolt by 10%, stacking up to 5 times.
    thermal_conditioning      = {  94640, 431117, 1 }, -- Frostfire Bolt's cast time is reduced by 10%.
} )


-- PvP Talents
spec:RegisterPvpTalents( {
    ethereal_blink             = 5602, -- (410939) Blink and Shimmer apply Slow at 100% effectiveness to all enemies you Blink through. For each enemy you Blink through, the cooldown of Blink and Shimmer are reduced by 1 sec, up to 5 sec.
    fireheart                  = 5656, -- (460942)
    glass_cannon               = 5495, -- (390428)
    greater_pyroblast          =  648, -- (203286) Hurls an immense fiery boulder that deals up to 30% of the target's total health in Fire damage.
    ice_wall                   = 5489, -- (352278) Conjures an Ice Wall 30 yards long that obstructs line of sight. The wall has 40% of your maximum health and lasts up to 15 sec.
    improved_mass_invisibility = 5621, -- (415945) The cooldown of Mass Invisibility is reduced by 4 min and can affect allies in combat.
    master_shepherd            = 5588, -- (410248) While an enemy player is affected by your Polymorph or Mass Polymorph, your movement speed is increased by 25% and your Versatility is increased by 12%. Additionally, Polymorph and Mass Polymorph no longer heal enemies.
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
            return talent.improved_combustion.enabled and 12 or 10 + ( talent.savor_the_moment.enabled and buff.spellfire_spheres.stacks * 0.5 or 0 )
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
        id = 468655,
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
        max_stack = 3
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

    -- Sunfury
	-- Spellfire Spheres actual buff
	-- Spellfire Spheres has two diffrent counter. 449400 for create a Sphere, 448604 is Sphere number
	-- https://www.wowhead.com/spell=449400/spellfire-spheres
    burden_of_power = {
        id = 451049,
        duration = 12,
        max_stack = 1
    },
    glorious_incandescence = {
        id = 451073,
        duration = 12,
        max_stack = 1
    },
    lingering_embers = {
        id = 461145,
        duration = 10,
        max_stack = 15
    },
    next_blast_spheres = {
        id = 449400,
        duration = 30,
        max_stack = 5,
    },
    spellfire_spheres = {
        id = 448604,
        duration = 3600,
        max_stack = function() return 3 + ( talent.rondurmancy.enabled and 2 or 0 ) end,
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

local TriggerHyperthermia = setfenv( function()
    applyBuff( "hyperthermia", 2 + ( buff.lingering_embers.stacks ) )
end, state )

spec:RegisterHook( "reset_precast", function ()


    if buff.combustion.up and talent.memory_of_alar.enabled then
        state:QueueAuraEvent( "combustion", TriggerHyperthermia, buff.combustion.expires, "AURA_EXPIRATION" )
    end

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
            if talent.excess_fire.enabled and buff.fire_mastery.stack_pct == 100 then applyBuff( "excess_fire" ) end
        end
        if ability.school == "frost" or ability.school == "frostfire" then
            if buff.frost_mastery.up then buff.frost_mastery.stack = buff.frost_mastery.stack + 1
            else applyBuff( "frost_mastery" ) end
            if talent.excess_frost.enabled and buff.frost_mastery.stack_pct == 100 then applyBuff( "excess_frost" ) end
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
        usable = function () return target.maxR < 8, "target must be in range" end,
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

        toggle = "interrupts",
        debuff = function () return talent.alexstraszas_fury.disabled and not target.is_boss and "casting" or nil end,
        readyTime = function () return talent.alexstraszas_fury.disabled and not target.is_boss and state.timeToInterrupt( gcd.max ) or nil end,

        usable = function () return target.maxR < 12 and ( not target.is_boss or talent.alexstraszas_fury.enabled ), "target must be within 12 yds" end,
        handler = function ()
            if not target.is_boss then interrupt() end
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

            if buff.glorious_incandescence.up then
                removeBuff( "glorious_incandescence" )
                reduceCooldown( "fire_blast" , 4)
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
        velocity = 45,

        usable = function ()
            if moving and settings.prevent_hardcasts and action.fireball.cast > buff.ice_floes.remains then return false, "prevent_hardcasts during movement and ice_floes is down" end
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

        copy = { 133, "frostfire_bolt", 431044 , 468655 }
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

        usable = function () return not moving or action.flamestrike.cast > buff.ice_floes.remains or buff.hot_streak.up or buff.firestorm.up or buff.hyperthermia.up end,
        handler = function ()
            removeStack( "sparking_cinders" )
            if buff.majesty_of_the_phoenix.up then removeStack( "majesty_of_the_phoenix" ) end

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
                        if talent.spellfire_spheres.enabled then
                            if buff.next_blast_spheres.stacks == 5 then
                                removeBuff( "next_blast_spheres" )
                                addStack( "spellfire_spheres" )
                                applyBuff( "burden_of_power" )
                            else addStack( "next_blast_spheres" )
                            end
                        end
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

            if buff.burden_of_power.up then 
                removeBuff( "burden_of_power" )
                applyBuff( "glorious_incandescence" )
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

    greater_invisibility = {
        id = 110959,
        cast = 0,
        cooldown = 120,
        gcd = "spell",

        toggle = "defensives",
        defensive = true,

        startsCombat = false,
        texture = 575584,

        handler = function ()
            applyBuff( "greater_invisibility" )
            if conduit.incantation_of_swiftness.enabled or talent.incantation_of_swiftness.enabled then applyBuff( "incantation_of_swiftness" ) end
        end,
    },

    -- Talent: Encases you in a block of ice, protecting you from all attacks and damage for 10 sec, but during that time you cannot attack, move, or cast spells. While inside Ice Block, you heal for 40% of your maximum health over the duration. Causes Hypothermia, preventing you from recasting Ice Block for 30 sec.
    ice_block = {
        id = 45438,
        cast = 0,
        cooldown = function () return 240 + ( conduit.winters_protection.mod * 0.001 ) - 30 * talent.winters_protection.rank end,
        gcd = "spell",
        school = "frost",

        talent = "ice_block",
        notalent = "ice_cold",
        startsCombat = false,
        nodebuff = "hypothermia",
        toggle = "defensives",

        handler = function ()
            applyBuff( "ice_block" )
            applyDebuff( "player", "hypothermia" )
        end,
    },

    -- Talent: Ice Block now reduces all damage taken by $414658s8% for $414658d but no longer grants Immunity, prevents movement, attacks, or casting spells. Does not incur the Global Cooldown.
    ice_cold = {
        id = 414658,
        known = 45438,
        cast = 0,
        cooldown = function () return 240 + ( conduit.winters_protection.mod * 0.001 ) - 30 * talent.winters_protection.rank end,
        gcd = "spell",
        school = "frost",

        talent = "ice_cold",
        startsCombat = false,
        nodebuff = "hypothermia",
        toggle = "defensives",

        handler = function ()
            applyBuff( "ice_cold" )
            applyDebuff( "player", "hypothermia" )
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
                if moving and settings.prevent_hardcasts and action.fireball.cast > buff.ice_floes.remains then return false, "prevent_hardcasts during movement and ice_floes is down" end
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
                        if talent.spellfire_spheres.enabled then
                            if buff.next_blast_spheres.stacks == 5 then
                                removeBuff( "next_blast_spheres" )
                                addStack( "spellfire_spheres" )
                                applyBuff( "burden_of_power" )
                            else addStack( "next_blast_spheres" )
                            end
                        end
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
            if buff.burden_of_power.up then 
                removeBuff( "burden_of_power" )
                applyBuff( "glorious_incandescence" )
            end
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

    -- Talent: Steals a beneficial magic effect from the target. This effect lasts a maximum of 2 min.
    spellsteal = {
        id = 30449,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "arcane",

        spend = 0.21,
        spendType = "mana",

        talent = "spellsteal",
        startsCombat = true,
        debuff = "stealable_magic",

        handler = function ()
            applyBuff( "time_warp" )
            applyDebuff( "player", "temporal_displacement" )
        end,
    },

    -- Talent: Pulses arcane energy around the target enemy or ally, dealing 748 Arcane damage to all enemies within 8 yards, and knocking them upward. A primary enemy target will take 100% increased damage.
    supernova = {
        id = function() return talent.gravity_lapse.enabled and 449700 or 157980 end,
        cast = 0,
        cooldown = function() return talent.gravity_lapse.enabled and 30 or 45 end,
        gcd = "spell",
        school = "arcane",

        talent = "supernova",
        startsCombat = false,
    
        toggle = "interrupts",
        debuff = function () return talent.unerring_proficiency.disabled and not target.is_boss and "casting" or nil end,
        readyTime = function () return talent.unerring_proficiency.disabled and not target.is_boss and state.timeToInterrupt( gcd.max ) or nil end,

        usable = function () return ( not target.is_boss or talent.unerring_proficiency.enabled ) end,
        handler = function ()
            if not target.is_boss then interrupt() end
            if talent.gravity_lapse.enabled then
                applyDebuff( "target", "gravity_lapse" )
                return
            end

            applyDebuff( "target", "supernova" )
        end,

        copy = { 157980, "gravity_lapse", 449700 }
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
            hot_streak( buff.heat_shimmer.up or target.health_pct < ( talent.sunfury_execution.enabled and 35 or 30 ) )
            applyDebuff( "target", "ignite" )
            if talent.from_the_ashes.enabled then reduceCooldown( "phoenix_flames", 1 ) end
            if talent.unleashed_inferno.enabled and buff.combustion.up then reduceCooldown( "combustion", 1.25 ) end
            if target.health.pct < 30 or buff.heat_shimmer.up then
                if talent.frenetic_speed.enabled then applyBuff( "frenetic_speed" ) end
                if talent.improved_scorch.enabled then applyDebuff( "target", "improved_scorch", nil, debuff.improved_scorch.stack + 1 ) end
            end
            removeBuff( "heat_shimmer" )
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
        toggle = "cooldowns",

        spend = 0.05,
        spendType = "mana",

        startsCombat = true,

        toggle = "cooldowns",

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

    potion = "tempered_potion",

    package = "Fire",
} )

spec:RegisterSetting( "pyroblast_pull", false, {
    name = strformat( "%s: Non-Instant Opener", Hekili:GetSpellLinkWithTexture( spec.abilities.pyroblast.id ) ),
    desc = strformat( "If checked, a non-instant %s may be recommended as an opener against bosses.", Hekili:GetSpellLinkWithTexture( spec.abilities.pyroblast.id ) ),
    type = "toggle",
    width = "full"
} )

spec:RegisterSetting( "prevent_hardcasts", false, {
    name = strformat( "%s and %s: Instant-Only When Moving", Hekili:GetSpellLinkWithTexture( spec.abilities.pyroblast.id ), Hekili:GetSpellLinkWithTexture( spec.abilities.fireball.id ) ),
    desc = function()
        return strformat( "If checked, non-instant %s and %s casts will not be recommended while you are moving.\n\nAn exception is made if %s is talented and active and your cast " ..
                          "would be complete before %s expires.",
                          Hekili:GetSpellLinkWithTexture( spec.abilities.pyroblast.id ),
                          Hekili:GetSpellLinkWithTexture( spec.abilities.fireball.id ),
                          Hekili:GetSpellLinkWithTexture( class.auras.ice_floes.id ),
                          Hekili:GetSpellLinkWithTexture( class.auras.ice_floes.id ) )
    end,
    type = "toggle",
    width = "full"
} )

spec:RegisterStateExpr( "fireball_hardcast_prevented", function()
    return settings.prevent_hardcasts and moving and action.fireball.cast > 0 and buff.ice_floes.down
end )

spec:RegisterSetting( "check_explosion_range", true, {
    name = strformat( "%s: Range Check", Hekili:GetSpellLinkWithTexture( 1449 ) ),
    desc = strformat( "If checked, %s will not be recommended when you are more than 10 yards from your target.", Hekili:GetSpellLinkWithTexture( 1449 ) ),
    type = "toggle",
    width = "full"
} )

spec:RegisterPack( "Fire", 20241102, [[Hekili:T3tAZTXXX(BHvkdbiscdakQi5IKVs2ojkoxUcDE(BeCjWcI9Pfyr2dsPuSWV9x3Z9rpZUGeu2kjFiXuyNTNz6PV7E69QXx9txD58K60R(Rtgn5vJhpAYWjJg)MtU6Y6pTj9Ql3Km7dj3c)X6KvW))VpRK9JFkVizo(UvfnLZGFAzD9MQV5R)6BZQx2CZWzfR(6QSvn5j1zfRNvMSOg)3Z(6RU8MMS86)46RUHCIN8MRUmPPEzr5vxEz2QVdGC285P8HNwn7QlXHF8O3C84tpA71JE7XJEl))oEK4)k(9jte)338nBVgb12RB2GZ42Fy7pWbYV94jVfE4pTmD71)Csj8)bR(S1xDzEwvDfU9G9Xnnv4EyAD2QS13c)4FLH0sxNCtE68R(2RUSydGhsRHf(mCKxD5DjLz4t5l5YSn8F(9P5BsHzr(4TxxVmPE71ZkwxNKTUc)3WpcqPjjF71PW8UcwVZHFpBLA0SXSo9JWF(DQv32RVplhENBGNvMMm)tdXvrEtkUfkYNxC)6H69YWY0v4eon9JBsNbZWvx2uLoTyXIP3oBoUbXTWu(rUbkGbzerKYFH7xMLNoDwc8uaZaVwnCA(iroSdbeuYDBXcXETAtkU147E92CtzkF4zRRlmXf6ToFkhUaiAVjjpFio(PCO)YTx3NHQZUlDA660vzPa()m9HJb6A6ICatuvxM9b4nhS96d5VjcA9tAh6xCE3a)X0dJbFXjxhpWe4OwoYoP7hz(ZkdrtTCnjw0lo8FpTUyQEGHxxVYzDrooBQOVpnp5t2mglkawoq(dY5HIVQQtkz)JM15Pvvg46f6NAS(acmyqa(yihZSk5JaoUmdgvwcSHsYtxxB(Udfl5Tx3B71h0k8virtqe8y2)ijkUfWINUxWInRRZagVl)tFlhFWoD3E98Msacwi2yyPQM1t)a8cvtVbX9WFzHSmXaCMh2pFtZIfdx0u(jatmfejmvcMHOCnf(RVyKetcSAMcaE2hymxHgLyedK8VNW(daZJVp877JtJxVxony00)H8K5zj1fLWXX3Mm)20J000zOOYIM85CzLZrqGi58I13I0(GWuamtgHe2G6N5v0e3P)ZMSnBsNp8w1Cn9gCQyNlknlUpvs(YW24KykxLscGRQQqaCFCc8BjK2X22DrAxmXyTDOjyHm)jq)lsYdNxlWZSxuH2OmmevHalXiF9vMJ7T3S7ux)9KmGU43DhWEwb2cfua685OM4K7Xtvu1mWCG)(QIYu2tRS1qNZunBtUn(un5gZQRQuKUa2uWlNuMU(f1OLnZaky4iihwgfBqtGYrD8Wiq4c7J0aeRLWozAkUrgIRNHPFeTIJrP6(OzfWHbxH8jKdaKRLW39xGRBfU3DCzR3hKKVTthB(WvPOMejCxt(60sgpNbQiUQAgRknmO2Q(yfRxGj)8GqaSztCsX3LFFYNqocKmX2u36LWgraPS8S6pXNdGHI9YGGWI7sllZMJ0MR)Kqaial0WEuoyYnfOYf0WXvjOzxvniDmk2820A(KcdBzAz6W2p)gpA)Da225ZHgYDnecOjy56UgZK9c)XOHVI9sJgoH9Sy2RmWCeGYX55wAOHhF25rLKV96hEOLbCbQM)2Lklzf6iE0MwArb9pQsd6Ge()KyoPaxLsY1f1CnLspI40gZ5sd5UHmBz68ggIOyDkx6h5deGCzcO5eMjUczpfU40TGj8KbegobMEUQ4wi4QTnYFjitKYVuluZFdMMsngqjUUAP2mborpN9Ye1jhtXAuOS7iXnM0NvZ3I7DwYAj6vmAWiYg4P)jG0c139TcRVqh6kMnuZLmdK3pL)pMISTMmjbubYOUuemvF4MPA2cKW8MIQkHHMwuGNXPaXzX3hkfgJY72WlwdGj8dKZxvr5XLemgEc6C89hxyJCrBWXv1rgocxvSkfJFXTAAl2uNuZ(Tm0dMW4qoFruZTB20YamphmCho67WSbIDinLXUPpwaznJSn0K6i)m3PkQB3irHjwMWnZFPqr9Fkyjg5n7TXnhqkolnh0ocYXXv0anj2MpvwCdADgLVHDyR)0olqonPFXzRao(7sNpTAwr5SLME8DadB0nNgLk0C33A1wg8xIibr5j2(CVRNr(EJYVdV1Kpd)6cdU77tqRKVljlhbXrS4IHYw)9Lfv1iqatNwTP4(0YvPRzsdKI4)9IzaxGRnLFZGOAk2fPdY5CAQEkrd66Spi6zAzrn4BoOs)dtzr6RAAggsmU(qLiGGRNOgBCM697RczNGAl9JPZA4cg7r)SulfeTfroolOBehjNfNN(eMhfZm9e5(4NWmzgOt6nL3aEcZgOhlTOCObHqVGpBhNLirXjOZ8u2czyf0s0mpMvC6ysJCw5RkW)Er26SQLmZdlLJ(VW2eIXDtrtn3EZCWAPHuEegjKSThMFgMzmnFKNty)V6KtWmag4sxLXmRDz2SLCHjOvBSTjAjBg(Evmh45yeB7xtKmKKokP0kTSiDD2hfQMDwsxYf0je1GiYFKpCy1Wgpm5WIzjqnKIRQnLzfLmNcZy28Rp8ehvmngiC4PoaShf15oKkGLOejMGUQnOZGvuQEKlEGRUOCT1iyO7LPmlWM2SborGDSufh)HkXFgpuRjVAkBPXfTo21c)2KT23oa06ddo3whuWoqUyTII9uMuLPBaAoPyG(r1PBWB7l)fF48u2E299nTw6voHJTDJM4kjAtE5GamgHoMepjQERd9p6frxM7EoUlm3BJ4Exdwhfw8KgX7WFyXs2uLGHNLh0oqCvnisjPCUjFaJuY1tM2iLijI6gPXSLjL3IuYL8Tc6OiSNNm80)lLZVEPC(P3zsZCKu4zcM7NBBYtkTfTYsswb(xOi1ff55f3ZuLnoKZUGXOGX6tXDRNLNb8TI)uHQLLFAtAjgvJv4RzRWMb6eW5)Tx)(FIhTh7uxXwzUE(L0QB4cvrVhJNXLSJWkDsWmntqQqsRnAOJG5aehUEm11KgJ0QkOAGzEsW9yLoclqA4AfIgBXlsNvtaxrh3I)y(ykktzObTRRxAqdgSDhYUmCSq6cPw7aOWUuTa706011Potp(7b2fJkMqfGnEq1QqdDQybdhhIXsPR8DggLSBX0ikvNtSyAzsIhbeg(Z1Q5N5n3JETsF8pX14y3LFaNUBrBJ8jPFetS2uguSObndkYexlm9SiEhm2fxah2I6ovaHOm5nK7b4c11(f9cnsCL63U5cNfWCHDN5NkiqtCvg6kLdWEtRwMTAvAP8a0isyZsYNRr5gMW7UDCSFFpT4dPVmQ3BSCY47Wgk26sHix0nntLNOfeltZ3GjJdZXxDQRkxUTigMViDaLLPbvuY4UCVovMph0PDWN1Q0Y7y(P66PKaBYIMVhpTPJFLj3bMUOYyQRiERyA0V7WniC4uLQG8gU4vGb(g2P(aswsXO6cxj7eVfv77UiPaID6EWydlo24FHQze8VKeYmdc8wiglawo2eCnY82qKHTWltehyAs2tTOKUqra0LaEQiucG4SOFXbFqNcgaxyKkstIiXPZXw8Y8H9((zEl6BmWk898jmwE4MxMClWFp9gGCREPJKOFMLaY3LN(rGCmP6FLG5FKB6exEIBc24ctyubG)pFpd2SCwYGovSarHmGaM7adEbrwPImV9p2WFsILymQ4nLOxCc1GoiF3tvvCWdyaGJVUP4Poi95MMsnnQGNHxGoQxiIp5d48hZtxK0Kx3AQN5hovdXOJcR8K6dp)Rnu1Cu2IZTvqDX5kIcdXuwMksbtT1ugH0TznGHzs4OOB0haAoGM1yPJaYlHn)ISzzPRNPogmKM0aE1SU4UeQ85sb2GhTbPEjYnPtnMTifSR)ouLRAdhlr0Z1VGm5FQTdthqDAIJyWiPjtP9B0WtJzQMR3xeL9T2eKAwv2lpF5fSJUelQeo4KSboB(iR64LKV(CW(CNmJoQQlkvaADZQBWYIa9lsvygIc1RMbr02KiIOIwWc0fuaFlsLQmh1jBk4S4M1IwuPLhsiFq8YghqmO(4sYqBv2Js1ayc7cMnhmRc0LVzOunWYtP8cpWTVJxVkxkaeycjcjZlaa)m1QkACR6hRuryVMMYFX2QKR2Xj9BtLSXZHtFmgDZAQlwSOD10bkLfU0EfUgOzwnD28PJh)QX6xxjhhn)eeN9H06H1JhUee(ORcQEwptbrs1ZoRD(1GWe4tIa8j7mWVGvdBdmpa5Bu2qMYvyqMueTiTpTcugas)NEF6nurFlaAxKQmFtvEZi2ksqozdEQyQ7lPZ4wgb02Wg8VT(yMds4ERswJuGW4zzyuYzL(ixErLCErLHG4WYIMQPG6K1vRYQRXYUFgrS6PPhhpQ96HYqKEOzmwWDbthslxKoREAs1S01ZtaLOtb)UAwTll0tKB6iGlwGCDRJ8op3xi1azqpdgPFQC94b44Xb1mjjeuXQ1lYdWOeiJiAxVkv)iSK3YkUJvSIF1Xnz4)Tbo4ZysEzr7N6Utf0qt(KBKRNHu53HlBOnTvcy5OTyrdOiTeu4lSb4LMscBriot2XxBiD0yDQLGEmt4Yz0dd9ltSLylsTqkWSEmVwt1dUQBtgLH7QN3kaGD02R)k2sUx7kBS4LJDhg8Zwx4RIvKqO)y9hv69rB7hQavzEV24((3s1p0gq2DR44vDlvu7Fcf)DhsMARUPhSsQ5oXnvuCoMHf1NLwWcYzdMQCq06gr5i15DZ))Ay3Etup3DoM2HxX1YI8kN6hrKYr034QeCXylQIHfb9KPj8eS9tfnSWfwj9kxQWKSIIh2cXEhYyaL8V2txDBHy2oYvh6MFBBk7dILNbTh(HJ)p)NnZbN5wrX4y732qLaqKdEmFF1gt2KrwrRXwunzgoIADT8OtUYucPO8Uog)quNo0uMEXO2G6eCBwCbrQu1ZGiIZ4YcDeXrtQ0Jum4ZPZhIw6HfpFdz0WlAQ15NZhgi3OX0QQIZIBW7noo5Yuqh2lOo5Rsehi52)WoNfKRoumuImommbMfCFoSdyxvvU7LevRb2HkHATvNnDqfqBwUoImNpwPEfoKMZlms3eWEqWRHByrm9PZ9NHMLwko0ryPaXeXqvQqNZYryKc3my9T8Zm2N3dBwbYwYYXd8OR(g645gkhuSOjXeo8XAEw4ttZfSGFlgF1wYtzqnmbW)TES3rJymaVPLSKPNKMA1wV)Df4nVBwYMnzYRcUUarLYSeQYH)961PCkzNq7qFCQrx0YiSRf5(CzLUIHolKeM6SzFWucthLa0JMEFazss7OLYxeRs3bTKaf7SAlQ(OhYY6(BAzrnpaGuPZtcQSzPtzXY25oimdqE)v4336EZbK6Bwbg4WVUbCnvuMQzKfLHos6injDhtiih)Om6qMKVAwX9GJlrNHc5OskH9d4Q966088uaVAhZ7G9WezgpU8y6AJ0K1YrxZixRrP6ee2mw)4FE71AZv(BSFM1UAqSQ2cBw0IwKzf204XbNORnmmseoBLJGkfiDY0o6S7qIAdLiiEb18urCEjdOgfFWcxsTQ03ne)BPhjMbCUiFTTyVswrNc07)SbegX2AKv4b)(nTjP2P6oatSE7BFRewheF8w2TqnHdOs6u3okPSOG(KK22JpNhKScI(7yAOEKNJ84OTideFuQptHtcvM12veOrSfAddsp0pVOWW8cQlccvLX(La9)oe3v9XN7flL6CZRGh)mEGzFgfSYfQAqdMcvpP6tVt(v7Phv)DP1tpHbbPFCtErf36k)Jp3b9z987DSjF71)o9S3zHvEcOCdzjIJatb2vS00vjRtmSk6v7lKXM0YzWHml8l4MdNhC7KxCFmecp3WQE5aFRVRj6MqEStKSArKS9O3rIKoqj4LsCMT5TlWvC2tMI7oC4BSdnVrLgh)JgEYUSp5(MXbdBrJhHjBf9nc)65WXfemdQQMxfvEG74(IkRoMBQoVL6o)TQstW)HL)Y(9Kdz4f3KOcUUyTbiRvy5nnKm3ZTx4cVMkb16WYHRTWnRJq1yHrHkqMF42xwWoXaGbY98uLVDmIrYKa3s6YLlGyz3ENmKJT6J0X0q1HQhhywDg1QII15z1WUnRALZZYW2Budluz3YDb36XvBkYYRWmgSonhiRkBQCxca)3nSLbkScuRkJaIAellkxJqa2By)y1n0ACxntybkNrZJPU20Ec0vD)QQub(asx41cYUMbCdgAZAjPnH1IjZEV9Eund27Y0LxeL6vr1TujzBH)9T3kqjvagpLfwS60BlqRP0fsaJ7IJ80GWsR1)JIEAYiD6xLB6vzLLfLtZwXAmVMrUOoC09iksZoeCVFwe2ov0tZKTscmBh)OSGlpQ7v96bTfNVoea8OrIwePpzvD7hV5lCUeL7WT8ChVClNlZzF)yLghRrAAe8BzTpPsAUDv7ALXn3oujrWR2jmR7USJ3xaZnQ0cERfTPn8TSN8oBAbZXpEuPOMOtIrrVzhNZfc(pfDEY6pX6KshjYyNTs6cdEDtsBzhYcVUPojdGl6JJBuLIQOtHX7cKBTlLX)W39982bgNvJDdwDn8JLiC5DDz4vUngmDNRYn(NIAaLiQNYrCtErXCw2SCgvlxGjRc8WaCPLvPLy0dvbyY8uHnBotKv5jJ3NxmhB5tN5Dtn88xpqjAPagrXBvtfX8Ox4dESQdLETabR0mxz2YUum7E3DxZ2xKr8fIYPhq6OQwcIDTDIuVah0kZyVUurbsHfHsaG8Hgxox9D0bevb6RaILjV07g(Ohfrwab1ISEvVmcvGVKhHrWRAPi39Mz3ByCs9Gx0A9Xy4KKA2Wp0I9cP2IlyBqBGoQ4z8vPsQOraAA9QPj1qg4qn(cmWXCO2sw4uOfLRB3UpXTEXF76L41HRmCvGg5IP2wjdDgHjk21q0P2Mc0LT(bUvEKIK5k)8P1w)s75fhBrE4gHVousfbsPE)27FjMPeEd(HAyDk6ZMHEoZ4zgDZAw3v9JyRAMoB2TAmRzXtOdoAGU1q726AnRXBFySPn4fnvuzA481pMy(hD10jSm98GdW46vYK)rxxaNS15kY5xdlESjonGMWEJCqqygeG83kQ0Coo)XuomFVzvIP7mqsdEosA)QRjVvgn5SpT14IwFtkdEwLaNvSHaVa9mFonJ77RmwLjA3k)ALhL2Hb0YNsZY)SWaocQlvnHAvkcdPc79xIcocqq1215w5EMHrv26Y5RyIgIYato5(6fbZO98MkLLJb6ZtJfckcwFxIwbvh83vjQJIB(LwD9AU(W29D8mslEnR9(qs36edir2h2xgee5cU7fJFxL1789236jDQvI4fpEx3t(1CRUWlC6wcfEKMHBYgs7EJInZLGtjbWDQ5pyGdxABlJGTCfBBY9UkVr6Lx7u)V2lw9rSWxI0ATABvlg)RrDKRMvyRt0(Z4sPoGKKjSbYE7jtVw8ZQCpEcphUb7gKrhRibSYfJxwSvHoM4iZIdGOpjKUUOb7FzIuqEeVF5Zu(cYEsW0VXQzGeNQOzRrLXWA8u1GSwDQUyMXktxg()M1uwchSODhRtVJhu8gaknIWhpEKDNjokYKUkKq0WB8I5evl)W4gYte9h5Rdee51lRQlw7I6mVs(6LmF88Zt(DRmA0B8hUAMXc1e07o7dXJpHhe4IgV92Yc2FvvKxyepmKpjTeKrCxwvg)dQrC3WDG)RDwHZaLUXDf2dawM3iHbrN3w9i3W5Z8612li1y1Qi0RtRKOe192FPwRmGbNyMkyxLuHbTSSmJNHYWxlVihrWYbuGofy84PzlCBiWbiVXOcLbZB(xOYjXIXPmCDEkJ5cyVa2BMCj(38XrtMC1L3NuIz)VsK)zq7EbMfjMReVWqHn)wq)cmoE)ZMmwU1WV3bavDtDH4ZKiwD5G1Ld3(d)zwll(vFd6mclVu4JFHm1eAB6FbxgdXtKheWi6p(JduW8uAy6xCSoGoC1Z6odJh9mSSdb0pi(kV4aXp48XFrdUT)q8Zj29IC3oME(rPbMbEvMP)Mb4IwDE8UIB9AE0UR)qnx6Uob29IphOt3O(8a94NDK)4aSHMEC5aCQ4x5c2jbw57bKYKtcGuqNsCXdMoQ0va54dJdid4HJhWdGxPcLVZmelA)F2Ngsjk2(mSBYtE(jPNqpdjU(M4mbEpVJidrbFTByHaRrQUBLZYmwdWYfteGaFpGjcj6t0szSBLnkWt3PB2bO62NAiGmXqEoHE7WDsCCH3J72Q1VN9qa5hnU4XbDnCFTnCl2KYdzxfVYqFbZivNRjwpU5PX7Djh2x5nP)907qbeIEtLFPoJKTClLh8vX68hhp(Sw6pjhQMjQQynoW77HHepj6Rn4R(QX9IGGoZ6ovlps)Y4W4RFopmId8GhgrFTb70zHM35np)kidzs8)wmf7nTBbn0CFShinLqv307fJj2lRZOgsOVMpoq2)()0riAC1IEbL)Ewx6OFbH5tyNhWD39peFs77pJW8jSZF9Nli(K23FgH5JANtklYiSvMAk3lsMSYHS7ENQ0KBzTQtmWUT8cqqkd3RZkZnkWD8izNHg5w0Ray3TDAaXy7TWeWNLFBafrKvyHZ8eVmm64m9eJAvitV2)R)Gr2BxdIviaTxcIvOGdM80nXA7p8hz03iyF7wRokns1Y651ZU6V(6tWofsXISCvLay3wXDBwiB)HFZ2RFexdWNqZ5y7pqTWKZYryA2p3uAQM64irSJo)4XhXUsrNlpY9Smd7d7wv0Kp0oB0JDZx3LB26EPbB0fCfD95BHaOhY5JeyXx9Y(EQ9E4bFLRdo8TV9TVS)b(pP3bEayWZl2Dp31l6eIMkF824zQrOqZyZb4zfN8yBJfDzZtxUrw7E6H8Lmv2(Ppt0f0Rt5(BHxDEMcHEYxEi0NuJFOl4r3QgYcr6(W9gN5ESfp8y2KSkNsPC8vJoQyZ5SMfqlBQoCGTJ9NHUS6netyhfZqctSh1oCOb)R9yFzyh3BM9vc1zZOHN01dNUZOTN7adDzFsfuy9M0El(yBfdDzDy2IgeKfVUlVx36edcioEcniBen4(OGKHc2d9xGUSRmO(4TcaXgiyFC4HhARhoymcR(3GXV727gmEerFBWCk97zdgp1QFnWWI)Y3jd6YHGvhBqCamzuizB8rtdxZQ6JHaOgKJrdIsnOZF7Pcbw11LcD9uma4Nn)euz(7QpGu4AqAubvQ3nFj7sB28n9CiMTo11JQ1sYPAT5NcZjhR(ddfaq9ohEclHt3NuUXC421moUaXHDgEFmuc2molR)s7Z9u7Or)DNj6HDX7r0clHFoFHNUiYmFyOmeYWRFg(ukzUnC0O0sIvfC0r2Cxe(E6WRC2GZDM3xtfXSflXXNPEMLKNhEWfhlM(lS8RqI47DGUsFj(emnOx)(0fRsVW1dsGv2Gd7txRh9cxofHa1fJhyIoT1iB)rncPt9YmTeNmEupR8lF2BgnqZJ)e(qhfE1fqHRLIcIt7XJGt2IQkN17KtDLOnVyAiRCQtQ(Wrg33RZhRyInWnnBE4bNjzu4Tt4pQrTTJojmqDTxPfqP48o(ukyYKGFG69952yN4pLp4qKS22iAVRPj8BQqEo16Axky()YOEt(38I)zNuvYkB82i7pFKViAKLRtI6nNmJV8p9uByFzCT(YC)r)v3h(MNfEkYBjhbtL)vZ9ItKTQfBPj(tvVGjNWYKuVqGqYV3)a67x7dpe)Y1EH64vXW78H5P3b8RojDlVyG4Xwxq0EexYy2Iur(r3zvo78Xp8qms0jcTU)N431MWMf68ndY0rjIeF1UfJbT((4tptqK06NdNddDuRG1(v)s3LuRIaUpUzqV4oy(l7xyftcaT0KoiQRn5qXSyAupUCeQigqLmREhyE)SeYnPer039wFd)Mu(QgCUnJf03AqeHNPmxC(KbTRcoqn4euOkXwjkUIRHCp9jIjYXnXbmn3KQxR0RVpl6z0VJ9NjMiCl98pb7WzGxH3CeEspRMVnItksDiXW57)VDlMBe5hmggJe99N3uHnBaHOPmcxM4DLx7hmGESp5)H81IZXquKPQM)ZXHgb7Px8Q4gpszWP0kbqu4DyDKLHzqmSYfdn889IsC)zrMzhxvJmYbC1)87S)70YOrdc5Px1puzoNSGu6VNfxrMrKSilgjZTyL60AxEDyKJu)yygsdtpF3uqzqeYohigQDP9HKimdqhF6GGMdoWK(ZWoF5XMoSDTomDtZS9HQAiM002Tcau(hB(ADK29otRyEe6vYwFxXhWSLcI5bvjtX1NWWkMTgzRx0itvSiqMM)Suk0tzIK8pOb2vnyR3qnz(psmHTmzXducsgal4)gpyPQ3JkJGC(bUhyuHGM3fTChjkfgwHny8USZFkQgKzRdJPum6G57diINnKCZYCIUlEBR2DueFrd6jDK0g9iwo2Yf46SiYMhUmpI1SC44jSouzTMxD8QzqsiokRooQXj3pKYxI5CxKh65(yKXgQVhE(OOXJqdAb2Z3eu3MGzmKHkJvp)OI(pgCHq5lV6BmUh(MwvrEiNXBVlb3wpgC8zt6fqdsVd6hw9VvfeP3dX3aXnyQBlFfh16cd2N7XOXQ6z0hXcbpZZkzhbB71)oDlbdz3Kca1T(Dh7jzqunfTW(12jd)apu7jd3sXZ5NQpfASNzHnlFvb(3lYwNvTehjgwd(O)lm7YeJ7MIMAUfn5Gi5wKZQ(PU5YzK2Y150MYh1hE4D6ZxDEnsYEu)EQV9KM6esQmciG49LNx(q25jpcyt0as7f4rpcO77XS5IpI70DEgeMZRoc7f437mK9cKxbwPr1y0cXQGtwGLwopxSEEgJ(CRUGvJt0AhOS6ejfLikyXKTm2NivWuEjxkIGDfzV8IfikdzjGpsX19MYSIYS6pXt4(mdwAbdmtQjVCYq0aykeRi)JRoZV2deILDB0ksPY2TdepV3XCbw77Ub)N1QM0DppevqfNFwmuXAPr1Zvn2YTjVCxcQvFDuT0NSXdVxSWGfoe6bK70AS1FLmvadIzsasagtoXac6qYqQfrI7HUN2Sic8Y(gF)jUy0GZM06H6p9oZJZJKKWjynuEBtEsPnboQLPQa)lKWErrEEX9TR0CxiciibIFmte8Wjdp9)E6lp9)o0f68eWfOTx)(FAl)JXXF6B5NLLSwjBC)FWx3W3wZ0aPSekudu3q8QD0X9RLyTqwTe2DYDO(eiXKqEAyaodWmqgvoNVnc7kCowiZYemXnA23Bg3ppd74B7N)ohfFDfCEnvzI4e76TrlONwueh6IvWJEqfRVCQsmNbu2fIL9MVHbPmC8L9r5pD3pL2B7N9(Y0ZRPqoirkfK)Bo9S5hNHuTyVuZMdJiYfCGM0MPileTFWb88UFCfoNzOWz34V64YsHbm6pW9urdaVvTkJVCwI7(c63iAM((wwJC8xYGk3EAtncOrgltZ3eolRCZvCQzlvl(xfRaUhZyA)ffFFk)ICLwExBUC4tpPUzvu397EgPw5mx5CkVW6hdcbERZELiKsHsi0zVzWapYA2tItz)8X(UleI(BydPsQ)6IZL9G2USOfHf)9ajegx870ENQkZeCIKvQTi(2Y6pEUSETf3RaQY4WSqKzgtrtmvZQo0d39kAYagmWZqcT7TlExXsNHBbDHRZm)NVHu6w5f2VydQ3j6OpXCGL8s6SN3DMvMMy)jmIwfSg1ZFz)Dt8ZazTqzg6KGqRvR7gCCBbdz)IL8JEMBrPtsLiUdfGMABcwURFlW7QK590hVlbO4eNVmi(3JEHxGPbIw6(CBwS5CSW747wZQ3qGNn0UB8uh)fj2bbWmIltHJ3run1GpV78NALcm4L9vvX4aZql5hXFIsKjSfHQ61iev2FqLMsq7mRGU1uzyd5)EDeWzMuIICXl8f7ozTeJu)KruxiZphiDL0v3CTAs8f8M21R1x)4jJIvAeTqJA(t8pbNvCx7ZQXeUck()8ITcOcNTl(7jybu97Udtv63erK085OcPewERrnuNWTABfppPZNxzROIhplBYLXNAqUG69qBozRqUDHRFrnQdh9MaqayIUl2Gk7Z52EkYquv6NBITsafnn9owHKaB0HzSQtW9xt)i2(x65(ZSlP3fNFI3duxnRXNsDq8U87t(uLO8xTnPbtI)Dn5On38pPcGWq2lZGo(90alB)sMx4SBnbJ9TIFh4y5v7MI7ezbyvc(D1qwQUOP81vYmEHb0(5hv7HJLBnGZlB9lpG(jnBCodmEM4KiUc4ZcnJA3HcytjRYkecqKS1kPLQROQYgprYwySvCZ6e3brw5CiC(H8bcqUmbeIbZexYSNKxNBx3c(NIN0plYK7ILowXnMCehszRSK94L9hFC)rdF1HJgo5L(Mtmq(BFq8DfyWzXQRXOfL3fw1EYXyTNiQe59(NQC9jtGYK1p487AHgtwhWUwT7KIYlmcsDhItENdqZ5JnkwrQpyAQYm(IXYsZG6t12zQpnVdmkcH6TFz)51(rqmyDxbJsgSZHCapRK8zMNb9ICSyr2e9GEqpKV7IrMLgPxvk7hr4GobsFt67rKUbbDLtK7hyCxdk3PVJZTS(DJmdvKtdgTg)vkRKnoikQTxBx4NX9OlO6Ehq8bJ7iXNd7ZvSCX3Wwb8MmpnYdaQBMGzkW5KuHKuHKpdObveIA8YZ667Kk(PKX5tk8JevsVairUd2p05DpHfrtPqxsta1YS1WL3s0Y9uLOcWZHNkPVIVNoqacbG1F1b7ov5ZaodDd8)G)032UmWDP6cOUnt9JPCtx(jK9V0bTeDKE97hWGiuaqB2kXVDuhqLm5OfIw)apZcWe5ka0v9Wd9PfGVZxivMvaN3233AqQP)fz6KbKxNmh(tJk3iCMdjVqAEfC4brKRpaVKkG(7uzChw1SwwkB3i4YKKYV3S2iegY1i8ZBLkORWbaqjjyvQ4rEWRTu(Lj1obopwQNa7a3e6t68dp4v5bdqYZ(8jX8d4mvnangOWjVzHtqEQigAY458jkFjZhXtFzCtppJWSkz)hGIDZ(EM0Q6Lovlg08V2Q9pRfRBFEvv3jR9EsjEST6gi(UsHu)mKy8ON9EPEM0J7w4WOm9wvNt2FLM75cE8hhWy725AJOfRs729Qjge8VkE24(lg3l8T)UBec06cLwMBtG0Y(LQrL6SEd34s7j)KkhzmSMcQX1P8xtFcK3poOqEb17Mqery2i6OCd1Dooy8gFCKXLI(tilRHlr(kQVQXD9fO(If79U9yFVJ7HFRJJmV4hibNx91HMwZUlO37i0CB99aw7SV73c4lecW12MkhXGqtUXN(3NVjVh7doCGLqPXho4UIZUX(lbSZR9gXnk4gQVMW4Nm4R())d]] )
