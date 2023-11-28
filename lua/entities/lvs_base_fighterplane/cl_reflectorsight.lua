
ENT.ReflectorSight = true
ENT.ReflectorSightPos = Vector(51,-0.05,99.65)
ENT.ReflectorSightColor = Color(255,191,0,255)
ENT.ReflectorSightColorBG = Color(0,0,0,50)
ENT.ReflectorSightMaterial = Material("lvs/sights/german.png")
ENT.ReflectorSightMaterialRes = 128
ENT.ReflectorSightHeight = 2.85
ENT.ReflectorSightWidth = 1.55
ENT.ReflectorSightGlowMaterial = Material( "sprites/light_glow02_add" )
ENT.ReflectorSightGlowColor = Color(255,191,0,255)

function ENT:IsDrawingReflectorSight()
	if not self.ReflectorSight then return false end

	local Pod = self:GetDriverSeat()

	if not IsValid( Pod ) then return false end

	return not Pod:GetThirdPersonMode()
end

function ENT:DrawReflectorSight( Pos2D )
	local Pos = self:LocalToWorld( self.ReflectorSightPos )
	local Up = self:GetUp()
	local Right = self:GetRight()

	local Width = self.ReflectorSightWidth
	local Height = self.ReflectorSightHeight

	local TopLeft = (Pos + Up * Height - Right * Width):ToScreen()
	local TopRight = (Pos + Up * Height + Right * Width):ToScreen()
	local BottomLeft = (Pos - Right * Width):ToScreen()
	local BottomRight = (Pos + Right * Width):ToScreen()

	Pos = Pos:ToScreen()

	if not Pos.visible then return end

	local poly = {
		{ x = TopLeft.x, y = TopLeft.y },
		{ x = TopRight.x, y = TopRight.y },
		{ x = BottomRight.x, y = BottomRight.y },
		{ x = BottomLeft.x, y = BottomLeft.y },
	}

	local Ang = 0

	if TopLeft.x < TopRight.x then
		Ang = (Vector( TopLeft.x, 0, TopLeft.y ) - Vector( TopRight.x, 0, TopRight.y )):Angle().p
	else
		Ang = (Vector( TopRight.x, 0, TopRight.y ) - Vector( TopLeft.x, 0, TopLeft.y )):Angle().p - 180
	end

	draw.NoTexture()
	surface.SetDrawColor( self.ReflectorSightColorBG )
	surface.DrawPoly( poly )

	render.SetStencilWriteMask( 0xFF )
	render.SetStencilTestMask( 0xFF )
	render.SetStencilReferenceValue( 0 )
	render.SetStencilPassOperation( STENCIL_KEEP )
	render.SetStencilZFailOperation( STENCIL_KEEP )
	render.ClearStencil()

	render.SetStencilEnable( true )
	render.SetStencilReferenceValue( 1 )
	render.SetStencilCompareFunction( STENCIL_NEVER )
	render.SetStencilFailOperation( STENCIL_REPLACE )

	draw.NoTexture()
	surface.SetDrawColor( color_white )
	surface.DrawPoly( poly )

	render.SetStencilCompareFunction( STENCIL_EQUAL )
	render.SetStencilFailOperation( STENCIL_KEEP )

	surface.SetDrawColor( self.ReflectorSightColor )
	surface.SetMaterial( self.ReflectorSightMaterial )
	surface.DrawTexturedRectRotated( Pos2D.x, Pos2D.y, self.ReflectorSightMaterialRes, self.ReflectorSightMaterialRes, -Ang )

	render.SetStencilEnable( false )
end
