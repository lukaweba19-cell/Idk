-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Original SourceAssetId: https://assetdelivery.roblox.com/v1/asset/?id=5692144533

-- ! Source from the asset above; the game may have edited it since.

--[[
-- Constants

local ITERATIONS	= 8

-- Module

local SPRING	= {}

-- Functions 

function SPRING.create(self, mass, force, damping, speed)

	local spring	= {
		Target		= Vector3.new();
		Position	= Vector3.new();
		Velocity	= Vector3.new();
		
		Mass		= mass or 5;
		Force		= force or 50;
		Damping		= damping or 4;
		Speed		= speed  or 4;
	}
	
	function spring.shove(self, force)
		local x, y, z	= force.X, force.Y, force.Z
		if x ~= x or x == math.huge or x == -math.huge then
			x	= 0
		end
		if y ~= y or y == math.huge or y == -math.huge then
			y	= 0
		end
		if z ~= z or z == math.huge or z == -math.huge then
			z	= 0
		end
		self.Velocity	= self.Velocity + Vector3.new(x, y, z)
	end
	
	function spring.update(self, dt)
		local scaledDeltaTime = math.min(dt,1) * self.Speed / ITERATIONS
		
		for i = 1, ITERATIONS do
			local iterationForce= self.Target - self.Position
			local acceleration	= (iterationForce * self.Force) / self.Mass
			
			acceleration		= acceleration - self.Velocity * self.Damping
			
			self.Velocity	= self.Velocity + acceleration * scaledDeltaTime
			self.Position	= self.Position + self.Velocity * scaledDeltaTime
		end
		
		return self.Position
	end
	
	return spring
end

-- Return

return SPRING
]]

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	create = function(_, p2, p3, p4, p5)
		return {
			Target = Vector3.new(),
			Position = Vector3.new(),
			Velocity = Vector3.new(),
			Mass = p2 or 5,
			Force = p3 or 50,
			Damping = p4 or 4,
			Speed = p5 or 4,
			shove = function(p6, p7)
				local v8 = p7.X
				local v9 = p7.Y
				local v10 = p7.Z

				if v8 ~= v8 or v8 == math.huge or v8 == -math.huge then
					v8 = 0
				end

				if v9 ~= v9 or v9 == math.huge or v9 == -math.huge then
					v9 = 0
				end

				if v10 ~= v10 or v10 == math.huge or v10 == -math.huge then
					v10 = 0
				end

				local velocity = p6.Velocity
				local vector3 = Vector3.new(v8, v9, v10)

				p6.Velocity = velocity + vector3
			end,
			update = function(p8, p9)
				local n1 = math.min(p9, 1) * p8.Speed / 8

				for _ = 1, 8 do
					p8.Velocity = p8.Velocity + ((p8.Target - p8.Position) * p8.Force / p8.Mass - p8.Velocity * p8.Damping) * n1
					p8.Position = p8.Position + p8.Velocity * n1
				end

				return p8.Position
			end
		}
	end
}
