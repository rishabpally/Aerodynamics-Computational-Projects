%CA2 3/2/23
%Problem: Varying parameters such as chord length, velocity, angle of
%attack, to visualize the equipotential lines, stream lines, and pressure
%contours of the flows around a symmetric airfoil. The goal is to generate multiple
%differnt plots. To start off we will be generating the stream lines for 4
%different values of aoa, velocity and chord length. Then we will be
%ouputting the equipotential lines 4 different values of aoa, velocity and
%chord length. Then we will generate a plot for both the pressure and
%velocity respective to the number of vortices. Lastly we will be
%generating plots for stream function, velocity and pressure contour lines.
%general housekeeping, initializing gridlock, using as a boolean while as
%well as effictively generating plots
clc
clear all
clear all global
tic
global gridlock
gridlock= true;

%given initial parameters
vortices= 100;
chord_length= 5;
angle= 15;
air_rho= 1.225;
aoa= deg2rad(angle);
velocity= 34;
pressure= 101.3*10^3;

%figure 1 and figure 2/ Streamlines/ Equipotential Lines
f(1)= figure;
f(2)= figure;

%we are varying cord lengths, 4 different values ranging from 4-6 m.
%using the meshed points, we are able to determine the streamlines and
%equipotentil lines. we are using 2 forloops so we can alternate between
%streamlines and equipotential lines as we subplot them.
cords= [4,  4.75,  5.5,  6.25];
for (i= (1:4))
    chord_length= cords(i);
    airfoil_val= Plot_Airfoil_Flow(chord_length, aoa, velocity, pressure, air_rho, vortices);
    av_min= min(airfoil_val.sf);
    av_max= max(airfoil_val.sf);
    av_sl_min= min(av_min);
    av_sl_max= max(av_max);
    sl_vec= linspace(av_sl_min, av_sl_max, 20)';
    
    vp_min= min(airfoil_val.vp);
    vp_max= max(airfoil_val.vp);
    av_sl_min= min(vp_min);
    av_sl_max= max(vp_max);
    sl_vec= linspace(av_sl_min, av_sl_max, 20)';
    
    c1= airfoil_val.xc;
    c2= airfoil_val.yc;
    c3= airfoil_val.sf;
    c4= sl_vec;
    c5= airfoil_val.vp;
    avx= airfoil_val.x;
    avy= airfoil_val.y;
%looping for both plots, contour using stream function levels as well as
%velocity potential levels. then the airfoil is plotted
for (j= 1:2)
    figure(f(j));
    subplot(3, 4, i)
    if (j==1)
      contour(c1, c2, c3, c4, "LineWidth", 2)
    else
      contour(c1, c2, c5, c4, "LineWidth", 2)
    end
    hold on
    plot(avx, avy, 'r', "LineWidth", 3)
    if (i== 3)
        if (j== 1)
            title({upper("Stream lines (Chord Length Parameter)"), " ",['c= ' num2str(chord_length) '[m]']})
        else
            title({upper("Equipotential lines (Chord Length Parameter)"), " ",['c= ' num2str(chord_length) '[m]']})
        end
    else
        title(['c= ' num2str(chord_length) '[m]'])
    end
    xlabel("X [m]")
    ylabel("Y [m]")
    pbar1= get(gca,  "xlim");
    pbar2= get(gca,  "ylim");
    set(gca,  "PlotBoxAspectRatio",  [diff(pbar1) diff(pbar2) 1])
    hold off
    drawnow
  end

end
%reset value to initial paramater for new plots
chord_length= 5;

%we are varying velocity, 4 different values ranging from 5-80 m/s.
%using the meshed points, we are able to determine the streamlines and
%equipotentil lines. we are using 2 forloops so we can alternate between
%streamlines and equipotential lines as we subplot them.
v_vec= [5,  20,  40,  80];
for (i= 1:4)
    velocity= v_vec(i);
    airfoil_val= Plot_Airfoil_Flow(chord_length, aoa, velocity, pressure, air_rho, vortices);
    av_min= min(airfoil_val.sf);
    av_max= max(airfoil_val.sf);
    av_sl_min= min(av_min);
    av_sl_max= max(av_max);
    sl_vec= linspace(av_sl_min, av_sl_max, 20)';
    vp_min= min(airfoil_val.vp);
    vp_max= max(airfoil_val.vp);
    av_sl_min= min(vp_min);
    av_sl_max= max(vp_max);
    sl_vec= linspace(av_sl_min, av_sl_max, 20)';
    
    c1= airfoil_val.xc;
    c2= airfoil_val.yc;
    c3= airfoil_val.sf;
    c4= sl_vec;
    c5= airfoil_val.vp;
    avx= airfoil_val.x;
    avy= airfoil_val.y;
