Libname NIS 'D:\YH666\Dropbox\HCUP\Project\DATA\NIS_2014';



Data NIS.Core001;
	Set NIS.NIS_2014_Core;
* To Include  those who were admitted to hospital within the neonatal period (first 28 days of life);
* To avoid those who were admitted later and may represent duplicity;
	IF .< Age < 1 & AGE_NEONATE = 1 Then NB = 1;
	Else NB = 0;

* To include  those who were admited with a neonatal related diagnosis;
* To include  those who were admited with a diagnosis reflects:
                specific GA (1st group) or
                specific BW (2nd group);
	IF NeoMat = 2 |

DX1='765'  | DX2='765'  | DX3='765'  | DX4='765'  | DX5='765'  | DX6='765'  | DX7='765'  | DX8='765'  | DX9='765'  | DX10='765'  | DX11='765'  | DX12='765'  | DX13='765'  | DX14='765'  | DX15='765'  |

DX1='7650' | DX2='7650' | DX3='7650' | DX4='7650' | DX5='7650' | DX6='7650' | DX7='7650' | DX8='7650' | DX9='7650' | DX10='7650' | DX11='7650' | DX12='7650' | DX13='7650' | DX14='7650' | DX15='7650' |

DX1='7651' | DX2='7651' | DX3='7651' | DX4='7651' | DX5='7651' | DX6='7651' | DX7='7651' | DX8='7651' | DX9='7651' | DX10='7651' | DX11='7651' | DX12='7651' | DX13='7651' | DX14='7651' | DX15='7651' |

DX1='7652' | DX2='7652' | DX3='7652' | DX4='7652' | DX5='7652' | DX6='7652' | DX7='7652' | DX8='7652' | DX9='7652' | DX10='7652' | DX11='7652' | DX12='7652' | DX13='7652' | DX14='7652' | DX15='7652' |

DX1='76520'| DX2='76520'| DX3='76520'| DX4='76520'| DX5='76520'| DX6='76520'| DX7='76520'| DX8='76520'| DX9='76520'| DX10='76520'| DX11='76520'| DX12='76520'| DX13='76520'| DX14='76520'| DX15='76520'|

DX1='76521'| DX2='76521'| DX3='76521'| DX4='76521'| DX5='76521'| DX6='76521'| DX7='76521'| DX8='76521'| DX9='76521'| DX10='76521'| DX11='76521'| DX12='76521'| DX13='76521'| DX14='76521'| DX15='76521'|

DX1='76522'| DX2='76522'| DX3='76522'| DX4='76522'| DX5='76522'| DX6='76522'| DX7='76522'| DX8='76522'| DX9='76522'| DX10='76522'| DX11='76522'| DX12='76522'| DX13='76522'| DX14='76522'| DX15='76522'|

DX1='76523'| DX2='76523'| DX3='76523'| DX4='76523'| DX5='76523'| DX6='76523'| DX7='76523'| DX8='76523'| DX9='76523'| DX10='76523'| DX11='76523'| DX12='76523'| DX13='76523'| DX14='76523'| DX15='76523'|

DX1='76524'| DX2='76524'| DX3='76524'| DX4='76524'| DX5='76524'| DX6='76524'| DX7='76524'| DX8='76524'| DX9='76524'| DX10='76524'| DX11='76524'| DX12='76524'| DX13='76524'| DX14='76524'| DX15='76524'|

DX1='76525'| DX2='76525'| DX3='76525'| DX4='76525'| DX5='76525'| DX6='76525'| DX7='76525'| DX8='76525'| DX9='76525'| DX10='76525'| DX11='76525'| DX12='76525'| DX13='76525'| DX14='76525'| DX15='76525'|

DX1='76526'| DX2='76526'| DX3='76526'| DX4='76526'| DX5='76526'| DX6='76526'| DX7='76526'| DX8='76526'| DX9='76526'| DX10='76526'| DX11='76526'| DX12='76526'| DX13='76526'| DX14='76526'| DX15='76526'|

DX1='76527'| DX2='76527'| DX3='76527'| DX4='76527'| DX5='76527'| DX6='76527'| DX7='76527'| DX8='76527'| DX9='76527'| DX10='76527'| DX11='76527'| DX12='76527'| DX13='76527'| DX14='76527'| DX15='76527'|

DX1='76528'| DX2='76528'| DX3='76528'| DX4='76528'| DX5='76528'| DX6='76528'| DX7='76528'| DX8='76528'| DX9='76528'| DX10='76528'| DX11='76528'| DX12='76528'| DX13='76528'| DX14='76528'| DX15='76528'|

