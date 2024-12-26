%CA 3 Helper PLLT FUNCTION
%function to initialize Prandtl Lift Line Theory used to calculate finite
%wings and analyze thin and thick airfoils. will be used to plot induced
%drag factor as a function of the taper ratio. Function based of span,
%angle of attack, at tip and root, geometeric parametes at tip and root. 
%c_L is the coefficient of lift, c_Di is the induced drag coefficient b is 
%the span, a0_t cross-sectional lift slope at the tips a0_r is at the root 
%c_t is the chord at the tips, c_r is at the root, aero_t zero-lift aoa at 
%tips, aero_r is the zero-lift aoa at the root, geo_t is the geometric angle 
%at tips, geo_r is roots, and N is odd terms out of circulation


function [induced_dragfactor, lift_coeffcient, induced_drag]= PLLT(b, a0_t, a0_r, c_t, c_r, attack_tip, attack_root, geo_t, geo_r, N)
%initial angle derivation
calc1= (2*N);
calctheta= pi/calc1;
calc2= pi/2;
theta= linspace(calctheta, calc2, N)';

%chord linear system
delta_csl= (a0_t-a0_r);
delta_chord= (c_t-c_r);
delta_attack= (attack_tip-attack_root);
delta_geo= (geo_t-geo_r);

angleval= cos(theta);
cls_val= angleval*delta_csl;
cls_main= cls_val+ a0_r;
cslr_val= angleval*delta_chord;

a0_r= cslr_val+ c_r;
aero_val= angleval*delta_attack;
geo_val= angleval*delta_geo;
aero= aero_val+ attack_root;
geo= geo_val+ geo_r;

% setting up the linear system
[i,j]= meshgrid(1:N,1:N);
span_num= 4*b;
term1= a0_r(j);
term2= cls_main(j);
factor1= i*2;
factor2= factor1-1;
anglecalc= (theta(j)).*factor2;
calc_sin1= sin(theta(j));
calcsin2= sin(anglecalc)./calc_sin1;
term3= factor2.*calcsin2;
term_sin= sin(anglecalc);
aterm_calc1= (term1.*term2);
main_a_term= span_num./aterm_calc1;
pllt_term1= main_a_term.* term_sin;
pllt_sum= pllt_term1+ term3;

%aoa of wing
%pllt calc sum
conversion= pi/180;
change_ag= geo-aero;
aoa= change_ag*conversion;
co= pllt_sum^(-1)*aoa;

%solving for induced drag
newcalc1= 2*N;
dragterm1_inverse= [3:2:newcalc1]';
dragterm= (co(2:end))/co(1);
dragterm_square= dragterm.^2;
maindragterm= dragterm1_inverse.*dragterm_square;
change= sum(maindragterm);
change1= change+1;
induced_dragfactor= change1^-1;
chord_sum= c_r+c_t;
b2= (b/2);
span_calc= b^2;
wing= b2*chord_sum;
aspect_ratio= span_calc/wing;
lc_factor= co(1)*pi;
lift_coeffcient= lc_factor*aspect_ratio;
calc_cdi1= lift_coeffcient^2;
calc_cdi2= aspect_ratio*induced_dragfactor*pi;
induced_drag= calc_cdi1/calc_cdi2;
end