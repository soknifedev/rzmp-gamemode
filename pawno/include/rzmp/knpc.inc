/**
* Knife's Zombies coded again from the RZ Survival Server.
* Copyright soknife.dev 2023
*/

#include <a_samp>
#include <FCNPC>
#include <YSI-Includes\YSI\y_hooks>
#include <PawnPlus>
#include <pause>

#if !defined equal
	#define equal(%0,%1) !strcmp(%0,%1,false) && strlen(%0) != strlen(%1)
#endif

#if !defined PRESSED
	#define PRESSED(%0) \
    	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#endif

#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))

#define PRESSING(%0,%1) \
	(%0 & (%1))

#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))


new Fmsg[256];
#define SendFormatMessageToAll(%1,%2,%3) format(Fmsg, sizeof(Fmsg),%2,%3) && SendClientMessageToAll(%1,Fmsg)
#define SendFormatMessage(%1,%2,%3,%4) format(Fmsg, sizeof(Fmsg),%3,%4) && SendClientMessage(%1,%2,Fmsg)

/**
* KNPC BOT Types
*/
#define KNPC_TYPE_GENERIC 0

/**
* KNPC Walking Styles
*/

#define WALKING_STYLE_TYPE_ZOMBIE 0


#define ENABLE_DEBUG

#if defined ENABLE_DEBUG
    #define KS_DEBUG(%0) SendFormatMessageToAll(-1, %0) && printf(%0)
#else
    stock _NO_DEBUG() { }
    #define KS_DEBUG(%0) _NO_DEBUG()
#endif

stock GetTickDiff(newtick, oldtick)
{
	if (oldtick < 0 && newtick >= 0) {
		return newtick - oldtick;
	} else if (oldtick >= 0 && newtick < 0 || oldtick > newtick) {
		return (cellmax - oldtick + 1) - (cellmin - newtick);
	}
	return newtick - oldtick;
}

/**
* Forward
*/
forward KNPC_OnConnect(npcId, type);
forward KNPC_OnDeath(npcId, killerId, weaponId, type);
forward KNPC_OnSpawn(npcId, type);
forward KNPC_OnRespawn(npcId, type);
forward KNPC_OnPlayerGiveDamage(playerId, npcId, damagedIdType, Float:amount, weaponId, bodypart);
forward KNPC_OnUpdate(npcId, nearestPlayerId, type);
forward KNPC_DoAutoRespawn(npcId);

/**
* Data Structures
* 
**/
enum KNPC_CONFIG_DATA
{
	Float:SeekMaxDistance/* = 120.0*/,
	Float:ZSMaxDistance/*= 70.0*/,
	Float:ZAMinDistance/* = 6.0*/,
	AutoRespawnTime,
	bool:HeadShotsAllowed
};
new KNPC_CONFIG[KNPC_CONFIG_DATA];

#define MAX_CAPABILITIES 2

#define CAPABILITY_ATTACK_ZOMBIES 0
#define CAPABILITY_ATTACK_HUMANS 1

enum KNPC_DATA
{
	TYPE,
	Float:AttackDamage/* = 8.0*/,
	WalkingLib[5],
	WalkingAnim[256],
	Float:MovingSpeed/* = 0.56444*/,
	BittingSpeed,
	BiteTick,
	SeekerTick,
	bool:Capability[MAX_CAPABILITIES],
	bool:AutoRespawn,
	Float:AttackRadius,
	Float:ThreatRadius,
	Float:SpawnPos[4] // X Y Z ANGLE
};
new KNPC_INFO[MAX_PLAYERS][KNPC_DATA];

enum KNPC_PLAYERDATA
{
	bool:Sprinting,
	SprintingTick,
	ZSTimeInterval // Currently unused... planned to auto spawn zombies around the player. 
};
new KNPC_PLAYER[MAX_PLAYERS][KNPC_PLAYERDATA];


