void_handler(option, value, value2, value3, value4)
{
	if (option == 0)
	{
		if (rToggle(0))
			self.ability_invulnerable = 1;
		else
			self.ability_invulnerable = undefined;
	}
	else if (option == 1)
	{
		if (rToggle(1))
			self thread loop_handler(1);
	}
	else if (option == 2)
	{
		self.ignoreMe = !self.ignoreme;
		if (self.ignoreme)
			rEnabled();
		else
			rDisabled();
	}
	else if (option == 3)
	{
		if (rToggle(3))
		{
			self HideAllParts();
		}
		else
		{
			self ShowAllParts();
		}
	}
	else if (option == 4)
	{
		if (rToggle(4))
			self thread loop_handler(4);
	}
	else if (option == 5)
	{
		self maps\mp\alien\_persistence::set_player_currency(maps\mp\alien\_persistence::get_player_currency() - value);
	}
	else if (option == 6)
	{
		if (rToggle(6))
			self thread tNoclip();
		else
		{
			self unlink();
			self enableweapons();
			self.originObj delete();
			self notify("stop_noclip");
		}
	}
	else if (option == 7)
	{
		if (rToggle(7))
			setdvar("camera_thirdPerson", 1);
		else
			setdvar("camera_thirdPerson", 0);
	}
	else if (option == 8)
	{
		if (rToggle(8))
			self thread loop_handler(8, 0);
	}
	else if (option == 9)
	{
		if (!maps\mp\alien\_challenge::current_challenge_exist())
			return;

		current_challenge = level.challenge_data[level.current_challenge];
		level.current_challenge = undefined;
		maps\mp\alien\_challenge::display_challenge_message("challenge failed", false);
		current_challenge [[current_challenge.failFunc]] ();
		current_challenge [[current_challenge.deactivateFunc]] ();

		wait 6;

		challenge = maps\mp\alien\_challenge::get_valid_challenge();

		maps\mp\alien\_challenge::activate_new_challenge(challenge);
	}
	else if (option == 10)
	{
		if (rToggle(10))
			self thread loop_handler(10);
	}
	else if (option == 11)
	{
		self clonePlayer(1);
		rDone();
	}
	else if (option == 12)
	{
		deadClone = self clonePlayer(1);
		deadClone startRagdoll(1);
		rDone();
	}
	else if (option == 13)
	{
		challenge = value;
		current_challenge = level.challenge_data[level.current_challenge];
		level.current_challenge = undefined;
		maps\mp\alien\_challenge::display_challenge_message("challenge failed", false);
		current_challenge [[current_challenge.failFunc]] ();
		current_challenge [[current_challenge.deactivateFunc]] ();
		wait 6;

		maps\mp\alien\_challenge::activate_new_challenge(challenge);
		rDone();
	}
	else if (option == 16)
	{
		self iprintln(value + " given");
		self thread giveperk(value, 0);
	}
	else if (option == 17)
	{
		self maps\mp\alien\_persistence::set_player_max_currency(999999);
		self maps\mp\alien\_persistence::give_player_currency(value);
		rDone();
	}
	else if (option == 18)
	{
		self maps\mp\alien\_persistence::set_player_currency(value);
		rDone();
	}
	else if (option == 19)
	{
		setdvar("cg_fov", value);
		rDone();
	}
	else if (option == 20)
	{
		weapon = value;
		self _giveweapon(value, 0, 0);
		self switchtoweapon(value);
		self iprintln("Gave " + value);
	}
	else if (option == 21)
	{
		pillage_spot = undefined;
		success = maps\mp\alien\_pillage::add_attachment_to_weapon(value, pillage_spot);

		rDone();
	}
	else if (option == 23)
	{
		self dropitem(self getcurrentweapon());
		rDone();
	}
	else if (option == 30)
	{
		color = (value, value2, value3);
		self.framecolor = color;
		self UpdateMenuLook();
		rDone();
	}
	else if (option == 31)
	{
		color = (value, value2, value3);
		self.bgcolor = color;
		self UpdateMenuLook();
		rDone();
	}
	else if (option == 32)
	{
		color = (value, value2, value3);
		self.slidercolor = color;
		self UpdateMenuLook();
		rDone();
	}
	else if (option == 33)
	{
		if (isDefined(self.rainbowmenu) && self.rainbowmenu)
		{
			self.rainbowmenu = false;
			rDisabled();
		}
		else
		{
			self.rainbowmenu = true;
			rEnabled();
		}
		if (self.rainbowmenu)
			self thread loop_handler(33);
	}
	else if (option == 34)
	{
		if (rToggle(34))
			self thread loop_handler(34);
	}
	else if (option == 35)
	{
		if (rToggle(35))
			self thread loop_handler(35);
	}
	else if (option == 36)
	{
		if (rToggle(36))
			self thread loop_handler(36, 0);
	}
	else if (option == 37)
	{
		if (value == "norm")
		{
			self visionsetnakedforplayer("", 1);
		}
		else
			self visionsetnakedforplayer(value, 1);
		rDone();
	}
	else if (option == 38)
	{
		level.pillage_areas = [];

		level.pillageable_explosives = ["alienclaymore_mp", "alienbetty_mp", "alienmortar_shell_mp"];
		level.pillageable_attachments = ["reflex", "eotech", "rof", "grip", "barrelrange", "acog", "firetypeburst", "xmags", "alienmuzzlebrake"];
		level.pillageable_attachments_dmr = ["eotech", "reflex", "firetypeburst", "barrelrange", "acog", "xmags", "alienmuzzlebrake"];
		level.pillageable_attachments_sg = ["reflex", "grip", "eotech", "barrelrange", "xmags", "alienmuzzlebrake"];
		level.pillageable_attachments_sg_fp6 = ["reflex", "grip", "eotech", "barrelrange", "alienmuzzlebrake"];
		level.pillageable_attachments_ar = ["reflex", "eotech", "grip", "rof", "barrelrange", "acog", "firetypeburst", "xmags", "alienmuzzlebrake"];
		level.pillageable_attachments_ar_sc2010 = ["reflex", "eotech", "grip", "firetypeburst", "acog", "xmags", "alienmuzzlebrake"];
		level.pillageable_attachments_ar_honeybadger = ["reflex", "eotech", "grip", "rof", "acog", "firetypeburst", "xmags"];
		level.pillageable_attachments_smg_k7 = ["reflex", "eotech", "rof", "grip", "acog", "barrelrange", "xmags", "alienmuzzlebrake"];
		level.pillageable_attachments_smg = ["reflex", "eotech", "rof", "grip", "barrelrange", "acog", "xmags", "alienmuzzlebrake"];
		level.pillageable_attachments_aliendlc23 = ["rof", "grip", "barrelrange", "xmags", "alienmuzzlebrake"];
		level.pillageable_attachments_sr = ["xmags", "alienmuzzlebrake"];
		level.pillageable_attachments_lmg = ["rof", "grip", "reflex", "eotech", "acog", "barrelrange", "xmags", "alienmuzzlebrake"];
		level.pillageable_attachments_lmg_kac = ["rof", "barrelrange", "xmags", "alienmuzzlebrake"];
		level.offhand_explosives = ["alienclaymore_mp", "alienbetty_mp", "alienmortar_shell_mp", "aliensemtex_mp"];
		level.offhand_secondaries = ["alienflare_mp", "alienthrowingknife_mp", "alientrophy_mp"];

		if (isDefined(level.custom_pillageInitFunc))
		{
			[[level.custom_pillageInitFunc]] ();
		}
		if (isDefined(level.custom_LockerPillageInitFunc))
		{
			[[level.custom_LockerPillageInitFunc]] ();
		}

		level.alien_crafting_items = undefined;
		if (isdefined(level.crafting_item_table))
			level.alien_crafting_items = level.crafting_item_table;

		pillage_areas = getstructarray("pillage_area", "targetname");
		foreach(index, area in pillage_areas)
		{
			if (!IsDefined(level.pillage_areas[index]))
				level.pillage_areas[index] = [];
			level.pillage_areas[index]["easy"] = [];
			level.pillage_areas[index]["medium"] = [];
			level.pillage_areas[index]["hard"] = [];

			pillage_spots = getstructarray(area.target, "targetname");
			foreach(spot in pillage_spots)
			{
				if (isDefined(spot.script_noteworthy))
				{
					tokens = StrTok(spot.script_noteworthy, ",");
					spot.pillage_type = tokens[0];
					if (isDefined(tokens[1]))
					{
						spot.script_model = tokens[1];
					}
					if (isDefined(tokens[2]))
					{
						spot.default_item_type = tokens[2];
					}
					switch (spot.pillage_type)
					{
					case "easy":
						level.pillage_areas[index]["easy"][level.pillage_areas[index]["easy"].size] = spot;
						break;

					case "medium":
						level.pillage_areas[index]["medium"][level.pillage_areas[index]["medium"].size] = spot;
						break;

					case "hard":
						level.pillage_areas[index]["hard"][level.pillage_areas[index]["hard"].size] = spot;
						break;
					}
				}

			}
		}

		foreach(index, area in level.pillage_areas)
		{

			level thread maps\mp\alien\_pillage::create_pillage_spots(level.pillage_areas[index]["easy"]);
			level thread maps\mp\alien\_pillage::create_pillage_spots(level.pillage_areas[index]["medium"]);
			level thread maps\mp\alien\_pillage::create_pillage_spots(level.pillage_areas[index]["hard"]);

		}

		maps\mp\alien\_pillage::build_pillageitem_arrays("easy");
		maps\mp\alien\_pillage::build_pillageitem_arrays("medium");
		maps\mp\alien\_pillage::build_pillageitem_arrays("hard");

		level.use_alternate_specialammo_pillage_amounts = false;

		rDone();

	}
	else if (option == 39)
	{
		level.easter_egg_lodge_sign_active = 1;
		rDone();
	}
	else if (option == 40)
	{
		hives_name_list = ["mini_lung", "lodge_lung_1", "lodge_lung_2", "lodge_lung_3", "lodge_lung_4", "lodge_lung_5", "lodge_lung_6", "city_lung_1", "city_lung_2", "city_lung_3", "city_lung_4", "city_lung_5", "lake_lung_1", "lake_lung_2", "lake_lung_3", "lake_lung_4", "lake_lung_6", "crater_lung"];

		common_hive_drill_jump_to(hives_name_list);

		flag_set("hives_cleared");
		rEscape();
	}
	else if (option == 42)
	{
		self thread maps\mp\gametypes\aliens::setModelFromCustomization();
		rDone();
	}
	else if (option == 43)
	{
		self thread loop_handler(option, value, value2);
		self iprintln("Set to ^2" + value2);
	}
	else if (option == 44)
	{
		self setModel(value);
		rDone();
	}
	else if (option == 45)
	{
		direction = self getplayerangles();
		direction_vec = anglesToForward(direction);
		eye = self geteye();
		scale = 200;
		direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);
		trace = bullettrace(eye, eye + direction_vec, 0, undefined);
		obj = spawn("script_model", trace["position"], 1);
		obj SetModel(value);
		rDone();
	}
	else if (option == 46)
	{
		if (rToggle(46))
			self thread loop_handler(46);
	}
	else if (option == 47)
	{
		team = "allies";
		isTrapPet = false;
		count = 1;
		direction = self getplayerangles();
		direction_vec = anglesToForward(direction);
		eye = self geteye();
		scale = 100000;
		trace = bullettrace(eye, eye + direction_vec, 0, undefined);
		if (isDefined(trace["position"]))
		{
			position = trace["position"];
			spawnAngle = self.angles;

			alienType = value;
			pet = maps\mp\gametypes\aliens::spawnallypet(alienType, count, position, self, spawnAngle, isTrapPet);
			rDone();
		}
	}
	else if (option == 48)
	{
		team = "axis";
		introVignetteAnim = undefined;
		direction = self getplayerangles();
		direction_vec = anglesToForward(direction);
		eye = self geteye();
		scale = 100000;
		trace = bullettrace(eye, eye + direction_vec, 0, undefined);
		if (isDefined(trace["position"]))
		{
			position = trace["position"];
			spawnAngle = self.angles;

			alienType = value;

			agent = maps\mp\gametypes\aliens::addalienagent(team, position, spawnAngle, alienType, introVignetteAnim);
			rDone();
		}
	}
	else if (option == 49)
	{
		aliens = maps\mp\alien\_spawnlogic::get_alive_enemies();
		foreach(alien in aliens)
		{
			if (!isalive(alien))
				continue;

			alien suicide();
		}
		rDone();
	}
	else if (option == 50)
	{
		aliens = maps\mp\alien\_spawnlogic::get_alive_enemies();
		player_pos = self.Origin;

		foreach(alien in aliens)
		{
			if (!isalive(alien))
				continue;

			alien SetOrigin(player_pos);
		}
		rDone();
	}
	else if (option == 51)
	{
		aliens = maps\mp\alien\_spawnlogic::get_alive_enemies();
		position = self.origin;
		position = bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 1000000, 0, self)["position"];
		foreach(alien in aliens)
		{
			if (!isalive(alien))
				continue;

			alien SetOrigin(position);
		}
		rDone();
	}
	else if (option == 52)
	{
		if (rToggle(52))
		{
			level.cycle_data.max_alien_count = 0;
			rEnabled();
		}
		else
		{
			level.cycle_data.max_alien_count = 18;
			rDisabled();
		}
	}
	else if (option == 58)
	{
		self thread maps\mp\alien\_persistence::set_player_points(999);
		rDone();
	}
	else if (option == 60)
	{
		self thread maps\mp\alien\_perkfunctions::set_perk_health_level_4();
		self thread maps\mp\alien\_perkfunctions::set_perk_bullet_damage_4();
		self thread maps\mp\alien\_perkfunctions::set_perk_rigger_4();
		self thread maps\mp\alien\_perkfunctions::set_perk_medic_4();
		rDone();
	}
	else if (option == 59)
	{
		self thread maps\mp\alien\_outline_proto::set_alien_outline();
		self.isFeral = true;
		rDone();
	}
	else if (option == 62)
	{
		min_cycle_count = 1;
		if (level.cycle_count > min_cycle_count)
		{
			level.cycle_count--;
		}
		iprintln(level.cycle_count);
	}
	else if (option == 61)
	{
		max_cycle_count = 15;
		map = getDvar("mapname");
		if (map == "mp_alien_beacon")
		{
			max_cycle_count = 23;
		}
		else if (map == "mp_alien_dlc3")
		{
			max_cycle_count = 19;
		}
		else if (map == "mp_alien_last")
		{
			max_cycle_count = 27;
		}
		if (level.cycle_count < max_cycle_count)
		{
			level.cycle_count++;
		}
		iprintln(level.cycle_count);
	}
	else if (option == 67)
	{
		level notify("game_ended", "allies");
		rDone();
	}
	else if (option == 68)
	{
		map_restart(false);
	}
	else if (option == 70)
	{
		if (rToggle(70))
		{
			setDvar("cg_drawFPS", "1");
		}
		else
		{
			setDvar("cg_drawFPS", "0");
		}
	}
	else if (option == 74)
	{
		if (rToggle(74))
			self thread loop_handler(74);
	}
	else if (option == 75)
	{
		BOX_TYPE = value;
		rank = 4;
		self maps\mp\alien\_combat_resources::default_TryUse_dpad_team_specialammo(rank, BOX_TYPE);
	}
	else if (option == 78)
	{
		level.nojoin = !level.nojoin;
		if (level.nojoin)
			rEnabled();
		else
			rDisabled();
	}
	else if (option == 80)
	{
		if (rToggle(80))
			foreach(player in level.players)
			player thread loop_handler(80, self);
	}
	else if (option == 81)
	{
		if (rToggle(81))
		{
			globalMeleeDistanceMod(true);
			rEnabled();
		}
		else
		{
			globalMeleeDistanceMod(false);
			rDisabled();
		}
	}
	else if (option == 82)
	{
		if (rToggle(82))
		{
			globalKnockbackMod(true);
			rEnabled();
		}
		else
		{
			globalKnockbackMod(false);
			rDisabled();
		}
	}
	else if (option == 85)
	{
		setDvar("g_gravity", value);
		rDone();
	}
	else if (option == 86)
	{
		relics = ["nerf_take_more_damage", "nerf_higher_threat_bias", "nerf_pistols_only", "nerf_smaller_wallet", "nerf_no_class", "nerf_lower_weapon_damage", "nerf_fragile", "nerf_move_slower", "nerf_no_abilities", "nerf_min_ammo", "nerf_no_deployables"];

		if (rToggle(86))
		{
			foreach(relic in relics)
			{
				if (self is_relic_active(relic))
				{
					self deactivate_relic(relic);
				}
				else
				{
					self maps\mp\alien\_prestige::activate_nerf(relic);
				}
			}
		}
	}
	else if (option == 99)
	{
		self thread playerGivePrestige();
	}
	else if (option == 100)
	{
		self thread kursssePrestige();
	}
	else if (option == 101)
	{
		self thread maps\mp\alien\_persistence::give_player_tokens(3000, 1);
	}
	else if (option == 179)
	{
		if (rToggle(179))
			self thread ANoclipBind();
	}
	else if (option == 184)
	{
		if (rToggle(184))
			self thread RicochetBullets();
	}
	else if (option == 193)
	{
		rDone();
		self thread AllPerks(value);
	}
}