DX1='76529'| DX2='76529'| DX3='76529'| DX4='76529'| DX5='76529'| DX6='76529'| DX7='76529'| DX8='76529'| DX9='76529'| DX10='76529'| DX11='76529'| DX12='76529'| DX13='76529'| DX14='76529'| DX15='76529'|

 
DX1='76501'| DX2='76501'| DX3='76501'| DX4='76501'| DX5='76501'| DX6='76501'| DX7='76501'| DX8='76501'| DX9='76501'| DX10='76501'| DX11='76501'| DX12='76501'| DX13='76501'| DX14='76501'| DX15='76501'|

DX1='76502'| DX2='76502'| DX3='76502'| DX4='76502'| DX5='76502'| DX6='76502'| DX7='76502'| DX8='76502'| DX9='76502'| DX10='76502'| DX11='76502'| DX12='76502'| DX13='76502'| DX14='76502'| DX15='76502'|

DX1='76503'| DX2='76503'| DX3='76503'| DX4='76503'| DX5='76503'| DX6='76503'| DX7='76503'| DX8='76503'| DX9='76503'| DX10='76503'| DX11='76503'| DX12='76503'| DX13='76503'| DX14='76503'| DX15='76503'|

DX1='76514'| DX2='76514'| DX3='76514'| DX4='76514'| DX5='76514'| DX6='76514'| DX7='76514'| DX8='76514'| DX9='76514'| DX10='76514'| DX11='76514'| DX12='76514'| DX13='76514'| DX14='76514'| DX15='76514'|

DX1='76515'| DX2='76515'| DX3='76515'| DX4='76515'| DX5='76515'| DX6='76515'| DX7='76515'| DX8='76515'| DX9='76515'| DX10='76515'| DX11='76515'| DX12='76515'| DX13='76515'| DX14='76515'| DX15='76515'|

DX1='76516'| DX2='76516'| DX3='76516'| DX4='76516'| DX5='76516'| DX6='76516'| DX7='76516'| DX8='76516'| DX9='76516'| DX10='76516'| DX11='76516'| DX12='76516'| DX13='76516'| DX14='76516'| DX15='76516'|

DX1='76517'| DX2='76517'| DX3='76517'| DX4='76517'| DX5='76517'| DX6='76517'| DX7='76517'| DX8='76517'| DX9='76517'| DX10='76517'| DX11='76517'| DX12='76517'| DX13='76517'| DX14='76517'| DX15='76517'|

DX1='76518'| DX2='76518'| DX3='76518'| DX4='76518'| DX5='76518'| DX6='76518'| DX7='76518'| DX8='76518'| DX9='76518'| DX10='76518'| DX11='76518'| DX12='76518'| DX13='76518'| DX14='76518'| DX15='76518'|

DX1='76519'| DX2='76519'| DX3='76519'| DX4='76519'| DX5='76519'| DX6='76519'| DX7='76519'| DX8='76519'| DX9='76519'| DX10='76519'| DX11='76519'| DX12='76519'| DX13='76519'| DX14='76519'| DX15='76519'|

DX1='76405'| DX2='76405'| DX3='76405'| DX4='76405'| DX5='76405'| DX6='76405'| DX7='76405'| DX8='76405'| DX9='76405'| DX10='76405'| DX11='76405'| DX12='76405'| DX13='76405'| DX14='76405'| DX15='76405'|

DX1='76406'| DX2='76406'| DX3='76406'| DX4='76406'| DX5='76406'| DX6='76406'| DX7='76406'| DX8='76406'| DX9='76406'| DX10='76406'| DX11='76406'| DX12='76406'| DX13='76406'| DX14='76406'| DX15='76406'|

DX1='76407'| DX2='76407'| DX3='76407'| DX4='76407'| DX5='76407'| DX6='76407'| DX7='76407'| DX8='76407'| DX9='76407'| DX10='76407'| DX11='76407'| DX12='76407'| DX13='76407'| DX14='76407'| DX15='76407'|

DX1='76408'| DX2='76408'| DX3='76408'| DX4='76408'| DX5='76408'| DX6='76408'| DX7='76408'| DX8='76408'| DX9='76408'| DX10='76408'| DX11='76408'| DX12='76408'| DX13='76408'| DX14='76408'| DX15='76408'|

