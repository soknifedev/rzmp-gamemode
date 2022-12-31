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

#include "main.h"

#include "core.h"
#include "natives.h"

#include <sdk/plugin.h>

#include <set>
#include <string>
#include <vector>

logprintf_t logprintf;

PLUGIN_EXPORT unsigned int PLUGIN_CALL Supports()
{
	return SUPPORTS_VERSION | SUPPORTS_AMX_NATIVES | SUPPORTS_PROCESS_TICK;
}

PLUGIN_EXPORT bool PLUGIN_CALL Load(void **ppData)
{
	core.reset(new Core);
	pAMXFunctions = ppData[PLUGIN_DATA_AMX_EXPORTS];
	logprintf = (logprintf_t)ppData[PLUGIN_DATA_LOGPRINTF];
	logprintf("\n\n*** RZClient v%s by SASRicardo Cargado ***\n", PLUGIN_VERSION);
	return true;
}

PLUGIN_EXPORT void PLUGIN_CALL Unload()
{
	core.reset();
	logprintf("\n\n*** RZClient v%s by SASRicardo Descargado***\n", PLUGIN_VERSION);
}

AMX_NATIVE_INFO natives[] =
{
	{ "RZClient_CreateTCPServer", Natives::RZClient_CreateTCPServer },
	{ "RZClient_DestroyTCPServer", Natives::RZClient_DestroyTCPServer },
	{ "RZClient_SetPack", Natives::RZClient_SetPack },
	{ "RZClient_IsClientConnected", Natives::RZClient_IsClientConnected },
	/*{ "RZClient_StopSync", Natives::RZClient_StopSync },
	{ "RZClient_StartSync", Natives::RZClient_StartSync },*/
	{ "RZClient_SendMessage", Natives::RZClient_SendMessage },
	{ "RZClient_TransferPack", Natives::RZClient_TransferPack },
	{ "RZClient_CreateSequence", Natives::RZClient_CreateSequence },
	{ "RZClient_DestroySequence", Natives::RZClient_DestroySequence },
	{ "RZClient_AddToSequence", Natives::RZClient_AddToSequence },
	{ "RZClient_RemoveFromSequence", Natives::RZClient_RemoveFromSequence },
	{ "RZClient_Play", Natives::RZClient_Play },
	{ "RZClient_PlayStreamed", Natives::RZClient_PlayStreamed },
	{ "RZClient_PlaySequence", Natives::RZClient_PlaySequence },
	{ "RZClient_Pause", Natives::RZClient_Pause },
	{ "RZClient_Resume", Natives::RZClient_Resume },
	{ "RZClient_Stop", Natives::RZClient_Stop },
	{ "RZClient_Restart", Natives::RZClient_Restart },
	{ "RZClient_GetPosition", Natives::RZClient_GetPosition },
	{ "RZClient_SetPosition", Natives::RZClient_SetPosition },
	{ "RZClient_SetVolume", Natives::RZClient_SetVolume },
	{ "RZClient_SetFX", Natives::RZClient_SetFX },
	{ "RZClient_RemoveFX", Natives::RZClient_RemoveFX },
	{ "RZClient_Set3DPosition", Natives::RZClient_Set3DPosition },
	{ "RZClient_Remove3DPosition", Natives::RZClient_Remove3DPosition },
	{ "RZClient_SetRadioStation", Natives::RZClient_SetRadioStation },
	{ "RZClient_StopRadio", Natives::RZClient_StopRadio },
	{ "RZClient_AddPlayer", Natives::RZClient_AddPlayer },
	{ "RZClient_RenamePlayer", Natives::RZClient_RenamePlayer },
	{ "RZClient_RemovePlayer", Natives::RZClient_RemovePlayer },
	{ "RZClient_checkFile", Natives::RZClient_checkFile },
	{ "RZClient_getFiles", Natives::RZClient_getFiles },
	{ 0, 0 }
};

PLUGIN_EXPORT int PLUGIN_CALL AmxLoad(AMX *amx)
{
	core->interfaces.insert(amx);
	return amx_Register(amx, natives, -1);
}

PLUGIN_EXPORT int PLUGIN_CALL AmxUnload(AMX *amx)
{
	core->interfaces.erase(amx);
	return AMX_ERR_NONE;
}

