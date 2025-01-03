
ENT.Base = "lvs_base_fighterplane"

ENT.PrintName = "Zero"
ENT.Author = "Luna"
ENT.Information = "Japanese World War 2 Manned Steerable Bomb"
ENT.Category = "[LVS] - Planes"

ENT.VehicleCategory = "Planes"
ENT.VehicleSubCategory = "Fighters"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/blu/zero.mdl"

ENT.AITEAM = 1

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

function ENT:InitWeapons()
	self.PosLMG = Vector(70.82,8.82,95.83)
	self.DirLMG = 0
	self:AddWeapon( LVS:GetWeaponPreset( "LMG" ) )

	self.PosHMG = Vector(67.36,86.55,69.35)
	self.DirHMG = 0.5
	self:AddWeapon( LVS:GetWeaponPreset( "HMG" ) )

	self:AddWeapon( LVS:GetWeaponPreset( "TURBO" ) )
end

ENT.FlyByAdvance = 0.65
ENT.FlyBySound = "lvs/vehicles/zero/flyby.wav" 
ENT.DeathSound = "LVS_FIGHTERPLANE_CRASH"

ENT.EngineSounds = {
	{
		sound = "^lvs/vehicles/zero/dist.wav",
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
		sound = "lvs/vehicles/zero/engine_low.wav",
		sound_int = "lvs/vehicles/zero/engine_low_int.wav",
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
		sound = "lvs/vehicles/zero/engine_high.wav",
		sound_int = "lvs/vehicles/zero/engine_high_int.wav",
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
	{
		pos = Vector(67.84,-18.61,87.15),
		ang = Angle(-90,20,0),
	},
	{
		pos = Vector(66.36,-21.87,79.01),
		ang = Angle(-90,20,0),
	},
	{
		pos = Vector(66.09,-22.23,70.26),
		ang = Angle(-90,20,0),
	},
	{
		pos = Vector(65.86,-18.2,62.44),
		ang = Angle(-90,20,0),
	},
}
