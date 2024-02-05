function [log, exit] = BloquePreguntas(bloque,hd, teclas)

    exit = false;
    log = [];
        
    %% Question Texts
    preguntas = cell(2,1); % Preallocate for speed
    
    if strcmp(bloque,'RestExtero')
        % First question definition  
        textos_opciones.pregunta = 'How clearly did you feel or hear the heartbeats?';
        textos_opciones.minimo = 'Not at all';
        textos_opciones.medio = '';
        textos_opciones.maximo = 'Very much';
    elseif strcmp(bloque,'Extero')
        % First question definition  
        textos_opciones.pregunta = 'How clearly did you feel or hear the heartbeats?';
        textos_opciones.minimo = 'Not at all';
        textos_opciones.medio = '';
        textos_opciones.maximo = 'Very much';
    elseif strcmp(bloque,'RestIntero')
        % First question definition  
        textos_opciones.pregunta = 'How clearly did you feel or hear your own heartbeats?';
        textos_opciones.minimo = 'Not at all';
        textos_opciones.medio = '';
        textos_opciones.maximo = 'Very much';
    elseif strcmp(bloque,'Intero')
        % First question definition  
        textos_opciones.pregunta = 'How clearly did you feel or hear your own heartbeats?';
        textos_opciones.minimo = 'Not at all';
        textos_opciones.medio = '';
        textos_opciones.maximo = 'Very much';
    end
    % Save in var
    preguntas{1} = textos_opciones;
    
    % Second question definition
    textos_opciones.pregunta = 'How well do you think you performed in the task?';
    textos_opciones.minimo = 'Very poorly';
    textos_opciones.medio = '';
    textos_opciones.maximo = 'Very well';
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