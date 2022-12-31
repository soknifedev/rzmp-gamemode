#include <a_samp>
#include <core>
#include <float>
#include <crashdetect>
#include <streamer>

/**
* Zombie & NPC System Stuff
*/
#include <knife_zombies>

/**
* Command Processor Stuff
*/
#include <Pawn.CMD>
#include <sscanf2>

/*
#include <huwi>
#include <umbrella>
#include <CA3>
*/

stock getPlayerName(playerid) {
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

main()
{
	print("\n----------------------------------");
	print("  Bare Script xd\n");
	print("----------------------------------\n");
}

stock IsHeadShooterWeapon(weaponId)
{
    if( weaponId == 34 || 
		weaponId == 33 || 
		weaponId == 24 || 
		weaponId == 25 ||
		weaponId == 23 ||
		weaponId == 31 ||
		weaponId == 30 ||
		weaponId == 29 ||
		weaponId == 27 ) return 1;
    else return 0;
}


public KNPC_OnPlayerGiveDamage(playerId, npcId, damagedIdType, Float:amount, weaponId, bodypart) { 

	return 1;
}


stock GetPlayerSpeed(playerid, bool:kmh) // by misco
{
  new Float:Vx,Float:Vy,Float:Vz,Float:rtn;
  if(IsPlayerInAnyVehicle(playerid)) GetVehicleVelocity(GetPlayerVehicleID(playerid),Vx,Vy,Vz); else GetPlayerVelocity(playerid,Vx,Vy,Vz);
  rtn = floatsqroot(floatabs(floatpower(Vx + Vy + Vz,2)));
  return kmh?floatround(rtn * 100 * 1.61):floatround(rtn * 100);
}

public KNPC_OnUpdate(npcId, nearestPlayerId, type) {

    if(type == KNPC_TYPE_ZOMBIE) {
        if(KNPC_IsPlayerSeekable(npcId, nearestPlayerId)) {
            //FCNPC_GoTo(npcId, x,y,z, FCNPC_MOVE_TYPE_RUN, FCNPC_MOVE_SPEED_RUN, FCNPC_MOVE_MODE_COLANDREAS, FCNPC_MOVE_PATHFINDING_Z, 5, true);
            // Walk to the player until can bite him!

            if(!FCNPC_IsMovingAtPlayer(npcId, nearestPlayerId)) // only call this once, if needed.
                KNPC_WalkToPlayerId(npcId, nearestPlayerId, FCNPC_MOVE_TYPE_RUN, FCNPC_MOVE_SPEED_RUN);

            if(KNPC_canBite(npcId, nearestPlayerId)) {
                KNPC_BitePlayer(npcId, nearestPlayerId);
            }

            return 1;
        } else {
            KNPC_stopAll(npcId); // stop all attacks
            if(!KNPC_isOnItsSpawnPos(npcId)){
                //KS_DEBUG("%s (%d) is going back to its original position. Threat? %d", getPlayerName(npcId), npcId, KNPC_hasThreateningPlayer(npcId, nearestPlayerId));
                KNPC_GoBackToSpawnPos(npcId);
            }
        }
    }


	if(type == KNPC_TYPE_HUMAN) {
        // KS_DEBUG("%s (%d) nearest Player: %s (%d); hasThreateningPlayer?", getPlayerName(npcId), npcId, getPlayerName(nearestPlayerId), nearestPlayerId, KNPC_hasThreateningPlayer(npcId, nearestPlayerId) ? "YES" : "NO");
        new keys, updown, leftright;
        GetPlayerKeys(nearestPlayerId, keys, updown, leftright);

        //KS_DEBUG("%s (%d) taking keys from: %s (%d); ud=%d, ld=%d, keys=%d", getPlayerName(npcId), npcId, getPlayerName(nearestPlayerId), nearestPlayerId, updown, leftright, keys);

        new bool:shouldAttack = false;
        //attack nearest enemy if should...
        if(KNPC_hasAttackPlayer(npcId, nearestPlayerId)) {
            shouldAttack = true;
            KNPC_stopAll(npcId);
            KNPC_shootAtPlayer(npcId, nearestPlayerId, FCNPC_GetWeapon(npcId));
            if(FCNPC_GetWeapon(npcId) >= 0 && FCNPC_GetWeapon(npcId) <= 8 || FCNPC_GetWeapon(npcId) >= 10 && FCNPC_GetWeapon(npcId) <= 15){
                FCNPC_MeleeAttack(npcId); // keep moving.
            }
            else return 0; // stop moving, until target is killed!
        } else{
            KNPC_stopAttack(npcId);
            if(GetPlayerTeam(npcId) != GetPlayerTeam(nearestPlayerId))
                FCNPC_AimAtPlayer(npcId, nearestPlayerId, false );
        }
        //has threater, maybe aly or enemy.
        if(KNPC_hasThreateningPlayer(npcId, nearestPlayerId)) {
            //KS_DEBUG("%s (%d) Threater: %s (%d); IsPlayerSprinting ? %s", getPlayerName(npcId), npcId, getPlayerName(nearestPlayerId), nearestPlayerId, KNPC_IsPlayerSprinting(nearestPlayerId) ? "YES" : "NO");

            // is running and is outside the attack range
            if(IsPlayerRunning(nearestPlayerId) && !shouldAttack){
                /*
                if(FCNPC_GetSpeed(npcId) != FCNPC_MOVE_SPEED_RUN) {
                    KNPC_stopAll(npcId); // stop to make new moves!
                    //KS_DEBUG("%s (%d) wasnt running to: %s (%d)... stopped to do run!", getPlayerName(npcId), npcId, getPlayerName(nearestPlayerId), nearestPlayerId);
                    KNPC_GoToPlayer(npcId, nearestPlayerId, FCNPC_MOVE_TYPE_RUN, FCNPC_MOVE_SPEED_RUN);
                }*/
                KNPC_GoToPlayer(npcId, nearestPlayerId, FCNPC_MOVE_TYPE_RUN, FCNPC_MOVE_SPEED_RUN);
                //KS_DEBUG("%s (%d) has Player Running: %s (%d)!", getPlayerName(npcId), npcId, getPlayerName(nearestPlayerId), nearestPlayerId);
            }
            else { // is not running
                //KS_DEBUG("%s (%d) has Player Walking: %s (%d)!", getPlayerName(npcId), npcId, getPlayerName(nearestPlayerId), nearestPlayerId);
                // FCNPC_MOVE_MODE_AUTO, pathfinding = FCNPC_MOVE_PATHFINDING_AUTO, Float:radius = 0.0, bool:set_angle = true, Float:min_distance = 0.0, Float:dist_check = 1.5, stopdelay = 250
                if(FCNPC_GetSpeed(npcId) != FCNPC_MOVE_SPEED_WALK) {
                    FCNPC_Stop(npcId); // stop to do new anim.
                }
                //KS_DEBUG("%s (%d) wasnt walking to: %s (%d)... stopped to do walk!", getPlayerName(npcId), npcId, getPlayerName(nearestPlayerId), nearestPlayerId);
                KNPC_GoToPlayer(npcId, nearestPlayerId, FCNPC_MOVE_TYPE_WALK, FCNPC_MOVE_SPEED_WALK);
            }
        }
        else {
            KNPC_stopAll(npcId); // stop all attacks
            if(!KNPC_isOnItsSpawnPos(npcId)){
                //KS_DEBUG("%s (%d) is going back to its original position. Threat? %d", getPlayerName(npcId), npcId, KNPC_hasThreateningPlayer(npcId, nearestPlayerId));
                KNPC_GoBackToSpawnPos(npcId);
            }
        }
	}
	return 1;
}

public KNPC_OnConnect(npcId, type) { 

	return 1;
}

public KNPC_OnDeath(npcId, killerId, weaponId) {

	return 1;
}


public KNPC_OnSpawn(npcId, type) {
	return 1;
}


public KNPC_OnRespawn(npcId, type) {
	return 1;
}


stock Countdown()
{
    SendClientMessageToAll(-1, "3");
    wait_ms(1000); // Non-blocking sleep (i.e. there is no code running and checking the time).
    SendClientMessageToAll(-1, "2");
    wait_ms(1000); // await task_ms(1000); can be also used
    SendClientMessageToAll(-1, "1");
    wait_ms(1000);
    SendClientMessageToAll(-1, "0");
}

public OnPlayerConnect(playerid)
{
	GameTextForPlayer(playerid,"~w~SA-MP: ~r~Bare Script",5000,5);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerInterior(playerid,0);
	TogglePlayerClock(playerid,0);
    GivePlayerWeapon(playerid, 24,9999999);
    GivePlayerWeapon(playerid, 31,9999999);
    GivePlayerWeapon(playerid, 27,9999999);
    GivePlayerWeapon(playerid, 34,9999999);
    GivePlayerWeapon(playerid, 29,9999999);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	GameTextForPlayer(playerid,"~r~WASTED",2000,5);
	SendDeathMessage(killerid, playerid, reason);
   	return 1;
}

SetupPlayerForClassSelection(playerid)
{
	SetPlayerPos(playerid, 2037.3472,1342.9836,10.8203);
	SetPlayerFacingAngle(playerid, 57.2459);
	SetPlayerCameraPos(playerid, 2023.615966, 1349.272583, 11.716372);
	SetPlayerCameraLookAt(playerid, 2028.283569, 1347.485229, 11.578890);
}

public OnPlayerRequestClass(playerid, classid)
{
	SetupPlayerForClassSelection(playerid);
	return 1;
}

public OnGameModeInit()
{
	SetGameModeText("Bare Script");
	ShowPlayerMarkers(1);
	ShowNameTags(1);
	AllowAdminTeleport(1);

	AddPlayerClass(265,2030.0754,1317.8086,10.8203,273.0718,0,0,0,0,0,0); // pedPosSpawn
	//CreateArt3(huwi, 5, 2046.1395,1318.0891,13.6719, 90, 90, 0);
	//CreateArt3(umbrella, 5, 2047.4459,1427.8132,13.6719, 90, 90, 0);

	return 1;
}

/*
* Server Commands
*/
public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
    return 1;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    if(result == -1)
    {
        SendFormatMessage(playerid, 0xFFFFFFFF, "SERVER: Unknown command. '%s' is not a valid command.", cmd);
        return 0;
    }
    return 1;
}

