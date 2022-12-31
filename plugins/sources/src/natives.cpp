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

#include "natives.h"

#include "core.h"
#include "main.h"
#include "session.h"

#include <boost/algorithm/string.hpp>
#include <boost/asio.hpp>
#include <boost/format.hpp>
#include <boost/lexical_cast.hpp>
#include <boost/scoped_ptr.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/thread.hpp>
#include <boost/unordered_map.hpp>

#include <map>
#include <set>
#include <string>
#include <vector>

cell AMX_NATIVE_CALL Natives::RZClient_CreateTCPServer(AMX *amx, cell *params)
{
	CHECK_PARAMS(1, "RZClient_CreateTCPServer");
	boost::mutex::scoped_lock lock(core->mutex);
	if (core->getServer()->isRunning())
	{
		return 0;
	}
	if (!core->getServer()->createAcceptor(static_cast<unsigned short>(params[1])))
	{
		return 0;
	}
	boost::thread startAsyncThread(&Server::startAsync, core->getServer());
	return 1;
}

cell AMX_NATIVE_CALL Natives::RZClient_DestroyTCPServer(AMX *amx, cell *params)
{
	boost::mutex::scoped_lock lock(core->mutex);
	if (!core->getServer()->isRunning())
	{
		return 0;
	}
	core->getServer()->stopAsync();
	return 1;
}

cell AMX_NATIVE_CALL Natives::RZClient_SetPack(AMX *amx, cell *params)
{
	CHECK_PARAMS(3, "RZClient_SetPack");
	boost::mutex::scoped_lock lock(core->mutex);
	char *name = NULL;
	amx_StrParam(amx, params[1], name);
	if (name == NULL)
	{
		return 0;
	}
	return static_cast<cell>(core->setPack(name, static_cast<int>(params[2]) != 0, static_cast<int>(params[3]) != 0));
}

cell AMX_NATIVE_CALL Natives::RZClient_IsClientConnected(AMX *amx, cell *params)
{
	CHECK_PARAMS(1, "RZClient_IsClientConnected");
	boost::mutex::scoped_lock lock(core->mutex);
	boost::unordered_map<int, SharedSession>::iterator c = core->getServer()->clients.find(static_cast<int>(params[1]));
	if (c != core->getServer()->clients.end())
	{
		return 1;
	}
	return 0;
}
/*
cell AMX_NATIVE_CALL Natives::RZClient_StopSync(AMX *amx, cell *params)
{
	CHECK_PARAMS(1, "RZClient_StopSync");
	RZC_StopSync[(int)(params[1])] = true;
	return 0;
}

cell AMX_NATIVE_CALL Natives::RZClient_StartSync(AMX *amx, cell *params)
{
	CHECK_PARAMS(1, "RZClient_StartSync");
	RZC_StopSync[static_cast<int>(params[1])] = false;
	return 0;
}*/

cell AMX_NATIVE_CALL Natives::RZClient_SendMessage(AMX *amx, cell *params)
{
	CHECK_PARAMS(2, "RZClient_SendMessage");
	boost::mutex::scoped_lock lock(core->mutex);
	boost::unordered_map<int, SharedSession>::iterator c = core->getServer()->clients.find(static_cast<int>(params[1]));
	if (c != core->getServer()->clients.end())
	{
		char *message = NULL;
		amx_StrParam(amx, params[2], message);
		if (message == NULL)
		{
			return 0;
		}
		c->second->sendAsync(boost::str(boost::format("%1%\t%2%\n") % Server::Message % message));
		return 1;
	}
	return 0;
}

cell AMX_NATIVE_CALL Natives::RZClient_TransferPack(AMX *amx, cell *params)
{
	CHECK_PARAMS(1, "RZClient_TransferPack");
	boost::mutex::scoped_lock lock(core->mutex);
	if (core->packAutomated || !core->packFiles)
	{
		return 0;
	}
	boost::unordered_map<int, SharedSession>::iterator c = core->getServer()->clients.find(static_cast<int>(params[1]));
	if (c != core->getServer()->clients.end())
	{
		if (c->second->transferring)
		{
			c->second->stopTransfer();
		}
		c->second->sendAsync(boost::str(boost::format("%1%\t%2%\n") % Server::Connect % core->packName));
		c->second->startTransfer();
	}
	return 0;
}

