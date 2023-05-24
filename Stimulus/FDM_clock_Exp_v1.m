% function TG = FDM_clock_Expv1()

clear
clc
cd('/Users/jongrok/Desktop/janghan/jumping');
addpath('/Users/jongrok/Desktop/janghan/jumping');
% written in Matlab R2019a
% for a display 1920*1080, 120Hz
% 'q' key for quit, 'space' key for moving to next trial
% plz check & modify "Distance Settings"

%% Gen Info
code_version = 'FDM_clock_Exp_v1';
% subject_number = 1;
initials = input('Subject initials?   ', 's');
date = datestr(now, 'mmm.dd.yyyy HH.MM.SS');
t_filename = strcat('Jumping_30.10_', initials,'_', date, '.mat');

%% EGI

triggerNet = 0;
% triggerNet = 1;
b_time = 2;

%% Exp Conditions
% independent
obj_rot_vel = [40 -40]; % object angular velocity (deg/s), +:clockwise / -:counter-clockwise
obj_texture_vel_rel = [0 1.9 3.5]; % pattern velocity relative to object velocity (tangential)
% 0: no jumps, 2: slow jumps, 2.5: fast jumps
% Ascending order is enssential


% constant
obj_num = 6;
obj_size = 1.42; % radius (deg)
obj_ecc = 10.66; % eccentricity (deg)
obj_dur = 6; % motion duration (sec)

obj_texture_angle_rel = 240; % pattern motion direction (deg) 0:inward / 180:outward / 90:forward / 270:backward

% make condition table
nRep = 5; % number of condition replication
expT = expmat_v3('obj_vel', obj_rot_vel, 'pat_vel', obj_texture_vel_rel, 'rep', nRep, 'response'); 
expT = sortrows(expT,'Order','ascend');
a = zeros(1, height(expT));
b = zeros(1, height(expT));
c = zeros(1, height(expT));
d = zeros(1, height(expT));

%% Init PTB
global ptb
ptb = initiatePtb_v3;
ptb.freq = 100;
% screen resolution should be 1920*1080, 120Hz

global rect % reduced resolution for flickering noise
rect.size = [ptb.x ptb.y]/4;
rect.rect = [0 0 rect.size];

ListenChar(2);


%% Key Setting
global key
key.q = KbName('q');
key.up = KbName('upArrow');
key.down = KbName('downArrow');
key.space = KbName('space');
key.s = KbName('s');
key.r = KbName('r');


%% Distance Settings
global dis
darkroom_302C_190429 = [140 163 91];
mylaptop = [15 29.4 16.7]; 
monitor_30inch = [70 59.6 33.5];
BrainX_Monitor = [60 40 30];
% [viewing distance (cm), display_horizontal_size (cm), display_vertical_size (cm)]

current_setting = BrainX_Monitor;
dis.scr2par = current_setting(1);
dis.scrSize = current_setting(2:3);


%% Stimulus Settings
pre_obj_dur = 0.5; % dynamic background noise only (sec)

obj_size_px = deg2pix_rect(obj_size);
obj_ecc_px = deg2pix(obj_ecc);

obj_env = zeros(round(obj_size_px)*3);
obj_env_center = round(size(obj_env)/2);

for px1 = 1:size(obj_env,1)
    for px2 = 1:size(obj_env,1)
        if (px1-obj_env_center(1))^2 + (px2-obj_env_center(2))^2 <= obj_size_px^2
            obj_env(px1,px2) = 1;
        end
    end
end

obj_rect = [0 0 size(obj_env)];
obj_texture = round( rand(size(obj_env,1), 3000) );


%% Noise texture
tmp = []; for cnt = 1:300, tmp.tmp{cnt} = round( rand(rect.size(2), rect.size(1)) ); end % for 1024*768 screen
%tmp = load('backnoise_long_rect.mat'); % for 1920*1080 screen
back_textures = tmp.tmp;
clear tmp;

