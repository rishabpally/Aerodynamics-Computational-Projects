%CA4 4/28/23
%Problem 1: Recreate theta_beta_M diagram, Chart 2 in NACA Technical Report 1135 
%Problem 2: Using a helper function and shock-expansion theory to solve
%for the sectional lift and wave-drag coefficients for a diamond-wedge
%airfoil
%Problem3: Generate 2 plots, one plot of the sectional lift coefficient
%with respect to angle of attack and varying mach values and the other plot
%of the sectional wave-drag coefficient with respect to angle of attack and varying mach values
clc
clear;
close all;

%===================================================================================
% Problem 1

%initial parameters problem2
aoa= 10;
ep1= 7.5;
ep2= 5;

%initial paramerts ranging angles/ mach values
%setting gamma
solution = ["Weak", "Strong"];
angle_range = 0:0.01:60;
mach_vector_val = [1:0.1:1.8, 1.2:0.2:4, 2:0.4:4, 4.2, 4.8, 6.4, 8, 9.6, 11.2];
air_stp= 1.4;
mv_size= length(mach_vector_val);
solution_size= length(solution);
angle_range_size= length(angle_range);
wedge_val= zeros(solution_size, angle_range_size, mv_size);

%looping through oblique shock beta function
%iterates the mach, angle values and outputs osb wave
for (i= 1:solution_size)
    for (j= 1:mv_size)
        for (k= 1:angle_range_size)
            mv_val= mach_vector_val(j);
            ar_val= angle_range(k);
            s_val= solution(i);
            check_osb= ObliqueShockBeta(mv_val, ar_val, air_stp, s_val);
            if isreal(check_osb)
                mv_val= mach_vector_val(j);
                ar_val= angle_range(k);
                s_val= solution(i);
                check_osb2= ObliqueShockBeta(mv_val, ar_val, air_stp, s_val);
                wedge_val(j,k,i)= check_osb2;
            end
        end
    end
end

mv_size2= length(mach_vector_val);
for (j= 1:mv_size2)
    sol_val1= wedge_val(j,:,1);
    sol_val2= wedge_val(j,:,2);
    sv1_size= length(sol_val1);
    for (i= 1:sv1_size)
        check_sv1= sol_val1(i);
        if (check_sv1==0)
            sv1_i= i;
            break
        else
            sv_size_1= length(sol_val1);
            sv1_i= sv_size_1;
        end
    end
    sv2_size= length(sol_val2);
for (i= 1:sv2_size)
    check_sv2= sol_val2(i);
    if (check_sv2==0)
        sv2_i= i;
        break
    else
        sv_size_2= length(sol_val2);
        sv2_i= sv_size_2;
    end
end

sol_val1(sv1_i:end)= NaN;
sol_val2(sv2_i:end)= NaN;

%plotting Oblique Shock wave NACA Report 1135 Chart
%replication Figure 9.9 in 
figure(1)
hold on
grid on
title("Oblique Shock wave NACA Report 1135 Chart")
xlabel("Deflection Angle θ, Unit [°]")
ylabel("Shock Wave Angle β, Unit [°]")
plot(angle_range,sol_val1,'Color','k')
plot(angle_range,sol_val2,':','Color','k')
legend("Weak Shock Wave", "Strong Shock Wave")
xlim([0 32])
ylim([0 100])
end
%===================================================================================

% Problem 2
%inital parameters
%using diamond airfoil function
mach_vector_val= 3;
aoa= 5;
ep1= 10;
ep2= 5;
%calculating lift coefficient and wave drag values using helper function
[lift_coefficeint,wave_drag]= DiamondAirfoil(mach_vector_val, aoa, ep1, ep2);

lc_val= lift_coefficeint*2;
wd= wave_drag*2;

%outputting sectional lift coefficient and wave frag values
fprintf("Problem 2:")
fprintf('\n')
fprintf("Sectional Lift Coefficient = %0.2f", lc_val);
fprintf('\n')
fprintf("Sectional Wave Drag Coefficient =%0.2f", wd);

fprintf("Reflection")
fprintf('\n')
fprintf("The lift and drag coefficients of a wing are dependent on the angles of its leading and trailing edges.\n")
fprintf("While lower trailing edge half-angles reduce drag, bigger leading edge half-angles increase lift. \n")
fprintf("Symmetric angles result in predictable values, whereas asymmetric angles can cause roll and yaw asymmetry which is not being accounted for.\n")
%===================================================================================

