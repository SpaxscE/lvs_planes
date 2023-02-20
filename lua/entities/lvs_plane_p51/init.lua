AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	PObj:SetMass( 5000 )

	self:AddDriverSeat( Vector(15,0,75), Angle(0,-90,0) )

	self:AddWheel( Vector(62.5,55,15), 15, 300 )
	self:AddWheel( Vector(62.5,-55,15), 15, 300 )
	self:AddWheel( Vector(-132,0,45), 10, 300, LVS.WHEEL_STEER_REAR )

	self:AddEngine( Vector(100,0,82) )

	self:AddRotor( Vector(175,0,82) )

	local Exhaust = {
		{
			pos = Vector(131,20.5,84),
			ang = Angle(-90,-20,0),
		},
		{
			pos = Vector(125,20.5,84),
			ang = Angle(-90,-20,0),
		},
		{
			pos = Vector(119,20.5,84),
			ang = Angle(-90,-20,0),
		},
		{
			pos = Vector(113,20.5,84),
			ang = Angle(-90,-20,0),
		},
		{
			pos = Vector(107,20.5,84),
			ang = Angle(-90,-20,0),
		},
		{
			pos = Vector(101,20.5,84),
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

	self.MISSILE_ENTITIES = {}

	for ID, pos in pairs( self.MISSILE_POSITIONS ) do
		local Missile = ents.Create( "prop_dynamic" )
		Missile:SetModel( self.MISSILE_MDL )
		Missile:SetModelScale( 0.8 )
		Missile:SetPos( self:LocalToWorld( pos * 0.8 ) )
		Missile:SetAngles( self:LocalToWorldAngles( Angle(0, -self:Sign( pos.y ), 0 ) ) )
		Missile:SetMoveType( MOVETYPE_NONE )
		Missile:Spawn()
		Missile:Activate()
		Missile:SetNotSolid( true )
		Missile:DrawShadow( false )
		Missile:SetParent( self )
		Missile.DoNotDuplicate = true
		self:TransferCPPI( Missile )

		
		self.MISSILE_ENTITIES[ ID ] = Missile
	end
end

function ENT:OnMaintenance()
	if not self.MISSILE_ENTITIES then return end

	for _, Missile in pairs( self.MISSILE_ENTITIES ) do
		if not IsValid( Missile ) then continue end
		Missile:SetNoDraw( false )
	end
end

function ENT:OnLandingGearToggled( IsDeployed )
	self:EmitSound( "lvs/vehicles/generic/gear.wav" )
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/p51d/engine_start.wav" )
	else
		self:EmitSound( "lvs/vehicles/p51d/engine_stop.wav" )
	end
end