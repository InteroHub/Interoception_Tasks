% Espera hasta que transcurra un tiempo o hasta que se apriete uno de los
% botones.
function [exit, respuesta, tiempo_respuesta] = EsperarBotones(botonSalida, botones)
    exit = false;
    tStart = GetSecs;
    respuesta = [];
    tiempo_respuesta = [];
    while true
        [~, ~, keyCode, ~] = KbCheck;
        
        if keyCode(botonSalida)
            exit = true;
            return
        end
        
        for i = 1:length(botones)
            if keyCode(botones{i})
                respuesta = i;
                tiempo_respuesta = GetSecs;
                return;
            end
        end
        
    end
end