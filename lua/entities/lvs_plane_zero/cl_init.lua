include("shared.lua")

function ENT:OnSpawn()
	self:RegisterTrail( Vector(14.5,230.5,84.5), 0, 20, 2, 1000, 400 )
	self:RegisterTrail( Vector(14.5,-230.5,84.5), 0, 20, 2, 1000, 400 )

	self:CreateBonePoseParameter( "cabin", 1, Angle(0,0,0), Angle(0,0,0), Vector(0,0,0), Vector(0,1.5,-27) )
end

function ENT:OnFrame()
	local FT = RealFrameTime()

	self:AnimControlSurfaces( FT )
	self:AnimLandingGear( FT )
	self:AnimRotor( FT )
end

function ENT:AnimRotor( frametime )
	if not self.RotorRPM then return end

	local PhysRot = self.RotorRPM < 470

	self._rRPM = self._rRPM and (self._rRPM + self.RotorRPM *  frametime * (PhysRot and 4 or 1)) or 0

	local Rot = Angle(0,self._rRPM,0)
	Rot:Normalize() 
	self:ManipulateBoneAngles( 12, Rot )

	self:SetBodygroup( 1, PhysRot and 0 or 1 ) 
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

	self:ManipulateBoneAngles( 13, Angle( 0,0,self.smRoll) )
	self:ManipulateBoneAngles( 4, Angle( 0,0,-self.smRoll) )
	
	self:ManipulateBoneAngles( 5, Angle( 0,0,-self.smPitch) )
	
	self:ManipulateBoneAngles( 11, Angle( 0,self.smYaw,0 ) )
end

function ENT:AnimLandingGear( frametime )
	self._smLandingGear = self._smLandingGear and self._smLandingGear + ((1 - self:GetLandingGear()) - self._smLandingGear) * frametime * 8 or 0

	local Inv = 1 - self._smLandingGear 
	local gExp = self._smLandingGear ^ 20
	local gExpInv = 1 - gExp

	self:ManipulateBoneAngles( 10, Angle(0,0,-45 * self._smLandingGear) )

	self:ManipulateBoneAngles( 2, Angle(-85 * self._smLandingGear,0,0) )
	self:ManipulateBoneAngles( 3, Angle(86 * self._smLandingGear,0,0) )

	self:ManipulateBoneAngles( 8, Angle(-90 * gExpInv,0,0) )
	self:ManipulateBoneAngles( 9, Angle(90 * gExpInv,0,0) )

	self:ManipulateBoneAngles( 6, Angle(0,0,-45 * self._smLandingGear) )
	self:ManipulateBoneAngles( 7, Angle(0,0,-45 * self._smLandingGear) )
end