cell AMX_NATIVE_CALL Natives::RZClient_CreateSequence(AMX *amx, cell *params)
{
	boost::mutex::scoped_lock lock(core->mutex);
	int sequenceID = 1;
	for (std::map<int, Data::Sequence>::iterator s = core->sequences.begin(); s != core->sequences.end(); ++s)
	{
		if (s->first != sequenceID)
		{
			break;
		}
		++sequenceID;
	}
	Data::Sequence sequence;
	core->sequences.insert(std::pair<int, Data::Sequence>(sequenceID, sequence));
	return static_cast<cell>(sequenceID);
}

cell AMX_NATIVE_CALL Natives::RZClient_DestroySequence(AMX *amx, cell *params)
{
	CHECK_PARAMS(1, "RZClient_DestroySequence");
	boost::mutex::scoped_lock lock(core->mutex);
	std::map<int, Data::Sequence>::iterator s = core->sequences.find(static_cast<int>(params[1]));
	if (s != core->sequences.end())
	{
		core->sequences.erase(s);
		return 1;
	}
	return 0;
}

cell AMX_NATIVE_CALL Natives::RZClient_AddToSequence(AMX *amx, cell *params)
{
	CHECK_PARAMS(2, "RZClient_AddToSequence");
	boost::mutex::scoped_lock lock(core->mutex);
	std::map<int, Data::Sequence>::iterator s = core->sequences.find(static_cast<int>(params[1]));
	if (s != core->sequences.end())
	{
		std::map<int, Data::File>::iterator f = core->files.find(static_cast<int>(params[2]));
		if (f != core->files.end())
		{
			s->second.audioIDs.push_back(static_cast<int>(params[2]));
			return 1;
		}
	}
	return 0;
}

cell AMX_NATIVE_CALL Natives::RZClient_RemoveFromSequence(AMX *amx, cell *params)
{
	CHECK_PARAMS(2, "RZClient_RemoveFromSequence");
	boost::mutex::scoped_lock lock(core->mutex);
	std::map<int, Data::Sequence>::iterator s = core->sequences.find(static_cast<int>(params[1]));
	if (s != core->sequences.end())
	{
		bool result = false;
		std::vector<int>::iterator a = s->second.audioIDs.begin();
		while (a != s->second.audioIDs.end())
		{
			if (*a == static_cast<int>(params[2]))
			{
				a = s->second.audioIDs.erase(a);
				result = true;
			}
			else
			{
				++a;
			}
		}
		if (result)
		{
			return 1;
		}
	}
	return 0;
}

cell AMX_NATIVE_CALL Natives::RZClient_Play(AMX *amx, cell *params)
{
	CHECK_PARAMS(5, "RZClient_Play");
	boost::mutex::scoped_lock lock(core->mutex);
	if (!core->packFiles)
	{
		return 0;
	}
	std::map<int, Data::File>::iterator f = core->files.find(static_cast<int>(params[2]));
	if (f == core->files.end())
	{
		return 0;
	}
	boost::unordered_map<int, SharedSession>::iterator c = core->getServer()->clients.find(static_cast<int>(params[1]));
	if (c != core->getServer()->clients.end())
	{
		int handleID = 1;
		for (std::set<int>::iterator h = c->second->handles.begin(); h != c->second->handles.end(); ++h)
		{
			if (*h != handleID)
			{
				break;
			}
			++handleID;
		}
		c->second->handles.insert(handleID);
		c->second->sendAsync(boost::str(boost::format("%1%\t%2%\t%3%\t%4%\t%5%\t%6%\n") % Server::Play % static_cast<int>(params[2]) % handleID % static_cast<int>(params[3]) % static_cast<int>(params[4]) % static_cast<int>(params[5])));
		return static_cast<cell>(handleID);
	}
	return 0;
}