new ZOMBIE_WALKING_STYLES[][] = { 
	"Sprint_Wuzi",
	"run_old",
	"sprint_panic",
	"run_fatold",
	"WALK_DRUNK",
	"run_civi",
	"run_fat",
	"skate_run",
	"SPANKINGW"
};



/**
* KNPC Config getters & setters
* 
**/
stock KNPC_setSeekMaxDistance(Float:distance) {
	KNPC_CONFIG[SeekMaxDistance] = distance;
}
stock Float:KNPC_getSeekMaxDistance() {
	return Float:KNPC_CONFIG[SeekMaxDistance];
}

stock KNPC_setZSMaxDistance(Float:distance) {
	KNPC_CONFIG[ZSMaxDistance] = distance;
}
stock Float:KNPC_getZSMaxDistance() {
	return KNPC_CONFIG[ZSMaxDistance];
}

stock KNPC_setZAMinDistance(Float:distance) {
	KNPC_CONFIG[ZAMinDistance] = distance;
}
stock Float:KNPC_getZAMinDistance() {
	return KNPC_CONFIG[ZAMinDistance];
}

stock KNPC_setAutoRespawnTime(seconds) {
	KNPC_CONFIG[AutoRespawnTime] = seconds * 1000;
}
stock KNPC_getAutoRespawnTime() {
	if(KNPC_CONFIG[AutoRespawnTime] <= 0) return 5000; // 5s
	return KNPC_CONFIG[AutoRespawnTime];
}

stock KNPC_setHeadShotsAllowed(bool:allowed) {
	KNPC_CONFIG[HeadShotsAllowed] = allowed;
}
stock bool:KNPC_isHeadShotsAllowed() {
	return bool:KNPC_CONFIG[HeadShotsAllowed];
}

stock KNPC_setZSTimeInterval(playerId, interval) {
	KNPC_PLAYER[playerId][ZSTimeInterval] = interval;
}
stock KNPC_getZSTimeInterval(playerId) {
	if(KNPC_PLAYER[playerId][ZSTimeInterval] <= 0) return 1000;
	else return KNPC_PLAYER[playerId][ZSTimeInterval];
}

stock bool:KNPC_IsPlayerSprinting(playerId) {
	return KNPC_PLAYER[playerId][Sprinting];
}
stock KNPC_setPlayerSprinting(playerId, bool:sprinting) {
	KNPC_PLAYER[playerId][Sprinting] = sprinting;
}

stock KNPC_setSeekerTick(npcId, tick) {
	KNPC_INFO[npcId][SeekerTick] = tick;
}
stock KNPC_getSeekerTick(npcId) {
	return KNPC_INFO[npcId][SeekerTick];
}

stock KNPC_setBiteTick(npcId, tick) {
	KNPC_INFO[npcId][BiteTick] = tick;
}
stock KNPC_getBiteTick(npcId) {
	return KNPC_INFO[npcId][BiteTick];
}

stock KNPC_setAutoRespawn(npcId, bool:toggle) {
	KNPC_INFO[npcId][AutoRespawn] = toggle;
}
stock bool:KNPC_hasAutoRespawn(npcId) {
	return bool:KNPC_INFO[npcId][AutoRespawn];
}

/**
* KNPC Util Functions
* 
**/

/**
* This function tells if a zombie can bite a player based on the ZAMinDistance config.
* @return True if can bite player, false otherwise.
*/
/*
stock bool:IsPlayerRunning(playerid)
{
    new keys, ud, lr;
    GetPlayerKeys(playerid, keys, ud, lr);

    if(keys & KEY_SPRINT || (ud == 0 && lr == 0))
        return false;

    return true;
}


stock bool:IsPlayerRunning(playerid)
{
    new ai = GetPlayerAnimationIndex(playerid);
    if(
		// ai == 1231 || // CJ Walking Style
		// ai == 1224 || // Noob Running/Walking Style
		ai == 1231 // CJ Running Style
	) return true;
    return false;
}

*/

