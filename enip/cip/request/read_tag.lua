local base = require 'enip.cip.request.base'
local types = require 'enip.cip.types'

local req = base:subclass('enip.cip.request.read_tag')

function req:initialize(path, count)
	base.initialize(self, types.SERVICES.READ_TAG, path)
	self._count = count
end

function req:encode()
	assert(self._count, 'Count is missing')
	return string.pack('<I2', self._count)
end

function req:decode(raw, index)
	self._count, index = string.unpack('<I2', raw, index)
	return index
end

return req
