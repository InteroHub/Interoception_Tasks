function DibujarTextura(textura, window)

%     [screenXpixels, screenYpixels] = Screen('WindowSize', hd.window);
%     TEXTURA_ANCHO = round(screenXpixels);
%     TEXTURA_ALTO = round(TEXTURA_ANCHO * 149/254);
%     
%     Xpos = round((screenXpixels - TEXTURA_ANCHO*3)/2);
%     Ypos = round((screenYpixels - TEXTURA_ALTO) / 2);
%     rect_imagen = [Xpos  Ypos Xpos+TEXTURA_ANCHO Ypos+TEXTURA_ALTO];
%     Screen('DrawTexture', hd.window, textura, [], rect_imagen );        

    Screen('DrawTexture', window, textura);  

end