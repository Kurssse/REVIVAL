tNoclip()
{
	while (rGetBool(6))
	{
		self thread rNoClip();
		self waittill("rechain");
		self notify("stop_noclip");
	}
}

ANoclipBind()
{
	if (rGetBool(6))
		rSetBool(6, false);
	self iprintln("^2Press [{+frag}] ^3to ^2Toggle No Clip");
	normalized = undefined;
	scaled = undefined;
	originpos = undefined;
	self unlink();
	self.originObj delete();
	while (rGetBool(179))
	{
		if (self fragbuttonpressed())
		{
			self.originObj = spawn("script_origin", self.origin, 1);
			self.originObj.angles = self.angles;
			self playerlinkto(self.originObj, undefined);
			while (self fragbuttonpressed())
				wait .1;
			rEnabled();
			self enableweapons();
			while (rGetBool(179))
			{
				if (self fragbuttonpressed())
					break;
				wait .05;
			}
			self unlink();
			self.originObj delete();
			rDisabled();
			while (self fragbuttonpressed())
				wait .1;
		}
		wait .1;
	}
}

AllPerks(give)
{
	perks = ["specialty_armorpiercing", "specialty_explosivebullets", "specialty_marathon", "specialty_fastreload", "specialty_stalker", "specialty_quickdraw", "specialty_quickswap", "specialty_fastoffhand", "specialty_fastsprintrecovery", "specialty_falldamage", "specialty_bulletdamage", "specialty_selectivehearing", "specialty_longersprint", "specialty_fastermelee"];

	foreach(perk in perks)
		if (give)
			self giveperk(perk, 0);
		else
			self _unsetperk(perk);
}

GetNormalTrace()
{
	return bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 1000000, 0, self);
}

rNoclip()
{
	self endon("stop_noclip");
	self.first = true;
	normalized = undefined;
	scaled = undefined;
	originpos = undefined;
	while (1)
	{
		if (self fragbuttonpressed())
		{
			if (self.first) {
				self.originObj = spawn("script_origin", self.origin, 1);
				self.originObj.angles = self.angles;
				self disableweapons();
				self playerlinkto(self.originObj, undefined);
				self.first = false;
			}
			normalized = anglesToForward(self getPlayerAngles());
			scaled = (normalized[0] * 50, normalized[1] * 50, normalized[2] * 50);
			originpos = self.origin + scaled;
			self.originObj.origin = originpos;
		}
		else if (self meleeButtonPressed() && !self.first)
		{
			self unlink();
			self enableweapons();
			self.originObj delete();
			self notify("rechain");
		}
		wait .05;
	}
}

RicochetBullets()
{
	start = undefined;
	end = undefined;
	while (rGetBool(184))
	{
		self waittill("weapon_fired", weapon);
		if (!rGetBool(184))
			break;
		start = GetNormalTrace()["position"];
		end = (randomintrange(-1000, 1000), randomintrange(-1000, 1000), randomintrange(0, 1000));
		magicBullet(weapon, start, start + end, self);
		start = bullettrace(start, end * 10000000, 0, self)["position"];
		end = -1 * start + (randomintrange(-1000, 1000), randomintrange(-1000, 1000), randomintrange(0, 1000));
		magicBullet(weapon, start, start + end, self);
	}
}

globalMeleeDistanceMod(toggle)
{
	if (toggle)
	{
		foreach(player in level.players)
		{
			player thread applyCustomMeleeDistance();
		}
	}
	else
	{
		foreach(player in level.players)
		{
			player thread restoreDefaultMeleeDistance();
		}
	}
}

applyCustomMeleeDistance()
{
	self endon("disconnect");

	while (true)
	{
		if (self meleeButtonPressed())
		{
			target = self getClosest(self getOrigin(), maps\mp\alien\_spawnlogic::get_alive_enemies());

			if (isDefined(target) && distance(self.origin, target.origin) <= 999)
			{
				target dodamage(target.maxhealth + 999, target.origin);
			}
		}

		wait 0.1;
	}
}

restoreDefaultMeleeDistance()
{
	self notify("restore_default_melee");
}

