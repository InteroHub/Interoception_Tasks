function HBD_Task()
%%%%%%%%%% Interoception Protocol
%%%%%%%%%% Psychtoolbox - Ineco - 2019
%% Contact Info
% Origin: Bs.As Argentina
% Mod:  29 June 2021 

% CITAS
% Paula Celeste Salamone, et al. 2020
% https://doi.org/10.1093/braincomms/fcaa095

%  Mail: pausalamone@gmail.com/matias.fraile95@gmail.com
%-------------------------------------------------------------------------%
%% Requirements
%  Psychtoolbox 
%  Recorded Heartbeats
%  Change port if using EEG  
%-------------------------------------------------------------------------%
%% Heartbeat detection (HBD) Task:
%  Conditions: Exteroception/Interoception/Exteroception/Interoception
%  Sequence: Extero-Intero-Extero-Intero
%  Blocks per Condition - 2 min each 
%  Behavior + ECG + optional EEG
%-------------------------------------------------------------------------%
%% Interoception: 
%  Tapping task following your OWN heartbeat. 
%  Press Z every time you consider your heart beats.
%  Not allowed to abuse the system by pressing your veins or...
%  any other kind of cheat.
%-------------------------------------------------------------------------%
%% Exteroception:
%  Blocks: Sincronic - Asincronic 
%  Tapping task following an external heartbeat.
%  Press Z every time you hear the heart beating.
%-------------------------------------------------------------------------%
%% Outputs:
%  Log Structure with: Secuencia(cell with block answers), name, sequence
%  order, task start latency, task end latency, questions (cell with
%  questions answers), task duration.
%-------------------------------------------------------------------------%
if exist('port_handle','var')
    close_ns_port(port_handle); %#ok
end

clc;
close all;
clearvars;

%% LIBRARY (fx)
addpath('lib');

%% Constants
global TAMANIO_INSTRUCCIONES
global TAMANIO_TEXTO
global EEG 
global pportobj pportaddr MARCA_DURACION %#ok
global MARCA_PAUSA_INICIO MARCA_PAUSA_FIN
TAMANIO_TEXTO         = 0.05; % Text size
TAMANIO_INSTRUCCIONES = 0.03; % Instruction size
MARCA_PAUSA_INICIO    = 254;  % Start marker
MARCA_PAUSA_FIN       = 255;  % Finish 255
DURACION_BLOQUE       = 120;  % Block duration in secs
MENSAJE_CONTINUAR     = 'Press SPACE to start'; %#ok<NASGU>
 
%% Paralel Port (Connect to EEG if true )z
MARCA_DURACION = 5e-3;
EEG            = false; % True if you want to use EEG/ECG
pportaddr      = '7'; % '4' 'C020'; % CHANGE TO BIOPAC PORT ------------------------------------- OOOO

if EEG && exist('pportaddr','var') && ~isempty(pportaddr)
    fprintf('Connecting to parallel port 0x%s.\n', pportaddr);
    %pportaddr  = serialport(pportaddr,9600); %hex2dec(pportaddr);
    port_handle = open_ns_port(pportaddr); % added
    %pportobj   = io64;
    %io64status = io64(pportobj);
    %EnviarMarca(0); % SEND EVENTS  ------------------------------------------------------------- OOOO
%     if io64status ~= 0
%         error('io62 failure: could not initialise parallel port.\n');
%     end
else
    port_handle = 0;
end

%% Keyboard
KbName('UnifyKeyNames');
teclas.ExitKey          = KbName('ESCAPE');          % Exit
teclas.LatidosKey       = KbName('Z');               % Tapping key 
teclas.pausa.inicio     = KbName('P');               % Start Pause key
teclas.pausa.fin        = KbName('Q');               % End Pause key
teclas.RightKey         = KbName('RightArrow');      % Right
teclas.LeftKey          = KbName('LeftArrow');       % Left
teclas.EnterKey         = KbName('DownArrow');       % Down
teclas.Continuar        = KbName('SPACE');           % Continue
teclas.Enter            = KbName('return');          % Enter Key
teclas.botones_salteado = KbName('W');               % Skip

