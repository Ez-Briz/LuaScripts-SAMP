script_name("NocolsForMine")
script_description("Nocols for any SAMP mine")
script_author("EzBriz")

require "lib.moonloader"
local MIN_PLAYERS = 7
local flag = false
function main()
	if not isSampLoaded() or not isCleoLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	while not sampIsLocalPlayerSpawned() do wait(100) end
	sampRegisterChatCommand("cols", colsonoff)
	while true do
		wait(0)
		local count = 0
		if flag then
			table = getAllChars()
			near = {}
			for i=1, #table do
				x1, y1, z1 = getCharCoordinates(table[i])
				x2, y2, z2 = getCharCoordinates(PLAYER_PED)
				if getDistanceBetweenCoords3d(x1, y1, z1, x2, y2, z2) < 5 then
					count = count+1
					near[#near+1] = table[i]
				end
			end
			if count >= MIN_PLAYERS then
				for i=1, #near do
					if not isCharDead(near[i]) and not isCharInAnyCar(near[i]) and not isCharInAnyHeli(near[i]) then
						if near[i] == PLAYER_PED then
							goto cont
						end
						setCharCollision(near[i], false)
					end
					::cont::
				end
			end
		end
	end
end

function colsonoff()
	flag = not flag
	if flag then
		sampAddChatMessage("{FFF000}[Cols]: {FFFFFF}Nocols for mine is on", 0xFFFFFF)
	else
		sampAddChatMessage("{FFF000}[Cols]: {FFFFFF}Nocols for mine is off", 0xFFFFFF)
	end
end
