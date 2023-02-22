include("shared.lua")

function ENT:OnSpawn()
	self:RegisterTrail( Vector(-22.64,277.91,99.35), 0, 20, 2, 1000, 600 )
	self:RegisterTrail( Vector(-22.64,-277.91,99.35), 0, 20, 2, 1000, 600 )
end

function ENT:OnFrame()
	local FT = RealFrameTime()

	self:AnimControlSurfaces( FT )
	--self:AnimLandingGear( FT )
	self:AnimRotor( FT )
end

function ENT:AnimRotor( frametime )
	if not self.RotorRPM then return end

	local PhysRot = self.RotorRPM < 470

	self._rRPM = self._rRPM and (self._rRPM + self.RotorRPM *  frametime * (PhysRot and 4 or 1)) or 0

	local Rot = Angle(self._rRPM,0,0)
	Rot:Normalize() 
	self:ManipulateBoneAngles( 17, Rot )

	self:SetBodygroup( 5, PhysRot and 0 or 1 ) 
end

function ENT:AnimControlSurfaces( frametime )
	local FT = frametime * 10

	local Steer = self:GetSteer()

	local Pitch = -Steer.y * 30
	local Yaw = -Steer.z * 20
	local Roll = math.Clamp(-Steer.x * 60,-30,30)

	self.smPitch = self.smPitch and self.smPitch + (Pitch - self.smPitch) * FT or 0
	self.smYaw = self.smYaw and self.smYaw + (Yaw - self.smYaw) * FT or 0
	self.smRoll = self.smRoll and self.smRoll + (Roll - self.smRoll) * FT or 0

	self:ManipulateBoneAngles( 10, Angle(0,0,self.smRoll) )
	self:ManipulateBoneAngles( 15, Angle(0,0,-self.smRoll) )

	self:ManipulateBoneAngles( 1, Angle(self.smPitch,0,0) )

	self:ManipulateBoneAngles( 2, Angle( self.smYaw,0,0 ) )
end

function ENT:AnimLandingGear( frametime )
	self._smLandingGear = self._smLandingGear and self._smLandingGear + (30 *  (1 - self:GetLandingGear()) - self._smLandingGear) * frametime * 8 or 0

	self:ManipulateBoneAngles( 1, Angle( 0,30 - self._smLandingGear,0) )
	self:ManipulateBoneAngles( 2, Angle( 0,30 - self._smLandingGear,0) )
end
