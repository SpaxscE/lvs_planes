
LVS:AddWeaponPreset( "LMG", {
	Icon = Material("lvs/weapons/mg.png"),
	Ammo = 1000,
	Delay = 0.1,
	Attack = function( ent )
		ent.MirrorPrimary = not ent.MirrorPrimary

		local Mirror = ent.MirrorPrimary and -1 or 1

		local Pos = ent:LocalToWorld( ent.PosLMG and Vector(ent.PosLMG.x,ent.PosLMG.y * Mirror,ent.PosLMG.z) or Vector(0,0,0) )
		local Dir = ent.DirLMG or 0

		local effectdata = EffectData()
		effectdata:SetOrigin( Pos )
		effectdata:SetNormal( ent:GetForward() )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )

		local bullet = {}
		bullet.Src =  Pos
		bullet.Dir = ent:LocalToWorldAngles( Angle(0,-Dir * Mirror,0) ):Forward()
		bullet.Spread 	= Vector( 0.015,  0.015, 0 )
		bullet.TracerName = "lvs_tracer_white"
		bullet.Force	= 1000
		bullet.HullSize 	= 50
		bullet.Damage	= 35
		bullet.Velocity = 30000
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo) end
		ent:LVSFireBullet( bullet )

		ent:TakeAmmo()
	end,
	StartAttack = function( ent )
		if not IsValid( ent.SoundEmitter1 ) then
			ent.SoundEmitter1 = ent:AddSoundEmitter( Vector(109.29,0,92.85), "lvs/weapons/mg_loop.wav", "lvs/weapons/mg_loop_interior.wav" )
			ent.SoundEmitter1:SetSoundLevel( 95 )
		end
	
		ent.SoundEmitter1:Play()
	end,
	FinishAttack = function( ent )
		if IsValid( ent.SoundEmitter1 ) then
			ent.SoundEmitter1:Stop()
			ent.SoundEmitter1:EmitSound("lvs/weapons/mg_lastshot.wav")
		end
	end,
	OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end,
	OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end,
} )

LVS:AddWeaponPreset( "TABLE_POINT_MG", {
	Icon = Material("lvs/weapons/mc.png"),
	Ammo = 2000,
	Delay = 0.1,
	Attack = function( ent )
		if not ent.PosTPMG or not ent.DirTPMG then return end

		for i = 1, 2 do
			ent._NumTPMG = ent._NumTPMG and ent._NumTPMG + 1 or 1

			if ent._NumTPMG > #ent.PosTPMG then ent._NumTPMG = 1 end
		
			local Pos = ent:LocalToWorld( ent.PosTPMG[ ent._NumTPMG ] )
			local Dir = ent.DirTPMG[ ent._NumTPMG ]

			local effectdata = EffectData()
			effectdata:SetOrigin( Pos )
			effectdata:SetNormal( ent:GetForward() )
			effectdata:SetEntity( ent )
			util.Effect( "lvs_muzzle", effectdata )

			local bullet = {}
			bullet.Src = Pos
			bullet.Dir = ent:LocalToWorldAngles( Angle(0,-Dir,0) ):Forward()
			bullet.Spread 	= Vector( 0.035,  0.035, 0 )
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.Force	= 1000
			bullet.HullSize 	= 25
			bullet.Damage	= 35
			bullet.Velocity = 40000
			bullet.Attacker 	= ent:GetDriver()
			bullet.Callback = function(att, tr, dmginfo) end
			ent:LVSFireBullet( bullet )
		end

		ent:TakeAmmo( 2 )
	end,
	StartAttack = function( ent )
		if not IsValid( ent.SoundEmitter1 ) then
			ent.SoundEmitter1 = ent:AddSoundEmitter( Vector(109.29,0,92.85), "lvs/weapons/mg_light_loop.wav", "lvs/weapons/mg_light_loop_interior.wav" )
			ent.SoundEmitter1:SetSoundLevel( 95 )
		end
	
		ent.SoundEmitter1:Play()
	end,
	FinishAttack = function( ent )
		if IsValid( ent.SoundEmitter1 ) then
			ent.SoundEmitter1:Stop()
			ent.SoundEmitter1:EmitSound("lvs/weapons/mg_light_lastshot.wav")
		end
	end,
	OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end,
	OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end,
} )

