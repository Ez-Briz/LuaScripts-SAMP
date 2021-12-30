script_name("CaptchaCatcher")
script_description("CaptchaCatcher for any dialog")
script_author("EzBriz")

require "lib.moonloader"
local vk = require "lib.vkeys"
local active = true
local lasttext = nil
local lastanswer = nil
local dialogText
local catch = true
local thread
function main()
	if not isSampLoaded() or not isCleoLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	while not sampIsLocalPlayerSpawned() do wait(100) end
	sampRegisterChatCommand("catch", turn)
	sampRegisterChatCommand("win", turnwin)
	sampRegisterChatCommand("dialog", dialog)
	while true do
		wait(0)
		if active and sampIsDialogActive() then
			local dialogTitle = sampGetDialogCaption()
			lastanswer = sampGetCurrentDialogEditboxText()
			if dialogTitle:match('.*Проверка на робота.*') ~= nil then
				dialogText = sampGetDialogText()
				local firstindex, lastindex = dialogText:find("Вопрос:.*Варианты ответа:")
				if lastindex ~= nil then
					lasttext = string.sub(dialogText, firstindex + #'Вопрос: ', lastindex - #'Варианты ответа:')
					lasttext = lasttext:gsub("{......}", "")
					lasttext = lasttext:gsub("\n", "")
					--print(lasttext)
					--catcher/////
					if catch then
						local ans = GetAnswerIfExist(lasttext)
						if (ans ~= nil and ans ~= "") then
							if #lasttext < 20 then
								wait(math.random(700, 900))
							else
								wait(math.random(750, 1000))
							end
							catch = not catch
							thread = lua_thread.create(startWritingAns, ans)
						end
					end
					--catcher\\\\\

				end
			end
		end
		if active and not sampIsDialogActive() then
			if lasttext ~= nil and lastanswer ~= nil and lastanswer ~= "" then
				if(isExist(lasttext) == false) then
					printCaptchaInfo(lasttext, lastanswer)
					printDialogText(dialogText)
				end
				lasttext = nil
				lastanswer = nil
			end
		end
	end
end

function startWritingAns(ans)
	local down, up
	if #ans < 8 then
		down = 75
		up = 200
	elseif #ans <14 then
		down = 50
		up = 250
	else
		down = 50
		up = 300
	end
	for counter=0, #ans do
		wait(math.random(75, 200))
		sampSetCurrentDialogEditboxText(ans:sub(1,counter))
	end
	wait(50)
	setVirtualKeyDown(vk.VK_RETURN, true)
	setVirtualKeyDown(vk.VK_RETURN, false)
end

function GetAnswerIfExist(lasttext)
	if lasttext == nil and lasttext == "" then
		return nil
	end
	local file = io.open("moonloader\\DB\\CaptchaDB.txt", "r")
	if file ~= nil then
		local filetext = file:read('*all')
		file:close()
		local first, last = string.find(filetext, lasttext)
		if last == nil or first == nil then
			return nil
		end
		local newsecond = -1
		local newfirst = -1
		for a = first, string.len(filetext) do
			currentchar = string.sub(filetext,a,a)
			if currentchar ~= nil then
		    if currentchar == '|' and newfirst == -1 then
		        newfirst = a+2
		    end
		    if currentchar == '\n' and newsecond == -1 then
		        newsecond = a
		        break
		    end
			end
		end
		local ans = string.sub(filetext, newfirst, newsecond)
		--if ans ~= nil then
		--	catch = false
		--end
		return ans
	else
		return nil
	end
end

function dialog()
	sampShowDialog(6054, "Проверка на робота","Вопрос: С какой буквы начинается предлoжeние?\nВарианты ответа:"," button1"," button2",1)
end

function isExist(question)
	if question == nil or question == "" then
		return false
	end
	local file = io.open("moonloader\\DB\\CaptchaDB.txt", "r")
	--sampAddChatMessage('try',-1)
	if file ~= nil then
		--sampAddChatMessage('catch',-1)
		local text = file:read('*all')
		file:close()
		if text:find(question) ~= nil then
			--sampAddChatMessage("БЫЛО",-1)
			return true
		else
			return false
		end
	else
		return false
	end
end


function printDialogText(dialogText)
	local file = io.open("moonloader\\DB\\dialogText.txt", "a")
	file:write(dialogText..'\n\n\n\n')
	file:close()
end

function printCaptchaInfo(question, answer)
	if question == "" or answer == "" then
		return
	end
	local file = io.open("moonloader\\DB\\CaptchaDB.txt", "a")
	--sampAddChatMessage('write',-1)
	file:write(question ..' | ' .. answer..'\n')
	file:close()
end

function turn()
	active = not active
	if active then
		sampAddChatMessage("{FFF000}[CaptchaCatcher]:{FFFFFF} Activated.", 0xFFFFFF)
	else
		sampAddChatMessage("{FFF000}[CaptchaCatcher]:{FFFFFF} Deactivated.", 0xFFFFFF)
	end
end
function turnwin()
	catch = not catch
	if catch then
		sampAddChatMessage("{FFF000}[HouseCatcher]:{FFFFFF} Activated.", 0xFFFFFF)
	else
		sampAddChatMessage("{FFF000}[HouseCatcher]:{FFFFFF} Deactivated.", 0xFFFFFF)
	end
end
