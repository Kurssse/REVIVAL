common_hive_drill_jump_to(hives_name_list)
{
	map = getDvar("mapname");

	if (map == "mp_alien_town")
	{
		hives_name_list = ["mini_lung", "lodge_lung_1", "lodge_lung_2", "lodge_lung_3", "lodge_lung_4", "lodge_lung_5", "lodge_lung_6", "city_lung_1", "city_lung_2", "city_lung_3", "city_lung_4", "city_lung_5", "lake_lung_1", "lake_lung_2", "lake_lung_3", "lake_lung_4", "lake_lung_6", "crater_lung"];
	}

	wait_and_remove_hives(hives_name_list);
}

wait_and_remove_hives(hives_name_list)
{
	wait 5;

	map = getDvar("mapname");

	rhandle_nondeterministic_entities_internal();
	if (map == "mp_alien_town")
	{
		hives_name_list = ["mini_lung", "lodge_lung_1", "lodge_lung_2", "lodge_lung_3", "lodge_lung_4", "lodge_lung_5", "lodge_lung_6", "city_lung_1", "city_lung_2", "city_lung_3", "city_lung_4", "city_lung_5", "lake_lung_1", "lake_lung_2", "lake_lung_3", "lake_lung_4", "lake_lung_6", "crater_lung"];
	}

	remove_hives(hives_name_list);
}

rhandle_nondeterministic_entities_internal()
{
	rremove_unused_hives(level.removed_hives);
	level.removed_hives = undefined;
}

remove_hives(hives_name_list)
{
	map = getDvar("mapname");

	if (map == "mp_alien_town")
	{
		hives_name_list = ["mini_lung", "lodge_lung_1", "lodge_lung_2", "lodge_lung_3", "lodge_lung_4", "lodge_lung_5", "lodge_lung_6", "city_lung_1", "city_lung_2", "city_lung_3", "city_lung_4", "city_lung_5", "lake_lung_1", "lake_lung_2", "lake_lung_3", "lake_lung_4", "lake_lung_6", "crater_lung"];
	}

	hives_name_list = delete_already_removed_hives(hives_name_list);

	foreach(hive_name in hives_name_list)
	{
		location_ent = getent(hive_name, "target");
		level.stronghold_hive_locs = array_remove(level.stronghold_hive_locs, location_ent);
	}

	rremove_unused_hives(hives_name_list);
}

rremove_unused_hives(removed_hives)
{
	foreach(hive in removed_hives)
	{
		location_ent = getent(hive, "target");
		assertEx(IsDefined(location_ent), "Invalid hive chosen to remove: " + hive);
		location_ent notify("stop_listening");
		location_ent thread maps\mp\alien\_hive::play_hive_scriptable_animations("remove", undefined, undefined, false);
		location_ent thread maps\mp\alien\_hive::delete_removables();
		location_ent maps\mp\alien\_hive::destroy_hive_icon();
		foreach(ent in location_ent.fx_ents)
		{
			ent delete();
		}

		if (isDefined(location_ent.dead_hive_model))
		{
			location_ent maps\mp\alien\_hive::show_dead_hive_model();
		}

		location_ent delete();
	}
}

delete_already_removed_hives(hives_name_list)
{
	new_list = [];

	map = getDvar("mapname");

	if (map == "mp_alien_town")
	{
		hives_name_list = ["mini_lung", "lodge_lung_1", "lodge_lung_2", "lodge_lung_3", "lodge_lung_4", "lodge_lung_5", "lodge_lung_6", "city_lung_1", "city_lung_2", "city_lung_3", "city_lung_4", "city_lung_5", "lake_lung_1", "lake_lung_2", "lake_lung_3", "lake_lung_4", "lake_lung_6", "crater_lung"];
	}

	foreach(hive in hives_name_list)
	{
		location_ent = getent(hive, "target");
		if (isDefined(location_ent))
			new_list[new_list.size] = hive;
	}
	return new_list;
}

