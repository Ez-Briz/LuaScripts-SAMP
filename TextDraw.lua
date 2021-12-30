script_name("Clicker on TextDraws by EzBriz")
script_author("EzBriz")


require "lib.moonloader"
local vk = require'lib.vkeys'
local ev = require'lib.samp.events'
local raknet = require'lib.samp.raknet'
local first = 2085
local second = 2083
local third = 2082
local fourth = 2084
local start = 2080
function main()
	if not isSampLoaded() or not isCleoLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	while not sampIsLocalPlayerSpawned() do wait(100) end
	sampRegisterChatCommand("sid", SetTextDraws)
	local font = renderCreateFont("Arial", 8, 5)
	sampfuncsRegisterConsoleCommand("delid", del)
	sampfuncsRegisterConsoleCommand("showid", show)
	while true do
		wait(0)
		if toggle then
			for a = 0, 2304	do
				if sampTextdrawIsExists(a) then
					x, y = sampTextdrawGetPos(a)
					x1, y1 = convertGameScreenCoordsToWindowScreenCoords(x, y)
					renderFontDrawText(font, a, x1, y1, 0xFFBEBEBE)
				end
			end
		end
		if (isKeyJustPressed(vk.VK_UP)) then
			if(sampTextdrawIsExists(first))
			then
				sampSendClickTextdraw(first)
			end
		end
		if (isKeyJustPressed(vk.VK_DOWN)) then
			if(sampTextdrawIsExists(second))
			then
				sampSendClickTextdraw(second)
			end
		end
		if (isKeyJustPressed(vk.VK_LEFT)) then
			if(sampTextdrawIsExists(third))
			then
				sampSendClickTextdraw(third)
			end
		end
		if (isKeyJustPressed(vk.VK_RIGHT)) then
			if(sampTextdrawIsExists(fourth))
			then
				sampSendClickTextdraw(fourth)
			end
		end
		if (isKeyJustPressed(vk.VK_SPACE)) then
			if(sampTextdrawIsExists(start))
			then
				sampSendClickTextdraw(start)
			end
		end
	end
end

function SetTextDraws(Text)
	local Fid, Sid, Tid, Ffid, Ssid
	Fid = tonumber(string.sub(Text, 0, 4))
	Sid = tonumber(string.sub(Text, 6, 9))
	Tid = tonumber(string.sub(Text, 10, 14))
	Ffid = tonumber(string.sub(Text, 15, 19))
	Ssid = tonumber(string.sub(Text, 20, 24))
	if (tonumber(Fid) ~= nil) then
		first = tonumber(Fid)
	end
	if (tonumber(Sid) ~= nil) then
		second = tonumber(Sid)
	end
	if (tonumber(Tid) ~= nil) then
		third = tonumber(Tid)
	end
	if (tonumber(Ffid) ~= nil) then
		fourth = tonumber(Ffid)
	end
	if (tonumber(Ssid) ~= nil) then
		start = tonumber(Ssid)
	end
end

function del(n)
	sampTextdrawDelete(n)
end

function show()
	toggle = not toggle
end

function raknet.RPC.UPDATE3DTEXTLABEL(id, bitStream)
	print(id)
	print(bitStream)
end