/*
stock bool:IsPlayerRunning(playerid)
{
    if(!IsPlayerConnected(playerid) || IsPlayerInAnyVehicle(playerid)) return false;
    new keys, updown, leftright;
    GetPlayerKeys(playerid, keys, updown, leftright);
    if(keys & KEY_SPRINT && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_USEJETPACK) return true;
	new ai = GetPlayerAnimationIndex(playerid);
    if(ai)
    {
        new animlib[32], animname[32];
        GetAnimationName(ai,animlib,32,animname,32);
        if(!strcmp(animlib, "PED"))
        {
			new const names[8][] = { "run_fat", "run_fatold", "run_old", "swat_run", "woman_run", "WOMAN_runbusy", "woman_runpanic", "WOMAN_runsexy" };
			for(new i; i < sizeof(names); i++)
			{
			    if(!strcmp(animname, names[i])) return true;
			}
        }
    }
    return false;
}*/

stock Float:randomFloat(Float:min, Float:max = FLOAT_NAN, dp = 2)
{
    new
        Float:mul = floatpower(10.0, float(dp));
    switch (dp)
    {
    case 0: mul = 1.0;
    case 1: mul = 10.0;
    case 2: mul = 100.0;
    case 3: mul = 1000.0;
    default: mul = floatpower(10.0, float(dp));
    }
    if (max != max)
    {
        if (min < 0.0)
            return -(float(random(floatround(-min * mul))) / mul);
        return float(random(floatround(min * mul))) / mul;
    }
    // Parameters are the wrong way around - do it anyway.
    if (max < min)
        return float(random(floatround(min * mul - max * mul))) / mul + max;
    // NOT a silly check - "IsNaN".
    return float(random(floatround(max * mul - min * mul))) / mul + min;
}

stock IsPlayerRunning(playerid) {
	return KNPC_IsPlayerSprinting(playerid);
}


stock KNPC_stopAll(npcId) {
	FCNPC_Stop(npcId);
	FCNPC_StopAim(npcId);
	FCNPC_StopAttack(npcId);
}


stock KNPC_stopAttack(npcId) {
	FCNPC_StopAim(npcId);
	FCNPC_StopAttack(npcId);
}

stock KNPC_canBite(npcId, playerId)
{
	if(!KNPC_IsPlayerVulnerable(npcId, playerId)) return 0;
	if(GetTickDiff( GetTickCount(), KNPC_getBiteTick(npcId) ) >= KNPC_getBittingSpeed(npcId))
	{
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerId, x, y, z);
		if(IsPlayerInRangeOfPoint(npcId, KNPC_getZAMinDistance(), x, y, z)) {
			KNPC_setBiteTick(npcId, GetTickCount());
			return 1;
		}
	}
	return 0;
}


stock KNPC_getName(npcId) {
	new name[MAX_PLAYER_NAME];
	GetPlayerName(npcId, name, sizeof(name));
	return name;
}

stock KNPC_setWalkingStyle(npcId, style) {
	switch(style) {
		case WALKING_STYLE_TYPE_ZOMBIE: {
			new WS_RAND = random(sizeof(ZOMBIE_WALKING_STYLES));
			if(equal(ZOMBIE_WALKING_STYLES[WS_RAND], "SPANKINGW")) {
				strmid(KNPC_INFO[npcId][WalkingLib], "SNM", 0, 12);
			}
			else {
				strmid(KNPC_INFO[npcId][WalkingLib], "PED", 0, 12);
			}
			strmid(KNPC_INFO[npcId][WalkingAnim], ZOMBIE_WALKING_STYLES[WS_RAND], 0, 12);
			KS_DEBUG("[%s] %s():: WalkingLib: %s, WalkingAnim: %s", "knife_zombies.inc", "KNPC_setWalkingStyle", KNPC_INFO[npcId][WalkingLib], KNPC_INFO[npcId][WalkingAnim]);
			return 1;
		}
		default: {
			KS_DEBUG("[%s] %s():: invalid style: %d", "knife_zombies.inc", "KNPC_getRandomWalkingStyle", style);
		}
	}
	return 0;
}


