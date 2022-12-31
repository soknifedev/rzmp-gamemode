/*
HUD-less Camera System
by MP2

Set a player's camera WITHOUT THE HUD!

Version: 3.0 (3th of April 2013)


HOW IT WORKS

There are 3 ways to set a camera:

	- Set (SetPlayerCamera)
		• Set a player's camera instantly to a static location
		
	- Move (SetPlayerCamera: )
		• Move (interpolate) a player's camera from it's current position to a new one
		
	- Interpolate (InterpolatePlayerCamera)
		• Like Move but with a specified delay. Doesn't interpolate from current pos,
		can interpolate from anywhere, TO anywhere.
	
To remove the HUD, the player is placed in to 'spectator mode'.
When in spectator mode and not spectating a player/vehicle, the player will see
a bridge, which I refer to as 'Spectator's Bridge'. If you set the player's camera
straight away, it will not work; they will be staring at that brige.
To get around this, you have to have a small delay. A timer would be your first thought
(as it was mine) but I use OnPlayerUpdate (hooked) as if a player was paused when
their camera was set, when they resume the game they will be still staring at
Spectator's Bridge. This fixes that.

This include can be used for many things:
- Login screens
- Ban screens
- Tutorials
- 'CCTV' cameras
- Menus
- Cutscenes
- and whatever else your imagination can think of!

If you have any suggestions, have found a bug (problem/issue) or just want to give some feedback
(negative or positive, I'm always open to advice!)
feel free to do so here: http://forum.sa-mp.com/showthread.php?p=2362690

Enjoy!

*/

// This include uses y_hooks by Y_Less (part of the 'YSI' library)
// You will need it. Google it.
#include <YSI\y_hooks>

new pUpdateCam[MAX_PLAYERS]; // Cam needs setting? See defines below
#define CAMUPDATE_NONE 0
#define CAMUPDATE_SET 1 // Just set the camera (static)
#define CAMUPDATE_MOVE 2 // 'CAMERA_MOVE' in SetPlayerCameraLookAt (reset to old pos)
#define CAMUPDATE_MOVE2 3 // 'CAMERA_MOVE' in SetPlayerCameraLookAt (move to new pos)
#define CAMUPDATE_INTERPOLATE 4 // Interpolation starts

enum E_CAMUPDATE_COORDS
{
	Float:CAMUPDATE_camPos[3],
	Float:CAMUPDATE_camLook[3],
	Float:CAMUPDATE_camPosNEW[3], // For interpolation (AFTER POS)
	Float:CAMUPDATE_camLookNEW[3] // For interpolation (AFTER LOOK)
}
new Float:pUpdateCamCoords[MAX_PLAYERS][E_CAMUPDATE_COORDS]; // Camera coords (pos+lookat)

new CAM_OnPlayerUpdate_Calls[MAX_PLAYERS]; // Times needed to be called (set to 2 on set)

/* FUNCTIONS
native SetPlayerCamera(playerid, Float:x, Float:y, Float:z, Float:lookx, Float:looky, Float:lookz, bool:camera_interpolate=false);

native InterpolatePlayerCamera(playerid, Float:startposx, Float:startposy, Float:startposz, Float:startlookx, Float:startlooky, Float:startlookz, Float:toposx, Float:toposy, Float:toposz, Float:tolookx, Float:tolooky, Float:tolookz, interpolation_time=3000);
*/

