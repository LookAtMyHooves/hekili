-- MageArcane.lua
-- July 2024

if UnitClassBase( "player" ) ~= "MAGE" then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State

local FindUnitBuffByID, FindUnitDebuffByID = ns.FindUnitBuffByID, ns.FindUnitDebuffByID

local GetItemCooldown = GetItemCooldown
local strformat = string.format

local spec = Hekili:NewSpecialization( 62 )

spec:RegisterResource( Enum.PowerType.ArcaneCharges, {
    arcane_orb = {
        aura = "arcane_orb",

        last = function ()
            local app = state.buff.arcane_orb.applied
            local t = state.query_time

            return app + floor( ( t - app ) * 2 ) * 0.5
        end,

        interval = 0.5,
        value = function () return state.active_enemies end,
    },
} )

spec:RegisterResource( Enum.PowerType.Mana )

-- Talents
spec:RegisterTalents( {
    -- Mage
    accumulative_shielding     = {  62093, 382800, 1 }, -- Your barrier's cooldown recharges 30% faster while the shield persists.
    alter_time                 = {  62115, 342245, 1 }, -- Alters the fabric of time, returning you to your current location and health when cast a second time, or after 10 sec. Effect negated by long distance or death.
    arcane_warding             = {  62114, 383092, 2 }, -- Reduces magic damage taken by 3%.
    barrier_diffusion          = {  62091, 455428, 1 }, -- Whenever one of your Barriers is removed, reduce its cooldown by 4 sec.
    blast_wave                 = {  62103, 157981, 1 }, -- Causes an explosion around yourself, dealing 6,152 Fire damage to all enemies within 8 yds, knocking them back, and reducing movement speed by 80% for 6 sec.
    cryofreeze                 = {  62107, 382292, 2 }, -- While inside Ice Block, you heal for 40% of your maximum health over the duration.
    displacement               = {  62095, 389713, 1 }, -- Teleports you back to where you last Blinked and heals you for 119,072 health. Only usable within 8 sec of Blinking.
    diverted_energy            = {  62101, 382270, 2 }, -- Your Barriers heal you for 10% of the damage absorbed.
    dragons_breath             = { 101883,  31661, 1 }, -- Enemies in a cone in front of you take 7,585 Fire damage and are disoriented for 4 sec. Damage will cancel the effect.
    energized_barriers         = {  62100, 386828, 1 }, -- When your barrier receives melee attacks, you have a 10% chance to be granted Clearcasting. Casting your barrier removes all snare effects.
    flow_of_time               = {  62096, 382268, 2 }, -- The cooldowns of Blink and Shimmer are reduced by 2 sec.
    freezing_cold              = {  62087, 386763, 1 }, -- Enemies hit by Cone of Cold are frozen in place for 5 sec instead of snared. When your roots expire or are dispelled, your target is snared by 90%, decaying over 3 sec.
    frigid_winds               = {  62128, 235224, 2 }, -- All of your snare effects reduce the target's movement speed by an additional 10%.
    greater_invisibility       = {  93524, 110959, 1 }, -- Makes you invisible and untargetable for 20 sec, removing all threat. Any action taken cancels this effect. You take 60% reduced damage while invisible and for 3 sec after reappearing.
    ice_block                  = {  62122,  45438, 1 }, -- Encases you in a block of ice, protecting you from all attacks and damage for 10 sec, but during that time you cannot attack, move, or cast spells. While inside Ice Block, you heal for 40% of your maximum health over the duration. Causes Hypothermia, preventing you from recasting Ice Block for 30 sec.
    ice_cold                   = {  62085, 414659, 1 }, -- Ice Block now reduces all damage taken by 70% for 6 sec but no longer grants Immunity, prevents movement, attacks, or casting spells. Does not incur the Global Cooldown.
    ice_floes                  = {  62105, 108839, 1 }, -- Makes your next Mage spell with a cast time shorter than 10 sec castable while moving. Unaffected by the global cooldown and castable while casting.
    ice_nova                   = {  62088, 157997, 1 }, -- Causes a whirl of icy wind around the enemy, dealing 15,625 Frost damage to the target and all other enemies within 8 yds, freezing them in place for 2 sec. Damage reduced beyond 8 targets.
    ice_ward                   = {  62086, 205036, 1 }, -- Frost Nova now has 2 charges.
    improved_frost_nova        = {  62108, 343183, 1 }, -- Frost Nova duration is increased by 2 sec.
    incantation_of_swiftness   = {  62112, 382293, 2 }, -- Greater Invisibility increases your movement speed by 40% for 6 sec.
    incanters_flow             = {  62118,   1463, 1 }, -- Magical energy flows through you while in combat, building up to 10% increased damage and then diminishing down to 2% increased damage, cycling every 10 sec.
    inspired_intellect         = {  62094, 458437, 1 }, -- Arcane Intellect grants you an additional 3% Intellect.
    mass_barrier               = {  62092, 414660, 1 }, -- Cast Prismatic Barrier on yourself and 4 allies within 40 yds.
    mass_invisibility          = {  62092, 414664, 1 }, -- You and your allies within 40 yards instantly become invisible for 12 sec. Taking any action will cancel the effect. Does not affect allies in combat.
    mass_polymorph             = {  62106, 383121, 1 }, -- Transforms all enemies within 10 yards into sheep, wandering around incapacitated for 15 sec. While affected, the victims cannot take actions but will regenerate health very quickly. Damage will cancel the effect. Only works on Beasts, Humanoids and Critters.
    master_of_time             = {  62102, 342249, 1 }, -- Reduces the cooldown of Alter Time by 10 sec. Alter Time resets the cooldown of Blink and Shimmer when you return to your original location.
    mirror_image               = {  62124,  55342, 1 }, -- Creates 3 copies of you nearby for 40 sec, which cast spells and attack your enemies. While your images are active damage taken is reduced by 20%. Taking direct damage will cause one of your images to dissipate.
    overflowing_energy         = {  62120, 390218, 1 }, -- Your spell critical strike damage is increased by 10%. When your direct damage spells fail to critically strike a target, your spell critical strike chance is increased by 2%, up to 10% for 8 sec. When your spells critically strike Overflowing Energy is reset.
    prismatic_barrier          = {  62121, 235450, 1 }, -- Shields you with an arcane force, absorbing 127,971 damage and reducing magic damage taken by 25% for 1 min. The duration of harmful Magic effects against you is reduced by 40%.
    quick_witted               = {  62104, 382297, 1 }, -- Successfully interrupting an enemy with Counterspell reduces its cooldown by 4 sec.
    reabsorption               = {  62125, 382820, 1 }, -- You are healed for 3% of your maximum health whenever a Mirror Image dissipates due to direct damage.
    reduplication              = {  62125, 382569, 1 }, -- Mirror Image's cooldown is reduced by 10 sec whenever a Mirror Image dissipates due to direct damage.
    remove_curse               = {  62116,    475, 1 }, -- Removes all Curses from a friendly target.
    rigid_ice                  = {  62110, 382481, 1 }, -- Frost Nova can withstand 80% more damage before breaking.
    ring_of_frost              = {  62088, 113724, 1 }, -- Summons a Ring of Frost for 10 sec at the target location. Enemies entering the ring are incapacitated for 10 sec. Limit 10 targets. When the incapacitate expires, enemies are slowed by 75% for 4 sec.
    shifting_power             = {  62113, 382440, 1 }, -- Draw power from within, dealing 27,624 Arcane damage over 3.4 sec to enemies within 18 yds. While channeling, your Mage ability cooldowns are reduced by 12 sec over 3.4 sec.
    shimmer                    = {  62105, 212653, 1 }, -- Teleports you 20 yds forward, unless something is in the way. Unaffected by the global cooldown and castable while casting.
    slow                       = {  62097,  31589, 1 }, -- Reduces the target's movement speed by 60% for 15 sec.
    spellsteal                 = {  62084,  30449, 1 }, -- Steals a beneficial magic effect from the target. This effect lasts a maximum of 2 min.
    supernova                  = { 101883, 157980, 1 }, -- Pulses arcane energy around the target enemy or ally, dealing 4,752 Arcane damage to all enemies within 8 yds, and knocking them upward. A primary enemy target will take 100% increased damage.
    tempest_barrier            = {  62111, 382289, 2 }, -- Gain a shield that absorbs 3% of your maximum health for 15 sec after you Blink.
    temporal_velocity          = {  62099, 382826, 2 }, -- Increases your movement speed by 5% for 3 sec after casting Blink and 20% for 6 sec after returning from Alter Time.
    time_anomaly               = {  62094, 383243, 1 }, -- At any moment, you have a chance to gain Arcane Surge for 4 sec, Clearcasting, or Time Warp for 6 sec.
    time_manipulation          = {  62129, 387807, 1 }, -- Casting Clearcasting Arcane Missiles reduces the cooldown of your loss of control abilities by 2 sec.
    tome_of_antonidas          = {  62098, 382490, 1 }, -- Increases Haste by 2%.
    tome_of_rhonin             = {  62127, 382493, 1 }, -- Increases Critical Strike chance by 2%.
    volatile_detonation        = {  62089, 389627, 1 }, -- Greatly increases the effect of Blast Wave's knockback. Blast Wave's cooldown is reduced by 5 sec
    winters_protection         = {  62123, 382424, 2 }, -- The cooldown of Ice Block is reduced by 30 sec.

    -- Arcane
    aether_attunement          = { 102476, 453600, 1 }, -- Every 3 times you consume Clearcasting, gain Aether Attunement. Aether Attunement: Your next Arcane Missiles deals 100% increased damage to your primary target and fires at up to 4 nearby enemies dealing 50% increased damage.
    aethervision               = { 102448, 467633, 1 }, -- Consuming Nether Precision with Arcane Blast increases the damage of your next Arcane Barrage by 10% and causes it to generate 2 Arcane Charges. Stacks up to 2 times.
    amplification              = { 102445, 236628, 1 }, -- Arcane Missiles fires 3 additional missiles.
    arcane_bombardment         = { 102465, 384581, 1 }, -- Arcane Barrage deals an additional 100% damage against targets below 35% health.
    arcane_debilitation        = { 102463, 453598, 2 }, -- Damaging a target with Arcane Missiles increases the damage they take from Arcane Missiles, Arcane Barrage, and Arcane Blast by 0.0% for 6 sec. Multiple instances may overlap.
    arcane_echo                = { 102457, 342231, 1 }, -- Direct damage you deal to enemies affected by Touch of the Magi, causes an explosion that deals 1,377 Arcane damage to all nearby enemies. Deals reduced damage beyond 8 targets.
    arcane_familiar            = { 102439, 205022, 1 }, -- Casting Arcane Intellect summons a Familiar that attacks your enemies and increases your maximum mana by 10% for 1 |4hour:hrs;.
    arcane_harmony             = { 102447, 384452, 1 }, -- Each time Arcane Missiles hits an enemy, the damage of your next Arcane Barrage is increased by 5%. This effect stacks up to 20 times.
    arcane_missiles            = { 102467,   5143, 1 }, -- Only castable when you have Clearcasting. Launches five waves of Arcane Missiles at the enemy over 2.1 sec, causing a total of 39,851 Arcane damage.
    arcane_surge               = { 102449, 365350, 1 }, -- Expend all of your current mana to annihilate your enemy target and nearby enemies for up to 59,436 Arcane damage based on Mana spent. Deals reduced damage beyond 5 targets. Generates Clearcasting. For the next 15 sec, your Mana regeneration is increased by 425% and spell damage is increased by 35%.
    arcane_tempo               = { 102436, 383980, 1 }, -- Consuming Arcane Charges increases your Haste by 2% for 12 sec, stacks up to 5 times.
    arcing_cleave              = { 102458, 231564, 1 }, -- For each Arcane Charge, Arcane Barrage hits 1 additional nearby target for 40% damage.
    big_brained                = { 102446, 461261, 1 }, -- Gaining Clearcasting increases your Intellect by 1% for 8 sec. Multiple instances may overlap.
    charged_orb                = { 102466, 384651, 1 }, -- Arcane Orb gains 1 additional charge. Arcane Orb damage increased by 15%.
    concentrated_power         = { 102461, 414379, 1 }, -- Arcane Missiles channels 20% faster. Clearcasting makes Arcane Explosion echo for 40% damage.
    concentration              = { 102438, 384374, 1 }, -- Arcane Blast has a small chance to make your next cast of Arcane Blast free.
    consortiums_bauble         = { 102475, 461260, 1 }, -- Reduces Arcane Blast's mana cost by 5% and increases its damage by 8%.
    dematerialize              = { 102456, 461456, 1 }, -- Spells empowered by Nether Precision cause their target to suffer an additional 8% of the damage dealt over 6 sec.
    energized_familiar         = { 102462, 452997, 1 }, -- During Arcane Surge, your Familiar fires 4 bolts instead of 1. Damage from your Arcane Familiar has a small chance to grant you up to 2% of your maximum mana.
    energy_reconstitution      = { 102454, 461457, 1 }, -- Damage from Dematerialize has a small chance to summon an Arcane Explosion at its target's location at 50% effectiveness. Arcane Explosions summoned from Energy Reconstitution do not generate Arcane Charges.
    enlightened                = { 102470, 321387, 1 }, -- Arcane damage dealt while above 70% mana is increased by 6%, Mana Regen while below 70% is increased by 20%.
    eureka                     = { 102455, 452198, 1 }, -- When a spell consumes Clearcasting, its damage is increased by 10%.
    evocation                  = { 102459,  12051, 1 }, -- Increases your mana regeneration by 1,500% for 2.6 sec and grants Clearcasting. While channeling Evocation, your Intellect is increased by 2% every 0.4 sec. Lasts 20 sec.
    high_voltage               = { 102472, 461248, 1 }, -- Damage from Arcane Missiles has a 10% chance to grant you 1 Arcane Charge. Chance is increased by 10% every time your Arcane Missiles fails to grant you an Arcane Charge.
    illuminated_thoughts       = { 102444, 384060, 1 }, -- Clearcasting has a 5% increased chance to proc.
    impetus                    = { 102480, 383676, 1 }, -- Arcane Blast has a 10% chance to generate an additional Arcane Charge. If you were to gain an Arcane Charge while at maximum charges instead gain 10% Arcane damage for 10 sec.
    improved_clearcasting      = { 102471, 321420, 1 }, -- Clearcasting can stack up to 2 additional times.
    improved_touch_of_the_magi = { 102452, 453002, 1 }, -- Your Touch of the Magi now accumulates 25% of the damage you deal.
    leydrinker                 = { 102474, 452196, 1 }, -- Consuming Nether Precision has a 25% chance to make your next Arcane Blast echo, repeating its damage at 60% effectiveness to the primary target and up to four nearby enemies. Casting Touch of the Magi grants Leydrinker.
    leysight                   = { 102477, 452187, 1 }, -- Nether Precision damage bonus increased to 30%.
    magis_spark                = { 102435, 454016, 1 }, -- Your Touch of the Magi now also conjures a spark, causing the damage from your next Arcane Barrage, Arcane Blast, and Arcane Missiles to echo for 100% of their damage. Upon receiving damage from all three spells, the spark explodes, dealing 45,289 Arcane damage to all nearby enemies.
    nether_munitions           = { 102435, 450206, 1 }, -- When your Touch of the Magi detonates, it increases the damage all affected targets take from you by 8% for 12 sec.
    nether_precision           = { 102473, 383782, 1 }, -- Consuming Clearcasting increases the damage of your next 2 Arcane Blasts or Arcane Barrages by 20%.
    orb_barrage                = { 102443, 384858, 1 }, -- Arcane Barrage has a 10% chance per Arcane Charge consumed to launch an Arcane Orb in front of you at 100% effectiveness.
    presence_of_mind           = { 102460, 205025, 1 }, -- Causes your next 2 Arcane Blasts to be instant cast.
    prodigious_savant          = { 102450, 384612, 2 }, -- Arcane Charges further increase Mastery effectiveness of Arcane Blast and Arcane Barrage by 20%.
    resonance                  = { 102437, 205028, 1 }, -- Arcane Barrage deals 10% increased damage per target it hits.
    reverberate                = { 102441, 281482, 1 }, -- If Arcane Explosion hits at least 3 targets, it has a 50% chance to generate an extra Arcane Charge.
    slipstream                 = { 102469, 236457, 1 }, -- Arcane Missiles can now be channeled while moving. Evocation can be channeled while moving.
    static_cloud               = { 102453, 461257, 1 }, -- Each time you cast Arcane Explosion, its damage increases by 25%. Bonus resets after reaching 100% damage.
    surging_urge               = { 102440, 457521, 1 }, -- Arcane Surge damage increased by 5% per Arcane Charge.
    time_loop                  = { 102451, 452924, 1 }, -- Arcane Debilitation's duration is increased by 2 sec. When you apply a stack of Arcane Debilitation, you have a 25% chance to apply another stack of Arcane Debilitation. This effect can trigger off of itself.
    touch_of_the_magi          = { 102468, 321507, 1 }, -- Applies Touch of the Magi to your current target, accumulating 25% of the damage you deal to the target for 12 sec, and then exploding for that amount of Arcane damage to the target and reduced damage to all nearby enemies. Generates 4 Arcane Charges.

    -- Spellslinger
    augury_abounds             = {  94662, 443783, 1 }, -- Casting Arcane Surge conjures 8 Arcane Splinters. During Arcane Surge, whenever you conjure an Arcane Splinter, you have a 100% chance to conjure an additional Arcane Splinter.
    controlled_instincts       = {  94663, 444483, 1 }, -- For 8 seconds after being struck by an Arcane Orb, 20% of the direct damage dealt by an Arcane Splinter is also dealt to nearby enemies. Damage reduced beyond 5 targets.
    force_of_will              = {  94656, 444719, 1 }, -- Gain 2% increased critical strike chance. Gain 5% increased critical strike damage.
    look_again                 = {  94659, 444756, 1 }, -- Displacement has a 50% longer duration and 25% longer range.
    phantasmal_image           = {  94660, 444784, 1 }, -- Your Mirror Image summons one extra clone. Mirror Image now reduces all damage taken by an additional 5%.
    reactive_barrier           = {  94660, 444827, 1 }, -- Your Prismatic Barrier can absorb up to 50% more damage based on your missing Health. Max effectiveness when under 50% health.
    shifting_shards            = {  94657, 444675, 1 }, -- Shifting Power fires a barrage of 8 Arcane Splinters at random enemies within 40 yds over its duration.
    signature_spell            = {  94657, 470021, 1 }, -- When your Magi's Spark explodes, you conjure 6 Arcane Splinters.
    slippery_slinging          = {  94659, 444752, 1 }, -- You have 40% increased movement speed during Alter Time and Evocation.
    spellfrost_teachings       = {  94655, 444986, 1 }, -- Direct damage from Arcane Splinters has a small chance to launch an Arcane Orb at 50% effectiveness and increase all damage dealt by Arcane Orb by 10% for 10 sec.
    splintering_orbs           = {  94661, 444256, 1 }, -- Enemies damaged by your Arcane Orb conjure 2 Arcane Splinters, up to 4. Arcane Orb damage is increased by 10%.
    splintering_sorcery        = {  94664, 443739, 1, "spellslinger" }, -- When you consume Nether Precision, conjure 2 Arcane Splinters that fire at your target. Arcane Splinter:
    splinterstorm              = {  94654, 443742, 1 }, -- Whenever you have 8 or more active Embedded Arcane Splinters, you automatically cast a Splinterstorm at your target. Splinterstorm: Shatter all Embedded Arcane Splinters, dealing their remaining periodic damage instantly. Conjure an Arcane Splinter for each Splinter shattered, then unleash them all in a devastating barrage, dealing 3,967 Arcane damage to your target for each Splinter in the Splinterstorm. Splinterstorm has a 5% chance to grant Clearcasting.
    unerring_proficiency       = {  94658, 444974, 1 }, -- Each time you conjure an Arcane Splinter, increase the damage of your next Supernova by 20%. Stacks up to 30 times.
    volatile_magic             = {  94658, 444968, 1 }, -- Whenever an Embedded Arcane Splinter is removed, it explodes, dealing 1,132 Arcane damage to nearby enemies. Deals reduced damage beyond 5 targets.

    -- Sunfury
    burden_of_power            = {  94644, 451035, 1 }, -- Conjuring a Spellfire Sphere increases the damage of your next Arcane Blast by 20%.
    codex_of_the_sunstriders   = {  94643, 449382, 1 }, -- Over its duration, your Arcane Phoenix will consume each of your Spellfire Spheres to cast an exceptional spell. Upon consuming a Spellfire Sphere, your Arcane Phoenix will grant you Lingering Embers.  Lingering Embers
    glorious_incandescence     = {  94645, 449394, 1 }, -- Consuming Burden of Power causes your next cast of Arcane Barrage to deal 20% increased damage, grant 4 Arcane Charges, and call down a storm of 4 Meteorites on its target.
    gravity_lapse              = {  94651, 458513, 1 }, -- Your Supernova becomes Gravity Lapse. Gravity Lapse The snap of your fingers warps the gravity around your target and 4 other nearby enemies, suspending them in the air for until canceled. Upon landing, nearby enemies take 6,887 Arcane damage.
    ignite_the_future          = {  94648, 449558, 1 }, -- Generating a Spellfire Sphere while your Phoenix is active causes it to cast an exceptional spell. Mana Cascade can now stack up to 15 times.
    invocation_arcane_phoenix  = {  94652, 448658, 1 }, -- When you cast Arcane Surge, summon an Arcane Phoenix to aid you in battle.  Arcane Phoenix Your Arcane Phoenix aids you for the duration of your Arcane Surge, casting random Arcane and Fire spells.
    lessons_in_debilitation    = {  94651, 449627, 1 }, -- Your Arcane Phoenix will Spellsteal when it is summoned and when it expires.
    mana_cascade               = {  94653, 449293, 1 }, -- Casting Arcane Blast or Arcane Barrage grants you 0.5% Haste for 10 sec. Stacks up to 10 times. Multiple instances may overlap.
    memory_of_alar             = {  94646, 449619, 1 }, -- While under the effects of a casted Arcane Surge, you gain twice as many stacks of Mana Cascade. When your Arcane Phoenix expires, it empowers you, granting Arcane Soul for 2 sec, plus an additional 1.0 sec for each exceptional spell it had cast. Arcane Soul: Arcane Barrage grants Clearcasting and generates 4 Arcane Charges.
    merely_a_setback           = {  94649, 449330, 1 }, -- Your Prismatic Barrier now grants 5% avoidance while active and 3% leech for 5 sec when it breaks or expires.
    rondurmancy                = {  94648, 449596, 1 }, -- Spellfire Spheres can now stack up to 5 times.
    savor_the_moment           = {  94650, 449412, 1 }, -- When you cast Arcane Surge, its duration is extended by 0.5 sec for each Spellfire Sphere you have, up to 2.5 sec.
    spellfire_spheres          = {  94647, 448601, 1, "sunfury" }, -- Every 6 times you cast Arcane Blast or Arcane Barrage, conjure a Spellfire Sphere. While you're out of combat, you will slowly conjure Spellfire Spheres over time.  Spellfire Sphere
    sunfury_execution          = {  94650, 449349, 1 }, -- Arcane Bombardment damage bonus increased to 130%.  Arcane Bombardment Arcane Barrage deals an additional 100% damage against targets below 35% health.
} )


