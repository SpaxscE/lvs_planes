AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

ENT.DriverActiveSound = "common/null.wav"
ENT.DriverInActiveSound = "common/null.wav"

function ENT:OnSpawn( PObj )
	PObj:SetMass( 5000 )

	local DriverSeat = self:AddDriverSeat( Vector(1,0,71.2), Angle(0,-90,0) )

	local DoorHandler = self:AddDoorHandler( "!cabin" )
	DoorHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	DoorHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	DoorHandler:LinkToSeat( DriverSeat )

	self:AddWheel( Vector(42,75,10), 10, 300 )
	self:AddWheel( Vector(42,-75,10), 10, 300 )
	self:AddWheel( Vector(-200,0,65), 10, 150, LVS.WHEEL_STEER_REAR )

	self:AddEngine( Vector(60,0,74.) )

	self:AddRotor( Vector(101.7429,0,74) )
end

function ENT:OnLandingGearToggled( IsDeployed )
	self:EmitSound( "lvs/vehicles/generic/gear.wav" )
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/zero/engine_start.wav" )
	else
		self:EmitSound( "lvs/vehicles/zero/engine_stop.wav" )
	end
end