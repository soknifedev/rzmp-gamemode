// OnPlayerInvalidBulletShot by Emmet

enum {
	BULLET_INVALID_WEAPON_ID,
	BULLET_INVALID_HIT_TYPE,
	BULLET_INVALID_HIT_ID,
	BULLET_OUT_OF_RANGE,
	BULLET_RAPID_SHOT
};

#if !defined IsValidVehicle
	native IsValidVehicle(vehicleid);
#endif

forward OnPlayerInvalidBulletShot(playerid, reason);

static
	s_iLastBulletShot[MAX_PLAYERS]
;

stock static IsFirearmWeapon(weaponid)
{
	return (22 <= weaponid <= 34) || weaponid == 38;
}

public OnPlayerConnect(playerid)
{
	s_iLastBulletShot[playerid] = 0;
	
	#if defined BT_OnPlayerConnect
		return BT_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	new tick = NetStats_GetConnectedTime(playerid);

	if ((tick - s_iLastBulletShot[playerid]) <= 40 && weaponid != WEAPON_UZI && weaponid != WEAPON_TEC9 && weaponid != WEAPON_MP5 && weaponid != WEAPON_MINIGUN) {
	    return CallLocalFunction("OnPlayerInvalidBulletShot", "ii", playerid, BULLET_RAPID_SHOT), 0;
	} else if (!IsFirearmWeapon(weaponid)) {
	    return CallLocalFunction("OnPlayerInvalidBulletShot", "ii", playerid, BULLET_INVALID_WEAPON_ID), 0;
	} else if (!(BULLET_HIT_TYPE_NONE <= hittype <= BULLET_HIT_TYPE_PLAYER_OBJECT)) {
		return CallLocalFunction("OnPlayerInvalidBulletShot", "ii", playerid, BULLET_INVALID_HIT_TYPE), 0;
	} else if ((hittype == BULLET_HIT_TYPE_NONE) && weaponid != WEAPON_SNIPER && GetPlayerDistanceFromPoint(playerid, fX, fY, fZ) > 300.0 && (fX != 0.0 && fY != 0.0 && fZ != 0.0)) {
		return CallLocalFunction("OnPlayerInvalidBulletShot", "ii", playerid, BULLET_OUT_OF_RANGE), 0;
	} else if ((hittype == BULLET_HIT_TYPE_PLAYER && !IsPlayerConnected(hitid)) || (hittype == BULLET_HIT_TYPE_VEHICLE && !IsValidVehicle(hitid)) || (hittype == BULLET_HIT_TYPE_OBJECT && !IsValidObject(hitid)) || (hittype == BULLET_HIT_TYPE_PLAYER_OBJECT && !IsValidPlayerObject(playerid, hitid))) {
		return CallLocalFunction("OnPlayerInvalidBulletShot", "ii", playerid, BULLET_INVALID_HIT_ID), 0;
	}

	s_iLastBulletShot[playerid] = tick;

	#if defined BT_OnPlayerWeaponShot
	    return BT_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, fX, fY, fZ);
	#else
	    return 1;
	#endif
}

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect BT_OnPlayerConnect

#if defined BT_OnPlayerConnect
	forward BT_OnPlayerConnect(playerid);
#endif

#if defined _ALS_OnPlayerWeaponShot
	#undef OnPlayerWeaponShot
#else
	#define _ALS_OnPlayerWeaponShot
#endif

#define OnPlayerWeaponShot BT_OnPlayerWeaponShot

#if defined BT_OnPlayerWeaponShot
	forward BT_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
#endif



