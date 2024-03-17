function w=genexpwin(length,force)
w=expwin(length*2,10);
w=w(length+1:end,1);
end
