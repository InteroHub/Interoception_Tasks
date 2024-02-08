function [apretados, anteriores] = KbCheckNewPush(anteriores)
    [~, ~, keyCode, ~] = KbCheck;
    teclas_activas = find(keyCode);
    anteriores_sub = find(anteriores);
    apretados_dif = setdiff(teclas_activas, anteriores_sub);
    anteriores = keyCode;

    apretados = zeros(1, 256);

    if isempty(apretados_dif)
        return
    end
    
    for i = 1:length(apretados_dif)
        apretados(apretados_dif(i)) = 1;
    end
end
