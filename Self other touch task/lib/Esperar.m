% Espera hasta que transcurra un tiempo o hasta que se apriete uno de los
% botones.
function [exit, saltear_bloque] = Esperar(tiempo, boton_salida, boton_pausa, botones_salteado)    
    exit = false;
    tStart = GetSecs;
    saltear_bloque = false;    
    while GetSecs - tStart < tiempo
        [~, ~, keyCode, ~] = KbCheck;
        
        if keyCode(boton_salida)
            exit = true;
            return
        end
        
        saltear_bloque = BotonesApretados(keyCode, botones_salteado);
        if saltear_bloque
            return;
        end
        
        if ~isempty(boton_pausa.inicio) && keyCode(boton_pausa.inicio)                  
            exit = EsperarPausa(boton_pausa.fin, boton_salida);              
        end

    end
end