loop_handler(option, a_id, arg1)
{
	if (option == 1)
	{
		while (rGetBool(1))
		{
			weapon = self getcurrentweapon();
			if (weapon != "none")
			{
				self setWeaponAmmoClip(weapon, weaponClipSize(weapon));
				self giveMaxAmmo(weapon);
			}
			if (self getCurrentOffHand() != "none")
				self giveMaxAmmo(self getCurrentOffHand());
			self waittill_any("weapon_fired", "grenade_fire", "missile_fire");
		}
	}
	else if (option == 4)
	{
		while (rGetBool(4))
		{
			while (self adsbuttonpressed())
			{
				trace = GetNormalTrace();
				while (self adsbuttonpressed())
				{
					trace["entity"] setOrigin(self GetTagOrigin("j_head") + anglesToForward(self GetPlayerAngles()) * 200);
					trace["entity"].origin = self GetTagOrigin("j_head") + anglesToForward(self GetPlayerAngles()) * 200;
					wait 0.05;
				}
			}
			wait 0.05;
		}
	}
	else if (option == 8 && isDefined(a_id) && a_id == 0)
	{
		self thread loop_handler(8, 1);
		while (rGetBool(8))
		{
			while (self adsButtonPressed())
			{
				Aliens = getClosest(self getOrigin(), maps\mp\alien\_spawnlogic::get_alive_enemies());
				self setplayerangles(VectorToAngles((Aliens getTagOrigin("j_head")) - (self getTagOrigin("j_head"))));
				if (isDefined(self.Aim_Shoot))magicBullet(self getCurrentWeapon(), Aliens getTagOrigin("j_head") + (0, 0, 5), Aliens getTagOrigin("j_head"), self);
				wait .05;
			}
			wait .05;
		}
	}
	else if (option == 8 && isDefined(a_id) && a_id == 1)
	{
		while (rGetBool(8))
		{
			self.Aim_Shoot = true;
			wait .05;
			self.Aim_Shoot = undefined;
			self waittill("weapon_fired");
		}
	}
	else if (option == 10)
	{
		while (rGetBool(10))
		{
			level waittill("drill_planted");

			wait 2.5;
			current_challenge = level.challenge_data[level.current_challenge];
			level.current_challenge = undefined;
			maps\mp\alien\_challenge::display_challenge_message("challenge failed", false);
			current_challenge [[current_challenge.failFunc]] ();
			current_challenge [[current_challenge.deactivateFunc]] ();
			wait 5;

			challenge = get_random_challenge();

			maps\mp\alien\_challenge::activate_new_challenge(challenge);
		}
	}
	else if (option == 33)
	{
		while (self.rainbowmenu)
		{
			self.framecolor = (randomfloatrange(0, 1), randomfloatrange(0, 1), randomfloatrange(0, 1));
			self.slidercolor = self.framecolor;
			self UpdateMenuLook();
			wait .25;
		}
		self UpdateMenuLook();
	}
	else if (option == 34)
	{
		while (rGetBool(34))
		{
			if (self usebuttonpressed() && self jumpbuttonpressed())
			{
				self iprintln("^2Saved Position");
				self.teletoloc = self.origin;
				wait .5;
			}
			if (self usebuttonpressed() && self adsbuttonpressed())
			{
				if (!isDefined(self.teletoloc))
				{

				}
				else
				{
					self setOrigin(self.teletoloc);
				}
				wait .5;
			}
			wait .1;
		}
	}
	else if (option == 35)
	{
		self iPrintln("Press [{+gostand}] & [{+usereload}]");
		self.jetboots = 100;
		while (rGetBool(35))
		{
			if (self usebuttonpressed() && self.jetboots > 0)
			{
				self.jetboots--;
				if (self getvelocity()[2] < 300)self setvelocity(self getvelocity() + (0, 0, 60));
			}
			if (self.jetboots < 100 && !self usebuttonpressed())self.jetboots++;
			wait .05;
		}
	}
	else if (option == 36 && a_id == 0)
	{
		object1 = undefined;
		object2 = undefined;
		self void_handler(20, "iw6_alienmagnum_mp_acogpistol_scope5");
		self.cooldowntime = 0;
		self.lastportal = undefined;

		while (rGetBool(36))
		{
			self waittill("weapon_fired", weapon);
			if (!rGetBool(36))
				break;

			if (weapon != "iw6_alienmagnum_mp_acogpistol_scope5")
				continue;

			trace = GetNormalTrace();
			pos = trace["position"];

			if (!isDefined(object1))
			{
				object1 = spawn("script_model", pos);
				object1 setModel(level._revival_portalmodel);
				object1 thread loop_handler(36, 1);
			}
			else if (!isDefined(object2))
			{
				object2 = spawn("script_model", pos);
				object2 setModel(level._revival_portalmodel);
				object1.portalto = object2 getOrigin();
				object2.portalto = object1 getOrigin();
				object2 thread loop_handler(36, 1);
			}
		}
		if (isDefined(object1)) object1 delete();
		if (isDefined(object2)) object2 delete();
		self.cooldowntime = 0;
		self.lastportal = undefined;
	}
	else if (option == 36 && a_id == 1)
	{
		while (!isDefined(self.portalto))
			wait .1;

		while (isDefined(self))
		{
			foreach(player in level.players)
			{
				if (Distance(self getOrigin(), player getOrigin()) < 100 && !player.cooldowntime)
				{
					player.cooldowntime = 1;
					player setOrigin(self.portalto);
					player iPrintlnBold("Teleported!");

					wait 2;
					player.cooldowntime = 0;
				}
			}
			wait .1;
		}
	}
	else if (option == 36 && a_id == 2)
	{
		portal = arg1;
		while (isDefined(portal) && portal isTouching(self))
			wait .1;
		self.lastportal = undefined;
		self.cooldowntime = 0;
	}
	else if (option == 43 && a_id == 0)
	{
		self.magic_weapon = arg1;
		if (self.magic_weapon == "norm")
			return;
		while (self.magic_weapon == arg1)
		{
			magicBullet(arg1, self getTagOrigin("tag_eye"), GetNormalTrace()["position"], self);
			self waittill("weapon_fired");
		}
	}
	else if (option == 46)
	{
		self iprintln("^3Press ^2AIM ^3to ^2Move Objects");
		wait 2.5;
		self iprintln("^3Press ^2AIM + SHOOT ^3to ^2Paste Objects");
		wait 2.5;
		self iprintln("^3Press ^2AIM + [{+usereload}] ^3to ^2Copy Objects");
		wait 2.5;
		self iprintln("^3Press ^2AIM + [{+gostand}] ^3to ^2Delete Objects");
		wait 2.5;
		self iprintln("^3Press ^GRENADE BUTTONS ^3to ^2Rotate Objects");
		object = undefined;
		trace = undefined;
		cannotsetmodel = undefined;
		currentent = undefined;
		while (rGetBool(46))
		{
			if (self adsbuttonpressed())
			{
				trace = GetNormalTrace();
				if (!isDefined(trace["entity"]))
				{
					cannotsetmodel = false;
					foreach(model in getEntArray("script_brushmodel", "classname"))
					{
						if (!isDefined(currentent) && Distance(model.origin, trace["position"]) < 100)
						{
							currentent = model;
							cannotsetmodel = true;
						}
						if (isDefined(currentent) && closer(trace["position"], model.origin, currentent.origin))
						{
							currentent = model;
							cannotsetmodel = true;
						}
					}
					foreach(model in getEntArray("script_model", "classname"))
					{
						if (!isDefined(currentent) && Distance(model.origin, trace["position"]) < 100)
						{
							currentent = model;
							cannotsetmodel = false;
						}
						if (isDefined(currentent) && closer(trace["position"], model.origin, currentent.origin))
						{
							currentent = model;
							cannotsetmodel = false;
						}
					}
					trace["entity"] = currentent;
				}
				while (self adsbuttonpressed())
				{
					trace["entity"] setOrigin(self GetTagOrigin("j_head") + anglesToForward(self GetPlayerAngles()) * 200);
					trace["entity"].origin = self GetTagOrigin("j_head") + anglesToForward(self GetPlayerAngles()) * 200;
					if (self attackbuttonpressed())
					{
						if (isDefined(object))
						{
							if (isDefined(trace["entity"]) && !cannotsetmodel)
							{
								self iprintln("Overwrote Objects Model With:^2 " + object);
								trace["entity"] setModel(object);
							}
							else
							{
								trace = GetNormalTrace();
								obj = spawn("script_model", trace["position"], 1);
								obj setModel(object);
								self iprintln("Spawned Object:^2 " + object);
							}
						}
						wait .75;
					}
					if (self usebuttonpressed())
					{
						if (isDefined(trace["entity"].model))
						{
							object = trace["entity"].model;
							self iprintln("Copied Model: ^2" + object);
						}
						wait .75;
						break;
					}
					if (self jumpbuttonpressed())
					{
						if (!isDefined(trace["entity"]))
						{
						}
						else
						{
							trace["entity"] delete();
							self iprintln("Entity Deleted");
						}
						wait .75;
						break;
					}
					if (self secondaryoffhandbuttonpressed())
					{
						if (isDefined(trace["entity"]))
						{
							trace["entity"] rotateRoll(-6, .05);
						}
						else
						{
							wait .5;
							break;
						}
						wait .1;
					}
					if (self fragbuttonpressed())
					{
						if (isDefined(trace["entity"]))
						{
							trace["entity"] rotateRoll(6, .05);
						}
						else
						{
							wait .5;
							break;
						}
						wait .1;
					}
					wait 0.05;
				}
			}
			wait .1;
		}
	}
	else if (option == 74)
	{
		while (rGetBool(74))
		{
			foreach(p in level.players)
			{
				if (p maps\mp\alien\_laststand::player_in_laststand())
					p maps\mp\alien\_laststand::instant_revive(p, p);
				wait .5;
			}
		}
	}
	else if (option == 80)
	{
		while (rGetHost() rGetBool(80))
		{
			if (self JumpButtonPressed())
			{
				for (i = 0; i < 5; i++)
				{
					self setVelocity(self getVelocity() + (0, 0, 200));
					wait 0.1;
				}
			}
			wait 0.05;
		}
	}
}

