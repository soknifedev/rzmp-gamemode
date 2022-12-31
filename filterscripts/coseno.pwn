#include <a_samp>
#include <crashdetect>
#include <streamer>
#include <mapandreas>

#pragma tabsize 0
new Fmsg[256];
#define SendFormatMessageToAll(%1,%2,%3) format(Fmsg, sizeof(Fmsg),%2,%3) && SendClientMessageToAll(%1,Fmsg)


//Utilice este filterscript para desarrollar el algoritmo que permite generar zombies en circulo!! fue una divertida aventura XD
//-knife


stock randomEx(min, max)
{
    new rand = random(max-min)+min;
    return rand;
}



stock NextCirclePosition(Float:x, Float:y, Float:offset, &Float:nx, &Float:ny, &Float:angle, Float:radius)
{
	nx = x + radius * floatcos(angle, degrees );
	ny = y + radius * floatsin(angle, degrees );
	angle += offset;
}


public OnPlayerCommandText(playerid, cmdtext[])
{
	new idx;
	new cmd[256];

	cmd = strtok(cmdtext, idx);

	if(strcmp(cmd, "/d", true) == 0) {
		new Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid,x,y,z);
		GetPlayerFacingAngle(playerid, a);
		new ZOMBIES = 30;

		new Float:offset = 360.0 / ZOMBIES;


		new Float:nx,Float:ny,Float:nz;

		for(new i = 0; i < ZOMBIES; i++)
		{
			new Float:radius = 10;//float(randomEx(35, 50));

			NextCirclePosition(x, y, offset, nx, ny, a, radius);
			MapAndreas_FindZ_For2DCoord(nx, ny, nz);
			z += 1;

			CreateDynamicObject(1339, nx, ny, nz, 0, 0, 0);
			SendFormatMessageToAll(-1,"[D][%d]: X: %.4f, Y: %.4f, Z: %.4f, A: %.2f, offset: %.4f", i, nx, ny, nz, a, offset);
		}
    	return 1;
	}
	if(strcmp(cmd, "/e", true) == 0) {
		new Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid,x,y,z);
		GetPlayerFacingAngle(playerid, a);
		new ZOMBIES = 5;
		//new Float:offset = (randomEx(-floatround(a) , floatround(a)) + a);

		new Float:offset = 360.0 / ZOMBIES;


		new Float:nx,Float:ny,Float:nz;

		for(new i = 0; i < ZOMBIES; i++)
		{
			new Float:radius = 10;//float(randomEx(35, 50));

			nx = x + radius * floatcos(a, degrees );
			ny = y + radius * floatsin(a, degrees );
			MapAndreas_FindZ_For2DCoord(x, y, nz);
			z += 1;

			CreateDynamicObject(1339, nx, ny, nz, 0, 0, 0);
			SendFormatMessageToAll(-1,"[E][%d]: X: %.4f, Y: %.4f, Z: %.4f, A: %.2f, offset: %.4f", i, nx, ny, nz, a, offset);
			a += offset;
		}
    	return 1;
	}


	if(strcmp(cmd, "/f", true) == 0) {
		new Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid,x,y,z);
		GetPlayerFacingAngle(playerid, a);
		new ZOMBIES = 30;
		//new Float:offset = (randomEx(-floatround(a) , floatround(a)) + a);

		new Float:offset = 360.0 / ZOMBIES;


		new Float:nx,Float:ny,Float:nz;

		for(new i = 0; i < ZOMBIES; i++)
		{
			new Float:radius = 10;//float(randomEx(10, 50));

			nx = x + radius * floatcos(a, degrees );
			ny = y + radius * floatsin(a, degrees );
			MapAndreas_FindZ_For2DCoord(x, y, nz);
			z += 1;

			CreateDynamicObject(1339, nx, ny, nz, 0, 0, 0);
			SendFormatMessageToAll(-1,"[F][%d]: X: %.4f, Y: %.4f, Z: %.4f, A: %.2f, offset: %.4f", i, nx, ny, nz, a, offset);
			a += offset;
		}
    	return 1;
	}

	if(strcmp(cmd, "/a", true) == 0) {
		new Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid,x,y,z);
		GetPlayerFacingAngle(playerid, a);
		new ZOMBIES = 30;

		new Float:offset = 360.0 / ZOMBIES;


		new Float:nx,Float:ny,Float:nz;

		for(new i = 0; i < ZOMBIES; i++)
		{
			new Float:radius = 10;//float(randomEx(35, 50));

			NextCirclePosition(x, y, offset, nx, ny, a, radius);
			MapAndreas_FindZ_For2DCoord(x, y, nz);
			z += 1;

			CreateDynamicObject(1339, nx, ny, nz, 0, 0, 0);
			SendFormatMessageToAll(-1,"[A][%d]: X: %.4f, Y: %.4f, Z: %.4f, A: %.2f, offset: %.4f", i, nx, ny, nz, a, offset);
		}
    	return 1;
	}
	if(strcmp(cmd, "/b", true) == 0) {
		new Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid,x,y,z);
		GetPlayerFacingAngle(playerid, a);
		new ZOMBIES = 5;
		//new Float:offset = (randomEx(-floatround(a) , floatround(a)) + a);


		new Float:radius = 15;//float(randomEx(5, 10));
new Float:nx,Float:ny,Float:nz;
		for(new i = 0; i < ZOMBIES; i++)
		{

			new Float:offset = float(random(360));
			nx = x + radius * floatcos(-offset, degrees );
			ny = y + radius * floatsin(-offset, degrees );
			MapAndreas_FindZ_For2DCoord(x, y, nz);
			z += 1;

			CreateDynamicObject(1339, nx, ny, nz, 0, 0, 0);
			SendFormatMessageToAll(-1,"[B][%d]: X: %.4f, Y: %.4f, Z: %.4f, A: %.2f, offset: %.4f", i, nx, ny, nz, a, offset);

		}
    	return 1;
	}
	if(strcmp(cmd, "/c", true) == 0) {
		new Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid,x,y,z);
		GetPlayerFacingAngle(playerid, a);
		new ZOMBIES = 5;
		new Float:offset = (randomEx(-floatround(a) , floatround(a)) + a);



		new Float:nx,Float:ny,Float:nz;
		for(new i = 0; i < ZOMBIES; i++)
		{
			new Float:radius = 15;//float(randomEx(5, 10));
			nx = (( x + floatcos(offset, degrees ) * radius) );
			ny = (( y + floatsin(offset, degrees ) * radius) );
			MapAndreas_FindZ_For2DCoord(nx, ny, nz);
			nz += 1;

			CreateDynamicObject(1339, nx, ny, nz, 0, 0, 0);
			SendFormatMessageToAll(-1,"[C][%d]: X: %.4f, Y: %.4f, Z: %.4f, A: %.2f, offset: %.4f", i, nx, ny, nz, a, offset);
			offset += (randomEx(-floatround(a) , floatround(a)) + a );
		}
    	return 1;
	}
	return 0;
}







strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}
