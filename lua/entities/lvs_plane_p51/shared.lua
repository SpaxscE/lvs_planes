
ENT.Base = "lvs_base_fighterplane"

ENT.PrintName = "P-51D"
ENT.Author = "Luna"
ENT.Information = "American World War 2 Fighterplane"
ENT.Category = "[LVS] - Planes"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/blu/p51d.mdl"

ENT.AITEAM = 2

ENT.MaxVelocity = 2500
ENT.MaxPerfVelocity = 1800
ENT.MaxThrust = 1250

ENT.TurnRatePitch = 1
ENT.TurnRateYaw = 1
ENT.TurnRateRoll = 1

ENT.ForceLinearMultiplier = 1

ENT.ForceAngleMultiplier = 1
ENT.ForceAngleDampingMultiplier = 1

ENT.MaxSlipAnglePitch = 20
ENT.MaxSlipAngleYaw = 10

ENT.MaxHealth = 650

ENT.MISSILE_MDL = "models/blu/p47_missile.mdl"
ENT.MISSILE_POSITIONS = {
	[1] = Vector(40,-130,65),
	[2] = Vector(40,130,65),
	[3] = Vector(40,-157,68),
	[4] = Vector(40,157,68),
	[5] = Vector(40,-170.5,69),
	[6] = Vector(40,170.5,69),
	[7] = Vector(40,-144,67),
	[8] = Vector(40,144,67),
}

function ENT:InitWeapons()
	self.PosTPMG= { Vector(70.78,79.35,63.07), Vector(70.78,-79.35,63.07), Vector(70.74,-88.45,63.69), Vector(70.74,88.45,63.69), Vector(70.88,97.43,64.43), Vector(70.88,-97.43,64.43), }
	self.DirTPMG= { 0.5, -0.5, -0.5, 0.5, 0.4, -0.4 }
	self:AddWeapon( LVS:GetWeaponPreset( "TABLE_POINT_MG" ) )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/missile.png")
	weapon.UseableByAI = false
	weapon.Ammo = 8
	weapon.Delay = 0.1
	weapon.HeatRateUp = 2.5
	weapon.HeatRateDown = 1
	weapon.Attack = function( ent )
		if not ent.MISSILE_ENTITIES then return end

		local Missile = ent.MISSILE_ENTITIES[ ent:GetAmmo() ]

		if not IsValid( Missile ) then return end

		Missile:SetNoDraw( true )

		local projectile = ents.Create( "lvs_missile" )
		projectile:SetPos( Missile:GetPos() )
		projectile:SetAngles( Missile:GetAngles() )
		projectile:SetOwner( ent )
		projectile:Spawn()
		projectile:Activate()
		projectile:SetAttacker( ent:GetDriver() )
		projectile:SetEntityFilter( ent:GetCrosshairFilterEnts() )
		projectile:SetSpeed( ent:GetVelocity():Length() + 4000 )
		projectile:SetDamage( 250 )
		projectile:Enable()

		ent:TakeAmmo()
	end
	self:AddWeapon( weapon )
end

ENT.FlyByAdvance = 0.5
ENT.FlyBySound = "lvs/vehicles/p51d/flyby.wav" 
ENT.DeathSound = "lvs/vehicles/generic/crash.wav"

ENT.EngineSounds = {
	{
		sound = "^lvs/vehicles/p51d/dist.wav",
		sound_int = "",
		Pitch = 80,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 40,
		FadeIn = 0.35,
		FadeOut = 1,
		FadeSpeed = 1.5,
		UseDoppler = true,
		VolumeMin = 0,
		VolumeMax = 1,
		SoundLevel = 110,
	},
	{
		sound = "lvs/vehicles/p51d/engine_low.wav",
		sound_int = "lvs/vehicles/p51d/engine_low_int.wav",
		Pitch = 80,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 300,
		FadeIn = 0,
		FadeOut = 0.15,
		FadeSpeed = 1.5,
		UseDoppler = false,
	},
	{
		sound = "lvs/vehicles/p51d/engine_high.wav",
		sound_int = "lvs/vehicles/p51d/engine_high_int.wav",
		Pitch = 50,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 60,
		FadeIn = 0.15,
		FadeOut = 1,
		FadeSpeed = 1,
		UseDoppler = true,
	},
}
