function [log, exit] = CorrerSecuenciaEmociones(texturas, codigos, instrucciones, hd, teclas, log, marcas, mensaje_practica)

    ExitKey = teclas.ExitKey;
    AfirmativeKey = teclas.afirmativo;
    NegativeKey = teclas.negativo;
    
    botones = {AfirmativeKey NegativeKey};
    texto_botones = {'Si expresa emoción MARCA' 'Si NO expresa emoción MARCA'};
    botones_salteado = teclas.botones_salteado;
    
    global TAMANIO_TEXTO
    global TAMANIO_INSTRUCCIONES
    global EEG

    
    %% INSTRUCCIONES
    EmocionesInstrucciones(instrucciones, TAMANIO_INSTRUCCIONES, botones, texto_botones, hd);
    Screen('Flip', hd.window);
    exit = EsperarBoton(teclas.Continuar, teclas.ExitKey);
    if exit
        return;
    end
    if ~isempty(mensaje_practica)
        TextoCentrado(mensaje_practica, TAMANIO_INSTRUCCIONES, hd);
        Screen('Flip', hd.window);
        exit = EsperarBoton(teclas.Continuar, teclas.ExitKey);
        if exit
            return;
        end
    end
    
    %% FIJACION
    TextoCentrado('+', TAMANIO_TEXTO, hd);
    Screen('Flip', hd.window);
    if ~isempty(codigos) && EEG
        EnviarMarca(150);
    end
    
    [exit, ~, ~, saltear_bloque] = Esperar(0.2, ExitKey, {}, botones_salteado);
    if exit || saltear_bloque
        return;
    end

    %% VACIO
    Screen('Flip', hd.window);
    WaitSecs(0.8);
          
    for i = 1:length(texturas)
        
        %% IMAGEN
        DibujarTextura(texturas{i}, hd.window);  
        [~, OnSetTime] = Screen('Flip', hd.window);
        if ~isempty(codigos) && EEG
            EnviarMarca(marcas(codigos{i}))
        end
        
        
        log_trial.imagen = OnSetTime;
        [exit, respuesta, tiempo, saltear_bloque] = Esperar(1.5, ExitKey, botones, botones_salteado);
        if exit || saltear_bloque
            return;
        end
        
        
        if isempty(respuesta)
            %% BLANK
            [~, OnSetTime] = Screen('Flip', hd.window);
            log_trial.blank = OnSetTime;
            [exit, respuesta, tiempo, saltear_bloque] = Esperar(1.5, ExitKey, botones, botones_salteado);
            if exit || saltear_bloque
                return;
            end
        end
        
        if respuesta == 1
            log_trial.respuesta = 'si';
        elseif respuesta == 2
            log_trial.respuesta = 'no';
        end
        
        if ~isempty(codigos)
            log_trial.codigo = codigos{i};
            respuesta_correcta = 1;
            if codigos{i}(1) == 'N'
                respuesta_correcta = 2;
            end
            
            if isempty(respuesta)
                log_trial.accuracy = 9;
            elseif respuesta_correcta == respuesta
                log_trial.accuracy = 1;
            else
                log_trial.accuracy = 0;
            end
            
            if ~isempty(codigos) && EEG
                EnviarMarca(log_trial.accuracy + 100);
            end
            
        end
        
        log_trial.respuesta_tiempo = tiempo;
        log_trial.reaction_time = log_trial.respuesta_tiempo - log_trial.imagen;
        
        
        
        %% OFFSET
        [~, OnSetTime] = Screen('Flip', hd.window);
        duracion = rand*0.4+0.8;
        
        log_trial.offset_time = OnSetTime;
        log_trial.offset_duracion = duracion;
        [exit, ~, ~, saltear_bloque] = Esperar(duracion, ExitKey, {}, botones_salteado);
        if exit || saltear_bloque
            return;
        end
        
        if ~isempty(log)
            log{i} = log_trial;
        end

    end
    

end