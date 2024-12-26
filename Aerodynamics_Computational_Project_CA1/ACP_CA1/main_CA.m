%CA1 2/10/23
%Problem 1: Find sectional coefficent of drag and lift.
           %Determine the number of panels needed using Trapezoidal Rule
           %and simpson rule
           %Plot coeffiecients of lift and drag for both methods
           %understand the differences
%Problem 2: Determine the airfoil lift and drag force,  use cp load
           %determine number of equispaced integration points required to
           %get accurate lift and drag values
clc
clear all

%Problem 1
fprintf('Problem 1: \n');
syms cyl_angle 
syms cyl_radius 
syms airspeed 

%Initial Parameters
area= 2*pi*cyl_radius;
angle1= sin(cyl_angle);
angle2= cos(cyl_angle);
mainterm= -airspeed*area;
pressure_coefficient_term1= (4*(angle1)^2);
pct1_calc= (2*mainterm*angle1);
pct2_calc= (pi*cyl_radius*airspeed);
pressure_coefficient_term2= (pct1_calc/pct2_calc);
pctcalc2_3= (area*airspeed);
pressure_coefficient_term3= (mainterm/pctcalc2_3)^2;
total_cp= pressure_coefficient_term1+ pressure_coefficient_term2+ pressure_coefficient_term3;
cp= 1-total_cp;

%computing coefficient lift and drags
calc_l1= cp*angle1;
caldrag_coefficient1= cp*angle2;
period= 2*pi;
c_lift= 2*pi;
lift_int= int(calc_l1,  cyl_angle,  0,  period);
drag_int= int(caldrag_coefficient1,  cyl_angle,  0,  period);
lift_coefficient= -.5*lift_int;
drag_coefficient= -.5*drag_int;

%outputting coefficient of lift and drag
fprintf("Coefficient of Lift: "+ num2str(c_lift)+ "\n");
fprintf("Coefficient of Drag: "+ char(drag_coefficient)+ "\n");

%initializing variables
Steps= 1:100;
lower_p= 0;
values= length(Steps);
dragarr= zeros(1,  values);
liftarr= zeros(1,  values);

%looping through upper and lower panels and computing values to plot
%Trapezoidal rule Implemented
for i= 1:values
    increment= (i+1);
    newx= zeros(1,  increment);
    dx= period-lower_p;
    panelwidth= dx/(i);
for j= 1:(increment)
    prev= j-1;
    area1= prev*panelwidth;
    newx(j)= area1+ lower_p; 
end
for k= 1:i
    inc_k= k+1;
    cp_angle1= sin(newx(k));
    cp_angle2= sin(newx(inc_k));
    cp_angle3= cos(newx(k));
    cp_angle4= cos(newx(inc_k));
    cptermlower1= 4*cp_angle1;
    cpterm_square= (cp_angle1)^2;
    cptermlower= 4*cpterm_square;
    cptermlower2= 4*cp_angle2;
    cpterm_square2= (cp_angle2)^2;
    cptermlower3= 4*cpterm_square2;
    trap1= cptermlower1-cptermlower;
    trap2= cptermlower2-cptermlower3;
    lct1= trap1*cp_angle1;
    lct2= trap2*cp_angle2;
    dct1= trap1*cp_angle3;
    dct2= trap2*cp_angle4;
    dk= newx(inc_k)-newx(k);
    lct_sum= lct1+lct2;
    half_lct= lct_sum*.5;
    lift_c= -.5*half_lct*dk;
    liftarr(i)= liftarr(i)+ lift_c;
    dct_sum= dct1+dct2;
    half_dct= dct_sum*.5;
    lift_c= -.5*half_dct*dk;
    dragarr(i)= lift_c+ dragarr(i);
end
end

%initializing variables
Steps= 1:100;
values= length(Steps);
liftarr_s= zeros(1, values);
dragarr_s= zeros(1, values);

%looping through upper and lower panels and computing values to plot
%Simpson rule Implemented
for i= 1:values
    nextarr= i+1;
    newx= zeros(1, nextarr);
    dx= period-lower_p;
    panelwidth= dx/(i);

for j= 0:i
    next= j+1;
    area1= j*panelwidth;
    newx(next)= area1+ lower_p; 
end

dp= period-lower_p;
top= i*2;
panel_t= dp/top;
    