rEscape()
{
	level endon("game_ended");

	rSetup_special_spawn_trigs();

	maps\mp\alien\_spawnlogic::escape_choke_init();

	nuke_trig = spawn("script_model", (-4606.2, 3258.7, 307.7));
	nuke_trig setmodel("tag_origin");
	nuke_trig MakeUsable();

	wait 0.05;

	icon = NewHudElem();
	icon SetShader("waypoint_bomb", 14, 14);
	icon.alpha = 1;
	icon.color = (1, 1, 1);
	icon SetWayPoint(true, true);
	icon.x = nuke_trig.origin[0];
	icon.y = nuke_trig.origin[1];
	icon.z = nuke_trig.origin[2];

	nuke_trig SetCursorHint("HINT_ACTIVATE");

	level thread rPlayers_use_nuke_monitor(nuke_trig);

	if (isdefined(level.players) && level.players.size > 1)
	{
		nuke_trig SetHintString(&"ALIEN_COLLECTIBLES_ACTIVATE_NUKE");
		IPrintLnBold(&"ALIEN_COLLECTIBLES_NUKE_ACTIVATE_USE");
	}
	else
	{
		nuke_trig SetHintString(&"ALIEN_COLLECTIBLES_ACTIVATE_NUKE_SOLO");
		IPrintLnBold(&"ALIEN_COLLECTIBLES_NUKE_ACTIVATE_USE_SOLO");
	}

	rWait_for_all_player_use();

	level thread maps\mp\alien\_spawnlogic::escape_spawning(level.escape_cycle);

	level thread maps\mp\alien\_music_and_dialog::playVOForNukeArmed();

	escape_ent = getent("escape_zone", "targetname");
	if (isdefined(level.rescue_waypoint))
		level.rescue_waypoint destroy();

	level.rescue_waypoint = NewHudElem();
	level.rescue_waypoint SetShader("waypoint_alien_beacon", 14, 14);
	level.rescue_waypoint.alpha = 0;
	level.rescue_waypoint.color = (1, 1, 1);
	level.rescue_waypoint SetWayPoint(true, true);
	level.rescue_waypoint.x = escape_ent.origin[0];
	level.rescue_waypoint.y = escape_ent.origin[1];
	level.rescue_waypoint.z = escape_ent.origin[2];

	flag_set("nuke_countdown");

	flag_clear("alien_music_playing");
	level thread maps\mp\alien\_music_and_dialog::Play_Nuke_Set_Music();

	icon destroy();
	nuke_trig MakeUnUsable();
	nuke_trig SetCursorHint("HINT_ACTIVATE");
	nuke_trig SetHintString("");
	nuke_trig delete();

	escape_start_time = getTime();

	level thread rNuke_countdown();

	level thread rRescue_think(escape_start_time);

	level thread rInfinite_mode_events();
}

rSetup_special_spawn_trigs()
{
	level.special_spawn_trigs = getentarray("force_special_spawn_trig", "targetname");

	foreach(trig in level.special_spawn_trigs)
		trig thread rWatch_special_spawn_trig();
}

rPlayers_use_nuke_monitor(nuke_trig)
{
	level endon("all_players_using_nuke");

	foreach(player in level.players)
		player thread rWatch_for_use_nuke_trigger(nuke_trig);

	while (true)
	{
		level waittill("connected", player);
		player thread rWatch_for_use_nuke_trigger(nuke_trig);
	}
}

rWait_for_all_player_use()
{
	level endon("game_ended");

	while (!rAre_all_players_using_nuke())
		wait 0.05;

	level notify("all_players_using_nuke");
}

rNuke_countdown()
{
	nukeTimer = 240;
	level.nukeLoc = (-9068, 5883, 600);
	level.nukeAngles = (0, -60, 90);

	setomnvar("ui_alien_nuke_timer", gettime() + (240 * 1000));
	level thread rHide_timer_on_game_end();
	rWait_for_nuke_detonate(nukeTimer, "force_nuke_detonate");

	level.nukeTimer = 3.35;
	level.players[0] thread maps\mp\alien\_nuke::doNukeSimple();

	flag_clear("nuke_countdown");
	setomnvar("ui_alien_nuke_timer", 0);
	flag_set("nuke_went_off");

	survived_time = 0;
	level thread rTrack_survived_time(survived_time);

	wait 2;
	level.fx_crater_plume Delete();
}