stock KNPC_isInRangeOfPlayer(npcId, playerId, Float:range)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerId, x, y, z);
	if(IsPlayerInRangeOfPoint(npcId, range, x, y, z)) return 1;
	else return 0;
}

stock KNPC_getConnectedCount(type)
{
    new count=0;
    for(new npcId=0; npcId< GetMaxPlayers(); npcId++)
        if (FCNPC_IsValid(npcId) && KNPC_getType(npcId) == type)
        	count++;
    return count;
}


/**
* returns the KNPC type: zombie, human, drone...
* 
**/
stock KNPC_setType(npcId, type) {
	KNPC_INFO[npcId][TYPE] = type;
}
stock KNPC_getType(npcId) {
	return KNPC_INFO[npcId][TYPE];
}

stock Float:KNPC_getAttackDamage(npcId) {
	return Float:KNPC_INFO[npcId][AttackDamage];
}
stock KNPC_setAttackDamage(npcId, Float:damage) {
	KNPC_INFO[npcId][AttackDamage] = damage;
}

stock KNPC_setMovingSpeed(npcId, Float:speed) {
	KNPC_INFO[npcId][MovingSpeed] = speed;
}
stock Float:KNPC_getMovingSpeed(npcId) {
	return Float:KNPC_INFO[npcId][MovingSpeed];
}

stock KNPC_setBittingSpeed(npcId, ms_speed) {
	if(ms_speed <= 0) return; // 1s by default
	KNPC_INFO[npcId][BittingSpeed] = ms_speed;
}

stock KNPC_getBittingSpeed(npcId) {
	if(KNPC_INFO[npcId][BittingSpeed] <= 0) return 1000; // 1s by default
	return KNPC_INFO[npcId][BittingSpeed];
}


stock KNPC_setAttackRadius(npcId, Float:radius) {
	KNPC_INFO[npcId][AttackRadius] = radius;
}
stock Float:KNPC_getAttackRadius(npcId) {
	return KNPC_INFO[npcId][AttackRadius];
}

stock bool:KNPC_setCapability(npcId, capabilityId, bool:status) {
	if(capabilityId > MAX_CAPABILITIES) return false;
	KNPC_INFO[npcId][Capability][capabilityId] = status;
	return true;
}
stock bool:KNPC_hasCapability(npcId, capabilityId) {
	if(capabilityId > MAX_CAPABILITIES) return false;
	return KNPC_INFO[npcId][Capability][capabilityId];
}

stock KNPC_setSpawnPos(npcId, Float:x, Float:y, Float:z, Float:a, skinId = -1) {
	if(skinId == -1) {
		skinId = FCNPC_GetSkin(npcId);
	}
	KNPC_INFO[npcId][SpawnPos][0] = x;
	KNPC_INFO[npcId][SpawnPos][1] = y;
	KNPC_INFO[npcId][SpawnPos][2] = z;
	KNPC_INFO[npcId][SpawnPos][3] = a;
	FCNPC_Spawn(npcId, skinId, x, y, z); // spawn again to update XYZ coords.
	FCNPC_SetSkin(npcId, skinId);
}

stock KNPC_getSpawnPos(npcId, &Float:x, &Float:y, &Float:z, &Float:a) {
	x = KNPC_INFO[npcId][SpawnPos][0];
	y = KNPC_INFO[npcId][SpawnPos][1];
	z = KNPC_INFO[npcId][SpawnPos][2];
	a = KNPC_INFO[npcId][SpawnPos][3];
}