DX1='76409'| DX2='76409'| DX3='76409'| DX4='76409'| DX5='76409'| DX6='76409'| DX7='76409'| DX8='76409'| DX9='76409'| DX10='76409'| DX11='76409'| DX12='76409'| DX13='76409'| DX14='76409'| DX15='76409'|

DX1='7660' | DX2='7660' | DX3='7660' | DX4='7660' | DX5='7660' | DX6='7660' | DX7='7660' | DX8='7660' | DX9='7660' | DX10='7660' | DX11='7660' | DX12='7660' | DX13='7660' | DX14='7660' | DX15='7660' |

DX1='7661' | DX2='7661' | DX3='7661' | DX4='7661' | DX5='7661' | DX6='7661' | DX7='7661' | DX8='7661' | DX9='7661' | DX10='7661' | DX11='7661' | DX12='7661' | DX13='7661' | DX14='7661' | DX15='7661' |

DX1='7662' | DX2='7662' | DX3='7662' | DX4='7662' | DX5='7662' | DX6='7662' | DX7='7662' | DX8='7662' | DX9='7662' | DX10='7662' | DX11='7662' | DX12='7662' | DX13='7662' | DX14='7662' | DX15='7662'

;

* Gestational Age ;
Array GestationalAge {15} DX1 DX2 DX3 DX4 DX5 DX6 DX7 DX8 DX9 DX10 DX11 DX12 DX13 DX14 DX15;

Do GL = 1 to 15;

IF GestationalAge{GL} = '76521' Then GA = '01) GA < 24';

Else IF GestationalAge{GL} = '76522' Then GA = '02) GA = 24';

Else IF GestationalAge{GL} = '76523' Then GA = '03) GA25-26';

Else IF GestationalAge{GL} = '76524' Then GA = '04) GA27-28';

Else IF GestationalAge{GL} = '76525' Then GA = '05) GA29-30';

Else IF GestationalAge{GL} = '76526' Then GA = '06) GA31-32';

Else IF GestationalAge{GL} = '76527' Then GA = '07) GA33-34';

Else IF GestationalAge{GL} = '76528' Then GA = '08) GA35-36';

Else IF GestationalAge{GL} = '76529' Then GA = '09) GA37-> ';

Else IF GestationalAge{GL} = '76520' Then GA = 'GAUS';

Else IF GestationalAge{GL} = '7652'  Then GA = 'GAUS';

Else IF GestationalAge{GL} = '7651'  Then GA = 'GAUS';

Else IF GestationalAge{GL} = '7650'  Then GA = 'GAUS';

Else IF GestationalAge{GL} = '765'   Then GA = 'GAUS';

End;

Drop GL;

* Birth Weight ;

Array BirthWeight1 {15} DX1 DX2 DX3 DX4 DX5 DX6 DX7 DX8 DX9 DX10 DX11 DX12 DX13 DX14 DX15;

Do BTW = 1 to 15;

IF         BirthWeight1{BTW} = '76408' Then BW = 'SGA 2000-2499';

Else IF BirthWeight1{BTW} = '76407' Then BW = 'SGA 1750-1999';

Else IF BirthWeight1{BTW} = '76406' Then BW = 'SGA 1500-1749';

Else IF BirthWeight1{BTW} = '76405' Then BW = 'SGA 1250-1499';

Else IF BirthWeight1{BTW} = '76404' Then BW = 'SGA 1000-1249';

Else IF BirthWeight1{BTW} = '7641'

Or         BirthWeight1{BTW} = '7649'  Then BW = 'SGA IUGR     ';

Else IF BirthWeight1{BTW} = '7640'  Then BW = 'SGA Unspecif ';

Else IF BirthWeight1{BTW} = '7661'  Then BW = '11) LGA      ';

Else IF BirthWeight1{BTW} = '7660'  Then BW = '10) > 4500   ';

Else IF BirthWeight1{BTW} = '76519'

OR         BirthWeight1{BTW} = '76409' Then BW = '09) > 2500   ';

Else IF BirthWeight1{BTW} = '76518' Then BW = '08) 2000-2499';

Else IF BirthWeight1{BTW} = '76517' Then BW = '07) 1750-1999';

Else IF BirthWeight1{BTW} = '76516' Then BW = '06) 1500-1749';

Else IF BirthWeight1{BTW} = '76515' Then BW = '05) 1250-1499';

Else IF BirthWeight1{BTW} = '76514' Then BW = '04) 1000-1249';

Else IF BirthWeight1{BTW} = '76503' Then BW = '03) 750 - 999';

Else IF BirthWeight1{BTW} = '76502' Then BW = '02) 500 - 749';