rRescue_think(escape_start_time)
{
	level endon("game_ended");

	escape_ent = getent("escape_zone", "targetname");
	chopper_struct = getstruct(escape_ent.target, "targetname");
	chopper_loc = chopper_struct.origin;
	chopper_angles = chopper_struct.angles;

	level.escape_loc = escape_ent.origin;

	thread rCall_in_rescue_heli(chopper_loc, chopper_angles, 10);

	while (!isdefined(level.rescue_heli))
		wait 0.05;

	level.rescue_heli delaythread(5, maps\mp\alien\_music_and_dialog::play_pilot_vo, "so_alien_plt_comeon");

	level.rescue_heli thread rHeli_leave_on_nuke();
	level.rescue_heli thread rFly_to_extraction_on_trigger();

	level.rescue_heli rWaittill_either_in_position_or_nuke();
	thread rWatch_player_escape(escape_ent, escape_start_time);
}

rInfinite_mode_events()
{
	level endon("game_ended");

	level notify("force_cycle_start");

	level.infinite_event_index = 1;
	level.infinite_event_interval = 60;

	while (true)
	{
		rWait_for_special_spawn();

		notify_msg = "chaos_event_2";
		level notify(notify_msg);

		level.last_special_event_spawn_time = gettime();

		maps\mp\alien\_spawn_director::activate_spawn_event(notify_msg);

		level.infinite_event_index++;
	}
}

rWatch_special_spawn_trig()
{
	level endon("game_ended");
	level endon("nuke_went_off");

	self endon("death");

	if (!flag_exist("nuke_countdown"))
		return;

	if (!flag("nuke_countdown"))
		flag_wait("nuke_countdown");

	while (1)
	{
		self waittill("trigger", player);
		if (isdefined(player) && isplayer(player) && isalive(player))
		{
			break;
		}
		else
		{
			wait 0.05;
			continue;
		}
	}

	if (isdefined(level.last_special_event_spawn_time))
	{
		grace_period = 15;
		if ((gettime() - level.last_special_event_spawn_time) / 1000 > grace_period)
		{
			level notify("force_chaos_event");
		}
	}
	else
	{
		level notify("force_chaos_event");
	}

	if (isdefined(level.special_spawn_trigs) && level.special_spawn_trigs.size)
		level.special_spawn_trigs = array_remove(level.special_spawn_trigs, self);

	self delete();
}

rWatch_for_use_nuke_trigger(nuke_trig)
{
	level endon("game_ended");
	level endon("all_players_using_nuke");

	self endon("disconnect");
	self notify("watch_for_use_nuke");
	self endon("watch_for_use_nuke");

	self.player_using_nuke = false;

	while (true)
	{
		if (self UseButtonPressed() && DistanceSquared(self.origin, nuke_trig.origin) < 130 * 130)
		{
			self.player_using_nuke = true;
			self notify("using_nuke");
			self thread rReset_nuke_usage();
		}

		wait 0.05;
	}
}

rAre_all_players_using_nuke()
{
	result = true;
	foreach(player in level.players)
	{
		if (!isdefined(player.player_using_nuke) || !player.player_using_nuke)
			result = false;
	}

	return result;
}

rHide_timer_on_game_end()
{
	level waittill("game_ended");
	setomnvar("ui_alien_nuke_timer", 0);
}

rWait_for_nuke_detonate(nuke_timer, override_msg)
{
	level endon(override_msg);

	if (!IsDefined(level.nuke_clockObject))
	{
		level.nuke_clockObject = Spawn("script_origin", (0, 0, 0));
		level.nuke_clockObject hide();
	}

	nuke_timer = int(nuke_timer);
	while (nuke_timer > 0)
	{
		if (nuke_timer == 10)
		{
			level thread maps\mp\alien\_music_and_dialog::playVOfor10Seconds();
		}

		if (nuke_timer == 30)
		{
			level thread maps\mp\alien\_music_and_dialog::playVoFor30Seconds();
		}
		if (nuke_timer == 120)
		{
			level thread maps\mp\alien\_music_and_dialog::playVOforGetToLz();
		}

		if (nuke_timer <= 30)
		{
			level.nuke_clockObject playSound("ui_mp_nukebomb_timer");

		}
		wait(1.0);
		nuke_timer--;
	}

	return true;
}

rTrack_survived_time(survived_time)
{
	start_time = gettime();
	level waittill("game_ended");
	end_time = gettime();

	level.survived_time = end_time - start_time;
}

