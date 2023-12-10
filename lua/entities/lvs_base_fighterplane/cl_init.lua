include("shared.lua")
include("cl_camera.lua")
include("sh_camera_eyetrace.lua")
include("cl_hud.lua")
include("cl_flyby.lua")
include("cl_deathsound.lua")
include("cl_reflectorsight.lua")

local ExhaustSprite = Material( "effects/muzzleflash2" )

function ENT:DoExhaustFX()
	local Throttle = self:GetThrottle()

	local OffsetMagnitude = (8 + 4 * Throttle)

	local T = CurTime()
	local FT = RealFrameTime()

	local HP = self:GetHP()
	local MaxHP = self:GetMaxHP() 

	if HP <= 0 then return end

	render.SetMaterial( ExhaustSprite )

	local ShouldDoEffect = false

	if (self.NextFX or 0) < T then
		self.NextFX = T + 0.05 + (1 - Throttle) / 10

		ShouldDoEffect = true
	end
	
	for id, data in pairs( self.ExhaustPositions ) do
		if not self.ExhaustPositions[ id ].PosOffset then
			self.ExhaustPositions[ id ].PosOffset = 0
		end

		if not self.ExhaustPositions[ id ].NextFX then
			self.ExhaustPositions[ id ].NextFX = 0
		end

		local Pos = self:LocalToWorld( data.pos ) 
		local Dir = self:LocalToWorldAngles( data.ang ):Up()

		self.ExhaustPositions[ id ].PosOffset = self.ExhaustPositions[ id ].PosOffset + FT * (8 + 4 * Throttle)

		if ShouldDoEffect then
			if math.random(0,1) == 1 then
				self.ExhaustPositions[ id ].PosOffset = 0

				local effectdata = EffectData()
				effectdata:SetOrigin( Pos )
				effectdata:SetNormal( Dir )
				effectdata:SetMagnitude( Throttle )
				effectdata:SetEntity( self  )
				if HP > MaxHP * 0.25 then
					util.Effect( "lvs_exhaust", effectdata )
				else
					util.Effect( "lvs_exhaust_fire", effectdata )
				end
			end
		end

		if self.ExhaustPositions[ id ].PosOffset > 1 or Throttle < 0.5 then continue end

		local Size = math.min( 10 * (1 - self.ExhaustPositions[ id ].PosOffset ) ^ 2, 5 + 5 * Throttle )

		render.SetMaterial( ExhaustSprite )
		render.DrawSprite( Pos + Dir * self.ExhaustPositions[ id ].PosOffset * (5 + 5 * Throttle), Size, Size, color_white )
	end
end