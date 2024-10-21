RegisterCommand("fib", function(source, args, raw)
    local src = source
    TriggerClientEvent("qnx:MarshallIplFour", src)
end)