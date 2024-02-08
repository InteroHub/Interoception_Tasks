function bloque = CargarArchivo(archivo)
    
    str = fileread(archivo);
    bloque = textscan(str, '%s', 'delimiter', '\n');
    bloque = bloque{1};

end