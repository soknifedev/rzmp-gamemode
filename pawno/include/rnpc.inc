/**
 *	RNPC - Recordfile NPCs
 *  Version 0.3.4
 *	made by Mauzen, parts based on Joe Staffs code
 */
#define RNPC_VERSION					"0.4"
#define RNPC_BUILD						12
#define RNPC_DATE						"26.06.2014"
#define RNPC_VERSION_DLPAGE				"www.mauzen.org/rnpc"
#define RNPC_VERSION_STARTURL			"www.mauzen.org/rnpc/rnpc_start.php"
#define RNPC_VERSION_UPDATEURL			"www.mauzen.org/rnpc/rnpc_update.php"

// Identify messages as RNPC commands
// (alternative communication protocol for future versions)
#define RNPC_COMM_ID				520


#define PLAYER_RECORDING_TYPE_NONE		0
#define PLAYER_RECORDING_TYPE_DRIVER	1
#define PLAYER_RECORDING_TYPE_ONFOOT	2

#define RNPC_SPEED_SPRINT				(0.0095)
#define RNPC_SPEED_RUN					(0.0057)
#define RNPC_SPEED_WALK					(0.0015)
#define RNPC_SPEED_FASTWALK				(0.0040)

#define MAP_ANDREAS_MODE_NONE			0
#define MAP_ANDREAS_MODE_MINIMAL		1
#define MAP_ANDREAS_MODE_MEDIUM			2	// currently unused
#define MAP_ANDREAS_MODE_FULL			3
#define MAP_ANDREAS_MODE_NOBUFFER		4

// RNPC_PEND_ACTION defines (Connection relevant states)
#define RNPC_ACTION_READY					(-1)
#define RNPC_NOT_EXISTING					(0)
#define RNPC_CONNECTION_PENDING				(1)
#define RNPC_CONNECTED						(2)
#define RNPC_STOPPING						(4)		// Stop-playback performed

// Adjustable stuff
#define RNPC_VEHICLE_DMG_MOD				(160.0)  // velocity * this value = vehicle hit damage

// @since 0.2
native RNPC_CreateBuild(npcid, type, slot=0);
native RNPC_FinishBuild(clear=1);
native RNPC_AddMovement(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2, Float:speed=RNPC_SPEED_RUN, use_zmap=0);
native RNPC_ConcatMovement(Float:x, Float:y, Float:z, Float:speed=RNPC_SPEED_RUN, use_zmap=0);
native RNPC_AddPause(time);

native RNPC_SetUpdateRate(rate);

native RNPC_SetLRKeys(lr);
native RNPC_SetUDKeys(ud);
native RNPC_SetKeys(keys);
native RNPC_SetQuat1(Float:w);
native RNPC_SetQuat2(Float:x);
native RNPC_SetQuat3(Float:y);
native RNPC_SetQuat4(Float:z);
native RNPC_SetHealth(hp);
native RNPC_SetArmour(arm);
native RNPC_SetSpecialAction(sp);
native RNPC_SetWeaponID(weaponid);
native RNPC_SetAnimID(anim);
native RNPC_SetAnimParams(params);
native RNPC_SetAngleQuats(Float:a, Float:h, Float:b);

native MapAndreas_Init(mode, name[]="", len=sizeof(name));
native MapAndreas_FindZ_For2DCoord(Float:X, Float:Y, &Float:Z);
native MapAndreas_FindAverageZ(Float:X, Float:Y, &Float:Z);
native MapAndreas_Unload();
native MapAndreas_SetZ_For2DCoord(Float:X, Float:Y, Float:Z);
native MapAndreas_SaveCurrentHMap(name[]);

// @since 0.2.1
native RNPC_GetBuildLength();

// @since 0.3
native RNPC_SetSirenState(siren);
native RNPC_SetDriverHealth(health);
native RNPC_SetInternalPos(Float:x, Float:y, Float:z);
native RNPC_SetAcceleration(Float:acc);
native RNPC_SetDeceleration(Float:dec);		// Unused yet
native RNPC_AddMovementAlt(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2, Float:speed=RNPC_SPEED_RUN, bool:lock=true);

