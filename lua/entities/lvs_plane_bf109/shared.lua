
ENT.Base = "lvs_base_fighterplane"

ENT.PrintName = "BF-109"
ENT.Author = "Luna"
ENT.Information = "German World War 2 Fighterplane"
ENT.Category = "[LVS] - Planes"

ENT.VehicleCategory = "Planes"
ENT.VehicleSubCategory = "Fighters"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/blu/bf109.mdl"

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
	self.PosLMG = Vector(109.29,7.13,92.85)
	self.DirLMG = 0
	self:AddWeapon( LVS:GetWeaponPreset( "LMG" ) )

	self.PosHMG = Vector(93.58,85.93,63.63)
	self.DirHMG = 0.5
	self:AddWeapon( LVS:GetWeaponPreset( "HMG" ) )

	self:AddWeapon( LVS:GetWeaponPreset( "TURBO" ) )
end

ENT.FlyByAdvance = 0.5
ENT.FlyBySound = "lvs/vehicles/bf109/flyby.wav" 
ENT.DeathSound = "lvs/vehicles/generic/crash.wav"

ENT.EngineSounds = {
	{
		sound = "^lvs/vehicles/bf109/dist.wav",
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
		sound = "lvs/vehicles/bf109/engine_compressor.wav",
		sound_int = "",
		Pitch = 50,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 60,
		FadeIn = 0.35,
		FadeOut = 1,
		FadeSpeed = 5,
		UseDoppler = true,
		VolumeMin = 0,
		VolumeMax = 0.25,
		SoundLevel = 120,
	},
	{
		sound = "lvs/vehicles/bf109/engine_low.wav",
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
		sound = "lvs/vehicles/bf109/engine_mid.wav",
		Pitch = 80,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 80,
		FadeIn = 0.15,
		FadeOut = 0.35,
		FadeSpeed = 1.5,
		UseDoppler = true,
	},
	{
		sound = "lvs/vehicles/bf109/engine_high.wav",
		sound_int = "lvs/vehicles/bf109/engine_high_int.wav",
		Pitch = 50,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 60,
		FadeIn = 0.35,
		FadeOut = 1,
		FadeSpeed = 1,
		UseDoppler = true,
	},
}

ENT.ExhaustPositions = {
	{
		pos = Vector(129.28,17.85,68.91),
		ang = Angle(-90,-20,0),
	},
	{
		pos = Vector(122.79,17.88,69.14),
		ang = Angle(-90,-20,0),
	},
	{
		pos = Vector(114.7,18.9,69.11),
		ang = Angle(-90,-20,0),
	},
	{
		pos = Vector(107.43,19.74,68.82),
		ang = Angle(-90,-20,0),
	},
	{
		pos = Vector(99.56,20.28,69.05),
		ang = Angle(-90,-20,0),
	},
	{
		pos = Vector(91.97,20.31,68.9),
		ang = Angle(-90,-20,0),
	},
	{
		pos = Vector(129.28,-17.85,68.91),
		ang = Angle(-90,20,0),
	},
	{
		pos = Vector(122.79,-17.88,69.14),
		ang = Angle(-90,20,0),
	},
	{
		pos = Vector(114.7,-18.9,69.11),
		ang = Angle(-90,20,0),
	},
	{
		pos = Vector(107.43,-19.74,68.82),
		ang = Angle(-90,20,0),
	},
	{
		pos = Vector(99.56,-20.28,69.05),
		ang = Angle(-90,20,0),
	},
	{
		pos = Vector(91.97,-20.31,68.9),
		ang = Angle(-90,20,0),
	},
}
