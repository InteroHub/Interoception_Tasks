function EnviarMarca(marca)

    global pportobj pportaddr MARCA_DURACION EEG

    if EEG
        io64(pportobj,pportaddr, marca);
        WaitSecs(MARCA_DURACION);
        io64(pportobj,pportaddr,0);
    else
        display(marca)
    end

    
end