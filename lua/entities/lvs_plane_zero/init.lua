AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	PObj:SetMass( 5000 )

	self:AddDriverSeat( Vector(1,0,71.5), Angle(0,-90,0) )

	self:AddWheel( Vector(42,75,10), 10, 300 )
	self:AddWheel( Vector(42,-75,10), 10, 300 )
	self:AddWheel( Vector(-200,0,65), 10, 200, LVS.WHEEL_STEER_REAR )

	self:AddEngine( Vector(60,0,74.) )

	self:AddRotor( Vector(101.7429,0,74) )

	local Exhaust = {
		{
			pos = Vector(67.84,18.61,87.15),
			ang = Angle(-90,-20,0),
		},
		{
			pos = Vector(66.36,21.87,79.01),
			ang = Angle(-90,-20,0),
		},
		{
			pos = Vector(66.09,22.23,70.26),
			ang = Angle(-90,-20,0),
		},
		{
			pos = Vector(65.86,18.2,62.44),
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