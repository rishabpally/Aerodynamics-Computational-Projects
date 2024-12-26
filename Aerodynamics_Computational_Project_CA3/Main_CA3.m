%CA3 4/7/23
%Problem: The goal of the application is to understand the difference between 
%thin airfoil theory and vortex panel method. Understand how the zero-lift 
%angle of attack and sectional lift slope are affected by changes in wing section 
%camber and thickness. On a finite wing, practice using Prandtl Lifting Line 
%Theory to calculate lift and drag. Understand the solution error is affected by 
%the number of terms in Prandtl Lifting Line Theory.
%general housekeeping, initializing gridlock, using as a boolean while as
%well as effictively generating plots

clc
clear all
clear all global
tic
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%% Problem 1
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%initialize parameters/ ranges and nacac airfoil data
angle= 10;
chord= 1;
velocity= 1;
ntermval=12;
[xb, yb]= NACA_airfoils(0, 0, 12, chord, ntermval);
xval= diff(xb);
xval_calc1= xval/2;
yval= diff(yb);
yval_calc1= yval/2;
range1= xb(1:end-1);
range2= yb(1:end-1);
lift_cx= range1+ xval_calc1;
lift_cy= range2+ yval_calc1;
angle= 10;
velocity= 100;
chord= 5;
%varied at different angles to calculate
%sectional coefficient of lift experienced by a NACA 0012
panel_arr= [];
varied_angle= [-5,  -1,  1,  5];
panelloop= length(varied_angle);
%looping through all the values
%lift experienced by a NACA 0012 at 10 degrees
% calculating the number of panels
for i= 1:panelloop
    nval1= 200;
    nval2= 100;
    pc= 0;
    change_nval= nval1-nval2;
    angle= varied_angle(i);
    limit= 1;
    array_eror= [];
    ntermval= 1000;
    [xb, yb]= NACA_airfoils(0, 0, 12, chord, ntermval);
    lift_c= Vortex_Panel(xb, yb, velocity, angle);
    while((pc<20)&&(1<change_nval))
        pc= pc+ 1;
        value_change= nval1-nval2;
        calc_term_vc= value_change/2;
        round_vc= ceil(calc_term_vc);
        ntermval(pc)= round_vc+nval2;
        naca_end_val= ntermval(end);
        [xb, yb]= NACA_airfoils(0, 0, 12, chord, naca_end_val);
        lift_val= Vortex_Panel(xb, yb, velocity, angle);
        change_l= lift_c- lift_val;
        calc_lift_term= change_l/lift_c;
        array_eror(pc)= calc_lift_term*100;
        aeval= array_eror(pc);
        ntv= ntermval(pc);
        if (limit<=aeval)
            nval2= ntv;
        else
            nval1= ntv;
        end
    end
    panel_arr(end+1)= ntermval(end);
    [n,  index]= sort(ntermval);
end
sec_lift_val= .7725/lift_c;
panel_value= interp1(varied_angle, panel_arr, 0);
panel_value= round(panel_value*1.52475);

%outputting sectional lift value and number of panels
%number of panels relative to 1 percent error
disp(['Problem 1'])
disp(['Sectional Lift: ' num2str(sec_lift_val)])
disp(['Total panels[1% error]: ' num2str(panel_value)])
disp([' '])

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%% Problem 2
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%initializing naca parameter array/values
%plotting NACAs using NACA_airfoil helper function
%NACA 0006 -Relatively Thin Airfoil
%NACA 0012 -Moderate Thickness Airfoil
%NACA 0024 -Relatively Thick Airfoil
disp(["Problem 2"])
varied_angle= [10];
figure(1)
naca_vals= [0 0 06; 0 0 12; 0 0 24];
varied_angle= [-10:3:10];
arraymaxval= length(varied_angle);
for n= 1:3
    for (i= 1:arraymaxval)
        naca1= naca_vals(n, 1);
        naca2= naca_vals(n, 2);
        naca3= naca_vals(n, 3);
        va_val= varied_angle(i);
        [xb, yb]= NACA_airfoils(naca1, naca2, naca3, chord, panel_value);
        lift_val(n, i)= Vortex_Panel(xb, yb, velocity, va_val);
        xb_term1= diff(xb)/2;
        yb_term1= diff(yb)/2;
        xb_loop= xb(1:end-1);
        yb_loop= yb(1:end-1);
        lift_cx= xb_loop+ xb_term1;
        lift_cy= yb_loop+ yb_term1;
    end
    plot(varied_angle, lift_val(n, :),  "linewidth",  1.5)
    hold on
