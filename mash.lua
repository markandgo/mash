-- v0.1

--[[
Copyright (c) 2012 Minh Ngo

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

	1. The origin of this software must not be misrepresented; you must not
	claim that you wrote the original software. If you use this software
	in a product, an acknowledgment in the product documentation would be
	appreciated but is not required.
	
	2. Altered source versions must be plainly marked as such, and must not be
	misrepresented as being the original software.
	
	3. This notice may not be removed or altered from any source
	distribution.
--]]

-- ================
-- animation class
-- ================
local a = {}
a.__index = a

function a:loop()
	self.frame = self.frame + 1
	self.frame = self.animation[self.frame] and self.frame or 1
end

function a:bounce()
	self.direction = self.animation[self.frame + self.direction] and self.direction or -1*self.direction
	self.frame = self.frame + self.direction
end

function a:once()
	self.frame  = self.animation[ self.frame+1 ] and self.frame+1 or self.frame
end

function a:pause()
	self.status = 'paused'
end

function a:resume()
	self.status = 'playing'
end

function a:stop()
	self.status = 'stopped'
	self.frame,self.t,self.direction = 1,0,1
end

function a:seek(frame,direction)
	self.t,self.frame,self.direction = 0,frame,direction or self.direction
end

function a:update(dt)
	if self.status ~= 'playing' then return end
	self.t = self.t + dt
	while self.t > self.animation[self.frame].t do
		self.t = self.t - self.animation[self.frame].t
		self[self.mode](self)
	end
end

function a:draw(x, y, r, sx, sy, ox, oy, kx, ky)
	local f       = self.animation[self.frame]
	ox,oy         = ox and ox + f.ox or f.ox,oy and oy + f.oy or f.oy
	love.graphics.draw( f.img , x, y, r, sx, sy, ox, oy, kx, ky)
end

-- ================
-- module
-- ================
local m = {}

function m.new(data,mode)
	return setmetatable(
	{
		status   = 'playing',
		frame    = 1,
		t        = 0,
		direction= 1,
		animation= data,
		mode     = mode or 'loop',
	},a)
end

function m.newData(sequence,delay,ox,oy)
	local data  = {}
	if type(delay) == 'function' then
		local callback = delay
		for i=1,#sequence do
			data[i] = {img = sequence[i]}
			data[i].t, data[i].ox, data[i].oy = callback(i,sequence)
		end
	else
		ox,oy = ox or 0,oy or 0
		for i=1,#sequence do
			data[i] = {img = sequence[i],t = delay,ox = ox,oy = oy}
		end
	end
	return data
end

function m.getImages(sprite_path)
	local files   = love.filesystem.enumerate(sprite_path)
	local sprites = {}
	for i = 1,#files do
		local fileName = files[i]
		local prefix = tonumber( fileName:match '(.*)%-' ) or fileName:match '(.*)%-'
		local suffix = tonumber( fileName:match '(%d*)%.%w*$' )
		
		sprites[prefix]         = sprites[prefix] or {}
		sprites[prefix][suffix] = love.graphics.newImage(sprite_path .. fileName)
	end
	return sprites
end

return m