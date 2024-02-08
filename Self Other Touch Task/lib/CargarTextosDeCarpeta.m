function textos = CargarTextosDeCarpeta(carpeta)
   
    archivos_de_carpeta = ArchivosDeCarpeta(carpeta);
    textos = cell(1, length(archivos_de_carpeta));
    for i = 1:length(textos)
        textos{i} = fileread(fullfile(carpeta, archivos_de_carpeta{i}));
    end

end