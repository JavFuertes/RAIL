function [dis_out,vel_out,acc_out,index,nodeRef]=time_history(nodeNumber, activeDof, dis, vel, acc,  dofID)
if nargin < 6
    dofID=1;
end
if nargin < 3
    dis=-1;
    vel=-1;
    acc=-1;
end

dof=2*(nodeNumber-1)+dofID;
[index,loc]=ismember(activeDof,dof);
loc1=loc(loc(:,1)~=0,1); %exclude those inactive DOF
nodeRef=zeros(length(loc1),1);
for i=1:length(loc1)
    nodeRef(i,1)=(dof(loc1(i))-dofID)/2+1; %calculate correspong nodes according to active DOF
end

if dis ~=-1
    dis_out=dis(:,index);
    vel_out=vel(:,index);
    acc_out=acc(:,index);
else
    dis_out=0;
    vel_out=0;
    acc_out=0;
end

end
