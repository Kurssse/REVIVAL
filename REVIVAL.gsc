REVIVAL_INIT()
{
	level.REVIVAL = spawnstruct();
	level.si_current_menu = 0;
	level.si_next_menu = 0;
	level.si_players_menu = -2;
	level.si_previous_menus = [];
	level.REVIVAL.menu = [];
	level.REVIVAL.cvars = [];
	level.REVIVAL.svars = [];
	level.REVIVAL.verifiedlist = [];
	level.REVIVAL.verifiedlist = strtok(getDvar("REVIVALverified"), ",");
	level thread REVIVAL_SMART_OVERFLOW_FIX();
	level OptionsInit();
}

REVIVALADDCLIENTVERIFICATION(CLIENTNAME, ACCESS)
{
	REVIVALREMOVECLIENTVERIFICATION(CLIENTNAME);
	dvar = "REVIVALverified";
	vf = strtok(getDvar(dvar), ",");
	vf = add_to_array(vf, CLIENTNAME + ";" + ACCESS, 0);
	str = "";
	for (i = 0; i < vf.size - 1; i++)
		str += vf[i] + ",";
	str += vf[vf.size - 1];
	setDvar(dvar, str);
	level.REVIVAL.verifiedlist = [];
	level.REVIVAL.verifiedlist = strtok(getDvar("REVIVALverified"), ",");
	getPlayerFromName(CLIENTNAME) notify("VerificationChanged");
}

REVIVAL_CLIENT_DEFAULTS(player)
{
	struct = spawnstruct();
	struct.menu = REVIVAL_CREATE_MENU(player);
	struct.bvars = [];
	struct.vars = spawnstruct();
	return struct;
}

REVIVAL_CREATE_MENU(player)
{
	res = getDvar("r_mode");
	res_width = int(strtok(res, "x")[0]);
	ref_width = 640;
	scaleX = (res_width / ref_width);
	player.control_scheme = 0;
	player.menutransitionfade = false;
	player.bgcolor = (.25, .25, .25);
	player.framecolor = (.22, 1, 1);
	player.slidercolor = (.2, .8, .2);
	struct = spawnStruct();
	struct.selectedPlayer = undefined;
	struct.currentMenu = -1;
	struct.cursor = 0;
	struct.roffset = 0;
	struct.background = player drawShader("white", int(scaleX * 300), 75, 200, 250, player.bgcolor, 0, 0);
	struct.header = player drawShader("white", int(scaleX * 300), 50, 200, 2, player.framecolor, 0, 5);
	struct.headerbottom = player drawShader("white", int(scaleX * 300), 73, 200, 2, player.framecolor, 0, 5);
	struct.headerbg = player drawShader("white", int(scaleX * 300), 50, 200, 25, (0, 0, 0), 0, 4);
	struct.headerbg2 = player drawShader("white", int(scaleX * 300), 50, 200, 25, (player.framecolor * (.75, .75, .75)), 0, 3);
	struct.textelems = [];
	for (i = 0; i < 10; i++)
		struct.textelems[i] = drawText("", "objective", 1.5, "CENTER", "TOP", int(scaleX * 125), 108 + (i * 20), (1, 1, 1), 0, (0, 0, 0), 0, 2);
	struct.slider = player drawShader("white", int(scaleX * 310), 98, 182, 21, player.slidercolor, 0, 1);
	struct.footer = player drawShader("white", int(scaleX * 300), 325, 200, 2, player.framecolor, 0, 5);
	struct.leftborder = player drawShader("white", int(scaleX * 300), 50, 2, 275, player.framecolor, 0, 5);
	struct.rightborder = player drawShader("white", int(scaleX * 460), 50, 2, 275, player.framecolor, 0, 5);
	struct.title = player drawText("RInitialization", "objective", 1.7, "CENTER", "TOP", int(scaleX * 125), 62, (1, 1, 1), 0, (0, 0, 0), 0, 6);
	struct.index = 0;
	struct.access = player rGetAccess();
	level.REVIVAL_CURRENT_OVERFLOW_COUNTER += 11;
	return struct;
}

