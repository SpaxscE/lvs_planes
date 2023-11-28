include("shared.lua")

ENT.ReflectorSight = true
ENT.ReflectorSightPos = Vector(33,0,106.68)
ENT.ReflectorSightColor = Color(248,165,40,255)
ENT.ReflectorSightColorBG = Color(0,0,0,0)
ENT.ReflectorSightMaterial = Material("lvs/sights/p51d.png")
ENT.ReflectorSightMaterialRes = 128
ENT.ReflectorSightHeight = 2.25
ENT.ReflectorSightWidth = 1.5
ENT.ReflectorSightGlow = true
ENT.ReflectorSightGlowMaterial = Material( "sprites/light_glow02_add" )
ENT.ReflectorSightGlowMaterialRes = 400
ENT.ReflectorSightGlowColor = Color(60,40,0,255)

function ENT:OnSpawn()
	self:RegisterTrail( Vector(18,-229,72), 0, 20, 2, 1000, 400 )
	self:RegisterTrail( Vector(18,229,72), 0, 20, 2, 1000, 400 )
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

	local Rot = Angle( self._rRPM,0,0)
	Rot:Normalize() 
	self:ManipulateBoneAngles( 10, Rot )

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

	self:ManipulateBoneAngles( 1, Angle( 0,0,-self.smRoll) )
	self:ManipulateBoneAngles( 16, Angle( 0,0,self.smRoll) )
	
	self:ManipulateBoneAngles( 2, Angle( 0,0,-self.smPitch) )
	
	self:ManipulateBoneAngles( 11, Angle( 0,-self.smYaw,0 ) )
end

function ENT:AnimLandingGear( frametime )
	self._smLandingGear = self._smLandingGear and self._smLandingGear + ((1 - self:GetLandingGear()) - self._smLandingGear) * frametime * 8 or 0

	local Inv = 1 - self._smLandingGear 
	local gExp = self._smLandingGear ^ 15
	local gExpInv = 1 - gExp

	self:ManipulateBoneAngles( 3, Angle(0,0,30 * Inv ) )
	self:ManipulateBoneAngles( 4, Angle(0,0,30 * Inv ) )

	self:ManipulateBonePosition( 5, Vector(0,15,-5) * self._smLandingGear ) 
	self:ManipulateBoneAngles( 5, Angle(0,0,-45* self._smLandingGear) )

	self:ManipulateBoneAngles( 6, Angle(-90 * gExp,0,0 ) )
	self:ManipulateBoneAngles( 7, Angle(-90 * gExp,0,0 ) )

	self:ManipulateBoneAngles( 8, Angle(87 * gExpInv,0,0) )
	self:ManipulateBoneAngles( 9, Angle(87 * gExpInv,0,0) )

	self:ManipulateBoneAngles( 12, Angle(-90,10,0 ) * self._smLandingGear )
	self:ManipulateBonePosition( 12, Vector(0,-0.7,0) * self._smLandingGear ) 

	self:ManipulateBoneAngles( 13, Angle(-90,-10,0 ) * self._smLandingGear )
	self:ManipulateBonePosition( 13, Vector(0,-0.7,0) * self._smLandingGear ) 

	self:ManipulateBoneAngles( 14, Angle(-85,0,0 ) * self._smLandingGear )
	self:ManipulateBoneAngles( 15, Angle(-85,0,0 ) * self._smLandingGear )
end