rCall_in_rescue_heli(drop_loc, drop_angles, player_loops)
{
	level endon("game_ended");
	level endon("nuke_went_off");

	level.heli_fly_height = 1200;
	level.heli_loop_radius = 1200;

	CoM = rGet_center_of_players();

	raised_CoM = CoM + (0, 0, level.heli_fly_height);
	raised_drop_loc = drop_loc + (0, 0, level.heli_fly_height);

	scaled_goal_vec = level.heli_loop_radius * (0, 1, 0);
	scaled_start_vec = 8000 * (0, 1, 0);

	path_goal_pos = raised_CoM + scaled_goal_vec;
	path_start_pos = raised_CoM + scaled_start_vec;

	if (isdefined(level.attack_heli))
	{
		level.attack_heli notify("convert_to_hive_heli");
		StopFXOnTag(level._effect["alien_heli_spotlight"], level.attack_heli, "tag_flash");

		wait 0.5;
		level.rescue_heli = level.attack_heli;
	}
	else
	{
		level.rescue_heli = rHeli_setup(level.players[0], path_start_pos, path_goal_pos);
		level.rescue_heli thread rHeli_fx_setup();
	}

	level.rescue_heli rHide_doors();

	level.rescue_heli.drop_loc = drop_loc;
	level.rescue_heli.exit_path = [];

	cur_node = getstruct("heli_extraction_start", "targetname");
	level.rescue_heli.exit_path[0] = cur_node;
	while (isdefined(cur_node.target))
	{
		cur_node = getstruct(cur_node.target, "targetname");
		level.rescue_heli.exit_path[level.rescue_heli.exit_path.size] = cur_node;
	}

	level.rescue_heli thread rHeli_turret_think();

	level.rescue_heli rHeli_fly_to(path_goal_pos, 60);

	wait 1;

	level.rescue_heli notify("weapons_free");

	PlayFxOnTag(level._effect["alien_heli_spotlight"], level.rescue_heli, "tag_flash");

	level.rescue_heli rHeli_loop(player_loops, false, ::rGet_player_loop_center, "fly_to_extraction");

	level.rescue_heli thread maps\mp\alien\_music_and_dialog::play_pilot_vo("so_alien_plt_exfil");

	level.rescue_heli notify("stop_turret");

	StopFXOnTag(level._effect["alien_heli_spotlight"], level.rescue_heli, "tag_flash");

	level.rescue_heli rHeli_fly_to(raised_drop_loc, 30);
	thread rSfx_rescue_heli_flyin(level.rescue_heli);
	level.rescue_heli rHeli_fly_to(drop_loc, 30);

	level.rescue_heli notify("in_position");
	level.rescue_heli setgoalyaw(drop_angles[1]);

	level.rescue_heli thread rHeli_turret_think();
	wait 0.05;
	level.rescue_heli notify("weapons_free");
	PlayFxOnTag(level._effect["alien_heli_spotlight"], level.rescue_heli, "tag_flash");
}

rHeli_leave_on_nuke()
{
	self endon("death");

	self waittill("rescue_chopper_exit");

	self setneargoalnotifydist(200);

	self.near_goal = true;

	start_node = self.exit_path[0];
	for (i = 0; i < self.exit_path.size; i++)
	{
		fly_to_node = self.exit_path[i];
		self rHeli_fly_to(fly_to_node.origin, int(min(35, 20 + i * 5)));
	}
}

rFly_to_extraction_on_trigger()
{
	level endon("nuke_went_off");
	self endon("death");

	fly_to_extraction_trigger = getent("fly_to_extraction_trig", "targetname");
	while (1)
	{
		fly_to_extraction_trigger waittill("trigger", owner);
		if (IsPlayer(owner))
		{
			self notify("fly_to_extraction");
			return;
		}
		wait 0.05;
	}
}

rWaittill_either_in_position_or_nuke()
{
	level endon("nuke_went_off");
	self waittill("in_position");

	level.rescue_heli thread maps\mp\alien\_music_and_dialog::play_pilot_vo("so_alien_plt_exfil");
	level thread rGet_on_chopper_nag();
}