REVIVAL_MONITOR()
{
	if (self rGetAccess() < 1)
		return;
	self endon("VerificationChanged");
	self.forceupdate = false;
	Menu = self rGetMenu();
	windowend = undefined;
	windowst = undefined;
	realoffset = undefined;
	while (true)
	{
		wait .05;
		if (!isAlive(self))
		{
			Menu.currentMenu = -1;
			UpdateMenu();
			while (!isAlive(self))
				wait .1;
		}
		if (self adsbuttonpressed() && self meleebuttonpressed() && Menu.currentMenu == -1)
		{
			Menu.currentmenu = 0;
			self freezecontrols(self.control_scheme);
			UpdateMenu();
			self enableweaponswitch();
			self enableoffhandweapons();
			while (self adsbuttonpressed() || self meleebuttonpressed())
				wait .1;
		}
		else if (self meleebuttonpressed() && Menu.currentMenu == 0)
		{
			Menu.currentmenu = -1;
			self notify("CleanupSlider");
			self freezecontrols(0);
			UpdateMenu();
			while (self meleebuttonpressed())
				wait .1;
		}
		else if (self RevivalUpButtonPressed() && Menu.currentMenu != -1 || self.forceupdate)
		{
			self.menutransitionfade = true;
			self.forceupdate = false;
			if (Menu.currentMenu != level.si_players_menu && !self.forceupdate)
			{
				if (level.REVIVAL.menu[Menu.currentmenu].options.size == 1)
					continue;
				if ((Menu.cursor + Menu.roffset) < 1)
				{
					if ((level.REVIVAL.menu[Menu.currentmenu].options.size - 1) > 9)
						Menu.cursor = 9;
					else
						Menu.cursor = level.REVIVAL.menu[Menu.currentmenu].options.size - 1;
					if (((level.REVIVAL.menu[Menu.currentmenu].options.size - 1) - Menu.cursor) > 0)
						Menu.roffset = ((level.REVIVAL.menu[Menu.currentmenu].options.size - 1) - Menu.cursor);
					else
						Menu.roffset = 0;
				}
				else if (Menu.roffset > 0 && Menu.cursor < 1)
					Menu.roffset--;
				else
					Menu.cursor--;
			}
			else if (!self.forceupdate)
			{
				if (level.players.size == 1)
					continue;
				if ((Menu.cursor + Menu.roffset) < 1)
				{
					if ((level.players.size - 1) > 9)
						Menu.cursor = 9;
					else
						Menu.cursor = level.players.size - 1;
					if (((level.players.size - 1) - Menu.cursor) > 0)
						Menu.roffset = ((level.players.size - 1) - Menu.cursor);
					else
						Menu.roffset = 0;
				}
				else if (Menu.roffset > 0 && Menu.cursor < 1)
					Menu.roffset--;
				else
					Menu.cursor--;
			}
			if (Menu.cursor < 1 || Menu.cursor == 9)
			{
				windowend = 0;
				if (Menu.currentMenu != level.si_players_menu && Menu.offset > 0 && level.REVIVAL.menu[Menu.currentmenu].options.size > 10)
				{
					windowend = 9 + Menu.roffset;
					windowst = windowend - 9;
					for (i = windowst; i <= windowend; i++)
					{
						Menu.textelems[(i - windowst)] rSetText(level.REVIVAL.menu[Menu.currentmenu].options[i].title);
					}
				}
				else if (Menu.currentMenu == level.si_players_menu && Menu.offset > 0 && level.players.size > 10)
				{
					windowend = (level.players.size - 1) - Menu.roffset;
					windowst = windowend - 9;
					for (i = windowst; i <= windowend; i++)
					{
						Menu.textelems[(i - windowst)] rSetText("[" + rGetAccessString(level.players[i] rGetAccess()) + "]" + level.players[i] getName());
					}
				}
				wait .05;
				self.menutransitionfade = false;
			}
			Menu.slider moveOverTime(.05);
			Menu.slider.y = 98 + (Menu.cursor * 20);
			while (self RevivalUpButtonPressed())
				wait .05;
		}
		else if (self RevivalDownButtonPressed() && Menu.currentMenu != -1)
		{
			if (Menu.currentMenu != level.si_players_menu)
			{
				if ((Menu.cursor + Menu.roffset) >= (level.REVIVAL.menu[Menu.currentmenu].options.size - 1))
				{
					Menu.cursor = 0;
					Menu.roffset = 0;
				}
				else if (Menu.cursor < 9)
					Menu.cursor++;
				else
					Menu.roffset++;
			}
			else
			{
				if ((Menu.cursor + Menu.roffset) >= (level.players.size - 1))
				{
					Menu.cursor = 0;
					Menu.roffset = 0;
				}
				else if (Menu.cursor < 9)
					Menu.cursor++;
				else
					Menu.roffset++;
			}
			if (Menu.cursor == 9 || Menu.cursor == 0)
			{
				windowend = 0;
				self.menutransitionfade = true;
				if (Menu.currentMenu != level.si_players_menu && level.REVIVAL.menu[Menu.currentmenu].options.size > 9)
				{
					if ((Menu.roffset + 9) > (level.REVIVAL.menu[Menu.currentmenu].options.size - 1))
						windowend = level.REVIVAL.menu[Menu.currentmenu].options.size - 1;
					else
						windowend = Menu.roffset + 9;
					windowst = windowend - 9;
					for (i = windowst; i <= windowend; i++)
					{
						Menu.textelems[(i - windowst)] rSetText(level.REVIVAL.menu[Menu.currentmenu].options[i].title);
					}
				}
				else if (level.players.size > 9 && Menu.currentMenu == level.si_players_menu)
				{
					if ((Menu.roffset + 9) > (level.players.size - 1))
						windowend = level.players.size - 1;
					else
						windowend = Menu.roffset + 9;
					windowst = windowend - 9;
					for (i = windowst; i <= windowend; i++)
					{
						Menu.textelems[(i - windowst)] rSetText("[" + rGetAccessString(level.players[i] rGetAccess()) + "]" + level.players[i] getName());
					}
				}
				wait .05;
				self.menutransitionfade = false;
			}
			Menu.slider moveOverTime(.05);
			Menu.slider.y = 98 + (Menu.cursor * 20);
			while (self RevivalDownButtonPressed())
				wait .05;
		}
		else if (self RevivalSelectButtonPressed() && Menu.currentMenu != -1)
		{
			self PerformOption();
			while (self RevivalSelectButtonPressed() && isAlive(self))
				wait .1;
		}
		else if (self meleebuttonpressed() && Menu.currentMenu > 0)
		{
			Menu.currentmenu = level.REVIVAL.menu[Menu.currentmenu].parentmenu;
			Menu.cursor = 0;
			Menu.roffset = 0;
			UpdateMenu();
			while (self meleebuttonpressed())
				wait .1;
		}
	}
}

