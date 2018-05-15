class('task')
		
task.FAIL			=	false
task.SUCCESS	= false
task.command	= cmd or 'click'
task.pslr			= false								-- pattern/string/location/region/timeOut
task.timeOut  = false
task.taskID 	= false

function task:execute(agent)
	local result = agent[self.command](agent, self.pslr, self.timeOut)
	return self[result]
end

function task:GTaskCount()
	local cnt = 0
	for key in _G['TASKS'] do
		cnt = cnt + 1
	end
	return cnt
end

function task:initialize(cmd, param, to, tid, onFail, onSucces)
	self.command 	= cmd or 'click'
	self.pslr	 		= param
	self.timeOut 	= 30 or to
	if not self.taskID then
		if _G['TASKS'] == nil then
			_G['TASKS'] = {}
		end
		self.taskID = tid or self:GTaskCount()
		TASKS[self.taskID] = self
	end
	
	if onFail then
		self:setFail(onFail)
	end
	
	if onSucces then
		self:setSuccess(onSucces)
	end
end

function task:setSuccess(tid)
	if typeOf(tid) == 'task' then
		task.SUCCESS = tid.taskID
	else
		task.SUCCESS = tid
	end
end

function task:setFail(tid)
	if typeOf(tid) == 'task' then
		task.FAIL = tid.taskID
	else
		task.FAIL = tid
	end
end