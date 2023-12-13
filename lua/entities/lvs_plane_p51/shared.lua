
ENT.Base = "lvs_base_fighterplane"

ENT.PrintName = "P-51D"
ENT.Author = "Luna"
ENT.Information = "American World War 2 Fighterplane"
ENT.Category = "[LVS] - Planes"

ENT.VehicleCategory = "Planes"
ENT.VehicleSubCategory = "Fighters"

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
	weapon.Delay = 0.2
	weapon.HeatRateUp = 1.25
	weapon.HeatRateDown = 0.25
	weapon.Attack = function( ent )
		if not ent.MISSILE_ENTITIES then return end

		local Missile = ent.MISSILE_ENTITIES[ ent:GetAmmo() ]

		if not IsValid( Missile ) then return end

		Missile:SetNoDraw( true )
		Missile:EmitSound("LVS_MISSILE_FIRE")

		local bullet = {}
		bullet.Src 	= Missile:GetPos()
		bullet.Dir 	= Missile:GetAngles():Forward()
		bullet.Spread 	= Vector(0,0,0)
		bullet.TracerName = "lvs_tracer_missile"
		bullet.Force	= 15000
		bullet.HullSize 	= 100 * (1 - ent:GetLandingGear())
		bullet.Damage	= 750
		bullet.SplashDamage = 250
		bullet.SplashDamageRadius = 250
		bullet.SplashDamageEffect = "lvs_bullet_impact_explosive"
		bullet.SplashDamageType = DMG_BLAST
		bullet.Velocity = 7000
		bullet.Attacker 	= ent:GetDriver()

		ent:LVSFireBullet( bullet )

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

ENT.ExhaustPositions = {
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
	{
		pos = Vector(131,-20.5,84),
		ang = Angle(-90,20,0),
	},
	{
		pos = Vector(125,-20.5,84),
		ang = Angle(-90,20,0),
	},
	{
		pos = Vector(119,-20.5,84),
		ang = Angle(-90,20,0),
	},
	{
		pos = Vector(113,-20.5,84),
		ang = Angle(-90,20,0),
	},
	{
		pos = Vector(107,-20.5,84),
		ang = Angle(-90,20,0),
	},
	{
		pos = Vector(101,-20.5,84),
		ang = Angle(-90,20,0),
	},
}