%looping for both plots, contour using stream function levels as well as
%velocity potential levels. then the airfoil is plotted
%we use glimit so we can make 3x4 subplot for both stream lines and
%equipotential lines
  for (j= 1:2)
      figure(f(j))
      g_limit= 4+i;
      subplot(3, 4, g_limit)
      if (j==1)
          contour(c1, c2, c3, c4, "LineWidth", 2)
      else
          contour(c1, c2, c5, c4, "LineWidth", 2)
      end
      hold on
      plot(avx, avy, 'r', "LineWidth", 3)
      if (i== 3)
          if (j== 1)
              title({upper("Stream lines (Velocity Parameter)"), " ", ['V= ' num2str(velocity)] '[m/s]'})
          else
              title({upper("Equipotential lines (Velocity Parameter)"), " ", ['V= ' num2str(velocity)] '[m/s]'})
          end
      else
          title(['V= ' num2str(velocity) '[m/s]'])
      end
      xlabel("X [m]")
      ylabel("Y [m]")
      pbar1= get(gca,  "xlim");
      pbar2= get(gca,  "ylim");
      set(gca,  "PlotBoxAspectRatio",  [diff(pbar1) diff(pbar2) 1])
      hold off
      drawnow
  end
end
%reset value to initial paramater for new plots
velocity= 34;

gridlock= false;

%we are varying angle of attack, 4 different values ranging from -10-20 degrees.
%using the meshed points, we are able to determine the streamlines and
%equipotentil lines. we are using 2 forloops so we can alternate between
%streamlines and equipotential lines as we subplot them.
aoa_parameter= [-10, 8,  14,  20];
for (i= 1:4)
    range= aoa_parameter(i);
    aoa= deg2rad(range);
    airfoil_val= Plot_Airfoil_Flow(chord_length,  aoa,  velocity,  pressure,  air_rho,  vortices);
    av_min= min(airfoil_val.sf);
    av_sl_min= min(av_min);
    av_max= max(airfoil_val.sf);
    av_sl_max= max(av_max);
    sl_vec= linspace(av_sl_min, av_sl_max, 20)';
    vp_min= min(airfoil_val.vp);
    vp_max= max(airfoil_val.vp);
    av_sl_min= min(vp_min);
    av_sl_max= max(vp_max);
    sl_vec= linspace(av_sl_min, av_sl_max, 20)';
    c1= airfoil_val.xc;
    c2= airfoil_val.yc;
    c3= airfoil_val.sf;
    c4= sl_vec;
    c5= airfoil_val.vp;
    avx= airfoil_val.x;
    avy= airfoil_val.y;
 for (j= 1:2)
     figure(f(j))
     g_limit2= 8+i;
     subplot(3, 4, g_limit2)
     if j==1
         contour(c1, c2, c3, c4, "LineWidth", 2)
     else
         contour(c1, c2, c5, c4, "LineWidth", 2)
     end
hold on
plot(avx, avy, 'r', "LineWidth", 3)
    if (i==3)
        if (j==1)
            title({upper("Stream lines (AOA Parameter)"), " ",  ['aoa= ' num2str(range)] '[degrees]'})
        else
            title({upper("Equipotential lines (AOA Parameter)"), " ", ['aoa= ' num2str(range)] '[degrees]'})
        end
    else
        title(['aoa= ' num2str(range) '[degrees]'])
    end
xlabel("X [m]")
ylabel("Y [m]")
    pbar1= get(gca,  "xlim");
    pbar2= get(gca,  "ylim");
    set(gca,  "PlotBoxAspectRatio",  [diff(pbar1) diff(pbar2) 1])
    hold off
    drawnow
end
end
%reset value to initial paramater for new plots
newangle=15;
aoa= deg2rad(newangle);
airfoil_val= Plot_Airfoil_Flow(chord_length, aoa, velocity, pressure, air_rho, vortices);
av_min= min(airfoil_val.sf);
av_max= max(airfoil_val.sf);
av_sl_min= min(av_min);
av_sl_max= max(av_max);
sl_vec= linspace(av_sl_min, av_sl_max, 50)';
vp_min= min(airfoil_val.vp);
vp_max= max(airfoil_val.vp);
av_sl_min= min(vp_min);
av_sl_max= max(vp_max);
sl_vec= linspace(av_sl_min, av_sl_max, 100)';
vpressure_min= min(airfoil_val.pressure);
vpressure_max= max(airfoil_val.pressure);
av_sl_min= min(vpressure_min);
av_sl_max= max(vpressure_max);
term1_p= (100-logspace(-3, 2, 60));
term_p_factor= term1_p/100;
delta_av= av_sl_max-av_sl_min;
term2_p= term_p_factor*delta_av;
total_p= term2_p+av_sl_min;
c1= airfoil_val.xc;
c2= airfoil_val.yc;
c3= airfoil_val.sf;
c4= sl_vec;
c5= airfoil_val.vp;
c6= airfoil_val.pressure;
avx= airfoil_val.x;
avy= airfoil_val.y;

