function hd = init_psych()

    ListenChar(2);
    HideCursor; 
    
    % Define screen atributes
    hd.bgcolor    = [127.5 127.5 127.5] ;
    hd.dispscreen = 0;
    hd.itemsize   = 100;
    hd.wsize      = (hd.itemsize/2)+30;
    
    % Define text atributes
    hd.textsize  = 60;
    hd.textfont  = 'Helvetica';
    hd.textcolor = [255 255 255];%[255 255 255]
    hd.ontime    = 150/1000;
    hd.offtime   = 850/1000;
    
    % Might not be used
    blacktime =500/1000; %#ok<NASGU>
    debounce  =100/1000;  %#ok<NASGU>
    
    % Define colors
    hd.white = [255 255 255];
    hd.black = [0 0 0];
    hd.red   = [255 0 0];
    hd.green = [0 255 0];
    hd.blue  = [0 0 255];

    % Screen Preferences
    Screen('Preference', 'TextRenderer', 1);
    Screen('Preference', 'TextAntiAliasing', 2);
    Screen('Preference', 'TextAlphaBlending',1);
    Screen('Preference', 'SkipSyncTests', 1) %Screen('Preference', 'SkipSyncTests', 0);

    % Open Psychtoolbox main window
    [window,scrnsize] = Screen('OpenWindow', hd.dispscreen, hd.bgcolor,[]); %  [50 50 730 470]
    hd.window   = window;
    hd.centerx  = scrnsize(3)/2;
    hd.centery  = scrnsize(4)/2;
    hd.scrnsize = scrnsize;

    % Adjust requested SOA so that it is an exact multiple of the base refresh
    % interval of the monitor at the current refresh rate.
    refreshInterval = Screen('GetFlipInterval',hd.window);
    hd.ontime       = ceil(hd.ontime/refreshInterval) * refreshInterval;
    hd.offtime      = ceil(hd.offtime/refreshInterval) * refreshInterval;
    fprintf('\nUsing ON time of %dms with OFF time of %dms.\n', round(hd.ontime*1000), round(hd.offtime*1000));
    Screen('TextFont',hd.window,hd.textfont);

    %Screen settings (Might not be used)
    xCenter=hd.centerx; %#ok<NASGU>
    yCenter=hd.centery; %#ok<NASGU>

    %KbName('UnifyKeyNames');
    % ScreenPriority
    topPriorityLevel = MaxPriority(window);
    Priority(topPriorityLevel);

    % Needed for dots to be circular
    Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    % Audio settings
    fprintf('Initialising audio.\n');
    InitializePsychSound
    if PsychPortAudio('GetOpenDeviceCount') == 1
        PsychPortAudio('Close',0);
    end
    
    % Audio for Mac
    if ismac
        audiodevices = PsychPortAudio('GetDevices');
        outdevice = strcmp('Built-in Output',{audiodevices.DeviceName}); %#ok<NASGU>
        hd.outdevice = 1;
    elseif ispc
        audiodevices = PsychPortAudio('GetDevices',3);
        if ~isempty(audiodevices)
            %DMX audio
            outdevice = strcmp('DMX 6Fire USB ASIO Driver',{audiodevices.DeviceName}); %#ok<NASGU>
            hd.outdevice = 2;
        else
            %Windows default audio
            audiodevices = PsychPortAudio('GetDevices',2);
            outdevice = strcmp('Microsoft Sound Mapper - Output',{audiodevices.DeviceName}); %#ok<NASGU>
            hd.outdevice = 3;
        end
    else
        error('Unsupported OS platform!');
    InitializePsychSound(1);
end