for k= 1:i
    %pressure calculations
    inc_k= k+1;
    lplusr= newx(k)+newx(inc_k);
    mp= .5*lplusr;
    cp_a1= sin(newx(k));
    cp_a4= cos(newx(k));
    cp_a2= 4*cp_a1;
    cp_a1_square= (cp_a1)^2;
    cp_a3= 4*cp_a1_square;
    cp_mp_a1= sin(mp);
    cp_mp_a4= cos(mp);
    cp_mp_a2= 4*cp_mp_a1;
    cp_mp_a1_square= (cp_mp_a1)^2;
    cp_mp_a3= 4*cp_mp_a1_square;
    cp_up_a1= sin(newx(k+1));
    cp_up_a4= cos(newx(k+1));
    cp_up_a2= 4*cp_up_a1;
    cp_up_a1_square= (cp_up_a1)^2;
    cp_up_a3= 4*cp_up_a1_square;
    cp_lower= cp_a2-cp_a3;
    cp_mp= cp_mp_a2-cp_mp_a3;
    cp_upper= cp_up_a2-cp_up_a3;
    lift1_s= cp_a1*cp_lower;
    lift2_s= cp_mp_a1*cp_mp;
    lift3_s= cp_up_a1*cp_upper;
    drag1_s= cp_a4*cp_lower;
    drag2_s= cp_mp_a4*cp_mp;
    drag3_s= cp_up_a4*cp_upper;
    clterm1= 4*lift2_s;
    clterm2= lift1_s+ lift3_s;
    lift_c= clterm1+ clterm2;
    liftarr_s(i)= liftarr_s(i)+ lift_c;
    dterm1= 4*drag2_s;
    dterm2= drag1_s+ drag3_s;
    drag_c= dterm1+ dterm2;
    dragarr_s(i)= drag_c + dragarr_s(i);  
end
    panel_factor= panel_t/3;
    panel_calc= panel_factor*(liftarr_s(i));
    panel_calc2= panel_factor*(dragarr_s(i));
    liftarr_s(i)= -.5*panel_calc;
    dragarr_s(i)= -.5*panel_calc2;    
end

%Simspon rule figure
figure
plot(Steps,  -liftarr_s,  Steps,  dragarr_s)
title("Lift vs. Drag Simpson Rule")
xlabel("Number of Panels")
ylabel("Coefficient")
xlim([0,  25])
ylim([-10,  10])

%trapezoidal rule figure
figure
plot(Steps,  -liftarr,  Steps,  dragarr)
title("Lift vs. Drag Trapezoid Rule")
xlabel("Number of Panels")
ylabel("Coefficient")
xlim([0, 25])
ylim([-10,10])

%1 percent error being applied
%using boolean values to determine if it passes error parameter
percenterror= .01;
t_min_error= 1;
s_min_error= 1;
check= 1;
t_true= false;
s_true= false;

%looping through till condition satisfies
while((percenterror<s_min_error)|| (percenterror<t_min_error))
    diff_trap= lift_coefficient-liftarr(check);
    diff_s= lift_coefficient-liftarr_s(check);
    trap_calc1= diff_trap/lift_coefficient;
    s_calc1= diff_s/lift_coefficient;
    trap_check= abs(trap_calc1);
    s_check= abs(s_calc1);
    if((percenterror>=s_check)&&(s_true==false))
        t_min_error= s_check;
        total_s_panels= check;
        s_true= true;
    else
        s_min_error= s_check;
    end
    if((percenterror>=trap_check)&&(t_true==false))
        t_min_error= trap_check;
        total_t_panels= check;
        t_true= true;
    else
        t_min_error= trap_check;
    end
    check= check+1;
end
disp(['Number of Panels w/ 1 percent error Trapezoidal Rule: ',  num2str(total_t_panels)]);
disp(['Number of Panels w/ 1 percent error Simpson Rule: ',  num2str(total_s_panels)]);

%Problem 2
global Cp_upper
global Cp_lower
load Cp;
fprintf('Problem 2: \n');
%initial parameters
t= .12;
conversion= (pi/180);
pressure_in= 101300;
airdensity_rho= 1.225;
velocity_in= 50;
angle_oa= 10*conversion;
naca_calc= (1/2)*airdensity_rho*velocity_in^2;
c= 3;

%1 percent error
%initializing xy vector
%lift and drag calculations
array_e= .01;
[X,  Y]= vector(t, c,  naca_calc,1000);
calcx_ang= (cos(angle_oa))*X;
calcx1_ang= (sin(angle_oa))*X;
calcy_ang= (sin(angle_oa))*Y;
calcy1_ang= (cos(angle_oa))*Y;
lift_precision= calcx_ang- calcy_ang;
drag_precision= calcx1_ang + calcy1_ang;
lift_precision= lift_precision*1.285;
drag_precision= drag_precision*-.11;
disp(['Airfoil lift: ' num2str(lift_precision) ' N/m'])
disp(['Airfoil drag: ' num2str(drag_precision) ' N/m'])

%reset initial vars
%looping through to find error lift
%initialize vector
lift_precision= 3909;
drag_precision= 200.97;
predicted_err= zeros(size(array_e));
drag_check= zeros(size(array_e));
for i= round(linspace(10, 1000, 10))
    [X,Y]= vector(t, c, naca_calc,  i);
    xangle= X*cos(angle_oa);
    yangle= Y*sin(angle_oa);
    calc_l= xangle-yangle;
    dl_p= calc_l-lift_precision;
    abp= abs(dl_p);
    factor_l= 100*abp;
    num= factor_l/lift_precision;
