%ASEN 3111 CA2 3/2/23
%similiar to the Lifting_Cylinder.m function we will be using this function
%to aid with plotting respective to the airfoil while setting initial
%parameters. Overall this will be a more effective and efficient way to
%generate the plots when analyzing the different parameters such as aoa/v/c

%initialzing the function airfoil_val with our aerodynamic parameters
%using gridlock we will be able to set the initial plot parameters as well
%as efficently mesh points. This will be useful when ploting the
%streamlines, equipotential lines, contour lines etc. as well as with
%generating plots.

function airfoil_val= Plot_Airfoil_Flow(c, aoa, velocity, pressure, air_rho, vortices)
global gridlock
r= @(dist_X, dist_Y, newx, newy) sqrt(((dist_X -newx).^2)+ ((dist_Y- newy).^2));
%radius and lift airfoil vec/linspace initilization (votices/locations) 
nval= vortices+1;
n2= vortices*2;
calc_c= c/n2;
lift_vec= linspace(0, c, nval);
lift_end= lift_vec(2:end);
lift_vec= lift_end-calc_c;
aoa_calc1= cos(aoa);
aoa_calc2= -sin(aoa);
dist_X= lift_vec*aoa_calc1;
dist_Y= lift_vec*aoa_calc2;

%gridlock check/ defining grid points change in x over change in y
if gridlock
    min_x_val= -2;
    min_y_val= -4;
    max_x_val= 8;
    max_y_val= 2;
    vortice_X= 200;
    vortice_Y= 200;
else
%vortices/chord calculations
    nval2= vortices+1;
    vector_lift= linspace(0, c, nval2);
    angle_oax= vector_lift*aoa_calc1;
    angle_oay= vector_lift*aoa_calc2;
    chord_factor= c/10;
    vortice_X= 200;
    var1x= min(angle_oax);
    var2x= max(angle_oax);
    var1y= min(angle_oay);
    var2y= max(angle_oay);
    min_x_val= var1x- chord_factor;
    max_x_val= var2x+ chord_factor;
    min_y_val= var1y- chord_factor;
    max_y_val= var2y+ chord_factor;
    delta_x= max_x_val-min_x_val;
    delta_y= max_y_val-min_y_val;
    dx_dy= delta_x/delta_y;
    vortice_Y= round(vortice_X/dx_dy);
end

%pressure vortex functions, sum of functions, uniform/vortex flows
%form of superposition in respect to velocity
g_psi= 0;
g_phi= 0;
xvec1= linspace(min_x_val,max_x_val,vortice_X);
yvec1= linspace(min_y_val,max_y_val,vortice_Y);
[x_pt, y_pt]= meshgrid(xvec1,yvec1);
lift_calc1= lift_vec/c;
lift_calc2= 1-lift_calc1;
lift_square= sqrt(lift_calc2./lift_calc1);
lv= lift_square* velocity;
lift_aoa= lv* aoa;
calc_cv= c/vortices;
calc_g= lift_aoa*2;
gamma_val= calc_cv*calc_g;
initial_p_x= velocity*x_pt;
initial_p_y= velocity*y_pt;

for (i= 1:vortices)
    pi_calc= 2*pi;
    gpsi_calc= gamma_val(i)/pi_calc;
    gphi_calc= gamma_val(i)/pi_calc;
    glog= log(r(x_pt, y_pt, dist_X(i), dist_Y(i)));
    gtan_calc= atan2(x_pt - dist_X(i), y_pt - dist_Y(i));
    psi_calc= glog*gpsi_calc;
    phi_calc= gtan_calc*gphi_calc;
    g_psi= psi_calc+ g_psi;
    g_phi= phi_calc+ g_phi;
end

%total pressure calculations Bernoulli's
sl_total= g_psi+ initial_p_y;
vpl_total= g_phi+ initial_p_x;
pointx= x_pt(1,:);
pointy= y_pt(:,1);
[dv, du]= gradient(sl_total, pointx, pointy);
dv= -dv;
square1= (du.^2);
square2= (dv.^2);
sum_uv= square1 +square2;
velocity_mag= sqrt(sum_uv);
v2=velocity^2;
v2_mag= (velocity_mag.^2);
v_change= v2- v2_mag;
term2= .5*(air_rho)*v_change;
total_p= pressure+ term2;

%setting final data points/values
%x y meshed points, magnitude of velocity, total presure, stream and
%velocity potential lines
airfoil_val.pressure= total_p;
airfoil_val.x= dist_X;
airfoil_val.y= dist_Y;
airfoil_val.sf= sl_total;
airfoil_val.vp= vpl_total;
airfoil_val.xc= x_pt;
airfoil_val.yc= y_pt;
airfoil_val.Velocity= velocity_mag;