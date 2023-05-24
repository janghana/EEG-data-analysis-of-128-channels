%% Epoch trials
clear all; clc;

% Make sure there is an EEGLAB (with neccessary plug-ins toolboxes) in the path.


% load cleaned raw dataset
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename','jge_20220712_postFilt_NaN.set','filepath','/Users/jongrok/Desktop/brxEGIpreprocessTool/raw/jge_20220712/preproc/');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = eeg_checkset( EEG );

% epoch each condition for its duration (ì§?ê¸??? ssvepë¥? ë³´ë?¤ê? ???? 0ì´?ë¶??? 8ì´?ê¹?ì§? ?°ì?´í?? ë½?ê³?
% ??????ì²? ??ê·?ê°??¼ë? ë²??´ì?¤ë?¼ì?? ì¡°ì??)

% H00C c001
EEG = pop_epoch( EEG, {  'H00C'  }, [0  8], 'newname', 'hi_c', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [],[]);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 
EEG = eeg_checkset( EEG );

c001 = EEG.data;
RejTrl = find(isnan(squeeze(c001(72,10,:))))';
c001(:,:,RejTrl)=[];

% H0AC c002
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'retrieve',1,'study',0);
EEG = eeg_checkset( EEG );
EEG = pop_epoch( EEG, {  'H0AC'  }, [0  8], 'newname', 'hi_ac', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [],[]);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'gui','off'); 

c002 = EEG.data;
RejTrl = find(isnan(squeeze(c002(72,10,:))))';
c002(:,:,RejTrl)=[];

% L00C c003
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 5,'retrieve',1,'study',0); 
EEG = eeg_checkset( EEG );
EEG = pop_epoch( EEG, {  'L00C'  }, [0  8], 'newname', 'lo_c', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [],[]);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 6,'gui','off'); 

c003 = EEG.data;
RejTrl = find(isnan(squeeze(c003(72,10,:))))';
c003(:,:,RejTrl)=[];

% L0AC c004
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 7,'retrieve',1,'study',0); 
EEG = eeg_checkset( EEG );
EEG = pop_epoch( EEG, {  'L0AC'  }, [0  8], 'newname', 'lo_ac', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [],[]);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 8,'gui','off'); 

c004 = EEG.data;
RejTrl = find(isnan(squeeze(c004(72,10,:))))';
c004(:,:,RejTrl)=[];

% Z00C c005
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 9,'retrieve',1,'study',0); 
EEG = eeg_checkset( EEG );
EEG = pop_epoch( EEG, {  'Z00C'  }, [0  8], 'newname', 'z_c', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [],[]);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 10,'gui','off'); 

c005 = EEG.data;
RejTrl = find(isnan(squeeze(c005(72,10,:))))';
c005(:,:,RejTrl)=[];

% Z0AC c006
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 11,'retrieve',1,'study',0); 
EEG = eeg_checkset( EEG );
EEG = pop_epoch( EEG, {  'Z0AC'  }, [0  8], 'newname', 'z_ac', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [],[]);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 12,'gui','off'); 

c006 = EEG.data;
RejTrl = find(isnan(squeeze(c006(72,10,:))))';
c006(:,:,RejTrl)=[];

cd('/Users/jongrok/Desktop/brxEGIpreprocessTool/raw/jge_20220712/preproc')

save c001.mat c001 
save c002.mat c002
save c003.mat c003
save c004.mat c004
save c005.mat c005
save c006.mat c006