--=============== Status Bar Text Content
textSectionBar = class('textSection')

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

local textSectionBar = {}
textSectionBar.__index = textSectionBar

require('base')

if SCR == nil then
	SCR = getAppUsableScreenSize()
end

function textSectionBar.create(x, y, w, h)
	local bar = newClass('textSectionBar', true)
	
	bar.x 				= x or 0
	bar.y 				= y or 0
	bar.w 				= w or SCR:getX()
	bar.h 				= h or SCR:getY()
	
	bar.borderColor = 0xFF6D6E6A
	bar.background	= bar.borderColor
	bar.textColor		= 0xFFF4F6F6
	bar.textSize		= 16
	bar.bar				= {}
	
	return setmetatable(bar, textSectionBar)
end

function textSectionBar:show(parent, default)	
	default = default or ''
	assert(parent, 'Parent parameter is required!')
	
	self.x = parent.x+2
	self.y = parent.y+2
	self.w = parent.w-2
	self.h = parent.h-2
	
	self.bar['X'] = Region(self.x, self.y , self.w, self.h)
	self.bar['Y'] = Region(self.x, self.y , self.w, self.h)
	self:Status(default)
end

function textSectionBar:hide()
	self.bar['X']:highlightOff()
end

function textSectionBar:Status(txt)
	setHighlightStyle(self.borderColor, false)	
	setHighlightTextStyle(self.borderColor, self.textColor, self.textSize)
	local bar = self.bar['Y']
	self.bar['Y'] = self.bar['X']
	self.bar['X'] = bar
	
	self.bar['X']:highlight(txt)
	self.bar['Y']:highlightOff()
end
	
return textSectionBar