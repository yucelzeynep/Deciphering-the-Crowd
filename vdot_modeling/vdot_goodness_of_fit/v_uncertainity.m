function [q2p_rho_v, p2q_rho_v] = v_uncertainity(vdot)

global vdot_modeling_bin_size;
load('..\edges');
load('..\evaluation_pts');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Q, histogram of actual distribution
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[histogram, bin] = histc(vdot, edges);
q = histogram/size(vdot,1)/vdot_modeling_bin_size;
q = q(:);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Pcoh, pdf of coherent distribution
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('..\vdot_kappa_coh');

f_coh =  mises_vdot_coh(evaluation_pts, kappa_coh);
f_coh = f_coh(:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Pnoncoh, pdf of non-coherent distribution
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('..\vdot_kappa_noncoh');

f_noncoh =  mises_vdot_noncoh(evaluation_pts, kappa_noncoh);
f_noncoh = f_noncoh(:);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% distance between Q->P1 and Q->P2
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
q = q(1:size(q,1)-1,1);

pcoh = f_coh(q>0);
pnoncoh = f_noncoh(q>0);
q = q(q>0);
 
% from q -> pcoh and q -> pnoncoh 
q2p_Dcoh_global = sum(q.*log(q./pcoh));
q2p_Dnoncoh_global = sum(q.*log(q./pnoncoh));

q2p_Dcoh_min = min(q.*log(q./pcoh));
q2p_Dnoncoh_min = min(q.*log(q./pnoncoh));

q2p_Dcoh_max = max(q.*log(q./pcoh));
q2p_Dnoncoh_max = max(q.*log(q./pnoncoh));

% from pcoh -> q and pnoncoh -> q
p2q_Dcoh_global = sum(pcoh.*log(pcoh./q));
p2q_Dnoncoh_global = sum(pnoncoh.*log(pnoncoh./q));

p2q_Dcoh_min = min(pcoh.*log(pcoh./q));
p2q_Dnoncoh_min = min(pnoncoh.*log(pnoncoh./q));

p2q_Dcoh_max = max(pcoh.*log(pcoh./q));
p2q_Dnoncoh_max = max(pnoncoh.*log(pnoncoh./q));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% uncertainity
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

q2p_rho_v = [...
    q2p_Dcoh_global/q2p_Dnoncoh_global...
    q2p_Dcoh_min/   q2p_Dnoncoh_min...
    q2p_Dcoh_max/   q2p_Dnoncoh_max];

p2q_rho_v = [...
    p2q_Dcoh_global/p2q_Dnoncoh_global...
    p2q_Dcoh_min/   p2q_Dnoncoh_min...
    p2q_Dcoh_max/   p2q_Dnoncoh_max];