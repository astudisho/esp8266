led1 = 3
led2 = 4
gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)

srv = net.createServer(net.TCP)
srv:listen(80, function(conn)
    conn:on("receive", function(sck, payload)
        print(payload)
        --sck:send("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n<h1> Hello, NodeMCU.</h1>")
        ------------------------------------------------------
        buf = "HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n<h1> Hello, NodeMCU.</h1>"
        buf = buf.."<html>"
        buf = buf.."<h1> ESP8266 Web Server</h1>";
        buf = buf.."<p>GPIO0 <a href=\"?pin=ON1\"><button>ON</button></a>&nbsp;<a href=\"?pin=OFF1\"><button>OFF</button></a></p>";
        buf = buf.."<p>GPIO2 <a href=\"?pin=ON2\"><button>ON</button></a>&nbsp;<a href=\"?pin=OFF2\"><button>OFF</button></a></p>";
        buf = buf.."</html>"
        ------------------------------------------------------
        sck:send(buf)

        local buf = "";
        local _, _, method, path, vars = string.find(payload, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(payload, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end

        local _on,_off = "",""
        if(_GET.pin == "ON1")then
              print("ON1")
              gpio.write(led1, gpio.HIGH);
        elseif(_GET.pin == "OFF1")then
              gpio.write(led1, gpio.LOW);
              print("OFF1")
        elseif(_GET.pin == "ON2")then
              print("ON2")
              gpio.write(led2, gpio.HIGH);
        elseif(_GET.pin == "OFF2")then
              print("OFF2")
              gpio.write(led2, gpio.LOW);
        end
        
    end)
    conn:on("sent", function(sck)
        print('On sent')
        sck:close() 
    end)
end)