cell AMX_NATIVE_CALL Natives::RZClient_PlayStreamed(AMX *amx, cell *params)
{
	CHECK_PARAMS(5, "RZClient_PlaySteamed");
	boost::mutex::scoped_lock lock(core->mutex);
	boost::unordered_map<int, SharedSession>::iterator c = core->getServer()->clients.find(static_cast<int>(params[1]));
	if (c != core->getServer()->clients.end())
	{
		char *url = NULL;
		amx_StrParam(amx, params[2], url);
		if (url == NULL)
		{
			return 0;
		}
		int handleID = 1;
		for (std::set<int>::iterator h = c->second->handles.begin(); h != c->second->handles.end(); ++h)
		{
			if (*h != handleID)
			{
				break;
			}
			++handleID;
		}
		c->second->handles.insert(handleID);
		c->second->sendAsync(boost::str(boost::format("%1%\t%2%\t%3%\t%4%\t%5%\t%6%\n") % Server::Play % url % handleID % static_cast<int>(params[3]) % static_cast<int>(params[4]) % static_cast<int>(params[5])));
		return static_cast<cell>(handleID);
	}
	return 0;
}

cell AMX_NATIVE_CALL Natives::RZClient_PlaySequence(AMX *amx, cell *params)
{
	CHECK_PARAMS(5, "RZClient_PlaySequence");
	boost::mutex::scoped_lock lock(core->mutex);
	if (!core->packFiles)
	{
		return 0;
	}
	std::map<int, Data::Sequence>::iterator s = core->sequences.find(static_cast<int>(params[2]));
	if (s == core->sequences.end())
	{
		return 0;
	}
	if (s->second.audioIDs.empty())
	{
		return 0;
	}
	std::string output;
	std::vector<int>::iterator b = s->second.audioIDs.begin();
	for (std::vector<int>::iterator a = s->second.audioIDs.begin(); a != s->second.audioIDs.end(); ++a)
	{
		if (std::distance(b, a) < 32)
		{
			try
			{
				output += boost::lexical_cast<std::string>(*a) + " ";
			}
			catch (boost::bad_lexical_cast &)
			{
				continue;
			}
		}
		else
		{
			s->second.transfers.insert(std::make_pair(static_cast<int>(params[1]), std::distance(b, a)));
			output += "U";
			break;
		}
	}
	if (output.find("U") == std::string::npos)
	{
		output += "F";
	}
	boost::unordered_map<int, SharedSession>::iterator c = core->getServer()->clients.find(static_cast<int>(params[1]));
	if (c != core->getServer()->clients.end())
	{
		int handleID = 1;
		for (std::set<int>::iterator h = c->second->handles.begin(); h != c->second->handles.end(); ++h)
		{
			if (*h != handleID)
			{
				break;
			}
			++handleID;
		}
		c->second->handles.insert(handleID);
		c->second->sendAsync(boost::str(boost::format("%1%\t%2%\t%3%\t%4%\t%5%\t%6%\t%7%\n") % Server::PlaySequence % static_cast<int>(params[2]) % handleID % static_cast<int>(params[3]) % static_cast<int>(params[4]) % static_cast<int>(params[5]) % output));
		return static_cast<cell>(handleID);
	}
	return 0;
}

cell AMX_NATIVE_CALL Natives::RZClient_Pause(AMX *amx, cell *params)
{
	CHECK_PARAMS(2, "RZClient_Pause");
	boost::mutex::scoped_lock lock(core->mutex);
	boost::unordered_map<int, SharedSession>::iterator c = core->getServer()->clients.find(static_cast<int>(params[1]));
	if (c != core->getServer()->clients.end())
	{
		std::set<int>::iterator h = c->second->handles.find(static_cast<int>(params[2]));
		if (h != c->second->handles.end())
		{
			c->second->sendAsync(boost::str(boost::format("%1%\t%2%") % Server::Pause % static_cast<int>(params[2])));
			return 1;
		}
	}
	return 0;
}