REVIVALREMOVECLIENTVERIFICATION(CLIENTNAME)
{
	dvar = "REVIVALverified";
	vf = strtok(getDvar(dvar), ",");
	str = "";
	for (i = 0; i < vf.size - 1; i++)
		if (strtok(vf[i], ";")[0] != CLIENTNAME)
			str += vf[i] + ",";
	if (strtok(vf[i], ";")[0] != CLIENTNAME)
		str += vf[vf.size - 1];
	setDvar(dvar, str);
	level.REVIVAL.verifiedlist = [];
	level.REVIVAL.verifiedlist = strtok(getDvar("REVIVALverified"), ",");
	getPlayerFromName(CLIENTNAME) notify("VerificationChanged");
}

REVIVALWaittillVerificationChanged()
{
	for (;;)
	{
		self waittill("VerificationChanged");
		self rCleanupMenu();
		if (self rGetVerified())
		{
			level.cvars[self getName()] = REVIVAL_CLIENT_DEFAULTS(self);
			self thread REVIVAL_MONITOR();
		}
	}
}

AddOption(title, function, arg1, arg2, arg3, arg4, arg5)
{
	parentmenu = level.REVIVAL.menu[level.si_current_menu];
	parentmenu.options[parentmenu.options.size] = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].function = function;
	parentmenu.options[parentmenu.options.size - 1].title = title;
	parentmenu.options[parentmenu.options.size - 1].arg1 = arg1;
	parentmenu.options[parentmenu.options.size - 1].arg2 = arg2;
	parentmenu.options[parentmenu.options.size - 1].arg3 = arg3;
	parentmenu.options[parentmenu.options.size - 1].arg4 = arg4;
	parentmenu.options[parentmenu.options.size - 1].arg5 = arg5;
}

