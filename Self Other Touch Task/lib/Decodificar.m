function [decodificado, claves] = Decodificar(codificado, map)

    decodificado = cell(length(codificado),1);
    claves = cell(length(codificado),1);
    
    for y = 1:length(codificado)

        claves{y} = codificado{y};
        decodificado{y} = map(codificado{y});
        
    end

end