cell AMX_NATIVE_CALL Natives::RZClient_Resume(AMX *amx, cell *params)
{
	CHECK_PARAMS(2, "RZClient_Resume");
	boost::mutex::scoped_lock lock(core->mutex);
	boost::unordered_map<int, SharedSession>::iterator c = core->getServer()->clients.find(static_cast<int>(params[1]));
	if (c != core->getServer()->clients.end())
	{
		std::set<int>::iterator h = c->second->handles.find(static_cast<int>(params[2]));
		if (h != c->second->handles.end())
		{
			c->second->sendAsync(boost::str(boost::format("%1%\t%2%\n") % Server::Resume % static_cast<int>(params[2])));
			return 1;
		}
	}
	return 0;
}

cell AMX_NATIVE_CALL Natives::RZClient_Stop(AMX *amx, cell *params)
{
	CHECK_PARAMS(2, "RZClient_Stop");
	boost::mutex::scoped_lock lock(core->mutex);
	boost::unordered_map<int, SharedSession>::iterator c = core->getServer()->clients.find(static_cast<int>(params[1]));
	if (c != core->getServer()->clients.end())
	{
		std::set<int>::iterator h = c->second->handles.find(static_cast<int>(params[2]));
		if (h != c->second->handles.end())
		{
			c->second->sendAsync(boost::str(boost::format("%1%\t%2%\n") % Server::Stop % static_cast<int>(params[2])));
			return 1;
		}
	}
	return 0;
}

cell AMX_NATIVE_CALL Natives::RZClient_Restart(AMX *amx, cell *params)
{
	CHECK_PARAMS(2, "RZClient_Restart");
	boost::mutex::scoped_lock lock(core->mutex);
	boost::unordered_map<int, SharedSession>::iterator c = core->getServer()->clients.find(static_cast<int>(params[1]));
	if (c != core->getServer()->clients.end())
	{
		std::set<int>::iterator h = c->second->handles.find(static_cast<int>(params[2]));
		if (h != c->second->handles.end())
		{
			c->second->sendAsync(boost::str(boost::format("%1%\t%2%\n") % Server::Restart % static_cast<int>(params[2])));
			return 1;
		}
	}
	return 0;
}

cell AMX_NATIVE_CALL Natives::RZClient_SetPosition(AMX *amx, cell *params)
{
	CHECK_PARAMS(3, "RZClient_SetPosition");
	boost::mutex::scoped_lock lock(core->mutex);
	boost::unordered_map<int, SharedSession>::iterator c = core->getServer()->clients.find(static_cast<int>(params[1]));
	if (c != core->getServer()->clients.end())
	{
		std::set<int>::iterator h = c->second->handles.find(static_cast<int>(params[2]));
		if (h != c->second->handles.end())
		{
			if (static_cast<int>(params[3]) >= 0)
			{
				c->second->sendAsync(boost::str(boost::format("%1%\t%2%\t%3%\n") % Server::SetPosition % static_cast<int>(params[2]) % static_cast<int>(params[3])));
				return 1;
			}
		}
	}
	return 0;
}

cell AMX_NATIVE_CALL Natives::RZClient_SetVolume(AMX *amx, cell *params)
{
	CHECK_PARAMS(3, "RZClient_SetVolume");
	boost::mutex::scoped_lock lock(core->mutex);
	boost::unordered_map<int, SharedSession>::iterator c = core->getServer()->clients.find(static_cast<int>(params[1]));
	if (c != core->getServer()->clients.end())
	{
		std::set<int>::iterator h = c->second->handles.find(static_cast<int>(params[2]));
		if (h != c->second->handles.end())
		{
			if (static_cast<int>(params[3]) >= 0 && static_cast<int>(params[3]) <= 100)
			{
				c->second->sendAsync(boost::str(boost::format("%1%\t%2%\t%3%\n") % Server::SetVolume % static_cast<int>(params[2]) % static_cast<int>(params[3])));
				return 1;
			}
		}
	}
	return 0;
}