AddPlayersMenu()
{
	AddSubMenu("Players Menu", 3);
	level.si_players_menu = level.si_current_menu;
	for (i = 0; i < 17; i++)
	{
		AddSubMenu("Undefined", 3);
		ClosePlayersSubMenu();
	}
	AddSubMenu("Player", 3);
}

AddSubMenu(title, access)
{
	level.si_previous_menus[level.si_previous_menus.size] = level.si_current_menu;
	parentmenu = level.REVIVAL.menu[level.si_current_menu];
	parentmenu.options[parentmenu.options.size] = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].function = ::submenu;
	parentmenu.options[parentmenu.options.size - 1].title = title;
	level.si_next_menu++;
	parentmenu.options[parentmenu.options.size - 1].arg1 = level.si_next_menu;
	parentmenu.options[parentmenu.options.size - 1].arg2 = access;
	level.REVIVAL.menu[level.si_next_menu] = spawnstruct();
	level.REVIVAL.menu[level.si_next_menu].options = [];
	level.REVIVAL.menu[level.si_next_menu].title = title;
	level.REVIVAL.menu[level.si_next_menu].parentmenu = level.si_current_menu;
	level.si_current_menu = level.si_next_menu;
}

ClosePlayersMenu()
{
	CloseSubMenu();
	CloseSubMenu();
}

ClosePlayersSubMenu()
{
	level.si_next_menu--;
	CloseSubMenu();
}

CreateRoot(title)
{
	level.REVIVAL.menu[0] = spawnstruct();
	level.REVIVAL.menu[0].options = [];
	level.REVIVAL.menu[0].title = title;
}

CloseSubMenu()
{
	if (level.si_previous_menus.size < 1)
		return;
	level.si_current_menu = level.si_previous_menus[level.si_previous_menus.size - 1];
	level.si_previous_menus[level.si_previous_menus.size - 1] = undefined;
}

getName()
{
	nT = getSubStr(self.name, 0, self.name.size);
	for (i = 0; i < nT.size; i++)
	{
		if (nT[i] == "]")
			break;
	}
	if (nT.size != i)
		nT = getSubStr(nT, i + 1, nT.size);
	return nT;
}

getPlayerFromName(name)
{
	foreach(player in level.players)
	{
		if (player GetName() == name)
			return player;
	}
	return undefined;
}

ifthen(bool, str, str2)
{
	if (isDefined(bool) && bool)
		return str;
	return str2;
}

PerformOption()
{
	self endon("CleanupSlider");
	Menu = self rGetMenu();
	Menu.slider.alpha = .5;
	SMenu = level.REVIVAL.menu[Menu.currentmenu];
	if (Menu.currentmenu == level.si_players_menu)
		Menu.selectedplayer = level.players[(Menu.cursor + Menu.roffset)];
	si_menu = SMenu.options[(Menu.cursor + Menu.roffset)];
	self thread [[ si_menu.function ]] (si_menu.arg1, si_menu.arg2, si_menu.arg3, si_menu.arg4, si_menu.arg5);
	wait .15;
	Menu.slider.alpha fadeovertime(.25);
	Menu.slider.alpha = 1;
}

