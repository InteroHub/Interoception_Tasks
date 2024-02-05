function [log, exit] = BloquePreguntas(bloque,hd, teclas)

    exit = false;
    log = [];
        
    %% Question Texts
    preguntas = cell(2,1); % Preallocate for speed
    
    if strcmp(bloque,'RestExtero')
        % First question definition  
        textos_opciones.pregunta = 'Hur tydligt kände eller hörde du hjärtslagen?';
        textos_opciones.minimo = 'Inget';
        textos_opciones.medio = '';
        textos_opciones.maximo = 'Väldigt mycket';
    elseif strcmp(bloque,'Extero')
        % First question definition  
        textos_opciones.pregunta = 'Hur tydligt kände eller hörde du hjärtslagen?';
        textos_opciones.minimo = 'Inget';
        textos_opciones.medio = '';
        textos_opciones.maximo = 'Väldigt mycket';
    elseif strcmp(bloque,'RestIntero')
        % First question definition  
        textos_opciones.pregunta = 'Hur tydligen kände eller hörde du dina egna hjärtslag?';
        textos_opciones.minimo = 'Inget';
        textos_opciones.medio = '';
        textos_opciones.maximo = 'Väldigt mycket';
    elseif strcmp(bloque,'Intero')
        % First question definition  
        textos_opciones.pregunta = 'Hur tydligen kände eller hörde du dina egna hjärtslag?';
        textos_opciones.minimo = 'Inget';
        textos_opciones.medio = '';
        textos_opciones.maximo = 'Väldigt mycket';
    end
    % Save in var
    preguntas{1} = textos_opciones;
    
    % Second question definition
    textos_opciones.pregunta = 'Hur bra tror du att du genomförde uppgiften?';
    textos_opciones.minimo = 'Väldigt dåligt';
    textos_opciones.medio = '';
    textos_opciones.maximo = 'Väldigt bra';
    % Save in var
    preguntas{2} = textos_opciones;
    
    % Iter through questions
    for j = 1:length(preguntas)
        Screen('Flip',hd.window);
        WaitSecs(0.5);
        [exit, log_respuesta, saltear_bloque] = Respuesta(preguntas{j}, teclas, hd);
        if exit || saltear_bloque
            return;
        end
        log_bloque.respuesta = log_respuesta; % Save answer in log
        log{j}               = log_bloque;    %#ok<AGROW>        
    end   
end