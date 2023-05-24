function pix_size = deg2pix(deg_size)
global ptb dis
cm_size = 2*dis.scr2par*tand(deg_size/2);
pix_size = cm_size*ptb.x/dis.scrSize(1);
end