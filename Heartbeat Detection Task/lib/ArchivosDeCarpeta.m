function archivos = ArchivosDeCarpeta(direccion)
    archivos_aux = dir(direccion);
    
    archivos = {};
    for x = 1:length(archivos_aux)
        if archivos_aux(x).name(1) == '.'
            continue
        end
        archivos = [archivos archivos_aux(x).name];
    end
    
end