LVS:AddWeaponPreset( "HMG", {
	Icon = Material("lvs/weapons/hmg.png"),
	Ammo = 300,
	Delay = 0.14,
	Attack = function( ent )
		ent.MirrorSecondary = not ent.MirrorSecondary

		local Mirror = ent.MirrorSecondary and -1 or 1

		local Pos = ent:LocalToWorld( ent.PosHMG and Vector(ent.PosHMG.x,ent.PosHMG.y * Mirror,ent.PosHMG.z) or Vector(0,0,0) )
		local Dir = ent.DirHMG or 0.5

		local effectdata = EffectData()
		effectdata:SetOrigin( Pos )
		effectdata:SetNormal( ent:GetForward() )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )

		local bullet = {}
		bullet.Src = Pos
		bullet.Dir = ent:LocalToWorldAngles( Angle(0,-Dir * Mirror,0) ):Forward()
		bullet.Spread 	= Vector( 0.04,  0.04, 0 )
		bullet.TracerName = "lvs_tracer_orange"
		bullet.Force	= 4000
		bullet.HullSize 	= 15
		bullet.Damage	= 45
		bullet.SplashDamage = 75
		bullet.SplashDamageRadius = 200
		bullet.Velocity = 15000
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo)
		end
		ent:LVSFireBullet( bullet )

		ent:TakeAmmo()
	end,
	StartAttack = function( ent )
		if not IsValid( ent.SoundEmitter2 ) then
			ent.SoundEmitter2 = ent:AddSoundEmitter( Vector(109.29,0,92.85), "lvs/weapons/mc_loop.wav", "lvs/weapons/mc_loop_interior.wav" )
			ent.SoundEmitter2:SetSoundLevel( 95 )
		end

		ent.SoundEmitter2:Play()
	end,
	FinishAttack = function( ent )
		if IsValid( ent.SoundEmitter2 ) then
			ent.SoundEmitter2:Stop()
			ent.SoundEmitter2:EmitSound("lvs/weapons/mc_lastshot.wav")
		end
	end,
	OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft2.wav") end,
	OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end,
} )

LVS:AddWeaponPreset( "TURBO", {
	Icon = Material("lvs/weapons/nos.png"),
	HeatRateUp = 0.1,
	HeatRateDown = 0.1,
	UseableByAI = false,
	Attack = function( ent )
		local PhysObj = ent:GetPhysicsObject()
		if not IsValid( PhysObj ) then return end
		local THR = ent:GetThrottle()
		local FT = FrameTime()

		local Vel = ent:GetVelocity():Length()

		PhysObj:ApplyForceCenter( ent:GetForward() * math.Clamp(ent.MaxVelocity + 500 - Vel,0,1) * PhysObj:GetMass() * THR * FT * 150 ) -- increase speed
		PhysObj:AddAngleVelocity( PhysObj:GetAngleVelocity() * FT * 0.5 * THR ) -- increase turn rate
	end,
	StartAttack = function( ent )
		ent.TargetThrottle = 1.3
		ent:EmitSound("lvs/vehicles/generic/boost.wav")
	end,
	FinishAttack = function( ent )
		ent.TargetThrottle = 1
	end,
	OnSelect = function( ent )
		ent:EmitSound("buttons/lever5.wav")
	end,
	OnThink = function( ent, active )
		if not ent.TargetThrottle then return end

		local Rate = FrameTime() * 0.5

		ent:SetMaxThrottle( ent:GetMaxThrottle() + math.Clamp(ent.TargetThrottle - ent:GetMaxThrottle(),-Rate,Rate) )

		local MaxThrottle = ent:GetMaxThrottle()

		ent:SetThrottle( MaxThrottle )

		if MaxThrottle == ent.TargetThrottle then
			ent.TargetThrottle = nil
		end
	end,
	OnOverheat = function( ent ) ent:EmitSound("lvs/overheat_boost.wav") end,
} )


sound.Add( {
	name = "LVS_MISSILE_FIRE",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = {
		"^lvs/weapons/missile_1.wav",
		"^lvs/weapons/missile_2.wav",
		"^lvs/weapons/missile_3.wav",
		"^lvs/weapons/missile_4.wav",
	}
} )


