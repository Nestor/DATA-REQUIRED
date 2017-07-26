
local hudhide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudCrosshair = true,
	CHudAmmo = true,
	CHudDamageIndicator = true,
}
hook.Add("HUDShouldDraw", "data_hudhide", function(n)
	if hudhide[n] then return false end
end)

-- Health bar HUD
local barcolor = Color(0,0,0)
local fillcolor = Color(255,255,255)
local x = 700
local y = 50

local damagetime = 0
local damagescale = 0
local lasthealth = 0
hook.Add("HUDPaint", "data_healthhud", function()
	local w,h = ScrW(),ScrH()
	local health = LocalPlayer():Health()
	if health < lasthealth then
		damagescale = (lasthealth-health)*0.1
		damagetime = CurTime() + 0.01*(lasthealth-health)
	end
	lasthealth = health
	
	local tx, ty, tw, th = w/2-x/2, h-50-y, x, y
	local tx2, ty2, tw2, th2 = w/2-x/2 + 5, h-50-y + 5, (x - 10)*health/100, y - 10
	if damagetime > CurTime() then
		tx = tx + math.random(-damagescale,damagescale)
		ty = ty + math.random(-damagescale,damagescale)
		--tw = tw + math.random(-damagescale,damagescale)
		--th = th + math.random(-damagescale,damagescale)
		tx2 = tx2 + math.random(-damagescale,damagescale)
		ty2 = ty2 + math.random(-damagescale,damagescale)
		--tw2 = tw2 + math.random(-damagescale,damagescale)
		--th2 = th2 + math.random(-damagescale,damagescale)
		
		local num = math.random(damagescale)
		surface.SetDrawColor(150,255,150,100)
		for i = 1, num do
			local rw = math.random(10,100)
			local rh = math.random(10,30)
			local rx = math.random(tx-rw-10, tx+tw)
			local ry = math.random(ty-rh-10, ty+th)
			surface.DrawRect(rx, ry, rw, rh)
			
			--[[local rx2 = math.random(-100,100)
			local ry2 = math.random(-50,50)
			local w2 = math.random(w)
			local h2 = math.random(h)
			
			surface.DrawRect(w2, (h+ry2)%h, rw, rh)
			surface.DrawRect((w+rx2)%w, h2, rw, rh)]]
		end
	end
	
	surface.SetDrawColor(0,20,0,100)
	surface.DrawRect(tx, ty, tw, th)
	surface.SetDrawColor(150,255,150,100)
	surface.DrawRect(tx2, ty2, tw2, th2)
end)

-- Weapon HUD

surface.CreateFont("DATAWeaponName", {
	font = "Arial",
	extended = false,
	size = 48,
	weight = 500,
	blursize = 0,
	scanlines = 3,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})
surface.CreateFont("DATAWeaponDesc", {
	font = "Arial",
	extended = false,
	size = 28,
	weight = 500,
	blursize = 0,
	scanlines = 3,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})
surface.CreateFont("DATAWeaponInstructions", {
	font = "Arial",
	extended = false,
	size = 24,
	weight = 500,
	blursize = 0,
	scanlines = 3,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

local textcolor = Color(200,255,200, 100)
local outlinecolor = Color(0,50,0, 100)
local outlinewidth = 2
hook.Add("HUDPaint", "data_weaponhud", function()
	local wep = LocalPlayer():GetActiveWeapon()
	if IsValid(wep) then
		local name = wep:GetPrintName()
		local desc = wep.Purpose
		local control = wep.Instructions
		local w,h = ScrW(), ScrH()
		
		draw.SimpleTextOutlined(name, "DATAWeaponName", w/2, h-140, textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, outlinewidth, outlinecolor)
		draw.SimpleTextOutlined(desc, "DATAWeaponDesc", w/2, h-120, textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, outlinewidth, outlinecolor)
		draw.SimpleTextOutlined(control, "DATAWeaponInstructions", w/2, h-100, textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, outlinewidth, outlinecolor)
	end
end)

local effecttime = 0
function ShowScreenDistortions(max, time, x, y, w, h)
	effecttime = CurTime() + time
	hook.Add("HUDPaint", "data_distortions", function()
		local num = math.random(max)
		surface.SetDrawColor(150,255,150,100)
		for i = 1, num do
			local rw = math.random(10,100)
			local rh = math.random(10,30)
			local rx = math.random(w-rw)
			local ry = math.random(h-rh)
			surface.DrawRect(x+rx, y+ry, rw, rh)
		end
		if CurTime() > effecttime then
			hook.Remove("HUDPaint", "data_distortions")
		end
	end)
end