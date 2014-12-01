function [r, lattice_title] = sirius_si_lattice(varargin)
% r = sirius_si_lattice       : retorna o modelo atual do anel;
%
% r = sirius_si_lattice(mode) : Ateh o momento, pode ser 'AC10'(default) or 'AC20'.
%
% r = sirius_si_lattice(mode,mode_version): mode_version define o ponto de operacao 
%      e a otimizacao sextupolar a ser usada. Exemplos: 'AC10_1', 'AC10_2',
%      'AC10_5'(default)...
%r = sirius_si_lattice(mode,mode_version, energy): energia em eV;
%
% Todos os inputs comutam e podem ser passados independentemente.
%
% 2012-08-28: nova rede. (xrr)
% 2013-08-08: inseri marcadores de IDs de 2 m nos trechos retos. (xrr)
% 2013-08-12: corretoras rapidas e atualizacao das lentas e dos BPMs (desenho CAD da Liu). (xrr)
% 2013-10-02: adicionei o mode_version como parametro de input. (Fernando)
% 2014-09-17: modificacao das corretoras para apenas uma par integrado de CV e CH rapidas e lentas no mesmo elemento. (Natalia) 
% 2014-10-07: atualizados nomes de alguns elementos. (xrr)

global THERING;


%% global parameters 
%  =================

% --- system parameters ---
energy = 3e9;
mode   = 'C';   % a = ac20, b = ac10(beta=4m), c = ac10(beta=1.5m)
version = '02';
strengths = @set_magnet_strengths;
harmonic_number = 864;

lattice_version = 'SI.V03';
% processamento de input (energia e modo de operacao)
for i=1:length(varargin)
    if ischar(varargin{i}) && length(varargin{i})==1
        mode = varargin{i};
    elseif ischar(varargin{i})
        version = varargin{i};
    elseif isa(varargin{i},'function_handle')
        strengths = varargin{i};
    else
        energy = varargin{i} * 1e9;
    end;
end

lattice_title = [lattice_version '.' mode version];
fprintf(['   Loading lattice ' lattice_title ' - ' num2str(energy/1e9) ' GeV' '\n']);


% carrega forcas dos imas de acordo com modo de operacao
strengths();

%% passmethods
%  ===========

bend_pass_method = 'BndMPoleSymplectic4Pass';
quad_pass_method = 'StrMPoleSymplectic4Pass';
sext_pass_method = 'StrMPoleSymplectic4Pass';


%% elements
%  ========


% --- drift spaces ---

id_length = 2.0; % [m]

dia1     = drift('dia1', id_length/2, 'DriftPass');
dia2     = drift('dia', 3.4828500 - id_length/2, 'DriftPass');
dib1     = drift('dib1', id_length/2, 'DriftPass');
dib2     = drift('dib', 3.0128500 - id_length/2, 'DriftPass');
d00      = drift('d00', 0.005000, 'DriftPass');
d10      = drift('d10', 0.100000, 'DriftPass');
d11      = drift('d11', 0.110000, 'DriftPass');
d12      = drift('d12', 0.120000, 'DriftPass');
d13      = drift('d13', 0.130000, 'DriftPass');
d14      = drift('d14', 0.140000, 'DriftPass');
d15      = drift('d15', 0.150000, 'DriftPass');
d16      = drift('d16', 0.160000, 'DriftPass');
d18      = drift('d18', 0.180000, 'DriftPass');
d19      = drift('d19', 0.190000, 'DriftPass');
d20      = drift('d20', 0.200000, 'DriftPass');
d22      = drift('d22', 0.220000, 'DriftPass');
d23      = drift('d23', 0.230000, 'DriftPass');
d30      = drift('d30', 0.300000, 'DriftPass');
d33      = drift('d33', 0.330000, 'DriftPass');
d44      = drift('d44', 0.440000, 'DriftPass');
d45      = drift('d45', 0.450000, 'DriftPass');

% --- markers ---
mc       = marker('mc',      'IdentityPass');
mia      = marker('mia',     'IdentityPass');
mib      = marker('mib',     'IdentityPass');
mb1      = marker('mb1',     'IdentityPass');
mb2      = marker('mb2',     'IdentityPass');
mb3      = marker('mb3',     'IdentityPass');
inicio   = marker('inicio',  'IdentityPass');
fim      = marker('fim',     'IdentityPass');
mida     = marker('id_enda', 'IdentityPass');
midb     = marker('id_endb', 'IdentityPass');
girder   = marker('girder',  'IdentityPass');

% --- beam position monitors ---
mon      = marker('bpm', 'IdentityPass');

