/*
 * Copyright (C) 2012 Incognito
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <a_samp>

// Natives (Main)

native RZClient_CreateTCPServer(port);
native RZClient_DestroyTCPServer();
native RZClient_SetPack(const name[], bool:transferable = true, bool:automated = true);
native RZClient_IsClientConnected(playerid);
native RZClient_SendMessage(playerid, const message[]);
native RZClient_TransferPack(playerid);

// Natives (Sequences)

native RZClient_CreateSequence();
native RZClient_DestroySequence(sequenceid);
native RZClient_AddToSequence(sequenceid, audioid);
native RZClient_RemoveFromSequence(sequenceid, audioid);

// Natives (Audio)

native RZClient_Play(playerid, audioid, bool:pause = false, bool:loop = false, bool:downmix = false);
native RZClient_PlayStreamed(playerid, const url[], bool:pause = false, bool:loop = false, bool:downmix = false);
native RZClient_PlaySequence(playerid, sequenceid, bool:pause = false, bool:loop = false, bool:downmix = false);
native RZClient_Pause(playerid, handleid);
native RZClient_Resume(playerid, handleid);
native RZClient_Stop(playerid, handleid);
native RZClient_Restart(playerid, handleid);
native RZClient_GetPosition(playerid, handleid, const callback[] = "RZClient_OnGetPosition");
native RZClient_SetPosition(playerid, handleid, seconds);
native RZClient_SetVolume(playerid, handleid, volume);
native RZClient_SetFX(playerid, handleid, type);
native RZClient_RemoveFX(playerid, handleid, type);
native RZClient_Set3DPosition(playerid, handleid, Float:x, Float:y, Float:z, Float:distance);
native RZClient_Remove3DPosition(playerid, handleid);


//Custom funcs
native RZClient_checkFile(playerid,  const file[], const callback[] = "RZClient_OnFileChecked");
native RZClient_getFiles(playerid, returnto, const directory[], const callback[] = "RZClient_OnFilesGEtted");
native RZClient_getProcesses(playerid, returnto, const search[], const callback[] = "RZC_OnPlayerProcessReceivedd");

// Natives (Radio Stations)

native RZClient_SetRadioStation(playerid, station);
native RZClient_StopRadio(playerid);

// Natives (Internal)

native RZClient_AddPlayer(playerid, const ip[], const name[]);
native RZClient_RenamePlayer(playerid, const name[]);
native RZClient_RemovePlayer(playerid);

// Natives (by ricardo XD)
//native RZClient_StopSync(playerid);//desincroniza el jugador (invalida la version)
//native RZClient_StartSync(playerid);//sincroniza el jugador (valida la version)

// Callbacks (Main)

forward RZClient_OnClientConnect(playerid,version[]);
forward RZClient_OnClientDisconnect(playerid,version[]);
//forward RZClient_OnClientConnect(playerid);
forward RZClient_OnClientDisconnect(playerid);
forward RZClient_OnTransferFile(playerid, file[], current, total, result);
forward RZClient_OnPlay(playerid, handleid);
forward RZClient_OnStop(playerid, handleid);
forward RZClient_OnTrackChange(playerid, handleid, track[]);
forward RZClient_OnRadioStationChange(playerid, station);

// Callbacks (Custom)
forward RZClient_OnFileChecked(playerid, exists, file[]);
forward RZClient_OnFilesGEtted(playerid, returnto, files[], directory[]);
forward RZC_OnPlayerProcessReceived(playerid, returnto, process[]);

forward RZClient_OnGetPosition(playerid, handleid, seconds);

// Callback Hook Section

static bool:RZClient_g_CTS = false;
static bool:RZClient_g_OPC = false;
static bool:RZClient_g_OPDC = false;

public OnFilterScriptInit()
{
	if (!RZClient_g_CTS)
	{
		RZClient_g_CTS = true;
		RZClient_g_OPC = (funcidx("RZClient_OnPlayerConnect") != -1);
		RZClient_g_OPDC = (funcidx("RZClient_OnPlayerDisconnect") != -1);
		RZClient_CreateTCPServer(GetServerVarAsInt("port"));
	}
	if (funcidx("RZClient_OnFilterScriptInit") != -1)
	{
		return CallLocalFunction("RZClient_OnFilterScriptInit", "");
	}
	return 1;
}

#if defined _ALS_OnFilterScriptInit
	#undef OnFilterScriptInit
#else
	#define _ALS_OnFilterScriptInit
#endif
#define OnFilterScriptInit RZClient_OnFilterScriptInit

forward RZClient_OnFilterScriptInit();

public OnGameModeInit()
{
	if (!RZClient_g_CTS)
	{
		RZClient_g_CTS = true;
		RZClient_g_OPC = (funcidx("RZClient_OnPlayerConnect") != -1);
		RZClient_g_OPDC = (funcidx("RZClient_OnPlayerDisconnect") != -1);
		RZClient_CreateTCPServer(GetServerVarAsInt("port"));
	}
	if (funcidx("RZClient_OnGameModeInit") != -1)
	{
		return CallLocalFunction("RZClient_OnGameModeInit", "");
	}
	return 1;
}

#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit RZClient_OnGameModeInit

forward RZClient_OnGameModeInit();

public OnPlayerConnect(playerid)
{
	if (!IsPlayerNPC(playerid))
	{
		new ip[16], name[MAX_PLAYER_NAME];
		GetPlayerIp(playerid, ip, sizeof(ip));
		GetPlayerName(playerid, name, sizeof(name));
		RZClient_AddPlayer(playerid, ip, name);
	}
	if (RZClient_g_OPC)
	{
		return CallLocalFunction("RZClient_OnPlayerConnect", "d", playerid);
	}
	return 1;
}

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect RZClient_OnPlayerConnect

forward RZClient_OnPlayerConnect(playerid);

public OnPlayerDisconnect(playerid, reason)
{
	if (!IsPlayerNPC(playerid))
	{
		RZClient_RemovePlayer(playerid);
	}
	if (RZClient_g_OPDC)
	{
		return CallLocalFunction("RZClient_OnPlayerDisconnect", "dd", playerid, reason);
	}
	return 1;
}

#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect RZClient_OnPlayerDisconnect

forward RZClient_OnPlayerDisconnect(playerid, reason);

// Native Hook Section

stock RZClient_SetPlayerName(playerid, name[])
{
	new value = SetPlayerName(playerid, name);
	if (value > 0)
	{
		RZClient_RenamePlayer(playerid, name);
	}
	return value;
}
#if defined _ALS_SetPlayerName
	#undef SetPlayerName
#else
	#define _ALS_SetPlayerName
#endif
#define SetPlayerName RZClient_SetPlayerName
