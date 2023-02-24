
ENT.Base = "lvs_base_fighterplane"

ENT.PrintName = "Stuka"
ENT.Author = "Luna"
ENT.Information = "German World War 2 Drive Bomber"
ENT.Category = "[LVS] - Planes"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/blu/stuka.mdl"

ENT.AITEAM = 1

ENT.MaxVelocity = 2500
ENT.MaxPerfVelocity = 1800
ENT.MaxThrust = 1250

ENT.TurnRatePitch = 1
ENT.TurnRateYaw = 1
ENT.TurnRateRoll = 0.75

ENT.ForceLinearMultiplier = 1

ENT.ForceAngleMultiplier = 1
ENT.ForceAngleDampingMultiplier = 1

ENT.MaxSlipAnglePitch = 10
ENT.MaxSlipAngleYaw = 10

ENT.MaxHealth = 650

function ENT:InitWeapons()
	self.PosLMG = Vector(27.94,81.46,79.95)
	self.DirLMG = 0.65
	local weapon = LVS:GetWeaponPreset( "LMG" )
	weapon.StartAttack = function( ent )
		if not IsValid( ent.SoundEmitter1 ) then
			ent.SoundEmitter1 = ent:AddSoundEmitter( Vector(27.94,0,79.95), "lvs/weapons/mg_light_loop.wav", "lvs/weapons/mg_light_loop_interior.wav" )
			ent.SoundEmitter1:SetSoundLevel( 95 )
		end
		ent.SoundEmitter1:Play()
	end
	self:AddWeapon( weapon )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/bomb.png")
	weapon.Ammo = 12
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.Attack = function( ent )
		if not IsValid( self._ProjectileEntity ) then return end

		self._ProjectileEntity:SetSpeed( ent:GetVelocity() )
	end
	weapon.StartAttack = function( ent )
		local Driver = ent:GetDriver()

		local projectile = ents.Create( "lvs_bomb" )
		projectile:SetPos( ent:LocalToWorld( Vector(-8,0,65) ) )
		projectile:SetAngles( ent:GetAngles() )
		projectile:SetParent( ent )
		projectile:Spawn()
		projectile:Activate()
		projectile:SetModel("models/blu/stuka_bomb.mdl")
		projectile:SetSpeed( ent:GetVelocity() )
		projectile:SetAttacker( IsValid( Driver ) and Driver or ent )
		projectile:SetEntityFilter( ent:GetCrosshairFilterEnts() )

		self._ProjectileEntity = projectile
	end
	weapon.FinishAttack = function( ent )
		if not IsValid( ent._ProjectileEntity ) then return end

		ent._ProjectileEntity:Enable()
	end

	self:AddWeapon( weapon )
end

ENT.FlyByAdvance = 0.8
ENT.FlyBySound = "lvs/vehicles/stuka/flyby.wav" 
ENT.DeathSound = "lvs/vehicles/generic/crash.wav"

ENT.EngineSounds = {
	{
		sound = "^lvs/vehicles/stuka/dist.wav",
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
		sound = "lvs/vehicles/stuka/engine_low.wav",
		sound_int = "lvs/vehicles/stuka/engine_low_int.wav",
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
		sound = "lvs/vehicles/stuka/engine_high.wav",
		sound_int = "lvs/vehicles/stuka/engine_high_int.wav",
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