// Set a player's camera. If camera_interpolate is true the camera will interpolate (NO TIME CONTROL - see InterpolatePlayerCamera)
stock SetPlayerCamera(playerid, Float:x, Float:y, Float:z, Float:lookx, Float:looky, Float:lookz, bool:camera_interpolate=false)
{
	TogglePlayerSpectating(playerid, true);
	
	if(camera_interpolate == false) // Just set
	{
		pUpdateCam[playerid] = CAMUPDATE_SET;
		
		// Store the new coordinates
		pUpdateCamCoords[playerid][CAMUPDATE_camPos][0] = x;
		pUpdateCamCoords[playerid][CAMUPDATE_camPos][1] = y;
		pUpdateCamCoords[playerid][CAMUPDATE_camPos][2] = z;

		pUpdateCamCoords[playerid][CAMUPDATE_camLook][0] = lookx;
		pUpdateCamCoords[playerid][CAMUPDATE_camLook][1] = looky;
		pUpdateCamCoords[playerid][CAMUPDATE_camLook][2] = lookz;
	}
	else // We will need to re-set the camera to where it currently is
	{
		pUpdateCam[playerid] = CAMUPDATE_MOVE;
		new Float:curx, Float:cury, Float:curz; // Cam pos
		new Float:curvx, Float:curvy, Float:curvz; // Front vector
		GetPlayerCameraPos(playerid, curx, cury, curz);
		GetPlayerCameraFrontVector(playerid, curvx, curvy, curvz);
		
		// NEW coordinates (after setting)
		pUpdateCamCoords[playerid][CAMUPDATE_camPosNEW][0] = x;
		pUpdateCamCoords[playerid][CAMUPDATE_camPosNEW][1] = y;
		pUpdateCamCoords[playerid][CAMUPDATE_camPosNEW][2] = z;

		pUpdateCamCoords[playerid][CAMUPDATE_camLookNEW][0] = lookx;
		pUpdateCamCoords[playerid][CAMUPDATE_camLookNEW][1] = looky;
		pUpdateCamCoords[playerid][CAMUPDATE_camLookNEW][2] = lookz;
		
		// CURRENT coordinates
		pUpdateCamCoords[playerid][CAMUPDATE_camPos][0] = curx;
		pUpdateCamCoords[playerid][CAMUPDATE_camPos][1] = cury;
		pUpdateCamCoords[playerid][CAMUPDATE_camPos][2] = curz;
		
		curx += curvx;
		cury += curvy;
		curz += curvz;

		pUpdateCamCoords[playerid][CAMUPDATE_camLook][0] = curx;
		pUpdateCamCoords[playerid][CAMUPDATE_camLook][1] = cury;
		pUpdateCamCoords[playerid][CAMUPDATE_camLook][2] = curz;
	}
	CAM_OnPlayerUpdate_Calls[playerid] = 3;
	return 1;
}

// Interpolate a player's camera.
stock InterpolatePlayerCamera(playerid, Float:startposx, Float:startposy, Float:startposz, Float:startlookx, Float:startlooky, Float:startlookz, Float:toposx, Float:toposy, Float:toposz, Float:tolookx, Float:tolooky, Float:tolookz, interpolation_time=3000)
{
	TogglePlayerSpectating(playerid, true);
	
	pUpdateCam[playerid] = CAMUPDATE_INTERPOLATE;
	
	pUpdateCamCoords[playerid][CAMUPDATE_camPos][0] = startposx;
	pUpdateCamCoords[playerid][CAMUPDATE_camPos][1] = startposy;
	pUpdateCamCoords[playerid][CAMUPDATE_camPos][2] = startposz;

	pUpdateCamCoords[playerid][CAMUPDATE_camLook][0] = startlookx;
	pUpdateCamCoords[playerid][CAMUPDATE_camLook][1] = startlooky;
	pUpdateCamCoords[playerid][CAMUPDATE_camLook][2] = startlookz;
	
	pUpdateCamCoords[playerid][CAMUPDATE_camPosNEW][0] = toposx;
	pUpdateCamCoords[playerid][CAMUPDATE_camPosNEW][1] = toposy;
	pUpdateCamCoords[playerid][CAMUPDATE_camPosNEW][2] = toposz;
	
	pUpdateCamCoords[playerid][CAMUPDATE_camLookNEW][0] = tolookx;
	pUpdateCamCoords[playerid][CAMUPDATE_camLookNEW][1] = tolooky;
	pUpdateCamCoords[playerid][CAMUPDATE_camLookNEW][2] = tolookz;
	
	SetPVarInt(playerid, "CAM_IP_TIME", interpolation_time);

	CAM_OnPlayerUpdate_Calls[playerid] = 3;
	return 1;
}