globalKnockbackMod(toggle)
{
	if (toggle)
	{
		foreach(player in level.players)
		{
			player thread applyCustomKnockback();
		}
	}
	else
	{
		foreach(player in level.players)
		{
			player thread restoreDefaultKnockback();
		}
	}
}

applyCustomKnockback()
{
	self endon("disconnect");

	while (true)
	{
		if (self attackButtonPressed())
		{
			target = self getClosest(self getOrigin(), maps\mp\alien\_spawnlogic::get_alive_enemies());

			if (isDefined(target) && distance(self.origin, target.origin) <= 999)
			{
				self thread applyKnockback(target);
			}
		}

		wait 0.1;
	}
}

applyKnockback(target)
{
	if (!isDefined(target))
		return;

	knockbackDirection = vectorNormalize(target.origin - self.origin);

	knockbackForce = 99999;
	target setVelocity(knockbackDirection * knockbackForce);

}

restoreDefaultKnockback()
{
	self notify("restore_default_knockback");
}

playerGivePrestige()
{
	self maps\mp\alien\_persistence::set_player_prestige(25);
	rDone();
}

kursssePrestige()
{
	self maps\mp\alien\_persistence::set_player_prestige(21);
	self maps\mp\alien\_persistence::set_player_xp(2500000);
	rDone();
}

array_copy(originalArray)
{
	newArray = [];
	for (i = 0; i < originalArray.size; i++)
	{
		newArray[i] = originalArray[i];
	}
	return newArray;
}

arrayremovevalue(array, value)
{
	newArray = [];

	for (i = 0; i < array.size; i++)
	{
		if (array[i] != value)
		{
			newArray[newArray.size] = array[i];
		}
	}
	return newArray;
}

IsInArray(array, item)
{
	foreach(entry in array)
	{
		if (entry == item) return true;
	}
	return false;
}

remove_duplicate_entries(array)
{
	new_array = [];

	foreach(item in array)
	{
		if (!array_contains(new_array, item))
		{
			new_array[new_array.size] = item;
		}
	}

	return new_array;
}

