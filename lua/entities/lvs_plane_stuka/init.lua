AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

ENT.WheelAutoRetract = true

function ENT:OnSpawn( PObj )
	PObj:SetMass( 2000 )

	self:AddDriverSeat( Vector(-23,-1.9,95.5), Angle(0,-90,0) )
	self:AddPassengerSeat( Vector(-65,0,90), Angle(0,90,0) )

	self:AddWheel( Vector(22,60,15.16), 16, 400 )
	self:AddWheel( Vector(22,-60,15.16), 16, 400 )
	self:AddWheel( Vector(-270,0,70), 10, 800, LVS.WHEEL_STEER_REAR )

	self:AddEngine( Vector(75,0,92) )

	self:AddRotor( Vector(135,0,92) )

	self:AddExhaust( Vector(65.04,-14.93,19.46), Angle(145,-90,0) )
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
