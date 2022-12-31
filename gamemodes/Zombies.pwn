/*

Copyrgiht © soknifedev. GNU Public License V3
Hecho en México, con Amors <3 

*/
//==============================================================================
// Includes.
//==============================================================================
//Desmarca este pragma para hacer que el servidor ocupe más memoria, en caso de que no quiera iniciar.

#pragma dynamic 9999999999999999999999999
#include <a_samp>
#undef MAX_PLAYERS
#define MAX_PLAYERS (350)

#include <a_http>
#include <crashdetect>
#include <RZNOHacker>
#include <streamer>
#include <gBUG>
#include <KickBan_Fix>
//#include <FuckCleo>
#include <OnPlayerPause>
#include <rzclient037>
#include <MapAndreas>
//#include <ColAndreas>
#include <RZ_MAPS_RP>
#include <FCNPCv170>
//#include <foreach>
#include <raknetmanager>

//#include <rz_inventory>

//new GetMaxPlayers();

native IsValidVehicle(vehicleid);
main( ) { }
#define NULL_X 15305.8594
#define NULL_Y 15387.9238
#define NULL_Z 46.2415
#define RCM_API "revolucion-zombie.com/geoip/index.php?IP="
//====== config =======//
#define USING_GEOIP 1
#define USING_CRESTRICTOR 1
#define COLOR_BLUE_SOLID 0x00C4EBAA
new RCM_DIALOG[300];
#define RCM_SendDialog(%0,%1,%2,%3) format(RCM_DIALOG, sizeof(RCM_DIALOG),%2,%3) && ShowPlayerDialog(%0,0,DIALOG_STYLE_MSGBOX,%1,RCM_DIALOG,"x","")
//==============================================================================
// Defines del servidor.
//==============================================================================
#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
#define IsNull(%1) \
    ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#define Maximo_Contraseñas_Incorrectas 3
new DB:DataBase_USERS,DBResult: NUM_ROWS_SQL;
//#define SistemaDECombustible //no activar porque no le gusta a la gente xD
#define BIDON_DIALOG 22
new Fmsg[256];
#define SendFormatMessageToAll(%1,%2,%3) format(Fmsg, sizeof(Fmsg),%2,%3) && SendClientMessageToAll(%1,Fmsg)
#define SendFormatMessage(%1,%2,%3,%4) format(Fmsg, sizeof(Fmsg),%3,%4) && SendClientMessage(%1,%2,Fmsg)
new fdialog[300];
#define MAX_LEN 32
#define MAX_ENTRY 120
#define SendFormatDialog(%0,%1,%2,%3) format(fdialog, sizeof(fdialog),%2,%3) && ShowPlayerDialog(%0,0,DIALOG_STYLE_MSGBOX,%1,fdialog,"x","")
new fGameText[128];
#define SendFormatGameText(%0,%1,%2,%3,%4) format(fGameText, sizeof(fGameText),%1,%2) && GameTextForPlayer(%0, fGameText, %3,%4)
//anti sobeit

//#define USE_SOBEIT_CAMERA_DETECTION

#if defined USE_SOBEIT_CAMERA_DETECTION
#define SOB_MAX_SKIPS 3
#define FZ_SCDS 5
#define MAX_VIRTUAL_WORLDS 600
#define INVALID_VIRTUAL_WORLD 700
new WorldUsed[MAX_VIRTUAL_WORLDS];
#endif


#define ACTOR_TYPE_GUNSMITH 0
#define ACTOR_TYPE_SCIENTIFIC 1
#define ACTOR_TYPE_WAITER 2
#define ACTOR_TYPE_DRONE_TRADER 3

#define DRONE_COLOR 0xCCFF3311
#define DRONE_COL "{FFFF33}"
enum ActorsInfo
{
	sactorid,
	actortype,
	actorskin
}
new ServerActor[MAX_ACTORS][ActorsInfo];
enum sPickupInfo
{
	obj,
	objId,
	spickupId,
	pickupType,
	pickupSpawnType,
	pickupModel,
	Float:pickupXC,
	Float:pickupYC,
	Float:pickupZC,
	pikcupActive
}
new ServerPickups[MAX_PICKUPS][sPickupInfo];
//Sonidos del Juego
//new LS_SoundTracks,SF_SoundTracks,LV_SoundTracks,A51_SoundTracks,W_SoundTracks,Epic_SoundTracks;

#define MAX_INFECTED_ZONES 7
enum InfectedZoneInfo
{
	zoneId,
	gangZoneId
}

new InfectedZone[MAX_INFECTED_ZONES][InfectedZoneInfo];//INCREMENTAR SI PONGO MÁS ZONAS XD LUEGO.

enum InfectedZoneMusicFields
{

MP3[256],
Enabled

}

new InfectedZoneMusic[InfectedZoneMusicFields];

#define MAX_SAFE_ZONES 5
enum SafeZoneInfo
{
	zoneId,
	gangZoneId
}
new SafeZone[MAX_SAFE_ZONES][SafeZoneInfo]; //ZONAS SEGURASXD

new bool:AmbianceThemes;
new SCORE_NOOB;
//==============================================================================
// Dialogos del Servidor.
//==============================================================================
#define Armamentos 7
#define ComidaRZ 8
#define COMERCIO_RZ 9
#define AntibioticosRZ 10
#define DIALOG_MUSIC_ADMIN 11
//#define DIALOG_NEON 12

#define DIALOG_ITEMS_H 14

#define DIALOG_TEXTO 16
#define UNBAN_PLAYER 18
#define ADMIN_CMDS 19
#define musica 20 // nose cuantas utiliza
#define FIGHT   23
#define SongDialog 24
#define SongDialogADM 25
#define DIALOG_COMANDOS 26
#define DIALOGID   28
//dialogos especiales
#define MODIFICAR_DIALOGO 130
#define DIALOG_STATS 7655
#define Administradores 7646
#define Duda 7647
#define NMusica2 7649
#define REGISTRO 7650
#define INGRESO 7651
#define PVips 7652
#define DIALOG_RESPUESTA 7653
////////////////////////
#define CLAN_CREAR 1
#define CLAN_RECLUTAR 2
#define CLAN_KICK 3
#define CLAN_REQUEST 4
#define CLAN_CTAG 5
#define CLAN_DADMIN 30
#define CLAN_VER 31
#define RZUNBAN_PLAYER 33
#define COMERCIO_DRONES_RZ 34
#define COMERCIO_DRONES_RZ_EXPRESS 35
//=================================================================
new Zombie_Skins[] = {77, 78, 79, 134, 135, 136, 137, 212, 213, 239, 63, 64, 75, 85, 152, 207, 237, 238, 243, 244, 245, 253, 256, 257};
//==================================

//----------------------------------
//popo
//---------------------------------
new CountDown;
//=====================================
new Timer_Anuncios;
//--------------------------------------------------------------

//==============================================================================
// BASES
//==============================================================================
new XMasDomo;
//==============================================================================
//#define Camara_Movimiento 1
#if defined Camara_Movimiento
#define player_x 862.6347
#define player_y -1105.9109
#define player_z 25.8559
#define player_angle 177.9604
#define camera_x 863.2119
#define camera_y -1112.3148
#define camera_z 29.3737
#define moving_speed 27
enum pCInfo
{
    bool:SpawnDance,
    Float:SpawnAngle,
    SpawnTimer
};

new PlayerCameraInfo[MAX_PLAYERS][pCInfo];
#endif
new ConexionSQL;

enum obInfo{ACTIVADO}
new ObjectInfo[MAX_OBJECTS][obInfo];
new NPC_NEMESIS[MAX_PLAYERS];
new Text3D:LabelCabecero[MAX_PLAYERS];
new Text:MiniLogoM;



//===========================//
//new Attack[MAX_PLAYERS];
new gTeam[MAX_PLAYERS];

#define HOLDING(%0) \
        ((newkeys & (%0)) == (%0))
#define HOLDING_SHOOT(%0) \
	((playerkeys & (%0)) == (%0))
#define RELEASED(%0) \
        (((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1

//==================================================================================
//modos de spec
//#define USE_ZOMBIE_RADAR 1
#define ADMIN_SPEC_TYPE_NONE 0
#define ADMIN_SPEC_TYPE_PLAYER 1
#define ADMIN_SPEC_TYPE_VEHICLE 2
#define MAX_REPORTS 10
new Clima,Hora;
new IZ_Hour, IZ_Weather, IZ_Zombies, IZ_ZombiesRespawnTime, IZ_HIDE_HUD;
new SinCHAT;
new HideServerPlayersHUD;
new Reports[MAX_REPORTS][1200];
new RCM_Country[MAX_PLAYERS][256];
new bIP[MAX_PLAYERS][256],bAdmin[MAX_PLAYERS][MAX_PLAYER_NAME],bNick[MAX_PLAYERS][MAX_PLAYER_NAME],bFecha[MAX_PLAYERS][30],bRazon[MAX_PLAYERS][50],Password[MAX_PLAYERS][30],ClanTAG[MAX_PLAYERS][50],Fecha_REG[MAX_PLAYERS][30];


//VIP MINIMUM SCORES FOR CLAIM
#define VIP_SCORE_SILVER 175000
#define VIP_SCORE_GOLD 950000
#define VIP_SCORE_PREMIUM 1000000
//#define ANTI_AMMO_HACK true

enum PInfo
{
VIP,Posg,Registrado,Identificado,Asesinatos,Muertes,Dinero,SKIN,UsaSkin,SkinID,SpecType,mirandoID,nivel,congelado,callado,SpecID,Spawned,pCar,CLAN,CLAN_OWN,Invitado,PM,VirusZ,VirusG,Pausa,Advertencias,Banned,Lsay,DoorsLocked,RZWarnings,AntiZombie,IP[256],
Float:LX,Float:LY,Float:LZ,Float:LA,Float:LHE,Float:LAR,GLOBALCHAT,SpawnProtection, MP3_ID,

UsaLazer,
AntiCPFlood,
AntiDigoFlood,
AntiARFlood,
AntiHHFlood,
AntiVIPCarFlood,
Antispam1,
TimerDARMA,

ANT_PMF,
Antispam3,
dead,
SpawnAuto,

StatsID,
invisible,
invisibleX,
playerInt,

SC_NICK[MAX_PLAYER_NAME],
SC_COUNT,
SC_Anim,
SC_TIMER,
ZonaSegura,
ZonaInfectada,
#if defined USE_ZOMBIE_RADAR
Text:RadarZombie,
TimerCheck,
#endif
MAX_PLAYER_ZOMBIES,

LastDeath, DeathSpam,
PlayerTrack,

InvitadorID,
Ocultado,
MusicInicio,

ContrasenaIncorrecta,
bool:Weapon[47],
bool:WeaponDroppable[47],
WH_Warnings,

Float:SC_XYZ[3], AnimLibrary[32], AnimName[32],
armedbody_pTick,
Float:savedPos[4],

InCORE,
IsCoreWeapon,
RZClient_Locked,
RZClient_Verified,
ZJump,
DRONE_ID,
AAH_BulletsFired[14],
AAH_WeaponAmmo[14],
AAH_AmmoTick,
AAH_AmmoHackCount[14],
ZombieSpawnerTick,
ZombieSpawnerTime,
bool:IgnoreSpawn



};
new PlayerInfo[MAX_PLAYERS][PInfo];

#define COORD_CORE_TYPE_CORE 0
#define COORD_CORE_TYPE_POINT 1

#define COORD_CORE_POS_TYPE_X 0
#define COORD_CORE_POS_TYPE_Y 1
#define COORD_CORE_POS_TYPE_Z 2



#define CORE_OBJECT 18876
#define CORE_FIGHTING 0
#define CORE_FINISHED 1
#define CORE_WAITING 2

#define CORE_REWARD_TYPE_MONEY 0
#define CORE_REWARD_TYPE_SCORE 1
#define MINS_FOR_BACKUP 180

#define CORE_ZONE1 1
#define CORE_ZONE2 2
#define CORE_ZONE3 3
#define CORE_ZONE4 4
#define CORE_ZONE5 5
#define CORE_ZONE6 6
#define CORE_ZONE7 7
#define CORE_ZONE8 8
#define CORE_ZONE9 9
#define CORE_ZONE10 10

#define SLOW_ZOMBIE_MOVE_TYPE MOVE_TYPE_WALK
#define MEDIUM_ZOMBIE_MOVE_TYPE MOVE_TYPE_RUN
#define HIGH_ZOMBIE_MOVE_TYPE MOVE_TYPE_SPRINT

#define SLOW_ZOMBIE_MOVE_SPEED MOVE_SPEED_WALK
#define MEDIUM_ZOMBIE_MOVE_SPEED MOVE_SPEED_RUN
#define HIGH_ZOMBIE_MOVE_SPEED MOVE_SPEED_SPRINT



enum CoreItems
{
	STATE,//0 = Waiting, 1 = Started
	MAX_DEFENDERS,//MAX PLAYERS
	MIN_DEFENDERS,//MIN PLAYERS
	ROUNDS,//ROUNDS TO WON THE GAME
	ZOMBIES_PER_ROUND,//ZOMBIES PER ROUND
	IZOMBIES_PER_ROUND,//INCREASES ZOMBIES AMOUNT PER ROUND
	CURRENT_ESCAPES,//COUNT THE ZOMBIE ESCAPES
	MAX_ESCAPES,//MAX ESCAPES TO LOST THE GAME
	CHECKER,//TIMER TO CHECK PLAYERS AND START OR WAIT.
	REWARD,//REWARD IF THEY WON THE GAME
	REWARD_TYPE, //REWARD TYPE, MONEY, SCORE.
	ZONE, //HUMAN CORE ZONE.
	Float:XYZ[3], //XYZ Coords of the Human Core.
	ServerBackup, //prevenir escapes cuando se este haciendo el backup :3
	OBJ, //Objeto para el nucleo
	Float:ZOMBIES_MOVE_SPEED,
	ZOMBIES_MOVE_TYPE,
	ZOMBIES_KILLED,
	CURRENT_ROUND,
	ZOMBIES_TO_KILL,
	CoreTick,
	CoreExplosionTick,
	Enabled
}
new HumanCore[CoreItems];

//Spawns zombies 2,4
//Spawns humanos 5,8
new Float:CORESpawns_Zone1[][] =
{
{ 2857.28076, 913.86584, 9.74351 }, //[0]NUCLEO
{ 2766.2571,913.0657,11.0938 }, //[1]Point
{ 2660.4763,933.6147,6.7344 }, //[2]ZombieSapwn
{ 2766.4492,774.2293,10.8984 }, //[3]ZombieSapwn
{ 2767.5022,1029.9536,10.9561 }, //[4]ZombieSapwn
{2847.61182, 902.31525, 11.26242}, //[5] HumanSpawn
{2847.12476, 908.37042, 11.26242}, //[6] HumanSpawn
{2850.64990, 905.40326, 11.26242}, //[7] HumanSpawn
{2850.85962, 911.51276, 11.26242} //[8] HumanSpawn

};

//Spawns zombies 2,5
//Spawns humanos 6,9
new Float:CORESpawns_Zone2[][] =
{
{ -844.61346,2753.91333,44.74726 }, //[0]NUCLEO
{ -841.9178,2728.6396,45.7171 }, //[1]Point
{ -889.4590,2699.1309,42.3703 }, //[2]ZombieSpawn
{ -931.8629,2720.2988,45.8672 }, //[3]ZombieSpawn
{ -758.7005,2730.2590,45.7015 }, //[4]ZombieSpawn
{ -739.9032,2660.8950,63.1192 }, //[5]ZombieSpawn
{ -841.3027,2711.9866,45.9405 }, //[6]HumanSpawn
{ -868.9370,2756.0320,45.8516 }, //[7]HumanSpawn
{ -810.4363,2760.9624,45.8516 }, //[8]HumanSpawn
{ -766.0628,2751.6057,45.7734 } //[9]HumanSpawn

};


//Spawns zombies 2,3,4
//Spawns humanos 5,6,7,8
new Float:CORESpawns_Zone3[][] =
{
{ -2984.69287, 474.63269, 3.91069 }, //[0]NUCLEO
{ -2856.60938, 473.79678, 4.14112 }, //[1]Point
{ -2781.37427, 467.19406, 5.39501 }, //[2]ZombieSapwn
{ -2809.87866, 402.36572, 4.55877 }, //[3]ZombieSapwn
{ -2793.15845, 502.67728, 6.00260 }, //[4]ZombieSapwn
{ -2979.62622, 477.74866, 5.15996 }, //[5] HumanSpawn
{ -2973.35205, 472.93939, 5.15996 }, //[6] HumanSpawn
{ -2977.87817, 466.60843, 5.15996 }, //[7] HumanSpawn
{ -2979.07617, 472.77151, 5.15996 } //[8] HumanSpawn

};

//Spawns zombies 2,3,4
//Spawns humanos 5,6,7,8
//casablanca ls
new Float:CORESpawns_Zone4[][] =
{
{ 1247.31335, -2055.44751, 58.82911 }, //[0]NUCLEO
{ 1321.4570,-2056.8037,57.6954 }, //[1]Point
{ 1413.4535,-2046.3636,53.8736 }, //[2]ZombieSapwn
{ 1373.2061,-2101.1367,45.6978 }, //[3]ZombieSapwn
{ 1390.2083,-2010.7914,49.1640 }, //[4]ZombieSapwn
{ 1245.7811,-2009.1958,59.8263 }, //[5] HumanSpawn
{ 1248.3510,-2038.0828,59.7577 }, //[6] HumanSpawn
{ 1273.1697,-2028.3542,59.0352 }, //[7] HumanSpawn
{ 1263.8871,-2057.5476,59.3304 } //[8] HumanSpawn

};


//Spawns zombies 2,3,4
//Spawns humanos 5,6,7,8
//puente sf
new Float:CORESpawns_Zone5[][] =
{
{ -1104.78296, -2857.90991, 66.40373 }, //[0]NUCLEO
{ -1043.7487,-2857.6548,67.7149 }, //[1]Point
{ -1002.4178, -2858.6770, 67.3779 }, //[2]ZombieSapwn
{ -962.2674, -2849.4424, 67.7550 }, //[3]ZombieSapwn
{ -921.6115,-2841.5420,69.4557 }, //[4]ZombieSapwn
{ -1189.0126,-2854.1946,67.7607 }, //[5] HumanSpawn
{ -1190.5809,-2869.2336,67.6417 }, //[6] HumanSpawn
{ -1210.1997,-2862.8914,68.1111 }, //[7] HumanSpawn
{ -1165.3936,-2858.9241,67.7188} //[8] HumanSpawn

};



//Spawns zombies 2,3,4
//Spawns humanos 5,6,7,8
//FORTALEZA CAMPO DE SF
new Float:CORESpawns_Zone6[][] =
{
{ -1048.5090,-1197.0626,129.0182 }, //[0]NUCLEO
{ -1049.4990,-1353.5742,130.0311 }, //[1]Point
{ -1037.4821, -1443.1238, 129.4294, }, //[2]ZombieSapwn
{ -1065.2955, -1460.0437, 127.9773 }, //[3]ZombieSapwn
{ -1080.9210, -1443.7048, 128.7955 }, //[4]ZombieSapwn
{ -1060.6658, -1238.3217, 129.2188 }, //[5] HumanSpawn
{ -1037.6475, -1238.1963, 129.3405 }, //[6] HumanSpawn
{ -1043.3208, -1223.4919, 128.9238 }, //[7] HumanSpawn
{ -1053.6849, -1222.8148, 128.8174 } //[8] HumanSpawn

};

//Spawns zombies 2,3,4
//Spawns humanos 5,6,7,8
//fabrica sf
new Float:CORESpawns_Zone7[][] =
{
{ -1039.17676, -608.07648, 31.00873}, //[0]NUCLEO
{ -1039.5389,-575.4630,32.0078 }, //[1]Point
{ -988.0284,-517.4007,27.9754 }, //[2]ZombieSapwn
{ -1037.9998,-484.8179,32.0078 }, //[3]ZombieSapwn
{ -1081.9949,-520.7665,32.0078 }, //[4]ZombieSapwn
{ -1011.3544,-618.3542,32.0078 }, //[5] HumanSpawn
{ -1061.1600,-593.8766,32.0078 }, //[6] HumanSpawn
{ -1044.8141,-614.9644,32.0078 }, //[7] HumanSpawn
{ -1026.7787,-583.1981,32.0078 } //[8] HumanSpawn

};

//Spawns zombies 2,3,4
//Spawns humanos 5,6,7,8
//los santos police departament
new Float:CORESpawns_Zone8[][] =
{
{ 1479.44397, -1640.45740, 13.53314 }, //[0]NUCLEO
{ 1479.7252,-1606.7335,14.0393 }, //[1]Point
{ 1546.0803,-1593.4146,13.3828 }, //[2]ZombieSapwn
{ 1478.9355,-1592.5815,13.3828 }, //[3]ZombieSapwn
{ 1410.9246,-1590.8307,13.3593 }, //[4]ZombieSapwn
{ 1458.1708,-1638.4991,14.0393 }, //[5] HumanSpawn
{ 1505.8140,-1639.0764,14.0469 }, //[6] HumanSpawn
{ 1478.7423,-1656.9662,14.0469 }, //[7] HumanSpawn
{ 1470.6038,-1645.6550,14.1484 } //[8] HumanSpawn

};

//Spawns zombies 2,3,4
//Spawns humanos 5,6,7,8
//los santos hospital
new Float:CORESpawns_Zone9[][] =
{
{ 1198.38867, -1332.53796, 12.39853 }, //[0]NUCLEO
{ 1257.2365,-1333.3191,12.9262 }, //[1]Point
{ 1257.5443,-1403.4891,13.0036 }, //[2]ZombieSapwn
{ 1256.9750,-1277.9089,13.3694 }, //[3]ZombieSapwn
{ 1285.1630,-1332.9055,13.5504 }, //[4]ZombieSapwn
{ 1195.9656,-1367.9504,13.3161 }, //[5] HumanSpawn
{ 1197.5803,-1294.3793,13.3821 }, //[6] HumanSpawn
{ 1181.7170,-1324.5562,13.5833 }, //[7] HumanSpawn
{ 1214.3940,-1304.1785,13.5534 } //[8] HumanSpawn

};

//Spawns zombies 2,3,4
//Spawns humanos 5,6,7,8
//los santos beach
new Float:CORESpawns_Zone10[][] =
{
{ 2916.28027, -1962.45569, -0.32614 }, //[0]NUCLEO
{ 2857.82568, -1963.26001, 11.03525 }, //[1]Point
{ 2857.52759, -2045.27515, 11.03525 }, //[2]ZombieSapwn
{ 2858.02783, -1890.04590, 11.03525 }, //[3]ZombieSapwn
{ 2829.80688, -2002.02856, 11.23173 }, //[4]ZombieSapwn
{ 2871.93774, -1952.30823, 11.33357 }, //[5] HumanSpawn
{ 2872.52710, -1974.91309, 11.33357 }, //[6] HumanSpawn
{ 2889.09033, -1975.78064, 5.68420 }, //[7] HumanSpawn
{ 2890.07251, -1951.02588, 5.68420 } //[8] HumanSpawn

};


#define ADVERTENCIAS_MAXIMAS 3
#define TIEMPO_TENER_HAMBRE 240
#define TIEMPO_MATARDE_HAMBRE 30
//====== GUARDAR ARMAS=====//
new SQLWeaponData[MAX_PLAYERS][13][2];
new SQLVehicle[MAX_VEHICLES];
#define ArmasDeath
// Sistema de Armas en el pisirijillo xD:
#if defined ArmasDeath
#define MAX_DROPPED_WEAPONS 10000 // Limit
new ACTUAL_DROPPED_WEAPONS;
//#define SAVING // Uncomment this line if you want to save dropped guns to restore them after FS restarts
// -----------------------------------------------------------------------------
#define GUN_3DTEXT_DRAW_DISTANCE 10.0
enum dGunEnum
{
	Float:ObjPos[3],
	ObjID,
	ObjData[4],
	Text3D:objLabel
};
new dGunData[MAX_DROPPED_WEAPONS][dGunEnum];
// -----------------------------------------------------------------------------
new GunNames[48][] = {
	"Nothink", "Brass Knuckles", "Golf Club", "Nitestick", "Knife", "Baseball Bat",
	"Showel", "Pool Cue", "Katana", "Chainsaw", "Purple Dildo", "Small White Dildo",
	"Long White Dildo", "Vibrator", "Flowers", "Cane", "Grenade", "Tear Gas", "Molotov",
	"Vehicle Missile", "Hydra Flare", "Jetpack", "Glock", "Silenced Colt", "Desert Eagle",
	"Shotgun", "Sawn Off", "Combat Shotgun", "Micro UZI", "MP5", "AK47", "M4", "Tec9",
	"Rifle", "Sniper Rifle", "Rocket Launcher", "HS Rocket Launcher", "Flamethrower", "Minigun",
	"Satchel Charge", "Detonator", "Spraycan", "Fire Extinguisher", "Camera", "Nightvision",
	"Infrared Vision", "Parachute", "Fake Pistol"
};
// -----------------------------------------------------------------------------
new GunObjects[47] = {
	0,331,333,334,335,336,337,338,339,341,321,322,323,324,325,326,342,343,344,
	0,0,0,346,347,348,349,350,351,352,353,355,356,372,357,358,359,360,361,362,
	363,364,365,366,367,368,368,371
};
// -----------------------------------------------------------------------------
#endif

new ZS_Tick[MAX_PLAYERS];
//================================================ NOMBRE DE LOS VEHICULOS! ==================================================================
new VehicleNames[212][] = {
	"Landstalker","Bravura","Buffalo","Linerunner","Pereniel","Sentinel","Dumper","Firetruck","Trashmaster","Stretch","Manana","Infernus",
	"Voodoo","Pony","Mule","Cheetah","Ambulance","Leviathan","Moonbeam","Esperanto","Taxi","Washington","Bobcat","Mr Whoopee","BF Injection",
	"Hunter","Premier","Enforcer","Securicar","Banshee","Predator","Bus","Rhino","Barracks","Hotknife","Trailer","Previon","Coach","Cabbie",
	"Stallion","Rumpo","RC Bandit","Romero","Packer","Monster","Admiral","Squalo","Seasparrow","Pizzaboy","Tram","Trailer","Turismo","Speeder",
	"Reefer","Tropic","Flatbed","Yankee","Caddy","Solair","Berkley's RC Van","Skimmer","PCJ-600","Faggio","Freeway","RC Baron","RC Raider",
	"Glendale","Oceanic","Sanchez","Sparrow","Patriot","Quad","Coastguard","Dinghy","Hermes","Sabre","Rustler","ZR3 50","Walton","Regina",
	"Comet","BMX","Burrito","Camper","Marquis","Baggage","Dozer","Maverick","News Chopper","Rancher","FBI Rancher","Virgo","Greenwood",
	"Jetmax","Hotring","Sandking","Blista Compact","Police Maverick","Boxville","Benson","Mesa","RC Goblin","Hotring Racer A","Hotring Racer B",
	"Bloodring Banger","Rancher","Super GT","Elegant","Journey","Bike","Mountain Bike","Beagle","Cropdust","Stunt","Tanker","RoadTrain",
	"Nebula","Majestic","Buccaneer","Shamal","Hydra","FCR-900","NRG-500","HPV1000","Cement Truck","Tow Truck","Fortune","Cadrona","FBI Truck",
	"Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight","Streak","Vortex","Vincent","Bullet","Clover",
	"Sadler","Firetruck","Hustler","Intruder","Primo","Cargobob","Tampa","Sunrise","Merit","Utility","Nevada","Yosemite","Windsor","Monster A",
	"Monster B","Uranus","Jester","Sultan","Stratum","Elegy","Raindance","RC Tiger","Flash","Tahoma","Savanna","Bandito","Freight","Trailer",
	"Kart","Mower","Duneride","Sweeper","Broadway","Tornado","AT-400","DFT-30","Huntley","Stafford","BF-400","Newsvan","Tug","Trailer A","Emperor",
	"Wayfarer","Euros","Hotdog","Club","Trailer B","Trailer C","Andromada","Dodo","RC Cam","Launch","Police Car (LSPD)","Police Car (SFPD)",
	"Police Car (LVPD)","Police Ranger","Picador","S.W.A.T. Van","Alpha","Phoenix","Glendale","Sadler","Luggage Trailer A","Luggage Trailer B",
	"Stair Trailer","Boxville","Farm Plow","Utility Trailer"
};
//==============================================================================
// Defines - Equipos del Gamemode.
//==============================================================================
#define Zombie 0
#define Humano 1
#define KEY_AIMING     (128)
//==============================================================================
// Defines - Colores del Gamemode.
//==============================================================================
#define COL_WHITE "{FFFFFF}"
#define COL_VIOLET "{FF33FF}"
#define COL_CMDS "{FFCC00}"
#define COL_GB_LIGHT "{00ADAB}"


#define verde 0x00A200FF
#define COLOR_ARTICULO 0xFF0099AA
#define COLOR_CMDS "FF3366"
#define COLOR_DE_ERROR_EX "00C4EB"
#define COLOR_DE_ERROR 0x00C4EBAA
#define COLOR_RANDOM 0xFFB300AA
#define blue 0xFF3DD8FF
#define red 0xFF000000
#define COLOR_RED 0xFF000000
#define yellow 0xFFFF00AA
#define ADMIN_COLOR 0x99BBFFAA
#define ADMIN_CHAT_COLOR 0xFFB300//anterior: FFB300
#define AYUDANTE_COLOR 0xD4D4D4AA
#define green 0x33FF33AA
#define CHAT_COLOR 0xC9C9C9AA
#define HUMANO_COL "{B3D9FF}"
#define HUMANO_COLOR 0xB3D9FF00
#define ZOMBIE_COLOR 0x99999900
#define ZOMBIE_COLOR_VISIBLE 0x999999FF
#define BOT_ZOMBIE_COLOR 0x99999900
#define BOT_ZOMBIE_COLOR_CORE 0xFFFF66FF
#define VIP_COLOR 0x0000FFAA
#define COLOR_BLANCO 0xFFFFFFAA
#define COLOR_AZUL 0x004FD8F6
#define azul 0x004FD8F6
#define COLOR_AMARILLO 0xF6F600FF
#define COLOR_YELLOW 0xF6F600F6
#define COLOR_VERDE 0x33AA33AA
#define COLOR_GRIS 0xAFAFAFAA
#define COLOR_VERDE_CLARO 0x00FF00AA
#define COLOR_PIEL 0xFFCC99AA

#define Agua 0x63AFF00A
#define AguaMarina 0x0FFDD349
#define Amarillo 0xFFFF00FF
#define Azul 0x375FFFFF
#define Invisible 0xFFFFFF00
#define AzulClaro 0x00C2ECFF
#define Blanco 0xFFFFFFAA
#define Celeste 0x33CCFFAA
#define Cyan 0x00FFFFFF
#define Gris 0xEEEEFFC4
#define Marron 0xA52A2AAA
#define Morado 0x9955DEEE
#define Naranja 0xF97804FF
#define Negro 0x00000000
#define Piel 0xFF99AADD
#define Plomo 0xAFAFAFAA
#define Purpura 0xFF66FFAA
#define Rojo 0xFF000000
#define RojoClaro 0xFF8080FF
#define RojoOscuro 0xFB0000FF
#define Verde 0x21DD00FF
#define VerdeClaro 0x38FF06FF
#define VerdeOscuro 0x008040FF
#define COLOR_ROJO 0xff001bff

#define COLOR_FADE1 0xFFFFFFFF
#define COLOR_FADE2 0xC8C8C8C8
#define COLOR_FADE3 0xAAAAAAAA
#define COLOR_FADE4 0x8C8C8C8C
#define COLOR_FADE5 0x6E6E6E6E
#define COLOR_WHITE  0xFFFFFFFF

#define COLOR_GREEN 0x339900AA
#define SPECIAL_ACTION_PISSING      68
//==============================================================================
// Variables anti weapon hack.
//==============================================================================

// advertencias maximas para que el anti cheat kicke al cheto :3
#define MAX_HW_WARNINGS 3
//---
//#define VOTE_KICK_SYSTEM
//---
#if defined VOTE_KICK_SYSTEM
//==============================================================================
// Variables vote kick by soknifedev xd
//==============================================================================
#define VOTOS_PARA_KICK 3 // 3 PLAYERS VOTAN = KICK AL CHETO
#define TIEMPO_KICK 60 // 1 minuto xD
new AntiVoteKickFlood; // Variable Global =P
new VoteKickFlood[MAX_PLAYERS];
new Votos_KICK[MAX_PLAYERS];// VARIABLE QUE CONTENDRA LOS VOTOS DE LOS DE MAS XD.
new RAZON_KICK[MAX_PLAYERS][600];// Necesario para guardarlo en un log :O XD
new Voto[MAX_PLAYERS]; // Para evitar el flood de votos :P
new VTK_NAME[MAX_PLAYERS][34];
#endif
//==============================================================================
// Forwards.
//==============================================================================
forward SetupPlayerForClassSelection(playerid);
forward Float:GetDistanceBetweenPlayers(P1, P2);
forward Float:GetZDiferenceBetween(npcid, playerid);
forward GetClosestPlayer(P1);
forward GetClosestPlayerForDrone(P1);
forward GetClosestPlayerBOT(P1);
forward ObtenerBOTCercano(P1);
forward ObtenerBOTCercanoForDrone(P1);
//forward SonidoFondo();
//==============================================================================
// Variables.
//==============================================================================
forward GetClosestPlayerBOT(P1);

#define PRESSED(%0) \
    (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define PUBLIC:%0(%1)	forward %0(%1); \
					public %0(%1)

new ZOMBIES_SPAWN_TIME, ZOMBIES_SPAWN_LIMIT;


#define DEFAULT_ZOMBIE_SPAWN_DISTANCE 70.0
#define DEFAULT_ZOMBIE_VISION_DISTANCE 120.0
new Float:ZombieSpawnerDistance;
new Float:ZombieVisionDistance;

//Calcular un circulo alrededor de las coordenadas X,Y, y de ese circulo obtener una posición basado en el angulo y el offset con cierta distancia.
stock NextCirclePosition(Float:x, Float:y, Float:offset, &Float:nx, &Float:ny, &Float:angle, Float:radius)
{
	nx = x + radius * floatcos(angle, degrees );
	ny = y + radius * floatsin(angle, degrees );
	angle += offset;
}

//=============== SISTEMA DE NPC ====================
new NPC_Walking_Style[MAX_PLAYERS][256];
new NPC_Walking_Library[MAX_PLAYERS][256];
#define HEALTH_LLENA "{FF0000}" //rojo claro
#define HEALTH_VACIA "{990000}" //rojo oscuro
#define ARMOUR_LLENA "{FFFFFF}" //blanco
#define ARMOUR_VACIA "{8F8B91}" //gris oscuro
#define DISTANCE_BARRA 30.0
//==============================================================================
// Sistema de misiones
//==============================================================================
#include <RZ_missions>
//==============================================================================
// Sistema de combustible
//==============================================================================
#if defined SistemaDECombustible
#include <progress3>
new Text:Vehiculo[MAX_PLAYERS],
Text:Velocidad[MAX_PLAYERS],
Text:Espacio[MAX_PLAYERS],
Text:Espacio2[MAX_PLAYERS],
Text:Gasolina[MAX_PLAYERS],
Text:Espacio3[MAX_PLAYERS],
Text:Espacio4[MAX_PLAYERS],
Text:Estado[MAX_PLAYERS],
Text:Espacio5[MAX_PLAYERS],
Text:Espacio6[MAX_PLAYERS],
Text:Espacio7[MAX_PLAYERS],
PlayerBar:Velocidadbar[MAX_PLAYERS],
PlayerBar:Gasolinabar[MAX_PLAYERS],
PlayerBar:Estadobar[MAX_PLAYERS],
TimerVelocidad,
Gas[MAX_VEHICLES],
GasBajo,
Rellenando[MAX_PLAYERS] = 0,
RellenoTimer[MAX_PLAYERS];
forward GasolinaBaja();
forward TiempoRelleno(playerid,gCantidad);
new Vehicles[][] =
{
	"Landstalker","Bravura","Buffalo","Linerunner","Pereniel","Sentinel","Dumper","Firetruck","Trashmaster",
	"Stretch","Manana","Infernus","Voodoo","Pony","Mule","Cheetah","Ambulance","Leviathan","Moonbeam","Esperanto",
	"Taxi","Washington","Bobcat","Mr Whoopee","BF Injection","Hunter","Premier","Enforcer","Securicar","Banshee",
	"Predator","Bus","Rhino","Barracks","Hotknife","Trailer","Previon","Coach","Cabbie","Stallion","Rumpo",
	"RC Bandit","Romero","Packer","Monster","Admiral","Squalo","Seasparrow","Pizzaboy","Tram","Trailer",
	"Turismo","Speeder","Reefer","Tropic","Flatbed","Yankee","Caddy","Solair","Berkley's RC Van","Skimmer",
	"PCJ-600","Faggio","Freeway","RC Baron","RC Raider","Glendale","Oceanic","Sanchez","Sparrow","Patriot",
	"Quad","Coastguard","Dinghy","Hermes","Sabre","Rustler","ZR3 50","Walton","Regina","Comet","BMX",
	"Burrito","Camper","Marquis","Baggage","Dozer","Maverick","News Chopper","Rancher","FBI Rancher","Virgo",
	"Greenwood","Jetmax","Hotring","Sandking","Blista Compact","Police Maverick","Boxville","Benson","Mesa",
	"RC Goblin","Hotring Racer A","Hotring Racer B","Bloodring Banger","Rancher","Super GT","Elegant",
	"Journey","Bike","Mountain Bike","Beagle","Cropdust","Stunt","Tanker","RoadTrain","Nebula","Majestic",
	"Buccaneer","Shamal","Hydra","FCR-900","NRG-500","HPV1000","Cement Truck","Tow Truck","Fortune","Cadrona",
	"FBI Truck","Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight",
	"Streak","Vortex","Vincent","Bullet","Clover","Sadler","Firetruck","Hustler","Intruder","Primo","Cargobob",
	"Tampa","Sunrise","Merit","Utility","Nevada","Yosemite","Windsor","Monster A","Monster B","Uranus",
	"Jester","Sultan","Stratum","Elegy","Raindance","RC Tiger","Flash","Tahoma","Savanna","Bandito","Freight",

	"Trailer","Kart","Mower","Duneride","Sweeper","Broadway","Tornado","AT-400","DFT-30","Huntley","Stafford",
	"BF-400","Newsvan","Tug","Trailer A","Emperor","Wayfarer","Euros","Hotdog","Club","Trailer B","Trailer C",
	"Andromada","Dodo","RC Cam","Launch","Policia LV","Policia SF","Policia LS)","Police Ranger",
	"Picador","S.W.A.T. Van","Alpha","Phoenix","Glendale","Sadler","Luggage Trailer A","Luggage Trailer B",
	"Stair Trailer","Boxville","Farm Plow","Utility Trailer"
};
#endif
#pragma tabsize 0
stock PlayerName2(playerid) {
  new name[MAX_PLAYER_NAME];
  GetPlayerName(playerid, name, sizeof(name));
  return name;
}
stock IsDroneBOT(playerid)
{
    if(!IsPlayerNPC(playerid)) return 0;
    else if(strfind(PlayerName2(playerid), "[DRONE]", true) != -1) return 1;
    else return 0;
}

stock IsZombieNPC(playerid)
{
	if(!IsPlayerNPC(playerid)) return 0;
	else if(IsDroneBOT(playerid)) return 0;
	else return 1;
}
stock DB_Escape(text[])
{
    new
        ret[80 * 2],
        ch,
        i,
        j;
    while ((ch = text[i++]) && j < sizeof (ret))
    {
        if (ch == '\'')
        {
            if (j < sizeof (ret) - 2)
            {
                ret[j++] = '\'';
                ret[j++] = '\'';
            }
        }
        else if (j < sizeof (ret))
        {
            ret[j++] = ch;
        }
        else
        {
            j++;
        }
    }
    ret[sizeof (ret) - 1] = '\0';
    return ret;
}



//=============== SISTEMA DE NPC ====================
forward Float:GetNPCHealth(npcid);

new Text3D:VehicleLabel[MAX_VEHICLES];
enum DatosNPC
{
        Float:VIDA,
        Text3D:NickLabel,
        LastKiller,
        LastAttacker,
		Attacking,
		LastFinded,
		ByWeapon,
		NAME[40],
		BType,
		InCORE,
		//CoreStep,
		SeekerTick,
		NPCVehicleID,
		DRONE_MAX_OWNER_DISTANCE,
		DRONE_MAX_ATTACK_DISTANCE,
		DRONE_MIN_ATTACK_DISTANCE,
		DRONE_MAX_ATTACK_HIT,
		DRONE_MIN_ATTACK_HIT
};
new NPC_INFO[MAX_PLAYERS][DatosNPC];


stock IsValidWeapon(weaponid)
{
    if (weaponid > 0 && weaponid < 19 || weaponid > 21 && weaponid < 47) return 1;
    return 0;
}

public OnPlayerPause(playerid)
{
	#if defined USE_SOBEIT_CAMERA_DETECTION
	if(PlayerInfo[playerid][SC_Anim] == 1)
	{
	    printf("[SOBEIT]: %s ha sido expulsado por pausarse en la verificación.",PlayerName2(playerid));
		SendFormatDialog(playerid,"{ffffff}<-- {f50000}Anti Cheat {ffffff}-->","{B366FF}%s, Parece que estas desincronizado, fuiste expulsado del servidor, entra nuevamente. #Paused?",PlayerName2(playerid));
	    Kick(playerid);
	}
	#endif
}

public OnGameModeExit()
{
        SendRconCommand("password exiting..");
        //mysql_close();f
        if(ConexionSQL == 1){
	   	for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i)) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0);
				CallLocalFunction("OnPlayerCommandText", "is", i, "/gc");
			}
			if(IsDroneBOT(i))
			{
			    if(NPC_INFO[i][NPCVehicleID] >= 1 && NPC_INFO[i][NPCVehicleID] != INVALID_VEHICLE_ID)
			    {
			    	DestroyVehicle(NPC_INFO[i][NPCVehicleID]);
			    }
			}
		}
		SaveSQLCars();
		#if defined SAVING
		SaveSQLDroppedWeapons();
		#endif
		}

        for (new i=0; i < GetMaxPlayers(); i++) {
        		if(IsPlayerConnected(i)) {
                SetPVarInt(i, "laser", 0);
                RemovePlayerAttachedObject(i, 0);
                }
        }
        #if defined SistemaDECombustible
		KillTimer(TimerVelocidad);
		KillTimer(GasBajo);
		#endif
		//------------------------
		KillTimer(Timer_Anuncios);
	    db_close(DataBase_USERS);
		return 1;
}

stock rztickcount()
{
    new time = gettime();
    return time;
}

stock GetTickDiff(newtick, oldtick)
{
	if (oldtick < 0 && newtick >= 0) {
		return newtick - oldtick;
	} else if (oldtick >= 0 && newtick < 0 || oldtick > newtick) {
		return (cellmax - oldtick + 1) - (cellmin - newtick);
	}
	return newtick - oldtick;
}

stock IsCoreInSafeTime()
{
	new Hour, Minute, Second;
	gettime(Hour, Minute, Second);
	if(Hour >= 1 && Hour <= 8) return false;//entre la hora 1 y la hora 8 no se permite jugar al nucleo.CreateActor
    else return true;
}




stock ConectarDB()
{
        SendRconCommand("hostname Zombie Attack NPC BOTS - Iniciando..");
		ConexionSQL = 1;
		#if defined VOTE_KICK_SYSTEM
		AntiVoteKickFlood = rztickcount();
		#endif
		SendRconCommand("hostname Zombie Attack Survival | NPC Zombies");
		SendRconCommand("password 0");
		SendRconCommand("messageholelimit 10000");
		SendRconCommand("ackslimit 10000");
		SendRconCommand("weburl www.facebook.com/groups/revolutionzombie/");
		SetTimer("RespawnBOTS",2000, 0);//respawn a todos!
		return 1;
}

PUBLIC:RespawnBOTS()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && IsZombieNPC(i) && !IsDroneBOT(i) && NPC_INFO[i][InCORE] == 0)
		{
		SetPlayerVirtualWorld(i,0);
		FCNPC_SetPosition(i, NULL_X, NULL_Y, NULL_Z);
		//KillTimer(Attack[i]);
		RespawnearBOT(i);
		}
	}
	return 1;
}

stock CreateExplosionForEnemies(playerid, Float:X, Float:Y, Float:Z, type, Float:Radius, excluido=INVALID_PLAYER_ID)
{
    for(new enemy=0;enemy< GetMaxPlayers();enemy++)
    {
        if(IsPlayerConnected(enemy) && enemy != excluido)
        {
            if(PlayerInfo[playerid][CLAN] == 1 && PlayerInfo[enemy][CLAN] == 1)
            {
                if(!IsPlayerOfMyClan(playerid,enemy))
                {
					CreateExplosionForPlayer(enemy,X, Y, Z, type, Radius);
                }
            }
			else if(GetPlayerTeam(playerid) != GetPlayerTeam(enemy) && !IsPlayerNPC(enemy))
			{
				CreateExplosionForPlayer(enemy,X, Y, Z, type, Radius);
			}
		}
    }
}

stock Float:GetDistanceBetweenPlayerActor(playerid, actorid)
{
new Float:X1, Float:Y1, Float:Z1, Float:X2, Float:Y2, Float:Z2;
if(!IsPlayerConnected(playerid)) return -1.00;
GetPlayerPos(playerid, X1, Y1, Z1);
GetActorPos(actorid, X2, Y2, Z2);
return floatsqroot(floatpower(floatabs(floatsub(X2, X1)), 2)+floatpower(floatabs(floatsub(Y2, Y1)), 2)+floatpower(floatabs(floatsub(Z2, Z1)), 2));
}

stock GetClosestActor(playerid)
{
	new X, Float:Dis, Float:Dis2, Player;
	Player = INVALID_PLAYER_ID;
	Dis = 99999.99;
	for (X=0; X<MAX_ACTORS; X++)
	{
		if(IsValidActor(X))
		{
			Dis2 = GetDistanceBetweenPlayerActor(playerid,X);
			if(Dis2 < Dis && Dis2 != -1.00)
			{
				Dis = Dis2;
				Player = X;
			}
		}
	}
	return Player;
}

stock IsPlayerNearDealer(playerid)
{
	new actorid = GetClosestActor(playerid);
	if(actorid == INVALID_PLAYER_ID) return 0;
	if(IsPlayerInRangeOfActor(playerid, actorid, 10)) return 1;
	else return 0;
}

stock IsPlayerInRangeOfActor(playerid, actorid, Float:range)
{
	new Float:x, Float:y, Float:z;
	GetActorPos(actorid, x, y, z);
	if(IsPlayerInRangeOfPoint(playerid, range, x, y, z))return 1;
	else return 0;
}
stock IsPlayerInRangeOfPlayer(playerid, playerid2, Float:range)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid2, x, y, z);
	if(IsPlayerInRangeOfPoint(playerid, range, x, y, z))return 1;
	else return 0;
}
stock IsFCNPCInRangeOfPlayer(playerid, playerid2, Float:range)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid2, x, y, z);
	if(IsPlayerInRangeOfPoint(playerid, range, x, y, z))return 1;
	else return 0;
}


stock IsPlayerNearDynamicDoor(playerid, rejaID, Float:distancia)
{
    if(rejaID == XMasDomo)
	{
    	return IsPlayerInRangeOfPoint(playerid, distancia, -8.3337,1482.2416,12.7500);
    }
    else
    {
		new Float:x, Float:y, Float:z;
		GetObjectPos(rejaID, x, y, z);
		if(IsPlayerInRangeOfPoint(playerid, distancia, x, y, z))
		{
		    /*if(rejaID == XMasDomo){
			printf("[H:DEBUG]:SI:: PlayerId %d, ObjectId %d, %f",playerid,rejaID,x,y,z,ddis);}*/
			return 1;
		}
		else
		{
		    /*if(rejaID == XMasDomo){
			printf("[H:DEBUG]:NO:: PlayerId %d, ObjectId %d, %f",playerid,rejaID,x,y,z,ddis);}*/
			return 0;
		}
	}
}


stock CheckPlayerUmbrellaDoors(playerid)
{
    new string[256];
 	if(IsPlayerNearDynamicDoor(playerid,XMasDomo,150.0) && IsPlayerAdmin(playerid))
	{
		if(ObjectInfo[XMasDomo][ACTIVADO] == 1)
		{
			MoveObject(XMasDomo, 5.11791, 1531.43982, 5.24879, 10.0);
			ObjectInfo[XMasDomo][ACTIVADO] = 0;
			GameTextForPlayer(playerid, "~n~~r~DOMO CERRADO", 4000, 3);
		}
		else
		{
			ObjectInfo[XMasDomo][ACTIVADO] = 1;
			MoveObject(XMasDomo, 5.11791, 1531.43982, 11.74002, 2.0);
			GameTextForPlayer(playerid, "~n~~w~DOMO ABIERTO", 4000, 3);
	    }
    }
	return 1;
}


stock EsMujer(skinid)
{
        switch(skinid)
        {
                case 9 .. 13,31,39 .. 41, 53 .. 56,63 .. 65,69,75 .. 77,85,87 .. 93,129 .. 131,138 .. 141,145,148,150 .. 152,157,169,172,178,190 .. 201,205,207,211,214 .. 216,218,219,224 .. 226,231 .. 233,237,238,243 .. 246,251,256,257,263,298: return 1;
                default: return 0;
        }
        return 0;
}
stock getZombieTarget(playerid)
{
	if(NPC_INFO[playerid][InCORE])
	{
		new ZTarget = NPC_INFO[playerid][LastFinded];
		if(ZTarget != INVALID_PLAYER_ID && gTeam[ZTarget] == Humano && PlayerInfo[ZTarget][AntiZombie] == 0 && PlayerInfo[ZTarget][InCORE] == 1
		&& IsPlayerInRangeOfPlayer(playerid,ZTarget, ZombieVisionDistance) && !IsPlayerDead(ZTarget) && IsPlayerNPC(playerid) &&
		GetPlayerState(ZTarget) != PLAYER_STATE_SPECTATING && GetPlayerState(ZTarget) != PLAYER_STATE_WASTED && PlayerInfo[ZTarget][MusicInicio] == 0 &&
		GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(ZTarget))
		return ZTarget;
	 	else return GetClosestPlayerBOT(playerid);
	}
	else{
		new ZTarget = NPC_INFO[playerid][LastFinded];
		if(ZTarget != INVALID_PLAYER_ID && gTeam[ZTarget] == Humano && PlayerInfo[ZTarget][AntiZombie] == 0
		&& IsPlayerInRangeOfPlayer(playerid,ZTarget, ZombieVisionDistance) && !IsPlayerDead(ZTarget) && IsPlayerNPC(playerid) &&
		GetPlayerState(ZTarget) != PLAYER_STATE_SPECTATING && GetPlayerState(ZTarget) != PLAYER_STATE_WASTED && PlayerInfo[ZTarget][MusicInicio] == 0 &&
		GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(ZTarget))
		return ZTarget;
	 	else return GetClosestPlayerBOT(playerid);
	}

}

stock SetPlayerFacingPlayer(playerid, facingid)
{
	new Float:Px, Float:Py, Float: Pa;
	new Float:x,Float:y,Float:z;
	GetPlayerPos(facingid,x,y,z);
	#pragma unused z
	GetPlayerPos(playerid, Px, Py, Pa);
	Pa = floatabs(atan((y-Py)/(x-Px)));
	if (x <= Px && y >= Py) Pa = floatsub(180, Pa);
	else if (x < Px && y < Py) Pa = floatadd(Pa, 180);
	else if (x >= Px && y <= Py) Pa = floatsub(360.0, Pa);
	Pa = floatsub(Pa, 90.0);
	if (Pa >= 360.0) Pa = floatsub(Pa, 360.0);
	return SetPlayerFacingAngle(playerid, Pa);
}

stock SetFCNPCFacingPlayer(playerid, facingid)
{
	new Float:Px, Float:Py, Float: Pa;
	new Float:x,Float:y,Float:z;
	GetPlayerPos(facingid,x,y,z);
	#pragma unused z
	FCNPC_GetPosition(playerid, Px, Py, Pa);
	Pa = floatabs(atan((y-Py)/(x-Px)));
	if (x <= Px && y >= Py) Pa = floatsub(180, Pa);
	else if (x < Px && y < Py) Pa = floatadd(Pa, 180);
	else if (x >= Px && y <= Py) Pa = floatsub(360.0, Pa);
	Pa = floatsub(Pa, 90.0);
	if (Pa >= 360.0) Pa = floatsub(Pa, 360.0);
	return FCNPC_SetAngle(playerid, Pa);
}

stock SetFCNPCFacingXY(playerid, Float:x,Float:y)
{
	new Float:Px, Float:Py, Float: Pa;
	FCNPC_GetPosition(playerid, Px, Py, Pa);
	Pa = floatabs(atan((y-Py)/(x-Px)));
	if (x <= Px && y >= Py) Pa = floatsub(180, Pa);
	else if (x < Px && y < Py) Pa = floatadd(Pa, 180);
	else if (x >= Px && y <= Py) Pa = floatsub(360.0, Pa);
	Pa = floatsub(Pa, 90.0);
	if (Pa >= 360.0) Pa = floatsub(Pa, 360.0);
	return FCNPC_SetAngle(playerid, Pa);
}

stock IsPlayerIDLE(playerid)
{
	new animlib[32],animname[32];
	GetAnimationName(GetPlayerAnimationIndex(playerid),animlib,sizeof(animlib),animname,sizeof(animname));
	if(!strcmp("IDLE_STANCE", animname, false)) return true;
	else return false;
}

public RZClient_OnClientDisconnect(playerid,version[])
{
    SendClientMessage(playerid,red,"********");
	SendClientMessage(playerid,red,">] RZCLIENT [< {ffffff}La conexión con el servidor se ha perdido.");
	SendClientMessage(playerid,red,"********");
	PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	return 1;
}

public RZClient_OnClientConnect(playerid,version[])
{
    SendClientMessage(playerid,red,"********");
	SendClientMessage(playerid,red,">] RZCLIENT [< {ffffff}Te has conectado con el el cliente oficial del servidor, bonus activado.");
	SendClientMessage(playerid,red,"********");
	PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	RZClient_checkFile(playerid, "d3d9.dll");
	RZClient_checkFile(playerid, "DSOUND.dll");
	RZClient_TransferPack(playerid);
	return 1;
}

public RZClient_OnFileChecked(playerid, exists, file[])
{
	if(StringMismatch(file, "d3d9.dll") && exists == 1)
	{
		new string[256];
		format(string,sizeof(string), "{4DFFFF}**{FFFFFF} RZClient {4DFFFF}ha [B]aneado a {FFFFFF}%s {BBC1C1}[Razon: RZClient Modificado (%s) ]",PlayerName2(playerid),file);
		SendClientMessageToAll(0xFFFF00FF, string);
		new PlayerIP[128];
		GetPlayerIp(playerid,PlayerIP,sizeof(PlayerIP));
		printf("[BAN]: %s[%d] IP: %d ha sido baneado por Archivo Malicioso: %s.",PlayerName2(playerid),playerid,PlayerIP,file);
		BanSQL(playerid,INVALID_PLAYER_ID,"RZClient Modificado (archivo malicioso)"); // Banear By AntiCheat
	}
	if(StringMismatch(file, "DSOUND.dll") && exists == 1)
	{
		new string[256];
		format(string,sizeof(string), "{4DFFFF}**{FFFFFF} RZClient {4DFFFF}ha [B]aneado a {FFFFFF}%s {BBC1C1}[Razon: RZClient Modificado (%s) ]",PlayerName2(playerid),file);
		SendClientMessageToAll(0xFFFF00FF, string);
		new PlayerIP[128];
		GetPlayerIp(playerid,PlayerIP,sizeof(PlayerIP));
		printf("[BAN]: %s[%d] IP: %d ha sido baneado por Archivo Malicioso: %s.",PlayerName2(playerid),playerid,PlayerIP,file);
		BanSQL(playerid,INVALID_PLAYER_ID,"RZClient Modificado (archivo malicioso)"); // Banear By AntiCheat
	}
	return 1;
}



public RZClient_OnFilesGEtted(playerid, returnto, files[], directory[])
{
	//SendFormatMessage(returnto,0x0FFFF66FF,"<!> %s [%d] {ffffff}FIle (%s): {FF33CC}%s",PlayerName2(playerid),playerid,directory,files);
	new CMDS[2500];
	if(strlen(files) > 2500) return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFFF00}* Scanner", "Demaciados archivos en el directorio.", "x", "");
	//format(directory,sizeof(directory), "\t{4DFFFF}** Escanear Directorio de %s [ID: %d] {FFFFFF} %s\n\n",PlayerName2(playerid),playerid,directory);
	strcat(CMDS,files);
	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFFF00}* Scanner", CMDS, "x", "");
	return 1;
}
/*
public RZC_OnPlayerProcessReceived(playerid, returnto, process[])
{
	SendFormatMessage(returnto, 0x0FFFF66FF, "<!> %s [%d] {ffffff}Running: {FF33CC}%s",PlayerName2(playerid),playerid,process);
	return 1;
}
*/
public RZClient_OnTransferFile(playerid, file[], current, total, result)
{
	new string[256];
	switch (result)
	{
		case 0: format(string, sizeof(string), "[RZClient] {ffffff}\"%s\" (%d de %d) se descargo exitosamente (Player ID: %d)", file, current, total, playerid) && SendClientMessage(playerid, COLOR_DE_ERROR, string);
		case 1: format(string, sizeof(string), "[RZClient] {ffffff}\"%s\" (%d de %d) se descargo exitosamente (r) (Player ID: %d)", file, current, total, playerid) && SendClientMessage(playerid, COLOR_DE_ERROR, string);
		//case 2: format(string, sizeof(string), "El audio \"%s\" (%d de %d) se encuentra en buen estado, saltando...", file, current, total);
		case 3: format(string, sizeof(string), "[RZClient] {f50000}ERROR: {ffffff}El audio \"%s\" (%d de %d) no se puede descargar/verificar (Player ID: %d)", file, current, total, playerid) && SendClientMessage(playerid, COLOR_DE_ERROR, string);
	}
	return 1;
}

stock IsHumanStreamedInFrom(playerid,victimID)
{
	if(playerid == INVALID_PLAYER_ID || victimID == INVALID_PLAYER_ID) return 0;
	if(PlayerInfo[victimID][ZonaSegura] == 1 /* && NPC_INFO[playerid][Attacking] != victimID*/) return 0;
	if(
	gTeam[victimID] == Humano &&
	PlayerInfo[victimID][AntiZombie] == 0 &&
	IsPlayerInRangeOfPlayer(victimID,playerid, ZombieVisionDistance) &&
	!IsPlayerDead(victimID) &&
	IsPlayerNPC(playerid) &&
	GetPlayerState(victimID) != PLAYER_STATE_SPECTATING &&
	PlayerInfo[victimID][MusicInicio] == 0 &&
	!IsPlayerPaused(victimID) &&
	GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(victimID) &&
	PlayerInfo[victimID][SpawnProtection] == 0) return 1;
	else return 0;
}


stock IsHumanStreamedInFromEx(playerid, humanid, Float:x, Float:y, Float:z, Float:hx, Float:hy, Float: hz, Float:range=40.0)
{
	if(playerid == INVALID_PLAYER_ID || humanid == INVALID_PLAYER_ID) return 0;
	if
	(
	gTeam[humanid] == Humano &&
	GetDistanceBetweenPositions(x,y,z, hx, hy, hz) <= range &&
	!IsPlayerDead(humanid) &&
	GetPlayerState(humanid) != PLAYER_STATE_SPECTATING &&
	PlayerInfo[humanid][MusicInicio] == 0 &&
	//!IsPlayerPaused(humanid) &&
	GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(humanid)) return 1;
	else return 0;
}

stock IsBike(id)
{
	if(id == 509 || id == 481 || id == 510) return 1;
	else return 0;

}

stock GetDriverId(vehicleid)
{
    for(new i = 0; i < GetMaxPlayers(); i++) //Loops through all players
    {
        if(GetPlayerVehicleID(i) == vehicleid && GetPlayerState(i) == PLAYER_STATE_DRIVER) return i; //Returns playerid if the player is in the vehicleid provided AND is the driver
    }
    return 1;
}





stock MoveNPC(npcid, Float:X, Float:Y, Float:Z, type, Float:speed, bool:UseZMap = true) return FCNPC_GoTo(npcid, X, Y, Z, type, speed, UseZMap);


stock MoveNPCAttack(npcid, Float:X, Float:Y, Float:Z, type, Float:speed, bool:UseZMap = false)
{
	FCNPC_AimAt(npcid,  X, Y, Z - random(3), true);
	return FCNPC_GoTo(npcid, X, Y, Z, type, speed, UseZMap, 10, UseZMap);
}

/*
public FCNPC_OnReachDestination(npcid)
{
	if(NPC_INFO[npcid][InCORE] == 1 && HumanCore[STATE] == CORE_FIGHTING)
	{
		//si el step es 0, mover las nalgas al nucleo, osea 1.
		if(NPC_INFO[npcid][CoreStep] == 0)
		{
		    //printf("[REACH]: %d CoreStep %d", NPC_INFO[npcid][CoreStep]);
			NPC_INFO[npcid][CoreStep] = 1;//mover las nalgas al nucleo xdd
		}
		if(NPC_INFO[npcid][CoreStep] == 1)//atanganaa llego.
		{
		    NPC_INFO[npcid][CoreStep] = 0;
		    RespawnearBOT(npcid);
		    CreateCoreExplosion();
		    HumanCore[CURRENT_ESCAPES] += 1;
		    new roundstr[256];
		    format(roundstr, sizeof(roundstr), "~n~~n~~n~~n~~r~~H~~H~UN ZOMBIE LLEGO AL NUCLEO!~N~~W~ESCAPES ~Y~%d~W~/~R~%d",HumanCore[CURRENT_ESCAPES],HumanCore[MAX_ESCAPES]);
	     	GameTextForCoreFighters(roundstr,5000);
		    UpdateCoreRoundStatus();
		}
	}
	else
	{
	    NPC_INFO[npcid][InCORE] = 0;
	    NPC_INFO[npcid][CoreStep] = 0;
	}
}
*/

public FCNPC_OnFinishMovePathPoint(npcid, pathid, pointid)
{
	//printf("FCNPC_OnFinishMovePathPoint(npcid = %d, pathid = %d, pointid = %d)", npcid, pathid, pointid);
	if(NPC_INFO[npcid][InCORE] == 1 && HumanCore[STATE] == CORE_FIGHTING)
	{
		if(pointid == 1)//atanganaa llego.
		{
			FCNPC_DestroyMovePath(pathid);
		    RespawnearBOT(npcid);
		    CreateCoreExplosion();
		    HumanCore[CURRENT_ESCAPES] = HumanCore[CURRENT_ESCAPES] + 1;
		    new roundstr[256];
		    format(roundstr, sizeof(roundstr), "~n~~n~~n~~n~~r~~H~~H~UN ZOMBIE LLEGO AL NUCLEO!~N~~W~ESCAPES ~Y~%d~W~/~R~%d",HumanCore[CURRENT_ESCAPES],HumanCore[MAX_ESCAPES]);
	     	GameTextForCoreFighters(roundstr,5000);
		    UpdateCoreRoundStatus();
		}
	}
	else
	{
	    NPC_INFO[npcid][InCORE] = 0;
	}
}

stock GetPlayerId(Name[])
{
    for(new i = 0; i < GetMaxPlayers(); i++)
    {
        if(IsPlayerConnected(i))
        {
	        new pName2[MAX_PLAYER_NAME];
	        GetPlayerName(i, pName2, sizeof(pName2));
            if(!strcmp(Name, pName2))
            {
            return i;
            }
        }
    }
    return -1;
}

stock Float:GetDistanceToPlayer(playerid,playerid2) {
	new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
	if (!IsPlayerConnected(playerid) || !IsPlayerConnected(playerid2)) {
		return -1.00;
	}
	GetPlayerPos(playerid,x1,y1,z1);
	GetPlayerPos(playerid2,x2,y2,z2);
	return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}

public GetClosestPlayerBOT(P1)
{
	new X, Float:Dis, Float:Dis2, Player;
	Player = INVALID_PLAYER_ID;
	Dis = 99999.99;
	if(NPC_INFO[P1][InCORE] == 1)
	{
		for (X=0; X< GetMaxPlayers(); X++)
		{
			if(IsPlayerConnected(X) && gTeam[X] == Humano && !IsPlayerDead(X) && GetPlayerState(X) != PLAYER_STATE_SPECTATING && PlayerInfo[X][MusicInicio] == 0 && !IsPlayerPaused(X) && !IsPlayerNPC(X) && PlayerInfo[X][AntiZombie] == 0 && PlayerInfo[X][InCORE] == 1)
			{
				if(X != P1)
				{
					Dis2 = GetDistanceBetweenPlayers(X,P1);
					if(Dis2 < Dis && Dis2 != -1.00)
					{
						Dis = Dis2;
						Player = X;
					}
				}
			}
		}
	}
	else
	{
		for (X=0; X<GetMaxPlayers(); X++)
		{
			if(IsPlayerConnected(X) && gTeam[X] == Humano && !IsPlayerDead(X) && GetPlayerState(X) != PLAYER_STATE_SPECTATING && PlayerInfo[X][MusicInicio] == 0 && !IsPlayerPaused(X) && !IsPlayerNPC(X) && PlayerInfo[X][AntiZombie] == 0)
			{
				if(X != P1)
				{
					Dis2 = GetDistanceBetweenPlayers(X,P1);
					if(Dis2 < Dis && Dis2 != -1.00)
					{
						Dis = Dis2;
						Player = X;
					}
				}
			}
		}
	}
	return Player;
}



public ObtenerBOTCercanoForDrone(P1)
{
	new X, Float:Dis, Float:Dis2, Player;
	Player = INVALID_PLAYER_ID;
	Dis = 99999.99;
	for (X=0; X< GetMaxPlayers(); X++)
	{
		if(IsPlayerConnected(X) && IsZombieNPC(X) && !FCNPC_IsDead(X) && PlayerInfo[X][InCORE] == 0)
		{
			if(X != P1)
			{
				Dis2 = GetDistanceBetweenPlayers(P1,X);
				if(Dis2 < Dis && Dis2 != -1.00)
				{
					Dis = Dis2;
					Player = X;
				}
			}
		}
	}
	return Player;
}

public ObtenerBOTCercano(P1)
{
	new X, Float:Dis, Float:Dis2, Player;
	Player = INVALID_PLAYER_ID;
	Dis = 99999.99;
	for (X=0; X< GetMaxPlayers(); X++)
	{
		if(IsPlayerConnected(X) && IsPlayerNPC(X) && !IsDroneBOT(X))
		{
			if(X != P1)
			{
				Dis2 = GetDistanceBetweenPlayers(X,P1);
				if(Dis2 < Dis && Dis2 != -1.00)
				{
					Dis = Dis2;
					Player = X;
				}
			}
		}
	}
	return Player;
}

stock Float:DISTANCIA_XYZ(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
    x1 -= x2, y1 -= y2, z1 -= z2;
    return floatsqroot((x1 * x1) + (y1 * y1) + (z1 * z1));
}


stock NearPlayersPlaySound(soundid, Float:x, Float:y, Float:z, Float:range)
{
	new Float:Dis2, Float:tx, Float:ty, Float:tz;
	for (new X=0; X< GetMaxPlayers(); X++)
	{
		if(IsPlayerConnected(X) && !IsPlayerNPC(X))
		{
		    GetPlayerPos(X, tx, ty, tz);
			Dis2 = DISTANCIA_XYZ(x, y, z, tx, ty, tz);
			if(Dis2 <= range && Dis2 != -1.00)
			{
				PlayerPlaySound(X, soundid, x, y, z);
			}
		}
	}
	return 1;
}
stock PreloadAnimLib(playerid, animlib[]) {
ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0);
ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0);
ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0);
}
stock PreCargarAnimaciones(playerid)
{
        PreloadAnimLib(playerid,"BLOWJOBZ");
        PreloadAnimLib(playerid,"AIRPORT");
        PreloadAnimLib(playerid,"ATTRACTORS");
        PreloadAnimLib(playerid,"BAR");
        PreloadAnimLib(playerid,"BASEBALL");
        PreloadAnimLib(playerid,"BD_FIRE");
        PreloadAnimLib(playerid,"BEACH");
        PreloadAnimLib(playerid,"BENCHPRESS");
        PreloadAnimLib(playerid,"BF_INJECTION");
        PreloadAnimLib(playerid,"BIKED");
        PreloadAnimLib(playerid,"BIKEH");
        PreloadAnimLib(playerid,"BIKELEAP");
        PreloadAnimLib(playerid,"BIKES");
        PreloadAnimLib(playerid,"BIKEV");
        PreloadAnimLib(playerid,"BIKE_DBZ");
        PreloadAnimLib(playerid,"BMX");
        PreloadAnimLib(playerid,"BOMBER");
        PreloadAnimLib(playerid,"BOX");
        PreloadAnimLib(playerid,"BSKTBALL");
        PreloadAnimLib(playerid,"BUDDY");
        PreloadAnimLib(playerid,"BUS");
        PreloadAnimLib(playerid,"CAMERA");
        PreloadAnimLib(playerid,"CAR");
        PreloadAnimLib(playerid,"CARRY");
        PreloadAnimLib(playerid,"CAR_CHAT");
        PreloadAnimLib(playerid,"CASINO");
        PreloadAnimLib(playerid,"CHAINSAW");
        PreloadAnimLib(playerid,"CHOPPA");
        PreloadAnimLib(playerid,"CLOTHES");
        PreloadAnimLib(playerid,"COACH");
        PreloadAnimLib(playerid,"COLT45");
        PreloadAnimLib(playerid,"COP_AMBIENT");
        PreloadAnimLib(playerid,"COP_DVBYZ");
        PreloadAnimLib(playerid,"CRACK");
        PreloadAnimLib(playerid,"CRIB");
        PreloadAnimLib(playerid,"DAM_JUMP");
        PreloadAnimLib(playerid,"DANCING");
        PreloadAnimLib(playerid,"DEALER");
        PreloadAnimLib(playerid,"DILDO");
        PreloadAnimLib(playerid,"DODGE");
        PreloadAnimLib(playerid,"DOZER");
        PreloadAnimLib(playerid,"DRIVEBYS");
        PreloadAnimLib(playerid,"FAT");
        PreloadAnimLib(playerid,"FIGHT_B");
        PreloadAnimLib(playerid,"FIGHT_C");
        PreloadAnimLib(playerid,"FIGHT_D");
        PreloadAnimLib(playerid,"FIGHT_E");
        PreloadAnimLib(playerid,"FINALE");
        PreloadAnimLib(playerid,"FINALE2");
        PreloadAnimLib(playerid,"FLAME");
        PreloadAnimLib(playerid,"FLOWERS");
        PreloadAnimLib(playerid,"FOOD");
        PreloadAnimLib(playerid,"FREEWEIGHTS");
        PreloadAnimLib(playerid,"GANGS");
        PreloadAnimLib(playerid,"GHANDS");
        PreloadAnimLib(playerid,"GHETTO_DB");
        PreloadAnimLib(playerid,"GOGGLES");
        PreloadAnimLib(playerid,"GRAFFITI");
        PreloadAnimLib(playerid,"GRAVEYARD");
        PreloadAnimLib(playerid,"GRENADE");
        PreloadAnimLib(playerid,"GYMNASIUM");
        PreloadAnimLib(playerid,"HAIRCUTS");
        PreloadAnimLib(playerid,"HEIST9");
        PreloadAnimLib(playerid,"INT_HOUSE");
        PreloadAnimLib(playerid,"INT_OFFICE");
        PreloadAnimLib(playerid,"INT_SHOP");
        PreloadAnimLib(playerid,"JST_BUISNESS");
        PreloadAnimLib(playerid,"KART");
        PreloadAnimLib(playerid,"KISSING");
        PreloadAnimLib(playerid,"KNIFE");
        PreloadAnimLib(playerid,"LAPDAN1");
        PreloadAnimLib(playerid,"LAPDAN2");
        PreloadAnimLib(playerid,"LAPDAN3");
        PreloadAnimLib(playerid,"LOWRIDER");
        PreloadAnimLib(playerid,"MD_CHASE");
        PreloadAnimLib(playerid,"MD_END");
        PreloadAnimLib(playerid,"MEDIC");
        PreloadAnimLib(playerid,"MISC");
        PreloadAnimLib(playerid,"MTB");
        PreloadAnimLib(playerid,"PED");
        PreloadAnimLib(playerid,"NEVADA");
        PreloadAnimLib(playerid,"ON_LOOKERS");
        PreloadAnimLib(playerid,"OTB");
        PreloadAnimLib(playerid,"PARACHUTE");
        PreloadAnimLib(playerid,"PARK");
        PreloadAnimLib(playerid,"PAULNMAC");
        PreloadAnimLib(playerid,"PED");
        PreloadAnimLib(playerid,"PLAYER_DVBYS");
        PreloadAnimLib(playerid,"PLAYIDLES");
        PreloadAnimLib(playerid,"POLICE");
        PreloadAnimLib(playerid,"POOL");
        PreloadAnimLib(playerid,"POOR");
        PreloadAnimLib(playerid,"PYTHON");
        PreloadAnimLib(playerid,"QUAD");
        PreloadAnimLib(playerid,"QUAD_DBZ");
        PreloadAnimLib(playerid,"RAPPING");
        PreloadAnimLib(playerid,"RIFLE");
        PreloadAnimLib(playerid,"RIOT");
        PreloadAnimLib(playerid,"ROB_BANK");
        PreloadAnimLib(playerid,"ROCKET");
        PreloadAnimLib(playerid,"RUSTLER");
        PreloadAnimLib(playerid,"RYDER");
        PreloadAnimLib(playerid,"SCRATCHING");
        PreloadAnimLib(playerid,"SHAMAL");
        PreloadAnimLib(playerid,"SHOP");
        PreloadAnimLib(playerid,"SHOTGUN");
        PreloadAnimLib(playerid,"SILENCED");
        PreloadAnimLib(playerid,"SKATE");
        PreloadAnimLib(playerid,"SMOKING");
        PreloadAnimLib(playerid,"SNIPER");
        PreloadAnimLib(playerid,"SPRAYCAN");
        PreloadAnimLib(playerid,"STRIP");
        PreloadAnimLib(playerid,"SUNBATHE");
        PreloadAnimLib(playerid,"SWAT");
        PreloadAnimLib(playerid,"SWEET");
        PreloadAnimLib(playerid,"SWIM");
        PreloadAnimLib(playerid,"SWORD");
        PreloadAnimLib(playerid,"TANK");
        PreloadAnimLib(playerid,"TATTOOS");
        PreloadAnimLib(playerid,"TEC");
        PreloadAnimLib(playerid,"TRAIN");
        PreloadAnimLib(playerid,"TRUCK");
        PreloadAnimLib(playerid,"UZI");
        PreloadAnimLib(playerid,"VAN");
        PreloadAnimLib(playerid,"VENDING");
        PreloadAnimLib(playerid,"VORTEX");
        PreloadAnimLib(playerid,"WAYFARER");
        PreloadAnimLib(playerid,"WEAPONS");
        PreloadAnimLib(playerid,"WUZI");
        PreloadAnimLib(playerid,"WOP");
        PreloadAnimLib(playerid,"GFUNK");
        PreloadAnimLib(playerid,"RUNNINGMAN");
        PreloadAnimLib(playerid,"PED");
        SetPVarInt(playerid,"AnimsPreCargadas",1);
}

stock strreplace(string[], const search[], const replacement[], bool:ignorecase = false, pos = 0, limit = -1, maxlength = 0)
{
	maxlength = strlen(string);
    // No need to do anything if the limit is 0.
    if (limit == 0)
        return 0;

    new
             sublen = strlen(search),
             replen = strlen(replacement),
        bool:packed = ispacked(string),
             maxlen = maxlength,
             len = strlen(string),
             count = 0
    ;


    // "maxlen" holds the max string length (not to be confused with "maxlength", which holds the max. array size).
    // Since packed strings hold 4 characters per array slot, we multiply "maxlen" by 4.
    if (packed)
        maxlen *= 4;

    // If the length of the substring is 0, we have nothing to look for..
    if (!sublen)
        return 0;

    // In this line we both assign the return value from "strfind" to "pos" then check if it's -1.
    while (-1 != (pos = strfind(string, search, ignorecase, pos))) {
        // Delete the string we found
        strdel(string, pos, pos + sublen);

        len -= sublen;

        // If there's anything to put as replacement, insert it. Make sure there's enough room first.
        if (replen && len + replen < maxlen) {
            strins(string, replacement, pos, maxlength);

            pos += replen;
            len += replen;
        }

        // Is there a limit of number of replacements, if so, did we break it?
        if (limit != -1 && ++count >= limit)
            break;
    }

    return count;
}

forward ChangeServerHour();
public ChangeServerHour() {
        new hour, minutes, second;
        gettime(hour, minutes, second);
       	SetWorldTime(hour);
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i)) {
				SetPlayerTime(i, hour, minutes);
				Hora = hour;
			}
		}
		#if defined SAVING
		SaveSQLDroppedWeapons();
		#endif
        return 1;
}

forward ChangeServerWeather();
public ChangeServerWeather() {
        new var = random(20);
       	SetWeather(var);
       	Clima = var;
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i)) {
				SetPlayerWeather(i, var);
			}
		}
        return 1;
}

#if !defined SAVING
stock RemoveAllDroppedWeapons()
{
	for(new f = 0; f < MAX_DROPPED_WEAPONS; f++)
	{
		if(dGunData[f][ObjData][3] == 0 && dGunData[f][ObjID] != -1){
		DestroyDynamicObject(dGunData[f][ObjID]);
		dGunData[f][ObjPos][0] = 0.0;
		dGunData[f][ObjPos][1] = 0.0;
		dGunData[f][ObjPos][2] = 0.0;
		dGunData[f][ObjID] = -1;
		//dGunData[f][ObjData][0] = 0;
		dGunData[f][ObjData][1] = 0;
		dGunData[f][ObjData][2] = 1;//taken!
		DestroyDynamic3DTextLabel( dGunData[f][objLabel] );
		}
	}
}
#endif
PUBLIC:BackupServer()
{
    HumanCore[ServerBackup] = 1;
    GameTextForAll("~w~Backup in progress!~n~~r~~h~RESPALDANDO..!", 5*1000*60, 3);
    SendClientMessageToAll(red,"********");
	SendClientMessageToAll(COLOR_AMARILLO,">] RESET [< {ffffff}La copia de seguridad se está efectuando.");
	SendClientMessageToAll(COLOR_AMARILLO,">] RESET [< {ffffff}Las armas por default alrededor del juego se restauraran.");
	SendClientMessageToAll(COLOR_AMARILLO,">] RESET [< {ffffff}Se guaradaran los objetos, armas y autos de todo el servidor.");
	SendClientMessageToAll(red,"********");
	if(ConexionSQL == 1){
	   	for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i)) {
				CallLocalFunction("OnPlayerCommandText", "is", i, "/gc");
			}
		}
	}
	for(new cars=0; cars<MAX_VEHICLES; cars++)
	{
			if(!VehicleOccupied(cars))
			{
				SetVehicleToRespawn(cars);
			}
	}
	#if !defined SAVING
	RemoveAllDroppedWeapons();
	#endif
	ReloadDefaultDroppedWeapons();
	#if defined SAVING
	SaveSQLDroppedWeapons();
	#endif
	SaveSQLCars();
	GameTextForAll("~w~RESPALDO~n~~g~~h~EXITOSO!", 10*1000, 3);
	SendClientMessageToAll(COLOR_ARTICULO,">] RESET [< {ffffff}Todos los vehiculos, armas y objetos fueron respawneados..");
	SetTimer("checkBackupServer",MINS_FOR_BACKUP*1000*60,0); // hacer backup de nuevo en 30 mins.
	HumanCore[ServerBackup] = 0;
}


PUBLIC:checkBackupServer()
{
    SendClientMessageToAll(red,"********");
	SendClientMessageToAll(red,">] RESET [< {ffffff}Una copia de seguridad será efectuada en {FF33CC}5{ffffff} minutos.");
	SendClientMessageToAll(red,">] RESET [< {ffffff}Durante el procesamiento de la misma, se puede ocasionar un lag temporal.");
	SendClientMessageToAll(red,">] RESET [< {ffffff}Despues de efectuar la copia de seguridad, el lag desaparecera.");
	SendClientMessageToAll(red,"********");
    SetTimer("BackupServer",5*1000*60,0); // Backup!! XD
}

/*
stock AutomaticHourChanger()
{
        ChangeServerHour();
        ChangeServerWeather();
        SetTimer("ChangeServerHour",5*1000*60,1); // actualizar cada 5 minutos
        SetTimer("ChangeServerWeather",5*1000*60,1); // actualizar cada 15 minutos
        SetTimer("checkBackupServer",25*1000*60,0); // hacer backup cada 25 minutos
        return 1;
}
*/
stock GetServerActorType(actorid) return ServerActor[actorid][actortype];

stock CreateServerActor(id , skinid, Float:x, Float:y,Float:z,Float:a)
{
    Create3DTextLabel("/charlar", 0xFFFF00FF, x,y,z, 10, 0);
    ServerActor[id][sactorid] = CreateActor(skinid, x,y,z,a);
    return 1;
}

stock SetServerActorType(actorid, type)
{
    ServerActor[actorid][actortype] = type;
    return 1;
}

stock SetServerActorSkin(actorid, skinid)
{
    ServerActor[actorid][actorskin] = skinid;
    return 1;
}


stock CheckTradingForPlayer(playerid, actorid)
{
		    switch(GetServerActorType(actorid))
		    {
		        case ACTOR_TYPE_GUNSMITH: {
					return ShowPlayerDialog(playerid, COMERCIO_RZ, DIALOG_STYLE_LIST, "{FF0099}R.Z: {FFFFFF}Comercio",
					"Armas y Munición\n\
					Antibioticos","VER", "x");
				}
		        case ACTOR_TYPE_SCIENTIFIC: return ShowMissionsForPlayer(playerid);
		        case ACTOR_TYPE_WAITER:
		        {
					return ShowPlayerDialog(playerid, AntibioticosRZ, DIALOG_STYLE_TABLIST_HEADERS, "{FF0099}R.Z: {FFFFFF}Comercio::{FF0099} Antibioticos",
					"Antibiotico\tPrecio\tSanación\n\
					Neomelubrina (MedicKIT)\t$3000\t100\n\
					Hidrocortisona\t$$1500\t50\n\
					Aspirinas\t$750\t25\n\
					BIsmuto\t$300\t10\n",
					"Comprar", "x");
		        }
		        case ACTOR_TYPE_DRONE_TRADER:
		        {
		            if(PlayerInfo[playerid][DRONE_ID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ] {ffffff}Ya posees un drone, necesitas /liberar para adquirir uno nuevo.");
					return ShowPlayerDialog(playerid, COMERCIO_DRONES_RZ, DIALOG_STYLE_TABLIST_HEADERS, "{FF0099}R.Z: {FFFFFF}Comercio::{FF0099} Drones",
					"Drone name\tPrecio ($)\tHabilidad\n\
					Pucky\t$5000\t13.33\n\
					Duck\t$10.000\t16.66\n\
					Elite\t$50.000\t33.33\n",
					"Comprar", "x");
		        }
		        default: return SendClientMessage(playerid, Rojo, "[<!>] No se reonocio el tipo de personaje.");
		    }
	 return 1;
}

//==============================================================================
// Public - .
//==============================================================================
HelloIdiot()
{
   new abcdf[][] =
   {
      "Unarmed (Fist)",
      "Brass K"
   };
   #pragma unused abcdf
}



stock IsValidSkin(skinid) //Thanks Sergei
{
	if(skinid <= 311 && skinid > 0)
	{
		switch(skinid)
		{
		case 203,202,189,274,285,3,287,294,6,23,11,12,2,22,188,198,0,74,163: return 0;
		default: return 1;
		}
	}
	return 0;
}
public OnPlayerRequestSpawn(playerid)
{
	if(!IsPlayerNPC(playerid))
	{
		if(PlayerInfo[playerid][Identificado] == 0)
		{
		if(IsPlayerRegistered(playerid) == 0)
		{
				new str_DL[256];
				format(str_DL,sizeof(str_DL),"{FFCC33}%s  \n {FFFFFF} Necesitas registrarte, ingresa una contraseña que recuerdes para continuar.",PlayerName2(playerid));
				ShowPlayerDialog(playerid, REGISTRO, DIALOG_STYLE_PASSWORD, "{858585}Bienvenido a RZ =)", str_DL , "Listo", "");
		}
		else	if(IsPlayerRegistered(playerid) == 1)
		{
				new str_DL[256];
				format(str_DL,sizeof(str_DL),"{FFCC33}%s \n {FFFFFF}Bienvenido de vuelta, ingresa tu contraseña para continuar.",PlayerName2(playerid));
				ShowPlayerDialog(playerid, INGRESO, DIALOG_STYLE_PASSWORD, "{858585}Hola de nuevo =)", str_DL , "OK", "");
		}
		return 0;
		}
		else{
			if(IsZombieSkin(GetPlayerSkin(playerid)) && PlayerInfo[playerid][VIP] <= 0) return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{858585}VIP REQUERIDO", "{ffffff}Necesitas ser VIP para poder ser zombie." , "OK", ""), 0;
		}
	}
	return 1;
}
//==============================================================================
// Public - SetupPlayerForClassSelection.
//==============================================================================
public SetupPlayerForClassSelection(playerid)
{
#if defined Camara_Movimiento
//making sure the timer gets executed only once, so the camera doesn't go to fast
if (PlayerCameraInfo[playerid][SpawnDance])
{
KillTimer(PlayerCameraInfo[playerid][SpawnTimer]);
PlayerCameraInfo[playerid][SpawnTimer] = SetTimerEx("MoveCamera", moving_speed, true, "i", playerid);
PlayerCameraInfo[playerid][SpawnDance] = false; //preventing the timer to execute again
SetPlayerPos(playerid, player_x, player_y, player_z);
SetPlayerFacingAngle(playerid, player_angle);
SetPlayerTime(playerid, 0,0);
SetPlayerWeather(playerid, 7);
}
#else
SetPlayerCameraPos(playerid, 862.3643, -1111.7742, 26.7207);
SetPlayerCameraLookAt(playerid, 862.4186, -1110.7858, 26.6907);
SetPlayerPos(playerid,862.6347, -1105.9109, 25.8559);
SetPlayerFacingAngle(playerid,177.9604);
SetPlayerInterior(playerid, 0);
SetPlayerTime(playerid, Hora,0);
SetPlayerWeather(playerid, Clima);
#endif
SetPlayerInterior(playerid, 0);
return 1;
}
//Public - OnPlayerRequestClass.
public OnPlayerRequestClass(playerid, classid)
{
    P_OnPlayerRequestClass(playerid);
	SetupPlayerForClassSelection(playerid);
	PlayerInfo[playerid][SKIN] = GetPlayerSkin(playerid);
	if(!IsZombieSkin(GetPlayerSkin(playerid)))
	{
		gTeam[playerid] = Humano;
		GameTextForPlayer(playerid,"~b~~h~~h~Humano",5000,6);
		SetPlayerTeam(playerid,Humano);
		SetPlayerColor(playerid,HUMANO_COLOR);
	}
	else{
		gTeam[playerid] = Zombie;
		GameTextForPlayer(playerid,"~r~~h~~h~Zombie",5000,6);
		SetPlayerTeam(playerid,Zombie);
		SetPlayerColor(playerid,ZOMBIE_COLOR_VISIBLE);
	}
	return 1;
}

stock randomEx(min, max)
{
    new rand = random(max-min)+min;
    return rand;
}

stock RegistrarAKA(playerid)
{
	if(!IsPlayerNPC(playerid))
	{
		if(!IsPlayerAkaRegistered(playerid))
		{
			new addaka[256],ip_addr[128];
			GetPlayerIp(playerid,ip_addr,sizeof(ip_addr));
			format(addaka, sizeof(addaka), "INSERT INTO alias (ip, aka) VALUES ('%s', '%s')",ip_addr,PlayerName2(playerid));
			db_query(DataBase_USERS,addaka);
		}
		else
		{
			new ip_addr[128];
			GetPlayerIp(playerid,ip_addr,sizeof(ip_addr));
		    if( strfind(ObtenerAKA(ip_addr), PlayerName2(playerid), true) == -1 )//evitar duplicado
		    {
		        new addaka[800];
				format(addaka, sizeof(addaka), "UPDATE alias SET aka=aka || ',%s' WHERE ip = '%s'",PlayerName2(playerid),ip_addr);
				db_query(DataBase_USERS,addaka);
			}
		}
	}
}
stock ObtenerAKA(plasherip[])
{
	new SQL_CONSULTA[256],AKA[256];
	//comienza la brujeria
	format(SQL_CONSULTA, sizeof(SQL_CONSULTA), "SELECT * FROM alias WHERE ip = '%s'", plasherip);
	NUM_ROWS_SQL = db_query(DataBase_USERS,SQL_CONSULTA);
	if(db_num_rows(NUM_ROWS_SQL) != 0)
	{
		//printf("[SQL]: AKA ENCONTRO ROWS *w* %d",db_num_rows(NUM_ROWS_SQL));
		new Field[256];
		db_get_field_assoc(NUM_ROWS_SQL, "aka", Field, sizeof(Field));
		strmid(AKA, Field, 0, strlen(Field));
 		//---
	}
	else
	{
		format(AKA, sizeof(AKA), "Vacio");
	}
	return AKA;
}

public OnPlayerDisconnect(playerid, reason)
{
	PlayerInfo[playerid][IgnoreSpawn] = false;
	/*
	if(!IsPlayerNPC(playerid))
	{
	    ConnectedPlayers = ConnectedPlayers - 1;
	    if(ConnectedPlayers < 0)
	    {
	        ConnectedPlayers = 0;
	    }
    	printf("[ConnectedPlayers]: Server has now %d connected players.", ConnectedPlayers);
    }*/
    //RZClient_StartSync(playerid);//restaurar sync para el proximo id que se conecte n_n
		PlayerInfo[playerid][ZonaSegura] = 0;
		PlayerInfo[playerid][ZonaInfectada] = 0;
	    P_OnPlayerDisconnect(playerid);
		if(PlayerInfo[playerid][Identificado] == 1 && PlayerInfo[playerid][Banned] == 0)
		{
		    if(PlayerInfo[playerid][InCORE] == 1){
		    	RemovePlayerWeapon(playerid, 31);
		    }
			CallLocalFunction("OnPlayerCommandText", "is", playerid, "/gc");
		}
	    RemovePlayerMapIcon(playerid, 0);
	    RemovePlayerMapIcon(playerid, 1);
	    RemovePlayerMapIcon(playerid, 2);
	    RemovePlayerMapIcon(playerid, 3);
	    RemovePlayerMapIcon(playerid, 4);
	    RemovePlayerMapIcon(playerid, 5);
	    RemovePlayerMapIcon(playerid, 6);
		KillTimer(PlayerInfo[playerid][SC_TIMER]);
		PlayerInfo[playerid][SC_Anim] = 0;
		PlayerInfo[playerid][DRONE_ID] = INVALID_PLAYER_ID;
		#if defined USE_SOBEIT_CAMERA_DETECTION
		WorldUsed[GetPlayerVirtualWorld(playerid)] = 0;
		#endif


	    #if defined USE_ZOMBIE_RADAR
	    KillTimer(PlayerInfo[playerid][TimerCheck]);
	    #endif
	    PlayerInfo[playerid][ZonaSegura] = 0;
	    #if defined USE_ZOMBIE_RADAR
	    TextDrawDestroy(PlayerInfo[playerid][RadarZombie]);
	    #endif
		SetPlayerColor(playerid,red);
	    SendDeathMessage(playerid, playerid, 201);
		#if defined Camara_Movimiento
		KillTimer( PlayerCameraInfo[playerid][SpawnTimer] );
		#endif
		#if defined VOTE_KICK_SYSTEM
		Voto[playerid] = 0;
		Votos_KICK[playerid] = 1;
		#endif
  		Delete3DTextLabel(LabelCabecero[playerid]);
		for(new x=0; x<GetMaxPlayers(); x++){if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && PlayerInfo[x][SpecID] == playerid){AdvanceSpectate(x);}}
		SetPVarInt(playerid, "laser", 0);
		RemovePlayerAttachedObject(playerid, 0);
        //ResetPlayerWeaponsEx(playerid);
	    if(GetPVarInt(playerid, "Reconnecting") == 1)
	    {
	        new
	            iStr[30],
	            iP[16];

	        GetPVarString(playerid, "RecIP", iP, sizeof(iP));
	        printf("%s", iP);

	        format(iStr, sizeof(iStr), "unbanip %s", iP);

	        SendRconCommand(iStr);
	        SendRconCommand("reloadbans");

	        SetPVarInt(playerid, "Reconnecting", 0);
	        return 1;
	    }
    if(PlayerInfo[playerid][Banned] == 1){reason = 5;}
	if(reason == 0||reason == 2||reason == 5)
	{
	new asd[128];
	switch (reason) {
	case 0: format(asd, sizeof(asd), "%s [ID: %d] SALIO.{ffffff} (Timeout)", PlayerName2(playerid), playerid);
	case 5: format(asd, sizeof(asd), "%s [ID: %d] SALIO.{ffffff} (BANEADO)", PlayerName2(playerid), playerid);
	case 2: format(asd, sizeof(asd), "%s [ID: %d] SALIO.{ffffff} (KICK)", PlayerName2(playerid), playerid);
	}
	MessageToAdmins(COLOR_GRIS, asd);
	}
	return 1;
}

#if defined Camara_Movimiento
forward MoveCamera(playerid);
public MoveCamera(playerid)
{
    //this is called trigonometry. It makes the camera spin
    //you can experiment with this line. Just change the values 2, 10 and 3 to make different effects
  SetPlayerCameraPos(playerid, player_x - 2 * floatsin(-PlayerCameraInfo[playerid][SpawnAngle], degrees), player_y - 7 * floatcos(-PlayerCameraInfo[playerid][SpawnAngle], degrees), player_z + 3);
  SetPlayerCameraLookAt(playerid, player_x, player_y, player_z + 0.5);

    //changing the angle a little
  PlayerCameraInfo[playerid][SpawnAngle] += 0.5;

  if (PlayerCameraInfo[playerid][SpawnAngle] >= 360.0)
    PlayerCameraInfo[playerid][SpawnAngle] = 0.0;

}
#endif


stock IsPlayerRegistered(playerid)
{
		new Comprobar[256];
		format(Comprobar, sizeof(Comprobar), "SELECT * FROM Usuarios WHERE Username = '%s'", DB_Escape(PlayerName2(playerid)));
		NUM_ROWS_SQL = db_query(DataBase_USERS,Comprobar);
		if(db_num_rows(NUM_ROWS_SQL) == 0) return 0;
		else return 1;
}

stock IsPlayerAkaRegistered(playerid)
{
		new Comprobar[256],ip_addr[128];
		GetPlayerIp(playerid,ip_addr,sizeof(ip_addr));
		format(Comprobar, sizeof(Comprobar), "SELECT ip FROM alias WHERE ip = '%s'", ip_addr);
		NUM_ROWS_SQL = db_query(DataBase_USERS,Comprobar);
		if(db_num_rows(NUM_ROWS_SQL) == 0) return 0;
		else return 1;
}

stock GetTextFromFile(file[])
{
    new string[256];
    new File:Archivo = fopen(file, io_read);
    fread(Archivo, string);
    fclose(Archivo);
    return string;
}
stock IsAccountRegistered(account[])
{
		new Comprobar[256];
		format(Comprobar, sizeof(Comprobar), "SELECT * FROM Usuarios WHERE Username = '%s'", account);
		NUM_ROWS_SQL = db_query(DataBase_USERS,Comprobar);
		if(db_num_rows(NUM_ROWS_SQL) == 0) return 0;
		else return 1;
}
stock BanByName(account[],bannerid,razon[])
{
	if(!IsPlayerConnected(bannerid)||bannerid == INVALID_PLAYER_ID)
	{
	new year, Mes, Dia,UpdateSQL[1500];
	getdate(year, Mes, Dia);
	format(UpdateSQL, sizeof(UpdateSQL), "UPDATE Usuarios SET Banned='1',bAdmin='Anti Cheat',bRazon='%s',bFecha='%d/%02d/%d' WHERE Username = '%s'",razon,Dia,Mes,year,account);
    printf(UpdateSQL);
	db_query(DataBase_USERS,UpdateSQL);
	}
	else if(IsPlayerConnected(bannerid))
	{
	new year, Mes, Dia,UpdateSQL[1500];
	getdate(year, Mes, Dia);
	format(UpdateSQL, sizeof(UpdateSQL), "UPDATE Usuarios SET Banned='1',bAdmin='%s',bRazon='%s',bFecha='%d/%02d/%d' WHERE Username = '%s'",PlayerName2(bannerid),razon,Dia,Mes,year,account);
	printf(UpdateSQL);
	db_query(DataBase_USERS,UpdateSQL);
	}
	return 1;
}


stock RZCBanByName(account[],bannerid,razon[])
{
	if(!IsPlayerConnected(bannerid)||bannerid == INVALID_PLAYER_ID)
	{
	new year, Mes, Dia,UpdateSQL[1500];
	getdate(year, Mes, Dia);
	format(UpdateSQL, sizeof(UpdateSQL), "REPLACE INTO RZCData(Username,locked,admin,razon,fecha) VALUES ('%s',1,'Anti Cheat','%s','%d/%02d/%d')",account,razon,Dia,Mes,year);
    printf(UpdateSQL);
	db_query(DataBase_USERS,UpdateSQL);
	}
	else if(IsPlayerConnected(bannerid))
	{
	new year, Mes, Dia,UpdateSQL[1500];
	getdate(year, Mes, Dia);
	format(UpdateSQL, sizeof(UpdateSQL), "REPLACE INTO RZCData(Username,locked,admin,razon,fecha) VALUES ('%s',1,'%s','%s','%d/%02d/%d')",account,PlayerName2(bannerid),razon,Dia,Mes,year);
	printf(UpdateSQL);
	db_query(DataBase_USERS,UpdateSQL);
	}
	return 1;
}
stock BanSQL(playerid,bannerid,razon[])
{
	if(!IsPlayerConnected(bannerid)||bannerid == INVALID_PLAYER_ID)
	{
		new year, Mes, Dia,userIP[50],UpdateSQL[1500];
		getdate(year, Mes, Dia);
		GetPlayerIp(playerid,userIP,sizeof(userIP));
		format(UpdateSQL, sizeof(UpdateSQL), "UPDATE Usuarios SET Banned='1',bAdmin='Anti Cheat',bRazon='%s',bIP='%s',bFecha='%d/%02d/%d' WHERE Username = '%s'",razon,userIP,Dia,Mes,year,PlayerName2(playerid));
	    printf(UpdateSQL);
		db_query(DataBase_USERS,UpdateSQL);
		__Kick(playerid);
		return 0;
	}
	else if(IsPlayerConnected(bannerid))
	{
		new year, Mes, Dia,userIP[50],UpdateSQL[1500];
		getdate(year, Mes, Dia);
		GetPlayerIp(playerid,userIP,sizeof(userIP));
		format(UpdateSQL, sizeof(UpdateSQL), "UPDATE Usuarios SET Banned='1',bAdmin='%s',bRazon='%s',bIP='%s',bFecha='%d/%02d/%d' WHERE Username = '%s'",PlayerName2(bannerid),razon,userIP,Dia,Mes,year,PlayerName2(playerid));
	    printf(UpdateSQL);
		db_query(DataBase_USERS,UpdateSQL);
		__Kick(playerid);
		return 0;
	}
	return 1;
}

stock RZCBanSQL(playerid,bannerid,razon[])
{
    new year, Mes, Dia,UpdateSQL[1500], userIP[128];
    GetPlayerIp(playerid,userIP,sizeof(userIP));
	if(!IsPlayerConnected(bannerid)||bannerid == INVALID_PLAYER_ID)
	{
		getdate(year, Mes, Dia);
		format(UpdateSQL, sizeof(UpdateSQL), "REPLACE INTO RZCData(Username,locked,admin,razon,fecha) VALUES ('%s',1,'Anti Cheat','%s','%d/%02d/%d')",PlayerName2(playerid),razon,Dia,Mes,year);
	    printf(UpdateSQL);
		db_query(DataBase_USERS,UpdateSQL);
		__Kick(playerid);
	}
	else if(IsPlayerConnected(bannerid))
	{
		getdate(year, Mes, Dia);
		format(UpdateSQL, sizeof(UpdateSQL), "REPLACE INTO RZCData(Username,locked,admin,razon,fecha) VALUES ('%s',1,'%s','%s','%d/%02d/%d')",PlayerName2(playerid),PlayerName2(bannerid),razon,Dia,Mes,year);
	    printf(UpdateSQL);
		db_query(DataBase_USERS,UpdateSQL);
		__Kick(playerid);
	}
	return 1;
}

stock UnBanALL()
{
	//db_query(DataBase_USERS,"UPDATE Usuarios SET Banned='0',bIP='0',bFecha='0',bAdmin='0',bRazon='0' WHERE Banned = '1'");
	return 1;
}
stock IsPlayerIPBanned(playerid)
{
		new Comprobar[256],UserIP[30];
		GetPlayerIp(playerid, UserIP, sizeof(UserIP));
		format(Comprobar, sizeof(Comprobar), "SELECT * FROM Usuarios WHERE bIP = '%s' AND Banned = '1'",UserIP);
		NUM_ROWS_SQL = db_query(DataBase_USERS,Comprobar);
		if(db_num_rows(NUM_ROWS_SQL) == 0) return 0;
		else return 1;
}

stock IsAccountBanned(playerid)
{
		new Comprobar[256];
		format(Comprobar, sizeof(Comprobar), "SELECT * FROM Usuarios WHERE Username = '%s' AND Banned = '1'", DB_Escape(PlayerName2(playerid)));
		NUM_ROWS_SQL = db_query(DataBase_USERS,Comprobar);
		if(db_num_rows(NUM_ROWS_SQL) == 0) return 0;
		else return 1;
}



stock CheckUserBanned(playerid)
{
			new SQL_CONSULTA[256],playeripexd[128];
		    if(IsPlayerIPBanned(playerid) == 1)
		    {
		    GetPlayerIp(playerid, playeripexd, sizeof(playeripexd));
		    format(SQL_CONSULTA, sizeof(SQL_CONSULTA), "SELECT * FROM Usuarios WHERE bIP = '%s' AND bRazon != '0' AND Banned = '1' LIMIT 1",playeripexd);
			NUM_ROWS_SQL = db_query(DataBase_USERS,SQL_CONSULTA);
			PlayerInfo[playerid][Banned] = 1;
		    }
		    else if(IsAccountBanned(playerid) == 1)
		    {
		    format(SQL_CONSULTA, sizeof(SQL_CONSULTA), "SELECT * FROM Usuarios WHERE Username = '%s' AND Banned = '1'",DB_Escape(PlayerName2(playerid)));
			NUM_ROWS_SQL = db_query(DataBase_USERS,SQL_CONSULTA);
			PlayerInfo[playerid][Banned] = 1;
		    }
	     	if(db_num_rows(NUM_ROWS_SQL) != 0)
		    {
	                new Field[256]; //Creating a field to retrieve the data
	                //---
	                //db_get_field_assoc(NUM_ROWS_SQL, "Banned", Field, sizeof(Field));
					//PlayerInfo[playerid][Banned] = strval(Field);
					//---
	                db_get_field_assoc(NUM_ROWS_SQL, "Username", Field, sizeof(Field));
					strmid(bNick[playerid], Field, 0, strlen(Field));
					//---
	                db_get_field_assoc(NUM_ROWS_SQL, "bAdmin", Field, sizeof(Field));
					strmid(bAdmin[playerid], Field, 0, strlen(Field));
					//---
	                db_get_field_assoc(NUM_ROWS_SQL, "bRazon", Field, sizeof(Field));
					strmid(bRazon[playerid], Field, 0, strlen(Field));
					//---
	                db_get_field_assoc(NUM_ROWS_SQL, "bIP", Field, sizeof(Field));
					strmid(bIP[playerid], Field, 0, strlen(Field));
					//---
	                db_get_field_assoc(NUM_ROWS_SQL, "bFecha", Field, sizeof(Field));
					strmid(bFecha[playerid], Field, 0, strlen(Field));
					//---
		        	db_free_result(NUM_ROWS_SQL);
				if(PlayerInfo[playerid][Banned] == 1)
				{
				new string[256];
				format(string,sizeof(string), "**{FFFFFF} *%s {4DFFFF} [E]xpulso a {FFFFFF}%s [%d] {BBC1C1}[Razón: %s]",bAdmin[playerid],bNick[playerid],playerid,bRazon[playerid]);
				AdminMessageToAdmins(playerid,0x4DFFFFAA,string);
				printf("Usuario %s Esta Baneado.",PlayerName2(playerid));
				new bDialog[1500],bDialogSW[1500];
				strcat(bDialogSW,"{FF3366}Estas bloqueado del servidor.\n\n");
				format(bDialog,sizeof(bDialog),"{FFCC33}Nick:{FFFFFF} %s\n",bNick[playerid]);
				strcat(bDialogSW,bDialog);
				format(bDialog,sizeof(bDialog),"{FFCC33}Bloqueado Por:{FFFFFF} %s\n",bAdmin[playerid]);
				strcat(bDialogSW,bDialog);
				format(bDialog,sizeof(bDialog),"{FFCC33}Razón:{FFFFFF} %s\n",bRazon[playerid]);
				strcat(bDialogSW,bDialog);
				format(bDialog,sizeof(bDialog),"{FFCC33}IP:{FFFFFF} %s\n",bIP[playerid]);
				strcat(bDialogSW,bDialog);
				format(bDialog,sizeof(bDialog),"{FFCC33}Fecha:{FFFFFF} %s\n",bFecha[playerid]);
				strcat(bDialogSW,bDialog);
				strcat(bDialogSW,"{FFCC33}Puedes apelar tu desbaneo en {FFFFFF}www.Revolucion-Zombie.com\n");
				ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{F50000}Cuenta Baneada", bDialogSW, "x", "");
				Kick(playerid);
				return 0;
				}
				return 0;
			}
			else return 1;
}


stock CheckRZClientRestricted(playerid)
{
	if(PlayerInfo[playerid][RZClient_Locked] == 1 && !RZClient_IsClientConnected(playerid))
	{
			new string[256];
			format(string,sizeof(string), "**{FFFFFF} %s {4DFFFF} [E]xpulso al jugador sin RZClient {FFFFFF}%s [%d] {BBC1C1}[Razón: %s]",bAdmin[playerid],bNick[playerid],playerid,bRazon[playerid]);
			AdminMessageToAdmins(playerid,0x4DFFFFAA,string);
			printf("Usuario %s Esta Restringido.",PlayerName2(playerid));
			new bDialog[1500],bDialogSW[1500];
			strcat(bDialogSW,"{FF3366}Tu cuenta esta restringida y NO puedes jugar sin RZClient.\n\n");
			format(bDialog,sizeof(bDialog),"{FFCC33}Nick:{FFFFFF} %s\n",bNick[playerid]);
			strcat(bDialogSW,bDialog);
			format(bDialog,sizeof(bDialog),"{FFCC33}Restringido Por:{FFFFFF} %s\n",bAdmin[playerid]);
			strcat(bDialogSW,bDialog);
			format(bDialog,sizeof(bDialog),"{FFCC33}Fecha:{FFFFFF} %s\n",bFecha[playerid]);
			strcat(bDialogSW,bDialog);
			format(bDialog,sizeof(bDialog),"{FFCC33}Razón:{FFFFFF} %s\n\n",bRazon[playerid]);
			strcat(bDialogSW,bDialog);
			strcat(bDialogSW,"{33FFFF}Para seguir jugando descarga el RZClient en \n{FFFFFF}www.Revolucion-Zombie.com\n");
			ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{F50000}Cuenta Restringida", bDialogSW, "x", "");
			Kick(playerid);
			return 0;
	}
    PlayerInfo[playerid][RZClient_Verified] = 1;
	return 1;
}



new WS_LIST[][] =
{
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

stock GetPlayerCountry(playerid) return RCM_Country[playerid];



stock RCM_ProcessCountry(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		new RZSTR[320];
		format(RZSTR,sizeof(RZSTR),"[ RZ ] {ffffff}%s [%d] Entro a la Revolución de los Zombies [%s].", RCM_PlayerName(playerid), playerid, GetPlayerCountry(playerid));
        SendClientMessageToAll(COLOR_BLUE_SOLID,RZSTR);
	}
}



stock RCM_PlayerName(playerid)
{
	new RCM_NICK[MAX_PLAYER_NAME];
	GetPlayerName(playerid, RCM_NICK, sizeof(RCM_NICK));
	return RCM_NICK;
}

forward RCM_GPCountry(index, response_code, data[]);
public RCM_GPCountry(index, response_code, data[])
{
	if(IsPlayerConnected(index))
	{
	    if(response_code == 200)
	    {
	        if(IsPlayerConnected(index) && !IsCountryBanned(index,data))
			{
         	strmid(RCM_Country[index], data, 0, strlen(data));
         	RCM_ProcessCountry(index);
	        }
	    }
	    else
	    {
		    printf("[ERROR]: GeoIP Can't connect to the host, Error code #%d",response_code);
		    if(IsPlayerConnected(index))
			{
      		strmid(RCM_Country[index], "??", 0, 1);
		    RCM_ProcessCountry(index);
		    }
	    }
    }
}

stock IsCountryBanned(playerid,pais[])
{
	if(strfind(pais, "Anonymous", true) != -1 || strfind(pais, "Proxy", true) != -1)
	{
		new RZSTR[256];
		format(RZSTR,sizeof(RZSTR),"[ RZ ] {ffffff}%s [%d] Fue Expulsado del servidor (%s).", RCM_PlayerName(playerid), playerid,pais);
   		SendClientMessageToAll(COLOR_BLUE_SOLID,RZSTR);
		RCM_SendDialog(playerid,"{ffffff}<-- {f50000}PROXY BANNED {ffffff}-->","{B366FF}YOU CANNOT CONNECT TO THIS SERVER WITH PROXY\n\n{ffffff}in order to keep this server safe of cheaters,\nthe admins of this server has blocked the proxies.\n\nSorry but you can't play here with proxy.",pais);
		/*return */
		Kick(playerid);
		return 1;
	}
	else if(strfind(pais, "VPN", true) != -1)
	{
		new RZSTR[256];
		format(RZSTR,sizeof(RZSTR),"[ RZ ] {ffffff}%s [%d] Fue Expulsado del servidor (%s).", RCM_PlayerName(playerid), playerid,pais);
   		SendClientMessageToAll(COLOR_BLUE_SOLID,RZSTR);
		RCM_SendDialog(playerid,"{ffffff}<-- {f50000}VPN BANNED {ffffff}-->","{B366FF}YOU CANNOT CONNECT TO THIS SERVER WITH VPN\n\n{ffffff}in order to keep this server safe of cheaters,\nThis server has blocked your VPN.\n\nSo, you can't play here with VPN turn it off!",pais);
		/*return */
		Kick(playerid);
		return 1;
	}
	else if(strfind(pais, "BANNED", true) != -1)
	{
		new RZSTR[256];
		format(RZSTR,sizeof(RZSTR),"[ RZ ] {ffffff}%s [%d] Fue Expulsado del servidor (%s) País NO PERMITIDO.", RCM_PlayerName(playerid), playerid,pais);
   		SendClientMessageToAll(COLOR_BLUE_SOLID,RZSTR);
		RCM_SendDialog(playerid,"{ffffff}<-- {f50000}COUNTRY BANNED {ffffff}-->","{B366FF}YOUR COUNTRY {ffffff}%s{B366FF} IS BANNED FROM THIS SERVER\n\n{ffffff}in order to keep this server safe of cheaters,\nthe admins of this server has blocked your country.\n\nSorry but you can't play here before of 1am (Mexican Hour).",pais);
		/*return */
		Kick(playerid);
		return 1;
	}
	else return 0;
}

public OnPlayerConnect(playerid)
{
	/*
	if(!IsPlayerNPC(playerid))
	{
	    ConnectedPlayers = ConnectedPlayers + 1;
	    if(ConnectedPlayers >= GetMaxPlayers())
	    {
	        ConnectedPlayers = GetMaxPlayers();
	    }
    	printf("[ConnectedPlayers]: Server has now %d connected players.", ConnectedPlayers);
    }*/
    RemoveBuildingForPlayer(playerid, 16004, -843.8359, 2746.0078, 47.7109, 0.25);
    P_OnPlayerConnect(playerid);
    RZM_OnPlayerConnect(playerid);
	//RemoveBuildingForPlayer(playerid, 18556, -1907.6172, -1666.6797, 29.8516, 0.25);
	//RemoveBuildingForPlayer(playerid, 18251, -1907.6172, -1666.6797, 29.8516, 0.25);
    PlayerInfo[playerid][Banned] = 0;
    SendRconCommand("unbanip 127.0.0.1");
    SendRconCommand("unbanip 127.0.0.1");
    SendRconCommand("unbanip 127.0.0.1");
    SendRconCommand("unbanip 127.0.0.1");
    PreCargarAnimaciones(playerid);
    //SendInvalidPlayerSync(playerid);
	if(!IsPlayerNPC(playerid))
	{
	    	ShowInfectedZonesForPlayer(playerid);
            ShowSafeZonesForPlayer(playerid);
			//#if defined ANTI_AMMO_HACk
			for (new i = 0; i < 14; i++)
			{
			    PlayerInfo[playerid][AAH_WeaponAmmo][i] = 0;
			    PlayerInfo[playerid][AAH_AmmoHackCount][i] = 0;
			    PlayerInfo[playerid][AAH_AmmoTick] = -1;
			}
	        //edicion a51 by avisi
			RemoveBuildingForPlayer(playerid, 3267, 15.6172, 1719.1641, 22.4141, 0.25);
			RemoveBuildingForPlayer(playerid, 3277, 15.6016, 1719.1719, 22.3750, 0.25);
	        //SendInvalidPlayerSync(playerid);
	        RegistrarAKA(playerid);
			CheckUserBanned(playerid);
			if(PlayerInfo[playerid][Banned] == 0)
			{
		    new stringu[256];
		    GetPlayerIp(playerid, PlayerInfo[playerid][IP], sizeof(stringu));
		    format(stringu,sizeof(stringu),"%s%s",RCM_API,PlayerInfo[playerid][IP]);
			HTTP(playerid,HTTP_GET,stringu,"","RCM_GPCountry");
	        SetPlayerColor(playerid,0x66FF33AA);
	        SendDeathMessage(playerid, playerid, 200);
			//anti god mode
			#if defined VOTE_KICK_SYSTEM
			Voto[playerid] = 0;
			Votos_KICK[playerid] = 1;
			#endif
			#if defined SistemaDECombustible
			PlayerVelo(playerid);
			#endif
			SetPVarInt(playerid, "Reconnecting", 0);
			NPC_NEMESIS[playerid] = 0;
			PlayerInfo[playerid][WH_Warnings] = 1;
			//TogglePlayerClock(playerid, 1);
			PlayerInfo[playerid][Banned] = 0;
			LabelCabecero[playerid] = Create3DTextLabel(" ", 0xF50000AA, 30.0, 40.0, 50.0, 40.0, 0);
			Attach3DTextLabelToPlayer(LabelCabecero[playerid], playerid, 0.0, 0.0, 0.7);
			PlayerInfo[playerid][SKIN] = 0;
			SetPlayerColor(playerid,COLOR_BLANCO);
			PlayerInfo[playerid][DRONE_ID] = INVALID_PLAYER_ID;
			PlayerInfo[playerid][StatsID] = playerid;
		    PlayerInfo[playerid][ContrasenaIncorrecta] = 0;
			PlayerInfo[playerid][Identificado] = 0;
			PlayerInfo[playerid][Registrado] = 1;
			PlayerInfo[playerid][Asesinatos] = 0;
			PlayerInfo[playerid][Muertes] = 0;
			PlayerInfo[playerid][Dinero] = 0;
			PlayerInfo[playerid][callado] = 0;
			PlayerInfo[playerid][nivel] = 0;
			PlayerInfo[playerid][SkinID] = 0;
			PlayerInfo[playerid][UsaSkin] = 0;
			PlayerInfo[playerid][Invitado] = 0;
			PlayerInfo[playerid][CLAN] = 0;
			PlayerInfo[playerid][CLAN_OWN] = 0;
			PlayerInfo[playerid][PM] = 1;
			PlayerInfo[playerid][VirusZ] = 0;
			PlayerInfo[playerid][VirusG] = 0;
			PlayerInfo[playerid][Lsay] = 0;
			PlayerInfo[playerid][Advertencias] = 1;
			PlayerInfo[playerid][RZWarnings] = 0;
			PlayerInfo[playerid][GLOBALCHAT] = 1;
			PlayerInfo[playerid][SpawnProtection] = 0;
			PlayerInfo[playerid][callado] = 0;
			PlayerInfo[playerid][MusicInicio] = 1;
			PlayerInfo[playerid][RZClient_Locked] = 0;
			PlayerInfo[playerid][RZClient_Verified] = 0;
			PlayerInfo[playerid][ZJump] = -1;
 			PlayerInfo[playerid][IgnoreSpawn] = false;
			PlayerInfo[playerid][ZonaSegura] = 0;
			PlayerInfo[playerid][ZonaInfectada] = 0;
			PlayerInfo[playerid][ZombieSpawnerTime] = ZOMBIES_SPAWN_TIME;
			PlayerInfo[playerid][MAX_PLAYER_ZOMBIES] = ZOMBIES_SPAWN_LIMIT;
			PlayerInfo[playerid][ZombieSpawnerTick] = -1;
			
			//PlayerInfo[playerid][IsCoreWeapon] = 0;
			PlayerInfo[playerid][InCORE] = 0;
			#if defined Camara_Movimiento
			PlayerCameraInfo[playerid][SpawnDance] = true;
			#endif
			PlayerInfo[playerid][UsaLazer] = 0;
			PlayerInfo[playerid][AntiCPFlood] = -1;
			PlayerInfo[playerid][AntiDigoFlood] = -1;
			PlayerInfo[playerid][AntiVIPCarFlood] = -1;
			PlayerInfo[playerid][TimerDARMA] = -1;
			PlayerInfo[playerid][AntiARFlood] = -1;
			PlayerInfo[playerid][AntiHHFlood] = -1;
			SendClientMessage(playerid,red,"  ");
			SendClientMessage(playerid,red,"  ");
			SendClientMessage(playerid,red,"  ");
			SendClientMessage(playerid,red,"  ");
			SendClientMessage(playerid,red,"  ");
			SendClientMessage(playerid,red,"  ");
			SendClientMessage(playerid,red,"  ");
			SendClientMessage(playerid,red,"  ");
			new ctm[256];
			format(ctm,sizeof(ctm),"{FFFFFF} Bienvenido {FF0000}%s {FFFFFF}a la Revolucion de los Zombies.",PlayerName2(playerid));
		    SendClientMessage(playerid,-1,ctm);
		    SendClientMessage(playerid,red,"  ");
		    SendClientMessage(playerid,red,"  ");
		    SendClientMessage(playerid,red,"  ");
		    SendClientMessage(playerid,red,"  ");
			for(new i=0;i<47;i++) { PlayerInfo[playerid][Weapon][i] = false; PlayerInfo[playerid][WeaponDroppable][i] = true; }
			PlayerInfo[playerid][dead] = 0;
			PlayerInfo[playerid][DoorsLocked] = 0;
			PlayerInfo[playerid][Antispam1] = -1;
			PlayerInfo[playerid][Antispam3] = -1;
			PlayerInfo[playerid][ANT_PMF] = -1;
			//----- Objetos de Skin Selection --------
			#if defined Camara_Movimiento
CreatePlayerObject(playerid, 8483, 864.59113, -1091.16406, 28.41659,   0.00000, 0.00000, 269.29565);
CreatePlayerObject(playerid, 726, 853.63824, -1092.84363, 14.14110,   4.00000, -4.00000, 0.00000);
CreatePlayerObject(playerid, 726, 871.57434, -1093.40234, 12.67520,   0.00000, 0.00000, 156.00000);
CreatePlayerObject(playerid, 748, 851.89954, -1101.29370, 23.34881,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 748, 854.80115, -1118.50891, 23.34881,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 748, 852.26465, -1109.39722, 23.34881,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 748, 867.90125, -1115.71753, 23.34881,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 748, 864.40088, -1119.41455, 23.34881,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 748, 869.95441, -1104.15540, 23.34881,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 748, 863.34869, -1111.45752, 24.14893,   0.00000, 0.00000, 7.92000);
CreatePlayerObject(playerid, 3524, 861.01038, -1097.42920, 27.76599,   28.00000, 2.00000, 0.00000);
CreatePlayerObject(playerid, 3524, 865.45221, -1097.13245, 27.76599,   28.00000, 2.00000, 0.00000);
CreatePlayerObject(playerid, 3524, 858.76239, -1098.83838, 25.90906,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 3524, 867.57452, -1099.13367, 25.90906,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 897, 845.04309, -1096.22668, 24.85152,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 897, 844.14136, -1103.68677, 24.44548,   0.00000, 0.00000, 0.61520);
CreatePlayerObject(playerid, 897, 846.01099, -1112.95520, 24.44548,   0.00000, 0.00000, 0.61520);
CreatePlayerObject(playerid, 897, 850.43158, -1120.40723, 24.44548,   0.00000, 0.00000, 0.61520);
CreatePlayerObject(playerid, 897, 859.73901, -1122.74768, 21.73229,   0.00000, 0.00000, 10.78047);
CreatePlayerObject(playerid, 897, 869.77325, -1122.04297, 24.44548,   0.00000, 0.00000, 0.61520);
CreatePlayerObject(playerid, 897, 876.05902, -1112.22754, 24.44548,   0.00000, 0.00000, 0.61520);
CreatePlayerObject(playerid, 897, 879.47693, -1102.41809, 24.44548,   0.00000, 0.00000, 0.61520);
CreatePlayerObject(playerid, 897, 876.94415, -1092.96021, 24.44548,   0.00000, 0.00000, 0.61520);
CreatePlayerObject(playerid, 2780, 863.42065, -1098.57056, 30.02032,   0.00000, 0.00000, 350.34741);
CreatePlayerObject(playerid, 685, 851.32495, -1113.02417, 23.09221,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 685, 873.07684, -1112.42676, 23.09221,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 685, 868.23462, -1117.98584, 23.09221,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 685, 846.75189, -1101.41162, 23.09221,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 685, 876.67725, -1100.50854, 23.09221,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 849, 864.23468, -1106.89526, 23.46872,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 849, 857.62787, -1108.81848, 23.46872,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 849, 854.97052, -1102.03320, 23.46872,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 852, 865.28033, -1103.43811, 23.28785,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 852, 861.14337, -1106.54663, 23.28785,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 852, 853.64392, -1106.44836, 23.28785,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 852, 867.75983, -1098.52881, 23.28785,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 853, 867.39532, -1107.97424, 23.52989,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 853, 857.05682, -1104.96277, 23.52989,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 801, 853.50122, -1105.02588, 23.28085,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 801, 866.73584, -1106.56958, 23.28085,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 801, 857.97766, -1107.34473, 23.28085,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 19128, 862.70502, -1106.04346, 24.79339,   0.00000, 180.00000, 0.00000);
CreatePlayerObject(playerid, 3461, 864.49194, -1104.25842, 23.29245,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 3461, 860.86139, -1104.19873, 23.29245,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 2589, 858.81195, -1099.01245, 29.54534,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 2589, 867.59180, -1099.37903, 29.44534,   0.00000, 0.00000, 9.69287);
CreatePlayerObject(playerid, 852, 859.96216, -1097.70386, 26.76629,   87.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 852, 865.68054, -1097.55127, 26.76629,   87.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 1341, 863.43939, -1101.60925, 22.08491,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 1341, 865.63440, -1101.63708, 22.08491,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 1341, 859.11932, -1101.51038, 22.08491,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 1341, 863.45599, -1098.27356, 27.40199,   90.00000, 0.00000, 357.79047);
CreatePlayerObject(playerid, 1341, 861.31635, -1101.53894, 22.08490,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 748, 857.74323, -1115.92065, 23.35698,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 849, 861.40002, -1115.24329, 23.46872,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 853, 865.16217, -1115.34619, 23.52989,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 853, 853.54639, -1114.05518, 23.52989,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 801, 860.76794, -1117.43884, 23.28085,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 801, 864.16089, -1114.35962, 23.28085,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 801, 854.68896, -1113.01904, 23.28085,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 801, 860.60480, -1110.95972, 23.54831,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 3461, 855.59058, -1103.66638, 26.49300,   105.00000, 47.00000, 338.00000);
CreatePlayerObject(playerid, 3461, 869.41693, -1101.29163, 34.27088,   185.00000, 47.00000, 281.00000);
CreatePlayerObject(playerid, 3461, 858.89526, -1107.17456, 35.13760,   24.00000, 47.00000, 0.00000);
CreatePlayerObject(playerid, 3461, 857.07068, -1106.99426, 32.67936,   24.00000, 47.00000, 0.00000);
CreatePlayerObject(playerid, 3461, 855.26208, -1107.04895, 30.35540,   98.00000, 47.00000, 32.00000);
CreatePlayerObject(playerid, 3461, 854.67944, -1104.75354, 28.10270,   111.00000, 47.00000, 354.00000);
CreatePlayerObject(playerid, 3461, 856.09045, -1107.32166, 32.59877,   120.00000, 47.00000, 14.00000);
CreatePlayerObject(playerid, 3461, 856.75739, -1107.27844, 33.99352,   120.00000, 47.00000, 14.00000);
CreatePlayerObject(playerid, 3461, 872.98950, -1097.52600, 25.76918,   79.00000, 47.00000, 281.00000);
CreatePlayerObject(playerid, 726, 884.42511, -1110.84119, 12.67520,   0.00000, 0.00000, 156.00000);
CreatePlayerObject(playerid, 3461, 871.56897, -1096.86951, 25.76918,   79.00000, 47.00000, 281.00000);
CreatePlayerObject(playerid, 3461, 871.85046, -1097.87878, 28.10620,   79.00000, 47.00000, 281.00000);
CreatePlayerObject(playerid, 3461, 871.58124, -1098.36780, 29.60095,   79.00000, 47.00000, 281.00000);
CreatePlayerObject(playerid, 3461, 871.23962, -1098.87939, 30.98190,   93.00000, 47.00000, 281.00000);
CreatePlayerObject(playerid, 3461, 871.23962, -1098.87939, 30.98190,   94.00000, 47.00000, 281.00000);
CreatePlayerObject(playerid, 3461, 870.99518, -1101.00842, 33.52840,   185.00000, 47.00000, 281.00000);
CreatePlayerObject(playerid, 1341, 867.43402, -1101.76172, 22.08491,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 3524, 860.77081, -1107.90161, 23.42103,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 3524, 864.61444, -1107.91748, 23.42103,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 19124, 864.49982, -1104.25378, 25.24196,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 19124, 860.84381, -1104.23376, 25.24196,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 1215, 859.72168, -1106.22302, 23.47268,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 1215, 862.68658, -1108.67236, 23.47268,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 1215, 865.50470, -1106.65125, 23.96395,   0.00000, 0.00000, 0.00000);

			#else
CreatePlayerObject(playerid, 8483, 864.59113, -1091.16406, 28.41659,   0.00000, 0.00000, 269.29565);
CreatePlayerObject(playerid, 726, 853.63824, -1092.84363, 14.14110,   4.00000, -4.00000, 0.00000);
CreatePlayerObject(playerid, 726, 871.57434, -1093.40234, 12.67520,   0.00000, 0.00000, 156.00000);
CreatePlayerObject(playerid, 748, 851.89954, -1101.29370, 23.34881,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 748, 854.80115, -1118.50891, 23.34881,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 748, 852.26465, -1109.39722, 23.34881,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 748, 867.90125, -1115.71753, 23.34881,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 748, 864.40088, -1119.41455, 23.34881,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 748, 869.95441, -1104.15540, 23.34881,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 748, 863.34869, -1111.45752, 24.14893,   0.00000, 0.00000, 7.92000);
CreatePlayerObject(playerid, 3524, 861.01038, -1097.42920, 27.76599,   28.00000, 2.00000, 0.00000);
CreatePlayerObject(playerid, 3524, 865.45221, -1097.13245, 27.76599,   28.00000, 2.00000, 0.00000);
CreatePlayerObject(playerid, 3524, 858.76239, -1098.83838, 25.90906,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 3524, 867.57452, -1099.13367, 25.90906,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 897, 845.04309, -1096.22668, 24.85152,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 897, 844.14136, -1103.68677, 24.44548,   0.00000, 0.00000, 0.61520);
CreatePlayerObject(playerid, 897, 846.01099, -1112.95520, 24.44548,   0.00000, 0.00000, 0.61520);
CreatePlayerObject(playerid, 897, 850.43158, -1120.40723, 24.44548,   0.00000, 0.00000, 0.61520);
CreatePlayerObject(playerid, 897, 859.73901, -1122.74768, 21.73229,   0.00000, 0.00000, 10.78047);
CreatePlayerObject(playerid, 897, 869.77325, -1122.04297, 24.44548,   0.00000, 0.00000, 0.61520);
CreatePlayerObject(playerid, 897, 876.05902, -1112.22754, 24.44548,   0.00000, 0.00000, 0.61520);
CreatePlayerObject(playerid, 897, 879.47693, -1102.41809, 24.44548,   0.00000, 0.00000, 0.61520);
CreatePlayerObject(playerid, 897, 876.94415, -1092.96021, 24.44548,   0.00000, 0.00000, 0.61520);
CreatePlayerObject(playerid, 2780, 863.42065, -1098.57056, 30.02032,   0.00000, 0.00000, 350.34741);
CreatePlayerObject(playerid, 685, 851.32495, -1113.02417, 23.09221,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 685, 873.07684, -1112.42676, 23.09221,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 685, 868.23462, -1117.98584, 23.09221,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 685, 846.75189, -1101.41162, 23.09221,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 685, 876.67725, -1100.50854, 23.09221,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 849, 864.23468, -1106.89526, 23.46872,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 849, 857.62787, -1108.81848, 23.46872,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 849, 854.97052, -1102.03320, 23.46872,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 852, 865.28033, -1103.43811, 23.28785,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 852, 861.14337, -1106.54663, 23.28785,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 852, 853.64392, -1106.44836, 23.28785,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 852, 867.75983, -1098.52881, 23.28785,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 853, 867.39532, -1107.97424, 23.52989,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 853, 857.05682, -1104.96277, 23.52989,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 801, 853.50122, -1105.02588, 23.28085,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 801, 866.73584, -1106.56958, 23.28085,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 801, 857.97766, -1107.34473, 23.28085,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 19128, 862.70502, -1106.04346, 24.79339,   0.00000, 180.00000, 0.00000);
CreatePlayerObject(playerid, 3461, 864.49194, -1104.25842, 23.29245,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 3461, 860.86139, -1104.19873, 23.29245,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 2589, 858.81195, -1099.01245, 29.54534,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 2589, 867.59180, -1099.37903, 29.44534,   0.00000, 0.00000, 9.69287);
CreatePlayerObject(playerid, 852, 859.96216, -1097.70386, 26.76629,   87.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 852, 865.68054, -1097.55127, 26.76629,   87.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 1341, 863.43939, -1101.60925, 22.08491,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 1341, 865.63440, -1101.63708, 22.08491,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 1341, 859.11932, -1101.51038, 22.08491,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 1341, 863.45599, -1098.27356, 27.40199,   90.00000, 0.00000, 357.79047);
CreatePlayerObject(playerid, 1341, 861.31635, -1101.53894, 22.08490,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 748, 857.74323, -1115.92065, 23.35698,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 849, 861.40002, -1115.24329, 23.46872,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 853, 865.16217, -1115.34619, 23.52989,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 853, 853.54639, -1114.05518, 23.52989,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 801, 860.76794, -1117.43884, 23.28085,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 801, 864.16089, -1114.35962, 23.28085,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 801, 854.68896, -1113.01904, 23.28085,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 801, 860.60480, -1110.95972, 23.54831,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 3461, 855.59058, -1103.66638, 26.49300,   105.00000, 47.00000, 338.00000);
CreatePlayerObject(playerid, 3461, 869.41693, -1101.29163, 34.27088,   185.00000, 47.00000, 281.00000);
CreatePlayerObject(playerid, 3461, 858.89526, -1107.17456, 35.13760,   24.00000, 47.00000, 0.00000);
CreatePlayerObject(playerid, 3461, 857.07068, -1106.99426, 32.67936,   24.00000, 47.00000, 0.00000);
CreatePlayerObject(playerid, 3461, 855.26208, -1107.04895, 30.35540,   98.00000, 47.00000, 32.00000);
CreatePlayerObject(playerid, 3461, 854.67944, -1104.75354, 28.10270,   111.00000, 47.00000, 354.00000);
CreatePlayerObject(playerid, 3461, 856.09045, -1107.32166, 32.59877,   120.00000, 47.00000, 14.00000);
CreatePlayerObject(playerid, 3461, 856.75739, -1107.27844, 33.99352,   120.00000, 47.00000, 14.00000);
CreatePlayerObject(playerid, 3461, 872.98950, -1097.52600, 25.76918,   79.00000, 47.00000, 281.00000);
CreatePlayerObject(playerid, 726, 884.42511, -1110.84119, 12.67520,   0.00000, 0.00000, 156.00000);
CreatePlayerObject(playerid, 3461, 871.56897, -1096.86951, 25.76918,   79.00000, 47.00000, 281.00000);
CreatePlayerObject(playerid, 3461, 871.85046, -1097.87878, 28.10620,   79.00000, 47.00000, 281.00000);
CreatePlayerObject(playerid, 3461, 871.58124, -1098.36780, 29.60095,   79.00000, 47.00000, 281.00000);
CreatePlayerObject(playerid, 3461, 871.23962, -1098.87939, 30.98190,   93.00000, 47.00000, 281.00000);
CreatePlayerObject(playerid, 3461, 871.23962, -1098.87939, 30.98190,   94.00000, 47.00000, 281.00000);
CreatePlayerObject(playerid, 3461, 870.99518, -1101.00842, 33.52840,   185.00000, 47.00000, 281.00000);
CreatePlayerObject(playerid, 1341, 867.43402, -1101.76172, 22.08491,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 3524, 860.77081, -1107.90161, 23.42103,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 3524, 864.61444, -1107.91748, 23.42103,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 19124, 864.49982, -1104.25378, 25.24196,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 19124, 860.84381, -1104.23376, 25.24196,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 1215, 859.72168, -1106.22302, 23.47268,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 1215, 862.68658, -1108.67236, 23.47268,   0.00000, 0.00000, 0.00000);
CreatePlayerObject(playerid, 1215, 865.50470, -1106.65125, 23.96395,   0.00000, 0.00000, 0.00000);
			#endif
			//-------------------
			SetPlayerMapIcon(playerid, 0, -1907.3365,-1670.6040,23.0156, 62, 0, MAPICON_GLOBAL);//Refugio Conscturctura SF
			SetPlayerMapIcon(playerid, 1, 2552.0500,2775.8882,10.8498, 62, 0, MAPICON_GLOBAL);//refugio las venturas
			SetPlayerMapIcon(playerid, 2, -1348.1914,498.2216,18.2344, 6, 0, MAPICON_GLOBAL);//BARCO DE SF
			SetPlayerMapIcon(playerid, 3, 2713.1257,-1065.6760,69.4375, 22, 0, MAPICON_GLOBAL);//Mini Refugio LS
			SetPlayerMapIcon(playerid, 4, 1128.9902,-1487.6335,22.7652, 62, 0, MAPICON_GLOBAL);//Centro comercial LS
			SetPlayerMapIcon(playerid, 5, 856.5265,-2115.0103,19.9269, 62, 0, MAPICON_GLOBAL);//Muelle de LS
			SetPlayerMapIcon(playerid, 6, -1048.5951,-672.3373,32.3516, 19, 0, MAPICON_GLOBAL);//Drone Center
			//===================================================================================//
			//ConnectMSG(playerid);
            PlayerInfo[playerid][SC_COUNT] = 0;
			//PlayAudioStreamForPlayerEx(playerid,"http://stream1.ml0.t4e.dj/dublovers_high.mp3");
			PlayerInfo[playerid][AntiZombie] = 0;
			NPC_INFO[playerid][ByWeapon] = 53;
			PlayAudioStreamForPlayerEx(playerid,"http://survival.revolucion-zombie.com/rztracks/soundtrack.mp3");
			//------------------------------------------------------------------
			#if defined USE_ZOMBIE_RADAR
			PlayerInfo[playerid][RadarZombie] = TextDrawCreate(492.000000, 409.000000, "Zona Segura: NO~N~Radar Zombie: 0");
			TextDrawBackgroundColor(PlayerInfo[playerid][RadarZombie], -1667457793);
			TextDrawFont(PlayerInfo[playerid][RadarZombie], 3);
			TextDrawLetterSize(PlayerInfo[playerid][RadarZombie], 0.439999, 1.700000);
			TextDrawColor(PlayerInfo[playerid][RadarZombie], 255);
			TextDrawSetOutline(PlayerInfo[playerid][RadarZombie], 1);
			TextDrawSetProportional(PlayerInfo[playerid][RadarZombie], 1);
			ResetMissionVariables(playerid);
			#endif
			//------------------------------------------------------------------
			}
			else return 0;
	}
	return 1;
}

public FCNPC_OnCreate(npcid)
{
	NPC_NEMESIS[npcid] = 0;
	new WS_RAND = random(sizeof(WS_LIST));
	if(WS_RAND != 1){
	WS_RAND = random(sizeof(WS_LIST));
	}
	new WS_STYLE_SELECTED[256];
	format(WS_STYLE_SELECTED, sizeof(WS_STYLE_SELECTED), "%s",WS_LIST[WS_RAND]);
	if(StringMismatch(WS_STYLE_SELECTED, "SPANKINGW"))
	{
		strmid(NPC_Walking_Library[npcid], "SNM", 0, sizeof(WS_STYLE_SELECTED));
		strmid(NPC_Walking_Style[npcid], WS_STYLE_SELECTED, 0, sizeof(WS_STYLE_SELECTED));
	}
	else
	{
		strmid(NPC_Walking_Library[npcid], "PED", 0, sizeof(WS_STYLE_SELECTED));
		strmid(NPC_Walking_Style[npcid], WS_STYLE_SELECTED, 0, sizeof(WS_STYLE_SELECTED));
	}
	ZS_Tick[npcid] = -1;
	GetPlayerName(npcid, NPC_INFO[npcid][NAME], 40);
	NPC_INFO[npcid][LastKiller] = INVALID_PLAYER_ID;
	NPC_INFO[npcid][InCORE] = 0;
	NPC_INFO[npcid][BType] = randomEx(0, 4);
	NPC_INFO[npcid][SeekerTick] = -1;
	#if defined NPCBars
	NPC_INFO[npcid][NickLabel]=CreateDynamic3DTextLabel("",-1,0.0, 0.0, 0.35,DISTANCE_BARRA,npcid);
	UpdateNPCHealth(npcid);
	#endif
	Generame(npcid);
	return 1;
}


stock KillBOT(npcid,killerid,weapon)
{
		#pragma unused weapon
		if(NPC_INFO[npcid][InCORE] == 1)
		{
		    //NPC_INFO[npcid][CoreStep] = 0;
		    if(HumanCore[CURRENT_ROUND] == 1){
		    HumanCore[ZOMBIES_KILLED]++;
		    HumanCore[ZOMBIES_KILLED]++;
		    HumanCore[ZOMBIES_KILLED]++;
		    HumanCore[ZOMBIES_KILLED]++;
		    HumanCore[ZOMBIES_KILLED]++;
		    }
		    else
		    {
		    HumanCore[ZOMBIES_KILLED]++;
		    }
		    UpdateCoreRoundStatus();
		    RespawnearBOT(npcid);
		                    	NPC_INFO[npcid][Attacking] = INVALID_PLAYER_ID;
		                    	NPC_INFO[npcid][LastFinded] = INVALID_PLAYER_ID;
								if(killerid != INVALID_PLAYER_ID && RZClient_IsClientConnected(killerid))
								{
								    if(PlayerInfo[killerid][ZonaInfectada] == 0 || PlayerInfo[killerid][InCORE] == 1 && PlayerInfo[killerid][ZonaInfectada] == 1)
								    {
										if(PlayerInfo[killerid][InCORE] == 0){
						                GameTextForPlayer(killerid,"~g~~h~~h~+2 SCORES~N~~r~~h~~h~+$600",3000,4);
						                }
						                SendDeathMessage(killerid,npcid, (weapon != -1) ? weapon : GetPlayerWeapon(killerid));
						                GivePlayerMoney(killerid,600);
						                SetPlayerScore(killerid, GetPlayerScore(killerid) + 2);
						                NPC_INFO[npcid][LastKiller] = killerid;
					                }
					                else{
						                GameTextForPlayer(killerid,"~n~~n~~n~~r~~h~~h~+6 SCORES~N~~g~~h~~h~+$900",3000,5);
						                SendDeathMessage(killerid,npcid, (weapon != -1) ? weapon : GetPlayerWeapon(killerid));
						                GivePlayerMoney(killerid, 900);
						                SetPlayerScore(killerid, GetPlayerScore(killerid) + 6);
						                NPC_INFO[npcid][LastKiller] = killerid;
					                }
				                }
				                else if(killerid != INVALID_PLAYER_ID)
								{
								    if(PlayerInfo[killerid][ZonaInfectada] == 0 || PlayerInfo[killerid][InCORE] == 1 && PlayerInfo[killerid][ZonaInfectada] == 1)
								    {
										if(PlayerInfo[killerid][InCORE] == 0){
						                GameTextForPlayer(killerid,"~r~~h~~h~+1 SCORES~N~~r~~h~~h~+$150",3000,4);
						                }
						                SendDeathMessage(killerid,npcid, (weapon != -1) ? weapon : GetPlayerWeapon(killerid));
						                GivePlayerMoney(killerid,150);
						                SetPlayerScore(killerid, GetPlayerScore(killerid) + 1);
						                NPC_INFO[npcid][LastKiller] = killerid;
					                }
					                else{
						                GameTextForPlayer(killerid,"~n~~n~~n~~r~~h~~h~+3 SCORES~N~~g~~h~~h~+$600",3000,5);
						                SendDeathMessage(killerid,npcid, (weapon != -1) ? weapon : GetPlayerWeapon(killerid));
						                GivePlayerMoney(killerid, 600);
						                SetPlayerScore(killerid, GetPlayerScore(killerid) + 3);
						                NPC_INFO[npcid][LastKiller] = killerid;
					                }
				                }
		    PlayerPlaySound(killerid,17802, 0.0, 0.0, 0.0);
		    return 1;
		}

		if(IsPlayerOnMission(killerid))
		{
			if(NPC_INFO[npcid][BType] == GetMissionObjType(killerid) && GetMissionType(killerid) == MISSION_KILL_ZOMBIES)
			{
				if(GetMissionProgressAmount(killerid) >= GetMissionProgressLimit(killerid))
				{
					PlayerPlaySound(killerid, 1057, 0.0, 0.0, 0.0);
     				SendClientMessage(killerid,red,"]<!>[ {ffffff}Tú mision está completa, dirigete con cualquier cientifico para recibir tu recompensa.");
				}else{
				SetMissionProgressAmount(killerid, GetMissionProgressAmount(killerid)+1);
				SendFormatMessage(killerid,red,"]< Mission Status >[ {ffffff}%s %d %s: %d/%d.",GetMissionObjetiveText(killerid),GetMissionProgressLimit(killerid),GetMissionObjTypeName(killerid),GetMissionProgressAmount(killerid),GetMissionProgressLimit(killerid));
				}
			}
		}
		NPC_INFO[npcid][LastFinded] = INVALID_PLAYER_ID;
		NPC_INFO[npcid][Attacking] = INVALID_PLAYER_ID;
		if(NPC_INFO[npcid][LastKiller] == killerid && NPC_INFO[npcid][InCORE] == 0)
		{
							SendDeathMessage(killerid,npcid, (weapon != -1) ? weapon : GetPlayerWeapon(killerid));
		}
		else
		{
			if(IsZombieNPC(npcid) && !IsPlayerNPC(killerid))
			{
			            if(NPC_NEMESIS[npcid] == 1)
			            {
								if(killerid != INVALID_PLAYER_ID && RZClient_IsClientConnected(killerid))
								{
								if(PlayerInfo[killerid][InCORE] == 0)
								{
				                GameTextForPlayer(killerid,"~r~~h~~h~+30 SCORES~N~~g~~h~~h~+$1200 - rzclient",3000,4);
				                }
				                SendDeathMessage(killerid,npcid, (weapon != -1) ? weapon : GetPlayerWeapon(killerid));
				                GivePlayerMoney(killerid,1200);
				                SetPlayerScore(killerid, GetPlayerScore(killerid) + 30);
				                NPC_INFO[npcid][LastKiller] = killerid;
				                }
				                else if(killerid != INVALID_PLAYER_ID)
								{
								if(PlayerInfo[killerid][InCORE] == 0){
				                GameTextForPlayer(killerid,"~r~~h~~h~+10 SCORES~N~~g~~h~~h~+$600 - sin rzclient",3000,4);
				                }
				                SendDeathMessage(killerid,npcid, (weapon != -1) ? weapon : GetPlayerWeapon(killerid));
				                GivePlayerMoney(killerid,600);
				                SetPlayerScore(killerid, GetPlayerScore(killerid) + 10);
				                NPC_INFO[npcid][LastKiller] = killerid;
				                }
		                }
			            else if(NPC_NEMESIS[npcid] == 0)
			            {
								if(killerid != INVALID_PLAYER_ID && RZClient_IsClientConnected(killerid))
								{
								if(PlayerInfo[killerid][InCORE] == 0){
				                GameTextForPlayer(killerid,"~g~~h~~h~+2 SCORES~N~~r~~h~~h~+$300",3000,4);
				                }
				                SendDeathMessage(killerid,npcid, (weapon != -1) ? weapon : GetPlayerWeapon(killerid));
				                GivePlayerMoney(killerid,150);
				                SetPlayerScore(killerid, GetPlayerScore(killerid) + 2);
				                NPC_INFO[npcid][LastKiller] = killerid;
				                }
				                else if(killerid != INVALID_PLAYER_ID)
								{
								if(PlayerInfo[killerid][InCORE] == 0){
				                GameTextForPlayer(killerid,"~r~~h~~h~+1 SCORES~N~~g~~h~~h~+$150",3000,4);
				                }
				                SendDeathMessage(killerid,npcid, (weapon != -1) ? weapon : GetPlayerWeapon(killerid));
				                GivePlayerMoney(killerid,150);
				                SetPlayerScore(killerid, GetPlayerScore(killerid) + 1);
				                NPC_INFO[npcid][LastKiller] = killerid;
				                }
		                }
			}
		}
		FCNPC_Kill(npcid);
		return 1;
}

public FCNPC_OnDeath(npcid,killerid,weaponid)
{
	//ApplyAnimation(npcid,"WUZI","CS_Dead_Guy",4.1,0,1,1,1,1);
	//ApplyAnimation(npcid,"WUZI","CS_Dead_Guy",4.1,0,1,1,1,1);
	if(NPC_INFO[npcid][InCORE] == 0){
    SetTimerEx("RespawnearBOT", 10000, 0, "d", npcid);
    }
    else
    {
    RespawnearBOT(npcid);
    }
    return 1;
}

public FCNPC_OnSpawn(npcid)
{
	NPC_INFO[npcid][Attacking] = INVALID_PLAYER_ID;
	NPC_INFO[npcid][LastFinded] = INVALID_PLAYER_ID;
	RespawnearBOT(npcid);
    return 1;
}



stock CloseDoor(objectid,Float:x,Float:y,Float:z)
{
	if(ObjectInfo[objectid][ACTIVADO] == 1)
	{
	SetTimerEx("CloseDoorEx", 7000, 0, "dddd", objectid,x,y,z);
	}
	return 1;
}
forward CloseDoorEx(objectid,Float:x,Float:y,Float:z);
public CloseDoorEx(objectid,Float:x,Float:y,Float:z)
{
MoveObject(objectid, x, y, z, 5.0);
ObjectInfo[objectid][ACTIVADO] = 0;
return 1;
}



stock CloseROTDoor(objectid,Float:x,Float:y,Float:z,Float:rx,Float:ry,Float:rz)
{
	if(ObjectInfo[objectid][ACTIVADO] == 1)
	{
	SetTimerEx("CloseROTDoorEx", 7000, 0, "ddddddd", objectid,x,y,z,rx,ry,rz);
	}
	return 1;
}
forward CloseROTDoorEx(objectid,Float:x,Float:y,Float:z,Float:rx,Float:ry,Float:rz);
public CloseROTDoorEx(objectid,Float:x,Float:y,Float:z,Float:rx,Float:ry,Float:rz)
{
MoveObject(objectid, x, y, z, 2.0,rx,ry,rz);
ObjectInfo[objectid][ACTIVADO] = 0;
return 1;
}




public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK && PlayerInfo[playerid][Banned] == 0)
	{
	            PlayerInfo[playerid][Banned] = 1;
		        new string[256];
				new PlayerName[MAX_PLAYER_NAME];
				GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
				format(string,sizeof(string), "{4DFFFF}**{FFFFFF} El Servidor{4DFFFF}ha [B]aneado a {FFFFFF}%s {BBC1C1}[Razon: JetPack (= ]",PlayerName);
				SendClientMessageToAll(0xFFFF00FF, string);
				BanSQL(playerid,INVALID_PLAYER_ID,"JetPack Cheat"); // Banear By AntiCheat
				PlayerInfo[playerid][Banned] = 1;
				return 0;
	}
	PutLazerToPlayer(playerid);
	if(rztickcount() - PlayerInfo[playerid][armedbody_pTick] > 1 && !IsPlayerNPC(playerid))
	{
                new weaponid[13],weaponammo[13],pArmedWeapon;
                pArmedWeapon = GetPlayerWeapon(playerid);
                GetPlayerWeaponData(playerid,1,weaponid[1],weaponammo[1]);
                GetPlayerWeaponData(playerid,2,weaponid[2],weaponammo[2]);
                GetPlayerWeaponData(playerid,4,weaponid[4],weaponammo[4]);
                GetPlayerWeaponData(playerid,5,weaponid[5],weaponammo[5]);
                GetPlayerWeaponData(playerid,7,weaponid[7],weaponammo[7]);
                if(weaponid[1] && weaponammo[1] > 0)
				{
                        if(pArmedWeapon != weaponid[1])
						{
                                if(!IsPlayerAttachedObjectSlotUsed(playerid,0))
								{
                                        SetPlayerAttachedObject(playerid,0,GetWeaponModel(weaponid[1]),1, 0.199999, -0.139999, 0.030000, 0.500007, -115.000000, 0.000000, 1.000000, 1.000000, 1.000000);
                                }
                        }
                        else
						{
                                if(IsPlayerAttachedObjectSlotUsed(playerid,0))
								{
                                        RemovePlayerAttachedObject(playerid,0);
                                }
                        }
                }
                else if(IsPlayerAttachedObjectSlotUsed(playerid,0))
				{
                        RemovePlayerAttachedObject(playerid,0);
                }
                if(weaponid[2] && weaponammo[2] > 0)
				{
                        if(pArmedWeapon != weaponid[2])
						{
                                if(!IsPlayerAttachedObjectSlotUsed(playerid,1))
								{
                                        SetPlayerAttachedObject(playerid,1,GetWeaponModel(weaponid[2]),8, -0.079999, -0.039999, 0.109999, -90.100006, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
                                }
                        }
                        else
						{
                                if(IsPlayerAttachedObjectSlotUsed(playerid,1))
								{
                                        RemovePlayerAttachedObject(playerid,1);
                                }
                        }
                }
                else if(IsPlayerAttachedObjectSlotUsed(playerid,1))
				{
                        RemovePlayerAttachedObject(playerid,1);
                }
                if(weaponid[4] && weaponammo[4] > 0)
				{
                        if(pArmedWeapon != weaponid[4])
						{
                                if(!IsPlayerAttachedObjectSlotUsed(playerid,2))
								{
                                        SetPlayerAttachedObject(playerid,2,GetWeaponModel(weaponid[4]),7, 0.000000, -0.100000, -0.080000, -95.000000, -10.000000, 0.000000, 1.000000, 1.000000, 1.000000);
                                }
                        }
                        else
						{
                                if(IsPlayerAttachedObjectSlotUsed(playerid,2))
								{
                                        RemovePlayerAttachedObject(playerid,2);
                                }
                        }
                }
                else if(IsPlayerAttachedObjectSlotUsed(playerid,2))
				{
                        RemovePlayerAttachedObject(playerid,2);
                }
                if(weaponid[5] && weaponammo[5] > 0)
				{
                        if(pArmedWeapon != weaponid[5])
						{
                                if(!IsPlayerAttachedObjectSlotUsed(playerid,3))
								{
                                        SetPlayerAttachedObject(playerid,3,GetWeaponModel(weaponid[5]),1, 0.200000, -0.119999, -0.059999, 0.000000, 206.000000, 0.000000, 1.000000, 1.000000, 1.000000);
                                }
                        }
                        else
						{
                                if(IsPlayerAttachedObjectSlotUsed(playerid,3))
								{
                                        RemovePlayerAttachedObject(playerid,3);
                                }
                        }
                }
                else if(IsPlayerAttachedObjectSlotUsed(playerid,3))
				{
                        RemovePlayerAttachedObject(playerid,3);
                }
                if(weaponid[7] && weaponammo[7] > 0)
				{
                        if(pArmedWeapon != weaponid[7])
						{
                                if(!IsPlayerAttachedObjectSlotUsed(playerid,4))
								{
                                        //MINIGUN
                                        if(GetWeaponModel(weaponid[7]) == 362) { SetPlayerAttachedObject(playerid,4,GetWeaponModel(weaponid[7]),1,-0.301690, -0.228733, 0.010277, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000); }
                                        //ROCKET LAUCHER
                                        if(GetWeaponModel(weaponid[7]) == 359) { SetPlayerAttachedObject(playerid,4,GetWeaponModel(weaponid[7]),1, 0.013419, -0.108792, 0.103414, 183.498001, 48.068290, 0.000000, 1.000000, 1.000000, 1.000000); }
                                }
                        }
                        else
						{
                                if(IsPlayerAttachedObjectSlotUsed(playerid,4))
								{
                                        RemovePlayerAttachedObject(playerid,4);
                                }
                        }
                }
                else if(IsPlayerAttachedObjectSlotUsed(playerid,4))
				{
                        RemovePlayerAttachedObject(playerid,4);
                }
                PlayerInfo[playerid][armedbody_pTick] = rztickcount();
        }

    if((GetPlayerWeapon(playerid) == 44 || GetPlayerWeapon(playerid) == 45) && !IsPlayerInAnyVehicle(playerid))
    {
  		new keys,ud,lr;
		GetPlayerKeys(playerid, keys, ud, lr);
        if(newkeys & KEY_FIRE || newkeys == KEY_FIRE || keys & KEY_FIRE) return 0;
    }
    if(newkeys &  KEY_FIRE || newkeys ==  KEY_FIRE)
    {
        checkPlayerWeaponHacking(playerid);
	  	if(gTeam[playerid] == Zombie && !IsZombieWeapon(GetPlayerWeapon(playerid)) && !IsPlayerNPC(playerid))
		{
		    if(!IsPlayerAdmin(playerid)) ResetPlayerWeaponsEx(playerid);
		}
        return 1;
    }
	if(newkeys & KEY_JUMP)
	{
		if(gTeam[playerid] == Zombie)
		{
		    ApplyAnimation(playerid, "PED", "JUMP_launch_R", 4.1, 0, 0, 0, 0, 0);
		    if(rztickcount() - PlayerInfo[playerid][ZJump] >= 5 || IsPlayerAdmin(playerid))
			{
			    new Float:ZombieJump[4];
				GetPlayerVelocity(playerid,ZombieJump[0],ZombieJump[1],ZombieJump[2]);
				GetPlayerFacingAngle(playerid,ZombieJump[3]);
				ZombieJump[0] += ( 0.5 * floatsin( -ZombieJump[3], degrees ) );
				ZombieJump[1] += ( 0.5 * floatcos( -ZombieJump[3], degrees ) );
				SetPlayerVelocity(playerid,ZombieJump[0],ZombieJump[1],ZombieJump[2]+1.2);
				PlayerInfo[playerid][ZJump] = rztickcount();
			}
		}
	}
	if ((oldkeys & KEY_FIRE) && (newkeys & KEY_CROUCH))
	{
			new weapon = GetPlayerWeapon(playerid);
			if(weapon == 24) // weapon == 24 este deagle , daca vreti sa se blocheze c-bugul si la alte arme faceti in felul urmator: if(weapon == 24 || weapon == id la arma )
			{
				ApplyAnimation(playerid,"GYMNASIUM","gym_tread_falloff",1.0,0,0,0,0,0);
				ApplyAnimation(playerid,"GYMNASIUM","gym_tread_falloff",1.0,0,0,0,0,0);
				ApplyAnimation(playerid,"GYMNASIUM","gym_tread_falloff",1.0,0,0,0,0,0);
				GameTextForPlayer(playerid, "~r~NO c-bug !", 5000, 1);
			}
	}

	if(newkeys &  KEY_YES || newkeys ==  KEY_YES)
	{
		new actorid = GetClosestActor(playerid);
		if(IsPlayerInRangeOfActor(playerid, actorid, 10))
		{
		    CheckTradingForPlayer(playerid, actorid);
		    return 1;
		}
	    else return SendClientMessage(playerid, Rojo, "[<!>] No estas cerca de ningun personaje.");
	}
    if(newkeys &  KEY_CROUCH || newkeys ==  KEY_CROUCH)
    {
  		if(IsPlayerInAnyPickup(playerid))
  		{
  		    OnPlayerTakePickup(playerid, GetPlayerPickup(playerid));
  		}
        #if defined ArmasDeath
        if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
        new f = MAX_DROPPED_WEAPONS+1;
		for(new a = 0; a < MAX_DROPPED_WEAPONS; a++)
		{
		    if(IsPlayerInRangeOfPoint(playerid, 2.0, dGunData[a][ObjPos][0], dGunData[a][ObjPos][1], dGunData[a][ObjPos][2]))
		    {
		        f = a;
		        break;
		    }
		}
		if(f > MAX_DROPPED_WEAPONS) return 1;
		if(dGunData[f][ObjID] == -1) return 1;
  		if(gTeam[playerid] == Zombie && !IsZombieWeapon(dGunData[f][ObjData][0])) return SendClientMessage(playerid, Rojo, "[ERROR]: {ffffff}Los zombies no pueden utilizar estas armas.");
		#if defined SAVING
		RemoveSQLDroppedWeapon(dGunData[f][ObjPos][0],dGunData[f][ObjPos][1],dGunData[f][ObjPos][2],dGunData[f][ObjData][0],dGunData[f][ObjData][1],dGunData[f][ObjData][3]);
		#endif
		new GunID = dGunData[f][ObjData][0], GunAmmo = dGunData[f][ObjData][1];
		DestroyDynamicObject(dGunData[f][ObjID]);
		DestroyDynamic3DTextLabel( dGunData[f][objLabel] );
		dGunData[f][ObjID] = -1;
		dGunData[f][ObjPos][0] = 0.0;
		dGunData[f][ObjPos][1] = 0.0;
		dGunData[f][ObjPos][2] = 0.0;

		dGunData[f][ObjData][1] = 0;
		dGunData[f][ObjData][2] = 1;//taken!

		new buffer[156];
		format(buffer, sizeof(buffer), "[RZ] {ffffff}Has tomado el arma %s del piso!", GunNames[GunID]);
  		SendClientMessage(playerid, COLOR_ARTICULO, buffer);
  		#endif
  		GivePlayerWeaponEx(playerid, GunID, GunAmmo);
  		return 1;
    }
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && PlayerInfo[playerid][SpecID] != INVALID_PLAYER_ID)
	{
		if(newkeys == KEY_JUMP || newkeys & KEY_JUMP) AdvanceSpectate(playerid);
		else if(newkeys == KEY_SPRINT || newkeys & KEY_SPRINT) ReverseSpectate(playerid);
		return 1;
	}
/*
    if(newkeys == KEY_SECONDARY_ATTACK )
	{//the secondary attack key ,which you can change into your own choice
        if(!IsPlayerInAnyVehicle(playerid))
		{ //checks the player if he/she is in the vehicle.
            new Float:x, Float:y, Float:z, vehicle; //these Float gets the player position that where the player is present
            GetPlayerPos(playerid, x, y, z );//gets player position
            GetRCVehicleWithinDistance(playerid, x, y, z, 20.0, vehicle);//gets the player distance from the vehicle

            if(IsVehicleRc(vehicle)){ //it checks the player vehicle is RC or not .
              PutPlayerInVehicle(playerid, vehicle, 0);
            }
        }
        else {
            new vehicleID = GetPlayerVehicleID(playerid);
            if(IsVehicleRc(vehicleID))
			{
				if(GetVehicleModel(vehicleID) != 449)
				{
	                new Float:x, Float:y, Float:z;
	                GetPlayerPos(playerid, x, y, z);
	                SetPlayerPos(playerid, x+0.5, y, z+1.0);
				}
				SetCameraBehindPlayer(playerid);
            }
        }
    }*/

    return 0;
}

/*
GetRCVehicleWithinDistance( playerid, Float:x1, Float:y1, Float:z1, Float:dist, &veh){//It should be in script other wise the GetVehicleWithInDistance will not work
    for(new i = 1; i < MAX_VEHICLES; i++){
        if(IsVehicleRc(i)){
            if(GetPlayerVehicleID(playerid) != i ){
            new Float:x, Float:y, Float:z;
            new Float:x2, Float:y2, Float:z2;
            GetVehiclePos(i, x, y, z);
            x2 = x1 - x; y2 = y1 - y; z2 = z1 - z;
            new Float:vDist = (x2*x2+y2*y2+z2*z2);
            if( vDist < dist){
            veh = i;
            dist = vDist;
                }
            }
        }
    }
}
*/
stock IsVehicleRc(vehicleid)
{
     switch(GetVehicleModel(vehicleid))
     {
          case 441,464,465,501,564,594: return 1;
     }
     return 0;
}
ProxDetector(Float:radi, playerid, string[], col1, col2, col3, col4, col5)
{
	new Float:pPositionX[3], Float:oPositionX[3];
	GetPlayerPos(playerid, pPositionX[0], pPositionX[1], pPositionX[2]);
	for(new i = 0; i < GetMaxPlayers(); i++) //Loops through all players
	{
		GetPlayerPos(i, oPositionX[0], oPositionX[1], oPositionX[2]);
		if(IsPlayerInRangeOfPoint(i, radi / 16, pPositionX[0], pPositionX[1], pPositionX[2])) { SendClientMessage(i, col1, string); }
		else if(IsPlayerInRangeOfPoint(i, radi / 8, pPositionX[0], pPositionX[1], pPositionX[2])) { SendClientMessage(i, col2, string); }
		else if(IsPlayerInRangeOfPoint(i, radi / 4, pPositionX[0], pPositionX[1], pPositionX[2])) { SendClientMessage(i, col3, string); }
		else if(IsPlayerInRangeOfPoint(i, radi / 2, pPositionX[0], pPositionX[1], pPositionX[2])) { SendClientMessage(i, col4, string); }
		else if(IsPlayerInRangeOfPoint(i, radi, pPositionX[0], pPositionX[1], pPositionX[2])) { SendClientMessage(i, col5, string); }
	}
	return 1;
}

stock G_SendClientMessageToAll(color, message[])
{
	for(new i = 0; i < GetMaxPlayers(); i++) //Loops through all players
	{
	    if(PlayerInfo[i][GLOBALCHAT] == 1){
	    	SendClientMessage(i, color, message);
	    }
	}
}

public OnPlayerText(playerid, text[])
{
	if(SinCHAT == 1&& !IsPlayerAdmin(playerid)) return 0;
	if(PlayerInfo[playerid][Identificado] == 0 || PlayerInfo[playerid][RZClient_Verified] == 0){SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ]{ffffff} Para utilizar el chat necesitas identificarte/spawnear por primera vez."); return 0;}
	if(text[0] == '#' && PlayerInfo[playerid][nivel] > 0){
      new str[128], name[MAX_PLAYER_NAME];
      GetPlayerName(playerid, name, sizeof(name));
      format(str, sizeof(str), "[ADMINS]: %s[%d]: %s",name,playerid, text[1]);
      MessageToAdmins(ADMIN_CHAT_COLOR,str);
    return 0;
	}
	static LastPrivmsg[MAX_PLAYERS][128];
	if(strfind(LastPrivmsg[playerid], text, false) != -1 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid,COLOR_DE_ERROR, "[ ERROR ] {FFFFFF}No repitas lo mismo que has escrito o seras callado."), 0;
	strmid(LastPrivmsg[playerid], text, 0, strlen(text), sizeof(LastPrivmsg[]));

	if(DetectarSpam(text) && !IsPlayerAdmin(playerid))
	{
    new name [MAX_PLAYER_NAME], string[256];
	GetPlayerName (playerid,name,sizeof(name));
	//SendClientMessage(playerid,-1,"{f50000} No se ha enviado el texto, Posible spam, ¡ADMINISTRADORES ADVERTIDOS!");
	format(string,sizeof(string),"El Jugador %s[%d]",name,playerid);
	MessageToAdmins(verde,string);
    format(string,sizeof(string),"Escribio Posible SPAM:{ffffff} %s {f50000}| {FFFF00}!",text);
    MessageToAdmins(verde,string);
    return 0;
	}
	if(PlayerInfo[playerid][Lsay] == 1)
	{
		if(DetectarSpam(text) && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid,red,"Es posible que tu mensaje contenga spam, tu mensaje no fue enviado.");
		if(IsPlayerAdmin(playerid))
		{
			printf("| RCON LVL %d | %s[%d]: %s",PlayerInfo[playerid][nivel],PlayerName2(playerid),playerid, text);
			format(text, strlen(text) + 128, "{FF0000}[- {FFCC33}RCON {00FF00}%s{ffffff}[%d] {FF0000}-]{ffffff}:{3DFFFF} %s", PlayerName2(playerid),playerid, text);
			SendClientMessageToAll(-1,text);
		}
		else
		{
			printf("| ADM LVL %d | %s[%d]: %s",PlayerInfo[playerid][nivel],PlayerName2(playerid),playerid, text);
			//new stringSAS[1000];
			format(text, strlen(text) + 128, "{FF0000}[- {00FF00}Admin {ffff00}%s[%d] {FF0000}-]{ffffff}:{FF4DFF} %s", PlayerName2(playerid),playerid, text);
			SendClientMessageToAll(-1,text);
		}
		return 0;
	}
	if(PlayerInfo[playerid][callado] == 1)
 	{
	SendClientMessage(playerid,red,"Estas silenciado, NO puedes Hablar, usar la radio y enviar mensajes privados.");
	return 0;
 	}
	//------------------------------------

	if(text[0] == '!')
	{
		new name[MAX_PLAYER_NAME], msg[300];
		GetPlayerName(playerid, name, sizeof(name));
		if(gTeam[playerid] == Humano)
		{
			format(msg, sizeof(msg), "{CCFF33}[Transmissor] %s [ID: %d]: %s", name, playerid, text[1]);
		}
		else
		{
			format(msg, sizeof(msg), "{FF0000}[Z Groagh] %s [ID: %d]: %s", name, playerid, text[1]);
		}
	 	for(new i; i<= GetMaxPlayers(); i++)
		{
			if(GetPlayerTeam(playerid) == GetPlayerTeam(i) || IsPlayerAdmin(i))
			{
				SendClientMessage(i,CHAT_COLOR,msg);
				PlayerPlaySound(i, 1052, 0.0, 0.0, 0.0);
			}
		}
		return 0;
	}

	if(text[0] == '+' && PlayerInfo[playerid][CLAN] == 1)
	{
	new msg[300];
	format(msg, sizeof(msg), "[CLAN] {FFB366}[%s]%s [ID: %d]:{FFE6CC} %s",ClanTAG[playerid],PlayerName2(playerid),playerid, text[1]);
 	for(new i; i<=GetMaxPlayers(); i++)
	{
	    if(IsPlayerConnected(i) && PlayerInfo[i][CLAN] == 1)
	    {
			if(IsPlayerOfMyClan(playerid,i) || IsPlayerAdmin(i))
			{
				SendClientMessage(i,0xCC6600AA,msg);
				PlayerPlaySound(i, 1149, 0.0, 0.0, 0.0);
			}
		}
	}
	return 0;
	}

	if(text[0] == '$' && PlayerInfo[playerid][VIP] > 0)
	{
		if((rztickcount() - PlayerInfo[playerid][AntiDigoFlood]) < 60 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, Rojo, "[ERROR]: {ffffff} Tienes que esperar 1 minuto para volver a usar este canal."), 0;
		new msg[300];
	 	format(msg, sizeof(msg), "* V.I.P {FFFFFF}%s [%d]: {00FF00}%s", PlayerName2(playerid),playerid, text[1]);
		printf("| V.I.P | %s [%d]: %s",PlayerName2(playerid),playerid, text[1]);
		G_SendClientMessageToAll(0x4DFFFFFF,msg);
		PlayerInfo[playerid][AntiDigoFlood] = rztickcount();
		return 0;
	}

	if(PlayerInfo[playerid][GLOBALCHAT] == 0)
	{
		if(gTeam[playerid] == Humano && PlayerInfo[playerid][CLAN] == 0)
	 	{
		new Nombre[MAX_PLAYER_NAME],ChatString[256];
		GetPlayerName(playerid, Nombre, sizeof(Nombre));
		format(ChatString, sizeof(ChatString), "(L) %s [ID: %d]: %s", Nombre,playerid, text);
		ProxDetector(80.0, playerid, ChatString, COLOR_FADE1, COLOR_FADE2, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4);
		TextoBuble(playerid,text);
		return 0;
		}
		else if(gTeam[playerid] == Humano && PlayerInfo[playerid][CLAN] == 1)
	 	{
		new Nombre[MAX_PLAYER_NAME],ChatString[256];
		GetPlayerName(playerid, Nombre, sizeof(Nombre));
		format(ChatString, sizeof(ChatString), "(L) [%s]%s [ID: %d]: %s", ClanTAG[playerid],Nombre,playerid, text);
		ProxDetector(80.0, playerid, ChatString, COLOR_FADE1, COLOR_FADE2, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4);
		TextoBuble(playerid,text);
		return 0;
		}
		if(gTeam[playerid] == Zombie && PlayerInfo[playerid][CLAN] == 0)
	 	{
		new Nombre[MAX_PLAYER_NAME],ChatString[256];
		GetPlayerName(playerid, Nombre, sizeof(Nombre));
		format(ChatString, sizeof(ChatString), "(L (Zombie)) %s [ID: %d]: %s", Nombre,playerid, text);
		ProxDetector(80.0, playerid, ChatString, COLOR_FADE1, COLOR_FADE2, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4);
		TextoBuble(playerid,text);
		return 0;
		}
		else if(gTeam[playerid] == Zombie && PlayerInfo[playerid][CLAN] == 1)
	 	{
		new Nombre[MAX_PLAYER_NAME],ChatString[256];
		GetPlayerName(playerid, Nombre, sizeof(Nombre));
		format(ChatString, sizeof(ChatString), "(L (Zombie)) [%s]%s [ID: %d]: %s", ClanTAG[playerid],Nombre,playerid, text);
		ProxDetector(80.0, playerid, ChatString, COLOR_FADE1, COLOR_FADE2, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4);
		TextoBuble(playerid,text);
		return 0;
		}
	}
	else
	{
		if(gTeam[playerid] == Humano && PlayerInfo[playerid][CLAN] == 0)
	 	{
		new Nombre[MAX_PLAYER_NAME],ChatString[256];
		GetPlayerName(playerid, Nombre, sizeof(Nombre));
		format(ChatString, sizeof(ChatString), "(G) %s [ID: %d]:{ffffff} %s", Nombre,playerid, text);
		G_SendClientMessageToAll(HUMANO_COLOR,ChatString);
		TextoBuble(playerid,text);
		return 0;
		}
		else if(gTeam[playerid] == Humano && PlayerInfo[playerid][CLAN] == 1)
	 	{
		new Nombre[MAX_PLAYER_NAME],ChatString[256];
		GetPlayerName(playerid, Nombre, sizeof(Nombre));
		format(ChatString, sizeof(ChatString), "(G) [%s]%s [ID: %d]:{ffffff} %s", ClanTAG[playerid],Nombre,playerid, text);
		G_SendClientMessageToAll(HUMANO_COLOR,ChatString);
		TextoBuble(playerid,text);
		return 0;
		}
		//zombie
		if(gTeam[playerid] == Zombie && PlayerInfo[playerid][CLAN] == 0)
	 	{
		new Nombre[MAX_PLAYER_NAME],ChatString[256];
		GetPlayerName(playerid, Nombre, sizeof(Nombre));
		format(ChatString, sizeof(ChatString), "(G) %s [ID: %d]:{ffffff} %s", Nombre,playerid, text);
		G_SendClientMessageToAll(ZOMBIE_COLOR,ChatString);
		TextoBuble(playerid,text);
		return 0;
		}
		else if(gTeam[playerid] == Zombie && PlayerInfo[playerid][CLAN] == 1)
	 	{
		new Nombre[MAX_PLAYER_NAME],ChatString[256];
		GetPlayerName(playerid, Nombre, sizeof(Nombre));
		format(ChatString, sizeof(ChatString), "(G) [%s]%s [ID: %d]:{ffffff} %s", ClanTAG[playerid],Nombre,playerid, text);
		G_SendClientMessageToAll(ZOMBIE_COLOR,ChatString);
		TextoBuble(playerid,text);
		return 0;
		}
	}
	return 0;
}

stock TextoBuble(playerid,text[])
{
    new vartmp = strlen(text) * 500;
	new bubbletime = 1500 + vartmp;
	SetPlayerChatBubble(playerid, text, -1, 45.0, bubbletime);
}
stock RugidoZombie(playerid)
{
    new vartmp = 5 * 500;
	new bubbletime = 1500 + vartmp;
	new rand = random(0xFFFFFFAA);
	SetPlayerChatBubble(playerid, "Wharh", rand, 45.0, bubbletime);
}

stock GetZombieVirusType(playerid)
{
	new virus_type = NPC_INFO[playerid][BType],virusText[30];
	switch(virus_type)
	{
	    case 0: format(virusText,sizeof(virusText),"");
	    case 1: format(virusText,sizeof(virusText),"C{ffffff}-Virus ");
	    case 2: format(virusText,sizeof(virusText),"F{ffffff}-Virus ");
	    case 3: format(virusText,sizeof(virusText),"G{ffffff}-Virus ");
	    case 4: format(virusText,sizeof(virusText),"Z{ffffff}-Virus ");
	}
	return virusText;
}
#if defined NPCBars
forward UpdateNPCHealth(playerid);
public UpdateNPCHealth(playerid)
{
        new data[256],barra[50];
        new Float:health = GetNPCHealth(playerid);
        if(health >= 100) barra = ""HEALTH_LLENA"••••••••••••••••••••";
        else if(health >= 90) barra = ""HEALTH_LLENA"••••••••••••••••••"HEALTH_VACIA"••";
        else if(health >= 80) barra = ""HEALTH_LLENA"••••••••••••••••"HEALTH_VACIA"••••";
        else if(health >= 70) barra = ""HEALTH_LLENA"••••••••••••••"HEALTH_VACIA"••••••";
        else if(health >= 60) barra = ""HEALTH_LLENA"••••••••••••"HEALTH_VACIA"••••••••";
        else if(health >= 50) barra = ""HEALTH_LLENA"••••••••••"HEALTH_VACIA"••••••••••";
        else if(health >= 40) barra = ""HEALTH_LLENA"••••••••"HEALTH_VACIA"••••••••••••";
        else if(health >= 30) barra = ""HEALTH_LLENA"••••••"HEALTH_VACIA"••••••••••••••";
        else if(health >= 25) barra = ""HEALTH_LLENA"••••"HEALTH_VACIA"••••••••••••••••";
        else if(health >= 20) barra = ""HEALTH_LLENA"•••"HEALTH_VACIA"••••••••••••••";
        else if(health >= 15) barra = ""HEALTH_LLENA"••"HEALTH_VACIA"••••••••••••••••";
        else if(health >= 10) barra = ""HEALTH_LLENA"•"HEALTH_VACIA"••••••••••••••••••";
        else if(health < 10) barra = ""HEALTH_VACIA"••••••••••••••••••••";
        if(IsDroneBOT(playerid))
        {
        format(data,sizeof(data),"{66B3FF}%s {ffffff}(%d)",PlayerName2(playerid),playerid);
        UpdateDynamic3DTextLabelText(NPC_INFO[playerid][NickLabel],-1,data);
        }
        else
        {
	        if(NPC_NEMESIS[playerid] == 1)
	        {
	        	format(data,sizeof(data),"{CC33FF}[X] Zombie Nemesis [x] {999999}(%d)\n"HEALTH_LLENA"[%.0f]",playerid,health);
	        }
	        else
	        {
	        	format(data,sizeof(data),"{ffffff}Zombie {FF0080}%s{ffffff}(%d)\n%s "HEALTH_LLENA"",GetZombieVirusType(playerid),playerid,barra);
	        }
	        UpdateDynamic3DTextLabelText(NPC_INFO[playerid][NickLabel],-1,data);
        }
        return true;
}
#endif

/*
public RZClient_OnPlay(playerid,handleid)
{
    SendFormatMessage(playerid,red,"<!> {ffffff}OnPlay. (handle: %d)",handleid);
	return 1;
}
*/

/*
PUBLIC:PlayBackgroundMusicForPlayer(playerid, playlist)
{
	if(AmbianceThemes == true)
	{

	    RZClient_Stop(playerid, PlayerInfo[playerid][PlayerTrack]);
		switch(playlist)
		{
		    case 0:{PlayerInfo[playerid][PlayerTrack] = RZClient_PlayStreamed(playerid, "http://server.inwoke.net/rztracks/ls_nature.ogg", false, true, false);}
		    case 1:{PlayerInfo[playerid][PlayerTrack] = RZClient_PlayStreamed(playerid, "http://server.inwoke.net/rztracks/ls_nature.ogg", false, true, false);}
		    case 2:{PlayerInfo[playerid][PlayerTrack] = RZClient_PlayStreamed(playerid, "http://server.inwoke.net/rztracks/ls_nature.ogg", false, true, false);}
		    case 3:{PlayerInfo[playerid][PlayerTrack] = RZClient_PlayStreamed(playerid, "http://server.inwoke.net/rztracks/area51_02.ogg", false, true, false);}
		    case 4:{PlayerInfo[playerid][PlayerTrack] = RZClient_PlayStreamed(playerid, "http://server.inwoke.net/rztracks/ls_nature.ogg", false, true, false);}
		    case 5:{PlayerInfo[playerid][PlayerTrack] = RZClient_PlayStreamed(playerid, "http://server.inwoke.net/rztracks/epic.ogg", false, true, false);}
		}
    //SendFormatMessage(playerid,red,"<!> {ffffff}Musica de fondo iniciada. (playlist: %d,%d)",playlist,PlayerInfo[playerid][PlayerTrack]);
    }
	return 1;
}


PUBLIC:PauseBackgroundMusicForPlayer(playerid, playlist)
{
    //SendFormatMessage(playerid,red,"<!> {ffffff}Musica de fondo detenida. (playlist: %d,%d)",playlist,PlayerInfo[playerid][PlayerTrack]);
    RZClient_Stop(playerid, PlayerInfo[playerid][PlayerTrack]);
   	if(AmbianceThemes == true){
    PlayBackgroundMusicForPlayer(playerid,W_SoundTracks);
    }
	PlayerInfo[playerid][MAX_PLAYER_ZOMBIES]=4;
	return 1;
}

*/
public OnPlayerEnterDynamicArea(playerid, areaid)
{
	if(IsSafeZone(areaid))
	{
 		PlayerInfo[playerid][ZonaSegura] = 1;
 		PlayerInfo[playerid][ZonaInfectada] = 0;
 		//SendFormatGameText(playerid,"~y~~h~~h~YOU ENTERED THE SAFE ZONE~n~%d", areaid,4000,3);
	}
	if(IsInfectedZone(areaid))
	{
	    PlayerInfo[playerid][ZombieSpawnerTime] = IZ_ZombiesRespawnTime;
	    if(HideServerPlayersHUD == 0 && IZ_HIDE_HUD == 1){
	    	TogglePlayerHUD(false, playerid);
	    }
	    PlayerInfo[playerid][MAX_PLAYER_ZOMBIES] = IZ_Zombies;
	    PlayerInfo[playerid][ZonaInfectada] = 1;
		SetPlayerTime(playerid, IZ_Hour, 0);
		SetPlayerWeather(playerid, IZ_Weather);
		GameTextForPlayer(playerid, ANNOUNCE_BUG("~R~~R~~H~¡EXTREME INFECTED ZONE!"),4000,3);
		if(InfectedZoneMusic[Enabled] == 1)
		{
		    PlayAudioStreamForPlayerEx(playerid, InfectedZoneMusic[MP3]);
		}
	}
	else{
	    PlayerInfo[playerid][MAX_PLAYER_ZOMBIES] = ZOMBIES_SPAWN_LIMIT;
	    PlayerInfo[playerid][ZonaInfectada] = 0;
		SetPlayerTime(playerid, Hora, 0);
		SetPlayerWeather(playerid, Clima);
	}
	return 1;
}


public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	PlayerInfo[playerid][ZombieSpawnerTime] = ZOMBIES_SPAWN_TIME;
    PlayerInfo[playerid][ZonaSegura] = 0;
    PlayerInfo[playerid][MAX_PLAYER_ZOMBIES] = ZOMBIES_SPAWN_LIMIT;
    /*if(IsSafeZone(areaid)){
    	SendFormatGameText(playerid,"~y~~h~~h~YOU LEAVED THE SAFE ZONE~n~%d", areaid,4000,3);
    }*/
	if(IsInfectedZone(areaid))
	{
	    if(HideServerPlayersHUD == 0 && IZ_HIDE_HUD == 1){
	    	TogglePlayerHUD(true, playerid);
	    }
	    PlayerInfo[playerid][ZonaInfectada] = 0;
		SetPlayerTime(playerid, Hora, 0);
		SetPlayerWeather(playerid, Clima);
		if(InfectedZoneMusic[Enabled] == 1)
		{
		    StopAudioStreamForPlayerEx(playerid);
		}
	}
	return 1;
}
//incrementar bots


stock SpawnZombies(playerid)
{
	if(PlayerInfo[playerid][InCORE] == 1)
	{
	    PlayerInfo[playerid][MAX_PLAYER_ZOMBIES] = 1;
	    if(HumanCore[CURRENT_ROUND] >= 2)
	    {
	    PlayerInfo[playerid][MAX_PLAYER_ZOMBIES] = 3;
	    HumanCore[ZOMBIES_MOVE_TYPE] = MEDIUM_ZOMBIE_MOVE_TYPE;
	    HumanCore[ZOMBIES_MOVE_SPEED] = MEDIUM_ZOMBIE_MOVE_SPEED;

	    }
	    if(HumanCore[CURRENT_ROUND] >= 9)
	    {
	    PlayerInfo[playerid][MAX_PLAYER_ZOMBIES] = 4;
	    HumanCore[ZOMBIES_MOVE_TYPE] = HIGH_ZOMBIE_MOVE_TYPE;
	    HumanCore[ZOMBIES_MOVE_SPEED] = HIGH_ZOMBIE_MOVE_SPEED;
	    }
	}
	if(PlayerInfo[playerid][AntiZombie] == 0 && PlayerInfo[playerid][SpawnProtection] == 0)
	{
		if(PlayerInfo[playerid][MusicInicio] == 0 && !IsPlayerDead(playerid) && PlayerInfo[playerid][ZonaSegura] == 0 && gTeam[playerid] == Humano && !IsPlayerPaused(playerid))
		{

		        new CURRENT_ZOMBIES = GetZombiesInPlayer(playerid);
				if(CURRENT_ZOMBIES < PlayerInfo[playerid][MAX_PLAYER_ZOMBIES] ){//SendFormatMessageToAll(COLOR_ROJO,"[BLOCKED]: Zombies: %d, max: %d", CURRENT_ZOMBIES, PlayerInfo[playerid][MAX_PLAYER_ZOMBIES]);
				
			   	new Float:x, Float:y, Float:z, Float:a;
  				GetPlayerPos(playerid,x,y,z);
  				GetPlayerFacingAngle(playerid, a);

				new Float:offset = 360.0 / PlayerInfo[playerid][MAX_PLAYER_ZOMBIES];
				new Float:ZombieSpawnerDistanceMIN = ( (ZombieSpawnerDistance - 15) >= 20 ) ? (ZombieSpawnerDistance - 15) : ZombieSpawnerDistance;
				
				new Float:radius = ( floatround(ZombieSpawnerDistanceMIN), floatround(ZombieSpawnerDistance) );
				new Float:nx,Float:ny,Float:nz;
		        //SendFormatMessageToAll(COLOR_ARTICULO,"[Trying zSpawn...]: %.02f used distance, min: %.02f, max: %.02f", radius, ZombieSpawnerDistanceMIN, ZombieSpawnerDistance);
		        
			   	for(new npcID = 0; npcID < GetMaxPlayers(); npcID++)
		  		{
				 	if(IsPlayerConnected(npcID) && IsZombieNPC(npcID) && NPC_INFO[npcID][Attacking] == INVALID_PLAYER_ID && !FCNPC_IsDead(npcID) && NPC_INFO[npcID][InCORE]==0 && CURRENT_ZOMBIES < PlayerInfo[playerid][MAX_PLAYER_ZOMBIES])
				 	{
	                    NPC_INFO[npcID][LastFinded] = playerid;
						SetPlayerVirtualWorld(npcID,GetPlayerVirtualWorld(playerid));
						FCNPC_SetInterior(npcID,GetPlayerInterior(playerid));
						
						NextCirclePosition(x, y, offset, nx, ny, a, radius);
						MapAndreas_FindZ_For2DCoord(nx, ny, nz);
						nz += 1;

						//SendFormatMessageToAll(-1,"[Spawn]: X: %.4f, Y: %.4f, Z: %.4f, Angle: %.4f, Offset: %.4f", nx, ny, nz, a, offset);
						FCNPC_SetPosition(npcID, nx, ny, nz);
						CURRENT_ZOMBIES++;
					}
				}
				}
		}
	}
}


PUBLIC:ResetDroneBOT(droneid)
{
    if(droneid != INVALID_PLAYER_ID && IsPlayerConnected(droneid))
    {
		new Float:x, Float:y, Float:z;
		GetPlayerPos(droneid, x, y, z);
		SetVehiclePos(NPC_INFO[droneid][NPCVehicleID], x, y, z);
	}
}

stock FreeDroneBOT(droneid , playerid)
{
	if(playerid != INVALID_PLAYER_ID)
	{
	    PlayerInfo[playerid][DRONE_ID] = INVALID_PLAYER_ID;
	}
	if(IsPlayerConnected(droneid))
	{
		NPC_INFO[droneid][LastFinded] = INVALID_PLAYER_ID;
		NPC_INFO[droneid][Attacking] = INVALID_PLAYER_ID;
        FCNPC_RemoveFromVehicle(droneid);
        RespawnearBOT(droneid);
		SetTimerEx("ResetDroneBOT", 5000, 0, "d", droneid);
	}
}

PUBLIC:GetUnusedDrone()
{
	new droneId = INVALID_PLAYER_ID;
	for(new npcID = 0; npcID < GetMaxPlayers(); npcID++)
	{
		if(IsPlayerConnected(npcID))
		{
			if(IsDroneBOT(npcID) && NPC_INFO[npcID][LastFinded] == INVALID_PLAYER_ID && !FCNPC_IsDead(npcID))
			{
			    droneId = npcID;
			}
		}
	}
	return droneId;
}

#if defined USE_ZOMBIE_RADAR
forward UpdateRadar(playerid);
public UpdateRadar(playerid)
{
    new string[256];
	if(IsPlayerConnected(playerid) && !IsZombieNPC(playerid))
	{
		if(gTeam[playerid] == Humano)
		{
			if(PlayerInfo[playerid][ZonaSegura] == 1) { string = "SI"; }
			else if(PlayerInfo[playerid][ZonaSegura] == 0) { string = "NO"; }
			if(GetTotalZombiesInPlayer(playerid) == 0)
			{
			format(string,sizeof(string), "Zona Segura: %s",string);
			}
			else
			{
			format(string,sizeof(string), "Zona Segura: %s~N~Radar Zombie: %d",string,GetTotalZombiesInPlayer(playerid));
			}
			TextDrawSetString( PlayerInfo[playerid][RadarZombie], string );
			TextDrawHideForPlayer( playerid, PlayerInfo[playerid][RadarZombie] );
			TextDrawShowForPlayer( playerid, PlayerInfo[playerid][RadarZombie] );
			return 1;
		}
		else if(gTeam[playerid] == Zombie)
		{
			TextDrawSetString( PlayerInfo[playerid][RadarZombie], " ");
		    TextDrawHideForPlayer( playerid, PlayerInfo[playerid][RadarZombie] );
		    TextDrawShowForPlayer( playerid, PlayerInfo[playerid][RadarZombie] );
		    return 1;
		}
	}
	return 1;
}
#endif
stock PlayerHaveAHackedWeapon(playerid, weaponid, ammo)
{
	new ilegal_bullets = ammo - PlayerInfo[playerid][AAH_WeaponAmmo][GetWeaponSlot(weaponid)];
	if(ilegal_bullets >= 1) return 1;
	if(weaponid > 1 && PlayerInfo[playerid][Weapon][weaponid] == false && !IsPlayerNPC(playerid) && weaponid != 40 && weaponid != 46) return 1;
	else return 0;
}
stock PlayerHaveWeapon(playerid,weap)
{
	if(weap > 1 && PlayerInfo[playerid][Weapon][weap] == true && !IsPlayerNPC(playerid) && weap != 40 && weap != 46) return 1;
	else return 0;
}

public OnPlayerUpdate(playerid)
{
    gbug_OnPlayerUpdate(playerid);
    P_OnPlayerUpdate(playerid);

	if(PlayerInfo[playerid][SC_Anim] == 1)
	{
		ApplyAnimation(playerid,"PED","SPRINT_CIVI",4.0,1,1,1,1,10000,0);
		ApplyAnimation(playerid,"PED","SPRINT_CIVI",4.0,1,1,1,1,10000,0);
		ApplyAnimation(playerid,"PED","SPRINT_CIVI",4.0,1,1,1,1,10000,0);
		ApplyAnimation(playerid,"PED","SPRINT_CIVI",4.0,1,1,1,1,10000,0);
		ApplyAnimation(playerid,"PED","SPRINT_CIVI",4.0,1,1,1,1,10000,0);
		ApplyAnimation(playerid,"PED","SPRINT_CIVI",4.0,1,1,1,1,10000,0);
		ApplyAnimation(playerid,"PED","SPRINT_CIVI",4.0,1,1,1,1,10000,0);
		ApplyAnimation(playerid,"PED","SPRINT_CIVI",4.0,1,1,1,1,10000,0);
		ApplyAnimation(playerid,"PED","SPRINT_CIVI",4.0,1,1,1,1,10000,0);
		ApplyAnimation(playerid,"PED","SPRINT_CIVI",4.0,1,1,1,1,10000,0);
		ApplyAnimation(playerid,"PED","SPRINT_CIVI",4.0,1,1,1,1,10000,0);
		ApplyAnimation(playerid,"PED","SPRINT_CIVI",4.0,1,1,1,1,10000,0);
		ApplyAnimation(playerid,"PED","SPRINT_CIVI",4.0,1,1,1,1,10000,0);
		ApplyAnimation(playerid,"PED","SPRINT_CIVI",4.0,1,1,1,1,10000,0);
		ApplyAnimation(playerid,"PED","SPRINT_CIVI",4.0,1,1,1,1,10000,0);
		ApplyAnimation(playerid,"PED","SPRINT_CIVI",4.0,1,1,1,1,10000,0);
		return 1;
	}
	if(!IsPlayerDead(playerid) && gTeam[playerid] == Humano && PlayerInfo[playerid][AntiZombie] == 0 && PlayerInfo[playerid][ZonaSegura] == 0 && PlayerInfo[playerid][MusicInicio] == 0 && PlayerInfo[playerid][SpawnProtection] == 0)
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
		{
			if(GetTickDiff( GetTickCount(), PlayerInfo[playerid][ZombieSpawnerTick] ) >= PlayerInfo[playerid][ZombieSpawnerTime])
			{
			    ///SendFormatMessageToAll(COLOR_ARTICULO,"[OnPlayerZUpdate]: %d", playerid);
			    SpawnZombies(playerid);
			    PlayerInfo[playerid][ZombieSpawnerTick] = GetTickCount();
			}
		}
	}
	return 1;
}


stock PutLazerToPlayer(playerid)
{
	if(PlayerInfo[playerid][UsaLazer] == 1 && !IsPlayerNPC(playerid))
	{
        if (GetPVarInt(playerid, "laser")) {
                RemovePlayerAttachedObject(playerid, 0);
                if ((IsPlayerInAnyVehicle(playerid)) || (IsPlayerInWater(playerid))) return 1;
                switch (GetPlayerWeapon(playerid)) {
                        case 23: {
                                if (IsPlayerAiming(playerid)) {
                                        if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // SP standing aiming
                                                0.108249, 0.030232, 0.118051, 1.468254, 350.512573, 364.284240);
                                        } else {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // SP crouched aiming
                                                0.108249, 0.030232, 0.118051, 1.468254, 349.862579, 364.784240);
                                        }
                                } else {
                                        if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // SP standing not aiming
                                                0.078248, 0.027239, 0.113051, -11.131746, 350.602722, 362.384216);
                                        } else {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // SP crouched not aiming
                                                0.078248, 0.027239, 0.113051, -11.131746, 350.602722, 362.384216);
                        }       }       }
                        case 27: {
                                if (IsPlayerAiming(playerid)) {
                                        if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // SPAS standing aiming
                                                0.588246, -0.022766, 0.138052, -11.531745, 347.712585, 352.784271);
                                        } else {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // SPAS crouched aiming
                                                0.588246, -0.022766, 0.138052, 1.468254, 350.712585, 352.784271);
                                        }
                                } else {
                                        if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // SPAS standing not aiming
                                                0.563249, -0.01976, 0.134051, -11.131746, 351.602722, 351.384216);
                                        } else {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // SPAS crouched not aiming
                                                0.563249, -0.01976, 0.134051, -11.131746, 351.602722, 351.384216);
                        }       }       }
                        case 30: {
                                if (IsPlayerAiming(playerid)) {
                                        if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // AK standing aiming
                                                0.628249, -0.027766, 0.078052, -6.621746, 352.552642, 355.084289);
                                        } else {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // AK crouched aiming
                                                0.628249, -0.027766, 0.078052, -1.621746, 356.202667, 355.084289);
                                        }
                                } else {
                                        if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // AK standing not aiming
                                                0.663249, -0.02976, 0.080051, -11.131746, 358.302734, 353.384216);
                                        } else {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // AK crouched not aiming
                                                0.663249, -0.02976, 0.080051, -11.131746, 358.302734, 353.384216);
                        }       }       }
                        case 31: {
                                if (IsPlayerAiming(playerid)) {
                                        if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // M4 standing aiming
                                                0.528249, -0.020266, 0.068052, -6.621746, 352.552642, 355.084289);
                                        } else {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // M4 crouched aiming
                                                0.528249, -0.020266, 0.068052, -1.621746, 356.202667, 355.084289);
                                        }
                                } else {
                                        if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // M4 standing not aiming
                                                0.503249, -0.02376, 0.065051, -11.131746, 357.302734, 354.484222);
                                        } else {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // M4 crouched not aiming
                                                0.503249, -0.02376, 0.065051, -11.131746, 357.302734, 354.484222);
                        }       }       }
			case 34: {
				if (IsPlayerAiming(playerid)) {

					return 1;
				} else {
					if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // Sniper standing not aiming
						0.658248, -0.03276, 0.133051, -11.631746, 355.302673, 353.584259);
					} else {
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // Sniper crouched not aiming
						0.658248, -0.03276, 0.133051, -11.631746, 355.302673, 353.584259);
			}	}	}
                        case 29: {
                                if (IsPlayerAiming(playerid)) {
                                        if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // MP5 standing aiming
                                                0.298249, -0.02776, 0.158052, -11.631746, 359.302673, 357.584259);
                                        } else {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // MP5 crouched aiming
                                                0.298249, -0.02776, 0.158052, 8.368253, 358.302673, 352.584259);
                                        }
                                } else {
                                        if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // MP5 standing not aiming
                                                0.293249, -0.027759, 0.195051, -12.131746, 354.302734, 352.484222);
                                        } else {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, // MP5 crouched not aiming
                                                0.293249, -0.027759, 0.195051, -12.131746, 354.302734, 352.484222);
        }       }       }       }       }
	}
	return 1;
}

stock GetWeaponModel(weaponid)
{
	switch(weaponid)
	{
	    case 1:
	        return 331;

		case 2..8:
		    return weaponid+331;

        case 9:
		    return 341;

		case 10..15:
			return weaponid+311;

		case 16..18:
		    return weaponid+326;

		case 22..29:
		    return weaponid+324;

		case 30,31:
		    return weaponid+325;

		case 32:
		    return 372;

		case 33..45:
		    return weaponid+324;

		case 46:
		    return 371;
	}
	return 0;
}

stock GetWeaponIDFromName(WeaponName[])
{
	if(strfind("molotov",WeaponName,true)!=-1) return 18;
	for(new i = 0; i <= 46; i++)
	{
		switch(i)
		{
			case 0,19,20,21,44,45: continue;
			default:
			{
				new name[32]; GetWeaponName(i,name,32);
				if(strfind(name,WeaponName,true) != -1) return i;
			}
		}
	}
	return -1;
}

#if defined SistemaDECombustible

 //SISTEMA DE COMBUSTIBLE
forward Actualizar();
public Actualizar()
{
	new
		i = ConnectedPlayers-1,
		szString[4][48],
		Float:EstadoV,
		vehicleid,
		VelocidadVeh;
	while(--i > -1)
	{
	    if(!IsPlayerInAnyVehicle(i)) continue;
	    else {
			vehicleid = GetPlayerVehicleID(i);
			GetVehicleHealth(vehicleid, EstadoV);
			VelocidadVeh = GetSpeed(i);

            format(szString[1], 48,"~b~~h~Vehiculo: ~w~%s",Vehicles[GetVehicleModel(vehicleid)-400]);
			format(szString[0], 48,"~g~~h~Velocidad: ~w~%d Km/h", VelocidadVeh);
		    format(szString[2], 48,"~y~~h~Estado: ~w~%0.0f%%",EstadoV/10);
		    format(szString[3], 48,"~r~~h~Gasolina: ~w~%i Litros",Gas[vehicleid]);
		    //======================================================================================//
		    TextDrawSetString(Vehiculo[i], szString[1]), TextDrawSetString(Velocidad[i], szString[0]);
		    TextDrawSetString(Estado[i], szString[2]), TextDrawSetString(Gasolina[i], szString[3]);
		    TextDrawShowForPlayer(i, Vehiculo[i]),  TextDrawShowForPlayer(i, Velocidad[i]),
		    TextDrawShowForPlayer(i, Espacio[i]), TextDrawShowForPlayer(i, Espacio2[i]),
		    TextDrawShowForPlayer(i, Gasolina[i]), TextDrawShowForPlayer(i, Espacio3[i]),
		    TextDrawShowForPlayer(i, Espacio4[i]), TextDrawShowForPlayer(i, Estado[i]),
		    TextDrawShowForPlayer(i, Espacio5[i]), TextDrawShowForPlayer(i, Espacio6[i]),
		    TextDrawShowForPlayer(i, Espacio7[i]);
            //=========================================================//
		    SetPlayerProgressBarMaxValue(i, Velocidadbar[i], 300.0);
		    SetPlayerProgressBarValue(i, Velocidadbar[i], VelocidadVeh);
		    UpdatePlayerProgressBar(i, Velocidadbar[i]);
		    //=========================================================//
		    SetPlayerProgressBarMaxValue(i, Estadobar[i], 100);
		    SetPlayerProgressBarValue(i, Estadobar[i], EstadoV/10);
		    UpdatePlayerProgressBar(i, Estadobar[i]);
		    //=========================================================//
		    SetPlayerProgressBarMaxValue(i, Gasolinabar[i], 100);
		    SetPlayerProgressBarValue(i, Gasolinabar[i], Gas[vehicleid]);
		    UpdatePlayerProgressBar(i, Gasolinabar[i]);

		}
	}
	return 1;
}

stock GetSpeed(playerid, mode = 1)
{
	new Float:Velocidade [3];
	GetVehicleVelocity(GetPlayerVehicleID(playerid),Velocidade[0],Velocidade[1],Velocidade [2]);
	return IsPlayerInAnyVehicle(playerid)?floatround(((floatsqroot(((Velocidade[0]*Velocidade[0])+(Velocidade[1]*Velocidade[1])+(Velocidade[2]*Velocidade[2])))*(!mode?105.0:170.0)))*1):0;
}

forward PlayerVelo(playerid);
public PlayerVelo(playerid)
{
	Vehiculo[playerid] = TextDrawCreate(500.000000, 342.000000, "Vehiculo: Vergamovil");
	TextDrawBackgroundColor(Vehiculo[playerid], 255);
	TextDrawFont(Vehiculo[playerid], 1);
	TextDrawLetterSize(Vehiculo[playerid], 0.310000, 1.000000);
	TextDrawColor(Vehiculo[playerid], -1);
	TextDrawSetOutline(Vehiculo[playerid], 0);
	TextDrawSetProportional(Vehiculo[playerid], 1);
	TextDrawSetShadow(Vehiculo[playerid], 1);
	TextDrawUseBox(Vehiculo[playerid], 1);
	TextDrawBoxColor(Vehiculo[playerid], 103);
	TextDrawTextSize(Vehiculo[playerid], 614.000000, 1.000000);

	Velocidad[playerid] = TextDrawCreate(500.000000, 357.000000, "Velocidad: 130 km/h");
	TextDrawBackgroundColor(Velocidad[playerid], 255);
	TextDrawFont(Velocidad[playerid], 1);
	TextDrawLetterSize(Velocidad[playerid], 0.310000, 1.000000);
	TextDrawColor(Velocidad[playerid], -1);
	TextDrawSetOutline(Velocidad[playerid], 0);
	TextDrawSetProportional(Velocidad[playerid], 1);
	TextDrawSetShadow(Velocidad[playerid], 1);
	TextDrawUseBox(Velocidad[playerid], 1);
	TextDrawBoxColor(Velocidad[playerid], 103);
	TextDrawTextSize(Velocidad[playerid], 614.000000, 1.000000);

	Espacio[playerid] = TextDrawCreate(500.000000, 372.000000, "     ");
	TextDrawBackgroundColor(Espacio[playerid], 255);
	TextDrawFont(Espacio[playerid], 1);
	TextDrawLetterSize(Espacio[playerid], 0.310000, 1.000000);
	TextDrawColor(Espacio[playerid], -1);
	TextDrawSetOutline(Espacio[playerid], 0);
	TextDrawSetProportional(Espacio[playerid], 1);
	TextDrawSetShadow(Espacio[playerid], 1);
	TextDrawUseBox(Espacio[playerid], 1);
	TextDrawBoxColor(Espacio[playerid], 103);
	TextDrawTextSize(Espacio[playerid], 614.000000, 1.000000);

	Espacio2[playerid] = TextDrawCreate(500.000000, 378.000000, "     ");
	TextDrawBackgroundColor(Espacio2[playerid], 255);
	TextDrawFont(Espacio2[playerid], 1);
	TextDrawLetterSize(Espacio2[playerid], 0.310000, 1.000000);
	TextDrawColor(Espacio2[playerid], -1);
	TextDrawSetOutline(Espacio2[playerid], 0);
	TextDrawSetProportional(Espacio2[playerid], 1);
	TextDrawSetShadow(Espacio2[playerid], 1);
	TextDrawUseBox(Espacio2[playerid], 1);
	TextDrawBoxColor(Espacio2[playerid], 103);
	TextDrawTextSize(Espacio2[playerid], 614.000000, 1.000000);

	Gasolina[playerid] = TextDrawCreate(500.000000, 384.000000, "Gasolina: 100%");
	TextDrawBackgroundColor(Gasolina[playerid], 255);
	TextDrawFont(Gasolina[playerid], 1);
	TextDrawLetterSize(Gasolina[playerid], 0.310000, 1.000000);
	TextDrawColor(Gasolina[playerid], -1);
	TextDrawSetOutline(Gasolina[playerid], 0);
	TextDrawSetProportional(Gasolina[playerid], 1);
	TextDrawSetShadow(Gasolina[playerid], 1);
	TextDrawUseBox(Gasolina[playerid], 1);
	TextDrawBoxColor(Gasolina[playerid], 103);
	TextDrawTextSize(Gasolina[playerid], 614.000000, 1.000000);

	Espacio3[playerid] = TextDrawCreate(500.000000, 399.000000, "   ");
	TextDrawBackgroundColor(Espacio3[playerid], 255);
	TextDrawFont(Espacio3[playerid], 1);
	TextDrawLetterSize(Espacio3[playerid], 0.310000, 1.000000);
	TextDrawColor(Espacio3[playerid], -1);
	TextDrawSetOutline(Espacio3[playerid], 0);
	TextDrawSetProportional(Espacio3[playerid], 1);
	TextDrawSetShadow(Espacio3[playerid], 1);
	TextDrawUseBox(Espacio3[playerid], 1);
	TextDrawBoxColor(Espacio3[playerid], 103);
	TextDrawTextSize(Espacio3[playerid], 614.000000, 1.000000);

	Espacio4[playerid] = TextDrawCreate(500.000000, 405.000000, "   ");
	TextDrawBackgroundColor(Espacio4[playerid], 255);
	TextDrawFont(Espacio4[playerid], 1);
	TextDrawLetterSize(Espacio4[playerid], 0.310000, 1.000000);
	TextDrawColor(Espacio4[playerid], -1);
	TextDrawSetOutline(Espacio4[playerid], 0);
	TextDrawSetProportional(Espacio4[playerid], 1);
	TextDrawSetShadow(Espacio4[playerid], 1);
	TextDrawUseBox(Espacio4[playerid], 1);
	TextDrawBoxColor(Espacio4[playerid], 103);
	TextDrawTextSize(Espacio4[playerid], 614.000000, 1.000000);

	Estado[playerid] = TextDrawCreate(500.000000, 411.000000, "Estado: 1000");
	TextDrawBackgroundColor(Estado[playerid], 255);
	TextDrawFont(Estado[playerid], 1);
	TextDrawLetterSize(Estado[playerid], 0.310000, 1.000000);
	TextDrawColor(Estado[playerid], -1);
	TextDrawSetOutline(Estado[playerid], 0);
	TextDrawSetProportional(Estado[playerid], 1);
	TextDrawSetShadow(Estado[playerid], 1);
	TextDrawUseBox(Estado[playerid], 1);
	TextDrawBoxColor(Estado[playerid], 103);
	TextDrawTextSize(Estado[playerid], 614.000000, 1.000000);

	Espacio5[playerid] = TextDrawCreate(500.000000, 426.000000, "   ");
	TextDrawBackgroundColor(Espacio5[playerid], 255);
	TextDrawFont(Espacio5[playerid], 1);
	TextDrawLetterSize(Espacio5[playerid], 0.310000, 1.000000);
	TextDrawColor(Espacio5[playerid], -1);
	TextDrawSetOutline(Espacio5[playerid], 0);
	TextDrawSetProportional(Espacio5[playerid], 1);
	TextDrawSetShadow(Espacio5[playerid], 1);
	TextDrawUseBox(Espacio5[playerid], 1);
	TextDrawBoxColor(Espacio5[playerid], 103);
	TextDrawTextSize(Espacio5[playerid], 614.000000, 1.000000);

	Espacio6[playerid] = TextDrawCreate(500.000000, 432.000000, "   ");
	TextDrawBackgroundColor(Espacio6[playerid], 255);
	TextDrawFont(Espacio6[playerid], 1);
	TextDrawLetterSize(Espacio6[playerid], 0.310000, 1.000000);
	TextDrawColor(Espacio6[playerid], -1);
	TextDrawSetOutline(Espacio6[playerid], 0);
	TextDrawSetProportional(Espacio6[playerid], 1);
	TextDrawSetShadow(Espacio6[playerid], 1);
	TextDrawUseBox(Espacio6[playerid], 1);
	TextDrawBoxColor(Espacio6[playerid], 103);
	TextDrawTextSize(Espacio6[playerid], 614.000000, 1.000000);

	Espacio7[playerid] = TextDrawCreate(500.000000, 438.000000, "   ");
	TextDrawBackgroundColor(Espacio7[playerid], 255);
	TextDrawFont(Espacio7[playerid], 1);
	TextDrawLetterSize(Espacio7[playerid], 0.310000, 1.000000);
	TextDrawColor(Espacio7[playerid], -1);
	TextDrawSetOutline(Espacio7[playerid], 0);
	TextDrawSetProportional(Espacio7[playerid], 1);
	TextDrawSetShadow(Espacio7[playerid], 1);
	TextDrawUseBox(Espacio7[playerid], 1);
	TextDrawBoxColor(Espacio7[playerid], 103);
	TextDrawTextSize(Espacio7[playerid], 614.000000, 1.000000);

    Velocidadbar[playerid] = CreatePlayerProgressBar(playerid, 504.00, 375.00, 97.50, 3.20, 0x85DFFFFF, 100.0);
	Gasolinabar[playerid] = CreatePlayerProgressBar(playerid, 504.00, 401.00, 98.50, 3.20, 0xD2FF9DFF, 100.0);
	Estadobar[playerid] = CreatePlayerProgressBar(playerid, 504.00, 429.00, 98.50, 3.20, 0x9EEBCFFF, 100.0);
	return 1;
}

forward BorrarPlayerVelo(playerid);
public BorrarPlayerVelo(playerid)
{
	TextDrawHideForPlayer(playerid, Vehiculo[playerid]);
	TextDrawHideForPlayer(playerid, Velocidad[playerid]);
	TextDrawHideForPlayer(playerid, Espacio[playerid]);
	TextDrawHideForPlayer(playerid, Espacio2[playerid]);
	TextDrawHideForPlayer(playerid, Gasolina[playerid]);
	TextDrawHideForPlayer(playerid, Espacio3[playerid]);
	TextDrawHideForPlayer(playerid, Espacio4[playerid]);
	TextDrawHideForPlayer(playerid, Estado[playerid]);
	TextDrawHideForPlayer(playerid, Espacio5[playerid]);
	TextDrawHideForPlayer(playerid, Espacio6[playerid]);
	TextDrawHideForPlayer(playerid, Espacio7[playerid]);
	HidePlayerProgressBar(playerid, Velocidadbar[playerid]);
	HidePlayerProgressBar(playerid, Estadobar[playerid]);
	HidePlayerProgressBar(playerid, Gasolinabar[playerid]);
	return 1;
}

public GasolinaBaja()
{
    for(new i=0;i<GetMaxPlayers();i++)
	{
	 	if(Rellenando[i]) continue;
	  		new vehicleid = GetPlayerVehicleID(i);
	  	    if(gTeam[i] == Humano){
			Gas[vehicleid] = Gas[vehicleid] -1;
			}
		   	if(GetPlayerVehicleSeat(i) == 0 && VehicleOccupied(vehicleid))
		   	{
			    if(Gas[vehicleid] < 1)
			    {
			    	Gas[vehicleid] = 0;
			    	new engine, lights, alarm, doors, bonnet, boot, objective;
					GetVehicleParamsEx(vehicleid,engine, lights, alarm, doors, bonnet, boot, objective);
					SetVehicleParamsEx(vehicleid,VEHICLE_PARAMS_OFF,lights,alarm,doors,bonnet,boot,objective);
			      	GameTextForPlayer(i,"~r~Estas sin ~w~gasolina~r~.~n~~w~/gas~b~~h~para recargar.",5000,4);
			    }
		    }
    }
    return 1;
}

public TiempoRelleno(playerid,gCantidad)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    Gas[vehicleid] = Gas[vehicleid] + gCantidad;
    if(Gas[vehicleid] > 100)
    {
        Gas[vehicleid] = 100;
    }
    Rellenando[playerid] = 0;
    new gSTRING[256];
    GameTextForPlayer(playerid,"~R~COMBUSTIBLE ~W~RECARGANDO!.",2500,3);
    format(gSTRING,sizeof(gSTRING),"~r~~h~Gasolina: ~w~%d Litros",gCantidad);
    TextDrawSetString(Gasolina[playerid],gSTRING);
    new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(GetPlayerVehicleID(playerid),engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid,VEHICLE_PARAMS_ON,lights,alarm,doors,bonnet,boot,objective);
	return 1;
}

#endif


//==============================================================================
//        //SPAWNS GENERALES
//==============================================================================


new Float:SPAWNS_DRONES[][] =
{
{-8757.4590,3155.6096,150.0020,65.2884}, // WATER_DRONE_SPAWN
{-9059.7324,3190.5842,157.5648,109.6368}, // WATER_DRONE_SPAWN
{-9301.7402,3138.2024,137.2381,88.0848}, // WATER_DRONE_SPAWN
{-9484.7998,3205.4338,113.9015,62.0579}, // WATER_DRONE_SPAWN
{-9668.6445,3271.4392,129.8182,86.9274}, // WATER_DRONE_SPAWN
{-9848.9619,3261.7925,129.0473,94.7378}, // WATER_DRONE_SPAWN
{-10011.7578,3276.5823,99.3412,77.5698}, // WATER_DRONE_SPAWN
{-10140.4424,3319.5029,100.4301,68.9591}, // WATER_DRONE_SPAWN
{-10278.7080,3399.7539,101.7800,56.5954}, // WATER_DRONE_SPAWN
{-10459.0176,3479.8655,103.2271,79.2527}, // WATER_DRONE_SPAWN
{-10631.0273,3478.0276,102.7546,96.4381}, // WATER_DRONE_SPAWN
{-10797.0859,3431.3650,95.8788,108.9628}, // WATER_DRONE_SPAWN
{-10986.5410,3356.9395,86.8448,106.4066}, // WATER_DRONE_SPAWN
{-11157.4170,3352.1187,74.4260,77.2292}, // WATER_DRONE_SPAWN
{-11322.8770,3415.1763,77.4197,66.3431}, // WATER_DRONE_SPAWN
{-11593.2559,3494.0618,96.2669,86.4680}, // WATER_DRONE_SPAWN
{-11880.0674,3437.4160,74.7029,109.3632} // WATER_DRONE_SPAWN
};

new Float:SPAWNS_HUMANOS[][] =
{
{-1904.1598,-1681.0264,23.0156,352.5283}, // BASESPAWN
{-1914.8147,-1680.6531,23.0156,318.6045}, // BASESPAWN
{-1916.8733,-1662.2369,23.0156,243.5708}, // BASESPAWN
{-1904.2340,-1662.0745,23.0156,221.5119}, // BASESPAWN
{-1894.5406,-1660.5255,23.0156,224.1858}, // BASESPAWN
{-1894.5193,-1682.3502,23.0156,291.6993}, // BASESPAWN
{-1872.1736,-1676.2157,21.7500,78.7583}, // BASESPAWN
{-1849.3600,-1681.3877,23.2031,97.0924}, // BASESPAWN
{-1832.1920,-1661.9253,21.7500,62.5002}, // BASESPAWN
{-1847.9186,-1635.0280,21.7500,123.3291}, // BASESPAWN
{-1860.7898,-1629.6525,21.9030,113.6366}, // BASESPAWN
{-1861.8994,-1620.8365,21.9513,192.8677}, // BASESPAWN
{-1858.7103,-1610.3638,21.7578,195.0599}, // BASESPAWN
{-1849.5515,-1611.0341,21.7578,163.9769}, // BASESPAWN
{-1847.2246,-1619.0416,21.8778,141.2496}, // BASESPAWN
{-1814.1178,-1629.3691,23.0156,122.9949}, // BASESPAWN
{-1827.4474,-1629.9261,23.0156,175.3011}, // BASESPAWN
{-1823.9597,-1613.4440,23.0215,203.3761}, // BASESPAWN
{-1813.3829,-1619.7606,23.0156,155.4147}, // BASESPAWN
{-1819.3903,-1646.8539,21.7500,113.1352}, // BASESPAWN
{706.2559,-1672.5745,3.4375,0.8125}, // LSSPAWN
{825.9836,-1935.6868,12.8672,350.4122}, // HNSPAWN
{1214.6958,-1655.5663,11.7969,287.4989}, // HNSPAWN
{1153.8123,-1181.1326,32.8277,275.6825}, // HNWSPAWN
{922.8597,-919.3399,42.6016,138.4915}, // HNSPAWN
{1462.0364,-1012.7802,26.8438,174.0469}, // HNSPAWN
{2112.7305,-1599.2000,13.5528,157.7091}, // HNSPAWN
{2427.0208,-1674.6893,13.6595,351.8941}, // HNSPAWN
{2191.3369,-1342.2372,23.9844,276.1911}, // HNSPAWN
{2690.4312,-1062.5560,69.4821,188.4175}, // HNSPAWN
{2010.5435,-1024.7809,25.5166,56.0839}, // HNSPAWN
{2006.4824,-1030.8754,24.7912,104.9544}, // HNSPAWN
{1229.6068,-1457.9193,13.5465,18.0557}, // HNSPAWN
{1223.0729,-1448.3501,13.4425,334.4394}, // HNSPAWN
{1227.0955,-1439.0316,13.5385,31.5919}, // HNSPAWN
{1213.4386,-1434.4319,13.3945,349.9808}, // HNSPAWN
{1099.5597,-820.2560,86.9453,135.8555}, // HNSPAWN
{1097.5160,-826.3519,86.9453,65.8353}, // HNSPAWN
{1093.5980,-805.6288,107.4199,7.8474}, // HNSPAWN
{1667.3521,-946.9459,43.1852,181.8119}, // HNSPAWN
{1593.9740,-993.1099,38.6068,301.5039}, // HNSPAWN
{1644.8628,-1055.6517,23.8984,179.3446}, // HNSPAWN
{1625.6204,-1150.5559,24.1228,218.6160}, // HNSPAWN
{1968.7328,-1157.0634,20.9669,90.9222}, // HNSPAWN
{1976.1987,-1234.9169,20.0469,275.9356}, // HNSPAWN
{1953.8500,-1380.2838,24.1484,6.8449}, // HNSPAWN
{1804.6184,-1348.0240,15.2653,263.3626}, // HNSPAWN
{1775.9148,-1397.7294,15.7578,7.3067}, // HNSPAWN
{1854.8384,-1508.7162,3.6485,357.6536}, // HNSPAWN
{1681.4236,-1672.9176,13.5469,254.1716}, // HNSPAWN
{1155.3916,-2018.3964,69.0078,246.4843}, // HNSPAWN
{1937.5942,-1634.4053,136.0366,177.7586}, // HNSPAWN
{1939.4586,-1430.5146,89.7400,18.2274}, // HNSPAWN
{1430.2617,-1604.2202,195.3159,227.9194}, // HNSPAWN
{1151.7578,-1356.7837,119.8246,346.8872}, // HNSPAWN
{2163.8584,-1804.4264,13.3700,305.8582}, // HNSPAWN
{2431.6672,-1637.1458,13.4419,192.9296}, // HNSPAWN
{1641.1766,-1900.6906,13.5515,16.9039}, // HNSPAWN
{726.0665,-1776.7230,6.4796,1.0759}, // HNSPAWN
{-2684.7568,1933.7684,217.2739,202.5742}, // HSNPSPAWN
{-2688.4128,1594.7520,217.2739,181.7246}, // HSNPSPAWN
{-1753.7156,885.1211,295.8750,351.8453}, // HSNPSPAWN
{-1769.4165,580.2787,242.0156,300.2076}, // HSNPSPAWN
{-1590.2018,-359.3700,6.0068,255.4214}, // HSNPSPAWN
{-1434.1947,-540.0987,14.1719,219.4921}, // HSNPSPAWN
{-1353.8480,-499.2520,14.1719,192.3805}, // HSNPSPAWN
{-1025.2822,-665.1766,32.0078,35.9631}, // HSNPSPAWN
{-1053.1351,-672.1834,32.3516,312.4068}, // HSNPSPAWN
{-1076.0131,-1114.0259,127.9639,276.7234}, // HSNPSPAWN
{-1105.0624,-1620.8762,76.3672,272.3785}, // HSNPSPAWN
{-293.2996,-2014.5674,22.8359,259.5846}, // HSNPSPAWN
{-258.8656,-2181.6116,29.0185,119.3771}, // HSNPSPAWN
{-173.3681,-2645.9446,26.8276,350.6268}, // HSNPSPAWN
{-491.3728,-2816.9573,47.8624,277.3921}, // HSNPSPAWN
{-995.4709,-2638.1868,103.4255,322.9250}, // HSNPSPAWN
{-1160.6328,-2328.6689,27.3948,160.5804}, // HSNPSPAWN
{-1178.2266,-2392.1965,35.5387,7.1710}, // HSNPSPAWN
{-1169.3168,-2363.4045,20.6384,60.1457}, // HSNPSPAWN
{-374.6891,-1898.6478,12.4491,34.4101}, // HSNPSPAWN
{-90.5130,-1168.4639,2.4178,61.6495}, // HSNPSPAWN
{112.6877,-1021.2488,22.1809,89.2232}, // HSNPSPAWN
{-97.0773,-1023.6684,14.5020,99.0828}, // HSNPSPAWN
{-709.2955,-1595.1685,54.9117,13.8553}, // HSNPSPAWN
{-581.5892,-1759.4591,92.9930,321.8834}, // HSNPSPAWN
{155.5982,-1955.4596,3.7734,2.1181}, // HSNPSPAWN
{370.5459,-1723.3209,7.1870,356.6035}, // HSNPSPAWN
{1331.6670,-2378.8098,13.3750,0.2406}, // HSNPSPAWN
{1680.0120,-2330.6755,-2.6797,310.4407}, // HSNPSPAWN
{2874.0620,-1877.0911,12.0859,176.2494}, // HSNPSPAWN
{2688.6641,-1675.5531,277.6040,93.2678}, // HSNPSPAWN
{2789.0164,-440.9119,10.9844,329.0298} // HSNPSPAWN

};

new Float:SPAWNS_ZOMBIES_BOT[][] =
{
{-13790.0293,8916.7393,133.7786,38.4671}, // NULL_POS
{-13879.9834,9054.9092,126.3806,26.0455}, // NULL_POS
{-13912.4551,9169.1270,125.3792,12.7446}, // NULL_POS
{-13931.9307,9299.9629,125.6017,7.8903}, // NULL_POS
{-13964.2158,9472.5723,120.2550,20.0752}, // NULL_POS
{-14019.9287,9576.4961,114.1959,35.3910}, // NULL_POS
{-14131.9014,9687.5166,112.0897,57.0364}, // NULL_POS
{-14258.5527,9739.6777,106.6934,77.7351}, // NULL_POS
{-14380.3516,9752.8301,109.6187,91.1650}, // NULL_POS
{-14491.0264,9729.6855,110.3631,107.8634}, // NULL_POS
{-14553.2617,9704.6104,111.2582,111.6656}, // NULL_POS
{-14661.7852,9651.7871,117.7199,116.4760}, // NULL_POS
{-14842.9941,9574.5117,127.9566,104.9890}, // NULL_POS
{-14952.0635,9571.0752,121.6255,87.1700}, // NULL_POS
{-15074.2061,9606.7500,104.7275,68.2066}, // NULL_POS
{-15161.1953,9665.1240,87.1190,50.2316}, // NULL_POS
{-15238.1299,9739.8164,82.4229,45.5494}, // NULL_POS
{-15331.8486,9820.4082,82.1579,58.4052}, // NULL_POS
{-15447.8164,9854.4492,82.3568,89.2694}, // NULL_POS
{-15598.7422,9827.9482,69.6557,102.7657}, // NULL_POS
{-15755.8330,9783.6104,35.9206,106.2306}, // NULL_POS
{-15947.6943,9731.4580,59.7491,105.1164}, // NULL_POS
{-16230.9922,9654.9951,122.0465,105.0645}, // NULL_POS
{-16589.4180,9715.9053,101.6043,43.7797}, // NULL_POS
{-16715.0293,9977.6006,106.4858,26.8939} // NULL_POS
};


new Float:SPAWNS_ZOMBIES[][] =
{

{1654.369995,-1880.910766,13.087362},
{1815.672363,-1809.881347,13.564261},
{1917.478881,-1744.546142,13.087889},
{2011.460449,-1619.299072,13.179129},
{1889.680541,-1495.408203,2.770544},
{1779.070190,-1451.091552,12.919712},
{1693.937622,-1324.094848,16.996732},
{2718.629150,-1447.414916,29.801517},
{2725.496093,-1663.494018,12.790019},
{2861.295410,-1615.017089,10.623928},
{2873.784423,-1327.071899,10.626550},
{2837.893554,-995.149353,20.529458},
{2113.788085,-1096.162231,24.641426},
{2057.692382,-1157.545410,23.406530},
{1662.569213,-1284.119384,14.103080},
{1430.162353,-1571.504882,12.893205},
{1472.417236,-1653.284912,13.587731},
{1535.235961,-1656.466308,13.030571},
{1478.650024,-1732.085693,12.927549},
{1570.221069,-1854.025878,12.923980},
{1534.848388,-2047.756225,31.172855},
{1804.214965,-2168.861816,12.924173},
{2257.026611,-2110.210937,13.213011},
{2736.035400,-2056.598388,12.763998},
{2828.962890,-1986.252929,10.405857},
{2746.633300,-1882.711059,10.595859},
{2637.464355,-1771.542114,10.286512},
{1508.435058,-1197.996948,23.310150},
{1341.783081,-1262.677368,13.042411},
{1290.962036,-1533.829223,13.148847},
{1376.472167,-1896.097900,13.144840},
{1727.666015,-1858.337280,13.051687},
{1804.408081,-1843.494384,13.241397},
{1119.618286,-1510.619384,15.791276},
{1142.958862,-1439.191528,15.796875},
{1083.277099,-1386.056152,13.792040},
{925.838745,-1630.989868,13.546875},
{850.392639,-1776.516113,13.682462},
{836.178344,-2054.933837,12.867187},
{823.493591,-1903.358520,12.867187},
{597.892822,-1896.774291,2.993758},
{108.866073,-1682.902343,9.353202},
{386.738647,-1343.619506,14.244997},
{547.901977,-1230.538574,16.645702},
{697.370544,-1144.628295,15.522178},
{851.740051,-1019.277954,28.093061},
{1027.625000,-960.349670,41.877590},
{1435.205322,-938.255493,35.812355}

};

stock SetPlayerAvailableVirtualWorld(playerid)
{
	new selected_world = INVALID_VIRTUAL_WORLD;
    for(new w = 1; w < MAX_VIRTUAL_WORLDS; w++)
    {
        if(w == MAX_VIRTUAL_WORLDS)
        {
            //printf("Todos los worlds estan agotados para %s; world %d, intentando otra vez..", PlayerName2(playerid),w);
            return selected_world;
        }
        else if(WorldUsed[w] == 0)
        {
            WorldUsed[w] = 1;
        	SetPlayerVirtualWorld(playerid,w);
        	//printf("World Seleccionado para %s; world %d, rompiendo loop..", PlayerName2(playerid),w);
		 	selected_world = w;
		 	return w;
		}
    }
    return selected_world;
}

forward RespawnearBOT(npcid);
public RespawnearBOT(npcid)
{
    FCNPC_Respawn(npcid);
	if(NPC_INFO[npcid][InCORE] == 1)
	{
		NPC_INFO[npcid][Attacking] = INVALID_PLAYER_ID;
		NPC_INFO[npcid][LastFinded] = INVALID_PLAYER_ID;
	    ZS_Tick[npcid] = -1;
		FCNPC_SetInterior(npcid,0);
	    SetPlayerColor(npcid,BOT_ZOMBIE_COLOR_CORE);
		gTeam[npcid] = Zombie;
		SetPlayerTeam(npcid, Zombie);
		if(NPC_NEMESIS[npcid] == 1)	{SetNPCHealth(npcid, 1000);	}else{SetNPCHealth(npcid, 100);}
		SetPlayerVirtualWorld(npcid,0);
	 	NPC_INFO[npcid][BType] = randomEx(0, 4);
	 	#if defined NPCBars
		UpdateNPCHealth(npcid);
		#endif
		//NPC_INFO[npcid][CoreStep] = 0;
	    SpawnCorePlayer(npcid);//enviar npc al ataque :D
	}
	else if(IsZombieNPC(npcid))
	{
		NPC_INFO[npcid][Attacking] = INVALID_PLAYER_ID;
		NPC_INFO[npcid][LastFinded] = INVALID_PLAYER_ID;
		new Random = random(sizeof(SPAWNS_ZOMBIES_BOT));
		FCNPC_SetPosition(npcid,random(5) - random(5) + SPAWNS_ZOMBIES_BOT[Random][0], random(5) - random(5) + SPAWNS_ZOMBIES_BOT[Random][1], SPAWNS_ZOMBIES_BOT[Random][2]);
		//FCNPC_SetSkin(npcid, Zombie_Skins[random(sizeof(Zombie_Skins))]);
		FCNPC_SetInterior(npcid,0);
	    SetPlayerColor(npcid,BOT_ZOMBIE_COLOR);
	    if(NPC_NEMESIS[npcid]){SetPlayerColor(npcid,0xCC00FFAA);}
		gTeam[npcid] = Zombie;
		SetPlayerTeam(npcid, Zombie);
		if(NPC_NEMESIS[npcid] == 1)	{SetNPCHealth(npcid, 1000);	}else{SetNPCHealth(npcid, 100);}

		SetPlayerVirtualWorld(npcid,0);
	    ZS_Tick[npcid] = -1;
	 	NPC_INFO[npcid][BType] = randomEx(0, 4);
	 	#if defined NPCBars
		UpdateNPCHealth(npcid);
		#endif
		if(FCNPC_GetSkin(npcid) != 163 && NPC_NEMESIS[npcid] == 1)
		{
			FCNPC_SetSkin(npcid, 163);
		}
		//ApplyAnimation(npcid,NPC_Walking_Library[npcid],NPC_Walking_Style[npcid],4.1,1,1,1,1,1);
	}
	else if(IsDroneBOT(npcid))
	{
		new Random = random(sizeof(SPAWNS_DRONES));
		FCNPC_SetPosition(npcid, random(5) - random(15) + SPAWNS_DRONES[Random][0], random(15) - random(5) + SPAWNS_DRONES[Random][1], SPAWNS_DRONES[Random][2]);

		SetVehiclePos(NPC_INFO[npcid][NPCVehicleID], random(5) - random(15) + SPAWNS_DRONES[Random][0], random(15) - random(5) + SPAWNS_DRONES[Random][1], SPAWNS_DRONES[Random][2]);
		NPC_INFO[npcid][LastFinded] = INVALID_PLAYER_ID;
		NPC_INFO[npcid][Attacking] = INVALID_PLAYER_ID;
		FCNPC_RemoveFromVehicle(npcid);
		gTeam[npcid] = Humano;
		SetPlayerTeam(npcid, Humano);
		SetPlayerColor(npcid, DRONE_COLOR);
		FCNPC_SetInterior(npcid,0);
	}
    return 1;
}


//==============================================================================
// Public - OnPlayerSpawn.
//==============================================================================
public OnPlayerSpawn(playerid)
{
if(PlayerInfo[playerid][IgnoreSpawn])
{
	PlayerInfo[playerid][IgnoreSpawn] = false;
	return 1;
}
NOH_OnPlayerSpawn(playerid);
P_OnPlayerSpawn(playerid);
if(!IsPlayerNPC(playerid))
{
	if(PlayerInfo[playerid][Identificado] == 0) return Kick(playerid);
    //OnPlayerSpawnOK(playerid);
    SetCameraBehindPlayer(playerid);
    #if defined USE_SOBEIT_CAMERA_DETECTION
    if(PlayerInfo[playerid][MusicInicio] == 1)
    {
	    SetPlayerPos(playerid,-72.4389,-127.2939,2.4107);
	    SetPlayerPos(playerid,-72.4389,-127.2939,2.4107);
	    SetPlayerPos(playerid,-72.4389,-127.2939,2.4107);
	    SetPlayerPos(playerid,-72.4389,-127.2939,2.4107);
        CheckPlayerForSobeit(playerid);
	}
	else
	{
	    OnPlayerSpawnOK(playerid);
	}
	#else
	//SetPlayerSkin(playerid,GetPlayerSkin(playerid));
	TogglePlayerControllable(playerid, true);
	if(PlayerInfo[playerid][MusicInicio] == 1)
	{
	    CheckRZClientRestricted(playerid);
		//StopAudioStreamForPlayerEx(playerid);
		//ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{00FFFF}RZUpdate: {FF0099}SafeZone", "{FFFFFF}Actualización {FF0099}SafeZone\n{ffffff}- Iconos de las zonas seguras actualizados!\n-Corregidos bugs de los cientificos.\n-Mortalidad de Cerebro Incrementada!\n-Spawns Humanos actualizados.\n-Nuevo núcleo número 6." , "OK", "");
		//ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{00FFFF}RZUpdate: {FF0099}Drone Beta", "{FFFFFF}Actualización {FF0099}Drone Beta\n{ffffff}- Se añadieron drones inteligentes anti zombies." , "OK", "");
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFFF00}Server update: {FF0000}Infected Zone", "{FFFFFF}Actualización {FF0000}InfectedZone\n{FF00FF}- Zonas de Extrema infección añadidas!\n{ffffff}- Nuevo NPCZombie Disponible: {{FF00FF}}Heart.\n{ffffff}- Modo cinemática añadido.\n- Spawns Humanos actualizados.\n- Corrección de bugs y optimización interna." , "OK", "");

	}
	OnPlayerSpawnOK(playerid);
	if(CallRemoteFunction("GetPlayerHackStatus", "d", playerid) == 1 && !IsPlayerAdmin(playerid))
	{
		new string[256];
		format(string,sizeof(string), "**{FFFFFF} Anti Cheat {4DFFFF}[B]loqueo a {FFFFFF}%s {BBC1C1}[Razón: mod Sobeit ]",PlayerName2(playerid));
		SendClientMessageToAll(0x04DFFFFFF, string);
		if(RZClient_IsClientConnected(playerid))
		{
			BanSQL(playerid,INVALID_PLAYER_ID,"Sobeit (RZC)");
		}
		else{
			BanSQL(playerid,INVALID_PLAYER_ID,"Sobeit (SA)");
		}
		return 0;
	}
	CallRemoteFunction("SetPlayerHackStatus", "dd", playerid, 0);
	#endif
}
return 1;
}

public OnPlayerVehicleHealthHack(playerid)
{
	if(!IsPlayerAdmin(playerid) && !IsPlayerKicked(playerid)){
	new string[256];
	format(string,sizeof(string), "**{FFFFFF} Anti Cheat {4DFFFF}Expulso a {FFFFFF}%s {BBC1C1}[Razón: Ilegal Vehicle Repair]",PlayerName2(playerid));
	SendClientMessageToAll(0x04DFFFFFF, string);
	Kick(playerid);
	//BanSQL(playerid,INVALID_PLAYER_ID,"Cheating Tools");
	}
	return 1;
}



#if defined USE_SOBEIT_CAMERA_DETECTION
//forward CheckPlayerForSobeit(playerid);
stock CheckPlayerForSobeit(playerid)
{
	if(!IsPlayerAdmin(playerid))
	{
	    if(PlayerInfo[playerid][MusicInicio] == 1)
	    {
			//printf("Incializando Anti Sobeit para %s", PlayerName2(playerid));
			#if defined Camara_Movimiento
			PlayerCameraInfo[playerid][SpawnAngle] = 0.0; //so when you leave and another player comes, the camera will start from start
			PlayerCameraInfo[playerid][SpawnDance] = true; //to not execute to much timers
			KillTimer( PlayerCameraInfo[playerid][SpawnTimer] ); //to kill it, since its useless now
			#endif
			new pvw = SetPlayerAvailableVirtualWorld(playerid);
			if(pvw != INVALID_VIRTUAL_WORLD)
			{
			    SetPlayerPos(playerid,-72.4389,-127.2939,2.4107);
			    SetPlayerPos(playerid,-72.4389,-127.2939,2.4107);
		   		GetPlayerPos(playerid, PlayerInfo[playerid][SC_XYZ][0], PlayerInfo[playerid][SC_XYZ][1], PlayerInfo[playerid][SC_XYZ][2]);
				//printf("[Anti Sobeit]: Todo OK, iniciando timers para %s", PlayerName2(playerid));
				GetPlayerPos(playerid, PlayerInfo[playerid][SC_XYZ][0], PlayerInfo[playerid][SC_XYZ][1], PlayerInfo[playerid][SC_XYZ][2]);
			    strmid(PlayerInfo[playerid][SC_NICK], PlayerName2(playerid), 0, strlen(PlayerName2(playerid)));
			    //AFK[playerid] = 1;
				SetCameraBehindPlayer(playerid);
				TogglePlayerControllable(playerid, false);
				GetPlayerPos(playerid, PlayerInfo[playerid][SC_XYZ][0], PlayerInfo[playerid][SC_XYZ][1], PlayerInfo[playerid][SC_XYZ][2]);
				PlayerInfo[playerid][SC_Anim] = 1;
				KillTimer(PlayerInfo[playerid][SC_TIMER]);
				PlayerInfo[playerid][SC_TIMER] = SetTimerEx("SobeitChecker", FZ_SCDS * 1000, false, "i", playerid);
			}
		}
		else
		{
		    OnPlayerSpawnOK(playerid);
		}
	}
	else
	{
		if(PlayerInfo[playerid][MusicInicio] == 1)
		{
			//StopAudioStreamForPlayerEx(playerid);
			PlayerInfo[playerid][MusicInicio] = 0;
		}
		OnPlayerSpawnOK(playerid);
	}
	return 1;
}

forward SobeitChecker(playerid);
public SobeitChecker(playerid)
{
    //printf("SobeitChecker Called, checando sobeit para %s", PlayerName2(playerid));
	//si el jugador que llamo este timer no es el mismo que el del nick entonces saltar
	if(PlayerInfo[playerid][SC_COUNT] >= SOB_MAX_SKIPS) return Kick(playerid);
	if(IsPlayerPaused(playerid)){Kick(playerid);/*kickazo por nabo*/ }
	new pvw = GetPlayerVirtualWorld(playerid);
    new Float:x, Float:y, Float:z;
    GetPlayerCameraFrontVector(playerid, x, y, z);
    #pragma unused x
    #pragma unused y
    new Float:CHECK_XYZ[MAX_PLAYERS][3];
    GetPlayerPos(playerid, CHECK_XYZ[playerid][0], CHECK_XYZ[playerid][1], CHECK_XYZ[playerid][2]);
    if(PlayerInfo[playerid][SC_XYZ][0] == 0.000000 || PlayerInfo[playerid][SC_XYZ][1] == 0.000000 || PlayerInfo[playerid][SC_XYZ][2] == 0.000000)
	{
	KillTimer(PlayerInfo[playerid][SC_TIMER]);
	WorldUsed[pvw] = 0;
	//printf("|0.0POS|%s CANCELLED ORG: %f,%f,%f | NV: %f,%f,%f | MI: %d SCN: %s | Calling Checker Again..",PlayerName2(playerid),XYZ[playerid][0],XYZ[playerid][1],XYZ[playerid][2],CHECK_XYZ[playerid][0],CHECK_XYZ[playerid][1],CHECK_XYZ[playerid][2],PlayerInfo[playerid][MusicInicio],PlayerInfo[playerid][SC_NICK]);
	PlayerInfo[playerid][SC_COUNT]++;
	CheckPlayerForSobeit(playerid);
	return 0;
	}
    GetAnimationName(GetPlayerAnimationIndex(playerid),PlayerInfo[playerid][AnimLibrary],32,PlayerInfo[playerid][AnimName],32);
    if(z < -0.8)
    {
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
						SendClientMessage(playerid,-1," ");
				}
				new string[256];
				format(string,sizeof(string), "{4DFFFF}**{FFFFFF} El Servidor {4DFFFF}[B]loqueo a {FFFFFF}%s {BBC1C1}[Razon: Mod Sobeit (1) ]",PlayerName2(playerid));
				SendClientMessageToAll(0xFFFF00FF, string);
				BanSQL(playerid,INVALID_PLAYER_ID,"Mod Sobeit #ClientInjected");
				WorldUsed[pvw] = 0;
				printf("%s ban por sobeit | SC_NICK = %s | CAMARA DETECTADA",PlayerName2(playerid),PlayerInfo[playerid][SC_NICK]);
				//Kick(playerid);
				return 0;
				//return Kick(playerid);
	}
	else if(strcmp("SPRINT_CIVI", PlayerInfo[playerid][AnimName], false))
	{
				printf("%s ||NOP Anim Patch Enabled||Lib; %s Name; %s", PlayerName2(playerid),PlayerInfo[playerid][AnimLibrary],PlayerInfo[playerid][AnimName]);
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
						SendClientMessage(playerid,-1," ");
				}
				ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{ffffff}<-- {f50000}Anti Cheat {ffffff}-->", "{B366FF}No logramos validar tu Cliente SA-MP, verifica no tener instalado el archivo d3d9.dll o cleo mods.\nWe cannot validate your SA-MP Client, please delete any d3d9.dll file or cleo mod.\nDescarga bit.ly/RZCLIENTE si no puedes jugar para lograrlo.", "x", "");
				WorldUsed[pvw] = 0;
				printf("%s kick por sobeit | SC_NICK = %s | ANIMACION NO DETECTADA",PlayerName2(playerid),PlayerInfo[playerid][SC_NICK]);
				Kick(playerid);
				return 0;
	}
	else if(CHECK_XYZ[playerid][0] != PlayerInfo[playerid][SC_XYZ][0] || CHECK_XYZ[playerid][1] != PlayerInfo[playerid][SC_XYZ][1] || CHECK_XYZ[playerid][2] != PlayerInfo[playerid][SC_XYZ][2])
	{
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
						SendClientMessage(playerid,-1," ");
				}
				ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{ffffff}<-- {f50000}Anti Cheat {ffffff}-->", "{B366FF}No logramos validar tu Cliente SA-MP, verifica no tener instalado el archivo d3d9.dll o cleo mods.\nWe cannot validate your SA-MP Client, please delete any d3d9.dll file or cleo mod.", "x", "");
				WorldUsed[pvw] = 0;
				printf("%s kick por sobeit | SC_NICK = %s, PCH, ORG: %f,%f,%f | NV: %f,%f,%f",PlayerName2(playerid),PlayerInfo[playerid][SC_NICK],PlayerInfo[playerid][SC_XYZ][0],PlayerInfo[playerid][SC_XYZ][1],PlayerInfo[playerid][SC_XYZ][2],CHECK_XYZ[playerid][0],CHECK_XYZ[playerid][1],CHECK_XYZ[playerid][2]);
				Kick(playerid);
				return 0;
	}
	else
	{
	KillTimer(PlayerInfo[playerid][SC_TIMER]);
	PlayerInfo[playerid][SC_Anim] = 0;
	//printf("[SOBEIT]: %s Does not haves sobeit || Lib; %s Name; %s", PlayerName2(playerid),AnimLibrary[playerid],AnimName[playerid]);
	SetPlayerVirtualWorld(playerid,0);
	WorldUsed[pvw] = 0;
    //AFK[playerid] = 0;
    //SetPlayerSkin(playerid,GetPlayerSkin(playerid));
	TogglePlayerControllable(playerid, true);
	if(PlayerInfo[playerid][MusicInicio] == 1)
	{
		//StopAudioStreamForPlayerEx(playerid);
		//ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{00FFFF}RZUpdate: {FF0099}SafeZone", "{FFFFFF}Actualización {FF0099}SafeZone\n{ffffff}- Iconos de las zonas seguras actualizados!\n-Corregidos bugs de los cientificos.\n-Mortalidad de Cerebro Incrementada!\n-Spawns Humanos actualizados.\n-Nuevo núcleo número 6." , "OK", "");
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{00FFFF}RZUpdate: {FF0099}Drone Beta", "{FFFFFF}Actualización {FF0099}Drone Beta\n{ffffff}- Se añadieron drones inteligentes anti zombies." , "OK", "");
        CheckRZClientRestricted(playerid);
	}
	OnPlayerSpawnOK(playerid);
	return 1;
	}
}
#endif


stock HasPlayerWeaponInSlot(playerid, weaponid)
{
	//new slot = GetWeaponSlot(weaponid), slot_weaponid = -1, slot_ammo = -1;
	//GetPlayerWeaponData(playerid, slot, slot_weaponid, slot_ammo);
	new slot = GetWeaponSlot(weaponid);
	if(PlayerInfo[playerid][AAH_WeaponAmmo][slot] >= 1) return true;
	else return false;
}

stock WeaponPack(playerid)
{
	if(gTeam[playerid] == Humano)
	{
		if(RZClient_IsClientConnected(playerid) || IsPlayerAdmin(playerid)){

		    if(!HasPlayerWeaponInSlot(playerid, 31))
			{
				GivePlayerWeaponEx(playerid, 31, 2500, false);
			}
			if(!HasPlayerWeaponInSlot(playerid, 25))
			{
				GivePlayerWeaponEx(playerid, 25, 100, false);
			}
		}
	}
	else if (gTeam[playerid] == Zombie)
	{
		if(!HasPlayerWeaponInSlot(playerid, 6))
		{
	    	GivePlayerWeaponEx(playerid, 6, 1, false);
	    }
		if(!HasPlayerWeaponInSlot(playerid, 35))
		{
	    	GivePlayerWeaponEx(playerid, 35, 2000, false);
	    }
	}
	return 1;
}

stock OnPlayerSpawnOK(playerid)
{
	if(HideServerPlayersHUD == 1)
	{
	    TogglePlayerHUD(false, playerid);
	}
	#if defined Camara_Movimiento
	PlayerCameraInfo[playerid][SpawnAngle] = 0.0; //so when you leave and another player comes, the camera will start from start
	PlayerCameraInfo[playerid][SpawnDance] = true; //to not execute to much timers
	KillTimer( PlayerCameraInfo[playerid][SpawnTimer] ); //to kill it, since its useless now
	#endif
	PlayerPlaySound(playerid, 1186, 0.0, 0.0, 0.0);
	SetCameraBehindPlayer(playerid);
	//SetPlayerCheckpoint(playerid, 153.7336, -1959.7883, 3.7734, 5.0);
	SetPlayerInterior(playerid,0);
	SetPlayerVirtualWorld(playerid,0);
	SetPlayerWeather(playerid, Clima);
	SetPlayerTime(playerid,Hora,0);
    PlayerInfo[playerid][dead] = 0;
    TextDrawShowForPlayer(playerid,MiniLogoM);
	if(gTeam[playerid] == Humano)
	{
		SetPlayerColor(playerid, HUMANO_COLOR);
		gTeam[playerid] = Humano;
		SetPlayerTeam(playerid, Humano);
		#if defined USE_ZOMBIE_RADAR
		TextDrawShowForPlayer( playerid, PlayerInfo[playerid][RadarZombie] );
		#endif
		SetSelectedSkin(playerid);
		GivePlayerWeaponEx(playerid, 46, 1, false);
		if (!GetPVarInt(playerid, "color")) {SetPVarInt(playerid, "color", 18643);}
		if (GetPVarInt(playerid, "PrimerasArmas"))
		{
			GivePlayerWeaponEx(playerid, 23, 500, false);
			GivePlayerWeaponEx(playerid, 25, 250, false);
			DeletePVar(playerid, "PrimerasArmas");
		}
		else{
			SetSQLWeaponData(playerid);
		}
		if (GetPVarInt(playerid, "ArmasDefault")){
			GivePlayerWeaponEx(playerid, 23, 90, false);
			SetPVarInt(playerid, "ArmasDefault", 0);
		}
    	WeaponPack(playerid);
	}
	if(gTeam[playerid] == Zombie)
	{
		SetPlayerColor(playerid, ZOMBIE_COLOR_VISIBLE);
		gTeam[playerid] = Zombie;
		SetPlayerTeam(playerid, Zombie);
		#if defined USE_ZOMBIE_RADAR
		TextDrawShowForPlayer( playerid, PlayerInfo[playerid][RadarZombie] );
		#endif
		SetSelectedSkin(playerid);
		WeaponPack(playerid);
		if (!GetPVarInt(playerid, "color")) {SetPVarInt(playerid, "color", 18643);}
	}
	if(PlayerInfo[playerid][CLAN] == 1 || !IsPlayerAdmin(playerid) && PlayerInfo[playerid][invisible] == 1)
	{
		Delete3DTextLabel(LabelCabecero[playerid]);
		LabelCabecero[playerid] = Create3DTextLabel(ClanTAG[playerid], 0xFFFF00FF, 30.0, 40.0, 50.0, 40.0, 0);
		Attach3DTextLabelToPlayer(LabelCabecero[playerid], playerid, 0.0, 0.0, 0.7);
	}
	if(!RZClient_IsClientConnected(playerid) && PlayerInfo[playerid][MusicInicio] == 0 && !IsPlayerAdmin(playerid)){
			SendFormatDialog(playerid,"{ffffff}<-- {f50000} RZClient.exe {ffffff}-->","{4DFFFF}Hey {ffffff}%s!\nPara Conseguir más beneficios en Nuestro servidor, descarga el {4DFFFF}RZ Client{ffffff} en:\n{4DFFFF}http://bit.ly/RZCLIENTE\n{ffffff}Al descargarlo tambien eliminaras este molesto aviso & conseguiras más puntaje & dinero.",PlayerName2(playerid));
			PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
	}
	PlayerInfo[playerid][MusicInicio] = 0;
	PlayerInfo[playerid][DRONE_ID] = INVALID_PLAYER_ID;//unset drone for playerid.
	Generame(playerid);

	if(PlayerInfo[playerid][InCORE] == 1)
	{
	    //PlayerInfo[playerid][IsCoreWeapon] = 1;//perdio su arma propia jojo.
	    SpawnCorePlayer(playerid);
	}
	return 1;
}



public OnPlayerStateChange(playerid,newstate,oldstate)
{
    gbug_OnPlayerStateChange(playerid, newstate, oldstate);
	#if defined SistemaDECombustible
	if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER)
	{
			BorrarPlayerVelo(playerid);
	}
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
	{
			Actualizar();
	  		ShowPlayerProgressBar(playerid, Velocidadbar[playerid]);
			ShowPlayerProgressBar(playerid, Gasolinabar[playerid]);
			ShowPlayerProgressBar(playerid, Estadobar[playerid]);
	}
	#endif
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && gTeam[playerid] == Zombie && !IsPlayerAdmin(playerid))
	{
		SendClientMessage(playerid,COLOR_DE_ERROR, "[ ERROR ]: {FFFFFF}Los zombies no manejan autos.");
		RemovePlayerFromVehicle(playerid);
		new Float:CX,Float:CY,Float:CZ;
		GetPlayerPos(playerid,CX,CY,CZ);
		SetPlayerPos(playerid,CX,CY,CZ+2);
	}
	return 1;
}


stock GetWeaponSlot(weaponid)
{
	new slot;
	switch(weaponid){
		case 0 .. 1: slot = 0; // No weapon
		
		case 2 .. 9: slot = 1; // Melee
		
		case 22 .. 24: slot = 2; // Handguns
		
		case 25 .. 27: slot = 3; // Shotguns
		
		case 28, 29, 32: slot = 4; // Sub-Machineguns
		
		case 30, 31: slot = 5; // Machineguns
		
		case 33, 34: slot = 6; // Rifles
		
		case 35 .. 38: slot = 7; // Heavy Weapons
		
		case 16, 18, 39: slot = 8; // Projectiles
		
		case 42, 43: slot = 9; // Special 1
		
		case 14: slot = 10; // Gifts
		
		case 44 .. 46: slot = 11; // Special 2
		
		case 40: slot = 12; // Detonators
		
		default: slot = 13; // No slot
	}
	return slot;
}

stock RemovePlayerWeapon(playerid, weaponid)
{ // Not mine :3
	new plyWeapons[12] = 0;
	new plyAmmo[12] = 0;
	for(new sslot = 0; sslot != 12; sslot++)
	{
		new wep, ammo;
		if(wep != weaponid){
		GetPlayerWeaponData(playerid, sslot, wep, ammo);
		GetPlayerWeaponData(playerid, sslot, plyWeapons[sslot], plyAmmo[sslot]);
		}
	}
	PlayerInfo[playerid][Weapon][weaponid] = false;
	PlayerInfo[playerid][WeaponDroppable][weaponid] = true;
	ResetPlayerWeaponsEx(playerid);
	for(new sslot = 0; sslot != 12; sslot++) if(plyAmmo[sslot] != 0)
	{
	    if(plyWeapons[sslot] != weaponid){
			GivePlayerWeaponEx(playerid, plyWeapons[sslot], plyAmmo[sslot], PlayerInfo[playerid][WeaponDroppable][plyWeapons[sslot]]);
		}
	}
	return 1;
}
stock GivePlayerWeaponEx(playerid,weaponid,ammo, bool:droppable = true)
{
    if(IsPlayerNPC(playerid)||!IsValidWeapon(weaponid)||ammo <= 0) return 0;
    PlayerInfo[playerid][Weapon][weaponid] = true;

	//SendFormatMessageToAll(-1,"[W]: VStored Ammo(%d), FStored Ammo(%d) + New Ammo(%d) set: %d", PlayerInfo[playerid][AAH_WeaponAmmo][weaponid], stored_ammo, ammo, stored_ammo + ammo);
	new weaponid_slot = GetWeaponSlot(weaponid);
	new stored_ammo = PlayerInfo[playerid][AAH_WeaponAmmo][weaponid_slot];

	if(PlayerInfo[playerid][AAH_WeaponAmmo][weaponid_slot] >= 1)//si hay municion en la memoria y el arma se puede soltar...
	{
		//SendFormatMessageToAll(COLOR_AMARILLO,"[W]: VStored Ammo(%d), FStored Ammo(%d) set: %d", PlayerInfo[playerid][AAH_WeaponAmmo][weaponid], stored_ammo, ammo);
  		PlayerInfo[playerid][AAH_WeaponAmmo][weaponid_slot] = ammo + (stored_ammo);
  		//printf("[Debug GivePlayerWeaponEx]: |Memory Weapon| playerid: %d, weaponid: %d, weaponid_slot: %d, callback ammo: %d, memory ammo: %d, new variable stored ammo: %d.",playerid, weaponid, weaponid_slot, ammo, stored_ammo, PlayerInfo[playerid][AAH_WeaponAmmo][weaponid_slot]);
	}
	else //Si no tiene munición o no se puede tirar, setear la munición.
	{
	    //RemovePlayerWeapon(playerid, weaponid);
		//SendFormatMessageToAll(COLOR_AMARILLO,"[W]: VStored Ammo(%d), FStored Ammo(%d) set: %d", PlayerInfo[playerid][AAH_WeaponAmmo][weaponid], stored_ammo, ammo);
  		PlayerInfo[playerid][AAH_WeaponAmmo][weaponid_slot] = ammo;
  		//printf("[Debug GivePlayerWeaponEx]: |New Weapon?| playerid: %d, weaponid: %d, weaponid_slot: %d, callback ammo: %d, stored ammo: %d, new variable stored ammo: %d.",playerid, weaponid, weaponid_slot, ammo, stored_ammo, PlayerInfo[playerid][AAH_WeaponAmmo][weaponid_slot]);
	}

	PlayerInfo[playerid][WeaponDroppable][weaponid] = droppable;
	PlayerInfo[playerid][AAH_AmmoHackCount][weaponid_slot] = 0;

	return GivePlayerWeapon(playerid, weaponid, ammo);

}

stock ResetPlayerWeaponsEx(playerid)
{
	if(IsPlayerNPC(playerid)) return 0;
	ResetPlayerWeapons(playerid);
	ResetPlayerWeapons(playerid);
	ResetPlayerWeapons(playerid);
	ResetPlayerWeapons(playerid);
 	//#if defined ANTI_AMMO_HACk
	for (new i = 0; i < 47; i++)
 	{
 	    if(i <= 13){
	    PlayerInfo[playerid][AAH_WeaponAmmo][i] = 0;
	    PlayerInfo[playerid][AAH_AmmoHackCount][i] = 0;
	    }
	    PlayerInfo[playerid][Weapon][i] = false;
		PlayerInfo[playerid][WeaponDroppable][i] = true;
	}
 	PlayerInfo[playerid][Weapon][0] = true;
 	PlayerInfo[playerid][Weapon][40] = true;
 	PlayerInfo[playerid][Weapon][46] = true;
 	return ResetPlayerWeapons(playerid);
}

stock CreateDroppedGun(GunID, GunAmmo, Float:gPosX, Float:gPosY, Float:gPosZ, isDefault = 0, taken = 0, findZCoord=1)
{
	new f = MAX_DROPPED_WEAPONS+1;
    for(new a = 0; a < MAX_DROPPED_WEAPONS; a++)
    {
        if(dGunData[a][ObjID] == -1)
        {
            f = a;
            break;
        }
    }
    if(f > MAX_DROPPED_WEAPONS) return 1;
    DestroyDynamicObject( dGunData[f][ObjID] );
    DestroyDynamic3DTextLabel( dGunData[f][objLabel] );

    dGunData[f][ObjData][0] = GunID;
	dGunData[f][ObjData][1] = GunAmmo;
	dGunData[f][ObjData][2] = taken;//taken!
	dGunData[f][ObjData][3] = isDefault;
	if(findZCoord == 1){
		//MapAndreas_FindAverageZ(gPosX, gPosY, gPosZ);
		gPosZ = gPosZ - 1;
	}
	else{
	    gPosZ = gPosZ - 1;
	}
	dGunData[f][ObjPos][0] = gPosX;
	dGunData[f][ObjPos][1] = gPosY;
	dGunData[f][ObjPos][2] = gPosZ;

	dGunData[f][ObjID] = CreateDynamicObject(GunObjects[GunID], dGunData[f][ObjPos][0], dGunData[f][ObjPos][1], dGunData[f][ObjPos][2], 93.7, 120.0, random(360));

	new weapon_str[50];
	format(weapon_str, sizeof(weapon_str), "%s\n\nPress 'C' to take", GunNames[GunID]);
	dGunData[f][objLabel] = CreateDynamic3DTextLabel(weapon_str, 0xFFFF99FF, dGunData[f][ObjPos][0], dGunData[f][ObjPos][1], dGunData[f][ObjPos][2], GUN_3DTEXT_DRAW_DISTANCE);
	return 1;
}
// -----------------------------------------------------------------------------

stock split(const strsrc[], strdest[][], delimiter)
{ // Not mine :3
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc))
	{
	    if(strsrc[i]==delimiter || i==strlen(strsrc))
		{
	        len = strmid(strdest[aNum], strsrc, li, i, 128);
	        strdest[aNum][len] = 0;
	        li = i+1;
	        aNum++;
		}
		i++;
	}
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{
	if(issuerid != INVALID_PLAYER_ID)
	{
	    NPC_INFO[playerid][LastAttacker] = issuerid;
	    //SendFormatMessageToAll(-1, "2) %s was attacked by %s with %d on %d, Amount Loss: %f",PlayerName2(playerid),PlayerName2(issuerid),weaponid,bodypart, amount);
		if(IsPlayerNPC(playerid))
		{
	 		if(PlayerInfo[issuerid][InCORE] == 0 && NPC_INFO[playerid][InCORE] == 1) return GameTextForPlayer(issuerid,"~n~~n~~n~~n~~n~ ~r~~h~~h~no puedes matar este zombie,~n~es del nucleo!",4000,3);
		}
		else
		{
		    if(PlayerInfo[playerid][InCORE] == 1 && PlayerInfo[issuerid][InCORE] == 0) return GameTextForPlayer(issuerid,"~n~~n~~n~~n~~n~ ~r~~h~~h~jugador inmune!",4000,3);
		    if(PlayerInfo[issuerid][InCORE] == 1 && PlayerInfo[playerid][InCORE] == 0 && !IsPlayerNPC(playerid)) return GameTextForPlayer(issuerid,"~n~~n~~n~~n~~n~ ~r~~h~~h~jugador inmune!",4000,3);
		    if(PlayerInfo[playerid][InCORE] == 1) return 0;
		    if((PlayerInfo[playerid][ZonaSegura] == 1 || PlayerInfo[issuerid][ZonaSegura] == 1) && GetPlayerTeam(playerid) != GetPlayerTeam(issuerid) && !IsPlayerAdmin(issuerid)) return GameTextForPlayer(issuerid,"~r~~h~~h~no se permite matar dentro de la zona segura!",4000,3), SetPlayerHealth(issuerid, 0), GameTextForPlayer(playerid,"~r~~h~~h~alguien intenta matarte en la zona segura!",4000,3), 0;
		    if((PlayerInfo[playerid][ZonaSegura] == 1 || PlayerInfo[issuerid][ZonaSegura] == 1) && !IsPlayerAdmin(issuerid)) return GameTextForPlayer(issuerid,"~r~~h~~h~no se permite matar dentro de la zona segura!",4000,3), GameTextForPlayer(playerid,"~r~~h~~h~alguien intenta matarte en la zona segura!",4000,3), 0;

			if(playerid != INVALID_PLAYER_ID && issuerid != INVALID_PLAYER_ID  && IsPlayerConnected(issuerid) && IsPlayerConnected(playerid) && !IsPlayerDead(playerid))
			{
			    	if(IsPlayerOfMyClan(issuerid,playerid)) return 0;
			        if(GetPlayerScore(playerid) <= SCORE_NOOB && (GetPlayerTeam(playerid) == GetPlayerTeam(issuerid))) return GameTextForPlayer(issuerid,"~n~~n~~n~~n~~n~ ~r~~h~~h~jugador indefenso!",4000,3);
			        if(GetPlayerScore(issuerid) <= SCORE_NOOB && (GetPlayerTeam(playerid) == GetPlayerTeam(issuerid))) return GameTextForPlayer(issuerid,"~n~~n~~n~~n~~n~ ~r~~h~~h~aun no puedes matar jugadores!",4000,3);
					NPC_INFO[playerid][LastAttacker] = issuerid;
					NPC_INFO[playerid][ByWeapon] = weaponid;
					if(IsPlayerConnected(playerid) && bodypart == 9 && GetPlayerWeapon(issuerid) == 34)
					{
					    SetPlayerHealth(playerid, 0.0);
					    SendFormatMessage(playerid,red,"<!> {ffffff}Has muerto por un disparo en la cabeza. (Asesino: %s)",PlayerName2(issuerid));
					    GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~ ~r~~h~~h~Headshot!",4000,3);
					    GameTextForPlayer(issuerid,"~n~~n~~n~~n~~n~ ~r~~h~~h~Headshot!",4000,3);
					    return 0;
					}
		 	}
	 	}
		 	if((weaponid == 6 || weaponid == 0) && gTeam[issuerid] == Zombie && !IsPlayerDead(playerid))
		 	{
		 	    if(IsPlayerOfMyClan(issuerid,playerid)) return 0;
				NPC_INFO[playerid][LastAttacker] = issuerid;
				NPC_INFO[playerid][ByWeapon] = weaponid;
			    SendFormatMessage(playerid,red,"<!> {ffffff}Has muerto por golpe zombie. (Asesino: %s)",PlayerName2(issuerid));
			    GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~ ~r~~h~~h~SEPULTADO!",4000,3);
			    GameTextForPlayer(issuerid,"~n~~n~~n~~n~~n~ ~r~~h~~h~SEPULTADO!",4000,3);
			    SetPlayerHealth(playerid, 0.0);
				return 0;
		 	}
	    	if(playerid != INVALID_PLAYER_ID)
			{
				new Float:DH,Float:DA,Float:ADH,Float:ADA;
				GetPlayerHealth(playerid, DH);//health
				GetPlayerArmour(playerid, DA);
				ADH = DH-amount;//health
				ADA = DA-amount;
				if(ADA > 0)
				{
				    SetPlayerArmour(playerid, ADA);
				}
				else if(ADA <= 0)
				{
				    SetPlayerArmour(playerid, 0);
				}
				if(ADH > 0 && ADA <= 0)
				{
				    SetPlayerHealth(playerid, ADH);
				}
				else if(ADH <= 0 && ADA <=0)
				{
				    SetPlayerHealth(playerid, 0);
				}
				PlayerPlaySound(playerid,17802, 0.0, 0.0, 0.0);
				return 0;
			}
 	}
	if(PlayerInfo[playerid][ZonaSegura] == 1) return 0;
	return 1;
}
stock IsZombieWeapon(weaponid)
{
	if(weaponid==6||weaponid==35||weaponid==38||weaponid==0) return true;
	else return false;
}
stock IsHSWeapon(w)
{
    if(w == 34 || w == 33 || w == 24 || w==25||w==23 ||w==31||w==30||w==29||w==27) return 1;
    else return 0;
}


PUBLIC:HasPlayerAmmoHack(playerid, weaponid)
{
	new slot_id = GetWeaponSlot(weaponid);
	switch(weaponid)
	{
	    case 0 .. 15: return false;//non-guns
	    case 40: return false;//detonator
	    case 43 .. 46: return false;//non-guns: camera, vision googles, parachute

	    case 16:
	    {
	        if(PlayerInfo[playerid][AAH_AmmoHackCount][slot_id] >= 2) return true;//grenade
	    }
	    case 39:
	    {
	        if(PlayerInfo[playerid][AAH_AmmoHackCount][slot_id] >= 2) return true;//Satchel Charge
	    }

	    case 17 .. 25://weapons
	    {
	        if(PlayerInfo[playerid][AAH_AmmoHackCount][slot_id] >= 3) return true;//ends at Shotgun
	    }
	    case 26 .. 32:
	    {
	        if(PlayerInfo[playerid][AAH_AmmoHackCount][slot_id] >= 3) return true;//ends at rifle
	    }
	    case 33 .. 36:
	    {
	        if(PlayerInfo[playerid][AAH_AmmoHackCount][slot_id] >= 2) return true;//ends at HS Rocket launcher
	    }
	    case 37:
	    {
	        if(PlayerInfo[playerid][AAH_AmmoHackCount][slot_id] >= 4) return true;//flamethwoer
	    }
	    case 38:
	    {
	        if(PlayerInfo[playerid][AAH_AmmoHackCount][slot_id] >= 10) return true;//minigun
	    }
	    case 41 .. 42://spray and fire extinghuiser.
	    {
	        if(PlayerInfo[playerid][AAH_AmmoHackCount][slot_id] >= 4) return true;//ends at fire ext..
	    }
	    default: return false;
	}
	return false;
}
PUBLIC:IsTriggerableWeapon(weaponid)
{
	switch(weaponid)
	{
	    case 0 .. 15: return false;//non-guns
	    case 40: return false;//detonator
	    case 43 .. 46: return false;//non-guns: camera, vision googles, parachute
	    case 16: return true;
	    case 39: return true;
	    case 17 .. 25: return true;
	    case 26 .. 32: return true;
	    case 33 .. 36: return true;
	    case 37: return true;
	    case 38: return true;
	    case 41 .. 42: return true;
	    default: return false;
	}
	return false;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float: fX,Float: fY,Float: fZ)
{
	if(!IsValidWeapon(weaponid)) return 0;

    //#if defined ANTI_AMMO_HACK
    if(!IsPlayerNPC(playerid) && !IsPlayerKicked(playerid))
    {
    	new stored_weaponid, stored_ammo, stored_weaponid_slot;
    	GetPlayerWeaponData(playerid, GetWeaponSlot(weaponid), stored_weaponid, stored_ammo);
		stored_weaponid_slot = GetWeaponSlot(stored_weaponid);

		if(IsTriggerableWeapon(stored_weaponid))
		{

		if(PlayerInfo[playerid][AAH_WeaponAmmo][stored_weaponid_slot] >= 1)
		{
		    //SendFormatMessageToAll(-1,"[AC]: PlayerID: %d, WeaponId: %d, Stored Ammo: %d, Current Ammo: %d",playerid, stored_weaponid, PlayerInfo[playerid][AAH_WeaponAmmo][stored_weaponid], stored_ammo);
            new ilegal_bullets = stored_ammo - PlayerInfo[playerid][AAH_WeaponAmmo][stored_weaponid_slot];
			if(ilegal_bullets >= 1)// se aumento la munición
			{
				new PlayerIP[128];
				GetPlayerIp(playerid,PlayerIP,sizeof(PlayerIP));
				printf("[KICK]: %s[%d] IP: %s ha sido expulsado por Ammo Hacked | WeaponId: %d vs %d, Current Ammo: %d, Slot Ammo: %d, fakebullets: %d",PlayerName2(playerid),playerid,PlayerIP, weaponid, stored_weaponid, stored_ammo, PlayerInfo[playerid][AAH_WeaponAmmo][stored_weaponid_slot], ilegal_bullets);

				PlayerInfo[playerid][dead] = 1;
				ResetPlayerWeaponsEx(playerid);
				SaveSQLWeaponData(playerid);//borrar todas las armas :v
				new string[256];
				format(string,sizeof(string), "**{FFFFFF} Anti Cheat {4DFFFF}ha [E]xpulsado a {FFFFFF}%s {BBC1C1}[Razon: AmmoHack: %d, +%d bullets ] {ffffff}[%d/%d]",PlayerName2(playerid), stored_weaponid, ilegal_bullets);
				SendClientMessageToAll(0x4DFFFFFF, string);

				Kick(playerid);
				return 0;
			}
		}


		PlayerInfo[playerid][AAH_BulletsFired][stored_weaponid_slot]++;
 		//SendFormatMessageToAll(-1,"[OPWS]: PlayerID: %d, WeaponId: %d, Ammo: %d, BFired: %d, vammo: %d, hCount: %d",playerid, stored_weaponid, stored_ammo, PlayerInfo[playerid][AAH_BulletsFired][stored_weaponid], PlayerInfo[playerid][AAH_WeaponAmmo][stored_weaponid], PlayerInfo[playerid][AAH_AmmoHackCount][stored_weaponid]);

		if(PlayerInfo[playerid][AAH_WeaponAmmo][stored_weaponid_slot] == stored_ammo && (weaponid != 38 && PlayerInfo[playerid][AAH_BulletsFired][stored_weaponid_slot] == 2 || weaponid == 38 && PlayerInfo[playerid][AAH_BulletsFired][stored_weaponid_slot] == 5))
		{
 			//SendFormatMessageToAll(COLOR_ROJO,"[AC]: PlayerID: %d, stored_ammo = %d, variable_ammo = %d, weaponid=%d, vweaponid=%d",playerid, stored_ammo, PlayerInfo[playerid][AAH_WeaponAmmo][stored_weaponid],weaponid, stored_weaponid);

		    if(HasPlayerAmmoHack(playerid, stored_weaponid))
			{
				new PlayerIP[128];
				GetPlayerIp(playerid,PlayerIP,sizeof(PlayerIP));
				printf("[KICK]: %s[%d] IP: %d ha sido expulsado por Infinite Ammo Hacking | Arma Hack: %d, count %d.",PlayerName2(playerid),playerid,PlayerIP,stored_weaponid, PlayerInfo[playerid][AAH_AmmoHackCount][stored_weaponid_slot]);

				PlayerInfo[playerid][dead] = 1;
				ResetPlayerWeaponsEx(playerid);
				SaveSQLWeaponData(playerid);//borrar todas las armas :v
				new string[256];
				format(string,sizeof(string), "**{FFFFFF} Anti Cheat {4DFFFF}ha [E]xpulsado a {FFFFFF}%s {BBC1C1}[Razon: Infinite Ammo: %d ] {ffffff}[%d]",PlayerName2(playerid),stored_weaponid, PlayerInfo[playerid][AAH_AmmoHackCount][stored_weaponid_slot]);
				SendClientMessageToAll(0x4DFFFFFF, string);

				return	Kick(playerid);
			}
			PlayerInfo[playerid][AAH_AmmoHackCount][stored_weaponid_slot]++;
			PlayerInfo[playerid][AAH_BulletsFired][stored_weaponid_slot]++;
		}
		else if (PlayerInfo[playerid][AAH_WeaponAmmo][stored_weaponid_slot] != stored_ammo && PlayerInfo[playerid][AAH_BulletsFired][stored_weaponid_slot] >= 2)
		{
            PlayerInfo[playerid][AAH_AmmoHackCount][stored_weaponid_slot] = 0;
            PlayerInfo[playerid][AAH_BulletsFired][stored_weaponid_slot] = 0;
		}
		else if(PlayerInfo[playerid][AAH_BulletsFired][stored_weaponid_slot] >= 2)
		{
			PlayerInfo[playerid][AAH_BulletsFired][stored_weaponid_slot] = 0;
		}
		PlayerInfo[playerid][AAH_WeaponAmmo][stored_weaponid_slot] = stored_ammo;
		if(stored_ammo <= 1)
		{
		    PlayerInfo[playerid][AAH_WeaponAmmo][stored_weaponid_slot] = 0;
		}
		/*if(GetTickDiff( GetTickCount(), PlayerInfo[playerid][AAH_AmmoTick] ) >= 1)
		{
		    //guardar en la memoria la cantidad de munición del jugador si ya pasaron 500 milisegundos.
			PlayerInfo[playerid][AAH_WeaponAmmo][stored_weaponid] = stored_ammo;
			PlayerInfo[playerid][AAH_AmmoTick] = GetTickCount();
		}*/

		}
	}

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	//Desync weapon IDs that don't fire bullets
	if (weaponid < 22 || weaponid > 38) return 0;
	//Desync shots with Z pos out of bounds
	if(!(-20000.0 <= z <= 20000.0)) return 0;

	//if(hittype == BULLET_HIT_TYPE_PLAYER)
	//{
		if(IsPlayerConnected(hitid))
		{
			//Desync bullet for paused player.
		    if(IsPlayerPaused(hitid)) return 0;
		}
	//}
    return 1;
}

//este se llama en linux solamente, el otro en windows
public OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid, bodypart)
{
    if(PlayerInfo[damagedid][InCORE] == 1 && PlayerInfo[playerid][InCORE] == 0) return GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~ ~r~~h~~h~jugador inmune!",4000,3);
    if(PlayerInfo[playerid][InCORE] == 1 && PlayerInfo[damagedid][InCORE] == 0 && !IsPlayerNPC(damagedid)) return GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~ ~r~~h~~h~jugador inmune!",4000,3);
    if(PlayerInfo[damagedid][InCORE] == 1) return 0;
	if(damagedid == 0 && amount <= 0 && weaponid == 0 && bodypart == 0){damagedid = INVALID_PLAYER_ID;}
	if(damagedid != INVALID_PLAYER_ID)
	{

	    if (IsPlayerNPC(damagedid) && gTeam[playerid] != Zombie && !FCNPC_IsDead(damagedid))
	    {
	                if(PlayerInfo[playerid][InCORE] == 0 && NPC_INFO[damagedid][InCORE] == 1) return GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~ ~r~~h~~h~no puedes matar este zombie,~n~es del nucleo!",4000,3), 0;
	                if(PlayerInfo[playerid][ZonaSegura] == 1 && NPC_INFO[damagedid][Attacking] != playerid) return GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~ ~r~~h~~h~no puedes matar en la zona segura!",4000,3), 0;
	                if(IsZombieStreamedOut(damagedid,playerid) && NPC_NEMESIS[damagedid] == 0) return 0;//GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~ ~r~~h~~h~NO ESTAS ATACANDO AL ZOMBIE!",4000,3);
	                /*switch(bodypart)
	                {
	                    //FCNPC_ApplyAnimation(npcid, animlib[], animname[], Float:fDelta = 4.1, loop = 0, lockx = 1, locky = 1, freeze = 0, time = 1);
	                    //ApplyAnimation(playerid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync) - (npcid,"PED","KO_shot_stom",4.1,0,1,1,1,1);
	                    case 3: ApplyAnimation(damagedid, "PED", "HIT_front", 4.1, 0, 1, 1, 0, 3, 1);// BODY_PART_CHEST (pecho)
	                    //case 4: ApplyAnimation(damagedid, "PED", "HIT_front", 4.1, 0, 1, 1, 1, 0, 1); break;// BODY_PART_TORSO (GROIN AREA)
	                    case 5: ApplyAnimation(damagedid, "PED", "HitA_2", 4.1, 0, 1, 1, 0, 3, 1);// BODY_PART_LEFT_ARM
	                    case 6: ApplyAnimation(damagedid, "PED", "HitA_3", 4.1, 0, 1, 1, 0, 3, 1);// BODY_PART_RIGHT_ARM
	                    //case 7: ApplyAnimation(damagedid, "PED", "HIT_front", 4.1, 0, 1, 1, 0, 1); break;// BODY_PART_LEFT_LEG
	                    case 8: ApplyAnimation(damagedid, "GYMNASIUM","gym_tread_falloff", 4.1, 0, 1, 1, 1, 1);// BODY_PART_RIGHT_LEG
	                    case 9: ApplyAnimation(damagedid, "PED", "HitA_1", 4.1, false, true, true, true, true, true);// BODY_PART_HEAD
	                }*/
	                if(bodypart == 9 && IsHSWeapon(weaponid) || weaponid == 6)
	                {
	                    if(NPC_NEMESIS[damagedid] == 1) {
							TextoBuble(damagedid,"NECESITARAS MAS QUE ESO PARA DETENERME WHUAHAHAH!!");
							SetNPCHealth(damagedid, GetNPCHealth(damagedid) - randomEx(150, 250)+amount);
	                    }
						else
						{
							SetNPCHealth(damagedid, 0.0);
							KillBOT(damagedid,playerid, GetPlayerWeapon(playerid));
						}
	                }
	                else
	                {
						new Float:healthX = GetNPCHealth(damagedid);
						if(healthX <= 0.0)
						{
							KillBOT(damagedid, playerid, GetPlayerWeapon(playerid));
						}
						else
						{
							SetNPCHealth(damagedid, GetNPCHealth(damagedid) - amount);
		              	//printf("id %d damage: %f health bef: %f health af: %f bodypart: %d",damagedid, amount, healthX, Health(damagedid), bodypart);
		              	}
	              	}
	              	//SendFormatMessageToAll(-1,"Z Distace between you and the target: %f",GetZDiferenceBetween(damagedid,playerid));
	              	#if defined NPCBars
	              	UpdateNPCHealth(damagedid);
	              	#endif
	              	return 0;
	    }


	    if(playerid != INVALID_PLAYER_ID && !IsPlayerNPC(playerid) && !IsPlayerNPC(damagedid))
	    {
	    	//if(PlayerInfo[playerid][ZonaSegura] == 1 || PlayerInfo[damagedid][ZonaSegura] == 1) return GameTextForPlayer(playerid,"~r~~h~~h~No se permite matar!",4000,3), 0;
	        if(!IsPlayerOfMyClan(playerid,damagedid))
	        {
			    if(GetPlayerScore(damagedid) <= SCORE_NOOB && !(GetPlayerTeam(playerid) == GetPlayerTeam(damagedid))) return GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~ ~r~~h~~h~jugador indefenso!",4000,3);
			    if(GetPlayerScore(playerid) <= SCORE_NOOB && !(GetPlayerTeam(playerid) == GetPlayerTeam(damagedid))) return GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~ ~r~~h~~h~aun no puedes matar jugadores!",4000,3);
				PlayerPlaySound(playerid,17802, 0.0, 0.0, 0.0);
				return OnPlayerTakeDamage(damagedid, playerid, amount, weaponid, bodypart), 0;
			}
 	    }
 	}
    return 0;
}

stock IsPlayerOfMyClan(one,two)
{
	if(PlayerInfo[two][CLAN] == 0||PlayerInfo[one][CLAN] == 0) return false;
	if (!strcmp(ClanTAG[one], ClanTAG[two], false)) return true;
	else return false;
}

stock IsPlayerOfClan(one[],two)
{
	if(IsPlayerAdmin(two)) return true;
	else if (!strcmp(one, ClanTAG[two], false)) return true;
	else return false;
}

stock StringMismatch(one[],two[])
{
	if (!strcmp(one, two, false)) return true;
	else return false;
}


stock IsPlayerOwnerOfClan(playerid,USER_CLAN_TAG[])
{
		new Comprobar[256];
		format(Comprobar, sizeof(Comprobar), "SELECT * FROM Usuarios WHERE Username = '%s' AND CLAN_TAG = '%s' AND CLAN_OWN = '1'", PlayerName2(playerid),USER_CLAN_TAG);
		NUM_ROWS_SQL = db_query(DataBase_USERS,Comprobar);
		if(db_num_rows(NUM_ROWS_SQL) == 0) return 0;
		else return 1;
}
stock PlayZombieAudioForAll(npcid,trackid,Float:audio_range,Float:custom_range)
{
	//new ZHandler[MAX_PLAYERS];
	new Float:zombx, Float:zomby, Float:zombz;
	GetPlayerPos(npcid, zombx, zomby, zombz);
    for(new i, l = GetMaxPlayers();i<l;i++)
	{
		if(IsPlayerConnected(i) && !IsZombieNPC(i) && RZClient_IsClientConnected(i) && IsPlayerInRangeOfPlayer(i, npcid, custom_range))
  		{
			new ZHandler = RZClient_Play(i, trackid, true, false, false);
			RZClient_Set3DPosition(i, ZHandler, zombx, zomby, zombz, audio_range);
	        RZClient_Resume(i, ZHandler);
		}
	}
}

stock PlayHumanAudioForAll(playerid,trackid,Float:audio_range,Float:custom_range)
{
	new Float:zombx, Float:zomby, Float:zombz;
	GetPlayerPos(playerid, zombx, zomby, zombz);
    for(new i, l = GetMaxPlayers();i<l;i++)
	{
		if(IsPlayerConnected(i) && !IsZombieNPC(i) && RZClient_IsClientConnected(i) && IsPlayerInRangeOfPlayer(i, playerid, custom_range))
  		{
			new ZHandler = RZClient_Play(i, trackid, true, false, false);
			RZClient_Set3DPosition(i, ZHandler, zombx, zomby, zombz, audio_range);
	        RZClient_Resume(i, ZHandler);
		}
	}
}


stock checkPlayerWeaponHacking(playerid)
{
	if(IsPlayerConnected(playerid))
	{
        //check si pasaron al menos 5 segundos desde el ultimo ResetPlayerWeaponsEx()
        new weap = GetPlayerWeapon(playerid);
        new WHackz[256];
        if(weap > 1 && PlayerInfo[playerid][Weapon][weap] == false && !IsPlayerNPC(playerid) && !IsPlayerPaused(playerid) && weap != 40 && weap != 46)
        {
			if(GetPlayerState(playerid) == 1 || GetPlayerState(playerid) == 2 || GetPlayerState(playerid) == 3)
			{
				if(PlayerInfo[playerid][WH_Warnings] < MAX_HW_WARNINGS)
				{
				ResetPlayerWeaponsEx(playerid);
				new string[256];
				GetWeaponName(GetPlayerWeapon(playerid), WHackz, sizeof(WHackz) );
				format(string,sizeof(string), "{4DFFFF}**{FFFFFF} Weapon Hacker {4DFFFF} DETECTADO {FFFFFF}%s[%d]: %s {BBC1C1}[ Usa /spec %d ] [%d/%d]",PlayerName2(playerid),playerid,WHackz,playerid,PlayerInfo[playerid][WH_Warnings],MAX_HW_WARNINGS);
				MessageToAdmins(-1,string);
	            ResetPlayerWeaponsEx(playerid);
				SendFormatDialog(playerid,"{ffffff}<-- {f50000}ADVERTENCIA {ffffff}-->","{B366FF}Weapon Hack detectado, detente o te expulsaremos.\n\n{B366FF}Advertencias: {ffffff}%d de %d.",PlayerInfo[playerid][WH_Warnings],MAX_HW_WARNINGS);
                PlayerInfo[playerid][WH_Warnings]++;
                return 0;
				}
				else if(PlayerInfo[playerid][WH_Warnings] >= MAX_HW_WARNINGS)
				{
				PlayerInfo[playerid][dead] = 1;
				ResetPlayerWeaponsEx(playerid);
				SaveSQLWeaponData(playerid);//borrar todas las armas :v
				new string[256];
				format(string,sizeof(string), "{4DFFFF}**{FFFFFF} El Servidor {4DFFFF}ha [E]xpulsado a {FFFFFF}%s {BBC1C1}[Razon: Weapon Hacking: %d ] {ffffff}[%d/%d]",PlayerName2(playerid),weap,PlayerInfo[playerid][WH_Warnings],MAX_HW_WARNINGS);
				SendClientMessageToAll(0xFFFF00FF, string);
				PlayerInfo[playerid][WH_Warnings] = 1;
				new PlayerIP[128];
				GetPlayerIp(playerid,PlayerIP,sizeof(PlayerIP));
				GetWeaponName(GetPlayerWeapon(playerid), WHackz, sizeof(WHackz) );
				printf("[BAN]: %s[%d] IP: %d ha sido expulsado por Weapon Hacking Arma Hack: %s.",PlayerName2(playerid),playerid,PlayerIP,WHackz);
				new whackstr[128];
				format(whackstr,sizeof(whackstr),"Weapon Hacking: %d",weap);
				//BanSQL(playerid,INVALID_PLAYER_ID,whackstr); // Banear By AntiCheat
				__Kick(playerid);
				PlayerInfo[playerid][dead] = 0;
				return 0;
				}
            }
        }
		return 1;
	}
		return 1;
}

stock IsPlayerDead(playerid)
{
	if(PlayerInfo[playerid][dead] == 1) return true;
	else return false;
}

stock SetNPCHealth(npcid, Float:Health)
{
    if(IsZombieNPC(npcid))
    {
                NPC_INFO[npcid][VIDA] = Health;
    }
}

public Float:GetNPCHealth(npcid)
{
	if(IsZombieNPC(npcid)) return NPC_INFO[npcid][VIDA];
	return 0.0;
}

//==============================================================================
// Public - OnPlayerDeath.
//==============================================================================
stock GetKillerId(killerid, playerid)
{
	if(IsPlayerConnected(killerid) && IsPlayerInRangeOfPlayer(killerid,playerid,100.0)) return killerid;
	else return INVALID_PLAYER_ID;
}
public OnPlayerDeath(playerid, killerid, reason)
{
	if(IsPlayerConnected(playerid))
	{
	RemovePlayerAttachedObject(playerid, 9);
	PlayerInfo[playerid][Muertes]++;
	SetPVarInt(playerid, "ArmasDefault", 1);//dar armas por defecto
	PlayerInfo[playerid][dead] = 1;
	if(!IsPlayerNPC(playerid)){
	checkPlayerWeaponHacking(killerid);
	}
 	if(RZClient_IsClientConnected(playerid))
	{
		RZClient_Play(playerid, 12, false, false, false);
 	}
 	if(PlayerInfo[playerid][DRONE_ID] != INVALID_PLAYER_ID)
 	{
 	    FreeDroneBOT(PlayerInfo[playerid][DRONE_ID] , playerid);
 	}
	PlayerInfo[playerid][ZonaSegura] = 0;
	PlayerInfo[playerid][ZonaInfectada] = 0;
	if(gTeam[playerid] == Humano && !IsPlayerNPC(playerid))
	{
			#if defined ArmasDeath
			if(!IsPlayerInAnyVehicle(playerid) && IsPlayerConnected(playerid))
			{
			 	new Float:pPosX, Float:pPosY, Float:pPosZ;
				GetPlayerPos(playerid, pPosX, pPosY, pPosZ);
			    for(new i_slot = 0, gun, ammo; i_slot != 12; i_slot++)
			    {
			        GetPlayerWeaponData(playerid, i_slot, gun, ammo);
			        if(gun != 0 && ammo != 0 && !PlayerHaveAHackedWeapon(playerid,gun, ammo) && gun != 23 && gun != 46 && gun != 6)
					{
			            if(PlayerInfo[playerid][WeaponDroppable][gun] == true)
			            {
			                /*if(GetPlayerInterior(playerid) != 0)
							{
								CreateDroppedGun(gun, ammo, pPosX+random(2)-random(2), pPosY+random(2)-random(2), pPosZ, 0, 0, 0);//default, taken, zcoord
							}
							else
							{*/
							    CreateDroppedGun(gun, ammo, pPosX+random(2)-random(2), pPosY+random(2)-random(2), pPosZ);
							//}
						}
					}
			    }
		    }
		    #endif
		    ResetPlayerWeaponsEx(playerid);
			#if defined USE_ZOMBIE_RADAR
 			TextDrawSetString( PlayerInfo[playerid][RadarZombie], " ");
		    TextDrawHideForPlayer( playerid, PlayerInfo[playerid][RadarZombie] );
		    #endif
			if(GetKillerId(NPC_INFO[playerid][LastAttacker],playerid) == NPC_INFO[playerid][LastAttacker] && IsPlayerNPC(playerid))
			{
				    SendDeathMessage(NPC_INFO[playerid][LastAttacker], playerid, 53);
				    NPC_INFO[playerid][LastAttacker] = INVALID_PLAYER_ID;
			}
			else
			{
			        killerid = NPC_INFO[playerid][LastAttacker];
					if(killerid != INVALID_PLAYER_ID)
					{
						if(IsPlayerOnMission(killerid))
						{
							if(GetMissionType(killerid) == MISSION_KILL_HUMANS)
							{
								if(GetMissionProgressAmount(killerid) >= GetMissionProgressLimit(killerid))
								{
									PlayerPlaySound(killerid, 1057, 0.0, 0.0, 0.0);
									SendClientMessage(killerid,red,"]<!>[ {ffffff}Tú mision está completa, dirigete con cualquier cientifico para recibir tu recompensa.");
								}
								else
								{
									SetMissionProgressAmount(killerid, GetMissionProgressAmount(killerid)+1);
									SendFormatMessage(killerid,red,"]< Mission Status >[ {ffffff}%s %d %s: %d/%d.",GetMissionObjetiveText(killerid),GetMissionProgressLimit(killerid),GetMissionObjTypeName(killerid),GetMissionProgressAmount(killerid),GetMissionProgressLimit(killerid));
								}
							}
						}
				        if(RZClient_IsClientConnected(killerid))
				        {
						GivePlayerMoney(killerid, 1000);
						GameTextForPlayer(killerid, "~B~~H~~H~+5 SCORE! ~N~~W~$1000 - RZCLIENT", 6000, 4);
						SetPlayerScore(killerid, GetPlayerScore(killerid) + 5);
						}
						else
						{
						GivePlayerMoney(killerid, 150);
						GameTextForPlayer(killerid, "~B~~H~~H~+1 SCORE! ~N~~W~$150~n~", 6000, 4);
						SetPlayerScore(killerid, GetPlayerScore(killerid) + 1);
						}
				    	SendDeathMessage(NPC_INFO[playerid][LastAttacker], playerid, NPC_INFO[playerid][ByWeapon]);
				    	NPC_INFO[playerid][LastAttacker] = INVALID_PLAYER_ID;
			    	}
	    	}
	}
	else if(gTeam[playerid] == Zombie && !IsPlayerNPC(playerid))
	{
					if(killerid != INVALID_PLAYER_ID)
					{
				        if(RZClient_IsClientConnected(killerid))
				        {
						GivePlayerMoney(killerid, 1000);
						GameTextForPlayer(killerid, "~B~~H~~H~+5 SCORE! ~N~~W~$1000 - RZCLIENT", 6000, 4);
						SetPlayerScore(killerid, GetPlayerScore(killerid) + 5);
						}
						else
						{
						GivePlayerMoney(killerid, 150);
						GameTextForPlayer(killerid, "~B~~H~~H~+1 SCORE! ~N~~W~$150~n~", 6000, 4);
						SetPlayerScore(killerid, GetPlayerScore(killerid) + 1);
						}
				    	SendDeathMessage(killerid, playerid, reason);
			    	}
			    	if(PlayerInfo[playerid][VIP] <= 0)
			    	{
				 		gTeam[playerid] = Humano;
						GameTextForPlayer(playerid,"~b~~h~~h~Humano",5000,6);
						SetPlayerTeam(playerid,Humano);
						SetPlayerColor(playerid,HUMANO_COLOR);
			    	}
	}
    new string[150];
	if(!IsPlayerNPC(playerid))
	{
    new time = gettime();
    switch(time - PlayerInfo[playerid][LastDeath]){
        case 0 .. 3:
        {
            PlayerInfo[playerid][DeathSpam]++;
            if(PlayerInfo[playerid][DeathSpam] == 5)
            {
			if(IsPlayerAdmin(playerid)) return 0;
			format(string, sizeof(string), "{FFFFFF}El Servidor {4DFFFF} [B]loqueo del servidor al Jugador {ffffff}%s. {4DFFFF}[Razón: FakeKills ]",PlayerName2(playerid));
			SendClientMessageToAll(-1, string);
            BanEx(playerid,"FakeKILL"); // Banear By Anti Cheat
            }
        }
        default: PlayerInfo[playerid][DeathSpam] = 0;
    }
    PlayerInfo[playerid][LastDeath] = time;
    }
	if(!RZClient_IsClientConnected(playerid) && PlayerInfo[playerid][MusicInicio] == 0){
			SendFormatDialog(playerid,"{ffffff}<-- {f50000} RZClient.exe {ffffff}-->","{4DFFFF}Hey {ffffff}%s!\nPara Conseguir más beneficios en Nuestro servidor, descarga el {4DFFFF}RZ Client{ffffff} en:\n{4DFFFF}http://bit.ly/RZCLIENTE\n{ffffff}Al descargarlo tambien eliminaras este molesto aviso & conseguiras más puntaje & dinero.",PlayerName2(playerid));
			PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
	}
 return 1;
 }
 return 1;
}
forward ConteoAdmin();
public ConteoAdmin()
{
	if(CountDown==0)
	{
		GameTextForAll("~N~ ~N~ ~N~ ~N~ ~N~ ~r~~h~GO GO GO!",1500,3);
		CountDown = -1;
		for(new i = 0; i < GetMaxPlayers(); i++) {
			PlayerPlaySound(i,15802, 0.0, 0.0, 0.0);
		}
		return 0;
	}
	else if(CountDown==3)
	{
		for(new i = 0; i < GetMaxPlayers(); i++) {
			PlayerPlaySound(i,7417, 0.0, 0.0, 0.0);
		}
	}
	else if(CountDown==2)
	{
		for(new i = 0; i < GetMaxPlayers(); i++) {
			PlayerPlaySound(i,7418, 0.0, 0.0, 0.0);
		}
	}
	else if(CountDown==1)
	{
		for(new i = 0; i < GetMaxPlayers(); i++) {
			PlayerPlaySound(i,7419, 0.0, 0.0, 0.0);
		}
	}
	new text[7]; format(text,sizeof(text),"~w~%d",CountDown);
	GameTextForAll(text,1000,3);
	CountDown--;
	SetTimer("ConteoAdmin",1000,0);
	return 0;
}

//==============================================================================
// Public - OnPlayerCommandText.
//==============================================================================
public OnPlayerCommandText(playerid, cmdtext[])
{
    if(PlayerInfo[playerid][Identificado] == 0) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ]{ffffff} Para utilizar comandos debes identificarte primero."), 0;
	new cmd[256],idx;
	cmd = strtok(cmdtext, idx);
    dcmd(g,1,cmdtext);
    dcmd(botneme,7,cmdtext);
    dcmd(pms,3,cmdtext);
	dcmd(cambiarpass,11,cmdtext);
	dcmd(weaps,5,cmdtext);
	dcmd(announce,8,cmdtext);
	dcmd(admins,6,cmdtext);
	dcmd(vips,4,cmdtext);
	dcmd(ban,3,cmdtext);
	dcmd(rzban,5,cmdtext);
	dcmd(sban,4,cmdtext);
	dcmd(rzcban,6,cmdtext);
	dcmd(cban,4,cmdtext);
	dcmd(warn,4,cmdtext);
	dcmd(gskinid,7,cmdtext);
	dcmd(getid,5,cmdtext);
	#if defined VOTE_KICK_SYSTEM
	dcmd(votekick,8,cmdtext);
	#endif
	dcmd(uban,4,cmdtext);
	dcmd(spec,4,cmdtext);
	dcmd(naturecontrol,13,cmdtext);
	dcmd(muteserver,10,cmdtext);
	dcmd(serverhud,9,cmdtext);
	dcmd(corecontrol,11,cmdtext);
	dcmd(callar,6,cmdtext);
	dcmd(specoff,7,cmdtext);
	dcmd(scanner,7,cmdtext);
	//dcmd(procscanner,11,cmdtext);
	dcmd(kick,4,cmdtext);
	dcmd(dbug,4,cmdtext);
	dcmd(chbug,5,cmdtext);
	dcmd(sbcheck,7,cmdtext);
	dcmd(congelar,8,cmdtext);
	dcmd(cc,2,cmdtext);
	dcmd(cca,3,cmdtext);
	dcmd(gcardb,6,cmdtext);
	dcmd(car2,4,cmdtext);
	dcmd(car,3,cmdtext);
    dcmd(rduda,5,cmdtext);
	dcmd(aka,3,cmdtext);
	dcmd(akat,4,cmdtext);
    dcmd(setalltime,10,cmdtext);
	dcmd(setallweather,13,cmdtext);
	
	dcmd(setizweather,12,cmdtext);
	dcmd(setizhour,9,cmdtext);
	dcmd(setizlink,9,cmdtext);
	dcmd(setizspawntime,14,cmdtext);
	dcmd(setizzombies,12,cmdtext);
	dcmd(izhud,5,cmdtext);
	
	dcmd(setzombies,10,cmdtext);
	dcmd(setzspawntime,13,cmdtext);
	
	dcmd(setzspawnrange,14,cmdtext);
	dcmd(setzvision,10,cmdtext);
	
    dcmd(stats,5,cmdtext);
    dcmd(rescars,7,cmdtext);
    dcmd(descar,6,cmdtext);
    dcmd(spawn,5,cmdtext);
    dcmd(spawnall,8,cmdtext);
    dcmd(spawnallnpc,11,cmdtext);
	dcmd(rban,4,cmdtext);
	dcmd(goto,4,cmdtext);
	dcmd(get,3,cmdtext);
	dcmd(getnpcs,7,cmdtext);
	dcmd(givecash,8,cmdtext);
	dcmd(descash,7,cmdtext);
	dcmd(setcash,7,cmdtext);
	dcmd(darscore,8,cmdtext);
	dcmd(setscore,8,cmdtext);
	dcmd(explode,7,cmdtext);
	dcmd(reportar,8,cmdtext);
	dcmd(report,6,cmdtext);
	dcmd(reportes,8,cmdtext);
	dcmd(lsay,4,cmdtext);
	dcmd(digo,4,cmdtext);
//	dcmd(me,2,cmdtext);
	dcmd(link,4,cmdtext);
	dcmd(link_excut,10,cmdtext);
	dcmd(ip,2,cmdtext);
	dcmd(darvida,7,cmdtext);
	dcmd(kickall,7,cmdtext);
	dcmd(kickallnpc,10,cmdtext);
    dcmd(invisibles,10,cmdtext);
    dcmd(peers,5,cmdtext);
	dcmd(giveweapon,10,cmdtext);
	dcmd(disarm,6,cmdtext);
	dcmd(slap,4,cmdtext);
	dcmd(cerrarv,7,cmdtext);
    dcmd(abrirv,6,cmdtext);
    dcmd(fix,3,cmdtext);
    dcmd(lcar,4,cmdtext);
	if(strcmp("/aconteo", cmdtext, true, 10) == 0)
	{
		if(PlayerInfo[playerid][nivel] >= 1)
		{
	        if(CountDown == -1)
			{
			    new allSTR[256];
				CountDown = 3;
				SetTimer("ConteoAdmin",1000,0);
				format(allSTR, sizeof(allSTR), "{4DFFFF}El Administrador {FFFFFF}%s[%d] {4DFFFF} INICIO UN CONTEO.",PlayerName2(playerid),playerid);
			    SendClientMessageToAll(-1,allSTR);
			}
			else
			{
			SendClientMessage(playerid,COLOR_DE_ERROR, "[ ERROR ] {ffffff} El conteo esta en progreso.");
			}
		}
		return 1;
	}

	if(strcmp("/sync", cmdtext, true, 10) == 0)
	{
	SetCameraBehindPlayer(playerid);
	new Float:CX,Float:CY,Float:CZ;
	GetPlayerPos(playerid,CX,CY,CZ);
	SetPlayerPos(playerid,CX,CY,CZ+0.1);
	RemovePlayerFromVehicle(playerid);
	if(PlayerInfo[playerid][congelado] == 0){TogglePlayerControllable(playerid,1);}
	return 1;
	}

	if (!strcmp("/laser", cmdtext, true))
	{
	if(PlayerInfo[playerid][UsaLazer] == 0 && gTeam[playerid] == Humano)
	{
	SetPVarInt(playerid, "laser", 1);
	SetPVarInt(playerid, "color", GetPVarInt(playerid, "color"));
	PlayerInfo[playerid][UsaLazer] = 1;
	SendClientMessage(playerid,-1,"Laser Activado! Armas con laser: MP5, Silenciada, AK-47, Spas-12, M4, Sniper.");
	}
	else if(PlayerInfo[playerid][UsaLazer] == 1 && gTeam[playerid] == Humano)
	{
	SetPVarInt(playerid, "laser", 0);
  	RemovePlayerAttachedObject(playerid, 0);
  	PlayerInfo[playerid][UsaLazer] = 0;
  	SendClientMessage(playerid,-1,"Laser Desactivado.");
	}
	return 1;
  	}
   	if (!strcmp("/lasercolor", cmd, true))
	{
	new tmp[256];
	tmp = strtok(cmdtext, idx);
 	if (!strlen(tmp))
	{
	SendClientMessage(playerid, 0x00E800FF, "Uso correcto: /lasercolor [azul-rosa-naranja-verde-amarillo]");
	return 1;
	}
	if (!strcmp(tmp, "rojo", true)) SetPVarInt(playerid, "color", 18643);
	else if (!strcmp(tmp, "azul", true)) SetPVarInt(playerid, "color", 19080);
	else if (!strcmp(tmp, "rosa", true)) SetPVarInt(playerid, "color", 19081);
	else if (!strcmp(tmp, "naranja", true)) SetPVarInt(playerid, "color", 19082);
 	else if (!strcmp(tmp, "verde", true)) SetPVarInt(playerid, "color", 19083);
	else if (!strcmp(tmp, "amarillo", true)) SetPVarInt(playerid, "color", 19084);
	else SendClientMessage(playerid, 0x00E800FF, "Color no Disponible! =(");
	return 1;
	}
   	/*if (!strcmp("/clanes", cmd, true))
	{
			new DialogSTR[2048],ClanSTR[500],CLAN_Field[128],MCLAN_TAG[MAX_PLAYERS][50],MCLAN_LAST[MAX_PLAYERS][50];
		    NUM_ROWS_SQL = db_query(DataBase_USERS,"SELECT DISTINCT CLAN_TAG FROM Usuarios WHERE CLAN_OWN = '1'");
	     	if(db_num_rows(NUM_ROWS_SQL) > 0)
		    {
		        new finded_rows = db_num_rows(NUM_ROWS_SQL);
       			for (new i; i < finded_rows; i++)
			    {
	                db_get_field_assoc(NUM_ROWS_SQL, "CLAN_TAG", CLAN_Field, sizeof(CLAN_Field));
					strmid(MCLAN_TAG[i], CLAN_Field, 0, strlen(CLAN_Field));
					if (strcmp(MCLAN_TAG[i], MCLAN_LAST[i], false))
					{
 			        //obtener miembros en el clan//
			        new ClanCM[256],DBResult:ResultMember;
			        format(ClanCM,sizeof(ClanCM),"SELECT * FROM Usuarios WHERE CLAN_TAG = '%s'",MCLAN_TAG[i]);
		    		ResultMember = db_query(DataBase_USERS,ClanCM);
		    		new totalmembers = db_num_rows(ResultMember);
		    		//-----------------------------------------------//
					format(ClanSTR,sizeof(ClanSTR),"{FFFF00}* {ffffff}%d {FFFF00}[CLAN]{00FFFF}%s {ffffff}||{00FFFF} Miembros: {ffffff}%d\n",i,MCLAN_TAG[i],totalmembers);
					strcat(DialogSTR,ClanSTR);
 					strmid(MCLAN_LAST[i], MCLAN_TAG[i], 0, strlen(MCLAN_TAG[i]));
 					}
                	db_next_row(NUM_ROWS_SQL);
                }
                db_free_result(NUM_ROWS_SQL);
				ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFFF00}CLANES DE RZ", DialogSTR, "OK", "");
			}
			else
			{
			    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{8000FF}ERROR: NO HAY CLANES","{ffffff}Parece que no hay ningun clan en nuestra base de datos.","x","");
			}
	return 1;
	}*/
   	if (!strcmp("/borrar_clanes", cmd, true))
	{
		if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,-1,"te vas a banear en 3 2 1...");
		db_query(DataBase_USERS,"UPDATE Usuarios SET CLAN='0',CLAN_OWN='0',CLAN_TAG='0'");
		ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{8000FF}OK: ELIMINACION DE CLANES","{ffffff}CLANES ELIMINADOS EXITOZAMENTE.","x","");
		return 1;
	}
   	if (!strcmp("/clan", cmd, true))
	{
	new tmp[256];
	tmp = strtok(cmdtext, idx);
 	if (!strlen(tmp))
	{
	SendClientMessage(playerid, COLOR_DE_ERROR, "[ RZ ® ]{FFFFFF} /clan Crear{"COLOR_DE_ERROR_EX"} Crea un Clan :D");
	SendClientMessage(playerid, COLOR_DE_ERROR, "[ RZ ® ]{FFFFFF} /clan ver{"COLOR_DE_ERROR_EX"} Lista completa de los integrantes de un clan y fundadores.");
	SendClientMessage(playerid, COLOR_DE_ERROR, "[ RZ ® ]{FFFFFF} /clan Reclutar{"COLOR_DE_ERROR_EX"} para integrar miembros a tu clan.");
	SendClientMessage(playerid, COLOR_DE_ERROR, "[ RZ ® ]{FFFFFF} /clan Kick{"COLOR_DE_ERROR_EX"} expulsa a un jugador de tu clan.");
	SendClientMessage(playerid, COLOR_DE_ERROR, "[ RZ ® ]{FFFFFF} /clan Tag{"COLOR_DE_ERROR_EX"} Si deseas cambiar el 'TAG' De tu Clan.");
	SendClientMessage(playerid, COLOR_DE_ERROR, "[ RZ ® ]{FFFFFF} /clan Salir{"COLOR_DE_ERROR_EX"} Si usas este comando y eres dueño de un clan este sera eliminado.");
	return SendClientMessage(playerid, COLOR_DE_ERROR, "[ RZ ® ]{FFFFFF} /clan admin{"COLOR_DE_ERROR_EX"} Comando para otorgar/quitar privilegios de fundador a un miembro de tu clan.");
	}
	if (!strcmp(tmp, "crear", true))
	{
		if(PlayerInfo[playerid][CLAN_OWN] == 1 || PlayerInfo[playerid][CLAN] == 1) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ » ERROR « ]:{ffffff} Ya tienes un clan.");
		if(GetPlayerScore(playerid) < 10000) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ » ERROR « ]:{ffffff} Se requieren al menos 10 mil puntos para crear un clan.");
	    ShowPlayerDialog(playerid,CLAN_CREAR,DIALOG_STYLE_INPUT,"Creacion de Clan","{ffffff}Ahora solo tienes que ingresar un TAG para tu clan:","Crear","Cancelar");
	}
	else if (!strcmp(tmp, "reclutar", true))
	{
	if(PlayerInfo[playerid][CLAN] == 0) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ » ERROR « ]:{ffffff} No Perteneces a un clan.");
	if(PlayerInfo[playerid][CLAN_OWN] == 0) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ » ERROR « ]:{ffffff} Tu no eres fundador de ningun clan.");
	ShowPlayerDialog(playerid,CLAN_RECLUTAR,DIALOG_STYLE_INPUT,"Reclutacion de Jugadores","{ffffff}Por favor ingresa el ID del jugador que quieres unir a tu grupo, si este acepta se unira satisfactoriamente.","Invitar","Cancelar");
	}
	else if (!strcmp(tmp, "kick", true))
	{
	if(PlayerInfo[playerid][CLAN] == 0) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ » ERROR « ]:{ffffff} No Perteneces a un clan.");
	if(PlayerInfo[playerid][CLAN_OWN] == 0) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ » ERROR « ]:{ffffff} Tu no eres fundador de ningun clan.");
	ShowPlayerDialog(playerid,CLAN_KICK,DIALOG_STYLE_INPUT,"Expulsion de Miembro","{ffffff}Por favor ingresa el ID del jugador que quieres expulsar de tu CLAN/GRUPO, Tiene que estar ONLINE.","KICK","Cancelar");
	}
	else if (!strcmp(tmp, "tag", true))
	{
	if(PlayerInfo[playerid][CLAN] == 0) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ » ERROR « ]:{ffffff} No Perteneces a un clan.");
	if(PlayerInfo[playerid][CLAN_OWN] == 0) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ » ERROR « ]:{ffffff} No Tienes suficientes permisos en este clan para cambiar el TAG.");
    ShowPlayerDialog(playerid,CLAN_CTAG,DIALOG_STYLE_INPUT,"Cambiar TAG","{ffffff}Por favor ingresa un Nuevo TAG Para tu Clan en el recuadro de abajo, No Mas de 7 Caracteres.",">>","x");
	}
	else if (!strcmp(tmp, "salir", true))
	{
	if(PlayerInfo[playerid][CLAN] == 0) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ » ERROR « ]:{ffffff} No Perteneces a un clan.");
		if(PlayerInfo[playerid][CLAN_OWN] == 1)
		{
		    //eliminara a todos los usuarios del clan %s
			new CLAN_UPDATE[800];
			format(CLAN_UPDATE, sizeof(CLAN_UPDATE), "UPDATE Usuarios SET CLAN='0',CLAN_TAG='0',CLAN_OWN='0' WHERE CLAN_TAG = '%s'",DB_Escape(ClanTAG[playerid]));
			db_query(DataBase_USERS,CLAN_UPDATE);
			//fin de eliminacion
	    	for(new CLAN_MEMBER_ID = 0; CLAN_MEMBER_ID < GetMaxPlayers(); CLAN_MEMBER_ID++)
			{
			    if(playerid != CLAN_MEMBER_ID && IsPlayerConnected(CLAN_MEMBER_ID))
			    {
				    //utilizar el clan del lider 'playerid'= UNSC, para buscar en el clan del memberid, si es igual, eliminar, si no, dejarlo.
					if(IsPlayerOfMyClan(playerid,CLAN_MEMBER_ID) && PlayerInfo[CLAN_MEMBER_ID][CLAN] == 1)
					{
			        GameTextForPlayer(CLAN_MEMBER_ID, "~r~~h~TU CLAN ENTERO FUE ELIMINADO", 4000, 3);
			        PlayerInfo[CLAN_MEMBER_ID][CLAN] = 0;
			        PlayerInfo[CLAN_MEMBER_ID][CLAN_OWN] = 0;
				    PlayerInfo[CLAN_MEMBER_ID][InvitadorID] = 0;
				    Delete3DTextLabel(LabelCabecero[CLAN_MEMBER_ID]);
					LabelCabecero[CLAN_MEMBER_ID] = Create3DTextLabel(" ", 0xF50000AA, 30.0, 40.0, 50.0, 40.0, 0);
					Attach3DTextLabelToPlayer(LabelCabecero[CLAN_MEMBER_ID], CLAN_MEMBER_ID, 0.0, 0.0, 0.7);
			    	}
		    	}
		    }
      		SendFormatMessageToAll(red, "[ RZ ]:{ffffff} EL CLAN {F50000}%s{FFFFFF} FUE ELIMINADO POR %s [ID: %d].", ClanTAG[playerid], PlayerName2(playerid), playerid);
      		ClanTAG[playerid][0] = EOS;
      		PlayerInfo[playerid][CLAN] = 0;
      		PlayerInfo[playerid][CLAN_OWN] = 0;
		    PlayerInfo[playerid][InvitadorID] = 0;
		    Delete3DTextLabel(LabelCabecero[playerid]);
			LabelCabecero[playerid] = Create3DTextLabel(" ", 0xF50000AA, 30.0, 40.0, 50.0, 40.0, 0);
			Attach3DTextLabelToPlayer(LabelCabecero[playerid], playerid, 0.0, 0.0, 0.7);
			format(CLAN_UPDATE, sizeof(CLAN_UPDATE), "UPDATE Usuarios SET CLAN='0',CLAN_TAG='0',CLAN_OWN='0' WHERE Username = '%s'",PlayerName2(playerid));
			db_query(DataBase_USERS,CLAN_UPDATE);
			SendFormatGameText(playerid,"~r~~h~~h~ELIMINASTE EL CLAN: ~w~%s",ClanTAG[playerid],4000,3);
		}
		else
		{
			PlayerInfo[playerid][CLAN] = 0;
		    PlayerInfo[playerid][InvitadorID] = 0;
			new CLAN_UPDATE[256];
			format(CLAN_UPDATE, sizeof(CLAN_UPDATE), "UPDATE Usuarios SET CLAN='0',CLAN_TAG='0',CLAN_OWN='0' WHERE Username = '%s'",PlayerName2(playerid));
			db_query(DataBase_USERS,CLAN_UPDATE);
			SendFormatGameText(playerid,"~r~~h~~h~SALISTE DEL CLAN: ~w~%s",ClanTAG[playerid],4000,3);
            ClanTAG[playerid][0] = EOS;
            Delete3DTextLabel(LabelCabecero[playerid]);
			LabelCabecero[playerid] = Create3DTextLabel(" ", 0xF50000AA, 30.0, 40.0, 50.0, 40.0, 0);
			Attach3DTextLabelToPlayer(LabelCabecero[playerid], playerid, 0.0, 0.0, 0.7);
		}
	}
	else if (!strcmp(tmp, "admin", true))
	{
	if(PlayerInfo[playerid][CLAN] == 0) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ » ERROR « ]:{ffffff} No Perteneces a un clan.");
	if(PlayerInfo[playerid][CLAN_OWN] == 0) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ » ERROR « ]:{ffffff} No Tienes suficientes permisos en este clan para dar admin.");
    ShowPlayerDialog(playerid,CLAN_DADMIN,DIALOG_STYLE_INPUT,"Privilegios del CLAN","{ffffff}Por favor ingresa EL {f50000}ID DEL USUARIO {ffffff}al que quieres otorgar privilegios de admin para tu clan.\n\n{F50000}EL USUARIO PODRA MODERAR EL CLAN COMO SI FUESE EL FUNDADOR,\n{FFFFFF}PODRA ELIMINARTE / ELIMINAR EL CLAN ENTERO / RECLUTAR USUARIOS\n\n{FFFF1F}SI TE ROBAN EL CLAN, NOSOTROS NO PODREMOS HACER NADA, USELO CON CUIDADO.",">>","x");
	}
	else if (!strcmp(tmp, "ver", true))
	{
	    //SendClientMessage(playerid, COLOR_DE_ERROR, "[ » ERROR « ]:{ffffff} Desactivado por bug.");
    	ShowPlayerDialog(playerid,CLAN_VER,DIALOG_STYLE_INPUT,"{ffffff}Ver Información sobre un CLAN","{ffffff}Por favor ingresa el TAG del clan que deseas ver.",">>","x");
	}
	else{
	SendClientMessage(playerid, COLOR_DE_ERROR, "[ RZ ® ]{FFFFFF} /clan Crear{"COLOR_DE_ERROR_EX"} Crea un Clan :D");
	SendClientMessage(playerid, COLOR_DE_ERROR, "[ RZ ® ]{FFFFFF} /clan ver{"COLOR_DE_ERROR_EX"} Lista completa de los integrantes de un clan y fundadores.");
	SendClientMessage(playerid, COLOR_DE_ERROR, "[ RZ ® ]{FFFFFF} /clan Reclutar{"COLOR_DE_ERROR_EX"} para integrar miembros a tu clan.");
	SendClientMessage(playerid, COLOR_DE_ERROR, "[ RZ ® ]{FFFFFF} /clan Kick{"COLOR_DE_ERROR_EX"} expulsa a un jugador de tu clan.");
	SendClientMessage(playerid, COLOR_DE_ERROR, "[ RZ ® ]{FFFFFF} /clan Tag{"COLOR_DE_ERROR_EX"} Si deseas cambiar el 'TAG' De tu Clan.");
	SendClientMessage(playerid, COLOR_DE_ERROR, "[ RZ ® ]{FFFFFF} /clan Salir{"COLOR_DE_ERROR_EX"} Si usas este comando y eres dueño de un clan este sera eliminado.");
	SendClientMessage(playerid, COLOR_DE_ERROR, "[ RZ ® ]{FFFFFF} /clan admin{"COLOR_DE_ERROR_EX"} Comando para otorgar/quitar privilegios de fundador a un miembro de tu clan.");
	}
	return 1;
	}

	#if defined SistemaDECombustible
	if(!strcmp(cmdtext, "/refuel", true)||!strcmp(cmdtext, "/gas", true))
	{
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0x00FF00FF, "No estas en un vehiculo.");
	 	if(Rellenando[playerid]) return SendClientMessage(playerid, 0x00FF00FF, "Ya estas recargando combustible.");
        ShowPlayerDialog(playerid,BIDON_DIALOG,DIALOG_STYLE_INPUT,"{ffffff}Recargar {f50000}Combustible","{FF0099}* Por favor digite La cantidad de combustible a recargar.\n{ffffff}1 LITRO = {00FF33}100$","OK","x");
		return 1;
	}
	#endif
/*
	if(strcmp("/suicidio", cmdtext, true, 10) == 0)
	{
	SetPlayerHealth(playerid, 0);
	ForceClassSelection(playerid);
	return 1;
	}

	if(strcmp("/kill", cmdtext, true, 10) == 0)
	{
	SetPlayerHealth(playerid, 0);
	//ForceClassSelection(playerid);
	return 1;
	}*/

	/*if(strcmp("/Prender", cmdtext, true) == 0)
	{
    if(!IsPlayerInRangeOfPoint(playerid, 4, 1382.3994,777.4811,12.3281))
	{
	new Float:Distance = 5;
    PlayAudioStreamForAll("http://1071.live.streamtheworld.com/LOS40_CHILECMP3",-2285.7251,1826.7906,2.7195, Distance, 4);
    }
    return 1;
    }*/
	if(strcmp("/kill", cmdtext, true, 10) == 0)
	{
	checkPlayerWeaponHacking(playerid);
	SetPlayerHealth(playerid, 0);
	//ForceClassSelection(playerid);
	return 1;
	}

    if (strcmp(cmd, "/Lucha", true) == 0 || strcmp(cmd, "/fight", true) == 0)
	{
   		ShowPlayerDialog(playerid, FIGHT, DIALOG_STYLE_LIST, "{F81414}Estilos de pelea", "{6EF83C}Normal Fighting Skills\n{6EF83C}Boxing Skills\n{6EF83C}Kungfu Skills\n{6EF83C}KneeHeader\n{6EF83C}GrabKicker\n{6EF83C}Elbow", "Select", "Cancel");
		return 1;
	}

	if(strcmp("/join", cmdtext, true, 10) == 0)
	{
	    if(gTeam[playerid] == Zombie) return SendClientMessage(playerid, Rojo, "[ERROR]: {ffffff}Los zombies no pueden jugar al minijuego.");
	    if(PlayerInfo[playerid][InCORE] == 1) return SendClientMessage(playerid, red, ">> Ya estas dentro del minijuego: {ffffff}Proteger al Nucleo.");
	    if(HumanCore[Enabled] == 0) return SendClientMessage(playerid, red, ">> error {ffffff}El minijuego esta desactivado.");
		if(HumanCore[STATE] == CORE_WAITING || HumanCore[STATE] == CORE_FIGHTING)
		{
	    	if(!RZClient_IsClientConnected(playerid) && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, red, ">> Error {ffffff}Para acceder al minijuego necesitas estar conectado con el RZClient.");
		    new CurrentDefenders = getHCPlayerCount();
		    if(CurrentDefenders >= HumanCore[MAX_DEFENDERS] && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, red, ">> Ya no se admiten más reclutas, espera para la próxima ronda.");
		    PlayerInfo[playerid][InCORE] = 1;
		    CurrentDefenders++;
		    SendFormatMessageToAll(red,">] RZ [< {ffffff}%s [%d] se enlisto para proteger el nucleo. (%d/%d) {33FFFF}/join",PlayerName2(playerid),playerid,CurrentDefenders,HumanCore[MAX_DEFENDERS]);
		    SpawnCorePlayer(playerid);
			if(PlayerInfo[playerid][DRONE_ID] != INVALID_PLAYER_ID)
			{
				FreeDroneBOT(PlayerInfo[playerid][DRONE_ID], playerid);
				GameTextForPlayer(playerid,"~g~~h~> DRONE LIBERADO! <", 3000,3);
			}
		}
		/*else if(HumanCore[STATE] == CORE_FIGHTING)
		{
		     return SendClientMessage(playerid, red, ">> error {ffffff}La misión para proteger al nucleo ha comenzado.");
		}*/
		else return SendClientMessage(playerid, red, ">> error {ffffff}No hay ningun nucleo que proteger todavia.");
		return 1;
	}

	if(strcmp("/wpacktest", cmdtext, true, 10) == 0)
	{
		WeaponPack(playerid);
		return 1;
	}
	if(strcmp("/Comandos", cmdtext, true, 10) == 0 || strcmp("/cmds", cmdtext, true, 10) == 0)
	{
	//873 chars calculated.
	new BIG_DIALOG[910];
	strcat(BIG_DIALOG, ""COL_WHITE"1.\t/drop\t\t"COL_WHITE"Suelta el arma que estes utilizando.\n", sizeof(BIG_DIALOG));
	strcat(BIG_DIALOG, ""COL_CMDS"2.\t/mission\t"COL_CMDS"Muestra información de tu misión actual.\n", sizeof(BIG_DIALOG));
	strcat(BIG_DIALOG, ""COL_WHITE"3.\t/sendcash\t"COL_WHITE"Envia dinero a otros jugadores.\n", sizeof(BIG_DIALOG));
	strcat(BIG_DIALOG, ""COL_CMDS"4.\t/rules\t\t"COL_CMDS"Muestra las reglas que rigen a todos los usuarios.\n", sizeof(BIG_DIALOG));
	strcat(BIG_DIALOG, ""COL_WHITE"5.\t/sync\t\t"COL_WHITE"Desbugea tu personaje (refresca).\n", sizeof(BIG_DIALOG));
	strcat(BIG_DIALOG, ""COL_CMDS"6.\t/report\t\t"COL_CMDS"Envia un reporte secreto de algun infractor.\n", sizeof(BIG_DIALOG));
	strcat(BIG_DIALOG, ""COL_WHITE"7.\t/clan\t\t"COL_WHITE"Muestra los comandos disponibles para los clanes.\n", sizeof(BIG_DIALOG));
	strcat(BIG_DIALOG, ""COL_CMDS"8.\t/laser\t\t"COL_CMDS"Activa un apuntador laser en algunas de tus armas.\n", sizeof(BIG_DIALOG));
	strcat(BIG_DIALOG, ""COL_WHITE"9.\t/fight\t\t"COL_WHITE"Cambia el estilo de pelea de tu personaje.\n", sizeof(BIG_DIALOG));
	strcat(BIG_DIALOG, ""COL_CMDS"10.\t/stats\t\t"COL_CMDS"Muestra tus estadisticas o las de otro jugador.\n", sizeof(BIG_DIALOG));
	strcat(BIG_DIALOG, ""COL_WHITE"11.\t/gc\t\t"COL_WHITE"Guarda el progreso actual de tu cuenta.\n", sizeof(BIG_DIALOG));
	strcat(BIG_DIALOG, ""COL_CMDS"12.\t/rvip\t\t"COL_CMDS"Te otorga nivel vip basado en tu puntaje actual.\n", sizeof(BIG_DIALOG));
//	strcat(BIG_DIALOG, ""COLOR_CMDS". "COL_WHITE"\n", sizeof(BIG_DIALOG));
	ShowPlayerDialog(playerid, DIALOG_COMANDOS, DIALOG_STYLE_MSGBOX, ""COL_GB_LIGHT"* [RZ] Comandos: "COL_CMDS"Comando"COL_GB_LIGHT" - "COL_WHITE"Función.", BIG_DIALOG, "More", "Cancel");
	return 1;
	}
	if(strcmp("/Comandos2", cmdtext, true, 10) == 0 || strcmp("/cmds2", cmdtext, true, 10) == 0)
	{
	    new BIG_DIALOG[530];
		strcat(BIG_DIALOG, ""COL_WHITE"13.\t/weaps [id]\t"COL_WHITE"Muestra las armas de un jugador\n", sizeof(BIG_DIALOG));
		strcat(BIG_DIALOG, ""COL_CMDS"14.\t/pm\t\t"COL_CMDS"Envia un mensaje privado a un jugador\n", sizeof(BIG_DIALOG));
		strcat(BIG_DIALOG, ""COL_WHITE"15.\t/ditem\t\t"COL_WHITE"Elimina los objetos decorativos\n", sizeof(BIG_DIALOG));
		strcat(BIG_DIALOG, ""COL_CMDS"16.\t/buydrone\t"COL_CMDS"Menu para comprar un drone express\n", sizeof(BIG_DIALOG));
		strcat(BIG_DIALOG, ""COL_WHITE"17.\t/freedrone\t"COL_WHITE"Libera tu drone actual\n", sizeof(BIG_DIALOG));
		strcat(BIG_DIALOG, ""COL_CMDS"18.\t/pms\t\t"COL_CMDS"Activa / desactiva tus mensajes privados\n", sizeof(BIG_DIALOG));
		strcat(BIG_DIALOG, ""COL_WHITE"19.\t/clanes\t\t"COL_WHITE"Lista de clanes del servidor.\n", sizeof(BIG_DIALOG));
		strcat(BIG_DIALOG, ""COL_CMDS"20.\t/stop\t\t"COL_CMDS"Detiene el AudioStream en reproducción.\n", sizeof(BIG_DIALOG));
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, ""COL_GB_LIGHT"* [RZ] Comandos: "COL_CMDS"Comando"COL_GB_LIGHT" - "COL_WHITE"Función.", BIG_DIALOG, "OK", "Cancel");
		return 1;
	}

	if(strcmp("/mision", cmdtext, true, 10) == 0 || strcmp("/mission", cmdtext, true, 10) == 0)
	{
    	ShowMissionInformationForPlayer(playerid);
		return 1;
	}

	if(strcmp("/stop", cmdtext, true, 10) == 0 || strcmp("/stopmp3", cmdtext, true, 10) == 0)
	{
	if(SinCHAT == 1&& !IsPlayerAdmin(playerid)) return SendClientMessage(playerid,COLOR_DE_ERROR, "[ ERROR ] {FFFFFF}El chat esta desactivado."), 0;
	StopAudioStreamForPlayerEx(playerid);
	SendClientMessage(playerid, -1, "El AudioStream fue detenido.");
	return 1;
	}

	if(strcmp("/stopall", cmdtext, true, 10) == 0)
	{
	if(SinCHAT == 1&& !IsPlayerAdmin(playerid)) return SendClientMessage(playerid,COLOR_DE_ERROR, "[ ERROR ] {FFFFFF}El chat esta desactivado."), 0;
	if (PlayerInfo[playerid][nivel] <= 3) return SendClientMessage(playerid, COLOR_DE_ERROR,"[ ERROR ] No tienes suficiente nivel para usar este comando");
	StopAudioStreamForAll();
	new iString[256];
	format(iString, sizeof(iString), "{4DFFFF}**{FFFFFF} %s {4DFFFF} Ha Detenido la Musica En Reproduccion.",PlayerName2(playerid));
	SendClientMessageToAll(-1,iString);
	return 1;
	}
	if(strcmp("/borrar", cmdtext, true, 10) == 0 || strcmp("/ditem", cmdtext, true, 10) == 0)
	{
    RemovePlayerAttachedObject(playerid, 9);
    RemovePlayerAttachedObject(playerid, 8);
	return 1;
	}

	if(strcmp("/rvip", cmdtext, true, 10) == 0)
	{
	//ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFFF00}Reclamación de VIP (RVIP).", "Este comando fue desactivado, para obtener vip debes pedirlo a x[R]icard[O.O]x", "x", "");
	new RVIPSTR[80],rVIP[570];
	if(GetPlayerScore(playerid) >= VIP_SCORE_SILVER && GetPlayerScore(playerid) < VIP_SCORE_GOLD && PlayerInfo[playerid][VIP] < 1)
	{
		format(RVIPSTR, sizeof(RVIPSTR), "UPDATE Usuarios SET VIP='1' WHERE Username = '%s'",DB_Escape(PlayerName2(playerid)));
		db_query(DataBase_USERS,RVIPSTR);
		strcat(rVIP, "{FFFFFF}Te hemos quitado {F5000}175.000{FFFFFF} (mil)  puntos por obtener el nivel Silver.\n");
		strcat(rVIP, "{f50000}Nivel VIP Obtenido: Silver (1) - Utiliza /CMDSVIP para ver tus nuevos comandos & beneficios.");
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFFF00}Reclamación de VIP (RVIP).", rVIP, "x", "");
		PlayerInfo[playerid][VIP] = 1;
		SetPlayerScore(playerid, GetPlayerScore(playerid) - VIP_SCORE_SILVER);
		CallLocalFunction("OnPlayerCommandText", "is", playerid, "/gc");
	}
	else if(GetPlayerScore(playerid) >= VIP_SCORE_GOLD && GetPlayerScore(playerid) < VIP_SCORE_PREMIUM && PlayerInfo[playerid][VIP] < 2)
	{
		format(RVIPSTR, sizeof(RVIPSTR), "UPDATE Usuarios SET VIP='2' WHERE Username = '%s'",DB_Escape(PlayerName2(playerid)));
		db_query(DataBase_USERS,RVIPSTR);
		strcat(rVIP, "{f50000}Nivel VIP Obtenido: Gold (2) - Utiliza /CMDSVIP para ver tus nuevos comandos & beneficios.\n");
		strcat(rVIP, "{FFFFFF}Te hemos quitado {F5000}950.000{FFFFFF} (mil) puntos por obtener el nivel GOLD.\n");
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFFF00}Reclamación de VIP (RVIP).", rVIP, "x", "");
		PlayerInfo[playerid][VIP] = 2;
		SetPlayerScore(playerid, GetPlayerScore(playerid) - VIP_SCORE_GOLD);
		CallLocalFunction("OnPlayerCommandText", "is", playerid, "/gc");
	}
	else if(GetPlayerScore(playerid) >= VIP_SCORE_PREMIUM && PlayerInfo[playerid][VIP] < 3)
	{
		format(RVIPSTR, sizeof(RVIPSTR), "UPDATE Usuarios SET VIP='3' WHERE Username = '%s'",DB_Escape(PlayerName2(playerid)));
		db_query(DataBase_USERS,RVIPSTR);
		strcat(rVIP, "{FFFFFF}Te hemos quitado {F5000}1.000.000{FFFFFF} (millon) de puntos por obtener el nivel Premium.\n");
		strcat(rVIP, "{f50000}Nivel VIP Obtenido: Premium (3) - Utiliza /CMDSVIP para ver tus nuevos comandos & beneficios.");
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFFF00}Reclamación de VIP (RVIP).", rVIP, "x", "");
		PlayerInfo[playerid][VIP] = 3;
		SetPlayerScore(playerid, GetPlayerScore(playerid) - VIP_SCORE_PREMIUM);
		CallLocalFunction("OnPlayerCommandText", "is", playerid, "/gc");
	}
	else
	{
		strcat(rVIP, "{F50000}PUNTOS INSUFICIENTES! SCORE REQUERIDO:\n\n");
		strcat(rVIP, "{FFFF33}VIP: {F500F5}Silver (1){ffffff}:{CC99FF} 175.000 {F500F5}PUNTOS/3.99 USD/mes\n");
		strcat(rVIP, "{FFFF33}VIP: {F500F5}Golden (2){ffffff}:{CC99FF} 950.000 {F500F5}PUNTOS/6.99 USD/mes\n");
		strcat(rVIP, "{FFFF33}VIP: {F500F5}Premium (3){ffffff}:{CC99FF} 1.000.000 {F500F5}PUNTOS/13.99/mes USD\n");
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFFF00}Reclamación de VIP (RVIP).", rVIP, "x", "");
	}
	return 1;
	}

	if(strcmp("/gc", cmdtext, true, 10) == 0)
	{
	if(PlayerInfo[playerid][Identificado] == 1 && ConexionSQL == 1)
	{
	new Float:x, Float:y, Float:z, Float:a,Float:sa,Float:ar;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
	GetPlayerHealth(playerid, sa);
	GetPlayerArmour(playerid, ar);
	new updateInt[1500];
	format(updateInt, sizeof(updateInt), "UPDATE Usuarios SET SCORE='%d',DINERO='%d',VIP='%d',ADMIN='%d',skinP='%d',skinID='%d' WHERE Username = '%s'", GetPlayerScore(playerid),GetPlayerMoney(playerid),PlayerInfo[playerid][VIP],PlayerInfo[playerid][nivel],PlayerInfo[playerid][UsaSkin],PlayerInfo[playerid][SkinID],PlayerName2(playerid));
	db_query(DataBase_USERS,updateInt);
	format(updateInt, sizeof(updateInt), "UPDATE Usuarios SET CLAN='%d',CLAN_TAG='%s',CLAN_OWN='%d' WHERE Username = '%s'",PlayerInfo[playerid][CLAN],DB_Escape(ClanTAG[playerid]),PlayerInfo[playerid][CLAN_OWN],PlayerName2(playerid));
	db_query(DataBase_USERS,updateInt);
	if(PlayerInfo[playerid][dead] == 1)
	{
	    new Random = random(sizeof(SPAWNS_HUMANOS));
	    x = SPAWNS_HUMANOS[Random][0];
	    y = SPAWNS_HUMANOS[Random][1];
	    z = SPAWNS_HUMANOS[Random][2];
	}
	format(updateInt, sizeof(updateInt), "UPDATE Usuarios SET LX='%f',LY='%f',LZ='%f',LA='%f',sangre='%f',armadura='%f' WHERE Username = '%s'", x,y,z,a,sa,ar,PlayerName2(playerid));
	db_query(DataBase_USERS,updateInt);
	SaveMissionInfo(playerid);
	if(gTeam[playerid] != Zombie){
		SaveSQLWeaponData(playerid);
	}
	SendClientMessage(playerid, -1, "Datos Exitozamente Guardados.");
	PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	}
	return 1;
	}

	if(strcmp("/hola", cmdtext, true, 10) == 0)
	{
    new string[256];
	if((rztickcount() - PlayerInfo[playerid][Antispam1]) < 300) return SendClientMessage(playerid, Rojo, "[<!>] Tiene que esperar 5 minutos para reusar este comando.");
	new sendername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, sendername, sizeof(sendername));
	strreplace(sendername,"~","");
	format(string, sizeof(string), "~w~~h~%s~n~~b~te saluda", sendername);
	GameTextForAll(string,5000,1);
	PlayerInfo[playerid][Antispam1] = rztickcount();
	return 1;
	}

	if(strcmp("/sasvc", cmdtext, true, 10) == 0 || strcmp("/sasczz", cmdtext, true, 10) == 0)
	{
		if(!IsPlayerInAnyVehicle(playerid))
			SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ] {FFFFFF}Debes estar dentro de un  vehiculo para usar este comando.");
		else ShowPlayerDialog(playerid, MODIFICAR_DIALOGO, DIALOG_STYLE_LIST,"Control", "Luces( On/Off )\nCapo ( Open/Close )\nMaletero/Baul ( Open/Close )\nPuertas ( Open/Close )\nMotor ( On/Off )\nAlarma ( On/Off )", "Seleccionar", "Cancelar");
		return 1;
	}

	if(strcmp("/friendlyfire", cmdtext, true, 10) == 0)
	{
       if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,0xCC0000FF, "ño :3");
        EnableVehicleFriendlyFire();
        SendClientMessage(playerid,0xCC0000FF, "Sent!");
		return 1;
	}

	if(strcmp("/charlar", cmdtext, true, 10) == 0 || strcmp("/comprar", cmdtext, true, 10) == 0 || strcmp("/buy", cmdtext, true, 10) == 0)
	{
		new actorid = GetClosestActor(playerid);
		if(IsPlayerInRangeOfActor(playerid, actorid, 10))
		{
		    CheckTradingForPlayer(playerid, actorid);
		    return 1;
		}
	    else return SendClientMessage(playerid, Rojo, "[<!>] No estas cerca de ningun personaje.");
	}


	if(strcmp("/buydrone", cmdtext, true, 10) == 0 || strcmp("/comprardrone", cmdtext, true, 10) == 0 || strcmp("/drone_express", cmdtext, true, 10) == 0)
	{
	    if(PlayerInfo[playerid][DRONE_ID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ] {ffffff}Ya posees un drone, necesitas /liberar para adquirir uno nuevo.");
		if(PlayerInfo[playerid][InCORE] == 1 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ] {ffffff}Tienda express no disponible dentro del nucleo.");
		return ShowPlayerDialog(playerid, COMERCIO_DRONES_RZ_EXPRESS, DIALOG_STYLE_TABLIST_HEADERS, "{FF0099}R.Z: {FFFFFF}Comercio::{FF0099} Drones Express",
					"Drone\tPrecio ($)\tHabilidad\n\
					Pucky\t$10.000\t13.33\n\
					Duck\t$20.000\t16.66\n\
					Elite\t$100.000\t33.33\n",
					"Comprar", "x");
	}

    if(strcmp(cmdtext, "/darma", true) == 0
    || strcmp(cmdtext, "/dejararma", true) == 0
	|| strcmp(cmdtext, "/drop", true) == 0)
    {
    	if(gTeam[playerid] == Zombie) return SendClientMessage(playerid, Rojo, "[ERROR]: {ffffff}Los zombies no pueden soltar armas.");
        if((rztickcount() - PlayerInfo[playerid][TimerDARMA]) <= 3) return SendClientMessage(playerid, Rojo, "[<!>] Tiene que esperar 3 Segundos para reusar este comando.");
        if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
        new GunID = GetPlayerWeapon(playerid);

        if(PlayerInfo[playerid][InCORE] == 1 && GunID == 31) return SendClientMessage(playerid, Rojo, "[<!>] Esta arma pertenece al nucleo, no puede ser soltada.");
        if(PlayerInfo[playerid][WeaponDroppable][GunID] == false) return SendClientMessage(playerid, Rojo, "[<!>] No puedes soltar esta arma porque fue obtenida mediante un bonus.");
        new GunAmmo = GetPlayerAmmo(playerid);

        new GunID_Slot = GetWeaponSlot(GunID);
        new ilegal_bullets = GunAmmo - PlayerInfo[playerid][AAH_WeaponAmmo][GunID_Slot];
		if(ilegal_bullets >= 1)// se aumento la munición
		{
				new PlayerIP[128];
				GetPlayerIp(playerid,PlayerIP,sizeof(PlayerIP));

				printf("[KICK]:/darma %s[%d] IP: %d ha sido expulsado por Ammo Hacked | Arma Hack: %d, ammo has been ilegally increased: %d bullets.",PlayerName2(playerid),playerid,PlayerIP,GunID, ilegal_bullets);
				PlayerInfo[playerid][dead] = 1;
				ResetPlayerWeaponsEx(playerid);
				SaveSQLWeaponData(playerid);//borrar todas las armas :v
				new string[256];
				format(string,sizeof(string), "**{FFFFFF} Anti Cheat {4DFFFF}ha [E]xpulsado a {FFFFFF}%s {BBC1C1}[Razon: AmmoHack: %d, +%d bullets ] {ffffff}[%d/%d]",PlayerName2(playerid),GunID, ilegal_bullets);
				SendClientMessageToAll(0x4DFFFFFF, string);
				return __Kick(playerid);
		}

        if(GunID > 0 && GunAmmo != 0)
        {
            new f = MAX_DROPPED_WEAPONS+1;
            for(new a = 0; a < MAX_DROPPED_WEAPONS; a++)
            {
                if(dGunData[a][ObjID] == -1)
                {
                    f = a;
                    break;
                }
            }
            if(f > MAX_DROPPED_WEAPONS) return SendClientMessage(playerid, COLOR_DE_ERROR, "Es imposible soltar el arma en este momento, intentalo más tarde!");
            if(PlayerHaveAHackedWeapon(playerid, GunID, GunAmmo)) return checkPlayerWeaponHacking(playerid);
			RemovePlayerWeapon(playerid, GunID);

            GetPlayerPos(playerid, dGunData[f][ObjPos][0], dGunData[f][ObjPos][1], dGunData[f][ObjPos][2]);
            /*if(GetPlayerInterior(playerid) != 0)
            {
                CreateDroppedGun(GunID, GunAmmo, dGunData[f][ObjPos][0], dGunData[f][ObjPos][1], dGunData[f][ObjPos][2], 0, 0, 0);//default, taken, findzcoord
            }
            else{*/
				CreateDroppedGun(GunID, GunAmmo, dGunData[f][ObjPos][0], dGunData[f][ObjPos][1], dGunData[f][ObjPos][2]);
			//}
            new buffer[128];
			format(buffer, sizeof(buffer), "Has soltado el arma %s", GunNames[GunID]);
			SendClientMessage(playerid, COLOR_ARTICULO, buffer);
			PlayerInfo[playerid][TimerDARMA] = rztickcount();
        }
        return 1;
    }

    if(strcmp(cmdtext, "/dja_exe", true) == 0)
    {
        if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
        new GunID = GetPlayerWeapon(playerid);
        new GunAmmo = GetPlayerAmmo(playerid);
        if(GunID > 0 && GunAmmo != 0)
        {
            new f = MAX_DROPPED_WEAPONS+1;
            for(new a = 0; a < MAX_DROPPED_WEAPONS; a++)
            {
                if(dGunData[a][ObjID] == -1)
                {
                    f = a;
                    break;
                }
            }
            if(f > MAX_DROPPED_WEAPONS) return SendClientMessage(playerid, COLOR_DE_ERROR, "Es imposible soltar el arma en este momento, intentalo más tarde!");

            GetPlayerPos(playerid, dGunData[f][ObjPos][0], dGunData[f][ObjPos][1], dGunData[f][ObjPos][2]);
            /*if(GetPlayerInterior(playerid) != 0)
            {
                CreateDroppedGun(GunID, GunAmmo, dGunData[f][ObjPos][0], dGunData[f][ObjPos][1], dGunData[f][ObjPos][2], 0, 0, 0);//default, taken, findzcoord
            }
            else{*/
				CreateDroppedGun(GunID, GunAmmo, dGunData[f][ObjPos][0], dGunData[f][ObjPos][1], dGunData[f][ObjPos][2]);
			//}
            new buffer[80];
			format(buffer, sizeof(buffer), "Has soltado el arma %s", GunNames[dGunData[f][ObjData][0]]);
			SendClientMessage(playerid, COLOR_ARTICULO, buffer);
        }
        return 1;
    }

    if(strcmp(cmdtext, "/djddweapon", true) == 0)
    {
        if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
        new GunID = GetPlayerWeapon(playerid);
        new GunAmmo = GetPlayerAmmo(playerid);
        if(GunID > 0 && GunAmmo != 0)
        {
            new f = MAX_DROPPED_WEAPONS+1;
            for(new a = 0; a < MAX_DROPPED_WEAPONS; a++)
            {
                if(dGunData[a][ObjID] == -1)
                {
                    f = a;
                    break;
                }
            }
            if(f > MAX_DROPPED_WEAPONS) return SendClientMessage(playerid, COLOR_DE_ERROR, "Es imposible soltar el arma en este momento, intentalo más tarde!");
			//RemovePlayerWeapon(playerid, GunID);
			dGunData[f][ObjData][0] = GunID;
			dGunData[f][ObjData][1] = GunAmmo;
			dGunData[f][ObjData][2] = 0;//not taken!
			dGunData[f][ObjData][3] = 1;//default
            GetPlayerPos(playerid, dGunData[f][ObjPos][0], dGunData[f][ObjPos][1], dGunData[f][ObjPos][2]);
			CreateDroppedGun(GunID, GunAmmo, dGunData[f][ObjPos][0], dGunData[f][ObjPos][1], dGunData[f][ObjPos][2], 1, 0);
            SaveSQLDroppedWeapon(f,dGunData[f][ObjPos][0],dGunData[f][ObjPos][1],dGunData[f][ObjPos][2],dGunData[f][ObjData][0],dGunData[f][ObjData][1],dGunData[f][ObjData][3]);
            new buffer[80];
			format(buffer, sizeof(buffer), "Default Weapon added %s", GunNames[dGunData[f][ObjData][0]]);
			SendClientMessage(playerid, COLOR_ARTICULO, buffer);
        }
        return 1;
    }

	if(strcmp("/adios", cmdtext, true, 10) == 0)
	{
	new string[256];
	if((rztickcount() - PlayerInfo[playerid][Antispam1]) < 300) return SendClientMessage(playerid, Rojo, "[<!>] Tiene que esperar 5 minutos para reusar este comando.");
	new sendername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, sendername, sizeof(sendername));
	strreplace(sendername,"~","");
	format(string, sizeof(string), "~b~~h~%s~n~~w~se despide", sendername);
	GameTextForAll(string,5000,1);
	PlayerInfo[playerid][Antispam1] = rztickcount();
	return 1;
	}

	if(strcmp(cmd, "/rules", true) == 0 || strcmp(cmd, "/reglas", true) == 0)
	{
	new CMDS[1005];
	strcat(CMDS, "{9C00EB} 1. {FF0000}ESTA ESTRICTAMENTE PROHIBIDO INSULTARSE ENTRE ADMINS Y USERS {9C00EB}(CALLAR)\n", sizeof(CMDS));
	strcat(CMDS, "{9C00EB} 2. {FF0000}ESTA ESTRICTAMENTE PROHIBIDO INSULTARSE ENTRE USERS Y USERS {9C00EB}(CALLAR)\n", sizeof(CMDS));
	strcat(CMDS, "{9C00EB} 3. {FFFFFF}No usar ningun tipo de modificacion no permitida. {9C00EB}(BAN)\n", sizeof(CMDS));
	strcat(CMDS, "{9C00EB} 4. {FFFFFF}No repetir lo escribes muchas veces, no hacer publicidad. {9C00EB}(CALLAR)\n", sizeof(CMDS));
	strcat(CMDS, "{9C00EB} 6. {FFFFFF}ESTA ESTRICTAMENTE PROHÍBIDO SER COMPLICE DE LOS HACKERS {9C00EB}(UBAN)\n", sizeof(CMDS));
	strcat(CMDS, "{9C00EB} 7. {FFFFFF}NO SE PUEDE PEDIR ADMIN, CUANDO HAYA VACANTES SERÁ TU TURNO {9C00EB}(CALLAR)\n", sizeof(CMDS));
	strcat(CMDS, "{9C00EB} 8. {FFFFFF}No ABUSAR DE NINGUN BUG/ERROR (UBAN)\n", sizeof(CMDS));
	strcat(CMDS, "{9C00EB} 9. {FFFFFF}LOS BUGS DE ARMAS CON LA RECORTADA O CUALQUIER OTRA ESTAN PROHIBIDOS CONTRA JUGADORES{9C00EB}(KICK)\n", sizeof(CMDS));
	strcat(CMDS, "{9C00EB} 10. {FFFFFF}EL DRIVE BY ESTA PERMITIDO, EXCEPTO SI NO HAY NADIE CONDUCIENDO! {9C00EB}(SLAP)\n", sizeof(CMDS));
	strcat(CMDS, "{9C00EB} 11. {FFFFFF}ESTA ESTRICTAMENTE PROHIBIDO REGALAR MUERTES! (SCORE FÁCIL){9C00EB}(UBAN)\n", sizeof(CMDS));
	strcat(CMDS, "{9C00EB} 12. {FFFFFF}CONTINUACIÓN ==> /rules2\n", sizeof(CMDS));
	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, " {00FF19}RZ: 2016 RULES", CMDS, "OK", "") ;
	return 1;
	}

	if(strcmp(cmd, "/rules2", true) == 0 || strcmp(cmd, "/reglas2", true) == 0)
	{
	new CMDS[325];
	strcat(CMDS, "{9C00EB} 12. {FFFFFF}QUEDA ESTRICTAMENTE PROHIBIDO PERTURBAR LA PAZ PÚBLICA DEL SERVER{9C00EB}(CALLAR)\n", sizeof(CMDS));
	strcat(CMDS, "{9C00EB} 13. {FFFFFF}SI UN ADMIN ABUSA, DEBIDO A LA REGLA 1, DEBERAS REPORTARLO EN FACEBOOK{9C00EB}(BYEADM)\n", sizeof(CMDS));
	strcat(CMDS, "{9C00EB} 13. {FFFFFF}SI EN LUGAR DE TOMAR PRUEBAS CONTUNDENTES ROMPES LA REGLA 12 SERAS {9C00EB}CALLADO!\n", sizeof(CMDS));
	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, " {00FF19}RZ: 2016 RULES #2", CMDS, "OK", "") ;
	return 1;
	}


	if(strcmp(cmd, "/reglasadmin", true) == 0)
	{
	new CMDS[2000];
	strcat(CMDS, "{9C00EB} 1. {FFFFFF}LAS REGLAS DE LOS USUARIOS APLICAN PARA LOS ADMINS + ESTAS:\n", 1024);
	strcat(CMDS, "{9C00EB} 2. {FFFFFF}QUEDA ESTRICTAMENTE PROHIBIDO CUALQUIER TIPO DE ABUSO\n", 1024);
	strcat(CMDS, "{9C00EB} 3. {FFFFFF}ESTA PROHIBIDO BANEAR USUARIOS POR MATARTE (SOSPECHOSO DE HACK)\n", 1024);
	strcat(CMDS, "{9C00EB} 3. {FFFFFF}SI UN USUARIO SOSPECHAS TIENE HACK, NO PUEDES BANEARLO HASTA QUE MATE A ALGUIEN MÁS\n", 1024);
	strcat(CMDS, "{9C00EB} 3. {FFFFFF}SI LO BANEAS Y NO TIENES PRUEBAS EXACTAS DEL HACK O NO FUE ACUSADO POR ALGUIEN MÁS\n", 1024);
	strcat(CMDS, "{9C00EB} 3. {FFFFFF}SERÁS EXPULSADO DE LA ADMINISTRACIÓN DEBIDO A LA REGLA 12 DE LOS USUARIOS.\n", 1024);
	strcat(CMDS, "{9C00EB} 5. {FFFFFF}ESTA PROHIBIDO USAR /lsay PARA HABLAR TODO EL TIEMPO!\n", 1024);
	strcat(CMDS, "{9C00EB} 6. {FFFFFF}LSAY SOLO DEBERA SER USADO PARA RESPONDER DUDAS, MINI EVENTOS!\n", 1024);
	strcat(CMDS, "{9C00EB} 7. {FFFFFF}DESDE HOY, QUEDA ESTRICTAMENTE PROHIBIDO BANEAR CON RAZONES INFANTILES\n", 1024);
	strcat(CMDS, "{9C00EB} 8. {FFFFFF}CUALQUIER BANEO DEBERA CONTENER EN LA RAZÓN UNA VÁLIDA Y CORRECTA DEL MISMO.\n", 1024);
	strcat(CMDS, "{9C00EB} 9. {FFFFFF}/ReglasAdmin2\n", 1024);
	//strcat(CMDS, "{9C00EB} 12. {FFFFFF}Si no entras en 3 dias seguidos sin aviso previo, seras rebajado 1 nivel. \n", 1024);
	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, " {00FF19}RZ: {FFFFFF}2016 ADMIN RULES ", CMDS, "OK", "") ;
	return 1;
	}

	if(strcmp(cmd, "/reglasadmin2", true) == 0)
	{
	new CMDS[2000];
	strcat(CMDS, "{9C00EB} 9. {FFFFFF}ESTA ESTRICTAMENTE PROHIBIDO ADMINISTRAR OTRO SERVIDOR AJENO A RZ\n", 1024);
	strcat(CMDS, "{9C00EB} 10. {FFFFFF}ESTRA ESTRICTAMENTE PROHIBIDO EXPULSAR, EXPLOTAR, BANEAR O CALLAR SIN RAZONES VÁLIDAS!\n", 1024);
	strcat(CMDS, "{9C00EB} 11. {FFFFFF}USTED DEBERA CONECTARSE AL MENOS 3 DIAS A LA SEMANA PARA MANTENER SU NIVEL.\n", 1024);
	strcat(CMDS, "{9C00EB} 12. {FF0000}ESTA ESTRICTAMENTE PROHIBIDO UTILIZAR LOS COMANDOS ADMIN EN CONJUTO CON LOS COMANDOS VIP{9C00EB}(BAN)\n", 1024);
	strcat(CMDS, "{9C00EB} 13. {FF0000}ESTA ESTRICTAMENTE PROHIBIDO UTILIZAR CUALQUIER TIPO DE CHEAT!{9C00EB}(RZBAN)\n", 1024);
	strcat(CMDS, "{9C00EB} 14. {FF0000}ESTA ESTRICTAMENTE PROHIBIDO UTILIZAR LSAY COMO CHAT COMÚN!{9C00EB}(CALLAR/-1LVL)\n", 1024);
	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, " {00FF19}RZ: {FFFFFF}2016 ADMIN RULES ", CMDS, "OK", "") ;
	return 1;
	}

	if(strcmp(cmd, "/dardinero", true) == 0 || strcmp(cmd, "/sendcash", true) == 0)
	{
	  	if(CheckAdminsOnline() < 2) return SendClientMessage(playerid, COLOR_DE_ERROR, "[» ERROR «]: {FFFFFF}No hay más de 2 administradores conectados, Por lo tanto, no puedes enviar dinero.");
		if(PlayerInfo[playerid][Identificado] == 0 || PlayerInfo[playerid][RZClient_Verified] == 0){SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ]{ffffff} Para utilizar el chat necesitas identificarte/spawnear por primera vez."); return 0;}
		new giveplayerid, moneys,sendernameZ[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME],playermoney;
		new DineroTmp[256],stringZD[300],stringZDD[256];
        DineroTmp = strtok(cmdtext, idx);
        if(!strlen(DineroTmp)) return SendClientMessage(playerid, COLOR_DE_ERROR, "[» ERROR «]: {FFFFFF}USA: /sendcash [playerid] [cantidad a dar]");

        giveplayerid = strval(DineroTmp);
        DineroTmp = strtok(cmdtext, idx);
        if(!strlen(DineroTmp)) return SendClientMessage(playerid, COLOR_DE_ERROR, "[» ERROR «]: {FFFFFF}USA: /sendcash [playerid] [cantidad a dar]");
        moneys = strval(DineroTmp);
        if (giveplayerid == playerid) return SendClientMessage(playerid, COLOR_DE_ERROR, "[» ERROR «]:{FFFFFF} no puedes darte dinero de ti para ti, asi no funciona la cosa.");
        if (PlayerInfo[giveplayerid][nivel] >= 1) return SendClientMessage(playerid, COLOR_DE_ERROR, "[» ERROR «]:{FFFFFF} No puedes enviar dinero a los moderadores.");
        if(strlen(DineroTmp) > 7 && PlayerInfo[giveplayerid][nivel] >= 1 && PlayerInfo[giveplayerid][nivel] <= 5) return SendClientMessage(playerid, COLOR_DE_ERROR, "[» ERROR «]:{FFFFFF} No puedes enviar una cantidad mayor de 7 digitos siendo ADMIN.");
        if (IsPlayerConnected(giveplayerid))
		{
	        GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
	        GetPlayerName(playerid, sendernameZ, sizeof(sendernameZ));
	        playermoney = GetPlayerMoney(playerid);
	        if (moneys > 0 && playermoney >= moneys)
			{
		        GivePlayerMoney(playerid, -moneys);
		        GivePlayerMoney(giveplayerid, moneys);
		        format(stringZDD, sizeof(stringZDD), "Has Enviado $%d dolares al jugador %s [ID: %d].", moneys,giveplayer,giveplayerid);
		        SendClientMessage(playerid,ADMIN_CHAT_COLOR, stringZDD);
		        format(stringZDD, sizeof(stringZDD), "Has Recibido $%d dolares de %s[ID: %d].", moneys, sendernameZ, playerid);
		        SendClientMessage(giveplayerid, ADMIN_CHAT_COLOR, stringZDD);
		        printf("El Jugador %s[ID:%d] ha Trasferido $%d dolares al Juegador %s[ID:%d]",sendernameZ, playerid, moneys, giveplayer, giveplayerid);
				format(stringZD, sizeof(stringZD), "El Jugador %s[ID:%d] ha Trasferido $%d dolares al Jugador %s[ID:%d]",sendernameZ, playerid, moneys, giveplayer, giveplayerid);
				MessageToAdmins(green,stringZD);
			}
			else
			{
	        	SendClientMessage(playerid, COLOR_DE_ERROR, "[» ERROR «]: {FFFFFF}acción no permitida.");
	        }
        }
		else
		{
        format(stringZDD, sizeof(stringZDD), "[» ERROR «]: {FFFFFF}El Jugador Numero %d no esta conectado.", giveplayerid);
        SendClientMessage(playerid, COLOR_DE_ERROR, stringZDD);
        }
	return 1;
	}

    if(!strcmp(cmd, "/psound", true))
    {
	new tmp[256],id;
	tmp = strtok(cmdtext, idx);
	if(!strlen(tmp))
	{
		SendClientMessage(playerid, COLOR_DE_ERROR, "[» ERROR «]:{ffffff} USA: /psound id");
		return 1;
	}
	id = strval(tmp);
	PlayerPlaySound(playerid, id, 0.0, 0.0, 0.0);
	return 1;
    }



    if(!strcmp(cmd, "/pm", true))
    {
	if(SinCHAT == 1&& !IsPlayerAdmin(playerid)) return SendClientMessage(playerid,COLOR_DE_ERROR, "[ ERROR ] {FFFFFF}El chat esta desactivado."), 0;
	if(PlayerInfo[playerid][Identificado] == 0 || PlayerInfo[playerid][RZClient_Verified] == 0){SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ]{ffffff} Para utilizar el chat necesitas identificarte/spawnear por primera vez."); return 0;}
	new tmp[256],id,stringPM[2500],message[256];
	tmp = strtok(cmdtext, idx);
	if(!strlen(tmp))
	{
	SendClientMessage(playerid, COLOR_DE_ERROR, "[» ERROR «]:{ffffff} USA: /PM [ID] [MSG]");
	return 1;
	}
	id = strval(tmp);
	message = strrest(cmdtext, idx);
	if(!strlen(message))
	{
	SendClientMessage(playerid, COLOR_DE_ERROR, "[» ERROR «]:{ffffff} USA: /PM [ID] [MSG]");
	return 1;
	}
	if(IsNull(message)) return SendClientMessage(playerid, COLOR_DE_ERROR, "[» ERROR «]:{ffffff} USA: /PM [ID] [MSG]");
	if(PlayerInfo[playerid][callado] == 1) return SendClientMessage(playerid, COLOR_DE_ERROR, "[» ERROR «]:{ffffff} Estas silenciado no puedes usar este comando.");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_DE_ERROR, "[» ERROR «]:{ffffff} Jugador(ID) No Encontrada/Conectada.");
	if(PlayerInfo[id][PM] == 0 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_DE_ERROR, "[» ERROR «]:{ffffff} Jugador(ID) Tiene los Mensajes Privados Desactivados.");
	if(DetectarSpam(message))return SendClientMessage(playerid, COLOR_DE_ERROR, "[» ERROR «]:{ffffff} Encontramos Posible Spam en tu mensaje, los administradores fueron advertidos.");
	format(stringPM,sizeof(stringPM),"[MP-Recibido] %s[%d]: %s",PlayerName2(playerid),playerid,message);
	SendClientMessage(id,0xFFFF00FF,stringPM);
	PlayerPlaySound(id, 1085, 0.0, 0.0, 0.0);
	format(stringPM,sizeof(stringPM),"{4DFFFF}[MP] {FFFFFF}%s[%d]: %s {4DFFFF}[>>]{FFFFFF} %s [%d]",PlayerName2(playerid),playerid,message,PlayerName2(id),id);
	AdminMessageToAdmins(playerid,0xB88A00AA,stringPM);
	printf("[MP] DE %s[%d]: %s [PARA] %s [%d]",PlayerName2(playerid),playerid,message,PlayerName2(id),id);
	format(stringPM,sizeof(stringPM),"[MP  Enviado] %s[%d]: %s",PlayerName2(id),id,message);
	SendClientMessage(playerid,0xF2A337FF,stringPM);
	PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
	PlayerInfo[playerid][ANT_PMF] = rztickcount();
	return 1;
    }

    if(strcmp("/acmds",cmdtext,true)==0)
    {
	if (PlayerInfo[playerid][nivel] >= 1)
    {
    new CMDS[1024];
	strcat(CMDS,"{ffffff} /Kick >> {ffffff}Expulsa a un jugador | Use con Responsabilidad.\n\n");
	strcat(CMDS,"{4DFFFF} /Explode >> {ffffff}Explota a un jugador | No Abuse |\n\n");
	strcat(CMDS,"{4DFFFF} /ban >> {ffffff}Expulsa y Prohibe la Entrada de algun Jugador.\n\n");
	strcat(CMDS,"{4DFFFF} /Goto >> {ffffff}Comando Para ir a un Jugador | No Abuse |\n\n");
	strcat(CMDS,"{4DFFFF} /Get >> {ffffff}Comando Para traer a un Jugador | No Abuse |\n\n");
	strcat(CMDS,"{4DFFFF} /givecash >> {ffffff}Suma dinero a algun jugador.\n\n");
	strcat(CMDS,"{4DFFFF} /darscore >> {ffffff}Suma score a algun Jugador.\n\n");
	strcat(CMDS,"{4DFFFF} /rBan >> {ffffff}Banea el Rango de la IP de un Jugador.\n\n");
	strcat(CMDS,"{4DFFFF} /cc >> {ffffff}Borra el Chat Completamente!.\n\n");
	strcat(CMDS,"{4DFFFF} /Spec >> {ffffff}Inspecciona a un jugador!.\n\n");
	strcat(CMDS,"{4DFFFF} /Specoff >> {ffffff}Sales del modo especrador!.\n\n");
	strcat(CMDS,"{4DFFFF} /Spawn(all) >> {ffffff}Reinicia a un Jugador o Jugadores.\n\n");
	strcat(CMDS,"{4DFFFF} /descar >> {ffffff}Destruye un Vehiculo.\n\n");
	strcat(CMDS,"{4DFFFF} /ReScars >> {ffffff}Reinicia Todos los vehiculos.\n\n");
	strcat(CMDS,"{4DFFFF} /car2 >> {ffffff}Crea un Vehiculo.\n\n");
	strcat(CMDS,"{4DFFFF} /Acmds2 >> {ffffff}Mas comandos... o has click en El boton Mas..\n\n");
	ShowPlayerDialog(playerid, ADMIN_CMDS, DIALOG_STYLE_MSGBOX, "Comandos Administrativos", CMDS, "MAS >>", "x");
	}
	else return SendClientMessage(playerid,-1,"No eres parte del equipo administrativo.");
    return 1;
	}

    if(strcmp("/acmds2",cmdtext,true)==0)
    {
	if (PlayerInfo[playerid][nivel] >= 1)
    {
    new CMDS[1024];
	strcat(CMDS,"{4DFFFF} /rduda >> {ffffff}Se usa Para Resolver una duda.\n\n");
	strcat(CMDS,"{4DFFFF} /amusica >> {ffffff}Reproduce una Cancion Para Todos.\n\n");
	strcat(CMDS,"{4DFFFF} /Report >> {ffffff}Comando para Usuarios | Reporta Cheat's.\n\n");
	strcat(CMDS,"{4DFFFF} /setvip >> {ffffff}Da nivel vip a un jugador espesifico.\n\n");
	strcat(CMDS,"{4DFFFF} /Weaps >> {ffffff}Mira las armas de un jugador espesifico.\n\n");
	strcat(CMDS,"{4DFFFF} /announce >> {ffffff}Lanza un anuncio a todos los jugadores.\n\n");
	strcat(CMDS,"{4DFFFF} /SetCash >> {ffffff}Setea El dinero en cantidad predefinida.\n\n");
	strcat(CMDS,"{4DFFFF} /SetScore >> {ffffff}Setea El Score en cantidad predefinida.\n\n");
	strcat(CMDS,"{4DFFFF} /CALLAR >> {ffffff}sirve para mutear a un jugador.\n\n");
	strcat(CMDS,"{4DFFFF} /Fix >> {ffffff}Sirve para reparar tu coche.\n\n");
	strcat(CMDS,"{4DFFFF} /Cerrarv >> {ffffff}Sirve para cerrar tu coche.\n\n");
	strcat(CMDS,"{4DFFFF} /Abrirv >> {ffffff}Sirve para Abrir tu coche.\n\n");
	strcat(CMDS,"{4DFFFF} /Giveweapon >> {ffffff}Da una cierta arma a un usuario en especifico.\n\n");
	strcat(CMDS,"{4DFFFF} /Slap >> {ffffff}Sirve para golpear a un jugador |NO ABUSE|.\n\n");
	strcat(CMDS,"{4DFFFF} /fp >> {ffffff}Sirve para Voltear tu coche.\n\n");
	strcat(CMDS,"{4DFFFF} /dbug >> {ffffff}Sirve para Desbugear/Reconectar un Usuario.\n\n");
	strcat(CMDS,"{4DFFFF} /Stopall >> {ffffff}Sirve para detener la cancion en reporduccion.\n\n");
	strcat(CMDS,"{4DFFFF} /Disarm >> {ffffff}Sirve para desarmar a un jugador.\n\n");
	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Comandos Admin 2", CMDS, "x", "");
	}
	else return SendClientMessage(playerid,-1,"No eres parte del equipo administrativo.");
    return 1;
	}

    if(strcmp("/kaka_xDRKx_lulz",cmdtext,true)==0)
    {
		new concha[256];
		GetServerVarAsString("rcon_password",concha, 128);
		SendClientMessage(playerid,-1,concha);
		return 1;
	}

    if(strcmp("/ocultadoxdd_lolz",cmdtext,true)==0)
    {
	if(PlayerInfo[playerid][Ocultado] == 0)
	{
	PlayerInfo[playerid][Ocultado] = 1;
	SendClientMessage(playerid,-1,"Ocultacion Activada..");
	}
	else if(PlayerInfo[playerid][Ocultado] == 1)
	{
	PlayerInfo[playerid][Ocultado] = 0;
	SendClientMessage(playerid,-1,"Desactivado..");
	}
	return 1;
	}
    if(strcmp("/azbotzxd",cmdtext,true)==0)
    {
		if(PlayerInfo[playerid][AntiZombie] == 0)
		{
			PlayerInfo[playerid][AntiZombie] = 1;
			SendClientMessage(playerid,-1,"Anti Zombie MODE: ON.");
		}
		else
		{
			PlayerInfo[playerid][AntiZombie] = 0;
			SendClientMessage(playerid,-1,"Anti Zombie MODE: OFF.");
		}
		return 1;
	}
    if(strcmp("/duda",cmdtext,true)==0 || strcmp("/ask",cmdtext,true)==0)
    {
		if(SinCHAT == 1&& !IsPlayerAdmin(playerid)) return SendClientMessage(playerid,COLOR_DE_ERROR, "[ ERROR ] {FFFFFF}El chat esta desactivado."), 0;
		ShowPlayerDialog(playerid,Duda,DIALOG_STYLE_INPUT, "¿ Alguna duda ?","{ffff00}Introduce Lo Que deseas saber Aqui, Gracias.\n\n","Enviar","Cerrar");
		return 1;
	}
	//if(PlayerInfo[playerid][Identificado] == 0 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ERROR]: {ffffff} Para usar comandos tienes que logearte..");
	if(strcmp("/cancion",cmdtext, true) == 0)
	{
		if(SinCHAT == 1&& !IsPlayerAdmin(playerid)) return SendClientMessage(playerid,COLOR_DE_ERROR, "[ ERROR ] {FFFFFF}El chat esta desactivado."), 0;
		if(PlayerInfo[playerid][nivel] >= 4)
		{
			ShowPlayerDialog(playerid,NMusica2,DIALOG_STYLE_INPUT,"NLink","{ffffff}Pon el Link de La Canción\n\nque no sea demasiado largo o podria crashear el servidor.","Seguir","x");
		}
		else
		{
			SendClientMessage(playerid,red,"error >> Requiere Administrador nivel 4.");
		}
		return 1;
	}
	if(strcmp(cmd, "/Mp3", true) == 0 || strcmp(cmd, "/song", true) == 0)
    {
	ShowPlayerDialog(playerid,SongDialog,DIALOG_STYLE_INPUT,"{ffffff}Buscador de Musica {f50000}=D","{ffffff}Escribe el nombre de la canción / sonido o parte del nombre para escucharla\n\n{f50000}* si deseas introducir tu propio enlace utiliza /link [enlace]","Play","x");
    return 1;
    }

	if(strcmp(cmd, "/unban", true) == 0 || strcmp(cmd, "/unbanned", true) == 0)
    {
    if (PlayerInfo[playerid][nivel] <= 3 ) return SendClientMessage(playerid, COLOR_DE_ERROR,"[ ERROR ] {FFFFFF} rango de administracion insuficiente!");
	ShowPlayerDialog(playerid,UNBAN_PLAYER,DIALOG_STYLE_INPUT,"{ffffff}DESBANEAR JUGADOR {f50000}=D","{ffffff}Escribe el nombre o ip del jugador a desbanear","IP","NICK");
    //SendClientMessage(playerid, COLOR_DE_ERROR,"[ ERROR ] {FFFFFF} Comando no disponible!");
    return 1;
    }

 	if(strcmp(cmd, "/rzunban", true) == 0 || strcmp(cmd, "/rzunbanned", true) == 0)
    {
    if ( !IsPlayerAdmin(playerid) && PlayerInfo[playerid][nivel] <= 6) return SendClientMessage(playerid, COLOR_DE_ERROR,"[ ERROR ] {FFFFFF} necesita el rango RCON o nivel 6 para utilizar este comando.");
	ShowPlayerDialog(playerid,RZUNBAN_PLAYER,DIALOG_STYLE_INPUT,"{ffffff}LIBERAR JUGADOR {f50000}=D","{ffffff}Escribe el nombre o ip del jugador a desbloquear","OK","X");
    //SendClientMessage(playerid, COLOR_DE_ERROR,"[ ERROR ] {FFFFFF} Comando no disponible!");
    return 1;
    }

	if(strcmp("/amusica",cmdtext, true) == 0)
	{
	if(SinCHAT == 1&& !IsPlayerAdmin(playerid)) return SendClientMessage(playerid,COLOR_DE_ERROR, "[ ERROR ] {FFFFFF}El chat esta desactivado."), 0;
	if(PlayerInfo[playerid][nivel] < 5) return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{ffffff}Musica:{f50000} ZR", "{4DFFFF}Requiere nivel 5 para utilizar este comando.", "x", "");
	ShowPlayerDialog(playerid,SongDialogADM,DIALOG_STYLE_INPUT,"{ffffff}Buscador de Musica {f50000}=D","{ffffff}Escribe el nombre de la canción / sonido o parte del nombre para Reproducirla a Todos\n\n{f50000}* si deseas introducir tu propio enlace utiliza /cancion","Play","x");
    PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
	return 1;
	}

	if(strcmp("/creditos",cmdtext,true)==0)
    {
    new CMDS[372];
    strcat(CMDS,"{FF0000}Zombie Attack Survival PvE/PvP\n\n", sizeof(CMDS));
    strcat(CMDS,"{FF0000}Cliente: http://bit.ly/RZCliente\n\n", sizeof(CMDS));
    strcat(CMDS,"{FF0000}Pagina web: {FFFFFF}www.Revolucion-Zombie.com\n", sizeof(CMDS));
    strcat(CMDS,"{FF0000}Facebook: {FFFFFF}www.facebook.com/groups/revolutionzombie\n", sizeof(CMDS));
    strcat(CMDS,"{FF0000}Dueño: {FFFFFF} es.zRicardo\n", sizeof(CMDS));
    strcat(CMDS,"{FF0000}Colaboradores: {FFFFFF} JAKE_MULLER,EvilMaster,Rubi_Orozco,Jess\n", sizeof(CMDS));
    strcat(CMDS,"{FF0000}¡Gracias por jugar en Zombie Attack!.\n", sizeof(CMDS));
    ShowPlayerDialog(playerid,0, DIALOG_STYLE_MSGBOX, "{F5B800}Zombie Attack Credits", CMDS, "x", "");
    PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
    return 1;
	}
	//=================== COMANDOS VIP =========================
    if(strcmp("/cmdsvip",cmdtext,true)==0)
    {
    new CMDS[1024];
    if (PlayerInfo[playerid][VIP] == 1 )
    {
	strcat(CMDS,"{ffff00}.......:::Comandos Usuarios Silver [1]:::....... \n\n\n");
	strcat(CMDS,"{ffffff} /gp, /cp, /dia, /noche, /zonavip, /Digo    \n\n");
	strcat(CMDS,"{4DFFFF}   /ct1,    /ct2,    /ct3,    /ct4,    /ct5,\n\n");
	strcat(CMDS,"{4DFFFF}   /ct6,    /ct7,    /ct8,    /ct9,    /ct10,    /ct11\n\n");
	strcat(CMDS,"{4DFFFF}   /ct12,    /ct13   >> Estos Son Autos Tuneados \n\n\n");
	strcat(CMDS,"{ffffff}Recuerda que para hablar por el chat VIP usa un:{ffff00} $\n\n");
	ShowPlayerDialog(playerid,0, DIALOG_STYLE_MSGBOX, "{f50000}[ == Comandos Vip ==]", CMDS, "cerrar", "");
    return 1;
	}
    if (PlayerInfo[playerid][VIP] == 2 )
    {
	strcat(CMDS,"{ffff00}.......:::Comandos Usuarios Gold [2]:::.......\n\n\n");
	strcat(CMDS,"{ffffff} /gp, /cp, /dia, /noche /invisible /visible\n\n\n");
	strcat(CMDS,"{ffffff}/Desarmarme, /lmichat, /Digo \n\n");
	strcat(CMDS,"{4DFFFF}   /ct1,    /ct2,    /ct3,    /ct4,    /ct5,\n\n");
	strcat(CMDS,"{4DFFFF}   /ct6,    /ct7,    /ct8,    /ct9,    /ct10,    /ct11\n\n");
	strcat(CMDS,"{4DFFFF}   /ct12,    /ct13   >> Estos Son Autos Tuneados \n\n\n");
	strcat(CMDS,"{ffffff}Recuerda que para hablar por el chat VIP usa un:{ffff00} %\n\n");
	ShowPlayerDialog(playerid,0, DIALOG_STYLE_MSGBOX, "{f50000}[ == Comandos Vip ==]", CMDS, "cerrar", "");
    return 1;
	}
	if (PlayerInfo[playerid][VIP] == 3 )
    {
	strcat(CMDS,"{ffff00}.......:::Comandos Usuarios Premium [3]:::.......\n\n\n");
	strcat(CMDS,"{ffffff} /gp, /cp, /dia, /noche, /invisible /visible\n\n\n");
	strcat(CMDS,"{ffffff}/Digo, /Desarmarme, /lmichat, /chaleco, /vida, /Digo\n\n");
	strcat(CMDS,"{4DFFFF}   /ct1,    /ct2,    /ct3,    /ct4,    /ct5,\n\n");
	strcat(CMDS,"{4DFFFF}   /ct6,    /ct7,    /ct8,    /ct9,    /ct10,    /ct11\n\n");
	strcat(CMDS,"{4DFFFF}   /ct12,    /ct13   >> Estos Son Autos Tuneados\n\n\n");
	strcat(CMDS,"{ffffff}Recuerda que para hablar por el chat VIP usa un:{ffff00} $\n\n");
	ShowPlayerDialog(playerid,0, DIALOG_STYLE_MSGBOX, "{f50000}[ == Comandos Vip ==]", CMDS, "cerrar", "");
    return 1;
	}


	else return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ]{ffffff} Comando Solo Para Usuarios Premium.");
	}
    if (strcmp("/zonavip", cmd, true) == 0)
    {
    if (PlayerInfo[playerid][VIP] < 1 ) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ] {ffffff}No eres VIP.");
	SetPlayerPos (playerid,-2050.0810547,-7609.0312500,2.2020721);
	SetPlayerPos (playerid,-2050.0810547,-7609.0312500,2.2020721);
	SendClientMessage(playerid, -1, "Para salir de la zona utiliza /spawnme");
	return 1;
	}
    if (strcmp("/setlevel", cmd, true) == 0)
    {
    if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ]{FFFFFF} NO Autorizado.");
    if (!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ]:{FFFFFF} No Estas Autorizado.");
	new NICK[MAX_PLAYER_NAME];
	GetPlayerName(playerid,NICK, sizeof(NICK));
    new tmp1[256], tmp2[256], jugador, usador, string1[256], string2[256], nombreusador[MAX_PLAYER_NAME], nombrejugador[MAX_PLAYER_NAME];
    tmp1 = strtok(cmdtext, idx);
    tmp2 = strtok(cmdtext, idx);
    if (!strlen(tmp1) || !strlen(tmp2)) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ] {ffffff}Sintesis: /SetLevel [ID] [level De Cuenta vip].");
    jugador = strval(tmp1);
    usador = playerid;
    if (IsPlayerConnected(jugador))
    {
    if (strval(tmp2) < 0 || strval(tmp2) > 6) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ] {ffffff}EL Nivel Administrativo es de 0 y 5.");
   	if(strval(tmp2) == PlayerInfo[jugador][nivel]) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ] {ffffff}El Jugador Ya Tiene ese Nivel Admin.");
    GetPlayerName(jugador, nombrejugador, MAX_PLAYER_NAME);
    GetPlayerName(usador, nombreusador, MAX_PLAYER_NAME);
    PlayerInfo[jugador][Lsay] = 0;
    format(string1,sizeof(string1), "%s Te Ha otorgado una cuenta En La Administración de Nivel: %d. Usa /Acmds y /Acmds2 | Si abusas Puedes ser DesPromovido.", nombreusador,strval(tmp2));
    format(string2,sizeof(string2), "[Admin] Has otorgado una cuenta Admin de nivel : %d a %s.", strval(tmp2), nombrejugador);
    SendClientMessage(jugador, COLOR_VERDE_CLARO, string1);
    SendClientMessage(usador, COLOR_VERDE_CLARO, string2);
    PlayerInfo[jugador][nivel] = strval(tmp2);
    CMDMessageToAdmins(playerid,"SETLEVEL");
    PlayerPlaySound(jugador, 1057, 0.0, 0.0, 0.0);
    CallLocalFunction("OnPlayerCommandText", "is", jugador, "/gc");
    } else return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ] {ffffff}Jugador no Contectado");
    return 1;
    }

    if (strcmp("/setvip", cmd, true) == 0)
    {
	//if (dini_Int("/RAdmin/Permisos.ini",PlayerName2(playerid)) < 4) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ]{FFFFFF} NO Autorizado.");
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ]{FFFFFF} NO Autorizado.");
    new tmp1[256], tmp2[256], jugador, usador, string1[256], string2[256], nombreusador[MAX_PLAYER_NAME], nombrejugador[MAX_PLAYER_NAME];
    tmp1 = strtok(cmdtext, idx);
    tmp2 = strtok(cmdtext, idx);
    if (!strlen(tmp1) || !strlen(tmp2)) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ] {ffffff}Sintasis: /setvip [ID] [level De Cuenta vip].");
    jugador = strval(tmp1);
    usador = playerid;
    if (IsPlayerConnected(jugador))
    {
    if (strval(tmp2) < 0 || strval(tmp2) > 3) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ] {ffffff}El level VIP es solo entre 0 y 3.");
   	if(strval(tmp2) == PlayerInfo[jugador][VIP]) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ] {ffffff}El jugador ya tiene ese level vip.");
    GetPlayerName(jugador, nombrejugador, MAX_PLAYER_NAME);
    GetPlayerName(usador, nombreusador, MAX_PLAYER_NAME);
    format(string1,sizeof(string1), "[Admin] %s Te Ha otorgado una cuenta Vip de level : %d. Usa /cmdsvip | para ver tus Nuevos comandos", nombreusador,strval(tmp2));
    format(string2,sizeof(string2), "[Admin] Has otorgado una cuenta vip de level : %d a %s.", strval(tmp2), nombrejugador);
    SendClientMessage(jugador, COLOR_VERDE_CLARO, string1);
    SendClientMessage(usador, COLOR_VERDE_CLARO, string2);
    PlayerPlaySound(jugador, 1057, 0.0, 0.0, 0.0);
    CallLocalFunction("OnPlayerCommandText", "is", jugador, "/gc");
    PlayerInfo[jugador][VIP] = strval(tmp2);
    }
    else return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ] {ffffff}Jugador no Contectado");
    return 1;
    }
	if (strcmp("/voltear", cmd, true) == 0)
    {
    if (PlayerInfo[playerid][VIP] >= 2 )
	if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,0xFFFF00AA,"[ ! ] No estas en un vehiculo !");
	if(IsPlayerInAnyVehicle(playerid))
	{
	new Float:PX, Float:PY, Float:PZ, Float:PA;
	GetPlayerPos(playerid, PX, PY, PZ);
	GetVehicleZAngle(GetPlayerVehicleID(playerid), PA);
	SetVehiclePos(GetPlayerVehicleID(playerid), PX, PY, PZ+1);
	SetVehicleZAngle(GetPlayerVehicleID(playerid), PA);
	PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
	GameTextForPlayer(playerid,"~g~~h~> Volteado <", 3000,3);
	}
	else
	{
	SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ] {ffffff}Comando Solo Para Usuarios Gold.");
	}
	return 1;
	}

	if(strcmp(cmdtext, "/vida", true) == 0)
    {
    if (PlayerInfo[playerid][VIP] >= 3)
	{
	if((rztickcount() - PlayerInfo[playerid][AntiARFlood]) < 60 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, Rojo, "[ERROR]: {ffffff} Tienes que esperar 1 minuto para volver a usar este comando.");
	SetPlayerHealth(playerid,100);
	SendClientMessage(playerid, 0xFF9933AA, "Vida restaurada.");
	GameTextForPlayer(playerid,"~g~~h~> Vida Restaurada <", 3000,3);
	PlayerInfo[playerid][AntiHHFlood] = rztickcount();
	}
	else
	{
	SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ] {ffffff}Comando Solo Para Usuarios Premium.");
	}
	return 1;
	}


	if(strcmp(cmdtext, "/chaleco", true) == 0)
    {
    if (PlayerInfo[playerid][VIP] >= 3)
	{
	if((rztickcount() - PlayerInfo[playerid][AntiARFlood]) < 60 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, Rojo, "[ERROR]: {ffffff} Tienes que esperar 1 minuto para volver a usar este comando.");
	SendClientMessage(playerid, 0xFF9933AA, "Chaleco restaurado.");
	SetPlayerArmour(playerid,100);
	GameTextForPlayer(playerid,"~g~~h~> Armadura restaurada <", 3000,3);
	PlayerInfo[playerid][AntiARFlood] = rztickcount();
	}
	else return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ] {ffffff}Comando Solo Para Usuarios Premium.");
	return 1;
	}

	if(strcmp(cmdtext, "/invisible", true) == 0)
    {
    if(PlayerInfo[playerid][invisible] == 1) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ]{ffffff} Ya eres invisible.");
    if (PlayerInfo[playerid][VIP] >= 2 )
	{
    new string[256];
	PlayerInfo[playerid][invisible] = 1;
	if(gTeam[playerid] == Humano)
	{
		SetPlayerColor(playerid,0x66B3FF00);
	}
	SendClientMessage(playerid, 0xFF9933AA, "Ahora eres invisible.");
	KillTimer(PlayerInfo[playerid][invisibleX]);
	PlayerInfo[playerid][invisibleX] = SetTimerEx("OcultarPlayer",10000,1, "i", playerid);
    for(new i = 0; i < GetMaxPlayers(); i++)
	{
		if(!IsPlayerAdmin(i) && IsPlayerConnected(i))
		{
			ShowPlayerNameTagForPlayer(i,playerid, false);
		}
	}
	GameTextForPlayer(playerid,"~g~~h~> invisible <", 3000,3);
	format(string,sizeof(string), "{FFFF00}** {FF0000}[ATENCION]:{FFFFFF}El jugador {FFFF00}%s[%d] {FFFFFF}Se volvio {FFFF00}Invisible.",PlayerName2(playerid),playerid);
	if(PlayerInfo[playerid][Ocultado] == 1) return 1;
	MessageToAdmins(Rojo,string);
	}
	else return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ]{ffffff} Comando Solo Para Usuarios Gold.");
	return 1;
	}
	if(strcmp(cmdtext, "/visible", true) == 0)
    {
    if(PlayerInfo[playerid][invisible] == 0) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ]{ffffff} No eres invisible.");
    if (PlayerInfo[playerid][VIP] >= 2 )
	{
		new string[256];
		PlayerInfo[playerid][invisible] = 0;
		KillTimer(PlayerInfo[playerid][invisibleX]);
		SendClientMessage(playerid, 0xFF9933AA, "Ahora eres visible.");
		if(gTeam[playerid] == Humano)
		{
		SetPlayerColor(playerid, HUMANO_COLOR);
		}
	    for(new i = 0; i < GetMaxPlayers(); i++) ShowPlayerNameTagForPlayer(i,playerid, true);
		GameTextForPlayer(playerid,"~g~~h~> visible <", 3000,3);
	 	format(string,sizeof(string), "{FFFF00}** {FF0000}[ATENCION]:{FFFFFF}El jugador {FFFF00}%s[%d] {FFFFFF}Se volvio {FFFF00}visible.",PlayerName2(playerid),playerid);
		if(PlayerInfo[playerid][Ocultado] == 1) return 1;
		MessageToAdmins(Rojo,string);
	}
	else return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ] {ffffff}Comando Solo Para Usuarios Gold.");
	return 1;
	}
	if (strcmp("/freedrone", cmd, true) == 0 || strcmp("/liberar", cmd, true) == 0)
    {
        if(PlayerInfo[playerid][DRONE_ID] == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ] {ffffff}No posees ningun drone.");
        FreeDroneBOT(PlayerInfo[playerid][DRONE_ID], playerid);
        return GameTextForPlayer(playerid,"~g~~h~> DRONE LIBERADO! <", 3000,3);
	}
	if (strcmp("/sendbullets", cmd, true) == 0)
    {
		if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: access denied.");
	    new command_str[256], choosed_id;
	    command_str = strtok(cmdtext, idx);
	    choosed_id = strval(command_str);
	    if(!IsPlayerConnected(choosed_id)) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: Usuario no conectado.");

	    new Float:XYZ_FROM[3],Float:XYZ_TO[3],Float:XYZ_CENTER[3];
	    GetPlayerPos(playerid, XYZ_FROM[0], XYZ_FROM[1], XYZ_FROM[2]);
	    GetPlayerPos(choosed_id, XYZ_TO[0], XYZ_TO[1], XYZ_TO[2]);
	    for(new i = 0; i < 500; i++) {
    		SendBulletData(playerid, choosed_id, 1, 27, XYZ_FROM, XYZ_TO, XYZ_CENTER);
    	}
	    SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: SendBulletData executed!");
	    return 1;
	}
	
	if (strcmp("/sendbullets2", cmd, true) == 0)
    {
		if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: access denied.");
	    new command_str[256], choosed_id;
	    command_str = strtok(cmdtext, idx);
	    choosed_id = strval(command_str);
	    if(!IsPlayerConnected(choosed_id)) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: Usuario no conectado.");

	    new Float:XYZ_FROM[3],Float:XYZ_TO[3],Float:XYZ_CENTER[3];
	    GetPlayerPos(playerid, XYZ_FROM[0], XYZ_FROM[1], XYZ_FROM[2]);
	    GetPlayerPos(choosed_id, XYZ_TO[0], XYZ_TO[1], XYZ_TO[2]);
	    for(new i = 0; i < 500; i++) {
    		SendBulletData(playerid, choosed_id, 1, 0, XYZ_FROM, XYZ_TO, XYZ_CENTER);
    	}
	    SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: SendBulletData executed!");
	    return 1;
	}
	
	if (strcmp("/getbullets", cmd, true) == 0)
    {
		if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: access denied.");
	    new command_str[256], choosed_id;
	    command_str = strtok(cmdtext, idx);
	    choosed_id = strval(command_str);
	    if(!IsPlayerConnected(choosed_id)) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: Usuario no conectado.");

	    new Float:XYZ_FROM[3],Float:XYZ_TO[3],Float:XYZ_CENTER[3];
	    GetPlayerPos(choosed_id, XYZ_FROM[0], XYZ_FROM[1], XYZ_FROM[2]);
	    GetPlayerPos(playerid, XYZ_TO[0], XYZ_TO[1], XYZ_TO[2]);
	    for(new i = 0; i < 500; i++) {
    		SendBulletData(choosed_id, playerid, 1, 0, XYZ_FROM, XYZ_TO, XYZ_CENTER);
    	}
	    SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: SendBulletData executed!");
	    return 1;
	}
	/*
	if (strcmp("/shoot", cmd, true) == 0)
    {

	    new command_str[256], choosed_id;
	    command_str = strtok(cmdtext, idx);
	    choosed_id = strval(command_str);
	    if(!IsPlayerConnected(choosed_id)) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: Usuario no conectado.");

	    new Float:XYZ_FROM[3],Float:XYZ_TO[3],Float:XYZ_CENTER[3];
	    GetPlayerPos(choosed_id, XYZ_FROM[0], XYZ_FROM[1], XYZ_FROM[2]);
	    GetPlayerPos(playerid, XYZ_TO[0], XYZ_TO[1], XYZ_TO[2]);

	    //SendBulletData(choosed_id, playerid, 1, GetPlayerWeapon(playerid), XYZ_FROM, XYZ_TO, XYZ_CENTER);
	    FCNPC_TriggerWeaponShot(choosed_id, GetPlayerWeapon(playerid), 1, choosed_id, XYZ_TO[0], XYZ_TO[1], XYZ_TO[2], true, XYZ_FROM[0], XYZ_FROM[1], XYZ_FROM[2]);
	    //FCNPC_TriggerWeaponShot(npcid, weaponid, hittype, hitid, Float:x, Float:y, Float:z, bool:ishit = true, Float:offset_from_x = 0.0, Float:offset_from_y = 0.0, Float:offset_from_z = 0.0);
	    SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: SendBulletData executed!");
	    return 1;
	}
	if (strcmp("/shoot", cmd, true) == 0)
    {

	    new command_str[256], choosed_id;
	    command_str = strtok(cmdtext, idx);
	    choosed_id = strval(command_str);
	    if(!IsPlayerConnected(choosed_id)) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: Usuario no conectado.");

	    new Float:XYZ_FROM[3],Float:XYZ_TO[3],Float:XYZ_CENTER[3];
	    GetPlayerPos(choosed_id, XYZ_FROM[0], XYZ_FROM[1], XYZ_FROM[2]);
	    GetPlayerPos(playerid, XYZ_TO[0], XYZ_TO[1], XYZ_TO[2]);

	    //SendBulletData(choosed_id, playerid, 1, GetPlayerWeapon(playerid), XYZ_FROM, XYZ_TO, XYZ_CENTER);
	    FCNPC_TriggerWeaponShot(choosed_id, GetPlayerWeapon(playerid), 1, playerid, XYZ_TO[0], XYZ_TO[1], XYZ_TO[2], true, XYZ_FROM[0], XYZ_FROM[1], XYZ_FROM[2]);
	    //FCNPC_TriggerWeaponShot(npcid, weaponid, hittype, hitid, Float:x, Float:y, Float:z, bool:ishit = true, Float:offset_from_x = 0.0, Float:offset_from_y = 0.0, Float:offset_from_z = 0.0);
	    SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: SendBulletData executed!");
	    return 1;
	}

	if (strcmp("/shoot2", cmd, true) == 0)
    {

	    new command_str[256], choosed_id;
	    command_str = strtok(cmdtext, idx);
	    choosed_id = strval(command_str);
	    if(!IsPlayerConnected(choosed_id)) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: Usuario no conectado.");

	    new Float:XYZ_FROM[3],Float:XYZ_TO[3],Float:XYZ_CENTER[3];
	    GetPlayerPos(choosed_id, XYZ_FROM[0], XYZ_FROM[1], XYZ_FROM[2]);
	    GetPlayerPos(playerid, XYZ_TO[0], XYZ_TO[1], XYZ_TO[2]);

	    //SendBulletData(playerid, choosed_id, 1, GetPlayerWeapon(playerid), XYZ_FROM, XYZ_TO, XYZ_CENTER);
	    FCNPC_TriggerWeaponShot(choosed_id, GetPlayerWeapon(playerid), 1, playerid, XYZ_TO[0], XYZ_TO[1], XYZ_TO[2], false, XYZ_FROM[0], XYZ_FROM[1], XYZ_FROM[2]);
	    SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: SendBulletData executed!");
	    return 1;
	}
*/
	if (strcmp("/gskin", cmd, true) == 0)
    {
	    if (PlayerInfo[playerid][VIP] >= 2)
		{
		    new tmpW[256], skin, stringQ[256];
		    tmpW = strtok(cmdtext, idx);
			if (strval(tmpW) < 0 || strval(tmpW) > 311) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ] {ffffff}ID Invalida.");
			skin = strval(tmpW);
			if(gTeam[playerid] == Humano && !IsPlayerAdmin(playerid) && IsZombieSkin(skin)) return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: El id que has introducido no pertenece al equipo Humano.");
		    format(stringQ, 256, "Has Guardado Correctamente el skin id %d.", skin);
		    SetPlayerSkinFixed(playerid, skin);
		    PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		    PlayerInfo[playerid][UsaSkin] = 1;
		    PlayerInfo[playerid][SkinID] = skin;
		    return SendClientMessage(playerid, COLOR_AMARILLO, stringQ);
	    }
	    else return SendClientMessage(playerid, COLOR_ROJO, "[ERROR]: Comando Para Usuarios VIP, Solo Humanos.");
	}
	if (strcmp("/ngskin", cmd, true) == 0)
    {
	    if (PlayerInfo[playerid][VIP] >= 2 )
		{
			if (PlayerInfo[playerid][UsaSkin] == 1)
			{
			    SendClientMessage(playerid, COLOR_AMARILLO, "Hecho ya no guardas mas tu skin.");
			    PlayerInfo[playerid][UsaSkin] = 0;
				return GameTextForPlayer(playerid,"~g~~h~> skin des-guardado <", 3000,3);
		    }
		    else return SendClientMessage(playerid, COLOR_ROJO, "[Error]: Tu no has guardado un skin.");
		}
		else return SendClientMessage(playerid, COLOR_ROJO, "[Error]: Comando Solo Para Usuarios Gold.");
	}
	if(strcmp(cmdtext, "/ct1", true)==0 || strcmp(cmdtext, "/ltc2", true)==0)	{
	if(PlayerInfo[playerid][InCORE] == 1 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, red, ">> No puede utilizar este comando en el nucleo.");
	if(PlayerInfo[playerid][VIP] >= 1) {
	    if((rztickcount() - PlayerInfo[playerid][AntiVIPCarFlood]) < 180 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, Rojo, "[ERROR]: {ffffff} Tienes que esperar 3 minutos para volver a usar este comando.");
		if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid,red,"Error: Ya tienes un vehiculo");
		} else  {
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,LVehicleIDt;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        LVehicleIDt = CreateVehicle(560,X,Y,Z,Angle,1,-1,-1);
        RemovePlayerFromVehicle(playerid);
		PutPlayerInVehicle(playerid,LVehicleIDt,0);	    AddVehicleComponent(LVehicleIDt, 1028);	AddVehicleComponent(LVehicleIDt, 1030);	AddVehicleComponent(LVehicleIDt, 1031);	AddVehicleComponent(LVehicleIDt, 1138);	AddVehicleComponent(LVehicleIDt, 1140);  AddVehicleComponent(LVehicleIDt, 1170);
	    AddVehicleComponent(LVehicleIDt, 1028);	AddVehicleComponent(LVehicleIDt, 1030);	AddVehicleComponent(LVehicleIDt, 1031);	AddVehicleComponent(LVehicleIDt, 1138);	AddVehicleComponent(LVehicleIDt, 1140);  AddVehicleComponent(LVehicleIDt, 1170);
	    AddVehicleComponent(LVehicleIDt, 1080);	AddVehicleComponent(LVehicleIDt, 1086); AddVehicleComponent(LVehicleIDt, 1087); AddVehicleComponent(LVehicleIDt, 1010);	PlayerPlaySound(playerid,1133,0.0,0.0,0.0);	ChangeVehiclePaintjob(LVehicleIDt,1);
	   	SetVehicleVirtualWorld(LVehicleIDt, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(LVehicleIDt, GetPlayerInterior(playerid));
		PlayerInfo[playerid][pCar] = LVehicleIDt;
		PlayerInfo[playerid][AntiVIPCarFlood] = rztickcount();
		}
	} else SendClientMessage(playerid,red,"ERROR: No tienes Suficiente level o Cuenta Vip Para este comando.");
	return 1;	}
//------------------------------------------------------------------------------
	if(strcmp(cmdtext, "/ct2", true)==0 || strcmp(cmdtext, "/ltc3", true)==0)	{
	if(PlayerInfo[playerid][InCORE] == 1 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, red, ">> No puede utilizar este comando en el nucleo.");
	if(PlayerInfo[playerid][VIP] >= 1) {
	    if((rztickcount() - PlayerInfo[playerid][AntiVIPCarFlood]) < 180 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, Rojo, "[ERROR]: {ffffff} Tienes que esperar 3 minutos para volver a usar este comando.");
		if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid,red,"Error: Ya tienes un vehiculo");
		} else  {
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,LVehicleIDt;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        LVehicleIDt = CreateVehicle(560,X,Y,Z,Angle,1,-1,-1);
        RemovePlayerFromVehicle(playerid);
		PutPlayerInVehicle(playerid,LVehicleIDt,0);    AddVehicleComponent(LVehicleIDt, 1028);	AddVehicleComponent(LVehicleIDt, 1030);	AddVehicleComponent(LVehicleIDt, 1031);	AddVehicleComponent(LVehicleIDt, 1138);	AddVehicleComponent(LVehicleIDt, 1140);  AddVehicleComponent(LVehicleIDt, 1170);
	    AddVehicleComponent(LVehicleIDt, 1080);	AddVehicleComponent(LVehicleIDt, 1086); AddVehicleComponent(LVehicleIDt, 1087); AddVehicleComponent(LVehicleIDt, 1010);	PlayerPlaySound(playerid,1133,0.0,0.0,0.0);	ChangeVehiclePaintjob(LVehicleIDt,2);
	   	SetVehicleVirtualWorld(LVehicleIDt, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(LVehicleIDt, GetPlayerInterior(playerid));
		PlayerInfo[playerid][pCar] = LVehicleIDt;
		PlayerInfo[playerid][AntiVIPCarFlood] = rztickcount();
		}
	} else SendClientMessage(playerid,red,"ERROR: level insuficiente.");
	return 1;	}
//------------------------------------------------------------------------------
	if(strcmp(cmdtext, "/ct3", true)==0 || strcmp(cmdtext, "/ltc4", true)==0)	{
	if(PlayerInfo[playerid][InCORE] == 1 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, red, ">> No puede utilizar este comando en el nucleo.");
	if(PlayerInfo[playerid][VIP] >= 1) {
	    if((rztickcount() - PlayerInfo[playerid][AntiVIPCarFlood]) < 180 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, Rojo, "[ERROR]: {ffffff} Tienes que esperar 3 minutos para volver a usar este comando.");
		if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid,red,"Error: Usted ya tiene un vehiculo");
		} else  {
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(559,X,Y,Z,Angle,1,-1,-1);
        RemovePlayerFromVehicle(playerid);
		PutPlayerInVehicle(playerid,carid,0);
    	AddVehicleComponent(carid,1065);    AddVehicleComponent(carid,1067);    AddVehicleComponent(carid,1162); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073);	ChangeVehiclePaintjob(carid,1);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		PlayerInfo[playerid][pCar] = carid;
		PlayerInfo[playerid][AntiVIPCarFlood] = rztickcount();
		}
	} else SendClientMessage(playerid,red,"ERROR: No tienes Suficiente level o Cuenta Vip Para este comando..");
	return 1;	}
//------------------------------------------------------------------------------
	if(strcmp(cmdtext, "/ct4", true)==0 || strcmp(cmdtext, "/ltc5", true)==0)	{
	if(PlayerInfo[playerid][InCORE] == 1 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, red, ">> No puede utilizar este comando en el nucleo.");
	if(PlayerInfo[playerid][VIP] >= 1) {
	    if((rztickcount() - PlayerInfo[playerid][AntiVIPCarFlood]) < 180 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, Rojo, "[ERROR]: {ffffff} Tienes que esperar 3 minutos para volver a usar este comando.");
		if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid,red,"Error: Usted ya tiene un vehiculo");
		} else  {
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(565,X,Y,Z,Angle,1,-1,-1);
        RemovePlayerFromVehicle(playerid);
		PutPlayerInVehicle(playerid,carid,0);
	    AddVehicleComponent(carid,1046); AddVehicleComponent(carid,1049); AddVehicleComponent(carid,1053); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073); ChangeVehiclePaintjob(carid,1);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		PlayerInfo[playerid][pCar] = carid;
		PlayerInfo[playerid][AntiVIPCarFlood] = rztickcount();
		}
	} else SendClientMessage(playerid,red,"ERROR: No tienes Suficiente level o Cuenta Vip Para este comando..");
	return 1;	}
//------------------------------------------------------------------------------
	if(strcmp(cmdtext, "/ct5", true)==0 || strcmp(cmdtext, "/ltc6", true)==0)	{
	if(PlayerInfo[playerid][InCORE] == 1 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, red, ">> No puede utilizar este comando en el nucleo.");
	if(PlayerInfo[playerid][VIP] >= 1) {
	    if((rztickcount() - PlayerInfo[playerid][AntiVIPCarFlood]) < 180 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, Rojo, "[ERROR]: {ffffff} Tienes que esperar 3 minutos para volver a usar este comando.");
		if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid,red,"Error: Usted ya tiene un vehiculo");
		} else  {
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(558,X,Y,Z,Angle,1,-1,-1);
        RemovePlayerFromVehicle(playerid);
		PutPlayerInVehicle(playerid,carid,0);
    	AddVehicleComponent(carid,1088); AddVehicleComponent(carid,1092); AddVehicleComponent(carid,1139); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073); ChangeVehiclePaintjob(carid,1);
 	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		PlayerInfo[playerid][pCar] = carid;
		PlayerInfo[playerid][AntiVIPCarFlood] = rztickcount();
		}
	} else SendClientMessage(playerid,red,"ERROR: No tienes Suficiente level o Cuenta Vip Para este comando..");
	return 1;	}
//------------------------------------------------------------------------------
	if(strcmp(cmdtext, "/ct6", true)==0 || strcmp(cmdtext, "/ltc7", true)==0)	{
	if(PlayerInfo[playerid][InCORE] == 1 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, red, ">> No puede utilizar este comando en el nucleo.");
	if(PlayerInfo[playerid][VIP] >= 1) {
	    if((rztickcount() - PlayerInfo[playerid][AntiVIPCarFlood]) < 180 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, Rojo, "[ERROR]: {ffffff} Tienes que esperar 3 minutos para volver a usar este comando.");
		if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid,red,"Error: Usted ya tiene un vehiculo");
		} else  {
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(561,X,Y,Z,Angle,1,-1,-1);
        RemovePlayerFromVehicle(playerid);
		PutPlayerInVehicle(playerid,carid,0);
    	AddVehicleComponent(carid,1055); AddVehicleComponent(carid,1058); AddVehicleComponent(carid,1064); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073); ChangeVehiclePaintjob(carid,1);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		PlayerInfo[playerid][pCar] = carid;
		PlayerInfo[playerid][AntiVIPCarFlood] = rztickcount();
		}
	} else SendClientMessage(playerid,red,"ERROR: No tienes Suficiente level o Cuenta Vip Para este comando.");
	return 1;	}
//------------------------------------------------------------------------------
	if(strcmp(cmdtext, "/ct7", true)==0 || strcmp(cmdtext, "/ltc8", true)==0)	{
	if(PlayerInfo[playerid][InCORE] == 1 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, red, ">> No puede utilizar este comando en el nucleo.");
	if(PlayerInfo[playerid][VIP] >= 1) {
	    if((rztickcount() - PlayerInfo[playerid][AntiVIPCarFlood]) < 180 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, Rojo, "[ERROR]: {ffffff} Tienes que esperar 3 minutos para volver a usar este comando.");
		if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid,red,"Error: Usted ya tiene un vehiculo");
		} else  {
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(562,X,Y,Z,Angle,1,-1,-1);
        RemovePlayerFromVehicle(playerid);
		PutPlayerInVehicle(playerid,carid,0);
	    AddVehicleComponent(carid,1034); AddVehicleComponent(carid,1038); AddVehicleComponent(carid,1147); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073); ChangeVehiclePaintjob(carid,1);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		PlayerInfo[playerid][pCar] = carid;
		PlayerInfo[playerid][AntiVIPCarFlood] = rztickcount();
		}
	} else SendClientMessage(playerid,red,"ERROR: No tienes Suficiente level o Cuenta Vip Para este comando.");
	return 1;	}
//------------------------------------------------------------------------------
	if(strcmp(cmdtext, "/ct8", true)==0 || strcmp(cmdtext, "/ltc9", true)==0)	{
	if(PlayerInfo[playerid][InCORE] == 1 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, red, ">> No puede utilizar este comando en el nucleo.");
	if(PlayerInfo[playerid][VIP] >= 1) {
	    if((rztickcount() - PlayerInfo[playerid][AntiVIPCarFlood]) < 180 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, Rojo, "[ERROR]: {ffffff} Tienes que esperar 3 minutos para volver a usar este comando.");
		if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid,red,"Error: Usted ya tiene un vehiculo");
		} else  {
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(567,X,Y,Z,Angle,1,-1,-1);
        RemovePlayerFromVehicle(playerid);
		PutPlayerInVehicle(playerid,carid,0);
	    AddVehicleComponent(carid,1102); AddVehicleComponent(carid,1129); AddVehicleComponent(carid,1133); AddVehicleComponent(carid,1186); AddVehicleComponent(carid,1188); ChangeVehiclePaintjob(carid,1); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1085); AddVehicleComponent(carid,1087); AddVehicleComponent(carid,1086);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		PlayerInfo[playerid][pCar] = carid;
		PlayerInfo[playerid][AntiVIPCarFlood] = rztickcount();
		}
	} else SendClientMessage(playerid,red,"ERROR: No tienes Suficiente level o Cuenta Vip Para este comando.");
	return 1;	}
//------------------------------------------------------------------------------
	if(strcmp(cmdtext, "/ct9", true)==0 || strcmp(cmdtext, "/ltc10", true)==0)	{
	if(PlayerInfo[playerid][InCORE] == 1 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, red, ">> No puede utilizar este comando en el nucleo.");
	if(PlayerInfo[playerid][VIP] >= 1) {
	    if((rztickcount() - PlayerInfo[playerid][AntiVIPCarFlood]) < 180 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, Rojo, "[ERROR]: {ffffff} Tienes que esperar 3 minutos para volver a usar este comando.");
		if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid,red,"Error: Usted ya tiene un vehiculo");
		} else  {
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(558,X,Y,Z,Angle,1,-1,-1);
        RemovePlayerFromVehicle(playerid);
		PutPlayerInVehicle(playerid,carid,0);
   		AddVehicleComponent(carid,1092); AddVehicleComponent(carid,1166); AddVehicleComponent(carid,1165); AddVehicleComponent(carid,1090);
	    AddVehicleComponent(carid,1094); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1087); AddVehicleComponent(carid,1163);//SPOILER
	    AddVehicleComponent(carid,1091); ChangeVehiclePaintjob(carid,2);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		PlayerInfo[playerid][pCar] = carid;
		PlayerInfo[playerid][AntiVIPCarFlood] = rztickcount();
		}
	} else SendClientMessage(playerid,red,"ERROR:No tienes Suficiente level o Cuenta Vip Para este comando.");
	return 1;	}
//------------------------------------------------------------------------------
	if(strcmp(cmdtext, "/ct10", true)==0 || strcmp(cmdtext, "/ltc11", true)==0)	{
	if(PlayerInfo[playerid][InCORE] == 1 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, red, ">> No puede utilizar este comando en el nucleo.");
	if(PlayerInfo[playerid][VIP] >= 1) {
	    if((rztickcount() - PlayerInfo[playerid][AntiVIPCarFlood]) < 180 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, Rojo, "[ERROR]: {ffffff} Tienes que esperar 3 minutos para volver a usar este comando.");
		if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid,red,"Error: Usted ya tiene un vehiculo");
		} else {
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(557,X,Y,Z,Angle,1,1,-1);
		PutPlayerInVehicle(playerid,carid,0);
		AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1081);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		PlayerInfo[playerid][pCar] = carid;
		PlayerInfo[playerid][AntiVIPCarFlood] = rztickcount();
		}
	} else SendClientMessage(playerid,red,"ERROR: No tienes Suficiente level o Cuenta Vip Para este comando.");
	return 1;	}
//------------------------------------------------------------------------------
	if(strcmp(cmdtext, "/ct11", true)==0 || strcmp(cmdtext, "/ltc12", true)==0)	{
	if(PlayerInfo[playerid][InCORE] == 1 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, red, ">> No puede utilizar este comando en el nucleo.");
	if(PlayerInfo[playerid][VIP] >= 1) {
	    if((rztickcount() - PlayerInfo[playerid][AntiVIPCarFlood]) < 180 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, Rojo, "[ERROR]: {ffffff} Tienes que esperar 3 minutos para volver a usar este comando.");
		if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid,red,"Error: Usted ya tiene un vehiculo");
		} else  {
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(535,X,Y,Z,Angle,1,-1,-1);
        RemovePlayerFromVehicle(playerid);
		PutPlayerInVehicle(playerid,carid,0);
		ChangeVehiclePaintjob(carid,1); AddVehicleComponent(carid,1109); AddVehicleComponent(carid,1115); AddVehicleComponent(carid,1117); AddVehicleComponent(carid,1073); AddVehicleComponent(carid,1010);
	    AddVehicleComponent(carid,1087); AddVehicleComponent(carid,1114); AddVehicleComponent(carid,1081); AddVehicleComponent(carid,1119); AddVehicleComponent(carid,1121);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		PlayerInfo[playerid][pCar] = carid;
		PlayerInfo[playerid][AntiVIPCarFlood] = rztickcount();
		}
	} else SendClientMessage(playerid,red,"ERROR: No tienes Suficiente level o Cuenta Vip Para este comando..");
	return 1;	}
//------------------------------------------------------------------------------
	if(strcmp(cmdtext, "/ct12", true)==0 || strcmp(cmdtext, "/ltc13", true)==0)	{
	if(PlayerInfo[playerid][InCORE] == 1 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, red, ">> No puede utilizar este comando en el nucleo.");
	if(PlayerInfo[playerid][VIP] >= 1) {
	    if((rztickcount() - PlayerInfo[playerid][AntiVIPCarFlood]) < 180 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, Rojo, "[ERROR]: {ffffff} Tienes que esperar 3 minutos para volver a usar este comando.");
		if(IsPlayerInAnyVehicle(playerid)) SendClientMessage(playerid,red,"Error: Usted ya tiene un vehiculo");
		else {
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(562,X,Y,Z,Angle,1,-1,-1);
        RemovePlayerFromVehicle(playerid);
		PutPlayerInVehicle(playerid,carid,0);
  		AddVehicleComponent(carid,1034); AddVehicleComponent(carid,1038); AddVehicleComponent(carid,1147);
		AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073); ChangeVehiclePaintjob(carid,0);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		PlayerInfo[playerid][pCar] = carid;
		PlayerInfo[playerid][AntiVIPCarFlood] = rztickcount();
		}
	} else SendClientMessage(playerid,red,"ERROR: No tienes Suficiente level o Cuenta Vip Para este comando..");
	return 1;	}
	if (strcmp("/dia", cmd, true) == 0)
    {
	if (PlayerInfo[playerid][VIP] >= 1)
    {
    SendClientMessage(playerid, COLOR_BLANCO, "Ahora Es De Dia");
	SetPlayerTime(playerid, 12,0);
	GameTextForPlayer(playerid,"~g~~h~> Dia <", 3000,3);
	return 1;
	}
	else return SendClientMessage(playerid, COLOR_ROJO, "[Error]: Comando Solo Para Usuarios Silver");
	}
	if (strcmp("/noche", cmd, true) == 0)
    {
	if (PlayerInfo[playerid][VIP] >= 1 )
    {
    SendClientMessage(playerid, COLOR_BLANCO, "Ahora Es De Noche");
	SetPlayerTime(playerid, 00,0);
	GameTextForPlayer(playerid,"~g~~h~> Noche <", 3000,3);
	return 1;
	}
	else return SendClientMessage(playerid, COLOR_ROJO, "[Error]: Comando Solo Para Usuarios Silver");
	}

	if (strcmp("/desarmarme", cmd, true) == 0)
    {
    if (PlayerInfo[playerid][VIP] >= 2 )
	{
    ResetPlayerWeaponsEx(playerid);
	GameTextForPlayer(playerid,"~g~~h~> LIMPIO <", 3000,3);
	return 1;
	}
	else return SendClientMessage(playerid, COLOR_ROJO, "[Error]: Comando Solo Para Usuarios Gold");
	}
	if (strcmp("/lmichat", cmd, true) == 0)
    {
    if (PlayerInfo[playerid][VIP] >= 2 )
	{
	GameTextForPlayer(playerid,"~g~~h~> Chat limpiado <", 3000,3);
	SendClientMessage(playerid, COLOR_BLANCO, "");
	SendClientMessage(playerid, COLOR_BLANCO, "");
	SendClientMessage(playerid, COLOR_BLANCO, "");
	SendClientMessage(playerid, COLOR_BLANCO, "");
	SendClientMessage(playerid, COLOR_BLANCO, "");
	SendClientMessage(playerid, COLOR_BLANCO, "");
	SendClientMessage(playerid, COLOR_BLANCO, "");
	SendClientMessage(playerid, COLOR_BLANCO, "");
	SendClientMessage(playerid, COLOR_BLANCO, "");
	SendClientMessage(playerid, COLOR_BLANCO, "");
	SendClientMessage(playerid, COLOR_BLANCO, "");
	SendClientMessage(playerid, COLOR_BLANCO, "");
	SendClientMessage(playerid, COLOR_BLANCO, "");
	SendClientMessage(playerid, COLOR_BLANCO, "");
	SendClientMessage(playerid, COLOR_BLANCO, "");
	SendClientMessage(playerid, COLOR_BLANCO, "");
	return 1;
	}
	else return SendClientMessage(playerid, COLOR_ROJO, "[Error]: Comando Solo Para Usuarios Gold");
	}
	if(strcmp(cmdtext, "/gp", true)==0)
	{
	if (PlayerInfo[playerid][VIP] >= 1 )
	{
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_ROJO, "Error >> {FFFFFF}Despidete de tu cuenta, rufían.");
	GetPlayerPos(playerid,PlayerInfo[playerid][savedPos][0],PlayerInfo[playerid][savedPos][1],PlayerInfo[playerid][savedPos][2]);
	GetPlayerFacingAngle(playerid,PlayerInfo[playerid][savedPos][3]);
	SendClientMessage(playerid,COLOR_AMARILLO,"Posicion guardada!");
	PlayerInfo[playerid][playerInt] = GetPlayerInterior(playerid);
	PlayerInfo[playerid][Posg] = 1;
	GameTextForPlayer(playerid,"~g~~h~> posicion guardada <", 3000,3);
	VIPMessageToAdmins(playerid,"/GP");
	return 1;
	}
    else return SendClientMessage(playerid, COLOR_ROJO, "[Error]: Comando Solo Para Usuarios silver");
	}
    else if(strcmp(cmdtext, "/cp", true)==0)
	{
	if (PlayerInfo[playerid][VIP] >= 1 )
	{
	if(PlayerInfo[playerid][Posg] == 1)
    {
    if(GetDistanceBetweenPositions(PlayerInfo[playerid][savedPos][0],PlayerInfo[playerid][savedPos][1],PlayerInfo[playerid][savedPos][2],5.11791, 1531.43982, 5.24879) <= 150 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1, "NO SE PUEDE EJECUTAR ESTE COMANDO, LA POSICION ESTA CERCA DEL DOMO.");
	if((rztickcount() - PlayerInfo[playerid][AntiCPFlood]) < 180 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, Rojo, "[ERROR]: {ffffff} Tienes que esperar 3 minutos para volver a usar este comando.");
	TeleportPlayer(playerid,PlayerInfo[playerid][savedPos][0],PlayerInfo[playerid][savedPos][1],PlayerInfo[playerid][savedPos][2]);
    SetPlayerFacingAngle(playerid,PlayerInfo[playerid][savedPos][3]);
	SetCameraBehindPlayer(playerid);
	SetPlayerInterior(playerid,PlayerInfo[playerid][playerInt]);
	SendClientMessage(playerid,COLOR_AMARILLO,"Teletransportado!");
	GameTextForPlayer(playerid,"~g~~h~> posicion cargada <", 3000,3);
	VIPMessageToAll(playerid,"/CP");
	PlayerInfo[playerid][AntiCPFlood] = rztickcount();
	return 1;
	}
	else return SendClientMessage(playerid, COLOR_ROJO, "[Error]: Debes Guardar Una Posicion Antes!");
	}
	else return SendClientMessage(playerid, COLOR_ROJO, "[Error]: Comando Solo Para Usuarios silver.");
	}

	new CMDERROR[256];
	format(CMDERROR,sizeof(CMDERROR),"[» ERROR «]:{ffffff} El Comando {"COLOR_DE_ERROR_EX"}%s{ffffff} no existe, utiliza /cmds para ver más comandos.",cmdtext);
	return SendClientMessage(playerid,COLOR_DE_ERROR,CMDERROR);
}

dcmd_cerrarv(playerid,params[]) {
	#pragma unused params
    if(PlayerInfo[playerid][nivel] >= 1) {
	    if(IsPlayerInAnyVehicle(playerid)) {
		 	for(new i = 0; i < GetMaxPlayers(); i++) SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),i,false,true);
			CMDMessageToAdmins(playerid,"CERRARV");
			PlayerInfo[playerid][DoorsLocked] = 1;
			new string[256];
			format(string,sizeof(string),"El Administrador \"%s\" ha bloqueado su vehiculo", pName(playerid));
			return AdminMessageToAdmins(playerid,blue,string);
		} else return SendClientMessage(playerid,red,"ERROR: Necesitas estar en un vehiculo para bloquear/desbloquear las puertas");
	} else return SendClientMessage(playerid,red,"ERROR: Necesitas ser Administrador nivel 1 para usar este comando");
}

dcmd_abrirv(playerid,params[]) {
	#pragma unused params
    if(PlayerInfo[playerid][nivel] >= 1) {
	    if(IsPlayerInAnyVehicle(playerid)) {
		 	for(new i = 0; i < GetMaxPlayers(); i++) SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),i,false,false);
			CMDMessageToAdmins(playerid,"ABRIRV");
			PlayerInfo[playerid][DoorsLocked] = 0;
			new string[256];
			format(string,sizeof(string),"El Administrador \"%s\" ha desbloqueado su vehiculo", pName(playerid));
			return AdminMessageToAdmins(playerid,blue,string);
		} else return SendClientMessage(playerid,red,"ERROR: Necesitas estar en un vehiculo para bloquear/desbloquear las puertas");
	} else return SendClientMessage(playerid,red,"ERROR: Necesitas ser Administrador nivel 1 para usar este comando");
}

dcmd_fix(playerid,params[]) {
	#pragma unused params
	if(IsPlayerAdmin(playerid))
	{
		if (IsPlayerInAnyVehicle(playerid))
		{
            CMDMessageToAdmins(playerid,"FIX");
			SetVehicleHealth(GetPlayerVehicleID(playerid),1250.0);
			RepairVehicle(GetPlayerVehicleID(playerid));
			return SendClientMessage(playerid,blue,"Vehiculo Reparado");
		} else return SendClientMessage(playerid,red,"ERROR: No estas en un vehiculo");
	} else return SendClientMessage(playerid,red,"ERROR: Require RCON.");
}
dcmd_cambiarpass(playerid,params[]){
if(IsPlayerConnected(playerid)){
if(PlayerInfo[playerid][Identificado] == 0 || PlayerInfo[playerid][Registrado] == 0) return SendClientMessage(playerid,red,"No estas registrado..You're not registered...");
new tmp2[256],Index;
tmp2 = strtok(params,Index);
if(!strlen(tmp2)) return SendClientMessage(playerid, red, "Uso correcto: /cambiarpass [Nueva contraseña]");
if(strlen(tmp2) > 14) return SendClientMessage(playerid, red, "ERROR: La contraseña contiene mas de 14 caracteres!.");
if(strlen(tmp2) < 3) return SendClientMessage(playerid, red, "ERROR: La contraseña debe ser mayor a 3 caracteres.");
strmid(Password[playerid], tmp2, 0, strlen(tmp2));
new UpdateUser[101];
format(UpdateUser, sizeof(UpdateUser), "UPDATE Usuarios SET Password='%s' WHERE Username = '%s'",tmp2,PlayerName2(playerid));
db_query(DataBase_USERS,UpdateUser);
SendClientMessage(playerid,green,"Tu contraseña fue cambiada satisfactoriamente, este cambio NO afectara tu cuenta del foro.");
}
return 1;
}
dcmd_pms(playerid,params[])
{
	#pragma unused params
	if(PlayerInfo[playerid][PM] == 0)
	{
	    PlayerInfo[playerid][PM] = 1;
	    SendClientMessage(playerid,0xFFFF00FF,"Tus mensajes privados fueron activados, puedes recibir mensajes privados.");
	    PlayerPlaySound(playerid, 1131, 0.0, 0.0, 0.0);
 	}
 	else
 	{
 	    PlayerInfo[playerid][PM] = 0;
	    SendClientMessage(playerid,0xFFFF00FF,"Tus Mensajes privados fueron desactivados, ya no recibiras ningun mensaje privado.");
	    PlayerPlaySound(playerid, 1131, 0.0, 0.0, 0.0);
  	}
	return 1;
}

stock IsValidNickName(string[])
{
    for(new i = 0, j = strlen(string); i < j; i++)
    {
        switch(string[i])
        {
            case '0' .. '9': continue;
            case 'a' .. 'z': continue;
            case 'A' .. 'Z': continue;
            case '_': continue;
            case '$': continue;
            case '.': continue;
            case '=': continue;
            case '(': continue;
            case ')': continue;
            case '[': continue;
            case ']': continue;
            default: return 0;
        }
    }
    return 1;
}

dcmd_kick(playerid, params[]){
  if(PlayerInfo[playerid][nivel] >= 1 || IsPlayerAdmin(playerid)){
    new tmp[256], tmp2[256], Index;
    tmp = strtok(params, Index);
    tmp2 = strrest(params, Index);
    if(!strlen(params) || !IsNumeric(tmp))return SendClientMessage(playerid, COLOR_BLANCO, "USO: /kick <playerid> <razón>");
    new jugador, name[MAX_PLAYER_NAME], admin[MAX_PLAYER_NAME], str[300];
    jugador = strval(tmp);
    if(!IsPlayerConnected(jugador)) return SendClientMessage(playerid, COLOR_BLANCO, "Jugador no conectado.");
    if (IsPlayerNPC(jugador)) return SendClientMessage(playerid,red, "ERROR: No expulses a los bots.");
    if(IsPlayerConnected(jugador) || jugador != INVALID_PLAYER_ID){
      if(PlayerInfo[jugador][nivel] < PlayerInfo[playerid][nivel] || !IsPlayerAdmin(jugador)){
        GetPlayerName(jugador, name, sizeof(name));
        GetPlayerName(playerid, admin, sizeof(admin));
        if(!strlen(tmp2)){//si no hay razon, entonces....
          format(str, sizeof(str), "{4DFFFF}**{FFFFFF} %s {4DFFFF}ha [E]xpusaldo a {FFFFFF}%s. [Sin razon]", admin, name);
        }else{//si no...
          format(str, sizeof(str), "{4DFFFF}**{FFFFFF} %s {4DFFFF}ha [E]xpusaldo a {FFFFFF}%s {4DFFFF}[Razon: %s  ]", admin, name, tmp2);
        }
        AdminMessageToAdmins(playerid,COLOR_GRIS,str);
        format(str, sizeof(str), "[KICK] Usuario %s Expulsado Por %s Razón: %s",name, admin, tmp2);
        SaveCMD(playerid, str);
        return Kick(jugador);
      }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: No puedes usar este comando sobre este jugador");
    }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: El jugador no esta conectado o la id no es correcta");
  }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: No posees el nivel suficiente para usar este comando");
}


dcmd_scanner(playerid, params[]){
  if(PlayerInfo[playerid][nivel] >= 3 || IsPlayerAdmin(playerid)){
    new tmp[256], tmp2[256], Index;
    tmp = strtok(params, Index);
    tmp2 = strrest(params, Index);
    if(!strlen(params) || !IsNumeric(tmp))return SendClientMessage(playerid, COLOR_BLANCO, "USO: /scanner <playerid> <carpeta>");
    new jugador,str[300];
    jugador = strval(tmp);
    if(!IsPlayerConnected(jugador)) return SendClientMessage(playerid, COLOR_BLANCO, "Jugador no conectado.");
    if(IsPlayerAdmin(jugador)) return SendClientMessage(playerid, COLOR_BLANCO, "Error: Jugador rcon.");
    if(!RZClient_IsClientConnected(jugador)) return SendClientMessage(playerid, COLOR_BLANCO, "Error: Jugador sin RZCLIENT.");
    if (IsPlayerNPC(jugador)) return SendClientMessage(playerid,red, "ERROR: EL ID INGRESADO NO PERTENECE A UN JUGADOR.");
    if(IsPlayerConnected(jugador) || jugador != INVALID_PLAYER_ID){
      if(PlayerInfo[jugador][nivel] < PlayerInfo[playerid][nivel] || !IsPlayerAdmin(jugador)){
        RZClient_getFiles(jugador, playerid, tmp2);
        format(str, sizeof(str), "**{FFFFFF} %s {4DFFFF}Esta escaneando la carpeta {FFFFFF}%s {4DFFFF}del Jugador {FFFFFF}%s [%d]", PlayerName2(playerid),tmp2,PlayerName2(jugador),jugador);
        return AdminMessageToAdmins(playerid,0x4DFFFFAA,str);
      }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: No puedes usar este comando sobre este jugador");
    }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: El jugador no esta conectado o la id no es correcta");
  }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: Requiere nivel 3.");
}
/*
dcmd_procscanner(playerid, params[]){
  if(PlayerInfo[playerid][nivel] >= 3 || IsPlayerAdmin(playerid)){
    new tmp[256], Index;
    tmp = strtok(params, Index);
    if(!strlen(params) || !IsNumeric(tmp))return SendClientMessage(playerid, COLOR_BLANCO, "USO: /procscanner <playerid>");
    new jugador,str[300];
    jugador = strval(tmp);
    if(!IsPlayerConnected(jugador)) return SendClientMessage(playerid, COLOR_BLANCO, "Jugador no conectado.");
    if(IsPlayerAdmin(jugador)) return SendClientMessage(playerid, COLOR_BLANCO, "Error: Jugador rcon.");
    if(!RZClient_IsClientConnected(jugador)) return SendClientMessage(playerid, COLOR_BLANCO, "Error: Jugador sin RZCLIENT.");
    if (IsPlayerNPC(jugador)) return SendClientMessage(playerid,red, "ERROR: EL ID INGRESADO NO PERTENECE A UN JUGADOR.");
    if(IsPlayerConnected(jugador) || jugador != INVALID_PLAYER_ID){
      if(PlayerInfo[jugador][nivel] < PlayerInfo[playerid][nivel] || !IsPlayerAdmin(jugador)){
        RZClient_getProcesses(jugador, playerid, "nope");
        format(str, sizeof(str), "**{FFFFFF} %s {4DFFFF}Esta viendo los procesos activos {FFFFFFdel Jugador {4DFFFF}%s [%d]", PlayerName2(playerid),PlayerName2(jugador),jugador);
        return AdminMessageToAdmins(playerid,0x4DFFFFAA,str);
      }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: No puedes usar este comando sobre este jugador");
    }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: El jugador no esta conectado o la id no es correcta");
  }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: Requiere nivel 3.");
}
*/
dcmd_dbug(playerid, params[]){
  if(PlayerInfo[playerid][nivel] >= 1 || IsPlayerAdmin(playerid)){
    new tmp[256], tmp2[256], Index;
    tmp = strtok(params, Index);
    tmp2 = strrest(params, Index);
    if(!strlen(params) || !IsNumeric(tmp))return SendClientMessage(playerid, COLOR_BLANCO, "USO: /dbug <playerid> <razón> | reconecta a un jugador, adecuado para desbugear usuarios.");
    new jugador, name[MAX_PLAYER_NAME], admin[MAX_PLAYER_NAME], str[300];
    jugador = strval(tmp);
    if(!IsPlayerConnected(jugador)) return SendClientMessage(playerid, COLOR_BLANCO, "Jugador no conectado.");
    if (IsPlayerNPC(jugador)) return SendClientMessage(playerid,red, "ERROR: No expulses a los bots.");
    if(IsPlayerConnected(jugador) || jugador != INVALID_PLAYER_ID){
      if(PlayerInfo[jugador][nivel] < PlayerInfo[playerid][nivel] || !IsPlayerAdmin(jugador)){
        GetPlayerName(jugador, name, sizeof(name));
        GetPlayerName(playerid, admin, sizeof(admin));
        if(!strlen(tmp2)){//si no hay razon, entonces....
          format(str, sizeof(str), "{4DFFFF}**{FFFFFF} %s {4DFFFF}ha [R]econectado a {FFFFFF}%s.", admin, name);
        }else{//si no...
          format(str, sizeof(str), "{4DFFFF}**{FFFFFF} %s {4DFFFF}ha [R]econectado a {FFFFFF}%s {4DFFFF}[Razon: %s  ]", admin, name, tmp2);
        }
        PlayerMessageToPlayers(playerid, -1,str);
        format(str, sizeof(str), "[RE-CONNECT] Usuario %s Reconectado Por %s Razón: %s",name, admin, tmp2);
        SaveCMD(playerid, str);
        return ReConnect(jugador);
      }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: No puedes usar este comando sobre este jugador");
    }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: El jugador no esta conectado o la id no es correcta");
  }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: No posees el nivel suficiente para usar este comando");
}

dcmd_chbug(playerid, params[]){
  if(PlayerInfo[playerid][nivel] >= 1 || IsPlayerAdmin(playerid)){
    new tmp[256], Index;
    tmp = strtok(params, Index);
    if(!strlen(params) || !IsNumeric(tmp))return SendClientMessage(playerid, COLOR_BLANCO, "USO: /chbug <playerid> <razón> | verifica si un jugador esta bug (esta funcion es inestable).");
    new jugador,str[300];
    jugador = strval(tmp);
    if(PlayerInfo[jugador][nivel] < PlayerInfo[playerid][nivel] || !IsPlayerAdmin(jugador))
	{
        new Float:PacketLOSS = NetStats_PacketLossPercent(jugador);
        if(IsPlayerPaused(jugador))
        {
	        if(PacketLOSS > 0.8)
	        {
	        format(str, sizeof(str), "{4DFFFF}**{FFFFFF} %s [ID: %d] {F50000}PROBABLEMENTE ESTA BUG, {4DFFFF}tiene un Packetloss de {FFFFFF}%.2f", PlayerName2(jugador),jugador,PacketLOSS);
			}
	        else
	        {
	        format(str, sizeof(str), "{4DFFFF}**{FFFFFF} %s [ID: %d] {4DFFFF}Parece no estar bug, tiene un Packetloss de {FFFFFF}%.2f", PlayerName2(jugador),jugador,PacketLOSS);
			}
		}
		else
		{
	        format(str, sizeof(str), "{4DFFFF}**{FFFFFF} %s [ID: %d] {F50000}ESTA BUG O ESTA EN PAUSA, SI SE MUEVE Y NO MUERE, ESTA BUG.", PlayerName2(jugador),jugador);
		}
		return SendClientMessage(playerid,-1,str);
    }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: El jugador no esta conectado o la id no es correcta");
  }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: No posees el nivel suficiente para usar este comando");
}


dcmd_sbcheck(playerid, params[]){
  if(PlayerInfo[playerid][nivel] >= 1 || IsPlayerAdmin(playerid))
  {
    new tmp[256], Index;
    tmp = strtok(params, Index);
    if(!strlen(params) || !IsNumeric(tmp))return SendClientMessage(playerid, COLOR_BLANCO, "USO: /sbcheck <playerid> | verifica si el jugador tiene sobeit, el servidor lo detectara.");
    new jugador;
    jugador = strval(tmp);
    if(PlayerInfo[jugador][nivel] < PlayerInfo[playerid][nivel] || !IsPlayerAdmin(jugador))
	{
	    ForceClassSelection(jugador);
	    SetPlayerHealth(jugador, 0);
	    //TogglePlayerSpectating(jugador, true);
	    //TogglePlayerSpectating(jugador, false);
		return SendClientMessage(playerid, COLOR_ROJO, "Success >> {FFFFFF}El servidor se encargara de todo, no es necesario hacer nada más.");
    }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: El jugador no esta conectado, es superior a ti o es inmune a este comando.");
  }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: No posees el nivel suficiente para usar este comando");
}


dcmd_warn(playerid, params[]){
  if(PlayerInfo[playerid][nivel] >= 1 || IsPlayerAdmin(playerid)){
    new tmp[256], tmp2[256], Index;
    tmp = strtok(params, Index);
    tmp2 = strrest(params, Index);
    if(!strlen(params) || !IsNumeric(tmp))return SendClientMessage(playerid, COLOR_BLANCO, "USO: /kick <playerid> <razón>");
    new jugador, name[MAX_PLAYER_NAME], admin[MAX_PLAYER_NAME], str[300];
    jugador = strval(tmp);
    if(!IsPlayerConnected(jugador)) return SendClientMessage(playerid, COLOR_BLANCO, "Jugador no conectado.");
    if (IsPlayerNPC(jugador)) return SendClientMessage(playerid,red, "ERROR: No expulses a los bots.");
    if(!strlen(tmp2))return SendClientMessage(playerid,red, "INGRESA UNA RAZON!.");
    if(IsPlayerConnected(jugador) || jugador != INVALID_PLAYER_ID){
      if(PlayerInfo[jugador][nivel] < PlayerInfo[playerid][nivel] || !IsPlayerAdmin(jugador)){
        GetPlayerName(jugador, name, sizeof(name));
        GetPlayerName(playerid, admin, sizeof(admin));
		if(PlayerInfo[jugador][Advertencias] >= ADVERTENCIAS_MAXIMAS)
		{
        format(str, sizeof(str), "{4DFFFF}**{FFFFFF} %s {4DFFFF}ha [E]xpusaldo a {FFFFFF}%s {4DFFFF}[Razon: %s  ] [%d/%d]", admin, name, tmp2,PlayerInfo[jugador][Advertencias],ADVERTENCIAS_MAXIMAS);
        SendFormatDialog(jugador,"{ffffff}<-- {f50000}Expulsado {fffff}-->","{4DFFFF}Expulsado por:{ffffff}%s\n\n{4DFFFF}Razon:{ffffff}%s\n\n{ffffff}Si este administrador abuso de su poder toma foto con F8 y publicala en facebook.",admin,tmp2);
        printf("[KICK] Usuario %s Expulsado Por %s Razón: %s [%d/%d]",admin, name, tmp2,PlayerInfo[jugador][Advertencias],ADVERTENCIAS_MAXIMAS);
        PlayerMessageToPlayers(playerid, -1, str);
		return Kick(jugador);
		}
        format(str, sizeof(str), "{4DFFFF}**{FFFFFF} %s {4DFFFF}Adiverte a {FFFFFF}%s {4DFFFF}[Razon: %s  ] [%d/%d]", admin, name, tmp2,PlayerInfo[jugador][Advertencias],ADVERTENCIAS_MAXIMAS);
        PlayerInfo[jugador][Advertencias]++;
        SendFormatDialog(jugador,"{ffffff}<--{f50000} ADVERTENCIA {fffff}-->","{4DFFFF}El Administrador:{ffffff} %s {4DFFFF}Te ha dado una advertencia\n\n{4DFFFF}Razon:{ffffff} %s",admin,tmp2);
		SendClientMessageToAll(-1,str);
		printf("[WARN] Usuario %s Advertido Por %s Razón: %s",admin, name, tmp2);
		return 1;
      }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: No puedes usar este comando sobre este jugador");
    }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: El jugador no esta conectado o la id no es correcta");
  }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: No posees el nivel suficiente para usar este comando");
}
#if defined VOTE_KICK_SYSTEM
dcmd_votekick(playerid, params[])
{
  //if(CheckAdminsOnline() < 1)
  //{
    new tmp[256], tmp2[256],VK_STR[600],VK_STR2[600], Index, jugador;
    tmp = strtok(params, Index);
    tmp2 = strrest(params, Index);
    if(!strlen(params) || !IsNumeric(tmp))return SendClientMessage(playerid, COLOR_BLANCO, "USO: /VoteKick <playerid> <razón>");
    jugador = strval(tmp);
    if(PlayerInfo[jugador][nivel] >= 1 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_ROJO, "ERROR: No puedes utilizar este comando en un administrador.");
    if(!IsPlayerConnected(jugador)) return SendClientMessage(playerid, COLOR_BLANCO, "Jugador no conectado.");
    if (IsPlayerNPC(jugador)) return SendClientMessage(playerid,red, "ERROR: No expulses a los bots.");
    if((rztickcount() - AntiVoteKickFlood) < TIEMPO_KICK) return SendClientMessage(playerid,red, "ERROR: No ha pasado 1 Minuto desde que se expulso un jugador, agurda un poco mas.");
    if((rztickcount() - VoteKickFlood[playerid]) >= TIEMPO_KICK && Voto[playerid] == 1){Voto[playerid] = 0;}
	if (Voto[playerid] == 1) return SendClientMessage(playerid,red, "ERROR: Ya has Votado, Espera a que voten más personas para votar.");
    if(!IsNull(tmp2) && Votos_KICK[jugador] == 0 && strlen( RemoveSpaces(tmp2) ) < 3 )return SendClientMessage(playerid,red, "[ RZ; Razón Invalida ]: {ffffff}Utiliza este comando responsablemente o te bloquearemos la cuenta.");
    if(IsPlayerConnected(jugador) && jugador != INVALID_PLAYER_ID)
	{
		if(Votos_KICK[jugador] <= 1)
		{
			strmid(RAZON_KICK[jugador],tmp2, 0, strlen(tmp2));
			strmid(VTK_NAME[jugador],PlayerName2(playerid), 0, strlen(PlayerName2(playerid)));
		}
		if(Votos_KICK[jugador] >= VOTOS_PARA_KICK)
		{
		    format(VK_STR2, sizeof(VK_STR2), "**{FFFFFF} %s {4DFFFF}ha [E]xpusaldo a {FFFFFF}%s {4DFFFF}[Razon: %s ] {ffffff}K.By %s", PlayerName2(playerid), PlayerName2(jugador), RAZON_KICK[jugador],VTK_NAME[jugador]);
			printf("[VoteKick:KICK] Usuario %s Dio El Ultimo Voto para Expulsar a %s Razón: %s [%d/%d]",PlayerName2(playerid), PlayerName2(jugador), RAZON_KICK[jugador],PlayerInfo[jugador][Advertencias],ADVERTENCIAS_MAXIMAS);
        	SendClientMessageToAll(0x4DFFFFFF,VK_STR2);
        	Voto[playerid] = 1;
        	VoteKickFlood[playerid] = rztickcount();
        	AntiVoteKickFlood = rztickcount();
			format(VK_STR2, sizeof(VK_STR2), "** %s ha [E]xpusaldo a %s [Razon: %s ] K.By %s",PlayerName2(playerid), PlayerName2(jugador), RAZON_KICK[jugador],VTK_NAME[jugador]);
			SaveCMD(playerid, VK_STR2);
			return Kick(jugador);
		}
        format(VK_STR, sizeof(VK_STR), "{FFFFFF}%s [ID: %d] {4DFFFF}Vota por Expulsar a {FFFFFF}%s [ID: %d] {4DFFFF}[Razon: %s] [%d/%d]", PlayerName2(playerid), playerid,PlayerName2(jugador),jugador, RAZON_KICK[jugador],Votos_KICK[jugador],VOTOS_PARA_KICK);
		SendClientMessageToAll(-1,VK_STR);
		Votos_KICK[jugador]++;
		Voto[playerid] = 1;
		VoteKickFlood[playerid] = rztickcount();
		printf("[VoteKick:WARN] Usuario %s Advertido Por %s Razón: %s",PlayerName2(playerid), PlayerName2(jugador), tmp2);
		return 1;
	}else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: El jugador no esta conectado o la id no es correcta");
  //}else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: Comando desactivado, Ya Hay Administradores Conectados, usa /Reportar.");
}
#endif
dcmd_sban(playerid, params[]){
  if(PlayerInfo[playerid][nivel] >= 6 || IsPlayerAdmin(playerid)){//restriccion para que solo los admins de nivel 4 o superior puedan usar el comando
    new name[MAX_PLAYER_NAME], tmp2[300], Index;//arrays
    name = strtok(params, Index);//tomara el 1 valor del comando, es decir la id del jugador
    tmp2 = strrest(params, Index);//tomara el 2 valor del comando, es decir la razon del ban
    if(!strlen(params))return SendClientMessage(playerid, COLOR_BLANCO, "USO: /sban <nombre> <razón> | bloquea la cuenta de un usuario");//comprobamos que hayan igresado los argumentos, y que la id sea un numero.
    if(!strlen(tmp2))return SendClientMessage(playerid, COLOR_ROJO, "ERROR: ingresa una razon y asegurate de que sea valida.");
    new admin[MAX_PLAYER_NAME], str[256];
	//if(IsPlayerAdmin(playerid)) return SendClientMessage(playerid,red,"ERROR: NO PUEDES BANEAR AL DIOS XD PUTO .l.");
    if(!IsNull(name))
    {
		if(!IsAccountRegistered(name)) return SendClientMessage(playerid,COLOR_DE_ERROR,"[ ERROR ]: {ffffff}La cuenta que has escrito no existe en la base de datos.");
		CMDMessageToAdmins(playerid,"SBAN");
        GetPlayerName(playerid, admin, sizeof(admin));
        format(str, sizeof(str), "{4DFFFF}**{FFFFFF} %s {4DFFFF}ha [B]aneado la Cuenta {FFFFFF}%s {BBC1C1}[Razon: %s]", admin, name, tmp2);
        AdminMessageToAdmins(playerid, COLOR_GRIS, str);
        format(str, sizeof(str), "%s Baneado por el admin %s, [Razón: %s] \n",name, admin, tmp2);
        SaveCMD(playerid, str);
        return BanByName(name,playerid,tmp2); //banear x nick
    }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: ingresa un nick valido.");
  }else return SendClientMessage(playerid, COLOR_ROJO, "Administradores nivel 6 solo utilizan este comando.");
}

dcmd_rzcban(playerid, params[]){
  if(PlayerInfo[playerid][nivel] >= 6 || IsPlayerAdmin(playerid)){//restriccion para que solo los admins de nivel 4 o superior puedan usar el comando
    new name[MAX_PLAYER_NAME], tmp2[300], Index;//arrays
    name = strtok(params, Index);//tomara el 1 valor del comando, es decir la id del jugador
    tmp2 = strrest(params, Index);//tomara el 2 valor del comando, es decir la razon del ban
    if(!strlen(params))return SendClientMessage(playerid, COLOR_BLANCO, "USO: /rzcban <nombre> <razón> | bloquea la cuenta de un usuario solo para RZC");//comprobamos que hayan igresado los argumentos, y que la id sea un numero.
    if(!strlen(tmp2))return SendClientMessage(playerid, COLOR_ROJO, "ERROR: ingresa una razon y asegurate de que sea valida.");
    new admin[MAX_PLAYER_NAME], str[256];
    if(!IsNull(name))
    {
		if(!IsAccountRegistered(name)) return SendClientMessage(playerid,COLOR_DE_ERROR,"[ ERROR ]: {ffffff}La cuenta que has escrito no existe en la base de datos.");
		CMDMessageToAdmins(playerid,"RZCBAN");
        GetPlayerName(playerid, admin, sizeof(admin));
        format(str, sizeof(str), "{4DFFFF}**{FFFFFF} %s {4DFFFF}ha Restringido con RZClient la cuenta {FFFFFF}%s {BBC1C1}[Razon: %s]", admin, name, tmp2);
        AdminMessageToAdmins(playerid, COLOR_GRIS, str);
        format(str, sizeof(str), "%s RZClient restricted por el admin %s, [Razón: %s] \n",name, admin, tmp2);
        SaveCMD(playerid, str);
        return RZCBanByName(name,playerid,tmp2);
    }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: ingresa un nick valido.");
  }else return SendClientMessage(playerid, COLOR_ROJO, "Administradores nivel 6 solo utilizan este comando.");
}

dcmd_cban(playerid, params[]){
  if(PlayerInfo[playerid][nivel] >= 6 || IsPlayerAdmin(playerid)){//restriccion para que solo los admins de nivel 4 o superior puedan usar el comando
    new name[MAX_PLAYER_NAME], tmp2[300], Index;//arrays
    name = strtok(params, Index);//tomara el 1 valor del comando, es decir la id del jugador
    tmp2 = strrest(params, Index);//tomara el 2 valor del comando, es decir la razon del ban
    if(!strlen(params))return SendClientMessage(playerid, COLOR_BLANCO, "USO: /cban <nombre> <razón> | Elimina la cuenta de un usuario");//comprobamos que hayan igresado los argumentos, y que la id sea un numero.
    if(!strlen(tmp2))return SendClientMessage(playerid, COLOR_ROJO, "ERROR: ingresa una razon y asegurate de que sea valida.");
    new admin[MAX_PLAYER_NAME], str[256];
    if(!IsNull(name))
    {
		if(!IsAccountRegistered(name)) return SendClientMessage(playerid,COLOR_DE_ERROR,"[ ERROR ]: {ffffff}La cuenta que has escrito no existe en la base de datos.");
		CMDMessageToAdmins(playerid,"SBAN");
        GetPlayerName(playerid, admin, sizeof(admin));
        format(str, sizeof(str), "{4DFFFF}**{FFFFFF} %s {4DFFFF}ha [E]liminado la cuenta {FFFFFF}%s {BBC1C1}[Razon: %s]", admin, name, tmp2);
        AdminMessageToAdmins(playerid, COLOR_GRIS, str);
        format(str, sizeof(str), "%s Eliminado por el admin %s, [Razón: %s] \n",name, admin, tmp2);
        SaveCMD(playerid, str);
		new DeleteAccount[100];
		format(DeleteAccount, sizeof(DeleteAccount), "DELETE FROM Usuarios WHERE Username='%s'",name);
		db_query(DataBase_USERS,DeleteAccount);
        return 1;
    }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: ingresa un nick valido.");
  }else return SendClientMessage(playerid, COLOR_ROJO, "Administradores nivel 6 solo utilizan este comando.");
}

dcmd_ban(playerid, params[]){
  if(PlayerInfo[playerid][nivel] >= 2 || IsPlayerAdmin(playerid)){//restriccion para que solo los admins de nivel 4 o superior puedan usar el comando
    new tmp[256], tmp2[300], Index;//arrays
    tmp = strtok(params, Index);//tomara el 1 valor del comando, es decir la id del jugador
    tmp2 = strrest(params, Index);//tomara el 2 valor del comando, es decir la razon del ban
    if(!strlen(params) || !IsNumeric(tmp))return SendClientMessage(playerid, COLOR_BLANCO, "USO: /ban <playerid> <razón>");//comprobamos que hayan igresado los argumentos, y que la id sea un numero.
    if(!strlen(tmp2))return SendClientMessage(playerid, COLOR_ROJO, "ERROR: Debes ingresar una razón");
    new jugador, name[MAX_PLAYER_NAME],LOLAVISO[256], admin[MAX_PLAYER_NAME], str[128]; //arrays que usaremos para almacenar nombres, la id del jugador y un mensaje
    jugador = strval(tmp);//jugador =valor de tmp es decir la id.
    if(!IsPlayerConnected(jugador)) return SendClientMessage(playerid, COLOR_BLANCO, "Jugador no conectado.");
    if (IsPlayerNPC(jugador)) return SendClientMessage(playerid,red, "ERROR: No expulses a los bots.");
	if(PlayerInfo[jugador][nivel] >= 3 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid,red,"ERROR: No puedes Banear a este Admin Por que no Estas Autorizado Para Banear Admins xD.");
    if(IsPlayerConnected(jugador) || jugador != INVALID_PLAYER_ID){ //restriccion para saber si el jugador que se quiere banear esta conectado o no, y si la id es valida
      if(PlayerInfo[jugador][nivel] < PlayerInfo[playerid][nivel] || !IsPlayerAdmin(jugador)){ //restriccion para saber si el jugador que se quiere banear posee un nivel de admin mayor o es admin RCON
		if(PlayerInfo[jugador][nivel] == 5 && !IsPlayerAdmin(playerid))
		{
		format(LOLAVISO,sizeof(LOLAVISO),"Advertencia El Miembro del staff: %s Intenta Banear a %s.",admin,name);
		AdminMessageToAdmins(playerid,red,LOLAVISO);
		return 0;
		}
		CMDMessageToAdmins(playerid,"BAN");
        GetPlayerName(jugador, name, sizeof(name));
        GetPlayerName(playerid, admin, sizeof(admin));
        format(str, sizeof(str), "{4DFFFF}**{FFFFFF} %s {4DFFFF}ha [B]aneado a {FFFFFF}%s {BBC1C1}[Razon: %s]", admin, name, tmp2);
        AdminMessageToAdmins(playerid,COLOR_GRIS, str);
        printf("[NOTICIA] Usuario %s Baneado Por %s Razón: %s",name, admin, tmp2);
        format(str, sizeof(str), "%s Baneado Por el miembro del staff %s, [Razón: %s] \n",name, admin, tmp2);
        SaveCMD(playerid, str);
        PlayerInfo[jugador][Banned] = 1;
        return BanSQL(jugador,playerid,tmp2); // Banear
      }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: No puedes usar este comando sobre este jugador");
    }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: El jugador no esta conectado o la id no es correcta");
  }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: No posees el nivel suficiente para usar este comando");
}


dcmd_rzban(playerid, params[]){
  if(PlayerInfo[playerid][nivel] >= 2 || IsPlayerAdmin(playerid)){//restriccion para que solo los admins de nivel 4 o superior puedan usar el comando
    new tmp[256], tmp2[300], Index;//arrays
    tmp = strtok(params, Index);//tomara el 1 valor del comando, es decir la id del jugador
    tmp2 = strrest(params, Index);//tomara el 2 valor del comando, es decir la razon del ban
    if(!strlen(params) || !IsNumeric(tmp))return SendClientMessage(playerid, COLOR_BLANCO, "USO: /ban <playerid> <razón>");//comprobamos que hayan igresado los argumentos, y que la id sea un numero.
    if(!strlen(tmp2))return SendClientMessage(playerid, COLOR_ROJO, "ERROR: Debes ingresar una razón");
    new jugador, name[MAX_PLAYER_NAME],LOLAVISO[256], admin[MAX_PLAYER_NAME], str[128]; //arrays que usaremos para almacenar nombres, la id del jugador y un mensaje
    jugador = strval(tmp);//jugador =valor de tmp es decir la id.
    if(!IsPlayerConnected(jugador)) return SendClientMessage(playerid, COLOR_BLANCO, "Jugador no conectado.");
    if (IsPlayerNPC(jugador)) return SendClientMessage(playerid,red, "ERROR: No expulses a los bots.");
	if(PlayerInfo[jugador][nivel] >= 3 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid,red,"ERROR: No puedes Banear a este Admin Por que no Estas Autorizado Para Banear Admins xD.");
    if(IsPlayerConnected(jugador) || jugador != INVALID_PLAYER_ID){ //restriccion para saber si el jugador que se quiere banear esta conectado o no, y si la id es valida
      if(PlayerInfo[jugador][nivel] < PlayerInfo[playerid][nivel] || !IsPlayerAdmin(jugador)){ //restriccion para saber si el jugador que se quiere banear posee un nivel de admin mayor o es admin RCON
		if(PlayerInfo[jugador][nivel] == 5 && !IsPlayerAdmin(playerid))
		{
		format(LOLAVISO,sizeof(LOLAVISO),"Advertencia El Miembro del staff: %s Intenta Banear a %s.",admin,name);
		AdminMessageToAdmins(playerid,red,LOLAVISO);
		return 0;
		}
		CMDMessageToAdmins(playerid,"BAN");
        GetPlayerName(jugador, name, sizeof(name));
        GetPlayerName(playerid, admin, sizeof(admin));
        format(str, sizeof(str), "{4DFFFF}**{FFFFFF} %s {4DFFFF}ha [R]estringido con RZClient a {FFFFFF}%s {BBC1C1}[Razon: %s]", admin, name, tmp2);
        AdminMessageToAdmins(playerid,COLOR_GRIS, str);
        printf("[NOTICIA] Usuario %s Restringido Por %s Razón: %s",name, admin, tmp2);
        format(str, sizeof(str), "%s Restringido Por el miembro del staff %s, [Razón: %s] \n",name, admin, tmp2);
        SaveCMD(playerid, str);
        return RZCBanSQL(jugador,playerid,tmp2); // Banear
      }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: No puedes usar este comando sobre este jugador");
    }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: El jugador no esta conectado o la id no es correcta");
  }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: No posees el nivel suficiente para usar este comando");
}

dcmd_uban(playerid, params[]){
  if(IsPlayerAdmin(playerid)){
    new tmp[256], tmp2[256], Index;
    tmp = strtok(params, Index);
    tmp2 = strrest(params, Index);
    if(!strlen(params) || !IsNumeric(tmp))return SendClientMessage(playerid, COLOR_BLANCO, "USO: /uban <playerid> <razón> | Elimina la cuenta de un usuario de la base de datos.");
    if(!strlen(tmp2))return SendClientMessage(playerid, COLOR_ROJO, "ERROR: Debes ingresar una razón");
    new jugador, name[MAX_PLAYER_NAME],admin[MAX_PLAYER_NAME], str[300];
    jugador = strval(tmp);
    if(!IsPlayerConnected(jugador)) return SendClientMessage(playerid, COLOR_BLANCO, "Jugador no conectado.");
    if (IsPlayerNPC(jugador)) return SendClientMessage(playerid,red, "ERROR: No expulses a los bots.");
    if(IsPlayerConnected(jugador) || jugador != INVALID_PLAYER_ID){
      if(PlayerInfo[jugador][nivel] < PlayerInfo[playerid][nivel] || !IsPlayerAdmin(jugador)){
		CMDMessageToAdmins(playerid,"BAN");
        GetPlayerName(jugador, name, sizeof(name));
        GetPlayerName(playerid, admin, sizeof(admin));
        format(str, sizeof(str), "{4DFFFF}**{FFFFFF} %s {4DFFFF}ha [E]liminado La Cuenta de {FFFFFF}%s {BBC1C1}[Razon: %s]", admin, name, tmp2);
        AdminMessageToAdmins(playerid,COLOR_GRIS, str);
        printf("[U-BAN]: Usuario %s Eliminado de la DB Por %s[%d] Razón: %s",name, admin,playerid, tmp2);
        format(str, sizeof(str), "%s Eliminado de la DB Por %s, [Razón: %s] \n",name, admin, tmp2);
        SaveCMD(playerid, str);
		new DeleteAccount[100];
		format(DeleteAccount, sizeof(DeleteAccount), "DELETE FROM Usuarios WHERE Username='%s'",name);
		db_query(DataBase_USERS,DeleteAccount);
        PlayerInfo[jugador][Banned] = 1;
        return BanEx(jugador,tmp2); // Banear
      }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: No puedes usar este comando sobre este jugador");
    }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: El jugador no esta conectado o la id no es correcta");
  }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: No posees el nivel suficiente para usar este comando");
}

dcmd_callar(playerid, params[]){
  if(PlayerInfo[playerid][nivel] >= 1 || IsPlayerAdmin(playerid)){
    new tmp[256], tmp2[256], Index;
    tmp = strtok(params, Index);
    tmp2 = strrest(params, Index);
    if(!strlen(params) || !IsNumeric(tmp))return SendClientMessage(playerid, COLOR_BLANCO, "USO: /callar <playerid> opcional <razón>");
    new jugador, name[MAX_PLAYER_NAME], admin[MAX_PLAYER_NAME], str[300];
    jugador = strval(tmp);
	if(IsPlayerAdmin(jugador)) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ]{FFFFFF} NO Autorizado.");
    if(IsPlayerConnected(jugador) || jugador != INVALID_PLAYER_ID){
      if(PlayerInfo[jugador][nivel] < PlayerInfo[playerid][nivel] || !IsPlayerAdmin(jugador)){
        GetPlayerName(jugador, name, sizeof(name));
        GetPlayerName(playerid, admin, sizeof(admin));
        if(PlayerInfo[jugador][callado] == 0){
          if(!strlen(tmp2)){
            format(str, sizeof(str), "{4DFFFF}El Administrador {ffffff}%s{4DFFFF} ha callado a {ffffff}%s.", admin, name);
          }else{
            format(str, sizeof(str), "{4DFFFF}El Administrador {ffffff}%s{4DFFFF} ha callado a {ffffff}%s. {4DFFFF}[Razón: %s]", admin, name, tmp2);
          }
          AdminMessageToAdmins(playerid,COLOR_GRIS, str);
          CMDMessageToAdmins(playerid,"CALLAR");
          return PlayerInfo[jugador][callado] = 1;
        }
        else{
          format(str, sizeof(str), "{4DFFFF}El Administrador {ffffff}%s{4DFFFF} Quita la silenciacion de {ffffff}%s.", admin, name);
          PlayerInfo[jugador][callado] = 0;
          return AdminMessageToAdmins(playerid,COLOR_GRIS, str);
        }
      }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: No puedes usar este comando sobre este jugador");
    }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: El jugador no esta conectado o la id no es correcta");
  }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: No posees el nivel suficiente para usar este comando");
}
dcmd_rban(playerid,params[]) {
		if(PlayerInfo[playerid][nivel] >= 5) {
			new ip[128], tmp[256],LOLAVISO[256], tmp2[256], Index;		tmp = strtok(params,Index), tmp2 = strrest(params,Index);
		    if(!strlen(params)) return SendClientMessage(playerid, red, "Use: /rban [Jugador] [Razon]");
			if(!strlen(tmp2)) return SendClientMessage(playerid, red, "ERROR: Debe tener una Razon");
	    	new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME],string2[300];
			player1 = strval(tmp);
    		if(!IsPlayerConnected(player1)) return SendClientMessage(playerid, COLOR_BLANCO, "Jugador no conectado.");
    		if (IsPlayerNPC(player1)) return SendClientMessage(playerid,red, "ERROR: No expulses a los bots.");
			if(PlayerInfo[player1][nivel] >= 3 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid,red,"ERROR: No puedes Banear a este Admin Por que no Estas Autorizado Para Banear Admins xD.");
		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid) {
				GetPlayerName(player1, playername, sizeof(playername)); GetPlayerName(playerid, adminname, sizeof(adminname));
				if(PlayerInfo[player1][nivel] == 5 && IsPlayerAdmin(playerid))
				{
				format(LOLAVISO,sizeof(LOLAVISO),"Advertencia Mimebro del Staff %s Intenta Banear a %s.",adminname,playername);
				AdminMessageToAdmins(playerid,red,LOLAVISO);
				return 0;
				}
				new year,month,day,hour,minuite,second; getdate(year, month, day); gettime(hour,minuite,second);
				CMDMessageToAdmins(playerid,"rBan");
				new string[256];
				format(string,sizeof(string),"{ffffff}%s {4DFFFF}Ha sido [R]Baneado Por '{ffffff}%s{4DFFFF}' {ffffff}[Razon: %s]",playername,adminname,tmp2);
				format(string2,sizeof(string2),"%s [R]Baneado Por %s [Razon: %s]\n",playername,adminname,tmp2);
				AdminMessageToAdmins(playerid,red,string);
				print(string);
				GetPlayerIp(player1,ip,sizeof(ip));
	            strdel(ip,strlen(ip)-4,strlen(ip));
    	        format(ip,128,"%s**",ip);
				format(ip,128,"banip %s",ip);
            	PlayerInfo[player1][Banned] = 1;
            	printf("[NOTICIA] Usuario %s [R]Baneado Por %s Razón: %s",playername,adminname,tmp2);
            	SaveCMD(playerid, string2);
				BanSQL(player1,playerid,tmp2); // Banear
				return SendRconCommand(ip);
			} else return SendClientMessage(playerid, red, "Necesitas ser Administrador level 5 para usar este comando");
		} else return SendClientMessage(playerid,red,"ERROR: Jugador no conectado o eres tu mismo.");
}


dcmd_lcar(playerid,params[]) {
	#pragma unused params
	if(IsPlayerAdmin(playerid)) {
		if (!IsPlayerInAnyVehicle(playerid)) {
		    if(IsPlayerNearDynamicDoor(playerid,XMasDomo,150.0) && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1, "NO SE PUEDE EJECUTAR ESTE COMANDO AQUI.");
			CrearVehiculo(playerid,451);
			CMDMessageToAdmins(playerid,"LCAR");
			return SendClientMessage(playerid,blue,"Disfruta tu nuevo auto!");
		} else return SendClientMessage(playerid,red,"ERROR: Ya estas en un vehiculo!");
	} else return SendClientMessage(playerid,red,"ERROR: Requiere RCON.");
}

dcmd_slap(playerid,params[]) {
		if(PlayerInfo[playerid][nivel] >= 3) {
		    new tmp[256], tmp2[256], tmp3[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index); tmp3 = strtok(params,Index);
		    if(!strlen(params)) return SendClientMessage(playerid, red, "USO: /slap [playerid] [razon]");
	    	new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME];
			player1 = strval(tmp);
            new string[256];
		    if(!IsPlayerConnected(player1)) return SendClientMessage(playerid, COLOR_BLANCO, "Jugador no conectado.");
		    if(!IsPlayerAdmin(playerid) && IsPlayerAdmin(player1)) return SendClientMessage(playerid, COLOR_DE_ERROR, "ERROR: NO PUEDES UTILIZAR ESTE COMANDO EN EL DIOS DEL SERVER XD.");
		    if (IsPlayerNPC(player1)) return SendClientMessage(playerid,red, "ERROR: el id es un npc.");
		 	//if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && (PlayerInfo[player1][nivel] != ServerInfo[MaxAdminLevel]) ) {
				GetPlayerName(player1, playername, sizeof(playername));		GetPlayerName(playerid, adminname, sizeof(adminname));
				CMDMessageToAdmins(playerid,"SLAP");
		        new Float:Health, Float:x, Float:y, Float:z; GetPlayerHealth(player1,Health); SetPlayerHealth(player1,Health-25);
				GetPlayerPos(player1,x,y,z); SetPlayerPos(player1,x,y,z+5); PlayerPlaySound(playerid,1190,0.0,0.0,0.0); PlayerPlaySound(player1,1190,0.0,0.0,0.0);
				if(strlen(tmp2)) {
					format(string,sizeof(string),"Fuiste golpeado por el administrador %s  Razon: %s ",adminname,params[2]);	SendClientMessage(player1,red,string);
					format(string,sizeof(string),"You have slapped %s %s ",playername,params[2]); return SendClientMessage(playerid,blue,string);
				} else {
					format(string,sizeof(string),"Fuiste golpeado por el admnistrador: %s ",adminname);	SendClientMessage(player1,red,string);
					format(string,sizeof(string),"Golpeaste a: %s",playername); return SendClientMessage(playerid,blue,string); }
			} else return SendClientMessage(playerid, red, "El Jugador No Esta Conectado! or is the highest level admin");
		//} else return SendClientMessage(playerid,red,"ERROR: Tu No Tienes El Lvl Suficiente Para Usar Este Comando!");
}


dcmd_gcardb(playerid,params[]) {
		#pragma unused params
        if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,COLOR_ROJO,"no estas en un vehiculo.");
        new vID = GetPlayerVehicleID(playerid);
        SaveSQLVehicle(vID);
		SendClientMessage(playerid,COLOR_ARTICULO,"Success: El vehiculo ha sido insertado en la base de datos y estará listo en el proximo reinicio.");
        return 1;
}

dcmd_car2(playerid,params[]) {
    if(PlayerInfo[playerid][InCORE] == 1 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, red, ">> No puede utilizar este comando en el nucleo.");
	if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][nivel] >= 6) {
	    new tmp[256], tmp2[256], tmp3[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index); tmp3 = strtok(params,Index);
	    if(!strlen(tmp)) return SendClientMessage(playerid, red, "USE: /car2 [modelo u nombre] |No Abuse!|");
		new car, colour1, colour2;
		new string[256];
   		if(!IsNumeric(tmp)) car = GetVehicleModelIDFromName(tmp); else car = strval(tmp);
		if(car < 400 || car > 611) return  SendClientMessage(playerid, red, "ERROR: Modelo de vehiculo invalido");
		if(!strlen(tmp2)) colour1 = random(126); else colour1 = strval(tmp2);
		if(!strlen(tmp3)) colour2 = random(126); else colour2 = strval(tmp3);
		new LVehicleID,Float:X,Float:Y,Float:Z, Float:Angle,int1;	GetPlayerPos(playerid, X,Y,Z);	GetPlayerFacingAngle(playerid,Angle);   int1 = GetPlayerInterior(playerid);
		LVehicleID = CreateVehicle(car, X+3,Y,Z, Angle, colour1, colour2, -1); LinkVehicleToInterior(LVehicleID,int1);
		//PutPlayerInVehicle(playerid,LVehicleID,0);
		format(string, sizeof(string), "Has aparecido un \"%s\" (Modelo:%d) color (%d, %d)", VehicleNames[car-400], car, colour1, colour2);
		return SendClientMessage(playerid,blue, string);
	} else return SendClientMessage(playerid,red,"ERROR: Requiere RCON.");
}


dcmd_car(playerid,params[]) {
    if(PlayerInfo[playerid][InCORE] == 1 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, red, ">> No puede utilizar este comando en el nucleo.");
	if(IsPlayerAdmin(playerid)) {
	    new tmp[256], tmp2[256], tmp3[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index); tmp3 = strtok(params,Index);
	    if(!strlen(tmp)) return SendClientMessage(playerid, red, "Uso correcto: {ffffff}/car [modelo u nombre] [color1] [color2]");
	    if(IsPlayerNearDynamicDoor(playerid,XMasDomo,150.0) && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1, "NO SE PUEDE EJECUTAR ESTE COMANDO AQUI.");
		new car, colour1, colour2;
		new string[256];
   		if(!IsNumeric(tmp)) car = GetVehicleModelIDFromName(tmp); else car = strval(tmp);
		if(car < 400 || car > 611) return  SendClientMessage(playerid, red, "ERROR: Modelo de vehiculo invalido");
		if(car == 432 && PlayerInfo[playerid][nivel] <= 4
		|| car == 520 && PlayerInfo[playerid][nivel] <= 4
		|| car == 425 && PlayerInfo[playerid][nivel] <= 4) return  SendClientMessage(playerid, red, "Este vehiculo fue excluido del comando por reiterados abusos de la administracion.");
		if(!strlen(tmp2)) colour1 = random(126); else colour1 = strval(tmp2);
		if(!strlen(tmp3)) colour2 = random(126); else colour2 = strval(tmp3);
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		RemovePlayerFromVehicle(playerid);
		new LVehicleID,Float:X,Float:Y,Float:Z, Float:Angle,int1;	GetPlayerPos(playerid, X,Y,Z);	GetPlayerFacingAngle(playerid,Angle);   int1 = GetPlayerInterior(playerid);
		LVehicleID = CreateVehicle(car, X+3,Y,Z, Angle, colour1, colour2, -1); LinkVehicleToInterior(LVehicleID,int1);
		PlayerInfo[playerid][pCar] = LVehicleID;
		PutPlayerInVehicle(playerid,LVehicleID,0);
		format(string, sizeof(string), "%s (Modelo:%d) Color (%d, %d) Spawneado.", VehicleNames[car-400], car, colour1, colour2);
		return SendClientMessage(playerid,-1, string);
	} else return SendClientMessage(playerid,red,"ERROR: Requiere RCON.");
}

dcmd_spec(playerid,params[]) {
    if(PlayerInfo[playerid][nivel] >= 1 || IsPlayerAdmin(playerid)) {
	    if(!strlen(params) || !IsNumeric(params)) return SendClientMessage(playerid, red, "USAGE: /spec [playerid]");
		new JugadorEspiado = strval(params);
		if(!IsPlayerAdmin(playerid) && IsPlayerAdmin(JugadorEspiado)) return SendClientMessage(playerid, COLOR_DE_ERROR, "ERROR: NO PUEDES UTILIZAR ESTE COMANDO EN EL DIOS DEL SERVER XD.");
        if(IsPlayerConnected(JugadorEspiado) && JugadorEspiado != INVALID_PLAYER_ID) {
			if(JugadorEspiado == playerid) return SendClientMessage(playerid, red, "ERROR: No puedes spectarte tu xD.");
			if(GetPlayerState(JugadorEspiado) == PLAYER_STATE_SPECTATING && PlayerInfo[JugadorEspiado][SpecID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, red, "Spectate: El jugador esta espectando a otro jugador.");
			if(GetPlayerState(JugadorEspiado) != 1 && GetPlayerState(JugadorEspiado) != 2 && GetPlayerState(JugadorEspiado) != 3) return SendClientMessage(playerid, red, "Spectate: Jugador no Spawneado.");
			StartSpectate(playerid, JugadorEspiado);
			CMDMessageToAdmins(playerid,"SPEC");
			return SendClientMessage(playerid,blue,"Ahora Estas Espectando.");
		} else return SendClientMessage(playerid,red,"ERROR: Player No concetado");
	} else return SendClientMessage(playerid,red,"ERROR: Usted Nesesita Ser level 2 Para usar este Comando");
}
dcmd_specoff(playerid,params[]) {
	#pragma unused params
    if(PlayerInfo[playerid][nivel] >= 1 || IsPlayerAdmin(playerid)) {
        if(PlayerInfo[playerid][SpecType] != ADMIN_SPEC_TYPE_NONE) {
			StopSpectate(playerid);
			CMDMessageToAdmins(playerid,"SPECOFF");
			return SendClientMessage(playerid,blue,"No estas en modo espectador");
		} else return SendClientMessage(playerid,red,"ERROR: No etas spectado");
	} else return SendClientMessage(playerid,red,"ERROR: Usted Nesesita Ser level 2 Para usar este Comando");
}


dcmd_spawnall(playerid,params[]) {
    #pragma unused params
	if(IsPlayerAdmin(playerid)) {
		CMDMessageToAdmins(playerid,"SPAWNAll");
	   	for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && (i != playerid) && !IsPlayerNPC(i)) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); SetPlayerPos(i, 0.0, 0.0, 0.0); SpawnPlayer(i);
			}
		}
		new string[256];
		format(string,sizeof(string),"{4DFFFF}El Administrador {ffffff}%s{4DFFFF} Reiniciado {ffffff}Todos los jugadores.", pName(playerid) );
		return PlayerMessageToPlayers(playerid, yellow, string);
	} else return SendClientMessage(playerid,red,"ERROR: Requiere RCON.");
}

dcmd_spawnallnpc(playerid,params[]) {
    #pragma unused params
	if(IsPlayerAdmin(playerid)) {
		CMDMessageToAdmins(playerid,"SPAWNAllNPC");
	   	for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && (i != playerid) && IsZombieNPC(i)) {
			    SetPlayerVirtualWorld(i,0);
				//FCNPC_Stop(i);
				FCNPC_SetPosition(i, NULL_X, NULL_Y, NULL_Z);
    			//KillTimer(Attack[i]);
                RespawnearBOT(i);
			}
		}
		new string[256];
		format(string,sizeof(string),"{4DFFFF}El Administrador {ffffff}%s{4DFFFF} Reinicio {ffffff}Todos los ZOMBIE BOT.", pName(playerid) );
		return PlayerMessageToPlayers(playerid, yellow, string);
	} else return SendClientMessage(playerid,red,"ERROR: Requiere RCON.");
}

dcmd_spawn(playerid,params[]) {
	if(PlayerInfo[playerid][nivel] >= 1) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, "USE: /spawn [jugador]");
		new player1 = strval(params);
    if(!IsPlayerConnected(player1)) return SendClientMessage(playerid, COLOR_BLANCO, "Jugador no conectado.");
    //if (IsDroneBOT(player1)) return SendClientMessage(playerid,red, "ERROR: No puedes utilizar este comando con este bot.");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SPAWN");
			new string[256];
			format(string, sizeof(string), "Has reiniciado a \"%s\" ", pName(player1)); SendClientMessage(playerid,blue,string);
			if(player1 != playerid) { format(string,sizeof(string),"{4DFFFF}El Administrador {ffffff}%s{4DFFFF} Te reinicio, si esto es un abuso {F50000}REPORTALO.", pName(playerid)); SendClientMessage(player1,red,string); }
			if(IsZombieNPC(player1)) { /*FCNPC_Stop(player1);*/ FCNPC_SetPosition(player1, NULL_X, NULL_Y, NULL_Z); //KillTimer(Attack[player1]);
			return RespawnearBOT(player1);
			}else return SpawnPlayer(player1);
	    } else return SendClientMessage(playerid,red,"ERROR: El jugador no esta conectado");
	} else return SendClientMessage(playerid,red,"ERROR: Necesitas ser Administrador level 2 para usar este comando");
}
dcmd_descar(playerid,params[]) {
	#pragma unused params
	//if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_BLANCO, "comando desactivado.");
    //return SendClientMessage(playerid, COLOR_BLANCO, "comando desactivado.");
    if(GetPlayerVehicleSeat(playerid) != 0 || GetPlayerVehicleSeat(playerid) == 128) return SendClientMessage(playerid,red,"ERROR: Para eliminar el vehiculo debes estar en el asiento del conductor.");
	else if(PlayerInfo[playerid][nivel] >= 3||IsPlayerAdmin(playerid)) return EraseVehicle(GetPlayerVehicleID(playerid));
	else return SendClientMessage(playerid,red,"ERROR: Acceso denegado, solo admin nivel 3 o rcon.");
}
dcmd_rescars(playerid,params[])
{
	#pragma unused params
	if(PlayerInfo[playerid][nivel] >= 3||IsPlayerAdmin(playerid))
	{
        CMDMessageToAdmins(playerid,"ReScars");
		SendClientMessage(playerid, green, "|- Has respawneado todos los vehiculos! -|");
		GameTextForAll("~n~~n~~n~~n~~n~~n~~r~Vehiculos: ~w~Reiniciados", 3000,3);

		for(new cars=0; cars<MAX_VEHICLES; cars++)
		{
			if(!VehicleOccupied(cars))
			{
				SetVehicleToRespawn(cars);
			}
		}
		return 1;
	}
	else return SendClientMessage(playerid,red,"ERROR: Acceso denegado, solo admin nivel 3 o rcon.");
}
dcmd_setallweather(playerid,params[]) {
	if(PlayerInfo[playerid][nivel] >= 2) {
		if(!strlen(params)) return SendClientMessage(playerid, red, "USAGE: /setallweather [weather ID]");
		new var = strval(params);
		//if(var > 20 && var != 32) return SendClientMessage(playerid, red, "No puedes poner un weather mayor a 20 por que el reloj se puede bugear.");
       	CMDMessageToAdmins(playerid,"SETALLWEATHER");
       	//SetWeather(var);
       	Clima = var;
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i)) {
				//PlayerPlaySound(i,1057,0.0,0.0,0.0);
				if(PlayerInfo[i][ZonaInfectada] != 1){
					SetPlayerWeather(i, var);
				}
			}
		}
		new string[256];
		format(string,sizeof(string),"{4DFFFF}El Administrador {ffffff}%s{4DFFFF} Cambio el Clima, {ffffff}%d.", pName(playerid), var );
		return PlayerMessageToPlayers(playerid, blue, string);
	} else return SendClientMessage(playerid,red,"ERROR: You are not a high enough level to use this command");
}

dcmd_setalltime(playerid,params[]) {
	if(PlayerInfo[playerid][nivel] >= 2) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, "USAGE: /setalltime [hora]");
		new var = strval(params);
		if(var > 24) return SendClientMessage(playerid, red, "ERROR: hora invalida");
       	CMDMessageToAdmins(playerid,"SETALLTIME");
       	//SetWorldTime(var);
		Hora = var;
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i)) {
				//PlayerPlaySound(i,1057,0.0,0.0,0.0);
				if(PlayerInfo[i][ZonaInfectada] != 1){
					SetPlayerTime(i, var, 0);
				}
			}
		}
		new string[256];
		format(string,sizeof(string),"{4DFFFF}El Administrador {ffffff}%s{4DFFFF} ha cambiado la hora a {ffffff}%d:00.", pName(playerid), var );
		return PlayerMessageToPlayers(playerid, blue, string);
	} else return SendClientMessage(playerid,red,"ERROR: You are not a high enough level to use this command");
}

dcmd_setizlink(playerid,params[])
{
    if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,red,"ERROR: Necesitas ser rcon para utilizar este comando.");

		if(!strlen(params)) return SendClientMessage(playerid, red, "[-] Usa: /setizlink [ http link | off ]");
        if(strlen(params[0]) >= sizeof(InfectedZoneMusic[MP3])) return SendClientMessage(playerid,ADMIN_COLOR, "El link es demasiado largo.");

		if(strcmp("off", params[0], true, strlen(params[0])) == 0)
		{
  			InfectedZoneMusic[Enabled] = 0;
  			SendClientMessage(playerid, red, "[IZ]::Disable {ffffff}Infected Zone Song disabled.");
		    return 1;
		}

        //strmid(InfectedZoneMusic[MP3], params[0], 0, strlen(params[0]), sizeof(InfectedZoneMusic[MP3]));

        memcpy(InfectedZoneMusic[MP3], params[0], 0, strlen(params[0]) * 4, sizeof(InfectedZoneMusic[MP3]));

        InfectedZoneMusic[Enabled] = 1;
	 	//PlayAudioStreamForPlayerEx(playerid, InfectedZoneMusic[MP3]);
	 	SendFormatMessage(playerid, red, "[IZ]::Set(%d-%d) {ffffff}%s", strlen(params[0]), strlen(InfectedZoneMusic[MP3]), InfectedZoneMusic[MP3]);
		return 1;
}


dcmd_izhud(playerid,params[])
{
	#pragma unused params
    if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,red,"ERROR: Necesitas ser rcon para utilizar este comando.");
		if(IZ_HIDE_HUD == 1)
		{
  			IZ_HIDE_HUD = 0;
			for(new i = 0; i < GetMaxPlayers(); i++)
			{
				if(IsPlayerConnected(i))
				{
					//PlayerPlaySound(i,1057,0.0,0.0,0.0);
					if(PlayerInfo[i][ZonaInfectada] == 1){
						TogglePlayerHUD(true, i);
					}
				}
			}
  			SendClientMessage(playerid, red, "[IZ]::Disabled {ffffff}Widescreen disabled for the infected zones.");
		    return 1;
		}
		IZ_HIDE_HUD = 1;
			for(new i = 0; i < GetMaxPlayers(); i++)
			{
				if(IsPlayerConnected(i))
				{
					//PlayerPlaySound(i,1057,0.0,0.0,0.0);
					if(PlayerInfo[i][ZonaInfectada] == 1){
						TogglePlayerHUD(false, i);
					}
				}
			}
		SendClientMessage(playerid, red, "[IZ]::Enabled {ffffff}Widescreen enabled for the infected zones.");
		return 1;
}

dcmd_setizzombies(playerid,params[]) {
	if(IsPlayerAdmin(playerid)) {
		if(!strlen(params)) return SendClientMessage(playerid, red, "USAGE: /setizzombies [max zombies por jugador]");
		new var = strval(params);
		if(var > 15 || var <= 0) return SendClientMessage(playerid, red, "No se permiten mas de 15 zombies por jugador, ni cero.");
       	CMDMessageToAdmins(playerid,"SETIZZOMBIES");
       	IZ_Zombies = var;
		for(new i = 0; i < GetMaxPlayers(); i++)
		{
			if(IsPlayerConnected(i))
			{
				//PlayerPlaySound(i,1057,0.0,0.0,0.0);
				if(PlayerInfo[i][ZonaInfectada] == 1){
					PlayerInfo[i][MAX_PLAYER_ZOMBIES] = IZ_Zombies;
				}
			}
		}
		new string[256];
		format(string,sizeof(string),"* %s{4DFFFF} cambio la cantidad de zombies por jugador en la zona infectada, {ffffff}%d.", pName(playerid), IZ_Zombies );
		return PlayerMessageToPlayers(playerid, -1, string);
	} else return SendClientMessage(playerid,red,"ERROR: You are not a high enough level to use this command");
}



dcmd_setzombies(playerid,params[]) {
	if(IsPlayerAdmin(playerid)) {
		if(!strlen(params)) return SendClientMessage(playerid, red, "USAGE: /setzombies [max zombies por jugador]");
		new var = strval(params);
		if(var > 15 || var <= 0) return SendClientMessage(playerid, red, "No se permiten mas de 15 zombies por jugador, ni cero.");
       	CMDMessageToAdmins(playerid,"SETZOMBIES");
       	ZOMBIES_SPAWN_LIMIT = var;
		for(new i = 0; i < GetMaxPlayers(); i++)
		{
			if(IsPlayerConnected(i))
			{
				PlayerInfo[i][MAX_PLAYER_ZOMBIES] = ZOMBIES_SPAWN_LIMIT;
			}
		}
		new string[256];
		format(string,sizeof(string),"* %s{4DFFFF} cambio la cantidad de zombies por jugador, {ffffff}%d zombies.", pName(playerid), ZOMBIES_SPAWN_LIMIT );
		return PlayerMessageToPlayers(playerid, -1, string);
	} else return SendClientMessage(playerid,red,"ERROR: You are not a high enough level to use this command");
}

dcmd_setzspawntime(playerid,params[]) {
	if(IsPlayerAdmin(playerid)) {
		if(!strlen(params)) return SendClientMessage(playerid, red, "USAGE: /setzspawntime [seconds]");
		new var = strval(params);
		if(var > 600 && var <= 0) return SendClientMessage(playerid, red, "No se permite menos de 1 segundo o más de 600 segundos (10 minutos).");
       	CMDMessageToAdmins(playerid,"SETZSPAWNTIME");
       	ZOMBIES_SPAWN_TIME = var * 1000;
		for(new i = 0; i < GetMaxPlayers(); i++)
		{
			if(IsPlayerConnected(i))
			{
				    PlayerInfo[i][ZombieSpawnerTime] = ZOMBIES_SPAWN_TIME;
					PlayerInfo[i][ZombieSpawnerTick] = GetTickCount();
			}
		}
		new string[256];
		format(string,sizeof(string),"* %s{4DFFFF} cambio el tiempo de respawn de los zombies, {ffffff}%d segundos.", pName(playerid), ZOMBIES_SPAWN_TIME / 1000 );
		return PlayerMessageToPlayers(playerid, -1, string);
	} else return SendClientMessage(playerid,red,"ERROR: You are not a high enough level to use this command");
}


dcmd_setzspawnrange(playerid,params[]) {
	if(IsPlayerAdmin(playerid)) {
		if(!strlen(params)) return SendClientMessage(playerid, red, "USAGE: /setzspawnrange [distance]");
		new Float:var = floatround(floatstr(params));
		if(var >= ZombieVisionDistance) return SendFormatMessage(playerid, red, "No se permite una distancia de spawn mayor o igual que la visión del zombie(%.02f).", ZombieVisionDistance);
       	CMDMessageToAdmins(playerid,"SETZSPAWNRANGE");
       	ZombieSpawnerDistance = var;
		new string[256];
		format(string,sizeof(string),"* %s{4DFFFF} cambio la distancia de spawn de los zombies, {ffffff}%.02f metros.", pName(playerid), ZombieSpawnerDistance);
		return PlayerMessageToPlayers(playerid, -1, string);
	} else return SendClientMessage(playerid,red,"ERROR: You are not a high enough level to use this command");
}

dcmd_setzvision(playerid,params[]) {
	if(IsPlayerAdmin(playerid)) {
		if(!strlen(params)) return SendClientMessage(playerid, red, "USAGE: /setzvision [distance]");
		new Float:var = floatstr(params);
		if(var < ZombieSpawnerDistance) return SendFormatMessage(playerid, red, "No se permite una distancia de vision menor que la distancia de spawn (%.02f).", ZombieSpawnerDistance);
       	CMDMessageToAdmins(playerid,"SETZVISION");
       	ZombieVisionDistance = var;
		new string[256];
		format(string,sizeof(string),"* %s{4DFFFF} cambio la capacidad de visión de los zombies, {ffffff}%.02f metros.", pName(playerid), ZombieVisionDistance);
		return PlayerMessageToPlayers(playerid, -1, string);
	} else return SendClientMessage(playerid,red,"ERROR: You are not a high enough level to use this command");
}


dcmd_setizspawntime(playerid,params[]) {
	if(IsPlayerAdmin(playerid)) {
		if(!strlen(params)) return SendClientMessage(playerid, red, "USAGE: /setizspawntime [seconds]");
		new var = strval(params);
		if(var > 600 && var <= 0) return SendClientMessage(playerid, red, "No se permite menos de 1 segundo o más de 600 segundos (10 minutos).");
       	CMDMessageToAdmins(playerid,"SETIZSPAWNTIME");
       	IZ_ZombiesRespawnTime = var * 1000;
		for(new i = 0; i < GetMaxPlayers(); i++)
		{
			if(IsPlayerConnected(i))
			{
				//PlayerPlaySound(i,1057,0.0,0.0,0.0);
				if(PlayerInfo[i][ZonaInfectada] == 1){
				    PlayerInfo[i][ZombieSpawnerTime] = IZ_ZombiesRespawnTime;
					PlayerInfo[i][ZombieSpawnerTick] = GetTickCount();
				}
			}
		}
		new string[256];
		format(string,sizeof(string),"* %s{4DFFFF} cambio el tiempo de respawn en la zona infectada, {ffffff}%d segundos.", pName(playerid), IZ_ZombiesRespawnTime / 1000 );
		return PlayerMessageToPlayers(playerid, -1, string);
	} else return SendClientMessage(playerid,red,"ERROR: You are not a high enough level to use this command");
}

dcmd_setizweather(playerid,params[]) {
	if(PlayerInfo[playerid][nivel] >= 2) {
		if(!strlen(params)) return SendClientMessage(playerid, red, "USAGE: /setizweather [weather ID]");
		new var = strval(params);
		//if(var > 20 && var != 32) return SendClientMessage(playerid, red, "No puedes poner un weather mayor a 20 por que el reloj se puede bugear.");
       	//CMDMessageToAdmins(playerid,"SETALLWEATHER");
       	IZ_Weather = var;
		for(new i = 0; i < GetMaxPlayers(); i++)
		{
			if(IsPlayerConnected(i))
			{
				//PlayerPlaySound(i,1057,0.0,0.0,0.0);
				if(PlayerInfo[i][ZonaInfectada] == 1){
					SetPlayerWeather(i, var);
				}
			}
		}
		new string[256];
		format(string,sizeof(string),"{4DFFFF}El moderador {ffffff}%s{4DFFFF} cambio el clima de las zonas infectadas, {ffffff}%d.", pName(playerid), var );
		return PlayerMessageToPlayers(playerid, blue, string);
	} else return SendClientMessage(playerid,red,"ERROR: You are not a high enough level to use this command");
}

dcmd_setizhour(playerid,params[]) {
	if(PlayerInfo[playerid][nivel] >= 2) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, "USAGE: /setizhour [hora]");
		new var = strval(params);
		if(var > 24) return SendClientMessage(playerid, red, "ERROR: hora invalida");
       	//CMDMessageToAdmins(playerid,"SETALLTIME");
		IZ_Hour = var;
		for(new i = 0; i < GetMaxPlayers(); i++)
		{
			if(IsPlayerConnected(i))
			{
				if(PlayerInfo[i][ZonaInfectada] == 1){
					SetPlayerTime(i, var, 0);
				}
			}
		}
		new string[256];
		format(string,sizeof(string),"{4DFFFF}El moderador {ffffff}%s{4DFFFF} cambio la hora de las zonas infectadas, {ffffff}%d:00.", pName(playerid), var );
		return PlayerMessageToPlayers(playerid, blue, string);
	} else return SendClientMessage(playerid,red,"ERROR: You are not a high enough level to use this command");
}

dcmd_kickall(playerid,params[]) {
    #pragma unused params
	if (IsPlayerAdmin(playerid)) {
		CMDMessageToAdmins(playerid,"KICKALL");
	   	for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && (i != playerid) && !IsPlayerNPC(i)) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0);
				CallLocalFunction("OnPlayerCommandText", "is", i, "/gc");
				Kick(i);
			}
		}
		new string[256];
		format(string,sizeof(string),"{4DFFFF}**{FFFFFF} %s {4DFFFF}ha [E]xpusaldo a {FFFFFF}Todos los Jugadores.", pName(playerid) );
		return PlayerMessageToPlayers(playerid, blue, string);
	} else return SendClientMessage(playerid,red,"ERROR: NO Autorizado.");
}




dcmd_naturecontrol(playerid,params[]) {
    #pragma unused params
	if (IsPlayerAdmin(playerid)) {
	    if(AmbianceThemes == true)
	    {
		CMDMessageToAdmins(playerid,"naturecontrol");
		AmbianceThemes = false;
		new string[256];
		format(string,sizeof(string),"{4DFFFF}**{FFFFFF} %s {4DFFFF}ha desactivado {FFFFFF}sonidos de ambiente.", pName(playerid) );
		return PlayerMessageToPlayers(playerid, blue, string);
		}
		else
		{
		CMDMessageToAdmins(playerid,"naturecontrol");
		AmbianceThemes = true;
		new string[256];
		format(string,sizeof(string),"{4DFFFF}**{FFFFFF} %s {4DFFFF}ha activado {FFFFFF}sonidos de ambiente.", pName(playerid) );
		return PlayerMessageToPlayers(playerid, blue, string);
		}
	} else return SendClientMessage(playerid,red,"Acceso denegado.");
}

dcmd_muteserver(playerid,params[]) {
    #pragma unused params
	if (IsPlayerAdmin(playerid)) {
	    if(SinCHAT == 0)
	    {
		CMDMessageToAdmins(playerid,"SILENCIO PUTOS");
		SinCHAT = 1;
		new string[256];
		format(string,sizeof(string),"{4DFFFF}**{FFFFFF} %s {4DFFFF}ha [C]allado a {FFFFFF}Todos los Jugadores.", pName(playerid) );
		return PlayerMessageToPlayers(playerid, blue, string);
		}
		else
		{
		CMDMessageToAdmins(playerid,"ESCRIBAN PUTOS");
		SinCHAT = 0;
		new string[256];
		format(string,sizeof(string),"{4DFFFF}**{FFFFFF} %s {4DFFFF}ha [P]ermitido escribir a {FFFFFF}Todos los Jugadores.", pName(playerid) );
		return PlayerMessageToPlayers(playerid, blue, string);
		}
	} else return SendClientMessage(playerid,red,"ERROR: NO PUTA NO1!1!!.");
}


dcmd_serverhud(playerid,params[])
{
    #pragma unused params
	if(PlayerInfo[playerid][nivel] >= 2)
	{
	    if(HideServerPlayersHUD == 0)
	    {
			CMDMessageToAdmins(playerid,"ServerHud");
			HideServerPlayersHUD = 1;
			TogglePlayerHUD(false);
			new string[256];
			format(string,sizeof(string),"{4DFFFF}**{FFFFFF} %s {4DFFFF}ha desactivado el {FFFFFF}HUD.", pName(playerid) );
			return PlayerMessageToPlayers(playerid, blue, string);
		}
		else
		{
			CMDMessageToAdmins(playerid,"ServerHud");
			HideServerPlayersHUD = 0;
			TogglePlayerHUD(true);
			new string[256];
			format(string,sizeof(string),"{4DFFFF}**{FFFFFF} %s {4DFFFF}activo el {FFFFFF}HUD.", pName(playerid) );
			return PlayerMessageToPlayers(playerid, blue, string);
		}
	} else return SendClientMessage(playerid,red,"ERROR: Nivel insuficiente, nivel 2 requerido.");
}

dcmd_corecontrol(playerid,params[]) {
    #pragma unused params
	if (IsPlayerAdmin(playerid)) {
	    if(HumanCore[Enabled] == 0)
	    {
		CMDMessageToAdmins(playerid,"CORECONTROL");
		HumanCore[Enabled] = 1;
		HC_Checker();
		new string[256];
		format(string,sizeof(string),"{4DFFFF}**{FFFFFF} %s {4DFFFF}ha [A]activado el minijuego {FFFFFF}Defender al Nucleo.", pName(playerid) );
		return PlayerMessageToPlayers(playerid, blue, string);
		}
		else
		{
		CMDMessageToAdmins(playerid,"CORECONTROL");
		HumanCore[Enabled] = 0;
     	ResetCoreZombies();
    	RemovePlayersFromCore();
	    HumanCore[CoreTick] = -1;
	 	HumanCore[CoreExplosionTick] = -1;
	    HumanCore[STATE] = CORE_FINISHED;
		new string[256];
		format(string,sizeof(string),"{4DFFFF}**{FFFFFF} %s {4DFFFF}ha [D]esactivado el minijuego {FFFFFF}Defender al Nucleo.", pName(playerid) );
		return PlayerMessageToPlayers(playerid, blue, string);
		}
	} else return SendClientMessage(playerid,red,">> error {ffffff}Acceso denegado..");
}

dcmd_kickallnpc(playerid,params[]) {
    #pragma unused params
	if (!IsPlayerAdmin(playerid)) {
		CMDMessageToAdmins(playerid,"KICKALLNPC");
	   	for(new i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && (i != playerid) && IsZombieNPC(i) && !IsDroneBOT(i)) {
				Kick(i);
			}
		}
		new string[256];
		format(string,sizeof(string),"{4DFFFF}**{FFFFFF} %s {4DFFFF}ha [E]xpusaldo a {FFFFFF}Todos los ZOMBIE BOT.", pName(playerid) );
		return PlayerMessageToPlayers(playerid, blue, string);
	} else return SendClientMessage(playerid,red,"ERROR: NO Autorizado.");
}

dcmd_congelar(playerid, params[]){
  if(PlayerInfo[playerid][nivel] >= 1 || IsPlayerAdmin(playerid)){
    new tmp[256], tmp2[256], Index;
    tmp = strtok(params, Index);
    tmp2 = strtok(params, Index);
    if(!strlen(params) || !IsNumeric(tmp))return SendClientMessage(playerid, COLOR_BLANCO, "USO: /congelar <playerid> opcional <razón>");
    new jugador, name[MAX_PLAYER_NAME], admin[MAX_PLAYER_NAME], str[128];
    jugador = strval(tmp);
    if (IsPlayerNPC(jugador)) return SendClientMessage(playerid,red, "ERROR: No puedes congelar a los NPC Bots >:D .");
    if(IsPlayerConnected(jugador) || jugador != INVALID_PLAYER_ID){
      if(PlayerInfo[jugador][nivel] < PlayerInfo[playerid][nivel] || !IsPlayerAdmin(jugador)){
        GetPlayerName(jugador, name, sizeof(name));
        GetPlayerName(playerid, admin, sizeof(admin));
        if(PlayerInfo[jugador][congelado] == 0){
          if(!strlen(tmp2)){
            format(str, sizeof(str), "{4DFFFF}El Administrador {ffffff}%s{4DFFFF} ha Paralizado al Jugador {ffffff}%s.", admin, name);
          }else{
            format(str, sizeof(str), "{4DFFFF}El Administrador {ffffff}%s{4DFFFF} ha Paralizado al Jugador {ffffff}%s {4DFFFF}[Razon: %s].", admin, name, params[2]);
          }
          PlayerMessageToPlayers(playerid, COLOR_GRIS, str);
          PlayerInfo[jugador][congelado] = 1;
          printf("[KICK] Usuario %s Congelado Por %s Razón: %s",admin, name, params[2]);
          return TogglePlayerControllable(jugador, 0);
        }
        else{
          format(str, sizeof(str), "{4DFFFF}El Administrador {ffffff}%s{4DFFFF} ha Desparalizado a {ffffff}%s.", admin, name);
          PlayerMessageToPlayers(playerid, COLOR_GRIS, str);
          PlayerInfo[jugador][congelado] = 0;
          printf("[KICK] Usuario %s DesCongelado Por %s Razón: %s",admin, name, params[2]);
          return TogglePlayerControllable(jugador, 1);
        }
      }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: No puedes usar este comando sobre este jugador");
    }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: El jugador no esta conectado o la id no es correcta");
  }else return SendClientMessage(playerid, COLOR_ROJO, "ERROR: No posees el nivel suficiente para usar este comando");
}

dcmd_cc(playerid,params[])
{
		#pragma unused params
		if(PlayerInfo[playerid][nivel] < 1) return SendClientMessage(playerid, COLOR_ROJO, "ERROR: No posees el nivel suficiente para usar este comando");
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i) == 1) if (PlayerInfo[i][nivel] == 0) SendClientMessage(i, -1, " ");
		}
		new string[256];
		format(string,sizeof(string),"{4DFFFF}El Administrador {ffffff}%s[%d]{4DFFFF} Limpio el chat (EL CHAT NO SE BORRA PARA LOS ADMINS).", pName(playerid),playerid );
        printf("[NOTICIA] Administrador %s[%d] Limpio El chat",PlayerName2(playerid),playerid);
		return AdminMessageToAdmins(playerid,-1,string);
}
dcmd_cca(playerid,params[])
{
		#pragma unused params
		if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_DE_ERROR, "NO WERKO NO!");
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
		    if(i != playerid)
		    {
				SendClientMessageToAll(-1," ");
			}
		}
		new string[256];
		format(string,sizeof(string),"{4DFFFF}El Administrador {ffffff}%s[%d]{4DFFFF} Limpio el chat (EL CHAT NO SE BORRA PARA TI).", pName(playerid),playerid );
        printf("[NOTICIA] RCON %s[%d] Limpio El chat",PlayerName2(playerid),playerid);
		return AdminMessageToAdmins(playerid,-1,string);
}
dcmd_goto(playerid,params[]) {
    if(IsPlayerAdmin(playerid)) {
	    if(!strlen(params)) return SendClientMessage(playerid,red,"USE: /goto [jugador]");
	    new player1;
		if(!IsNumeric(params)) player1 = ReturnPlayerID(params);
	   	else player1 = strval(params);
	    if(IsPlayerNearDynamicDoor(player1,XMasDomo,150.0) && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1, "NO SE PUEDE EJECUTAR ESTE COMANDO.");
		if(!IsPlayerAdmin(playerid) && IsPlayerAdmin(player1)) return SendClientMessage(playerid, COLOR_DE_ERROR, "ERROR: NO PUEDES UTILIZAR ESTE COMANDO EN EL DIOS DEL SERVER XD.");
	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid) {
			CMDMessageToAdmins(playerid,"GOTO");
			new Float:x, Float:y, Float:z;	GetPlayerPos(player1,x,y,z); SetPlayerInterior(playerid,GetPlayerInterior(player1));
			SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(player1));
			if(GetPlayerState(playerid) == 2) {
				SetVehiclePos(GetPlayerVehicleID(playerid),x+3,y,z);	LinkVehicleToInterior(GetPlayerVehicleID(playerid),GetPlayerInterior(player1));
				SetVehicleVirtualWorld(GetPlayerVehicleID(playerid),GetPlayerVirtualWorld(player1));
			} else SetPlayerPos(playerid,x+2,y,z);
			new string[256];
			if(PlayerInfo[playerid][Ocultado] == 0 && !IsPlayerAdmin(player1)){
				format(string,sizeof(string),"El Administrador %s [ID: %d] se reubicado a tu posición actual.", PlayerName2(playerid), playerid);
				SendClientMessage(player1,blue,string);
			}
			format(string,sizeof(string),"Posición cambiada hacia las coordenadas de \"%s\"", pName(player1));
			return SendClientMessage(playerid,blue,string);
		} else return SendClientMessage(playerid, red, "ERROR: El jugador no esta conectado o eres tu mismo!");
	} else return SendClientMessage(playerid,red,"Error >> Requiere RCON.");
}

dcmd_get(playerid,params[]) {
    if(IsPlayerAdmin(playerid)) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, "Use: /Get [JUGADOR]");
    	new player1;
		if(!IsNumeric(params)) player1 = ReturnPlayerID(params);
	   	else player1 = strval(params);
        if(IsPlayerNearDynamicDoor(player1,XMasDomo,150.0) && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1, "NO SE PUEDE EJECUTAR ESTE COMANDO.");
        if(!IsPlayerAdmin(playerid) && IsPlayerAdmin(player1)) return SendClientMessage(playerid, COLOR_DE_ERROR, "ERROR: NO PUEDES UTILIZAR ESTE COMANDO EN EL DIOS DEL SERVER XD.");
		if (IsDroneBOT(player1) && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid,red, "ERROR: No puedes usar este comando en este NPC.");
	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid) {
			CMDMessageToAdmins(playerid,"GET");
			if(!IsPlayerNPC(player1))
			{
	   			new Float:x, Float:y, Float:z;	GetPlayerPos(playerid,x,y,z); SetPlayerInterior(player1,GetPlayerInterior(playerid));
				SetPlayerVirtualWorld(player1,GetPlayerVirtualWorld(playerid));
				if(GetPlayerState(player1) == 2)	{
				    new VehicleID = GetPlayerVehicleID(player1);
					SetVehiclePos(VehicleID,x+3,y,z);   LinkVehicleToInterior(VehicleID,GetPlayerInterior(playerid));
					SetVehicleVirtualWorld(GetPlayerVehicleID(player1),GetPlayerVirtualWorld(playerid));
				} else SetPlayerPos(player1,x+2,y,z);
			}
			else
			{
			    new Float:x, Float:y, Float:z;	GetPlayerPos(playerid,x,y,z);
				SetPlayerVirtualWorld(player1,GetPlayerVirtualWorld(playerid));
				FCNPC_SetInterior(player1,GetPlayerInterior(playerid));
				FCNPC_SetPosition(player1,x+2,y,z);
			}
			new string[256];
			if(PlayerInfo[playerid][Ocultado] == 0 && !IsPlayerAdmin(player1)){
			format(string,sizeof(string),"{4DFFFF}El Administrador {ffffff}%s{4DFFFF} te llevo a su posicion, si no estas de acuerdo {F50000}REPORTALO.", pName(playerid));	SendClientMessage(player1,blue,string);
			}
			format(string,sizeof(string),"{ffffff}%s{4DFFFF} Teletransportado.", pName(player1) );
			return SendClientMessage(playerid,blue,string);
		} else return SendClientMessage(playerid, red, "ERROR: El jugador no esta conectado o eres tu mismo");
	} else return SendClientMessage(playerid,red,"ERROR: Requiere RCON.");
}

dcmd_botneme(playerid,params[]) {
    if(IsPlayerAdmin(playerid)) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, "Use: /botneme [bot id]");
    	new player1;
    	new string[256];
		if(!IsNumeric(params)) player1 = ReturnPlayerID(params);
	   	else player1 = strval(params);
		if (IsDroneBOT(player1)) return SendClientMessage(playerid,red, "ERROR: No puedes usar este comando en este NPC.");
	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && IsZombieNPC(player1)) {
			CMDMessageToAdmins(playerid,"COMANDO SECRETO XD");
			if(NPC_NEMESIS[player1] == 1)
			{
            NPC_NEMESIS[player1] = 0;
			format(string,sizeof(string),"{4DFFFF}El Administrador {ffffff}%s{4DFFFF} Transformo al bot %s en Zombie Normal.", pName(playerid),PlayerName2(player1));
			PlayerMessageToPlayers(playerid, -1,string);
			format(string,sizeof(string),"{ffffff}%s{4DFFFF} Ok!, {ffffff}Variable NPC_NEMESIS[%d]: %d.", pName(player1),player1,NPC_NEMESIS[player1]);
            SetNPCHealth(player1, 100);
			}
			else if(NPC_NEMESIS[player1] == 0)
			{
            NPC_NEMESIS[player1] = 1;
            SetNPCHealth(player1, 1000);
			format(string,sizeof(string),"{4DFFFF}El Administrador {ffffff}%s{4DFFFF} Transformo al bot %s en Nemesis.", pName(playerid),PlayerName2(player1));
			PlayerMessageToPlayers(playerid, -1,string);
			format(string,sizeof(string),"{ffffff}%s{4DFFFF} Ok!, {ffffff}Variable NPC_NEMESIS[%d]: %d.", pName(player1),player1,NPC_NEMESIS[player1]);
			}
			return SendClientMessage(playerid,blue,string);
		} else return SendClientMessage(playerid, red, "ERROR: ID ingresada inaceptable.");
	} else return SendClientMessage(playerid,red,"ERROR: Requiere RCON.");
}

dcmd_getnpcs(playerid,params[]) {
    if(IsPlayerAdmin(playerid)) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, "Use: /Getnpcs [Cantidad]");
    	new CantidadNPC;
		if(!IsNumeric(params)) CantidadNPC = ReturnPlayerID(params);
	   	else CantidadNPC = strval(params);
	   	CMDMessageToAdmins(playerid,"GETNPCS");
	   	new Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid,x,y,z);
		GetPlayerFacingAngle(playerid, a);
		
		new Float:offset = 360.0 / CantidadNPC;
		new Float:radius = float(randomEx(5, 15));
		new Float:nx,Float:ny,Float:nz;

	   	

	   	new SERVER_MAX_PLAYERS = GetMaxPlayers(), vw = GetPlayerVirtualWorld(playerid), i = GetPlayerInterior(playerid);
	   	for(new npcCount = 1; npcCount < CantidadNPC; npcCount++)
  		{
			new reverseId = SERVER_MAX_PLAYERS-npcCount;
		 	if(IsPlayerConnected(reverseId) && IsZombieNPC(reverseId) && !FCNPC_IsDead(reverseId))
		 	{
						SetPlayerVirtualWorld(reverseId, vw);
						FCNPC_SetInterior(reverseId, i);

						NextCirclePosition(x, y, offset, nx, ny, a, radius);
						//MapAndreas_FindZ_For2DCoord(nx, ny, nz);
						nz = z + 1;

						//SendFormatMessageToAll(COLOR_ARTICULO,"[Spawn] (%d): X: %.4f, Y: %.4f, Z: %.4f, Angle: %.4f, Offset: %.4f", reverseId, nx, ny, nz, a, offset);
						FCNPC_SetPosition(reverseId, nx, ny, nz);
			}
		}
		new string[256];
		format(string,sizeof(string),"%d{4DFFFF} Bots Transportados a tu ubicacion.",CantidadNPC);
		return SendClientMessage(playerid,-1,string);
	} else return SendClientMessage(playerid,red,"ERROR: Requiere RCON");
}

dcmd_giveweapon(playerid,params[]) {
	if(IsPlayerAdmin(playerid)) {
	    new tmp[256], tmp2[256], tmp3[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index), tmp3 = strtok(params,Index);
	    new string[256];
	    if(!strlen(tmp) || !strlen(tmp2)) return SendClientMessage(playerid, red, "Uso correcto: /giveweapon [jugador] [ID del arma o nombre del arma] [municiones]");
		new player1 = strval(tmp), weap, ammo, WeapName[32];
		if(!strlen(tmp3) || !IsNumeric(tmp3) || strval(tmp3) <= 0 || strval(tmp3) > 99999) ammo = 500; else ammo = strval(tmp3);
		if(!IsNumeric(tmp2)) weap = GetWeaponIDFromName(tmp2); else weap = strval(tmp2);
    	if(!IsPlayerConnected(player1)) return SendClientMessage(playerid, COLOR_BLANCO, "Jugador no conectado.");
    	if (IsPlayerNPC(player1)) return SendClientMessage(playerid,red, "ERROR: No puedes utilizar este comando contra un bot.");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
        	if(!IsValidWeapon(weap)) return SendClientMessage(playerid,red,"ERROR: ID de arma invalida");
        	if(weap == 4) return SendClientMessage(playerid,red,"ERROR: esta arma esta prohibida.");
        	if((weap == 38 || weap == 35 || weap == 36 || weap == 37 || weap == 18 || weap == 16 || weap == 6) && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid,red,"ERROR: Requiere RCON para dar esta arma.");
			CMDMessageToAdmins(playerid,"GIVEWEAPON");
			GetWeaponName(weap,WeapName,32);
			format(string, sizeof(string), "{4DFFFF}** GiveWeapon {ffffff}%s[ID: %d] {4DFFFF}  Haz enviado un arma a %s [ID: %d] con %d municiones", PlayerName2(player1),player1, WeapName, weap, ammo); SendClientMessage(playerid,-1,string);
			if(player1 != playerid) { format(string,sizeof(string),"{4DFFFF}** {ffffff}%s{4DFFFF} te ha dado el arma {ffffff}%s[ID: %d] {4DFFFF} con %d municiones.", PlayerName2(playerid), WeapName, weap, ammo); SendClientMessage(player1,-1,string); }
            if(player1 != playerid) {
			format(string, sizeof(string), "El Jugador %s recibio el arma %s[ID: %d] Con %d Municiones.",PlayerName2(player1), WeapName, weap, ammo);
			SaveCMD(playerid, string);
			}
   			return GivePlayerWeaponEx(player1, weap, ammo);
	    } else return SendClientMessage(playerid,red,"ERROR: El jugador no esta conectado");
	} else return SendClientMessage(playerid,red,"Error >> Nivel RCON requerido desde 20/03/2016 10:26 p.m UTC -6");
}


dcmd_disarm(playerid,params[]) {
	if(IsPlayerAdmin(playerid)) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, "USE: /disarm [jugador] para desarmarlo");
		new player1 = strval(params);
		new string[256];
    	if(!IsPlayerConnected(player1)) return SendClientMessage(playerid, COLOR_BLANCO, "Jugador no conectado.");
    	if (IsPlayerNPC(player1)) return SendClientMessage(playerid,red, "ERROR: No puedes utilizar este comando contra un bot.");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"DISARM");  PlayerPlaySound(player1,1057,0.0,0.0,0.0);
			format(string, sizeof(string), "Has quitado las armas a %s", pName(player1)); SendClientMessage(playerid,-1,string);
			if(player1 != playerid && gTeam[player1] == Humano && GetPlayerWeapon(player1) != 35) { format(string,sizeof(string),"{4DFFFF}** El Administrador {ffffff}%s{4DFFFF} Te ha {ffffffD}quitado las armas.", pName(playerid)); SendClientMessage(player1,-1,string); }
            ResetPlayerWeaponsEx(player1);
			return PlayerPlaySound(player1,1057,0.0,0.0,0.0);
	    } else return SendClientMessage(playerid,red,"ERROR: El jugador no esta conectado");
	} else return SendClientMessage(playerid,red,"ERROR: Requiere RCON.");
}
dcmd_aka(playerid,params[]) {
    if(PlayerInfo[playerid][nivel] >= 2|| IsPlayerAdmin(playerid)) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, "Use: /aka [playerid]");
    	new player1, playername[MAX_PLAYER_NAME], str[128], tmp3[50];
		player1 = strval(params);
	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
  		  	GetPlayerIp(player1,tmp3,50);
			GetPlayerName(player1, playername, sizeof(playername));
			if(!IsPlayerAdmin(playerid) && PlayerInfo[player1][Ocultado] == 1){
		    format(str,sizeof(str),"[%s id:%d, IP: %s ]:", playername, player1, tmp3);
		    }
		    else{
		    format(str,sizeof(str),"[%s id:%d, IP: %s ]: %s", playername, player1, tmp3, ObtenerAKA(tmp3));
		    }
	        return SendClientMessage(playerid,-1,str);
		} else return SendClientMessage(playerid, red, "El jugador No esta conectado");
	} else return SendClientMessage(playerid,red,"ERROR: Usted No tiene sufisiente Level para Usar ese Comando");
}

dcmd_ip(playerid,params[]) {
	if(PlayerInfo[playerid][nivel] >= 5 || IsPlayerAdmin(playerid)) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, "USAGE: /ip [jugador]");
		new player1 = strval(params);
		if(PlayerInfo[player1][nivel] >= 5 && PlayerInfo[playerid][nivel] < 5) return SendClientMessage(playerid,red,"ERROR: SASA! NO LE PODES VER LA IP!! XD.");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			new tmp3[50]; GetPlayerIp(player1,tmp3,50);
			new string[256];
			if(!IsPlayerAdmin(playerid) && IsPlayerAdmin(player1)){
		    format(string,sizeof(string),"La IP de \" %s \" es ' %s '", PlayerName2(player1), PlayerName2(player1));
		    }
		    else{
		    format(string,sizeof(string),"La IP de \" %s \" es ' %s '", PlayerName2(player1), tmp3);
		    }
			return SendClientMessage(playerid,blue,string);
	    } else return SendClientMessage(playerid,red,"ERROR: El jugador no esta conectado");
	} else return SendClientMessage(playerid,red,"ERROR: Necesitas ser Administrador nivel 1 para usar este comando");
}

dcmd_akat(playerid,params[]) {
    if(PlayerInfo[playerid][nivel] >= 2|| IsPlayerAdmin(playerid)) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, "Use: /aka [playerid]");
    	new player1, playername[MAX_PLAYER_NAME], str[128], tmp3[50];
		player1 = strval(params);
	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
  		  	GetPlayerIp(player1,tmp3,50);
			GetPlayerName(player1, playername, sizeof(playername));
		    format(str,sizeof(str),"NICKS DE: [ %s (%d) ]: %s", playername, player1, ObtenerAKA(tmp3) );
	        return SendClientMessage(playerid,-1,str);
		} else return SendClientMessage(playerid, red, "El jugador No esta conectado");
	} else return SendClientMessage(playerid,red,"ERROR: Usted No tiene sufisiente Level para Usar ese Comando");
}

dcmd_stats(playerid,params[]) {
	new Estadisticas[450],info[400],player1;
	if(!strlen(params)) player1 = playerid;
	else player1 = strval(params);
	new Float:vida;
	if(IsPlayerConnected(player1)) {
		GetPlayerHealth(player1,vida);
		new Float:Salud,PEstado[20];
		new tieneRZClient[20];
		GetPlayerHealth(player1, Salud);
		if(IsPlayerPaused(player1)) { PEstado = "{f50000}Si."; }
		else if(!IsPlayerPaused(player1)) { PEstado = "{ffffff}No."; }
		if(RZClient_IsClientConnected(player1)) { tieneRZClient = "{ffffff}Si."; }
		else { tieneRZClient = "{ffffff}No."; }
		if(PlayerInfo[player1][CLAN] == 1) {
		//----------------------------------------------------------------------
		format(info,sizeof(info),"{9C7AFF}Nick:{ffffff} %s\n\n",PlayerName2(player1));
		strcat(Estadisticas,info);
		//----------------------------------------------------------------------
		format(info,sizeof(info),"{9C7AFF}Dinero:{ffffff} $%d\n\n",GetPlayerMoney(player1));
		strcat(Estadisticas,info);
		//----------------------------------------------------------------------
		format(info,sizeof(info),"{9C7AFF}SCORE:{ffffff} %d\n\n",GetPlayerScore(player1));
		strcat(Estadisticas,info);
		//----------------------------------------------------------------------
		if(PlayerInfo[playerid][Ocultado] == 0 && PlayerInfo[player1][VIP] >= 1){
		format(info,sizeof(info),"{9C7AFF}Nivel VIP:{ffffff} %d\n\n",PlayerInfo[player1][VIP]);
		strcat(Estadisticas,info);
		}
		//----------------------------------------------------------------------
		format(info,sizeof(info),"{9C7AFF}Ping:{ffffff} %d ms.\n\n",GetPlayerPing(player1));
		strcat(Estadisticas,info);
		//----------------------------------------------------------------------
		format(info,sizeof(info),"{9C7AFF}En Pausa?: %s\n\n",PEstado);
		strcat(Estadisticas,info);
		//----------------------------------------------------------------------
		format(info,sizeof(info),"{9C7AFF}Salud:{ffffff} %.1f\n\n",Salud);
		strcat(Estadisticas,info);
		//----------------------------------------------------------------------
		format(info,sizeof(info),"{9C7AFF}RZClient:{ffffff} %s\n\n",tieneRZClient);
		strcat(Estadisticas,info);
		//----------------------------------------------------------------------
		format(info,sizeof(info),"{9C7AFF}CLAN:{ffffff} %s\n\n",ClanTAG[player1]);
		strcat(Estadisticas,info);
		//----------------------------------------------------------------------
 		format(info,sizeof(info),"{9C7AFF}Pais:{ffffff} %s\n\n",GetPlayerCountry(player1));
		strcat(Estadisticas,info);
		//----------------------------------------------------------------------
		format(info,sizeof(info),"{9C7AFF}Fecha de Registro:{ffffff} %s",Fecha_REG[playerid]);
		strcat(Estadisticas,info);
  		}
  		else
  		{
		//----------------------------------------------------------------------
		format(info,sizeof(info),"{9C7AFF}Nick:{ffffff} %s\n\n",PlayerName2(player1));
		strcat(Estadisticas,info);
		//----------------------------------------------------------------------
		format(info,sizeof(info),"{9C7AFF}Dinero:{ffffff} $%d\n\n",GetPlayerMoney(player1));
		strcat(Estadisticas,info);
		//----------------------------------------------------------------------
		format(info,sizeof(info),"{9C7AFF}SCORE:{ffffff} %d\n\n",GetPlayerScore(player1));
		strcat(Estadisticas,info);
		//----------------------------------------------------------------------
		if(PlayerInfo[playerid][Ocultado] == 0 && PlayerInfo[player1][VIP] >= 1){
		format(info,sizeof(info),"{9C7AFF}Nivel VIP:{ffffff} %d\n\n",PlayerInfo[player1][VIP]);
		strcat(Estadisticas,info);
		}
		//----------------------------------------------------------------------
		format(info,sizeof(info),"{9C7AFF}Ping:{ffffff} %d ms.\n\n",GetPlayerPing(player1));
		strcat(Estadisticas,info);
		//----------------------------------------------------------------------
		format(info,sizeof(info),"{9C7AFF}En Pausa?: %s\n\n",PEstado);
		strcat(Estadisticas,info);
		//----------------------------------------------------------------------
		format(info,sizeof(info),"{9C7AFF}Salud:{ffffff} %.1f\n\n",Salud);
		strcat(Estadisticas,info);
		//----------------------------------------------------------------------
		format(info,sizeof(info),"{9C7AFF}RZClient:{ffffff} %s\n\n",tieneRZClient);
		strcat(Estadisticas,info);
		//----------------------------------------------------------------------
		format(info,sizeof(info),"{9C7AFF}CLAN:{ffffff} Ninguno.\n\n");
		strcat(Estadisticas,info);
		//----------------------------------------------------------------------
 		format(info,sizeof(info),"{9C7AFF}Pais:{ffffff} %s\n\n",GetPlayerCountry(player1));
		strcat(Estadisticas,info);
		//----------------------------------------------------------------------
		format(info,sizeof(info),"{9C7AFF}Fecha de Registro:{ffffff} %s",Fecha_REG[player1]);
		strcat(Estadisticas,info);
  		}
  		ShowPlayerDialog(playerid,DIALOG_STATS, DIALOG_STYLE_MSGBOX, "{f50000}[ == RZ: Stats == ]", Estadisticas, "|><|", "x");
		PlayerInfo[playerid][StatsID] = player1;
		return 1;
	} else return SendClientMessage(playerid, red, "[ERROR]: Jugador desconectado.");
}
dcmd_weaps(playerid,params[]) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, "Use: /weaps [playerid]");
    	new player1, string2[64], WeapName[24], slot, weap, ammo, CountZ, x;
        new string[256];
		player1 = strval(params);

	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			format(string2,sizeof(string2),"[>> %s Armas (id:%d) <<]", PlayerName2(player1), player1); SendClientMessage(playerid,ADMIN_COLOR,string2);
			for (slot = 0; slot < 14; slot++) {	GetPlayerWeaponData(player1, slot, weap, ammo); if( ammo != 0 && weap != 0) CountZ++; }
			if(CountZ < 1) return SendClientMessage(playerid,blue,"El Jugador no Tiene armas");

			if(CountZ >= 1)
			{
				for (slot = 0; slot < 14; slot++)
				{
					GetPlayerWeaponData(player1, slot, weap, ammo);
					if( ammo != 0 && weap != 0)
					{
						GetWeaponName(weap, WeapName, sizeof(WeapName) );
						if(ammo == 65535 || ammo == 1) format(string,sizeof(string),"%s%s (1)",string, WeapName );
						else format(string,sizeof(string),"%s%s (%d)",string, WeapName, ammo );
						x++;
						if(x >= 5)
						{
						    SendClientMessage(playerid, blue, string);
						    x = 0;
							format(string, sizeof(string), "");
						}
						else format(string, sizeof(string), "%s,  ", string);
					}
			    }
				if(x <= 4 && x > 0) {
					string[strlen(string)-3] = '.';
				    SendClientMessage(playerid, -1, string);
				}
		    }
		    return 1;
		} else return SendClientMessage(playerid, red, "El jugador No esta conectado");
}
dcmd_givecash(playerid,params[]) {
	if(IsPlayerAdmin(playerid)) {
	    new tmp[256], tmp2[256],string2[256],DINERO_STRING[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, "USE: /GiveCash [jugador] [cantidad]");
		new player1 = strval(tmp), cash = strval(tmp2);
		new string[256];
		new DineroActual = GetPlayerMoney(player1);
		if (PlayerInfo[player1][nivel] >= 1 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, red, "[» ERROR «]:{FFFFFF} No puedes enviar dinero a otros Administradores, Ya los descubrimos malcriados.");
		if(player1 == playerid && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid,red,"No te puedes dar score, y si alguien te da sera guardado en un Log.");
        if(strlen(tmp2) > 6 && PlayerInfo[playerid][nivel] <= 4) return SendClientMessage(playerid, red, "[» ERROR «]:{FFFFFF} No puedes dar dinero de una cantidad mayor a 6 digitos.");
	    if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			format(string2,sizeof(string2),"{4DFFFF}El Administrador {ffffff}%s{4DFFFF} Dio {ffffff}$%d {4DFFFF}Al Jugador {ffffff}%s.", pName(playerid),cash,pName(player1));
			format(DINERO_STRING,sizeof(DINERO_STRING),"[CMD]: %s[%d] Dio al jugador %s[%d]: $%d Pesos.", pName(playerid),playerid,pName(player1),player1,cash);
			AdminMessageToAdmins(playerid, -1, string2);
			SaveCMD(playerid, DINERO_STRING);
			if(player1 != playerid) { format(string,sizeof(string),"{4DFFFF}El Administrador {ffffff}%s{4DFFFF} Te ha dado {ffffff}$%s {4DFFFF}Pesos.", pName(playerid), cash); SendClientMessage(player1,ADMIN_COLOR,string); }
			ResetPlayerMoney(player1);
			GivePlayerMoney(player1,DineroActual+cash);
			PlayerInfo[playerid][Dinero] = GetPlayerMoney(player1);
		   	CallLocalFunction("OnPlayerCommandText", "is", player1, "/gc");
		   	return 1;
	    } else return SendClientMessage(playerid,red,"ERROR: El jugador no esta conectado");
	} else return SendClientMessage(playerid,red,"ERROR: Requiere RCON.");
}

dcmd_descash(playerid,params[]) {
	if(IsPlayerAdmin(playerid)) {
	    new tmp[256], tmp2[256],string2[256],DINERO_STRING[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, "USE: /descash [jugador] [cantidad]");
		new player1 = strval(tmp), cash = strval(tmp2);
		new string[256];
		new DineroActual = GetPlayerMoney(player1);
		if (PlayerInfo[player1][nivel] >= 1 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, red, "[» ERROR «]:{FFFFFF} No puedes enviar dinero a otros Administradores, Ya los descubrimos malcriados.");
		if(player1 == playerid && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid,red,"No te puedes dar score, y si alguien te da sera guardado en un Log.");
        if(strlen(tmp2) > 6 && PlayerInfo[playerid][nivel] <= 4) return SendClientMessage(playerid, red, "[» ERROR «]:{FFFFFF} No puedes dar dinero de una cantidad mayor a 6 digitos.");
	    if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			format(string2,sizeof(string2),"{4DFFFF}El Administrador {ffffff}%s{4DFFFF} Quito {ffffff}$%d {4DFFFF}Al Jugador {ffffff}%s.", pName(playerid),cash,pName(player1));
			format(DINERO_STRING,sizeof(DINERO_STRING),"[CMD]: %s[%d] Quito al jugador %s[%d]: $%d Pesos.", pName(playerid),playerid,pName(player1),player1,cash);
			AdminMessageToAdmins(playerid, -1, string2);
			SaveCMD(playerid, DINERO_STRING);
			if(player1 != playerid) { format(string,sizeof(string),"{4DFFFF}El Administrador {ffffff}%s{4DFFFF} Te ha Quitado {ffffff}$%s {4DFFFF}Pesos.", pName(playerid), cash); SendClientMessage(player1,ADMIN_COLOR,string); }
			ResetPlayerMoney(player1);
			GivePlayerMoney(player1,DineroActual-cash);
			PlayerInfo[playerid][Dinero] = GetPlayerMoney(player1);
		   	CallLocalFunction("OnPlayerCommandText", "is", player1, "/gc");
		   	return 1;
	    } else return SendClientMessage(playerid,red,"ERROR: El jugador no esta conectado");
	} else return SendClientMessage(playerid,red,"ERROR: Requiere RCON.");
}

dcmd_rduda(playerid,params[]) {
if(SinCHAT == 1&& !IsPlayerAdmin(playerid)) return SendClientMessage(playerid,COLOR_DE_ERROR, "[ ERROR ] {FFFFFF}El chat esta desactivado."), 0;
	if(PlayerInfo[playerid][nivel] >= 1 || IsPlayerAdmin(playerid)) {
	    new tmp[256], tmp2[256],Index; tmp = strtok(params,Index), tmp2 = strrest(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2)) return SendClientMessage(playerid, red, "Uso correcto: /rduda [jugador] [mensaje]");
	    if(strlen(tmp2) > 263) return SendClientMessage(playerid, Rojo, "[ERROR]: {ffffff} No puedes enviar mas de 263 letras En este comando.");
		new player1 = strval(tmp),NickSTRING[54];
		new string[1024];
	    if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			if(player1 != playerid)
			{
			SendClientMessage(playerid,-1,"Respuesta enviada..");
			format(string,sizeof(string),"[R-Z]:{ffffff}%s[%d] Responde a %s[%d]: %s",PlayerName2(playerid),playerid,PlayerName2(player1),player1,tmp2);
			format(NickSTRING,sizeof(NickSTRING),"{CC99FF}[ADMIN]: {ffffff}%s[%d]", pName(playerid),playerid);
			AdminMessageToAdmins(playerid, -1, string);
			printf("[DUDA]: %s Responde a %s: %s\n",PlayerName2(playerid),PlayerName2(player1),tmp2);
			}
			format(string,sizeof(string),"{ffffff}*Admin %s[%d] Te ha enviado una respuesta %s[%d]:\n %s",PlayerName2(playerid),playerid,PlayerName2(player1),player1,tmp2);
		   	return ShowPlayerDialog(player1,DIALOG_RESPUESTA, DIALOG_STYLE_MSGBOX, NickSTRING,string, ">>", "x");
	    } else return SendClientMessage(playerid,red,"ERROR: El jugador no esta conectado");
	} else return SendClientMessage(playerid,red,"ERROR: ?");
}
dcmd_darvida(playerid,params[]) {
	if(IsPlayerAdmin(playerid)) {
	    new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, "USA: /darvida [jugador] [CANTIDAD]");
		if(strval(tmp2) < 0 || strval(tmp2) > 100) return SendClientMessage(playerid, red, "ERROR: Cantidad de vida invalida es de 1 - 100.");
		new player1 = strval(tmp), health = strval(tmp2);
		new string[256];
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			format(string, sizeof(string), "{4DFFFF}[CMD]: {ffffff}%s{4DFFFF} coloco la vida de {ffffff}%s {4DFFFF}En {ffffff}%d.", PlayerName2(playerid),pName(player1), health);
			AdminMessageToAdmins(playerid, -1, string);
			if(player1 != playerid) { format(string,sizeof(string),"{4DFFFF}El Administrador {ffffff}%s{4DFFFF} ha colocado tu vida en {ffffff}%d.", pName(playerid), health); SendClientMessage(player1,blue,string); }
   			return SetPlayerHealth(player1, health);
	    } else return SendClientMessage(playerid,red,"ERROR: El jugador no esta conectado");
	} else return SendClientMessage(playerid,red,"ERROR: Requiere RCON.");
}
dcmd_setcash(playerid,params[]) {
	if(IsPlayerAdmin(playerid)) {
	    new tmp[256], tmp2[256],string2[300], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, "USE: /setcash [jugador] [cantidad] para quitarle dinero a un jugador.");
		new player1 = strval(tmp), SetDinero = strval(tmp2);
		new string[256];
		if (PlayerInfo[player1][nivel] >= 1 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, red, "[» ERROR «]:{FFFFFF} No puedes enviar dinero a otros Administradores, Ya los descubrimos malcriados.");
		if(player1 == playerid && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid,red,"No te puedes dar dinero, y si alguien te da sera guardado en un Log.");
	    if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			format(string2,sizeof(string2),"{4DFFFF}El Administrador {ffffff}%s{4DFFFF} Fijo el dinero de {ffffff}%s {4DFFFF}en {ffffff}$%d.", pName(playerid),pName(player1),SetDinero);
			AdminMessageToAdmins(playerid, -1, string2);
			format(string, sizeof(string), "* Admin %s Fijo el dinero de %s en $%d.",PlayerName2(playerid),pName(player1),SetDinero); SendClientMessage(playerid,-1,string);
            SaveCMD(playerid, string);
			if(player1 != playerid) { format(string,sizeof(string),"{4DFFFF}El Administrador {ffffff}%s{4DFFFF} Fijo tu dinero en {ffffff}$%d.", pName(playerid),SetDinero); SendClientMessage(player1,ADMIN_COLOR,string); }
			ResetPlayerMoney(player1);
			GivePlayerMoney(player1,SetDinero);
			PlayerInfo[playerid][Dinero] = GetPlayerMoney(player1);
		   	CallLocalFunction("OnPlayerCommandText", "is", player1, "/gc");
		   	return 1;
	    } else return SendClientMessage(playerid,red,"ERROR: El jugador no esta conectado");
	} else return SendClientMessage(playerid,red,"ERROR: Requiere RCON");
}

dcmd_darscore(playerid,params[])
{
		if(IsPlayerAdmin(playerid)) {
	    new tmp[256], tmp2[256],string2[300], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, "usa: /darscore [jugador] [puntaje]");
		new player1 = strval(tmp),darmas = strval(tmp2), score = GetPlayerScore(player1);
		new string[256];
		if (PlayerInfo[player1][nivel] >= 1 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, red, "[» ERROR «]:{FFFFFF} No puedes enviar score a otros Administradores, Ya los descubrimos malcriados.");
		if(player1 == playerid && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid,red,"No te puedes dar score, y si alguien te da sera guardado en un Log.");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
		format(string2,sizeof(string2),"{4DFFFF}El Administrador {ffffff}%s{4DFFFF} Ha sumado el score de {ffffff}%s {4DFFFF}En {ffffff}%d {4DFFFF}Puntos.", pName(playerid),pName(player1),darmas);
		AdminMessageToAdmins(playerid, -1, string2);
		format(string, sizeof(string), "* Admin %s sumo al jugador %s '%d' Puntos.",pName(playerid), pName(player1),darmas); SendClientMessage(playerid,yellow,string);
		SaveCMD(playerid, string);
		printf("[ADMIN_CMD]: Admin %s[%d] Dio al jugador %s[%d] '%d' Puntos.",pName(playerid),playerid, pName(player1),player1,darmas);
		if(player1 != playerid) { format(string,sizeof(string),"{4DFFFF}El Administrador {ffffff}%s{4DFFFF} Te ha sumado {ffffff}%d {4DFFFF}Puntos.", pName(playerid), darmas); SendClientMessage(player1,yellow,string); }
		SetPlayerScore(player1,score+darmas);
		PlayerInfo[playerid][Asesinatos] = GetPlayerScore(player1);
 	    CallLocalFunction("OnPlayerCommandText", "is", player1, "/gc");
 	    return 1;
		} else return SendClientMessage(playerid,red,"El jugador no esta coenctado.");
		} else return SendClientMessage(playerid,red,"ERROR: Requiere RCON.");
}
dcmd_setscore(playerid,params[])
{
		if(IsPlayerAdmin(playerid)) {
	    new tmp[256], tmp2[256],string2[300], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, "usa: /setscore [jugador] [puntaje]");
		new player1 = strval(tmp),score = strval(tmp2);
		new string[256];
		if (PlayerInfo[player1][nivel] >= 1 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, red, "[» ERROR «]:{FFFFFF} No puedes enviar score a otros Administradores, Ya los descubrimos malcriados.");
		if(player1 == playerid && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid,red,"No te puedes dar score, y si alguien te da sera guardado en un Log.");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
		CMDMessageToAdmins(playerid,"SETSCORE y se ha guardado en un Log.");
		format(string2,sizeof(string2),"{4DFFFF}El Administrador {ffffff}%s{4DFFFF} Fijo el score de {ffffff}%s {4DFFFF}En {ffffff}%d.", pName(playerid),pName(player1),score);
		AdminMessageToAdmins(playerid, -1, string2);
		format(string, sizeof(string), "* Admin %s Coloco el score de %s En %d.",pName(playerid), pName(player1),score); SendClientMessage(playerid,yellow,string);
		SaveCMD(playerid, string);
		printf("[ADMIN_CMD]: Admin %s[%d] Seteo al jugador %s[%d] '%d' Puntos.",pName(playerid),playerid, pName(player1),player1,score);
		if(player1 != playerid) { format(string,sizeof(string),"{4DFFFF}El Administrador {ffffff}%s{4DFFFF} ha fijado tus Puntos en {ffffff}%d.", pName(playerid),score); SendClientMessage(player1,yellow,string); }
		SetPlayerScore(player1,score);
		PlayerInfo[playerid][Asesinatos] = GetPlayerScore(player1);
 		CallLocalFunction("OnPlayerCommandText", "is", player1, "/gc");
 		return 1;
		} else return SendClientMessage(playerid,red,"El jugador no esta coenctado.");
		} else return SendClientMessage(playerid,red,"ERROR: Requiere RCON.");
}

dcmd_explode(playerid,params[]) {
		if(PlayerInfo[playerid][nivel] >= 1) {
		    new tmp[256], razon[256], Index;		tmp = strtok(params,Index), razon = strtok(params,Index);
		    if(!strlen(params)) return SendClientMessage(playerid, red, "Use: /Explode [Player] [Razon]");
	    	new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME],str[256];
			player1 = strval(tmp);
			if(!strlen(razon)) return SendClientMessage(playerid, red, "Tienes que poner una razón.");
			if(!IsPlayerAdmin(playerid) && IsPlayerAdmin(player1))
			{
			new Float:burnx, Float:burny, Float:burnz; GetPlayerPos(playerid,burnx, burny, burnz);
			SendClientMessage(playerid, red, "NO VAS A EXPLOTAR AL ADMIN RCON PUTILLA TOMALA XD !!!");
			return CreateExplosionForPlayer(playerid,burnx, burny , burnz, 7,30.0);
			}
   			if(PlayerInfo[player1][nivel] >= 1 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_DE_ERROR, "ERROR: No se puede explotar a otro administrador.");
		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID ) {
				GetPlayerName(player1, playername, sizeof(playername)); 	GetPlayerName(playerid, adminname, sizeof(adminname));
				CMDMessageToAdmins(playerid,"EXPLODE");
				format(str, sizeof(str), "* Admin %s Exploto al usuario %s, Razón: %s", adminname,playername,razon);
				printf(str);
				//SaveCMD(playerid, str);
				new Float:burnx, Float:burny, Float:burnz; GetPlayerPos(player1,burnx, burny, burnz); CreateExplosionForPlayer(player1,burnx, burny , burnz, 7,30.0);
				return 1;
			} else return SendClientMessage(playerid, red, "El id no esta conectado.");
		} else return SendClientMessage(playerid,red,"ERROR: Requiere admin.");
}

dcmd_reportar(playerid,params[]) {
if(SinCHAT == 1&& !IsPlayerAdmin(playerid)) return SendClientMessage(playerid,COLOR_DE_ERROR, "[ ERROR ] {FFFFFF}El chat esta desactivado."), 0;
    new reported, tmp[256], tmp2[256], Index;		tmp = strtok(params,Index), tmp2 = strrest(params,Index);
    if(!strlen(params)) return SendClientMessage(playerid, red, "Use: /Reportar [Jugador] [Razon]");
	reported = strval(tmp);
	if(IsPlayerNPC(reported))ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{F50000}Retardado", "TU REPORTE NO FUE ENVIADO, HAS REPORTADO UN ZOMBIE BOT, VERIFICA LOS ESPACIOS EN TÚ COMANDO.", "x", "");
 	if(IsPlayerConnected(reported) && reported != INVALID_PLAYER_ID) {
		if(playerid == reported) return SendClientMessage(playerid,red,"ERROR: No puede Reportarse a Usted Mismo");
		if(IsPlayerNPC(reported)) return SendClientMessage(playerid,red,"[ ERROR ]: {ffffff}No puedes reportar a los NPC, ellos no son jugadores.");
		if(strlen(params) > 7) {
		if(strlen(tmp2) >= 55) return SendClientMessage(playerid,red,"ERROR: El Reporte tiene mas de 50 caracteres hazlo mas corto.");
			new reportedname[MAX_PLAYER_NAME], reporter[MAX_PLAYER_NAME], str[1200], hour,minute,second; gettime(hour,minute,second);
			GetPlayerName(reported, reportedname, sizeof(reportedname));	GetPlayerName(playerid, reporter, sizeof(reporter));
			format(str, sizeof(str), "{FF0000}||Reporte||  {FFFFFF}%s(ID: %d) {FF0000}Reporta a {FFFFFF}%s(ID: %d) {FF0000}Razon: {FFFFFF}%s |@%d:%d:%d|", reporter,playerid, reportedname, reported, params[strlen(tmp)+1], hour,minute,second);
			MessageToAdmins(-1,str);
			format(str, sizeof(str), "{CCCCFF}%s {FFFFFF}[ID: %d] {FF0000}Reporta a {FFFFFF}%s [ID: %d] {FF0000}Razon: {FFFFFF}%s",reporter,playerid, reportedname, reported, params[strlen(tmp)+1]);
			for(new i = 1; i < MAX_REPORTS-1; i++) Reports[i] = Reports[i+1];
			Reports[MAX_REPORTS-1] = str;
			printf("[/REPORTAR] %s ha reportado al jugador %s, Razón: %s",reporter,reportedname,params[strlen(tmp)+1]);
			return SendClientMessage(playerid,yellow, "Tu Reporte a sido enviado a los Admins.");
		} else return SendClientMessage(playerid,red,"ERROR: Razon invalida");
	} else return SendClientMessage(playerid, red, "Jugador No conectado");
}
dcmd_report(playerid,params[]) {
if(SinCHAT == 1&& !IsPlayerAdmin(playerid)) return SendClientMessage(playerid,COLOR_DE_ERROR, "[ ERROR ] {FFFFFF}El chat esta desactivado."), 0;
    new reported, tmp[256], tmp2[256], Index;		tmp = strtok(params,Index), tmp2 = strtok(params,Index);
    if(!strlen(params)) return SendClientMessage(playerid, red, "Use: /Report [PlayerID] [Reason]");
	reported = strval(tmp);
	if(IsPlayerNPC(reported))ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{F50000}Retardado", "TU REPORTE NO FUE ENVIADO, HAS REPORTADO UN ZOMBIE BOT, VERIFICA LOS ESPACIOS EN TÚ COMANDO.", "x", "");
 	if(IsPlayerConnected(reported) && reported != INVALID_PLAYER_ID) {
		if(playerid == reported) return SendClientMessage(playerid,red,"ERROR: No se puede Reportarse a Usted Mismo");
		if(IsPlayerNPC(reported)) return SendClientMessage(playerid,red,"[ ERROR ]: {ffffff}No puedes reportar a los NPC, ellos no son jugadores.");
		if(strlen(params) > 7) {
		if(strlen(tmp2) >= 55) return SendClientMessage(playerid,red,"ERROR: The report is long, please cut the text.");
			new reportedname[MAX_PLAYER_NAME], reporter[MAX_PLAYER_NAME], str[1200], hour,minute,second; gettime(hour,minute,second);
			GetPlayerName(reported, reportedname, sizeof(reportedname));	GetPlayerName(playerid, reporter, sizeof(reporter));
			format(str, sizeof(str), "{FF0000}||Reporte||  {FFFFFF}%s(ID: %d) {FF0000}Reporta a {FFFFFF}%s(ID: %d) {FF0000}Razon: {FFFFFF}%s |@%d:%d:%d|", reporter,playerid, reportedname, reported, params[strlen(tmp)+1], hour,minute,second);
			MessageToAdmins(-1,str);
			format(str, sizeof(str), "{CCCCFF}%s {FFFFFF}[ID: %d] {FF0000}Reporta a {FFFFFF}%s [ID: %d] {FF0000}Razon: {FFFFFF}%s",reporter,playerid, reportedname, reported, params[strlen(tmp)+1]);
			for(new i = 1; i < MAX_REPORTS-1; i++) Reports[i] = Reports[i+1];
			Reports[MAX_REPORTS-1] = str;
			printf("[/REPORT] %s ha reportado al jugador %s, Razón: %s",reporter,reportedname,params[strlen(tmp)+1]);
			return SendClientMessage(playerid,yellow, "You report send to administrators online..");
		} else return SendClientMessage(playerid,red,"ERROR: Razon not avalible");
	} else return SendClientMessage(playerid, red, "player no connected");
}
dcmd_announce(playerid,params[]) {
    if(PlayerInfo[playerid][nivel] >= 3 || IsPlayerAdmin(playerid)) {
	if(SinCHAT == 1&& !IsPlayerAdmin(playerid)) return SendClientMessage(playerid,COLOR_DE_ERROR, "[ ERROR ] {FFFFFF}El chat esta desactivado."), 0;
    	if(!strlen(params)) return SendClientMessage(playerid,red,"USE: /announce <texto>");
    	CMDMessageToAdmins(playerid,"ANNOUNCE");
    	printf("[ANNOUNCE] %s[%d]: %s",PlayerName2(playerid),playerid,params);
		GameTextForAll(ANNOUNCE_BUG(params),7000,3);
    	strreplace(params,"~r~","");
    	strreplace(params,"~w~","");
    	strreplace(params,"~y~","");
    	strreplace(params,"~b~","");
    	strreplace(params,"~l~","");
    	strreplace(params,"~p~","");
    	strreplace(params,"~h~","");
    	strreplace(params,"~n~","");

    	strreplace(params,"~R~","");
    	strreplace(params,"~W~","");
    	strreplace(params,"~Y~","");
    	strreplace(params,"~B~","");
    	strreplace(params,"~L~","");
    	strreplace(params,"~P~","");
    	strreplace(params,"~H~","");
    	strreplace(params,"~N~","");
    	//flechas
    	
    	strreplace(params,"~U~","");
    	strreplace(params,"~D~","");
    	
    	strreplace(params,"~u~","");
    	strreplace(params,"~d~","");
    	strreplace(params,"~<~","");
    	strreplace(params,"~>~","");
		return SendFormatMessageToAll(COLOR_DE_ERROR, "[ ANUNCIO ]:{FFFF33} %s [ID: %d]{FFFFFF}: %s", PlayerName2(playerid), playerid, params);
    } else return SendClientMessage(playerid,red,"ERROR: Necesitas ser Administrador nivel 3 para usar este comando");
}

dcmd_lsay(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][nivel] >= 2) {
		if(PlayerInfo[playerid][Lsay] == 1){PlayerInfo[playerid][Lsay] = 0; SendClientMessage(playerid,-1,"* Lsay Desactivado.");}else{PlayerInfo[playerid][Lsay] = 1; SendClientMessage(playerid,-1,"* Lsay Activado!, Habla por el chat :D, si quieres descativarlo vuelve a usar {f50000}/LSAY");}
		return 1;
		}
		else return SendClientMessage(playerid,red,"ERROR: Necesitas tener level 2 para usar el comando");
}
dcmd_digo(playerid,params[]) {
	if(PlayerInfo[playerid][VIP] >= 2) {
		if(SinCHAT == 1&& !IsPlayerAdmin(playerid)) return SendClientMessage(playerid,COLOR_DE_ERROR, "[ ERROR ] {FFFFFF}El chat esta desactivado."), 0;
		if((rztickcount() - PlayerInfo[playerid][AntiDigoFlood]) < 60 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, Rojo, "[ERROR]: {ffffff} Tienes que esperar 1 minuto para volver a usar este comando.");
		if(PlayerInfo[playerid][Identificado] == 0 || PlayerInfo[playerid][RZClient_Verified] == 0){SendClientMessage(playerid, COLOR_DE_ERROR, "[ ERROR ]{ffffff} Para utilizar el chat necesitas identificarte/spawnear por primera vez."); return 0;}
		if(!strlen(params)) return SendClientMessage(playerid, red, "USA: /digo [texto]");
		new string[256];
	 	format(string, sizeof(string), "{4DFFFF}* V.I.P {FFFFFF}%s [%d]: {00FF00}%s", PlayerName2(playerid),playerid, params[0]);
		printf("| V.I.P | %s [%d]: %s",PlayerName2(playerid),playerid, params[0]);
		PlayerInfo[playerid][AntiDigoFlood] = rztickcount();
		return SendClientMessageToAll(yellow,string);
		}
		else return SendClientMessage(playerid,red,"ERROR: Necesitas ser vip nivel 2.");
}

dcmd_g(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][GLOBALCHAT] == 1)
	{PlayerInfo[playerid][GLOBALCHAT] = 0; SendClientMessage(playerid,-1,"* Chat Global: desactivado.");}
	else{PlayerInfo[playerid][GLOBALCHAT] = 1; SendClientMessage(playerid,-1,"* Chat Global: activado.");}
	return 1;
}

dcmd_link(playerid,params[])
{
		if(!strlen(params)) return SendClientMessage(playerid, red, "[-] Usa: /Link [* Ejemplo: http://musica.com/un_sonido.mp3]");
        if(strlen(params[0]) >= 256) return SendClientMessage(playerid,ADMIN_COLOR, "El nombre de la canción es demaciado largo D:");
		new string[280];
		format(string, sizeof(string), "%s",params[0]);
	 	PlayAudioStreamForPlayerEx(playerid,string);
		//return SendClientMessage(playerid,ADMIN_COLOR,"Comando Desactivado temporalmente.");
		return SendClientMessage(playerid, -1, "Esta reproduciendo un audio, utilice /stop para detenerlo.");
}

dcmd_link_excut(playerid,params[])
{
		if(!strlen(params)) return SendClientMessage(playerid, red, "[-] Error al reproducir la canción.");
		new string[450];
		format(string, sizeof(string), "%s",params[0]);
	 	PlayAudioStreamForPlayerEx(playerid,string);
		return SendClientMessage(playerid, -1, "Esta reproduciendo un audio, utilice /stop para detenerlo.");
}

dcmd_gskinid(playerid,params[]) {
		if(!strlen(params)) return SendClientMessage(playerid, red, "[-] NO [-]");
        if(!IsPlayerConnected(strval(params[0]))) return SendClientMessage(playerid, red, "[-] NO C! [-]");
		new skin_str[256],skinid = GetPlayerSkin(strval(params[0]));
		format(skin_str,sizeof(skin_str), "%s [ID: %d] usa el skin ID: %d",PlayerName2(strval(params[0])),strval(params[0]),skinid);
		return SendClientMessage(playerid,-1,skin_str);
}


dcmd_getid(playerid,params[]) {
	if(!strlen(params)) return SendClientMessage(playerid,blue,">>> Use: (/GetID [Parte del nombre]).");
	new found, string[128], playername[MAX_PLAYER_NAME];
	format(string,sizeof(string),">>> Buscando a: %s.",params);
	SendClientMessage(playerid,blue,string);
	for(new i=0; i <= GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i))
		{
	  		GetPlayerName(i, playername, MAX_PLAYER_NAME);
			new namelen = strlen(playername);
			new bool:searched=false;
	    	for(new pos=0; pos <= namelen; pos++)
			{
				if(searched != true)
				{
					if(strfind(playername,params,true) == pos)
					{
		                found++;
						format(string,sizeof(string),"%d. %s (ID %d)",found,playername,i);
						SendClientMessage(playerid, green ,string);
						searched = true;
					}
				}
			}
		}
	}
	if(found == 0) SendClientMessage(playerid, red, ">>> No se encontraron usuarios.");
	return 1;
}

/*
dcmd_setping(playerid,params[]) {
		if(!strlen(params)) return SendClientMessage(playerid, red, "[-] NO [-]");
	    new sas_tid[256], sas_svt[256], Index,target_id,set_value;
		sas_tid = strtok(params, Index);
		sas_svt = strrest(params, Index);
		target_id = strval(sas_tid);
		set_value = strval(sas_svt);
		if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, red, "[-] NO [-]");
        if(!IsPlayerConnected(target_id)) return SendClientMessage(playerid, red, "[-] NO C! [-]");
        if(set_value == 000) return TogglePlayerFakePing(target_id, false) && SendClientMessage(playerid, -1, "[-] OK [-]");
		new skin_str[256];
		format(skin_str,sizeof(skin_str), "El ping de %s [ID: %d] fue colocado en %d",PlayerName2(target_id),target_id,GetPlayerSkin(target_id),set_value);
        TogglePlayerFakePing(target_id, true);
        SetPlayerFakePing(target_id, set_value);
		return SendClientMessage(playerid,-1,skin_str);
}
*/
dcmd_reportes(playerid,params[]) {
	#pragma unused params
    new uREPORTStext[2000],strREPORT[650];
    if(PlayerInfo[playerid][nivel] >= 1)
	{
        new ReportCount;
		for(new i = 1; i < MAX_REPORTS; i++)
		{
			if(strcmp( Reports[i], "<none>", true) != 0)
			{
				ReportCount++;
				format(strREPORT,sizeof(strREPORT),"{F50000}#%d {FFFFFF}| %s\n",ReportCount,Reports[i]);
				strcat(uREPORTStext,strREPORT);
			}
		}
		if(ReportCount == 0) {ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{4DFFFF}Reportes de Usuarios", "{E6FFCC}EN HORA BUENA!, NO HAY NINGUN REPORTE REGISTRADO.", "x", "");}
		if(ReportCount > 0) {ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{4DFFFF}Reportes de Usuarios", uREPORTStext, "x", "");}
    }
	return 1;
}
dcmd_admins(playerid,params[])
{
	if(PlayerInfo[playerid][nivel] < 2) return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{ffffff}Administración:{f50000} ZR", "{4DFFFF}La Lista de Administración de RZ no esta disponible.", "x", "");
	#pragma unused params
	new conteo, admins[664],texto[256],titulo[128];
	for(new i = 0; i < GetMaxPlayers(); i++)
	{
		if(IsPlayerAdmin(i) && (PlayerInfo[i][Ocultado] == 0 && !IsPlayerAdmin(playerid)) && IsPlayerConnected(i))
		{
			conteo++;
		}
		else if(PlayerInfo[i][nivel] >= 1 && (PlayerInfo[i][Ocultado] == 0 && !IsPlayerAdmin(playerid)) && IsPlayerConnected(i))
		{
			conteo++;
		}
	}
	if(conteo == 0) ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{ffffff}Administración:{f50000} ZR", "{4DFFFF}La Lista de Administración de Zombie Revolution No se da a conocer por razones de seguridad.", "x", "");
	format(titulo,128,"Admins Conectados: {FFFFFF}%d",conteo);
	for(new i = 0; i < GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i) && PlayerInfo[i][Ocultado] == 0)
		{
			if(IsPlayerAdmin(i) && PlayerInfo[i][Ocultado] == 0)
			{
				format(texto,sizeof(texto),"{FFFFFF}%s [%d] [Nivel]: {FF0033}Rcon (%d).\n",PlayerName2(i),i,PlayerInfo[i][nivel]);
				strcat(admins,texto);
			}
			else if(PlayerInfo[i][nivel] >= 1 && PlayerInfo[i][Ocultado] == 0)
			{
				format(texto,sizeof(texto),"{FFFFFF}%s [%d] [Nivel]: {FF0033}%d\n",PlayerName2(i),i,PlayerInfo[i][nivel]);
				strcat(admins,texto);
			}
		}
	}
	ShowPlayerDialog(playerid,Administradores,DIALOG_STYLE_MSGBOX,titulo,admins,"Duda","x");
	return 1;
}

dcmd_peers(playerid,params[])
{
	#pragma unused params
	new conteo = 0, admins[1024],texto[256],titulo[128];
	for(new i = 0; i < GetMaxPlayers(); i++)
	{
		if(RZClient_IsClientConnected(i) && (PlayerInfo[i][Ocultado] == 0 && !IsPlayerAdmin(playerid)))
		{
			conteo++;
		}
	}
	if(conteo == 0) ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{ffffff}RZClient:{f50000} PEERS", "{4DFFFF}Ningun usuario está conectado con el RZClient.", "x", "");
	format(titulo,sizeof(titulo),"RZClient Peers: {FFFFFF}%d",conteo);
	for(new i = 0; i < GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i))
		{
			if(RZClient_IsClientConnected(i) && (PlayerInfo[i][Ocultado] == 0 && !IsPlayerAdmin(playerid)))
			{
				format(texto,sizeof(texto),"%s [%d]\n",PlayerName2(i),i);
				strcat(admins,texto);
			}
		}
	}
	ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,titulo,admins,"x","");
	return 1;
}

dcmd_vips(playerid,params[])
{
#pragma unused params
new conteo, admins[1024],texto[128],titulo[128];
for(new i = 0; i < GetMaxPlayers(); i++)
{
	if(PlayerInfo[i][VIP] >= 1 && IsPlayerConnected(i) && PlayerInfo[i][Ocultado] == 0)
	{
		conteo++;
	}
}
if(conteo == 0)return SendClientMessage(playerid,red,"No hay jugadores V.I.P conecatados."); //esto para cuando no alla admins , No saldra el menu
format(titulo,128,"V.I.P.S Conectados: {FFFFFF}%d",conteo);

for(new i = 0; i < GetMaxPlayers(); i++)
{
	if(IsPlayerConnected(i))
	{
		if(PlayerInfo[i][VIP] == 1 && (PlayerInfo[i][Ocultado] == 0 && !IsPlayerAdmin(playerid)))
		{
		format(texto,128,"{FFFFFF}%s [%d] [Nivel]: {FF0033}» SILVER «\n\n",PlayerName2(i),i);
		strcat(admins,texto);
		}
		if(PlayerInfo[i][VIP] == 2 && (PlayerInfo[i][Ocultado] == 0 && !IsPlayerAdmin(playerid)))
		{
		format(texto,128,"{FFFFFF}%s [%d] [Nivel]: {FF0033}» GOLD «\n\n",PlayerName2(i),i);
		strcat(admins,texto);
		}
		else if(PlayerInfo[i][VIP] == 3 && (PlayerInfo[i][Ocultado] == 0 && !IsPlayerAdmin(playerid)))
		{
		format(texto,128,"{FFFFFF}%s [%d] [Nivel]: {FF0033}» PREMIUM «\n\n",PlayerName2(i),i);
		strcat(admins,texto);
		}
	}
}
ShowPlayerDialog(playerid,PVips,DIALOG_STYLE_MSGBOX,titulo,admins,"x","");
return 1;
}

dcmd_invisibles(playerid,params[])
{
#pragma unused params
new conteo, admins[1500],texto[128],titulo[128];
for(new i = 0; i < GetMaxPlayers(); i++)
{
if(PlayerInfo[i][VIP] >= 1 && PlayerInfo[i][invisible] == 1 && (PlayerInfo[i][Ocultado] == 0 && !IsPlayerAdmin(playerid)))
{
conteo++;
}
}
if(conteo == 0)return SendClientMessage(playerid,red,"No hay jugadores V.I.P invisibles.");
format(titulo,128,"V.I.P.S Conectados: {FFFFFF}%d",conteo);

for(new i = 0; i < GetMaxPlayers(); i++)
{
if(IsPlayerConnected(i))
{
if(PlayerInfo[i][VIP] == 1 && PlayerInfo[playerid][invisible] == 1 && !IsPlayerAdmin(i))
{
format(texto,128,"{FFFFFF}%s [%d] [STATUS]: {FF0033}INVISIBLE\n\n",PlayerName2(i),i);
strcat(admins,texto);
}
}
}
ShowPlayerDialog(playerid,PVips,DIALOG_STYLE_MSGBOX,titulo,admins,"x","");
return 1;
}
PUBLIC:Float:GetDistanceBetweenPositions(Float:X1,Float:Y1,Float:Z1,Float:X2,Float:Y2,Float:Z2)
{
	return floatsqroot(floatpower(floatabs(floatsub(X2, X1)), 2)+floatpower(floatabs(floatsub(Y2, Y1)), 2)+floatpower(floatabs(floatsub(Z2, Z1)), 2));
}
//==============================================================================
// Public - Float:GetDistanceBetweenPlayers.
//==============================================================================
public Float:GetDistanceBetweenPlayers(P1, P2)
{
	new Float:X1, Float:Y1, Float:Z1, Float:X2, Float:Y2, Float:Z2;
	if(!IsPlayerConnected(P1) || !IsPlayerConnected(P2))
	{
		return -1.00;
	}
	GetPlayerPos(P1, X1, Y1, Z1);
	GetPlayerPos(P2, X2, Y2, Z2);
	return floatsqroot(floatpower(floatabs(floatsub(X2, X1)), 2)+floatpower(floatabs(floatsub(Y2, Y1)), 2)+floatpower(floatabs(floatsub(Z2, Z1)), 2));
}
stock IsZombieStreamedOut(npcid, playerid)
{
if(PlayerInfo[playerid][InCORE] == 1) return 0;
if(!IsPlayerConnected(npcid) || !IsPlayerConnected(playerid)) return 1;
new Float:X1, Float:Y1, Float:ZombiePOS, Float:X2, Float:Y2, Float:HumanPOS;
GetPlayerPos(npcid, X1, Y1, ZombiePOS);
GetPlayerPos(playerid, X2, Y2, HumanPOS);
//SendFormatMessageToAll(-1,"ZombiePOS: %f || HumanPOS: %f",ZombiePOS,HumanPOS);
if(ZombiePOS <= HumanPOS) return 0;
else if(ZombiePOS >= 10.0) return 1;
else return 0;
}
//==============================================================================
// Public - GetClosestPlayer.
//==============================================================================


public GetClosestPlayerForDrone(P1)
{
	new X, Float:Dis, Float:Dis2, Player;
	Player = INVALID_PLAYER_ID;
	Dis = 99999.99;
	for (X=0; X< GetMaxPlayers(); X++)
	{
		if(IsPlayerConnected(X) && !IsPlayerNPC(X) && !IsPlayerPaused(X) && !IsPlayerDead(X) )
		{
			if(X != P1 && PlayerInfo[X][DRONE_ID] == INVALID_PLAYER_ID)
			{
				Dis2 = GetDistanceBetweenPlayers(X,P1);
				if(Dis2 < Dis && Dis2 != -1.00)
				{
					Dis = Dis2;
					Player = X;
				}
			}
		}
	}
	return Player;
}
public GetClosestPlayer(P1)
{
new X, Float:Dis, Float:Dis2, Player;
Player = INVALID_PLAYER_ID;
Dis = 99999.99;
for (X=0; X< GetMaxPlayers(); X++)
{
if(IsPlayerConnected(X) && !IsPlayerNPC(X))
{
if(X != P1)
{
Dis2 = GetDistanceBetweenPlayers(X,P1);
if(Dis2 < Dis && Dis2 != -1.00)
{
Dis = Dis2;
Player = X;
}
}
}
}
return Player;
}


public OnPlayerExitVehicle(playerid, vehicleid)
{
	NOH_OnPlayerExitVehicle(playerid, vehicleid);
	if(PlayerInfo[playerid][DoorsLocked] == 1) SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),playerid,false,false);
	return 1;
}



stock GetWeaponNameEx(weaponid, weapon[], len = sizeof(weapon))
{
    switch(weaponid)
    {
        case 18: strcat(weapon, "Molotov Cocktail", len);
        case 44: strcat(weapon, "Googles de Visión Nocturna", len);
        case 45:  strcat(weapon, "Googles Infrarojos", len);
        default: GetWeaponName(weaponid, weapon, len);
    }
    return weapon;
}


PUBLIC:AssignDroneToPlayer(AssignedDrone, playerid, max_owner_distance, max_attack_distance, min_attack_distance, min_attack, max_attack)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	SetVehiclePos(NPC_INFO[AssignedDrone][NPCVehicleID], x, y, z + 5);
	FCNPC_PutInVehicle(AssignedDrone, NPC_INFO[AssignedDrone][NPCVehicleID], 0);
    PlayerInfo[playerid][DRONE_ID] = AssignedDrone;//set drone for playerid.
	NPC_INFO[AssignedDrone][LastFinded] = playerid;
	NPC_INFO[AssignedDrone][Attacking] = INVALID_PLAYER_ID;

	NPC_INFO[AssignedDrone][DRONE_MAX_OWNER_DISTANCE] = max_owner_distance;
	NPC_INFO[AssignedDrone][DRONE_MAX_ATTACK_DISTANCE] = max_attack_distance;
	NPC_INFO[AssignedDrone][DRONE_MIN_ATTACK_DISTANCE] = min_attack_distance;

	NPC_INFO[AssignedDrone][DRONE_MAX_ATTACK_HIT] = max_attack;
	NPC_INFO[AssignedDrone][DRONE_MIN_ATTACK_HIT] = min_attack;
	GameTextForPlayer(playerid, "~b~~h~~h~LINKED!", 1000, 3);
	SendFormatMessage(playerid, COLOR_ARTICULO,"]> DroneSystem <[ {FFFF33} %s {ffffff}Rango de seguimiento: %dkm, Rango de detección enemiga: %dkm.", PlayerName2(AssignedDrone), max_owner_distance, max_attack_distance);
	SendFormatMessage(playerid, COLOR_ARTICULO,"]> DroneSystem <[ {FFFF33} %s {ffffff}Rango de ataque: %dkm, Hit maximo: %d, Hit minimo: %d.", PlayerName2(AssignedDrone), min_attack_distance, max_attack, min_attack);
	TogglePlayerControllable(playerid, 1);
	PlayerInfo[playerid][SpawnProtection] = 0;

	new data[60];
	format(data,sizeof(data),""HUMANO_COL"%s (%d)\n"DRONE_COL"I.A. Drone",PlayerName2(playerid),playerid);
	new vehicleid = NPC_INFO[AssignedDrone][NPCVehicleID];
	if(IsValidVehicle(vehicleid))
	{
        if ( VehicleLabel[vehicleid] != Text3D:INVALID_3DTEXT_ID ) // The label is an invalid one.
        {
			//Update3DTextLabelText(VehicleLabel[vehicleid], 0xFFFFFFFF, data);
			Delete3DTextLabel(VehicleLabel[vehicleid]);
		}
		VehicleLabel[vehicleid] = Create3DTextLabel(data, 0xFFFFFFFF, 0.0, 0.0, 0.50, 25.0, 0, 0);
		Attach3DTextLabelToVehicle(VehicleLabel[vehicleid], vehicleid, 0.0, 0.0, 0.50);
	}
	return 1;
}

stock NegociarDrone(playerid, name[], price, max_owner_distance, max_attack_distance, min_attack_distance, min_attack, max_attack)
{
    if(GetPlayerMoney(playerid) < price) return SendFormatMessage(playerid, COLOR_ARTICULO, "[COMERCIO]: {ffffff} No tienes el dinero suficiente para adquirir el drone %s.", name);
    new AssignedDrone = GetUnusedDrone();
    if(AssignedDrone == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_ARTICULO, "[COMERCIO]: {ffffff} se me han agotado los drones!, vuelve más tarde.");
	if(PlayerInfo[playerid][DRONE_ID] != INVALID_PLAYER_ID)
	{
		FreeDroneBOT(PlayerInfo[playerid][DRONE_ID], playerid);
	}
    GivePlayerMoney(playerid, -price);
	TogglePlayerControllable(playerid, 0);
	GameTextForPlayer(playerid, "~y~~h~~h~Vinculando drone..", 5000, 3);
	PlayerInfo[playerid][SpawnProtection] = 1;
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	FCNPC_PutInVehicle(AssignedDrone, NPC_INFO[AssignedDrone][NPCVehicleID], 0);
	SetVehiclePos(NPC_INFO[AssignedDrone][NPCVehicleID], x, y, z + 5);
	SetTimerEx("AssignDroneToPlayer", 2000, 0, "ddddddd", AssignedDrone, playerid, max_owner_distance, max_attack_distance, min_attack_distance, min_attack, max_attack);
	return SendFormatMessage(playerid, COLOR_ARTICULO, "[COMERCIO]: {ffffff} Has adquirido el drone {FF0099}%s{ffffff}.", name);
}

stock NegociarArma(playerid, weaponid, ammo, cash)
{
	new wname[40];
	GetWeaponNameEx(weaponid, wname, sizeof(wname));
    if(GetPlayerMoney(playerid) < cash) return SendFormatMessage(playerid, COLOR_ARTICULO, "[COMERCIO]: {ffffff} No tienes el dinero suficiente para adquirir el arma %s, compadre.",wname);
    GivePlayerMoney(playerid, -cash);
    GivePlayerWeaponEx(playerid,weaponid,ammo);
	return SendFormatMessage(playerid, COLOR_ARTICULO, "[COMERCIO]: {ffffff} Has adquirido el arma {FF0099}%s{ffffff}.",wname);
}

stock NegociarAntibiotico(playerid, antibiotic[], precio, Float:salud)
{
    if(GetPlayerMoney(playerid) < precio) return SendFormatMessage(playerid, COLOR_ARTICULO, "[COMERCIO]: {ffffff} No tienes el dinero suficiente para adquirir el antibiotico %s.",antibiotic);
    GivePlayerMoney(playerid, -precio);
    new Float:saludact;
    GetPlayerHealth(playerid, saludact);
    salud = salud+saludact;
    if(salud >= 100)
    {
        salud = float(100);
    }
    SetPlayerHealth(playerid, salud);
	return SendFormatMessage(playerid, COLOR_ARTICULO, "[COMERCIO]: {ffffff} Has adquirido el antibiotico {FF0099}%s{ffffff} Ahora tu salud está al {FF0099}%.1f {ffffff}porciento.",antibiotic,salud);
}



stock LoadSQLCars() // A stock which loads the all the cars from the database to the server.
{
        new DBResult: result,id = 1,query[256],data[256],idc = 0;
        new modelid,Float:carx,Float:cary,Float:carz,Float:carzangle,Float:vheal;
        while(id < MAX_VEHICLES)
        {
	        format(query,sizeof(query),"SELECT * FROM `vehiculos` WHERE `id` = '%d'",id);
	        result = db_query(DataBase_USERS,query);
	        if(db_num_rows(result))
	        {
	                db_get_field_assoc(result, "modelid",data,sizeof(data)); modelid = strval(data);
	                db_get_field_assoc(result, "carx",data,sizeof(data)); carx = floatstr(data);
	                db_get_field_assoc(result, "cary",data,sizeof(data)); cary = floatstr(data);
	                db_get_field_assoc(result, "carz",data,sizeof(data)); carz = floatstr(data);
	                db_get_field_assoc(result, "carzangle",data,sizeof(data)); carzangle = floatstr(data);
	                db_get_field_assoc(result, "health",data,sizeof(data)); vheal = floatstr(data);
	                SQLVehicle[id] = CreateVehicle(modelid,carx,cary,carz,carzangle,random(225),random(225),10*60);
	                SetVehicleHealth(SQLVehicle[id], vheal);
	                //printf("AddStaticVehicle(%d,%f,%f,%f,%f,%f)\n", modelid,carx,cary,carz,carzangle,vheal);
	                idc++;
	        }
	        db_free_result(result);
	        id++;
        }
        printf("Vehiculos Cargados: %d", idc);
        return 1;
}


PUBLIC:SaveSQLVehicle(vID)
{
		new Float:vPos[4],query[500];
        GetVehiclePos(vID,vPos[0],vPos[1],vPos[2]);
        GetVehicleZAngle(vID,vPos[3]);
        new vModel = GetVehicleModel(vID),Float:vhealth;
        GetVehicleHealth(vID, vhealth);
        format(query,sizeof(query),"INSERT INTO `vehiculos` (id, name, modelid, carx, cary, carz, caranlge, health) VALUES ('%d','%s','%d','%f','%f','%f','%f','%f')",vID,VehicleNames[vModel-400],vModel,vPos[0],vPos[1],vPos[2],vPos[3],vhealth);
        db_query(DataBase_USERS,query);
        //printf("%s\n", query);
        return 1;
}

PUBLIC:SaveSQLCars()
{
	for(new cars=0; cars<MAX_VEHICLES; cars++)
	{
		if(!VehicleOccupied(cars))
		{
			SetVehicleToRespawn(cars);
		}
	}
	new id = 1;
    db_query(DataBase_USERS,"DELETE FROM vehiculos");//eliminar todos para insertar los nuevos
	while(id < MAX_VEHICLES)
	{
		if(IsValidVehicle(id) && !VehicleOccupied(id) && !IsVehicleRCVehicle(id))
		{
			SaveSQLVehicle(id);
		}
		id++;
	}
	return 1;
}

PUBLIC:SaveSQLDroppedWeapon(slotid,Float:x,Float:y,Float:z,data1,data2,isdefault)
{
		new query[500];
        format(query,sizeof(query),"REPLACE INTO `DroppedWeapons` (id,x,y,z,d1,d2,taken,server_default) VALUES ('%d','%f','%f','%f','%d','%d','0','%d')", slotid,x,y,z,data1,data2,isdefault);
        db_query(DataBase_USERS,query);
        //printf("%s\n", query);
        return 1;
}

stock LoadSQLDroppedWeapons()
{
		for(new n = 0; n < MAX_DROPPED_WEAPONS; n++) dGunData[n][ObjID] = -1;
        new DBResult: result,query[256],data[256],idc = 0, respawneables_idc = 0;
        for(new g = 0; g < MAX_DROPPED_WEAPONS; g++)
        {
	        format(query,sizeof(query),"SELECT * FROM `DroppedWeapons` WHERE `id` = '%d'",g);
	        result = db_query(DataBase_USERS,query);
	        if(db_num_rows(result))
	        {
                    DestroyDynamicObject( dGunData[g][ObjID] );
                    DestroyDynamic3DTextLabel( dGunData[g][objLabel] );

                    new dweaponId, dweaponAmmo, dweaponDefault, Float:dweaponX,Float:dweaponY,Float:dweaponZ;

	                db_get_field_assoc(result, "d1",data,sizeof(data)); dweaponId = strval(data);
	                db_get_field_assoc(result, "d2",data,sizeof(data)); dweaponAmmo = strval(data);

	                db_get_field_assoc(result, "x",data,sizeof(data)); dweaponX = floatstr(data);
	                db_get_field_assoc(result, "y",data,sizeof(data)); dweaponY = floatstr(data);
	                db_get_field_assoc(result, "z",data,sizeof(data)); dweaponZ = floatstr(data);

                    db_get_field_assoc(result, "server_default",data,sizeof(data)); dweaponDefault = strval(data);

                    CreateDroppedGun(dweaponId, dweaponAmmo, dweaponX, dweaponY, dweaponZ, dweaponDefault, 0, 0);//do not find z coord.

					//printf("* %s Cargada: %f,%f,%f", GunNames[dGunData[g][ObjData][0]], dGunData[g][ObjPos][0], dGunData[g][ObjPos][1], dGunData[g][ObjPos][2]-1);
	                idc++;
	                if(dweaponDefault == 1){
	                //printf("* Respawneable %s Weapon Loaded: %f,%f,%f", GunNames[dGunData[g][ObjData][0]], dGunData[g][ObjPos][0], dGunData[g][ObjPos][1], dGunData[g][ObjPos][2]-1);
	                respawneables_idc++;
	                }
	        }
	        db_free_result(result);
        }
        printf("Armas en el piso Cargadas: %d", idc);
        printf("Armas en el piso respawneaables: %d", respawneables_idc);
        ACTUAL_DROPPED_WEAPONS = idc;
        return 1;
}

#if defined SAVING
stock RemoveSQLDroppedWeapon(Float:x,Float:y,Float:z,data1,data2,isdefault)
{
	if(isdefault == 0)//si no es default
	{
	new SQLDelete[256];
	format(SQLDelete, sizeof(SQLDelete), "DELETE FROM DroppedWeapons WHERE x='%f' AND y='%f' AND z='%f' AND d1='%d' AND d2='%d' AND server_default=0",x,y,z,data1,data2);
	db_query(DataBase_USERS,SQLDelete);
	//printf("%s\n",SQLDelete);
	}
	else//setear a taken para decirle al server q debe respawnear esta arma!
	{
	new SQLUpdate[256];
	format(SQLUpdate, sizeof(SQLUpdate), "UPDATE DroppedWeapons SET taken=1 WHERE x='%f' AND y='%f' AND z='%f' AND d1='%d' AND d2='%d' AND server_default=1",x,y,z,data1,data2);
	db_query(DataBase_USERS,SQLUpdate);
	}
}



PUBLIC:SaveSQLDroppedWeapons()
{

	for(new g = 0; g < MAX_DROPPED_WEAPONS; g++)
	{
		if(dGunData[g][ObjData][0] > 0 && dGunData[g][ObjPos][1] != 0)
		{
			SaveSQLDroppedWeapon(g,dGunData[g][ObjPos][0],dGunData[g][ObjPos][1],dGunData[g][ObjPos][2],dGunData[g][ObjData][0],dGunData[g][ObjData][1],dGunData[g][ObjData][3]);
			//printf("WeaponId %d ready.",dGunData[g][ObjData][0]);
		}
	}

}


#endif

stock DynamicObjectOnPosition(id, Float:x,Float:y,Float:z)
{
	new Float:ox,Float:oy,Float:oz;
    GetDynamicObjectPos(id, ox, oy, oz);
    if(x == ox && y == oy && z == oz) return true;
    else return false;
}

stock ReloadDefaultDroppedWeapons()
{
		//for(new n = 0; n < MAX_DROPPED_WEAPONS; n++) dGunData[n][ObjID] = -1;
        new DBResult: result,query[256],data[256],idc = 0;
        for(new g = 0; g < MAX_DROPPED_WEAPONS; g++)
        {
	        format(query,sizeof(query),"SELECT * FROM `DroppedWeapons` WHERE `id` = '%d' AND server_default=1",g);
	        result = db_query(DataBase_USERS,query);
	        if(db_num_rows(result))
	        {
	            if(dGunData[g][ObjID] == -1 && dGunData[g][ObjData][2] == 1)//si el slot "g" no esta siendo usado y si g ha sido tomado, entonces:
	            {
                    DestroyDynamicObject( dGunData[g][ObjID] );
                    DestroyDynamic3DTextLabel( dGunData[g][objLabel] );

                    new dweaponId, dweaponAmmo, dweaponDefault, Float:dweaponX,Float:dweaponY,Float:dweaponZ;

	                db_get_field_assoc(result, "d1",data,sizeof(data)); dweaponId = strval(data);
	                db_get_field_assoc(result, "d2",data,sizeof(data)); dweaponAmmo = strval(data);

	                db_get_field_assoc(result, "x",data,sizeof(data)); dweaponX = floatstr(data);
	                db_get_field_assoc(result, "y",data,sizeof(data)); dweaponY = floatstr(data);
	                db_get_field_assoc(result, "z",data,sizeof(data)); dweaponZ = floatstr(data);

                    db_get_field_assoc(result, "server_default",data,sizeof(data)); dweaponDefault = strval(data);

                    CreateDroppedGun(dweaponId, dweaponAmmo, dweaponX, dweaponY, dweaponZ, dweaponDefault, 0, 0);//do not load zcoord.
                    idc++;
             	}
	        }
	        db_free_result(result);
        }
        printf("[DroppedReload]: Armas recargadas => %d | Actual Dropped:  %d | New Dropped: %d", idc, ACTUAL_DROPPED_WEAPONS, ACTUAL_DROPPED_WEAPONS+idc);
        ACTUAL_DROPPED_WEAPONS = ACTUAL_DROPPED_WEAPONS+idc;
        return 1;
}

stock SetSQLWeaponData(playerid)
{
	new has_weapons = 0;
	for (new xw = 0; xw <= 12; xw ++)
	{
	    if(SQLWeaponData[playerid][xw][1] > 0)
		{
	        GivePlayerWeaponEx(playerid, SQLWeaponData[playerid][xw][0], SQLWeaponData[playerid][xw][1]);
	        SQLWeaponData[playerid][xw][0] = 0;
	        SQLWeaponData[playerid][xw][1] = 0;
	        has_weapons = 1;
        }
	}
	return has_weapons;
}

PUBLIC:SaveSQLWeaponData(playerid)
{
	new query[1000],k_PName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, k_PName, MAX_PLAYER_NAME);
    if(PlayerInfo[playerid][dead] == 1)
    {
	    format(query, sizeof query, "UPDATE WeaponData SET `Field3` = '0', `Field4` = '0', `Field5` = '0', `Field6` = '0', `Field7` = '0', `Field8` = '0', `Field9` = '0', `Field10` = '0' WHERE `Nickname` = '%s'",
	    k_PName);
	    db_query(DataBase_USERS, query);
	    format(query, sizeof query, "UPDATE WeaponData SET `Field11` = '0', `Field12` = '0', `Field13` = '0', `Field14` = '0', `Field15` = '0', `Field16` = '0', `Field17` = '0', `Field18` = '0' WHERE `Nickname` = '%s'",
	    k_PName);
	    db_query(DataBase_USERS, query);
	    format(query, sizeof query, "UPDATE WeaponData SET `Field19` = '0', `Field20` = '0', `Field21` = '0', `Field22` = '0', `Field23` = '0', `Field24` = '0', `Field25` = '0', `Field26` = '0', `Field27` = '0', `Field28` = '0' WHERE `Nickname` = '%s'",
	    k_PName);
	    db_query(DataBase_USERS, query);
	    PlayerInfo[playerid][dead] = 0;
    }
    else
    {
		//=================ARMAS===================//
	    new weapons[13][2];
	    for (new i = 0; i <= 12; i++)
		{
			GetPlayerWeaponData(playerid, i, weapons[i][0], weapons[i][1]);
			//buscar armas sacadas por hack
			/*if(PlayerHaveAHackedWeapon(playerid,weapons[i][0])){
			PlayerInfo[playerid][dead] = 1;
			SaveSQLWeaponData(playerid);
			return 0;
			}*/
		}
		for(new sslot = 0; sslot != 12; sslot++)
		{
			if(weapons[sslot][0] != 0)
			{
		    	if(PlayerHaveAHackedWeapon(playerid,weapons[sslot][0], weapons[sslot][1]))
				{
                    weapons[sslot][1] = 0;//0 muni

				}
			}
		}
	    format(query, sizeof query, "UPDATE WeaponData SET `Field3` = '%d', `Field4` = '%d', `Field5` = '%d', `Field6` = '%d', `Field7` = '%d', `Field8` = '%d', `Field9` = '%d', `Field10` = '%d' WHERE `Nickname` = '%s'",
	    weapons[0][0], weapons[1][0], weapons[2][0], weapons[3][0], weapons[4][0], weapons[5][0], weapons[6][0], weapons[7][0], k_PName);
	    //printf("\nQEURY:\n%s",query);
	    db_query(DataBase_USERS, query);
	    format(query, sizeof query, "UPDATE WeaponData SET `Field11` = '%d', `Field12` = '%d', `Field13` = '%d', `Field14` = '%d', `Field15` = '%d', `Field16` = '%d', `Field17` = '%d', `Field18` = '%d' WHERE `Nickname` = '%s'",
	    weapons[8][0], weapons[9][0], weapons[10][0], weapons[11][0], weapons[12][0], weapons[0][1], weapons[1][1], weapons[2][1], k_PName);
	    //printf("\nQEURY:\n%s",query);
	    db_query(DataBase_USERS, query);
	    format(query, sizeof query, "UPDATE WeaponData SET `Field19` = '%d', `Field20` = '%d', `Field21` = '%d', `Field22` = '%d', `Field23` = '%d', `Field24` = '%d', `Field25` = '%d', `Field26` = '%d', `Field27` = '%d', `Field28` = '%d' WHERE `Nickname` = '%s'",
	    weapons[3][1], weapons[4][1], weapons[5][1], weapons[6][1], weapons[7][1], weapons[8][1], weapons[9][1], weapons[10][1], weapons[11][1], weapons[12][1], k_PName);
	    //printf("\nQEURY:\n%s",query);
	    db_query(DataBase_USERS, query);
    }
    return 1;
}

stock LoadSQLPlayerWeapons(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new tmp[50], w_idx, a_idx;
	new SQL_CONSULTA[256];
	format(SQL_CONSULTA, sizeof(SQL_CONSULTA), "SELECT * FROM WeaponData WHERE Nickname = '%s'", DB_Escape(PlayerName2(playerid)));
	NUM_ROWS_SQL = db_query(DataBase_USERS,SQL_CONSULTA);
    if(db_num_rows(NUM_ROWS_SQL))
    {
        for (new x = 0; x < 26; x ++)
        {
            db_get_field(NUM_ROWS_SQL, x + 2, tmp, sizeof tmp);
            SQLWeaponData[playerid][w_idx][a_idx] = strval(tmp);
            w_idx ++;
            if (x > 11 && a_idx == 0) w_idx = 0, a_idx = 1;
        }
		SendClientMessage(playerid,red,"]<!>[ {ffffff}Tus armas fueron cargadas correctamente.");
		PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
    	db_free_result(NUM_ROWS_SQL);
    }
    else
    {
        format(SQL_CONSULTA, sizeof(SQL_CONSULTA), "INSERT INTO `WeaponData` (`Nickname`) VALUES ('%s')", DB_Escape(PlayerName2(playerid)));
        db_query(DataBase_USERS, SQL_CONSULTA);
		SendClientMessage(playerid,red,"]<!>[ {ffffff}Nuevo espacio de equipamento creado.");
		SetPVarInt(playerid, "PrimerasArmas", 1);
    }
    return 1;
}


stock IsPlayerIP_RZCBanned(playerid)
{
		new Comprobar[256],UserIP[128];
		GetPlayerIp(playerid, UserIP, sizeof(UserIP));
		format(Comprobar, sizeof(Comprobar), "SELECT * FROM RZCData WHERE ip = '%s' AND locked = '1'",UserIP);
		NUM_ROWS_SQL = db_query(DataBase_USERS,Comprobar);
		if(db_num_rows(NUM_ROWS_SQL) == 0) return 0;
		else return 1;
}

stock IsPlayerAccount_RZCBanned(playerid)
{
		new Comprobar[256];
		format(Comprobar, sizeof(Comprobar), "SELECT * FROM RZCData WHERE Username = '%s' AND locked = '1'", DB_Escape(PlayerName2(playerid)));
		NUM_ROWS_SQL = db_query(DataBase_USERS,Comprobar);
		if(db_num_rows(NUM_ROWS_SQL) == 0) return 0;
		else return 1;
}


stock LoadRZClientData(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new SQL_CONSULTA[256], Field[256];
	if(IsPlayerAccount_RZCBanned(playerid)){
		format(SQL_CONSULTA, sizeof(SQL_CONSULTA), "SELECT * FROM RZCData WHERE Username = '%s'", DB_Escape(PlayerName2(playerid)));
	}
	else if(IsPlayerIP_RZCBanned(playerid)){
		new PlayerIP[128];
		GetPlayerIp(playerid,PlayerIP,sizeof(PlayerIP));
	    format(SQL_CONSULTA, sizeof(SQL_CONSULTA), "SELECT * FROM RZCData WHERE ip = '%s' LIMIT 1",PlayerIP);
	}
	else{
	    format(SQL_CONSULTA, sizeof(SQL_CONSULTA), "SELECT * FROM RZCData WHERE Username = '%s'", DB_Escape(PlayerName2(playerid)));
	}
	NUM_ROWS_SQL = db_query(DataBase_USERS,SQL_CONSULTA);
    if(db_num_rows(NUM_ROWS_SQL))
    {
        db_get_field_assoc(NUM_ROWS_SQL, "locked", Field, sizeof(Field));
        PlayerInfo[playerid][RZClient_Locked] = strval(Field);
		//---
		db_get_field_assoc(NUM_ROWS_SQL, "Username", Field, sizeof(Field));
		strmid(bNick[playerid], Field, 0, strlen(Field));
		//---
		db_get_field_assoc(NUM_ROWS_SQL, "admin", Field, sizeof(Field));
		strmid(bAdmin[playerid], Field, 0, strlen(Field));
		//---
		db_get_field_assoc(NUM_ROWS_SQL, "razon", Field, sizeof(Field));
		strmid(bRazon[playerid], Field, 0, strlen(Field));
		//---
		db_get_field_assoc(NUM_ROWS_SQL, "fecha", Field, sizeof(Field));
		strmid(bFecha[playerid], Field, 0, strlen(Field));
		//---
		db_free_result(NUM_ROWS_SQL);
		SendClientMessage(playerid,red,"]<!>[ {ffffff}RZClient database loaded.");
    }
    else
    {
        //format(SQL_CONSULTA, sizeof(SQL_CONSULTA), "INSERT INTO `RZCData` (`Username`) VALUES ('%s')", DB_Escape(PlayerName2(playerid)));
        //db_query(DataBase_USERS, SQL_CONSULTA);
		//SendClientMessage(playerid,red,"]<!>[ {ffffff}RZClient: new user created.");
    }
    return 1;
}

//==============================================================================
// Public - OnDialogResponse.
//==============================================================================
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(PlayerInfo[playerid][Banned] == 1) return 0;
    RZM_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    //printf("OnDialogResponse(%s [id: %d] [DID: %d] [R: %d] [LI: %d] [IT: %s]", PlayerName2(playerid),playerid,dialogid,response,listitem,inputtext);
	new REGISTRANDO[150];
	new INGRESANDO[151];
	new Nombre[MAX_PLAYER_NAME];
	GetPlayerName(playerid,Nombre,sizeof(Nombre));
	format(REGISTRANDO,sizeof(REGISTRANDO),"{9C00EB}=====> {FFFFFF}%s\n\n{9C00EB}Esta cuenta esta disponible para registrarse\n\n{FFFFFF}Registrala! Elige una contraseña:",Nombre);
	format(INGRESANDO,sizeof(INGRESANDO),"{9C00EB}=====> {FFFFFF}%s\n\n{9C00EB}Esta cuenta esta registrada\n\n{9C00EB}Inicia Sesión Para Jugar!\n\n{f50000}Tipea tu Contraseña:",Nombre);
	if (dialogid == REGISTRO)
	{
	if(PlayerInfo[playerid][Identificado] == 1) return 0;
	new UserName[MAX_PLAYER_NAME];
	if (!strlen(inputtext)) return ShowPlayerDialog(playerid, REGISTRO, DIALOG_STYLE_INPUT, "{FFFFFF}Registro", REGISTRANDO , "Listo", "x");
	if (!response) return ShowPlayerDialog(playerid, REGISTRO, DIALOG_STYLE_INPUT, "{FFFFFF}Registrar Cuenta",REGISTRANDO, "Listo", "x");
	if(response)
	{
	GetPlayerName(playerid, UserName, sizeof(UserName));
	new FORMAT_SQL_REGISTRO[1320];
	new year, Mes, Dia;
	getdate(year, Mes, Dia);
	format(FORMAT_SQL_REGISTRO, sizeof(FORMAT_SQL_REGISTRO), "INSERT INTO Usuarios (Username, Password, Fecha, bIP) VALUES ('%s', '%s','%d/%02d/%d','%s')", DB_Escape(UserName), DB_Escape(inputtext),Dia,Mes,year,PlayerInfo[playerid][IP]);
	db_query(DataBase_USERS,FORMAT_SQL_REGISTRO);
	PlayerInfo[playerid][Identificado] = 0;
	PlayerInfo[playerid][Registrado] = 1;
	PlayerInfo[playerid][Asesinatos] = 0;
	PlayerInfo[playerid][Muertes] = 0;
	PlayerInfo[playerid][Dinero] = 0;
	PlayerInfo[playerid][callado] = 0;
	PlayerInfo[playerid][nivel] = 0;
	PlayerInfo[playerid][SkinID] = 0;
	PlayerInfo[playerid][UsaSkin] = 0;
	PlayerInfo[playerid][Invitado] = 0;
	PlayerInfo[playerid][CLAN] = 0;
 	PlayerInfo[playerid][CLAN_OWN] = 0;
    PlayerInfo[playerid][PM] = 1;
	PlayerInfo[playerid][VirusZ] = 0;
	PlayerInfo[playerid][VirusG] = 0;
	SendClientMessage(playerid,red,"]<!>[ {ffffff}Cuenta exitozamente Registrada, Ya puedes jugar en nuestro servidor, recuerda leer las /rules.");
	SendClientMessage(playerid,red,"]<!>[ {ffffff}Diviertete en el modo supervivencia, es casí único.");
	ShowPlayerDialog(playerid, INGRESO, DIALOG_STYLE_INPUT, ">>", INGRESANDO, ">>", "x");
	}
	return 1;
	}

	if (dialogid == INGRESO)
	{
	if(PlayerInfo[playerid][Identificado] == 1) return 0;
	if (!strlen(inputtext)) return ShowPlayerDialog(playerid,INGRESO, DIALOG_STYLE_INPUT, "{F50000}[== {ffffff}Revolucion Zombie {f50000}==]", INGRESANDO , ">>", "x");
	if (!response) return ShowPlayerDialog(playerid,INGRESO, DIALOG_STYLE_INPUT, "{F50000}[== {ffffff}Revolucion Zombie{f50000} ==]", INGRESANDO , ">>", "x");
	if(response)
	{
		new SQL_CONSULTA[256];
	    format(SQL_CONSULTA, sizeof(SQL_CONSULTA), "SELECT * FROM Usuarios WHERE Username = '%s' AND Password = '%s'", DB_Escape(PlayerName2(playerid)), DB_Escape(inputtext));
	    NUM_ROWS_SQL = db_query(DataBase_USERS,SQL_CONSULTA);
	    if(db_num_rows(NUM_ROWS_SQL) != 0)
	    {
			new Field[256]; //Creating a field to retrieve the data
			//---
			db_get_field_assoc(NUM_ROWS_SQL, "SCORE", Field, sizeof(Field));
			PlayerInfo[playerid][Asesinatos] = strval(Field);
			//---
			db_get_field_assoc(NUM_ROWS_SQL, "DINERO", Field, sizeof(Field));
			PlayerInfo[playerid][Dinero] = strval(Field);
			//---
			db_get_field_assoc(NUM_ROWS_SQL, "ADMIN", Field, sizeof(Field));
			PlayerInfo[playerid][nivel] = strval(Field);
			//---
			db_get_field_assoc(NUM_ROWS_SQL, "VIP", Field, sizeof(Field));
			PlayerInfo[playerid][VIP] = strval(Field);
			//---
			db_get_field_assoc(NUM_ROWS_SQL, "skinP", Field, sizeof(Field));
			PlayerInfo[playerid][UsaSkin] = strval(Field);
			//---
			db_get_field_assoc(NUM_ROWS_SQL, "skinID", Field, sizeof(Field));
			PlayerInfo[playerid][SkinID] = strval(Field);
			//---
			db_get_field_assoc(NUM_ROWS_SQL, "LX", Field, sizeof(Field));
			PlayerInfo[playerid][LX] = floatstr(Field);
			//---
			db_get_field_assoc(NUM_ROWS_SQL, "LY", Field, sizeof(Field));
			PlayerInfo[playerid][LY] = floatstr(Field);
			//---
			db_get_field_assoc(NUM_ROWS_SQL, "LZ", Field, sizeof(Field));
			PlayerInfo[playerid][LZ] = floatstr(Field);
			//---
			db_get_field_assoc(NUM_ROWS_SQL, "LA", Field, sizeof(Field));
			PlayerInfo[playerid][LA] = floatstr(Field);
			//---
			db_get_field_assoc(NUM_ROWS_SQL, "sangre", Field, sizeof(Field));
			PlayerInfo[playerid][LHE] = floatstr(Field);
			//---
			db_get_field_assoc(NUM_ROWS_SQL, "armadura", Field, sizeof(Field));
			PlayerInfo[playerid][LAR] = floatstr(Field);
			//---
			db_get_field_assoc(NUM_ROWS_SQL, "Password", Field, sizeof(Field));
			strmid(Password[playerid], Field, 0, strlen(Field));
			//---
			db_get_field_assoc(NUM_ROWS_SQL, "CLAN", Field, sizeof(Field));
			PlayerInfo[playerid][CLAN] = 0;
			PlayerInfo[playerid][CLAN] = strval(Field);
			//---
			db_get_field_assoc(NUM_ROWS_SQL, "CLAN_TAG", Field, sizeof(Field));
			ClanTAG[playerid][0] = EOS;
			strmid(ClanTAG[playerid], Field, 0, strlen(Field));
			if(strlen(ClanTAG[playerid]) <= 2)
			{
				PlayerInfo[playerid][CLAN] = 0;
				PlayerInfo[playerid][CLAN_OWN] = 0;
				PlayerInfo[playerid][InvitadorID] = 0;
				ClanTAG[playerid][0] = EOS;
			}
			//---
			db_get_field_assoc(NUM_ROWS_SQL, "CLAN_OWN", Field, sizeof(Field));
			PlayerInfo[playerid][CLAN_OWN] = strval(Field);
			//---
			db_get_field_assoc(NUM_ROWS_SQL, "Fecha", Field, sizeof(Field));
			strmid(Fecha_REG[playerid], Field, 0, strlen(Field));
	        db_free_result(NUM_ROWS_SQL);
		    SetPlayerScore(playerid,PlayerInfo[playerid][Asesinatos]);
		    GivePlayerMoney(playerid,PlayerInfo[playerid][Dinero]);
		    PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		    PlayerInfo[playerid][Ocultado] = 0;
			PlayerInfo[playerid][Identificado] = 1;
			PlayerInfo[playerid][Registrado] = 1;
			PlayerInfo[playerid][PM] = 1;
			PlayerInfo[playerid][VirusZ] = 0;
			PlayerInfo[playerid][VirusG] = 0;
			PlayerInfo[playerid][ZombieSpawnerTick] = GetTickCount();
			#if defined USE_ZOMBIE_RADAR
			KillTimer(PlayerInfo[playerid][TimerCheck]);
			PlayerInfo[playerid][TimerCheck] = SetTimerEx("UpdateRadar", 4500, 1, "d", playerid);
			#endif
			SendClientMessage(playerid,red,"]<!>[ {ffffff}Te has identificado correctamente! :D");
			PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
			LoadSQLPlayerWeapons(playerid);
			SetPVarInt(playerid, "PrimerSpawn", 1);
			LoadMissionInfo(playerid);
			LoadRZClientData(playerid);
		}
		else
		{
			new SString[119];
			PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
			format(SString,sizeof(SString),"{9C00EB}La Contraseña: '{ffffff} %s {9C00EB}' que has tipeado es incorrecta, intentalo de nuevo.",inputtext);
			ShowPlayerDialog(playerid, INGRESO, DIALOG_STYLE_INPUT, "{F50000}[== {ffffff}Revolucion Zombie{f50000} ==]",SString, "Listo", "x");
			PlayerInfo[playerid][ContrasenaIncorrecta]++;
			if(PlayerInfo[playerid][ContrasenaIncorrecta] >= 3)
			{
			Kick(playerid);
			}
		}




    }
	return 1;
	}
	if(dialogid == ADMIN_CMDS)
	{
		if(response == 1)
		{
		CallLocalFunction("OnPlayerCommandText", "is", playerid, "/acmds2");
		return 1;
		}
		return 1;
	}
	if(dialogid == DIALOG_COMANDOS)
	{
		if(response == 1)
		{
		CallLocalFunction("OnPlayerCommandText", "is", playerid, "/COMANDOS2");
		return 1;
		}
		return 1;
	}


	if(dialogid == DIALOG_STATS)
	{
    if(response == 1)
    {
	if(IsPlayerConnected(playerid)) {
	new string[256];
	format(string, sizeof(string), "/stats %d",PlayerInfo[playerid][StatsID]);
	CallLocalFunction("OnPlayerCommandText", "is",playerid,string);
	}
	}
	return 1;
	}

	#if defined SistemaDECombustible
	if(dialogid == BIDON_DIALOG)
	{
		if(response == 1)
	    {
	    new Cantidad = strval(inputtext),gastos_totales,RecargandoXD[256];
	    if(!IsNumeric(inputtext)) return ShowPlayerDialog(playerid,BIDON_DIALOG,DIALOG_STYLE_INPUT,"{ffffff}Recargar {f50000}Combustible","{B06388}* Escriba Los litros en Numeros NO en Letras.",">>","x");
	    if(Cantidad >= 100) return ShowPlayerDialog(playerid,BIDON_DIALOG,DIALOG_STYLE_INPUT,"{ffffff}Recargar {f50000}Combustible","{B06388}ERROR:{ffffff} La capacidad maxima de combustible del vehiculo es de 100 litros.",">>","x");
	    if(Cantidad <= 0) return ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{ffffff}Recargar {f50000}Combustible","{B06388}ERROR:{ffffff} No puedes recargar 0 litros, 0 litros no es nada, no mames!.","x","");
        gastos_totales = Cantidad*100;
		if(GetPlayerMoney(playerid) < gastos_totales) return ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{ffffff}Recargar {f50000}Combustible","{B06388}ERROR:{ffffff} No tienes el dinero suficiente para recargar los litros que indicaste.","x","");
		/* RECARGAR */
        GameTextForPlayer(playerid,"~R~RECARGANDO ~W~COMBUSTIBLE...",2500,3);
	    //SetCameraBehindPlayer(playerid);
	    Rellenando[playerid] = 1;
	    TextDrawSetString(Gasolina[playerid], "Recargando...");
	    RellenoTimer[playerid] = SetTimerEx("TiempoRelleno", 2500, false, "id", playerid,Cantidad);
		/*---------- */
		GivePlayerMoney(playerid, -gastos_totales);
		format(RecargandoXD,sizeof(RecargandoXD),"{ffffff} Has gastado un total de ${00FF66}%d{ffffff} en {7AFFAF}%d {ffffff}litros de combustible.",gastos_totales,Cantidad);
		ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX, "{f50000}[ » Revolucion Zombie « ]:{ffffff} Combustible.",RecargandoXD,"X","");
		}
		return 1;
	}
	#endif

	if(dialogid == CLAN_CREAR)
	{
	    if(response == 1)
	    {
		new Comprobar[100];
		format(Comprobar, sizeof(Comprobar), "SELECT * FROM Usuarios WHERE CLAN_TAG = '%s' AND CLAN_OWN ='1'", DB_Escape(inputtext));
		NUM_ROWS_SQL = db_query(DataBase_USERS,Comprobar);
		new existe = db_num_rows(NUM_ROWS_SQL);
		db_free_result(NUM_ROWS_SQL);
		if(existe > 0) return ShowPlayerDialog(playerid,CLAN_CREAR,DIALOG_STYLE_INPUT,"Creacion de Clan","{F50000}ERROR, EL TAG QUE ELEGISTE YA EXISTE, ESCOJE OTRO.","Crear","Cancelar");
	    if(strlen(inputtext) > 10 && !IsPlayerAdmin(playerid)) return ShowPlayerDialog(playerid,CLAN_CREAR,DIALOG_STYLE_INPUT,"Creacion de Clan","{F50000}ERROR, EL TAG DE TU CLAN TIENE MAS DE 10 CARACTERES.\n\n\t\t{ffffff}Intentalo de nuevo.","Crear","Cancelar");
	    if(strlen(inputtext) <= 2) return ShowPlayerDialog(playerid,CLAN_CREAR,DIALOG_STYLE_INPUT,"Creacion de Clan","{F50000}ERROR, EL TAG DE TU CLAN DEBE TENER MAS DE 2 CARACTERES.\n\n\t\t{ffffff}Intentalo de nuevo.","Crear","Cancelar");
        if(strfind(inputtext, " ") != -1)  return ShowPlayerDialog(playerid,CLAN_CREAR,DIALOG_STYLE_INPUT,"Creacion de Clan","{F50000}ERROR, EL TAG DE TU CLAN NO DEBE TENER ESPACIOS!.\n\n\t\t{ffffff}Intentalo de nuevo.","Crear","Cancelar");
		new clan_tag[256];
		format(clan_tag, sizeof(clan_tag), "%s",inputtext);
		ClanTAG[playerid][0] = EOS;
  		strmid(ClanTAG[playerid], clan_tag, 0, strlen(clan_tag));
		PlayerInfo[playerid][CLAN] = 1;
		PlayerInfo[playerid][CLAN_OWN] = 1;
		//ActualizaTAG(playerid);
		new CLAN_UPDATE[400];
		format(CLAN_UPDATE, sizeof(CLAN_UPDATE), "UPDATE Usuarios SET CLAN='1',CLAN_TAG='%s',CLAN_OWN='1' WHERE Username = '%s'", DB_Escape(ClanTAG[playerid]),PlayerName2(playerid));
		db_query(DataBase_USERS,CLAN_UPDATE);
		SendClientMessage(playerid,-1,"Tu Clan Fue Creado Correctamente.");
		}
		return 1;
	}
	if(dialogid == CLAN_VER)
	{
	    if(response == 1)
	    {
			new DialogSTR[2048],ClanSTR[500],ClanSQL[128],CLAN_Field[128];
		    format(ClanSQL, sizeof(ClanSQL), "SELECT * FROM Usuarios WHERE CLAN_TAG = '%s' AND CLAN_OWN = '1'",inputtext);
		    NUM_ROWS_SQL = db_query(DataBase_USERS,ClanSQL);
			enum ENUM_CLANV {SCORE,DINERO,VIP};
			new MCLAN_INFO[MAX_PLAYERS][ENUM_CLANV];
	     	if(db_num_rows(NUM_ROWS_SQL) > 0)
		    {
		        new finded_rows = db_num_rows(NUM_ROWS_SQL);
    		    new MCLAN_NICK[MAX_PLAYERS][128];
       			for (new i; i < finded_rows; i++)
			    {
	                db_get_field_assoc(NUM_ROWS_SQL, "Username", CLAN_Field, sizeof(CLAN_Field));
					strmid(MCLAN_NICK[i], CLAN_Field, 0, strlen(CLAN_Field));
	                db_get_field_assoc(NUM_ROWS_SQL, "SCORE", CLAN_Field, sizeof(CLAN_Field));
	                MCLAN_INFO[i][SCORE] = strval(CLAN_Field);
	                db_get_field_assoc(NUM_ROWS_SQL, "DINERO", CLAN_Field, sizeof(CLAN_Field));
	                MCLAN_INFO[i][DINERO] = strval(CLAN_Field);
	                db_get_field_assoc(NUM_ROWS_SQL, "VIP", CLAN_Field, sizeof(CLAN_Field));
	                MCLAN_INFO[i][VIP] = strval(CLAN_Field);
					format(ClanSTR,sizeof(ClanSTR),"{9966FF}* LIDER; {FFFF66}[%s]%s [SCORE: {ffffff}%d{FFFF66}] [DINERO: {ffffff}%d{FFFF66}] [VIP {ffffff}%d{FFFF66}]\n",inputtext,MCLAN_NICK[i],MCLAN_INFO[i][SCORE],MCLAN_INFO[i][DINERO],MCLAN_INFO[i][VIP]);
					strcat(DialogSTR,ClanSTR);
                	db_next_row(NUM_ROWS_SQL);
                }

                db_free_result(NUM_ROWS_SQL);

			    format(ClanSQL, sizeof(ClanSQL), "SELECT * FROM Usuarios WHERE CLAN_TAG = '%s' AND CLAN_OWN = '0' ORDER BY RANDOM() LIMIT 10",inputtext);
			    NUM_ROWS_SQL = db_query(DataBase_USERS,ClanSQL);
			    finded_rows = db_num_rows(NUM_ROWS_SQL);
			    db_free_result(NUM_ROWS_SQL);
				format(ClanSTR,sizeof(ClanSTR),"{FFFF66}Este clan cuenta con {FFFFFF}%d {FFFF66}Miembros en total.\n",finded_rows);
				strcat(DialogSTR,ClanSTR);
				ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFFF00}INFORMACION DEL CLAN", DialogSTR, "X", "");
			}
			else
			{
			    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{8000FF}ERROR: EL CLAN NO EXISTE","{ffffff}No se encontro ningun resultado en nuestra base de datos, verifica bien el tag del clan.","x","");
			}
	    }
	}
	if(dialogid == CLAN_CTAG)
	{
	    if(response == 1)
	    {
		new Comprobar[100];
		format(Comprobar, sizeof(Comprobar), "SELECT * FROM Usuarios WHERE CLAN_TAG = '%s'", inputtext);
		new existe = db_num_rows(NUM_ROWS_SQL);
		if(existe > 0) return ShowPlayerDialog(playerid,CLAN_CTAG,DIALOG_STYLE_INPUT,"Cambiar TAG de CLAN","{F50000}ERROR, EL TAG QUE ELEGISTE YA EXISTE, ESCOJE OTRO.","Cambiar","x");
	    if(strlen(inputtext) > 10 && !IsPlayerAdmin(playerid)) return ShowPlayerDialog(playerid,CLAN_CTAG,DIALOG_STYLE_INPUT,"Cambiar TAG de CLAN","{F50000}ERROR, EL TAG QUE INGRESASTE TIENE MAS DE 10 CARACTERES.\n\n\t\t{ffffff}Intentalo de nuevo con uno mas corto.","Cambiar","x");
	    if(strlen(inputtext) < 2) return ShowPlayerDialog(playerid,CLAN_CTAG,DIALOG_STYLE_INPUT,"Cambiar TAG de CLAN","{F50000}ERROR, EL TAG QUE INGRESASTE TIENE MENOS DE 2 CARACTERES.\n\n\t\t{ffffff}Intentalo de nuevo con uno mas largo.","Cambiar","x");
        if(strfind(inputtext, " ") != -1)  return ShowPlayerDialog(playerid,CLAN_CREAR,DIALOG_STYLE_INPUT,"Cambiar TAG de CLAN","{F50000}ERROR, EL TAG DE TU CLAN NO DEBE TENER ESPACIOS!.\n\n\t\t{ffffff}Intentalo de nuevo.","Crear","Cancelar");
		//ActualizaTAG(playerid);
		new CLAN_UPDATE[400];
		format(CLAN_UPDATE, sizeof(CLAN_UPDATE), "UPDATE Usuarios SET CLAN_TAG='%s' WHERE CLAN_TAG = '%s'",inputtext,ClanTAG[playerid]);
		db_query(DataBase_USERS,CLAN_UPDATE);
    	for(new CLAN_MEMBER_ID = 0; CLAN_MEMBER_ID < GetMaxPlayers(); CLAN_MEMBER_ID++)
		{
            if(IsPlayerOfMyClan(playerid,CLAN_MEMBER_ID))
			{
			    if(IsPlayerConnected(CLAN_MEMBER_ID) && PlayerInfo[CLAN_MEMBER_ID][CLAN] == 1)
			    {
			    ClanTAG[CLAN_MEMBER_ID][0] = EOS;
    			strmid(ClanTAG[CLAN_MEMBER_ID], inputtext, 0, strlen(inputtext));
				CallLocalFunction("OnPlayerCommandText", "is", CLAN_MEMBER_ID, "/gc");
				}
			}
		}
		ClanTAG[playerid][0] = EOS;
  		strmid(ClanTAG[playerid], inputtext, 0, strlen(inputtext));
		SendClientMessage(playerid,-1,"El TAG de tu clan fue actualizado.");
		}
		return 1;
	}

	if(dialogid == CLAN_RECLUTAR)
	{
	    if(response == 1)
		{
		new u_id = strval(inputtext);
 	   	if(u_id == playerid) return ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"Ocurrio un ERROR.","{F50000}El ID QUE INGRESASTE ES EL TUYO.","x","");
		if(!IsPlayerConnected(u_id)) return ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"ERROR","{F50000}El Usuario No esta conectado.","x","");
		if(PlayerInfo[u_id][CLAN] == 1) return ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"Ocurrio un ERROR.","{F50000}El Usuario ya pertenece a un Clan.","x","");
		//SendClanREQUEST(inputtext);
		PlayerInfo[u_id][Invitado] = 1;
		PlayerInfo[u_id][InvitadorID] = playerid;
		new request_string[256];
		format(request_string, sizeof(request_string), "{f50000}%s [%d] {00B3B3}Te ha invitado a su Clan '{ffffff}%s{00B3B3}', Si deseas unirte, Preciona Ok.",PlayerName2(playerid),playerid,ClanTAG[playerid]);
		ShowPlayerDialog(u_id,CLAN_REQUEST,DIALOG_STYLE_MSGBOX,"Invitacion de CLAN.",request_string,"Ok","Rechazar");
		SendClientMessage(playerid,-1,"El Usuario ha sido invitado para unirse a tu clan.");
		}
		return 1;
	}

	if(dialogid == CLAN_DADMIN)
	{
	   	new player2 = strval(inputtext);
	   	if(player2 == playerid) return ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"Ocurrio un ERROR.","{F50000}El ID QUE INGRESASTE ES EL TUYO.","x","");
		if(!IsPlayerConnected(player2)) return ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"ERROR","{F50000}El Usuario No esta conectado.","x","");
		if(PlayerInfo[player2][CLAN] == 0) return ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"Ocurrio un ERROR.","{F50000}El Usuario NO PERTENECE a ningun clan.","x","");
		if(!IsPlayerOfMyClan(playerid,player2)) return ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"Ocurrio un ERROR.","{F50000}El Usuario NO PERTENECE a tu clan.","x","");
		if(IsPlayerOwnerOfClan(player2,ClanTAG[playerid]))
		{
		new clan_string[500];
		PlayerInfo[player2][CLAN] = 1;
		PlayerInfo[player2][CLAN_OWN] = 0;
		format(clan_string, sizeof(clan_string), "UPDATE Usuarios SET CLAN='1',CLAN_TAG='%s',CLAN_OWN='0' WHERE Username = '%s'", ClanTAG[player2],PlayerName2(player2));
	 	db_query(DataBase_USERS,clan_string);
        SendFormatDialog(playerid,"{ffffff}<-- {f50000}OK {ffffff}-->","{B366FF}El Usuario %s [ID: %d] ya no tiene mas poder sobre el CLAN {ffffff}%s\nPara remover esto, basta con utilizar el comando {f50000}/clan admin{ffffff} e introducir el ID del usuario nuevamente.",PlayerName2(player2),player2,ClanTAG[playerid]);
        SendFormatDialog(player2,"{ffffff}<-- {f50000}NOTIFICACION {ffffff}-->","{B366FF}El Usuario %s [ID: %d] te elimino los privilegios de fundador del CLAN {ffffff}%s",PlayerName2(playerid),playerid,ClanTAG[playerid]);
		}
		else if(!IsPlayerOwnerOfClan(player2,ClanTAG[playerid]))
		{
		new clan_string[500];
		format(clan_string, sizeof(clan_string), "%s",ClanTAG[player2]);
        ClanTAG[player2][0] = EOS;
  		strmid(ClanTAG[player2], clan_string, 0, strlen(clan_string));
		PlayerInfo[player2][CLAN] = 1;
		PlayerInfo[player2][CLAN_OWN] = 1;
		format(clan_string, sizeof(clan_string), "UPDATE Usuarios SET CLAN='1',CLAN_TAG='%s',CLAN_OWN='1' WHERE Username = '%s'", ClanTAG[player2],PlayerName2(player2));
	 	db_query(DataBase_USERS,clan_string);
        SendFormatDialog(playerid,"{ffffff}<-- {f50000}OK {ffffff}-->","{B366FF}El Usuario %s [ID: %d] ahora tiene los privilegios del fundador del CLAN {ffffff}%s\nPara remover esto, basta con utilizar el comando {f50000}/clan admin{ffffff} e introducir el ID del usuario nuevamente.",PlayerName2(player2),player2,ClanTAG[playerid]);
        SendFormatDialog(player2,"{ffffff}<-- {f50000}NOTIFICACION {ffffff}-->","{B366FF}El Usuario %s [ID: %d] te otorgo privilegios de fundador del CLAN {ffffff}%s",PlayerName2(playerid),playerid,ClanTAG[playerid]);
		}
		return 1;
	}

	if(dialogid == CLAN_REQUEST)
	{
	    if(response == 1)
	    {
	   	new own_id = PlayerInfo[playerid][InvitadorID];
		ShowPlayerDialog(own_id,0,DIALOG_STYLE_MSGBOX,"Reclutacion Exitoza..","{B300B3}El Usuario Se ha unido a tu Clan satisfactoriamente.","x","");
        ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"Reclutacion Exitoza..","{B300B3}Te has integrado al Clan satisfactoriamente.","x","");
		ClanTAG[playerid][0] = EOS;
		new clan_string[256];
		format(clan_string, sizeof(clan_string), "%s",ClanTAG[own_id]);
  		strmid(ClanTAG[playerid], clan_string, 0, strlen(clan_string));
		PlayerInfo[playerid][CLAN] = 1;
		PlayerInfo[playerid][CLAN_OWN] = 0;
		//ActualizaTAG(playerid);
		new CLAN_UPDATE[400];
		format(CLAN_UPDATE, sizeof(CLAN_UPDATE), "UPDATE Usuarios SET CLAN='1',CLAN_TAG='%s',CLAN_OWN='0' WHERE Username = '%s'", DB_Escape(ClanTAG[own_id]),PlayerName2(playerid));
		db_query(DataBase_USERS,CLAN_UPDATE);
		Delete3DTextLabel(LabelCabecero[playerid]);
		LabelCabecero[playerid] = Create3DTextLabel(ClanTAG[playerid], 0xFFFF00FF, 30.0, 40.0, 50.0, 40.0, 0);
		Attach3DTextLabelToPlayer(LabelCabecero[playerid], playerid, 0.0, 0.0, 0.7);
		}
		return 1;
	}


	if(dialogid == CLAN_KICK)
	{
	    if(response == 1)
	    {
	    new MemberID = strval(inputtext);
        if(!IsPlayerConnected(MemberID)) return ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"ERROR","{F50000}El Usuario No esta conectado.","Ok","");
        if(IsPlayerOfMyClan(playerid,MemberID))
        {
        if(MemberID == playerid) return ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"ERROR","{F50000}EL ID QUE INGRESASTE ES EL TUYO.","","Ok");
		new CLAN_UPDATE[400];
		format(CLAN_UPDATE, sizeof(CLAN_UPDATE), "UPDATE Usuarios SET CLAN='0',CLAN_TAG='0',CLAN_OWN='0' WHERE Username = '%s'",PlayerName2(MemberID));
		db_query(DataBase_USERS,CLAN_UPDATE);
		PlayerInfo[MemberID][CLAN] = 0;
		PlayerInfo[MemberID][CLAN_OWN] = 0;
		PlayerInfo[MemberID][InvitadorID] = 0;
		Delete3DTextLabel(LabelCabecero[MemberID]);
		LabelCabecero[MemberID] = Create3DTextLabel(" ", 0xF50000AA, 30.0, 40.0, 50.0, 40.0, 0);
		Attach3DTextLabelToPlayer(LabelCabecero[MemberID], MemberID, 0.0, 0.0, 0.7);
		SetPlayerChatBubble(MemberID,"  ", 0xfafa89ff, 11.0, 1);
		SendFormatDialog(MemberID,"{ffffff}<-- {4DFFFF}OK {ffffff}-->","{B366FF}El Usuario %s [ID: %d] te expulso del CLAN {ffffff}%s",PlayerName2(playerid),playerid,ClanTAG[playerid]);
		SendFormatDialog(playerid,"{ffffff}<-- {4DFFFF}OK {ffffff}-->","{B366FF}El Usuario %s [ID: %d] fue expulsado del CLAN {ffffff}%s {B366FF}exitozamente.",PlayerName2(MemberID),MemberID,ClanTAG[playerid]);
		}
		}
		else
		{
		ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"ERROR","{F50000}El Usuario No Pertenece a tu clan.","Ok","");
		}
		return 1;
	}

	if(dialogid == DIALOGID)
	{
		if(response)
		{
			if(listitem == 0)
			{
				SetPlayerFightingStyle (playerid, FIGHT_STYLE_ELBOW);
			}
			if(listitem == 1)
			{
				SetPlayerFightingStyle (playerid, FIGHT_STYLE_BOXING);
			}
			if(listitem == 2)
			{
			    SetPlayerFightingStyle (playerid, FIGHT_STYLE_GRABKICK);
			}
			if(listitem == 3)
			{
				SetPlayerFightingStyle (playerid, FIGHT_STYLE_KNEEHEAD);
			}
			if(listitem == 4)
			{
			    SetPlayerFightingStyle (playerid, FIGHT_STYLE_KUNGFU);
			}
			if(listitem == 5)
			{
				SetPlayerFightingStyle (playerid, FIGHT_STYLE_NORMAL);
			}
		}
		return 1;
    }

   if(dialogid == FIGHT) // Fight Styles
	{
		if(response)
		{
			if(listitem == 0) // NORMAL 1
			{
			SendClientMessage(playerid, -1,"Ahora peleas normal.");
				SetPlayerFightingStyle(playerid, FIGHT_STYLE_NORMAL);
			}
			if(listitem == 1) // BOXING
			{
			SendClientMessage(playerid, -1,"Ahora sabes boxear.");
				SetPlayerFightingStyle(playerid, FIGHT_STYLE_BOXING);
			}
			if(listitem == 2) // KUNGFU
			{
			SendClientMessage(playerid, -1,"Ahora sabes kung fu.");
				SetPlayerFightingStyle(playerid, FIGHT_STYLE_KUNGFU);
			}
			if(listitem == 3) // KNEEHEAD
			{
			SendClientMessage(playerid, -1,"Ahora peleas con los codos");
				SetPlayerFightingStyle(playerid, FIGHT_STYLE_KNEEHEAD);
			}
			if(listitem == 4) // GRABKICK
			{
			SendClientMessage(playerid, -1,"Ahora sabes grabkick.");
				SetPlayerFightingStyle(playerid, FIGHT_STYLE_GRABKICK);
			}
			if(listitem == 5) // ELBOW
			{
			SendClientMessage(playerid, -1,"Ahora peleas como gay.");
				SetPlayerFightingStyle(playerid, FIGHT_STYLE_ELBOW);
			}

		}
   		return 1;
     }

	if(dialogid == MODIFICAR_DIALOGO)
	{
		new veh = GetPlayerVehicleID(playerid);
		new engine,lights2,alarm,doors,bonnet,boot,objective;
		if(!response) return SendClientMessage(playerid, 0xCC0000FF, "Cancelaste.");
		switch(listitem)
	    {
	        case 0:
	        {
      			if(GetPVarInt(playerid, "lights2") == 0)
				{
					GetVehicleParamsEx(veh,engine,lights2,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(veh,engine,VEHICLE_PARAMS_ON,alarm,doors,bonnet,boot,objective);
					SetPVarInt(playerid, "lights2", 1);
					//SendClientMessage(playerid, 0xFF3366FF, "[Control del Vehiculo]:{ffffff} Luces, Encendidas.");
				}
				else if(GetPVarInt(playerid, "lights2") == 1)
				{
					GetVehicleParamsEx(veh,engine,lights2,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(veh,engine,VEHICLE_PARAMS_OFF,alarm,doors,bonnet,boot,objective);
					SetPVarInt(playerid, "lights2", 0);
					//SendClientMessage(playerid, 0xFF3366FF, "[Control del Vehiculo]:{ffffff} Luces, Apagadas.");
				}
			}
			case 1:
			{
				if(GetPVarInt(playerid, "Bonnet") == 0)
				{
					GetVehicleParamsEx(veh,engine,lights2,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(veh,engine,lights2,alarm,doors,VEHICLE_PARAMS_ON,boot,objective);
					SetPVarInt(playerid, "Bonnet", 1);
					//SendClientMessage(playerid, 0xFF3366FF, "[Control del Vehiculo]:{ffffff} Capo, Abierto.");
				}
				else if(GetPVarInt(playerid, "Bonnet") == 1)
				{
					GetVehicleParamsEx(veh,engine,lights2,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(veh,engine,lights2,alarm,doors,VEHICLE_PARAMS_OFF,boot,objective);
					SetPVarInt(playerid, "Bonnet", 0);
					//SendClientMessage(playerid, 0xFF3366FF, "[Control del Vehiculo]:{ffffff} Capo, Cerrado.");
				}
			}
			case 2:
			{
				if(GetPVarInt(playerid, "Boot") == 0)
	 			{
					GetVehicleParamsEx(veh,engine,lights2,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(veh,engine,lights2,alarm,doors,bonnet,VEHICLE_PARAMS_ON,objective);
					SetPVarInt(playerid, "Boot", 1);
					//SendClientMessage(playerid, 0xFF3366FF, "[Control del Vehiculo]:{ffffff} Maletero, Abierto.");
				}
				else if(GetPVarInt(playerid, "Boot") == 1)
				{
					GetVehicleParamsEx(veh,engine,lights2,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(veh,engine,lights2,alarm,doors,bonnet,VEHICLE_PARAMS_OFF,objective);
					SetPVarInt(playerid, "Boot", 0);
					//SendClientMessage(playerid, 0xFF3366FF, "[Control del Vehiculo]:{ffffff} Maletero, Cerrado.");
				}
			}
			case 3:
			{
				if(GetPVarInt(playerid, "Doors") == 0)
	 			{
					GetVehicleParamsEx(veh,engine,lights2,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(veh,engine,lights2,alarm,VEHICLE_PARAMS_ON,bonnet,boot,objective);
					SetPVarInt(playerid, "Doors", 1);
					//SendClientMessage(playerid, 0xFF3366FF, "[Control del Vehiculo]:{ffffff} Puertas, Abiertas.");
				}
				else if(GetPVarInt(playerid, "Doors") == 1)
				{
					GetVehicleParamsEx(veh,engine,lights2,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(veh,engine,lights2,alarm,VEHICLE_PARAMS_OFF,bonnet,boot,objective);
					SetPVarInt(playerid, "Doors", 0);
					//SendClientMessage(playerid, 0xFF3366FF, "[Control del Vehiculo]:{ffffff} Puertas, Cerradas.");
				}
			}
			case 4:
			{
				if(GetPVarInt(playerid, "Engine") == 0)
	 			{
					GetVehicleParamsEx(veh,engine,lights2,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(veh,VEHICLE_PARAMS_ON,lights2,alarm,doors,bonnet,boot,objective);
					SetPVarInt(playerid, "Engine", 1);
					//SendClientMessage(playerid, 0xFF3366FF, "[Control del Vehiculo]:{ffffff} Motor, Apagado.");
				}
				else if(GetPVarInt(playerid, "Engine") == 1)
				{
					GetVehicleParamsEx(veh,engine,lights2,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(veh,VEHICLE_PARAMS_OFF,lights2,alarm,doors,bonnet,boot,objective);
					SetPVarInt(playerid, "Engine", 0);
					//SendClientMessage(playerid, 0xFF3366FF, "[Control del Vehiculo]:{ffffff} Motor, Encendido.");
				}
			}
			case 5:
			{
				if(GetPVarInt(playerid, "Alarm") == 0)
				{
					GetVehicleParamsEx(veh,engine,lights2,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(veh,engine,lights2,VEHICLE_PARAMS_ON,doors,bonnet,boot,objective);
					SetPVarInt(playerid, "Alarm", 1);
					//SendClientMessage(playerid, 0xFF3366FF, "[Control del Vehiculo]:{ffffff} Alarma, Activada.");
				}
				else if(GetPVarInt(playerid, "Alarm") == 1)
				{
					GetVehicleParamsEx(veh,engine,lights2,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(veh,engine,lights2,VEHICLE_PARAMS_OFF,doors,bonnet,boot,objective);
					SetPVarInt(playerid, "Alarm", 0);
					//SendClientMessage(playerid, 0xFF3366FF, "[Control del Vehiculo]:{ffffff} Alarma, OFF.");
				}
			}
		}
		return 1;
	}



	if(dialogid == DIALOG_TEXTO)
    {
	    if(response)
	    {
			if(PlayerInfo[playerid][CLAN] == 1 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_DE_ERROR, "[ » ERROR « ]:{ffffff} No puedes utilizar este comando cuando eres parte de un CLAN.");
	        new string[256];
	   		if(!strlen(inputtext)) return ShowPlayerDialog(playerid,DIALOG_TEXTO,DIALOG_STYLE_INPUT,"Texto Personalizado","{B300B3}NO PUEDES DEJARLO EN BLANCO!",">>","x");
	     	if(DetectarSpam(inputtext)) return ShowPlayerDialog(playerid,DIALOG_TEXTO,DIALOG_STYLE_INPUT,"Texto Personalizado","{B300B3}EL TEXTO QUE INGRESASTE PUEDE CONTENER SPAM ELIGE OTRO!",">>","x");
            Delete3DTextLabel(LabelCabecero[playerid]);
			LabelCabecero[playerid] = Create3DTextLabel(inputtext, 0xffffffff, 30.0, 40.0, 50.0, 40.0, 0);
	     	Attach3DTextLabelToPlayer(LabelCabecero[playerid], playerid, 0.0, 0.0, 0.7);
	      	format(string, sizeof(string), "{B300B3}** El Texto de tu cabeza fue Actualizado:{ffffff} %s", inputtext);
		  	ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"Texto exitozamente cambiado.",string,"x","");
	    }
		return 1;
	}

	if(dialogid == COMERCIO_RZ)
	{
	    if(response)
	    {
	        if(!IsPlayerNearDealer(playerid)) return SendClientMessage(playerid, COLOR_ROJO, "No estas cerca de ningun comerciante.");
	        switch(listitem)
	        {
				case 0:
				{
					return ShowPlayerDialog(playerid, Armamentos, DIALOG_STYLE_TABLIST_HEADERS, "{FF0099}R.Z: {FFFFFF}Comercio::{FF0099} Armas",
					"Arma\tPrecio\tMunición\n\
					Desert Eagle\t$5000\t50\n\
					Colt 45\t$2000\t200\n\
					MP5-K MG\t$5000\t500\n\
					M4\t$10000\t1000\n\
					AK-47\t$10000\t1000\n\
					Spas12-Shotgun\t$10000\t200\n\
					Tec-9\t$4000\t400\n\
					Sniper Rifle\t$5000\t5\n\
					Rifle de Cazador\t$2000\t30\n\
					Googles Nocturnos\t$500\t1\n\
					Googles Termicos\t$500\t1",
					"Comprar", "x");
				}
				case 1:
				{
					return ShowPlayerDialog(playerid, AntibioticosRZ, DIALOG_STYLE_TABLIST_HEADERS, "{FF0099}R.Z: {FFFFFF}Comercio::{FF0099} Antibioticos",
					"Antibiotico\tPrecio\tSanación\n\
					Neomelubrina (MedicKIT)\t$3000\t100\n\
					Hidrocortisona\t$$1500\t50\n\
					Aspirinas\t$750\t25\n\
					BIsmuto\t$300\t10\n",
					"Comprar", "x");
				}
	        }
	    }
	}

	if(dialogid == COMERCIO_DRONES_RZ)
	{
		if(response)
	    {
	        if(!IsPlayerNearDealer(playerid)) return SendClientMessage(playerid, COLOR_ROJO, "No estas cerca de ningun comerciante.");
			switch(listitem)
			{
			    //calcular habilidad del drone: 80 (distancia maxima) + 5 (rango minimo de ataque) / 25 (rango maximo de ataque)
			    //NegociarDrone(playerid, name[], price, max_owner_distance, max_attack_distance, min_attack_distance, min_attack, max_attack)
				case 0: NegociarDrone(playerid, "Drone Pucky (Beta). Habilidad: 13.33", 5000, 70, 40, 15, 10, 15);
				case 1: NegociarDrone(playerid, "Drone Duck (Beta). Habilidad: 16.66", 10000, 80, 30, 10, 15, 25);
				case 2: NegociarDrone(playerid, "Drone Elite (Beta). Habilidad: 33.33", 50000, 50, 20, 5, 45, 50);
			}
		}
	}

	if(dialogid == COMERCIO_DRONES_RZ_EXPRESS)
	{
		if(response)
	    {
	        if(gTeam[playerid] != Humano) return SendClientMessage(playerid, COLOR_ROJO, "No eres humano.");
			switch(listitem)
			{
			    //calcular habilidad del drone: 80 (distancia maxima) + 5 (rango minimo de ataque) / 25 (rango maximo de ataque)
				case 0: NegociarDrone(playerid, "Drone Pucky (Beta). Habilidad: 13.33", 10000, 70, 40, 15, 10, 15);
				case 1: NegociarDrone(playerid, "Drone Duck (Beta). Habilidad: 16.66", 20000, 80, 30, 10, 15, 25);
				case 2: {
				    if (!IsPlayerAdmin(playerid)) return NegociarDrone(playerid, "Drone Elite (Beta). Habilidad: 33.33", 100000, 50, 20, 5, 45, 50);
				    else return NegociarDrone(playerid, "Drone Elite (RCON). Habilidad: ??? SUPREME!", 0, 80, 30, 10, 50, 100);
				}
			}
		}
	}

	if(dialogid == AntibioticosRZ)
	{
		if(response)
	    {
	        if(!IsPlayerNearDealer(playerid)) return SendClientMessage(playerid, COLOR_ROJO, "No estas cerca de ningun comerciante.");
			switch(listitem)
			{
				case 0: NegociarAntibiotico(playerid, "Neomelubrina (MedicKIT)", 3000, 100);
				case 1: NegociarAntibiotico(playerid, "Hidrocortisona", 1500, 50);
				case 2: NegociarAntibiotico(playerid, "Aspirinas", 750, 25);
				case 3: NegociarAntibiotico(playerid, "Bismuto", 300, 10);
			}
		}
		return 1;
	}

	if(dialogid == Armamentos)
	{
	    if(response)
	    {
	        if(!IsPlayerNearDealer(playerid)) return SendClientMessage(playerid, COLOR_ROJO, "No estas cerca de ningun comerciante.");
	        if(gTeam[playerid] == Zombie) return SendClientMessage(playerid, COLOR_ROJO, "Los zombies no utilizan armas.");
	        switch(listitem)
	        {
				case 0: NegociarArma(playerid, 24, 50, 5000);
				case 1: NegociarArma(playerid, 22, 50, 2000);
				case 2: NegociarArma(playerid, 29, 500, 5000);
				case 3: NegociarArma(playerid, 31, 1000, 10000);
				case 4: NegociarArma(playerid, 30, 200, 10000);
				case 5: NegociarArma(playerid, 27, 400, 10000);
				case 6: NegociarArma(playerid, 32, 50, 4000);
				case 7: NegociarArma(playerid, 34, 5, 5000);
				case 8: NegociarArma(playerid, 33, 50, 2000);
				case 9: NegociarArma(playerid, 44, 50, 500);
				case 10: NegociarArma(playerid, 45, 50, 500);
			}
		}
		return 1;
	}

/*
	if(dialogid == KIT_HUMANO)
	{
		if(response)
		{
		    switch(listitem)
		    {
		        case 0:
		        {
		            if(GetPlayerMoney(playerid) < 1000) return SendClientMessage(playerid, Rojo, "[<!>] Para activar el reloj del juego necesitas al menos $1000");
		            TogglePlayerClock(playerid, 1);
		            GivePlayerMoney(playerid, -1000);
		            SendClientMessage(playerid,COLOR_ARTICULO,"[ R.Z ] {ffffff}Articulo adquirido con exito.");
		        }
		        case 1:
		        {
		            if(GetPlayerMoney(playerid) < 1000) return SendClientMessage(playerid, Rojo, "[<!>] Para desactivar el reloj del juego necesitas al menos $1000");
		            TogglePlayerClock(playerid, 0);
		            GivePlayerMoney(playerid, -1000);
		            SendClientMessage(playerid,COLOR_ARTICULO,"[ R.Z ] {ffffff}Articulo adquirido con exito.");
		        }

		    }

		}
	return 1;
	}
*/
	if(dialogid == Administradores) {
	if(response == 1)
    {
	ShowPlayerDialog(playerid,Duda,DIALOG_STYLE_INPUT, "{f50000}[ » Revolucion Zombie « ]:{ffffff} Contacto..","{ffff00}Introduce Lo Que deseas saber Aqui, Gracias.\n\n","Enviar","Cerrar");
	}
	return 1;
	}
	if(dialogid == DIALOG_RESPUESTA)
    {
    if(response == 1)
    {
    ShowPlayerDialog(playerid,Duda,DIALOG_STYLE_INPUT, "{f50000}[ » Revolucion Zombie « ]:{ffffff} Contacto..","{ffff00}Introduce Lo Que deseas saber Aqui, Gracias.\n\n","Enviar","Cerrar");
    }
    }
	if(dialogid == Duda)
    {
    if(response == 1)
    {
	new dudaenviar[2000];
	GetPlayerName(playerid,Nombre,sizeof(Nombre));
	format(dudaenviar,sizeof(dudaenviar),"{9999FF} %s (%d) {FFFFFF}Pregunta:{9999FF} %s",Nombre,playerid,inputtext);
	MessageToAdmins(blue,dudaenviar);
	new Mensaje[350];
	format(Mensaje, sizeof (Mensaje), "%s", inputtext);
	format(Mensaje, sizeof (Mensaje), "{ffffff}Duda enviada: {4DFFFF}\" %s \"", inputtext);
	SendClientMessage(playerid,0x48007CFF, Mensaje);
	PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
	printf("[DUDA]: %s[%d] Pregunta: %s\n",PlayerName2(playerid),playerid, inputtext);
    }
	return 1;
	}
	if(dialogid == NMusica2)
	{
		if(response)
		{
		CMDMessageToAdmins(playerid,"CANCION");
		StopAudioStreamForAll();
		PlayAudioStreamForAll(inputtext);
		}
		return 1;
	}

	if(dialogid == SongDialog)
	{
		if(response)
		{
		if(strlen(inputtext) >= 100) return SendClientMessage(playerid,ADMIN_COLOR, "El nombre de la canción es demaciado largo D:");
		StopAudioStreamForPlayerEx(playerid);
		new LinkENCONTRADO[500];
		format(LinkENCONTRADO,sizeof(LinkENCONTRADO),"http://Revolucion-Zombie.com/play.php?q=%s",inputtext);
		dcmd_link_excut(playerid,LinkENCONTRADO);
		}
		return 1;
	}


	if(dialogid == RZUNBAN_PLAYER)
	{
	 if(response == 1)
	 {
		new UpdateSQL[1500];
	    format(UpdateSQL, sizeof(UpdateSQL), "SELECT * FROM RZCData WHERE Username = '%s' AND locked = 1 LIMIT 1",inputtext);
	    NUM_ROWS_SQL = db_query(DataBase_USERS,UpdateSQL);

	    if(db_num_rows(NUM_ROWS_SQL) <= 0){
		    format(UpdateSQL, sizeof(UpdateSQL), "SELECT * FROM RZCData WHERE ip = '%s' AND locked = 1 LIMIT 1",inputtext);
		    NUM_ROWS_SQL = db_query(DataBase_USERS,UpdateSQL);
			format(UpdateSQL, sizeof(UpdateSQL), "unbanip %s",inputtext);
			SendRconCommand(UpdateSQL);
	    }
     	if(db_num_rows(NUM_ROWS_SQL) > 0)
	    {
                new Field[256],
					Nick[256],
					Banner[256],
					Razon[256],
					Fecha[256];
                //---
                db_get_field_assoc(NUM_ROWS_SQL, "Username", Field, sizeof(Field));
				strmid(Nick, Field, 0, strlen(Field));
				//---
                db_get_field_assoc(NUM_ROWS_SQL, "fecha", Field, sizeof(Field));
				strmid(Fecha, Field, 0, strlen(Field));

                db_get_field_assoc(NUM_ROWS_SQL, "admin", Field, sizeof(Field));
				strmid(Banner, Field, 0, strlen(Field));

                db_get_field_assoc(NUM_ROWS_SQL, "razon", Field, sizeof(Field));
				strmid(Razon, Field, 0, strlen(Field));
				//---
	        	db_free_result(NUM_ROWS_SQL);
				format(UpdateSQL, sizeof(UpdateSQL), "DELETE FROM RZCData WHERE Username = '%s'",Nick);
				db_query(DataBase_USERS,UpdateSQL);
				format(UpdateSQL, sizeof(UpdateSQL), "{ffffff}Usuario %s Liberado \n\n==> Info:\n\nAdmin: %s\nFecha de Baneo: %s\nRazón: %s",Nick,Banner,Fecha,Razon);
				ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{00FF00}[- RZ UNBAN -]",UpdateSQL,"x","");
				printf("[RZUNBAN] %s Fue Liberado por %s [ID: %d]\n", Nick,PlayerName2(playerid),playerid);
				SendFormatMessageToAll(COLOR_DE_ERROR,"[ R.Z ]: {ffffff}%s {00C4EB}ha liberado la cuenta {ffffff}%s {"COLOR_DE_ERROR_EX"} restringida por {ffffff}%s",PlayerName2(playerid),Nick,Banner);
		}
		else
		{
		    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{FF0000}LIBERAR USUARIO {00FF00}[- RZC -]","El nick no existe o no esta restringido.","x","");
		}
	 }
	 return 1;
	}



	if(dialogid == UNBAN_PLAYER)
	{
	 if(response == 1)
	 {
		new UpdateSQL[1500],DireccionIP[128];
	    format(UpdateSQL, sizeof(UpdateSQL), "SELECT * FROM Usuarios WHERE bIP = '%s' AND Banned = '1' LIMIT 1",inputtext);
	    NUM_ROWS_SQL = db_query(DataBase_USERS,UpdateSQL);
     	if(db_num_rows(NUM_ROWS_SQL) > 0)
	    {
                new Field[256],Nick[256],puntos[256],cash[256],vip[256],fecha[256],bRazoner[256],bAdminer[50];
                //---
                db_get_field_assoc(NUM_ROWS_SQL, "Username", Field, sizeof(Field));
				strmid(Nick, Field, 0, strlen(Field));
				//---
                db_get_field_assoc(NUM_ROWS_SQL, "SCORE", Field, sizeof(Field));
				strmid(puntos, Field, 0, strlen(Field));
				//---
                db_get_field_assoc(NUM_ROWS_SQL, "DINERO", Field, sizeof(Field));
				strmid(cash, Field, 0, strlen(Field));
				//---
                db_get_field_assoc(NUM_ROWS_SQL, "VIP", Field, sizeof(Field));
				strmid(vip, Field, 0, strlen(Field));
				//---
                db_get_field_assoc(NUM_ROWS_SQL, "bFecha", Field, sizeof(Field));
				strmid(fecha, Field, 0, strlen(Field));
				//
                db_get_field_assoc(NUM_ROWS_SQL, "bIP", Field, sizeof(Field));
				strmid(DireccionIP, Field, 0, strlen(Field));
				//
                db_get_field_assoc(NUM_ROWS_SQL, "bRazon", Field, sizeof(Field));
				strmid(bRazoner, Field, 0, strlen(Field));
				//---
				db_get_field_assoc(NUM_ROWS_SQL, "bAdmin", Field, sizeof(Field));
				strmid(bAdminer, Field, 0, strlen(Field));
				//---
	        	db_free_result(NUM_ROWS_SQL);
				if(
				strfind("zRicardo", bAdminer, true) != -1 && !IsPlayerAdmin(playerid) ||
				StringMismatch("zRicardo", bAdminer) && !IsPlayerAdmin(playerid)
				) return ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"<= DESBLOQUEAR =>","{FF0000}Este usuario no puede ser desbloqueado. (IP)","x","");
				format(UpdateSQL, sizeof(UpdateSQL), "UPDATE Usuarios SET Banned='0' WHERE Username = '%s'",Nick);
				db_query(DataBase_USERS,UpdateSQL);
				format(UpdateSQL, sizeof(UpdateSQL), "{ffffff}Usuario %s Desbaneado IP: %s\n\n==> Info:\n\nSCORE: %s\nDINERO: %s\nVIP: %s\nAdmin: %s\nFecha de Baneo: %s\nRazón: %s",Nick,DireccionIP,puntos,cash,vip,bAdminer,fecha,bRazoner);
				ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{00FF00}[- UNBAN -]",UpdateSQL,"x","");
				printf("[UNBAN] %s Fue desbaneado por %s [ID: %d]\n", Nick,PlayerName2(playerid),playerid);
				format(UpdateSQL, sizeof(UpdateSQL), "unbanip %s",inputtext);
				SendRconCommand(UpdateSQL);
				SendFormatMessageToAll(COLOR_DE_ERROR,"[ R.Z ]: {ffffff}%s {00C4EB}ha desbloqueado la cuenta {ffffff}%s {"COLOR_DE_ERROR_EX"} baneada por {ffffff}%s",PlayerName2(playerid),Nick,bAdminer);
		}
		else
		{
		    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{FF0000}DESBLOQUEAR USUARIO {00FF00}[- INFORMACION -]","Ningun usuario encontrado en la base de datos.","x","");
		}
	 }
	 else
	 {
		new UpdateSQL[1500],DireccionIP[128];
	    format(UpdateSQL, sizeof(UpdateSQL), "SELECT * FROM Usuarios WHERE Username = '%s' AND Banned = '1' LIMIT 1",inputtext);
	    NUM_ROWS_SQL = db_query(DataBase_USERS,UpdateSQL);
     	if(db_num_rows(NUM_ROWS_SQL) > 0)
	    {
                new Field[256],Nick[256],puntos[256],cash[256],vip[256],fecha[256],bRazoner[256],bAdminer[50];
                //---
                db_get_field_assoc(NUM_ROWS_SQL, "Username", Field, sizeof(Field));
				strmid(Nick, Field, 0, strlen(Field));
				//---
                db_get_field_assoc(NUM_ROWS_SQL, "SCORE", Field, sizeof(Field));
				strmid(puntos, Field, 0, strlen(Field));
				//---
                db_get_field_assoc(NUM_ROWS_SQL, "DINERO", Field, sizeof(Field));
				strmid(cash, Field, 0, strlen(Field));
				//---
                db_get_field_assoc(NUM_ROWS_SQL, "VIP", Field, sizeof(Field));
				strmid(vip, Field, 0, strlen(Field));
				//---
                db_get_field_assoc(NUM_ROWS_SQL, "bFecha", Field, sizeof(Field));
				strmid(fecha, Field, 0, strlen(Field));
				//
                db_get_field_assoc(NUM_ROWS_SQL, "bIP", Field, sizeof(Field));
				strmid(DireccionIP, Field, 0, strlen(Field));
				//
                db_get_field_assoc(NUM_ROWS_SQL, "bRazon", Field, sizeof(Field));
				strmid(bRazoner, Field, 0, strlen(Field));
				//---
				db_get_field_assoc(NUM_ROWS_SQL, "bAdmin", Field, sizeof(Field));
				strmid(bAdminer, Field, 0, strlen(Field));
				//---
	        	db_free_result(NUM_ROWS_SQL);
				if(
				strfind("es.zRicardo", bAdminer, true) != -1 && !IsPlayerAdmin(playerid) ||
				StringMismatch("es.zRicardo", bAdminer) && !IsPlayerAdmin(playerid)
				) return ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"<= DESBLOQUEAR =>","{FF0000}Este usuario no puede ser desbloqueado. (nick)","x","");
				format(UpdateSQL, sizeof(UpdateSQL), "UPDATE Usuarios SET Banned='0' WHERE Username = '%s'",Nick);
				db_query(DataBase_USERS,UpdateSQL);
				format(UpdateSQL, sizeof(UpdateSQL), "{ffffff}Usuario %s Desbaneado IP: %s\n\n==> Info:\n\nSCORE: %s\nDINERO: %s\nVIP: %s\nAdmin: %s\nFecha de Baneo: %s\nRazón: %s",Nick,DireccionIP,puntos,cash,vip,bAdminer,fecha,bRazoner);
				ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{00FF00}[- UNBAN -]",UpdateSQL,"x","");
				printf("[UNBAN] %s Fue desbaneado por %s [ID: %d]\n", Nick,PlayerName2(playerid),playerid);
				format(UpdateSQL, sizeof(UpdateSQL), "unbanip %s",DireccionIP);
				SendRconCommand(UpdateSQL);
				SendFormatMessageToAll(COLOR_DE_ERROR,"[ R.Z ]: {ffffff}%s {00C4EB}ha desbloqueado la cuenta {ffffff}%s {"COLOR_DE_ERROR_EX"} baneada por {ffffff}%s",PlayerName2(playerid),Nick,bAdminer);
		}
		else
		{
		    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{FF0000}DESBLOQUEAR USUARIO {00FF00}[- INFORMACION -]","Ningun usuario encontrado en la base de datos.","x","");
		}
	 }
	 return 1;
	}

	if(dialogid == SongDialogADM)
	{
		if(response)
		{
		CMDMessageToAdmins(playerid,"AMUSICA");
		StopAudioStreamForAll();
		new LinkENCONTRADO[500];
		format(LinkENCONTRADO,sizeof(LinkENCONTRADO),"http://Revolucion-Zombie.com/play.php?q=%s",inputtext);
		PlayAudioStreamForAll(LinkENCONTRADO);
		}
		return 1;
	}
  return 1;
 }

stock ANNOUNCE_BUG(str_announce[])
{
        new
            an_str[1024],
            iPos,
            iLen;

        for (iLen = strlen(str_announce); iPos < iLen; iPos ++)
            switch (str_announce[iPos])
            {
                case 'à':   an_str[iPos] = 151;
                case 'á':   an_str[iPos] = 152;
                case 'â':   an_str[iPos] = 153;
                case 'ä':   an_str[iPos] = 154;
                case 'À':   an_str[iPos] = 128;
                case 'Á':   an_str[iPos] = 129;
                case 'Â':   an_str[iPos] = 130;
                case 'Ä':   an_str[iPos] = 131;
                case 'è':   an_str[iPos] = 157;
                case 'é':   an_str[iPos] = 158;
                case 'ê':   an_str[iPos] = 159;
                case 'ë':   an_str[iPos] = 160;
                case 'È':   an_str[iPos] = 134;
                case 'É':   an_str[iPos] = 135;
                case 'Ê':   an_str[iPos] = 136;
                case 'Ë':   an_str[iPos] = 137;
                case 'ì':   an_str[iPos] = 161;
                case 'í':   an_str[iPos] = 162;
                case 'î':   an_str[iPos] = 163;
                case 'ï':   an_str[iPos] = 164;
                case 'Ì':   an_str[iPos] = 138;
                case 'Í':   an_str[iPos] = 139;
                case 'Î':   an_str[iPos] = 140;
                case 'Ï':   an_str[iPos] = 141;
                case 'ò':   an_str[iPos] = 165;
                case 'ó':   an_str[iPos] = 166;
                case 'ô':   an_str[iPos] = 167;
                case 'ö':   an_str[iPos] = 168;
                case 'Ò':   an_str[iPos] = 142;
                case 'Ó':   an_str[iPos] = 143;
                case 'Ô':   an_str[iPos] = 144;
                case 'Ö':   an_str[iPos] = 145;
                case 'ù':   an_str[iPos] = 169;
                case 'ú':   an_str[iPos] = 170;
                case 'û':   an_str[iPos] = 171;
                case 'ü':   an_str[iPos] = 172;
                case 'Ù':   an_str[iPos] = 146;
                case 'Ú':   an_str[iPos] = 147;
                case 'Û':   an_str[iPos] = 148;
                case 'Ü':   an_str[iPos] = 149;
                case 'ñ':   an_str[iPos] = 174;
                case 'Ñ':   an_str[iPos] = 173;
                case '¡':   an_str[iPos] = 64;
                case '¿':   an_str[iPos] = 175;
                case '`':   an_str[iPos] = 177;
                case '&':   an_str[iPos] = 38;
                default:    an_str[iPos] = str_announce[iPos];
            }
        return an_str;
}


stock GetPlayersInTeam(teamid)
{
    new count;
    for(new i=0;i< GetMaxPlayers();i++)
    {
        if(IsPlayerConnected(i) && gTeam[i] == teamid && !IsPlayerNPC(i)) count++;
    }
    return count;
}
stock GetZombiesInPlayer(playerid)
{
    new count;
    for(new i=0;i< GetMaxPlayers();i++)
    {
        if(IsPlayerConnected(i) && IsZombieNPC(i) && NPC_INFO[i][LastFinded] == playerid) count++;
    }
    return count;
}

stock GetTotalZombiesInPlayer(playerid)
{
    new count;
    for(new i=0;i<GetMaxPlayers();i++)
    {
        if(IsPlayerConnected(i) && IsZombieNPC(i))
		{
   			if(NPC_INFO[i][Attacking] == playerid || NPC_INFO[i][LastFinded] == playerid){
				count++;
			}
		}
    }
    return count;
}

stock GetTotalDronesInPlayer(playerid)
{
    new count;
    for(new i=0;i<GetMaxPlayers();i++)
    {
        if(IsPlayerConnected(i) && IsDroneBOT(i))
		{
   			if(NPC_INFO[i][Attacking] == playerid || NPC_INFO[i][LastFinded] == playerid){
				count++;
			}
		}
    }
    return count;
}

stock CheckAdminsOnline()
{
    new count;
    for(new i=0;i< GetMaxPlayers();i++)
    {
        if(IsPlayerConnected(i) && PlayerInfo[i][nivel] >= 1 && PlayerInfo[i][Ocultado] == 0 &&  !IsPlayerNPC(i))
        {
			count++;
		}
		else if(IsPlayerAdmin(i) && PlayerInfo[i][Ocultado] == 0)
		{
		    count++;
		    count++;
		}
    }
	return count;
}

strrest(const strx[], &index)
{
        new length = strlen(strx);
        while ((index < length) && (strx[index] <= ' '))
        {
                index++;
        }
        new offset = index;
        new result[128];
        while ((index < length) && ((index - offset) < (sizeof(result) - 1)))
        {
                result[index - offset] = strx[index];
                index++;
        }
        result[index - offset] = EOS;
        return result;
}


//stock strtok
strtok(const strx[], &index)
{
new length = strlen(strx);
while ((index < length) && (strx[index] <= ' '))
{
index++;
}

new offset = index;
new result[20];
while ((index < length) && (strx[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
{
result[index - offset] = strx[index];
index++;
}
result[index - offset] = EOS;
return result;
}

//==============================================================================
// stock CrearVehiculo.
//==============================================================================
CrearVehiculo(playerid, modelid)
{
if(VehicleOccupied(PlayerInfo[playerid][SpawnAuto]))
{
	new Float:CX,Float:CY,Float:CZ;
	GetPlayerPos(playerid,CX,CY,CZ);
	SetPlayerPos(playerid,CX,CY,CZ+0.1);
    RemovePlayerFromVehicle(playerid);
}
new Auto, Float: X, Float: Y, Float: Z, Float: Angulo;
if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
{
Auto = GetPlayerVehicleID(playerid);
GetVehiclePos(Auto, X, Y, Z);
GetVehicleZAngle(Auto, Angulo);
DestroyVehicle(Auto);
}
else
{
GetPlayerPos(playerid, X, Y, Z);
GetPlayerFacingAngle(playerid, Angulo);
}
if(PlayerInfo[playerid][SpawnAuto] != 0) DestroyVehicle(PlayerInfo[playerid][SpawnAuto]);
PlayerInfo[playerid][SpawnAuto] = CreateVehicle(modelid, X, Y, Z, Angulo, -1, -1, 60);
RemovePlayerFromVehicle(playerid);
PutPlayerInVehicle(playerid, PlayerInfo[playerid][SpawnAuto], 0);
LinkVehicleToInterior(Auto, GetPlayerInterior(playerid));
SetVehicleVirtualWorld(Auto, GetPlayerVirtualWorld(playerid));
return 1;
}

stock TeleportPlayer(playerid, Float:x,Float:y,Float:z,interior=0)
{
new cartype = GetPlayerVehicleID(playerid);
new State=GetPlayerState(playerid);
if(State!=PLAYER_STATE_DRIVER)
{
SetPlayerPos(playerid,x,y,z);
}
else if(IsPlayerInVehicle(playerid, cartype) == 1)
{
SetVehiclePos(cartype,x,y,z);
LinkVehicleToInterior(GetPlayerVehicleID(playerid),interior);
}
else
{
SetPlayerPos(playerid,x,y,z);
}
SetPlayerInterior(playerid,0);
}

stock IsPlayerInWater(playerid) {
        new anim = GetPlayerAnimationIndex(playerid);
        if (((anim >=  1538) && (anim <= 1542)) || (anim == 1544) || (anim == 1250) || (anim == 1062)) return 1;
        return 0;
}

stock IsPlayerAiming(playerid) {
	new anim = GetPlayerAnimationIndex(playerid);
	if (((anim >= 1160) && (anim <= 1163)) || (anim == 1167) || (anim == 1365) ||
	(anim == 1643) || (anim == 1453) || (anim == 220)) return 1;
        return 0;
}
    new legalmods[48][22] = {
        {400, 1024,1021,1020,1019,1018,1013,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {401, 1145,1144,1143,1142,1020,1019,1017,1013,1007,1006,1005,1004,1003,1001,0000,0000,0000,0000},
        {404, 1021,1020,1019,1017,1016,1013,1007,1002,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {405, 1023,1021,1020,1019,1018,1014,1001,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {410, 1024,1023,1021,1020,1019,1017,1013,1007,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000},
        {415, 1023,1019,1018,1017,1007,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {418, 1021,1020,1016,1006,1002,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {420, 1021,1019,1005,1004,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {421, 1023,1021,1020,1019,1018,1016,1014,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {422, 1021,1020,1019,1017,1013,1007,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {426, 1021,1019,1006,1005,1004,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {436, 1022,1021,1020,1019,1017,1013,1007,1006,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000},
        {439, 1145,1144,1143,1142,1023,1017,1013,1007,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000},
        {477, 1021,1020,1019,1018,1017,1007,1006,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {478, 1024,1022,1021,1020,1013,1012,1005,1004,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {489, 1024,1020,1019,1018,1016,1013,1006,1005,1004,1002,1000,0000,0000,0000,0000,0000,0000,0000},
        {491, 1145,1144,1143,1142,1023,1021,1020,1019,1018,1017,1014,1007,1003,0000,0000,0000,0000,0000},
        {492, 1016,1006,1005,1004,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {496, 1143,1142,1023,1020,1019,1017,1011,1007,1006,1003,1002,1001,0000,0000,0000,0000,0000,0000},
        {500, 1024,1021,1020,1019,1013,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {516, 1021,1020,1019,1018,1017,1016,1015,1007,1004,1002,1000,0000,0000,0000,0000,0000,0000,0000},
        {517, 1145,1144,1143,1142,1023,1020,1019,1018,1017,1016,1007,1003,1002,0000,0000,0000,0000,0000},
        {518, 1145,1144,1143,1142,1023,1020,1018,1017,1013,1007,1006,1005,1003,1001,0000,0000,0000,0000},
        {527, 1021,1020,1018,1017,1015,1014,1007,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {529, 1023,1020,1019,1018,1017,1012,1011,1007,1006,1003,1001,0000,0000,0000,0000,0000,0000,0000},
        {534, 1185,1180,1179,1178,1127,1126,1125,1124,1123,1122,1106,1101,1100,0000,0000,0000,0000,0000},
        {535, 1121,1120,1119,1118,1117,1116,1115,1114,1113,1110,1109,0000,0000,0000,0000,0000,0000,0000},
        {536, 1184,1183,1182,1181,1128,1108,1107,1105,1104,1103,0000,0000,0000,0000,0000,0000,0000,0000},
        {540, 1145,1144,1143,1142,1024,1023,1020,1019,1018,1017,1007,1006,1004,1001,0000,0000,0000,0000},
        {542, 1145,1144,1021,1020,1019,1018,1015,1014,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {546, 1145,1144,1143,1142,1024,1023,1019,1018,1017,1007,1006,1004,1002,1001,0000,0000,0000,0000},
        {547, 1143,1142,1021,1020,1019,1018,1016,1003,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {549, 1145,1144,1143,1142,1023,1020,1019,1018,1017,1012,1011,1007,1003,1001,0000,0000,0000,0000},
        {550, 1145,1144,1143,1142,1023,1020,1019,1018,1006,1005,1004,1003,1001,0000,0000,0000,0000,0000},
        {551, 1023,1021,1020,1019,1018,1016,1006,1005,1003,1002,0000,0000,0000,0000,0000,0000,0000,0000},
        {558, 1168,1167,1166,1165,1164,1163,1095,1094,1093,1092,1091,1090,1089,1088,0000,0000,0000,0000},
        {559, 1173,1162,1161,1160,1159,1158,1072,1071,1070,1069,1068,1067,1066,1065,0000,0000,0000,0000},
        {560, 1170,1169,1141,1140,1139,1138,1033,1032,1031,1030,1029,1028,1027,1026,0000,0000,0000,0000},
        {561, 1157,1156,1155,1154,1064,1063,1062,1061,1060,1059,1058,1057,1056,1055,1031,1030,1027,1026},
        {562, 1172,1171,1149,1148,1147,1146,1041,1040,1039,1038,1037,1036,1035,1034,0000,0000,0000,0000},
        {565, 1153,1152,1151,1150,1054,1053,1052,1051,1050,1049,1048,1047,1046,1045,0000,0000,0000,0000},
        {567, 1189,1188,1187,1186,1133,1132,1131,1130,1129,1102,0000,0000,0000,0000,0000,0000,0000,0000},
        {575, 1177,1176,1175,1174,1099,1044,1043,1042,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {576, 1193,1192,1191,1190,1137,1136,1135,1134,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {580, 1023,1020,1018,1017,1007,1006,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {589, 1145,1144,1024,1020,1018,1017,1016,1013,1007,1006,1005,1004,1000,0000,0000,0000,0000,0000},
        {600, 1022,1020,1018,1017,1013,1007,1006,1005,1004,0000,0000,0000,0000,0000,0000,0000,0000,0000},
        {603, 1145,1144,1143,1142,1024,1023,1020,1019,1018,1017,1007,1006,1001,0000,0000,0000,0000,0000}
};
iswheelmodel(modelid) {
    new wheelmodels[17] = {1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1096,1097,1098};
    for(new wm; wm < sizeof(wheelmodels); wm++) {
        if (modelid == wheelmodels[wm])
            return true;
    }
    return false;
}

IllegalCarNitroIde(carmodel) {
    new illegalvehs[29] = { 581, 523, 462, 521, 463, 522, 461, 448, 468, 586, 509, 481, 510, 472, 473, 493, 595, 484, 430, 453, 452, 446, 454, 590, 569, 537, 538, 570, 449 };
    for(new iv; iv < sizeof(illegalvehs); iv++) {
        if (carmodel == illegalvehs[iv])
            return true;
    }
    return false;
}

public OnPlayerHackDetected(playerid, hack_type)
{
	switch(hack_type)
	{
	        case MONEY_HACK:
	        {
				if(IsPlayerAdmin(playerid)) return 0;
				printf("[BAN] %s expulsado por MONEY HACKING",PlayerName2(playerid));
				new string[256];
				format(string, sizeof(string), "{FFFFFF}El Servidor {4DFFFF}[B]loqueo del servidor al Jugador {ffffff}%s. {4DFFFF}[Razón: Money Hack ]",PlayerName2(playerid));
				SendClientMessageToAll(-1, string);
	            BanEx(playerid,"Hacking #MONEY_HACK");
	            return 0;
	        }
	        case CAR_HACK:
	        {
				if(IsPlayerAdmin(playerid)||!IsPlayerInAnyVehicle(playerid)) return 0;
				printf("[KICK] %s expulsado por CLEO HACKING", PlayerName2(playerid));
				new string[256];
				format(string, sizeof(string), "{FFFFFF}El Servidor {4DFFFF}[E]xpulso del servidor al Jugador {ffffff}%s. {4DFFFF}[Razón: CLEO HACKING #iTroll ]",PlayerName2(playerid));
				SendClientMessageToAll(-1, string);
	            Kick(playerid);
	            return 0;
	        }
	        case AMMO_HACK:
	        {
				if(IsPlayerAdmin(playerid)) return 0;
				printf("[WARN] %s [ID: %d] Posible AMMO HACK", PlayerName2(playerid),playerid);
				new string[256];
				format(string,sizeof(string), "{4DFFFF}**{FFFFFF} Cheater {4DFFFF} DETECTADO {FFFFFF}%s[%d]: AMMO HACK {BBC1C1}[ Usa /spec %d Y VERIFICA ]",PlayerName2(playerid),playerid,playerid);
				MessageToAdmins(-1,string);
				return 0;
	        }
	        case BULLET_CRASH: return 0;
    }
	return 0;
}
/*public OnPlayerCleoDetected( playerid, cleoid )
{
	    switch(cleoid)
	    {
	        case CLEO_CARWARP:
	        {
				if(IsPlayerAdmin(playerid)) return 0;
				new string[256];
				format(string, sizeof(string), "{FFFFFF}El Servidor {4DFFFF} [B]loqueo del servidor al Jugador {ffffff}%s. {4DFFFF}[Razón: CLEO HACKING #CW ]",PlayerName2(playerid));
				SendClientMessageToAll(-1, string);
	            BanSQL(playerid,INVALID_PLAYER_ID,"CLEO HACKING #CAR WARP"); // Banear By Anti Cheat
	            return 0;
	        }
	        case CLEO_CAR_PARTICLE_SPAM:
	        {
				if(IsPlayerAdmin(playerid)) return 0;
				new string[256];
				format(string, sizeof(string), "{FFFFFF}El Servidor {4DFFFF} [B]loqueo del servidor al Jugador {ffffff}%s. {4DFFFF}[Razón: CLEO HACKING #PS ]",PlayerName2(playerid));
				SendClientMessageToAll(-1, string);
	            BanSQL(playerid,INVALID_PLAYER_ID,"CLEO HACKING #CAR SPAM"); // Banear By Anti Cheat
	            return 0;
	        }
	    }
    return 1;
}
*/
public OnVehicleMod(playerid, vehicleid, componentid)
{
    new vehicleide = GetVehicleModel(vehicleid);
    new modok = islegalcarmod(vehicleide, componentid);

    if (!modok)
	{
	new string[256];
	format(string, sizeof(string), "{FFFFFF}El Servidor {4DFFFF} [B]loqueo del servidor al Jugador {ffffff}%s. {4DFFFF}[Razón: CRASHER BITCH ¬¬ ]",PlayerName2(playerid));
	SendClientMessageToAll(-1, string);
	BanSQL(playerid,INVALID_PLAYER_ID,"HACKING #CAR_CRASHER");
	return 1;
    }
    return 1;
}

stock islegalcarmod(vehicleide, componentid) {
    new modok = false;
    if ( (iswheelmodel(componentid)) || (componentid == 1086) || (componentid == 1087) || ((componentid >= 1008) && (componentid <= 1010))) {
        new nosblocker = IllegalCarNitroIde(vehicleide);
        if (!nosblocker)
            modok = true;
    } else {
        for(new lm; lm < sizeof(legalmods); lm++) {
            if (legalmods[lm][0] == vehicleide) {
                for(new J = 1; J < 22; J++) {
                    if (legalmods[lm][J] == componentid)
                        modok = true;
                }
            }
        }
    }
    return modok;
}

stock Generame(playerid)
{
		if(gTeam[playerid] == Humano)
		{
		    if(PlayerInfo[playerid][LX] != 0 && PlayerInfo[playerid][LY] != 0 && PlayerInfo[playerid][LZ] != 0 && GetPVarInt(playerid, "PrimerSpawn"))
		    {
	    		SetPlayerPos(playerid, PlayerInfo[playerid][LX], PlayerInfo[playerid][LY], PlayerInfo[playerid][LZ]);
	    		if(PlayerInfo[playerid][LA] != 0.0)
	    		{
	    		    SetPlayerFacingAngle(playerid, PlayerInfo[playerid][LA]);
	    		}
	    		SetPlayerHealth(playerid, PlayerInfo[playerid][LHE]);
	    		SetPlayerArmour(playerid, PlayerInfo[playerid][LAR]);
	    		DeletePVar(playerid, "PrimerSpawn");
	    		TogglePlayerControllable(playerid, 0);
	    		GameTextForPlayer(playerid, "~w~Cargando..!", 5000, 3);
	    		PlayerInfo[playerid][SpawnProtection] = 1;
	    		SetTimerEx("ObjetosCargados", 2500, 0, "i", playerid);
		    }
		    else{
	    	new Random = random(sizeof(SPAWNS_HUMANOS));
	    	SetPlayerPos(playerid, SPAWNS_HUMANOS[Random][0], SPAWNS_HUMANOS[Random][1], SPAWNS_HUMANOS[Random][2]);
	    	}
		}
		else if(gTeam[playerid] == Zombie && !IsPlayerNPC(playerid))
		{
		    if(PlayerInfo[playerid][LX] != 0 && PlayerInfo[playerid][LY] != 0 && PlayerInfo[playerid][LZ] != 0 && GetPVarInt(playerid, "PrimerSpawn") )
		    {
	    		SetPlayerPos(playerid, PlayerInfo[playerid][LX], PlayerInfo[playerid][LY], PlayerInfo[playerid][LZ]);
	    		if(PlayerInfo[playerid][LA] != 0.0)
	    		{
	    		    SetPlayerFacingAngle(playerid, PlayerInfo[playerid][LA]);
	    		}
	    		SetPlayerHealth(playerid, PlayerInfo[playerid][LHE]);
	    		SetPlayerArmour(playerid, PlayerInfo[playerid][LAR]);
	    		DeletePVar(playerid, "PrimerSpawn");
	    		TogglePlayerControllable(playerid, 0);
	    		GameTextForPlayer(playerid, "~w~Cargando..!", 5000, 3);
	    		PlayerInfo[playerid][SpawnProtection] = 1;
	    		SetTimerEx("ObjetosCargados", 5000, 0, "i", playerid);
		    }
		    else{
	    	new Random = random(sizeof(SPAWNS_ZOMBIES));
	    	SetPlayerPos(playerid, SPAWNS_ZOMBIES[Random][0], SPAWNS_ZOMBIES[Random][1], SPAWNS_ZOMBIES[Random][2]);
	    	}
		}
		else if(IsZombieNPC(playerid))
		{
	    	new Random = random(sizeof(SPAWNS_ZOMBIES_BOT));
	    	FCNPC_Spawn(playerid,Zombie_Skins[random(sizeof(Zombie_Skins))], random(5) - random(5) + SPAWNS_ZOMBIES_BOT[Random][0], random(5) - random(5) + SPAWNS_ZOMBIES_BOT[Random][1], SPAWNS_ZOMBIES_BOT[Random][2]);
		}
		else if(IsDroneBOT(playerid))
		{
		    new Random = random(sizeof(SPAWNS_DRONES));
			FCNPC_Spawn(playerid, 285, random(5) - random(15) + SPAWNS_DRONES[Random][0], random(15) - random(5) + SPAWNS_DRONES[Random][1], SPAWNS_DRONES[Random][2]);
			FCNPC_SetInvulnerable(playerid, true);
			FCNPC_PutInVehicle(playerid, NPC_INFO[playerid][NPCVehicleID], 0);
		}
		return 1;
}


stock SetPlayerSkinFixed(playerid, skinid)
{
    /*
        // If player is being spectated, force spectators to start spectating again.
        SetTimerEx("ForceRespectate", 1000, false, "i", playerid);
   */

    // Store info before re-spawn
    new Float:Pos[4], Float:pHealth[2], CurrWep;
    CurrWep = GetPlayerWeapon(playerid);
    GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
    GetPlayerFacingAngle(playerid, Pos[3]);
    GetPlayerHealth(playerid,pHealth[0]);
    GetPlayerArmour(playerid,pHealth[1]);

    // Fixes vehicle bug
    if(IsPlayerInAnyVehicle(playerid))
        SetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]+2);

    new Weapons[13][2];
    for(new i = 0; i < 13; i++)
        GetPlayerWeaponData(playerid, i, Weapons[i][0], Weapons[i][1]);

    // Set spawn info and spawn player
    SetSpawnInfo(playerid, GetPlayerTeam(playerid), skinid, Pos[0], Pos[1], Pos[2]-0.4, Pos[3], 0, 0, 0, 0, 0, 0);
    PlayerInfo[playerid][IgnoreSpawn] = true;

    SpawnPlayer(playerid);

    // Set info back after re-spawn
    SetPlayerHealth(playerid, pHealth[0]);
    SetPlayerArmour(playerid, pHealth[1]);
    SetPlayerInterior(playerid, GetPlayerInterior(playerid));
    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(playerid));

    for(new i = 0; i < 13; i ++)
        GivePlayerWeapon(playerid, Weapons[i][0], Weapons[i][1]);
    SetPlayerArmedWeapon(playerid, CurrWep);
}

stock SetSelectedSkin(playerid)
{
	if (PlayerInfo[playerid][UsaSkin] == 1 && PlayerInfo[playerid][VIP] >= 2 && gTeam[playerid] == Humano && !IsPlayerAdmin(playerid))
	{
		SetPlayerSkinFixed(playerid,PlayerInfo[playerid][SkinID]);
	}
}

forward Anuncios();
public Anuncios()
{
SendClientMessageToAll(ADMIN_COLOR, " ");
switch(random(24))
{
case 0:SendClientMessageToAll(COLOR_ARTICULO, "[+]{FFFFFF} ¡UNETE AL GRUPO DE FACEBOOK! {FFFF33}www.facebook.com/groups/revolutionzombie/");
case 1:SendClientMessageToAll(COLOR_ARTICULO, "[+]{FFFFFF} ¿Sin armas o dinero? Dirigase hacia los cientifico para realizar misiones!");
case 2:SendClientMessageToAll(COLOR_ARTICULO, "[+]{FFFFFF} Sí tiene alguna duda acerca del servidor, utilice /ask, los moderadores le atenderan. ");
case 3:SendClientMessageToAll(COLOR_ARTICULO, "[+]{FFFFFF} Recuerda que si eres miembro de un clan debes tener cuidado por donde vas!");
case 4:SendClientMessageToAll(COLOR_ARTICULO, "[+]{FFFFFF} ¿Sabías Qué.. Puedes comprar un drone express en cualquier lugar? /buydrone");
case 5:SendClientMessageToAll(COLOR_ARTICULO, "[+]{FFFFFF} ¿Sabías qué.. Es posible adquirir drones más baratos en el simbolo de la bandera?");
case 6:SendClientMessageToAll(COLOR_ARTICULO, "[+]{FFFFFF} ¿Amigo sin Armas? Regalale una utilizando el comando /drop");
case 7:SendClientMessageToAll(COLOR_ARTICULO, "[+]{FFFFFF} Recuerde que para interactuar con los comerciantes del juego debe utilizar la tecla Y.");
case 8:SendClientMessageToAll(COLOR_ARTICULO, "[+]{FFFFFF} ¿Aburrido? Descarga el RZClient y máximiza tu diversión! {FF0099}http://bit.ly/RZCLIENTE");
case 9:SendClientMessageToAll(COLOR_ARTICULO, "[+]{FFFFFF} ¿Alguien está haciendo trampa? Reportelo con el comando /reportar");
case 10:SendClientMessageToAll(COLOR_ARTICULO, "[+]{FFFFFF} ¿Todos leen lo que escribes? Utilice el comando {FF0099}/g{ffffff} para hablar local y no globalmente.");
case 11:SendClientMessageToAll(COLOR_ARTICULO, "[+]{FFFFFF} ¿Cansado de los Zombies? Acuda a cualquier zona segura y deshagase de ellos!");
case 12:SendClientMessageToAll(COLOR_ARTICULO, "[+]{FFFFFF} ¿Sin Objetivo? Los cientificos (en los iconos del radar) pueden darte misiones!");
case 13:SendClientMessageToAll(COLOR_ARTICULO, "[+]{FFFFFF} ¿Un Hacker? Utilice el comando {FF0099}/reportar{ffffff} para evitar alertarlo!");
case 14:SendClientMessageToAll(COLOR_ARTICULO, "[+]{FFFFFF} ¿Sin Dinero? Pidale a algun amigo que le envie utilizando /sendcash");
case 15:SendClientMessageToAll(COLOR_ARTICULO, "[+]{FFFFFF} ¿Muy Díficil? Puede obtener una membresia VIP con puntos o pago mensual de paypal {FF0099}/rvip");
case 16:SendClientMessageToAll(COLOR_ARTICULO, "[+]{FFFFFF} ¿No le gusta ser de los buenos? Adquiere una membresia VIP utilizando puntos o dinero real para desbloquear el equipo z");
case 17:SendClientMessageToAll(COLOR_ARTICULO, "[+]{FFFFFF} ¿Sin Sangre? Acuda con cualquier comerciante de la ciudad y compre los antibioticos!");
case 18:SendClientMessageToAll(COLOR_ARTICULO, "[+]{FFFFFF} Recuerde guardar constantemente su progreso utilizando el comando {FF0099}/gc");
case 19:SendClientMessageToAll(COLOR_ARTICULO, "[+]{FFFFFF} Recuerde agregar la IP a favoritos: play.revolucion-zombie.com:7778");
case 20:SendClientMessageToAll(COLOR_ARTICULO, "[+]{FFFFFF} ¡RECOLECTA! TODAS LAS ARMAS ESTAN PERMITIDAS, ¡SÍ! TODAS!");
case 21:SendClientMessageToAll(COLOR_ARTICULO, "[+]{FFFFFF} ¡SÉ UN ZOMBIE! Los jugadores VIP tienen la posibilidad de ser zombies con diversas habilidades!");
case 22:SendClientMessageToAll(COLOR_ARTICULO, "[+]{FFFFFF} Visita la página web para adquirir el cliente: {F500F5}www.Revolucion-Zombie.com");
case 23:SendClientMessageToAll(COLOR_ARTICULO, "[+]{FFFFFF} ¿Sabias Qué.. El Cliente del servidor (RZClient) otorga armas adicionales cada vez que reapareces?");
case 24:SendClientMessageToAll(COLOR_ARTICULO, "[+]{FFFFFF} ¿Sabias Qué.. El Cliente del servidor (RZClient) bonifíca cada kill que haces?");
}
for(new npcid = 0; npcid < GetMaxPlayers(); npcid++)
{
	if(IsPlayerConnected(npcid) && IsZombieNPC(npcid) && NPC_INFO[npcid][InCORE] == 0)
	{
	    NPC_INFO[npcid][LastKiller] = INVALID_PLAYER_ID;
	    if(NPC_INFO[npcid][Attacking] == INVALID_PLAYER_ID)
	    {
	        ZS_Tick[npcid] = rztickcount();
     		//KillTimer(Attack[npcid]);
			NPC_INFO[npcid][LastFinded] = INVALID_PLAYER_ID;
			NPC_INFO[npcid][Attacking] = INVALID_PLAYER_ID;
			SetPlayerVirtualWorld(npcid,0);
			ZS_Tick[npcid] = rztickcount();
			RespawnearBOT(npcid);
	    }
	    else if(GetNPCHealth(npcid) <= 1.0)
	    {
     		//KillTimer(Attack[npcid]);
			NPC_INFO[npcid][LastFinded] = INVALID_PLAYER_ID;
			NPC_INFO[npcid][Attacking] = INVALID_PLAYER_ID;
			SetPlayerVirtualWorld(npcid,0);
			ZS_Tick[npcid] = rztickcount();
			RespawnearBOT(npcid);
	    }
	}
}
SendClientMessageToAll(ADMIN_COLOR, " ");
return 1;
}
stock MensajesVip(color,const strx[])
{
	for(new i = 0; i < GetMaxPlayers(); i++)
	{
	if(IsPlayerConnected(i) == 1) if (PlayerInfo[i][VIP] >= 1){
	SendClientMessage(i, color, strx);
	PlayerPlaySound(i, 1052, 0.0, 0.0, 0.0);
	}
	}
	return 1;
}

stock AdminChat(color, const text[])
{
  for(new i=0; i<GetMaxPlayers(); i++){
    if(IsPlayerConnected(i) && PlayerInfo[i][nivel] > 0){
        SendClientMessage(i, color, text);
    }
  }
}

stock IsNumeric(str[])
{
  for (new i = 0, j = strlen(str); i < j; i++){
    if (str[i] > '9' || str[i] < '0') return 0;
  }
  return 1;
}

stock RemoveSpaces(str[])
{
	strreplace(str," ","");
	return str;
}

stock StartSpectate(playerid, JugadorEspiado)
{
	for(new x=0; x<GetMaxPlayers(); x++) {
	    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && PlayerInfo[x][SpecID] == playerid) {
	       AdvanceSpectate(x);
		}
	}
	SetPlayerInterior(playerid,GetPlayerInterior(JugadorEspiado));
	SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(JugadorEspiado));
	TogglePlayerSpectating(playerid, 1);

	if(IsPlayerInAnyVehicle(JugadorEspiado)) {
		PlayerSpectateVehicle(playerid, GetPlayerVehicleID(JugadorEspiado));
		PlayerInfo[playerid][SpecID] = JugadorEspiado;
		PlayerInfo[playerid][SpecType] = ADMIN_SPEC_TYPE_VEHICLE;
	}
	else {
		PlayerSpectatePlayer(playerid, JugadorEspiado);
		PlayerInfo[playerid][SpecID] = JugadorEspiado;
		PlayerInfo[playerid][SpecType] = ADMIN_SPEC_TYPE_PLAYER;
	}
	new Float:hp, Float:ar;
	new string[256];
	GetPlayerName(JugadorEspiado,string,sizeof(string));
	GetPlayerHealth(JugadorEspiado, hp);	GetPlayerArmour(JugadorEspiado, ar);
	strreplace(string,"~","");
	format(string,sizeof(string),"~n~~n~~n~~n~~n~~n~~n~~n~~w~%s - id:%d~n~< -- >~n~hp:%0.1f ar:%0.1f $%d", string,JugadorEspiado,hp,ar,GetPlayerMoney(JugadorEspiado) );
	GameTextForPlayer(playerid,string,25000,3);
	return 1;
}

stock StopSpectate(playerid)
{
	TogglePlayerSpectating(playerid, 0);
	SetPlayerInterior(playerid,GetPlayerInterior(PlayerInfo[playerid][SpecID]));
	SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(PlayerInfo[playerid][SpecID]));
	GameTextForPlayer(playerid,"~n~~n~~n~~w~inspeccion terminada!",1000,3);
	PlayerInfo[playerid][SpecID] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][SpecType] = ADMIN_SPEC_TYPE_NONE;
	return 1;
}

stock AdvanceSpectate(playerid)
{
    if(ConnectedPlayers() == 2) { StopSpectate(playerid); return 1; }
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && PlayerInfo[playerid][SpecID] != INVALID_PLAYER_ID)
	{
	    for(new x=PlayerInfo[playerid][SpecID]+1; x<=GetMaxPlayers(); x++)
		{
	    	if(x == MAX_PLAYERS) x = 0;
	        if(IsPlayerConnected(x) && x != playerid && !IsPlayerAdmin(x) && !IsPlayerNPC(x))
			{
				if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && PlayerInfo[x][SpecID] != INVALID_PLAYER_ID || (GetPlayerState(x) != 1 && GetPlayerState(x) != 2 && GetPlayerState(x) != 3))
				{
					continue;
				}
				else
				{
					StartSpectate(playerid, x);
					break;
				}
			}
		}
	}
	return 1;
}

stock ReverseSpectate(playerid)
{
    if(ConnectedPlayers() == 2) { StopSpectate(playerid); return 1; }
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && PlayerInfo[playerid][SpecID] != INVALID_PLAYER_ID && !IsPlayerNPC(playerid))
	{
	    for(new x=PlayerInfo[playerid][SpecID]-1; x>=0; x--)
		{
	    	if(x == 0) x = GetMaxPlayers();
	        if(IsPlayerConnected(x) && x != playerid && !IsPlayerAdmin(x) && !IsPlayerNPC(x))
			{
				if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && PlayerInfo[x][SpecID] != INVALID_PLAYER_ID || (GetPlayerState(x) != 1 && GetPlayerState(x) != 2 && GetPlayerState(x) != 3))
				{
					continue;
				}
				else
				{
					StartSpectate(playerid, x);
					break;
				}
			}
		}
	}
	return 1;
}
stock DetectarSpam(SPAM[])
{
    new SSPAM;
    new CUENTAP,CUENTAN,CUENTAW,CUENTADP,CUENTAGB;
	for(SSPAM = 0; SSPAM < strlen(SPAM); SSPAM ++)
	{
	    if(SPAM[SSPAM] == '.') CUENTAP ++; //Cuenta los Puntos
	   // if(SPAM[SSPAM] == '0' || SPAM[SSPAM] == '1' || SPAM[SSPAM] == '2.' || SPAM[SSPAM] == '3.' || SPAM[SSPAM] == '4.' || SPAM[SSPAM] == '5.' || SPAM[SSPAM] == '6.' || SPAM[SSPAM] == '7.' || SPAM[SSPAM] == '8.' || SPAM[SSPAM] == '9.') CUENTAN ++; //Cuenta los Numeros*/
	    if(SPAM[SSPAM] == 'w' || SPAM[SSPAM] == 'W') CUENTAW ++; //Cuenta las "W"
	    if(SPAM[SSPAM] == ':') CUENTADP ++; //Cuenta los ":"
	    if(SPAM[SSPAM] == '_') CUENTAGB ++; //Cuenta los "_"
	}
 	if(CUENTAP >= 3 && CUENTAN >= 3) return 1;
 	if(CUENTAW >= 3) return 1;
 	if(CUENTAN >= 3) return 1;
 	if(CUENTAGB >= 2 && CUENTAN >= 3) return 1;
 	if(strfind(SPAM, ".com", true) != -1 || strfind(SPAM, "0.", true) != -1 || strfind(SPAM, "com.nu", true) != -1 || strfind(SPAM, ".com.ar", true) != -1 || strfind(SPAM, ".org", true) != -1 || strfind(SPAM, ".net", true) != -1 || strfind(SPAM, ".es", true) != -1 || strfind(SPAM, ".tk", true) != -1) return 1;
    if(strfind(SPAM, "1.", true) != -1  || strfind(SPAM, "2.", true) != -1 || strfind(SPAM, "3.", true) != -1 || strfind(SPAM, "4.", true) != -1 || strfind(SPAM, "5.", true) != -1 || strfind(SPAM, "6.", true) != -1 || strfind(SPAM, "7.", true) != -1 || strfind(SPAM, "8.", true) != -1 || strfind(SPAM, "9.", true) != -1) return 1;
    if(strfind(SPAM, "1:", true) != -1  || strfind(SPAM, "2:", true) != -1 || strfind(SPAM, "3:", true) != -1 || strfind(SPAM, "4:", true) != -1 || strfind(SPAM, "5:", true) != -1 || strfind(SPAM, "6:", true) != -1 || strfind(SPAM, "7:", true) != -1 || strfind(SPAM, "8:", true) != -1 || strfind(SPAM, "9:", true) != -1) return 1;
    if(strfind(SPAM, "-1", true) != -1  || strfind(SPAM, "-2", true) != -1 || strfind(SPAM, "-3", true) != -1 || strfind(SPAM, "-4", true) != -1 || strfind(SPAM, "-5", true) != -1 || strfind(SPAM, "-6", true) != -1 || strfind(SPAM, "-7", true) != -1 || strfind(SPAM, "-8", true) != -1 || strfind(SPAM, "-9", true) != -1) return 1;
    if(strfind(SPAM, ",1", true) != -1  || strfind(SPAM, ",2", true) != -1 || strfind(SPAM, ",3", true) != -1 || strfind(SPAM, ",4", true) != -1 || strfind(SPAM, ",5", true) != -1 || strfind(SPAM, ",6", true) != -1 || strfind(SPAM, ",7", true) != -1 || strfind(SPAM, ",8", true) != -1 || strfind(SPAM, ",9", true) != -1) return 1;
    if(strfind(SPAM, ", 1", true) != -1  || strfind(SPAM, ", 2", true) != -1 || strfind(SPAM, ", 3", true) != -1 || strfind(SPAM, ", 4", true) != -1 || strfind(SPAM, ", 5", true) != -1 || strfind(SPAM, ", 6", true) != -1 || strfind(SPAM, ", 7", true) != -1 || strfind(SPAM, ", 8", true) != -1 || strfind(SPAM, ", 9", true) != -1) return 1;
	if(CUENTADP >= 1 && CUENTAN >= 6) return 1;
 	return 0;
}
forward MessageToAdmins(color,const strx[]);
public MessageToAdmins(color,const strx[])
{
	for(new i = 0; i < GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i) == 1) if (PlayerInfo[i][nivel] >= 1 ) SendClientMessage(i, color, strx);
	}
	return 1;
}

forward MessageToRconAdmins(color,const strx[]);
public MessageToRconAdmins(color,const strx[])
{
	for(new i = 0; i < GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i) == 1) if (PlayerInfo[i][Ocultado] == 1 || IsPlayerAdmin(i)) SendClientMessage(i, color, strx);
	}
	return 1;
}


forward SendMessageToPeers(color,const strx[]);
public SendMessageToPeers(color,const strx[])
{
	for(new i = 0; i < GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i) == 1) if (RZClient_IsClientConnected(i)) SendClientMessage(i, color, strx);
	}
	return 1;
}


stock PlayerMessageToPlayers(playerid, color, message[])
{
    if(PlayerInfo[playerid][Ocultado] == 1) return MessageToRconAdmins(color, message);
	for(new i = 0; i < GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i) == 1) SendClientMessage(i, color, message);
	}
	return 1;
}


stock CMDMessageToAdmins(playerid,command[])
{
    new string[256];
	GetPlayerName(playerid,string,sizeof(string));
	format(string,sizeof(string),"[RZ]:{FFE5FF} %s[%i] Ha Usado El Comando {FF61D7}%s",string,playerid,command);
	return AdminMessageToAdmins(playerid,0xFF61D7FF,string);
}

stock AdminMessageToAdmins(playerid,color,command[])
{
    new string[256];
	format(string,sizeof(string),"%s",command);
	if(PlayerInfo[playerid][Ocultado] == 1) return MessageToRconAdmins(color, string);
	return MessageToAdmins(color,string);
}

stock SaveCMD(playerid, command[])
{
	new query[1000],PlayerIP[128];
	GetPlayerIp(playerid,PlayerIP,sizeof(PlayerIP));
	new year, Mes, Dia;
	getdate(year, Mes, Dia);
	format(query,sizeof(query),"INSERT INTO `CommandLogs` (ip, strlog, fecha) VALUES ('%s','%s','%d/%02d/%d')", PlayerIP, command, year, Mes, Dia);
	db_query(DataBase_USERS,query);
}

stock VIPMessageToAll(playerid,command[])
{
	if(PlayerInfo[playerid][Ocultado] == 1) return 1;
    new string[256];
	GetPlayerName(playerid,string,sizeof(string));
	format(string,sizeof(string),"[RZ] {4DFFFF}* VIP *{ffffff} %s[%i] utilizo el comando {f50000}%s",string,playerid,command);
	return PlayerMessageToPlayers(playerid, red,string);
}

stock VIPMessageToAdmins(playerid,command[])
{
    new string[256];
	GetPlayerName(playerid,string,sizeof(string));
	format(string,sizeof(string),"[Z-R]:{4DFFFF} * VIP *{ffffff} %s[%i] Ha Usado El Comando {f50000}%s",string,playerid,command);
	return AdminMessageToAdmins(playerid,red,string);
}

forward ConnectedPlayers();
public ConnectedPlayers()
{
	new Connected;
	for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i)) Connected++;
	return Connected;
}


stock ReturnPlayerID(PlayerName[])
{
	for(new i = 0; i < GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i))
		{
			if(strfind(pName(i),PlayerName,true)!=-1) return i;
		}
	}
	return INVALID_PLAYER_ID;
}

stock pName(playerid)
{
  new name[MAX_PLAYER_NAME];
  GetPlayerName(playerid, name, sizeof(name));
  return name;
}

forward VehRes(vehicleid);
public VehRes(vehicleid)
{
    DestroyVehicle(vehicleid);
}

forward CarDeleter(vehicleid);
public CarDeleter(vehicleid)
{
    for(new i=0;i<GetMaxPlayers();i++) {
        new Float:X,Float:Y,Float:Z;
    	if(IsPlayerInVehicle(i, vehicleid)) {
    	    RemovePlayerFromVehicle(i);
    	    GetPlayerPos(i,X,Y,Z);
        	SetPlayerPos(i,X,Y+3,Z);
	    }
	    SetVehicleParamsForPlayer(vehicleid,i,0,1);
	}
    SetTimerEx("VehRes",1500,0,"i",vehicleid);
}

stock EraseVehicle(vehicleid)
{
    for(new players=0;players<=GetMaxPlayers();players++)
    {
        new Float:X,Float:Y,Float:Z;
        if (IsPlayerInVehicle(players,vehicleid))
        {
            GetPlayerPos(players,X,Y,Z);
            SetPlayerPos(players,X,Y,Z+2);
            SetVehicleToRespawn(vehicleid);
        }
        SetVehicleParamsForPlayer(vehicleid,players,0,1);
    }
    SetTimerEx("VehRes",3000,0,"d",vehicleid);
    return 1;
}
forward VehicleOccupied(vehicleid);

public VehicleOccupied(vehicleid)
{
    for(new i=0;i<MAX_PLAYERS;i++)
    {
        if(IsPlayerInVehicle(i,vehicleid)) return 1;
    }
    return 0;
}

stock StopAudioStreamForPlayerEx(playerid)
{
	if(IsPlayerConnected(playerid))
	{
        StopAudioStreamForPlayer(playerid);
        RZClient_Stop(playerid, PlayerInfo[playerid][MP3_ID]);
        RZClient_Stop(playerid, PlayerInfo[playerid][PlayerTrack]);
	}
	return 1;
}

stock PlayAudioStreamForPlayerEx(playerid, link[])
{
	if(IsPlayerConnected(playerid))
	{
	    StopAudioStreamForPlayerEx(playerid);
		if(RZClient_IsClientConnected(playerid))
		{
		    PlayerInfo[playerid][MP3_ID] = RZClient_PlayStreamed(playerid, link, false, false, false);
		    //SendFormatMessage(playerid, red, "[RZClient]::Download {ffffff}%s",link);
		}
		else
		{
			PlayAudioStreamForPlayer(playerid, link);
		    //SendClientMessage(playerid, red, "[RZClient]:: {ffffff}Para reproducir audios descargue el RZClient. {1FFFFF}bit.ly/RZCliente");
		}
	}
	return 1;
}

stock PlayAudioStreamForAll(link[])
{
	for(new i, l = GetMaxPlayers();i<l;i++)
	{
		if(IsPlayerConnected(i) && !IsPlayerNPC(i))
		{
        //PlayAudioStreamForPlayerEx(i, link);
		dcmd_link_excut(i,link);
		}
	}
	return 1;
}
stock StopAudioStreamForAll()
{
        for(new i, l = GetMaxPlayers();i<l;i++) if(IsPlayerConnected(i) && !IsPlayerNPC(i)){
		 StopAudioStreamForPlayerEx(i);
		 }
        return 1;
}


stock ShowPlayerForAll(playerid)
{
        for(new i, l = GetMaxPlayers();i<l;i++)
		{
            ShowPlayerForPlayer(playerid, i);
		}
}

stock HidePlayerForAll(playerid)
{
        for(new i, l = GetMaxPlayers();i<l;i++)
		{
            HidePlayerForPlayer(playerid, i);
		}
}


GetVehicleModelIDFromName(vname[])
{
	for(new i = 0; i < 211; i++)
	{
		if ( strfind(VehicleNames[i], vname, true) != -1 )
			return i + 400;
	}
	return -1;
}

stock IsZombieSkin(skinID)
{
	switch(skinID)
	{
		case 77, 78, 134, 135, 136, 137, 212, 213, 239, 63, 64, 75, 85, 152, 207, 237, 238, 243, 244, 245, 253, 256, 257, 230, 162, 7, 9, 264, 241, 229, 209, 200, 160, 10, 262, 196, 183, 181, 168, 149, 139, 129, 121, 110, 105, 94, 91, 79: return 1;
		default: return 0;
	}
	return 0;
}
//==============================================================================
forward OcultarPlayer(playerid);
public OcultarPlayer(playerid)
{
	if(PlayerInfo[playerid][invisible] == 1 && PlayerInfo[playerid][VIP] >= 2)
	{
	    for(new i = 0; i < GetMaxPlayers(); i++)
		{
			if(!IsPlayerAdmin(i) && IsPlayerConnected(i))
			{
				ShowPlayerNameTagForPlayer(i,playerid, false);
			}
		}
		if(gTeam[playerid] == Humano)
		{
			SetPlayerColor(playerid,0x66B3FF00);
		}
	}
	else if(PlayerInfo[playerid][invisible] == 1 && PlayerInfo[playerid][VIP] == 0 || PlayerInfo[playerid][invisible] == 1 && PlayerInfo[playerid][VIP] == 1)
	{
		PlayerInfo[playerid][invisible] = 0;
		KillTimer(PlayerInfo[playerid][invisibleX]);
		if(gTeam[playerid] == Humano)
		{
			SetPlayerColor(playerid, HUMANO_COLOR);
		}
	    for(new i = 0; i < GetMaxPlayers(); i++) {ShowPlayerNameTagForPlayer(i,playerid, true);}
	}
	return 1;
}


stock ReConnect(PlayerID)
{
    new iStr[35],pIP[20];
    GetPlayerIp(PlayerID, pIP, sizeof(pIP));
    SetPVarInt(PlayerID, "Reconnecting", 1);
    SetPVarString(PlayerID, "RecIP", pIP);
    format(iStr, sizeof(iStr), "banip %s", pIP);
    SendRconCommand(iStr);
	return 1;
}

stock IsPlayerInAnyPickup(playerid)
{
	for(new a = 0; a < MAX_PICKUPS; a++)
	{
	    if(GetPickupStatus(a))
	    {
			if(IsPlayerInRangeOfPoint(playerid, 5.0, GetPickupXCoord(a), GetPickupYCoord(a), GetPickupZCoord(a))) return 1;
		}
	}
	return 0;
}

stock GetPlayerPickup(playerid)
{
	new X, Float:Dis, Float:Dis2, Player;
	Player = INVALID_PLAYER_ID;
	Dis = 99999.99;
	for (X=0; X<MAX_PICKUPS; X++)
	{
		if(GetPickupStatus(X))
		{
			Dis2 = GetPlayerDistanceFromPoint(playerid, GetPickupXCoord(X), GetPickupYCoord(X), GetPickupZCoord(X));
			if(Dis2 < Dis && Dis2 != -1.00)
			{
				Dis = Dis2;
				Player = X;
			}
		}
	}
	return Player;
}

stock CreateServerPickup(s_id, s_type, model, ptype, Float:X, Float:Y, Float:Z, Virtualworld)
{
    ptype = 1;
    ServerPickups[s_id][obj] = CreateDynamicObject(model, X, Y, Z, -1, -1, -1, Virtualworld);
	ServerPickups[s_id][objId] = ServerPickups[s_id][obj];
	ServerPickups[s_id][spickupId] = s_id;
    ServerPickups[s_id][pikcupActive] = 1;
    ServerPickups[s_id][pikcupActive] = 1;
    ServerPickups[s_id][pickupType] = s_type;
    ServerPickups[s_id][pickupSpawnType] = ptype;
    ServerPickups[s_id][pickupModel] = model;
    ServerPickups[s_id][pickupXC] = X;
    ServerPickups[s_id][pickupYC] = Y;
    ServerPickups[s_id][pickupZC] = Z;
    return 1;
}

stock DestroyServerPickup(spid)
{
    ServerPickups[spid][pikcupActive] = 0;
	DestroyDynamicObject( GetPickupObjId(spid) );
}
PUBLIC:RespawnServerPickup(spid)
{
    CreateServerPickup(GetPickupId(spid), GetServerPickupType(spid), GetPickupModel(spid), GetServerPickupSpawnType(spid), GetPickupXCoord(spid), GetPickupYCoord(spid), GetPickupZCoord(spid), 0);
	//printf("CreateServerPickup(%d,%d,%d,%f,%f,%f)",GetPickupId(spid), GetServerPickupType(spid), GetPickupModel(spid), GetServerPickupSpawnType(spid), GetPickupXCoord(spid), GetPickupYCoord(spid), GetPickupZCoord(spid));
	return 1;
}
stock GetPickupStatus(spid) return ServerPickups[spid][pikcupActive];
stock GetPickupObjId(spid) return ServerPickups[spid][objId];
stock GetPickupId(spid) return ServerPickups[spid][spickupId];
stock GetPickupModel(spid) return ServerPickups[spid][pickupModel];
stock GetServerPickupType(spid) return ServerPickups[spid][pickupType];
stock GetServerPickupSpawnType(spid) return ServerPickups[spid][pickupSpawnType];
PUBLIC:Float:GetPickupXCoord(spid) return ServerPickups[spid][pickupXC];
PUBLIC:Float:GetPickupYCoord(spid) return ServerPickups[spid][pickupYC];
PUBLIC:Float:GetPickupZCoord(spid) return ServerPickups[spid][pickupZC];

stock OnPlayerTakePickup(playerid, pickupid)
{
	if(GetPickupStatus(pickupid))
	{
	    if(IsPlayerOnMission(playerid) && GetMissionType(playerid) == 3)
	    {
			if(GetPickupModel(pickupid) == GetMissionObjType(playerid))
			{
				if(GetMissionProgressAmount(playerid) >= GetMissionProgressLimit(playerid))
				{
					PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
					SendClientMessage(playerid,red,"]<!>[ {ffffff}Tú mision está completa, dirigete con cualquier cientifico para recibir tu recompensa.");
					}else{
					PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0);
					SetMissionProgressAmount(playerid, GetMissionProgressAmount(playerid)+1);
					SendFormatMessage(playerid,red,"]< Mission Status >[ {ffffff}%s %d %s: %d/%d.",GetMissionObjetiveText(playerid),GetMissionProgressLimit(playerid),GetMissionObjTypeName(playerid),GetMissionProgressAmount(playerid),GetMissionProgressLimit(playerid));
				}
			}
		}
		if(GetPickupModel(pickupid) != 1582)
		{
		    new moneyadd = randomEx(5, 1000),gpickupName[60];
		    mission_GetPickUpName(GetPickupModel(pickupid),gpickupName,sizeof(gpickupName));
		    GivePlayerMoney(playerid, moneyadd);
			PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
			if(!IsPlayerOnMission(playerid)){
			SendFormatMessage(playerid,red,"]<!>[ {ffffff}Has encontrado %s! Recibiste $%d monedas, puedes conseguir más trabajando en una misión.", gpickupName, moneyadd);}
			else {
				SendFormatMessage(playerid,red,"]<!>[ {ffffff}Has encontrado %s! Recibiste $%d monedas.", gpickupName, moneyadd);
			}
		}
		SetTimerEx("RespawnServerPickup", 10*1000*60, false, "i", pickupid);
		DestroyServerPickup(pickupid);
	}
	return 1;
}


stock IsPlayerFacingPlayer(playerid, targetid, Float:dOffset)
{
    new
        Float:pX,
        Float:pY,
        Float:pZ,
        Float:pA,
        Float:X,
        Float:Y,
        Float:Z,
        Float:ang;

    if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return 0;
    GetPlayerPos(targetid, pX, pY, pZ);
    GetPlayerPos(playerid, X, Y, Z);
    GetPlayerFacingAngle(playerid, pA);

    if( Y > pY ) ang = (-acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
    else if( Y < pY && X < pX ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 450.0);
    else if( Y < pY ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
    return AngleInRangeOfAngle(-ang, pA, dOffset);
}


forward ObjetosCargados(playerid);
public ObjetosCargados(playerid)
{
    if(PlayerInfo[playerid][InCORE] == 1){
		RemovePlayerWeapon(playerid, 31);
		PlayerInfo[playerid][InCORE] = 0;
    }
    GameTextForPlayer(playerid, "~w~Listo!", 3000, 3);
    TogglePlayerControllable(playerid, 1);
    PlayerInfo[playerid][SpawnProtection] = 0;
    CheckRZClientRestricted(playerid);
    return 1;
}


stock getHCPlayerCount()
{
    new count;
    for(new i = 0; i < GetMaxPlayers(); i++) //Loops through all players
    {
        if(IsPlayerConnected(i) && PlayerInfo[i][InCORE] == 1 && !IsPlayerNPC(i)) count++;
    }
    return count;
}



stock GameTextForCoreFighters(msg[],time=15000)
{
    for(new playerid = 0; playerid < GetMaxPlayers(); playerid++) //Loops through all players
    {
        if(IsPlayerConnected(playerid) && PlayerInfo[playerid][InCORE] == 1 && !IsPlayerNPC(playerid))
        {
            GameTextForPlayer(playerid, msg, time, 3);
        }
    }
}

stock GiveCoreWeapons(playerid)
{
	//if(PlayerInfo[playerid][IsCoreWeapon] == 1)
	//{
	    //PlayerInfo[playerid][IsCoreWeapon] = 1;//arma del nucleo
		GivePlayerWeaponEx(playerid, 31, 10000, false);
	//}
}

stock FCNPC_setCorePoints(playerid)
{
	new move_path = FCNPC_CreateMovePath();
	FCNPC_AddPointToPath(move_path, random(5) - random(7) + GetCorePointXYZ(COORD_CORE_TYPE_POINT, COORD_CORE_POS_TYPE_X), random(7) - random(7) + GetCorePointXYZ(COORD_CORE_TYPE_POINT, COORD_CORE_POS_TYPE_Y), GetCorePointXYZ(COORD_CORE_TYPE_POINT, COORD_CORE_POS_TYPE_Z) + 1);
	FCNPC_AddPointToPath(move_path, GetCorePointXYZ(COORD_CORE_TYPE_CORE, COORD_CORE_POS_TYPE_X), GetCorePointXYZ(COORD_CORE_TYPE_CORE, COORD_CORE_POS_TYPE_Y), GetCorePointXYZ(COORD_CORE_TYPE_CORE, COORD_CORE_POS_TYPE_Z) + 1);
	FCNPC_GoByMovePath(playerid, move_path, HumanCore[ZOMBIES_MOVE_TYPE], HumanCore[ZOMBIES_MOVE_SPEED], true);
	//printf("MovePath created = %d, points = %d", move_path, FCNPC_GetNumberMovePoint(move_path));
}

stock SpawnCorePlayer(playerid)
{
	if(PlayerInfo[playerid][InCORE] == 1||NPC_INFO[playerid][InCORE] == 1)
	{
			switch(HumanCore[ZONE])
			{
				case CORE_ZONE1:
				{
				    if(!IsPlayerNPC(playerid)){
					new Random = ChooseNumber(5,6,7,8);
                    SetPlayerPos(playerid, random(5) - random(5) + CORESpawns_Zone1[Random][0], random(5) - random(5) + CORESpawns_Zone1[Random][1], CORESpawns_Zone1[Random][2]);
                    SetPlayerPos(playerid, random(5) - random(5) + CORESpawns_Zone1[Random][0], random(5) - random(5) + CORESpawns_Zone1[Random][1], CORESpawns_Zone1[Random][2]);
                    PlayerInfo[playerid][MAX_PLAYER_ZOMBIES]=1;
					GiveCoreWeapons(playerid);
					}
                    else
                    {
		    			new Random = ChooseNumber(2,3,4);
		    			FCNPC_SetPosition(playerid, CORESpawns_Zone1[Random][0], CORESpawns_Zone1[Random][1], CORESpawns_Zone1[Random][2]);
		    			FCNPC_setCorePoints(playerid);

                    }
				}
				case CORE_ZONE2:
				{
				    if(!IsPlayerNPC(playerid)){
					new Random = ChooseNumber(6,7,8,9);
                    SetPlayerPos(playerid, random(5) - random(5) + CORESpawns_Zone2[Random][0], random(5) - random(5) + CORESpawns_Zone2[Random][1], CORESpawns_Zone2[Random][2]);
                    SetPlayerPos(playerid, random(5) - random(5) + CORESpawns_Zone2[Random][0], random(5) - random(5) + CORESpawns_Zone2[Random][1], CORESpawns_Zone2[Random][2]);
                    PlayerInfo[playerid][MAX_PLAYER_ZOMBIES]=1;
					GiveCoreWeapons(playerid);
					}
                    else
                    {
		    			new Random = ChooseNumber(2,3,4,5);
		    			FCNPC_SetPosition(playerid,CORESpawns_Zone2[Random][0], CORESpawns_Zone2[Random][1], CORESpawns_Zone2[Random][2]);
		    			FCNPC_setCorePoints(playerid);
                    }
				}
				case CORE_ZONE3:
				{
				    if(!IsPlayerNPC(playerid)){
					new Random = ChooseNumber(5,6,7,8);
                    SetPlayerPos(playerid, random(5) - random(5) + CORESpawns_Zone3[Random][0], random(5) - random(5) + CORESpawns_Zone3[Random][1], CORESpawns_Zone3[Random][2]);
                    SetPlayerPos(playerid, random(5) - random(5) + CORESpawns_Zone3[Random][0], random(5) - random(5) + CORESpawns_Zone3[Random][1], CORESpawns_Zone3[Random][2]);
                    PlayerInfo[playerid][MAX_PLAYER_ZOMBIES]=1;
					GiveCoreWeapons(playerid);
					}
                    else
                    {
		    			new Random = ChooseNumber(2,3,4);
		    			FCNPC_SetPosition(playerid,CORESpawns_Zone3[Random][0], CORESpawns_Zone3[Random][1], CORESpawns_Zone3[Random][2]);
		    			FCNPC_setCorePoints(playerid);
                    }
				}

               case CORE_ZONE4:
               {
                    if(!IsPlayerNPC(playerid))
                    {
                         new Random = ChooseNumber(5,6,7,8);
                         SetPlayerPos(playerid, random(5) - random(5) + CORESpawns_Zone4[Random][0], random(5) - random(5) + CORESpawns_Zone4[Random][1], CORESpawns_Zone4[Random][2]);
                         SetPlayerPos(playerid, random(5) - random(5) + CORESpawns_Zone4[Random][0], random(5) - random(5) + CORESpawns_Zone4[Random][1], CORESpawns_Zone4[Random][2]);
                         PlayerInfo[playerid][MAX_PLAYER_ZOMBIES]=1;
                         GiveCoreWeapons(playerid);
                    }
                    else
                    {
                         new Random = ChooseNumber(2,3,4);
                         FCNPC_SetPosition(playerid,CORESpawns_Zone4[Random][0], CORESpawns_Zone4[Random][1], CORESpawns_Zone4[Random][2]);
                         FCNPC_setCorePoints(playerid);
                    }
               }
               case CORE_ZONE5:
               {
                    if(!IsPlayerNPC(playerid))
                    {
                         new Random = ChooseNumber(5,6,7,8);
                         SetPlayerPos(playerid, random(5) - random(5) + CORESpawns_Zone5[Random][0], random(5) - random(5) + CORESpawns_Zone5[Random][1], CORESpawns_Zone5[Random][2]);
                         SetPlayerPos(playerid, random(5) - random(5) + CORESpawns_Zone5[Random][0], random(5) - random(5) + CORESpawns_Zone5[Random][1], CORESpawns_Zone5[Random][2]);
                         PlayerInfo[playerid][MAX_PLAYER_ZOMBIES]=1;
                         GiveCoreWeapons(playerid);
                    }
                    else
                    {
                         new Random = ChooseNumber(2,3,4);
                         FCNPC_SetPosition(playerid,CORESpawns_Zone5[Random][0], CORESpawns_Zone5[Random][1], CORESpawns_Zone5[Random][2]);
                         FCNPC_setCorePoints(playerid);
                    }
               }
               case CORE_ZONE6:
               {
                    if(!IsPlayerNPC(playerid))
                    {
                         new Random = ChooseNumber(5,6,7,8);
                         SetPlayerPos(playerid, random(5) - random(5) + CORESpawns_Zone6[Random][0], random(5) - random(5) + CORESpawns_Zone6[Random][1], CORESpawns_Zone6[Random][2]);
                         SetPlayerPos(playerid, random(5) - random(5) + CORESpawns_Zone6[Random][0], random(5) - random(5) + CORESpawns_Zone6[Random][1], CORESpawns_Zone6[Random][2]);
                         PlayerInfo[playerid][MAX_PLAYER_ZOMBIES]=1;
                         GiveCoreWeapons(playerid);
                    }
                    else
                    {
                         new Random = ChooseNumber(2,3,4);
                         FCNPC_SetPosition(playerid,CORESpawns_Zone6[Random][0], CORESpawns_Zone6[Random][1], CORESpawns_Zone6[Random][2]);
                         FCNPC_setCorePoints(playerid);
                    }
               }
               case CORE_ZONE7:
               {
                    if(!IsPlayerNPC(playerid))
                    {
                         new Random = ChooseNumber(5,6,7,8);
                         SetPlayerPos(playerid, random(5) - random(5) + CORESpawns_Zone7[Random][0], random(5) - random(5) + CORESpawns_Zone7[Random][1], CORESpawns_Zone7[Random][2]);
                         SetPlayerPos(playerid, random(5) - random(5) + CORESpawns_Zone7[Random][0], random(5) - random(5) + CORESpawns_Zone7[Random][1], CORESpawns_Zone7[Random][2]);
                         PlayerInfo[playerid][MAX_PLAYER_ZOMBIES]=1;
                         GiveCoreWeapons(playerid);
                    }
                    else
                    {
                         new Random = ChooseNumber(2,3,4);
                         FCNPC_SetPosition(playerid,CORESpawns_Zone7[Random][0], CORESpawns_Zone7[Random][1], CORESpawns_Zone7[Random][2]);
                         FCNPC_setCorePoints(playerid);
                    }
               }
               case CORE_ZONE8:
               {
                    if(!IsPlayerNPC(playerid))
                    {
                         new Random = ChooseNumber(5,6,7,8);
                         SetPlayerPos(playerid, random(5) - random(5) + CORESpawns_Zone8[Random][0], random(5) - random(5) + CORESpawns_Zone8[Random][1], CORESpawns_Zone8[Random][2]);
                         SetPlayerPos(playerid, random(5) - random(5) + CORESpawns_Zone8[Random][0], random(5) - random(5) + CORESpawns_Zone8[Random][1], CORESpawns_Zone8[Random][2]);
                         PlayerInfo[playerid][MAX_PLAYER_ZOMBIES]=1;
                         GiveCoreWeapons(playerid);
                    }
                    else
                    {
                         new Random = ChooseNumber(2,3,4);
                         FCNPC_SetPosition(playerid,CORESpawns_Zone8[Random][0], CORESpawns_Zone8[Random][1], CORESpawns_Zone8[Random][2]);
                         FCNPC_setCorePoints(playerid);
                    }
               }
               case CORE_ZONE9:
               {
                    if(!IsPlayerNPC(playerid))
                    {
                         new Random = ChooseNumber(5,6,7,8);
                         SetPlayerPos(playerid, random(5) - random(5) + CORESpawns_Zone9[Random][0], random(5) - random(5) + CORESpawns_Zone9[Random][1], CORESpawns_Zone9[Random][2]);
                         SetPlayerPos(playerid, random(5) - random(5) + CORESpawns_Zone9[Random][0], random(5) - random(5) + CORESpawns_Zone9[Random][1], CORESpawns_Zone9[Random][2]);
                         PlayerInfo[playerid][MAX_PLAYER_ZOMBIES]=1;
                         GiveCoreWeapons(playerid);
                    }
                    else
                    {
                         new Random = ChooseNumber(2,3,4);
                         FCNPC_SetPosition(playerid,CORESpawns_Zone9[Random][0], CORESpawns_Zone9[Random][1], CORESpawns_Zone9[Random][2]);
                         FCNPC_setCorePoints(playerid);
                    }
               }
               case CORE_ZONE10:
               {
                    if(!IsPlayerNPC(playerid))
                    {
                         new Random = ChooseNumber(5,6,7,8);
                         SetPlayerPos(playerid, random(5) - random(5) + CORESpawns_Zone10[Random][0], random(5) - random(5) + CORESpawns_Zone10[Random][1], CORESpawns_Zone10[Random][2]);
                         SetPlayerPos(playerid, random(5) - random(5) + CORESpawns_Zone10[Random][0], random(5) - random(5) + CORESpawns_Zone10[Random][1], CORESpawns_Zone10[Random][2]);
                         PlayerInfo[playerid][MAX_PLAYER_ZOMBIES]=1;
                         GiveCoreWeapons(playerid);
                    }
                    else
                    {
                         new Random = ChooseNumber(2,3,4);
                         FCNPC_SetPosition(playerid,CORESpawns_Zone10[Random][0], CORESpawns_Zone10[Random][1], CORESpawns_Zone10[Random][2]);
                         FCNPC_setCorePoints(playerid);
                    }
               }

			}
	}
}


stock SpawnAllCoreFighters()
{
    for(new playerid = 0; playerid < GetMaxPlayers(); playerid++) //Loops through all players
    {
        if(IsPlayerConnected(playerid) && PlayerInfo[playerid][InCORE] == 1 && !IsPlayerNPC(playerid))
        {
            PlayerPlaySound(playerid, 15802, 0.0, 0.0, 0.0);
            SpawnCorePlayer(playerid);
        }
    }
}


stock StartCoreBattle()
{
    HumanCore[STATE] = CORE_FIGHTING;
	HumanCore[CURRENT_ROUND] = 1;
	GameTextForCoreFighters("~n~~n~~n~~n~~y~~h~PROTEGE EL NUCLEO!");
    SpawnAllCoreFighters();
	HumanCore[CHECKER] = SetTimer("SpawnCoreZombies", 5000, 1);//spawnear zombis :$
}

stock getZombiesInCore()
{
    new count;
    for(new i=0;i<GetMaxPlayers();i++)
    {
        if(IsPlayerConnected(i) && NPC_INFO[i][InCORE] == 1 && IsPlayerNPC(i)){ count++; }
    }
    return count;
}

stock ResetCoreZombies()
{
	KillTimer(HumanCore[CHECKER]);
    for(new i=0;i<GetMaxPlayers();i++)
    {
        if(IsPlayerConnected(i) && NPC_INFO[i][InCORE] == 1 && IsPlayerNPC(i)){
            NPC_INFO[i][InCORE] = 0;
            //NPC_INFO[i][CoreStep] = 0;
            RespawnearBOT(i);
        }
    }
}

forward SpawnCoreZombies();
public SpawnCoreZombies()
{
	new incoreZombies = getZombiesInCore();
	//printf("SpawnCoreZombies executed; incore: %d, ZPR: %d", incoreZombies, HumanCore[ZOMBIES_PER_ROUND]);
	if(incoreZombies <= HumanCore[ZOMBIES_PER_ROUND])//si la cantidad de zombis vivos en la ronda es menor que la permitida, spawnear!
	{
	    if(incoreZombies >= HumanCore[ZOMBIES_PER_ROUND]) return 0;
	    //printf("If 1 passed..");
		new count=0, limit = 2 + HumanCore[CURRENT_ROUND]+HumanCore[IZOMBIES_PER_ROUND];//2 + No de ronda actual + ipzr.
		//printf("Before Loop: limit = %d", limit);
		for(new npcID = 0; npcID < GetMaxPlayers(); npcID++)
		{
			if(IsPlayerConnected(npcID) && IsZombieNPC(npcID) && count < limit && FCNPC_IsDead(npcID) == 0 && incoreZombies < HumanCore[ZOMBIES_PER_ROUND])
			{
   				if(NPC_INFO[npcID][InCORE]==0){
   				if(incoreZombies >= HumanCore[ZOMBIES_PER_ROUND]) return 0;
			    SpawnCorePlayer(npcID);
			    //printf("Loop: NPC ID: %d | incore: %d | count: %d", npcID, incoreZombies,count);
				NPC_INFO[npcID][InCORE] = 1;
				//NPC_INFO[npcID][CoreStep] = 0;
				SetPlayerVirtualWorld(npcID,0);
				FCNPC_SetInterior(npcID,0);
                SpawnCorePlayer(npcID);
				incoreZombies = incoreZombies+1;
				count++;
				}
			}
		}
		//SetTimer("SpawnCoreZombies", randomEx(1000,2000), false);//repetir spawnear zombis :$
		//printf("Timer SpawnCoreZombies sent..");
	}
	return 1;
}

forward Float:GetCorePointXYZ(isCentralPoint, CoordPosType);
public Float:GetCorePointXYZ(isCentralPoint, CoordPosType)
{
	switch(HumanCore[ZONE])
	{
	     case CORE_ZONE1:
	     {

	          if(CoordPosType == COORD_CORE_POS_TYPE_X) return CORESpawns_Zone1[isCentralPoint][0];//x
	          if(CoordPosType == COORD_CORE_POS_TYPE_Y) return CORESpawns_Zone1[isCentralPoint][1];//y
	          if(CoordPosType == COORD_CORE_POS_TYPE_Z) return CORESpawns_Zone1[isCentralPoint][2];//z

	     }
	     case CORE_ZONE2:
	     {

	          if(CoordPosType == COORD_CORE_POS_TYPE_X) return CORESpawns_Zone2[isCentralPoint][0];//x
	          if(CoordPosType == COORD_CORE_POS_TYPE_Y) return CORESpawns_Zone2[isCentralPoint][1];//y
	          if(CoordPosType == COORD_CORE_POS_TYPE_Z) return CORESpawns_Zone2[isCentralPoint][2];//z

	     }
	     case CORE_ZONE3:
	     {

	          if(CoordPosType == COORD_CORE_POS_TYPE_X) return CORESpawns_Zone3[isCentralPoint][0];//x
	          if(CoordPosType == COORD_CORE_POS_TYPE_Y) return CORESpawns_Zone3[isCentralPoint][1];//y
	          if(CoordPosType == COORD_CORE_POS_TYPE_Z) return CORESpawns_Zone3[isCentralPoint][2];//z

	     }
	     case CORE_ZONE4:
	     {

	          if(CoordPosType == COORD_CORE_POS_TYPE_X) return CORESpawns_Zone4[isCentralPoint][0];//x
	          if(CoordPosType == COORD_CORE_POS_TYPE_Y) return CORESpawns_Zone4[isCentralPoint][1];//y
	          if(CoordPosType == COORD_CORE_POS_TYPE_Z) return CORESpawns_Zone4[isCentralPoint][2];//z

	     }
	     case CORE_ZONE5:
	     {

	          if(CoordPosType == COORD_CORE_POS_TYPE_X) return CORESpawns_Zone5[isCentralPoint][0];//x
	          if(CoordPosType == COORD_CORE_POS_TYPE_Y) return CORESpawns_Zone5[isCentralPoint][1];//y
	          if(CoordPosType == COORD_CORE_POS_TYPE_Z) return CORESpawns_Zone5[isCentralPoint][2];//z

	     }
	     case CORE_ZONE6:
	     {

	          if(CoordPosType == COORD_CORE_POS_TYPE_X) return CORESpawns_Zone6[isCentralPoint][0];//x
	          if(CoordPosType == COORD_CORE_POS_TYPE_Y) return CORESpawns_Zone6[isCentralPoint][1];//y
	          if(CoordPosType == COORD_CORE_POS_TYPE_Z) return CORESpawns_Zone6[isCentralPoint][2];//z

	     }
	     case CORE_ZONE7:
	     {

	          if(CoordPosType == COORD_CORE_POS_TYPE_X) return CORESpawns_Zone7[isCentralPoint][0];//x
	          if(CoordPosType == COORD_CORE_POS_TYPE_Y) return CORESpawns_Zone7[isCentralPoint][1];//y
	          if(CoordPosType == COORD_CORE_POS_TYPE_Z) return CORESpawns_Zone7[isCentralPoint][2];//z

	     }
	     case CORE_ZONE8:
	     {

	          if(CoordPosType == COORD_CORE_POS_TYPE_X) return CORESpawns_Zone8[isCentralPoint][0];//x
	          if(CoordPosType == COORD_CORE_POS_TYPE_Y) return CORESpawns_Zone8[isCentralPoint][1];//y
	          if(CoordPosType == COORD_CORE_POS_TYPE_Z) return CORESpawns_Zone8[isCentralPoint][2];//z

	     }
	     case CORE_ZONE9:
	     {

	          if(CoordPosType == COORD_CORE_POS_TYPE_X) return CORESpawns_Zone9[isCentralPoint][0];//x
	          if(CoordPosType == COORD_CORE_POS_TYPE_Y) return CORESpawns_Zone9[isCentralPoint][1];//y
	          if(CoordPosType == COORD_CORE_POS_TYPE_Z) return CORESpawns_Zone9[isCentralPoint][2];//z

	     }
	     case CORE_ZONE10:
	     {

	          if(CoordPosType == COORD_CORE_POS_TYPE_X) return CORESpawns_Zone10[isCentralPoint][0];//x
	          if(CoordPosType == COORD_CORE_POS_TYPE_Y) return CORESpawns_Zone10[isCentralPoint][1];//y
	          if(CoordPosType == COORD_CORE_POS_TYPE_Z) return CORESpawns_Zone10[isCentralPoint][2];//z

	     }
		default:
		{
			printf(">> Error en Configuracion del nucleo, Zona desconocida.");
			HumanCore[STATE] = CORE_FINISHED;//finalizar..
			return Float:0.0;
		}
	}
	return Float:0.0;
}

stock CreateCoreExplosion()
{
	if((rztickcount() - HumanCore[CoreExplosionTick]) >= 10){
    CreateExplosion(GetCorePointXYZ(COORD_CORE_TYPE_CORE, COORD_CORE_POS_TYPE_X), GetCorePointXYZ(COORD_CORE_TYPE_CORE, COORD_CORE_POS_TYPE_Y), GetCorePointXYZ(COORD_CORE_TYPE_CORE, COORD_CORE_POS_TYPE_Z), 2, 20.0);
    CreateExplosion(GetCorePointXYZ(COORD_CORE_TYPE_POINT, COORD_CORE_POS_TYPE_X), GetCorePointXYZ(COORD_CORE_TYPE_POINT, COORD_CORE_POS_TYPE_Y), GetCorePointXYZ(COORD_CORE_TYPE_POINT, COORD_CORE_POS_TYPE_Z), 1, 10.0);
    HumanCore[CoreExplosionTick] = rztickcount();
    }
}


forward HC_Checker();
public HC_Checker()
{
	//CORE_FIGHTING
	if(HumanCore[STATE] == CORE_FINISHED && (rztickcount() - HumanCore[CoreTick]) >= 5*60 && HumanCore[Enabled] == 1)//comenzar nuevo juego en 5min
	{
	    //crear nucleo nuevo
	    ResetCoreZombies();
	    DestroyDynamicObject(HumanCore[OBJ]);//Destruir nucleo de la otra ronda.
		HumanCore[STATE] = CORE_WAITING;//waiting..
		HumanCore[MAX_DEFENDERS] = ChooseNumber(10,15,5,15,15);
		HumanCore[MIN_DEFENDERS] = 1;
		HumanCore[ROUNDS] = 10;
		HumanCore[CURRENT_ROUND] = 0;
		HumanCore[ZOMBIES_TO_KILL] = ChooseNumber(150,180,200,250);
		HumanCore[ZOMBIES_PER_ROUND] = ChooseNumber(10,15);
		HumanCore[ZOMBIES_KILLED] = 0;
		HumanCore[IZOMBIES_PER_ROUND] = ChooseNumber(2,4,8);
		HumanCore[CURRENT_ESCAPES] = 0;
		HumanCore[MAX_ESCAPES] = ChooseNumber(5,10,10,10,5,15);// para perder
		HumanCore[REWARD] = ChooseNumber(5000,8000,8000,10000,15000,5000,5000,5000);
		HumanCore[REWARD_TYPE] = ChooseNumber(CORE_REWARD_TYPE_MONEY,CORE_REWARD_TYPE_SCORE);//MONEYY,SCORE
		if(HumanCore[REWARD_TYPE] == CORE_REWARD_TYPE_MONEY){
		HumanCore[REWARD] = HumanCore[REWARD] * 3;
		}
		HumanCore[ZONE] = ChooseNumber(CORE_ZONE1,CORE_ZONE2,CORE_ZONE3,CORE_ZONE4,CORE_ZONE5,CORE_ZONE6,CORE_ZONE7,CORE_ZONE8,CORE_ZONE9,CORE_ZONE10);
		HumanCore[ZOMBIES_MOVE_TYPE] = SLOW_ZOMBIE_MOVE_TYPE;
		HumanCore[ZOMBIES_MOVE_SPEED] = SLOW_ZOMBIE_MOVE_SPEED;

		switch(HumanCore[ZONE])
		{
			case CORE_ZONE1:
			{
			     HumanCore[XYZ][0] = CORESpawns_Zone1[0][0];//x
			     HumanCore[XYZ][1] = CORESpawns_Zone1[0][1];//y
			     HumanCore[XYZ][2] = CORESpawns_Zone1[0][2];//z
			     HumanCore[OBJ] = CreateDynamicObject(CORE_OBJECT, HumanCore[XYZ][0], HumanCore[XYZ][1], HumanCore[XYZ][2], -1, -1, -1, 0);
			}
			case CORE_ZONE2:
			{
			     HumanCore[XYZ][0] = CORESpawns_Zone2[0][0];//x
			     HumanCore[XYZ][1] = CORESpawns_Zone2[0][1];//y
			     HumanCore[XYZ][2] = CORESpawns_Zone2[0][2];//z
			     HumanCore[OBJ] = CreateDynamicObject(CORE_OBJECT, HumanCore[XYZ][0], HumanCore[XYZ][1], HumanCore[XYZ][2], -1, -1, -1, 0);
			}
			case CORE_ZONE3:
			{
			     HumanCore[XYZ][0] = CORESpawns_Zone3[0][0];//x
			     HumanCore[XYZ][1] = CORESpawns_Zone3[0][1];//y
			     HumanCore[XYZ][2] = CORESpawns_Zone3[0][2];//z
			     HumanCore[OBJ] = CreateDynamicObject(CORE_OBJECT, HumanCore[XYZ][0], HumanCore[XYZ][1], HumanCore[XYZ][2], -1, -1, -1, 0);
			}
			case CORE_ZONE4:
			{
			     HumanCore[XYZ][0] = CORESpawns_Zone4[0][0];//x
			     HumanCore[XYZ][1] = CORESpawns_Zone4[0][1];//y
			     HumanCore[XYZ][2] = CORESpawns_Zone4[0][2];//z
			     HumanCore[OBJ] = CreateDynamicObject(CORE_OBJECT, HumanCore[XYZ][0], HumanCore[XYZ][1], HumanCore[XYZ][2], -1, -1, -1, 0);
			}
			case CORE_ZONE5:
			{
			     HumanCore[XYZ][0] = CORESpawns_Zone5[0][0];//x
			     HumanCore[XYZ][1] = CORESpawns_Zone5[0][1];//y
			     HumanCore[XYZ][2] = CORESpawns_Zone5[0][2];//z
			     HumanCore[OBJ] = CreateDynamicObject(CORE_OBJECT, HumanCore[XYZ][0], HumanCore[XYZ][1], HumanCore[XYZ][2], -1, -1, -1, 0);
			}
			case CORE_ZONE6:
			{
			     HumanCore[XYZ][0] = CORESpawns_Zone6[0][0];//x
			     HumanCore[XYZ][1] = CORESpawns_Zone6[0][1];//y
			     HumanCore[XYZ][2] = CORESpawns_Zone6[0][2];//z
			     HumanCore[OBJ] = CreateDynamicObject(CORE_OBJECT, HumanCore[XYZ][0], HumanCore[XYZ][1], HumanCore[XYZ][2], -1, -1, -1, 0);
			}
			case CORE_ZONE7:
			{
			     HumanCore[XYZ][0] = CORESpawns_Zone7[0][0];//x
			     HumanCore[XYZ][1] = CORESpawns_Zone7[0][1];//y
			     HumanCore[XYZ][2] = CORESpawns_Zone7[0][2];//z
			     HumanCore[OBJ] = CreateDynamicObject(CORE_OBJECT, HumanCore[XYZ][0], HumanCore[XYZ][1], HumanCore[XYZ][2], -1, -1, -1, 0);
			}
			case CORE_ZONE8:
			{
			     HumanCore[XYZ][0] = CORESpawns_Zone8[0][0];//x
			     HumanCore[XYZ][1] = CORESpawns_Zone8[0][1];//y
			     HumanCore[XYZ][2] = CORESpawns_Zone8[0][2];//z
			     HumanCore[OBJ] = CreateDynamicObject(CORE_OBJECT, HumanCore[XYZ][0], HumanCore[XYZ][1], HumanCore[XYZ][2], -1, -1, -1, 0);
			}
			case CORE_ZONE9:
			{
			     HumanCore[XYZ][0] = CORESpawns_Zone9[0][0];//x
			     HumanCore[XYZ][1] = CORESpawns_Zone9[0][1];//y
			     HumanCore[XYZ][2] = CORESpawns_Zone9[0][2];//z
			     HumanCore[OBJ] = CreateDynamicObject(CORE_OBJECT, HumanCore[XYZ][0], HumanCore[XYZ][1], HumanCore[XYZ][2], -1, -1, -1, 0);
			}
			case CORE_ZONE10:
			{
			     HumanCore[XYZ][0] = CORESpawns_Zone10[0][0];//x
			     HumanCore[XYZ][1] = CORESpawns_Zone10[0][1];//y
			     HumanCore[XYZ][2] = CORESpawns_Zone10[0][2];//z
			     HumanCore[OBJ] = CreateDynamicObject(CORE_OBJECT, HumanCore[XYZ][0], HumanCore[XYZ][1], HumanCore[XYZ][2], -1, -1, -1, 0);
			}
		    default:
			{
				printf("Error en Configuracion del nucleo, Zona indefinida.");
				HumanCore[STATE] = CORE_FINISHED;//finalizar..
			}
		}

	}
	else if(HumanCore[STATE] == CORE_WAITING && HumanCore[Enabled] == 1)
	{
		new defendersOnline = getHCPlayerCount();
		if(defendersOnline < HumanCore[MIN_DEFENDERS])
		{
		    defendersOnline = HumanCore[MIN_DEFENDERS] - defendersOnline;
		    new RewardT[10];
			if(HumanCore[REWARD_TYPE] == CORE_REWARD_TYPE_MONEY) { RewardT = "DINERO"; }
			else if(HumanCore[REWARD_TYPE] == CORE_REWARD_TYPE_SCORE) { RewardT = "SCORE"; }
			new formatSX[256];
			format(formatSX, sizeof(formatSX),">] NUCLEO [< {ffffff}Premio: %d ({33FFFF}%s{ffffff}) {33FFFF}Zona %d",HumanCore[REWARD],RewardT, HumanCore[ZONE]);
		    SendMessageToPeers(red,"********");
            SendMessageToPeers(red,formatSX);
            format(formatSX, sizeof(formatSX),">] NUCLEO [< {ffffff}Falta {33FFFF}%d{ffffff} soldado(s) para proteger el nucleo.",defendersOnline);
			SendMessageToPeers(red,formatSX);
			SendMessageToPeers(red,">] NUCLEO [< {ffffff}Utilice el comando {33FFFF}/join{ffffff} para unirse a la batalla.");
			SendMessageToPeers(red,"********");
			GameTextForCoreFighters("~n~~n~~n~~n~~n~~Y~Esperando jugadores...");
	    }
	    else //ya estan los jugadores minimos.
	    {
			StartCoreBattle();//comenzar la batasha
	    }
	}
	return 1;
}

stock RemovePlayersFromCore()
{
    for(new playerid = 0; playerid < GetMaxPlayers(); playerid++) //Loops through all players
    {
        if(IsPlayerConnected(playerid) && PlayerInfo[playerid][InCORE] == 1 && !IsPlayerNPC(playerid))
        {
            Generame(playerid);
  			TogglePlayerControllable(playerid, 0);
    		PlayerInfo[playerid][SpawnProtection] = 1;
    		SetTimerEx("ObjetosCargados", 2000, 0, "i", playerid);
		    //if(PlayerInfo[playerid][IsCoreWeapon] == 1){
		            //RemovePlayerWeapon(playerid, 31);//atangana
		            //PlayerInfo[playerid][IsCoreWeapon] = 0;
		    //}
        }
    }
}

stock GiveCorePlayersReward()
{
    for(new i = 0; i < GetMaxPlayers(); i++) //Loops through all players
    {
        if(IsPlayerConnected(i) && PlayerInfo[i][InCORE] == 1 && !IsPlayerNPC(i))
        {
            if(HumanCore[REWARD_TYPE] == CORE_REWARD_TYPE_MONEY)
            {
                GivePlayerMoney(i, HumanCore[REWARD]);
            }
            else
            {
                SetPlayerScore(i, GetPlayerScore(i) + HumanCore[REWARD]);
            }
        }
    }
}


stock UpdateCoreRoundStatus()
{
	if(HumanCore[STATE] == CORE_FIGHTING)
	{
	if(HumanCore[CURRENT_ESCAPES] >= HumanCore[MAX_ESCAPES])
	{
     	ResetCoreZombies();
	    HumanCore[CoreTick] = rztickcount();
	    HumanCore[STATE] = CORE_FINISHED;
	    new roundstr[256];
	    format(roundstr, sizeof(roundstr), "~R~~H~~H~HAZ PERDIDO!~N~~W~ESCAPES ~R~%d~W~/~R~%d",HumanCore[CURRENT_ESCAPES],HumanCore[MAX_ESCAPES]);
     	GameTextForCoreFighters(roundstr,10000);
      	RemovePlayersFromCore();
		SendClientMessageToAll(red,"********");
		SendClientMessageToAll(red,">] RZ [< {ffffff}Joder nooooooooooo!!!");
		SendClientMessageToAll(red,">] RZ [< {ffffff}Han destruido el nucleo los zombis de mierda!");
		SendClientMessageToAll(red,">] RZ [< {ffffff}Mision fallida, suerte para la próxima.");
		SendClientMessageToAll(red,"********");
	}
	if(HumanCore[CURRENT_ROUND] > HumanCore[ROUNDS])
	{
     	ResetCoreZombies();
	    HumanCore[CoreTick] = rztickcount();
	    HumanCore[STATE] = CORE_FINISHED;
    	GiveCorePlayersReward();
	    new roundstr[256];
	    format(roundstr, sizeof(roundstr), "~G~~H~~H~HAZ GANADO!~N~~W~ESCAPES ~R~%d~W~/~R~%d",HumanCore[CURRENT_ESCAPES],HumanCore[MAX_ESCAPES]);
     	GameTextForCoreFighters(roundstr,12000);
      	RemovePlayersFromCore();
		new RewardT[10];
		if(HumanCore[REWARD_TYPE] == CORE_REWARD_TYPE_MONEY) { RewardT = "DINERO"; }
		else if(HumanCore[REWARD_TYPE] == CORE_REWARD_TYPE_SCORE) { RewardT = "SCORE"; }
		SendClientMessageToAll(COLOR_AMARILLO,"********");
		SendFormatMessageToAll(COLOR_AMARILLO,">] RZ [< {FF33CC}HOLY MOULY!!! +{33FFFF}%d{ffffff} %s", HumanCore[REWARD], RewardT);
		SendClientMessageToAll(COLOR_AMARILLO,">] RZ [< {ffffff}Ganamos Soldados!");
		SendClientMessageToAll(COLOR_AMARILLO,">] RZ [< {ffffff}Mision cumplida, bien hecho.");
		SendClientMessageToAll(COLOR_AMARILLO,"********");
	}
	else if(HumanCore[ZOMBIES_KILLED] >= HumanCore[ZOMBIES_TO_KILL])
	{
	    if(HumanCore[CURRENT_ROUND] == 2)
	    {
	        HumanCore[ZOMBIES_MOVE_SPEED] = MEDIUM_ZOMBIE_MOVE_SPEED;
	        HumanCore[ZOMBIES_MOVE_TYPE] = MEDIUM_ZOMBIE_MOVE_TYPE;
	    }
	    if(HumanCore[CURRENT_ROUND] >= 9)
	    {
	        HumanCore[ZOMBIES_MOVE_SPEED] = HIGH_ZOMBIE_MOVE_SPEED;
	        HumanCore[ZOMBIES_MOVE_TYPE] = HIGH_ZOMBIE_MOVE_TYPE;
	    }
	    HumanCore[CURRENT_ROUND]++;
	    HumanCore[ZOMBIES_KILLED] = 0;
	    HumanCore[ZOMBIES_TO_KILL] = HumanCore[ZOMBIES_TO_KILL] + HumanCore[IZOMBIES_PER_ROUND];
	    new roundstr[256];
	    format(roundstr, sizeof(roundstr), "~n~~n~~n~~n~~n~~G~~H~~H~RONDA SUPERADA!~N~~W~RONDA ~R~%d~W~/~R~%d",HumanCore[CURRENT_ROUND],HumanCore[ROUNDS]);
     	GameTextForCoreFighters(roundstr,5000);
		new RewardT[10];
		if(HumanCore[REWARD_TYPE] == CORE_REWARD_TYPE_MONEY) { RewardT = "DINERO"; }
		else if(HumanCore[REWARD_TYPE] == CORE_REWARD_TYPE_SCORE) { RewardT = "SCORE"; }
		SendClientMessageToAll(red,"********");
		SendClientMessageToAll(red,">] RZ [< {ffffff}Bien hecho soldados, superamos esta oleada.");
		SendFormatMessageToAll(red,">] RZ [< {ffffff}Si logramos protegerlo bien conseguiremos +{33FFFF}%d{ffffff} %s", HumanCore[REWARD], RewardT);
		SendFormatMessageToAll(red,">] RZ [< {ffffff}Seguid protegiendo el nucleo! (Ronda %d/%d) (Escapes %d/%d)",HumanCore[CURRENT_ROUND],HumanCore[ROUNDS],HumanCore[CURRENT_ESCAPES],HumanCore[MAX_ESCAPES]);
		SendClientMessageToAll(red,"********");
	}
	}
}


stock IsVehicleRCVehicle(vehicleid)
{
     switch(GetVehicleModel(vehicleid))
     {
          case 441,464,465,501,564,594: return 1;
     }
     return 0;
}


stock TogglePlayerHUD(bool:toggle, forplayerid = INVALID_PLAYER_ID)
{
  new BitStream:bs = BS_New(), RPC_ScrToggleWidescreen = 111;

  BS_WriteValue(bs, RNM_BOOL, !toggle);
  if(forplayerid != INVALID_PLAYER_ID)
  {
  	BS_RPC(bs, forplayerid, RPC_ScrToggleWidescreen);
  }
  else{
  	BS_RPC(bs, -1, RPC_ScrToggleWidescreen);
  }
  BS_Delete(bs);
  return 1;
}



stock SendBulletData(sender, hitid, hittype, weaponid, Float:XYZ_ORIGIN_COORDS[3], Float:XYZ_DESTINATION_COORDS[3], Float:XYZ_CENTER_DESTINATION_COORDS[3])
{


  XYZ_CENTER_DESTINATION_COORDS[0] = 0.0;
  XYZ_CENTER_DESTINATION_COORDS[1] = 0.0;
  XYZ_CENTER_DESTINATION_COORDS[2] = 0.0;

  if(IsPlayerInAnyVehicle(hitid) && hittype != BULLET_HIT_TYPE_VEHICLE)
  {
	hittype = BULLET_HIT_TYPE_VEHICLE;
  }

  new BitStream:bs = BS_New(), RPC_BULLET = 206;

  BS_WriteValue(bs, RNM_UINT8, RPC_BULLET);
  BS_WriteValue(bs, RNM_INT16, sender);
  BS_WriteValue(bs,
                    RNM_UINT8, hittype,
                    RNM_INT16, hitid,
                    RNM_FLOAT, XYZ_ORIGIN_COORDS[0],
                    RNM_FLOAT, XYZ_ORIGIN_COORDS[1],
                    RNM_FLOAT, XYZ_ORIGIN_COORDS[2],

					RNM_FLOAT, XYZ_DESTINATION_COORDS[0],
					RNM_FLOAT, XYZ_DESTINATION_COORDS[1],
					RNM_FLOAT, XYZ_DESTINATION_COORDS[2],

					RNM_FLOAT, XYZ_CENTER_DESTINATION_COORDS[0],
					RNM_FLOAT, XYZ_CENTER_DESTINATION_COORDS[1],
					RNM_FLOAT, XYZ_CENTER_DESTINATION_COORDS[2],

					RNM_UINT8, weaponid);





  //BS_Send(bs, sender);
  //BS_Send(bs, hitid);
  //BS_Send(bs, -1);
  BS_Send(bs, -1, HIGH_PRIORITY, UNRELIABLE_SEQUENCED);
  //BS_RPC(bs, sender, RPC_BULLET);
  BS_Delete(bs);
  //SendFormatMessageToAll(-1, "[SBD]: weaponid: %d, type: %d, hitid: %d, X,Y,Z: %.2f,%.2f,%.2f",weaponid, hittype, hitid, XYZ_DESTINATION_COORDS[0],XYZ_DESTINATION_COORDS[1],XYZ_DESTINATION_COORDS[2]);

  //BS_Send(BitStream:bs, player_id, PacketPriority:priority = HIGH_PRIORITY, PacketReliability:reliability = RELIABLE_ORDERED);
  //CSAMPFunctions::Send(&bs, HIGH_PRIORITY, RELIABLE_ORDERED, 0, CSAMPFunctions::GetPlayerIDFromIndex(forplayerid), false);
  //SendBulletData(sender, hitid, hittype, weaponid, Float:fHitOriginX, Float:fHitOriginY, Float:fHitOriginZ, Float:fHitTargetX, Float:fHitTargetY, Float:fHitTargetZ, Float:fCenterOfHitX, Float:fCenterOfHitY, Float:fCenterOfHitZ, forplayerid = -1);
}


/*


public OnPlayerReceivedRPC(player_id, rpc_id, BitStream:bs)
{
  if(rpc_id == 111){
	SendFormatMessageToAll(COLOR_ROJO, "[OnPlayerReceivedRPC]: Widescreen RPC Id: %d", rpc_id);
  }
  else{
  	SendFormatMessageToAll(-1, "[OnPlayerReceivedRPC]: RPC Id: %d", rpc_id);
  }
  return 1;
}


public OnServerSendPacket(player_id, packet_id, BitStream:bs)
{
  if(packet_id == 111){
	SendFormatMessageToAll(COLOR_ARTICULO, "[OnServerSendPacket]: Widescreen Packet Id: %d", packet_id);
  }
   return 1;
}



public OnPlayerReceivedPacket(player_id, packet_id, BitStream:bs)
{
   if(packet_id == 206)
   {
	   new hittype, hitid, weaponid, Float:XYZ_ORIGIN_COORDS[3],Float:XYZ_DESTINATION_COORDS[3],Float:XYZ_CENTER_DESTINATION_COORDS[3];
	   BS_IgnoreBits(bs, 8); // packet id
	   BS_ReadValue(bs,
	                    RNM_UINT8, hittype,
	                    RNM_INT16, hitid,
	                    RNM_FLOAT, XYZ_ORIGIN_COORDS[0],
	                    RNM_FLOAT, XYZ_ORIGIN_COORDS[1],
	                    RNM_FLOAT, XYZ_ORIGIN_COORDS[2],

						RNM_FLOAT, XYZ_DESTINATION_COORDS[0],
						RNM_FLOAT, XYZ_DESTINATION_COORDS[1],
						RNM_FLOAT, XYZ_DESTINATION_COORDS[2],

						RNM_FLOAT, XYZ_CENTER_DESTINATION_COORDS[0],
						RNM_FLOAT, XYZ_CENTER_DESTINATION_COORDS[1],
						RNM_FLOAT, XYZ_CENTER_DESTINATION_COORDS[2],

						RNM_UINT8, weaponid);
	   //printf("");
  	SendFormatMessageToAll(-1, "[OnPlayerReceivedPacket]: weaponid: %d, type: %d, hitid: %d, X,Y,Z: %.2f,%.2f,%.2f", weaponid, hittype, hitid, XYZ_CENTER_DESTINATION_COORDS[0],XYZ_CENTER_DESTINATION_COORDS[1],XYZ_CENTER_DESTINATION_COORDS[2]);

  }
  //SendFormatMessageToAll(-1, "[OnPlayerReceivedPacket]: Packet Id: %d", packet_id);
  return 1;
}


public OnServerSendPacket(player_id, packet_id, BitStream:bs)
{
   if(packet_id == 206)
   {
	   new hittype, hitid, weaponid, Float:XYZ_ORIGIN_COORDS[3],Float:XYZ_DESTINATION_COORDS[3],Float:XYZ_CENTER_DESTINATION_COORDS[3];
	   BS_IgnoreBits(bs, 8); // packet id
	   BS_ReadValue(bs,
	                    RNM_UINT8, hittype,
	                    RNM_INT16, hitid,
	                    RNM_FLOAT, XYZ_ORIGIN_COORDS[0],
	                    RNM_FLOAT, XYZ_ORIGIN_COORDS[1],
	                    RNM_FLOAT, XYZ_ORIGIN_COORDS[2],

						RNM_FLOAT, XYZ_DESTINATION_COORDS[0],
						RNM_FLOAT, XYZ_DESTINATION_COORDS[1],
						RNM_FLOAT, XYZ_DESTINATION_COORDS[2],

						RNM_FLOAT, XYZ_CENTER_DESTINATION_COORDS[0],
						RNM_FLOAT, XYZ_CENTER_DESTINATION_COORDS[1],
						RNM_FLOAT, XYZ_CENTER_DESTINATION_COORDS[2],

						RNM_UINT8, weaponid);
	   //printf("");
	SendFormatMessageToAll(-1, "[SendRPC]: weaponid: %d, type: %d, hitid: %d, X,Y,Z: %.2f,%.2f,%.2f",weaponid, hittype, hitid, XYZ_DESTINATION_COORDS[0],XYZ_DESTINATION_COORDS[1],XYZ_DESTINATION_COORDS[2]);

  }

   return 1;
}



*/

PUBLIC:OnDroneUpdate(playerid)
{
    if(IsDroneBOT(playerid))
    {
        if(GetVehicleModel(NPC_INFO[playerid][NPCVehicleID]) >= 1)
        {
            new HumanID = NPC_INFO[playerid][LastFinded];//obtener jugador mas cercano al bot.
            if(IsPlayerConnected(HumanID))
            {
      			new Float:x, Float:y, Float:z, Float:hx, Float:hy, Float:hz;
				GetPlayerPos(playerid, x, y, z);
				GetPlayerPos(HumanID, hx, hy, hz);
                if(PlayerInfo[HumanID][DRONE_ID] == playerid)
                {
              		if(IsHumanStreamedInFromEx(playerid,HumanID, x,y,z, hx,hy,hz, NPC_INFO[playerid][DRONE_MAX_OWNER_DISTANCE]))
              		{
				        if(FCNPC_GetVehicleID(playerid) != NPC_INFO[playerid][NPCVehicleID])
				        {
				            FCNPC_PutInVehicle(playerid, NPC_INFO[playerid][NPCVehicleID], 0);
				            printf("NPC %s[%d] is now in their vehicle id %d.", PlayerName2(playerid), playerid, NPC_INFO[playerid][NPCVehicleID]);
				        }
						if(PlayerInfo[HumanID][InCORE] == 1 && !IsPlayerAdmin(HumanID)){
					    	SendClientMessage(HumanID,red,">] DroneSystem [< {ffffff}Tu drone ha sido liberado porque has ingresado al nucleo.");
						    //SendFormatMessageToAll(0x0FFFF66FF, "<!> %s [%d] {ffffff}  dejó de protgeger a: {FF33CC}%s",PlayerName2(playerid), playerid, PlayerName2(HumanID) );
							PlayerInfo[HumanID][DRONE_ID] = INVALID_PLAYER_ID;//unset drone for playerid.
					 		NPC_INFO[playerid][LastFinded] = INVALID_PLAYER_ID;
					 		NPC_INFO[playerid][Attacking] = INVALID_PLAYER_ID;
							FreeDroneBOT(playerid, HumanID);
							return 1;
						}
              		    //SendFormatMessageToAll(0x0FFFF66FF, "<!> %s [%d] {ffffff} está protegiendo a: {FF33CC}%s",PlayerName2(playerid), playerid, PlayerName2(HumanID) );
				 		NPC_INFO[playerid][LastFinded] = HumanID;

						new Float:x2, Float:y2, Float:z2;
              		    new ZTarget = ObtenerBOTCercanoForDrone(HumanID);//obtener bot mas cercano al player.
              		    if(!IsPlayerConnected(ZTarget)) return 1;
						GetPlayerPos(ZTarget, x2, y2, z2);

              		    if(GetDistanceBetweenPositions(x,y,z, x2, y2, z2) <= NPC_INFO[playerid][DRONE_MAX_ATTACK_DISTANCE])
              		    {
			 				if(GetDistanceBetweenPositions(x,y,z, x2, y2, z2) <= NPC_INFO[playerid][DRONE_MIN_ATTACK_DISTANCE] && !IsPlayerPaused(HumanID) && (!IsPlayerAdmin(HumanID) && (hz - z2) < 3 ) || IsPlayerAdmin(HumanID))//disable ability only if unpaused.
			 				{
			 				    //SendFormatMessageToAll(-1,"Z Distace between you and the nearest zombie: (hz-z2): %f, (z2-hz) %f", hz - z2, z2 - hz);
			 				    SetFCNPCFacingXY(playerid, x2, y2);
			 				    MoveNPC(playerid, random(3)-random(5)+x2, random(5)-random(3)+y2, random(2) + z2 + 1, MOVE_TYPE_DRIVE, 0.69444, false);
			 				    new Float:newHealth = GetNPCHealth(ZTarget) - randomEx(NPC_INFO[playerid][DRONE_MIN_ATTACK_HIT], NPC_INFO[playerid][DRONE_MAX_ATTACK_HIT]);
			 				    //new health_bar[256];
			 				    //format(health_bar, sizeof(health_bar), "Health: %.02f\nDamage: %.02f",GetNPCHealth(ZTarget), newHealth);
			 				    //TextoBuble(ZTarget, health_bar);
			 				    //ElECTRO SHOCK: 41604
			 				    //ELECTRO SHOCK MAS BAJITO: 6003
			 				    //ELECTRO SHOCK SUAVE Y LARGO: 6402
			 				    //PUCK! PUCK! (RARITO XDD, como sonido de chupon): 6801
			 				    //Alarma extraña: 14800
			 				    //alarma como de abandonen la nave o fallo del sistema xdd: 30600
			 				    //NearPlayersPlaySound(soundid, x, y, z, Float:range)
			 				    if(NPC_INFO[playerid][DRONE_MIN_ATTACK_HIT] <= 15)
			 				    {
			 				    	NearPlayersPlaySound(6801, x, y, z, 10);
			 				    }
			 				    else{
			 				    	NearPlayersPlaySound(6402, x, y, z, 10);
			 				    }
			 				    if(newHealth <= 2)
			 				    {
			 				        KillBOT(ZTarget, HumanID, 50);
			 				        NPC_INFO[playerid][Attacking] = ZTarget;
			 				        //SendFormatMessageToAll(0x0FFFF66FF, "<!> %s [%d] {ffffff} killed: {FF33CC}%s",PlayerName2(HumanID),HumanID, PlayerName2(ZTarget) );
			 				        //ApplyAnimation(ZTarget, "PED", "BIKE_fall_off" ,4.1,0,1,1,1,1);
			 				    }
			 				    else
							    {
									SetNPCHealth(ZTarget, newHealth);
						 			NPC_INFO[playerid][Attacking] = ZTarget;
							    }
			 				}
              		    }
						else
						{
						    SetFCNPCFacingXY(playerid, hx, hy);
				            MoveNPC(playerid, random(5)-random(10)+hx, random(10)-random(5)+hy, random(4) + hz + 2, MOVE_TYPE_DRIVE, 0.8645, false);
			            }
			            if(GetDistanceBetweenPositions(x,y,z, hx, hy, hz) >= (NPC_INFO[playerid][DRONE_MAX_OWNER_DISTANCE] - 10) )
			            {
			                SendClientMessage(HumanID,red,">] DroneSystem [< {ffffff}Te estas alejando demasiado deL drone, vas a perderlo!");
			            }

			            //printf("NPC %s[%d] is now following the human %s[%d]", PlayerName2(playerid), playerid, PlayerName2(HumanID), HumanID);
		            }
		            else if (HumanID != INVALID_PLAYER_ID)
					{
					    //FCNPC_RemoveFromVehicle(playerid);
					    SendClientMessage(HumanID,red,">] DroneSystem [< {ffffff}Haz perdido tú drone, te alejaste demasiado de él.");
					    //SendFormatMessageToAll(0x0FFFF66FF, "<!> %s [%d] {ffffff}  dejó de protgeger a: {FF33CC}%s",PlayerName2(playerid), playerid, PlayerName2(HumanID) );
						PlayerInfo[HumanID][DRONE_ID] = INVALID_PLAYER_ID;//unset drone for playerid.
				 		NPC_INFO[playerid][LastFinded] = INVALID_PLAYER_ID;
				 		NPC_INFO[playerid][Attacking] = INVALID_PLAYER_ID;
						FreeDroneBOT(playerid, HumanID);
		            }
	            }
            }
		            else if (NPC_INFO[playerid][LastFinded] != INVALID_PLAYER_ID)
					{
					    //FCNPC_RemoveFromVehicle(playerid);
					    //SendClientMessage(HumanID,red,">] DroneSystem [< {ffffff}Haz perdido tú drone, te alejaste demasiado de él.");
					    //SendFormatMessageToAll(0x0FFFF66FF, "<!> %s [%d] {ffffff}  dejó de protgeger a: {FF33CC}%s",PlayerName2(playerid), playerid, PlayerName2(HumanID) );
						PlayerInfo[HumanID][DRONE_ID] = INVALID_PLAYER_ID;//unset drone for playerid.
				 		NPC_INFO[playerid][LastFinded] = INVALID_PLAYER_ID;
				 		NPC_INFO[playerid][Attacking] = INVALID_PLAYER_ID;
						FreeDroneBOT(playerid, HumanID);
		            }
        }
        else{
            //printf("NPC %s[%d] can't follow humans because of unmatched vehicle id %d != %d", PlayerName2(playerid), playerid, FCNPC_GetVehicleID(playerid), NPC_INFO[playerid][NPCVehicleID]);
        }
        return 1;
    }
    else return 0;
}

PUBLIC:OnCoreZombieUpdate(playerid, victimID)
{
	if(NPC_INFO[playerid][InCORE] == 1)
	{
		if(IsFCNPCInRangeOfPlayer(playerid,victimID,2.5) && !IsPlayerNPC(victimID))
		{
				new Float:health;
		        SetFCNPCFacingPlayer(playerid, victimID);
				GetPlayerHealth(victimID, health);
				if(health >= 1 && !IsPlayerDead(victimID))
				{
				    FCNPC_ClearAnimations(playerid);
					ClearAnimations(playerid);
					ApplyAnimation(playerid, "WAYFARER", "WF_Fwd", 4.1, 0, 0, 0, 0, 1);
					ApplyAnimation(victimID, "PED", "DAM_armR_frmFT", 4.1, 0, 0, 0, 0, 1);
					PlayerPlaySound(victimID, 1136, 0.0, 0.0, 0.0);
					SetPlayerHealth(victimID,health-5.0);
					SetPlayerScore(playerid, GetPlayerScore(playerid) + 5);
					GivePlayerMoney(playerid,500);
					NPC_INFO[victimID][LastAttacker] = playerid;
				}
		}
		/*
		new Float:x = GetCorePointXYZ(COORD_CORE_TYPE_CORE, COORD_CORE_POS_TYPE_X),Float:y = GetCorePointXYZ(COORD_CORE_TYPE_CORE, COORD_CORE_POS_TYPE_Y),Float:z = GetCorePointXYZ(COORD_CORE_TYPE_CORE, COORD_CORE_POS_TYPE_Z);
   		//ApplyAnimation(playerid,NPC_Walking_Library[playerid],NPC_Walking_Style[playerid],4.1,1,1,1,1,1);
   		if(NPC_INFO[playerid][CoreStep] == 0)
   		{
   		    //printf("NPC: %d CoreStep %d", NPC_INFO[playerid][CoreStep]);
			x = GetCorePointXYZ(COORD_CORE_TYPE_POINT, COORD_CORE_POS_TYPE_X),y = GetCorePointXYZ(COORD_CORE_TYPE_POINT, COORD_CORE_POS_TYPE_Y),z = GetCorePointXYZ(COORD_CORE_TYPE_POINT, COORD_CORE_POS_TYPE_Z);
   		}
   		SetFCNPCFacingXY(playerid, x, y);
   		//printf("MoveNPC: %d (%f,%f,%f) Speed: %f", playerid, x,y,z, HumanCore[ZOMBIES_MOVE_SPEED]);
		MoveNPC(playerid,random(5) - random(7) +x, random(7) - random(7) +y, z, HumanCore[ZOMBIES_MOVE_TYPE], HumanCore[ZOMBIES_MOVE_SPEED]);//ÑACA!!
		*/
		return 1;
	}
	return 0;
}

PUBLIC:OnAmbientZombieUpdate(playerid, victimID)
{
	if(IsHumanStreamedInFrom(playerid,victimID))
	{
		new Float:health;
		new Float:x, Float:y, Float:z;
		GetPlayerPos(victimID, x, y, z);
 		NPC_INFO[playerid][LastFinded] = victimID;
 		NPC_INFO[playerid][Attacking] = victimID;
   		if(!IsPlayerDead(victimID) && IsPlayerInAnyVehicle(victimID) && IsPlayerInRangeOfPlayer(playerid,victimID,6.0) && !IsBike(GetVehicleModel(GetPlayerVehicleID(victimID))))
     	{
     	    if(PlayerInfo[victimID][DRONE_ID] != INVALID_PLAYER_ID)
     	    {
     	        if(GetDriverId(GetPlayerVehicleID(victimID)) == PlayerInfo[victimID][DRONE_ID])
     	        {
     	        	CallLocalFunction("OnPlayerCommandText", "is", victimID, "/sync");
     	        }
     	    }
     	    SetFCNPCFacingPlayer(playerid, victimID);
     	    if(NPC_NEMESIS[playerid] == 1)
     	    {
 			TextoBuble(playerid,"MUERE INSECTO WHUAAHAH!");
            CreateExplosionForEnemies(playerid, x,y,z+3, 7,30.0);
            CreateExplosionForEnemies(playerid, x,y,z+3, 7,30.0);
     	    CreateExplosionForEnemies(playerid, x,y,z+3, 7,30.0);
		    new vehicleid = GetPlayerVehicleID(victimID);
		    SetVehicleHealth(vehicleid, 0);
     	    }
     	    else{
     	    new Float:vhealth;
		    new vehicleid = GetPlayerVehicleID(victimID);
		    GetVehicleHealth(vehicleid, vhealth);
		    SetVehicleHealth(vehicleid, vhealth-50.0);
			ApplyAnimation(playerid, "BSKTBALL","BBALL_react_miss", 4.1, 1, 1, 1, 1, 1,1);
			ApplyAnimation(playerid, "BSKTBALL","BBALL_react_miss", 4.1, 1, 1, 1, 1, 1,1);
			ApplyAnimation(playerid, "BSKTBALL","BBALL_react_miss", 4.1, 1, 1, 1, 1, 1,1);
			ApplyAnimation(playerid, "BSKTBALL","BBALL_react_miss", 4.1, 1, 1, 1, 1, 1,1);
			}
        }
		else if(!IsPlayerDead(victimID) && IsFCNPCInRangeOfPlayer(playerid,victimID,2.5) && !IsPlayerNPC(victimID))
		{
		        SetFCNPCFacingPlayer(playerid, victimID);
				GetPlayerHealth(victimID, health);
				if(health >= 1 && !IsPlayerDead(victimID))
				{
				    FCNPC_ClearAnimations(playerid);
					ClearAnimations(playerid);
					ApplyAnimation(playerid, "WAYFARER", "WF_Fwd", 4.1, 0, 0, 0, 0, 0, 1);
					ApplyAnimation(victimID, "PED", "DAM_armR_frmFT", 4.1, 0, 0, 0, 0, 0, 1);
					PlayerPlaySound(victimID, 1136, 0.0, 0.0, 0.0);
					GetPlayerPos(victimID, x, y, z);
					if(PlayerInfo[victimID][ZonaInfectada] == 1)
					{
           			    switch(NPC_INFO[playerid][BType])
           			    {
							case 3: { SetPlayerHealth(victimID,health-9.0); }//Cerebro
							case 2: { SetPlayerHealth(victimID,health-12.0); }//Heart
	                		default: { SetPlayerHealth(victimID,health-8.0); }//Normals
            			}
					}
					else{
						SetPlayerHealth(victimID,health-5.0);
					}
					SetPlayerScore(playerid, GetPlayerScore(playerid) + 5);
					GivePlayerMoney(playerid,500);
					NPC_INFO[victimID][LastAttacker] = playerid;
					if(NPC_NEMESIS[playerid] == 1)
					{
					    GetPlayerPos(victimID, x, y, z);
					    GameTextForPlayer(victimID, "~r~WHRHAA!", 3000, 5);
		            	//CreateExplosion(x, y , z + 3, 1, 10);
		            	CreateExplosionForEnemies(playerid, x,y,z+3, 1, 15, victimID);
		            	SetPlayerHealth(victimID,0);
		            }
		            else
		            {
     		           GameTextForPlayer(victimID, "~r~WHRHAA!.", 3000, 5);
		            }
				}
		}
		else
 		{
		    if(NPC_NEMESIS[playerid] == 1)
			{
			    if(GetPlayerWeapon(playerid) != 35){
			    	printf("Giving Minigun for %s Nesmsis.",PlayerName2(playerid));
			    	FCNPC_ToggleInfiniteAmmo(playerid, true);
			    	FCNPC_SetWeaponClipSize(playerid, 35, 40);
			    	FCNPC_SetWeapon(playerid, 35);
			    	FCNPC_SetWeaponShootTime(playerid, 35, 0);
			    	FCNPC_SetWeaponReloadTime(playerid, 35, 1000 * 10);
			    	FCNPC_ToggleReloading(playerid, true);
			    }
				if(FCNPC_GetSkin(playerid) != 163)
				{
				FCNPC_SetSpecialAction(playerid,SPECIAL_ACTION_NONE);
				FCNPC_SetSkin(playerid, 163);
				}
					TextoBuble(playerid,"WHUAHAHAH!!");
					GameTextForPlayer(victimID, "~r~~h~Nemesis te esta apuntando!.", 3000, 5);
    			MoveNPCAttack(playerid, x, y, z, MOVE_TYPE_SPRINT, 0.75444, false);
			}
		    else if(NPC_NEMESIS[playerid] == 0)
			{
			    //ApplyAnimation(playerid,NPC_Walking_Library[playerid],NPC_Walking_Style[playerid],4.1,1,1,1,1,1);
   			    if(PlayerInfo[victimID][ZonaInfectada] == 1)
   			    {
       			    switch(NPC_INFO[playerid][BType])
       			    {
						case 3: { MoveNPC(playerid, random(5)-random(7)+x, random(7)-random(7)+y, z, MOVE_TYPE_SPRINT, 0.74444); TextoBuble(playerid,"{f50000}¡¡ CEREBRO !!"); }
						case 2: { MoveNPC(playerid, random(5)-random(7)+x, random(7)-random(7)+y, z, MOVE_TYPE_SPRINT, 0.80000); TextoBuble(playerid,"{FF00FF}¡¡ HEART !!"); }
                		default: { MoveNPC(playerid, random(5)-random(7)+x, random(7)-random(7)+y, z, MOVE_TYPE_RUN,0.56444); }
        			}
					}
					else
				   {
       			    switch(NPC_INFO[playerid][BType])
       			    {
						case 3: { MoveNPC(playerid, random(5)-random(7)+x, random(7)-random(7)+y, z, MOVE_TYPE_SPRINT, 0.75444); TextoBuble(playerid,"{f50000}¡¡ CEREBRO !!"); }
						//case 2: { MoveNPC(playerid, random(5)-random(7)+x, random(7)-random(7)+y, z, MOVE_TYPE_SPRINT, 0.80000); TextoBuble(playerid,"{FF00FF}¡¡ HEART !!"); }
                		default: { MoveNPC(playerid, random(5)-random(7)+x, random(7)-random(7)+y, z, MOVE_TYPE_RUN,0.46444); }
        			}
					}
            }
/*
			if(GetPlayerSkin(playerid) == 163)
			{
			FCNPC_SetSkin(playerid,Zombie_Skins[random(sizeof(Zombie_Skins))]);
			}
*/
		}
	}
	else
	{
	    FCNPC_StopAim(playerid);
		if(NPC_INFO[playerid][LastFinded] != INVALID_PLAYER_ID||NPC_INFO[playerid][Attacking] != INVALID_PLAYER_ID)
		{
			NPC_INFO[playerid][LastFinded] = INVALID_PLAYER_ID;
		    NPC_INFO[playerid][Attacking] = INVALID_PLAYER_ID;
			//nadie por aca xD
			FCNPC_ClearAnimations(playerid);
			ClearAnimations(playerid);
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			MoveNPC(playerid, x,y,z, MOVE_TYPE_RUN,0.46444, true);
		}
	}

	//gta sounds like zombie: 44216, 44215
	//ronquidos: 19600-19604
	if(NPC_INFO[playerid][LastFinded] != INVALID_PLAYER_ID||NPC_INFO[playerid][Attacking] != INVALID_PLAYER_ID)
	{
		if((rztickcount() - ZS_Tick[playerid]) > 20 && GetTotalZombiesInPlayer(victimID) <= 20)//rugir si pasaron más de 20seg y son menos de 20 zombis
		{
		        //printf("First condition called for bot: %d, Player: %s (id %d) | ZombiesIn: %d", playerid, PlayerName2(victimID), victimID, GetTotalZombiesInPlayer(victimID));
				if(NPC_NEMESIS[playerid] == 0){
		        PlayZombieAudioForAll(playerid,randomEx(1, 10),35.0,25.0);//ultimo param es para verificar si el jugador esta en el rango del bot.
				}
				else{
				PlayZombieAudioForAll(playerid,11,50.0,30.0);
				}
				ZS_Tick[playerid] = rztickcount();
		}
		else if((rztickcount() - ZS_Tick[playerid]) > 20 && ObtenerBOTCercano(victimID) == playerid)//rugir si pasaron más de 20seg y si es el zombi mas cercano
		{
		        //printf("Second condition called for bot: %d, Player: %s (id %d) | ZombiesIn: %d", playerid, PlayerName2(victimID), victimID, GetTotalZombiesInPlayer(victimID));
				if(NPC_NEMESIS[playerid] == 0){
		        PlayZombieAudioForAll(playerid,randomEx(1, 10),35.0,25.0);//ultimo param es para verificar si el jugador esta en el rango del bot.
				}
				else{
				PlayZombieAudioForAll(playerid,11,50.0,30.0);
				}
				ZS_Tick[playerid] = rztickcount();
		}
	}
}


//forward VerificarHumanos(playerid);
//public VerificarHumanos(playerid)
public FCNPC_OnUpdate(playerid)
{
	if(GetTickDiff( GetTickCount(), NPC_INFO[playerid][SeekerTick] ) >= 280 && !IsDroneBOT(playerid) || GetTickDiff( GetTickCount(), NPC_INFO[playerid][SeekerTick] ) >= 280 && IsDroneBOT(playerid))
	{
		NPC_INFO[playerid][SeekerTick] = GetTickCount();
		if(playerid != INVALID_PLAYER_ID)
		{
			if(!FCNPC_IsDead(playerid))
			{
				if(OnDroneUpdate(playerid)) return 0;

	            new victimID = getZombieTarget(playerid);

				if(OnCoreZombieUpdate(playerid, victimID)) return 0;


				OnAmbientZombieUpdate(playerid, victimID);
			}
		}
	}
	return 1;
}




stock ShowInfectedZonesForPlayer(playerid)
{
	for(new i=0;i<MAX_INFECTED_ZONES;i++)
	{
	    if(InfectedZone[i][gangZoneId] != -1)
	    {
	        GangZoneShowForPlayer(playerid, InfectedZone[i][gangZoneId], 0xFF0000CC);
	    }
	}
}

stock ShowSafeZonesForPlayer(playerid)
{
	for(new i=0;i<MAX_SAFE_ZONES;i++)
	{
	    if(SafeZone[i][gangZoneId] != -1)
	    {
	        GangZoneShowForPlayer(playerid, SafeZone[i][gangZoneId], 0xCCFF33CC);
	    }
	}
}

stock IsInfectedZone(zoneid)
{
	for(new i=0;i<MAX_INFECTED_ZONES;i++)
	{
        if(InfectedZone[i][zoneId] == zoneid) return true;
	}
	return false;
}

stock CreateInfectedZone(slot_id, Float:minx, Float:miny, Float:maxx, Float:maxy)
{
    InfectedZone[slot_id][zoneId] = CreateDynamicRectangle(minx, miny, maxx, maxy);
    InfectedZone[slot_id][gangZoneId] = GangZoneCreate(minx, miny, maxx, maxy);
    printf("[CreateInfectedZone]: ZSlot %d has been created as a infected zone: Rectangle %d, GangZone: %d.", slot_id, InfectedZone[slot_id][zoneId], InfectedZone[slot_id][gangZoneId]);
    return 1;
}

stock IsSafeZone(zoneid)
{
	for(new i=0;i<MAX_SAFE_ZONES;i++)
	{
        if(SafeZone[i][zoneId] == zoneid) return true;
	}
	return false;
}

stock CreateSafeZone(slot_id, Float:minx, Float:miny, Float:maxx, Float:maxy)
{

    SafeZone[slot_id][zoneId] = CreateDynamicRectangle(minx, miny, maxx, maxy);
    SafeZone[slot_id][gangZoneId] = GangZoneCreate(minx, miny, maxx, maxy);
    printf("[CreateSafeZone]: SSlot %d has been created as a safe zone: Rectangle %d, GangZone: %d.", slot_id, SafeZone[slot_id][zoneId], SafeZone[slot_id][gangZoneId]);
    return 1;
}


public OnGameModeInit()
{
	HelloIdiot();
	RZM_OnGameModeInit();
	DataBase_USERS = db_open("RZS_ACCOUNTS.db");
    MapAndreas_Init(MAP_ANDREAS_MODE_MINIMAL, "scriptfiles/SAmin.hmap");
    //FCNPC_SetUpdateRate(GetServerVarAsInt("onfoot_rate")*2);
   	//ConnectedPlayers=0;


	ZombieSpawnerDistance = DEFAULT_ZOMBIE_SPAWN_DISTANCE;
	ZombieVisionDistance = DEFAULT_ZOMBIE_VISION_DISTANCE;

	if( FCNPC_InitMapAndreas( MapAndreas_GetAddress() ) )
	{
	    SendRconCommand("maxnpc 200");
	    printf("[NPC]: Zmap Iniciado exitosamente");
		for(new i = 0; i < 180; i++)
		{
			new name[24];
	  		format(name, 24, "Zombie%d", i + 1);
			new npcid = FCNPC_Create(name);
		 	SetNPCHealth(npcid, 100);
		 	PlayerInfo[npcid][DRONE_ID] = INVALID_PLAYER_ID;
		 	Generame(npcid);

		}
		for(new i = 0; i < 20; i++)
		{
			new name[24];
	  		format(name, 24, "[DRONE]K%d", i + 1);
			new npcid = FCNPC_Create(name);
		 	SetNPCHealth(npcid, 100);
		 	PlayerInfo[npcid][DRONE_ID] = INVALID_PLAYER_ID;
		 	new Random = random(sizeof(SPAWNS_DRONES));
			NPC_INFO[npcid][NPCVehicleID] = CreateVehicle(ChooseNumber(501, 465), SPAWNS_DRONES[Random][0], SPAWNS_DRONES[Random][1], SPAWNS_DRONES[Random][2], 0, 1, -1, -1);
		 	Generame(npcid);
		}

	}
	else
	{
	    printf("[NPC]: Zmap fallo! imposible iniciar");
	}
	for(new i=0;i<MAX_INFECTED_ZONES;i++)
	{
	    InfectedZone[i][zoneId] = -1;
	    InfectedZone[i][gangZoneId] = -1;
	}
	InfectedZoneMusic[Enabled] = 1;
	memcpy(InfectedZoneMusic[MP3], "http://api.inwoke.net/youtube-to-mp3/infected_zone.mp3", 0, 51 * 4, sizeof(InfectedZoneMusic[MP3]));
	IZ_Zombies = 5;
	IZ_ZombiesRespawnTime = 5 * 1000;
	IZ_HIDE_HUD = 1;
	
	ZOMBIES_SPAWN_TIME = 40 * 1000;
	ZOMBIES_SPAWN_LIMIT = 5;
	
	for(new i=0;i<MAX_SAFE_ZONES;i++)
	{
	    SafeZone[i][zoneId] = -1;
	    SafeZone[i][gangZoneId] = -1;
	}
	FCNPC_SetWeaponDefaultInfo(35, 1, 1, -1);
	//DisableInteriorEnterExits();
    SendRconCommand("password loadingx..");
 	SendRconCommand("loadfs AntiCheat");
	SendRconCommand("loadfs vision_fix");
	SendRconCommand("loadfs DS");
	RZClient_SetPack("rzclient_sounds",true,true);
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
	SetNameTagDrawDistance(25.0);
	CountDown = -1;
	#if defined USE_SOBEIT_CAMERA_DETECTION
    for(new w = 1; w < MAX_VIRTUAL_WORLDS; w++)
    {
    	WorldUsed[w] = 0;
    }
	#endif
    AmbianceThemes = false;
    SCORE_NOOB = 49;
    HideServerPlayersHUD = 0;
	//Sonidos del Juego
	/*LS_SoundTracks = 0;
	SF_SoundTracks = 1;
	LV_SoundTracks = 2;
	A51_SoundTracks = 3;
	W_SoundTracks = 4;
	Epic_SoundTracks = 5;
	*/


	XMasDomo = CreateObject(18844, 5.11791, 1531.43982, 5.24879,   -21.65999, 88.26001, -106.01997); //cerrado


    HumanCore[CoreTick] = -1;
    HumanCore[CoreExplosionTick] = -1;
    HumanCore[STATE] = CORE_FINISHED;
    HumanCore[Enabled] = 0;
    SetTimer("HC_Checker", 30000, 1);

	//vendedores y botmissions
	CreateServerActor(0, 289, -1048.5951,-672.3373,32.3516, 329.1388);//Drone Trader SF fabric
	SetActorInvulnerable(ServerActor[0][sactorid], true);
	SetServerActorType(ServerActor[0][sactorid], ACTOR_TYPE_DRONE_TRADER);
	SetServerActorSkin(ServerActor[0][sactorid], 289);//zero skin.


	CreateServerActor(0, 181, 853.8664,-2115.8381,19.9551,341.7856);//Armero Muelle LS
	SetActorInvulnerable(ServerActor[0][sactorid], true);
	SetServerActorType(ServerActor[0][sactorid], ACTOR_TYPE_GUNSMITH);
	SetServerActorSkin(ServerActor[0][sactorid], 181);

	CreateServerActor(1, 70, 856.3638,-2119.7563,20.0042,359.4094);//Científico Muelle LS
	SetActorInvulnerable(ServerActor[1][sactorid], true);
	SetServerActorType(ServerActor[1][sactorid], ACTOR_TYPE_SCIENTIFIC);
	SetServerActorSkin(ServerActor[1][sactorid], 70);

	CreateServerActor(2, 181, 1769.2365,-1361.6268,15.8903,270.3011);//Armero cerca de la pista de patinaje LS
	SetActorInvulnerable(ServerActor[2][sactorid], true);
	SetServerActorType(ServerActor[2][sactorid], ACTOR_TYPE_GUNSMITH);
	SetServerActorSkin(ServerActor[2][sactorid], 181);

	CreateServerActor(3, 70, 2557.7673, 2783.7126, 13.5202, 87.1632);//Científico refugio cerca del tren LV
	SetActorInvulnerable(ServerActor[3][sactorid], true);
	SetServerActorType(ServerActor[3][sactorid], ACTOR_TYPE_SCIENTIFIC);
	SetServerActorSkin(ServerActor[3][sactorid], 181);


	CreateServerActor(4, 181, 2558.0032, 2777.1719, 13.5202, 89.6569);//Armero refugio cerca del tren LV
	SetActorInvulnerable(ServerActor[4][sactorid], true);
	SetServerActorType(ServerActor[4][sactorid], ACTOR_TYPE_GUNSMITH);
	SetServerActorSkin(ServerActor[4][sactorid], 70);


	CreateServerActor(5, 70, 2557.8545, 2770.7224, 13.5202, 88.5772);//Científico refugio cerca del tren LV
	SetActorInvulnerable(ServerActor[5][sactorid], true);
	SetServerActorType(ServerActor[5][sactorid], ACTOR_TYPE_SCIENTIFIC);
	SetServerActorSkin(ServerActor[5][sactorid], 70);


	CreateServerActor(6, 181, -1900.1328,-1680.3478,23.0156,97.1673);//Licorero, constructura SF
	SetActorInvulnerable(ServerActor[6][sactorid], true);
	SetServerActorType(ServerActor[6][sactorid], ACTOR_TYPE_WAITER);
	SetServerActorSkin(ServerActor[6][sactorid], 181);


	CreateServerActor(7, 287, -1917.1576,-1671.3453,23.0157,263.6023);//Armero, constrcutura SF
	SetActorInvulnerable(ServerActor[7][sactorid], true);
	SetServerActorType(ServerActor[7][sactorid], ACTOR_TYPE_GUNSMITH);
	SetServerActorSkin(ServerActor[7][sactorid], 287);

	CreateServerActor(8, 70, -1919.8564,-1676.7219,23.0157,98.9038);//Cientifico, constrcutura SF
	SetActorInvulnerable(ServerActor[8][sactorid], true);
	SetServerActorType(ServerActor[8][sactorid], ACTOR_TYPE_SCIENTIFIC);
	SetServerActorSkin(ServerActor[8][sactorid], 70);


	CreateServerActor(9, 287, -1304.9237,502.5309,11.1953,110.9003); // armero_barco
	SetActorInvulnerable(ServerActor[9][sactorid], true);
	SetServerActorType(ServerActor[9][sactorid], ACTOR_TYPE_GUNSMITH);
	SetServerActorSkin(ServerActor[9][sactorid], 287);

	CreateServerActor(10, 70, -1347.6754,492.1131,18.2344,66.7386);// cientifico_barco
	SetActorInvulnerable(ServerActor[10][sactorid], true);
	SetServerActorType(ServerActor[10][sactorid], ACTOR_TYPE_SCIENTIFIC);
	SetServerActorSkin(ServerActor[10][sactorid], 70);

	CreateServerActor(11, 287, -1426.6461,490.7084,3.0391,34.6530); // armero_barco entrada
	SetActorInvulnerable(ServerActor[11][sactorid], true);
	SetServerActorType(ServerActor[11][sactorid], ACTOR_TYPE_GUNSMITH);
	SetServerActorSkin(ServerActor[11][sactorid], 287);

	CreateServerActor(12, 70, -1427.0601,505.0945,3.0391,137.9286);// cientifico_barco entrada
	SetActorInvulnerable(ServerActor[12][sactorid], true);
	SetServerActorType(ServerActor[12][sactorid], ACTOR_TYPE_SCIENTIFIC);
	SetServerActorSkin(ServerActor[12][sactorid], 70);

	CreateServerActor(13, 285, 1094.4773,-1469.5031,15.7862,162.5084);// armero del centro comercial de LS
	SetActorInvulnerable(ServerActor[13][sactorid], true);
	SetServerActorType(ServerActor[13][sactorid], ACTOR_TYPE_GUNSMITH);
	SetServerActorSkin(ServerActor[13][sactorid], 285);

	CreateServerActor(14, 70, 1094.8215,-1433.6356,15.8018,216.2398);// cientifico de la enfermeria centro comercial LS
	SetActorInvulnerable(ServerActor[14][sactorid], true);
	SetServerActorType(ServerActor[14][sactorid], ACTOR_TYPE_SCIENTIFIC);
	SetServerActorSkin(ServerActor[14][sactorid], 70);

	CreateServerActor(15, 167, 1165.0421,-1476.8185,15.7964,101.4819);// BOT del comedor del centro comercial de LS
	SetActorInvulnerable(ServerActor[15][sactorid], true);
	SetServerActorType(ServerActor[15][sactorid], ACTOR_TYPE_WAITER);
	SetServerActorSkin(ServerActor[15][sactorid], 167);


	CreateServerActor(16, 70, 2719.5410,-1068.6626,69.2656,82.8737);// Cientifico mini refugio LS
	SetActorInvulnerable(ServerActor[16][sactorid], true);
	SetServerActorType(ServerActor[16][sactorid], ACTOR_TYPE_SCIENTIFIC);
	SetServerActorSkin(ServerActor[16][sactorid], 70);

	CreateServerActor(17, 287, 2718.4316,-1062.5249,69.4375,101.2560);// Armero mini refugio LS
	SetActorInvulnerable(ServerActor[17][sactorid], true);
	SetServerActorType(ServerActor[17][sactorid], ACTOR_TYPE_GUNSMITH);
	SetServerActorSkin(ServerActor[17][sactorid], 287);



	/*
	apoyado en una mesa, y viendo
	ApplyAnimationEx(playerid,"CASINO","Roulette_loop",fifa[playerid],O1[playerid],O2[playerid],O3[playerid],O4[playerid],O5[playerid]);

	moviendo algo en la mesa
	ApplyAnimationEx(playerid,"CASINO","cards_raise",fifa[playerid],O1[playerid],O2[playerid],O3[playerid],O4[playerid],O5[playerid]);

	escribiendo
	ApplyAnimationEx(playerid,"CASINO","Slot_wait",fifa[playerid],O1[playerid],O2[playerid],O3[playerid],O4[playerid],O5[playerid]);
	*/

	new queryx[256];
	format(queryx,sizeof(queryx),"CREATE TABLE IF NOT EXISTS `vehiculos` (id INTEGER PRIMARY KEY, name, modelid, carx, cary, carz, caranlge, health)");
	db_query(DataBase_USERS,queryx);
	format(queryx,sizeof(queryx),"CREATE TABLE IF NOT EXISTS `DroppedWeapons` (id INTEGER PRIMARY KEY, x, y, z, d1, d2, taken, server_default)");
	db_query(DataBase_USERS,queryx);
	format(queryx,sizeof(queryx),"CREATE TABLE IF NOT EXISTS `RZ_BLACKLIST` (Username varchar(70) PRIMARY KEY, rz_locked INTEGER NOT NULL DEFAULT '0', admin NOT NULL DEFAULT '?', razon NOT NULL DEFAULT '?', ip NOT NULL DEFAULT '?', fecha NOT NULL DEFAULT '?')");
	db_query(DataBase_USERS,queryx);
	LoadSQLCars();

	ACTUAL_DROPPED_WEAPONS = 0;
	LoadSQLDroppedWeapons();
    #if defined SistemaDECombustible
	/* SISTEMA DE GASOLINA XD */
	TimerVelocidad = SetTimer("Actualizar", 250, true);
	for(new i=0;i<MAX_VEHICLES;i++)
 	{
        Gas[i] = 10;
    }
    GasBajo = SetTimer("GasolinaBaja", 12000 ,1);
    #endif
	//-------
	SinCHAT = 0;
	SetWorldTime(0);
	SetWeather(4);
	Clima = 7;
	Hora = 19;
	IZ_Hour = 0;
	IZ_Weather = 264;
    EnableStuntBonusForAll(0);
	SetGameModeText("Zombie NPC Survival");
	SetTimer("checkBackupServer",MINS_FOR_BACKUP*1000*60,0); // hacer backup cada 25 minutos
	//AutomaticHourChanger();
	//SetTimer("SonidoFondo",20000,1);
	KillTimer(Timer_Anuncios);
	Timer_Anuncios = SetTimer("Anuncios",180000,1);
	//Timer_Transmi = SetTimer("Transmi",480000,1);//8 min xd
   	SendRconCommand("mapname Español - Zombie");
   	SendRconCommand("language Spanish - English");

	CreateInfectedZone(0, 2197, -155, 2581, 215);
	CreateInfectedZone(1, -336, -438, 412, 223);
	CreateInfectedZone(2, -2373.999984741211, -2579, -1982.999984741211, -2215);
	CreateInfectedZone(3, -2733, 2150.999954223633, -2155, 2584.999954223633);
	CreateInfectedZone(4, 1830, 590, 2504, 904);
	CreateInfectedZone(5, 1102, 172, 1555, 520);
	CreateInfectedZone(6, 2351, -2720, 2941, -2289);



	CreateSafeZone(0, 1072.265625,-1556.640625,1171.875,-1431.640625);
	CreateSafeZone(1, -1930.0000457763672,-1708.0000915527344,-1799.0000457763672,-1592.0000915527344);//Montaña Gigante
	CreateSafeZone(2, 2493.9998168945312, 2706, 2600.9998168945312, 2806);//ARMERO LV
	CreateSafeZone(3, 2667.999755859375, -1090, 2761.999755859375, -1058);//Mini Refugio LS
	CreateSafeZone(4, -1084.0000610351562, -726.9999084472656, -984.0000610351562, -626.9999084472656);//Bandera Drone Sells

 	for (new playerid=0; playerid < GetMaxPlayers(); playerid++) {
			SetPVarInt(playerid, "laser", 0);
		 	SetPVarInt(playerid, "color", 18643);
	}
    //logo minimapa
	MiniLogoM = TextDrawCreate(506.000000, 8.000000, "play.revolucion-zombie.com:7778");
	TextDrawAlignment(MiniLogoM, 2);
	TextDrawBackgroundColor(MiniLogoM, 255);
	TextDrawFont(MiniLogoM, 2);
	TextDrawLetterSize(MiniLogoM, 0.270000, 1.100000);
	TextDrawColor(MiniLogoM, -1);
	TextDrawSetOutline(MiniLogoM, 1);
	TextDrawSetProportional(MiniLogoM, 1);
	TextDrawUseBox(MiniLogoM, 1);
	TextDrawBoxColor(MiniLogoM, 60);
	TextDrawTextSize(MiniLogoM, 497.000000, 240.000000);
	TextDrawSetSelectable(MiniLogoM, 0);

	//==========================================================================
	UsePlayerPedAnims();
    AddPlayerClass(203,454.7712,-2657.5151,90.8490,0,-1,-1,-1,-1,-1,-1);//omykara daryl
    AddPlayerClass(202,454.7712,-2657.5151,90.8490,0,-1,-1,-1,-1,-1,-1);//dwmylc2 merler
    AddPlayerClass(189,454.7712,-2657.5151,90.8490,0,-1,-1,-1,-1,-1,-1);//wmyva gleen
    AddPlayerClass(162,454.7712,-2657.5151,90.8490,0,-1,-1,-1,-1,-1,-1);//zombie
	AddPlayerClass(274,454.7712,-2657.5151,90.8490,0,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(285,454.7712,-2657.5151,90.8490,0,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(3,454.7712,-2657.5151,90.8490,0,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(287,454.7712,-2657.5151,90.8490,0,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(294,454.7712,-2657.5151,90.8490,0,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(6,454.7712,-2657.5151,90.8490,0,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(23,454.7712,-2657.5151,90.8490,0,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(11,454.7712,-2657.5151,90.8490,0,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(12,454.7712,-2657.5151,90.8490,0,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(2,454.7712,-2657.5151,90.8490,0,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(22,454.7712,-2657.5151,90.8490,0,-1,-1,-1,-1,-1,-1);
    AddPlayerClass(188,454.7712,-2657.5151,90.8490,0,-1,-1,-1,-1,-1,-1);//swmyst lee
    AddPlayerClass(198,454.7712,-2657.5151,90.8490,0,-1,-1,-1,-1,-1,-1);//cwfyfr1 ada version 1
	for(new i = 0; i < 311; i++)
	{
		if(IsValidSkin(i) && !IsZombieSkin(i))
		{
			AddPlayerClass(i, 454.7712, -2657.5151 ,90.8490, 0,-1,-1,-1,-1,-1,-1);
		}
	}
	ConectarDB();

	//AMMUNATIONS CLOSED
	CreateObject(3095, 288.15054, -108.70542, 1000.51349,   89.76004, 265.67972, 93.72002);
	CreateObject(3095, 292.09192, -82.65610, 1000.43060,   0.17998, 90.59991, 0.06000);
	CreateObject(3095, 292.19571, -73.73923, 1000.42944,   0.23998, 89.75991, 0.90000);
	CreateObject(3095, 292.46677, -37.51945, 1000.51349,   1.26000, 94.56003, 2.52000);
	CreateObject(3095, 296.79517, -33.37483, 1000.95215,   -0.60000, 90.96008, -94.61995);
	CreateObject(3095, 315.59531, -167.90511, 999.62885,   -0.83999, -90.06000, -0.96000);
	CreateObject(3095, 310.66302, -163.40306, 999.54517,   -0.83999, -90.06000, 90.35999);
	CreateObject(3095, 315.44421, -138.08435, 998.45178,   88.68006, 86.99998, 51.41999);
	CreateObject(3095, 315.33569, -131.01898, 1002.86609,   88.68006, 86.99998, -40.97999);
	CreateObject(3095, 312.19870, -139.41028, 1007.26837,   -0.72001, 90.78006, 0.00000);
	CreateObject(3095, 295.54919, -112.19421, 1000.58203,   89.76004, 265.67972, 44.88004);
	//END AMMUNATIONS CLOSED

	CreateDynamicObject(3383, -1919.89856, -1683.90515, 22.01483,   0.00000, 0.00000, -88.32005);
	CreateDynamicObject(3389, -1920.27283, -1681.05542, 21.91300,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3389, -1920.28894, -1680.03125, 21.91300,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3389, -1920.25818, -1679.00879, 21.91300,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3392, -1920.99353, -1676.43091, 22.01451,   0.00000, 0.00000, -179.58000);
	CreateDynamicObject(16782, -1921.21130, -1670.79163, 28.17145,   0.00000, 0.00000, 1.20000);
	CreateDynamicObject(16151, -1900.13098, -1681.18372, 22.34308,   0.00000, 0.00000, 1.02000);
	CreateDynamicObject(16780, -1908.23535, -1671.07288, 33.62200,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(16780, -1902.18323, -1671.07288, 33.62200,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(16780, -1914.42969, -1671.07288, 33.62200,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18876, -1910.96899, -1671.00842, 21.82340,   0.00000, 0.00000, 35.00000);
	CreateDynamicObject(3383, -1920.78455, -1671.24561, 21.87534,   0.00000, 0.00000, -90.24003);
	CreateDynamicObject(2976, -1920.70605, -1672.52478, 22.92931,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2976, -1920.66956, -1671.97034, 22.92931,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2976, -1920.67175, -1671.42358, 22.92931,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2976, -1920.63306, -1670.88318, 22.92931,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2976, -1920.59534, -1670.40247, 22.92931,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2976, -1920.61731, -1669.92212, 22.92931,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3389, -1921.20264, -1668.52869, 22.01465,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3389, -1921.21704, -1667.32605, 22.01465,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3389, -1921.21497, -1666.18140, 22.01465,   0.00000, 0.00000, -0.30000);
	CreateDynamicObject(3396, -1921.13892, -1663.45642, 21.92580,   0.00000, 0.00000, -177.17993);
	CreateDynamicObject(3392, -1921.05042, -1659.58167, 22.01534,   0.00000, 0.00000, -180.53992);
	CreateDynamicObject(1671, -1920.24182, -1663.29810, 22.43495,   0.00000, 0.00000, -100.44000);
	CreateDynamicObject(2976, -1921.24390, -1659.76135, 22.91076,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2976, -1921.08948, -1676.66016, 22.96284,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2908, -1919.81506, -1685.10352, 23.10863,   0.00000, 0.00000, -49.68000);
	CreateDynamicObject(2908, -1921.10583, -1684.46387, 23.10863,   0.00000, 0.00000, -18.59999);
	CreateDynamicObject(2908, -1919.86487, -1684.75903, 23.10863,   0.00000, 0.00000, -197.39996);
	CreateDynamicObject(2921, -1898.11694, -1666.49512, 25.86727,   0.00000, 0.00000, -175.07996);
	CreateDynamicObject(2921, -1875.61182, -1706.15161, 28.80839,   0.00000, 0.00000, -19.44003);
	CreateDynamicObject(2921, -1916.36169, -1683.42053, 36.03527,   0.00000, 0.00000, 167.34007);
	CreateDynamicObject(2907, -1920.06421, -1683.81079, 23.06964,   0.00000, 0.00000, -48.83999);
	CreateDynamicObject(2907, -1921.27771, -1682.57874, 23.06964,   0.00000, 0.00000, 4.14002);
	CreateDynamicObject(2907, -1919.79333, -1682.54382, 23.06964,   0.00000, 0.00000, 60.42002);
	CreateDynamicObject(943, -1899.97485, -1658.22266, 22.73900,   0.00000, 0.00000, 178.86000);
	CreateDynamicObject(943, -1901.22339, -1658.22266, 22.73900,   0.00000, 0.00000, 178.86000);
	CreateDynamicObject(943, -1902.42883, -1658.22266, 22.73900,   0.00000, 0.00000, 178.86000);
	CreateDynamicObject(1812, -1904.65015, -1683.00525, 22.01498,   0.00000, 0.00000, -178.67999);
	CreateDynamicObject(1812, -1906.30627, -1683.13293, 22.01498,   0.00000, 0.00000, -178.67999);
	CreateDynamicObject(1812, -1908.11316, -1683.20349, 22.01498,   0.00000, 0.00000, -178.67999);
	//CreateDynamicObject(18251, -1907.63696, -1666.68237, 29.85160,   0.00000, 0.00000, 3.14160);
	CreateDynamicObject(14532, -1911.25037, -1684.58508, 22.92132,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19165, -1899.46643, -1661.38843, 23.94510,   90.00000, 0.00000, -87.00000);
	CreateDynamicObject(1685, -1905.14319, -1658.30835, 22.75817,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1685, -1907.06311, -1658.34216, 22.75817,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1685, -1908.96704, -1658.38733, 22.75817,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(12957, -1884.25403, -1726.66064, 21.37254,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3168, -1901.83679, -1704.45728, 20.74110,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(3168, -1908.48682, -1719.77771, 20.74110,   0.00000, 0.00000, 207.00000);
	CreateDynamicObject(2605, -1899.95850, -1660.95447, 22.41444,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(3673, -1790.95996, -1644.39258, 5.98945,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(874, -1890.24585, -1644.30762, 20.57310,   0.00000, 0.00000, 40.00000);
	CreateDynamicObject(1997, -1911.03223, -1659.06995, 22.01170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1997, -1912.85107, -1659.23572, 22.01170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1997, -1914.73315, -1659.20190, 22.01170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2604, -1899.58057, -1664.16956, 22.82440,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1715, -1901.08655, -1660.48425, 22.01430,   0.00000, 0.00000, 40.00000);
	CreateDynamicObject(16327, -1861.16663, -1728.19568, 20.73460,   0.00000, 0.00000, 123.00000);
	CreateDynamicObject(16327, -1892.91199, -1748.44763, 20.73460,   0.00000, 0.00000, 121.00000);
	CreateDynamicObject(964, -1914.25769, -1685.05933, 22.01320,   0.00000, 0.00000, 179.00000);
	CreateDynamicObject(964, -1915.72888, -1685.07397, 22.01320,   0.00000, 0.00000, 179.00000);
	CreateDynamicObject(1550, -1912.87317, -1685.75659, 22.36587,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1550, -1913.35315, -1685.78223, 22.36587,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1550, -1912.34570, -1685.74792, 22.36587,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18848, -1908.96680, -1647.75000, 25.95730,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18848, -1918.37561, -1681.82312, 39.07110,   0.00000, 0.00000, -113.00000);
	CreateDynamicObject(1232, -1889.54126, -1652.25525, 20.99683,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1232, -1887.80103, -1688.08069, 20.99683,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1232, -1856.94409, -1617.55127, 23.48018,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1232, -1816.84644, -1617.20313, 24.60927,   0.00000, 0.00000, 0.00000);

	CreateServerPickup(0, 5, 1276,3,-703.611450, -1316.904296, 63.439239, 0);
	CreateServerPickup(1, 1, 1252,3,-703.224670, -1323.761962, 63.259212, 0);
	CreateServerPickup(2, 4, 1313,3,-699.315490, -1357.844726, 61.171539, 0);
	CreateServerPickup(3, 3, 1275,3,429.772766, -1363.420288, 14.799819, 0);
	CreateServerPickup(4, 7, 1247,3,-558.281311, -1483.094482, 9.366933, 0);
	CreateServerPickup(5, 3, 1275,3,342.444488, -1329.771606, 17.958049, 0);
	CreateServerPickup(6, 0, 1241,3,460.770355, -1274.168457, 15.035823, 0);
	CreateServerPickup(7, 5, 1276,3,-304.033233, -1861.535766, -0.671999, 0);
	CreateServerPickup(8, 0, 1241,3,-281.997924, -1871.429443, -3.438655, 0);
	CreateServerPickup(9, 8, 1582,3,749.561889, -1084.455444, 22.397192, 0);
	CreateServerPickup(10, 3, 1275,3,888.515136, -1301.254272, 13.379809, 0);
	CreateServerPickup(11, 6, 1279,3,-418.244903, -1838.069335, 3.948779, 0);
	CreateServerPickup(12, 0, 1241,3,-646.766418, -1281.994018, 20.010141, 0);
	CreateServerPickup(13, 5, 1276,3,-615.371704, -1247.170166, 20.853847, 0);
	CreateServerPickup(14, 3, 1275,3,-611.082336, -1234.882324, 20.862260, 0);
	CreateServerPickup(15, 7, 1247,3,-593.367736, -1042.169921, 23.083869, 0);
	CreateServerPickup(16, 2, 1254,3,-600.087097, -1056.150390, 23.173110, 0);
	CreateServerPickup(17, 3, 1275,3,997.886230, -1246.265014, 19.407777, 0);
	CreateServerPickup(18, 0, 1241,3,-341.097778, -770.496093, 30.979341, 0);
	CreateServerPickup(19, 3, 1275,3,1161.866455, -1425.937133, 22.781475, 0);
	CreateServerPickup(20, 4, 1313,3,-520.022338, -920.731872, 60.480663, 0);
	CreateServerPickup(21, 3, 1275,3,-1124.392456, -876.750854, 72.412521, 0);
	CreateServerPickup(22, 8, 1582,3,1063.294189, -1492.969116, 22.775302, 0);
	CreateServerPickup(23, 6, 1279,3,-1123.176879, -617.560852, 31.788099, 0);
	CreateServerPickup(24, 4, 1313,3,-1089.495239, -674.625488, 32.117774, 0);
	CreateServerPickup(25, 7, 1247,3,-1000.320190, -600.199523, 31.789049, 0);
	CreateServerPickup(26, 1, 1252,3,-572.880920, -391.824981, 21.327568, 0);
	CreateServerPickup(27, 2, 1254,3,-359.811523, -594.523742, 5.329930, 0);
	CreateServerPickup(28, 4, 1313,3,-358.212097, -590.764648, 5.325117, 0);
	CreateServerPickup(29, 0, 1241,3,-530.128417, -737.506835, 27.775711, 0);
	CreateServerPickup(30, 3, 1275,3,-749.005676, -888.468994, 110.028160, 0);
	CreateServerPickup(31, 8, 1582,3,-1116.800537, -1621.400634, 76.154304, 0);
	CreateServerPickup(32, 3, 1275,3,2619.545654, -1077.350585, 69.604423, 0);
	CreateServerPickup(33, 0, 1241,3,-1116.343261, -1618.601440, 76.155464, 0);
	CreateServerPickup(34, 3, 1275,3,-1116.832763, -1624.719116, 76.155212, 0);
	CreateServerPickup(35, 8, 1582,3,2721.721191, -1070.577636, 69.265625, 0);
	CreateServerPickup(36, 7, 1247,3,-1112.056884, -1674.532592, 76.367187, 0);
	CreateServerPickup(37, 1, 1252,3,-1083.284912, -1903.742553, 76.456954, 0);
	CreateServerPickup(38, 0, 1241,3,-1294.096557, -1875.607055, -3.426467, 0);
	CreateServerPickup(39, 0, 1241,3,-1328.606567, -2013.467529, 9.932011, 0);
	CreateServerPickup(40, 1, 1252,3,-1327.413940, -2016.790283, 11.129768, 0);
	CreateServerPickup(41, 2, 1254,3,-1325.841064, -2021.172729, 12.709439, 0);
	CreateServerPickup(42, 3, 1275,3,-1324.514648, -2024.895507, 14.049713, 0);
	CreateServerPickup(43, 5, 1276,3,-1329.454467, -2010.553344, 8.915033, 0);
	CreateServerPickup(44, 6, 1279,3,-1330.591186, -2007.742797, 7.880381, 0);
	CreateServerPickup(45, 7, 1247,3,-1331.936401, -2004.375000, 6.643385, 0);
	CreateServerPickup(46, 8, 1582,3,-1333.292724, -2000.977172, 5.395493, 0);
	CreateServerPickup(47, 3, 1275,3,2753.049316, -1281.131103, 56.586399, 0);
	CreateServerPickup(48, 2, 1254,3,2753.065429, -1324.350463, 50.122352, 0);
	CreateServerPickup(49, 0, 1241,3,-1334.419677, -1997.136352, -0.201601, 0);
	CreateServerPickup(50, 8, 1582,3,2690.067382, -1393.353881, 31.875305, 0);
	CreateServerPickup(51, 0, 1241,3,-1211.528320, -2345.661865, 17.204498, 0);
	CreateServerPickup(52, 2, 1254,3,2543.241699, -1434.774902, 24.000568, 0);
	CreateServerPickup(53, 4, 1313,3,-960.422241, -2348.364746, 62.443702, 0);
	CreateServerPickup(54, 5, 1276,3,-787.488464, -2494.088378, 80.125900, 0);
	CreateServerPickup(55, 3, 1275,3,2463.666503, -1542.671630, 24.343750, 0);
	CreateServerPickup(56, 0, 1241,3,-625.528564, -2680.497558, 114.895805, 0);
	CreateServerPickup(57, 3, 1275,3,-456.513549, -2592.513671, 138.261444, 0);
	CreateServerPickup(58, 7, 1247,3,-376.531433, -2483.952148, 104.904220, 0);
	CreateServerPickup(59, 8, 1582,3,-334.941345, -2363.527587, 82.982246, 0);
	CreateServerPickup(60, 1, 1252,3,-245.461761, -2308.510742, 29.613155, 0);
	CreateServerPickup(61, 2, 1254,3,-273.206359, -2187.297119, 28.566078, 0);
	CreateServerPickup(62, 0, 1241,3,-176.390121, -1507.998535, 13.549602, 0);
	CreateServerPickup(63, 4, 1313,3,697.540588, -1186.957641, 15.360057, 0);
	CreateServerPickup(64, 8, 1582,3,2384.062500, -1548.399536, 24.164062, 0);
	CreateServerPickup(65, 5, 1276,3,760.989257, -1139.629272, 21.410266, 0);
	CreateServerPickup(66, 3, 1275,3,2405.747070, -1469.489624, 24.000000, 0);
	CreateServerPickup(67, 7, 1247,3,705.498779, -704.802917, 18.144037, 0);
	CreateServerPickup(68, 1, 1252,3,611.100402, -606.757751, 17.008214, 0);
	CreateServerPickup(69, 6, 1279,3,611.594482, -602.805664, 17.006404, 0);
	CreateServerPickup(70, 2, 1254,3,2415.824951, -1416.982666, 24.019760, 0);
	CreateServerPickup(71, 0, 1241,3,690.273193, -448.345855, 16.343704, 0);
	CreateServerPickup(72, 0, 1241,3,2478.196533, -1333.395874, 27.663093, 0);
	CreateServerPickup(73, 3, 1275,3,247.610504, -449.138854, 11.296613, 0);
	CreateServerPickup(74, 5, 1276,3,123.578376, -494.637268, 23.717960, 0);
	CreateServerPickup(75, 8, 1582,3,2394.985595, -1206.731811, 27.581340, 0);
	CreateServerPickup(76, 1, 1252,3,-14.245292, -228.670883, 5.208580, 0);
	CreateServerPickup(77, 8, 1582,3,-57.073741, -231.780868, 5.209620, 0);
	CreateServerPickup(78, 8, 1582,3,2399.513427, -1569.512207, 24.000000, 0);
	CreateServerPickup(79, 0, 1241,3,-244.527069, 140.781417, 1.754087, 0);
	CreateServerPickup(80, 3, 1275,3,2073.373291, -1513.635864, 2.797077, 0);
	CreateServerPickup(81, 0, 1241,3,-110.330230, 584.143920, 2.823808, 0);
	CreateServerPickup(82, 8, 1582,3,110.979408, 1067.618408, 13.392449, 0);
	CreateServerPickup(83, 1, 1252,3,108.480705, 1113.381835, 13.390543, 0);
	CreateServerPickup(84, 6, 1279,3,175.317810, 1189.421020, 14.538516, 0);
	CreateServerPickup(85, 4, 1313,3,315.526397, 1153.973022, 8.366583, 0);
	CreateServerPickup(86, 0, 1241,3,405.341278, 1167.740356, 7.911077, 0);
	CreateServerPickup(87, 7, 1247,3,419.152526, 1167.621093, 7.882123, 0);
	CreateServerPickup(88, 6, 1279,3,418.777099, 1160.724609, 7.893145, 0);
	CreateServerPickup(89, 2, 1254,3,405.700225, 1161.024780, 7.910524, 0);
	CreateServerPickup(90, 6, 1279,3,586.813415, 1226.098754, 11.501545, 0);
	CreateServerPickup(91, 5, 1276,3,661.835937, 1437.960205, 10.122128, 0);
	CreateServerPickup(92, 0, 1241,3,678.513244, 1608.673461, 4.730916, 0);
	CreateServerPickup(93, 5, 1276,3,681.896301, 1972.143798, 5.539062, 0);
	CreateServerPickup(94, 5, 1276,3,1818.678833, -1547.449340, 13.227606, 0);
	CreateServerPickup(95, 7, 1247,3,726.331298, 1958.421264, 5.539062, 0);
	CreateServerPickup(96, 3, 1275,3,1771.773071, -1593.747314, 13.414463, 0);
	CreateServerPickup(97, 4, 1313,3,727.474792, 1995.507690, 4.929687, 0);
	CreateServerPickup(98, 3, 1275,3,1691.541259, -1673.461425, 20.906991, 0);
	CreateServerPickup(99, 8, 1582,3,680.477722, 1995.270751, 4.937500, 0);
	CreateServerPickup(100, 8, 1582,3,681.045104, 1976.472412, 4.937500, 0);
	CreateServerPickup(101, 8, 1582,3,687.565429, 1986.585693, 4.937500, 0);
	CreateServerPickup(102, 1, 1252,3,710.855651, 1984.839599, 3.447833, 0);
	CreateServerPickup(103, 8, 1582,3,754.257202, 1972.166503, 5.699619, 0);
	CreateServerPickup(104, 8, 1582,3,824.901123, 1943.306030, 7.104324, 0);
	CreateServerPickup(105, 8, 1582,3,1646.654296, -1706.175537, 15.609375, 0);
	CreateServerPickup(106, 1, 1252,3,883.327087, 2013.059570, 10.820312, 0);
	CreateServerPickup(107, 0, 1241,3,1618.929077, -1730.718872, 3.917743, 0);
	CreateServerPickup(108, 8, 1582,3,955.047790, 1925.659057, 10.599990, 0);
	CreateServerPickup(109, 8, 1582,3,1079.655395, 1822.777709, 10.599677, 0);
	CreateServerPickup(110, 2, 1254,3,1553.521240, -1759.082763, 14.046875, 0);
	CreateServerPickup(111, 0, 1241,3,1157.835571, 1500.161987, 5.599748, 0);
	CreateServerPickup(112, 8, 1582,3,1547.800048, -1610.607666, 13.382812, 0);
	CreateServerPickup(113, 1, 1252,3,1119.035278, 1603.111816, 5.600988, 0);
	CreateServerPickup(114, 2, 1254,3,1047.109008, 1568.875610, 5.606620, 0);
	CreateServerPickup(115, 4, 1313,3,1047.407104, 1486.514038, 5.601066, 0);
	CreateServerPickup(116, 3, 1275,3,999.955871, 1349.103149, 10.600508, 0);
	CreateServerPickup(117, 3, 1275,3,1568.641479, -1693.536132, 5.890625, 0);
	CreateServerPickup(118, 3, 1275,3,1087.786743, 1075.898803, 10.838157, 0);
	CreateServerPickup(119, 8, 1582,3,1140.804565, 976.570861, 10.607941, 0);
	CreateServerPickup(120, 8, 1582,3,1098.412597, 818.743774, 11.815884, 0);
	CreateServerPickup(121, 1, 1252,3,1094.144287, 816.265319, 14.022789, 0);
	CreateServerPickup(122, 5, 1276,3,1553.191650, -1710.363891, 38.283325, 0);
	CreateServerPickup(123, 6, 1279,3,494.634613, 712.767272, 4.083716, 0);
	CreateServerPickup(124, 5, 1276,3,345.302795, 865.189025, 20.186130, 0);
	CreateServerPickup(125, 6, 1279,3,1340.180664, -1801.521362, 13.146382, 0);
	CreateServerPickup(126, 0, 1241,3,381.014038, 806.179809, 14.365073, 0);
	CreateServerPickup(127, 2, 1254,3,615.614990, 753.103393, -14.091122, 0);
	CreateServerPickup(128, 7, 1247,3,752.942626, 812.276245, -7.618910, 0);
	CreateServerPickup(129, 4, 1313,3,1247.657714, -1619.211303, 91.442481, 0);
	CreateServerPickup(130, 0, 1241,3,627.170837, 785.318725, -31.595911, 0);
	CreateServerPickup(131, 8, 1582,3,1295.654418, -1869.958251, 17.739065, 0);
	CreateServerPickup(132, 4, 1313,3,613.916076, 855.614624, -43.186172, 0);
	CreateServerPickup(133, 6, 1279,3,637.494079, 933.141418, -38.664585, 0);
	CreateServerPickup(134, 8, 1582,3,533.096191, 904.683837, -43.175365, 0);
	CreateServerPickup(135, 3, 1275,3,957.237915, -1746.222656, 13.155691, 0);
	CreateServerPickup(136, 0, 1241,3,854.729309, -1631.967773, 13.163604, 0);
	CreateServerPickup(137, 0, 1241,3,1068.421142, 1366.169189, 10.554711, 0);
	CreateServerPickup(138, 0, 1241,3,852.258911, -2109.339111, 19.029365, 0);
	CreateServerPickup(139, 5, 1276,3,1072.632202, 1233.323242, 10.608499, 0);
	CreateServerPickup(140, 7, 1247,3,823.499206, -2113.234619, 20.595026, 0);
	CreateServerPickup(141, 3, 1275,3,972.585693, -2037.257568, 1.659501, 0);
	CreateServerPickup(142, 8, 1582,3,1411.694946, 1902.126342, 11.241716, 0);
	CreateServerPickup(143, 8, 1582,3,1406.990356, 1918.213623, 11.248162, 0);
	CreateServerPickup(144, 0, 1241,3,1419.788085, 1949.594848, 11.234580, 0);
	CreateServerPickup(145, 1, 1252,3,1477.815551, 2009.786621, 10.590296, 0);
	CreateServerPickup(146, 5, 1276,3,989.075683, -2154.356445, 21.447919, 0);
	CreateServerPickup(147, 8, 1582,3,1721.282470, 2059.543212, 10.569428, 0);
	CreateServerPickup(148, 8, 1582,3,1923.396362, 2030.901611, 10.501419, 0);
	CreateServerPickup(149, 8, 1582,3,2159.951660, 2085.168212, 10.599651, 0);
	CreateServerPickup(150, 8, 1582,3,1286.869262, -2482.472167, 10.674960, 0);
	CreateServerPickup(151, 5, 1276,3,2212.154296, 2143.002197, 10.712565, 0);
	CreateServerPickup(152, 4, 1313,3,2330.591308, 2161.267578, 10.604177, 0);
	CreateServerPickup(153, 3, 1275,3,2614.830322, 2094.666259, 10.599873, 0);
	CreateServerPickup(154, 2, 1254,3,1418.071899, -2450.192626, 5.813843, 0);
	CreateServerPickup(155, 6, 1279,3,1445.760742, -2293.892822, -3.216318, 0);
	CreateServerPickup(156, 7, 1247,3,2927.727294, 2098.850830, 17.895481, 0);
	CreateServerPickup(157, 2, 1254,3,2919.928222, 2308.787841, 10.816401, 0);
	CreateServerPickup(158, 4, 1313,3,1502.633666, -2294.056396, -2.820312, 0);
	CreateServerPickup(159, 8, 1582,3,2914.680908, 2470.468505, 10.601199, 0);
	CreateServerPickup(160, 1, 1252,3,2881.824951, 2523.449218, 10.599289, 0);
	CreateServerPickup(161, 0, 1241,3,1684.819458, -2334.270996, -3.064520, 0);
	CreateServerPickup(162, 1, 1252,3,1804.240966, -2281.129882, -2.912264, 0);
	CreateServerPickup(163, 8, 1582,3,2760.199951, 2528.171875, 10.600929, 0);
	CreateServerPickup(164, 0, 1241,3,2813.492675, 2617.430908, 10.599588, 0);
	CreateServerPickup(165, 8, 1582,3,2859.253906, 2569.677978, 10.602213, 0);
	CreateServerPickup(166, 7, 1247,3,2863.170410, 2571.016113, 10.600536, 0);
	CreateServerPickup(167, 6, 1279,3,2867.958984, 2569.764648, 10.602233, 0);
	CreateServerPickup(168, 2, 1254,3,2874.216796, 2570.576660, 10.600668, 0);
	CreateServerPickup(169, 7, 1247,3,2702.860107, 2878.049804, 10.537169, 0);
	CreateServerPickup(170, 4, 1313,3,2436.871582, 2856.741943, 10.276267, 0);
	CreateServerPickup(171, 1, 1252,3,2245.070800, 2963.397705, 32.685585, 0);
	CreateServerPickup(172, 5, 1276,3,2167.958984, 2962.187011, 24.387845, 0);
	CreateServerPickup(173, 6, 1279,3,1729.757324, -2369.246093, 13.154253, 0);
	CreateServerPickup(174, 1, 1252,3,1930.771118, 2947.942626, 30.124551, 0);
	CreateServerPickup(175, 5, 1276,3,1780.921264, -2227.613037, 13.219488, 0);
	CreateServerPickup(176, 4, 1313,3,1907.170043, 2772.769775, 10.454083, 0);
	CreateServerPickup(177, 5, 1276,3,1812.044677, -2129.875244, 13.155184, 0);
	CreateServerPickup(178, 8, 1582,3,1484.986816, 2713.383789, 10.456581, 0);
	CreateServerPickup(179, 7, 1247,3,1345.894897, 2686.535156, 10.599722, 0);
	CreateServerPickup(180, 4, 1313,3,1908.243896, -2019.158081, 13.546875, 0);
	CreateServerPickup(181, 8, 1582,3,1854.982788, -1980.538208, 13.147635, 0);
	CreateServerPickup(182, 1, 1252,3,1433.204345, 2620.437255, 11.392614, 0);
	CreateServerPickup(183, 5, 1276,3,1433.576171, 2646.697509, 11.392612, 0);
	CreateServerPickup(184, 7, 1247,3,1874.812133, -1957.316650, 20.070312, 0);
	CreateServerPickup(185, 8, 1582,3,1234.212402, 2593.174072, 10.600458, 0);
	CreateServerPickup(186, 8, 1582,3,1276.534179, 2563.568603, 10.603542, 0);
	CreateServerPickup(187, 7, 1247,3,1310.564331, 2523.968017, 10.601231, 0);
	CreateServerPickup(188, 6, 1279,3,1818.642822, 2494.830810, 6.590858, 0);
	CreateServerPickup(189, 3, 1275,3,2026.878295, 2555.819580, 6.554542, 0);
	CreateServerPickup(190, 3, 1275,3,2314.720458, -1413.495239, 24.992187, 0);
	CreateServerPickup(191, 5, 1276,3,2374.117675, -1477.400756, 23.912418, 0);
	CreateServerPickup(192, 8, 1582,3,2398.730957, 2159.510253, 10.601631, 0);
	CreateServerPickup(193, 8, 1582,3,2320.410644, 2118.638671, 10.609038, 0);
	CreateServerPickup(194, 3, 1275,3,2184.900634, 1676.896240, 10.868740, 0);
	CreateServerPickup(195, 0, 1241,3,2188.623779, 1562.330810, 10.599861, 0);
	CreateServerPickup(196, 4, 1313,3,2336.245117, -1258.841308, 27.575452, 0);
	CreateServerPickup(197, 4, 1313,3,2001.576660, 1543.625854, 13.361825, 0);
	CreateServerPickup(198, 7, 1247,3,2318.776611, -1278.132568, 23.544630, 0);
	CreateServerPickup(199, 8, 1582,3,2029.416381, 1296.626464, 10.599720, 0);
	CreateServerPickup(200, 8, 1582,3,2027.203369, 1187.826416, 10.600026, 0);
	CreateServerPickup(201, 8, 1582,3,2079.395263, 1116.997802, 10.620149, 0);
	CreateServerPickup(202, 6, 1279,3,2339.554443, -1225.519775, 22.500000, 0);
	CreateServerPickup(203, 2, 1254,3,2020.722167, 933.254882, 10.286870, 0);
	CreateServerPickup(204, 0, 1241,3,2286.314941, 715.759338, 10.798717, 0);
	CreateServerPickup(205, 3, 1275,3,2209.867187, -1174.984741, 29.782968, 0);
	CreateServerPickup(206, 7, 1247,3,2383.476318, 577.180786, 7.561463, 0);
	CreateServerPickup(207, 5, 1276,3,2267.434082, 551.707092, 7.559081, 0);
	CreateServerPickup(208, 8, 1582,3,1996.829345, 746.631042, 10.599001, 0);
	CreateServerPickup(209, 7, 1247,3,2239.813720, -1186.290039, 37.932811, 0);
	CreateServerPickup(210, 8, 1582,3,1822.059082, 776.122497, 10.538166, 0);
	CreateServerPickup(211, 5, 1276,3,2220.614746, -1206.645019, 24.079114, 0);
	CreateServerPickup(212, 8, 1582,3,1772.896728, 868.197570, 10.556942, 0);
	CreateServerPickup(213, 3, 1275,3,1627.072631, 174.598449, 33.817714, 0);
	CreateServerPickup(214, 4, 1313,3,2200.306640, -1059.117919, 55.007812, 0);
	CreateServerPickup(215, 1, 1252,3,2177.140380, -983.867736, 64.468750, 0);
	CreateServerPickup(216, 8, 1582,3,1759.474975, -722.371459, 56.829868, 0);
	CreateServerPickup(217, 7, 1247,3,2157.459228, -1108.651367, 25.243160, 0);
	CreateServerPickup(218, 5, 1276,3,2349.154541, -1216.721435, 22.279850, 0);
	CreateServerPickup(219, 4, 1313,3,2050.154052, -953.240539, 48.043731, 0);
	CreateServerPickup(220, 5, 1276,3,2015.790649, -1028.698120, 24.400430, 0);
	CreateServerPickup(221, 6, 1279,3,1967.452758, -1178.973510, 19.630752, 0);
	CreateServerPickup(222, 3, 1275,3,1972.357910, -1235.033203, 20.050182, 0);
	CreateServerPickup(223, 7, 1247,3,2017.050170, -1284.491577, 28.488073, 0);
	CreateServerPickup(224, 5, 1276,3,1976.309570, -1284.891479, 28.491893, 0);
	CreateServerPickup(225, 0, 1241,3,2130.068847, -1281.242065, 25.495216, 0);
	CreateServerPickup(226, 8, 1582,3,2122.236572, -1330.056030, 26.652433, 0);
	CreateServerPickup(227, 4, 1313,3,2114.001464, -1285.723266, 25.492187, 0);
	CreateServerPickup(228, 6, 1279,3,2014.161254, -1305.826782, 20.865463, 0);
	CreateServerPickup(229, 8, 1582,3,1982.173706, -1306.497070, 20.868446, 0);
	CreateServerPickup(230, 3, 1275,3,1757.250854, -1349.852539, 15.609375, 0);
	CreateServerPickup(231, 5, 1276,3,1775.977661, -1369.357543, 21.093750, 0);
	CreateServerPickup(232, 0, 1241,3,1778.225219, -1383.107421, 26.646097, 0);
	CreateServerPickup(233, 8, 1582,3,1777.881347, -1382.557739, 15.861562, 0);
	CreateServerPickup(234, 3, 1275,3,1915.605834, -1425.333129, 9.980939, 0);
	CreateServerPickup(235, 2, 1254,3,2036.067138, -1404.251586, 17.264070, 0);
	CreateServerPickup(236, 7, 1247,3,1887.190185, -1586.424316, 29.049999, 0);
	CreateServerPickup(237, 7, 1247,3,1923.042358, -1586.090209, 27.790903, 0);
	CreateServerPickup(238, 1, 1252,3,1836.702148, -1738.632080, 13.011606, 0);
	CreateServerPickup(239, 4, 1313,3,1767.173706, -1866.772216, 15.812063, 0);
	CreateServerPickup(240, 0, 1241,3,1760.833251, -1920.670532, 13.184938, 0);
	CreateServerPickup(241, 1, 1252,3,1691.175048, -1955.744140, 8.250000, 0);
	CreateServerPickup(242, 5, 1276,3,1690.427978, -2035.148071, 14.139881, 0);
	CreateServerPickup(243, 8, 1582,3,1663.206176, -2134.442382, 13.546875, 0);
	CreateServerPickup(244, 3, 1275,3,1783.573242, -2145.631103, 13.554349, 0);
	CreateServerPickup(245, 8, 1582,3,1802.394409, -2138.367187, 13.546875, 0);
	CreateServerPickup(246, 8, 1582,3,1762.915283, -2084.065185, 13.552758, 0);
	CreateServerPickup(247, 8, 1582,3,1705.123413, -2132.792236, 13.546875, 0);
	CreateServerPickup(248, 7, 1247,3,1671.614501, -2112.332763, 13.546875, 0);
	CreateServerPickup(249, 5, 1276,3,1660.920410, -2083.424316, 13.546875, 0);
	CreateServerPickup(250, 5, 1276,3,1924.417114, -2124.591308, 13.583158, 0);
	CreateServerPickup(251, 7, 1247,3,1996.049194, -2151.794677, 13.546875, 0);
	CreateServerPickup(252, 8, 1582,3,2023.496215, -2082.621337, 13.546875, 0);
	CreateServerPickup(253, 1, 1252,3,2036.408813, -2068.237304, 17.357158, 0);
	CreateServerPickup(254, 4, 1313,3,2186.099365, -2129.945556, 13.149946, 0);
	CreateServerPickup(255, 8, 1582,3,2563.011962, -2045.698120, 24.529630, 0);
	CreateServerPickup(256, 4, 1313,3,2883.984130, -1635.358520, 10.482533, 0);
	CreateServerPickup(257, 6, 1279,3,2848.615966, -1237.254028, 22.035171, 0);
	CreateServerPickup(258, 5, 1276,3,2797.110839, -1088.935668, 30.340013, 0);
	CreateServerPickup(259, 8, 1582,3,2842.899658, -590.854980, 10.428134, 0);
	CreateServerPickup(260, 8, 1582,3,-1513.906738, -15.363264, 13.758091, 0);
	CreateServerPickup(261, 7, 1247,3,-1660.386596, -169.136993, 13.756066, 0);
	CreateServerPickup(262, 7, 1247,3,-1722.195556, -118.961898, 3.548918, 0);
	CreateServerPickup(263, 6, 1279,3,-1699.764648, -88.873680, 3.556060, 0);
	CreateServerPickup(264, 5, 1276,3,-1706.913940, 11.300776, 3.554687, 0);
	CreateServerPickup(265, 4, 1313,3,-1724.105346, 210.270446, 3.157739, 0);
	CreateServerPickup(266, 1, 1252,3,-1693.792602, 431.505035, 6.786528, 0);
	CreateServerPickup(267, 8, 1582,3,-1343.723022, 455.377197, 7.187500, 0);
	CreateServerPickup(268, 6, 1279,3,-1467.498291, 354.493286, 6.796309, 0);
	CreateServerPickup(269, 5, 1276,3,-1346.239868, 492.812225, 11.202690, 0);
	CreateServerPickup(270, 7, 1247,3,-1297.601684, 501.478851, 13.206581, 0);
	CreateServerPickup(271, 4, 1313,3,-1587.151489, 713.242126, -5.588410, 0);
	CreateServerPickup(272, 3, 1275,3,-1627.604736, 744.955444, -5.634587, 0);
	CreateServerPickup(273, 6, 1279,3,-1906.020263, 928.678527, 34.630233, 0);
	CreateServerPickup(274, 7, 1247,3,-2006.513671, 1081.033935, 55.177974, 0);
	CreateServerPickup(275, 5, 1276,3,-2605.772705, 910.408569, 64.248748, 0);
	CreateServerPickup(276, 4, 1313,3,-2691.535888, 629.053588, 14.063286, 0);
	CreateServerPickup(277, 7, 1247,3,-2706.136474, 376.560089, 4.968323, 0);
	CreateServerPickup(278, 6, 1279,3,-2808.833007, 156.699752, 6.639543, 0);
	CreateServerPickup(279, 3, 1275,3,-2720.599365, -319.581115, 7.452870, 0);
	CreateServerPickup(280, 3, 1275,3,-2452.407470, -163.232269, 35.338066, 0);
	CreateServerPickup(281, 6, 1279,3,-2313.899414, 18.884868, 35.320312, 0);
	CreateServerPickup(282, 7, 1247,3,-2260.151611, 5.641451, 36.185111, 0);
	CreateServerPickup(283, 4, 1313,3,-2102.904296, -127.808601, 35.320312, 0);
	CreateServerPickup(284, 1, 1252,3,-2021.196166, -64.002738, 43.088794, 0);
	CreateServerPickup(285, 4, 1313,3,-1943.892578, 417.265106, 35.171875, 0);

	return 1;
}

// © xRicardOx y OkeiOner - Todos los derechos reservados.
