 %sirius_booster;
 %global THERING;

a = calctwiss;
gamma = 150/0.511;
emit = 50e-6/gamma;
energysprd = 0.005;
varenergy = 0.0025;

a.etay = 0.01*a.etax;

codx = load(['C:\Arq\MatlabMiddleLayer\Release\lnls\fac_scripts\sirius' ...
'\lattice_errors\CONFIG_BOOSTER_V300\CONFIG_BOOSTER_V300_codx_corrected.dat']);
codx = max(abs(codx))'/1000;

cody = load(['C:\Arq\MatlabMiddleLayer\Release\lnls\fac_scripts\sirius' ...
'\lattice_errors\CONFIG_BOOSTER_V300\CONFIG_BOOSTER_V300_cody_corrected.dat']);
cody = max(abs(cody))'/1000;

Ax =   4.0*sqrt(a.betax*1*emit+(a.etax).^2*energysprd^2)*1000 + ... 4*beamsize@injection + 
      1*codx + ... 1mm(cod) + 
      1*varenergy*a.etax*1000 + ... varenergylinac*dispersion +
      1*4.4; % 4mm(oscila��o residual inje��o)
   
Ay =  4.0*sqrt(a.betay*1*emit+a.etay.^2*energysprd^2)*1000 + ... 4*beamsize@injection + 
       1*cody + ... 1mm(cod) + 
       1*varenergy*a.etay*1000 + ... % varenergylinac*dispersion
       1*1.4; % (oscila��o residual inje��o)

max_s = a.pos(end)/5;
   
% Create figure
figure1 = figure('Position',[93,94,1239,461]) ;
axes1 = axes('Parent',figure1,...
    'Position',[0.0676968359087564 0.154905335628227 0.911272669874628 0.770094664371774],...
    'FontSize',20);
box(axes1,'on');
grid(axes1,'on');
hold(axes1,'all');


% Create multiple lines using matrix input to plot
plot1 = plot(axes1,a.pos,[Ax,Ay]);
set(axes1,'XLim',[0 max_s]);
drawlattice(2.5,2,axes1,max_s);
% Create xlabel
xlabel({'s [m]'},'FontSize',20);
% Create ylabel
ylabel({'Aperture [mm]'},'FontSize',20);
legend1 = legend(plot1,'show',{'X';'Y'});
     set(legend1, 'Location','NorthEast');

maxx = max(Ax)
maxy = max(Ay)
       