cmd:velocity(playerid) {
    new Float:Velocity[3], string[80];
    GetPlayerVelocity(playerid, Velocity[0], Velocity[1], Velocity[2]);
    format(string, sizeof(string), "You are going at a velocity of X: %f, Y: %f, Z: %f", Velocity[0], Velocity[1], Velocity[2]);
    SendClientMessage(playerid, 0xFFFFFFFF, string);

}

cmd:createZombie(playerid) // 
{
	new Float:x, Float:y, Float:z, Float:a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
	KNPC_createZombie(random(6) - random(6) + x, random(6) - random(6) + y, z, a);
    return 1;
} 

cmd:getZombie(playerid, params[]) // 
{
    new npcId;
    if(sscanf(params, "i", npcId)) return SendClientMessage(playerid, -1, "Use /getZombie [npcId]");
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	FCNPC_SetPosition(npcId, random(6) - random(6) + x, random(6) - random(6) + y, z);
    return 1;
}

cmd:createHuman(playerid) // 
{
	new Float:x, Float:y, Float:z, Float:a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
	KNPC_createHuman(random(6) - random(6) + x, random(6) - random(6) + y, z, a);
    return 1;
} 

cmd:getHuman(playerid, params[]) // 
{
    new npcId;
    if(sscanf(params, "i", npcId)) return SendClientMessage(playerid, -1, "Use /getHuman [npcId]");
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	FCNPC_SetPosition(npcId, random(6) - random(6) + x, random(6) - random(6) + y, z);
    return 1;
}

