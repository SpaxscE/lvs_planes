include("shared.lua")
include( "cl_prediction.lua" )

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

	local volume = math.Clamp((self:GetVelocity():Length() - self.MaxVelocity) / 500,0,1)

	local pitch = 100 * self:CalcDoppler( LocalPlayer() ) * (0.75 + 0.25 * volume)

	self._Jericho:ChangeVolume( volume, 1 )
	self._Jericho:ChangePitch( pitch, 1 )
end

function ENT:StartJericho()
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
