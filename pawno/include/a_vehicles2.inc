    /*
        Extended vehicle functions by Emmet_

            Thanks to:

            - [uL]Pottus -> GetVehicleTopSpeed idea
            - kvann -> SetVehicleInterior idea
            - Hanger -> Top speed data
    */
    #include <a_samp>

    #define GetVehicleInterior(%0) \
            (g_aVehicles[(%0)][e_VehicleInterior])

    #define GetVehicleSeats(%0) \
            (GetVehicleModelSeats(GetVehicleModel(%0)))

    enum e_Vehicles {
            e_VehicleInterior,
            e_VehicleTrailer,
            Float:e_VehiclePos[3]
    };

    enum e_ParamTypes {
            VEHICLE_TYPE_ENGINE,
            VEHICLE_TYPE_LIGHTS,
            VEHICLE_TYPE_ALARM,
            VEHICLE_TYPE_DOORS,
            VEHICLE_TYPE_BONNET,
            VEHICLE_TYPE_BOOT,
            VEHICLE_TYPE_OBJECTIVE
    };

    static g_aVehicles[MAX_VEHICLES][e_Vehicles];

    new const g_aTopSpeed[212] =
    {
            157, 147, 186, 110, 133, 164, 110, 148, 100, 158, 129, 221, 168, 110, 105, 192, 154, 270,
            115, 149, 145, 154, 140, 99, 135, 270, 173, 165, 157, 201, 190, 130, 94, 110, 167, 0, 149,
            158, 142, 168, 136, 145, 139, 126, 110, 164, 270, 270, 111, 0, 0, 193, 270, 60, 135, 157,
            106, 95, 157, 136, 270, 160, 111, 142, 145, 145, 147, 140, 144, 270, 157, 110, 190, 190,
            149, 173, 270, 186, 117, 140, 184, 73, 156, 122, 190, 99, 64, 270, 270, 139, 157, 149, 140,
            270, 214, 176, 162, 270, 108, 123, 140, 145, 216, 216, 173, 140, 179, 166, 108, 79, 101, 270,
            270, 270, 120, 142, 157, 157, 164, 270, 270, 160, 176, 151, 130, 160, 158, 149, 176, 149, 60,
            70, 110, 167, 168, 158, 173, 0, 0, 270, 149, 203, 164, 151, 150, 147, 149, 142, 270, 153, 145,
            157, 121, 270, 144, 158, 113, 113, 156, 178, 169, 154, 178, 270, 145, 165, 160, 173, 146, 0, 0,
            93, 60, 110, 60, 158, 158, 270, 130, 158, 153, 151, 136, 85, 0, 153, 142, 165, 108, 162, 0, 0,
            270, 270, 130, 190, 175, 175, 175, 158, 151, 110, 169, 171, 148, 152, 0, 0, 0, 108, 0, 0
    };

    forward SetParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    public SetParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective)
    {
            SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    }

    public OnPlayerUpdate(playerid)
    {
            if (IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
            {
                new
                            vehicleid = GetPlayerVehicleID(playerid),
                            trailerid = GetVehicleTrailer(vehicleid);

                if (trailerid != g_aVehicles[vehicleid][e_VehicleTrailer])
                {
                    if (trailerid != 0)
					{
						CallLocalFunction("OnTrailerHooked", "ddd", playerid, vehicleid, trailerid);
					}
					else
					{
						CallLocalFunction("OnTrailerUnhooked", "ddd", playerid, vehicleid, g_aVehicles[vehicleid][e_VehicleTrailer]);
					}
					g_aVehicles[vehicleid][e_VehicleTrailer] = trailerid;
                }
            }
            #if defined EVF_OnPlayerUpdate
                EVF_OnPlayerUpdate(playerid);
            #else
                    return 1;
            #endif
		return 1;
    }

    public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
    {
            if ((hittype == BULLET_HIT_TYPE_VEHICLE) && (22 <= weaponid <= 38))
            {
                    CallLocalFunction("OnPlayerShootVehicle", "ddd", playerid, hitid, weaponid);
            }
            #if defined EVF_OnPlayerWeaponShot
                EVF_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, fX, fY, fZ);
            #else
                return 1;
            #endif
		return 1;
    }

    stock GetVehicleParams(vehicleid, type)
    {
            static
                params[7];

            if (!(0 <= type <= 7))
                return 0;

            GetVehicleParamsEx(vehicleid, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
            return (params[type] > 0);
    }

    stock SetVehicleParams(vehicleid, type, status, delay = 0)
    {
            static
                params[7];

        GetVehicleParamsEx(vehicleid, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
            params[type] = status;

            if (delay > 0)
                    SetTimerEx("SetParamsEx", delay, 0, "dddddddd", vehicleid, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);

            else
                    SetVehicleParamsEx(vehicleid, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);

            return 1;
    }

    stock GetVehicleBoot(vehicleid, &Float:x, &Float:y, &Float:z)
    {
            if (!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
                return (x = 0.0, y = 0.0, z = 0.0), 0;

            static
                Float:pos[7];

            GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
            GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);
            GetVehicleZAngle(vehicleid, pos[6]);

            x = pos[3] - (floatsqroot(pos[1] + pos[1]) * floatsin(-pos[6], degrees));
            y = pos[4] - (floatsqroot(pos[1] + pos[1]) * floatcos(-pos[6], degrees));
            z = pos[5];

            return 1;
    }

    stock GetVehicleHood(vehicleid, &Float:x, &Float:y, &Float:z)
    {
        if (!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
                return (x = 0.0, y = 0.0, z = 0.0), 0;

            static
                Float:pos[7];

            GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
            GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);
            GetVehicleZAngle(vehicleid, pos[6]);

            x = pos[3] + (floatsqroot(pos[1] + pos[1]) * floatsin(-pos[6], degrees));
            y = pos[4] + (floatsqroot(pos[1] + pos[1]) * floatcos(-pos[6], degrees));
            z = pos[5];

            return 1;
    }

    stock GetVehicleRoof(vehicleid, &Float:x, &Float:y, &Float:z)
    {
        if (!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
                return (x = 0.0, y = 0.0, z = 0.0), 0;

            static
                Float:pos[6];

            GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
            GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);

            x = pos[3];
            y = pos[4];
            z = pos[5] + floatsqroot(pos[2]);

            return 1;
    }

    stock GetOffsetFromPosition(vehicleid, Float:x, Float:y, Float:z, &Float:fOffsetX, &Float:fOffsetY, &Float:fOffsetZ)
    {
        if (!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
                return (x = 0.0, y = 0.0, z = 0.0), 0;

            new
                Float:vX,
                Float:vY,
                Float:vZ;

            GetVehiclePos(vehicleid, vX, vY, vZ);

            fOffsetX = (x - vX);
            fOffsetY = (y - vY);
            fOffsetZ = (z - vZ);

            return 1;
    }

    stock GetNearestVehicle(playerid)
    {
            static
                Float:x[2],
                Float:y[2],
                Float:z[2];

            for (new i = 1; i != MAX_VEHICLES; i ++)
            {
                if (GetVehicleModel(i) != 0 && GetPlayerInterior(playerid) == GetVehicleInterior(i) && GetPlayerVirtualWorld(playerid) == GetVehicleVirtualWorld(i))
                {
                            GetVehiclePos(i, x[0], y[0], z[0]);
                            GetVehicleModelInfo(GetVehicleModel(i), VEHICLE_MODEL_INFO_SIZE, x[1], y[1], z[1]);

                            if (IsPlayerInRangeOfPoint(playerid, floatsqroot(x[1] + y[1] + z[1]), x[0], y[0], z[0]))
                                    return i;
                    }
            }
            return INVALID_VEHICLE_ID;
    }

    stock GetVehicleDriver(vehicleid)
    {
            for (new i = 0, l = GetMaxPlayers(); i != l; i ++)
            {
                if (GetPlayerState(i) == PLAYER_STATE_DRIVER && IsPlayerInVehicle(i, vehicleid))
                            return i;
            }
            return INVALID_PLAYER_ID;
    }

    stock IsSeatOccupied(vehicleid, seatid)
    {
            if (!GetVehicleModel(vehicleid))
                    return 0;

            for (new i = 0, j = GetMaxPlayers(); i != j; i ++)
            {
                if (IsPlayerInVehicle(i, vehicleid) && GetPlayerVehicleSeat(i) == seatid)
                            return 1;
            }
            return 0;
    }

    stock GetVehicleNextSeat(vehicleid, passenger = 1)
    {
            if (!GetVehicleModel(vehicleid) || GetVehicleSeats(vehicleid) <= 1)
                return -1;

            for (new i = passenger; i < GetVehicleSeats(vehicleid); i ++)
            {
                if (!IsSeatOccupied(vehicleid, i))
                            return i;
            }
            return -1;
    }

    stock GetVehicleModelSeats(modelid)
    {
        static const g_aVehicleSeats[] =
            {
                    4, 2, 2, 2, 4, 4, 1, 2, 2, 4, 2, 2, 2, 4, 2, 2, 4, 2, 4, 2, 4, 4, 2, 2, 2, 1, 4, 4, 4, 2,
                    1, 7, 1, 2, 2, 0, 2, 7, 4, 2, 4, 1, 2, 2, 2, 4, 1, 2, 1, 0, 0, 2, 1, 1, 1, 2, 2, 2, 4,
                    4, 2, 2, 2, 2, 1, 1, 4, 4, 2, 2, 4, 2, 1, 1, 2, 2, 1, 2, 2, 4, 2, 1, 4, 3, 1, 1, 1, 4, 2,
                    2, 4, 2, 4, 1, 2, 2, 2, 4, 4, 2, 2, 1, 2, 2, 2, 2, 2, 4, 2, 1, 1, 2, 1, 1, 2, 2, 4, 2, 2,
                    1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 4, 1, 1, 1, 2, 2, 2, 2, 7, 7, 1, 4, 2, 2, 2, 2, 2, 4, 4,
                    2, 2, 4, 4, 2, 1, 2, 2, 2, 2, 2, 2, 4, 4, 2, 2, 1, 2, 4, 4, 1, 0, 0, 1, 1, 2, 1, 2, 2, 1, 2,
                    4, 4, 2, 4, 1, 0, 4, 2, 2, 2, 2, 0, 0, 7, 2, 2, 1, 4, 4, 4, 2, 2, 2, 2, 2, 4, 2, 0, 0, 0,
                    4, 0, 0
            };
            return (modelid < 400 || modelid > 611) ? (0) : (g_aVehicleSeats[(modelid - 400)]);
    }

    stock GetVehicleTopSpeed(vehicleid)
    {
            new model = GetVehicleModel(vehicleid);

            if (!model)
                    return 0;

            return g_aTopSpeed[(model - 400)];
    }

    stock IsTirePopped(vehicleid, tireid)
    {
        new
                panels,
                doors,
                lights,
                tires;

            GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);

            switch (GetVehicleModel(vehicleid))
            {
                case 448, 461..463, 468, 521..523, 581, 586:
                {
                    if (((tireid == 0) && (tires & 10 || tires & 11)) || (tireid == 1) && (tires & 01 || tires & 11))
                                    return 1;
                    }
                    default:
                    {
                        if ((tireid == 0) && (tires & 1000 || tires & 1001 || tires & 1010 || tires & 1011 || tires & 1100 || tires & 1101 || tires & 1110 || tires & 1111))
                                    return 1;

                            else if ((tireid == 1) && (tires & 0010 || tires & 0011 || tires & 0110 || tires & 0111 || tires & 1010 || tires & 1011 || tires & 1110 || tires & 1111))
                                return 1;

                            else if ((tireid == 2) && (tires & 0100 || tires & 0101 || tires & 0110 || tires & 0111 || tires & 1100 || tires & 1101 || tires & 1110 || tires & 1111))
                                return 1;

                            else if ((tireid == 3) && (tires & 0001 || tires & 0011 || tires & 0101 || tires & 0111 || tires & 1001 || tires & 1011 || tires & 1101 || tires & 1111))
                                return 1;
                    }
            }
            return 0;
    }

    stock GetVehicleDamage(vehicleid)
    {
        new
                    Float:health;

            if (GetVehicleHealth(vehicleid, health))
            {
                if (health > 1000.0)
                    return 100;

                else if (health < 250.0)
                    return 0;

                else
                            return floatround(((1000.0 - health) / 10) * 1.334);
            }
            return 0;
    }

    stock EVF_LinkVehicleToInterior(vehicleid, interiorid)
    {
            if ((0 <= vehicleid < MAX_VEHICLES) && GetVehicleModel(vehicleid))
            {
                    g_aVehicles[vehicleid][e_VehicleInterior] = interiorid;
                    LinkVehicleToInterior(vehicleid, interiorid);
            }
            return 1;
    }

    stock EVF_CreateVehicle(modelid, Float:x, Float:y, Float:z, Float:a, color1, color2, respawn_delay)
    {
            new vehicleid = CreateVehicle(modelid, x, y, z, a, color1, color2, respawn_delay);

            if (vehicleid != INVALID_VEHICLE_ID)
            {
                    g_aVehicles[vehicleid][e_VehicleInterior] = 0;
                    g_aVehicles[vehicleid][e_VehicleTrailer] = INVALID_VEHICLE_ID;

                    CallLocalFunction("OnVehicleCreated", "d", vehicleid);
                    return vehicleid;
            }
            return INVALID_VEHICLE_ID;
    }

    stock EVF_AddStaticVehicle(modelid, Float:x, Float:y, Float:z, Float:a, color1, color2)
    {
            new vehicleid = AddStaticVehicle(modelid, x, y, z, a, color1, color2);

            if (vehicleid != INVALID_VEHICLE_ID)
            {
                    g_aVehicles[vehicleid][e_VehicleInterior] = 0;
                    g_aVehicles[vehicleid][e_VehicleTrailer] = INVALID_VEHICLE_ID;

                    CallLocalFunction("OnVehicleCreated", "d", vehicleid);
                    return vehicleid;
            }
            return INVALID_VEHICLE_ID;
    }

    stock EVF_AddStaticVehicleEx(modelid, Float:x, Float:y, Float:z, Float:a, color1, color2, respawn_delay)
    {
            new vehicleid = AddStaticVehicleEx(modelid, x, y, z, a, color1, color2, respawn_delay);

            if (vehicleid != INVALID_VEHICLE_ID)
            {
                    g_aVehicles[vehicleid][e_VehicleInterior] = 0;
                    g_aVehicles[vehicleid][e_VehicleTrailer] = INVALID_VEHICLE_ID;

                    CallLocalFunction("OnVehicleCreated", "d", vehicleid);
                    return vehicleid;
            }
            return INVALID_VEHICLE_ID;
    }

    #if defined _ALS_LinkVehicleToInterior
            #define LinkVehicleToInterior
    #else
            #define _ALS_LinkVehicleToInterior
    #endif

    #if defined _ALS_CreateVehicle
            #define CreateVehicle
    #else
            #define _ALS_CreateVehicle
    #endif

    #if defined _ALS_AddStaticVehicle
            #define AddStaticVehicle
    #else
            #define _ALS_AddStaticVehicle
    #endif

    #if defined _ALS_AddStaticVehicleEx
            #define AddStaticVehicleEx
    #else
            #define _ALS_AddStaticVehicleEx
    #endif

    #if defined _ALS_OnPlayerUpdate
            #undef OnPlayerUpdate
    #else
            #define _ALS_OnPlayerUpdate
    #endif

    #if defined _ALS_OnPlayerWeaponShot
            #undef OnPlayerWeaponShot
    #else
            #define _ALS_OnPlayerWeaponShot
    #endif

    #define LinkVehicleToInterior   EVF_LinkVehicleToInterior
    #define CreateVehicle                   EVF_CreateVehicle
    #define AddStaticVehicle                EVF_AddStaticVehicle
    #define AddStaticVehicleEx              EVF_AddStaticVehicleEx
    #define OnPlayerUpdate          EVF_OnPlayerUpdate
    #define OnPlayerWeaponShot      EVF_OnPlayerWeaponShot
    #define SetVehicleInterior      LinkVehicleToInterior

    #if defined EVF_OnPlayerUpdate
            forward EVF_OnPlayerUpdate(playerid);
    #endif

    #if defined EVF_OnPlayerWeaponShot
            forward EVF_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
    #endif

    forward OnVehicleCreated(vehicleid);
    forward OnPlayerShootVehicle(playerid, vehicleid, weaponid);
    forward OnTrailerHooked(playerid, vehicleid, trailerid);
    forward OnTrailerUnhooked(playerid, vehicleid, trailerid);