cmd:giveweapon(playerid, params[]) // 
{
    new dstId, weaponId, ammo;
    if(sscanf(params, "iii", dstId, weaponId, ammo)) return SendClientMessage(playerid, -1, "Use /giveweapon [playerId/npcId] [weaponId] [ammo]");
    if(FCNPC_IsValid(dstId)) {
        FCNPC_SetWeapon(dstId, weaponId);
        FCNPC_SetAmmo(dstId, ammo);
        FCNPC_UseInfiniteAmmo(dstId, true);
        FCNPC_UseReloading(dstId, true);
        FCNPC_SetWeaponSkillLevel(dstId, WEAPONSKILL_M4, 999);
        FCNPC_SetWeaponSkillLevel(dstId, WEAPONSKILL_PISTOL, 999);
        FCNPC_SetWeaponSkillLevel(dstId, WEAPONSKILL_PISTOL_SILENCED, 999);
        FCNPC_SetWeaponSkillLevel(dstId, WEAPONSKILL_SPAS12_SHOTGUN, 999);
        FCNPC_SetWeaponSkillLevel(dstId, WEAPONSKILL_SPAS12_SHOTGUN, 999);
        FCNPC_SetWeaponSkillLevel(dstId, WEAPONSKILL_MP5, 999);
        FCNPC_SetWeaponSkillLevel(dstId, WEAPONSKILL_MICRO_UZI, 999);
        FCNPC_SetWeaponSkillLevel(dstId, WEAPONSKILL_DESERT_EAGLE, 999);
        // FCNPC_SetAmmoInClip(npcid, ammo);
        // FCNPC_SetWeaponInfo(dstId, weaponId, reload_time = -1, shoot_time = -1, clip_size = -1, Float:accuracy = 1.0);
        /*
			    	FCNPC_ToggleInfiniteAmmo(playerid, true);
			    	FCNPC_SetWeaponClipSize(playerid, 35, 40);
			    	FCNPC_SetWeapon(playerid, 35);
			    	FCNPC_SetWeaponShootTime(playerid, 35, 0);
			    	FCNPC_SetWeaponReloadTime(playerid, 35, 1000 * 10);
			    	FCNPC_ToggleReloading(playerid, true);
        */


    }
    else {
        GivePlayerWeapon(dstId, weaponId, ammo);
    }
    new weaponName[32];
    GetWeaponName(weaponId, weaponName, sizeof(weaponName));
    SendFormatMessageToAll(-1, "%d (id: %d) received weapon %s (id: %d) with %d ammo by %s (id: %d).", getPlayerName(dstId), dstId, weaponName, weaponId, ammo, getPlayerName(playerid), playerid );
    return 1;
} 

