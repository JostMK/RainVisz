-- @author Jost K. / GitHub: JostMK
-- Generates all the necessary measures and meters depending on the amount of specified bars

function Initialize()
    GenerateRawMeasures()
    GenerateSmoothedMeasures()
    GenerateMeters()
end

function GenerateRawMeasures()
    local file = io.open(SKIN:MakePathAbsolute(SELF:GetOption('RawMeasuresIncFile')), "w")

    local count = tonumber(SKIN:GetVariable('BarCount','1'))

    local content = {}
    for i = 0, count-1 do
        -- Section name
        table.insert(content, SubstituteIndex("[MeasureBandRaw{%%}]", i))

        -- Section definitions
        table.insert(content, "Measure=Plugin")
        table.insert(content, "Plugin=AudioLevel")
        table.insert(content, "Parent=MeasureAudio")
        table.insert(content, "Type=Band")
        table.insert(content,  SubstituteIndex("BandIdx={%%}", i))
        table.insert(content, "Channel=Avg")
    end

    file:write(table.concat(content, "\n"))
	file:close()
end

function GenerateSmoothedMeasures()
    local file = io.open(SKIN:MakePathAbsolute(SELF:GetOption('SmoothedMeasuresIncFile')), "w")

    local count = tonumber(SKIN:GetVariable('BarCount','1'))
    local smoothingSize = tonumber(SKIN:GetVariable('SmoothingSize','1'))

    if smoothingSize == 0 then
        return
    end

    local content = {}
    for i = 0, count-1 do
        -- Section name
        table.insert(content, SubstituteIndex("[MeasureBandSmoothed{%%}]", i))

        -- Generate Smoothed Formula
        local formula = {}
        for j = -smoothingSize, smoothingSize do
            table.insert(formula, SubstituteIndex("[MeasureBandRaw{%%}]", clamp(i+j, 0, count-1)))
        end
        formula = "((" .. table.concat(formula, "+") .. ")/" .. (smoothingSize*2+1) .. ")"

        -- Section definitions
        table.insert(content, "Measure=Calc")
        table.insert(content, "Formula=" .. formula)
        table.insert(content, "DynamicVariables=1")
    end

    file:write(table.concat(content, "\n"))
	file:close()
end

function GenerateMeters()
    local file = io.open(SKIN:MakePathAbsolute(SELF:GetOption('MetersIncFile')), "w")

    local count = tonumber(SKIN:GetVariable('BarCount','1'))

    local meterX = SKIN:GetVariable('MeterX', "")
    local meterY = SKIN:GetVariable('MeterY',"")
    local barX = SKIN:GetVariable('BarX',"")
    local barY = SKIN:GetVariable('BarY',"")
    local barW = SubstituteMeasureType(SKIN:GetVariable('BarW',""))
    local barH = SubstituteMeasureType(SKIN:GetVariable('BarH',""))

    local content = {}
    for i = 0, count-1 do
        -- Section name
        table.insert(content, SubstituteIndex("[MeterBand{%%}]", i))

        -- Shape dimensions
        local barW_i = SubstituteIndex(barW, i)
        local barH_i = SubstituteIndex(barH, i)
        local dimensions = barX .. "," .. barY .. "," .. barW_i .. "," .. barH_i .. ",(#BarWidth#*0.5)"

        -- Section definitions
        table.insert(content, "Meter=Shape")
        table.insert(content, "X=" .. meterX)
        table.insert(content, "Y=" .. meterY)
        table.insert(content, "Shape=Rectangle " .. dimensions .. " | Fill Color #Color# | StrokeWidth 0")
        table.insert(content, "DynamicVariables=1")
    end

    file:write(table.concat(content, "\n"))
	file:close()
end

function SubstituteIndex(text, index)
    return (text:gsub("{%%%%}", index))
end

function SubstituteMeasureType(text, measureType)
    local smoothingSize = tonumber(SKIN:GetVariable('SmoothingSize','1'))

    local measureType = "MeasureBandSmoothed"
    if smoothingSize == 0 then 
        measureType = "MeasureBandRaw" 
    end

    return (text:gsub("{MeasureType}", measureType))
end

function clamp(value, lowerBound, uppperBound)
    return math.max(math.min(value,uppperBound),lowerBound)
end