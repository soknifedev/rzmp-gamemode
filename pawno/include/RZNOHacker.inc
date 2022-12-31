/*====================== Anti Cheeaat ================================|
||                     Anti Cheat System                               |
||                            BY                                        |
||                       x]R[icard]O[x                                 |
||=====================================================================*/
#define MONEY_HACK ( 1 )
#define CAR_HACK ( 2 )
#define HEALTH_HACK ( 3 )
#define ARMOUR_HACK ( 4 )
#define WEAPON_HACK ( 5 )
#define CRASHER_HACK ( 6 )
#define AMMO_HACK ( 7 )
#define BULLET_CRASH ( 8 )
#define PLAYER_OUT_OF_VEHICLE 0


#include <a_vehicles>

new LastVehicle[MAX_PLAYERS];

forward PutPlayerInVehicleNOW(playerid, vehicleid, seatid);

stock VehicleOccupiedWithBOT(vehicleid)
{
    for(new i=0;i<GetMaxPlayers();i++)
    {
   		if(IsPlayerInVehicle(i,vehicleid) && IsPlayerNPC(i)) return 1;
    }
    return 0;
}





#define MAX_VEHICLEHEALTH 999.0

static Checkvehicle[MAX_PLAYERS];
static bool:PlayerInModShop[MAX_PLAYERS];

static const Float:PAYNSPRAY[][] =
{
  {1025.05, -1024.23, 32.1}, // LS Temple
  {487.68, -1740.87, 11.13}, // LS Santa Maria
  {-1420.73, 2583.37, 55.56}, // El Quebrados
  {-1904.39, 284.97, 40.75}, // Wang Cars
  {-2425.91, 1022.33, 50.10}, // Juniper Hill
  {1975.60, 2162.16, 10.77}, // LV Redsands
  {2065.38, -1831.51, 13.25}, // Idlewood
  {-99.55, 1118.36, 19.44}, // Fort Carson
  {721.07, -455.94, 16.04}, // Dillimore
  {2393.74, 1493.01, 10.52} // LV Unused (Pyramid)
};

forward CheckVehicleHealth(playerid);
forward OnPlayerVehicleHealthHack(playerid);



//Callbacks



public OnPlayerDisconnect(playerid, reason)
{
  KillTimer(Checkvehicle[playerid]);

  #if defined AntiRepair_OnPlayerDisconnect
  return AntiRepair_OnPlayerDisconnect(playerid, reason);
  #else
  return 1;
  #endif
}

public OnVehicleSpawn(vehicleid)
{
  SetVehicleHealth(vehicleid, MAX_VEHICLEHEALTH);

  #if defined AntiRepair_OnVehicleSpawn
  return AntiRepair_OnVehicleSpawn(vehicleid);
  #else
  return 1;
  #endif
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
  new Float:Vehiclehealth;
  GetVehicleHealth(vehicleid, Vehiclehealth);
  if(Vehiclehealth > MAX_VEHICLEHEALTH)
  {
    SetVehicleHealth(vehicleid, MAX_VEHICLEHEALTH);
  }

  #if defined AntiRepair_OnPlayerEnterVehicle
  return AntiRepair_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
  #else
  return 1;
  #endif
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER)
    {
      Checkvehicle[playerid] = SetTimerEx("CheckVehicleHealth", 1000, 1, "i",  playerid);
    }

    if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT)
    {
      KillTimer(Checkvehicle[playerid]);
    }

  #if defined AntiRepair_OnPlayerStateChange
  return AntiRepair_OnPlayerStateChange(playerid, newstate, oldstate);
  #else
  return 1;
  #endif
}