cell AMX_NATIVE_CALL Natives::RZClient_SetFX(AMX *amx, cell *params)
{
	CHECK_PARAMS(3, "RZClient_SetFX");
	boost::mutex::scoped_lock lock(core->mutex);
	boost::unordered_map<int, SharedSession>::iterator c = core->getServer()->clients.find(static_cast<int>(params[1]));
	if (c != core->getServer()->clients.end())
	{
		std::set<int>::iterator h = c->second->handles.find(static_cast<int>(params[2]));
		if (h != c->second->handles.end())
		{
			if (static_cast<int>(params[3]) >= 0 && static_cast<int>(params[3]) <= 8)
			{
				c->second->sendAsync(boost::str(boost::format("%1%\t%2%\t%3%\n") % Server::SetFX % static_cast<int>(params[2]) % static_cast<int>(params[3])));
				return 1;
			}
		}
	}
	return 0;
}

cell AMX_NATIVE_CALL Natives::RZClient_RemoveFX(AMX *amx, cell *params)
{
	CHECK_PARAMS(3, "RZClient_RemoveFX");
	boost::mutex::scoped_lock lock(core->mutex);
	boost::unordered_map<int, SharedSession>::iterator c = core->getServer()->clients.find(static_cast<int>(params[1]));
	if (c != core->getServer()->clients.end())
	{
		std::set<int>::iterator h = c->second->handles.find(static_cast<int>(params[2]));
		if (h != c->second->handles.end())
		{
			c->second->sendAsync(boost::str(boost::format("%1%\t%2%\t%3%\n") % Server::RemoveFX % static_cast<int>(params[2]) % static_cast<int>(params[3])));
			return 1;
		}
	}
	return 0;
}

cell AMX_NATIVE_CALL Natives::RZClient_Set3DPosition(AMX *amx, cell *params)
{
	CHECK_PARAMS(6, "RZClient_Set3DPosition");
	boost::mutex::scoped_lock lock(core->mutex);
	boost::unordered_map<int, SharedSession>::iterator c = core->getServer()->clients.find(static_cast<int>(params[1]));
	if (c != core->getServer()->clients.end())
	{
		std::set<int>::iterator h = c->second->handles.find(static_cast<int>(params[2]));
		if (h != c->second->handles.end())
		{
			c->second->sendAsync(boost::str(boost::format("%1%\t%2%\t%3%\t%4%\t%5%\t%6%\n") % Server::Set3DPosition % static_cast<int>(params[2]) % amx_ctof(params[3]) % amx_ctof(params[4]) % amx_ctof(params[5]) % amx_ctof(params[6])));
			return 1;
		}
	}
	return 0;
}

cell AMX_NATIVE_CALL Natives::RZClient_Remove3DPosition(AMX *amx, cell *params)
{
	CHECK_PARAMS(2, "RZClient_Remove3DPosition");
	boost::mutex::scoped_lock lock(core->mutex);
	boost::unordered_map<int, SharedSession>::iterator c = core->getServer()->clients.find(static_cast<int>(params[1]));
	if (c != core->getServer()->clients.end())
	{
		std::set<int>::iterator h = c->second->handles.find(static_cast<int>(params[2]));
		if (h != c->second->handles.end())
		{
			c->second->sendAsync(boost::str(boost::format("%1%\t%2%\n") % Server::Remove3DPosition % static_cast<int>(params[2])));
			return 1;
		}
	}
	return 0;
}

cell AMX_NATIVE_CALL Natives::RZClient_SetRadioStation(AMX *amx, cell *params)
{
	CHECK_PARAMS(2, "RZClient_SetRadioStation");
	boost::mutex::scoped_lock lock(core->mutex);
	boost::unordered_map<int, SharedSession>::iterator c = core->getServer()->clients.find(static_cast<int>(params[1]));
	if (c != core->getServer()->clients.end())
	{
		if (static_cast<int>(params[2]) >= 0 && static_cast<int>(params[2]) <= 12)
		{
			c->second->sendAsync(boost::str(boost::format("%1%\t%2%\n") % Server::SetRadioStation % static_cast<int>(params[2])));
			return 1;
		}
	}
	return 0;
}

