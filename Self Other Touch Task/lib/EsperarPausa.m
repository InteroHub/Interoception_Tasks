function exit = EsperarPausa(boton_pausa, boton_salida)

    global MARCA_PAUSA_INICIO
    global MARCA_PAUSA_FIN

    EnviarMarca(MARCA_PAUSA_INICIO)   
    
    [~, keyCode, ~] = KbReleaseWait;
    while ~isempty(find(keyCode,1))
            [~, keyCode, ~] = KbReleaseWait;
    end
        
    exit = EsperarBoton(boton_pausa, boton_salida);    
    if exit
        return
    end
    
    [~, keyCode, ~] = KbReleaseWait;
    while ~isempty(find(keyCode,1))
            [~, keyCode, ~] = KbReleaseWait;
    end         
    

    EnviarMarca(MARCA_PAUSA_FIN)  
    
end