// @since 0.3.4
native RNPC_CreateCustomBuild(type, name[]);
native RNPC_PathFinderMovement(Float:start_x, Float:start_y, Float:start_z, nodes_array[], nodes_array_size, Float:speed=RNPC_SPEED_FASTWALK);
// fake-functions
#define RNPC_SetAutorepeat(%1,%2)				new rtxt[10]; format(rtxt, 10, "RNPC:%d", 110 + %2); SendClientMessage(%1, -1, rtxt)
#define RNPC_PauseRecordingPlayback(%1)			SendClientMessage(%1, -1, "RNPC:103")
#define RNPC_ResumeRecordingPlayback(%1)		SendClientMessage(%1, -1, "RNPC:104")
#define RNPC_ToggleVehicleCollisionCheck(%1,%2) new rtxt[10]; format(rtxt, 10, "RNPC:%d", 115 - %2); SendClientMessage(%1, -1, rtxt)
#define	RNPC_StopPlayback(%1)					SendClientMessage(%1, -1, "RNPC:102")

// Redirecting SendClientMessage when debugmode is enabled
#if defined RNPC_DEBUG
	stock RNPC_TEMP_SendClientMessage(playerid, color, text[], len=sizeof(text)) {
		#pragma unused len
		// if (IsPlayerRNPC(playerid))
		// not needed here as this include doesnt communicate with real players anyways
		printf("RNPC %d <-- [CMD] %s", playerid, text);
		SendClientMessage(playerid, color, text);
	}
	#define SendClientMessage RNPC_TEMP_SendClientMessage
#endif
// --------------------------------------------------------

// Custom callbacks
forward OnRNPCPlaybackFinished(npcid);
forward OnRNPCPlaybackStopped(npcid);
forward OnRNPCVehicleHit(npcid, driverid, vehicleid, times);

/**
 *	Connects a new RNPC, returning his predicted ID.
 *	@since 	V0.1
 */
stock ConnectRNPC(name[])
{
	ConnectNPC(name, "RNPC");
	return 1;
}

/**
 *	Moves a RNPC to the given position.
 *	@since 	V0.1
 */
stock MoveRNPC(npcid, Float:x, Float:y, Float:z, Float:speed, use_zmap=1)
{
	#pragma unused use_zmap
	if (!IsPlayerNPC(npcid)) return false;
	new Float:nx, Float:ny, Float:nz;
	GetPlayerPos(npcid, nx, ny, nz);
	RNPC_CreateBuild(npcid, PLAYER_RECORDING_TYPE_ONFOOT);
	if(GetPlayerInterior(npcid) != 0)
	{
	RNPC_ConcatMovement(x, y, z, speed, 0);
	}
	else
	{
	RNPC_AddMovementAlt(nx, ny, nz, x, y, z, speed);
	}
	RNPC_FinishBuild();
	RNPC_StartBuildPlayback(npcid);
	return true;
}

stock MoveRNPC_EX(npcid, Float:x, Float:y, Float:z, Float:speed, use_zmap=0)
{
	if (!IsPlayerNPC(npcid)) return false;
	new Float:nx, Float:ny, Float:nz;
	GetPlayerPos(npcid, nx, ny, nz);
	RNPC_CreateBuild(npcid, PLAYER_RECORDING_TYPE_ONFOOT);
	RNPC_ConcatMovement(x, y, z, speed, use_zmap);
	RNPC_FinishBuild();
	RNPC_StartBuildPlayback(npcid);
	return true;
}

/**
 *
 *	@since	V0.1.1
 */
stock RNPC_StartPlayback(npcid, rec[])
{
	if (!IsPlayerNPC(npcid)) return false;

	new form[40];
	format(form, 40, "RNPC:109:%s", rec);
	SendClientMessage(npcid, -1, form);

	return true;
}

/**
 *
 *	@since V0.2
 */
stock RNPC_StartBuildPlayback(npcid, slot=0, vehicleid=0)
{
	if (vehicleid) {
		PutPlayerInVehicle(npcid, vehicleid, 0);
		SetTimerEx("DelayStart", 100, 0, "iii", npcid, vehicleid, slot);
	}
	new cmd[16];
	format(cmd, 16, "RNPC:101:%d", slot);
	SendClientMessage(npcid, -1, cmd);
}

/**
 * Delayed second start to fix vehicle playback problems
 * @since V0.3
 */
forward DelayStart(npcid, vehicleid, slot);
public DelayStart(npcid, vehicleid, slot)
{
	PutPlayerInVehicle(npcid, vehicleid, 0);
	new cmd[16];
	format(cmd, 16, "RNPC:101:%d", slot);
	SendClientMessage(npcid, -1, cmd);
}