%% Subject Name
nombre = inputdlg('Name / Code:');
nombre = nombre{1};

%% Load sequence to run (start with intero or extero cond)
%secuencia_actual = {'Motor', 'Motor', 'Intero', 'Intero', 'Feedback', 'Intero', 'Intero'};
choice = menu('Choose version','1-E','2-I');
if choice == 1
    secuencia_actual = {'RestExtero','RestIntero','Extero','Intero'};
else
    secuencia_actual = {'RestIntero', 'RestExtero','Intero','Extero'};
end

%% PSYCHOTOOLBOX
hd = init_psych;

%% LOG Struct
log.BlockAnswers = secuencia_actual; % Sequence
log.name         = nombre;           % Name

%% Load Interoception data

log.sequence   = secuencia_actual;                 % Define sequence
intero.bloques = cell(length(secuencia_actual),1); % Preallocate blocks  
intero.marcas  = cell(length(secuencia_actual),1); % Preallocate marks
AudioAmount    = 1;                                % Define var for audio to play sincronic first

% Create path where to look for instructions 
intero_dir     = fullfile('data','BlockInstructions');

% Iter through sequence
for i = 1:length(secuencia_actual)
    bloque = secuencia_actual{i};
    data_dir = fullfile(intero_dir, bloque); 
    if strcmp(bloque, 'RestExtero')      % Load Motor instructions
        intero.bloques{i} = CargarBloqueInteroMotor(data_dir, AudioAmount); 
        marca.inicio      = 1;           % Start marker
        marca.respuesta   = 5;         % Answer marker
        marca.fin         = 11;          % End marker
    elseif strcmp(bloque, 'Extero')      % Load Motor instructions
        intero.bloques{i} = CargarBloqueInteroMotor(data_dir, AudioAmount);
        marca.inicio      = 3;
        marca.respuesta   = 6;
        marca.fin         = 33;
    elseif strcmp(bloque, 'RestIntero')  % Load Intero instructions
        intero.bloques{i} = CargarBloqueInteroMotor(data_dir, AudioAmount);
        marca.inicio      = 2;      
        marca.respuesta   = 7;      
        marca.fin         = 22;      
    elseif strcmp(bloque, 'Intero')      % Load Intero instructions
        intero.bloques{i} = CargarBloqueInteroMotor(data_dir, AudioAmount);
        marca.inicio      = 4;      
        marca.respuesta   = 8;      
        marca.fin         = 44;     
    end       
        intero.marcas{i}      = marca;    % Save in struct for output
end


%% Prepare log for task
log_file   = PrepararLog('log', nombre, 'paradigma'); % Prepare log
log.start = GetSecs;                                  % Task Start latency

%% Presentation Instructions
instrucciones_generales = fileread(fullfile('data', 'General_Instructions.txt'));    % Load instructions
exit                    = PresentarInstruccion(hd, instrucciones_generales, teclas); % General instructions presentation (Exit task function (esc))
if exit; Salir(hd); return; end 

%% Task start
% Iter Through sequence
for i = 1:length(secuencia_actual)
    % Hard code the first event
    if i == 1 && EEG
        send_ns_trigger(100, port_handle); % Task start
    end
    [log.BlockAnswers{i}, exit] = CorrerSecuenciaIntero(intero.bloques{i}, teclas, hd, DURACION_BLOQUE, intero.marcas{i}, port_handle);    
    if exit; break; end
    [log.preguntas{i}, exit] = BloquePreguntas(secuencia_actual{i},hd, teclas); % Log Autopercecption Scale
    if exit; break; end 
    save(log_file, 'log'); % Save Log
end

%% Task end message
TextoCentrado('Well done! Thank you for your participation', TAMANIO_INSTRUCCIONES, hd, hd.white);
Screen('Flip',hd.window);

if EEG
    % Add one last hard coded event and TADA
    send_ns_trigger(101, port_handle); %#ok
end 
%% Task duration log save
log.end      = GetSecs;              % Final latency
log.duration = log.end - log.start;  %Task Duration
save(log_file, 'log');               % Save Log
WaitSecs(2);

if EEG
    close_ns_port(port_handle); %#ok
end
%% Exit
Salir(hd);

end