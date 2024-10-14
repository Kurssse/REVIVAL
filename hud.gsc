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
