
ENT.Base = "lvs_base_fighterplane"

ENT.PrintName = "Ju-87"
ENT.Author = "Luna"
ENT.Information = "German World War 2 Dive Bomber"
ENT.Category = "[LVS] - Planes"

ENT.VehicleCategory = "Planes"
ENT.VehicleSubCategory = "Bombers"

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

ENT.MaxSlipAnglePitch = 20
ENT.MaxSlipAngleYaw = 10

ENT.MaxHealth = 650

function ENT:OnSetupDataTables()
	self:AddDT( "Entity", "GunnerSeat" )
	self:AddDT( "Bool", "AirBrake" )
	self:AddDT( "Bool", "MutedJericho",	{ KeyName = "mutedjericho",	Edit = { type = "Boolean",	order = 3,	category = "Misc"} } )
end

function ENT:SetPoseParameterMG( weapon )
	local ID = self:LookupAttachment( "mg" )
	local MG = self:GetAttachment( ID )

	if not MG then return end

	local trace = weapon:GetEyeTrace()

	local _,Ang = WorldToLocal( Vector(0,0,0), (trace.HitPos - MG.Pos):GetNormalized():Angle(), Vector(0,0,0), self:LocalToWorldAngles( Angle(0,180,0) ) )

	self:SetPoseParameter("mg_pitch", Ang.p )
	self:SetPoseParameter("mg_yaw", Ang.y )
end

function ENT:InitWeapons()
	self.PosLMG = Vector(27.94,81.46,79.95)
	self.DirLMG = 0.65
	self:AddWeapon( LVS:GetWeaponPreset( "LMG" ) )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/bomb.png")
	weapon.Ammo = 1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 1
	weapon.StartAttack = function( ent )
		local Driver = ent:GetDriver()

		local projectile = ents.Create( "lvs_bomb" )
		projectile:SetPos( ent:LocalToWorld( Vector(-8,0,65) ) )
		projectile:SetAngles( ent:GetAngles() )
		projectile:SetParent( ent )
		projectile:Spawn()
		projectile:Activate()
		projectile:SetModel("models/blu/stuka_bomb.mdl")
		projectile:SetAttacker( IsValid( Driver ) and Driver or ent )
		projectile:SetEntityFilter( ent:GetCrosshairFilterEnts() )
		projectile:SetSpeed( ent:GetVelocity() )
		projectile:SetDamage( 6000 )

		self._ProjectileEntity = projectile
	end
	weapon.FinishAttack = function( ent )
		if not IsValid( ent._ProjectileEntity ) then return end

		ent._ProjectileEntity:Enable()

		timer.Simple(0.1, function()
			if not IsValid( ent ) then return end
			ent:SetBodygroup( 6, 0 )
		end)

		ent:TakeAmmo()
		ent:SetHeat( 1 )
		ent:SetOverheated( true )
	end
	self:AddWeapon( weapon )


	local weapon = {}
	weapon.Icon = Material("lvs/weapons/stuka_airbrake.png")
	weapon.UseableByAI = false
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 1
	weapon.StartAttack = function( ent )
		if not ent.SetAirBrake then return end

		if ent:GetAI() then return end

		ent:SetAirBrake( not ent:GetAirBrake() )

		if ent:GetAirBrake() then
			ent:EmitSound( "npc/dog/dog_pneumatic1.wav", 75, 100 )
			ent.MaxSlipAnglePitch = 0
		else
			ent:EmitSound( "ambient/materials/shutter8.wav", 75, 100 )
			ent.MaxSlipAnglePitch = 20
		end
	end
	self:AddWeapon( weapon )



	local COLOR_RED = Color(255,0,0,255)
	local COLOR_WHITE = Color(255,255,255,255)
	self.RearGunAngleRange = 30

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Ammo = -1
	weapon.Delay = 0.15
	weapon.Attack = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "mg_muzzle" )
		local Muzzle = base:GetAttachment( ID )

		if not Muzzle then return end

		local RearGunInRange = ent:AngleBetweenNormal( ent:GetAimVector(), ent:GetForward() ) < base.RearGunAngleRange

		if not RearGunInRange then
			if IsValid( base.SNDTurret ) then
				base.SNDTurret:Stop()
			end

			return true
		else
			if IsValid( base.SNDTurret ) then
				base.SNDTurret:Play()
			end
		end

		local trace = ent:GetEyeTrace()

		local effectdata = EffectData()
		effectdata:SetOrigin( Muzzle.Pos )
		effectdata:SetNormal( -Muzzle.Ang:Right() )
		effectdata:SetEntity( base )
		util.Effect( "lvs_muzzle", effectdata )

		local bullet = {}
		bullet.Src = Muzzle.Pos
		bullet.Dir = (trace.HitPos - Muzzle.Pos):GetNormalized()
		bullet.Spread 	= Vector( 0.03,  0.03, 0.03 )
		bullet.TracerName = "lvs_tracer_yellow"
		bullet.Force	= 10
		bullet.HullSize 	= 25
		bullet.Damage	= 45
		bullet.Velocity = 30000
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo) end
		ent:LVSFireBullet( bullet )

		ent:TakeAmmo()
	end
	weapon.StartAttack = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) or not IsValid( base.SNDTurret ) then return end

		base.SNDTurret:Play()
	end
	weapon.FinishAttack = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) or not IsValid( base.SNDTurret ) then return end

		base.SNDTurret:Stop()
	end
	weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end
	weapon.OnThink = function( ent, active )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		base:SetPoseParameterMG( ent )
	end
	weapon.CalcView = function( ent, ply, pos, angles, fov, pod )
		local base = ent:GetVehicle()

		if not IsValid( base ) then 
			return LVS:CalcView( ent, ply, pos, angles, fov, pod )
		end

		local TargetZoom = ply:lvsKeyDown( "ZOOM" ) and 1 or 0

		ent.smZoom = ent.smZoom and (ent.smZoom + (TargetZoom - ent.smZoom) * RealFrameTime() * 10) or 0

		if pod:GetThirdPersonMode() then
			pos = pos + base:GetUp() * 100
		else
			local ID = base:LookupAttachment( "mg" )
			local MG = base:GetAttachment( ID )

			if MG then
				pos = MG.Pos + MG.Ang:Up() * (8 - 4.5 * ent.smZoom) - MG.Ang:Forward() * (20 - 15 * ent.smZoom)
			end
		end

		return LVS:CalcView( base, ply, pos, angles, fov, pod )
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local RearGunInRange = ent:AngleBetweenNormal( ent:GetAimVector(), ent:GetForward() ) < base.RearGunAngleRange

		local Col = RearGunInRange and COLOR_WHITE or COLOR_RED

		local Pos2D = ent:GetEyeTrace().HitPos:ToScreen() 

		base:PaintCrosshairCenter( Pos2D, Col )
		base:PaintCrosshairOuter( Pos2D, Col )
		base:LVSPaintHitMarker( Pos2D )
	end
	self:AddWeapon( weapon, 2 )
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
