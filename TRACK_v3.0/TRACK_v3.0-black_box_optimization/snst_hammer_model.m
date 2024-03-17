function varargout = snst_hammer_model(randInp,inp,geo,N,setnumC1,setnumC2)
parfor nsim = 1:N
    inpOne = inp;
    for npara = 1:8
        nmat = setnumC1(npara);
        ndata = setnumC2(npara);
        if nmat < 3
        inpOne.mater(nmat).Data(ndata)= randInp(nsim,npara)./inpOne.mater(nmat).Data(ndata+1);
    else
        inpOne.mater(nmat).Data(ndata)= randInp(nsim,npara);
        end
    end
    inpOne.mater(1).Data(5)=inpOne.mater(1).Data(1)/(2*(1+0.3));
    inpOne.mater(2).Data(5)=inpOne.mater(2).Data(1)/(2*(1+0.17));
    
    mat_trk = form_mat_trk_2(inpOne,geo);
    
%     if nsim ==1
%     [H1,fxx] = hammer_main_snst_mcs(inpOne,mat_trk,geo);
%     else
         [H1] = hammer_main_snst_mcs(inpOne,mat_trk,geo);
%     end
    
    S(:,nsim)=H1;
    %S(npara).dis=[dis_out,dis.w];
    %S(npara).vel=[vel_out,vel.w];
    %S(npara).acc=[acc_out,acc.w];

    disp (['Simulation No. ',num2str(nsim),' finished. Time: ' datestr(now)]);
    
end
% mat_trk = form_mat_trk_2(inp,geo);
% [~,fxx] = hammer_main_snst_mcs(inp,mat_trk,geo);
w = genexpwin(inp.solver.n_ts);
sf = inp.ext_force.sf;
[~,~,~,~,~,fxx] =tran_fun([ones(inp.solver.n_ts,1),ones(inp.solver.n_ts,1)],w,0,25600,sf);
featMag(:,1)=abs(S(1,:)');
featMag(:,2)=sum(abs(S(fxx>150 & fxx< 900,:)))';
featMag(:,3)=sum(abs(S(fxx>1000 & fxx< 2500,:)))';
varargout{2} = S;
varargout{1} = featMag;
varargout{3} = fxx;
end