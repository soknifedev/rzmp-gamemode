
/*
* Determines if a weaponId is capable of killking a player with an headshot!
*/
stock IsHeadshotPossible(weaponId)
{
    if( weaponId == 34 || 
		weaponId == 33 || 
		weaponId == 24 || 
		weaponId == 25 ||
		weaponId == 23 ||
		weaponId == 31 ||
		weaponId == 30 ||
		weaponId == 29 ||
		weaponId == 27 ) return 1;
    else return 0;
}
