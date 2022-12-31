#include <a_samp>
#define FILTERSCRIPT



new HasHack[MAX_PLAYERS];

stock PlayerName2(playerid) {
  new name[MAX_PLAYER_NAME];
  GetPlayerName(playerid, name, sizeof(name));
  return name;
}

native SendClientCheck(clientid, actionid, arg1, arg2, bytes);
forward OnClientCheckResponse(clientid, actionid, checksum, crc);

public OnPlayerConnect(playerid)
{
	SetPlayerHackStatus(playerid, 0);
	return 1;
}

public OnPlayerDisconnect(playerid)
{
	SetPlayerHackStatus(playerid, 0);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    SendClientCheck(playerid, 0x47,0x00000000,0x0000,0x0004);
    return 1;
}


public OnClientCheckResponse(clientid, actionid, checksum, crc)
{
	//printf("[OnClientCheckResponse]: PlayerId %d has ClientCheck enabled...", clientid);
	if(GetPlayerHackStatus(clientid) == 0)
	{
	  	switch(actionid)
	  	{
	    	case 0x47: SendClientCheck(clientid, 0x02,0x00000000,0x0000,0x0004);
	    	case 0x02:
	    	{
	    	    //if ((addr & 0xFC0000) != 0xFC0000)
	 	 		if (checksum & 0x00ff0000 == 0x00300000)
	 	 		{
					SetPlayerHackStatus(clientid, 1);
					printf("[OnClientCheckResponse]: HACK! PlayerId %d", clientid);
					return 1;
				}
	    	}
	  	}
  	}
    return 1;
}
forward SetPlayerHackStatus(playerid, status);
public SetPlayerHackStatus(playerid, status){
    HasHack[playerid] = status;
	return true;
}

forward GetPlayerHackStatus(playerid);
public GetPlayerHackStatus(playerid){
	return HasHack[playerid];
}







