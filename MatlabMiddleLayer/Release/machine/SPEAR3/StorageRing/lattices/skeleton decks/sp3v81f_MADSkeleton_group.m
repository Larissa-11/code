!SP3V81f_MADSKeleton_Group 04/08/2003
!Injection kickers and injection point(downstream exit of the septum) are added
!
!All the lengths of quadrupoles were changed to effective lengths. 03/13/03
!
!SPEAR3 V8.1 Positions of bpms and correctors were
!updated by Jeff in accordance with the drawings.
!Lengths of the dipole magnets were changed to the effective lengths.
!Accordingly the gradients of the dipoles were also changed. *** by M. Yoon
! 03/12/2003
!
!SPEAR 3 Lattice SP3V81
! DATE AND TIME:   06/21/02  08.00.00
!
! FILE:            SP3V81RESP.MAD
! From SP3V80.MAD with SFI and QDX moves
! Includes correctors and BPMs
! 4/8/03 JC File modified for use with HW2OpticsDeck

!BPM
BPM: MONITOR

!Correctors
HCOR: HKICKER, L=0.075
VCOR: VKICKER, L=0.075
HVCOR: LINE=(HCOR,VCOR)

! Standard Cell Drifts 
D0: DRIFT, L=0.0
DC1A: DRIFT, L=1.405934
DC1B: DRIFT, L=0.12404125
DC2: DRIFT, L=0.0975
DC3: DRIFT, L=0.25
DC4: DRIFT, L=0.23
DC5: DRIFT, L=0.200986
DC6: DRIFT, L=0.18

!Standard Cell BPM Drifts
DC3A:  DRIFT, L=0.05322065
DC3B:  DRIFT, L=0.16368247
DC4A:  DRIFT, L=0.15921467
DC4B:  DRIFT, L=0.044418
DC6A:  DRIFT, L=0.110646   
DC6B:  DRIFT, L=0.06316585  
!0.069354 corrected to make path length consistent

!Standard Cell Corrector Drifts
DC2A:  DRIFT, L=0.11576525 
DC2B:  DRIFT, L=0.11581045
DC2C:  DRIFT, L=0.10210045 
DC2D:  DRIFT, L=0.12947525 
DC5A:  DRIFT, L=0.09058  
DC5B:  DRIFT, L=0.36139 
DC5C:  DRIFT, L=0.09584 
DC5D:  DRIFT, L=0.35613

!Standard Cell Dipoles
KBND:=-0.31537858    !Nominal
!Write Grouped Standard Cell Dipoles - DO NOT REMOVE THIS LINE: command used to fill skeleton deck
BEND: SBEND, L=1.5048, K1=KBND, ANGLE=0.184799567858223 ,&  
     E1=0.092399783929112 , E2=0.092399783929112 
     
!Standard Cell Quadrupoles
KQF:=1.768672904054     !Nominal
KQD:=-1.542474230359    !Nominal
KQFC:=1.748640831069    !Nominal
!Write Grouped Standard Cell Quadrupoles - DO NOT REMOVE THIS LINE: command used to fill skeleton deck
QF: QUADRUPOLE, L=0.3533895, K1=KQF
QD: QUADRUPOLE, L=0.1634591, K1=KQD
QFC: QUADRUPOLE, L=0.5123803, K1=KQFC

!Standard Cell Sextupoles
KSF:=32.047709345958/2    !Nominal
KSD:=-38.801530341794/2   !Nominal
!NOTE: transfer function will return AT units for sextupoles
!MAD multipole strength coefficients K(n) are defined without 1/n!
!Write Grouped Standard Cell Sextupoles - DO NOT REMOVE THIS LINE: command used to fill skeleton deck
SF: SEXTUPOLE, L=0.21, K2=2*KSF
SD: SEXTUPOLE, L=0.25, K2=2*KSD

!Injection
IK1 : HKICK, L=0.0, KICK=  0.0000000E+00, TYPE=KMAGNET
IK2 : HKICK, L=0.0, KICK=  0.0000000E+00, TYPE=KMAGNET
IK3 : HKICK, L=0.0, KICK=  0.0000000E+00, TYPE=KMAGNET