/*
cmd:setReloadTime(playerid, params[]) // 
{
    new npcId, weaponid, time;
    if(sscanf(params, "iii", npcId, weaponid, time)) return SendClientMessage(playerid, -1, "Use /setReloadTime [npcId] [weaponid] [time in ms]");
    FCNPC_SetWeaponReloadTime(npcId, weaponid, time);
    SendFormatMessage(playerid, -1, "New reload time value: %d (original %d)", FCNPC_GetWeaponActualReloadTime(npcId, weaponid), FCNPC_GetWeaponReloadTime(npcId, weaponid));
    return 1;
}
*/
cmd:respawnNPC(playerid, params[]) // 
{
    new npcId;
    if(sscanf(params, "i", npcId)) return SendClientMessage(playerid, -1, "Use /respawnNPC [npcId]");
	FCNPC_Respawn(npcId);
    return 1;
}


cmd:setSeekMaxDistance(playerid, params[]) // 
{
    new Float:dst;
    if(sscanf(params, "g", dst)) return SendClientMessage(playerid, -1, "Use /setSeekMaxDistance [Float:distance]");
	KNPC_setSeekMaxDistance(dst);
    SendFormatMessage(playerid, -1, "KNPC Config. New value: %f", dst);
    return 1;
}


cmd:setZSMaxDistance(playerid, params[]) // 
{
    new Float:dst;
    if(sscanf(params, "g", dst)) return SendClientMessage(playerid, -1, "Use /setZSMaxDistance [Float:distance]");
	KNPC_setZSMaxDistance(dst);
    SendFormatMessage(playerid, -1, "KNPC Config. New value: %f", dst);
    return 1;
}


