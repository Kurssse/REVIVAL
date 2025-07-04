#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;
#include maps\mp\alien\_utility;

init()
{
	precacheshader("white");
	precacheModel("test_sphere_silver");
	level._revival_portalmodel = "test_sphere_silver";
	level.REVIVAL_INITIALIZED = 0;
	level.REVIVAL_MIN_OVERFLOW_THRESHOLD = 750;
	level.REVIVAL_MAX_OVERFLOW_THRESHOLD = 1250;
	level.REVIVAL_CURRENT_OVERFLOW_COUNTER = 0;
	level.nojoin = false;
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for (;;)
	{
		level waittill("connected", player);
		if (level.nojoin)
			kick(player getentitynumber());
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self waittill("spawned_player");
	if (getDvar("ui_gametype") == "aliens")
	{
		if (self isHost())
		{
			level REVIVAL_INIT();
			self thread SpawnMSG();
		}
		while (!level.REVIVAL_INITIALIZED)
			wait .05;
		level.cvars[self getName()] = REVIVAL_CLIENT_DEFAULTS(self);
		self thread REVIVAL_MONITOR();
		self thread REVIVALWaittillVerificationChanged();
	}
}

createShader(shader, align, relative, x, y, width, height, color, alpha, sort)
{
	hud = newClientHudElem(self);
	hud.elemtype = "icon";
	hud.color = color;
	hud.alpha = alpha;
	hud.sort = sort;
	hud.children = [];
	hud setParent(level.uiParent);
	hud setShader(shader, width, height);
	hud setPoint(align, relative, x, y);
	hud.hideWhenInMenu = true;
	hud.archived = false;
	return hud;
}

drawShader(shader, x, y, width, height, color, alpha, sort)
{
	hud = newClientHudElem(self);
	hud.elemtype = "icon";
	hud.color = color;
	hud.alpha = alpha;
	hud.sort = sort;
	hud.children = [];
	hud setParent(level.uiParent);
	hud setShader(shader, width, height);
	hud.x = x;
	hud.y = y;
	hud.hideWhenInMenu = true;
	hud.archived = false;
	return hud;
}

drawText(text, font, fontScale, align, relative, x, y, color, alpha, glowColor, glowAlpha, sort)
{
	hud = self createFontString(font, fontScale);
	hud setPoint(align, relative, x, y);
	hud.color = color;
	hud.alpha = alpha;
	hud.glowColor = glowColor;
	hud.glowAlpha = glowAlpha;
	hud.sort = sort;
	hud.alpha = alpha;
	hud setText(text);
	if (text == "RInitialization")
		hud.foreground = true;
	hud.hideWhenInMenu = true;
	hud.archived = false;
	return hud;
}

rSetText(svar)
{
	self SetText(svar);
	level.REVIVAL_CURRENT_OVERFLOW_COUNTER++;
	if (level.REVIVAL_CURRENT_OVERFLOW_COUNTER > level.REVIVAL_MIN_OVERFLOW_THRESHOLD)
	{
		level notify("REVIVAL_OVERFLOW_BEGIN_WATCH");
	}
}

SpawnMSG(text, textb, textc)
{
	wait 7.5;
	notifyData = spawnstruct();
	notifyData.titletext = "Welcome To ^1Revival";
	notifyData.notifytext = "Created By kurssse";
	notifyData.notifytext2 = "^1Press ^7[{+speed_throw}] ^1& ^7[{+melee}] ^1to open";
	notifyData.glowcolor = (.2, .2, .2);
	notifyData.sound = "alien_hive_destroyed";
	notifyData.duration = 6;
	notifyData.font = "objective";
	notifyData.hidewheninmenu = 1;
	self thread maps\mp\gametypes\_hud_message::notifymessage(notifyData);
}

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
			AddSubMenu("Other Models", 2);
				foreach(model in menuModels)
				{
					AddOption(model, ::void_handler, 44, model);
				}
			CloseSubMenu();
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
					foreach (challenge in level.challenges)
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
			AddOption("Money Lobby", ::void_handler, 66);
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
		thread maps\mp\alien\_airdrop::escape();
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
	else if (option == 66)
	{
		if (rToggle(66))
		{
			level.new_cycle_reward_scalar = level.cycle_reward_scalar * 10;
			return level.new_cycle_reward_scalar;
		}
		else
		{
			return level.cycle_reward_scalar;
		}
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
			foreach (player in self.modifierlist)
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
