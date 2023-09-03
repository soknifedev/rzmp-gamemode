#include <rzmp\knpc>


#define KNPC_TYPE_ZOMBIE 1

new ZOMBIE_SKIN_IDS[] = {
    77, 78, 79, 134, 135, 136, 137, 212, 213, 239, 63, 64, 75, 85, 152, 207, 237, 238, 243, 244, 245, 253, 256, 257
};


stock KNPC_Zombie_getRandomSkin() {
	return ZOMBIE_SKIN_IDS[random(sizeof(ZOMBIE_SKIN_IDS))];
}

stock KNPC_Zombie_create(Float:x, Float:y, Float:z, Float:a, Float:health=100.0) {
	new name[16];
	format(name, 16, "KZombie%d", KNPC_getConnectedCount(KNPC_TYPE_ZOMBIE) + 1);
	new npcId = FCNPC_Create(name);
	FCNPC_SetHealth(npcId, health);
	KNPC_setType(npcId, KNPC_TYPE_ZOMBIE);
	KNPC_setAttackDamage(npcId, 8); // Bite Damage
	KNPC_setMovingSpeed(npcId, FCNPC_MOVE_SPEED_RUN);
	KNPC_setAutoRespawn(npcId, true);

	KNPC_setSeekerTick(npcId, -1); // -1 by default
	KNPC_setBiteTick(npcId, -1);
	KNPC_setBittingSpeed(npcId, 1000); // 1s by default
	KNPC_setWalkingStyle(npcId, WALKING_STYLE_TYPE_ZOMBIE);

	KS_DEBUG("[%s] %s():: Name: %s; id: %d", "knife_zombies.inc", "KNPC_createZombie", KNPC_getName(npcId), npcId);
	KNPC_setSpawnPos(npcId, x, y, z, a, getRandomZombieSkinId()); // set SpawnPos
	return npcId;
}


/*
* Le quita vida a un jugador basandose en el valor de AttackDamage
*/
stock KNPC_Zombie_bitePlayer(npcId, playerId) {
	FCNPC_ClearAnimations(npcId);
	ClearAnimations(npcId);
	ApplyAnimation(npcId, "WAYFARER", "WF_Fwd", 4.1, 0, 0, 0, 0, 0, 1);
	ApplyAnimation(playerId, "PED", "DAM_armR_frmFT", 4.1, 0, 0, 0, 0, 0, 1);
	PlayerPlaySound(playerId, 1136, 0.0, 0.0, 0.0);
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerId, x,y,z);
 	FCNPC_TriggerWeaponShot(npcId, 24, BULLET_HIT_TYPE_PLAYER, playerId, x,y,z, true, 0.0,0.0,0.0, FCNPC_ENTITY_CHECK_NONE);
	new Float:health;
	GetPlayerHealth(playerId, health);
	return SetPlayerHealth(playerId, health - KNPC_getAttackDamage(npcId));
}

stock KNPC_setThreatRadius(npcId, Float:radius) {
	KNPC_INFO[npcId][ThreatRadius] = radius;
}
stock Float:KNPC_getThreatRadius(npcId) {
	return KNPC_INFO[npcId][ThreatRadius];
}


/*
* Obtiene el zombie que esta mas cerca del jugador
*/
stock KNPC_Zombie_getNearestZombie(playerid)
{
    new Float:X, Float:Y, Float:Z, nearestNpcId = INVALID_PLAYER_ID;
    for(new i = 0; i < GetMaxPlayers(); i++)
    {
		// Omitir si el indice es el jugador en cuestion
		// o omitir si el indice no es un KNPC zombie
		if((i == playerid) || !KNPC_IsValid(i, KNPC_TYPE_ZOMBIE)) continue;

        KNPC_GetPosition(i, X, Y, Z);
        new Float:lastZombieDistance = 99999.99;
        new Float:zombieDistanceFromPlayer = GetPlayerDistanceFromPoint(playerid, X, Y, Z);

		// Algoritmo de busqueda
		if (nearestNpcId == INVALID_PLAYER_ID)
        {
            nearestNpcId = i;
            lastZombieDistance = zombieDistanceFromPlayer;
        }
		else if (zombieDistanceFromPlayer < lastZombieDistance)
        {
            nearestNpcId = i;
            lastZombieDistance = zombieDistanceFromPlayer;
        }
    }
    return nearestNpcId;
}