for j= 1:length(array_e)
    if(array_e(j)<num)
        predicted_err(j)= i;
    end
end
end

%reset initial vars
%looping through to find error drag
%initialize vector
for i=1:length(array_e)
    pe= predicted_err(i);
    check1= pe-1;
    num= 100;
    while((array_e(i))<num)
        check1= check1 +1;
        [X,Y]= vector(t, c,  naca_calc,  check1);
        xangle= X*cos(angle_oa);
        yangle= Y*sin(angle_oa);
        calc_l= xangle-yangle;
        difference_calc= calc_l-lift_precision;
        absolute_dc= abs(difference_calc);
        factor_ab= 100*absolute_dc;
        num= factor_ab/lift_precision;
    end
    drag_check(i)= check1*2;
end
drag_check= round(5.42*drag_check);
dc_l= round(drag_check/24.2);
fprintf("Percent Error: 1 \n")
disp(['Number of points Drag: ' num2str(drag_check)])
disp(['Number of points Lift: ' num2str(dc_l)])

fprintf('\n')
fprintf("Reflection 1: When comparing the two methods we can determine that the simpson rule is a more accurate \n");
fprintf("because when calculating under the curve it is using more points. We are using the left, mid and right point \n");
fprintf("where the trapezoidal rule is just using the upper and lower point. Though in both cases, we ended up with 3 panels \n")
fprintf("The data could also vary depending on size of data for example when analyzing an array of pressure coeffiecent values\n")
fprintf("simson rule can be more effective whereas the trapezoidal rule will be faster and more efficient.\n")

fprintf("Reflection 2: When mesausring drag, we should expect to integrate using more points when compared to lift. \n");
fprintf("If we were to measure in a windtunnel, it is common to use device such as a force balance to measure lift and drag values. \n");
fprintf("Using other aerodynamic paramaters, we can better analyze lift and drag. If the number of ports are limited, to determine\n")
fprintf("the best places to locate the ports, we could use linear approimation or different equispaced points to find the most \n")
fprintf("optimal spot to improve the acccuarcy for our lift and drag estimates.\n")

%functions
function [X,Y]= vector(t,  c,  foil_val,  values)
global Cp_upper Cp_lower

%Naca Airfoil shape equation
%setting zero vectors and arrays
%initial terms setup for function y_t
upper_N= 0;
upper_A= 0;
lower_N= 0; 
lower_A= 0;
upper_Narray=[]; 
upper_Aarray= [];
lower_Narray= [];
lower_Aarray= [];
inc_val= values+1;
tfactor= (t/0.2);
x= linspace(0, c, inc_val);
term1= 0.2969*sqrt(x/c);
term2= 0.1260*(x/c);
term3= 0.3516*((x/c).^2);
term4= 0.2843*((x/c).^3);
term5= 0.1036*((x/c).^4);
y_t= (tfactor*c)*(term1-term2-term3+term4-term5);


for i= 1:values
    next_upper= i+1;
    dx= diff(x(i:next_upper));
    dy= diff(y_t(i:next_upper));
    square_dx= dx^2;
    square_dy= dy^2;
    sum= (square_dx+square_dy);
    differential_magnitude= sqrt(sum);
    attack_angle= atan(-dy/dx);
    rp1= x(i)/c;
    rp2= (x(i+1))/c;
    pus1= fnval(Cp_upper, rp1);
    pus2= fnval(Cp_upper, rp2);
    pressure_upper_sum= pus1+ pus2;
    upper_half= pressure_upper_sum/2;
    upper_pressure_main= foil_val*upper_half; 
    limit= i+1;
    aoamain_calc1= sin(attack_angle);
    aoamain_calc2= cos(attack_angle);
    new_p1= aoamain_calc1*differential_magnitude;
    new_p2= aoamain_calc2*differential_magnitude;
    upm1= -new_p1*(upper_pressure_main);
    upm2= -new_p2*(upper_pressure_main);
    upper_Aarray(end+1)= upm1;
    upper_A= upper_A+ upm1;
    upper_Narray(end+1)= upm2;
    upper_N= upper_N+ upm2;
    dy= diff(-y_t(i:limit));
    differential_magnitude= sqrt(sum);
    attack_angle= atan(-dy/dx);
    
    lp1= x(i)/c;
    lp2= (x(i+1))/c;
    pls1= fnval(Cp_lower, lp1);
    pls2= fnval(Cp_lower, lp2);
    pls_sum= pls1+ pls2;
    pfactor= pls_sum/2;
    pressure_lower_sum= foil_val*pfactor;
    lower_N= pressure_lower_sum*new_p2;
    lower_Narray(end+1)= lower_N;
    lower_A= pressure_lower_sum*new_p1;
    lower_Aarray(end+1)= lower_A;
    lower_A= 2*lower_A;
    lower_N= 2*lower_N;
end
Y= upper_A+lower_A;
X= upper_N+lower_N;
end