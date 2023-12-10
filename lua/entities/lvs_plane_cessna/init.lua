AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

ENT.WheelSteerAngle = 20
ENT.WheelAutoRetract = true

ENT.DriverActiveSound = "common/null.wav"
ENT.DriverInActiveSound = "common/null.wav"

function ENT:OnSpawn( PObj )
	PObj:SetMass( 1000 )

	local DriverSeat = self:AddDriverSeat( Vector(5,8,38), Angle(0,-90,0) )
	local PassengerSeat = self:AddPassengerSeat( Vector(5,-8,38), Angle(0,-90,0) )
	self:AddPassengerSeat( Vector(-35,-8,38), Angle(0,-90,0) )
	self:AddPassengerSeat( Vector(-35,8,38), Angle(0,-90,0) )

	local mins = self:OBBMins()
	local maxs = self:OBBMaxs()

	local DoorHandler = self:AddDoorHandler( "left_door", vector_origin, angle_zero, Vector(mins.x,0,mins.z), maxs )
	DoorHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	DoorHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	DoorHandler:LinkToSeat( DriverSeat )

	local DoorHandler = self:AddDoorHandler( "right_door", vector_origin, angle_zero, mins, Vector(maxs.x,0,maxs.z) )
	DoorHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	DoorHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	DoorHandler:LinkToSeat( PassengerSeat )

	local Wheel = self:AddWheel( Vector(-100,100,10), 15, 40 )
	Wheel:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	
	local Wheel = self:AddWheel( Vector(-100,-100,10), 15, 40 )
	Wheel:SetCollisionGroup( COLLISION_GROUP_DEBRIS )

	self:AddWheel( Vector(100,0,5), 15, 80, LVS.WHEEL_STEER_FRONT )

	self:AddEngine( Vector(40,0,45) )

	self:AddRotor( Vector(50,0,47.28) )
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/cessna/start.wav" )
	else
		self:EmitSound( "lvs/vehicles/cessna/stop.wav" )
	end
end
