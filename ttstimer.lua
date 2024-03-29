
-- Refactored code for the Sulfur Timer system. Inspired by that one timer i found on the workshop [attribution here]

local timerCount = 15 -- The global timer length
local running = false -- Whether the timer is running or not

function doTime() -- This is the global function for counting time down
	timing = Wait.time(function()
        timerCount = timerCount - 1
        updateDisplay() 
        if timerCount <= 0 then
            Wait.stop(timing)
            print("TIME UP!!!")
        end
    end, 1, -1)
end


-- Default step times, don't change these, change the ones in the moraleMod func
longStep = 45
medStep = 25
shortStep = 15

-- Change timer global step counts based on given input
function moraleMod(_,_,input)
    local option = tonumber(input)
    if option == 5 then
        longStep = 90
        medStep = 60
        shortStep = 30
    elseif option == 4 then
        longStep = 60
        medStep = 30
        shortStep = 20
    elseif option == 3 then
        longStep = 45
        medStep = 25
        shortStep = 15
    elseif option == 2 then
        longStep = 25
        medStep = 15
        shortStep = 10
    elseif option == 1 then
        longStep = 10
        medStep = 5
        shortStep = 3
    end
end

--Prettify time output
function secondsToClock(seconds)
    local minutes = math.floor(seconds / 60)
    local seconds = seconds % 60
    return string.format("%02d:%02d", minutes, seconds)
end

--Add and remove time functions
function subTimeShort()
    if timerCount - shortStep >= 0 then
        timerCount = timerCount - shortStep
        updateDisplay()
    end
end
function subTimeMed()
    if timerCount - medStep >= 0 then
        timerCount = timerCount - medStep
        updateDisplay()
    end
end
function subTimeLong()
    if timerCount - longStep >= 0 then
        timerCount = timerCount - longStep
        updateDisplay()
    end
end
function addTimeShort()
    timerCount = timerCount + shortStep
    updateDisplay()
end
function addTimeMed()
    timerCount = timerCount + medStep
    updateDisplay()
end
function addTimeLong()
    timerCount = timerCount + longStep
    updateDisplay()
end


function createButtons()
    self.createButton({
        position={0,0.1,-0.55},
        width=700,
        height=300,
        click_function="runTimer",
        function_owner=self
    })
    self.createButton({
        click_function="subTimeLong",
        position={0.4,0.1,0.1},
        label="L",
        color={1,0,0},
        function_owner=self
    })
    self.createButton({
        click_function="subTimeMed",
        position={0.7,0.1,0.1},
        label="M",
        color={1,0,0},
        function_owner=self
    })
    self.createButton({
        click_function="subTimeShort",
        position={1,0.1,0.1},
        label="S",
        color={1,0,0},
        function_owner=self
    })
    self.createButton({
        click_function="addTimeLong",
        position={-0.4,0.1,0.1},
        label="L",
        color={0,1,0},
        function_owner=self
    })
    self.createButton({
        click_function="addTimeMed",
        position={-0.7,0.1,0.1},
        label="M",
        color={0,1,0},
        function_owner=self
    })
    self.createButton({
        click_function="addTimeShort",
        position={-1,0.1,0.1},
        label="S",
        color={0,1,0},
        function_owner=self
    })
    self.createButton({
        click_function="reset",
        position={0,0.1,0.55},
        function_owner=self,
        label="RESET",
        width=500,
        height=200,
        color={1,0,0.8}

    })
    self.createInput({
        position={0,0.1,0.1},
        input_function="moraleMod",
        label=3,
        width=200,
        height=200,
        alignment=3,
        font_size=150,
        function_owner=self
    })
end

function runTimer()
    if running then
        Wait.stop(timing)
        running = false
    else
       doTime()
       running = true
    end
end

function reset()
    if timing then
        Wait.stop(timing)
    end
    timerCount = 15
    running = false
    updateDisplay()
end

function updateDisplay()
    local displayTime = secondsToClock(timerCount)
    self.editButton({index=0,label=displayTime})
end




createButtons()
updateDisplay()