back_len = length(back_textures);
back_rect = [0 0 size(back_textures{1})];


%% Fixataion Cross Settings
fixCrossDimPix = 8;
fix_xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
fix_yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
fix_allCoords = [fix_xCoords; fix_yCoords];
fix_widthPix = 4;
crossCol= 0;


%% Response Stim Settings
% rsp_size = 1768/1080; % radius (deg)
rsp_size = 1.42;
resp_rect = [ptb.xCenter ptb.yCenter+3]*[1 0 1 0; 0 1 0 1] + deg2pix(rsp_size)*[-1 -1 1 1];

rsp_stim_dur = 0.02; % (sec)

rsp_intvl_list = [inf logspace(log10(0.8), log10(0.125), 8)]; % (sec)




% EGI connecting
if triggerNet
	disp('Connecting to NetStation');
	[status,errorMsg] = NetStation('Connect','10.10.10.41',55513);
	if status ~= 0
		 error(errorMsg)
	end
end

% EGI starting
if triggerNet
    NetStation('StartRecording');
    WaitSecs(6);
    disp('Synchronizing to NetStation');
    NetStation('Synchronize',2);       % default SynchLimit = 2.5 ms
end


% Make Diode Texture at specified location

%% Trial Loop
% movie = Screen('CreateMovie', ptb.w, 'Test.mov');

