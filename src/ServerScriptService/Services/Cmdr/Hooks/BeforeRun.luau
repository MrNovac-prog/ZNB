
local whiteList = {
    [2657853823] = true,

}

return function (registry)
    registry:RegisterHook("BeforeRun", function(context)
        local userId = context.Executor.UserId 
        
        if not whiteList[userId] then
            return "You Don't Have Permission for this command"
        end
    end)
end