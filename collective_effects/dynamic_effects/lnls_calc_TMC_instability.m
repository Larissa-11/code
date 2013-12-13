function [value varargout] = calc_TMC_instability(ringdata, kick, beta)
% Calcula a instabilidade Transverse Mode Coupling.
% Inputs:
% ringdata = c�lula com dados do anel;
% kick = vetor de kick factors a serem considerados;
% beta = vetor dos valores da fun��o beta nos locais das imped�ncias.
% 
% Outputs:
% value = figura de m�rito da instabilidade
% varargout(1) = flag de instabilidade
% varargout(2) = corrente de threshold
%
% Implementado de acordo com a refer�ncia:
% Editor: Chao, W. A.; Tigner, M. Accelerator PHysics and Engineering;
%
% O resultado obtido por essa f�rmula � duas vezes maior que o tuneshift do
% modo azimutal 0. H� f�rmulas no CDR e artigos do NSLS II que fornecem
% estimativas iguais ao tuneshift.
%
% dividi por 2;

w0   = ringdata.w0;
E    = ringdata.E;
nus  = ringdata.nus;
I_tot= ringdata.I_tot;
nb   = ringdata.nb;

kicks = sum(kick.*beta);
value = I_tot/nb/w0/nus/E/1e9*kicks/2;

varargout{1} = false;
if abs(value) > 0.7 % de acordo com o NSLS II e com estimativas olhando o artigo do ESRF
    varargout{1} = true;
end

varargout{2} = w0*nus*E*1e9/kicks;