function [q2p_rho_d, p2q_rho_d] = d_uncertainity(d_hist)

global d_modeling_bin_size;

load('../edges');
load('../evaluation_pts');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Q, histogram of actual distribution
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[n, bin] = histc(d_hist, edges); % real
q = n/size(d_hist,1)/d_modeling_bin_size;
q = q(:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Pcoh, pdf of coherent distribution
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('..\sigma_coh');
y_coh = maxwell_boltzmann(evaluation_pts, sigma_coh);
y_coh = y_coh(:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Pnoncoh, pdf of non-coherent distribution,
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y_noncoh = square_line_pick(evaluation_pts);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% distance between Q->P1 and Q->P2
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
q = q(1:size(q,1)-1,1);

pcoh = y_coh(q>0);
pnoncoh = y_noncoh(q>0);
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

q2p_rho_d = [...
    q2p_Dcoh_global/q2p_Dnoncoh_global...
    q2p_Dcoh_min/   q2p_Dnoncoh_min...
    q2p_Dcoh_max/   q2p_Dnoncoh_max];

p2q_rho_d = [...
    p2q_Dcoh_global/p2q_Dnoncoh_global...
    p2q_Dcoh_min/   p2q_Dnoncoh_min...
    p2q_Dcoh_max/   p2q_Dnoncoh_max];