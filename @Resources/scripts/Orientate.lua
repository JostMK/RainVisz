-- @author Jost K. / GitHub: JostMK
-- Sets the variables for the meters based of the orientation setting

function Initialize()
    local orientation = string.upper(SKIN:GetVariable('Orientation','UP'))

    if orientation == 'DOWN' then
        SKIN:Bang("!SetVariable", "BarX", "0")
        SKIN:Bang("!SetVariable", "BarY", "0")
        SKIN:Bang("!SetVariable", "BarW", "#BarWidth#")
        SKIN:Bang("!SetVariable", "BarH", "(#BarWidth# + #BarHeight# * [{MeasureType}{%%}])")
    elseif orientation == 'LEFT' then
        SKIN:Bang("!SetVariable", "MeterX", "0r")
        SKIN:Bang("!SetVariable", "MeterY", "#BarPadding#R")

        SKIN:Bang("!SetVariable", "BarX", "(#BarWidth# + #BarHeight#)")
        SKIN:Bang("!SetVariable", "BarY", "0")
        SKIN:Bang("!SetVariable", "BarW", "(-#BarWidth# - #BarHeight# * [{MeasureType}{%%}])")
        SKIN:Bang("!SetVariable", "BarH", "#BarWidth#")
    elseif orientation == 'RIGHT' then
        SKIN:Bang("!SetVariable", "MeterX", "0r")
        SKIN:Bang("!SetVariable", "MeterY", "#BarPadding#R")

        SKIN:Bang("!SetVariable", "BarX", "0")
        SKIN:Bang("!SetVariable", "BarY", "0")
        SKIN:Bang("!SetVariable", "BarW", "(#BarWidth# + #BarHeight# * [{MeasureType}{%%}])")
        SKIN:Bang("!SetVariable", "BarH", "#BarWidth#")
    else
        -- default case (UP) nothing to change
    end
end