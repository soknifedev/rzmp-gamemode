
#define TIME_DIF 4 //Decreasing will make it more accurate, leave it like that, it's fine.

forward C_Paused(playerid);
forward OnPlayerPause(playerid);
//forward OnPlayerUnPause(playerid);

new g_Paused[MAX_PLAYERS];
new g_Timer[MAX_PLAYERS];
new bool:g_Requesting[MAX_PLAYERS];
new bool:g_IsPaused[MAX_PLAYERS];

	forward  P_OnPlayerConnect(playerid);
    public P_OnPlayerConnect(playerid)
    {
        g_IsPaused[playerid] = false;
        g_Requesting[playerid] = false;
        g_Timer[playerid] = SetTimerEx("C_Paused", 754, 1, "i", playerid);
        return 1;
    }
	forward P_OnPlayerUpdate(playerid);
    public P_OnPlayerUpdate(playerid)
    {
        g_Paused[playerid] = rztickcount();
        return 1;
    }
	forward P_OnPlayerRequestClass(playerid);
    public P_OnPlayerRequestClass(playerid)
    {
            g_Requesting[playerid] = true;
            g_IsPaused[playerid] = false;
            return 1;
    }
	forward  P_OnPlayerDisconnect(playerid);
    public P_OnPlayerDisconnect(playerid)
    {
    	KillTimer(g_Timer[playerid]);
        g_Requesting[playerid] = false;
        g_IsPaused[playerid] = false;
		return 1;
    }
	forward P_OnPlayerSpawn(playerid);
    public P_OnPlayerSpawn(playerid)
    {
            g_Requesting[playerid] = false;
            g_IsPaused[playerid] = false;
            return 1;
    }

    public C_Paused(playerid)
    {
	if(rztickcount()-g_Paused[playerid] > TIME_DIF && g_Requesting[playerid] != true && g_IsPaused[playerid] != true && InvalidStates(playerid) != 1)
            {
                    OnPlayerPause(playerid);
                    g_IsPaused[playerid] = true;
            }
            else if(rztickcount()-g_Paused[playerid] < TIME_DIF && g_Requesting[playerid] != true && g_IsPaused[playerid] != false && InvalidStates(playerid) != 1)
            {
                //OnPlayerUnPause(playerid);
                g_IsPaused[playerid] = false;
            }
    return 1;
    }

    stock IsPlayerPaused(playerid)
    {
            return g_IsPaused[playerid];
    }

    stock InvalidStates(playerid)
    {
		new pState = GetPlayerState(playerid);
        if(pState == 0 || pState == 7)
        {
                    return 1;
            }
            else
            {
                    return 0;
            }
    }

