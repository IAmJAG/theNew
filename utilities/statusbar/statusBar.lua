--=============== Status Bar ===============--
statusBar = class('rectangle')

if SCR == nil then
	SCR = getAppUsableScreenSize()
end

statusBar.x 			 			= 0
statusBar.y 			 			= SCR:getY() - 60
statusBar.w 			 			= SCR:getX()
statusBar.h 			 			= SCR:getY()

statusBar.borderColor 	= 0xFF464742
statusBar.background		= 0xFF464742
statusBar.textColor			= 0xFF464742
statusBar.bar			 			= Region(statusBar.x, statusBar.y, statusBar.w, statusBar.h)
statusBar.sections			= {}

function statusBar:show()
	setHighlightTextStyle(self.background, self.textColor, 16)
	setHighlightStyle(self.borderColor, false)
	self.bar:highlight('')
	for i, sec in pairs(self.sections) do
		sec:show(self)
	end
end

function statusBar:hide()
	for i, sec in pairs(self.sections) do
		sec:hide()
	end
	self.bar:highlightOff()
end

function statusBar:addSection(sctnClss, name, w, h)
	x 	= x or self.x+2
	y 	= y or self.y+2
	w 	= w or self.w-2
	h 	= h or self.h-2
	local newSection = sctnClss(name)
	newSection.w = w
	newSection.h = h
	self.sections[#self.sections+1] = newSection
	return newSection
end


colors = {
	green = 0xFF709E00;
	blue = 0xFF1F91C2;
	orange = 0xFFCF5200;
	red = 0xFFBC1000;
	purple = 0xFF6C0083;
	--
	green_dark = 0xFF577B00;
	blue_dark = 0xFF187197;
	orange_dark = 0xFFA14000;
	red_dark = 0xFF920D00;
	purple_dark = 0xFF540066;
	--
	white = 0xFFF4F6F6;
	black = 0xFF2A2A27;
	gray = 0xFF464742;
	gray_light = 0xFF6D6E6A;
	--
	transparent = 0x00FFFFFF;
}