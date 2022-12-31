#define DIALOG_MISSION_LIST 50
#define DIALOG_MISSION_REQUEST 51
#define DIALOG_MISSION_CANCELREQUEST 52


#define MISSION_REWARD_MONEY 0
#define MISSION_REWARD_SCORE 1

#define MISSION_KILL_ZOMBIES 0
#define MISSION_KILL_HUMANS 1
#define MISSION_FIND_WEAPONS 2
#define MISSION_FIND_PICKUPS 3

stock gRandom(min, max)
{
    new rand = random(max-min)+min;
    return rand;
}

stock ChooseNumber(_:...) return getarg(random(numargs()));


stock mission_GetWeaponName(weaponid, weapon[], len = sizeof(weapon))
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

enum MissionInfo
{
	active,
	missiontype,
	camount,
	remount,
	target_id,
	reward,
	rewardtype
}
new PlayerMission[MAX_PLAYERS][MissionInfo];


stock CreateMissionForPlayer(playerid, mtype, rtype)
{
	/*
	rtype = rewardtype
	mission types
	0 - kill zombies
	1 - kill humans
	2 - find weapons
	3 - find pickups
	*/
	switch(mtype)
	{
	    case MISSION_KILL_ZOMBIES: ShowPlayerMissionPrompt(playerid, MISSION_KILL_ZOMBIES, gRandom(50, 400), gRandom(1, 4), rtype);//matar 30 o 300 zombis
	    case MISSION_KILL_HUMANS: ShowPlayerMissionPrompt(playerid, MISSION_KILL_HUMANS, gRandom(50, 250), 0, rtype);//matar 50 o 150 humanos
	    case MISSION_FIND_WEAPONS: ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{F50000}* R.Z System", "{ffffff}Por el momento esta misión no está disponible.", "x", "");//encontrar munición
	    case MISSION_FIND_PICKUPS: ShowPlayerMissionPrompt(playerid, MISSION_FIND_PICKUPS, gRandom(30, 120), ChooseNumber(1241, 1252, 1254, 1275, 1313, 1276, 1279, 1247/*, 1582*/), rtype);//encontrar pickups de 30 a 120
		default: return 1;
	}
	return 1;
}


stock CalculateRewardAmountForMission(mtype, amount, rtype)
{
	switch(rtype)
	{
	    case MISSION_REWARD_MONEY://dinero
	    {
	        switch(mtype)
	        {
	            case MISSION_KILL_ZOMBIES: { amount = amount*gRandom(35, 45); /* kill zombies */ return amount; }
	            case MISSION_KILL_HUMANS: { amount = amount*gRandom(90, 100); /* kill humans */ return amount; }
	            case MISSION_FIND_WEAPONS: { amount = amount*gRandom(2, 5); /* encontrar armas */ return amount; }
	            case MISSION_FIND_PICKUPS: { amount = amount*gRandom(35, 120); /* encontrar pickups */ return amount; }
	        }
	    }
	    case MISSION_REWARD_SCORE://score
	    {
	        switch(mtype)
	        {
	            case MISSION_KILL_ZOMBIES: { amount = amount*gRandom(2, 3); /* kill zombies */ return amount; }
	            case MISSION_KILL_HUMANS: { amount = amount*gRandom(5, 10); /* kill humans */ return amount; }
	            case MISSION_FIND_WEAPONS: { amount = amount/gRandom(2, 3); /* encontrar armas */ return amount; }
	            case MISSION_FIND_PICKUPS: { amount = amount*gRandom(25, 35); /* encontrar pickups */ return amount; }
	        }
	    }
	    default: return 0;
	}
	return 1;
}


stock mission_GetPickUpName(pickupId, pikcupName[], len)
{
    switch(pickupId)
    {
        //1241, 1252, 1254, 1275, 1313, 1276, 1279, 1247, 1582
        case 1241: strcat(pikcupName, "Pildoras de Adrenalina", len);
        case 1252: strcat(pikcupName, "Bombas Grises", len);
        case 1254: strcat(pikcupName, "Calaveras", len);
        case 1275: strcat(pikcupName, "Camisetas Azules", len);
        case 1313: strcat(pikcupName, "Calaveras Dobles", len);
        case 1276: strcat(pikcupName, "Totems Tiki", len);
        case 1279: strcat(pikcupName, "Paquetes de Drogas", len);
        case 1247: strcat(pikcupName, "Estrellas", len);
        case 1582: strcat(pikcupName, "Pizzas", len);
        default: strcat(pikcupName, "???", len);
    }
    return pikcupName;
}