cmd:setZAMinDistance(playerid, params[]) // 
{
    new Float:dst;
    if(sscanf(params, "g", dst)) return SendClientMessage(playerid, -1, "Use /setZAMinDistance [Float:distance]");
	KNPC_setZAMinDistance(dst);
    SendFormatMessage(playerid, -1, "KNPC Config. New value: %f", dst);
    return 1;
}


cmd:KNPC_setZSTimeInterval(playerid, params[]) // 
{
    new dstPlayerId, interval;
    if(sscanf(params, "ii", dstPlayerId, interval)) return SendClientMessage(playerid, -1, "Use /setZSTimeInterval [playerid] [interval in seconds]");
	KNPC_setZSTimeInterval(dstPlayerId, interval * 1000);
    SendFormatMessage(playerid, -1, "%s id: %d. New value: %d", getPlayerName(dstPlayerId), dstPlayerId, interval);
    return 1;
}



cmd:setBittingSpeed(playerid, params[]) // 
{
    new npcId, interval;
    if(sscanf(params, "ii", npcId, interval)) return SendClientMessage(playerid, -1, "Use /setBittingSpeed [npcId] [interval in ms]");
	KNPC_setBittingSpeed(npcId, interval);
    SendFormatMessage(playerid, -1, "%s id: %d. New value: %d", getPlayerName(npcId), npcId, interval);
    return 1;
}

cmd:setAutoRespawnTime(playerid, params[]) // 
{
    new interval;
    if(sscanf(params, "i", interval)) return SendClientMessage(playerid, -1, "Use /setAutoRespawnTime [interval in ms]");
	KNPC_setAutoRespawnTime(interval);
    SendFormatMessage(playerid, -1, "KNPC Config. New value: %f", interval);
    return 1;
}


cmd:debug(me, params[]) // 
{
	new npcId, playerid;
    if(sscanf(params, "ii", playerid, npcId)) return SendClientMessage(me, -1, "Use /debug [playerid] [npcId]");
    SendClientMessage(me, 0x00aee3ff, "<-- KNPC Config Data -->");
    SendFormatMessage(me, -1, "SeekMaxDistance: %f", KNPC_getSeekMaxDistance());
    SendFormatMessage(me, -1, "ZSMaxDistance: %f", KNPC_getZSMaxDistance());
    SendFormatMessage(me, -1, "ZAMinDistance: %f", KNPC_getZAMinDistance());
    SendFormatMessage(me, -1, "AutoRespawnTime: %d", KNPC_getAutoRespawnTime());
    SendFormatMessage(me, 0xFF0077FF, "<-- Player Data: %s (Id: %d) -->", getPlayerName(playerid), playerid);
    SendFormatMessage(me, -1, "ZSTimeInterval: %d", KNPC_getZSTimeInterval(playerid));
    //SendFormatMessage(me, -1, "PlayerLastAttackerId: %d", KNPC_getPlayerLastAttackerId(playerid));
    SendFormatMessage(me, 0x00F040FF, "<-- KNPC Data: %s (Id: %d) -->", KNPC_getName(npcId), npcId);
    SendFormatMessage(me, -1, "Type: %d", KNPC_getType(npcId));
    SendFormatMessage(me, -1, "ByteDamage: %f", KNPC_getAttackDamage(npcId));
    SendFormatMessage(me, -1, "MovingSpeed: %f", KNPC_getMovingSpeed(npcId));
    SendFormatMessage(me, -1, "BittingSpeed: %d ms", KNPC_getBittingSpeed(npcId));
    SendFormatMessage(me, -1, "SeekerTick: %d", KNPC_getSeekerTick(npcId));
    SendFormatMessage(me, -1, "BiteTick: %d", KNPC_getBiteTick(npcId));
    return 1;
}


