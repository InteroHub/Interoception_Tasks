function respuesta = BotonesApretados(keyCode, botones)

    if isempty(keyCode)
        [~, ~, keyCode, ~] = KbCheck;
    end

    respuesta = find(keyCode(botones) == 1);
    if length(respuesta) == length(botones)
        respuesta = true;
    else
        respuesta = false;
    end

end