%Pressure Contour Lines Figure/plots
figure
contourf(c1, c2, c6, total_p)
hold on
colorbar
title("Pressure Contour Lines [pa]");
xlabel("X [m]")
ylabel("Y [m]")
xlim([0, 5])
ylim([-1.75, .5])
set(gca,  "PlotBoxAspectRatio",  [diff(pbar1) diff(pbar2) 1])
plot(airfoil_val.x, airfoil_val.y, 'k', "LineWidth", 2)
hold off
toc

%Stream Function Contour Lines Figure/plots
figure
subplot(2, 1, 1)
contour(c1, c2, c3, c4,  "LineWidth", 2)
hold on
plot(avx, avy, 'r', "LineWidth", 2)
title("Stream Function Contour Lines");
xlabel("X [m]")
ylabel("Y [m]")
xlim([0, 5])
ylim([-1.75, .5])
hold off
drawnow

%Velocity Contour Lines Figure/plots
subplot(2, 1, 2)
contour(c1, c2, c5, c4, "LineWidth", 2)
hold on
title("Velocity Potential Contour Lines");
xlabel("X [m]")
ylabel("Y [m]")
xlim([0, 5])
ylim([-1.75, .5])
plot(avx, avy, 'k', "LineWidth", 2)
hold off
drawnow

vortices= 10000;
airfoil_val= Plot_Airfoil_Flow(chord_length, aoa, velocity, pressure, air_rho, vortices);
logval= logspace(0, 4, 10);
roundval= round(logval);
err_range= flip(roundval);

%error Figure/plots
figure
subplot(1, 2, 2)
range(2)= semilogx((1*10^4),  0);
title("Error in pressure over N-Vortices");
xlabel("N (number of Vortices)")
ylabel("Error [pa]")
xlim([1,  (1*10^5)])
ylim([0,  500])
subplot(1, 2, 1)
range(1)= semilogx((1*10^4),  0);
title("Error in Velocity over N-Vortices");
xlabel("N (number of Vortices)")
ylabel("Error [m/s]")
xlim([1, (1*10^5)])
ylim([0,  10])
drawnow

V_err= 0;
P_err= 0;
endr= length(err_range);

%looping through, calculating error for velocity and pressure
%by setting a range/ number of vortices we can see how the error decreases
%as the number of vortices increases(converges to 0) for both velocity and pressure
for (i= 2:endr)
    vortices= err_range(i);
    errorData= Plot_Airfoil_Flow(chord_length, aoa, velocity, pressure, air_rho, vortices);
    change_v_err1= errorData.Velocity-airfoil_val.Velocity;
    absolute_calc1= abs(change_v_err1);
    err_term1= mean(absolute_calc1);
    V_err(end+1)= mean(err_term1);   
    change_p_err= errorData.pressure-airfoil_val.pressure;
    absolute_calc2= abs(change_p_err);
    err_term2= mean(absolute_calc2);
    P_err(end+1)= mean(err_term2);
    err_range1= length(V_err);
    err_range2= length(P_err);
    r1= range(1);
    r2= range(2);
    newrange1= err_range(1:err_range1);
    newrange2= err_range(1:err_range2);
    set(r1,  "xdata",  newrange1,  "ydata",  V_err);
    set(r2,  "xdata", newrange2,  "ydata",  P_err);
    drawnow
end

%Evaluate the pressure contours, and identify the locations of minimum and
%maximum pressure. How do these change as the above conditions are altered? Consider
%the streamlines and equipotential lines; are the fields continuous? What does this imply?
fprintf("Reflection: When looking at the plots, the streamlines and equipotential lines stay consistent respctively as the angle \n");
fprintf("of attack, chord length, and velocity increase. When looking at the pressure contour lines, you can determine that \n");
fprintf("that presure is low at the top of the body while the pressure is high on the bottom. The air splits at the front and for the most\n")
fprintf("part and the stream lines/ equipotential lines are continous. We should also note that there are stagnation points and it varies \n")
fprintf("with different angle of attacks. The optimal spot is where the angle of attack is not too high so that the air hitting the body \n")
fprintf("does not create too much drag. A shorter chord length along with a angle of attack between 8-14 degrees would be optimal.")