function [log, exit] = BloquePreguntas(bloque,hd, teclas)

    exit = false;
    log = [];
        
    %% Question Texts
    preguntas = cell(2,1); % Preallocate for speed
    
    if strcmp(bloque,'Self')
        % First question definition  
        textos_opciones.pregunta = 'How pleasant was this condition?';
        textos_opciones.minimo = 'Not at all';
        textos_opciones.medio = '';
        textos_opciones.maximo = 'Very much';
    elseif strcmp(bloque,'Other')
        % First question definition  
        textos_opciones.pregunta = 'How pleasant was this condition?';
        textos_opciones.minimo = 'Not at all';
        textos_opciones.medio = '';
        textos_opciones.maximo = 'Very much';
    elseif strcmp(bloque,'Object')
        % First question definition  
        textos_opciones.pregunta = 'How pleasant was this condition?';
        textos_opciones.minimo = 'Not at all';
        textos_opciones.medio = '';
        textos_opciones.maximo = 'Very much';
    end
    % Save in var
    preguntas{1} = textos_opciones;
    
    % Second question definition
    textos_opciones.pregunta = 'How unpleasant was this condition?';
    textos_opciones.minimo = 'Not at all';
    textos_opciones.medio = '';
    textos_opciones.maximo = 'Very much';
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