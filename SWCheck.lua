script_name("SWCheck by Ez-Briz")
script_author("EzBriz")

require "lib.moonloader"
local ev = require'samp.events'
local act = require"moonloader".audiostream_state
local flag = false
local turn = false
local sound = 1

function main()
	if not isSampLoaded() or not isCleoLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	while not sampIsLocalPlayerSpawned() do wait(100) end
	sampRegisterChatCommand("SWCheck", Acheck)
	while true do
		wait(0)
		if turn then
			AHandle = loadAudioStream("moonloader/alarm.wav")
			setAudioStreamVolume(AHandle, sound)
			local th = lua_thread.create(soundup)
			setAudioStreamLooped(AHandle, 1)
			setAudioStreamState(AHandle, act.RESUME)
			--printStyledString("PRESS 'ALT'", 4000, 2)
			print('Started to "pilik"')
			while turn do
				wait(0)
				if isKeyJustPressed(18) then
					th:terminate()
					setAudioStreamVolume(AHandle, sound)
					setAudioStreamState(AHandle, act.STOP)
					releaseAudioStream(AHandle)
					turn = false
					print('"Pilik" ended!')
					break;
				end
			end
		end
	end
end

function ev.onServerMessage(_, message)
	if (string.find(message,'.*Администратор.*%[.*]:')  ~= nil and flag) then
		turn = true
	end
end

function Acheck()
	if flag then
		sampAddChatMessage("{FFF000}[AdmChecker]:{FFFFFF} Deactivated.", 0xFFFFFF)
	else
		sampAddChatMessage("{FFF000}[AdmChecker]:{FFFFFF} Activated.", 0xFFFFFF)
	end
	flag = not flag
end

function soundup()
	local Ssound = sound
	while(Ssound < 50) do
		Ssound = Ssound + 1
		setAudioStreamVolume(AHandle, Ssound)
		wait(500)
	end
end
