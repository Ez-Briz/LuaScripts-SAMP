script_name("Check /pt")
script_description("Проверяет на наличие розыска всех в радиусе рендера")
script_author("Ez-Briz")

KEY = 76
pt_activated = "{FFF000}[Проверка]: {FF0000}Преступник обнаружен!"
local found = false
require "lib.moonloader"
local sampev = require 'lib.samp.events'
local pattern = "Данный игрок не в розыске"
function main()
	if not isSampLoaded() or not isCleoLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	while not sampIsLocalPlayerSpawned() do wait(100) end
	while true do
		wait(0)

		found = false
		if isKeyJustPressed(KEY) and isKeyDown(18) then
			sampAddChatMessage("{FFF000}[Проверка]: {FFFFFF}Сканер преступников активирован.", 0xFFFFFF)
			for i=0, sampGetMaxPlayerId() do
				if sampIsPlayerConnected(i) then
					local result, cped = sampGetCharHandleBySampPlayerId(i)


					if result then
						local hisx,hisy,hisz = getCharCoordinates(cped)
						local myx, myy, myz = getCharCoordinates(PLAYER_PED)
						if (math.sqrt(math.abs(math.pow((hisx - myx), 2)+math.pow((hisy - myy), 2) + math.pow((hisz - myz), 2)))) < 60 then
							sampAddChatMessage(string.format("{FFF000}[Проверка]: {FFFFFF}Проверка {FF0000}%d {FFFFFF}ID.", i), 0xFFFFFF)
							sampSendChat(string.format("/pt %d", i))
							wait(400)
						end
					end
				end
			end
			if found then sampAddChatMessage("{FFF000}[Проверка]: {FFFFFF}Проверка завершена, преступник {FF0000}найден.", 0xFFFFFF)
		else sampAddChatMessage("{FFF000}[Проверка]: {FFFFFF}Проверка завершена, преступник {00FF00}не найден.", 0xFFFFFF) end
		found = false
		end
	end
end

function sampev.onServerMessage(color, message)
	if string.find(message,"Данный игрок не в розыске или уровень розыска меньше 2", 1, true) then
		return false
	end
	if string.find(message, "далеко друг от друга", 1, true) then
		sampAddChatMessage(pt_activated, 0xFFFFFF)
		found = true
		return false
	end
end
