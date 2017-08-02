wifi.setmode(wifi.STATIONAP)
wifi.sta.config("FuzzyBot","HoughCirclesIsolation")
print(wifi.sta.getip())
led1 = 3
led2 = 4
gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        print('Japper')
        
        buf = buf.."HTTP/1.1 200 OK\n";
        buf = buf.."Content-Type: text/html\n";
        buf = buf.."\n";
        
        local buf = "";
        
        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)