/*
* Makes the NPC aim and walk to X Y Z coordinates.
*/
stock KNPC_WalkToPlayerId(npcId, playerId, type = FCNPC_MOVE_TYPE_RUN, Float:speed = FCNPC_MOVE_SPEED_RUN)
{
	return FCNPC_GoToPlayer(npcId, playerId, type, speed);
}

stock KNPC_GoToPlayer(npcId, playerId, MOVE_TYPE = FCNPC_MOVE_TYPE_RUN, Float:MOVE_SPEED = FCNPC_MOVE_SPEED_RUN, Float:radius = 0.0, Float:min_distance = 0.0, stopdelay = 1)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerId, x, y, z);
	return FCNPC_GoTo(npcId, random(3)-random(5)+x, random(5)-random(3)+y, z, MOVE_TYPE, MOVE_SPEED, FCNPC_MOVE_MODE_MAPANDREAS, FCNPC_MOVE_PATHFINDING_Z, radius, true, min_distance, stopdelay);
}

stock bool:KNPC_weaponRequiresKeys(weaponId) {
	if(weaponId == 35 || weaponId == 25 || weaponId == 36 || weaponId == 24) return true;
	else return false;
}

// Fixes some weapons like Rocket Launcher.
stock KNPC_shootAtPlayer(npcId, playerId, weaponId)
{
	if(FCNPC_IsReloading(npcId)) return 0;
	if(!KNPC_weaponRequiresKeys(weaponId)) return FCNPC_AimAtPlayer(npcId, playerId, true );
	new Float:x, Float:y, Float:z, Float:offsetZ = 0.0;
	GetPlayerPos(playerId, x, y, z);
	//FCNPC_AimAt(npcId, x, y, z- random(3));
	if(weaponId == 35 || weaponId == 36) {
		offsetZ = -randomFloat(1.4, 1.8);
	}
	FCNPC_AimAtPlayer(npcId, playerId,  false, -1, true, 0.0, 0.0, offsetZ);
	return FCNPC_SetKeys(npcId, 0, 0, 132); // shoot!
}


/*
* Makes the NPC walk to X Y Z coordinates.
*/
stock KNPC_Walk(npcId, Float:X, Float:Y, Float:Z, type, Float:speed) {
	return FCNPC_GoTo(npcId, X, Y, Z, type, speed);
}

stock KNPC_GoBackToSpawnPos(npcId) {
	new Float:x,Float:y,Float:z,Float:a;
	KNPC_getSpawnPos(npcId, x,y,z,a);
	return FCNPC_GoTo(npcId, x, y, z, FCNPC_MOVE_TYPE_SPRINT, FCNPC_MOVE_SPEED_SPRINT);
}

stock KNPC_GetPosition(npcId, Float:X, Float:Y, Float:Z) {
	KNPC_GetPosition(npcId, X, Y, Z);
}

stock KNPC_IsValid(npcId, type) {
	return (FCNPC_IsValid(npcId) && KNPC_getType(npcId) == type)
}

stock KNPC_getNearestEnemy(npcId, Float:distance = 99999.99)
{
    new Float:xX,Float:yY,Float:zZ, retElement = INVALID_PLAYER_ID;
    for(new i = 0; i < GetMaxPlayers(); i++)
    {
		if((i == npcId) || (i == INVALID_PLAYER_ID) || !IsPlayerConnected(i) || !KNPC_IsPlayerVulnerable(npcId, i)) continue;
        GetPlayerPos(i, xX, yY, zZ); // get player pos
        new Float:odist = GetPlayerDistanceFromPoint(npcId, xX, yY, zZ);
		if (retElement == INVALID_PLAYER_ID)
        {
            retElement = i;
            distance = odist;
        }
		else if (odist < distance)
        {
            retElement = i;
            distance = odist;
        }
    }
    return retElement;
}