% --- quadrupoles ---
qfa      = quadrupole('qfa',  0.250000, qfa_strength,  quad_pass_method);
qda1     = quadrupole('qda1', 0.140000, qda1_strength, quad_pass_method);
qdb2     = quadrupole('qdb2', 0.140000, qdb2_strength, quad_pass_method);
qfb      = quadrupole('qfb',  0.340000, qfb_strength,  quad_pass_method);
qdb1     = quadrupole('qdb1', 0.140000, qdb1_strength, quad_pass_method);
qf1      = quadrupole('qf1',  0.250000, qf1_strength,  quad_pass_method);
qf2      = quadrupole('qf2',  0.250000, qf2_strength,  quad_pass_method);
qf3      = quadrupole('qf3',  0.250000, qf3_strength,  quad_pass_method);
qf4      = quadrupole('qf4',  0.250000, qf4_strength,  quad_pass_method);

% --- bending magnets --- 
deg_2_rad = (pi/180);

% -- b1 --
dip_nam =  'b1';
dip_len =  0.828080;
dip_ang =  2.766540 * deg_2_rad;
dip_K   = -0.78;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);                    
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);                    
B1      = [h1 mb1 h2];

% -- b2 --
dip_nam =  'b2';
dip_len =  1.228262;
dip_ang =  4.103510 * deg_2_rad;
dip_K   = -0.78;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);                    
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);    
B2      = [h1 mb2 h2];

% -- b3 --
dip_nam =  'b3';
dip_len =  0.428011;
dip_ang =  1.429950 * deg_2_rad;
dip_K   = -0.78;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);                    
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);                    
B3      = [h1 mb3 h2];

% -- bc --
dip_nam =  'bc';
dip_len =  0.125394;
dip_ang =  1.4 * deg_2_rad;
dip_K   =  0.00;
dip_S   = -21.4;
bce     = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
bcs     = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
BC      = [bce mc bcs];


% --- correctors ---
ch     = corrector('hcm',  0, [0 0], 'CorrectorPass');
cv     = corrector('vcm',  0, [0 0], 'CorrectorPass');
crhv   = corrector('crhv', 0, [0,0], 'CorrectorPass');

% --- sextupoles ---    
sfa      = sextupole('sfa',  0.150000, sfa_strength,  sext_pass_method);
sda      = sextupole('sda',  0.150000, sda_strength,  sext_pass_method);
sfb      = sextupole('sfb',  0.150000, sfb_strength,  sext_pass_method);
sdb      = sextupole('sdb',  0.150000, sdb_strength,  sext_pass_method);
sd1a     = sextupole('sd1a', 0.150000, sd1a_strength, sext_pass_method);
sf1a     = sextupole('sf1a', 0.150000, sf1a_strength, sext_pass_method);
sd2a     = sextupole('sd2a', 0.150000, sd2a_strength, sext_pass_method);
sd3a     = sextupole('sd3a', 0.150000, sd3a_strength, sext_pass_method);
sf2a     = sextupole('sf2a', 0.150000, sf2a_strength, sext_pass_method);
sd1b     = sextupole('sd1b', 0.150000, sd1b_strength, sext_pass_method);
sf1b     = sextupole('sf1b', 0.150000, sf1b_strength, sext_pass_method);
sd2b     = sextupole('sd2b', 0.150000, sd2b_strength, sext_pass_method);
sd3b     = sextupole('sd3b', 0.150000, sd3b_strength, sext_pass_method);
sf2b     = sextupole('sf2b', 0.150000, sf2b_strength, sext_pass_method);
           
% --- rf cavity ---
cav = rfcavity('cav', 0, 2.5e6, 500e6, harmonic_number, 'CavityPass');

%% lines 

insa   = [dia1, mida, dia2, girder, ch, cv, crhv, d12, sda, d12, mon, ...
           d12,  qfa,  d23,  qda1, d14, d00, sfa, d19, d00, girder];
insb   = [dib1, midb, dib2, girder, qdb2,  d18,  ch,  cv, crhv, d16, sdb, ...
           d15,  mon,  d11,   qfb,   d23, qdb1, d14, d00,  sfb, d19, d00, girder];

cline1a = [ girder, d45, d00, ch, cv, d16, sd1a, d14, d00, qf1, d12, mon, d11, ...
           sf1a, d20, qf2, d14, d00, sd2a, d12, ch, d10, mon, d12, d00, girder];
cline2a = [ girder, d30, d00, cv, d16, sd3a, d14, d00, qf3, d12, mon, d11, sf2a, ...
            d20, qf4, d16, ch, crhv, d33, d10, mon, d12, girder];
cline3a = [ girder, d44, d11, ch, d16, qf4, d20, sf2a, d11, mon, d12, qf3, d14, ...
            d00, sd3a, d16, cv, crhv, d30, d00, girder];