Submenu(child, access)
{
	Menu = self rGetMenu();
	if (Menu.access < access)
	{
		self iprintln("You do not have permission to access this menu");
		return;
	}
	Menu.currentMenu = child;
	if (Menu.currentMenu == level.si_players_menu)
		Menu.selectedPlayer = level.players[Menu.cursor + Menu.roffset];
	Menu.cursor = 0;
	Menu.roffset = 0;
	self UpdateMenu();
}

UpdateMenu(textonly)
{
	Menu = self rGetMenu();
	if (Menu.currentMenu == -1)
	{
		self.menutransitionfade = true;
		for (i = 0; i < 10; i++)
		{
			Menu.textelems[i] fadeovertime(.4);
			Menu.textelems[i].alpha = 0;
			Menu.textelems[i] moveovertime(.25);
			Menu.textelems[i].y = 60;
		}
		wait .4;
		Menu.background fadeovertime(.25);
		Menu.header fadeovertime(.25);
		Menu.footer fadeovertime(.25);
		Menu.slider fadeovertime(.25);
		Menu.leftborder fadeovertime(.25);
		Menu.rightborder fadeovertime(.25);
		Menu.title fadeovertime(.25);
		Menu.headerbottom fadeovertime(.25);
		Menu.headerbg fadeovertime(.25);
		Menu.headerbg2 fadeovertime(.25);
		Menu.headerbg2.alpha = 0;
		Menu.background.alpha = 0;
		Menu.header.alpha = 0;
		Menu.footer.alpha = 0;
		Menu.slider.alpha = 0;
		Menu.leftborder.alpha = 0;
		Menu.rightborder.alpha = 0;
		Menu.title.alpha = 0;
		Menu.headerbottom.alpha = 0;
		Menu.headerbg.alpha = 0;
		wait .25;
		wait .05;
		self.menutransitionfade = false;
	}
	else
	{
		self.menutransitionfade = true;
		if (!isDefined(textOnly))
		{
			Menu.background fadeovertime(.25);
			Menu.header fadeovertime(.25);
			Menu.footer fadeovertime(.25);
			Menu.slider fadeovertime(.25);
			Menu.leftborder fadeovertime(.25);
			Menu.rightborder fadeovertime(.25);
			Menu.title fadeovertime(.25);
			Menu.headerbottom fadeovertime(.25);
			Menu.headerbg fadeovertime(.25);
			Menu.headerbg2 fadeovertime(.25);
			Menu.background.alpha = 1;
			Menu.header.alpha = 1;
			Menu.footer.alpha = 1;
			Menu.slider.alpha = .75;
			Menu.leftborder.alpha = 1;
			Menu.rightborder.alpha = 1;
			Menu.title.alpha = 1;
			Menu.headerbottom.alpha = 1;
			Menu.headerbg.alpha = 1;
			Menu.headerbg2.alpha = 1;
			Menu.cursor = 0;
			Menu.roffset = 0;
		}
		Menu.title rSetText(level.REVIVAL.menu[Menu.currentMenu].title);
		if (Menu.currentMenu != level.si_players_menu)
			for (i = 0; i < 10; i++)
			{
				if (!isDefined(textOnly))
				{
					Menu.textelems[i].alpha = 0;
					Menu.textelems[i] fadeovertime(.25);
				}
				if (level.REVIVAL.menu[Menu.currentMenu].options.size > i)
				{
					Menu.textelems[i] rSetText(level.REVIVAL.menu[Menu.currentMenu].options[i].title);
					if (!isDefined(textOnly))
						Menu.textelems[i].alpha = 1;
				}
				if (!isDefined(textOnly))
				{
					Menu.textelems[i] moveovertime(.25);
					Menu.textelems[i].y = 108 + (i * 20);
				}
			}
		else
		{
			if (!isDefined(textOnly))
				for (i = 0; i < 10; i++)
				{
					Menu.textelems[i].alpha = 0;
					Menu.textelems[i] fadeovertime(.25);
				}
			for (i = 0; i < 10 && i < level.players.size; i++)
			{
				Menu.textelems[i] rSetText("[" + rGetAccessString(level.players[i] rGetAccess()) + "]" + level.players[i] getName());
				if (!isDefined(textOnly))
					Menu.textelems[i].alpha = 1;
			}
		}
		if (!isDefined(textOnly))
		{
			Menu.slider moveovertime(.05);
			Menu.slider.y = 98;
		}
		wait .26;
		self.menutransitionfade = false;
	}
}

