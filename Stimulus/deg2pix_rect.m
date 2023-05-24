function pix_size = deg2pix_rect(deg_size)
global rect dis
cm_size = 2*dis.scr2par*tand(deg_size/2);
pix_size = cm_size*rect.size(1)/dis.scrSize(1);
end