cline4a = [ girder, d22, d00, ch,  d12, sd2a, d14, d00, qf2, d20, sf1a, d11, mon, ...
            d12, qf1, d14, d00, sd1a, d16, ch, cv, d33, d00, mon, d12, girder];

cline1b = [ girder, d45, d00, ch, cv, d16, sd1b, d14, d00, qf1, d12, mon, d11, ...
           sf1b, d20, qf2, d14, d00, sd2b, d12, ch, d10, mon, d12, d00, girder];
cline2b = [ girder, d30, d00, cv, d16, sd3b, d14, d00, qf3, d12, mon, d11, sf2b, ...
            d20, qf4, d16, ch, crhv, d33, d10, mon, d12, girder];
cline3b = [ girder, d44, d11, ch, d16, qf4, d20, sf2b, d11, mon, d12, qf3, d14, ...
            d00, sd3b, d16, cv, crhv, d30, d00, girder];
cline4b = [ girder, d22, d00, ch, d12, sd2b, d14, d00, qf2, d20, sf1b, d11, mon, ...
            d12, qf1, d14, d00, sd1b, d16, ch, cv, d33, d00, mon, d12, girder];

%% Injection Section

dchinj   = drift('dchinj', 3.1428500, 'DriftPass');
dinjmia  = drift('dinjmia', 0.34, 'DriftPass');
dmiakick = drift('dmiakick', 1.95000, 'DriftPass');
dkickpmm = drift('dkickpmm' , 0.8070, 'DriftPass');
dpmmch   = drift('dpmmch' , 0.7258500, 'DriftPass');
%kick     = corrector('kick',0.5, [0 0], 'CorrectorPass');
%pmm      = sextupole('pmm', 0.5, 0.0, sext_pass_method);
kick     = marker('kick','IdentityPass');
pmm      = marker('pmm','IdentityPass');
inj      = marker('inj','IdentityPass');

insaend  = [girder, ch, cv, crhv, d12, sda, d12, mon, d12, qfa, d23, qda1, d14, d00, sfa, d19, d00, girder];
insainj  = [dmiakick, kick, dkickpmm, pmm, dpmmch, insaend];
injinsa  = [fliplr(insaend), dchinj, dinjmia];

B3BCB3 = [ B3, d13, BC, d13, B3];     


%% the_ring  

% Lattice Ordering
% ----------------
% 
% R01 C01 R02 C02 R03 C03 R04 C04 R05 C05 R06 C06 R07 C07 R08 C08 R09 C09 R10 C10
% R11 C11 R12 C12 R13 C13 R14 C14 R15 C15 R16 C16 R17 C17 R18 C18 R19 C19 R20 C20
% 
% High Beta (mia) : R01, R03, R05, R07, R09, R11, R13, R15, R17, R19
% Low  Beta (mib) : R02, R04, R06, R08, R10, R12, R14, R16, R18, R20
%
% injection: straight section R01
% cavities:  straight section R03


sector_01S = [injinsa fim inicio mia insainj];  % injection sector, marker of the lattice model starting element
sector_03S = [fliplr(insa) mia cav insa];       % sector with cavities
sector_05S = [fliplr(insa) mia insa];
sector_07S = [fliplr(insa) mia insa];
sector_09S = [fliplr(insa) mia insa];
sector_11S = [fliplr(insa) mia insa];
sector_13S = [fliplr(insa) mia insa];
sector_15S = [fliplr(insa) mia insa];
sector_17S = [fliplr(insa) mia insa];
sector_19S = [fliplr(insa) mia insa];
 
sector_02S = [fliplr(insb) mib insb];
sector_04S = [fliplr(insb) mib insb];
sector_06S = [fliplr(insb) mib insb];
sector_08S = [fliplr(insb) mib insb];
sector_10S = [fliplr(insb) mib insb];
sector_12S = [fliplr(insb) mib insb];
sector_14S = [fliplr(insb) mib insb];
sector_16S = [fliplr(insb) mib insb];
sector_18S = [fliplr(insb) mib insb];
sector_20S = [fliplr(insb) mib insb];