rGetAccess()
{
	if (!self rGetVerified())
		return 0;
	if (self isHost())
		return 4;
	str = strtok(getDvar("REVIVALverified"), ",");
	for (i = 0; i < str.size; i++)
	{
		if (strtok(str[i], ";")[0] == self GetName())
		{
			return Int(Strtok(str[i], ";")[1]);
		}
	}
	return 0;
}

rGetAccessString(accessLevel)
{
	if (accessLevel == 0)
		return " ";
	if (accessLevel == 1)
		return "Verified";
	if (accessLevel == 2)
		return "Elevated";
	if (accessLevel == 3)
		return "CoHost";
	return "Host";
}

rGetBool(index)
{
	menu = self rGetMenu();
	return isDefined(menu.bvars[index]) && menu.bvars[index];
}

rGetHost()
{
	for (i = 0; i < level.players.size; i++)
	{
		if (level.players[i] isHost())
			return level.players[i];
	}
	return undefined;
}

rGetMenu()
{
	return level.cvars[self GetName()].menu;
}

rGetVerified()
{
	if (self isHost())
		return 1;
	str = strtok(getDvar("REVIVALVerified"), ",");
	for (i = 0; i < str.size; i++)
		if (strtok(str[i], ";")[0] == self getName())
			return 1;
	return 0;
}

rSetBool(index, value)
{
	Menu = self rGetMenu();
	Menu.bvars[index] = value;
}

rSyncBool(index)
{
	foreach(client in self.modifierlist)
	{
		if (client rGetVerified())
			client rSetBool(index, rGetGlobalBool(index));
	}
}

rGlobalToggle(index)
{
	cval = rGetGlobalBool(index);
	if (isDefined(cval) && cval)
		cval = false;
	else
		cval = true;
	rSetGlobal(index, cval);
	if (cval)
		rEnabled();
	else
		rDisabled();
	rSyncBool(index);
	return cval;
}

rSetGlobal(index, value)
{
	level.REVIVAL.svars[index] = value;
}

rGetGlobalBool(index)
{
	return isDefined(level.REVIVAL.svars[index]) && level.REVIVAL.svars[index];
}

rToggle(index, client)
{
	cval = undefined;
	if (isDefined(client))
	{
		cval = client rGetBool(index);
		cval = !cval;
		client rSetBool(index, cval);
	}
	else
	{
		cval = rGetBool(index);
		cval = !cval;
		rSetBool(index, cval);
	}
	if (cval)
		rEnabled();
	else
		rDisabled();
	return cval;
}

rCleanupMenu()
{
	Menu = self rGetMenu();
	if (!isDefined(Menu))
		return;
	Menu.background Destroy();
	Menu.header Destroy();
	Menu.footer Destroy();
	Menu.slider Destroy();
	Menu.leftborder Destroy();
	Menu.rightborder Destroy();
	Menu.title Destroy();
	Menu.headerbottom Destroy();
	Menu.headerbg Destroy();
	Menu.headerbg2 Destroy();
	for (i = 0; i < Menu.textelems.size; i++)
		Menu.textelems[i] Destroy();
	Menu Delete();
}

rDisabled()
{
	self iprintln("^1Disabled");
}

rDone()
{
	self iprintln("Done!");
}

rEnabled()
{
	self iprintln("^2Enabled");
}

RevivalUpButtonPressed()
{
	return self adsbuttonpressed();
}

