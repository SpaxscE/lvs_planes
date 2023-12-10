AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

ENT.DriverActiveSound = "common/null.wav"
ENT.DriverInActiveSound = "common/null.wav"

function ENT:OnSpawn( PObj )
	PObj:SetMass( 5000 )

	local DriverSeat = self:AddDriverSeat( Vector(29,0,61), Angle(0,-90,0) )

	local DoorHandler = self:AddDoorHandler( "!cabin" )
	DoorHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	DoorHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	DoorHandler:LinkToSeat( DriverSeat )

	self:AddWheel( Vector(80.28,45,11.05), 10, 300 )
	self:AddWheel( Vector(80.28,-45,11.05), 10, 300 )
	self:AddWheel( Vector(-150.29,0,64), 10, 200, LVS.WHEEL_STEER_REAR )

	self:AddEngine( Vector(115,0,75.52) )

	self:AddRotor( Vector(165,0,75.52) )
end

function ENT:OnLandingGearToggled( IsDeployed )
	self:EmitSound( "lvs/vehicles/generic/gear.wav" )
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/spitfire/engine_start.wav" )
	else
		self:EmitSound( "lvs/vehicles/spitfire/engine_stop.wav" )
	end
end