rWatch_player_escape(escape_ent, escape_start_time)
{
	level.rescue_heli endon("death");

	org = escape_ent.origin;
	rad = escape_ent.radius;
	height = 128;

	escape_ring_fx = spawnFx(level._effect["escape_zone_ring"], org);
	triggerFx(escape_ring_fx);

	escape_trig = spawn("trigger_radius", org, 0, rad, height);

	rWait_for_escape_conditions_met(escape_trig);

	escape_ring_fx delete();

	flag_set("escape_conditions_met");

	if (isdefined(level.rescue_waypoint))
		level.rescue_waypoint destroy();

	assertex(isdefined(level.rescue_heli), "Chopper became undefined while waiting to rescue");
	level.rescue_heli notify("extract");

	players_escaped = [];
	players_left = [];
	foreach(player in level.players)
	{
		if (player IsTouching(escape_trig) && isalive(player) && !(isdefined(player.laststand) && player.laststand))
		{
			players_escaped[players_escaped.size] = player;

			if (!is_casual_mode())
				player maps\mp\alien\_persistence::set_player_escaped();

			player.nuke_escaped = true;
		}
		else
		{
			players_left[players_left.size] = player;
			player.nuke_escaped = false;
		}
	}

	foreach(player in level.players)
	{
		if (true == player.nuke_escaped)
			player maps\mp\alien\_persistence::award_completion_tokens();
	}


	level.num_players_left = level.players.size - players_escaped.size;
	level.num_players_escaped = players_escaped.size;

	foreach(player in players_left)
		player IPrintLnBold(&"ALIEN_COLLECTIBLES_YOU_DIDNT_MAKE_IT");

	if (players_escaped.size == 0)
	{
		failed_msg = maps\mp\alien\_hud::get_end_game_string_index("fail_escape");
		level delaythread(15, maps\mp\gametypes\aliens::AlienEndGame, "axis", failed_msg);
		level.rescue_heli notify("rescue_chopper_exit");
		return;
	}

	escape_time_remains = rGet_escape_time_remains(escape_start_time);

	teleport_struct = getstruct("player_teleport_loc", "targetname");
	teleport_loc = teleport_struct.origin;

	foreach(player in players_escaped)
		player thread rPlayer_blend_to_chopper();

	wait 1.6;

	if (level.players.size == 1)
	{
		level.rescue_heli delaythread(2, maps\mp\alien\_music_and_dialog::play_pilot_vo, "so_alien_plt_itsjustyou");
	}
	else if (level.players.size > level.num_players_escaped)
	{
		level.rescue_heli delaythread(2, maps\mp\alien\_music_and_dialog::play_pilot_vo, "so_alien_plt_wherestherest");
	}

	level thread maps\mp\alien\_music_and_dialog::Play_Exfil_Music();
	thread rSfx_rescue_heli_escape(level.rescue_heli);
	wait 0.5;
	level.rescue_heli notify("rescue_chopper_exit");
	wait 4;

	level notify("force_nuke_detonate");

	pilot_lines = ["so_alien_plt_sourceofinvasion", "so_alien_plt_squashmorebugs"];
	level.rescue_heli delaythread(2, maps\mp\alien\_music_and_dialog::play_pilot_vo, random(pilot_lines));

	level.rescue_heli thread rPlay_nuke_rumble(4.5);

	maps\mp\alien\_alien_matchdata::set_escape_time_remaining(escape_time_remains);

	maps\mp\alien\_achievement::update_escape_achievements(players_escaped, escape_time_remains);

	maps\mp\alien\_gamescore::process_end_game_score_escaped(escape_time_remains, players_escaped);

	maps\mp\alien\_unlock::update_escape_item_unlock(players_escaped);

	maps\mp\alien\_persistence::update_LB_alienSession_escape(players_escaped, escape_time_remains);

	wait 2;

	if (players_escaped.size == level.players.size)
		win_msg = maps\mp\alien\_hud::get_end_game_string_index("all_escape");
	else
		win_msg = maps\mp\alien\_hud::get_end_game_string_index("some_escape");

	level delaythread(10, maps\mp\gametypes\aliens::AlienEndGame, "allies", win_msg);
}

rWait_for_special_spawn()
{
	level endon("force_chaos_event");

	if (level.infinite_event_index == 1)
		wait 5;
	else
		wait level.infinite_event_interval;
}

rReset_nuke_usage()
{
	level endon("game_ended");
	level endon("all_players_using_nuke");

	self endon("death");
	self endon("disconnect");

	self endon("using_nuke");

	wait 0.5;
	self.player_using_nuke = false;
}

