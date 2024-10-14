OptionsInit()
{
	menuModels = [];
	foreach(model in getEntArray("script_model", "classname"))
		if (!isInArray(menuModels, model.model))
			menuModels[menuModels.size] = model.model;
	foreach(model in level.addtionalmodels)
		if (!isInArray(menuModels, model))
			menuModels[menuModels.size] = model;
	menuModels = remove_duplicate_entries(menuModels);

	relics = ["nerf_take_more_damage", "nerf_higher_threat_bias", "nerf_pistols_only", "nerf_smaller_wallet", "nerf_no_class", "nerf_lower_weapon_damage", "nerf_fragile", "nerf_move_slower", "nerf_no_abilities", "nerf_min_ammo", "nerf_no_deployables"];

	perks = ["specialty_armorpiercing", "specialty_explosivebullets", "specialty_marathon", "specialty_fastreload", "specialty_stalker", "specialty_quickdraw", "specialty_quickswap", "specialty_fastoffhand", "specialty_fastsprintrecovery", "specialty_falldamage", "specialty_bulletdamage", "specialty_selectivehearing", "specialty_longersprint", "specialty_fastermelee"];

	attachments = ["alienmuzzlebrake", "xmags", "vzscope", "thermal", "rof", "reflex", "ironsight", "grip", "eotech", "barrelrange", "acog", "firetypeburst"];

	map = (getDvar("mapname"));

	if (map == "mp_alien_armory")
	{
		level.AR = ["iw6_aliendlc13_mp", "iw6_aliendlc15_mp"];
		level.SG = ["iw6_alienmaul_mp", "iw6_alienmts255_mp"];
		level.SMG = ["iw6_alienkriss_mp", "iw6_alienvepr_mp"];
		level.LMG = ["iw6_aliendlc12_mp", "iw6_alienkac_mp"];
		level.SR = ["iw6_alienl115a3_mp", "iw6_alienvks_mp", "iw6_alieng28_mp", "iw6_aliendlc14_mp"];
		level.Special = ["iw6_aliendlc11_mp", "iw5_alienriotshield_mp", "iw6_alienminigun_mp", "iw6_alienrgm_mp", "iw6_alienmk32_mp", "iw6_alienmk321_mp", "iw6_alienmk322_mp", "aliensemtex_mp", "alienmortar_shell_mp", "alienbetty_mp", "alienclaymore_mp", "alientrophy_mp", "alienthrowingknife_mp", "alienflare_mp", "aliensoflam_mp"];
		level.Other = ["alienbomb_mp", "defaultweapon_mp", "alienvulture_mp", "aliensoflam_missle_mp", "alienspit_mp", "alienspit_gas_mp", "breach_plant_mp"];
		level.challenges = ["spend_10k", "spend_20k", "kill_leper", "spend_no_money", "no_reloads", "no_abilities", "melee_5_goons", "melee_spitter", "focus_fire", "healthy_kills", "minion_preexplode", "kill_nodamage", "no_stuck_drill", "stay_prone", "kill_10_with_traps", "avoid_minion_explosion", "stay_within_area", "long_shot", "pistols_only", "shotguns_only", "snipers_only", "lmgs_only", "ar_only", "smg_only", "kill_10_with_turrets", "kill_airborne_aliens", "50_percent_accuracy", "kill_10_in_30", "protect_player", "no_laststand", "no_bleedout"];
	}
	if (map == "mp_alien_beacon")
	{
		level.AR = ["iw6_alienhoneybadger_mp", "iw6_altalienarx_mp"];
		level.SG = ["iw6_alienmaul_mp", "iw6_alienfp6_mp"];
		level.SMG = ["iw6_aliencbjms_mp", "iw6_alienmicrotar_mp", "iw6_aliendlc23_mp"];
		level.LMG = ["iw6_altalienlsat_mp", "iw6_alienkac_mp"];
		level.SR = ["iw6_alienvks_mp", "iw6_alieng28_mp", "iw6_altaliensvu_mp"];
		level.Special = ["iw6_aliendlc11_mp", "iw6_aliendlc11li_mp", "iw6_aliendlc11fi_mp", "iw6_aliendlc11sp_mp", "iw6_alienpanzerfaust3_mp", "iw5_alienriotshield_mp", "iw6_alienminigun_mp", "iw6_alienrgm_mp", "iw6_alienmk32_mp", "iw6_alienmk321_mp", "iw6_alienmk322_mp", "iw6_alienmaaws_mp", "iw6_alienmaawschild_mp", "aliensemtex_mp", "alienmortar_shell_mp", "alienbetty_mp", "alienclaymore_mp", "iw6_aliendlc22_mp", "iw6_aliendlc21_mp", "alientrophy_mp", "alienthrowingknife_mp", "alienflare_mp", "alienpropanetank_mp", "aliensoflam_mp"];
		level.Other = ["alienbomb_mp", "defaultweapon_mp", "alienvulture_mp", "aliensoflam_missle_mp", "alienspit_mp", "alienspit_gas_mp", "seeder_spit_mp", "killstreak_remote_turret_remote_mp"];
		level.challenges = ["spend_10k", "spend_20k", "kill_leper", "spend_no_money", "no_reloads", "no_abilities", "melee_5_goons", "melee_spitter", "focus_fire", "healthy_kills", "minion_preexplode", "kill_nodamage", "no_stuck_drill", "stay_prone", "kill_10_with_traps", "avoid_minion_explosion", "stay_within_area", "long_shot", "pistols_only", "shotguns_only", "snipers_only", "lmgs_only", "ar_only", "smg_only", "kill_10_with_turrets", "kill_airborne_aliens", "50_percent_accuracy", "kill_10_in_30", "protect_player", "no_laststand", "no_bleedout"];
	}
	if (map == "mp_alien_dlc3")
	{
		level.AR = ["iw6_arkalienr5rgp_mp", "iw6_arkaliendlc15_mp"];
		level.SG = ["iw6_arkalienmaul_mp", "iw6_arkalienuts15_mp"];
		level.SMG = ["iw6_arkalienk7_mp", "iw6_arkaliendlc23_mp"];
		level.LMG = ["iw6_arkalienameli_mp", "iw6_arkalienkac_mp"];
		level.SR = ["iw6_arkalienusr_mp", "iw6_arkalienvks_mp", "iw6_arkalienmk14_mp", "iw6_arkalienimbel_mp"];
		level.Special = ["iw6_aliendlc11_mp", "iw6_aliendlc11li_mp", "iw6_aliendlc11fi_mp", "iw6_aliendlc11sp_mp", "iw5_alienriotshield_mp", "iw6_alienminigun_mp", "iw6_alienrgm_mp", "iw6_alienmk32_mp", "iw6_alienmk321_mp", "iw6_alienmk322_mp", "iw6_alienmaaws_mp", "iw6_alienmaawschild_mp", "aliensemtex_mp", "alienmortar_shell_mp", "alienbetty_mp", "alienclaymore_mp", "iw6_aliendlc22_mp", "iw6_aliendlc21_mp", "alientrophy_mp", "alienthrowingknife_mp", "alienflare_mp", "iw6_aliendlc31_mp", "iw6_aliendlc32_mp", "iw6_aliendlc33_mp", "aliensoflam_mp"];
		level.Other = ["alienbomb_mp", "defaultweapon_mp", "alienvulture_mp", "aliensoflam_missle_mp", "alienspit_mp", "alienspit_gas_mp", "breach_plant_mp", "aliencortex_mp"];
		level.challenges = ["spend_10k", "spend_20k", "kill_leper", "spend_no_money", "no_reloads", "no_abilities", "melee_5_goons_dlc3", "team_prone", "jump_shot", "lower_ground", "higher_ground", "flying_aliens", "melee_gargoyles", "bomber_preexplode", "melee_spitter", "focus_fire", "healthy_kills", "new_weapon", "kill_nodamage", "no_stuck_drill", "stay_prone", "kill_10_with_traps", "stay_within_area", "long_shot", "pistols_only", "shotguns_only", "snipers_only", "lmgs_only", "ar_only", "smg_only", "kill_airborne_aliens", "50_percent_accuracy", "kill_10_in_30", "protect_player", "no_laststand", "no_bleedout", "2_weapons_only", "semi_autos_only"];
	}
	if (map == "mp_alien_last")
	{
		level.AR = ["iw6_arkalienr5rgp_mp", "iw6_arkaliendlc15_mp"];
		level.SG = ["iw6_arkalienmaul_mp", "iw6_arkalienuts15_mp"];
		level.SMG = ["iw6_arkalienk7_mp", "iw6_arkaliendlc23_mp"];
		level.LMG = ["iw6_arkalienameli_mp", "iw6_arkalienkac_mp"];
		level.SR = ["iw6_arkalienusr_mp", "iw6_arkalienvks_mp", "iw6_arkalienmk14_mp", "iw6_arkalienimbel_mp"];
		level.Other = ["defaultweapon_mp", "alienvulture_mp", "aliensoflam_missle_mp", "alienspit_mp", "alienspit_gas_mp", "breach_plant_mp", "killstreak_remote_turret_remote_mp", "alien_ancestor_mp"];
		level.Special = ["iw6_aliendlc41_mp", "iw6_aliendlc42_mp", "iw5_alienriotshield_mp", "iw6_alienminigun_mp", "iw6_alienrgm_mp", "iw6_alienmk32_mp", "iw6_alienmk321_mp", "iw6_alienmk322_mp", "iw6_alienmaaws_mp", "iw6_alienmaawschild_mp", "aliensemtex_mp", "alienmortar_shell_mp", "alienbetty_mp", "alienclaymore_mp", "iw6_aliendlc22_mp", "iw6_aliendlc21_mp", "alientrophy_mp", "alienthrowingknife_mp", "alienflare_mp", "iw6_aliendlc31_mp", "iw6_aliendlc32_mp", "iw6_aliendlc33_mp", "iw6_aliendlc43_mp", "aliensoflam_mp"];
		level.challenges = ["spend_10k", "spend_20k", "kill_leper", "spend_no_money", "no_reloads", "no_abilities", "melee_5_goons_last", "melee_spitter", "focus_fire", "healthy_kills", "minion_preexplode", "kill_nodamage", "no_stuck_drill", "stay_prone", "kill_10_with_traps", "avoid_minion_explosion", "stay_within_area_1", "stay_within_area_2", "stay_within_area_3", "stay_within_area_4", "stay_within_area_5", "long_shot", "pistols_only", "shotguns_only", "snipers_only", "lmgs_only", "ar_only", "smg_only", "kill_10_with_turrets", "kill_airborne_aliens", "50_percent_accuracy", "kill_10_in_30", "no_laststand", "no_bleedout", "semi_autos_only", "2_weapons_only", "bomber_preexplode", "melee_gargoyles", "new_weapon", "kill_ancestor", "weakpoint_ancestor", "no_ancestor_damage", "flying_aliens", "higher_ground", "lower_ground", "team_prone"];
	}
	if (map == "mp_alien_town")
	{
		level.AR = ["iw6_aliensc2010_mp", "iw6_alienbren_mp", "iw6_alienak12_mp", "iw6_alienhoneybadger_mp"];
		level.SG = ["iw6_alienmaul_mp", "iw6_alienfp6_mp", "iw6_alienmts255_mp"];
		level.SMG = ["iw6_alienpp19_mp", "iw6_aliencbjms_mp", "iw6_alienkriss_mp", "iw6_alienvepr_mp", "iw6_alienmicrotar_mp"];
		level.LMG = ["iw6_alienm27_mp", "iw6_alienkac_mp"];
		level.SR = ["iw6_alienl115a3_mp", "iw6_alienvks_mp", "iw6_alieng28_mp", "iw6_alienimbel_mp"];
		level.Special = ["iw5_alienriotshield_mp", "iw6_alienminigun_mp", "iw6_alienrgm_mp", "iw6_alienpanzerfaust3_mp", "iw6_alienmk32_mp", "iw6_alienmk321_mp", "iw6_alienmk322_mp", "aliensemtex_mp", "alienmortar_shell_mp", "alienbetty_mp", "alienclaymore_mp", "alientrophy_mp", "alienthrowingknife_mp", "alienflare_mp", "alienpropanetank_mp", "aliensoflam_mp"];
		level.Other = ["alienbomb_mp", "defaultweapon_mp", "alienvulture_mp", "aliensoflam_missle_mp", "alienspit_mp", "alienspit_gas_mp"];
		level.challenges = ["spend_10k", "melee_only", "spend_20k", "kill_leper", "spend_no_money", "no_reloads", "no_abilities", "take_no_damage", "melee_5_goons", "melee_spitter", "no_stuck_drill", "kill_10_with_propane", "stay_prone", "kill_10_with_traps", "avoid_minion_explosion", "75_percent_accuracy", "pistols_only", "shotguns_only", "snipers_only", "lmgs_only", "ar_only", "smg_only", "kill_10_with_turrets", "kill_airborne_aliens", "50_percent_accuracy", "kill_10_in_30", "protect_player", "no_laststand", "no_bleedout"];
	}

	CreateRoot("[Revival]");
	AddSubMenu("Main Mods", 1);
	AddOption("God Mode", ::void_handler, 0);
	AddOption("Infinite Ammo", ::void_handler, 1);
	AddOption("No Target", ::void_handler, 2);
	AddOption("Floating Head", ::void_handler, 3);
	AddOption("Basic Forge Mode", ::void_handler, 4);
	AddOption("No Clip", ::void_handler, 6);
	AddOption("Third Person", ::void_handler, 7);
	AddOption("Toggle Aimbot", ::void_handler, 8);
	AddOption("Spawn Clone", ::void_handler, 11);
	AddOption("Spawn Dead Clone", ::void_handler, 12);
	AddSubMenu("Perks Menu", 1);
	AddOption("Give all Perks", ::void_handler, 193, 1);
	AddOption("Take all Perks", ::void_handler, 193, 0);
	foreach(perk in perks)
		AddOption(perk, ::void_handler, 16, perk);
	CloseSubMenu();
	AddSubMenu("Money Menu", 1);
	AddOption("Give 1K", ::void_handler, 17, 1000);
	AddOption("Give 10K", ::void_handler, 17, 10000);
	AddOption("Give 100K", ::void_handler, 17, 100000);
	AddOption("Give Max Points", ::void_handler, 17, 2000000);
	AddOption("Give Min Points", ::void_handler, 18, -999999);
	AddOption("Take 100K", ::void_handler, 5, 100000);
	AddOption("Take 10K", ::void_handler, 5, 10000);
	AddOption("Take 1K", ::void_handler, 5, 1000);
	CloseSubMenu();
	AddSubMenu("FOV Menu", 1);
	AddOption("Set FOV to 120", ::void_handler, 19, 120);
	AddOption("Set FOV to 100", ::void_handler, 19, 100);
	AddOption("Set FOV to 90", ::void_handler, 19, 90);
	AddOption("Set FOV to 75", ::void_handler, 19, 75);
	AddOption("Set FOV to 65", ::void_handler, 19, 65);
	CloseSubMenu();
	AddSubMenu("Account Menu", 1);
	AddOption("Master Prestige", ::void_handler, 99);
	AddOption("kurssse Prestige", ::void_handler, 100);
	AddOption("Teeth", ::void_handler, 101);
	CloseSubMenu();
	CloseSubMenu();
	AddSubMenu("Weapons Menu", 1);
	AddSubMenu("Weapons Options", 2);
	AddSubMenu("Give Attachment", 2);
	foreach(attachment in attachments)
		AddOption(attachment, ::void_handler, 21, attachment);
	CloseSubMenu();
	AddOption("Drop Weapon", ::void_handler, 23);
	AddSubMenu("Bullets Menu", 2);
	AddOption("Default", ::void_handler, 43, 0, "norm");
	AddOption("Death Machiine", ::void_handler, 43, 0, "iw6_alienminigun_mp");
	AddOption("Kastet", ::void_handler, 43, 0, "iw6_alienrgm_mp");
	AddOption("MK32", ::void_handler, 43, 0, "iw6_alienmk322_mp");
	AddOption("SOFLAM", ::void_handler, 43, 0, "aliensoflam_missile_mp");
	AddOption("Vulture Rocket", ::void_handler, 43, 0, "alienvulture_mp");
	if (map == "mp_alien_town")
	{
		AddOption("L115", ::void_handler, 43, 0, "iw6_alienl115a3_mp");
		AddOption("Panzerfaust", ::void_handler, 43, 0, "iw6_alienpanzerfaust3_mp");
	}
	if (map == "mp_alien_armory")
	{
		AddOption("Venom-X", ::void_handler, 43, 0, "iw6_aliendlc11_mp");
		AddOption("VKS", ::void_handler, 43, 0, "iw6_alienvks_mp");
	}
	if (map == "mp_alien_beacon")
	{
		AddOption("Venom-X", ::void_handler, 43, 0, "iw6_aliendlc11_mp");
		AddOption("Venom-LX", ::void_handler, 43, 0, "iw6_aliendlc11li_mp");
		AddOption("Venom-FX", ::void_handler, 43, 0, "iw6_aliendlc11fi_mp");
		AddOption("Venom-SX", ::void_handler, 43, 0, "iw6_aliendlc11fsp_mp");
		AddOption("VKS", ::void_handler, 43, 0, "iw6_alienvks_mp");
	}
	if (map == "mp_alien_dlc3")
	{
		AddOption("Venom-X", ::void_handler, 43, 0, "iw6_aliendlc11_mp");
		AddOption("Venom-LX", ::void_handler, 43, 0, "iw6_aliendlc11li_mp");
		AddOption("Venom-FX", ::void_handler, 43, 0, "iw6_aliendlc11fi_mp");
		AddOption("USR", ::void_handler, 43, 0, "iw6_alienusr_mp");
		AddOption("MAAWS", ::void_handler, 43, 0, "iw6_alienmaaws_mp");
		AddOption("Cortex", ::void_handler, 43, 0, "aliencortex_mp");
	}
	if (map == "mp_alien_last")
	{
		AddOption("Disruptor Charged", ::void_handler, 43, 0, "iw6_aliendlc42_mp");
		AddOption("Disruptor Single", ::void_handler, 43, 0, "iw6_aliendlc41_mp");
		AddOption("Ancestor Black Hole", ::void_handler, 43, 0, "alien_ancestor_mp");
		AddOption("USR", ::void_handler, 43, 0, "iw6_alienusr_mp");
		AddOption("MAAWS", ::void_handler, 43, 0, "iw6_alienmaaws_mp");
	}
	CloseSubMenu();
	CloseSubMenu();
	AddSubMenu("Pistols", 1);
	AddOption("iw6_alienm9a1_mp", ::void_handler, 20, "iw6_alienm9a1_mp");
	AddOption("iw6_alienmp443_mp", ::void_handler, 20, "iw6_alienmp443_mp");
	AddOption("iw6_alienp226_mp", ::void_handler, 20, "iw6_alienp226_mp");
	AddOption("iw6_alienmagnum_mp", ::void_handler, 20, "iw6_alienmagnum_mp");
	CloseSubMenu();
	AddSubMenu("Assault Rifles", 1);
	foreach(weapon in level.AR)
		AddOption(weapon, ::void_handler, 20, weapon);
	CloseSubMenu();
	AddSubMenu("SMG", 1);
	foreach(weapon in level.SMG)
		AddOption(weapon, ::void_handler, 20, weapon);
	CloseSubMenu();
	AddSubMenu("Snipers and DMR", 1);
	foreach(weapon in level.SR)
		AddOption(weapon, ::void_handler, 20, weapon);
	CloseSubMenu();
	AddSubMenu("LMG", 1);
	foreach(weapon in level.LMG)
		AddOption(weapon, ::void_handler, 20, weapon);
	CloseSubMenu();
	AddSubMenu("Shotgun", 1);
	foreach(weapon in level.SG)
		AddOption(weapon, ::void_handler, 20, weapon);
	CloseSubMenu();
	AddSubMenu("Specials/Equipment", 1);
	foreach(weapon in level.Special)
		AddOption(weapon, ::void_handler, 20, weapon);
	CloseSubMenu();
	AddSubMenu("Other Weapons", 1);
	foreach(weapon in level.Other)
		AddOption(weapon, ::void_handler, 20, weapon);
	CloseSubMenu();
	CloseSubMenu();
	AddSubMenu("Fun Menu", 1);
	AddOption("Save Load Position", ::void_handler, 34);
	AddOption("Jet Pack", ::void_handler, 35);
	AddOption("Portal Gun", ::void_handler, 36);
	AddSubMenu("Vision Menu", 1);
	AddOption("Normal", ::void_handler, 37, "norm");
	AddOption("Thermal", ::void_handler, 37, "mp_alien_thermal_trinity");
	AddOption("Black Screen", ::void_handler, 37, "black_bw");
	AddOption("Enhanced", ::void_handler, 37, "cheat_bw");
	AddOption("Blind", ::void_handler, 37, "coup_sunblind");
	AddOption("Night", ::void_handler, 37, "default_night");
	AddOption("Red Screen", ::void_handler, 37, "near_death");
	CloseSubMenu();
	AddOption("Ricochet Bullets", ::void_handler, 184);
	CloseSubMenu();
	AddSubMenu("Models Menu", 2);
	AddOption("Reset Model", ::void_handler, 42);
	AddOption("alien_goon", ::void_handler, 44, "alien_goon");
	AddOption("alien_brute", ::void_handler, 44, "alien_brute");
	AddOption("alien_minion", ::void_handler, 44, "alien_minion");
	AddOption("alien_spitter", ::void_handler, 44, "alien_spitter");
	AddOption("alien_queen", ::void_handler, 44, "alien_queen");
	if (map == "mp_alien_armory")
	{
		AddOption("alien_locust", ::void_handler, 44, "alien_locust");
		AddOption("alien_spider", ::void_handler, 44, "alien_spider");
	}
	if (map == "mp_alien_beacon")
	{
		AddOption("alien_locust", ::void_handler, 44, "alien_locust");
		AddOption("alien_eeder", ::void_handler, 44, "alien_seeder");
		AddOption("alien_squid", ::void_handler, 44, "alien_squid");
	}
	if (map == "mp_alien_dlc3")
	{
		AddOption("alien_locust", ::void_handler, 44, "alien_locust");
		AddOption("alien_bomber", ::void_handler, 44, "alien_bomber");
		AddOption("alien_mammoth", ::void_handler, 44, "alien_mammoth");
		AddOption("alien_gargoyle", ::void_handler, 44, "alien_gargoyle");
	}
	if (map == "mp_alien_last")
	{
		AddOption("alien_locust", ::void_handler, 44, "alien_locust");
		AddOption("alien_bomber", ::void_handler, 44, "alien_bomber");
		AddOption("alien_mammoth", ::void_handler, 44, "alien_mammoth");
		AddOption("alien_gargoyle", ::void_handler, 44, "alien_gargoyle");
		AddOption("alien_ancestor", ::void_handler, 44, "alien_ancestor");
	}
	CloseSubMenu();
	AddSubMenu("Forge Menu", 2);
	AddOption("Forge Tool", ::void_handler, 46);
	foreach(model in menuModels)
	{
		AddOption(model, ::void_handler, 45, model);
	}
	CloseSubMenu();
	AddSubmenu("Aliens Menu", 3);
	AddSubMenu("Spawn Menu", 3);
	AddSubMenu("Enemy", 3);
	AddOption("Scout", ::void_handler, 48, "goon");
	AddOption("Scorpion", ::void_handler, 48, "spitter");
	AddOption("Hunter", ::void_handler, 48, "brute");
	AddOption("Seeker", ::void_handler, 48, "minion");
	AddOption("Rhino", ::void_handler, 48, "elite");
	AddOption("Leper", ::void_handler, 48, "leper");
	if (map == "mp_alien_armory")
	{
		AddOption("Phantom", ::void_handler, 48, "locust");
	}
	if (map == "mp_alien_beacon")
	{
		AddOption("Phantom", ::void_handler, 48, "locust");
		AddOption("Seeder", ::void_handler, 48, "seeder");
	}
	if (map == "mp_alien_dlc3")
	{
		AddOption("Phantom", ::void_handler, 48, "locust");
		AddOption("Bomber", ::void_handler, 48, "bomber");
		AddOption("Mammoth", ::void_handler, 48, "mammoth");
		AddOption("Gargoyle", ::void_handler, 48, "gargoyle");
	}
	if (map == "mp_alien_last")
	{
		AddOption("Phantom", ::void_handler, 48, "locust");
		AddOption("Bomber", ::void_handler, 48, "bomber");
		AddOption("Mammoth", ::void_handler, 48, "mammoth");
		AddOption("Gargoyle", ::void_handler, 48, "gargoyle");
		AddOption("Ancestor", ::void_handler, 48, "ancestor");
	}
	CloseSubMenu();
	AddSubMenu("Friendly", 3);
	AddOption("Scout", ::void_handler, 47, "goon");
	AddOption("Scorpion", ::void_handler, 47, "spitter");
	AddOption("Hunter", ::void_handler, 47, "brute");
	AddOption("Seeker", ::void_handler, 47, "minion");
	AddOption("Rhino", ::void_handler, 47, "elite");
	AddOption("Leper", ::void_handler, 47, "leper");
	if (map == "mp_alien_armory")
		AddOption("Phantom", ::void_handler, 47, "locust");
	if (map == "mp_alien_beacon")
	{
		AddOption("Phantom", ::void_handler, 47, "locust");
		AddOption("Seeder", ::void_handler, 47, "seeder");
	}
	if (map == "mp_alien_dlc3")
	{
		AddOption("Phantom", ::void_handler, 47, "locust");
		AddOption("Bomber", ::void_handler, 47, "bomber");
		AddOption("Mammoth", ::void_handler, 47, "mammoth");
		AddOption("Gargoyle", ::void_handler, 47, "gargoyle");
	}
	if (map == "mp_alien_last")
	{
		AddOption("Phantom", ::void_handler, 47, "locust");
		AddOption("Bomber", ::void_handler, 47, "bomber");
		AddOption("Mammoth", ::void_handler, 47, "mammoth");
		AddOption("Gargoyle", ::void_handler, 47, "gargoyle");
		AddOption("Ancestor", ::void_handler, 47, "ancestor");
	}
	CloseSubMenu();
	CloseSubMenu();
	AddOption("Kill All Aliens", ::void_handler, 49);
	AddOption("Tele to Me", ::void_handler, 50);
	AddOption("Tele to Crosshair", ::void_handler, 51);
	AddOption("Toggle Spawn", ::void_handler, 52);
	CloseSubMenu();
	AddSubMenu("Loadout Menu", 2);
	AddOption("Max Skill Points", ::void_handler, 58);
	AddOption("Quad Class", ::void_handler, 60);
	AddSubMenu("Ammo Types", 2);
	AddOption("Cryptid Slayer", ::void_handler, 75, "deployable_specialammo_comb");
	AddOption("Incendiary", ::void_handler, 75, "deployable_specialammo_in");
	AddOption("Armor Piercing", ::void_handler, 75, "deployable_specialammo_ap");
	AddOption("Stun", ::void_handler, 75, "deployable_specialammo");
	AddOption("Explosive", ::void_handler, 75, "deployable_specialammo_explo");
	CloseSubMenu();
	AddOption("Infinite Feral", ::void_handler, 59);
	AddSubMenu("Relics Menu", 2);
	foreach(relic in relics)
		AddOption(relic, ::void_handler, 86, relic);
	CloseSubMenu();
	CloseSubMenu();
	AddSubmenu("Cycle Menu", 3);
	AddOption("+1 Cycle Count", ::void_handler, 61);
	AddOption("-1 Cycle Count", ::void_handler, 62);
	if (map == "mp_alien_town")
	{
		AddOption("Skip to Escape", ::void_handler, 40);
	}
	CloseSubMenu();
	AddSubmenu("Map Mods", -1);
	AddOption("Respawn All Pillage", ::void_handler, 38);
	AddSubMenu("Challenge Menu", -1);
	AddOption("Reroll", ::void_handler, 9);
	AddOption("Random Challenges", ::void_handler, 10);
	AddSubMenu("Choose Challenge", -1);
	foreach(challenge in level.challenges)
		AddOption(challenge, ::void_handler, 13, challenge);
	CloseSubMenu();
	CloseSubMenu();
	if (map == "mp_alien_town")
	{
		AddOption("Infinite LOL EE", ::void_handler, 39);
	}
	if (map == "mp_alien_armory")
		AddOption("Infinite ZAP EE", ::void_handler, 39);
	if (map == "mp_alien_dlc3")
		AddOption("Infinite Mushroom EE", ::void_handler, 39);
	CloseSubMenu();
	AddSubMenu("Lobby Mods", 4);
	AddOption("End Game", ::void_handler, 67);
	AddOption("Restart Map", ::void_handler, 68);
	AddOption("Toggle FPS", ::void_handler, 70);
	AddOption("Auto Revive", ::void_handler, 74);
	CloseSubMenu();
	AddSubmenu("Game Settings", 4);
	AddOption("Anti-Join", ::void_handler, 78);
	AddOption("Super Jump", ::void_handler, 80);
	AddOption("Super Melee Aimbot", ::void_handler, 81);
	AddOption("Super Knockback", ::void_handler, 82);
	AddSubmenu("Edit Gravity", 4);
	AddOption("Gravity: 250", ::void_handler, 85, 250);
	AddOption("Gravity: 500", ::void_handler, 85, 500);
	AddOption("Gravity: Default", ::void_handler, 85, 800);
	AddOption("Gravity: 1000", ::void_handler, 85, 1000);
	AddOption("Gravity: 1250", ::void_handler, 85, 1250);
	CloseSubMenu();
	CloseSubMenu();
	AddSubmenu("Menu Colors", 1);
	AddSubmenu("Frame Color", 1);
	AddOption("Default", ::void_handler, 30, 0, .75, 0);
	AddOption("White", ::void_handler, 30, 1, 1, 1);
	AddOption("Blue", ::void_handler, 30, 0, 0, 1);
	AddOption("Black", ::void_handler, 30, 0, 0, 0);
	AddOption("Red", ::void_handler, 30, 1, 0, 0);
	AddOption("Pink", ::void_handler, 30, 1, 0, 1);
	AddOption("Purple", ::void_handler, 30, .25, 0, .25);
	AddOption("Yellow", ::void_handler, 30, 1, 1, 0);
	AddOption("Light Blue", ::void_handler, 30, 0, 1, 1);
	AddOption("Dark Blue", ::void_handler, 30, 0, 0, .35);
	AddOption("Dark Red", ::void_handler, 30, .35, 0, 0);
	AddOption("Dark Green", ::void_handler, 30, 0, .15, 0);
	CloseSubMenu();
	AddSubmenu("Background Color", 1);
	AddOption("Default", ::void_handler, 31, 0, 0, 0);
	AddOption("White", ::void_handler, 31, 1, 1, 1);
	AddOption("Blue", ::void_handler, 31, 0, 0, 1);
	AddOption("Green", ::void_handler, 31, 0, 1, 0);
	AddOption("Red", ::void_handler, 31, 1, 0, 0);
	AddOption("Pink", ::void_handler, 31, 1, 0, 1);
	AddOption("Purple", ::void_handler, 31, .25, 0, .25);
	AddOption("Yellow", ::void_handler, 31, 1, 1, 0);
	AddOption("Light Blue", ::void_handler, 31, 0, 1, 1);
	AddOption("Dark Blue", ::void_handler, 31, 0, 0, .35);
	AddOption("Dark Red", ::void_handler, 31, .35, 0, 0);
	AddOption("Dark Green", ::void_handler, 31, 0, .15, 0);
	CloseSubMenu();
	AddSubmenu("Slider Color", -1);
	AddOption("Default", ::void_handler, 32, 0, 1, 0);
	AddOption("White", ::void_handler, 32, 1, 1, 1);
	AddOption("Blue", ::void_handler, 32, 0, 0, 1);
	AddOption("Black", ::void_handler, 32, 0, 0, 0);
	AddOption("Red", ::void_handler, 32, 1, 0, 0);
	AddOption("Pink", ::void_handler, 32, 1, 0, 1);
	AddOption("Purple", ::void_handler, 32, .25, 0, .25);
	AddOption("Yellow", ::void_handler, 32, 1, 1, 0);
	AddOption("Light Blue", ::void_handler, 32, 0, 1, 1);
	AddOption("Dark Blue", ::void_handler, 32, 0, 0, .35);
	AddOption("Dark Red", ::void_handler, 32, .35, 0, 0);
	AddOption("Dark Green", ::void_handler, 32, 0, .15, 0);
	CloseSubMenu();
	AddOption("Rainbow Menu", ::void_handler, 33);
	CloseSubMenu();
	AddPlayersMenu();
	AddSubmenu("Main Mods", 3);
	AddOption("Toggle Godmode", ::PlayersManager, 0, 0);
	AddOption("Infinite Ammo", ::PlayersManager, 0, 1);
	AddOption("No Target", ::PlayersManager, 0, 2);
	AddOption("Floating Head", ::PlayersManager, 0, 3);
	AddOption("Forge Mode", ::PlayersManager, 0, 4);
	AddOption("No Clip", ::PlayersManager, 0, 6);
	AddOption("Toggle Aimbot", ::PlayersManager, 0, 8);
	AddOption("Revive Player", ::PlayersManager, 0, 10);
	AddOption("Kill Player", ::PlayersManager, 0, 13);
	CloseSubMenu();
	AddSubmenu("Money Menu", 3);
	AddOption("Give 1000", ::PlayersManager, 0, 17, 1000);
	AddOption("Give 10000", ::PlayersManager, 0, 17, 10000);
	AddOption("Give 100000", ::PlayersManager, 0, 17, 100000);
	AddOption("Give Max", ::PlayersManager, 0, 17, 2000000);
	AddOption("Give Min", ::PlayersManager, 0, 18, -999999);
	AddOption("Take 100000", ::PlayersManager, 0, 5, 100000);
	AddOption("Take 10000", ::PlayersManager, 0, 5, 10000);
	AddOption("Take 1000", ::PlayersManager, 0, 5, 1000);
	CloseSubMenu();
	AddSubmenu("Weapons Menu", 3);
	AddSubmenu("Weapons Options", 3);
	AddSubMenu("Give Attachment", 3);
	foreach(attachment in attachments)
		AddOption(attachment, ::PlayersManager, 21, attachment);
	CloseSubMenu();
	AddOption("Drop Weapon", ::PlayersManager, 0, 23);
	CloseSubMenu();
	AddSubMenu("Pistols", 3);
	AddOption("iw6_alienm9a1_mp", ::PlayersManager, 20, "iw6_alienm9a1_mp");
	AddOption("iw6_alienmp443_mp", ::PlayersManager, 20, "iw6_alienmp443_mp");
	AddOption("iw6_alienp226_mp", ::PlayersManager, 20, "iw6_alienp226_mp");
	AddOption("iw6_alienmagnum_mp", ::PlayersManager, 20, "iw6_alienmagnum_mp");
	CloseSubMenu();
	AddSubMenu("Assault Rifles", 3);
	foreach(weapon in level.AR)
		AddOption(weapon, ::PlayersManager, 20, weapon);
	CloseSubMenu();
	AddSubMenu("SMG", 3);
	foreach(weapon in level.SMG)
		AddOption(weapon, ::PlayersManager, 20, weapon);
	CloseSubMenu();
	AddSubMenu("Snipers and DMR", 3);
	foreach(weapon in level.SR)
		AddOption(weapon, ::PlayersManager, 20, weapon);
	CloseSubMenu();
	AddSubMenu("LMG", 3);
	foreach(weapon in level.LMG)
		AddOption(weapon, ::PlayersManager, 20, weapon);
	CloseSubMenu();
	AddSubMenu("Shotgun", 3);
	foreach(weapon in level.SG)
		AddOption(weapon, ::PlayersManager, 20, weapon);
	CloseSubMenu();
	AddSubMenu("Specials/Equipment", 3);
	foreach(weapon in level.Special)
		AddOption(weapon, ::PlayersManager, 20, weapon);
	CloseSubMenu();
	AddSubMenu("Other Weapons", 3);
	foreach(weapon in level.Other)
		AddOption(weapon, ::PlayersManager, 20, weapon);
	CloseSubMenu();
	CloseSubMenu();
	AddSubmenu("Perks Menu", 3);
	AddOption("Give All Perks", ::PlayersManager, 0, 193, 1);
	foreach(perk in perks)
		AddOption(perk, ::PlayersManager, 16, perk);
	CloseSubMenu();
	AddSubmenu("Account Menu", 4);
	AddOption("Master Prestige", ::PlayersManager, 0, 143);
	AddOption("kurssse Prestige", ::PlayersManager, 1, 145);
	AddOption("Teeth", ::PlayersManager, 0, 144, 1);
	CloseSubMenu();
	AddSubMenu("Verification Menu", 3);
	AddOption("Set Standard Access", ::PlayersManager, 0, 1337, 1);
	AddOption("Set Elevated Access", ::PlayersManager, 0, 1337, 2);
	AddOption("Set CoHost Access", ::PlayersManager, 0, 1337, 3);
	AddOption("Unverify Player", ::PlayersManager, 0, -1337);
	CloseSubMenu();
	ClosePlayersMenu();
	AddSubmenu("All Players Menu", 3);
	AddSubmenu("Main Mods", 3);
	AddOption("Toggle Godmode", ::PlayersManager, 1, 0);
	AddOption("Infinite Ammo", ::PlayersManager, 1, 1);
	AddOption("No Target", ::PlayersManager, 1, 2);
	AddOption("Floating Head", ::PlayersManager, 1, 3);
	AddOption("Forge Mode", ::PlayersManager, 1, 4);
	AddOption("No Clip", ::PlayersManager, 1, 6);
	AddOption("Toggle Aimbot", ::PlayersManager, 1, 8);
	AddOption("Revive Player", ::PlayersManager, 1, 10);
	AddOption("Kill Player", ::PlayersManager, 1, 13);
	CloseSubMenu();
	AddSubmenu("Money Menu", 3);
	AddOption("Give 1000", ::PlayersManager, 1, 17, 1000);
	AddOption("Give 10000", ::PlayersManager, 1, 17, 10000);
	AddOption("Give 100000", ::PlayersManager, 1, 17, 100000);
	AddOption("Give Max", ::PlayersManager, 1, 17, 2000000);
	AddOption("Give Min", ::PlayersManager, 1, 18, -999999);
	AddOption("Take 100000", ::PlayersManager, 1, 5, 100000);
	AddOption("Take 10000", ::PlayersManager, 1, 5, 10000);
	AddOption("Take 1000", ::PlayersManager, 1, 5, 1000);
	CloseSubMenu();
	AddSubmenu("Weapons Menu", 3);
	AddSubmenu("Weapons Options", 3);
	AddSubMenu("Give Attachment", 3);
	foreach(attachment in attachments)
		AddOption(attachment, ::PlayersManager, 21, attachment);
	CloseSubMenu();
	AddOption("Drop Weapon", ::PlayersManager, 1, 23);
	CloseSubMenu();
	AddSubMenu("Pistols", 3);
	AddOption("iw6_alienm9a1_mp", ::PlayersManager, 20, "iw6_alienm9a1_mp");
	AddOption("iw6_alienmp443_mp", ::PlayersManager, 20, "iw6_alienmp443_mp");
	AddOption("iw6_alienp226_mp", ::PlayersManager, 20, "iw6_alienp226_mp");
	AddOption("iw6_alienmagnum_mp", ::PlayersManager, 20, "iw6_alienmagnum_mp");
	CloseSubMenu();
	AddSubMenu("Assault Rifles", 3);
	foreach(weapon in level.AR)
		AddOption(weapon, ::PlayersManager, 20, weapon);
	CloseSubMenu();
	AddSubMenu("SMG", 3);
	foreach(weapon in level.SMG)
		AddOption(weapon, ::PlayersManager, 20, weapon);
	CloseSubMenu();
	AddSubMenu("Snipers and DMR", 3);
	foreach(weapon in level.SR)
		AddOption(weapon, ::PlayersManager, 20, weapon);
	CloseSubMenu();
	AddSubMenu("LMG", 3);
	foreach(weapon in level.LMG)
		AddOption(weapon, ::PlayersManager, 20, weapon);
	CloseSubMenu();
	AddSubMenu("Shotgun", 3);
	foreach(weapon in level.SG)
		AddOption(weapon, ::PlayersManager, 20, weapon);
	CloseSubMenu();
	AddSubMenu("Specials/Equipment", 3);
	foreach(weapon in level.Special)
		AddOption(weapon, ::PlayersManager, 20, weapon);
	CloseSubMenu();
	AddSubMenu("Other Weapons", 3);
	foreach(weapon in level.Other)
		AddOption(weapon, ::PlayersManager, 20, weapon);
	CloseSubMenu();
	CloseSubMenu();
	AddSubmenu("Perks Menu", 3);
	AddOption("Give All Perks", ::PlayersManager, 1, 193, 1);
	foreach(perk in perks)
		AddOption(perk, ::PlayersManager, 16, perk);
	CloseSubMenu();
	AddSubmenu("Account Menu", 4);
	AddOption("Prestige Master", ::PlayersManager, 1, 143);
	AddOption("kurssse Prestige", ::PlayersManager, 1, 145);
	AddOption("Teeth", ::PlayersManager, 1, 144, 1);
	CloseSubMenu();
	AddSubMenu("Verification Menu", 3);
	AddOption("Set Standard Access", ::PlayersManager, 1, 1337, 1);
	AddOption("Set Elevated Access", ::PlayersManager, 1, 1337, 2);
	AddOption("Set CoHost Access", ::PlayersManager, 1, 1337, 3);
	AddOption("Unverify Player", ::PlayersManager, 1, -1337);
	CloseSubMenu();
	CloseSubMenu();
	level.REVIVAL_INITIALIZED = true;
}