RevivalDownButtonPressed()
{
	return self attackbuttonpressed();
}

RevivalSelectButtonPressed()
{
	return self usebuttonpressed();
}

rHostOnly()
{
	self iprintln("Host Only.");
}

rNotForAllPlayers()
{
	self iprintln("Not supported for all players");
}

REVIVAL_SMART_OVERFLOW_FIX()
{
	return;
	bool = false;
	REVIVAL_SMART_OVERFLOW_ANCHOR = createServerFontString("default", 1.5);
	REVIVAL_SMART_OVERFLOW_ANCHOR rSetText("default");
	REVIVAL_SMART_OVERFLOW_ANCHOR.alpha = 0;
	for (;;)
	{
		while (level.REVIVAL_CURRENT_OVERFLOW_COUNTER < level.REVIVAL_MAX_OVERFLOW_THRESHOLD)
		{
			level waittill_any("REVIVAL_OVERFLOW_BEGIN_WATCH");
			bool = false;
			foreach(player in level.players)
				menu = player rGetMenu();
			if (player rGetVerified() && menu.currentmenu != -1)
				bool = true;
			if (level.REVIVAL_CURRENT_OVERFLOW_COUNTER >= level.REVIVAL_MAX_OVERFLOW_THRESHOLD)
				break;
			wait .02;
		}
		level.REVIVAL_CURRENT_OVERFLOW_COUNTER = 0;
		while (rGetTransitionState() > 0)
			wait .1;
		REVIVAL_SMART_OVERFLOW_ANCHOR clearAllTextAfterHudElem();
		wait .01;
		foreach(player in level.players)
		{
			player rReCreateTextElements();
			menu = player rGetMenu();
			if (menu.currentMenu != -1)
				player.forceupdate = true;
		}
		wait .02;
	}
}

rReCreateTextElements()
{
	res = getDvar("r_mode");
	res_width = int(strtok(res, "x")[0]);
	ref_width = 640;
	scaleX = (res_width / ref_width);
	struct = self rGetMenu();
	for (i = 0; i < struct.textelems.size; i++)
		struct.textelems[i] Destroy();
	struct.title Destroy();
	for (i = 0; i < 10; i++)
		struct.textelems[i] = drawText("", "objective", 1.5, "CENTER", "TOP", int(scaleX * 125), 108 + (i * 20), (1, 1, 1), 0, (0, 0, 0), 0, 2);
	struct.title = self drawText("RInitialization", "objective", 1.7, "CENTER", "TOP", int(scaleX * 125), 62, (1, 1, 1), 0, 0, 6);
}

rGetTransitionState()
{
	count = 0;
	foreach(player in level.players)
		if (isDefined(player.menutransitionfade) && player.menutransitionfade)
			count++;
	return count;
}

UpdateMenuLook()
{
	Menu = self rGetMenu();

	self.menutransitionfade = true;
	Menu.background fadeovertime(.25);
	Menu.header fadeovertime(.25);
	Menu.footer fadeovertime(.25);
	Menu.slider fadeovertime(.25);
	Menu.leftborder fadeovertime(.25);
	Menu.rightborder fadeovertime(.25);
	Menu.title fadeovertime(.25);
	Menu.headerbottom fadeovertime(.25);
	Menu.headerbg fadeovertime(.25);
	Menu.headerbg2 fadeovertime(.25);
	Menu.slider.color = self.slidercolor;
	Menu.background.color = self.bgcolor;
	Menu.header.color = self.framecolor;
	Menu.footer.color = self.framecolor;
	Menu.leftborder.color = self.framecolor;
	Menu.rightborder.color = self.framecolor;
	Menu.headerbottom.color = self.framecolor;
	Menu.headerbg.color = ifthen(self.framecolor == (0, 0, 0), (1, 1, 1), (0, 0, 0));
	Menu.headerbg2.color = self.framecolor * (.75, .75, .75);
	wait .26;
	self.menutransitionfade = false;
}
