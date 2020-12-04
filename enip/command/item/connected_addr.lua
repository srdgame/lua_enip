local base = require 'enip.command.item.base'

local item = base:subclass('enip.command.item.connected_addr')

function item:initialize(conn_identity)
	base.initialize(self, base.TYPES.CONNECTED_ADDR)
	self._conn_identity = tonumber(conn_identity) or 0
end

function item:encode()
	return string.pack('<I4', self._conn_identity)
end

function item:decode(raw, index)
	self._conn_identity, index = string.unpack('<I4', raw, index)
	return index
end

function item:identity()
	return self._conn_identity
end
