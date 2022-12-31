#if !defined _RPG_included
#define _RPG_included

#include <a_samp>
#tryinclude <raknetmanager>

#define RPC_WorldPlayerAdd 32
#define RPC_WorldPlayerRemove 163
#define RPC_ServerJoin 137
#define RPC_ServerQuit 138
#define ID_PLAYER_SYNC 207
#define ID_AIM_SYNC 203
#define MAX_SLOTS 1004

static stock Float:GetVectorLength(Float:v[3])
{
	return floatsqroot(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
}

static stock GetUnitVector(Float:v[3], Float:out[3])
{
	new Float:length = GetVectorLength(v);
	out[0] = v[0]/length;
	out[1] = v[1]/length;
	out[2] = v[2]/length;
}

static stock VectorDiff(Float:v1[3], Float:v2[3], Float:out[3])
{
	out[0] = v2[0] - v1[0];
	out[1] = v2[1] - v1[1];
	out[2] = v2[2] - v1[2];
}

static stock GetAimVector(Float:origin[3], Float:target[3], Float:out[3])
{
	new Float:diff[3];
	VectorDiff(origin, target, diff);
	GetUnitVector(diff, out);
}

static stock GetQuatFromRot(Float:yaw, Float:pitch, Float:roll, Float:quat[4])
{
	yaw = yaw - 180.0;
	
    new Float:W, Float:X, Float:Y, Float:Z;
	new Float:c1 = floatcos(yaw/2, degrees);
	new Float:s1 = floatsin(yaw/2, degrees);
	new Float:c2 = floatcos(pitch/2, degrees);
	new Float:s2 = floatsin(pitch/2, degrees);
	new Float:c3 = floatcos(roll/2, degrees);
	new Float:s3 = floatsin(roll/2, degrees);
	new Float:c1c2 = c1*c2;
	new Float:s1s2 = s1*s2;
    W = c1c2*c3 - s1s2*s3;
   	X = c1c2*s3 + s1s2*c3;
    Y = s1*c2*c3 + c1*s2*s3;
    Z = c1*s2*c3 - s1*c2*s3;
    
   	new Float:norm = floatsqroot(W*W + X*X + Y*Y + Z*Z);
    if (norm == 0.0)
    {
        W = 1.0;
        X = Y = Z = 0.0;
    }
    else
    {
        W /= norm;
        X /= norm;
        Y /= norm;
        Z /= norm;
    }
    
	quat[3] = W;
	quat[1] = X;
	quat[0] = Y;
	quat[2] = Z;
}

static stock GetRotFromQuat(Float:quat[4], &Float:yaw, &Float:pitch, &Float:roll)
{
	new Float:W, Float:X, Float:Y, Float:Z;

	W = quat[3];
	X = quat[1];
	Y = quat[0];
	Z = quat[2];

	new Float:sqw = W*W;
	new Float:sqx = X*X;
	new Float:sqy = Y*Y;
	new Float:sqz = Z*Z;
	new Float:unit = sqx + sqy + sqz + sqw;
	new Float:test = X*Y + Z*W;
	
	if (test > 0.499*unit)
	{
	    yaw = 2 * atan2(X,W);
	    pitch = 90.0;
	    roll = 0.0;
	}
	else if (test < -0.499*unit)
	{
	    yaw = -2 * atan2(X,W);
		pitch = -90.0;
		roll = 0.0;
	}
	else
	{
	
	/*

	*/
		yaw = atan2(2.0*Y*W - 2.0*X*Z, sqx - sqy - sqz + sqw);
		pitch = -asin(2.0*test/unit);
		roll = atan2(2.0*X*W - 2.0*Y*Z, 1-sqx + sqy - sqz + sqw);
	}
	
	yaw = 180.0 + yaw;
}

static stock GetRotFromAim(Float:vecAim[3], &Float:yaw, &Float:pitch, &Float:roll)
{
	yaw = atan2(vecAim[0], -vecAim[1]) + 180.0;
	pitch = -asin(vecAim[2]);
	roll = pitch * (-floatsin(yaw, degrees));
	pitch = pitch * floatcos(yaw, degrees);
}

static stock GetAimFromRot(Float:yaw, Float:pitch, Float:out[3])
{
	out[0] = -(floatsin(yaw, degrees)*floatcos(pitch, degrees));
	out[1] = floatcos(yaw, degrees)*floatcos(pitch, degrees);
	out[2] = floatsin(pitch, degrees);
}

static stock GetAimVectorFromQuat(Float:quat[4], Float:aim[3])
{
    new Float:yaw, Float:pitch, Float:roll;
    GetRotFromQuat(quat, yaw, pitch, roll);
    GetAimFromRot(yaw, pitch, aim);
}

new usedSlots[(MAX_SLOTS + 3)/4];

forward Timer_FreeSlot(slot);
public Timer_FreeSlot(slot)
{
	if (!IsPlayerConnected(slot))
	{
		new BitStream:stream = BS_New();
	    BS_WriteValue(stream, RNM_INT16, slot);
	    BS_RPC(stream, -1, RPC_WorldPlayerRemove);
		BS_Delete(stream);

		stream = BS_New();
	    BS_WriteValue(stream, RNM_INT16, slot);
		BS_WriteValue(stream, RNM_INT8, 0);
	    BS_RPC(stream, -1, RPC_ServerQuit);
		BS_Delete(stream);

		FreeSlot(slot);
	}
}

stock GetValidSlot()
{
	new validId = -1;
	for (new i = MAX_SLOTS - 1; validId == -1 && i > -1; i--)
	{
	    if (!IsPlayerConnected(i))
	    {
	        if (usedSlots{i} == 0)
	        {
	            validId = i;
         	}
	    }
	}
	
	return validId;
}

stock TakeSlot(slot)
{
	if (slot > -1 && slot < 1004)
	    usedSlots{slot} = 1;
}

stock FreeSlot(slot)
{
	if (slot > -1 && slot < 1004)
	    usedSlots{slot} = 0;
}

stock RPG_FireAimQuat(Float:vecFrom[3], Float:vecAim[3], Float:quat[4], Float:vecSpeed[3], skinId = 0, liveTime = 1000, worldId = -1, interiorId = -1, Float:stream_distance = 300.0)
{
    new BitStream:bsJoin, BitStream:bsAdd, BitStream:bsOnFoot, BitStream:bsAim, slot, Float:rot[3];

	slot = GetValidSlot();

	new Float:mQuat[4];
	mQuat[0] = 0.0;
	mQuat[1] = 0.0;
	mQuat[2] = 0.0;
	mQuat[3] = 0.0;

	if (slot != -1)
	{
	    TakeSlot(slot);

 		//GetRotFromAim(quat, rot[0], rot[1], rot[2]);

		bsJoin = BS_New();
		
		BS_WriteValue(bsJoin, RNM_INT16, slot);//playerid
		BS_WriteValue(bsJoin, RNM_INT8, -1); //unknown
		BS_WriteValue(bsJoin, RNM_INT8, 0); //isNPC
		BS_WriteValue(bsJoin, RNM_INT8, 0); //nameLen

		bsAdd = BS_New();
		BS_WriteValue(bsAdd, RNM_INT16, slot);
		BS_WriteValue(bsAdd, RNM_INT8, -1); //team
		BS_WriteValue(bsAdd, RNM_INT8, 23); //skin
		BS_WriteValue(bsAdd, RNM_FLOAT, vecFrom[0]);
		BS_WriteValue(bsAdd, RNM_FLOAT, vecFrom[1]);
		BS_WriteValue(bsAdd, RNM_FLOAT, vecFrom[2]);
		BS_WriteValue(bsAdd, RNM_FLOAT, rot[0]); //facingAngle
		BS_WriteValue(bsAdd, RNM_INT8, -1); //color
		BS_WriteValue(bsAdd, RNM_INT8, 4); //fightingStyle
		static unkArray[11] = {0xC8, 0xC8, 0xC8, 0xC8, 0xC8, 0xC8, 0xC8, 0xC8, 0xC8, 0xC8, 0xC8};
		BS_WriteValue(bsAdd, RNM_UINT8, unkArray, sizeof(unkArray));
		
  		bsOnFoot = BS_New();
		BS_WriteValue(bsOnFoot, RNM_UINT8, ID_PLAYER_SYNC); //PacketID
		BS_WriteValue(bsOnFoot, RNM_UINT16, slot); //playerId
		BS_WriteValue(bsOnFoot, RNM_BOOL, false); //hasLR
		//BS_WriteValue(bsOnFoot, RNM_UINT16, 0); //lrAnalog
		BS_WriteValue(bsOnFoot, RNM_BOOL, false); //hasUD
		//BS_WriteValue(bsOnFoot, RNM_UINT16, 0); //udAnalog
		BS_WriteValue(bsOnFoot, RNM_UINT16, 4 | 128); //keys

		BS_WriteValue(bsOnFoot, RNM_FLOAT, vecFrom[0]);
		BS_WriteValue(bsOnFoot, RNM_FLOAT, vecFrom[1]);
		BS_WriteValue(bsOnFoot, RNM_FLOAT, vecFrom[2]);
		BS_WriteValue(bsOnFoot, RNM_FLOAT, mQuat); //quat

		BS_WriteValue(bsOnFoot, RNM_INT8, 0xF); //health/armour

		BS_WriteValue(bsOnFoot, RNM_INT8, 35); //weapon
		BS_WriteValue(bsOnFoot, RNM_INT8, 0); //specialAction

		BS_WriteValue(bsOnFoot, RNM_FLOAT, vecSpeed[0]); //moveSpeed
		BS_WriteValue(bsOnFoot, RNM_FLOAT, vecSpeed[1]); //moveSpeed
		BS_WriteValue(bsOnFoot, RNM_FLOAT, vecSpeed[2]); //moveSpeed
		
		BS_WriteValue(bsOnFoot, RNM_BOOL, false); //hasSurfInfo
		BS_WriteValue(bsOnFoot, RNM_BOOL, false); //hasAnimation
		//WriteToBitStream(bsOnFoot, BS_INT, 0x800404A5); //animation

	    bsAim = BS_New();
	    BS_WriteValue(bsAim, RNM_UINT8, ID_AIM_SYNC); //PacketID
		BS_WriteValue(bsAim, RNM_UINT16, slot); //playerId
	    BS_WriteValue(bsAim, RNM_UINT8, 4); //CamMode
	    BS_WriteValue(bsAim, RNM_FLOAT, vecAim[0]); //AimF1.X
	    BS_WriteValue(bsAim, RNM_FLOAT, vecAim[1]); //AimF1.Y
	    BS_WriteValue(bsAim, RNM_FLOAT, vecAim[2]); //AimF1.Z
		BS_WriteValue(bsAim, RNM_FLOAT, vecFrom[0]);
		BS_WriteValue(bsAim, RNM_FLOAT, vecFrom[1]);
		BS_WriteValue(bsAim, RNM_FLOAT, vecFrom[2]);
		BS_WriteValue(bsAim, RNM_FLOAT, 0); //fAimZ
		BS_WriteValue(bsAim, RNM_UINT8, 0xFF); //ExtZoom : 6 / weapoonState : 2
		BS_WriteValue(bsAim, RNM_UINT8, 0x55);//bUnk

		for (new i = 0; i < (MAX_SLOTS - 4); i++)
		{
		    if (IsPlayerConnected(i))
		    {
		        if (worldId == -1 || (GetPlayerVirtualWorld(i) == worldId))
		        {
		            if (interiorId == -1 || (GetPlayerInterior(i) == interiorId))
		            {
				    	if (GetPlayerDistanceFromPoint(i, vecFrom[0], vecFrom[1], vecFrom[2]) <= stream_distance)
				    	{
				    	    BS_RPC(bsJoin, i, RPC_ServerJoin);
				    	    BS_RPC(bsAdd, i, RPC_WorldPlayerAdd);
				    	    BS_Send(bsOnFoot, i, HIGH_PRIORITY, UNRELIABLE_SEQUENCED);
				    	    BS_Send(bsAim, i);
				    	}
			    	}
		    	}
	    	}
		}

		BS_Delete(bsJoin);
		BS_Delete(bsAdd);
        BS_Delete(bsOnFoot);
        BS_Delete(bsAim);

		SetTimerEx("Timer_FreeSlot", liveTime, false, "i", slot);
	}
}

stock RPG_FireQuat(Float:vecPos[3], Float:quat[4], Float:vecSpeed[3], skinId = 0, liveTime = 1000, worldId = -1, interiorId = -1, Float:stream_distance = 300.0)
{
	new Float:aim[3];
    GetAimVectorFromQuat(quat, aim);
    RPG_FireAimQuat(vecPos, aim, quat, vecSpeed, skinId, liveTime, worldId, interiorId, stream_distance);
}

stock RPG_FireAim(Float:vecFrom[3], Float:vecAim[3], Float:vecSpeed[3], skinId = 0, liveTime = 1000, worldId = -1, interiorId = -1, Float:stream_distance = 300.0)
{
	new Float:quat[4], Float:rot[3];
	GetRotFromAim(vecAim, rot[0], rot[1], rot[2]);
	GetQuatFromRot(rot[0], rot[1], rot[2], quat);
	RPG_FireAimQuat(vecFrom, vecAim, quat, vecSpeed, skinId, liveTime, worldId, interiorId, stream_distance);
}

stock RPG_FireFromTo(Float:vecFrom[3], Float:vecTo[3], Float:vecSpeed[3], skinId = 0, liveTime = 1000, worldId = -1, interiorId = -1, Float:stream_distance = 300.0)
{
	new Float:aim[3];
	GetAimVector(vecFrom, vecTo, aim);
	RPG_FireAim(vecFrom, aim, vecSpeed, skinId, liveTime, worldId, interiorId, stream_distance);
}

stock RPG_FireRot(Float:vecPos[3], Float:vecSpeed[3], Float:vecRot[3], skinId = 0, liveTime = 1000, worldId = -1, interiorId = -1, Float:stream_distance = 300.0)
{
	new Float:quat[4];
	GetQuatFromRot(vecRot[0], vecRot[1], vecRot[2], quat);
	RPG_FireQuat(vecPos, quat, vecSpeed, skinId, liveTime, worldId, interiorId, stream_distance);
}

stock RPG_Fire(playerid)
{
	new Float:vecPos[3];
	new Float:vecSpeed[3];
	new Float:angle;
	new Float:quat[4];
	new Float:aim[3];
	
	if (IsPlayerInAnyVehicle(playerid))
	{
	    new vid = GetPlayerVehicleID(playerid);
	    GetVehiclePos(vid, vecPos[0], vecPos[1], vecPos[2]);
	    GetVehicleVelocity(vid, vecSpeed[0], vecSpeed[1], vecSpeed[2]);
	    GetVehicleZAngle(vid, angle);
	    GetVehicleRotationQuat(vid, quat[0], quat[1], quat[2], quat[3]);

        GetAimVectorFromQuat(quat, aim);
        
        vecPos[0] += 6.5*aim[0];
		vecPos[1] += 6.5*aim[1];
		vecPos[2] += 6.5*aim[2] + 0.1;
		
		vecSpeed[0] += 0.15*aim[0];
		vecSpeed[1] += 0.15*aim[1];
		vecSpeed[2] += 0.15*aim[2];
		
		RPG_FireAimQuat(vecPos, aim, quat, vecSpeed, random(300), 1000);
	}
	else
	{
	    GetPlayerPos(playerid, vecPos[0], vecPos[1], vecPos[2]);
	    GetPlayerVelocity(playerid, vecSpeed[0], vecSpeed[1], vecSpeed[2]);
	    GetPlayerFacingAngle(playerid, angle);
	    
		GetPlayerCameraFrontVector(playerid, aim[0], aim[1], aim[2]);

	    vecPos[0] += 2.5;
		vecPos[1] += 2.5;
		vecPos[2] += 0.5;
		
		RPG_FireAim(vecPos, aim, vecSpeed, random(300), 1000);
	}	
}
#endif