PLUGIN_EXPORT void PLUGIN_CALL ProcessTick()
{
	if (!core->messages.empty())
	{
		boost::mutex::scoped_lock lock(core->mutex);
		Data::Message message(core->messages.front());
		core->messages.pop();
		lock.unlock();
		for (std::set<AMX*>::iterator i = core->interfaces.begin(); i != core->interfaces.end(); ++i)
		{
			cell amxAddress = 0;
			int amxIndex = 0;
			switch (message.array.at(0))
			{
				case Data::OnClientConnect:
				{
					if (!amx_FindPublic(*i, "RZClient_OnClientConnect", &amxIndex))
					{
						amx_PushString(*i, &amxAddress, NULL, message.buffer.at(0).c_str(), 0, 0);
						amx_Push(*i, message.array.at(1));
						amx_Exec(*i, NULL, amxIndex);
						amx_Release(*i, amxAddress);
					}
					break;
				}
				/*case Data::OnOldClientConnect:
				{
					if (!amx_FindPublic(*i, "RZClient_OnOldClientConnect", &amxIndex))
					{
						amx_PushString(*i, &amxAddress, NULL, message.buffer.at(0).c_str(), 0, 0);
						amx_Push(*i, message.array.at(1));
						amx_Exec(*i, NULL, amxIndex);
						amx_Release(*i, amxAddress);
					}
					break;
				}*/
				case Data::OnClientDisconnect:
				{
					if (!amx_FindPublic(*i, "RZClient_OnClientDisconnect", &amxIndex))
					{
						amx_Push(*i, message.array.at(1));
						amx_Exec(*i, NULL, amxIndex);
					}
					break;
				}
				case Data::OnTransferFile:
				{
					if (!amx_FindPublic(*i, "RZClient_OnTransferFile", &amxIndex))
					{
						amx_Push(*i, message.array.at(1));
						amx_Push(*i, message.array.at(2));
						amx_Push(*i, message.array.at(3));
						amx_PushString(*i, &amxAddress, NULL, message.buffer.at(0).c_str(), 0, 0);
						amx_Push(*i, message.array.at(4));
						amx_Exec(*i, NULL, amxIndex);
						amx_Release(*i, amxAddress);
					}
					break;
				}
				case Data::OnPlay:
				{
					if (!amx_FindPublic(*i, "RZClient_OnPlay", &amxIndex))
					{
						amx_Push(*i, message.array.at(1));
						amx_Push(*i, message.array.at(2));
						amx_Exec(*i, NULL, amxIndex);
					}
					break;
				}
				case Data::OnStop:
				{
					if (!amx_FindPublic(*i, "RZClient_OnStop", &amxIndex))
					{
						amx_Push(*i, message.array.at(1));
						amx_Push(*i, message.array.at(2));
						amx_Exec(*i, NULL, amxIndex);
					}
					break;
				}
				case Data::OnRadioStationChange:
				{
					if (!amx_FindPublic(*i, "RZClient_OnRadioStationChange", &amxIndex))
					{
						amx_Push(*i, message.array.at(1));
						amx_Push(*i, message.array.at(2));
						amx_Exec(*i, NULL, amxIndex);
					}
					break;
				}
				case Data::OnTrackChange:
				{
					if (!amx_FindPublic(*i, "RZClient_OnTrackChange", &amxIndex))
					{
						amx_PushString(*i, &amxAddress, NULL, message.buffer.at(0).c_str(), 0, 0);
						amx_Push(*i, message.array.at(1));
						amx_Push(*i, message.array.at(2));
						amx_Exec(*i, NULL, amxIndex);
						amx_Release(*i, amxAddress);
					}
					break;
				}
				case Data::OnGetPosition:
				{
					if (!amx_FindPublic(*i, message.buffer.at(0).c_str(), &amxIndex))
					{
						amx_Push(*i, message.array.at(1));
						amx_Push(*i, message.array.at(2));
						amx_Push(*i, message.array.at(3));
						amx_Exec(*i, NULL, amxIndex);
					}
					break;
				}
				case Data::OnFileChecked:
				{
					if (!amx_FindPublic(*i, "RZClient_OnFileChecked", &amxIndex))
					{
						amx_PushString(*i, &amxAddress, NULL, message.buffer.at(0).c_str(), 0, 0);
						amx_Push(*i, message.array.at(1));
						amx_Push(*i, message.array.at(2));
						amx_Exec(*i, NULL, amxIndex);
						amx_Release(*i, amxAddress);
					}
					break;
				}
				case Data::OnfilesGET:
				{
					if (!amx_FindPublic(*i, "RZClient_OnFilesGEtted", &amxIndex))
					{
						amx_PushString(*i, &amxAddress, NULL, message.buffer.at(1).c_str(), 0, 0);
						amx_PushString(*i, &amxAddress, NULL, message.buffer.at(0).c_str(), 0, 0);
						amx_Push(*i, message.array.at(1));
						amx_Push(*i, message.array.at(2));
						amx_Exec(*i, NULL, amxIndex);
						amx_Release(*i, amxAddress);
					}
					break;
				}
			}
		}
	}
}
