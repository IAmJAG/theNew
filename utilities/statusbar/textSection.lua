class('textSection')

if SCR == nil then
	SCR = getAppUsableScreenSize()
end

textsection.x 			 			= 0
textsection.y 			 			= SCR:getY() - 60
textsection.w 			 			= SCR:getX()
textsection.h 			 			= SCR:getY()
    
textsection.borderColor 	= 0xFF6D6E6A
textsection.background		= 0xFF6D6E6A
textsection.textColor			= 0xFFF4F6F6
textsection.bar			 			= {}
textsection.textSize      = 16

function textsection:show(parent, default)	
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

function textsection:hide()
	self.bar['X']:highlightOff()
end

function textsection:Status(txt)
	setHighlightStyle(self.borderColor, false)	
	setHighlightTextStyle(self.borderColor, self.textColor, self.textSize)
	local bar = self.bar['Y']
	self.bar['Y'] = self.bar['X']
	self.bar['X'] = bar
	
	self.bar['X']:highlight(txt)
	wait(0.06)
	self.bar['Y']:highlightOff()
end