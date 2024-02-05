function exit = PresentarInstruccion(hd, instruccion, teclas)
   
    global TAMANIO_INSTRUCCIONES   
    TextoCentrado(instruccion, TAMANIO_INSTRUCCIONES, hd);
    Screen('Flip',hd.window);
    exit = EsperarBoton(teclas.Continuar, teclas.ExitKey);
    
end