rGet_center_of_players(height_offset)
{
	if (!isdefined(height_offset))
		height_offset = 0;

	x = 0; y = 0; z = 0;
	foreach(player in level.players)
	{
		x += player.origin[0];
		y += player.origin[1];
		z += player.origin[2] + height_offset;
	}

	player_count = max(1, level.players.size);
	CoM = (x / player_count, y / player_count, z / player_count);

	return CoM;
}

rHeli_setup(owner, path_start_pos, path_goal_pos)
{
	forward = vectorToAngles(path_goal_pos - path_start_pos);
	heli = SpawnHelicopter(owner, path_start_pos, forward, "nh90_alien", "vehicle_nh90_interior2");

	if (!IsDefined(heli))
		return;

	heli.health = 999999;
	heli.maxhealth = 500;
	heli.damageTaken = 0;
	heli.team = "allies";
	heli setCanDamage(false);
	heli SetYawSpeed(80, 60);
	heli SetMaxPitchRoll(30, 30);
	heli SetHoverParams(10, 10, 60);
	heli setVehWeapon("cobra_20mm_alien");
	heli.fire_time = weaponFireTime("cobra_20mm_alien");

	return heli;
}

rHeli_fx_setup()
{
	PlayFXOnTag(level._effect["cockpit_blue_cargo01"], self, "tag_light_cargo01");
	PlayFXOnTag(level._effect["cockpit_blue_cockpit01"], self, "tag_light_cockpit01");

	wait 0.05;
	PlayFXOnTag(level._effect["white_blink"], self, "tag_light_belly");
	PlayFXOnTag(level._effect["white_blink_tail"], self, "tag_light_tail");

	wait 0.05;
	PlayFXOnTag(level._effect["wingtip_green"], self, "tag_light_L_wing");
	PlayFXOnTag(level._effect["wingtip_red"], self, "tag_light_R_wing");
}

rHide_doors()
{
	self HidePart("door_l");
	self HidePart("door_l_handle");
	self HidePart("door_l_lock");
	self HidePart("door_r");
	self HidePart("door_r_handle");
	self HidePart("door_r_lock");
}

rHeli_turret_think(favorite_target, favorite_target_bias)
{
	level endon("game_ended");
	self endon("death");
	self endon("stop_turret");
	self endon("convert_to_hive_heli");

	self waittill("weapons_free");

	while (isdefined(self) && isalive(self))
	{
		primary_target = self rGet_primary_target(favorite_target, favorite_target_bias);
		if (!isdefined(primary_target) || !isalive(primary_target))
		{
			SetOmnvar("ui_alien_chopper_state", 0);
			wait 1;
			continue;
		}

		if (flag_exist("evade") && flag("evade"))
		{
			SetOmnvar("ui_alien_chopper_state", 1);
			wait 1;
			continue;
		}

		self setTurretTargetVec(primary_target.origin + (0, 0, 16));
		self waittill_notify_or_timeout("turret_on_target", 4);

		if (isdefined(primary_target) && isdefined(favorite_target) && primary_target == favorite_target)
		{
			SetOmnvar("ui_alien_chopper_state", 2);
			SetOmnvar("ui_alien_boss_status", 2);
		}

		clip_size = 30 + (RandomIntRange(0, 20) - 5);
		for (i = 0; i < clip_size; i++)
		{
			if (!isdefined(primary_target) || !isalive(primary_target))
				break;

			noise = (0, 0, 16);
			self setTurretTargetVec(primary_target.origin + noise);
			self fireWeapon("tag_flash", primary_target, (0, 0, 0));
			wait self.fire_time;
		}

		wait RandomFloatRange(1, 3.5);
	}
}

rHeli_fly_to(path_goal_pos, speed, endon_msg)
{
	self notify("new_flight_path");
	self endon("new_flight_path");
	self endon("convert_to_hive_heli");

	if (isdefined(endon_msg))
		level endon(endon_msg);

	self Vehicle_SetSpeed(speed, speed * 0.75, speed * 0.75);
	self setVehGoalPos(path_goal_pos, 1);

	rDebug_line(self.origin, path_goal_pos, (0, 0.5, 1), 200);

	if (isdefined(self.near_goal) && self.near_goal)
		self waittill("near_goal");
	else
		self waittill("goal");
}

