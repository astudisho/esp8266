RELAY_PIN = 1
UMBRAL_VOLTS = 600
TIEMPO = 200

isLedActive = true
ultimaLectura = true
vecesCambio = 0

print('Inicializando')     

gpio.mode(RELAY_PIN, gpio.OUTPUT)
--gpio.write( RELAY_PIN, gpio.LOW )

tmr.alarm(0, TIEMPO, 1, function ()
    print('Ejecutando funcion alarm')

    lectura = tonumber( tostring( adc.read( 0 ) ) )

    print('Lectura: ')
    print(lectura)
    print(adc.read( 0 ))
    
    estaPresionando = (lectura < UMBRAL_VOLTS)
    
    if ultimaLectura ~= estaPresionando
    then
        vecesCambio = vecesCambio + 1   
                
        print('Cambiando de estado')
        
        print('Veces que cambio ' .. vecesCambio)
        

        if vecesCambio == 2
        then
            gpio.write(RELAY_PIN, isLedActive and 1 or 0 )
            isLedActive = not isLedActive  
            vecesCambio = 0
        end       
        
    end

    ultimaLectura = estaPresionando
    print()
end)
