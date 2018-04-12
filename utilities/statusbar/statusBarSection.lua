--=============== Status Bar Text Content
local textSectionBar = require('base')

if SCR == nil then
	SCR = getAppUsableScreenSize()
end

function textSectionBar.create(x, y, w, h)
	local bar = textSectionBar:new('textSectionBar', true)
	
	bar.x 				= x or 0
	bar.y 				= y or 0
	bar.w 				= w or SCR:getW()
	bar.h 				= h or SCR:getH()
	
	bar.barColor 	= gray
	bar.bar				= {}
	
	return bar
end

function textSectionBar:show(parent, default)
	assert(parent, 'Parent parameter is required!')
	self.bar['X'] = self.bar['X'] or Region(parent.x + bar.x, parent.y + bar.y, bar.w, bar.h)
	self.bar['Y'] = self.bar['Y'] or Region(parent.x + bar.x, parent.y + bar.y, bar.w, bar.h)
	self:Status(default)
end

function textSectionBar:hide()
	self.bar['X']:highlightOff()
end

function textSectionBar:Status(txt)
	setHighlightStyle(self.barColor, false)	
	local bar = self.bar['Y']
	self.bar['Y'] = self.bar['X']
	self.bar['X'] = bar
	
	self.bar['X']:highlight(txt)
	self.bar['Y']:highlightOff()
end
	
return textSectionBar