-- PvP Talents
spec:RegisterPvpTalents( {
    arcanosphere               = 5397, -- (353128) Builds a sphere of Arcane energy, gaining power over 4 sec. Upon release, the sphere passes through any barriers, knocking enemies back and dealing up to 95,047 Arcane damage.
    chrono_shift               = 5661, -- (235711)
    ethereal_blink             = 5601, -- (410939)
    ice_wall                   = 5488, -- (352278) Conjures an Ice Wall 30 yards long that obstructs line of sight. The wall has 40% of your maximum health and lasts up to 15 sec.
    improved_mass_invisibility =  637, -- (415945)
    kleptomania                = 3529, -- (198100) Unleash a flurry of disruptive magic onto your target, stealing a beneficial magic effect every 0.4 sec for 3.4 sec. Castable while moving, but movement speed is reduced by 40% while channeling.
    master_of_escape           =  635, -- (210476)
    master_shepherd            = 5589, -- (410248)
    ring_of_fire               = 5491, -- (353082) Summons a Ring of Fire for 8 sec at the target location. Enemies entering the ring burn for 18% of their total health over 6 sec.
    temporal_shield            = 3517, -- (198111) Envelops you in a temporal shield for 4 sec. 60% of all damage taken while shielded will be instantly restored when the shield ends.
} )