stock mission_GetVirusTypeText(virus_type, virusText[], len)
{
	switch(virus_type)
	{
	    case 0: strcat(virusText,"Zombies Normales", len);
	    case 1: strcat(virusText,"Zombies con el C-Virus", len);
	    case 2: strcat(virusText,"Zombies con el F-Virus", len);
	    case 3: strcat(virusText,"Zombies con el G-Virus", len);
	    case 4: strcat(virusText,"Zombies con el Z-Virus", len);
	}
	return virusText;
}

stock GetMissionObjName(mtype, target, objName[], len = sizeof(objName))
{
	switch(mtype)
	{
	    case MISSION_KILL_ZOMBIES: mission_GetVirusTypeText(target, objName, len);
	    case MISSION_KILL_HUMANS: strcat(objName, "Humanos", len);
	    case MISSION_FIND_WEAPONS: mission_GetWeaponName(target,objName, len);
	    case MISSION_FIND_PICKUPS: mission_GetPickUpName(target,objName, len);
	    default: strcat(objName, "?", len);
	}
	return objName;
}

stock GetMissionObjetiveName(mtype, missionObjetiveName[], len = sizeof(missionObjetiveName))
{
    switch(mtype)
    {
        case MISSION_KILL_ZOMBIES: strcat(missionObjetiveName, "Matar", len);
        case MISSION_KILL_HUMANS: strcat(missionObjetiveName, "Asesinar", len);
        case MISSION_FIND_WEAPONS: strcat(missionObjetiveName, "Recolectar", len);
        case MISSION_FIND_PICKUPS: strcat(missionObjetiveName, "Encontrar", len);
        default: strcat(missionObjetiveName, "?", len);
    }
    return missionObjetiveName;
}


stock GetRewardTypeTextByTypeId(rtype, text[], len = sizeof(text))
{
    switch(rtype)
    {
        case MISSION_REWARD_MONEY: strcat(text, "Billetes", len);
        case MISSION_REWARD_SCORE: strcat(text, "Puntos", len);
        default: strcat(text, "???", len);
    }
    return text;
}

stock GetRewardTypeText(playerid, text[], len = sizeof(text))
{
    new rtype= PlayerMission[playerid][rewardtype];
    switch(rtype)
    {
        case MISSION_REWARD_MONEY: strcat(text, "Billetes", len);
        case MISSION_REWARD_SCORE: strcat(text, "Puntos", len);
        default: strcat(text, "???", len);
    }
    return text;
}

stock ShowPlayerMissionPrompt(playerid, mtype, amount, objtarget_id, rtype)
{
	new Obtendras = CalculateRewardAmountForMission(mtype, amount, rtype);//usar el algoritmo para calcular cuanto recibira como recompensa.
	
    PlayerMission[playerid][missiontype] = mtype;
    PlayerMission[playerid][camount] = 0;
    PlayerMission[playerid][remount] = amount;
    PlayerMission[playerid][target_id] = objtarget_id;
    PlayerMission[playerid][rewardtype] = rtype;
    PlayerMission[playerid][reward] = Obtendras;
    
	new objName[350],MissionObjetive[40],RewardType[10];
	GetMissionObjName(mtype, objtarget_id, objName);
	GetMissionObjetiveName(mtype, MissionObjetive);
	GetRewardTypeTextByTypeId(rtype, RewardType);
	
	new request_string[256],request_title[128];
	format(request_string, sizeof(request_string), "{FF6633}Eh vale... qué te parece esto?\n{FF6633}%s {ffffff}%d %s{FF6633}, por supuesto.. la recompensa: %d %s (%d).\n{33FF66}¿Aceptas la Mission?", MissionObjetive, amount, objName, Obtendras, RewardType, rtype);
	format(request_title, sizeof(request_title), "{FF33CC}R.Z{ffffff} Mision de: {FF33CC}%s",MissionObjetive);
	return ShowPlayerDialog(playerid,DIALOG_MISSION_REQUEST,DIALOG_STYLE_MSGBOX,request_title,request_string,"SI","NO");
}

