function Zl = lnls_calc_metallic_coating_on_ceramic_pipe(tc, tm, cond, perm, b, L, sigmal, w)
% FALTA TERMINAR DE IMPLEMENTAR: APARENTE DISCORD�NCIA ENTRE BIBLIOGRAFIAS.
% Imped�ncia tubo cil�ndrico de cer�mica com coating met�lico.
% Inputs:
% tc = espessura da parede de cer�mica [m]
% tc = espessura do coating met�lico [m]
% cond  = condutividade el�trica do metal [1/(Ohm.m)]
% perm  = permeabilidade el�trica relativa da cer�mica
% b     = raio da c�mara [m]
% L     = comprimento longitudinal da c�mara [m]
% sigmal = comprimento longitudinal do pacote [m]
% w     = frequ�ncias para as quais a imped�ncia ser� calculada [Hz]
%
% Outputs: 
% Zl    = imped�ncia longitudinal (real e imagin�ria) calculada para w 
%
% Todos os outputs tem as dimens�es do SI
%
% Limites de aplica��o:
% 1-) b >> Max(tc,tm)
%
% 2-) Max((perm-1)*tc^2/3,(1-1/perm)*b*tc/2) << sigmal^2
%
% Considera��es: O problema � resolvido pelo m�todo exato, de casamento dos
% campos nas interfaces, em [1], portanto, as aproxima��es s�o oriundas
% dessa refer�ncia. Contudo, a f�rmula para a imped�ncia s� � apresentada
% em [2], onde o problema � resolvido perturbativamente e n�o h�
% especifica��o clara das aproxima��es. N�o consegui chegar no resultado de
% [2] a partir do de [1], � necess�rio estudar mais o problema.
% A f�rmula empregada foi retirada de [3], que apenas reescreve e
% particulariza para o caso de metal-cer�mica o resultado de [2], que �
% geral e pode ser aplicado para metal-metal tamb�m.
% Ainda, [4] modela o problema diferentemente, considerando um comprimento 
% finito para o sistema. 
%
% Refer�ncias:
%
% [1] Piwinski A.; Penetration of the field of a bunched beam through a 
%     ceramic vacuum chamber with metallic coating, IEEE 1977.
% [2] Lin, X. E.; RF loss in and leakage through thin metal film,
%     SLAC-PUB-7924 1998.
% [3] Ng, K. Y., Explicit Expressions of Impedances and Wake Functions,
%     SLAC-PUB-15078 2010.
% [4] Danilov V. et al; An Improved Impedance Model of Metallic Coatings,
%     EPAC 2002.
%

% Constantes utilizadas
c   = 299792458; % velocidade da luz
u0  = 4e-7*pi; % permeabilidade magn�tica do v�cuo
Z0  = c*u0; % Imped�ncia do v�cuo
bigger = 5; %constante multiplicativa de delta_c para indicar ">>"

% Par�metros auxiliares
s0 = (2*b^2*perm/Z0/cond)^(1/3); % ~ 20um

x = (b > bigger*max(tc,tm)) && ...
    (max([(perm-1)*tc^2/3,(1-1/perm)*b*tc/2])*bigger < sigmal^2);
if x
    k       = w/c;
    delta_c = sqrt(2/Z0/perm/cond/abs(k));
    nu      = (1-sign(w)*1i)./delta_c;
    A       = (1-1/perm)*nu*tc;
    Z0m     = 
    Zl      = L*Z0m*(A+tanh(nu*tm))/(1+A*tanh(nu*tm));
else
    disp('Express�o n�o � v�lida');
end


