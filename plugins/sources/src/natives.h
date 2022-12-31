/*
 * Copyright (C) 2012 Incognito
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef NATIVES_H
#define NATIVES_H

#include <sdk/plugin.h>

#define CHECK_PARAMS(m, n) \
	if (params[0] != (m * 4)) \
	{ \
		logprintf("*** %s: Expecting %d parameter(s), but found %d", n, m, params[0] / 4); \
		return 0; \
	}

namespace Natives
{
	cell AMX_NATIVE_CALL RZClient_CreateTCPServer(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_DestroyTCPServer(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_SetPack(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_IsClientConnected(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_StopSync(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_StartSync(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_SendMessage(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_TransferPack(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_CreateSequence(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_DestroySequence(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_AddToSequence(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_RemoveFromSequence(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_Play(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_PlayStreamed(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_PlaySequence(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_Pause(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_Resume(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_Stop(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_Restart(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_GetPosition(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_SetPosition(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_SetVolume(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_SetFX(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_RemoveFX(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_Set3DPosition(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_Remove3DPosition(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_SetRadioStation(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_StopRadio(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_AddPlayer(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_RenamePlayer(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_RemovePlayer(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_checkFile(AMX *amx, cell *params);
	cell AMX_NATIVE_CALL RZClient_getFiles(AMX *amx, cell *params);
};

#endif