hook OnPlayerUpdate(playerid)
{	
	if(CAM_OnPlayerUpdate_Calls[playerid] > 1) // We need to do stuff
	{
		CAM_OnPlayerUpdate_Calls[playerid]--;
		DoPlayerCameraSet(playerid);
	}
	return 1;
}

forward CAM_DoPlayerCameraSet(playerid);
public CAM_DoPlayerCameraSet(playerid)
{
	DoPlayerCameraSet(playerid);
	return 1;
}

stock DoPlayerCameraSet(playerid)
{
	switch(pUpdateCam[playerid])
	{
		case CAMUPDATE_SET:
		{
			SetPlayerCameraPos(playerid, pUpdateCamCoords[playerid][CAMUPDATE_camPos][0], pUpdateCamCoords[playerid][CAMUPDATE_camPos][1], pUpdateCamCoords[playerid][CAMUPDATE_camPos][2]);
			SetPlayerCameraLookAt(playerid, pUpdateCamCoords[playerid][CAMUPDATE_camLook][0], pUpdateCamCoords[playerid][CAMUPDATE_camLook][1], pUpdateCamCoords[playerid][CAMUPDATE_camLook][2]);
		}
		case CAMUPDATE_MOVE:
		{
			// Set it back to the old one first
			SetPlayerCameraPos(playerid, pUpdateCamCoords[playerid][CAMUPDATE_camPos][0], pUpdateCamCoords[playerid][CAMUPDATE_camPos][1], pUpdateCamCoords[playerid][CAMUPDATE_camPos][2]);
			SetPlayerCameraLookAt(playerid, pUpdateCamCoords[playerid][CAMUPDATE_camLook][0], pUpdateCamCoords[playerid][CAMUPDATE_camLook][1], pUpdateCamCoords[playerid][CAMUPDATE_camLook][2]);
			
			if(CAM_OnPlayerUpdate_Calls[playerid] == 1)
			{
				pUpdateCam[playerid] = CAMUPDATE_MOVE2;
				CAM_OnPlayerUpdate_Calls[playerid] = 3;
			}
		}
		case CAMUPDATE_MOVE2:
		{
			// Now move it
			SetPlayerCameraPos(playerid, pUpdateCamCoords[playerid][CAMUPDATE_camPosNEW][0], pUpdateCamCoords[playerid][CAMUPDATE_camPosNEW][1], pUpdateCamCoords[playerid][CAMUPDATE_camPosNEW][2]);
			SetPlayerCameraLookAt(playerid, pUpdateCamCoords[playerid][CAMUPDATE_camLookNEW][0], pUpdateCamCoords[playerid][CAMUPDATE_camLookNEW][1], pUpdateCamCoords[playerid][CAMUPDATE_camLookNEW][2], CAMERA_MOVE);
		}
		case CAMUPDATE_INTERPOLATE:
		{
			InterpolateCameraPos(playerid,
			pUpdateCamCoords[playerid][CAMUPDATE_camPos][0], pUpdateCamCoords[playerid][CAMUPDATE_camPos][1], pUpdateCamCoords[playerid][CAMUPDATE_camPos][2],
			pUpdateCamCoords[playerid][CAMUPDATE_camPosNEW][0], pUpdateCamCoords[playerid][CAMUPDATE_camPosNEW][1], pUpdateCamCoords[playerid][CAMUPDATE_camPosNEW][2],
			GetPVarInt(playerid, "CAM_IP_TIME"), CAMERA_MOVE);

			InterpolateCameraLookAt(playerid,
			pUpdateCamCoords[playerid][CAMUPDATE_camLook][0], pUpdateCamCoords[playerid][CAMUPDATE_camLook][1], pUpdateCamCoords[playerid][CAMUPDATE_camLook][2],
			pUpdateCamCoords[playerid][CAMUPDATE_camLookNEW][0], pUpdateCamCoords[playerid][CAMUPDATE_camLookNEW][1], pUpdateCamCoords[playerid][CAMUPDATE_camLookNEW][2],
			GetPVarInt(playerid, "CAM_IP_TIME"), CAMERA_MOVE);
			
			DeletePVar(playerid, "CAM_IP_TIME"); // No longer needed.
		}
	}
}