public OnEnterExitModShop(playerid, enterexit, interiorid)
{
  if(enterexit == 1) // Player entered a Mod Shop
  {
    PlayerInModShop[playerid] = true;
  }

  if(enterexit == 0) // Player left a Mod Shop
  {
    SetVehicleHealth(GetPlayerVehicleID(playerid), MAX_VEHICLEHEALTH);
    PlayerInModShop[playerid] = false;
  }

  #if defined AntiRepair_OnEnterExitModShop
  return AntiRepair_OnEnterExitModShop(playerid, enterexit, interiorid);
  #else
  return 1;
  #endif
}

public CheckVehicleHealth(playerid)
{
  new Float:Vehiclehealth;
  GetVehicleHealth(GetPlayerVehicleID(playerid), Vehiclehealth);

  for(new i=0; i<sizeof(PAYNSPRAY); i++)
  {
    if(IsPlayerInRangeOfPoint(playerid, 10, PAYNSPRAY[i][0], PAYNSPRAY[i][1], PAYNSPRAY[i][2]))
    {
      if(Vehiclehealth > MAX_VEHICLEHEALTH && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
      {
        SetVehicleHealth(GetPlayerVehicleID(playerid), MAX_VEHICLEHEALTH);
        return 1;
      }
    }
  }

  if(Vehiclehealth > MAX_VEHICLEHEALTH && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && PlayerInModShop[playerid] == false)
  {
    SetVehicleToRespawn(GetPlayerVehicleID(playerid));
    OnPlayerVehicleHealthHack(playerid);
    return 1;
  }

  return 1;
}

//================================================
//  ANTI VEHICLE REPAIR HACK
//================================================
#if defined _ALS_OnPlayerDisconnect
#undef OnPlayerDisconnect
#else
#define _ALS_OnPlayerDisconnect
#endif

#define OnPlayerDisconnect AntiRepair_OnPlayerDisconnect
#if defined AntiRepair_OnPlayerDisconnect
forward AntiRepair_OnPlayerDisconnect();
#endif

#if defined _ALS_OnVehicleSpawn
#undef OnVehicleSpawn
#else
#define _ALS_OnVehicleSpawn
#endif

#define OnVehicleSpawn AntiRepair_OnVehicleSpawn
#if defined AntiRepair_OnVehicleSpawn
forward AntiRepair_OnVehicleSpawn();
#endif

#if defined _ALS_OnPlayerStateChange
#undef OnPlayerStateChange
#else
#define _ALS_OnPlayerStateChange
#endif

#define OnPlayerStateChange AntiRepair_OnPlayerStateChange
#if defined AntiRepair_OnPlayerStateChange
forward AntiRepair_OnPlayerStateChange();
#endif


#if defined _ALS_OnEnterExitModShop
#undef OnEnterExitModShop
#else
#define _ALS_OnEnterExitModShop
#endif

#define OnEnterExitModShop AntiRepair_OnEnterExitModShop
#if defined AntiRepair_OnEnterExitModShop
forward AntiRepair_OnEnterExitModShop();
#endif

#if defined _ALS_OnPlayerEnterVehicle
#undef OnPlayerEnterVehicle
#else
#define _ALS_OnPlayerEnterVehicle
#endif

#define OnPlayerEnterVehicle AntiRepair_OnPlayerEnterVehicle
#if defined AntiRepair_OnPlayerEnterVehicle
forward AntiRepair_OnPlayerEnterVehicle();
#endif

//Function Hooks

stock AddStaticVehicleHooked(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:angle, color1, color2)
{
  new vehicleid = AddStaticVehicle(modelid, spawn_x, spawn_y, spawn_z, angle, color1, color2);
  if(vehicleid)
  {
    SetVehicleHealth(vehicleid, MAX_VEHICLEHEALTH);
  }
  return vehicleid;
}

#if defined _ALS_AddStaticVehicle
    #undef AddStaticVehicle
#else
    #define _ALS_AddStaticVehicle
#endif

#define AddStaticVehicle AddStaticVehicleHooked

stock AddStaticVehicleExHooked(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:z_angle, color1, color2, respawn_delay, addsiren=0)
{
  new vehicleid = AddStaticVehicleEx(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:z_angle, color1, color2, respawn_delay, addsiren);
  if(vehicleid)
  {
    SetVehicleHealth(vehicleid, MAX_VEHICLEHEALTH);
  }
  return vehicleid;
}

#if defined _ALS_AddStaticVehicleEx
    #undef AddStaticVehicleEx
#else
    #define _ALS_AddStaticVehicleEx
#endif

#define AddStaticVehicleEx AddStaticVehicleExHooked


stock CreateVehicleHooked(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, addsiren=0)
{
  new vehicleid = CreateVehicle(vehicletype, x, y, z, rotation, color1, color2, respawn_delay, addsiren);
  if(vehicleid)
  {
    SetVehicleHealth(vehicleid, MAX_VEHICLEHEALTH);
  }
  return vehicleid;
}

#if defined _ALS_CreateVehicle
    #undef CreateVehicle
#else
    #define _ALS_CreateVehicle
#endif

#define CreateVehicle CreateVehicleHooked


stock RepairVehicleHooked(vehicleid)
{
  RepairVehicle(vehicleid);
  if(vehicleid)
  {
    SetVehicleHealth(vehicleid, MAX_VEHICLEHEALTH);
  }
  return vehicleid;
}

#if defined _ALS_RepairVehicle
    #undef RepairVehicle
#else
    #define _ALS_RepairVehicle
#endif

#define RepairVehicle RepairVehicleHooked


stock SetVehicleToRespawnHooked(vehicleid)
{
  SetVehicleToRespawn(vehicleid);
  if(vehicleid)
  {
    SetVehicleHealth(vehicleid, MAX_VEHICLEHEALTH);
  }
  return vehicleid;
}

#if defined _ALS_SetVehicleToRespawn
    #undef SetVehicleToRespawn
#else
    #define _ALS_SetVehicleToRespawn
#endif

#define SetVehicleToRespawn SetVehicleToRespawnHooked


stock SetVehicleHealthHooked(vehicleid, Float:health)
{
  if(health > MAX_VEHICLEHEALTH)
  {
    SetVehicleHealth(vehicleid, MAX_VEHICLEHEALTH);
  }
  else
  {
    SetVehicleHealth(vehicleid, health);
  }
  return 1;
}

#if defined _ALS_SetVehicleHealth
    #undef SetVehicleHealth
#else
    #define _ALS_SetVehicleHealth
#endif

#define SetVehicleHealth SetVehicleHealthHooked

//================================================
//  ANTI MONEY HACK
//================================================
stock ObtenerDineroJugador(playerid) return GetPlayerMoney(playerid);

stock DarDineroJugador(playerid,CantidadM)
{
	SetPVarInt(playerid,"DineroS",GetPVarInt(playerid,"DineroS") + CantidadM);
	return GivePlayerMoney(playerid,CantidadM);
}

stock QuitarDineroJugador(playerid)
{
	SetPVarInt(playerid,"DineroS",0);
	return ResetPlayerMoney(playerid);
}

stock PlayerNameX(playerid) {
  new name[MAX_PLAYER_NAME];
  GetPlayerName(playerid, name, sizeof(name));
  return name;
}

//================================================
//  ANTI MONEY HACK
//================================================

public OnPlayerUpdate(playerid)
{
	new Float:SXhealth;
	GetPlayerHealth(playerid,SXhealth);
	if(IsPlayerInAnyVehicle(playerid) && LastVehicle[playerid] != GetVehicleModel(GetPlayerVehicleID(playerid)))
	{
	    if(LastVehicle[playerid] != PLAYER_OUT_OF_VEHICLE && !IsPlayerInAnyVehicle(playerid))return CallLocalFunction( "OnPlayerHackDetected", "dd", playerid, CAR_HACK);
		//{
		//printf("[SAS] JUGADOR %d HACKEO UN VEHICULO! Ultimo: %d | Nuevo: %d",playerid,LastVehicle[playerid],GetVehicleModel(GetPlayerVehicleID(playerid)));
		//return CallLocalFunction( "OnPlayerHackDetected", "dd", playerid, CAR_HACK);
		//}
	}
    if( GetPlayerMoney(playerid) != GetPVarInt(playerid,"DineroS"))
	{
  		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid,GetPVarInt(playerid,"DineroS"));
	}
    return CallLocalFunction( "AntiCheat_OnPlayerUpdate", "i", playerid );
}
#if defined _ALS_OnPlayerUpdate
    #undef OnPlayerUpdate