cell AMX_NATIVE_CALL Natives::RZClient_StopRadio(AMX *amx, cell *params)
{
	CHECK_PARAMS(1, "RZClient_StopRadio");
	boost::mutex::scoped_lock lock(core->mutex);
	boost::unordered_map<int, SharedSession>::iterator c = core->getServer()->clients.find(static_cast<int>(params[1]));
	if (c != core->getServer()->clients.end())
	{
		c->second->sendAsync(boost::str(boost::format("%1%\n") % Server::StopRadio));
		return 1;
	}
	return 0;
}

cell AMX_NATIVE_CALL Natives::RZClient_AddPlayer(AMX *amx, cell *params)
{
	CHECK_PARAMS(3, "RZClient_AddPlayer");
	boost::mutex::scoped_lock lock(core->mutex);
	char *address = NULL, *name = NULL;
	amx_StrParam(amx, params[2], address);
	amx_StrParam(amx, params[3], name);
	if (address == NULL || name == NULL)
	{
		return 0;
	}
	boost::system::error_code error;
	boost::asio::ip::address::from_string(address, error);
	if (error)
	{
		return 0;
	}
	std::map<int, Data::Player>::iterator p = core->players.find(static_cast<int>(params[1]));
	if (p != core->players.end())
	{
		if (boost::algorithm::equals(p->second.address, address) && boost::algorithm::equals(p->second.name.front(), name))
		{
			return 0;
		}
		core->players.erase(p);
	}
	Data::Player player;
	player.address = address;
	player.name.push_back(name);
	core->players.insert(std::make_pair(static_cast<int>(params[1]), player));
	return 1;
}

cell AMX_NATIVE_CALL Natives::RZClient_RenamePlayer(AMX *amx, cell *params)
{
	CHECK_PARAMS(2, "RZClient_RenamePlayer");
	boost::mutex::scoped_lock lock(core->mutex);
	char *name = NULL;
	amx_StrParam(amx, params[2], name);
	if (name == NULL)
	{
		return 0;
	}
	amx_StrParam(amx, params[2], name);
	boost::unordered_map<int, SharedSession>::iterator c = core->getServer()->clients.find(static_cast<int>(params[1]));
	if (c != core->getServer()->clients.end())
	{
		std::map<int, Data::Player>::iterator p = core->players.find(static_cast<int>(params[1]));
		if (p != core->players.end())
		{
			p->second.name.front() = name;
		}
		c->second->playerName = name;
		c->second->sendAsync(boost::str(boost::format("%1%\t%2%\n") % Server::Name % name));
		return 1;
	}
	std::map<int, Data::Player>::iterator f = core->players.find(static_cast<int>(params[1]));
	if (f != core->players.end())
	{
		if (f->second.name.size() > 1)
		{
			f->second.name.pop_back();
		}
		f->second.name.push_back(name);
		return 1;
	}
	return 0;
}

cell AMX_NATIVE_CALL Natives::RZClient_RemovePlayer(AMX *amx, cell *params)
{
	CHECK_PARAMS(1, "RZClient_RemovePlayer");
	boost::mutex::scoped_lock lock(core->mutex);
	boost::unordered_map<int, SharedSession>::iterator c = core->getServer()->clients.find(static_cast<int>(params[1]));
	if (c != core->getServer()->clients.end())
	{
		c->second->stopAsync();
	}
	std::map<int, Data::Player>::iterator p = core->players.find(static_cast<int>(params[1]));
	if (p != core->players.end())
	{
		core->players.erase(p);
		return 1;
	}
	return 0;
}