rHeli_loop(loop_num, counter_clockwise, loop_center_func, self_endon_msg, loop_speed_override)
{
	self notify("new_flight_path");
	self endon("new_flight_path");
	self endon("death");
	self endon("convert_to_hive_heli");

	if (isdefined(self_endon_msg))
	{
		level endon(self_endon_msg);
		self endon(self_endon_msg);
	}

	angular_interval = 12;
	if (isdefined(counter_clockwise) && counter_clockwise)
		angular_interval *= -1;

	angular_shift = 0;
	radius_vec = (0, level.heli_loop_radius, 0);

	loop_speed = 30;
	if (isdefined(loop_speed_override))
		loop_speed = loop_speed_override;

	last_goal = self.origin;
	next_goal_pos = last_goal;
	loop_center = [[ loop_center_func ]] ();
	while (loop_num > 0 && self.health > 0)
	{
		rotated_vec = RotateVector(radius_vec, (0, angular_shift, 0));
		angular_shift += angular_interval;
		if (angular_shift >= 360)
		{
			loop_center = [[ loop_center_func ]] ();
			angular_shift = 0;
			loop_num--;
		}

		last_goal = next_goal_pos;
		next_goal_pos = loop_center + rotated_vec;

		self Vehicle_SetSpeed(loop_speed, loop_speed, loop_speed);
		self setVehGoalPos(next_goal_pos, 0);

		rDebug_line(last_goal, next_goal_pos, (0, 0.5, 1), 100);

		next_goal_dist = abs(level.heli_loop_radius * sin(angular_interval));
		travel_time = rGet_travel_time(next_goal_dist, loop_speed);

		look_ahead_frac = 0.1;
		wait(travel_time * (1 - look_ahead_frac));
	}
}

rSfx_rescue_heli_flyin(heli)
{
	heli PlaySound("alien_heli_rescue_dz_flyin");

	wait 1;
	heli Vehicle_TurnEngineOff();
	wait 1.6;
	level.heli_lp = Spawn("script_origin", heli.origin);
	level.heli_lp LinkTo(heli);
	level.heli_lp PlayLoopSound("alien_heli_rescue_dz_engine_lp");
}

rGet_on_chopper_nag()
{
	level endon("nuke_went_off");
	level endon("escape_conditions_met");

	nag_lines = ["so_alien_plt_getonchopper", "so_alien_plt_hurryup", "so_alien_plt_comeon"];

	while (1)
	{
		wait(randomintrange(10, 15));
		level.rescue_heli thread maps\mp\alien\_music_and_dialog::play_pilot_vo(random(nag_lines));
	}
}

rWait_for_escape_conditions_met(trig)
{
	level endon("nuke_went_off");

	if (flag("nuke_went_off"))
		return;

	while (1)
	{
		alive_players_inside = [];
		alive_players_outside = [];

		foreach(player in level.players)
		{
			if (!isalive(player) || (isdefined(player.laststand) && player.laststand))
				continue;

			if (player IsTouching(trig))
				alive_players_inside[alive_players_inside.size] = player;
			else
				alive_players_outside[alive_players_outside.size] = player;
		}

		if (alive_players_inside.size == 0)
		{
			wait 0.05;
			continue;
		}
		else
		{
			if (alive_players_outside.size == 0)
				return;
		}

		wait 0.05;
	}
}

rGet_escape_time_remains(escape_start_time)
{
	escape_time_passed = getTime() - escape_start_time;
	escape_time_remains = 240 * 1000 - escape_time_passed;
	escape_time_remains = max(0, escape_time_remains);

	return escape_time_remains;
}

rPlayer_blend_to_chopper()
{
	self endon("death");
	self endon("disconnect");

	if (self IsUsingTurret() && isdefined(self.current_sentry))
	{
		self.current_sentry notify("death");
		wait 0.5;
	}

	self notify("force_cancel_placement");

	self.playerLinkedToChopper = true;
	self notify("dpad_cancel");
	self DisableUsability();

	self rFade_black_screen();
	self.escape_overlay FadeOverTime(0.5);
	self.escape_overlay.alpha = 1;

	wait 0.5;

	self PlayerHide();
	self freezeControlsWrapper(true);

	position = "TAG_ALIEN_P1";

	self PlayerLinkToBlend(level.rescue_heli, position, 0.6, 0.2, 0.2);

	wait 0.6;

	self PlayerLinkTo(level.rescue_heli, position, 1, 50, 50, 18, 30, false);

	self thread rForce_crouch(true);
	self allowJump(false);

	self.escape_overlay FadeOverTime(0.5);
	self.escape_overlay.alpha = 0;
	wait 0.5;
	self.escape_overlay destroy();
}

