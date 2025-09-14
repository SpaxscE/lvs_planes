AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_prediction.lua" )
include("shared.lua")

ENT.WheelAutoRetract = true

ENT.DriverActiveSound = "common/null.wav"
ENT.DriverInActiveSound = "common/null.wav"

function ENT:OnSpawn( PObj )
	PObj:SetMass( 2000 )

	local DriverSeat = self:AddDriverSeat( Vector(-23,-1.9,95.5), Angle(0,-90,0) )
	self:SetGunnerSeat( self:AddPassengerSeat( Vector(-65,0,90), Angle(0,90,0) ) )

	local DoorHandler = self:AddDoorHandler( "!cabin" )
	DoorHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	DoorHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	DoorHandler:LinkToSeat( DriverSeat )

	self:AddWheel( Vector(22,60,15.16), 16, 400 )
	self:AddWheel( Vector(22,-60,15.16), 16, 400 )
	self:AddWheel( Vector(-270,0,70), 10, 250, LVS.WHEEL_STEER_REAR )

	self:AddEngine( Vector(75,0,92) )

	local Rotor = self:AddRotor( Vector(135,0,92) )	
	Rotor:SetSound("lvs/vehicles/generic/bomber_propeller.wav")
	Rotor:SetSoundStrain("lvs/vehicles/generic/bomber_propeller_strain.wav")

	local ID = self:LookupAttachment( "mg_muzzle" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/weapons/gunner_mg_loop.wav", "lvs/weapons/gunner_mg_loop_interior.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )

	self:SetBodygroup( 6, 1 ) 
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/stuka/engine_start.wav" )
	else
		self:EmitSound( "lvs/vehicles/stuka/engine_stop.wav" )
	end
end

function ENT:OnCollision( data, physobj )
	if self:WorldToLocal( data.HitPos ).z < 40 then return true end -- dont detect collision  when the lower part of the model touches the ground

	return false
end

function ENT:OnMaintenance(entity)
	self:SetBodygroup( 6, 1 )
end

function ENT:HandleAirBrake()
	if not self:GetAirBrake() then return end

	local PhysObj = self:GetPhysicsObject()

	if not IsValid( PhysObj ) then return end

	local Vel = PhysObj:GetVelocity()

	local Mul = math.max( Vel:Length() - self.MaxVelocity, 0 ) / 3000

	PhysObj:ApplyForceCenter( -Vel * PhysObj:GetMass() * FrameTime() * Mul )
end

function ENT:OnTick()
	self:HandleAirBrake()
end