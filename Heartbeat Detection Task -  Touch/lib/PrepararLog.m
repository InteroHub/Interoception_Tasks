function log_file = PrepararLog(log_dir, nombre, paradigma)

    if (~exist(log_dir,'dir')) 
        mkdir(log_dir);
    end

    continuar = true;
    contador = 0;
    while continuar
        contador = contador + 1;
        nombre_archivo = [paradigma '_' nombre '_' date '_v' int2str(contador)];

        log_file = fullfile(log_dir, [nombre_archivo '.mat']);
        if (~exist(log_file ,'file'))
            continuar = false;
        end

    end
end