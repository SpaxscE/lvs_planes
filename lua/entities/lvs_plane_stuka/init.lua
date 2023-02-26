AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_prediction.lua" )
include("shared.lua")

ENT.WheelAutoRetract = true

function ENT:OnSpawn( PObj )
	PObj:SetMass( 2000 )

	self:AddDriverSeat( Vector(-23,-1.9,95.5), Angle(0,-90,0) )
	self:SetGunnerSeat( self:AddPassengerSeat( Vector(-65,0,90), Angle(0,90,0) ) )

	self:AddWheel( Vector(22,60,15.16), 16, 400 )
	self:AddWheel( Vector(22,-60,15.16), 16, 400 )
	self:AddWheel( Vector(-270,0,70), 10, 250, LVS.WHEEL_STEER_REAR )

	self:AddEngine( Vector(75,0,92) )

	local Rotor = self:AddRotor( Vector(135,0,92) )	
	Rotor:SetSound("lvs/vehicles/generic/bomber_propeller.wav")
	Rotor:SetSoundStrain("lvs/vehicles/generic/bomber_propeller_strain.wav")

	local Exhaust = {
		{
			pos = Vector(89.5,20,87),
			ang = Angle(-90,-20,0),
		},
		{
			pos = Vector(83,20,87),
			ang = Angle(-90,-20,0),
		},
		{
			pos = Vector(76.5,20,87),
			ang = Angle(-90,-20,0),
		},
		{
			pos = Vector(70,20,87),
			ang = Angle(-90,-20,0),
		},
		{
			pos = Vector(63.5,20,87),
			ang = Angle(-90,-20,0),
		},
		{
			pos = Vector(57,20,87),
			ang = Angle(-90,-20,0),
		},
	}
	for id, exh in pairs( Exhaust ) do
		for i = -1, 1, 2 do
			local pos = Vector( exh.pos.x, exh.pos.y * i, exh.pos.z )
			local ang = Angle( exh.ang.p, exh.ang.y * i, exh.ang.r )

			self:AddExhaust( pos, ang )
		end
	end

	local ID = self:LookupAttachment( "mg_muzzle" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/weapons/stuka_mg_loop.wav", "lvs/weapons/stuka_mg_loop_interior.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )

	self:SetBodygroup( 6, 1 ) 
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/bf109/engine_start.wav" )
	else
		self:EmitSound( "lvs/vehicles/bf109/engine_stop.wav" )
	end
end

function ENT:OnCollision( data, physobj )
	if self:WorldToLocal( data.HitPos ).z < 40 then return true end -- dont detect collision  when the lower part of the model touches the ground

	return false
end

function ENT:OnMaintenance()
	self:SetBodygroup( 6, 1 )
end

function ENT:HandleAirBrake()
	if not self:GetAirBrake() then return end

	local PhysObj = self:GetPhysicsObject()

	if not IsValid( PhysObj ) then return end

	local Vel = PhysObj:GetVelocity()

	local Mul = math.max( Vel:Length() - self.MaxVelocity, 0 ) / 15000

	PhysObj:ApplyForceCenter( -Vel * PhysObj:GetMass() * FrameTime() * Mul )
end

function ENT:OnTick()
	self:HandleAirBrake()
end