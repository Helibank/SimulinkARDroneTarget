% This script defines a project shortcut. 
%
% To get a handle to the current project use the following function:
%
% project = simulinkproject();
%
% You can use the fields of project to get information about the currently 
% loaded project. 
%
% See: help simulinkproject

%% Check if the compiler has been registered

if exist('AR_Drone_Target/registry/thirdpartytools/thirdpartytools_win32.xml','file') == 0 || ...
        exist('AR_Drone_Target/registry/thirdpartytools/thirdpartytools_win64.xml','file') == 0
    disp('No third party compiler has been registered for the AR Drone, running install script')
   run('AR_Drone_Target/install_script.m') 
end

%% Check if TargetRegistry has been set
if exist('AR_Drone_Target/registry/gcc_codesourcery_arm_linux_gnueabihf_gmake_win64_v4_8.mat','file') == 0
    disp('No toolchain info mat file was found for use with rtwTargetInfo.m, generating the gcc_codesourcery_arm_linux_gnueabihf_gmake_win64 mat file')
    run('AR_Drone_Target\registry\generateTargetInfoMatFile.m');  % create the mat file containing the toolchain info
    RTW.TargetRegistry.getInstance('reset');         % reset the TargetRegistry such that rtwTargetInfo.m is called when a model is made for the first time
end    

%% Compile the video library if needed

if exist('AR_Drone_Target/blocks/videolib/ARdrone_video_lib.slx','file') == 0
    disp('No video library has been found, starting compilation of the video library using the Legacy Code Tool')
   run('AR_Drone_Target/blocks/videolib/Generate_AR_Drone_Video.m')
end

%% update paths 

addpath([pwd '\registry']); % folder is generated post download
addpath([pwd '\Docs']); % include the documentation


%% register the compiler
sl_refresh_customizations;

%% Initialise the config

run('AR_Drone_Models\Flight_Models\AR_DRONE_SCRIPT.m')