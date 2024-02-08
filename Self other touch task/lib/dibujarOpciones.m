function dibujarOpciones(elegido, textos, cursor, hd)

    window = hd.window;
    scrnsize = hd.scrnsize;
    
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    [xCenter, yCenter] = RectCenter(scrnsize);
    
    white = [255 255 255];
    black = [0 0 0];
    red = [255 0 0];

    xLength = round(screenXpixels * 0.5); % ancho del rectangulo
    yLength = round(screenYpixels * 0.1); % alto del rectangulo
    xPos = xCenter - round(xLength/2);    % posicion X del rectangulo
    yPos = yCenter + round(yLength/2);    % posicion Y del rectangulo
    BoxXLength = round(xLength/9);        % ancho de cada cajita

   % ---------- TEXTOS -------------------------------------
   
    textYpos = yPos - yLength;
    
    textSize = round(yLength*0.5);
    Screen('TextSize', window, textSize);
    rectText = [0  round(textYpos/2) screenXpixels textYpos];
    DrawFormattedText(window, textos.pregunta, 'center', 'center', white, [],[],[], 2,[],rectText);

    texto_instrucciones = 'The right and left arrows move the markers, press the down arrow to confirm your choice.';
    MensajeContinuar(texto_instrucciones, hd);
    
    if cursor
    
    % ------------------------ OPCIONES -----------------------------------

        textSize = round(yLength*0.4);
        Screen('TextSize', window, textSize);

        rectText = [xPos  textYpos BoxXLength+xPos textYpos+yLength];
        DrawFormattedText(window, textos.minimo, 'center', 'center', white, [],[],[],[],[],rectText);

        rectText = [xPos+BoxXLength*4  textYpos BoxXLength*5+xPos textYpos+yLength];
        DrawFormattedText(window, textos.medio, 'center', 'center', white, [],[],[],[],[],rectText);

        rectText = [xPos+BoxXLength*8  textYpos BoxXLength*9+xPos textYpos+yLength];
        DrawFormattedText(window, textos.maximo, 'center', 'center', white, [],[],[],[],[],rectText);

        % ------------------------ CURSOR -------------------------------------

        textSize = round(yLength*0.6);
        Screen('TextSize', window, textSize);
        centro = round(yPos + yLength/2); 
        corrimiento = 0;
        for n = 1:9
            rectSel = [xPos+BoxXLength*(n-1)  yPos BoxXLength*n+xPos yLength+yPos];
            textRec = [xPos+BoxXLength*(n-1)  centro-round(textSize/2)-corrimiento BoxXLength*n+xPos centro+round(textSize/2)];
            if n == elegido
                Screen('FillRect', window, red, rectSel);
            else
                Screen('FillRect', window, white, rectSel);
            end
            DrawFormattedText(window, int2str(n), 'center','center', black, [],[],[],[],[], textRec);
        end
    end
end