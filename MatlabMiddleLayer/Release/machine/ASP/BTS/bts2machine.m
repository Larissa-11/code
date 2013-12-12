%% bts2machine
% This script will use SETSP to set the BTS quadrupoles on the
% machine to the values in the model.
%
% Eugene Tan  2006-08-21

%% initialise the lattice variables
global THERING BTS

if isempty(THERING) || isempty(THERING)
    error('global variable THERING or BTS not loaded. Please run asboosterinit again');
end

q_ind = getfamilydata('BTS_Q','AT','ATIndex');
q_vals = getcellstruct(BTS,'K',q_ind);
setsp('BTS_Q',q_vals,'Physics');

clear q_ind q_vals;