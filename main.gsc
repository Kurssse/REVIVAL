#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;
#include maps\mp\alien\_utility;

init()
{
	precacheShader("white");
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
