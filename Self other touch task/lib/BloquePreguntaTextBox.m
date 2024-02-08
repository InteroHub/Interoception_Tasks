function [texto, exit] = BloquePreguntaTextBox(hd, teclas)

    global TAMANIO_TEXTO

    [screenXpixels, screenYpixels] = Screen('WindowSize', hd.window);
    
    textSize = round(screenYpixels*TAMANIO_TEXTO);
    
    
    BORRAR = 8;
    BOTON_PUNTO = 190;
    BOTON_COMA = 188;
    BOTONES_NUMERICO = [96 97 98 99 100 101 102 103 104 105];
    
    PREGUNTA = 'Por favor, ingresar abajo una estimacion intuitiva\n de cuantos segundos duro el ultimo bloque';
    texto = '';
    UNIDADES = 'segundos';
    MENSAJE_CONTINUAR = 'Escriba utilizando los números del teclado\n y presiona ENTER para continuar.';
    
    RECT_PREGUNTA = [0 round(screenYpixels/5) screenXpixels   round(screenYpixels/4)];
    RECT_TEXTO = [round(screenXpixels/4) round(screenYpixels*9/20) round(screenXpixels/2)   round(screenYpixels*11/20)];
    RECT_UNIDADES = [round(screenXpixels/2) round(screenYpixels*9/20) round(screenXpixels*3/4)   round(screenYpixels*11/20)];
    
    Screen('TextSize', hd.window, textSize);
    DrawFormattedText(hd.window, PREGUNTA, 'center','center', hd.white, [],[],[],2,[],RECT_PREGUNTA);
    DrawFormattedText(hd.window, texto, 'justifytomax','center', hd.white, [],[],[],[],[],RECT_TEXTO);
    DrawFormattedText(hd.window, UNIDADES, 'center','center', hd.white, [],[],[],[],[],RECT_UNIDADES);
    MensajeContinuar(MENSAJE_CONTINUAR, hd);
    
    Screen('Flip',hd.window); 
    
    exit = false;
    continuar = true;
    FlushEvents;
    while continuar
    

        [~, keyCode, ~] = KbPressWait;

        if keyCode(teclas.Enter)
            continuar = false;
        elseif keyCode(teclas.ExitKey)
            exit = true;
            return
        else
            numero_boton = find(keyCode==1);
            if length(numero_boton) == 1
                if ('0' <= numero_boton && numero_boton <= '9') || any(numero_boton == BOTONES_NUMERICO) || numero_boton == BOTON_PUNTO || numero_boton == BOTON_COMA || numero_boton == BORRAR

                    if numero_boton == BORRAR && ~isempty(texto)
                        texto(end) = [];
                    elseif length(texto) < 10 && numero_boton ~= BORRAR
                        if any(numero_boton == BOTONES_NUMERICO)
                            sub = find(numero_boton == BOTONES_NUMERICO);
                            texto = [texto num2str(sub-1)];
                        elseif numero_boton == BOTON_PUNTO || numero_boton == BOTON_COMA
                            texto = [texto ','];
                        else
                            texto = [texto char(numero_boton)];
                        end

                    end

                    Screen('TextSize', hd.window, textSize);
                    DrawFormattedText(hd.window, PREGUNTA, 'center','center', hd.white, [],[],[],2,[],RECT_PREGUNTA);
                    DrawFormattedText(hd.window, texto, 'justifytomax','center', hd.white, [],[],[],[],[],RECT_TEXTO);
                    DrawFormattedText(hd.window, UNIDADES, 'center','center', hd.white, [],[],[],[],[],RECT_UNIDADES);
                    MensajeContinuar(MENSAJE_CONTINUAR, hd);

                    Screen('Flip',hd.window); 
                end
            end
        end 
        
    end

end