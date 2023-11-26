
ENT.ReflectorSight = true
ENT.ReflectorSightPos = Vector(51,-0.05,99.5)
ENT.ReflectorSightColor = Color(208,201,56,255)
ENT.ReflectorSightColorBG = Color(0,0,0,100)
ENT.ReflectorSightMaterial = Material("lvs/sights/german.png")
ENT.ReflectorSightMaterialRes = 128
ENT.ReflectorSightHeight = 3
ENT.ReflectorSightWidth = 1.6

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

	if not Pos:ToScreen().visible then return end

	local X = TopLeft.x
	local Y = TopLeft.y

	local W = TopRight.x - TopLeft.x
	local H = BottomLeft.y - TopLeft.y

	surface.SetDrawColor( self.ReflectorSightColorBG )
	surface.DrawRect(X,Y,W,H)

	local S = self.ReflectorSightMaterialRes
	local S05 = S * 0.5
	render.SetScissorRect(X,Y,X+W,Y+H, true )
		surface.SetDrawColor( self.ReflectorSightColor )
		surface.SetMaterial( self.ReflectorSightMaterial )
		surface.DrawTexturedRect( Pos2D.x - S05, Pos2D.y - S05, S, S )
	render.SetScissorRect( 0, 0, 0, 0, false )
end

function ENT:PaintCrosshairCenter( Pos2D, Col )
	if self:IsDrawingReflectorSight() then
		self:DrawReflectorSight( Pos2D )

		return
	end

	if not Col then
		Col = Color( 255, 255, 255, 255 )
	end

	local Alpha = Col.a / 255
	local Shadow = Color( 0, 0, 0, 80 * Alpha )

	surface.DrawCircle( Pos2D.x, Pos2D.y, 4, Shadow )
	surface.DrawCircle( Pos2D.x, Pos2D.y, 5, Col )
	surface.DrawCircle( Pos2D.x, Pos2D.y, 6, Shadow )
end

function ENT:PaintCrosshairOuter( Pos2D, Col )
	if self:IsDrawingReflectorSight() then return end

	if not Col then
		Col = Color( 255, 255, 255, 255 )
	end

	local Alpha = Col.a / 255
	local Shadow = Color( 0, 0, 0, 80 * Alpha )

	surface.DrawCircle( Pos2D.x,Pos2D.y, 17, Shadow )
	surface.DrawCircle( Pos2D.x, Pos2D.y, 18, Col )

	if LVS.AntiAliasingEnabled then
		surface.DrawCircle( Pos2D.x, Pos2D.y, 19, Color( Col.r, Col.g, Col.b, 150 * Alpha ) )
		surface.DrawCircle( Pos2D.x, Pos2D.y, 20, Shadow )
	else
		surface.DrawCircle( Pos2D.x, Pos2D.y, 19, Shadow )
	end
end

