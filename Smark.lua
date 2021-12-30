script_name("Smark by EzBriz")
script_description("Пробивает /setmark по номеру, использовать /smark ID")
script_author("EzBriz")

require "lib.moonloader"
local sampev = require 'lib.samp.events'
local flag = false
local number = 0
function main()
	if not isSampLoaded() or not isCleoLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	while not sampIsLocalPlayerSpawned() do wait(100) end

	sampRegisterChatCommand("smark", mark)
	while true do
		wait(0)
	end
end

function mark(id)
	if id == "" then
		sampAddChatMessage("{FFF000}[Smark]: {FFFFFF}Используйте {FFF000}/smark \'ID\'{FFFFFF}.", 0xFFFFFF)
		return
	end
		flag = true
 		sampSendChat("/number " .. id)
end

function sampev.onServerMessage(_, message)
	if (string.find(message, "Номер", 1, true) ~= nil and flag) then
		number = string.sub(message, string.find(message, "%d%d%d%d%d", 1, false), -1)
		sampAddChatMessage(message, 0xFFFFFF)
		sampSendChat("/setmark " .. number)
		flag = false
	end
end