cell AMX_NATIVE_CALL Natives::RZClient_GetPosition(AMX *amx, cell *params)
{
	CHECK_PARAMS(3, "RZClient_GetPosition");
	boost::mutex::scoped_lock lock(core->mutex);
	boost::unordered_map<int, SharedSession>::iterator c = core->getServer()->clients.find(static_cast<int>(params[1]));
	if (c != core->getServer()->clients.end())
	{
		std::set<int>::iterator h = c->second->handles.find(static_cast<int>(params[2]));
		if (h != c->second->handles.end())
		{
			char *callback = NULL;
			amx_StrParam(amx, params[3], callback);
			if (callback == NULL)
			{
				return 0;
			}
			int requestID = 1;
			for (std::map<int, Data::Message>::iterator r = c->second->requests.begin(); r != c->second->requests.end(); ++r)
			{
				if (r->first != requestID)
				{
					break;
				}
				++requestID;
			}
			Data::Message message;
			message.array.push_back(Server::Position);
			message.buffer.push_back(callback);
			c->second->requests.insert(std::make_pair(requestID, message));
			c->second->sendAsync(boost::str(boost::format("%1%\t%2%\t%3%\n") % Server::GetPosition % requestID % static_cast<int>(params[2])));
			return 1;
		}
	}
	return 0;
}


cell AMX_NATIVE_CALL Natives::RZClient_checkFile(AMX *amx, cell *params)
{
	CHECK_PARAMS(3, "RZClient_checkFile");
	boost::mutex::scoped_lock lock(core->mutex);
	boost::unordered_map<int, SharedSession>::iterator c = core->getServer()->clients.find(static_cast<int>(params[1]));
	if (c != core->getServer()->clients.end())
	{
		char *message = NULL;
		amx_StrParam(amx, params[2], message);
		if (message == NULL)
		{
			logprintf("*** RZC Plugin: failed archivo al Id %d (%s)", static_cast<int>(params[1]), message);
			return 0;
		}
		char *callback = NULL;
		amx_StrParam(amx, params[3], callback);
		if (callback == NULL)
		{
			logprintf("*** RZC Plugin: failed archivo al Id %d (%s) callback %s", static_cast<int>(params[1]), message, callback);
			return 0;
		}
		Data::Message message2;
		message2.array.push_back(Server::checkFile);
		message2.buffer.push_back(callback);
		c->second->sendAsync(boost::str(boost::format("%1%\t%2%\n") % Server::checkFile % message));
		return 1;
	}
	return 0;
}

cell AMX_NATIVE_CALL Natives::RZClient_getFiles(AMX *amx, cell *params)
{
	CHECK_PARAMS(4, "RZClient_getFiles");
	boost::mutex::scoped_lock lock(core->mutex);
	boost::unordered_map<int, SharedSession>::iterator c = core->getServer()->clients.find(static_cast<int>(params[1]));
	//logprintf("*** RZC Plugin: getFiles al Id %d", static_cast<int>(params[1]));
	if (c != core->getServer()->clients.end())
	{
		char *message = NULL;
		amx_StrParam(amx, params[3], message);
		if (message == NULL)
		{
			//logprintf("*** RZC Plugin: failed getFiles al Id %d (%s)", static_cast<int>(params[1]), message);
			return 0;
		}
		char *callback = NULL;
		amx_StrParam(amx, params[4], callback);
		if (callback == NULL)
		{
			//logprintf("*** RZC Plugin: failed getFiles al Id %d (%s) callback %s", static_cast<int>(params[1]), message, callback);
			return 0;
		}
		//logprintf("*** RZC Plugin bifor: getFiles al Id %d (%s) callback %s", static_cast<int>(params[1]), message, callback);
		Data::Message message2;
		message2.array.push_back(Server::getFiles);
		message2.buffer.push_back(callback);
		c->second->sendAsync(boost::str(boost::format("%1%\t%2%\t%3%\t%4%\n") % Server::getFiles % static_cast<int>(params[1]) % static_cast<int>(params[2]) % message));
		//logprintf("*** RZC Plugin: getFiles al Id %d (%s) returnto => %d callback %s", static_cast<int>(params[1]), message, static_cast<int>(params[2]), callback);
		return 1;
	}
	return 0;
}