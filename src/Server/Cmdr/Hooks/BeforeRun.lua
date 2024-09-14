return function(registry)
	registry:RegisterHook("BeforeRun", function(context)
		---@pass
		-- if
		-- 	context.Group == "Admin"
		-- 	and context.Executor.UserId ~= game.CreatorId
		-- then
		-- 	return "You don't have permission to run this command"
		-- end
	end)
end
