--=============== Status Bar Text Content
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