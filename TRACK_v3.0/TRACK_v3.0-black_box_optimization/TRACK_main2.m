%
% clear
% clc
% format short;
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Main program for TRACK model
% % Author: Luca Sabbatini and Chen Shen
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test track
if exist('mat_trk','var')
    return
end



disp('Forming track model...\n ');
prompt='Please select the track parameters(1.Custom;2.Squat;3.Hammer;4.Benchmark): [1]\n';

inputFile = input(prompt,'s');
flag=0;
if isempty(inputFile)
    inputFile='4';
end

switch inputFile
    case '1' %strcmp('1',inputFile) == 1
        prompt='You choose the custom track parameters, please make sure correct values are defined in get_input. Continue? Y/N [Y]: ';
        j=input(prompt,'s');
        if isempty(j)
            j='Y';
        end
        if j=='Y'
            inp=get_input_1();
%             mat_trk=form_mat_trk_2(inp,geo);
%             clear flag i j prompt kclear
%             return
        else
            disp('Stopping the program...');
            flag=1;
            return
        end
        
    case '2' %strcmp('2',inputFile) == 1
        inp=get_input_2();
    case '3' %strcmp('3',inputFile) == 1
        inp=get_input_3();
    case '4' %strcmp('4',inputFile) == 1
        inp=get_input_4();
    otherwise
        inp = feval(inputFile); 
end

btypr=inp.mesh.btypr;
btyps=inp.mesh.btyps;

if exist('nodeCoord','var')==0
    
    prompt='Do you wish to creat nodes based on input file? Continue? Y/N [Y]: ';
    j=input(prompt,'s');
    if isempty(j)
        j='Y';
    end
    if j=='Y'
        prompt='Mesh full track or half track(1.full track; 2. half track: [1]\n';
        i=input(prompt);
        if isempty(i)
            i=1;
        end
        switch i
            case 1
                [nodeCoord]=node_coor(inp);
            case 2
                [nodeCoord]=node_coor(inp,1);
                
        end
        prompt='Do you wish to modify node coordinates? Y/N [N]:';
        k=input(prompt,'s');
        if isempty(k)
            k='N';
        end
        switch k
            case 'Y'
                disp('Model not meshed due to user request. Please modify the node coordinates. ')
                clear flag i j prompt k
                return
            case 'N'
        [geo] = mesh_trk_full(btypr,btyps,nodeCoord);
        mat_trk=form_mat_trk_2(inp,geo);
        end
    else
        disp('Nodes not created. Please define nodes manually.\n');
        clear flag i j prompt k
        return
    end
else
    disp('Geometry file already exists. Starting mesh...')
    [geo] = mesh_trk_full(btypr,btypr,nodeCoord);
    mat_trk=form_mat_trk_2(inp,geo);
end
mat_ws=form_mat_ws(inp);





%%
%PLOT MODEL BASED ON GEO
% plot_geo(geo)
% %plot element
% 
% 
% xlim([25,35])
%%
% mat_trk=form_mat_trk_2(inp,geo);
% [dis, vel,acc, t]=solver_newmark(inp,mat);
% figure;
% plot(dis(:,299));
clear flag i j prompt k btypr btyps