-- Auras
spec:RegisterAuras( {
    aether_attunement = {
        id = 453601,
        duration = 30,
        max_stack = 1
    },
    aether_attunement_stack = {
        id = 458388,
        duration = 180,
        max_stack = 3
    },
    aethervision = {
        id = 467634,
        duration = 10,
        max_stack = 2
    },
    -- Talent: Altering Time. Returning to past location and health when duration expires.
    -- https://wowhead.com/beta/spell=342246
    alter_time = {
        id = 342246,
        duration = 10,
        max_stack = 1
    },
    arcane_blast_overcapped = {
        duration = 3,
        max_stack = 1,
    },
    -- Increases the damage of Arcane Blast, Arcane Missiles, Arcane Explosion, and Arcane Barrage by $36032w1%.    Increases the mana cost of Arcane Blast by $36032w2%$?{$w5<0}[, and reduces the cast time of Arcane Blast by $w5%.][.]    Increases the number of targets hit by Arcane Barrage for 50% damage by $36032w3.
    -- https://wowhead.com/beta/spell=36032
    arcane_charge = {
        duration = 3600,
        max_stack = 4,
        generate = function ()
            local ac = buff.arcane_charge

            if arcane_charges.current > 0 then
                ac.count = arcane_charges.current
                ac.applied = query_time
                ac.expires = query_time + 3600
                ac.caster = "player"
                return
            end

            ac.count = 0
            ac.applied = 0
            ac.expires = 0
            ac.caster = "nobody"
        end,
    },
    arcane_debilitation = {
        id = 453599,
        duration = function () return 6 + (talent.time_loop.enabled and 2 or 0) end,
        max_stack = 15
    },
    -- Talent: Maximum mana increased by $s1%.
    -- https://wowhead.com/beta/spell=210126
    arcane_familiar = {
        id = 210126,
        duration = 3600,
        max_stack = 1
    },
    -- Talent: Increases the damage of your next Arcane Barrage by $s1%.
    -- https://wowhead.com/beta/spell=384455
    arcane_harmony = {
        id = 384455,
        duration = 3600,
        max_stack = 1,
        copy = 332777
    },
    -- Intellect increased by $w1%.
    -- https://wowhead.com/beta/spell=1459
    arcane_intellect = {
        id = 1459,
        duration = 3600,
        type = "Magic",
        max_stack = 1,
        shared = "player"
    },
    arcane_orb = {
        duration = 2.5,
        max_stack = 1,
        --[[ generate = function ()
            local last = action.arcane_orb.lastCast
            local ao = buff.arcane_orb

            if query_time - last < 2.5 then
                ao.count = 1
                ao.applied = last
                ao.expires = last + 2.5
                ao.caster = "player"
                return
            end

            ao.count = 0
            ao.applied = 0
            ao.expires = 0
            ao.caster = "nobody"
        end, ]]
    },
    arcane_soul = {
        id = 451038,
        duration = function () return 2 + ( buff.lingering_embers.stacks * 1 ) end,
        max_stack = 1
    },
    -- Talent: Spell damage increased by $w1% and Mana Regeneration increase $w3%.
    -- https://wowhead.com/beta/spell=365362
    arcane_surge = {
        id = 365362,
        duration = function() return 15 + ( set_bonus.tier30_2pc > 0 and 3 or 0 ) + ( talent.savor_the_moment.enabled and buff.spellfire_spheres.stacks * 0.5 or 0 ) end,
        type = "Magic",
        max_stack = 1
    },
    arcane_tempo = {
        id = 383997,
        duration = 12,
        max_stack = 5
    },
    big_brained = {
        id = 461531,
        duration = 8,
        max_stack = 10
    },
    -- Talent: Movement speed reduced by $s2%.
    -- https://wowhead.com/beta/spell=157981
    blast_wave = {
        id = 157981,
        duration = 6,
        type = "Magic",
        max_stack = 1

        -- Affected by:
        -- frigid_winds[235224] #6: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- volatile_detonation[389627] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -5000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
    },
    -- Absorbs $w1 damage.  Melee attackers take $235314s1 Fire damage.
    -- https://wowhead.com/beta/spell=235313
    blazing_barrier = {
        id = 235313,
        duration = 60,
        type = "Magic",
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
    burden_of_power = {
        id = 451049,
        duration = 12,
        max_stack = 1
    },
    -- Talent: Your next Arcane Missiles or Arcane Explosion costs no mana$?s321758[ and Arcane Missiles fires an additional missile][].
    -- https://wowhead.com/beta/spell=263725
    clearcasting = {
        id = function () return pvptalent.arcane_empowerment.enabled and 276743 or 263725 end,
        duration = 15,
        type = "Magic",
        max_stack = function ()
            return ( talent.improved_clearcasting.enabled and 3 or 1 ) + ( pvptalent.arcane_empowerment.enabled and 2 or 0 )
        end,
        copy = { 263725, 276743 }
    },
    clearcasting_channel = {
        duration = function () return 2.5 * haste end,
        tick_time = function () return ( 2.5 / 6 ) * haste end,
        max_stack = 1,
    },
    -- Talent: Your next Clearcasting will not be consumed.
    -- https://wowhead.com/beta/spell=384379
    concentration = {
        id = 384379,
        duration = 30,
        max_stack = 1
    },
    dematerialize = {
        id = 461498,
        duration = 6,
        max_stack = 1
    },
    embedded_arcane_splinter = {
        id = 444735,
        duration = 18,
        max_stack = 99
    },
    expanded_potential = {
        id = 327495,
        duration = 300,
        max_stack = 1
    },
    -- Talent: Mana regeneration increased by $s1%.
    -- https://wowhead.com/beta/spell=12051
    evocation = {
        id = 12051,
        duration = function () return 2.8 * haste end,
        tick_time = function () return 0.5 * haste end,
        max_stack = 1,
    },
    freezing_cold = {
        id = 386770,
        duration = 5,
        max_stack = 1,
    },
    -- Frozen in place.
    -- https://wowhead.com/beta/spell=122
    frost_nova = {
        id = 122,
        duration = function() return talent.improved_frost_nova.enabled and 8 or 6 end,
        type = "Magic",
        max_stack = 1,
        copy = 235235
    },
    glorious_incandescence = {
        id = 451073,
        duration = 11,
        max_stack = 1
    },
    gravity_lapse = {
        id = 473291,
        duration = 3,
        max_stack = 1
    },
    high_voltage = {
        id = 461525,
        duration = 3600,
        max_stack = 10
    },
    hypothermia = {
        id = 41425,
        duration = 30,
        max_stack = 1,
    },
    -- Talent: Immune to all attacks and damage.  Cannot attack, move, or use spells.
    -- https://wowhead.com/beta/spell=45438
    ice_block = {
        id = 45438,
        duration = 10,
        mechanic = "invulneraility",
        type = "Magic",
        max_stack = 1
    },
    ice_cold = {
        id = 414658,
        duration = 6,
        max_stack = 1
    },
    -- Talent: Able to move while casting spells.
    -- https://wowhead.com/beta/spell=108839
    ice_floes = {
        id = 108839,
        duration = 15,
        type = "Magic",
        max_stack = 3
    },
    impetus = {
        id = 393939,
        duration = 10,
        max_stack = 1,
    },
    incantation_of_swiftness = {
        id = 382294,
        duration = 6,
        max_stack = 1,
        copy = 337278
    },
    incanters_flow = {
        id = 116267,
        duration = 3600,
        max_stack = 5,
        meta = {
            stack = function() return state.incanters_flow_stacks end,
            stacks = function() return state.incanters_flow_stacks end,
        }
    },
    intuition = {
        id = 455681,
        duration = 10,
        max_stack = 1
    },
    leydrinker = {
        id = 453758,
        duration = 30,
        max_stack = 1
    },
    lingering_embers = {
        id = 461145,
        duration = 10,
        max_stack = 15
    },
    magis_spark_arcane_barrage = {
        duration = 12,
        max_stack = 1
    },
    magis_spark_arcane_blast = {
        duration = 12,
        max_stack = 1
    },
    magis_spark_arcane_missiles = {
        duration = 12,
        max_stack = 1
    },
    mana_cascade = {
        id = 449322,
        duration = 10,
        max_stack = function () return 10 + talent.ignite_the_future.enabled and 5 or 0 end
    },
    mass_polymorph = {
        id = 383121,
        duration = 15,
        max_stack = 1
    },
    mirror_image = {
        id = 55342,
        duration = 40,
        max_stack = 3,
        generate = function ()
            local mi = buff.mirror_image

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
    mirrors_of_torment = {
        id = 314793,
        duration = 20,
        type = "Magic",
        max_stack = 3,
    },
    nether_munitions = {
        id = 454004,
        duration = 12,
        max_stack = 1
    },
    nether_precision = {
        id = 383783,
        duration = 10,
        max_stack = 2,
        copy = 336889
    },
    -- Talent: Deals $w1 Arcane damage and an additional $w1 Arcane damage to all enemies within $114954A1 yards every $t sec.
    -- https://wowhead.com/beta/spell=114923
    nether_tempest = {
        id = 114923,
        duration = 12,
        tick_time = 1,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Spell critical strike chance increased by $w1%.
    -- https://wowhead.com/beta/spell=394195
    overflowing_energy = {
        id = 394195,
        duration = 8,
        max_stack = 5
    },
    -- Talent: Arcane Blast is instant cast.
    -- https://wowhead.com/beta/spell=205025
    presence_of_mind = {
        id = 205025,
        duration = 3600,
        max_stack = 2,
        onRemove = function( t )
            setCooldown( "presence_of_mind", action.presence_of_mind.cooldown )
        end,
    },
    -- Talent: Absorbs $w1 damage.  Magic damage taken reduced by $s3%.  Duration of all harmful Magic effects reduced by $w4%.
    -- https://wowhead.com/beta/spell=235450
    prismatic_barrier = {
        id = 235450,
        duration = 60,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Every $t1 sec, deal $382445s1 Nature damage to enemies within $382445A1 yds and reduce the remaining cooldown of your abilities by ${-$s2/1000} sec.
    -- https://wowhead.com/beta/spell=382440
    shifting_power = {
        id = 382440,
        duration = function() return 4 * haste end,
        tick_time = function() return haste end,
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
    siphon_storm = {
        id = 384267,
        duration = 30,
        max_stack = 10,
        copy = 332934
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
    static_cloud = {
        id = 461515,
        duration = 60,
        max_stack = 4
    },
    -- Talent: Absorbs $w1 damage.
    -- https://wowhead.com/beta/spell=382290
    tempest_barrier = {
        id = 382290,
        duration = 15,
        type = "Magic",
        max_stack = 1
    },
    temporal_velocity = {
        id = 384360,
        duration = 3,
        type = "Magic",
        max_stack = 1,
    },
    -- Rooted and Silenced.
    -- https://wowhead.com/beta/spell=317589
    tormenting_backlash = {
        id = 317589,
        duration = 4,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Will explode for $w1 Arcane damage upon expiration.
    -- https://wowhead.com/beta/spell=210824
    touch_of_the_magi = {
        id = 210824,
        duration = 12,
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
    unerring_proficiency = {
        id = 444981,
        duration = 60,
        max_stack = 30
    },

    -- Azerite Powers
    brain_storm = {
        id = 273330,
        duration = 30,
        max_stack = 1,
    },
    equipoise = {
        id = 264352,
        duration = 3600,
        max_stack = 1,
    },

    -- Legendaries
    heart_of_the_fae = {
        id = 356881,
        duration = 15,
        max_stack = 1,
    },
    grisly_icicle = {
        id = 348007,
        duration = 8,
        max_stack = 1
    },

    -- Sunfury
	-- Spellfire Spheres actual buff
	-- Spellfire Spheres has two diffrent counter. 449400 for create a Sphere, 448604 is Sphere number
	-- https://www.wowhead.com/spell=449400/spellfire-spheres
    spellfire_spheres = {
        id = 448604,
        duration = 3600,
        max_stack = function() return 3 + ( talent.rondurmancy.enabled and 2 or 0 ) end,
    },

    next_blast_spheres = {
        id = 449400,
        duration = 30,
        max_stack = 5,
    }
	
} )


-- Variables from APL (2022-11-30)
-- actions.precombat+=/variable,name=aoe_target_count,default=-1,op=set,if=variable.aoe_target_count=-1,value=3
spec:RegisterVariable( "aoe_target_count", function ()
    return 3
end )

-- Goal is to conserve mana through the first TotM in a fight, then burn otherwise.
local totm_casts = 0
local clearcasting_consumed = 0

spec:RegisterHook( "COMBAT_LOG_EVENT_UNFILTERED", function( _, subtype, _, sourceGUID, sourceName, _, _, destGUID, destName, destFlags, _, spellID, spellName )
    if sourceGUID == GUID then
        if subtype == "SPELL_CAST_SUCCESS" and spellID == 321507 then
            totm_casts = ( totm_casts + 1 ) % 2

        elseif subtype == "SPELL_AURA_REMOVED" and ( spellID == 276743 or spellID == 263725 ) then
            -- Clearcasting was consumed.
            clearcasting_consumed = GetTime()
        end
    end
end, false )

spec:RegisterEvent( "PLAYER_REGEN_ENABLED", function ()
    totm_casts = 0
end )

-- actions.precombat+=/variable,name=conserve_mana,op=set,value=0
-- actions.touch_phase+=/variable,name=conserve_mana,op=set,if=debuff.touch_of_the_magi.remains>9,value=1-variable.conserve_mana
spec:RegisterVariable( "conserve_mana", function ()
    return totm_casts % 2 > 0
end )


do
    -- Builds Disciplinary Command; written so that it can be ported to the other two Mage specs.
    function Hekili:EmbedDisciplinaryCommand( x )
        local file_id = x.id

        x:RegisterAuras( {
            disciplinary_command = {
                id = 327371,
                duration = 20,
            },

            disciplinary_command_arcane = {
                duration = 10,
                max_stack = 1,
            },

            disciplinary_command_frost = {
                duration = 10,
                max_stack = 1,
            },

            disciplinary_command_fire = {
                duration = 10,
                max_stack = 1,
            }
        } )

        local __last_arcane, __last_fire, __last_frost, __last_disciplinary_command = 0, 0, 0, 0
        local __last_arcSpell, __last_firSpell, __last_froSpell

        x:RegisterHook( "reset_precast", function ()
            if not legendary.disciplinary_command.enabled then return end

            if now - __last_arcane < 10 then applyBuff( "disciplinary_command_arcane", 10 - ( now - __last_arcane ) ) end
            if now - __last_fire   < 10 then applyBuff( "disciplinary_command_fire",   10 - ( now - __last_fire ) ) end
            if now - __last_frost  < 10 then applyBuff( "disciplinary_command_frost",  10 - ( now - __last_frost ) ) end

            if now - __last_disciplinary_command < 30 then
                setCooldown( "buff_disciplinary_command", 30 - ( now - __last_disciplinary_command ) )
            end

            Hekili:Debug( "Disciplinary Command:\n - Arcane: %.2f, %s\n - Fire  : %.2f, %s\n - Frost : %.2f, %s\n - ICD   : %.2f", buff.disciplinary_command_arcane.remains, __last_arcSpell or "None", buff.disciplinary_command_fire.remains, __last_firSpell or "None", buff.disciplinary_command_frost.remains, __last_froSpell or "None", cooldown.buff_disciplinary_command.remains )
        end )

        x:RegisterStateFunction( "update_disciplinary_command", function( action )
            local ability = class.abilities[ action ]

            if not ability then return end
            if ability.item or ability.from == 0 then return end

            if     ability.school == "arcane" then applyBuff( "disciplinary_command_arcane" )
            elseif ability.school == "fire"   then applyBuff( "disciplinary_command_fire"   )
            elseif ability.school == "frost"  then applyBuff( "disciplinary_command_frost"  )
            else
                local sAction = x.abilities[ action ]
                local sDiscipline = sAction and sAction.school

                if sDiscipline then
                    if     sDiscipline == "arcane" then applyBuff( "disciplinary_command_arcane" )
                    elseif sDiscipline == "fire"   then applyBuff( "disciplinary_command_fire"   )
                    elseif sDiscipline == "frost"  then applyBuff( "disciplinary_command_frost"  ) end
                else applyBuff( "disciplinary_command_" .. state.spec.key ) end
            end

            if buff.disciplinary_command_arcane.up and buff.disciplinary_command_fire.up and buff.disciplinary_command_frost.up then
                applyBuff( "disciplinary_command" )
                setCooldown( "buff_disciplinary_command", 30 )
                removeBuff( "disciplinary_command_arcane" )
                removeBuff( "disciplinary_command_fire" )
                removeBuff( "disciplinary_command_frost" )
            end
        end )

        x:RegisterHook( "runHandler", function( action )
            if not legendary.disciplinary_command.enabled or cooldown.buff_disciplinary_command.remains > 0 then return end
            update_disciplinary_command( action )
        end )

        local triggerEvents = {
            SPELL_CAST_SUCCESS = true,
            SPELL_HEAL = true,
            SPELL_SUMMON= true
        }

        local spellChanges = {
            [108853] = 319836,
            [212653] = 1953,
            [342130] = 116011,
            [337137] = 1,
        }

        local spellSchools = {
            [4] = "fire",
            [16] = "frost",
            [64] = "arcane"
        }

        x:RegisterHook( "COMBAT_LOG_EVENT_UNFILTERED", function( _, subtype, _, sourceGUID, _, _, _, _, _, _, _, spellID, spellName, spellSchool )
            if sourceGUID == GUID then
                if triggerEvents[ subtype ] then
                    spellID = spellChanges[ spellID ] or spellID
                    if not IsSpellKnown( spellID, false ) then return end

                    local school = spellSchools[ spellSchool ]
                    if not school then return end

                    if     school == "arcane" then __last_arcane = GetTime(); __last_arcSpell = spellName
                    elseif school == "fire"   then __last_fire   = GetTime(); __last_firSpell = spellName
                    elseif school == "frost"  then __last_frost  = GetTime(); __last_froSpell = spellName end
                    return
                elseif subtype == "SPELL_AURA_APPLIED" and spellID == class.auras.disciplinary_command.id then
                    __last_disciplinary_command = GetTime()
                    __last_arcane = 0
                    __last_fire = 0
                    __last_frost = 0
                end
            end
        end, false )

        x:RegisterAbility( "buff_disciplinary_command", {
            cooldown_special = function ()
                local remains = ( now + offset ) - __last_disciplinary_command

                if remains < 30 then
                    return __last_disciplinary_command, 30
                end

                return 0, 0
            end,
            unlisted = true,

            cast = 0,
            cooldown = 30,
            gcd = "off",

            handler = function()
                applyBuff( "disciplinary_command" )
            end,
        } )
    end
end


spec:RegisterGear( "tier31", 207288, 207289, 207290, 207291, 207293, 217232, 217234, 217235, 217231, 217233 )
spec:RegisterAuras( {
    forethought = {
        id = 424293,
        duration = 20,
        max_stack = 5
    },
    arcane_battery = {
        id = 424334,
        duration = 30,
        max_stack = 3
    },
    arcane_artillery = {
        id = 424331,
        duration = 30,
        max_stack = 1
    }
} )

-- Tier 30
spec:RegisterGear( "tier30", 202554, 202552, 202551, 202550, 202549 )
spec:RegisterAura( "arcane_overload", {
    id = 409022,
    duration = 18,
    max_stack = 25
} )

local TriggerArcaneOverloadT30 = setfenv( function()
    applyBuff( "arcane_overload" )
end, state )

-- Hero Talents
local TriggerArcaneSoul = setfenv( function()
    applyBuff( "arcane_soul" )
end, state )

spec:RegisterGear( "tier29", 200318, 200320, 200315, 200317, 200319 )
spec:RegisterAura( "bursting_energy", {
    id = 395006,
    duration = 12,
    max_stack = 4
} )


spec:RegisterHook( "spend", function( amt, resource )
    if resource == "arcane_charges" then
        if arcane_charges.current == 0 then
            removeBuff( "arcane_charge" )
        else
            applyBuff( "arcane_charge", nil, arcane_charges.current )
        end
        if amt > 0 and talent.arcane_tempo.enabled then
            addStack( "arcane_tempo", nil, 1 )
        end

    elseif resource == "mana" then
        if azerite.equipoise.enabled and mana.percent < 70 then
            removeBuff( "equipoise" )
        end
    end
end )

spec:RegisterHook( "gain", function( amt, resource )
    if resource == "arcane_charges" then
        if arcane_charges.current == 0 then
            removeBuff( "arcane_charge" )
        else
            applyBuff( "arcane_charge", nil, arcane_charges.current )
        end
    end
end )

spec:RegisterHook( "runHandler", function( action )
    if buff.ice_floes.up then
        local ability = class.abilities[ action ]
        if ability and ability.cast > 0 and ability.cast < 10 then removeStack( "ice_floes" ) end
    end
end )


--[[ spec:RegisterStateTable( "burn_info", setmetatable( {
    __start = 0,
    start = 0,
    __average = 20,
    average = 20,
    n = 1,
    __n = 1,
}, {
    __index = function( t, k )
        if k == "active" then
            return t.start > 0
        end
    end,
} ) ) ]]


-- spec:RegisterTotem( "rune_of_power", 609815 )


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

spec:RegisterStateExpr( "tick_reduction", function ()
    return action.shifting_power.cdr / 4
end )

spec:RegisterStateExpr( "full_reduction", function ()
    return action.shifting_power.cdr
end )


local abs = math.abs


local NetherMunitions = setfenv( function()
    applyDebuff( "target", "nether_munitions" )
    active_dot.nether_munitions = true_active_enemies
end, state )


spec:RegisterHook( "reset_precast", function ()
   --[[ if pet.rune_of_power.up then applyBuff( "rune_of_power", pet.rune_of_power.remains )
    else removeBuff( "rune_of_power" ) end --]]

    if buff.casting.up and buff.casting.v1 == 5143 and abs( action.arcane_missiles.lastCast - clearcasting_consumed ) < 0.15 then
        applyBuff( "clearcasting_channel", buff.casting.remains )
    end

    if arcane_charges.current > 0 then applyBuff( "arcane_charge", nil, arcane_charges.current ) end

    if buff.arcane_surge.up and set_bonus.tier30_4pc > 0 then
        state:QueueAuraEvent( "arcane_overload", TriggerArcaneOverloadT30, buff.arcane_surge.expires, "AURA_EXPIRATION" )
    end

    if buff.arcane_surge.up and talent.memory_of_alar.enabled then
        state:QueueAuraEvent( "arcane_soul", TriggerArcaneSoul, buff.arcane_surge.expires, "AURA_EXPIRATION" )
    end

    incanters_flow.reset()

    if talent.magis_spark.enabled and debuff.touch_of_the_magi.up then
        if action.arcane_barrage.lastCast < debuff.touch_of_the_magi.applied then applyDebuff( "target", "magis_spark_arcane_barrage" ) end
        if action.arcane_blast.lastCast < debuff.touch_of_the_magi.applied then applyDebuff( "target", "magis_spark_arcane_blast" ) end
        if action.arcane_missiles.lastCast < debuff.touch_of_the_magi.applied then applyDebuff( "target", "magis_spark_arcane_missiles" ) end
    end

    if talent.nether_munitions.enabled and debuff.touch_of_the_magi.up then
        state:QueueAuraExpiration( "touch_of_the_magi", NetherMunitions, debuff.touch_of_the_magi.expires )
    end
end )


-- Abilities
spec:RegisterAbilities( {
    -- Alters the fabric of time, returning you to your current location and health when cast a second time, or after 10 seconds. Effect negated by long distance or death.
    alter_time = {
        id = function () return buff.alter_time.down and 342247 or 342245 end,
        cast = 0,
        cooldown = function () return talent.master_of_time.enabled and 50 or 60 end,
        gcd = "spell",
        school = "arcane",

        spend = 0.01,
        spendType = "mana",

        toggle = "defensives",
        startsCombat = false,

        handler = function ()
            if buff.alter_time.down then
                applyBuff( "alter_time" )
            else
                removeBuff( "alter_time" )
                if talent.master_of_time.enabled then setCooldown( "blink", 0 ) end
            end
        end,

        copy = { 342247, 342245 },
    },

    -- Talent: Launches bolts of arcane energy at the enemy target, causing 1,617 Arcane damage. For each Arcane Charge, deals 36% additional damage and hits 1 additional nearby target for 40% of its damage. Consumes all Arcane Charges.
    arcane_barrage = {
        id = 44425,
        cast = 0,
        cooldown = 3,
        gcd = "spell",
        school = "arcane",

        startsCombat = true,

        -- TODO: Determine if I need to separate what is consumed/built on impact vs. on cast.
        -- velocity = 24,
        handler = function ()
            gain( 0.02 * mana.modmax * arcane_charges.current, "mana" )

            spend( arcane_charges.current, "arcane_charges" )
            removeBuff( "arcane_harmony" )
            removeBuff( "bursting_energy" )

            if talent.spellfire_spheres.enabled then
                if buff.next_blast_spheres.stacks == 5 then
                    removeBuff( "next_blast_spheres" )
                    addStack( "spellfire_spheres" )
                    applyBuff( "burden_of_power" )
                else addStack( "next_blast_spheres" )
                end
            end

            if buff.glorious_incandescence.up then
                gain( 4, "arcane_charges")
                removeBuff( "glorious_incandescence" )
            end

            if buff.arcane_soul.up then
                addStack( "clearcasting" )
                gain( 4, "arcane_charges" )
            end

            if buff.intuition.up then
                gain( 4, "arcane_charges" )
                removeBuff( "intuition" )
            end

            if buff.aethervision.up then
                gain( 2*buff.aethervision.stacks, "arcane_charges" )
                removeBuff( "aethervision" )
            end

            if buff.nether_precision.up then
                removeStack( "nether_precision" )
                if talent.dematerialize.enabled then applyDebuff( "target", "dematerialize" ) end
            end

            if debuff.magis_spark_arcane_barrage.up then
                removeDebuff( "target", "magis_spark_arcane_barrage" )
            end
        end,
    },

    -- Blasts the target with energy, dealing 1,340 Arcane damage. Each Arcane Charge increases damage by 72% and mana cost by 100%, and reduces cast time by 8%. Generates 1 Arcane Charge.
    arcane_blast = {
        id = 30451,
        cast = function ()
            if buff.presence_of_mind.up then return 0 end
            return 2.25 * ( 1 - ( 0.08 * arcane_charges.current ) ) * haste
        end,
        cooldown = 0,
        gcd = "spell",
        school = "arcane",

        spend = function ()
            -- More mana trickery to achieve the correct rotation
           if buff.concentration.up then return 0 end
            local mult = 0.0275 * ( 1 + arcane_charges.current ) * ( talent.consortiums_bauble.enabled and 0.95 or 1 )
            -- if azerite.equipoise.enabled and mana.pct < 70 then return ( mana.modmax * mult ) - 190 end
            return mana.modmax * mult, "mana"
        end,
        spendType = "mana",

        startsCombat = true,

        usable = function () return not moving end,
        handler = function ()
            if buff.presence_of_mind.up then
                removeStack( "presence_of_mind" )
                if buff.presence_of_mind.down then setCooldown( "presence_of_mind", 60 ) end
            end

            removeBuff( "concentration" )
            removeBuff( "leydrinker" )

            if talent.spellfire_spheres.enabled then
                if buff.next_blast_spheres.stacks == 5 then
                    removeBuff( "next_blast_spheres" )
                    addStack( "spellfire_spheres" )
                    applyBuff( "burden_of_power" )
                else addStack( "next_blast_spheres" )
                end
            end

            if buff.burden_of_power.up then
                removeBuff( "burden_of_power" )
                applyBuff( "glorious_incandescence" )
            end

            if buff.nether_precision.up then
                removeStack( "nether_precision" )
                if talent.dematerialize.enabled then applyDebuff( "target", "dematerialize" ) end
                if talent.aethervision.enabled then addStack( "aethervision" ) end
            end

            if debuff.magis_spark_arcane_blast.up then
                removeDebuff( "target", "magis_spark_arcane_blast" )
            end

            if arcane_charges.current == arcane_charges.max then
                applyBuff( "arcane_blast_overcapped" )
                if talent.arcane_echo.enabled then echo_opened = true end
            end -- Use this to catch "5th" cast of Arcane Blast.
            gain( 1, "arcane_charges" )
        end,
    },

    -- Causes an explosion of magic around the caster, dealing 1,684 Arcane damage to all enemies within 10 yards. Generates 1 Arcane Charge if any targets are hit.
    arcane_explosion = {
        id = 1449,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "arcane",

        spend = function ()
            if not pvptalent.arcane_empowerment.enabled and buff.clearcasting.up then return 0 end
            return 0.1
        end,
        spendType = "mana",

        startsCombat = true,

        usable = function () return target.maxR < 10 end,
        handler = function ()
            if buff.expanded_potential.up then removeBuff( "expanded_potential" )
            else
                if buff.clearcasting.up then
                    if buff.expanded_potential.up then removeBuff( "expanded_potential" )
                    else removeStack( "clearcasting" ) end
                    if talent.aether_attunement.enabled then
                        if buff.aether_attunement_stack.stack == 2 then
                            removeBuff( "aether_attunement_stack" )
                            applyBuff( "aether_attunement" )
                        else
                            addStack( "aether_attunement_stack" )
                        end
                    end
                    if talent.arcane_debilitation.enabled then addStack( "arcane_debilitation" ) end
                    if conduit.nether_precision.enabled or talent.nether_precision.enabled then addStack( "nether_precision", nil, 2 ) end
                    if set_bonus.tier31_2pc > 0 then addStack( "forethought" ) end
                    if set_bonus.tier31_4pc > 0 then
                        if buff.arcane_battery.stack == 2 then
                            removeBuff( "arcane_battery" )
                            applyBuff( "arcane_artillery" )
                        else
                            addStack( "arcane_battery" )
                        end
                    end
                end
                if legendary.sinful_delight.enabled then gainChargeTime( "mirrors_of_torment", 4 ) end
            end
            if talent.static_cloud.enabled then
                if buff.static_cloud.stack == 4 then
                    removeStack( "static_cloud", nil, 3 )
                else
                    addStack( "static_cloud" )
                end
            end
            gain( 1, "arcane_charges" )
        end,
    },

    --[[ Talent: Summon a Familiar that attacks your enemies and increases your maximum mana by 10% for 1 |4hour:hrs;.
    arcane_familiar = {
        id = 205022,
        cast = 0,
        cooldown = 10,
        gcd = "spell",
        school = "arcane",

        talent = "arcane_familiar",
        startsCombat = false,
        nobuff = "arcane_familiar",
        essential = true,

        handler = function ()
            if buff.arcane_familiar.down then mana.max = mana.max * 1.10 end
            applyBuff( "arcane_familiar" )
        end,

        copy = "summon_arcane_familiar"
    }, ]]

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
            if talent.arcane_familiar.enabled then
                if buff.arcane_familiar.down then mana.max = mana.max * 1.10 end
                applyBuff( "arcane_familiar" )
            end
        end,
    },

    -- Talent: Launches five waves of Arcane Missiles at the enemy over 2.2 sec, causing a total of 5,158 Arcane damage.
    arcane_missiles = {
        id = 5143,
        cast = function () return ( talent.concentrated_power.enabled and buff.clearcasting.up and 0.8 or 1 ) * 2.5 * haste end,
        channeled = true,
        cooldown = 0,
        gcd = "spell",
        school = "arcane",

        usable = function () return not moving or talent.slipstream.enabled end,

        spend = function ()
            if buff.clearcasting.up then return 0 end
            return 0.15
        end,
        spendType = "mana",

        talent = "arcane_missiles",
        startsCombat = true,
        buff = "clearcasting",

        aura = function () return buff.clearcasting_channel.up and "clearcasting_channel" or "casting" end,
        breakchannel = function ()
            removeBuff( "clearcasting_channel" )
        end,

        tick_time = function ()
            if buff.clearcasting_channel.up then return buff.clearcasting_channel.tick_time end
            return 0.5 * haste
        end,

        start = function ()
            removeBuff( "arcane_blast_overcapped" )
            removeBuff( "arcane_artillery" )

            if debuff.magis_spark_arcane_missiles.up then
                removeDebuff( "target", "magis_spark_arcane_missiles" )
            end

            if buff.clearcasting.up then
                    if buff.expanded_potential.up then removeBuff( "expanded_potential" )
                    else removeStack( "clearcasting" ) end
                    if buff.aether_attunement_stack.stack == 2 then
                        removeBuff( "aether_attunement_stack" )
                        applyBuff( "aether_attunement" )
                    else
                        addStack( "aether_attunement_stack" )
                    end
                    if talent.arcane_debilitation.enabled then addStack( "arcane_debilitation" ) end
                    if conduit.nether_precision.enabled or talent.nether_precision.enabled then addStack( "nether_precision", nil, 2 ) end
                    if set_bonus.tier31_2pc > 0 then addStack( "forethought" ) end
                    if set_bonus.tier31_4pc > 0 then
                        if buff.arcane_battery.stack > 1 then
                            removeBuff( "arcane_battery" )
                            applyBuff( "arcane_artillery" )
                        else
                            addStack( "arcane_battery" )
                        end
                    end

                if talent.amplification.enabled then applyBuff( "clearcasting_channel" ) end
                if legendary.sinful_delight.enabled then gainChargeTime( "mirrors_of_torment", 4 ) end
            end

            if buff.expanded_potential.up then removeBuff( "expanded_potential" ) end

            if talent.high_voltage.enabled then
                if buff.high_voltage.stack == 10 then
                    removeBuff( "high_voltage" )
                    gain( 1, "arcane_charges" )
                else
                    addStack( "high_voltage" )
                end
            end

            if conduit.arcane_prodigy.enabled and cooldown.arcane_surge.remains > 0 then
                reduceCooldown( "arcane_surge", conduit.arcane_prodigy.mod * 0.1 )
            end
        end,

        tick = function ()
            if talent.arcane_harmony.enabled or legendary.arcane_harmony.enabled then addStack( "arcane_harmony", nil, 1 ) end
        end,
    },

    -- Talent: Launches an Arcane Orb forward from your position, traveling up to 40 yards, dealing 2,997 Arcane damage to enemies it passes through. Grants 1 Arcane Charge when cast and every time it deals damage.
    arcane_orb = {
        id = 153626,
        cast = 0,
        charges = function() return talent.charged_orb.enabled and 2 or nil end,
        cooldown = 20,
        recharge = function() return talent.charged_orb.enabled and 20 or nil end,
        gcd = "spell",
        school = "arcane",

        spend = 0.01,
        spendType = "mana",

        startsCombat = true,

        handler = function ()
            gain( 1, "arcane_charges" )
            applyBuff( "arcane_orb" )
        end,
    },

    -- Talent: Expend all of your current mana to annihilate your enemy target and nearby enemies for up to ${$s1*$s2} Arcane damage based on Mana spent. Deals reduced damage beyond $s3 targets.; For the next $365362d, your Mana regeneration is increased by $365362s3% and spell damage is increased by $365362s1%.
    arcane_surge = {
        id = 365350,
        cast = 2.5,
        cooldown = 90,
        gcd = "spell",
        school = "arcane",
        
        -- Mana cap for arcane surge this tier is 2,900,001 mana
        spend = function() return min( mana.current, 2900001 ) end,
        spendType = "mana",

        talent = "arcane_surge",
        startsCombat = true,
        toggle = "cooldowns",

        usable = function () return not moving end,
        handler = function ()
            applyBuff( "arcane_surge" )
            addStack( "clearcasting" )
            mana.regen = mana.regen * 5.25
            -- trick addon into thinking you have enough mana to cast arcane blast right after, because in reality you do
            gain ( (mana.modmax*0.25), "mana" )
            -- forecastResources( "mana" )
            -- if talent.rune_of_power.enabled then applyBuff( "rune_of_power" ) end
            -- start_burn_phase()
            
        end,

        copy = "arcane_power"
    },


    arcanosphere = {
        id = 353128,
        cast = 0,
        cooldown = 45,
        gcd = "spell",

        pvptalent = "arcanosphere",
        startsCombat = false,
        texture = 4226155,

        handler = function ()
        end,
    },


    blink = {
        id = function () return talent.shimmer.enabled and 212653 or 1953 end,
        cast = 0,
        charges = function () return talent.shimmer.enabled and 2 or nil end,
        cooldown = function () return ( talent.shimmer.enabled and 25 or 15 ) - conduit.flow_of_time.mod * 0.001 - ( 2 * talent.flow_of_time.rank ) end,
        recharge = function () return ( talent.shimmer.enabled and ( 25 - conduit.flow_of_time.mod * 0.001 - talent.flow_of_time.rank * 2 ) or nil ) end,
        gcd = "off",
        icd = 6,

        spend = 0.02,
        spendType = "mana",

        startsCombat = false,
        texture = function () return talent.shimmer.enabled and 135739 or 135736 end,

        handler = function ()
            if talent.displacement.enabled then applyBuff( "displacement_beacon" ) end
            if talent.tempest_barrier.enabled then applyBuff( "tempest_barrier" ) end
            if talent.temporal_velocity.enabled then applyBuff( "temporal_velocity" ) end
        end,

        copy = { 212653, 1953, "shimmer", "blink_any", "any_blink" }
    },

    -- Counters the enemy's spellcast, preventing any spell from that school of magic from being cast for 6 sec.
    counterspell = {
        id = 2139,
        cast = 0,
        cooldown = function () return 24 - ( conduit.grounding_surge.mod * 0.1 ) end,
        gcd = "off",
        school = "arcane",

        spend = 0.02,
        spendType = "mana",

        startsCombat = true,
        toggle = "interrupts",
        debuff = function () return not runeforge.disciplinary_command.enabled and "casting" or nil end,
        readyTime = function () if debuff.casting.up then return state.timeToInterrupt() end end,

        handler = function ()
            interrupt()
            if talent.quick_witted.enabled then reduceCooldown( "counterspell", 4 ) end
        end,
    },

    -- Talent: Teleports you back to where you last Blinked. Only usable within 8 sec of Blinking.
    displacement = {
        id = 389713,
        cast = 0,
        cooldown = 45,
        gcd = "spell",
        school = "arcane",

        talent = "displacement",
        startsCombat = false,
        buff = "displacement_beacon",

        handler = function ()
            gain( 0.2 * health.max, "health" )
            removeBuff( "displacement_beacon" )
        end,
    },

    -- Talent: Increases your mana regeneration by 750% for 5.3 sec.
    evocation = {
        id = 12051,
        cast = function () return 2.8 * haste end,
        charges = 1,
        cooldown = 90,
        recharge = 90,
        gcd = "spell",
        school = "arcane",

        channeled = true,
        fixedCast = true,

        talent = "evocation",
        startsCombat = false,
        toggle = "cooldowns",

        aura = "evocation",
        tick_time = function () return 0.5 * haste end,

        -- Dont senselesly cast when out of range.
        -- Check for slipstream talent.
        usable = function () return (not moving or talent.slipstream.enabled) and target.maxR < 40 end,

        start = function ()
            applyBuff( "evocation" )
            addStack( "clearcasting" )
            if azerite.brain_storm.enabled then
                gain( 2, "arcane_charges" )
                applyBuff( "brain_storm" )
            end

            mana.regen = mana.regen * ( 8.5 / haste )
        end,

        tick = function ()
            addStack( "siphon_storm", nil, 1 )
        end,

        finish = function ()
            mana.regen = mana.regen / ( 8.5 * haste )
        end,

        breakchannel = function ()
            removeBuff( "evocation" )
            mana.regen = mana.regen / ( 8.5 * haste )
        end,
    },


    focus_magic = {
        id = 321358,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.02,
        spendType = "mana",

        startsCombat = true,
        texture = 135754,

        talent = "focus_magic",

        usable = function () return active_dot.focus_magic == 0 and group, "can apply one in a group" end,
        handler = function ()
            applyBuff( "focus_magic" )
        end,
    },

    -- Blasts enemies within 12 yds of you for 45 Frost damage and freezes them in place for 6 sec. Damage may interrupt the freeze effect.
    frost_nova = {
        id = 122,
        cast = 0,
        charges = function () return talent.ice_ward.enabled and 2 or nil end,
        cooldown = 30,
        recharge = function () return talent.ice_ward.enabled and 30 or nil end,
        gcd = "spell",
        school = "frost",

        spend = 0.02,
        spendType = "mana",

        startsCombat = true,

        usable = function () return not state.spec.frost or target.maxR < 12, "target out of range" end,
        handler = function ()
            applyDebuff( "target", "frost_nova" )
            if talent.bone_chilling.enabled then addStack( "bone_chilling" ) end
            if legendary.grisly_icicle.enabled then applyDebuff( "target", "grisly_icicle" ) end
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

    -- Talent: Makes your next Mage spell with a cast time shorter than 10 sec castable while moving. Unaffected by the global cooldown and castable while casting.
    ice_floes = {
        id = 108839,
        cast = 0,
        charges = 3,
        cooldown = 20,
        recharge = 20,
        gcd = "off",
        dual_cast = true,
        school = "frost",

        talent = "ice_floes",
        startsCombat = false,

        handler = function ()
            addStack( "ice_floes" )
        end,
    },

    -- Talent: Causes a whirl of icy wind around the enemy, dealing 2,328 Frost damage to the target and reduced damage to all other enemies within 8 yards, and freezing them in place for 2 sec.
    ice_nova = {
        id = 157997,
        cast = 0,
        cooldown = 25,
        gcd = "spell",
        school = "frost",

        talent = "ice_nova",
        startsCombat = false,

        handler = function ()
            applyBuff( "ice_nova" )
        end,
    },


    ice_wall = {
        id = 352278,
        cast = 1.5,
        cooldown = 90,
        gcd = "spell",

        spend = 0.08,
        spendType = "mana",

        pvptalent = "ice_wall",
        startsCombat = false,
        texture = 4226156,

        toggle = "cooldowns",

        handler = function ()
        end,
    },

    -- Cast $?c1[Prismatic]?c2[Blazing]?c3[Ice][] Barrier on yourself and $414661i nearby allies.
    mass_barrier = {
        id = 414660,
        cast = 0.0,
        cooldown = 180,
        gcd = "spell",

        spend = 0.120,
        spendType = 'mana',

        talent = "mass_barrier",
        startsCombat = false,

        handler = function ()
            if state.spec.arcane then applyBuff( "prismatic_barrier" )
            elseif state.spec.fire then applyBuff( "blazing_barrier" )
            elseif state.spec.frost then applyBuff( "ice_barrier" ) end
        end,
    },

    -- You and your allies within $A1 yards instantly become invisible for $d. Taking any action will cancel the effect.; $?a415945[]; [Does not affect allies in combat.]
    mass_invisibility = {
        id = 414664,
        cast = 0.0,
        cooldown = function() return pvptalent.improved_mass_invisibility.rank and 60 or 300 end,
        gcd = "spell",

        spend = 0.060,
        spendType = 'mana',

        talent = "mass_invisibility",
        startsCombat = false,

        handler = function()
            applyBuff( "mass_invisibility" )
        end,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_INVISIBILITY, 'points': 200.0, 'radius': 40.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_CASTER_AREA_RAID, }
        -- #1: { 'type': APPLY_AURA, 'subtype': UNKNOWN, 'points': 1.0, 'radius': 40.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_CASTER_AREA_RAID, }
        -- #2: { 'type': APPLY_AURA, 'subtype': SCREEN_EFFECT, 'value': 1421, 'schools': ['physical', 'fire', 'nature'], 'value1': 7, 'radius': 40.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_CASTER_AREA_RAID, }
        -- #3: { 'type': SANCTUARY_2, 'subtype': NONE, 'radius': 40.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_CASTER_AREA_RAID, }

        -- Affected by:
        -- improved_mass_invisibility[415945] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -240000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
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
            applyBuff( "mirror_image", nil, 3 )
        end,
    },


    polymorph = {
        id = 118,
        cast = 1.7,
        cooldown = 0,
        gcd = "spell",

        spend = 0.04,
        spendType = "mana",

        startsCombat = true,
        texture = 136071,

        handler = function ()
        end,
    },

    -- Talent: Causes your next 2 Arcane Blasts to be instant cast.
    presence_of_mind = {
        id = 205025,
        cast = 0,
        cooldown = 45,
        gcd = "off",
        school = "arcane",

        talent = "presence_of_mind",
        startsCombat = false,
        nobuff = "presence_of_mind",

        handler = function ()
            applyBuff( "presence_of_mind", nil, 2 )
        end,
    },

    -- Talent: Shields you with an arcane force, absorbing 8,622 damage and reducing magic damage taken by 15% for 1 min. The duration of harmful Magic effects against you is reduced by 25%.
    prismatic_barrier = {
        id = 235450,
        cast = 0,
        cooldown = 25,
        gcd = "spell",
        school = "arcane",

        spend = 0.03,
        spendType = "mana",

        talent = "prismatic_barrier",
        startsCombat = false,

        handler = function ()
            applyBuff( "prismatic_barrier" )
            if legendary.triune_ward.enabled then
                applyBuff( "blazing_barrier" )
                applyBuff( "ice_barrier" )
            end
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


    ring_of_fire = {
        id = 353082,
        cast = 2,
        cooldown = 30,
        gcd = "spell",

        spend = 0.02,
        spendType = "mana",

        pvptalent = "ring_of_fire",
        startsCombat = false,
        texture = 4067368,

        handler = function ()
        end,
    },

    -- Talent: Summons a Ring of Frost for 10 sec at the target location. Enemies entering the ring are incapacitated for 10 sec. Limit 10 targets. When the incapacitate expires, enemies are slowed by 65% for 4 sec.
    ring_of_frost = {
        id = 113724,
        cast = 2,
        cooldown = 45,
        gcd = "spell",
        school = "frost",

        spend = 0.08,
        spendType = "mana",

        talent = "ring_of_frost",
        startsCombat = true,

        handler = function ()
        end,
    },

    --[[ Talent: Teleports you 20 yards forward, unless something is in the way. Unaffected by the global cooldown and castable while casting. Gain a shield that absorbs 3% of your maximum health for 15 sec after you Shimmer.
    shimmer = {
        id = 212653,
        cast = 0,
        charges = 2,
        cooldown = function() return 25 - talent.flow_of_time.rank * 2 end,
        recharge = function() return 25 - talent.flow_of_time.rank * 2 end,
        gcd = "off",
        school = "arcane",

        spend = 0.02,
        spendType = "mana",

        talent = "shimmer",
        startsCombat = false,

        handler = function ()
            applyBuff( "shimmer" )
        end,
    }, ]]

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

        -- Arcane mostly doesnt care about the damage, leave this at 40 yards so it doesnt proc when you cant use your cooldowns anyway.
        -- Needed for:
        -- - Touch of the Magi
        -- - Arcane Surge
        -- - Evocation
        usable = function () return not moving and target.maxR < 40 end,

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
        debuff = function () return talent.unerring_proficiency.disabled and "casting" or nil end,
        readyTime = function () return talent.unerring_proficiency.disabled and state.timeToInterrupt( gcd.max ) or nil end,

        usable = function () return not target.is_boss end,
        handler = function ()
            if not target.is_boss then interrupt() end
            if talent.gravity_lapse.enabled then
                applyDebuff( "target", "gravity_lapse" )
                return
            end

            applyDebuff( "target", "supernova" )
            removeBuff( "unerring_proficiency" )
        end,

        copy = { 157980, "gravity_lapse", 449700 }
    },


    temporal_shield = {
        id = 198111,
        cast = 0,
        cooldown = 45,
        gcd = "off",

        spend = 0.03,
        spendType = "mana",

        pvptalent = "temporal_shield",
        startsCombat = false,

        handler = function ()
            applyBuff( "temporal_shield" )
        end,
    },

    -- Warp the flow of time, increasing haste by 30% for all party and raid members for 40 sec. Allies will be unable to benefit from Bloodlust, Heroism, or Time Warp again for 10 min.
    time_warp = {
        id = 80353,
        cast = 0,
        cooldown = 300,
        gcd = "off",

        spend = 0.04,
        spendType = "mana",

        nobuff = "bloodlust",
        startsCombat = false,
        toggle = "cooldowns",

        handler = function ()
            applyBuff( "time_warp" )
            applyDebuff( "player", "temporal_displacement" )
        end,
    },

    -- Talent: Applies Touch of the Magi to your current target, accumulating 20% of the damage you deal to the target for 10 sec, and then exploding for that amount of Arcane damage to the target and reduced damage to all nearby enemies. Generates 4 Arcane Charges.
    touch_of_the_magi = {
        id = 321507,
        cast = 0,
        cooldown = 45,
        gcd = "off",
        school = "arcane",
        -- More mana trickery
        -- spend = function () return buff.arcane_surge.up and 0 or 0.05 end,
        spend = 0.05,
        spendType = "mana",

        talent = "touch_of_the_magi",
        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "touch_of_the_magi" )
            if talent.nether_munitions.enabled then
                state:QueueAuraEvent( "touch_of_the_magi", NetherMunitions, debuff.touch_of_the_magi.expires, "AURA_EXPIRATION" )
            end
            if talent.magis_spark.enabled then
                applyDebuff( "target", "magis_spark_arcane_barrage" )
                applyDebuff( "target", "magis_spark_arcane_blast" )
                applyDebuff( "target", "magis_spark_arcane_missiles" )
            end
            if talent.leydrinker.enabled then
                applyBuff( "leydrinker" )
            end
            gain( 4, "arcane_charges" )
        end,
    },
} )


spec:RegisterRanges( "arcane_blast", "polymorph", "fire_blast" )

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

    package = "Arcane",
} )


spec:RegisterSetting( "check_explosion_range", true, {
    name = strformat( "%s: Range Check", Hekili:GetSpellLinkWithTexture( spec.abilities.arcane_explosion.id ) ),
    desc = strformat( "If checked, %s will not be recommended when you are more than 10 yards from your target.", Hekili:GetSpellLinkWithTexture( spec.abilities.arcane_explosion.id ) ),
    type = "toggle",
    width = "full"
} )

spec:RegisterSetting( "cancel_pom", false, {
    name = strformat( "Cancel %s", Hekili:GetSpellLinkWithTexture( spec.abilities.presence_of_mind.id ) ),
    desc = strformat( "If checked, canceling %s (icon with a red X) may be recommended during the opener with cooldowns. " ..
                      "\n\nThis behavior is consistent with the SimulationCraft priority but may feel awkward or incorrect. The DPS impact is minor.", Hekili:GetSpellLinkWithTexture( spec.abilities.presence_of_mind.id ) ),
    type = "toggle",
    width = "full"
} )

spec:RegisterPack( "Arcane", 20241102, [[Hekili:T3vEVnUXs(pldcGgXepk6YZrGSxK38YUVeSj5b4z33)zAAskl(mfPcpShVWqF23Q6dY(MuwsECoacYmJyZURU664xvD1nVCYLF6YlIcQIV8xMoE68jtgpD00XtE3PF4YlQEyt8LxSji82GBG)swWA4))9fHbzKF(H08Gi81lZRlcHFAvv1MYV7B)2BsQwvF9OW81FBzY660GQK8SWIGLv4)o8BV8IRRtsR(XSlV28y)oOp3ehE5V82PqVMefftBACz4LxGn9ntgpA67(UTxDrY6pU9Q6nyVS9N2(tSh(MPtHhozYOXJo9KTxTm5ZXLnpE8hGhd)k(NV3wFapCYy4HF6(4GB3Ev(M4S4cXNoEcTlgpJ9N27Q3)MPFW6dFhLi(0Q4Tx9VckG)hW9sYU8I0KYQsc7ToBzDXd(b5XW)8xiRyXzbxNghD5F7Ylccr2l8NKfg)Rdkkilxi3Qizd9HFAvs52RWUC7v4Flpl9bGwkJJ2E19WaU9QGTxDxqrc2TadlhiK4pxva)Asg8VwtwdHzAcRdYYRiVtu8YG60kEFhgKMI9zqweTD3G8n4hHr7(8IYyS)GU(U4c8xcE4YlaISkgg4lVy42RUUE5YrSzciwLoQEZ2RgS9QHK)J80W0ySbLvjz3mQScKo3E1ITxnB7vEBV6Xhn0hfXRdsYkjn7MWOrRd(mPXExwbsEkSZWvbi3FIgJDDszzsAC5LxKKbeCr9Mk)KLGwss4T(vjRJph7B2ynGseXvRIl8dQQQZIxhNvnkk)(mPoy964OeufahXwwHb(G4RDtA(1bP47aZGzQZaRm06IBIjKaHNsEuzYMv5z(LvWAC7JIIjpSkVoCLF(sFyA4Vo4MK2weMNNI)JrX3LhseoAzZNdQENk3k9EsT1E815M3Hr15fx32yOj0LfXNclzWedE6zGMiVNwMCZQkFPrzC7AA5QKLOaK)M87JlqU4CRCrrwiDOee7MYj7xT9QQGuCnEfmY(3LNwbQHJy9ivY8vMeHrjCpnPnyEHu1PUwBh2SqHC0s)Ynbf36ZTdKc9pPZB0jUUUaSKIRcKzT8dtJFiQij7w2VtzIabVPi(oFuYEYiXE2entEas1VTVsKYSty5BUafbc5fj51L(jzqJrZzXzHXYunvd7UKsuKOTBMk0eqRPoHiY0oV4KrgvbfMJH0UqQZLwMOs(gM0m7TW0(DVCnLOjXjWe07AoxGjqZOAyTADE2dTI0Ewnj9(NGY0zeB4QgW1AZ0wUjSSvIIeOe96KSiCK)G1rMnzkqFpxd(KQuuoDQMRVgg)5nP5OmdoQGPLpzrDqGyWgoXud5USfBk8MHr(uChMC73oXmOHs7q(QSSft2db9c)LPYgjxGgqhDkLFiick8ez9hjhlCPgvd40NkAjE24gN1dnzHH8gT(OSTOmNiccGyabGLypGCPgMRMlhvir4ZbKqlb5Ce81pdnPbs0QyqzNc1D7v)no7eb0Soj6nu(g8UakPe49FiVE7v)7A0Qi995V5f0jcbnePrr5zVgA1QG7Ij0pVHFK6c7egTCFaIZIbEg9Sr(v0YafbwvWTKFnF7v)wDCnziYrTy4L2eNMc)7Lv4)InjPZhcfWijqXnN9yJOGKvyv10iWrSz9xfpIbpBYRe)piSWFT4AgUZpYDNNNXM4m03T8Ak)7FaRcBV6)L6PfMYC(0pZmVIqBrEbfdAvm7XujrWqiFOyDAwmqV6gmm5o3nGHouawqK6BaI(1CSR9eVK(RFQKFPgazMWpy1ruRVQ0euxd4eZg)S4Fsq9VH0P2g0nmqKDS4ZXoOJ(ZvLTusx3I)CCyDvSpv77B04(9asJhlCdv2pzaO26zXrzYsVKUcThkrnsi(6RdQ(MZ(wrfWtswE2RysUcSttVwZJX3r9vAP1W8AKHtSR42urleyqgOOGaVUiFzsycy7Ob3Gai86nXfz53fyYQH0S(VhVmoRm5ousTHUGOk9P)dFm4tAeZ(0Sue1(cCv1MrfNiLvXOGJKVz7yTHjw8VvNSztC0OYnpSg4ZadX)(4RL8gkflf3BOuObTbl1a9yGDhMbrpWLDWEQxKG0Jejc94HMHUHnghidOSGa7MCUfLEJTxjAZUdPehR7aGvG9Je0495uG8cubXTBP))Uo6g0eJrm3IKJlKf8KDmI7CPfqshVPoZemE8(XCiZqZaNgG4v1QrBcROjN40MaaLXuFnQmwermyQJg1WQPxFro5sMvETfadxgxClOU6g6(FXq7ldnnppYhZzN7is(lgApzOltkIjm12yT(lg6(WqdaS8LvfbP(Ox02atnGuedVc4VRlvdFIKSOksahHjGtEsSpygGlrJ3aV(Htespmg6encjA6M5(8kDhjlBYPGgubNO(sZ0Xnm)MfDKzKNe5xrjCFoRIm7vb10eej4foea2IPHc4xzLRtQG(rlajb2Dr8M8IkXWuhZ37eB9gsb2IAsEHupdGpbEM3ZNmTbCjY8heG8yljSD68XIs)MxM94mxfgfYtvdrJZtjH0bYTqu0qRdcdlIzyk7LPeNCw8HUso(IMKCAA(WNm2OqCwzlMUK1aC6LXHv(byQsJaL8h8bp71RngmKiTrqAkr5MGI2fr7Gaq6wf54oOJnStE67KrsBOrEIwzfr7QUteDnnDPfRchTXGlaYcAALpj6JL5yCFYby0PDkBKpf)mtzZvmcg0PpNQt3OdzImXPLkOq(0ADqK)VvhdHAby5ZiBL7bCwXPkdJcsuQaRAqlehuCDbt1joCv(XGM0hem0yvOjn8P4I40OaOPv5G)2Ja9OmciXO6rpFdyKmUQLQ4dm(3sRH)ySiLznGn22hOGMI0DSOVz)cse2ZwGbvmTeKiS5ktDMGGFatrHaQcAIuBs8bF7PJIbklIK6VCAcrHxcvL5o0GUyvEsO78m0oh04bcPGOn79i1BpBHmpPunoaOlO7buuCzB(saKAjHvsj32zYpyfmazCDMuJJWqtsUskWHzZ73Ez)3VJMKt1KfmLxeZ8xAk4GrjZnQczOKoMXAlY6CX0G8yFQrrFssUAZc3ftnLsQUvG(Gzgmq(yYWWnH7U2Ci7IsmKF5Uh9H9mbYN1KOtH8rrYYjUMsZZzdgXUsMDF6m08fRrs9c(u)YeiyeI()PUXG0v9c0o(80EPryDmG2RLbpZM3u1U6Enslg0xy7Mw7SKkbrG(zkVFDpvBWICtAaM4)CW501brCe0TqvsUjde8zYQBksYlEqPjwGdR2rkyEKEOfuBkTYoewLgc)z4T3J7hcWnJsHOPH)Ui7Zv4MQOe7MxkcT7fb7C)yuC13UwDKKhB)z)O8AG74dgyQlJnL1YU5OtMi35ghF)gxs(HSD30gQZEefZRikOnoDtjBKf6yOmVimU4bPnfOXqH15TaUDxHKivAcRtkkYl8twR5)vpdqDguxFI8K4yxevqxLXy7MczQcglJz45AlIrEjhAOmgXT4o4MBaOa4wbHn(7)1Fa37BC7FIO79)Y8WAOVwwNLfNY3x8CCp5PoK5BjF(DK6yeWqUPKo8LKTJa7vuFcnLCDDfR1e1UKQheA(AYoXNMtGgPM)iJByMqHXm2emNgwMCXSjZ3(xe2YfSMG)TGIiGCUNKRUmww7AF()e7dAfdGvkdmPcktcPvW5YG7YliTQbODlB4e6sqoYdi1Oa8xX9NhhO7dqO1iNLmA4JH2vMeftxe4DNE6TCSJs2cfUxB2up85pOFWPivwOdathW6x0TFELQ(XoKcNr21fGiEA3yPuGAlJlawseUeRqmdWOve9THhzMg8FwnrApukQiZovtKhYYESJITWCLz)rHkZJAOi(ZHP1CdwGPtu1jxOCKAlVfSuQjw0ifyuq69bpq(1kA9rqkeBADarmkrlxI2LxyOYIOdy8Mkw1389X06i67BQKd9vmJfmyR4G5cGDGPQQK9I2feq5EtWpF5xBLd7j)WfECbbvTsvLUcAVgmTLksTQMuwE8x5NmaWvaRLuB0)Ccridl1)87X8KWRynsBbIRK5X9MyMT(5c1YfbgObhFgN99UuqnG8RN9)Cx5AY5w2UF1rQjdipdLskpLqUaE5cfX)jAA4cANCIb4cuOynLz4RlIzhrK6SOg7pXlrmIuPPGShSSjG)U0VVvV1kA5KZYbX6Id8CH42ZM6JVNE5T2XwuX8sXhwTc3SvdysJ9fCCfl8Mfe1d89zrhPzYWPxDRlcsjnQPe6gyZahZuQzQZQ1mdae6LFyIFuPk9nhEY6K)puVM4zKhIqahKFyEjtAUmFTyicqFHHnuKWls31qK2qRQr1cHcyvX3VZQBfPaeUoPozdz1Tkj7mNqclkhToJ))eAasHi1uAYFEZmJi(xYJCsA8G(Kkij0JjSjtdtc0HP53tGQdqIAjtRNclbN0Kd9fTqkBGTmsry2T96wbf1JXISHH(kgDUWz3zyV2p7bU2wClQsNZ9JpWDYG3vqd6NGOMadCg)Xcbfp9SYkfmY58GrKQ)KViaa7Cb8qvUcwx(AzaUidbMJZJKuFoztpPJTKtwXGEXgmUkXWAs)VEeQJEn(tmB1yHt6yqOwg)eJgAghP2m6h(Uf81eJUE5SY(CI9SYkmftI0e(cy4igQZiAtSWseZmemhVgZeczcdca51OzvOTHPjB2qM1McgZA8okCglbm4sluf3LWbWv73fX6Ouo8GkZBmnkSvhpLOwSgDMJiWAI(Bhd(XjeGghBchxMq0NlGXaWzglg0d6DnnydDAcCb8WNqZWh(32KdlkWyFIMx9SCYXEMhPe)GP8lSf6)jF1sC4dslZrF8KZu9Ygm1)qgjZBqFeHasaICfy5NIuiQMMNoMpxtEALnW0g5YEz(YtWr2bWyuRz31bzbnDW7gl2bXT8bRrxRecHbmLZeTZ37PPBZXomKoq2xT74mEBJFS2DfOD350DpRR(keu1b88ZBCyTaDZcLBkeEjLsHdZfrReTyEp19rY6nbOeb215ys8BuGBqTIQQnMi4W2bBY0C9ZTPGXUkMOS)Rp(3LCwXILLQbVp2KTNQixMSnlkPLRK(ID0MlZzTE47J15NyUZ6YYTZCV4uoRxPmIR8PbJ7mPmoBkSsTcp3AACuQnj(Vtn6J39jrmbTLjfKGSyHZP5Rit1Y9EN8jRt(52ZPKPKpnDhs(KWHXYr(NscXHkh3fDRN9RwEHIlLPuxk4M9LBk1koFrKXP8ZZpvYcpsBHGPAd5rQ5rgbejh(rtBfDWbDgq0IhO2BaJJa1c(Dq3WxNKcWfDNYffQ)0Xptu)LM3yzNBsJgTklcGJGPim6vhaZcayMFyDbTSaSFy1u6K3lCu4ae6L49DtirGoHLHbrBdkp3eGZV8RnDnHmj5ToOSuywPS19M0EF2ZBREBQkQJLs9kqgtMsoQUVLesIzmlU3a1U2ztdrlT37XQ8ePDJw94RM76DAZEMG59k7YkwX)Xm8(mi7gszzWlScN7YeXbj9EIIe5d(ut3zdnL6lDwfuJxAvKNI0i1NlqxfTzTLY4pHFnlWZRj)6wG1UiOVEGowRsQy72HjALcCu9cyGuVqVKtIEdGC1IpL8c76z5Up5HFVNDDxLmTkdINT8d6TO0oxXaoxB2HBrPDlhgkyjzAo8nm4tXR3Ktf9dUMuYoOgaGGnbtZbMbb5C6)XMnCGNBF6MgyiVf0RoosAhy7IaP2GuONaslf2kdswWKYlOL(wmVGklLDfDSCghQqEG1WJOp1q2VOpWwmXSrQX3q3zt5LzIE3Z0UyOthyhCGNIR5o3vIb9kLd6usBlg7qVSHEzZuGaAU1KeW((utZizNgBZqbB3fB3vTus9vq(rswZjAMKXqOv0KHyqfbvPR3CI5n(ZWo95gcNloBF910SdodpoBoLuoO(sSZud7wFuLN0Kkc(8uFlLeb(58CK0)mOjU)lDzMvXE9mciQWBzyLqNDejQ11zHRaI6KTn1FgU9fiaPLSePvNbdEPuV9eZHMXuykUo1NIK6LtcTSlATWubkXk)r33)bhZee5UULogPocExSkgWwsVIGhJy8UpOaV(UkXIcpMKg4CeDpXI5RBo2DVgrR8B1aGMiEbAeuxLdbcJ)aBJ5gT9N(VtWIQC23bilYZGrJ84xBWEXRPI(MEeNhdnz4Kp7ncVEFnqBTjcB3iUPMjoEq)keMAUaAjkNt1NyV9UduVzJHHNhVdc3YuWdkuNRqDuN3NAEuAIMxPR1U5N6jFuhbNshBhIN6i8(J(i8HJ(iqUtUpYdHf9Jd4qmDU5Hq7G4QmcwpOUAdGfPZdWayupT5ysTBAQ250TWC0zY6qG6PCOHJCL2836HYQdoGWL0(UXdSik8KD80hRjRO3KVMLFxjFn)2tERaGdLU1auK(Xlpi8XdOwR9ry)KwposapR96Zcx(qncwSnUNCMJV)BlJGqEyu6AdzOrTpTGjyp5f28sFqnsOCMs3nRfwWiQSDpkePLnd65r(6ThLE95WAUWc1UTin5iUizb6XboibllAmDEsMKnBoqk307wVEim1yze2ltnw6tHKRQ0Ngs7ApnjUNkf2nLVFo6p4Mf)rIIg2vVFR0nDeQdH7jhiGIx5b0hz8sJU5k1z7pzQv8Du5eCpmptDNcpjFZzK7zNtybQF20NA3GDc5Mz4SpiEfwlXx3(tF1)ii82heQG2BJJ3SLUFTyQg5xQkf5vSBKpy(f0Vjh9DLPLHDxGMloJLMABx)nEdg68oCPZo4XhLteU6DNZItF8rNJW5tovKieVNCA6Bt3rosDS25Ld71(Wxf2lozMRYvHZGH6BpesGUNAZg794Jd137vsRgylBNlMdK(x9vBnEVOlt(cb2rUURAe1h3i93hUGTRdgzwI174LhF0597IWJTC3Ui2bs3RlcpWYTiIqlSFrFi0iZ34l9Ghz9MorrP8llx6PZd8g0fRUFCP(Cv1W4vtMyUl53QVo7sIH4HCCv6Pgzq33rnwSqiwTG9HaDCBd9tw0I5GDS)rrW2B687Ia62L9sqtf)2ii(7nvFI4iBc4iHiARWvP(w5E2JYjIm222VPbI)k9s7NqcweRz2CvU8)bdQACRb2mddM198SQ3Wha1B1AyiKkMTZNnB8at0INN4ms5daao1m41ajZbolPWbYBW15NnvAyAVr8jJGnVlkoWqhrwBR80DX7h)4JABy8IzGd3xzfS(JpAMx65YdOTvEz(A7nw)FsMWn3O8)jz(kFHV)h6j9xH46(XS7YXJC)p8z4rzbPLA378Tx7nFFDv96mSKAsWsKRCvEnEancjPNGEN1ZQXZ2xggLwMBczW8JzJfPUAPwRjvIleJ1Y6sML4HwnfBzUISHE8kngQ96lTDnwvgO7iW4yz961u)9wOINsNgq4RyN2DuuNFkXt4H6JkGOOFZhWahtVhF0eR8XhLfVNcI3VQr9W6T1SHXUtywQ6aIxs(lMp2EFklrqKWSP1yEs6DyuI18ZlodoB(4bYU7NoFmQGRYF9SprTGy3LPmltyxb1UyUorzNMSdlvsQx5M23EiTKh2)H3H8KPO95D57gy)HECZXgUG8Ha(nrDcHrduyuUVTauQckV9eHtBWztAL8vbGQR4rfWclEydEqwGFTQOMbEN3S)dstGrhGjIfiKFw8NbAiKKXTBivNEuc)VQ8wS79ESExjx79(XKcqtGZSyM9vcd3B(ey3DASWe7gxzCy0xt388zN6qVr)YZF)Om7JK2vI)XAGKVR7pCJIR8bcdIJJ0JkOjw03s6UCRM0mAJDOIqoXd4b)ISV7qkBQyoKMuMiQQ3M7bHCKjeZSwXKmq6iNqMi9R7v2QpXGQ71G05aWUyZO329u7s26)E0BcKRuxALMTlMGPB4RmFUN(t53Q22Kf1i1c8mnvsD3m6qeyC4bdP9OYpR)5rEXzJhboafkyyYV49fiV1M4b4YWjLXHann(uhqDhGRmVHnN1TLHPldtCx0cOFMC6jSVgSNn5uZSEoxJNMncLVr)Zfmrm(f0h6xNZM8IRfmbiULHMFnPmg6EZEgYoHdF9mVbDhwuBZf3RfdumVA5vw4fcLrxCGmlfkl(Z25QI)edffpQUPui8WprQsE4p5ItZg7C6q4z9lYXfk6Vu2T4hT3VPHjo0ME1zZ9Wuh0stI2WbYs(O1sJYYsEhndZOJ0r2Zt385dNm9BE7xZMowYqc3Ug3zJC9qyZALdWngJxsKSWa388uIWBYyIk)Fkp3VwLJcBp41SeePyPSxoUqBTdmBOLknpXkbOnEUW124MJjWrhtdh7lL0PVW6rlEqh7fIWoYOq4AU3eDJPXg6JxmvvCXTSzhzj2pxYsg6ugrvxNdh295qMfgJ0zq2BWRCkKyybZJOB(NRZkCNRdTbMn00bjgT2AOiTKWQXp0Wg(rUKd34nMwDbxRIhr4ZMYwMfpAWCCMgwnjeMEc7gynDDuYt7m6I0e)a)U4DJhOxBxwEXbM9f6r8qj7Ew4uCE(yR4CpBUHrI(KXweQj0HELJrL0FzDKB3fjrhqw6R54ZNOxbscN7wUePAzgjTsrwjTGeegqdiLnSaQOxioBqA0SqS8C5SPEu6uy6nfbFyPEXK(Aj8Y90V2LeHi8(H2zSgvk8EUb531KHfDLnrHfZ7QdAo3Pe2HEPsYSEAQVN4PT1)DoC0RXJUAKC(A(J0hRiZtDmrCQWM6dyiG787QpjrUN9pxXfAQ6l7r(dGOWmu(Pcg)hy1M)zJ1JOZDaNhOilfcQ0smSEoxt6PvMz9PtoIyZPatE5)1)PxSPwalhvmc9HweDvAS7ho0kLy0BeFlrFP4CfKAoUFJECYLnLabRquNz3tS4jfyheSm0rw8Fl3r7fKH(maoajyCkXakCK)U6iqq0X43l(S088ihIzZv5VH5x4UNJnto16ojBArIiHCTHEEEs52CX9fQDWpCPnJhf9F9jY558tKJjbkDBJDMKatFYC6RO15tBDzYhAHujzkOD9y0NBocDxoJv8BJyp3)SyC8tJHoZB3lMonMhppAYDSWeXy6dT(bm4lu6f9OyEpqFkyCOA0f2)PM9MmO5ypikbWyw6thYK5i9zEXXKtdGR5uHAg7R28wryw879W5nBB683O3BeoPxFW)(0W4(h3pgl7InDrvuog1NGcpODBj9QwvI77MbOJAubzYmpVEqE2n(yr7BqpoBUN)wXc2wzVCmPkm0qYvzPlWtoebrfLfIBiVdxXgPeLKu)I9JCYUyrspKB7gQmTa3e94UfQoiP1h7rh44X7hIF7YfodswpD1ZOLj6(8nfXXs5EfNSZuRRzQtjGzlMcLsOoT2xBZMoRai1ZL(s6glxHLessg8VwtlplQMf2bez9aHZscTV55NN4SgBh1RajvZ3NxuYXPtRpf03H6mWAcmokgC6y410mLh(V4kl2tJUfFlKF(5pJeNEiZIEhRzDdE1cm1xzY2BxsipLmCRgn5ti13pjLgz3PDbQOB4s9o(hlqq2vLplOXnejkEcSeXLTIEN89L372XmlWM4Hs(J2n3rDjKz0)JRC1A4y6pQ944dVvZxWkKyfGzp90bKpmvwEntFUN06HhFu4Fo)uMSJ0xpOwlzQF5GoVj5iClh8w4nG8faYcLjEnnOqrNo(Grco4M4Z1gylTVq4B)uFFhTVmskV47hZtbSXVGsw4AcFeLoECnxe2a(N1P6Qv5fxEXf0kCfi1pwaHaqUyTV8))p]] )
