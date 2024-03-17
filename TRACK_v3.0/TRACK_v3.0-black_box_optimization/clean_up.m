function seq_out=clean_up(seq,tol)
diff=seq(2:end)-seq(1:end-1);
ind=diff<tol;
ind=[0; ind];
seq_out=seq(~ind);
end