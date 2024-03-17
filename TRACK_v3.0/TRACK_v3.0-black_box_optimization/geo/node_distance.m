function  distance=node_distance(node1,node2,ND)
node_coord1=ND(node1,2:4);
node_coord2=ND(node2,2:4);
vector=node_coord2-node_coord1;
distance=norm(vector);
end
