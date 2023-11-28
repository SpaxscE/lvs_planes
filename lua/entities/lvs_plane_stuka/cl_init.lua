include("shared.lua")
include( "cl_prediction.lua" )

DEFINE_BASECLASS( "lvs_base_fighterplane" )

ENT.ReflectorSight = true
ENT.ReflectorSightPos = Vector(0,-1.88,127.28)
ENT.ReflectorSightColor = Color(255,150,0,255)
ENT.ReflectorSightColorBG = Color(0,0,0,0)
ENT.ReflectorSightMaterial = Material("lvs/sights/stuka.png")
ENT.ReflectorSightMaterialRes = 128
ENT.ReflectorSightHeight = 2.2
ENT.ReflectorSightWidth = 1.3
ENT.ReflectorSightGlow = true
ENT.ReflectorSightGlowMaterial = Material( "sprites/light_glow02_add" )
ENT.ReflectorSightGlowMaterialRes = 600
ENT.ReflectorSightGlowColor = Color(60,40,0,255)

function ENT:LVSHudPaintInfoText( X, Y, W, H, ScrX, ScrY, ply )
	BaseClass.LVSHudPaintInfoText( self, X, Y, W, H, ScrX, ScrY, ply )

	if not self:GetAirBrake() then return end

	draw.SimpleText( "!!Air Brake!!" , "LVS_FONT",  X, Y, Color(255,0,0,math.abs( math.cos( CurTime() * 5) ) * 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:StartJericho()
	else
		self:StopJericho()
	end
end

function ENT:OnRemoved()
	self:StopJericho()
end

function ENT:OnFrameActive()
	if not self._Jericho then return end

	local ply = LocalPlayer()

	if not IsValid( ply ) then return end

	local Vel = self:GetVelocity():Length()

	if self:GetAirBrake() then
		Vel = Vel * 1.25
	end

	local volume = math.Clamp((Vel - self.MaxVelocity) / 500,0,1)

	local pitch = 110 * self:CalcDoppler( ply ) * (0.75 + 0.25 * volume)

	if ply:GetViewEntity() == ply and ply:lvsGetVehicle() == self then
		self._Jericho:ChangeVolume( volume, 1 )
		self._Jericho:ChangePitch( pitch, 1 )
	else
		self._smJerVolume = self._smJerVolume and (self._smJerVolume + math.Clamp(volume - self._smJerVolume,-0.25,1) * FrameTime() * 2) or 0

		self._Jericho:ChangeVolume( self._smJerVolume, 0.2 )
		self._Jericho:ChangePitch( pitch, 0.4 )
	end
end

function ENT:StartJericho()
	if self:GetMutedJericho() then return end

	self._Jericho = CreateSound( self, "lvs/vehicles/stuka/jericho.wav" )
	self._Jericho:SetSoundLevel( 140 )
	self._Jericho:PlayEx(0,100)
end

function ENT:StopJericho()
	if not self._Jericho then return end

	self._Jericho:Stop()
	self._Jericho = nil
end

function ENT:OnSpawn()
	self:RegisterTrail( Vector(-22.64,277.91,99.35), 0, 20, 2, 1000, 600 )
	self:RegisterTrail( Vector(-22.64,-277.91,99.35), 0, 20, 2, 1000, 600 )

	self:CreateBonePoseParameter( "cabin", 18, Angle(0,0,0), Angle(0,0,0), Vector(0,0,0), Vector(0,0,-20) )
end

function ENT:OnFrame()
	local FT = RealFrameTime()

	self:AnimControlSurfaces( FT )
	self:AnimLandingGear( FT )
	self:AnimRotor( FT )
	self:AnimJerichos( FT )
	self:AnimBombLauncher( FT )
	self:PredictPoseParamaters()
end

function ENT:AnimBombLauncher( frametime )
	local BombActive = self:GetBodygroup( 6 ) == 1

	if self._oldBombActive ~= BombActive then
		self._oldBombActive = BombActive

		if not BombActive then
			self:EmitSound("buttons/lever7.wav",75,60,1)

			self.smBomb = 1
		end
	end

	if not self.smBomb then return end

	self.smBomb = math.max(self.smBomb - frametime * 2,0)

	self:ManipulateBoneAngles( 16, Angle(-70 * math.sin( self.smBomb * math.pi ),0,0) )
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

function ENT:AnimJerichos( frametime )
	if not self._Jericho then return end

	local JerichoRPM = math.min( self._Jericho:GetVolume() * 10, 1 ) ^ 2 * 2000 + math.min( (self:GetVelocity():Length() / 1000) ^ 2, 1 ) * 500

	self.smJerichoRPM = self.smJerichoRPM and self.smJerichoRPM + (JerichoRPM - self.smJerichoRPM) * frametime * 0.05 or 0

	self._jRPM = self._jRPM and (self._jRPM + JerichoRPM *  frametime) or 0

	local Rot1 = Angle(self._jRPM * 0.99,0,0)
	Rot1:Normalize() 
	local Rot2 = Angle(self._jRPM * 1.01,0,0)
	Rot2:Normalize() 

	self:ManipulateBoneAngles( 9, Rot1 )
	self:ManipulateBoneAngles( 14, Rot2 )
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

	self.smAirBrake = self.smAirBrake and self.smAirBrake + ((self:GetAirBrake() and 1 or 0) - self.smAirBrake) * FT * 1 or 0

	self:ManipulateBoneAngles( 6, Angle(-90 * self.smAirBrake,0,0 ) )
	self:ManipulateBoneAngles( 11, Angle(90 * self.smAirBrake,0,0 ) )
end

function ENT:AnimLandingGear( frametime )
	self._smLandingGear = self._smLandingGear and self._smLandingGear + (self:GetLandingGear() - self._smLandingGear) * frametime * 8 or 0

	self:ManipulateBoneAngles( 7, Angle(-65 * self._smLandingGear,0,0) )
	self:ManipulateBoneAngles( 8, Angle(-45 * self._smLandingGear,0,0) )
	self:ManipulateBoneAngles( 12, Angle(65 * self._smLandingGear,0,0) )
	self:ManipulateBoneAngles( 13, Angle(45 * self._smLandingGear,0,0) )
end
