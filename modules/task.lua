class('task')
		
task.FAIL			=	false
task.SUCCESS	= false
task.command	= cmd or 'click'
task.pslr			= false								-- pattern/string/location/region/timeOut
task.timeOut  = false
task.taskID 	= false

function task:execute(agent)
	return self[agent[self.command](agent, self)]
end

function task:initialize(cmd, param, to, tid, onFail, onSucces)
	self.command 	= cmd or 'click'
	self.pslr	 		= param
	self.timeOut 	= 30 or to
	if not self.taskID then
		if _G['TASKS'] == nil then
			_G['TASKS'] = {}
		end
		self.taskID = tid or #TASKS + 1
		TASKS[self.taskID] = self
	end
	
	if onFail then
		self:setRight(onFail)
	end
	
	if onSucces then
		self:setLeft(onSucces)
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