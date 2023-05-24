function [ ptb, ppa ] = initiatePtb_v3
% This function was created for a Flicker-defiend motion (FDM) related task (04/08/2018).

%% PsychToolBox Screen (ptb)
PsychDefaultSetup(2);

Screen('Preference', 'SkipSyncTests', 1);
screens = Screen('Screens');
ptb.scrNum = max(screens); 

ptb.white = WhiteIndex(ptb.scrNum);    
ptb.black = BlackIndex(ptb.scrNum);
ptb.grey = ptb.white / 2;

[ptb.w, ptb.fullRect] = PsychImaging('OpenWindow', ptb.scrNum, ptb.grey); % screen handle
% [ptb.w, ptb.fullRect] = PsychImaging('OpenWindow', 1, ptb.grey); % screen handle

Screen('BlendFunction', ptb.w, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

ptb.x = ptb.fullRect(3);
ptb.y = ptb.fullRect(4);

[ptb.xCenter, ptb.yCenter] = RectCenter(ptb.fullRect);
ptb.ifi = Screen('GetFlipInterval', ptb.w);

Screen('Flip', ptb.w);

ptb.help = { ... 
    'scrNum: selected (maximum) monitor number among detected monitors'
    'white: white color'
    'black: black color'
    'grey: grey color'
    'w: handle of window (base rect)'
    'fullRect: pixel size of window'
    'xCenter: horizontal pixel size of window'
    'yCenter: vertical pixel size of window'
    'ifi: flip interval in seconds'
    'startTime: psychtoolbox start time (absolute time)' ...
};
%% PsychPortAudio (ppa)
% InitializePsychSound(1);
% 
% nrchannels = 2; % nrchannels: number of audio channels to use (eg., 2 is for stereo)
% freq = 48000; % freq: sound frequency in Hz
% beepLengthSecs = 0.08;
% ppa.startCue = 0;
% ppa.waitForDeviceStart = 0;
% 
% %ppa.trialHndl = PsychPortAudio('Open', [], 1, 3, freq, nrchannels); % audio handle
% ppa.glimpseHndl = PsychPortAudio('Open', [], 1, 3, freq, nrchannels); % audio handle
% %PsychPortAudio('Volume', ppa.trialHndl, 0.5);
% PsychPortAudio('Volume', ppa.glimpseHndl, 0.6);
% %trialBeep = MakeBeep(500, beepLengthSecs, freq);
% glimepsBeep = MakeBeep(300, beepLengthSecs, freq);
% %PsychPortAudio('FillBuffer', ppa.trialHndl, [trialBeep; trialBeep]);
% PsychPortAudio('FillBuffer', ppa.glimpseHndl, [glimepsBeep; glimepsBeep]);
% 
% ppa.help = {...
%     'startCue: '
%     'waitForDeviceStart: '
%     'trialHndl: handle of audio track for notifying start of each trial'
%     'glimpseHndl: handle of audio track for notifying out of fixation area'
% };
%% Maximum Priority
maxPriorityLevel = MaxPriority(ptb.scrNum);
Priority(maxPriorityLevel);

%% Mouse & Keyboard
HideCursor;
%ListenChar(2);

%% Others
ptb.startTime = GetSecs;
end