INJ : MARKER    ! Injection point (downstream end of the septum)
DI1 : DRIFT, L=0.1176401
DI2 : DRIFT, L=1.2882939
DI3 : DRIFT, L=0.9834939
DI4 : DRIFT, L=0.4224401
DI5 : DRIFT, L=1.24013
DI6 : DRIFT, L=0.165804
DI7 : DRIFT, L=1.2882939
DI8 : DRIFT, L=0.1176401


!Standard Cell Definitions
CEL: LINE=(DC1A, BPM, DC1B, QF, DC2A, HVCOR, DC2B, QD, &  
       DC3A, BPM, DC3B, BEND, DC4A, BPM, DC4B, SD,DC5A, HVCOR, DC5B, SF, &  
       DC6A, BPM, DC6B, QFC, DC6B, DC6A, SF, DC5C, HVCOR, DC5D, &
       SD, DC4B, BPM, DC4A, BEND, DC3B, DC3A, QD, DC2C, HVCOR, &
       DC2D, QF, DC1B, BPM, DC1A)

CEL2: LINE=(DI1,IK1,DI2, BPM, DC1B, QF, DC2A, HVCOR, DC2B, QD,&  
       DC3A, BPM, DC3B, BEND, DC4A, BPM, DC4B, SD,DC5A, HVCOR, DC5B, SF, &  
       DC6A, BPM, DC6B, QFC, DC6B, DC6A, SF, DC5C, HVCOR, DC5D,&
       SD, DC4B, BPM, DC4A, BEND, DC3B, DC3A, QD, DC2C, HVCOR, &
       DC2D, QF, DC1B, BPM, DI3,IK2,DI4)

CEL3: LINE=(DI5,INJ,DI6, BPM, DC1B, QF, DC2A, HVCOR, DC2B, QD,&  
       DC3A, BPM, DC3B, BEND, DC4A, BPM, DC4B, SD,DC5A, HVCOR, DC5B, SF, &  
       DC6A, BPM, DC6B, QFC, DC6B, DC6A, SF, DC5C, HVCOR, DC5D,&
       SD, DC4B, BPM, DC4A, BEND, DC3B, DC3A, QD, DC2C, HVCOR, &
       DC2D, QF, DC1B, BPM, DI2,IK3,DI1)

!Matching Cell Drifts without correctors or BPMs
DM1: DRIFT, L=3.810000
DM2: DRIFT, L=0.0975
DM3: DRIFT, L=0.275
DM4: DRIFT, L=0.21584572
DM5: DRIFT, L=0.25
DM6: DRIFT, L=0.490684631
DM7: DRIFT, L=0.17380985
DM8: DRIFT, L=0.5
DM9: DRIFT, L=0.105
DM10: DRIFT, L=3.27657140

!Matching Cell A BPM Drifts
DA1A: DRIFT, L=3.6792386
DA1B: DRIFT, L=0.12406665
DA3A: DRIFT, L=0.20889925
DA3B: DRIFT, L=0.05414045

DA5A: DRIFT, L=0.11397747
DA5B: DRIFT, L=0.108563
DA5C: DRIFT, L=0.051845

DA5D: DRIFT, L=0.17069547
DA7A: DRIFT, L=0.1106966
DA7B: DRIFT, L=0.06311325

DA8A: DRIFT, L=0.33735947
DA8B: DRIFT, L=0.12848625
DA10A: DRIFT, L=0.12393965
DA10B: DRIFT, L=3.145937

!Matching Cell A Corrector Drifts
DA2A: DRIFT, L=0.11530525
DA2B: DRIFT, L=0.11773445
DA6A: DRIFT, L=0.126600
DA6B: DRIFT, L=0.904768280     
!0.90477 corrected to make path length consistent
DA6C: DRIFT, L=0.096000
DA6D: DRIFT, L=0.93537
DA9A: DRIFT, L=0.10930525
DA9B: DRIFT, L=0.13730525

