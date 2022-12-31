
#include <a_samp>



#define INVALID_ICAMERA_ID 0
#define MAX_ICAMERAS 100
#define MAX_ICAMERA_NODES 100

#define INVALID_ICAMERA_NODE_POS 0
#define INVALID_ICAMERA_NODE_ID 0
#define DEFAULT_ICAMERA_NODE_TIME 5000

#define ICAMERA_ERROR_NOCAMERA 1
#define ICAMERA_ERROR_NONODES 2

enum enumiCameraInfo
{
	icameraId = INVALID_ICAMERA_ID,
	bool:IsMoving = false,
	Float:fx = INVALID_ICAMERA_NODE_POS,
	Float:fy = INVALID_ICAMERA_NODE_POS,
	Float:fz = INVALID_ICAMERA_NODE_POS,
	Float:flx = INVALID_ICAMERA_NODE_POS,
	Float:fly = INVALID_ICAMERA_NODE_POS,
	Float:flz = INVALID_ICAMERA_NODE_POS,

	Float:tx = INVALID_ICAMERA_NODE_POS,
	Float:ty = INVALID_ICAMERA_NODE_POS,
	Float:tz = INVALID_ICAMERA_NODE_POS,
	Float:tlx = INVALID_ICAMERA_NODE_POS,
	Float:tly = INVALID_ICAMERA_NODE_POS,
	Float:tlz = INVALID_ICAMERA_NODE_POS
}

new iCameraInfo[MAX_ICAMERAS][MAX_ICAMERA_NODES][enumiCameraInfo];


stock iCamera_AssignNodes(icamid)
{
	new assignedNodes = 0;
	for(new inode=0;inode<MAX_ICAMERA_NODES;inode++)
	{
		if(iCameraInfo[icamid][inode][used] == false)
		{
			/*if(iCameraInfo[icamid][inode][fx] == INVALID_ICAMERA_NODE_POS && iCameraInfo[icamid][inode][fy] == INVALID_ICAMERA_NODE_POS && iCameraInfo[icamid][inode][fz] == INVALID_ICAMERA_NODE_POS && 
			   iCameraInfo[icamid][inode][flx] == INVALID_ICAMERA_NODE_POS && iCameraInfo[icamid][inode][fly] == INVALID_ICAMERA_NODE_POS && iCameraInfo[icamid][inode][flz] == INVALID_ICAMERA_NODE_POS && 
			   iCameraInfo[icamid][inode][tx] == INVALID_ICAMERA_NODE_POS && iCameraInfo[icamid][inode][ty] == INVALID_ICAMERA_NODE_POS && iCameraInfo[icamid][inode][tz] == INVALID_ICAMERA_NODE_POS && 
			   iCameraInfo[icamid][inode][tlx] == INVALID_ICAMERA_NODE_POS && iCameraInfo[icamid][inode][tly] == INVALID_ICAMERA_NODE_POS && iCameraInfo[icamid][inode][tlz] == INVALID_ICAMERA_NODE_POS)
			{*/

				iCameraInfo[icamid][inode][used] = false;

				iCameraInfo[icamid][inode][icameraId] = icamid;
				iCameraInfo[icamid][inode][nodetime] = DEFAULT_ICAMERA_NODE_TIME;

				iCameraInfo[icamid][inode][fx] = INVALID_ICAMERA_NODE_POS;
				iCameraInfo[icamid][inode][fy] = INVALID_ICAMERA_NODE_POS;
				iCameraInfo[icamid][inode][fz] = INVALID_ICAMERA_NODE_POS;
				iCameraInfo[icamid][inode][flx] = INVALID_ICAMERA_NODE_POS;
				iCameraInfo[icamid][inode][fly] = INVALID_ICAMERA_NODE_POS;
				iCameraInfo[icamid][inode][flz] = INVALID_ICAMERA_NODE_POS;

				iCameraInfo[icamid][inode][tx] = INVALID_ICAMERA_NODE_POS;
				iCameraInfo[icamid][inode][ty] = INVALID_ICAMERA_NODE_POS;
				iCameraInfo[icamid][inode][tz] = INVALID_ICAMERA_NODE_POS;
				iCameraInfo[icamid][inode][tlx] = INVALID_ICAMERA_NODE_POS;
				iCameraInfo[icamid][inode][tly] = INVALID_ICAMERA_NODE_POS;
				iCameraInfo[icamid][inode][tlz] = INVALID_ICAMERA_NODE_POS;

				assignedNodes++;
			//}
		}
	}
	return assignedNodes;
}

stock iCamera_Exists(icamid)
{
	for(new i = 0; i < MAX_ICAMERAS; i++)
	{
		if(iCameraInfo[i][cameraid] == icamid)
		{
			return true;
		}
	}
	return false;
}

stock iCamera_Create()
{
	new icamid = INVALID_ICAMERA_ID;
	for(new i = 0; i < MAX_ICAMERAS; i++)
	{
		if(iCameraInfo[i][cameraid] == INVALID_ICAMERA_ID)
		{
			icamid = i;
			if(iCamera_AssignNodes(icamid) >= 1) return icamid;
			printf("[iCamera_Create]: Error while creating the icamera: wasn't possible to assign nodes to the camera.");
			else return INVALID_ICAMERA_ID;
		}
	}
	printf("[iCamera_Create]: Error while creating the icamera: MAX %d limit reached.", MAX_ICAMERAS);
	return INVALID_ICAMERA_ID;
}