get_random_challenge()
{
	map = getDvar("mapname");

	if (map == "mp_alien_town")
	{
		level.challenges = ["spend_10k", "melee_only", "spend_20k", "kill_leper", "spend_no_money", "no_reloads", "no_abilities", "take_no_damage", "melee_5_goons", "melee_spitter", "no_stuck_drill", "kill_10_with_propane", "stay_prone", "kill_10_with_traps", "avoid_minion_explosion", "75_percent_accuracy", "pistols_only", "shotguns_only", "snipers_only", "lmgs_only", "ar_only", "smg_only", "kill_10_with_turrets", "kill_airborne_aliens", "50_percent_accuracy", "kill_10_in_30", "protect_player", "no_laststand", "no_bleedout"];
	}
	else if (map == "mp_alien_armory")
	{
		level.challenges = ["spend_10k", "spend_20k", "kill_leper", "spend_no_money", "no_reloads", "no_abilities", "melee_5_goons", "melee_spitter", "focus_fire", "healthy_kills", "minion_preexplode", "kill_nodamage", "no_stuck_drill", "stay_prone", "kill_10_with_traps", "avoid_minion_explosion", "stay_within_area", "long_shot", "pistols_only", "shotguns_only", "snipers_only", "lmgs_only", "ar_only", "smg_only", "kill_10_with_turrets", "kill_airborne_aliens", "50_percent_accuracy", "kill_10_in_30", "protect_player", "no_laststand", "no_bleedout"];
	}
	else if (map == "mp_alien_beacon")
	{
		level.challenges = ["spend_10k", "spend_20k", "kill_leper", "spend_no_money", "no_reloads", "no_abilities", "melee_5_goons", "melee_spitter", "focus_fire", "healthy_kills", "minion_preexplode", "kill_nodamage", "no_stuck_drill", "stay_prone", "kill_10_with_traps", "avoid_minion_explosion", "stay_within_area", "long_shot", "pistols_only", "shotguns_only", "snipers_only", "lmgs_only", "ar_only", "smg_only", "kill_10_with_turrets", "kill_airborne_aliens", "50_percent_accuracy", "kill_10_in_30", "protect_player", "no_laststand", "no_bleedout"];
	}
	else if (map == "mp_alien_dlc3")
	{
		level.challenges = ["spend_10k", "spend_20k", "kill_leper", "spend_no_money", "no_reloads", "no_abilities", "melee_5_goons_dlc3", "team_prone", "jump_shot", "lower_ground", "higher_ground", "flying_aliens", "melee_gargoyles", "bomber_preexplode", "melee_spitter", "focus_fire", "healthy_kills", "new_weapon", "kill_nodamage", "no_stuck_drill", "stay_prone", "kill_10_with_traps", "stay_within_area", "long_shot", "pistols_only", "shotguns_only", "snipers_only", "lmgs_only", "ar_only", "smg_only", "kill_airborne_aliens", "50_percent_accuracy", "kill_10_in_30", "protect_player", "no_laststand", "no_bleedout", "2_weapons_only", "semi_autos_only"];
	}
	else if (map == "mp_alien_last")
	{
		level.challenges = ["spend_10k", "spend_20k", "kill_leper", "spend_no_money", "no_reloads", "no_abilities", "melee_5_goons_last", "melee_spitter", "focus_fire", "healthy_kills", "minion_preexplode", "kill_nodamage", "no_stuck_drill", "stay_prone", "kill_10_with_traps", "avoid_minion_explosion", "stay_within_area_1", "stay_within_area_2", "stay_within_area_3", "stay_within_area_4", "stay_within_area_5", "long_shot", "pistols_only", "shotguns_only", "snipers_only", "lmgs_only", "ar_only", "smg_only", "kill_10_with_turrets", "kill_airborne_aliens", "50_percent_accuracy", "kill_10_in_30", "no_laststand", "no_bleedout", "semi_autos_only", "2_weapons_only", "bomber_preexplode", "melee_gargoyles", "new_weapon", "kill_ancestor", "weakpoint_ancestor", "no_ancestor_damage", "flying_aliens", "higher_ground", "lower_ground", "team_prone"];
	}

	random_index = randomint(level.challenges.size);
	return level.challenges[random_index];
}

is_relic_active(relic)
{
	return array_contains(self.activated_nerfs, relic);
}

deactivate_relic()
{
	relics = ["nerf_take_more_damage", "nerf_higher_threat_bias", "nerf_pistols_only", "nerf_smaller_wallet", "nerf_no_class", "nerf_lower_weapon_damage", "nerf_fragile", "nerf_move_slower", "nerf_no_abilities", "nerf_min_ammo", "nerf_no_deployables"];

	foreach(relic in relics)
	{
		switch (relic)
		{
		case "nerf_take_more_damage":
			self.nerf_scalars["nerf_take_more_damage"] = 1;
			break;

		case "nerf_higher_threatbias":
			self.threatbias = 0;
			break;

		case "nerf_smaller_wallet":
			current_wallet_size = self.maxCurrency;
			self maps\mp\alien\_persistence::set_player_max_currency(current_wallet_size);
			break;

		case "nerf_lower_weapon_damage":
			self.nerf_scalars["nerf_lower_weapon_damage"] = 1.0;
			break;

		case "nerf_no_class":
			self.nerf_scalars["nerf_no_class"] = 0;
			break;

		case "nerf_pistols_only":
			self.nerf_scalars["nerf_pistols_only"] = 0;
			break;

		case "nerf_fragile":
			self.nerf_scalars["nerf_fragile"] = 1.0;
			break;

		case "nerf_move_slower":
			self.nerf_scalars["nerf_move_slower"] = 1.0;
			break;

		case "nerf_no_abilities":
			self.nerf_scalars["nerf_no_abilities"] = 0;
			break;

		case "nerf_min_ammo":
			self.nerf_scalars["nerf_min_ammo"] = 1.0;
			break;

		case "nerf_no_deployables":
			self.nerf_scalars["nerf_no_deployables"] = 0;
			break;
		}
	}
}
