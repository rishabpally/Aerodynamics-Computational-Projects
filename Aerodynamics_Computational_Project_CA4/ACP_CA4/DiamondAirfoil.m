function [lift_coefficient, wave_drag]= DiamondAirfoil(mach, aoa, ep1, ep2)
%this fuction makes using shock expansion theory efficienylu by taking
%account for given mach, angle of attack, trailing edge, and leading edge
%angles. using built in flowisentropic, flownormalshock, flowprandtlmeyer
%tools, we can efficiently calculate different regions
%initial diamond airfoil region parameters
mach1= mach;
osw_regiona= ep1- aoa;
osw_regionc= ep1+ aoa;
pmef_regionb= ep1+ep2;
pmef_regiond= ep1+ep2;

air_stp= 1.4;
solution = 'Weak';
wedge_angle = ObliqueShockBeta(mach1,osw_regiona,air_stp,solution);

%Ranging pressure ratio from 2-1 accounting for region 2
machcalc1= sind(wedge_angle);
mach_val1= machcalc1*mach1;

[~,~,pressure_ratio_21,~,mach_val2,~,~]= flownormalshock(air_stp,mach_val1);

mchange_angle= wedge_angle- osw_regiona;
machcalc2= sind(mchange_angle);
mach2 = mach_val2/machcalc2;


%Ranging pressure ratio from 3-2 accounting for region 3
[~,v_ratio13,~] = flowprandtlmeyer(air_stp, mach2);
v_ratio23 = pmef_regionb+ v_ratio13;
[mach3,~,~] = flowprandtlmeyer(air_stp,v_ratio23,"nu");
[~,~,pressure_ratio_03,~,~] = flowisentropic(air_stp,mach3);
[~,~,pressure_ratio_02,~,~] = flowisentropic(air_stp,mach2);

p_calc1= 1/pressure_ratio_02;
p_calc2= (pressure_ratio_03)*pressure_ratio_21;
pressure_ratio_31 = p_calc1*p_calc2;

%Ranging pressure ratio from 4-1 accounting for region 4
wedge_angle2 = ObliqueShockBeta(mach1,osw_regionc,air_stp,solution);
m_calc_ang= sind(wedge_angle2);
mach_val1= m_calc_ang*mach1;
[~,~,pressure_ratio_41,~,machval4,~,~]= flownormalshock(air_stp,mach_val1);
mchange_angle2= wedge_angle2- osw_regionc;
mach4_calc= sind(wedge_angle2- osw_regionc);
mach4= machval4/mach4_calc;

%Ranging pressure ratio from 4-5 accounting for region 5
[~,v_ratio15,~] = flowprandtlmeyer(air_stp, mach4);
v_ratio25 = pmef_regiond + v_ratio15;
[mach5,~,~]= flowprandtlmeyer(air_stp,v_ratio25,"nu");
[~,~,pressure_ratio_05,~,~] = flowisentropic(air_stp,mach5);
[~,~,presurre_ratio_04,~,~] = flowisentropic(air_stp,mach4);

p_ratio_calc1= 1/presurre_ratio_04;
p_ratio_calc2= p_ratio_calc1*pressure_ratio_05;
pressure_ratio_51 = pressure_ratio_41*p_ratio_calc2;


%solving for cn/ca values using presure ration changes
%and respective equations
pressure_change= pressure_ratio_41- pressure_ratio_21;
pressure_change2= pressure_ratio_51- pressure_ratio_31;
t_calc1= cotd(ep1);
t_calc2= tand(ep2);
t_main= t_calc1*t_calc2;
tp_val= t_main*pressure_change;
main_calc_num= tp_val+ pressure_change2;
msquare1= mach1^2;
b_calc1= msquare1*air_stp;
b_angle1= tand(ep2);
b_angle2= cotd(ep1);
b_main= b_angle1*b_angle2;
b_main1= b_main+1;
num_val = 2*main_calc_num;
den_val = b_main1*b_calc1;
ld_val= num_val/den_val;
pchange1= pressure_ratio_41-pressure_ratio_51;
pchange2= pressure_ratio_21-pressure_ratio_31;
total_p= pchange1+pchange2;
t_angle1= tand(ep2);
t_angle2= cotd(ep1);
t_main= t_angle1*t_angle2;
t_main1= t_main+1;
total_main= 2*total_p;
msquare2= mach1^2;
t_calc1= air_stp*msquare2;
num_val2= total_main*t_angle1;
den_val2= t_main1*t_calc1;
ld_val2= num_val2/den_val2;

%lift and drag coefficeint calculations
aoa_val1= sind(aoa);
aoa_val2= cosd(aoa);
ld_term1= aoa_val2*ld_val;
ld_term2= aoa_val1*ld_val2;
ld_term3= aoa_val1*ld_val;
ld_term4= aoa_val2*ld_val2;
lift_coefficient= ld_term1-ld_term2; 
wave_drag= ld_term3+ld_term4;
end