Else IF BirthWeight1{BTW} = '76501' Then BW = '01) < 500    ';

End;

Drop BTW;

Run;

*** Merge Hospital Trendwt ;
Data HWT; Set NIS.NIS_2014_Hospital; Run;

Data NIS.Core002; Merge NIS.Core001 HWT; By HOSP_NIS; Run;

*** Creat indicators and find number of observations with GA/BW ;
Data NIS.Core003;
	Set NIS.Core002;
		If GA NE ' ' Then GAC = 1;
			Else GAC = 0 ;
		If BW NE ' ' Then BWC = 1;
			Else BWC = 0 ;
Run;

Data NIS.CoreNB;
	Set NIS.Core003;
	Length PAY001 $ 18 RACE001 $ 26 FEMALE001 $ 12 DIED001 $ 12;
	Label PAY001 = 'Expected primary payer'
		  RACE001 = 'Race'
		  FEMALE001 = 'Gender'
		  DIED001 = 'DIED';

	IF PAY1 = 1 Then PAY001 = 'Medicare';
	ELSE IF PAY1 = 2 Then PAY001 = 'Medicaid';
	ELSE IF PAY1 = 3 Then PAY001 = 'Private insurance';
	ELSE IF PAY1 = 4 Then PAY001 = 'Self-pay';
	ELSE IF PAY1 = 5 Then PAY001 = 'No charge';
	ELSE IF PAY1 = 6 Then PAY001 = 'Other';
	ELSE IF PAY1 = . Then PAY001 = 'Missing';
	ELSE IF PAY1 = .A Then PAY001 = 'Invalid';
	ELSE IF PAY1 = .B Then PAY001 = 'Unavailable';

	IF RACE = 1 Then RACE001 = 'White';
	ELSE IF RACE = 2 Then RACE001 = 'Black';
	ELSE IF RACE = 3 Then RACE001 = 'Hispanic';
	ELSE IF RACE = 4 Then RACE001 = 'Asian or Pacific Islander';
	ELSE IF RACE = 5 Then RACE001 = 'Native American';
	ELSE IF RACE = 6 Then RACE001 = 'Other';
	ELSE IF RACE = . Then RACE001 = 'Missing';
	ELSE IF RACE = .A Then RACE001 = 'Invalid';
	ELSE IF RACE = .B Then RACE001 = 'Unavailable';

	IF FEMALE = 0 Then FEMALE001 = 'Male';
	ELSE IF FEMALE = 1 Then FEMALE001 = 'Female';
	ELSE IF FEMALE = . Then FEMALE001 = 'Missing';
	ELSE IF FEMALE = .A Then FEMALE001 = 'Invalid';
	ELSE IF FEMALE = .C Then FEMALE001 = 'Inconsistent';

	IF DIED = 0 Then DIED001 = 'Did not die';
	ELSE IF DIED = 1 Then DIED001 = 'Died';
	ELSE IF DIED = . Then DIED001 = 'Missing';
	ELSE IF DIED = .A Then DIED001 = 'Invalid';
	ELSE IF DIED = .B Then DIED001 = 'Unavailable ';
	
	If GAC = 1 AND BWC = 1 Then GABWC = 1;
		Else GABWC = 0 ;

	Array RespDS {15} DX1 DX2 DX3 DX4 DX5 DX6 DX7 DX8 DX9 DX10 DX11 DX12 DX13 DX14 DX15;
		Do RY = 1 to 15;
		IF RespDS{RY} = '769' Then RDS_1 = 1;
	End;
	Drop RY;

	If RDS_1 = 1 Then RDSI = 1;
	Else RDSI = 0;

	If NB = 1;
Run;

/*
Proc Export Data = Corenb
	Outfile = "D:\Dropbox\Dropbox\GWU\Practicum\Corenb.csv"
	Dbms = csv
	Replace;
Run;
*/

Proc Export Data = NIS.Corenb
	Outfile = "D:\YH666\Dropbox\HCUP\Project\DATA\NIS_2014\Corenb.csv"
	Dbms = csv
	Replace;
Run;

Proc Export Data = NIS.NIS_2014_Core
	Outfile = "D:\YH666\Dropbox\HCUP\Project\DATA\NIS_2014\nis2014.csv"
	Dbms = csv
	Replace;
Run;

Proc Sql;
	Select sum(GAC) As TotalGA,
	       sum(BWC) As TotalBW,
		   sum(GABWC) As TotalGABWC,
		   sum(RDSI) As TotalRDS
	From NIS.Corenb;
Quit;
