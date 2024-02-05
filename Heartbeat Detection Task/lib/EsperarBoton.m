function exit = EsperarBoton(ContinueKey, exitKey)
    exit = false;
    while true
        [~, keyCode, ~] = KbPressWait();
      
        if keyCode(ContinueKey)
            return;
        elseif keyCode(exitKey)
            exit = true;
            return;
        end
        
    end 
end