stock iCamera_GetUsedNodes(icamid)
{
	new usedNodes = 0;
	if(icamid == INVALID_ICAMERA_ID) return 0;
	for(new inode=0;inode<MAX_ICAMERA_NODES;inode++)
	{
		if(iCameraInfo[icamid][inode][cameraId] == icamid && iCameraInfo[icamid][inode][used] == true)
		{
			/*if(iCameraInfo[icamid][inode][fx] != INVALID_ICAMERA_NODE_POS && iCameraInfo[icamid][inode][fy] != INVALID_ICAMERA_NODE_POS && iCameraInfo[icamid][inode][fz] != INVALID_ICAMERA_NODE_POS && 
			   iCameraInfo[icamid][inode][flx] != INVALID_ICAMERA_NODE_POS && iCameraInfo[icamid][inode][fly] != INVALID_ICAMERA_NODE_POS && iCameraInfo[icamid][inode][flz] != INVALID_ICAMERA_NODE_POS && 
			   iCameraInfo[icamid][inode][tx] != INVALID_ICAMERA_NODE_POS && iCameraInfo[icamid][inode][ty] != INVALID_ICAMERA_NODE_POS && iCameraInfo[icamid][inode][tz] != INVALID_ICAMERA_NODE_POS && 
			   iCameraInfo[icamid][inode][tlx] != INVALID_ICAMERA_NODE_POS && iCameraInfo[icamid][inode][tly] != INVALID_ICAMERA_NODE_POS && iCameraInfo[icamid][inode][tlz] != INVALID_ICAMERA_NODE_POS)
			{*/
				usedNodes++;
			//}
		}
	}
	return usedNodes;
}

stock iCamera_GetAvailableNode(icamid)
{
	for(new inode=0;inode<MAX_ICAMERA_NODES;inode++)
	{
		if(iCameraInfo[icamid][inode][cameraId] == icamid && iCameraInfo[icamid][inode][used] != true)
		{
			/*if(iCameraInfo[icamid][inode][fx] == INVALID_ICAMERA_NODE_POS && iCameraInfo[icamid][inode][fy] == INVALID_ICAMERA_NODE_POS && iCameraInfo[icamid][inode][fz] == INVALID_ICAMERA_NODE_POS && 
			   iCameraInfo[icamid][inode][flx] == INVALID_ICAMERA_NODE_POS && iCameraInfo[icamid][inode][fly] == INVALID_ICAMERA_NODE_POS && iCameraInfo[icamid][inode][flz] == INVALID_ICAMERA_NODE_POS && 
			   iCameraInfo[icamid][inode][tx] == INVALID_ICAMERA_NODE_POS && iCameraInfo[icamid][inode][ty] == INVALID_ICAMERA_NODE_POS && iCameraInfo[icamid][inode][tz] == INVALID_ICAMERA_NODE_POS && 
			   iCameraInfo[icamid][inode][tlx] == INVALID_ICAMERA_NODE_POS && iCameraInfo[icamid][inode][tly] == INVALID_ICAMERA_NODE_POS && iCameraInfo[icamid][inode][tlz] == INVALID_ICAMERA_NODE_POS)
			{*/
				return i;
			//}
		}
	}
	return INVALID_ICAMERA_NODE_ID;
}

stock iCamera_DelNode(icamid, inode)
{
	if(iCameraInfo[icamid][inode][used] == true)
	{
		return iCameraInfo[icamid][inode][used] = false;
	}
	else return false;
}

stock iCamera_AddNode(icamid, Float:startposx, Float:startposy, Float:startposz, Float:startlookx, Float:startlooky, Float:startlookz, Float:toposx, Float:toposy, Float:toposz, Float:tolookx, Float:tolooky, Float:tolookz, interpolation_time=DEFAULT_ICAMERA_NODE_TIME)
{
	new inode = iCamera_GetAvailableNode(icamid);
	if(nodeId == INVALID_ICAMERA_NODE_ID){
		printf("[iCamera_AddNode]: Error while adding position node to icamera (%d): MAX %d cameras limit reached.", MAX_ICAMERAS);
		return INVALID_ICAMERA_NODE_POS;
	}
	iCameraInfo[icamid][inode][fx] = startposx;

	iCameraInfo[icamid][inode][fx] = startposx;
	iCameraInfo[icamid][inode][fy] = startposy;
	iCameraInfo[icamid][inode][fz] = startposz;
	iCameraInfo[icamid][inode][flx] = startlookx;
	iCameraInfo[icamid][inode][fly] = startlooky;
	iCameraInfo[icamid][inode][flz] = startlookz;

	iCameraInfo[icamid][inode][tx] = toposx;
	iCameraInfo[icamid][inode][ty] = toposy;
	iCameraInfo[icamid][inode][tz] = toposz;
	iCameraInfo[icamid][inode][tlx] = tolookx;
	iCameraInfo[icamid][inode][tly] = tolooky;
	iCameraInfo[icamid][inode][tlz] = tolookz;

	iCameraInfo[icamid][inode][nodetime] = interpolation_time;
	iCameraInfo[icamid][inode][used] = true;
	return nodeId;
}


stock iCamera_Play(playerid, icamid)
{
	if(!iCamera_Exists(icamid)) retrun ICAMERA_ERROR_NOCAMERA;
	if(iCamera_GetUsedNodes(icamid) >= 0) return ICAMERA_ERROR_NONODES;


}