function respuesta = AlgunBotonApretado(keyCode, botones)

    if isempty(keyCode)
        [~, ~, keyCode, ~] = KbCheck;
    end

    respuesta = find(keyCode(botones) == 1);
    if isempty(respuesta)
        respuesta = false;
    else
        respuesta = true;
    end

end