stock KNPC_getNearestPlayerId(npcId, Float:distance = 99999.99)
{
    new Float:xX,Float:yY,Float:zZ, retElement = KNPC_getNearestEnemy(npcId, KNPC_getThreatRadius(npcId)); // priorize enemies
	if(retElement != INVALID_PLAYER_ID) return retElement;
    for(new i = 0; i < GetMaxPlayers(); i++)
    {
		if((i == npcId) || (i == INVALID_PLAYER_ID) || !IsPlayerConnected(i) || !KNPC_IsPlayerVulnerable(npcId, i, true)) continue;
        GetPlayerPos(i, xX, yY, zZ); // get player pos
        new Float:odist = GetPlayerDistanceFromPoint(npcId, xX, yY, zZ);
		if (retElement == INVALID_PLAYER_ID)
        {
            retElement = i;
            distance = odist;
        }
		else if (odist < distance)
        {
            retElement = i;
            distance = odist;
        }
    }
    return retElement;
}

stock IsPlayerDead(playerid) {
	return (GetPlayerState(playerid) == PLAYER_STATE_WASTED);
}

stock KNPC_IsPlayerVulnerable(npcId, playerId, bool:ignoreTeam=false) {
	if(
		GetPlayerVirtualWorld(npcId) == GetPlayerVirtualWorld(playerId) && // SAME VIRTUAL WORLD
		!IsPlayerDead(playerId) && // NOT DEAD & NOT PAUSED
		(GetPlayerTeam(npcId) != GetPlayerTeam(playerId) || ignoreTeam) && // NOT SAME TEAM, OR IGNORE.
		GetPlayerState(playerId) != PLAYER_STATE_SPECTATING && // IS NOT SPECTATING
		(
			(KNPC_getType(playerId) == KNPC_TYPE_ZOMBIE && KNPC_hasCapability(npcId, CAPABILITY_ATTACK_ZOMBIES)) || // IS A ZOMBIE, BUT CAN KILL HIM
			(KNPC_getType(playerId) == KNPC_TYPE_HUMAN && KNPC_hasCapability(npcId, CAPABILITY_ATTACK_HUMANS)) || // IS A HUMAN, BUT CAN KILL HIM
			(
				!IsPlayerNPC(playerId) && !FCNPC_IsValid(playerId) && // IS NOT A NPC 
				!IsPlayerPaused(playerId) // IS NOT PAUSED
			)
		) // but if capabilities... then is vulnerable.
	) return 1;
	else return 0;
}

stock bool:KNPC_IsPlayerSeekable(npcId, playerId) {
	if(
		KNPC_IsPlayerVulnerable(npcId, playerId) &&
		KNPC_isInRangeOfPlayer(npcId, playerId, KNPC_getSeekMaxDistance()) // IS UNDER A VALID SEEKING DISTANCE
	) return true;
	else return false;
}

// returns true if the npc has a player in its threatening radius.
stock bool:KNPC_hasThreateningPlayer(npcId, playerId) {
	if(
		KNPC_IsPlayerVulnerable(npcId, playerId, true) &&
		KNPC_isInRangeOfPlayer(npcId, playerId, KNPC_getThreatRadius(npcId))
	) return true;
	else return false;
}

// returns true if the npc has a player in its attack radius.
stock bool:KNPC_hasAttackPlayer(npcId, playerId) {
	if(
		KNPC_IsPlayerVulnerable(npcId, playerId) && // ARE NOT IN THE SAME TEAM
		KNPC_isInRangeOfPlayer(npcId, playerId, KNPC_getAttackRadius(npcId))
	) return true;
	else return false;
}

stock bool:KNPC_isOnItsSpawnPos(npcId) {
	new Float:_x,Float:_y,Float:_z,Float:_a;
	KNPC_getSpawnPos(npcId, _x,_y,_z,_a);
	if(IsPlayerInRangeOfPoint(npcId, 2, _x, _y, _z)) return true;
	else return false;
}

