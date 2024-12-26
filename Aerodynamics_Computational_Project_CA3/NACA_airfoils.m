%NACA airfoils are the airfoil shapes of the wings in respect in thickness
%chord length, pressure, mean camber line etc. This function will aid in
%plotting the various different airfoils. Relatively thin airfoils,
%Moderate thickness airfoils, Relatively thickn airfoils ranging from NACA
%0006, 0012, 0024, 2412, 4412. This will aid in calculating estimate the 
%sectional lift slope and zero-lift angle of attack
function [chord_x,chord_y]= NACA_airfoils(m_val,p_val,thickness,chord,nterm)
%initial setup
%thickness/ camber airfoil parameters
nval= nterm/2;
new_i= floor(nval);
nt= 2*new_i;
nterm= nt+1;
thickness= thickness*.01;
m_val= m_val*.01;
p_val= p_val*.1;
new_p_calc= eps*(p_val==0);
p_val= new_p_calc+ p_val;
factor1= 2*pi;

%angle calculations
angle= linspace(0, factor1, nterm)';
trig_angle= cos(angle);
newangle_sum= trig_angle+1;
nas= newangle_sum/2;
chord_x= nas*chord;
chord_y= chord_x*0;
chord_val= p_val*chord;
check1= [chord_x>=chord_val];
check2= [chord_x<=chord_val];

%thickness calculations
tsec_val= thickness/0.2;
nacaterm1= chord*tsec_val;
c_val_1= chord_x/chord;
calc_c_val= sqrt(c_val_1);
nacaterm2= 0.297*calc_c_val;
nacaterm3= .126*c_val_1;
calc_c_val2= c_val_1.^2;
calc_c_val3= c_val_1.^3;
calc_c_val4= c_val_1.^4;
nacaterm4= .3515*calc_c_val2;
nacaterm5= .284*calc_c_val3;
nacaterm6= .1036*calc_c_val4;

%sum of all NACA terms
naca_main= nacaterm1*nacaterm2-nacaterm3-nacaterm4+nacaterm5-nacaterm6;
mp_square= m_val/p_val^2;
x_value= chord_x(check2);
calc_ychord= 2*p_val;
calc_ychord1= chord_x(check2)/chord;
ychord_term= calc_ychord -calc_ychord1;
ychord_main= x_value.* ychord_term;
mp_square2= m_val/(1-p_val)^2;
ychord_term1= chord-chord_x(check1);
termcheck= chord_x(check1)/chord;
p_val_calc1= 2*p_val;
ychord_calc= termcheck-p_val_calc1;
y_chord_calc= ychord_calc+ 1;

%chord calculations
ep_val1= 2*m_val/p_val;
ep_val2= chord_x(check2)/(chord_val);
epterm1= 1-ep_val2;
change_p= 1-p_val;
ep_val_term1= m_val/change_p^2;
epcheck1_term= ep_val_term1*2;
ept= chord_x(check1)/chord;
ept2= p_val-ept;

chord_y(check2,1)= mp_square*ychord_main;
chord_y(check1,1)= mp_square2 *ychord_term1.*y_chord_calc;

e_val(check2,1)= epterm1*ep_val1;
e_val(check1,1)= epcheck1_term*ept2;

val_eps= atan(e_val);

naca_angle_s= sin(val_eps);
naca_angle_c= cos(val_eps);
naca_total= naca_main.*naca_angle_s;
naca_total2= naca_main.*naca_angle_c;

%upper/lower chord caluclations
uppper_xval= chord_x-naca_total;
lower_xval= chord_x-naca_total;
upper_yval= chord_y+naca_total2;
lower_yval= chord_y-naca_total2;

%chord values
chord_y(1:new_i,1)= lower_yval(1:new_i);
chord_y(new_i+1:end,1)= upper_yval(new_i+1:end);
chord_x(1:new_i,1)= lower_xval(1:new_i);
chord_x(new_i+1:end,1)= uppper_xval(new_i+1:end);

end