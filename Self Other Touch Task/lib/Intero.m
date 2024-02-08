function Intero()

clc;
sca;
close all;
clearvars;
clear all;

%% LIBRERIAS

addpath('lib');

%% CONSTANTES

global TAMANIO_INSTRUCCIONES
global TAMANIO_TEXTO
global EEG
global pportobj pportaddr MARCA_DURACION

MARCA_DURACION = 1e-3;

EEG = true;

TAMANIO_TEXTO = 0.05;
TAMANIO_INSTRUCCIONES = 0.03;

TIEMPO_MOTOR_PRACTICA = 30;
TIEMPO_MOTOR = 120;

%% PUERTO PARALELO

if EEG
    pportaddr = 'C020';

    if exist('pportaddr','var') && ~isempty(pportaddr)
        fprintf('Connecting to parallel port 0x%s.\n', pportaddr);
        pportaddr = hex2dec(pportaddr);

        pportobj = io32;
        io32status = io32(pportobj);

        if io32status ~= 0
            error('io32 failure: could not initialise parallel port.\n');
        end
    end
end

%% TECLAS

KbName('UnifyKeyNames');
teclas.ExitKey = KbName('ESCAPE');
teclas.LatidosKey = KbName('Z'); 
teclas.afirmativo = KbName('V');
teclas.negativo = KbName('N');
teclas.botones_salteado = [KbName('P') KbName('Q')];
teclas.RightKey = KbName('RightArrow');
teclas.LeftKey = KbName('LeftArrow');
teclas.EnterKey = KbName('DownArrow');
teclas.Continuar = KbName('SPACE');
teclas.Enter = KbName('return');


%% NOMBRE DEL PACIENTE

nombre = inputdlg('Nombre:');
nombre = nombre{1};

%% CARGO LA SECUENCIA A CORRER
secuencia_actual.intero = {'intero' 'intero'};

%% PSYCHOTOOLBOX
hd = init_psych;

%% LOG
log.secuencia = secuencia_actual;
log.nombre = nombre;


%% CARGO DATOS DE INTERO

log.intero = cell(length(secuencia_actual.intero),1);
intero.bloques = cell(length(secuencia_actual.intero),1);
intero.marcas = cell(length(secuencia_actual.intero),1);

contador_intero = 1;
contador_motor = 1;
intero_dir = fullfile('data','intersujeto');
for i = 1:length(secuencia_actual.intero)

    bloque = secuencia_actual.intero{i};
    data_dir = fullfile(intero_dir, bloque);
    
    if strcmp(bloque, 'motor')
        intero.bloques{i} = CargarBloqueInteroMotor(data_dir, contador_motor);    
        marca.inicio = contador_motor;
        contador_motor = contador_motor + 1;
    else
        intero.bloques{i} = CargarBloqueInteroMotor(data_dir, contador_intero);
        marca.inicio = contador_intero + 2;
        contador_intero = contador_intero + 1;
    end
    
    marca.respuesta = 100 + marca.inicio;
    marca.fin = 11*marca.inicio;
    
    intero.marcas{i} = marca;
    
end

practica_dir = fullfile(intero_dir, 'practica');
intero.practica = CargarBloqueInteroMotor(practica_dir, 1);

%% INSTRUCCION QUE NO ES HEP 
instrucciones_HEP = fileread(fullfile('data','instrucciones.txt'));
TextoCentrado(instrucciones_HEP, TAMANIO_INSTRUCCIONES, hd);
Screen('Flip',hd.window);
exit = EsperarBoton(teclas.Continuar, teclas.ExitKey);
if exit
    Salir(hd);
    return;
end

%% INSTRUCCIONES PRINCIPALES
instrucciones = CargarTextosDeCarpeta(fullfile('data','instrucciones'));
for x = 1:length(instrucciones)
    TextoCentrado(instrucciones{x}, TAMANIO_INSTRUCCIONES, hd);
    Screen('Flip',hd.window);
    exit = EsperarBoton(teclas.Continuar, teclas.ExitKey);
    if exit
        Salir(hd);
        return;
    end
end
    

%% PRACTICAS
[~, exit] = CorrerSecuenciaIntero(intero.practica, teclas, hd, TIEMPO_MOTOR_PRACTICA, true, []);
if exit
    Salir(hd);
    return
end

%% PARADIGMA

for i = 1:length(secuencia_actual.intero)
    [log.intero{i}, exit] = CorrerSecuenciaIntero(intero.bloques{i}, teclas, hd, TIEMPO_MOTOR, false, intero.marcas{i});
    if exit
        break;
    end
    [log.preguntas{i}, exit] = BloquePreguntas(hd, teclas);
    if exit
        break;
    end

    [log.intero{i}.tiempo_estimado, exit] = BloquePreguntaTextBox(hd, teclas);
    if exit
        break;
    end

end

TextoCentrado('Usted lo hizo muy bien, gracias por participar', TAMANIO_INSTRUCCIONES, hd, hd.white);
Screen('Flip',hd.window);
WaitSecs(2);


%% GUARDO LOG
log_file = PrepararLog('log', nombre, 'Intero');
save(log_file, 'log');

%% SALIR
Salir(hd);
end