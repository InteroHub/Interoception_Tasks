function textura = CargarTextura(direccion, window)

    imagen = imread(direccion);
    textura = Screen('MakeTexture', window, imagen);

end