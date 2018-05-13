--=============== Status Bar ===============--
class('statusBar')

if SCR == nil then
	SCR = getAppUsableScreenSize()
end

statusbar.x 			 			= 0
statusbar.y 			 			= SCR:getY() - 60
statusbar.w 			 			= SCR:getX()
statusbar.h 			 			= SCR:getY()

statusbar.borderColor 	= 0xFF464742
statusbar.background		= 0xFF464742
statusbar.textColor			= 0xFF464742
statusbar.bar			 			= Region(statusbar.x, statusbar.y, statusbar.w, statusbar.h)
statusbar.sections			= {}

function statusbar:show()
	setHighlightTextStyle(self.background, self.textColor, 16)
	setHighlightStyle(self.borderColor, false)
	self.bar:highlight('')
	for i, sec in pairs(self.sections) do
		sec:show(self)
	end
end

function statusbar:hide()
	for i, sec in pairs(self.sections) do
		sec:hide()
	end
	self.bar:highlightOff()
end

function statusbar:addSection(sctnClss, name, w, h)
	x 	= self.x+2
	y 	= self.y+2
	w 	= w or self.w-2
	h 	= h or self.h-2
	
	local newSection = sctnClss()
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