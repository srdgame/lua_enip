local class = require 'middleclass'

local types = require 'enip.cip.types'
local seg_parser = require 'enip.cip.segment.parser'

local reply = class('LUA_ENIP_CIP_REPLY')

function reply:initialize(service_code, status, data, additional_status)
	self._code = service_code | types.SERVICES.REPLY
	self._status = status or -1
	self._data = data
	self._additional_status = additional_status
end

function reply:service_code()
	return self._code & ( ~ types.SERVICES.REPLY)
end

function reply:status()
	return self._status
end

function reply:additional_status()
	return self._additional_status
end

function reply:data()
	return self._data
end

function reply:error_info()
	local sts = types.status_to_string(self._status)
	sts = sts or 'STATUS: 0x'..string.format('%02X', self._status)
	if self._additional_status then
		sts = sts..'. Additional status: 0x'..string.format('%04X', self._additional_status)
	end

	return sts
end

function reply:to_hex()
	assert(self._status, 'status is missing')
	assert(self._data, 'data is missing')

	if not self._additional_status then
		local data = self._data.to_hex and self._data:to_hex() or tostring(self._data)
		return string.pack('<I1I1I1I1', self._code, 0, self._status, 0)..data
	else
		return string.pack('<I1I1I1I1I2', self._code, 0, self._status, 1, self._additional_status)
	end
end

function reply:from_hex(raw, index)
	local status_ex_size
	self._code, _, self._status, status_ex_size, index = string.unpack('<I1I1I1I1', raw, index)

	if status_ex_size == 0 then
		if self._status == types.STATUS.OK then
			self._data, index = seg_parser(raw, index)
		end
	else
		assert(self._status ~= types.STATUS.OK, 'Status must not be OK')
		assert(status_ex_size == 1, 'Only word status support for now')
		self._additional_status, index = string.unpack('<I2', raw, index)
	end

	return index
end

return reply
