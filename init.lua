wifi.setmode(wifi.STATION)
wifi.sta.config("FD-11","")
gpio.mode(0, gpio.OUTPUT)
gpio.mode(1, gpio.OUTPUT)
--gpio.mode(0,gpio.PULLUP)
local ans
mytimer1 = tmr.create()
mytimer2 = tmr.create()
--mytimer:alarm(10000,tmr.ALARM_AUTO,function() print ("hey") end)
function sendData1()
    --print("Setting up mqtt.Client...")
    --m = mqtt.Client("nodemcu", 0, "username", "group14")
    --print("Attempting client connect...")
    --m:connect("iot.eclipse.org", 1883, 0, 0,
        --function(client)
            --print("Connected to MQTT")
            payload = "Pump Started"
            m:publish("/nodemcu/intensity", payload, 0, 0, 
                function(client) 
                    print("Message sent")
                    mytimer2:alarm(20000,tmr.ALARM_AUTO,function() 
                                                tem2() 
                                            end) 
                end)
end

function sendData2()
    --print("Setting up mqtt.Client...")
    --m = mqtt.Client("nodemcu", 0, "username", "group14")
    --print("Attempting client connect...")
    --m:connect("iot.eclipse.org", 1883, 0, 0,
        --function(client)
            --print("Connected to MQTT")
            payload = "Pump powered off"
            m:publish("/nodemcu/intensity", payload, 0, 0, 
                function(client) 
                    print("Message sent")
                    mytimer1:alarm(20000,tmr.ALARM_AUTO,function() 
                                                tem1() 
                                            end)
                end)
end

function tem1()    
    ans = adc.read(0)
    print(ans)
    if(ans>650) then
            mytimer1:unregister()
            sendData1()
        end
end

function tem2()    
        ans = adc.read(0)
        print(ans)
        if(ans<650) then
            mytimer2:unregister()
            sendData2()
        end
end
function ConnStatus(x)
    print("Waiting for IP ...")
    status = wifi.sta.status()
    if (status == 5) then
        print('Connected as '..wifi.sta.getip())
        m = mqtt.Client("nodemcu", 0, "username", "group14")
        print("started")
        m:on("offline", function(client) print ("offline") ConnStatus(60) end)
        m:connect("iot.eclipse.org", 1883, 0,
        function(client) print("connected") 
        mytimer1:alarm(20000,tmr.ALARM_AUTO,function() 
                       tem1() 
             end)
               end)
        
        --gpio.trig(0,"up",sendData())
       --while(har>0)
       --do
           --sendData()
           --print("hey")
           --sendData()
           --m:publish("/nodemcu/intensity", payload, 0, 0, 
           --     function(client) 
           --         print("Message sent") 
           --     end)
           --tmr.delay(10000000)
           --har=har-1
      --end
    else
        if x > 0 then
            -- Keep trying
            tmr.alarm(0, 1000, 0, function() ConnStatus(x - 1) end)
        else
            print("Connection failed")
        end
    end
end
ConnStatus(60)
Trying to see how cherry pick works
