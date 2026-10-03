-- Liest alle Themes (*.inc) in @Resources\Themes ein – beliebige Dateinamen, keine Nummern nötig.
-- Die Dateiliste kommt von MeasureThemeList (RunCommand, "dir /b"), danach wird Parse() aufgerufen.
-- Sortierung ist "natürlich": 2.inc vor 10.inc, Namen alphabetisch.
-- Setzt die Variablen ThemeNext, ThemePrev, ThemeIndex und ThemeCount.

local count = 0

function Initialize()
	listMeasure = SELF:GetOption('ListMeasure', 'MeasureThemeList')
end

local function sortKey(s)
	-- Zahlen auf feste Länge auffüllen, damit "2" vor "10" kommt
	return s:lower():gsub('%d+', function(d)
		d = d:gsub('^0+', '')
		return string.rep('0', 20 - #d) .. d
	end)
end

function Parse()
	local measure = SKIN:GetMeasure(listMeasure)
	local output = measure and measure:GetStringValue() or ''

	local list = {}
	for line in output:gmatch('[^\r\n]+') do
		local name = line:match('^%s*(.-)%.[iI][nN][cC]%s*$')
		if name and name ~= '' then
			table.insert(list, name)
		end
	end
	table.sort(list, function(a, b) return sortKey(a) < sortKey(b) end)
	count = #list

	local current = SKIN:GetVariable('Theme') or ''
	local index = 0
	for i, name in ipairs(list) do
		if name:lower() == current:lower() then
			index = i
			break
		end
	end

	local nextTheme, prevTheme = current, current
	if count > 0 then
		if index == 0 then
			-- Aktuelles Theme existiert nicht (mehr) -> zum ersten / letzten springen
			nextTheme, prevTheme = list[1], list[count]
		else
			nextTheme = list[index % count + 1]
			prevTheme = list[(index - 2) % count + 1]
		end
	end

	SKIN:Bang('!SetVariable', 'ThemeNext', nextTheme)
	SKIN:Bang('!SetVariable', 'ThemePrev', prevTheme)
	SKIN:Bang('!SetVariable', 'ThemeIndex', index > 0 and tostring(index) or '?')
	SKIN:Bang('!SetVariable', 'ThemeCount', tostring(count))
	SKIN:Bang('!UpdateMeter', 'MeterThemeButton')
	SKIN:Bang('!Redraw')
end

function Update()
	return count
end
