function TextoCentrado(texto, tamanio, hd, color)

    [~, screenYpixels] = Screen('WindowSize', hd.window);

    textSize = round(screenYpixels*tamanio);
   
    Screen('TextSize', hd.window, textSize);
    if nargin > 3
        DrawFormattedText(hd.window, texto, 'center','center', color, [], [], [], 1.5, [], []);
    else
        DrawFormattedText(hd.window, texto, 'center','center', hd.white, [], [], [], 1.5, [], []);
    end
    
end