for cnt = 1:height(expT)
    nn = numel(obj_rot_vel)*numel(obj_texture_vel_rel)*nRep;
    
    
    dioRect = [ 0 0 repmat(round(rect.rect(4)*0.5),1,2) ];% upper left corner for photodiode
    dio = zeros(dioRect(4), dioRect(3), 'uint8');
    dioInd0 = Screen('MakeTexture', ptb.w, dio); %black
    dio(:) = 255;
    dioInd1 = Screen('MakeTexture', ptb.w, dio); %white
    
    Screen('DrawTexture', ptb.w, dioInd1, [], dioRect); % creating white area at STRAT-SIGN onset
    a(1,cnt) = Screen('Flip', ptb.w);
    
    
    %Screen('TextSize',ptb.w, 30);
    %Screen('DrawText', ptb.w, text1, cx-deg2pixel(8), cy, 2);
    %Screen('Flip', ptb.w, 0);
    
    
    % 0. Hit s-key to start
    Screen('TextSize', ptb.w, ceil(0.045*ptb.x)); 
    Screen('TextFont', ptb.w, 'Helvetica');
    
    if mod(cnt-1,b_time) == 0 && cnt ~= 1
        tr_text = sprintf('break time!!!!!!!!'); 
        NetStation('StopRecording');
        NetStation('Disconnect');
    else
        tr_text = sprintf('Hit S-KEY to start');  
    end
    
        
    counting = sprintf('%d / %d',cnt, nn);
    Screen('DrawText',ptb.w,tr_text,ceil(0.34*ptb.x),ceil(0.4*ptb.y),[0,0,0]) % %d = N / %0.02f = 0.xx / %s = abcdef 
    Screen('DrawText',ptb.w,counting,ceil(0.8*ptb.x),ceil(0.8*ptb.y),[0,0,0])
    
    Screen('DrawTexture', ptb.w, dioInd0, [], dioRect); % creating black area during START-SIGN duration
    Screen('Flip', ptb.w);

        keyNext=0;
        while keyNext~=1
            [eKey, ~, kCod] = KbCheck;
            if eKey==1
                if mod(cnt - 1,b_time) == 0 && cnt ~= 1
                    if kCod(key.r)==1
                        keyNext=1;
                        if triggerNet
                            disp('Connecting to NetStation');
                            [status,errorMsg] = NetStation('Connect','10.10.10.41',55513);
                            if status ~= 0
                                error(errorMsg)
                            end
                        end
                        if triggerNet
                            NetStation('StartRecording');
                            WaitSecs(6);
                            disp('Synchronizing to NetStation')
                            NetStation('Synchronize',2);       % default SynchLimit = 2.5 ms
                        end
                    end
                else    
                    if kCod(key.s)==1
                        keyNext=1;
                    end
                end
                if kCod(key.q)==1
                    NetStation('StopRecording');
                    NetStation('Disconnect');
                    sca;break;
                end
            end
        end

    
    % 1. Prep
    curr = expT(expT.Order==cnt,:);
    
    back_idx = 1;
    
    obj_rot_vel_fr = curr.obj_vel / ptb.freq; % (deg/frame)
    obj_texture_vel_abs = curr.pat_vel * (abs(curr.obj_vel) * pi/180 * obj_ecc); % linear velocity (deg/s)
    obj_texture_vel_px_fr = deg2pix_rect(obj_texture_vel_abs) / ptb.freq; % (pixel/frame)
    
    if curr.obj_vel >= 0
        obj_texture_angle_rel_f = obj_texture_angle_rel;
    else
        obj_texture_angle_rel_f = 360 - obj_texture_angle_rel;
    end
    
    obj_texture_curr_idx = 1;
    obj_pos_curr_angle_standard = 0; % rotation angle (deg)
    
    rsp_intvl_curr = rsp_intvl_list(randi(length(rsp_intvl_list)));
    rsp_stim_on = 1;
    prevKeyCode = 0;
    
    % 2. Play
    for fr = 1:pre_obj_dur*ptb.freq
        
        % make texture
        back_make_texture = Screen('MakeTexture', ptb.w, back_textures{back_idx});
        
        
        % draw texture
        Screen('DrawTexture', ptb.w, back_make_texture, [], ptb.fullRect);
        Screen('DrawLines', ptb.w, fix_allCoords, fix_widthPix, crossCol, [ptb.xCenter ptb.yCenter]);
        if fr ==1
            
            Screen('DrawTexture', ptb.w, dioInd1, [], dioRect); % creating white area at fixation onset
        else
            
            Screen('DrawTexture', ptb.w, dioInd0, [], dioRect); % creating black area during fixation duration
        end
        if fr == 1
            b(1,cnt) = Screen('Flip', ptb.w);
        else
            Screen('Flip', ptb.w);
        end
        
        
        
        % key check
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown == 1
            if keyCode(key.q)
                NetStation('StopRecording');
                NetStation('Disconnect');
                sca; break;
            end
        end
        
        
        % update
        back_idx = back_idx+1;
        if back_idx > back_len, back_idx = 1; end
    end
    
    
    
    for fr = 1:obj_dur*ptb.freq
        
        % make texture
        obj_texture_end_idx = round(obj_texture_curr_idx)+size(obj_env,1)-1;
        obj_curr_texture = obj_texture(:,round(obj_texture_curr_idx):obj_texture_end_idx);

        obj_make_texture = Screen('MakeTexture', ptb.w, cat(3,obj_curr_texture, obj_env)); 
        back_make_texture = Screen('MakeTexture', ptb.w, back_textures{back_idx});
        Screen('BlendFunction', obj_make_texture, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
        
        
        
        
        % draw texture
        Screen('DrawTexture', ptb.w, back_make_texture, [], ptb.fullRect);
        
        

        for on = 1:obj_num
            obj_pos_curr_angle_this = obj_pos_curr_angle_standard + 360/obj_num*(on-1);
            obj_texture_angle_this = rem(90 - obj_pos_curr_angle_this + obj_texture_angle_rel_f - 90, 360);
            
            obj_pos_curr_center_this = [ptb.yCenter + sind(-1*obj_pos_curr_angle_this)*obj_ecc_px ...
                ptb.xCenter + cosd(-1*obj_pos_curr_angle_this)*obj_ecc_px];

            obj_destin_rect_curr_this = CenterRectOnPointd(obj_rect*4, ...
                obj_pos_curr_center_this(2), obj_pos_curr_center_this(1));

            Screen('DrawTexture', ptb.w, obj_make_texture, [], obj_destin_rect_curr_this, obj_texture_angle_this);
        end
        
        Screen('DrawLines', ptb.w, fix_allCoords, fix_widthPix, crossCol, [ptb.xCenter ptb.yCenter]);
        
        if fr ==1
            Screen('DrawTexture', ptb.w, dioInd1, [], dioRect); % creating white area at stimulus onset
        else
            
            Screen('DrawTexture', ptb.w, dioInd0, [], dioRect); % creating black area during stimulus duration
        
        end
        
        if fr == 1
            c(1,cnt) = Screen('Flip', ptb.w);
            
        else
            
            Screen('Flip', ptb.w);
        end
        
        
        % key check
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown == 1
            if keyCode(key.q)
                NetStation('StopRecording');
                NetStation('Disconnect');
                sca;
                break;
            end
        end
        
        
        % update
        back_idx = back_idx+1;
        if back_idx > back_len, back_idx = 1; end
        obj_pos_curr_angle_standard = rem(obj_pos_curr_angle_standard+obj_rot_vel_fr, 360);
        obj_texture_curr_idx = obj_texture_curr_idx + obj_texture_vel_px_fr;
    end
    

    Screen('DrawTexture', ptb.w, dioInd1, [], dioRect); % creating white area at response onset
    d(1,cnt) = Screen('Flip', ptb.w);
    % 3. Response
    time0 = GetSecs;
    while 1
        % prep
        if GetSecs-time0 > rsp_intvl_curr
            rsp_stim_on = 1;
            time0 = GetSecs;
        elseif GetSecs-time0 > rsp_stim_dur && rsp_intvl_curr ~= inf
            rsp_stim_on = 0;
        end
        
        % play
%         if rsp_stim_on
%             Screen('FillOval', ptb.w, [.4 .4 .4], obj_destin_rect_curr_this);
%         end
        if rsp_stim_on
            for on = 1:obj_num
                obj_pos_curr_angle_this = obj_pos_curr_angle_standard + 360/obj_num*(on-1);
                obj_texture_angle_this = rem(90 - obj_pos_curr_angle_this + obj_texture_angle_rel_f - 90, 360);

                obj_pos_curr_center_this = [ptb.yCenter + sind(-1*obj_pos_curr_angle_this)*obj_ecc_px ...
                    ptb.xCenter + cosd(-1*obj_pos_curr_angle_this)*obj_ecc_px];

                obj_destin_rect_curr_this = CenterRectOnPointd(obj_rect*4, ...
                    obj_pos_curr_center_this(2), obj_pos_curr_center_this(1));

                Screen('FillOval', ptb.w, [.4 .4 .4], obj_destin_rect_curr_this);
            end
        end
%         obj_pos_curr_angle_this = obj_pos_curr_angle_standard + 360/obj_num*(on-1);
% 
%         obj_pos_curr_center_this = [ptb.yCenter + sind(-1*obj_pos_curr_angle_this)*obj_ecc_px ...
%             ptb.xCenter + cosd(-1*obj_pos_curr_angle_this)*obj_ecc_px];
% 
%         obj_destin_rect_curr_this = CenterRectOnPointd(obj_rect*4, ...
%             obj_pos_curr_center_this(2), obj_pos_curr_center_this(1));


        % update
        back_idx = back_idx+1;
        if back_idx > back_len, back_idx = 1; end
        obj_pos_curr_angle_standard = rem(obj_pos_curr_angle_standard+obj_rot_vel_fr, 360);
        obj_texture_curr_idx = obj_texture_curr_idx + obj_texture_vel_px_fr;

        Screen('DrawLines', ptb.w, fix_allCoords, fix_widthPix, crossCol, [ptb.xCenter ptb.yCenter]);
        Screen('DrawTexture', ptb.w, dioInd0, [], dioRect); % creating black area during response duration
        
        Screen('Flip', ptb.w);
        
        
        % key check
        [~,~,KeyCode] = KbCheck(-1);
        if sum(prevKeyCode) == 0
        
            if sum(KeyCode) ~= 0
                if KeyCode(key.q)
                    NetStation('StopRecording');
                    NetStation('Disconnect'); break;
                elseif KeyCode(key.down)
                    rsp_intvl_idx = find(rsp_intvl_list==rsp_intvl_curr) + 1;
                    if rsp_intvl_idx > length(rsp_intvl_list), rsp_intvl_idx = 1;
                    elseif rsp_intvl_idx < 1, rsp_intvl_idx = length(rsp_intvl_list); end
                    rsp_intvl_curr = rsp_intvl_list(rsp_intvl_idx);
                    rsp_stim_on = 1;
                elseif KeyCode(key.up)
                    rsp_intvl_idx = find(rsp_intvl_list==rsp_intvl_curr) - 1;
                    if rsp_intvl_idx > length(rsp_intvl_list), rsp_intvl_idx = 1;
                    elseif rsp_intvl_idx < 1, rsp_intvl_idx = length(rsp_intvl_list); end
                    rsp_intvl_curr = rsp_intvl_list(rsp_intvl_idx);
                    rsp_stim_on = 1;
                    
                elseif KeyCode(key.space)
                    if rsp_intvl_curr == inf
                        expT.response(expT.Order==curr.Order) = 0;
                    else
                        expT.response(expT.Order==curr.Order) = rsp_intvl_curr;
                    end
                    break;
                end
                
                prevKeyCode = KeyCode;
            end
        else
            if sum(KeyCode) == 0, prevKeyCode = 0; end
        end
       
    end %while
    
    Screen('Close');
    if KeyCode(key.q)
        NetStation('StopRecording');
        NetStation('Disconnect');break;
    end
        

    if triggerNet == 1
        if expT{cnt,2} == -40
            clock_value = '00C';
        elseif expT{cnt,2} == 40
            clock_value = '0AC';
        else
            clock_value = '000';
        end
        NetStation('Event', sprintf('S%s',clock_value), a(1,cnt))  % Start sign
        NetStation('Event', sprintf('F%s',clock_value), b(1,cnt))  % Fixation onset
        
        if expT{cnt,3} == obj_texture_vel_rel(1,1)
            NetStation('Event', sprintf('Z%s',clock_value), c(1,cnt))  % Target onset - Zero jump
        elseif expT{cnt,3} == obj_texture_vel_rel(1,2)
            NetStation('Event', sprintf('L%s',clock_value), c(1,cnt)) % Target onset - Low jump
        else %expT{cnt,3} == obj_texture_vel_rel(1,3)
            NetStation('Event', sprintf('H%s',clock_value), c(1,cnt)) % Target onset - High jump
        end
        
        NetStation('Event', sprintf('R%s',clock_value), d(1,cnt))  % Response onset
    end
    
end
% Screen('AddFrameToMovie', ptb.w);
% Screen('FinalizeMovie', movie);



% 0 slow fast frequency section separation
% netstation name problem? & netstation time point?


% EGI disconnecting
if triggerNet
    NetStation('StopRecording');
	NetStation('Disconnect');
end


%% Finalize
sca;
clear back_textures;
save(t_filename, 'initials', 'date');
% save([code_version '_S' num2str(subject_number) '.mat'])
disp('data saved');

WaitSecs(1);
ListenChar;






% %% Functions
% function pix_size = deg2pix(deg_size)
% global ptb dis
% cm_size = 2*dis.scr2par*tand(deg_size/2);
% pix_size = cm_size*ptb.x/dis.scrSize(1);
% end
% 
% function pix_size = deg2pix_rect(deg_size)
% global rect dis
% cm_size = 2*dis.scr2par*tand(deg_size/2);
% pix_size = cm_size*rect.size(1)/dis.scrSize(1);
% end
