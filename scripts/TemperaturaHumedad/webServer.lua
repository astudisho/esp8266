uart.setup(0,115200,8,0,1)

SSID = "HOME-D632"
PWD = "29249312100333C0"

wifi.setmode(wifi.STATIONAP)
wifi.sta.config(SSID,PWD)
print(wifi.sta.getip())

led0 = 1
led1 = 2
pausa = 500000

gpio.mode(led0, gpio.OUTPUT)
gpio.mode(led1, gpio.OUTPUT)
srv=net.createServer(net.TCP)
srv:listen(3246,function(conn)
    conn:on("receive", function(client,request)
        local buf = "";
        IP = tostring(wifi.sta.getip())
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end
        buf = buf.."<html>\n";
        buf = buf.."<body>\n";
        buf = buf.."<title>Garage wifi</title>\n";
        buf = buf.."<p><font size=120> Victor's garage</font></p>\n";
        buf = buf.."<p><a href=\"?pin=ON0\"><button style=\"height:300px;width:300px\"><font size = 50>Abrir / Cerrar</font></button></a></a>&nbsp\n";
        buf = buf.."<p><font size=30>\n";
        buf = buf.."Ip: "..IP;
        buf = buf.."</font></p>\n";
        buf = buf.."</body>";
        buf = buf.."</html>";
        local _on,_off = "",""
        if(_GET.pin == "ON1")then
              gpio.write(led1, gpio.HIGH);
              print("Led1 On");
        elseif(_GET.pin == "OFF1")then
              gpio.write(led1, gpio.LOW);
              print("Led1 Off");
        elseif(_GET.pin == "ON0")then
              gpio.write(led0, gpio.HIGH);
              print("Led0 On");
              tmr.delay(pausa);
              gpio.write(led0, gpio.LOW);
              print("Led0 Off");
              
        elseif(_GET.pin == "OFF2")then
              gpio.write(led0, gpio.LOW);
              print("Led2 Off");
        elseif(_GET.pin == "restart")then
              print("Reinicio");
              node.restart();
        elseif(_GET.pin == "comando")then
              print("Comando");
        end
        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)