rSfx_rescue_heli_escape(heli)
{
	level.player PlaySound("alien_heli_rescue_exfil_lr");
	wait 1;

	level.heli_lp StopLoopSound("alien_heli_rescue_dz_engine_lp");

	wait 5;
	level.heli_exfil_lp = Spawn("script_origin", heli.origin);
	level.heli_exfil_lp LinkTo(heli);
	level.heli_exfil_lp PlayLoopSound("alien_heli_exfil_engine_lp");

	wait 18;
	level.heli_exfil_lp StopLoopSound("alien_heli_exfil_engine_lp");
}

rPlay_nuke_rumble(delay)
{
	wait delay;
	foreach(player in level.players)
	{
		Earthquake(0.33, 4, player.origin, 1000);
		player PlayRumbleOnEntity("heavy_3s");
	}
}

rGet_primary_target(favorite_target, favorite_target_bias)
{
	targets = [];
	foreach(agent in level.agentArray)
	{
		if (!isdefined(agent.allowVehicleDamage))
			agent.allowVehicleDamage = true;

		if (agent.team != "axis")
			continue;

		if (!isalive(agent))
			continue;

		if (Distance(agent.origin, self.origin) > 2500)
			continue;

		alive_time = gettime() - agent.birthtime;
		if (alive_time < 4000)
			continue;

		targets[targets.size] = agent;
	}

	if (targets.size > 0)
	{
		targets = SortByDistance(targets, self.origin);

		if (isdefined(favorite_target))
		{
			assertex(isdefined(favorite_target_bias), "favorite target bias not defined when favorite target is");

			dist_to_alien = Distance(targets[0].origin, self.origin);
			dist_favorite_target = Distance(favorite_target.origin, self.origin);

			if (dist_to_alien >= dist_favorite_target / favorite_target_bias)
				return favorite_target;
		}

		return targets[0];
	}
	else
	{
		if (isdefined(favorite_target))
			return favorite_target;

		return undefined;
	}
}

rGet_travel_time(dist, speed)
{
	speed_inch_per_sec = speed * 17.6;
	travel_time = dist / speed_inch_per_sec;

	return travel_time;
}

rGet_player_loop_center()
{
	CoM = rGet_center_of_players();
	return CoM + (0, 0, level.heli_fly_height);
}

rDebug_line(from, to, color, frames)
{
	if (isdefined(level.heli_debug) && level.heli_debug == 1.0 && !isdefined(frames))
	{
		thread rDraw_line(from, to, color);
	}
	else if (isdefined(level.heli_debug) && level.heli_debug == 1.0)
		thread rDraw_line(from, to, color, frames);
}

rDraw_line(from, to, color, frames)
{
	if (isdefined(frames))
	{
		for (i = 0; i < frames; i++)
		{
			line(from, to, color);
			wait 0.05;
		}
	}
	else
	{
		for (;; )
		{
			line(from, to, color);
			wait 0.05;
		}
	}
}

rFade_black_screen()
{
	self.escape_overlay = newClientHudElem(self);
	self.escape_overlay.x = 0;
	self.escape_overlay.y = 0;
	self.escape_overlay setshader("black", 640, 480);
	self.escape_overlay.alignX = "left";
	self.escape_overlay.alignY = "top";
	self.escape_overlay.sort = 1;
	self.escape_overlay.horzAlign = "fullscreen";
	self.escape_overlay.vertAlign = "fullscreen";
	self.escape_overlay.alpha = 0;
	self.escape_overlay.foreground = true;
}

rForce_crouch(force_on)
{
	self endon("death");
	self endon("remove_force_crouch");

	if (isdefined(force_on) && force_on == false)
		self notify("remove_force_crouch");
	else
	{
		while (1)
		{
			if (self GetStance() != "crouch")
				self setstance("crouch");
			wait 0.05;
		}
	}
}