hook OnGameModeInit()
{
	FCNPC_UseMoveMode(FCNPC_MOVE_MODE_MAPANDREAS);
	//FCNPC_UseMoveMode(FCNPC_MOVE_MODE_COLANDREAS);
	/* Initialize Default Config */
	KNPC_setSeekMaxDistance(120);
	KNPC_setZSMaxDistance(70);
	KNPC_setZAMinDistance(6);
	KNPC_setHeadShotsAllowed(true); // Allow Headshots by default!

	return Y_HOOKS_CONTINUE_RETURN_1;
}

hook FCNPC_OnCreate(npcId)
{
	//setWalkingStyle
	FCNPC_SetMoveMode(npcId, FCNPC_MOVE_MODE_MAPANDREAS);
	new type = KNPC_getType(npcId);
	KNPC_OnConnect(npcId, type);
	KS_DEBUG("[%s] %s():: Connected: %s; id: %d; type=%d", "knife_zombies.inc", "KNPC_OnConnect", KNPC_getName(npcId), npcId, KNPC_getType(npcId), type );
	return Y_HOOKS_CONTINUE_RETURN_1;
}

stock KNPC_Respawn(npcId) {
    FCNPC_Respawn(npcId);
}

public KNPC_DoAutoRespawn(npcId) {
	FCNPC_Respawn(npcId);
	return 1;
}

stock KNPC_SendDeathMessage(killerid, playerid, reason) {
	// Modify Kill reason when the killer is a Zombie, to keep the kills table fancy :P.
    if(FCNPC_IsValid(killerid) && KNPC_getType(killerid) == KNPC_TYPE_ZOMBIE){
		reason = 53;
	}
	//KS_DEBUG("{e8fc03}[%s] %s():: %s; id: %d killedBy %s id: %d with %d", "knife_zombies.inc", "SendDeathMessage", KNPC_getName(playerid), playerid, KNPC_getName(killerid), killerid, reason);
	SendDeathMessage(killerid, playerid, reason);
	return 0;
}
#if defined _ALS_SendDeathMessage
	#undef SendDeathMessage
#else
	#define _ALS_SendDeathMessage
#endif
#define SendDeathMessage KNPC_SendDeathMessage 

hook FCNPC_OnDeath(npcId, killerId, weaponId)
{
	/*
		Handle Unknown KNPC Death, probably caused by headshot!
	*/

	if(KNPC_hasAutoRespawn(npcId)) {
		//KS_DEBUG("[%s] %s():: Respawn: %s; id: %d in %d ms", "knife_zombies.inc", "KNPC_hasAutoRespawn", KNPC_getName(npcId), npcId, KNPC_getAutoRespawnTime());
		SetTimerEx("KNPC_DoAutoRespawn", KNPC_getAutoRespawnTime(), 0, "d", npcId);
	}

	//KS_DEBUG("[%s] %s():: Death: %s; id: %d killed By PlayerId %d with weapon: %d", "knife_zombies.inc", "KNPC_OnDeath", KNPC_getName(npcId), npcId, killerId, weaponId);
	KNPC_OnDeath(npcId, killerId, weaponId, KNPC_getType(npcId));
    return Y_HOOKS_CONTINUE_RETURN_1;
}


hook FCNPC_OnSpawn(npcId)
{
	new type = KNPC_getType(npcId);
	KNPC_OnSpawn(npcId, type);
	KS_DEBUG("[%s] %s():: Spawned: %s; id: %d", "knife_zombies.inc", "KNPC_OnZombieSpawn", KNPC_getName(npcId), npcId);
	return Y_HOOKS_CONTINUE_RETURN_1;
}

hook FCNPC_OnRespawn(npcId)
{
	new type = KNPC_getType(npcId);
	KNPC_OnRespawn(npcId, type);
	KS_DEBUG("[%s] %s():: Respawned: %s; id: %d", "knife_zombies.inc", "KNPC_OnRespawn", KNPC_getName(npcId), npcId);
	return Y_HOOKS_CONTINUE_RETURN_1;
}

