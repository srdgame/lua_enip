local class = require 'middleclass'
local command = require 'enip.command.base'
local command_parser = require 'enip.command.parser'

--- UDP Only? List Identity
local req = class('LUA_ENIP_MSG_REQ_SEND_UNIT_DATA', msg)

function req:initialize(session, data, timeout)
	command:initialize(session, command.header.CMD_SEND_UNIT_DATA)

	self._data = data
	self._interface_handle = 0 --- CIP over ENIP must be zero here
	self._timeout = timeout or 0
end

function req:encode()
	local data = self._data

	local data_1 = string.pack('<I4I2', self._interface_handle, self._timeout)
	local data_2 = data.to_hex and data:to_hex() or tostring(data)
	return data_1..data_2
end

function req:decode(raw, index)
	local index = msg:from_hex(raw, index)
	local data_raw = self:data()
	self._interface_handle, self._timeout, index = string.unpack('<I4I2', data)

	assert(self._interface_handle == 0, "Only CIP interface supported!!!")
	
	local command_data = string.sub(raw, index)
	self._data, index = command_parser.parse(command_data)

	return index
end

function req:interface_handle()
	return self._interface_handle
end

function req:timeout()
	return self._timeout
end

function req:data()
	return self._data
end

return req