C01 = [ B1 cline1a B2 cline2a B3BCB3 cline3b B2 cline4b B1 ];
C02 = [ B1 cline1b B2 cline2b B3BCB3 cline3a B2 cline4a B1 ];
C03 = [ B1 cline1a B2 cline2a B3BCB3 cline3b B2 cline4b B1 ];
C04 = [ B1 cline1b B2 cline2b B3BCB3 cline3a B2 cline4a B1 ];
C05 = [ B1 cline1a B2 cline2a B3BCB3 cline3b B2 cline4b B1 ];
C06 = [ B1 cline1b B2 cline2b B3BCB3 cline3a B2 cline4a B1 ];
C07 = [ B1 cline1a B2 cline2a B3BCB3 cline3b B2 cline4b B1 ];
C08 = [ B1 cline1b B2 cline2b B3BCB3 cline3a B2 cline4a B1 ];
C09 = [ B1 cline1a B2 cline2a B3BCB3 cline3b B2 cline4b B1 ];
C10 = [ B1 cline1b B2 cline2b B3BCB3 cline3a B2 cline4a B1 ];
C11 = [ B1 cline1a B2 cline2a B3BCB3 cline3b B2 cline4b B1 ];
C12 = [ B1 cline1b B2 cline2b B3BCB3 cline3a B2 cline4a B1 ];
C13 = [ B1 cline1a B2 cline2a B3BCB3 cline3b B2 cline4b B1 ];
C14 = [ B1 cline1b B2 cline2b B3BCB3 cline3a B2 cline4a B1 ];
C15 = [ B1 cline1a B2 cline2a B3BCB3 cline3b B2 cline4b B1 ];
C16 = [ B1 cline1b B2 cline2b B3BCB3 cline3a B2 cline4a B1 ];
C17 = [ B1 cline1a B2 cline2a B3BCB3 cline3b B2 cline4b B1 ];
C18 = [ B1 cline1b B2 cline2b B3BCB3 cline3a B2 cline4a B1 ];
C19 = [ B1 cline1a B2 cline2a B3BCB3 cline3b B2 cline4b B1 ];
C20 = [ B1 cline1b B2 cline2b B3BCB3 cline3a B2 cline4a B1 ];

anel = [ ...
    sector_01S C01 sector_02S C02 sector_03S C03 sector_04S C04 sector_05S C05 ...
    sector_06S C06 sector_07S C07 sector_08S C08 sector_09S C09 sector_10S C10 ...
    sector_11S C11 sector_12S C12 sector_13S C13 sector_14S C14 sector_15S C15 ...
    sector_16S C16 sector_17S C17 sector_18S C18 sector_19S C19 sector_20S C20 ...
];
elist = anel;


%% finalization 

THERING = buildlat(elist);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), energy);

% shift lattice to start at the marker 'inicio'
idx = findcells(THERING, 'FamName', 'inicio');
THERING = [THERING(idx:end) THERING(1:idx-1)];

% checks if there are negative-drift elements
lens = getcellstruct(THERING, 'Length', 1:length(THERING));
if any(lens < 0)
    error(['AT model with negative drift in ' mfilename ' !\n']);
end

% adjusts RF frequency according to lattice length and synchronous condition
const  = lnls_constants;
L0_tot = findspos(THERING, length(THERING)+1);
rev_freq    = const.c / L0_tot;
rf_idx      = findcells(THERING, 'FamName', 'cav');
rf_frequency = rev_freq * harmonic_number;
THERING{rf_idx}.Frequency = rf_frequency;
fprintf(['   RF frequency set to ' num2str(rf_frequency/1e6) ' MHz.\n']);

% by default cavities and radiation is set to off 
setcavity('off'); 
setradiation('off');

% sets default NumIntSteps values for elements
THERING = set_num_integ_steps(THERING);

% define vacuum chamber for all elements
THERING = set_vacuum_chamber(THERING);

% defines girders
THERING = set_girders(THERING);

% pre-carrega passmethods de forma a evitar problema com bibliotecas recem-compiladas
lnls_preload_passmethods;

r = THERING;


function the_ring = set_girders(the_ring)

gir = findcells(the_ring,'FamName','girder');

if isempty(gir), return; end

for ii=1:length(gir)-1
    idx = gir(ii):gir(ii+1)-1;
    name_girder = sprintf('%03d',ii);
    the_ring = setcellstruct(the_ring,'Girder',idx,name_girder);
end
idx = [1:gir(1)-1 gir(end):length(the_ring)];
name_girder = sprintf('%03d',ii+1);
the_ring = setcellstruct(the_ring,'Girder',idx,name_girder);

function the_ring = set_num_integ_steps(the_ring0)

the_ring = the_ring0;

bends = findcells(the_ring, 'BendingAngle');
quads = setdiff(findcells(the_ring, 'K'), bends);
sexts = setdiff(findcells(the_ring, 'PolynomB'), [bends quads]);
kicks = findcells(the_ring, 'XGrid');

dl = 0.035;

bends_len = getcellstruct(the_ring, 'Length', bends);
bends_nis = ceil(bends_len / dl);
bends_nis = max([bends_nis'; 10 * ones(size(bends_nis'))]);
the_ring = setcellstruct(the_ring, 'NumIntSteps', bends, bends_nis);
the_ring = setcellstruct(the_ring, 'NumIntSteps', quads, 10);
the_ring = setcellstruct(the_ring, 'NumIntSteps', sexts, 5);
the_ring = setcellstruct(the_ring, 'NumIntSteps', kicks, 1);