#else
    #define _ALS_OnPlayerUpdate
#endif


public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    CallLocalFunction("gbug_OnPlayerEnterVehicle", "ddd", playerid, vehicleid, ispassenger);
	//printf("PlayerId %d has enter into a car (%d)", playerid,GetVehicleModel(vehicleid));
    LastVehicle[playerid] = GetVehicleModel(vehicleid);
    LinkVehicleToInterior(LastVehicle[playerid], GetPlayerInterior(playerid));
    return 1;
}
forward NOH_OnPlayerExitVehicle(playerid, vehicleid);
public NOH_OnPlayerExitVehicle(playerid, vehicleid)
{
	//printf("PlayerId %d has enter into a car (%d)", playerid,GetVehicleModel(vehicleid));
    LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
}

public PutPlayerInVehicleNOW(playerid,vehicleid, seatid)
{
    LastVehicle[playerid] = GetVehicleModel(vehicleid);
    LastVehicle[playerid] = GetVehicleModel(vehicleid);
    LastVehicle[playerid] = GetVehicleModel(vehicleid);
    //printf("[ColocadoXD] %d  PUESTO DENTRO DEL COCHESITO >_< (%d)\n", playerid,GetVehicleModel(vehicleid));
	return PutPlayerInVehicle(playerid, vehicleid, seatid);
}

