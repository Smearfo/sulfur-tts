--    MrStump's (and smearfo's) Scripted Countdown Timer


--Variables that can be edited to change timer behavior


--The default starting time for the timer in seconds.
--This is what the time is if your timeMod = 0 (before you hit + or -)
defaultStartTime = 15
--This is how much + or - buttons effect timeMod.
--In other words, how much the time increases/decreses by
bigStep = 90
medStep = 60
smallStep = 30
--The following are colors for the timer to change to, in {R,G,B} format
--RGB values should be between 0 and 1
--Reset and idle color
colorReset = {0.5,0.2,0.7}
--Paused color
colorPause = {0.5,0.5,0.5}
--Running color
colorRun = {0.2,1,0.2}
--Time has run out color
colorEnd = {1,0.2,0.2}

moraleMult = 1


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


--Setup that runs when tool is loaded/saved


--Runs whenever this object is saved, individually or as part of a table
function onSave()
	local data_to_save = {tc=timeCount, tm=timeMod}
	local saved_data = JSON.encode(data_to_save)
	return saved_data
end

--Runs only when the timer is first loaded on the table
function onload(saved_data)
	if saved_data ~= nil and saved_data ~= "" then
		local loaded_data = JSON.decode(saved_data)
		timeCount = loaded_data.tc
		timeMod = loaded_data.tm
	else
		timeCount = 0
		timeMod = 0
	end
	if timeCount > 0 then self.setColorTint(colorPause) end
	if defaultStartTime - timeCount + timeMod <= 0 then
		self.setColorTint(colorEnd)
	end
	runTimer = false
	disablePauseOrStart = false
	createButtons()
end


--Running processes to do the actual counting, and knowing when to stop


--When runTimer is true, this does the counting to track time passing
function update()
    if runTimer == true then
        calculateDelta()
        timeCount = timeCount + 1 * deltaTime
        updateDisplays()
        if timeCount >= defaultStartTime + timeMod then
            broadcastToAll(string.char(8987).." - Time's Up - "..string.char(8987), {1,1,1})
            self.setColorTint(colorEnd)
            runTimer = false
            disablePauseOrStart = true
        end
    end
end

--Determines the real time between the last update and this one to keep count accurate
function calculateDelta()
    local oldTime = newTime
    newTime = os.clock()
    deltaTime = newTime - oldTime
end


--Display/naming/color, to format the cube and buttons visually


--Updates the time to the 4 side displays
function updateDisplays()
    local timeForDisplay = getTimeString()
    --This if statement cuts way down on the amount of button updates being done
    if self.getButtons()[1].label ~= timeForDisplay then
        for i=0, 3 do
            self.editButton({index=i, label=timeForDisplay})
        end
    end
end

--Converts a number in seconds only into minutes/seconds and returns it
function getTimeString()
    local timeInSeconds = math.ceil(defaultStartTime + timeMod - timeCount)
    local minutes = math.floor(timeInSeconds/60)
    local seconds = timeInSeconds % 60
    return string.format("%d:%02d",minutes,seconds)
end


--Click Functions (what happens when you click buttons)


--Runs when a side is clicked, starts/stops timer
function pauseOrStart()
    if disablePauseOrStart == false then
        if runTimer == false then
            newTime = os.clock()
            runTimer = true
            self.setColorTint(colorRun)
        else
            runTimer = false
            self.setColorTint(colorPause)
        end
    end
end

function changeTimeMod(_,_,input,_)
    if not(tonumber(input) == 0 or input == "") then
        moraleMod(tonumber(input))
    end
end

--Activated by the reset button, resetting and stopping it if needed
function resetTimer()
    timeMod = 0
    timeCount = 0
    runTimer = false
    disablePauseOrStart = false
    updateDisplays()
    self.setColorTint(colorReset)
end

--The + button, adds time to timeMod to increase total timer time
function moreTimeBig()
    if true then
        timeMod = timeMod + bigStep
        updateDisplays()
    end
end

function moreTimeMed()
    if true then
        timeMod = timeMod + medStep
        updateDisplays()
    end
end

function moreTimeSmall()
    if true then
        timeMod = timeMod + smallStep
        updateDisplays()
    end
end


--The - button, removes time from timeMod to decrease total timer time
function lessTimeBig()
    if defaultStartTime + timeMod - timeCount - bigStep > 0 then
        timeMod = timeMod - bigStep
        updateDisplays()
    end
end

function lessTimeMed()
    if defaultStartTime + timeMod - timeCount - medStep > 0 then
        timeMod = timeMod - medStep
        updateDisplays()
    end
end

function lessTimeSmall()
    if defaultStartTime + timeMod - timeCount - smallStep > 0 then
        timeMod = timeMod - smallStep
        updateDisplays()
    end
end

--Button creation area belows


--Creates the buttons in the start of the code
function createButtons()
    local t = getTimeString()
    self.createButton({
        label=t, click_function="pauseOrStart", function_owner=self,
        position={0,0.5,0}, rotation={0,0,0}, height=190, width=500, font_size=200
    })
    self.createButton({
        label=t, click_function="pauseOrStart", function_owner=self,
        position={0.5,0,0}, rotation={0,-90,90}, height=300, width=500, font_size=210
    })
    self.createButton({
        label=t, click_function="pauseOrStart", function_owner=self,
        position={0,0,-0.5}, rotation={90,180,0}, height=300, width=500, font_size=210
    })
    self.createButton({
        label=t, click_function="pauseOrStart", function_owner=self,
        position={-0.5,0,0}, rotation={0,90,-90}, height=300, width=500, font_size=210
    })
    self.createButton({
        label="Reset", click_function="resetTimer", function_owner=self,
        position={0,0.5,-0.35}, height=150, width=300, font_size=80
    })
    self.createButton({
        label="+B", click_function="moreTimeBig", function_owner=self,
        position={0.25,0.5,0.35}, rotation={00,0,0}, height=120, width=120, font_size=90
    })
    self.createButton({
        label="+M", click_function="moreTimeMed", function_owner=self,
        position={0.5,0.5,0.35}, rotation={00,0,0}, height=120, width=120, font_size=90
    })
    self.createButton({
        label="+S", click_function="moreTimeSmall", function_owner=self,
        position={0.75,0.5,0.35}, rotation={00,0,0}, height=120, width=120, font_size=90
    })
    self.createButton({
        label="-B", click_function="lessTimeBig", function_owner=self,
        position={-0.25,0.5,0.35}, rotation={00,0,0}, height=120, width=120, font_size=90
    })
    self.createButton({
        label="-M", click_function="lessTimeMed", function_owner=self,
        position={-0.5,0.5,0.35}, rotation={0,0,0}, height=120, width=120, font_size=90
    })
    self.createButton({
        label="-S", click_function="lessTimeSmall", function_owner=self,
        position={-0.75,0.5,0.35}, rotation={0,0,0}, height=120, width=120, font_size=90
    })
    self.createInput({
        function_owner=self, input_function="changeTimeMod", position={0,0.5,0.35}, 
        validation=3, alignment=3, font_size=50
    })
end
