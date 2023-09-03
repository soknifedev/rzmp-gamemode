#include <rzmp\knpc>


#define KNPC_TYPE_HUMAN 2


new HUMAN_SKIN_IDS[] = {287, 285, 164, 165, 166}; // ARMY & MEN IN BLACK xd


stock KNPC_Human_getRandomSkin() {
	return HUMAN_SKIN_IDS[random(sizeof(HUMAN_SKIN_IDS))];
}

stock KNPC_Human_create(Float:x, Float:y, Float:z, Float:a, Float:health=100.0) {
	new name[16];
	format(name, 16, "KHuman%d", KNPC_getConnectedCount(KNPC_TYPE_HUMAN) + 1);
	new npcId = FCNPC_Create(name);
	FCNPC_SetHealth(npcId, health);
	KNPC_setType(npcId, KNPC_TYPE_HUMAN);
	KNPC_setAttackDamage(npcId, 1);
	KNPC_setMovingSpeed(npcId, FCNPC_MOVE_SPEED_RUN);
	KNPC_setAutoRespawn(npcId, true);

	KNPC_setAttackRadius(npcId, 10);
	KNPC_setThreatRadius(npcId, 50);

	KS_DEBUG("[%s] %s():: Name: %s; id: %d", "knife_zombies.inc", "KNPC_createZombie", KNPC_getName(npcId), npcId);
	KNPC_setSpawnPos(npcId, x, y, z, a, getRandomHumanSkinId()); // set SpawnPos
	return npcId;
}