public FCNPC_OnTakeDamage(npcid, issuerid, Float:amount, weaponid, bodypart) {
	//KS_DEBUG("[%s] %s():: %s; id: %d damaged by %s (%d). Made %.02f damage with %d in %d", "knife_zombies.inc", "FCNPC_OnTakeDamage", KNPC_getName(npcid), npcid, KNPC_getName(issuerid), issuerid, amount, weaponid, bodypart);
	if(KNPC_isHeadShotsAllowed() && bodypart == 9 && IsHeadShooterWeapon(weaponid)) {
		//KS_DEBUG("{BFF542}[debug]: %s (%d) headshot %s (%d) with weaponId: %d ", getPlayerName(issuerid), issuerid, getPlayerName(npcid), npcid, weaponid);
 		// FCNPC_TriggerWeaponShot(playerId, weaponId, BULLET_HIT_TYPE_PLAYER, damagedId, x,y,z, true, 0.0,0.0,0.0, FCNPC_ENTITY_CHECK_NONE);
		FCNPC_SetHealth(npcid, 0.0);
		//FCNPC_Kill(damagedId);
		return 0; // end!
	}
	return 1;
}

hook OnPlayerGiveDamage(playerId, damagedId, Float:amount, weaponId, bodypart) {
	// Do not hook if the damagedId isn't a NPC.
	if(!FCNPC_IsValid(damagedId)) return Y_HOOKS_CONTINUE_RETURN_1;

	// KS_DEBUG("{fcba03}[%s] %s():: %s; id: %d damaged by %s (%d). NEW Death reason: %d", "knife_zombies.inc", "OnPlayerGiveDamage", KNPC_getName(KNPC_getKillerId(damagedId)), KNPC_getKillerId(damagedId), KNPC_getName(playerId), playerId, KNPC_getDeathReason(damagedId));

	// gets the NPC type to call its callback.
	new type = KNPC_getType(damagedId);
	KNPC_OnPlayerGiveDamage(playerId, damagedId, type, amount, weaponId, bodypart);	
	//KS_DEBUG("[%s] %s():: %s; id: %d damaged by %s (%d). Made %.02f damage with %d in %d", "knife_zombies.inc", "KNPC_OnPlayerGiveDamage", KNPC_getName(damagedId), damagedId, KNPC_getName(playerId), playerId, amount, weaponId, bodypart);
	return Y_HOOKS_CONTINUE_RETURN_1;
}

hook FCNPC_OnUpdate(npcId) {
	if(GetTickDiff( GetTickCount(), KNPC_getSeekerTick(npcId) ) >= 180){
		KNPC_setSeekerTick(npcId, GetTickCount());
		new nearestPlayerId = KNPC_getNearestPlayerId(npcId);
		if(nearestPlayerId == INVALID_PLAYER_ID) {
			KNPC_stopAll(npcId);
			return Y_HOOKS_CONTINUE_RETURN_1; // no update needed.
		}
		KNPC_OnUpdate(npcId, nearestPlayerId, KNPC_getType(npcId));
	}
	return Y_HOOKS_CONTINUE_RETURN_1;
}


hook OnPlayerUpdate(playerid) {
	// is this efficient??...
    new keys, updown, leftright;
    GetPlayerKeys(playerid, keys, updown, leftright);
	new since = GetTickDiff(GetTickCount(), KNPC_PLAYER[playerid][SprintingTick]);
    if(keys & KEY_SPRINT)
    {
        if(since < 700)
			KNPC_setPlayerSprinting(playerid, true);
        KNPC_PLAYER[playerid][SprintingTick] = GetTickCount();
    }
	else if(since > 500) {
		KNPC_setPlayerSprinting(playerid, false);
	}
	return Y_HOOKS_CONTINUE_RETURN_1;
}