!Matching Cell B  BPM Drifts 
DB1A: DRIFT, L=3.747082
DB1B: DRIFT, L=0.05622325
DB3A: DRIFT, L=0.13222685
DB3B: DRIFT, L=0.13081285
DB5A: DRIFT, L=0.17069547
DB5B: DRIFT, L=0.051845
DB5C: DRIFT, L=0.1085632
DB5D: DRIFT, L=0.11397727
DB7A: DRIFT, L=0.06311305
DB7B: DRIFT, L=0.1106968
DB8A: DRIFT, L=0.32725027
DB8B: DRIFT, L=0.13859545
DB10A: DRIFT, L=0.12404125
DB10B: DRIFT, L=3.1458354

!Matching Cell B Corrector Drifts
DB2A: DRIFT, L=0.11580525
DB2B: DRIFT, L=0.11723445
DB6A: DRIFT, L=0.937370
DB6B: DRIFT, L=0.093998520   !0.094 corrected to make path length consistent
DB6C: DRIFT, L=0.90437000
DB6D: DRIFT, L=0.127000000
DB9A: DRIFT, L=0.12330525
DB9B: DRIFT, L=0.12330525

!Matching Cell Dipoles
KB34:=-0.31537858    !Nominal
!Write Grouped Match Cell Dipoles - DO NOT REMOVE THIS LINE: command used to fill skeleton deck
B34: SBEND, L=1.14329, ANGLE=0.138599675893667 , K1=KB34, &  
   E1=0.069299837946834 , E2=0.069299837946834 

!Matching Cell Quadrupoles
KQDX:=-1.386467245226    !Nominal
KQFX:=1.573196278394     !Nominal
KQDY:=-0.460640930646    !Nominal
KQFY:=1.481493709831     !Nominal
KQDZ:=-0.878223937747    !Nominal
KQFZ:=1.427902006984     !Nominal
!Write Grouped Match Cell Quadrupoles - DO NOT REMOVE THIS LINE: command used to fill skeleton deck
QDX: QUADRUPOLE, L=0.3533895, K1=KQDX
QFX: QUADRUPOLE, L=0.6105311, K1=KQFX
QDY: QUADRUPOLE, L=0.3533895, K1=KQDY
QFY: QUADRUPOLE, L=0.5123803, K1=KQFY
QDZ: QUADRUPOLE, L=0.3533895, K1=KQDZ
QFZ: QUADRUPOLE, L=0.3533895, K1=KQFZ

!Matching Cell Sextupoles
KSFI:=15.02/     !Nominal
KSDI:=-17.0/2    !Nominal
!NOTE: transfer function will return AT units for sextupoles
!MAD multipole strength coefficients K(n) are defined without 1/n!
!Write Grouped Match Cell Sextupoles - DO NOT REMOVE THIS LINE: command used to fill skeleton deck
SFI: SEXTUPOLE, L=0.21, K2=2*KSFI
SDI: SEXTUPOLE, L=0.21, K2=2*KSDI


!Matching Cell Definitions
MCA: LINE=(DA1A, BPM, DA1B, QDX, DA2A, HVCOR, DA2B,&
QFX, DA3A, BPM, DA3B, QDY, DM4, B34, DA5A, BPM, DA5B,&
SDI, DA6A, HVCOR, DA6B, SFI, DA7A ,BPM ,DA7B ,QFY,&
DM7 ,SFI ,DA6C, HVCOR, DA6D, SDI, DA5C, BPM, DA5D, B34,&
DA8A, BPM, DA8B, QDZ, DA9A, HVCOR, DA9B, QFZ, DA10A, BPM, DA10B)

MCBR: LINE=(DB10B, BPM, DB10A, QFZ, DB9B, HVCOR, DB9A, &
QDZ, DB8B, BPM, DB8A, B34, DB5D, BPM, DB5C, SDI, DB6D, & 
HVCOR, DB6C, SFI, DB7B, BPM, DB7A, QFY, DM7, SFI, &
DB6B, HVCOR, DB6A, SDI, DB5B, BPM,&  
DB5A, B34, DM4, QDY, DB3B, BPM, DB3A, QFX, DB2B, HVCOR, DB2A, &
QDX,DB1B,BPM,DB1A)

!MAIN RING
RING: LINE= (MCA,CEL,CEL2,CEL3,4*CEL,MCBR,MCA,7*CEL,MCBR)
USE, RING

TWISS, DELT=0, TAPE

STOP