stock ShowMissionsForPlayer(playerid)
{
	if(!checkMissionCompleted(playerid))
	{
		ShowPlayerDialog(playerid, DIALOG_MISSION_LIST, DIALOG_STYLE_TABLIST_HEADERS, "{FF0099}R.Z: {FFFFFF}Missions",
		"Tipo\tRecompensa\n\
		Matar Zombies\t{66FF33}Monedas\n\
		Matar Humanos\t{66FF33}Monedas\n\
		Recolectar Munición\t{66FF33}Monedas\n\
		Buscar Objetos\t{66FF33}Monedas\n\
		Matar Zombies\t{FF6633}SCORE\n\
		Matar Humanos\t{FF6633}SCORE\n\
		Recolectar Munición\t{FF6633}SCORE\n\
		Buscar Objetos\t{FF6633}SCORE",
		"VER", "X");
	}
	return 1;
}
forward RZM_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
public RZM_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_MISSION_LIST)
	{
		if(response == 1)
		{
		    if(PlayerMission[playerid][active]) return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{F50000}* Mission Errror", "Ya estas en una misión", "x", "");
			switch(listitem)
			{
			    case 0: return CreateMissionForPlayer(playerid, MISSION_KILL_ZOMBIES, MISSION_REWARD_MONEY);//kill zombies - money
			    case 1: return CreateMissionForPlayer(playerid, MISSION_KILL_HUMANS, MISSION_REWARD_MONEY);//kill humans - money
			    case 2: return CreateMissionForPlayer(playerid, MISSION_FIND_WEAPONS, MISSION_REWARD_MONEY);//find weapons - money
			    case 3: return CreateMissionForPlayer(playerid, MISSION_FIND_PICKUPS, MISSION_REWARD_MONEY);//find pickups - money

			    case 4: return CreateMissionForPlayer(playerid, MISSION_KILL_ZOMBIES, MISSION_REWARD_SCORE);//kill zombies - score
			    case 5: return CreateMissionForPlayer(playerid, MISSION_KILL_HUMANS, MISSION_REWARD_SCORE);//kill humans - score
			    case 6: return CreateMissionForPlayer(playerid, MISSION_FIND_WEAPONS, MISSION_REWARD_SCORE);//find weapons - score
			    case 7: return CreateMissionForPlayer(playerid, MISSION_FIND_PICKUPS, MISSION_REWARD_SCORE);//find pickups - score
			    default: return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{F50000}* System Fatal Error", "Unkown List Item Error", "x", "");
			}
		}
	}
	if(dialogid == DIALOG_MISSION_REQUEST)
	{
	    if(response == 1)
	    {
	        PlayerMission[playerid][active] = 1;
			SendClientMessage(playerid,red,"]<!>[ {ffffff}Mision Activa.");
			PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	    }
	    else ShowMissionsForPlayer(playerid);
	}
	if(dialogid == DIALOG_MISSION_CANCELREQUEST)
	{
	    if(response == 1)
	    {
	        PlayerMission[playerid][active] = 0;
	        ShowMissionsForPlayer(playerid);
	    }
	}
	return 1;
}

stock ResetMissionVariables(playerid)
{
	PlayerMission[playerid][active] = 0;
	PlayerMission[playerid][missiontype] = 0;
	PlayerMission[playerid][remount] = 0;
	PlayerMission[playerid][camount] = 0;
	PlayerMission[playerid][target_id] = 0;
	PlayerMission[playerid][reward] = 0;
	PlayerMission[playerid][rewardtype] = 0;
}

stock DisableMissionInfo(playerid)
{
	PlayerMission[playerid][active] = 0;
	PlayerMission[playerid][missiontype] = 0;
	PlayerMission[playerid][remount] = 0;
	PlayerMission[playerid][camount] = 0;
	PlayerMission[playerid][target_id] = 0;
	PlayerMission[playerid][reward] = 0;
	PlayerMission[playerid][rewardtype] = 0;
	new updateInt[300];
	format(updateInt, sizeof(updateInt), "UPDATE MissionData SET status='0',mtype='0',amount='0',current_amount='0',target_id='0',reward='0',rewardtype='0' WHERE Nickname = '%s'", DB_Escape(PlayerName2(playerid)));
	db_free_result(db_query(DataBase_USERS,updateInt));
	return 1;
}

