function bloque = CargarBloqueInteroMotor(carpeta, AudioAmount)
    bloque.audio = [];         % Preallocate for speed
    bloque.freq = [];          % Preallocate for speed
    bloque.instrucciones = []; % Preallocate for speed   
    
    if AudioAmount == 1
        archivo_audio = fullfile(carpeta, 'sampleecg.wav');       % Asincronic
        AudioAmount = AudioAmount + 1; %#ok<NASGU>
    else
        archivo_audio = fullfile(carpeta, 'sampleecg.wav');      % Asincronic
    end    
    carpeta_instrucciones = fullfile(carpeta, 'instrucciones');  % instructions
    if exist(carpeta_instrucciones, 'dir') == 7
        bloque.instrucciones = CargarTextosDeCarpeta(carpeta_instrucciones);
    end
    if exist(archivo_audio, 'file') == 2
        [bloque.audio, bloque.freq] = audioread(archivo_audio);
    end

end