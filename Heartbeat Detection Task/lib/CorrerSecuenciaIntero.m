function [log, exit] = CorrerSecuenciaIntero(bloque, teclas, hd, tiempo_limite, marcas, port_handle)
    
    global EEG
    global TAMANIO_INSTRUCCIONES
    global TAMANIO_TEXTO
    exit = false;
    log  = [];
    
    %% Instructions
    for x = 1:length(bloque.instrucciones)
        TextoCentrado(bloque.instrucciones{x}, TAMANIO_INSTRUCCIONES, hd);
        Screen('Flip', hd.window);
        exit = EsperarBoton(teclas.Continuar, teclas.ExitKey);
        if exit; return; end
    end
    
    %% Fixation Cross
    TextoCentrado('+', TAMANIO_TEXTO, hd); % Fixation Cross
    if EEG; send_ns_trigger(marcas.inicio, port_handle); end
    Screen('Flip', hd.window);             % Window Flip   
    
    %% Begining of Task
    indice        = 0;                     % Amounts of 'Z' pressed
    status.Active = 1;                     % Activate task (Transformers assemble)
    inicio        = GetSecs;               % Task start Latency
    % Audio config
    if ~isempty(bloque.audio)
        % Audio variables
        audiodevices    = PsychPortAudio('GetDevices');
        num_dispositivo = BuscarDeviceOutput(audiodevices);
        hd.pahandle     = PsychPortAudio('Open',audiodevices(num_dispositivo).DeviceIndex,[],1,bloque.freq,1);
        % Audio port config
        PsychPortAudio('Volume', hd.pahandle , 10);     
        PsychPortAudio('FillBuffer', hd.pahandle, bloque.audio'); % Fill the audio playback buffer with the audio data 'wavedata':
        PsychPortAudio('Start', hd.pahandle, 1, 0, 1);
        status = PsychPortAudio('GetStatus',hd.pahandle);  % Check if it plays the audio
    end
    
    %% Audio starts playing (if required)
    log.inicio = inicio; % Define in log starting point of Task
    timedout   = false;
    
    % Key usage (define keys to allow)
    while status.Active == 1 && exit == false
        RestrictKeysForKbCheck([teclas.LatidosKey, teclas.ExitKey, teclas.botones_salteado]);
        while ~timedout
            [keyIsDown, keyTime, keyCode] = KbCheck;
            if (keyIsDown), break; end
            if ((keyTime - inicio) >= tiempo_limite), timedout = true; end
        end 
        
        if (~timedout)
            if keyCode(teclas.LatidosKey)
            if EEG; send_ns_trigger(marcas.respuesta, port_handle); end
            log_trial.ReactionTime = keyTime;                                    % Log save per press
            log_trial.relative     = keyTime - inicio;                           % Log save per press relative to start of task ---------------------------------- OOOO
            while keyIsDown == 1; [keyIsDown,~,~] = KbCheck; end              % Wait for subject to realease key
            indice              = indice + 1;                                 % Add to index (amount of PRESSES)
            log.Tapping(indice) = log_trial;
            elseif keyCode(teclas.ExitKey); exit = true; if EEG; send_ns_trigger(marcas.fin, port_handle); end ;break; % If presses escape send finishing event exit
            elseif keyCode(teclas.botones_salteado); break;  
            end
        end
       if ~isempty(bloque.audio)
            status = PsychPortAudio('GetStatus', hd.pahandle);                % Check if it keeps playing  
       end 
       if (GetSecs-inicio) >= tiempo_limite; status.Active = 0; end           % If it exceeds max time, kill it   
    end  
    
    %% Stop audio once it finishes or is stopped
    if ~isempty(bloque.audio); PsychPortAudio('Stop',hd.pahandle); end
       
    %% Log Save block finish
    if EEG; send_ns_trigger(marcas.fin, port_handle); end
    log.fin    = GetSecs;      % Task ends
    log.indice = indice;       % log amount of pressed keys
    RestrictKeysForKbCheck([]);

end