PlayersManager(all, option, value, value2, value3)
{
	Menu = self rGetMenu();
	self.modifierlist = [];
	if (all)
	{
		self.modifierlist = array_copy(level.players);
		arrayremovevalue(self.modifierlist, rGetHost());
	}
	else
	{
		self.modifierlist[0] = Menu.selectedPlayer;
	}
	if (option == 1337)
	{
		foreach(player in self.modifierlist)
		{
			if (player IsHost())
			{
				rHostOnly();
				return;
			}
			REVIVALADDCLIENTVERIFICATION(player GetName(), value);
		}
		rDone();
	}
	else if (option == -1337)
	{
		foreach(player in self.modifierlist)
		{
			if (player IsHost())
			{
				rHostOnly();
				return;
			}
			REVIVALREMOVECLIENTVERIFICATION(player GetName());
		}
		rDone();
	}
	else if (option == 0)
	{
		if (all)
		{
			if (rGlobalToggle(0))
			{
				foreach(player in self.modifierlist)
					player.ability_invulnerable = 1;
			}
			else
			{
				foreach(player in self.modifierlist)
					player.ability_invulnerable = undefined;
			}
		}
		else
		{
			if (rToggle(0, self.modifierlist[0]))
				self.modifierlist[0].ability_invulnerable = 1;
			else
				self.modifierlist[0].ability_invulnerable = undefined;
		}
	}
	else if (option == 1)
	{
		if (all)
		{
			if (rGlobalToggle(1))
			{
				foreach(player in self.modifierlist)
					player thread loop_handler(1);
			}
		}
		else
		{
			if (rToggle(1, self.modifierlist[0]))
				self.modifierlist[0] thread loop_handler(1);
		}
	}
	else if (option == 2)
	{
		if (all)
		{
			if (isDefined(level.ignoremestate) && level.ignoremestate)
				level.ignoremestate = false;
			else
				level.ignoremestate = true;
			foreach(player in self.modifierlist)
				player.ignoreme = level.ignoremestate;
			if (level.ignoremestate)
				rEnabled();
			else
				rDisabled();
		}
		else
		{
			self.modifierlist[0].ignoreMe = !self.modifierlist[0].ignoreMe;
			if (self.modifierlist[0].ignoreMe)
				rEnabled();
			else
				rDisabled();
		}
	}
	else if (option == 3)
	{
		if (all)
		{
			if (isDefined(level.invis) && level.invis)
				level.invis = false;
			else
				level.invis = true;
			foreach(player in self.modifierlist)
			{
				player.invis = level.invis;
				if (player.invis)
					player hideAllParts();
				else
					player showAllParts();
			}
		}
		else
		{
			self.modifierlist[0].invis = !self.modifierlist[0].invis;
			if (self.modifierlist[0].invis)
			{
				rEnabled();
				self.modifierlist[0] hideAllParts();
			}
			else
			{
				rDisabled();
				self.modifierlist[0] showAllParts();
			}
		}
	}
	else if (option == 4)
	{
		if (all)
		{
			if (rGlobalToggle(4))
				foreach(player in self.modifierlist)
				player thread loop_handler(4);
		}
		else
		{
			if (rToggle(4, self.modifierlist[0]))
				self.modifierlist[0] thread loop_handler(4);
		}
	}
	else if (option == 5)
	{
		if (all)
		{
			foreach(player in self.modifierlist)
				player thread maps\mp\alien\_persistence::set_player_currency(maps\mp\alien\_persistence::get_player_currency() - value);
			rDone();
		}
		else
		{
			self.modifierlist[0] thread maps\mp\alien\_persistence::set_player_currency(maps\mp\alien\_persistence::get_player_currency() - value);
			rDone();
		}
	}
	else if (option == 6)
	{
		if (all)
		{
			if (rGlobalToggle(6))
			{
				foreach(player in self.modifierlist)
				{
					player thread tNoclip();
				}
			}
			else
			{
				foreach(player in self.modifierlist)
				{
					player unlink();
					player enableweapons();
					player.originObj delete();
					player notify("stop_noclip");
				}
			}
		}
		else
		{
			if (rToggle(6, self.modifierlist[0]))
				self.modifierlist[0] thread tNoclip();
			else
			{
				self.modifierlist[0] unlink();
				self.modifierlist[0] enableweapons();
				self.modifierlist[0].originObj delete();
				self.modifierlist[0] notify("stop_noclip");
			}
		}
	}
	else if (option == 8)
	{
		if (all)
		{
			if (rGlobalToggle(8))
				foreach(player in self.modifierlist)
				player thread loop_handler(8);
		}
		else
		{
			if (rToggle(8, self.modifierlist[0]))
				self.modifierlist[0] thread loop_handler(8);
		}
	}
	else if (option == 10)
	{
		if (all)
		{
			foreach(player in self.modifierlist)
				if (player maps\mp\alien\_laststand::player_in_laststand())
					player maps\mp\alien\_laststand::instant_revive(player, player);
			rDone();
		}
		else
		{
			if (self.modifierlist[0] maps\mp\alien\_laststand::player_in_laststand())
				self.modifierlist[0] maps\mp\alien\_laststand::instant_revive(self.modifierlist[0], self.modifierlist[0]);
			rDone();
		}
	}
	else if (option == 13)
	{
		if (all)
		{
			foreach(player in self.modifierlist)
			{
				player notify("suicide");

				bleedOutSpawnEntity = SpawnStruct();
				bleedOutSpawnEntity.origin = player.origin;

				player maps\mp\alien\_laststand::forcebleedout(bleedOutSpawnEntity);
			}
			rDone();
		}
		else
		{
			self.modifierlist[0] notify("suicide");

			bleedOutSpawnEntity = SpawnStruct();
			bleedOutSpawnEntity.origin = self.modifierlist[0].origin;

			self.modifierlist[0] maps\mp\alien\_laststand::forcebleedout(bleedOutSpawnEntity);
			rDone();
		}
	}
	else if (option == 143)
	{
		if (all)
		{
			foreach(player in self.modifierlist)
				player thread playerGivePrestige();
		}
		else
		{
			self.modifierlist[0] thread playerGivePrestige();
		}
	}
	else if (option == 144)
	{
		if (all)
		{
			foreach(player in self.modifierlist)
				player thread maps\mp\alien\_persistence::give_player_tokens(3000, 1);
		}
		else
		{
			self.modifierlist[0] thread maps\mp\alien\_persistence::give_player_tokens(3000, 1);
		}
	}
	else if (option == 145)
	{
		if (all)
		{
			foreach(player in self.modifierlist)
				player thread kursssePrestige();
		}
		else
		{
			self.modifierlist[0] thread kursssePrestige();
		}
	}
	else if (option == 17)
	{
		if (all)
		{
			foreach(player in self.modifierlist)
			{
				player thread maps\mp\alien\_persistence::set_player_max_currency(999999);
				player thread maps\mp\alien\_persistence::give_player_currency(value);
			}
			rDone();
		}
		else
		{
			self.modifierlist[0] thread maps\mp\alien\_persistence::set_player_max_currency(999999);
			self.modifierlist[0] thread maps\mp\alien\_persistence::give_player_currency(value);
			rDone();
		}
	}
	else if (option == 18)
	{
		if (all)
		{
			foreach(player in self.modifierlist)
				player thread maps\mp\alien\_persistence::set_player_currency(value);
			rDone();
		}
		else
		{
			self.modifierlist[0] thread maps\mp\alien\_persistence::set_player_currency(value);
			rDone();
		}
	}
	else if (option == 16)
	{
		if (all)
		{
			foreach(player in self.modifierlist)
				player thread giveperk(value, 0);
			rDone();
		}
		else
		{
			self.modifierlist[0] thread giveperk(value, 0);
			rDone();
		}
	}
	else if (option == 20)
	{
		if (all)
		{
			foreach(player in self.modifierlist)
			{
				player thread void_handler(20, value);
			}
			rDone();
		}
		else
		{
			self.modifierlist[0] thread void_handler(20, value);
			rDone();
		}
	}
	else if (option == 21)
	{
		if (all)
		{
			foreach(player in self.modifierlist)
			{
				player thread void_handler(21);
			}
			rDone();
		}
		else
		{
			self.modifierlist[0] thread void_handler(21);
			rDone();
		}
	}
	else if (option == 23)
	{
		if (all)
		{
			foreach(player in self.modifierlist)
			{
				player dropitem(player getcurrentweapon());
			}
			rDone();
		}
		else
		{
			self.modifierlist[0] dropitem(self.modifierlist[0] getcurrentweapon());
			rDone();
		}
	}
	else if (option == 193)
	{
		if (all)
		{
			foreach(player in self.modifierlist)
				player AllPerks(value, 0);
		}
		else
			self.modifierlist[0] AllPerks(value, 0);
		rDone();
	}
}