cmd:setAttackRadius(playerid, params[]) // 
{
    new npcId, Float:dst;
    if(sscanf(params, "ig", npcId, dst)) return SendClientMessage(playerid, -1, "Use /AttackRadius [npcId] [Float:radius]");
	KNPC_setAttackRadius(npcId, dst);
    SendFormatMessage(playerid, -1, "%s id: %d. New value: %f", getPlayerName(npcId), npcId, dst);
    return 1;
}

cmd:setThreatRadius(playerid, params[]) // 
{
    new npcId, Float:dst;
    if(sscanf(params, "ig", npcId, dst)) return SendClientMessage(playerid, -1, "Use /ThreatRadius [npcId] [Float:radius]");
	KNPC_setThreatRadius(npcId, dst);
    SendFormatMessage(playerid, -1, "%s id: %d. New value: %f", getPlayerName(npcId), npcId, KNPC_getThreatRadius(npcId));
    return 1;
}

cmd:setteam(playerid, params[]) // 
{
    new dstid, team;
    if(sscanf(params, "ii", dstid, team)) return SendClientMessage(playerid, -1, "Use /setteam [playerid/npcId] [teamId]");
	if(team < 1 || team > 255) return SendClientMessage(playerid, 0x00ff3cff, "Invalid team Id"); 
	SetPlayerTeam(dstid, team);
    SendFormatMessage(playerid, -1, "%s id: %d. new team: %d", getPlayerName(dstid), dstid, team);
    return 1;
}


cmd:setCapability(playerid, params[]) // 
{
    new npcId, capId, bool:capStatus;
    if(sscanf(params, "iib", npcId, capId, capStatus)) return SendClientMessage(playerid, -1, "Use /setCapability [npcId] [capabilityId] [status]");
	if(!KNPC_setCapability(npcId, capId, capStatus)) return SendClientMessage(playerid, 0x00ff3cff, "Invalid capability Id"); 
    SendFormatMessage(playerid, -1, "%s id: %d. new capability: %d = %s%d", getPlayerName(npcId), npcId, capId, capStatus ? "{00ff3c}" : "{00ff3c}", capStatus);
    return 1;
}

cmd:hasCapability(playerid, params[]) // 
{
    new npcId, capId;
    if(sscanf(params, "i", npcId, capId)) return SendClientMessage(playerid, -1, "Use /hasCapability [npcId] [capabilityId]");
    SendFormatMessage(playerid, -1, "%s id: %d. Has capability %d ?: %s", getPlayerName(npcId), npcId, capId, KNPC_hasCapability(npcId, capId) ? "{00ff3c}YES" : "{ff0000}NO");
    return 1;
}

cmd:getCapabilities(playerid, params[]) // 
{
    new npcId;
    if(sscanf(params, "i", npcId)) return SendClientMessage(playerid, -1, "Use /getCapabilities [npcId]");
    for (new ci = 0; ci < MAX_CAPABILITIES; ci++)
    {
        SendFormatMessage(playerid, -1, "%s id: %d. Has capability %d ?: %s", getPlayerName(npcId), npcId, ci, KNPC_hasCapability(npcId, ci) ? "{00ff3c}YES" : "{ff0000}NO");
    }

    return 1;
}


cmd:setSpawnPos(playerid, params[]) // 
{
    new npcId;
    if(sscanf(params, "i", npcId)) return SendClientMessage(playerid, -1, "Use /setSpawnPos [npcId]");
	new Float:x, Float:y, Float:z, Float:a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
	KNPC_setSpawnPos(npcId, x, y, z, a);
    SendFormatMessage(playerid, -1, "%s id: %d. New value: %f, %f, %f, %f", getPlayerName(npcId), npcId, x, y, z, a);
    return 1;
}