stock SAS_PutPlayerInVehicle(playerid, vehicleid, seatid)
{
    LastVehicle[playerid] = PLAYER_OUT_OF_VEHICLE;
    if(IsPlayerInAnyVehicle(playerid))
    {
    //printf("[VehiculoXD] %d  Ya esta en un auto >_< (%d)\n", playerid,GetVehicleModel(vehicleid));
    LastVehicle[playerid] = PLAYER_OUT_OF_VEHICLE;
	return SetTimerEx("PutPlayerInVehicleNOW", 100, false, "ddd", playerid,vehicleid,seatid);
    }
    else
    {
    //printf("PlayerId %d has been putted into a car (%d)\n", playerid,GetVehicleModel(vehicleid));
    LastVehicle[playerid] = GetVehicleModel(vehicleid);
    LastVehicle[playerid] = GetVehicleModel(vehicleid);
    LastVehicle[playerid] = GetVehicleModel(vehicleid);
	return PutPlayerInVehicle(playerid, vehicleid, seatid);
	}
}
#if defined _ALS_PutPlayerInVehicle
	#undef PutPlayerInVehicle
#else
	#define _ALS_PutPlayerInVehicle
#endif
forward NOH_OnPlayerSpawn(playerid);
public NOH_OnPlayerSpawn(playerid)
{
    LastVehicle[playerid] = PLAYER_OUT_OF_VEHICLE;
    //ChangingPLayerMoney[playerid] = 0;
    //printf("PlayerId %d has joined to server, changed veh. to(%d)\n", playerid,LastVehicle[playerid]);
}

forward AntiCheat_OnPlayerUpdate( playerid );
forward OnPlayerHackDetected( playerid, hack_type );


#define OnPlayerUpdate AntiCheat_OnPlayerUpdate
#define GetPlayerMoney ObtenerDineroJugador
#define GivePlayerMoney DarDineroJugador
#define ResetPlayerMoney QuitarDineroJugador
#define PutPlayerInVehicle SAS_PutPlayerInVehicle

