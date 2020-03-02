local class = require 'middleclass'
local cpf = require 'cip.item.base'
local types = require 'cip.item.types'

local connected_address = class('LUA_ENIP_CIP_TYPES_CONNECTED_ADDRESS', cpf)

function connected_address:initialize(conn_identity)
	cpf:initialize(types.CONNECTED_ADDR)
	self._conn_identity = tonumber(conn_identity) or 0
end

function connected_address:encode()
	return string.pack('<I4', self._conn_identity)
end

function connected_address:decode(raw)
	self._conn_identity = string.unpack('<I4', raw)
end

function connected_address:identity()
	return self._conn_identity
end
