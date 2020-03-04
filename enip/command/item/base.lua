local class = require 'middleclass'

local item = class('LUA_ENIP_COMMAND_ITEM_BASE')

function item:initialize(type_id)
	self._type_id = type_id or 0x0000 --- NULL
	self._data_len = -1
end

function item:to_hex()
	local data = self.decode and self:decode() or ''
	self._data_len = string.len(data)
	return string.pack('<I2I2', self._type_id, self._data_len)..data
end

function item:from_hex(raw, index)
	local index = index or 1
	self._type_id, self._data_len, index = string.unpack('<I2I2', raw, index)
	if self._data_len > 0 then
		assert(self.decode, "Decode function missing")
		index = self:decode(raw, index)
	end
	return index
end

function item:type_id()
	return self._type_id
end

function item:data_len()
	if self._data_len < 0 then
		local data = self.decode and self:decode() or ''
		self._data_len = string.len(data)
	end
	return self._data_len
end

return item
