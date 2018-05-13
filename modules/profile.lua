class('profile')

profile.name = ''

function profile:click(pslr, to)
	to = to or 0
	pslr:click()
	local tcks = GU:ms() + to
	while GU:ms() <= tcks do		
	end
	return 'SUCCESS'
end

function profile.wait(pslr, to)
	to = to or 150
	local tcks = GU:ms() + to
	while GU:ms() <= tcks do
	end
	return 'SUCCESS'
end