stock SaveMissionInfo(playerid)
{
	if(IsPlayerOnMission(playerid))
	{
		new updateInt[1500];
		format(updateInt, sizeof(updateInt), "UPDATE MissionData SET status='%d',mtype='%d',amount='%d',current_amount='%d',target_id='%d',reward='%d',rewardtype='%d' WHERE Nickname = '%s'", IsPlayerOnMission(playerid), PlayerMission[playerid][missiontype], PlayerMission[playerid][remount],PlayerMission[playerid][camount], PlayerMission[playerid][target_id], PlayerMission[playerid][reward], PlayerMission[playerid][rewardtype], DB_Escape(PlayerName2(playerid)));
		db_free_result(db_query(DataBase_USERS,updateInt));
	}
	else
	{
	    DisableMissionInfo(playerid);
	}
}

stock LoadMissionInfo(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new DBResult: result,data[128],SQL_CONSULTA[256];
	format(SQL_CONSULTA, sizeof(SQL_CONSULTA), "SELECT * FROM MissionData WHERE Nickname = '%s'", DB_Escape(PlayerName2(playerid)));
	result = db_query(DataBase_USERS,SQL_CONSULTA);
    if(db_num_rows(result))
    {
        db_get_field_assoc(result, "status",data,sizeof(data)); PlayerMission[playerid][active] = strval(data);
        db_get_field_assoc(result, "mtype",data,sizeof(data)); PlayerMission[playerid][missiontype] = strval(data);
        db_get_field_assoc(result, "amount",data,sizeof(data)); PlayerMission[playerid][remount] = strval(data);
        db_get_field_assoc(result, "current_amount",data,sizeof(data)); PlayerMission[playerid][camount] = strval(data);
        db_get_field_assoc(result, "target_id",data,sizeof(data)); PlayerMission[playerid][target_id] = strval(data);
        db_get_field_assoc(result, "reward",data,sizeof(data)); PlayerMission[playerid][reward] = strval(data);
        db_get_field_assoc(result, "rewardtype",data,sizeof(data)); PlayerMission[playerid][rewardtype] = strval(data);
        db_free_result(result);
		new Obtendras = CalculateRewardAmountForMission(PlayerMission[playerid][missiontype], PlayerMission[playerid][remount], PlayerMission[playerid][rewardtype]);//usar el algoritmo para calcular cuanto recibira como recompensa.
		new objName[350],MissionObjetive[40],RewardType[10];
		GetMissionObjName(PlayerMission[playerid][missiontype], PlayerMission[playerid][target_id], objName);
		GetMissionObjetiveName(PlayerMission[playerid][missiontype], MissionObjetive);
		GetRewardTypeText(playerid, RewardType);
		if(IsPlayerOnMission(playerid))
		{
			if(GetMissionProgressAmount(playerid) < GetMissionProgressLimit(playerid)){
			new request_string[256];
			format(request_string, sizeof(request_string), "{FFFFFF}Hey!! No te olvides de completar tu misión.\n{FFFFFF}Aun tienes que %s {FF6633}%d %s más,{FFFFFF} Te pagaremos {FF6633}%d %s.", MissionObjetive, PlayerMission[playerid][remount]-PlayerMission[playerid][camount], objName, Obtendras, RewardType);
			ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"R.Z Mission Reminder",request_string,"OK","");
			}
			else
			{
			ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"R.Z Mission Reminder","{ffffff}Hey! Ya has completado tu misión,\nPara obtener tu recompensa acude con cualquier cientifico.","OK","");
			}
		}
    }
    else
    {
        format(SQL_CONSULTA, sizeof(SQL_CONSULTA), "INSERT INTO `MissionData` (`Nickname`) VALUES ('%s')", DB_Escape(PlayerName2(playerid)));
        db_free_result(db_query(DataBase_USERS, SQL_CONSULTA));
    }
    return 1;
}

stock MissionLog(playerid, command[])
{
	new query[1000];
	new year, Mes, Dia;
	getdate(year, Mes, Dia);
	format(query,sizeof(query),"INSERT INTO `MissionLogs` (Nickname, strlog, fecha) VALUES ('%s','%s','%d/%02d/%d')", PlayerName2(playerid), command, year, Mes, Dia);
	db_free_result(db_query(DataBase_USERS,query));
}


stock GetMissionType(playerid) return PlayerMission[playerid][missiontype];
stock GetMissionObjType(playerid) return PlayerMission[playerid][target_id];
stock GetMissionRewardType(playerid) return PlayerMission[playerid][rewardtype];
stock GetMissionReward(playerid) return PlayerMission[playerid][reward];
stock IsPlayerOnMission(playerid)
{
	if(PlayerMission[playerid][active] == 1) return 1;
	else return 0;
}
stock GetMissionProgressAmount(playerid) return PlayerMission[playerid][camount];
stock GetMissionProgressLimit(playerid) return PlayerMission[playerid][remount];