% Problem 3
%Plotting 2 different plots

%initial parameters
%ranging mach values and angle of attack
mach3_vec = [2,3,4,5];
aoa3 = 0:0.1:8;
mach3_vec_size= length(mach3_vec);
lift_coefficient3= zeros(1,mach3_vec_size);
wave_drag_3= zeros(1, mach3_vec_size);

%Linear and shock expansion parameter ranges
%trailing and leading edge calculations
linear_aoa3= deg2rad(0:0.1:8);
mach3_size= length(mach3_vec);
linear_lift_coefficient= zeros(1,mach3_size);
linear_wave_drag= zeros(1,mach3_size); 
ep2_val= tand(ep2); 
ep1_val= tand(ep1);
linear_ep1= cotd(ep1);
linear_ep2= ep2_val^2;
linear_calc1= linear_ep1*ep2_val;
linear_calc2= 1-linear_calc1;
linear_calc3= linear_calc2*linear_ep2;
linear_ep_calc= ep1_val*ep2_val;
linear2_calc= linear_ep1*ep2_val;
linear_num= linear_calc3+linear_ep_calc;
linear_num2= linear2_calc+1;
linear_main= linear_num/linear_num2;
main_linear_val= linear_main;


%loops and itteraties through mach values to get shock expansion
%linear coefficent of lift and drag values in respect to varyinh aoa 
%mach values
mach3_size= length(mach3_vec);
aoa_size= length(aoa3);
for (i= 1:mach3_size)
    for (k= 1:aoa_size)
        m3_val= mach3_vec(i);
        aoa3main= aoa3(k);
        [lift_coefficient3(k), wave_drag_3(k)]= DiamondAirfoil(m3_val, aoa3main, ep1, ep2);
        l_aoa3= linear_aoa3(k);
        m3_main= mach3_vec(i);
        m3_square= (m3_main)^2;
        m3_calc= m3_square-1;
        m3_main_calc= sqrt(m3_calc);
        laoa_calc1= l_aoa3*4;
        wavedrag_calc1= 2/m3_main_calc;
        l_aoa3_square= (l_aoa3)^2;
        wavedrag_calc2= l_aoa3_square*2;
        wavedrag_main= linear_main+main_linear_val+wavedrag_calc2;
        linear_lift_coefficient(k)= laoa_calc1/m3_main_calc;
        linear_wave_drag(k)= wavedrag_calc1*wavedrag_main;
    end

    figure(2)
    title("Coefficent of Lift vs. aoa/mach values")
    xlabel("Angle of Attack")
    ylabel("Lift Coeffcient")
    hold on
    grid on
    plot(aoa3, lift_coefficient3)
    plot(aoa3, linear_lift_coefficient, "--")
    xlim([0 8])
    ylim([0 .4])
    hold off

    figure(3)
    title("Sectional Wave Drag vs. aoa/mach values")
    xlabel("Angle of Attack")
    ylabel("Wave Drag Coeffcient")
    hold on
    grid on
    plot(aoa3, wave_drag_3)
    plot(aoa3, linear_wave_drag, "--")
    xlim([0 8])
    ylim([0 .095])
    hold off
end

figure(2)
legend("Mach[2]- SE", "Mach[2]- Linear", "Mach[3]- SE", "Mach[3]- Linear", "Mach[4]- SE", "Mach[4]- Linear", "Mach[5]- SE", "Mach[5]- Linear", "Location", "west")
figure(3)
legend("Mach[2]- SE", "Mach[2]- Linear", "Mach[3]- SE", "Mach[3]- Linear", "Mach[4]- SE", "Mach[4]- Linear", "Mach[5]- SE" , "Mach[5]- Linear", "Location", "west")

fprintf("Problem 3:")
fprintf('\n')
fprintf("Reflection:")
fprintf("When predicting lift and drag for diamond-wedge airfoils, shock-expansion and linearized compressible flow theories are slightly different \n")
fprintf("Thin airfoil theory only applies to flow that cannot be compressed. Changes in Mach number significantly influence lift and wave-drag. \n")
fprintf("with lift expanding up to the basic Mach number, after which it lowers because of shock waves.")