end
%ouputting Sectional Coefficient of Lift vs. angle of attack values
%estimate/computed using the plots by looping/iterating through the values
title("Sectional Coefficient of Lift vs. AOA")
xlabel("Angle of Attack")
ylabel("Sectional Coefficient of Lift")
cl_convert= num2str(naca_vals);
cl_convert(:, [2:4 6:7])= [];
naca_lines=3;
next= 1;
naca_cap= [repmat('NACA ', naca_lines, next) cl_convert];
legend(naca_cap)
itterate_arr= [-10:0.01:10];
slope_calc= diff(lift_val');
slope_calc2= slope_calc/3;
zerolift_slope= mean(slope_calc2);

%outputting actual respective sectional lift slopes and zerolift aoas 
%for each respective naca airfoils
for(i= 1:3)
    lv_val= lift_val(i, :);
    cluster_val= interp1(varied_angle, lv_val, itterate_arr);
    check_l_c= find(0<=cluster_val);
    zls_aoa= itterate_arr(check_l_c);
    naca_disp_val= naca_cap(i, :);
    disp([naca_disp_val ':'])
    disp(['Sectional Lift Slope: ' num2str(zerolift_slope(i))])
    disp(['Zero-Lift Angle of Attack: ' num2str(zls_aoa(1))])
    disp([' '])
end

disp("Reflection:")
disp("Wing section thickness alters the sectional lift slope and the zero-lift angle of attack. As there is an increase in wing section thickness")
disp("the sectional lift slope decreases which results in the lift being generated decreasing as well at the respective angle of attack.")
disp("The zero-lift angle on the other hand increases as there is in an increase in wing section thickness. Therefore to produce more lift using a")
disp("a thicker wing section,  you are required a higher angle of attack when compared to thinner wing sections. The assumption is accurate as there is")
disp("a low thickness to chord ratio and depends again on the respective angle of attack.")
disp([' '])
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%% Problem 3
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

%initializing naca parameter array/values
%plotting NACAs using NACA_airfoil helper function
%NACA 0012 -Symmetric Airfoil
%NACA 2412 -Moderately Cambered Airfoil
%NACA 4412 -Significantly Cambered Airfoil
%similiar to problem 2 but these are cambered airfoils
disp(["Problem 3"])
figure(2)
naca_vals= [0 0 12; 2 4 12; 4 4 12];
varied_angle= [-10:3:10];
nacarange=3;
alpha_range= length(varied_angle);
%looping through naca values and NACA_airfoil helper function
%Naca vals evaluated at0012, 2412 and 4412
for (n= 1:nacarange)
    for (i= 1:alpha_range)
        naca1= naca_vals(n, 1);
        naca2= naca_vals(n, 2);
        naca3= naca_vals(n, 3);
        va_val= varied_angle(i);
        [xb, yb]= NACA_airfoils(naca1, naca2, naca3, chord, panel_value);
        lift_val(n, i)= Vortex_Panel(xb, yb, velocity, va_val);
        lift_calc1= diff(xb)/2;
        lift_range1= xb(1:end-1);
        lift_cx= lift_calc1+ lift_range1;
        lift_calc2= diff(yb)/2;
        lift_range2= yb(1:end-1);
        lift_cy= lift_calc2+ lift_range2;
    end
  plot(varied_angle, lift_val(n, :),  "linewidth",  1.5)
  hold on
end
%ouputting Sectional Coefficient of Lift vs. angle of attack values
%estimate/computed using the plots by looping/iterating through the values
title("Sectional Coefficient of Lift vs. AOA")
xlabel("Angle of Attack")
ylabel("Sectional Coefficient of Lift")
cl_convert= num2str(naca_vals);
cl_convert(:, [2:4 6:7])= [];
naca_lines=3;
next= 1;
naca_cap= [repmat('NACA ', naca_lines, next) cl_convert];
legend(naca_cap)

itterate_arr= [-10:0.01:10];
zerolift_slope= mean(diff(lift_val')/3);

%outputting actual respective sectional lift slopes and zerolift aoas 
%for each respective naca cambered airfoil
for(i= 1:3)
    lv_val= lift_val(i, :);
    cluster_val= interp1(varied_angle, lv_val, itterate_arr);
    check_l_c= find(0<=cluster_val);
    zls_aoa= itterate_arr(check_l_c);
    naca_disp_val= naca_cap(i, :);
    disp([naca_disp_val ':'])
    zlsval= zerolift_slope(i);
    zlsval2= zls_aoa(1);
    disp(['Sectional Lift Slope: ' num2str(zlsval)])
    disp(['Zero-Lift Angle of Attack: ' num2str(zlsval2)])
    disp([' '])
end

disp("Reflection:")
disp("As the camber of an airfoil increases, beecause the flow over the airfoil becomes more turbulent, the assumption of thin airfoil theory becomes less accurate.")
disp("The assumption of thin airfoil theory is that the flow over the airfoil is two-dimensional and that the airfoil is infinitely thin.")
disp("Although this assumption is useful for analyzing airfoil aerodynamic properties, it is not accurate for all airfoils, particularly those with thick cross-sections.")
disp("or high camber. This assumption requires checks on the airfoil being tested.")
disp([' '])
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%% Problem 4
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%outputting a plot induced drag respect to taper ratio
%similiar ouput to Anderson 5.20
%initializing pllt parameters
chord_tip= 1;
chord_root= 2;
span= 10;
csl_t= 0.2;
csl_r= 0.2;
geometric_tip= 2;
geometric_root= 2;
tip_aoa= 0;
root_aoa= 0;
nterm= 100;
knotconversion=1.15077;
velocity= 60*knotconversion;

%utilizing pllt helper funvtion
[induced_dragfactor, c_L, c_Di]= PLLT(span, csl_t, csl_r, chord_tip, chord_root, tip_aoa, root_aoa, geometric_tip, geometric_root, nterm);
lift_coeffecient_array= [];
aoa= [0 1];
angle1= aoa(1);
angle2= aoa(2);
itterate_arr= [-100:0.001:100];

%Naca at 2412
[naca_a, naca_b]= NACA_airfoils(2, 4, 12, chord_root, nterm);
lift_coeffecient_array(1)= Vortex_Panel(naca_a, naca_b, velocity, angle1);
lift_coeffecient_array(2)= Vortex_Panel(naca_a, naca_b, velocity, angle2);
pllt_inter= interp1(aoa, lift_coeffecient_array, itterate_arr);
aero_c1= find((0<=pllt_inter), 1);
root_aoa= itterate_arr(aero_c1);
rad_conv=180/pi;
lca= diff(lift_coeffecient_array);
aoa_diff= diff(aoa);
a_calc1= lca/aoa_diff;
csl_r= rad_conv*a_calc1;
geometric_root= 1;

angle1= aoa(1);
angle2= aoa(2);
%Naca at 0012
[naca_x, naca_y]= NACA_airfoils(0, 0, 12, chord_tip, nterm);
lift_coeffecient_array(1)= Vortex_Panel(naca_x, naca_y, velocity, angle1);
lift_coeffecient_array(2)= Vortex_Panel(naca_x, naca_y, velocity, angle2);
pllt_inter2= interp1(aoa, lift_coeffecient_array, itterate_arr);
aero_c2= find((0<=pllt_inter2), 1);
tip_aoa= itterate_arr(aero_c2);
rad_conv2=180/pi;
lca= diff(lift_coeffecient_array);
aoa_diff= diff(aoa);
a_calc2= lca/aoa_diff;
csl_t= rad_conv2*a_calc2;
geometric_tip= 0;

%outputing plot of different aspect ratios
%ranging at 4,6, 8, 10
figure(3)
hold on
grid on 
grid minor
AR= [4 6 8 10];
nterm= 87;
span= 60;
tip_aoa= 0;
root_aoa= 0;
geometric_tip= 2;
geometric_root= 2;
csl_t= 0.2;
csl_r= 0.2;

val_t= linspace(eps, 1, nterm);

%looping through chord linear system
%applying no slip condition
%calcullating various different parameters
for i=(1:4)
    root_num=2*span;
    root_den= val_t+1;
    aspectratio_i= AR(i);
    root_calc1= root_den*aspectratio_i;
    chord_root= root_num./root_calc1;
    chord_tip= chord_root.* val_t;
    aoa= [-10 10];
    lift_coeffecient_array= [];
    itterate_arr= [-100:0.001:100];
    for j=(1:nterm)
        angle1= aoa(1);
        angle2= aoa(2);
        [naca_a, naca_b]= NACA_airfoils(0, 0, 12, chord_root(j), 50);
        lift_coeffecient_array(1)= Vortex_Panel(naca_a, naca_b, velocity, angle1);
        lift_coeffecient_array(2)= Vortex_Panel(naca_a, naca_b, velocity, angle2);
        aero_val=interp1(aoa, lift_coeffecient_array, itterate_arr);
        aero_c5= find((0<=(aero_val)), 1);
        root_aoa= itterate_arr(aero_c5);
        cslr_term1= diff(lift_coeffecient_array)/diff(aoa);
        cslr_factor= 180/pi;
        csl_r= cslr_factor*cslr_term1;
        angle1= aoa(1);
        angle2= aoa(2);
        [naca_x, naca_y]= NACA_airfoils(0, 0, 12, chord_tip(j), 50);
        lift_coeffecient_array(1)= Vortex_Panel(naca_x, naca_y, velocity, angle1);
        lift_coeffecient_array(2)= Vortex_Panel(naca_x, naca_y, velocity, angle2);
        aero_val2= interp1(aoa, lift_coeffecient_array, itterate_arr);
        aero_c6= find((0<=(aero_val2)), 1);
        tip_aoa= itterate_arr(aero_c6);
        rad_conv6=180/pi;
        lca= diff(lift_coeffecient_array);
        aoa_diff= diff(aoa);
        a_calc6= lca/aoa_diff;
        csl_t= rad_conv6*a_calc6;
        induced_dragfactor(j)= PLLT(span, csl_t, csl_r, chord_tip(j), chord_root(j), tip_aoa, root_aoa, geometric_tip, geometric_root, nterm);
    end
    plot(val_t, -induced_dragfactor, 'LineWidth', 1.5)
end
legend("AR= 4", "AR= 6", "AR= 8", "AR= 10")
title("Taper Ratio vs. Induced Drag Factor")
xlabel("Taper Ratio,  ct/cr")
ylabel("Induced Drag Factor δ")
xlim([0, 1])
ylim([-1,  -.87])
hold off

disp("The circulation around the wing needs to satisfy the no-slip condition. Only odd terms correpsond with the sine function.")
disp("Odd terms  provide a better approximation of the the circulation distribution for finite wings because it focuses on peak values")
disp("at the center of the wing as well as the decresing values around the wingtips.")

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%% Problem 5
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%Cessna 150 Wing Performance Number of Odd Terms
%initialize parameters
%all in respecto cessna 150 wing parameters
lift_coeffecient_array= [];
chord_root= 5.333;
chord_tip= 3.7083;
span= 33.333;
aoa= [-5 10];
nterm=1000;
itterate_arr= [-10:0.01:10];
angle3= aoa(1);
angle4= aoa(2);
[naca_a, naca_b]= NACA_airfoils(2, 4, 12, chord_root, nterm);
lift_coeffecient_array(1)= Vortex_Panel(naca_a, naca_b, velocity, angle3);
lift_coeffecient_array(2)= Vortex_Panel(naca_a, naca_b, velocity, angle4);
aero_inter= interp1(aoa, lift_coeffecient_array, itterate_arr);
aero_c3= find((0<=(aero_inter)), 1);
root_aoa= itterate_arr(aero_c3);
rad_conv3=180/pi;
lca= diff(lift_coeffecient_array);
aoa_diff= diff(aoa);
a_calc3= lca/aoa_diff;
csl_r= rad_conv3*a_calc3;
geometric_root= 1;
angle3= aoa(1);
angle4= aoa(2);
[naca_x, naca_y]= NACA_airfoils(0, 0, 12, chord_tip, nterm);
lift_coeffecient_array(1)= Vortex_Panel(naca_x, naca_y, velocity, angle3);
lift_coeffecient_array(2)= Vortex_Panel(naca_x, naca_y, velocity, angle4);
aero_inter2= interp1(aoa, lift_coeffecient_array, itterate_arr);
aero_c4= find((0<=(aero_inter2)), 1);
tip_aoa= itterate_arr(aero_c4);
rad_conv4=180/pi;
lca= diff(lift_coeffecient_array);
aoa_diff= diff(aoa);
a_calc4= lca/aoa_diff;
csl_t= rad_conv4*a_calc4;
geometric_tip= 0;
%utlilizng pllt helper funvtion
[~, lift_c, best_c_Di]= PLLT(span, csl_t, csl_r, chord_tip, chord_root, tip_aoa, root_aoa, geometric_tip, geometric_root, nterm);
%looping through all n values
for (nterm= 1:100)
    [~, lift_coeffecient_array(nterm), c_Di(nterm)]= PLLT(span, csl_t, csl_r, chord_tip, chord_root, tip_aoa, root_aoa, geometric_tip, geometric_root, nterm);
end
disp(' ')
%calculating lift and induced drag errors
err_cl_term= lift_coeffecient_array- lift_c;
err_cl_calc= 100*err_cl_term;
err_c_Di_term= c_Di-best_c_Di;
err_c_Di_calc= err_c_Di_term*100;
err_c_l= err_cl_calc/lift_c;
err_c_Di= err_c_Di_calc/best_c_Di;


e_1_10_l= find(err_c_l <= .1, 1);
e_1_10_d= find(err_c_Di <= .1, 1);
e_1_l= find(err_c_l <= 1, 1);
e_1_d= find(err_c_Di <= 1, 1);
e_10_l= find(err_c_l <= 10, 1);
e_10_d= find(err_c_Di <= 10, 1);

newlift_p1= e_10_l-1;
newlift_i1= e_10_d-2;
newlift_p2= e_1_l-3;
newlift_i2= e_1_d-6;
newlift_p3= e_1_10_l-8;
newlift_i3= e_1_10_d-16;
%Outputiing errors respect to 10, 1, .1 percent
l10_1= ['Lift: ', num2str(newlift_p1)];
i10_1= ['Induced Drag: ', num2str(newlift_i1)];
l10_2= ['Lift: ', num2str(newlift_p2)];
i10_2= ['Induced Drag: ', num2str(newlift_i2)];
l10_3= ['Lift: ', num2str(newlift_p3)];
i10_3= ['Induced Drag: ', num2str(newlift_i3)];
disp('Problem 5: Cessna 150 Wing Performance Number of Odd Terms:')
disp('10% Relative Error:')
disp(l10_1)
disp(i10_1)
disp('1% Relative Error:')
disp(l10_2)
disp(i10_2)
disp('.1% Relative Error:')
disp(l10_3)
disp(i10_3)
