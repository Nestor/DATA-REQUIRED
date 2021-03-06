if SERVER then
	AddCSLuaFile()
end

if CLIENT then

	SWEP.PrintName     	    = "Fragment Cannon"

end

SWEP.Base			= "proto_base"

SWEP.Author			= "Zet0r"
SWEP.Contact		= "youtube.com/Zet0r"
SWEP.Purpose		= "Shoot a cannonball that explodes into a ring of fragments"
SWEP.Instructions	= "LMB to fire cannonball - LMB again to explode"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.HoldType = "revolver"

SWEP.AttachModel = "models/combine_turrets/floor_turret_gib3.mdl"
SWEP.AttachScale = 1.5
SWEP.AttachOffset = Vector(10,-4,0)

local speed = 300
local size = 30
local fragmentsize = 10
local fragmentspeed = 300
local numfragments = 30

local shootsound = Sound("weapons/ar2/ar2_altfire.wav")
local explodesound = Sound("weapons/ar2/npc_ar2_altfire.wav")

local explodefunc = function(bul, weapon, owner)
	sound.Play(explodesound, bul:GetPos(), 511, 100, 1)
	bul:Remove()
	
	for i = 1, numfragments do
		local vel = Angle(0,360/numfragments*i,0):Forward()*fragmentspeed
		local bul2 = owner:FireProjectile(fragmentsize, bul:GetPos(), vel, 100)
		bul2.WeaponClass = "proto_fragment"
	end
end

function SWEP:PrimaryAttack()
	if SERVER then
		if not IsValid(self.Bullet) then			
			local bullet = self.Owner:FireProjectileAim(size, speed, 100)
			local owner = self.Owner
			bullet:SetCollideFunction(function(self2, ent)
				explodefunc(self2, self, owner)
				if IsValid(self) then self:Finish() end
			end)
			bullet.WeaponClass = "proto_fragment"
			self.Bullet = bullet
			self.Owner:EmitSound(shootsound)
		else
			explodefunc(self.Bullet, self, self.Owner)
			self:Finish()
		end
	end
	
end

GAMEMODE:AddWeaponPickup("proto_fragment", 100, Color(250,250,150), SWEP.AttachModel, 3, Vector(5,-10,0), Angle(0,-45,0))