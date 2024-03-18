-- Refactored code for the Sulfur Timer system. Inspired by that one timer i found on the workshop [attribution here]

timerCount = 0 -- The global timer length

function doTime(length) -- This is the global function for counting time down
	timerCount = length
	Wait.time(function() timerCount = timerCount - 1 end, 1, timerCount)
	if timerCount <= 0 then return(timerCount) end
end

-- Default step times, don't change these, change the ones in the moraleMod func
longStep = 90
medStep = 60
shortStep = 30


-- Change timer global step counts based on given input
function moraleMod(option)
    if option == 5 then
        bigStep = 90
        medStep = 60
        smallStep = 30
    elseif option == 4 then
        bigStep = 60
        medStep = 30
        smallStep = 15
    elseif option == 3 then
        bigStep = 45
        medStep = 25
        smallStep = 15
    elseif option == 2 then
        bigStep = 25
        medStep = 15
        smallStep = 10
    elseif option == 1 then
        bigStep = 10
        medStep = 5
        smallStep = 3
    end
end


function secondsToClock(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local seconds = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

-- Example usage:
local totalSeconds = 9421 -- 1 hour, 1 minute, and 1 second
print(secondsToClock(totalSeconds)) -- Output: 01:01:01


--Creation of buttons and other inputs
function createInputs()
	local time=timeToString()
	self.createButton({
		label=time,
		click_function="pauseOrStart",
		function_owner=self,
		position={0,0,0},
		height=300,
		width=300,
		font_size=200
	})

	self.createInput({
		function_owner=self,
		input_function="moraleMod",
		alignment=3,
		validation=2,
		position={0,0,0},
		font_size=50
	})
end