stock GetMissionObjTypeName(playerid)
{
    new objName[350];
    GetMissionObjName(PlayerMission[playerid][missiontype], PlayerMission[playerid][target_id], objName);
    return objName;
}

stock GetMissionObjetiveText(playerid)
{
    new objName[350];
    GetMissionObjetiveName(PlayerMission[playerid][missiontype], objName);
    return objName;
}

stock SetMissionProgressAmount(playerid, progress)
{
    PlayerMission[playerid][camount] = progress;
    return 1;
}

stock IsMissionCompleted(playerid)
{
    if(GetMissionProgressAmount(playerid) >= GetMissionProgressLimit(playerid)) return 1;
    else return 0;
}



stock checkMissionCompleted(playerid)
{
	if(IsPlayerOnMission(playerid))
	{
	    if(GetMissionType(playerid) == 2)
	    {
	        new ammo = GetPlayerAmmo(playerid);
	        if(ammo > 32767) {ammo = 32767;}
	        SetMissionProgressAmount(playerid, ammo);
	    }
	    if(GetMissionProgressAmount(playerid) >= GetMissionProgressLimit(playerid))
	    {
	        if(GetMissionType(playerid) == 2)
	        {
	            CallLocalFunction("RemovePlayerWeapon", "dd", playerid, GetPlayerWeapon(playerid));
	        }
	        PlayerMission[playerid][active] = 0;
	        new recompensa[40];
	        GetRewardTypeText(playerid, recompensa);
			SendFormatMessage(playerid,red,"]< Mission Completed >[ {ffffff}Has recibido %d %s por completar una misión.", GetMissionReward(playerid), recompensa);
			if(GetMissionRewardType(playerid) == 0)
			{
			    GivePlayerMoney(playerid, GetMissionReward(playerid));
			}
			else
			{
			    SetPlayerScore(playerid,GetPlayerScore(playerid)+GetMissionReward(playerid));
			}
			PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
            new missionlog[256];
            format(missionlog,sizeof(missionlog),"Completo la misión %s %d %s y recibio %d %s", GetMissionObjetiveText(playerid), GetMissionProgressLimit(playerid), GetMissionObjTypeName(playerid), GetMissionReward(playerid), recompensa);
            MissionLog(playerid, missionlog);
            PlayerMission[playerid][active] = 0;
            SaveMissionInfo(playerid);
            DisableMissionInfo(playerid);
	    }
	    else
	    {
		 	ShowPlayerDialog(playerid,DIALOG_MISSION_CANCELREQUEST,DIALOG_STYLE_MSGBOX,"R.Z Mission","{FF6633}Hey hey hey! Aun no has completado tu misión anterior\n{33FF66}¿Deseas Cancelarla y obtener una nueva?","SI","NO");
		}
		return 1;
	}
	else return 0;
}




stock ShowMissionInformationForPlayer(playerid)
{
	if(!IsPlayerOnMission(playerid)) return SendClientMessage(playerid,red,"]<!>[ {ffffff}No tienes ninguna mision activa.");
	if(IsMissionCompleted(playerid))
	{
		new recompensa[30];
		GetRewardTypeText(playerid, recompensa);
		new request_string[256];
		format(request_string, sizeof(request_string), "{FFFFFF}%s {FF6633}%d %s más.\n{FFFFFF} Recompensa: {FF6633}%d %s\n{ffffff}Status: {33FF66}Mision Completada.", GetMissionObjetiveText(playerid),  GetMissionProgressLimit(playerid)-GetMissionProgressAmount(playerid), GetMissionObjTypeName(playerid), GetMissionReward(playerid), recompensa);
		ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"R.Z Mission Info",request_string,"OK","");
	    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	}
	else
	{
		new recompensa[30];
		GetRewardTypeText(playerid, recompensa);
		new request_string[256];
		format(request_string, sizeof(request_string), "{FFFFFF}%s {FF6633}%d %s más,{FFFFFF} Recompensa: {FF6633}%d %s.\n{ffffff}Status: {F50000}Mision Incompleta.",GetMissionObjetiveText(playerid),  GetMissionProgressLimit(playerid)-GetMissionProgressAmount(playerid), GetMissionObjTypeName(playerid), GetMissionReward(playerid), recompensa);
		ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"R.Z Mission Info",request_string,"OK","");
	}
	return 1;
}









