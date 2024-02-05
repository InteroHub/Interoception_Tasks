function device = BuscarDeviceOutput(audiodevices)

    device = -1;

    for x = 1:length(audiodevices)
        nombre = audiodevices(x).DeviceName;
        separado = strsplit(nombre, '-');
        palabra_clave = separado{end};
        palabra_clave = lower(palabra_clave);
        if strcmp(palabra_clave, 'output')
            device = x;
            return
        end
        
    end

end