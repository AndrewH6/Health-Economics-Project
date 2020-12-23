****** Birth Weight ******;
Libname NIS 'D:\YH666\Dropbox\HCUP\Project\DATA\NIS_2014';
*** Include all Died and not Died ;
*** Dataset for non-missing BW information ;
Data BW001; Set NIS.CoreNB; If BWC = 1; Run;
*** Dataset for 
1) non-missing TOTCHG 
2) non-missing LOS
3) non-missing RDS
information (sorted by BW);
Data BW002; Set BW001; 
	If TOTCHG NE .;
	If LOS NE .;

	Array RespDS {15} DX1 DX2 DX3 DX4 DX5 DX6 DX7 DX8 DX9 DX10 DX11 DX12 DX13 DX14 DX15;
		Do RY = 1 to 15;
		IF RespDS{RY} = '769' Then RDS1 = 1;
	End;
	Drop RY;

	If RDS1 = 1 Then RDS = 1;
	Else RDS = 0;
Run;
Proc Sort Data = BW002 Out = BW003; By BW; Run;

*** Calculate Frequencies by BW ;
Proc Freq Data = BW003;
	Tables BW / out = BWfreq nocol nopercent nocum list;
Run;

*** Calculate RDS percentage by BW;
Proc Freq Data = BW003;
	Tables BW*RDS / out = BW_RDS1 nocol nopercent nocum list;
Run;

Data BW_RDS2 (Drop = RDS);
	Set BW_RDS1 (Rename = (Count = RDScount));
	If RDS = 1;
	Label RDScount = 'RDS cases';
Run;

Data BW_RDS3 (Drop = COUNT PERCENT RDScount);
	Merge BWfreq BW_RDS2;
	By BW;
	RDSpct = RDScount / Count;
	Label RDSpct = 'RDS (%)';
Run;

/* BW_RDS3 */

*** Calculate median, mean for TOTCHG by GA;
Proc Means Data = BW003;
	Var TOTCHG;
	Class BW;
	Output Out = BWmeans_TOTCHG1 mean = mean median = median;
Run;

Data BWmeans_TOTCHG2 (Keep = BW _FREQ_ mean_totchg median_totchg);
	Set BWmeans_TOTCHG1;
	If _TYPE_ = 1;
	mean_totchg = mean;
	median_totchg = median;
	Label mean_totchg = 'Mean Total Charge'
		  median_totchg = 'Median Total Charge'
		  _FREQ_ = 'N';
Run;

/* BWmeans_TOTCHG2 */

*** Calculate median, mean for TOTCHG by LOS;
Proc Means Data = BW003;
	Var LOS;
	Class BW;
	Output Out = BWmeans_LOS1 mean = mean median = median;
Run;

Data BWmeans_LOS2 (Keep = BW _FREQ_ mean_los median_los);
	Set BWmeans_LOS1;
	If _TYPE_ = 1;
	mean_los = mean;
	median_los = median;
	Label mean_los = 'Mean Length of Stay'
		  median_los = 'Median Length of Stay'
		  _FREQ_ = 'N';
Run;

/* GAmeans_LOS2 */

*** Combined ;

Data BW_Table1(Drop = COUNT PERCENT);
	Merge BWfreq BWmeans_TOTCHG2;
	By BW;
Run;

Data BW_Table2;
	Merge BW_Table1 BWmeans_LOS2;
	By BW;
Run;

Data BW_Table3;
	Merge BW_Table2 BW_RDS3;
	By BW;
Run;

*** Generate BW * PAY1 Table;
Data BW_PAY1_1;
	Set BW003;
	
	Length PAY001 $ 18;
	Label PAY001 = 'Expected primary payer';

	IF PAY1 = 1 Then PAY001 = 'Medicare';
	ELSE IF PAY1 = 2 Then PAY001 = 'Medicaid';
	ELSE IF PAY1 = 3 Then PAY001 = 'Private insurance';
	ELSE IF PAY1 = 4 Then PAY001 = 'Self-pay';
	ELSE IF PAY1 = 5 Then PAY001 = 'No charge';
	ELSE IF PAY1 = 6 Then PAY001 = 'Other';
	ELSE IF PAY1 = . Then PAY001 = 'Missing';
	ELSE IF PAY1 = .A Then PAY001 = 'Invalid';
	ELSE IF PAY1 = .B Then PAY001 = 'Unavailable';
Run;

Proc Freq Data = BW_PAY1_1;
	Tables BW*PAY001 / out = BW_PAY1_freq1 nocol nopercent nocum list;
Run;

Data BWname(Drop = Percent);
	Set BWfreq;
	SubTotal = Count;
Run;

Data PAY1name;
	Input PAY001 $ 18.;
Datalines;
Medicare
Medicaid
Private insurance
Self-pay
No charge
Other
Missing
Invalid
Unavailable
;
Run;

Proc SQL;
	Create Table P1_Merge1 As
		Select * From BWname
		Cross Join PAY1name;
Quit;

Proc Sort Data = P1_Merge1 Out = P1_Merge2; By BW PAY001; Run;

Data P1_Merge3;
	Set P1_Merge2;
	Count = 0;
Run;

Data BW_PAY1_freq2(Drop = Percent COUNT SubTotal);
	Merge P1_Merge3 BW_PAY1_freq1;
	By BW PAY001;
	Format Grouppct 6.3;
	Grouppct = (COUNT / SubTotal) * 100;
	Label Grouppct = 'Group Percentage (%)';
Run;

Proc Transpose Data = BW_PAY1_freq2
			   Out = BW_PAY1_TSP;
	By BW;
	ID PAY001;
Run;

Data BW_PAY1_Table;
	Set BW_PAY1_TSP(Drop = _NAME_ _LABEL_);
	Label BW = 'Birth Weight Group'
		  Invalid = 'Invalid (%)'
		  Medicaid = 'Medicaid (%)'
		  Medicare = 'Medicare (%)'
          Missing = 'Missing (%)'
		  No_charge = 'No Charge (%)'
		  Other = 'Other (%)'
		  Private_insurance = 'Private Insurance (%)'
		  Self_pay = 'Self-pay (%)'
		  Unavailable = 'Unavailable (%)';
Run;

*** Generate BW * RACE Table;

Data BW_RACE_1;
	Set BW003;
	
	Length RACE001 $ 26;
	Label RACE001 = 'Race';

	IF RACE = 1 Then RACE001 = 'White';
	ELSE IF RACE = 2 Then RACE001 = 'Black';
	ELSE IF RACE = 3 Then RACE001 = 'Hispanic';
	ELSE IF RACE = 4 Then RACE001 = 'Asian or Pacific Islander';
	ELSE IF RACE = 5 Then RACE001 = 'Native American';
	ELSE IF RACE = 6 Then RACE001 = 'Other';
	ELSE IF RACE = . Then RACE001 = 'Missing';
	ELSE IF RACE = .A Then RACE001 = 'Invalid';
	ELSE IF RACE = .B Then RACE001 = 'Unavailable';
Run;

Proc Freq Data = BW_RACE_1;
	Tables BW*RACE001 / out = BW_RACE_freq1 nocol nopercent nocum list;
Run;

Data BWname(Drop = Percent);
	Set BWfreq;
	SubTotal = Count;
Run;

Data RACEname;
	Input RACE001 $ 26.;
Datalines;
White
Black
Hispanic
Asian or Pacific Islander
Native American
Other
Missing
Invalid
Unavailable
;
Run;

Proc SQL;
	Create Table RACE_Merge1 As
		Select * From BWname
		Cross Join RACEname;
Quit;

Proc Sort Data = RACE_Merge1 Out = RACE_Merge2; By BW RACE001; Run;

Data RACE_Merge3;
	Set RACE_Merge2;
	Count = 0;
Run;

Data BW_RACE_freq2(Drop = Percent COUNT SubTotal);
	Merge RACE_Merge3 BW_RACE_freq1;
	By BW RACE001;
	Format Grouppct 6.3;
	Grouppct = (COUNT / SubTotal) * 100;
	Label Grouppct = 'Group Percentage (%)';
Run;

Proc Transpose Data = BW_RACE_freq2
			   Out = BW_RACE_TSP;
	By BW;
	ID RACE001;
Run;

Data BW_RACE_Table;
	Set BW_RACE_TSP(Drop = _NAME_ _LABEL_);
	Label BW = 'Birth Weight Group'
		  White = 'White (%)'
		  Black = 'Black (%)'
		  Hispanic = 'Hispanic (%)'
          Missing = 'Missing (%)'
		  Asian_or_Pacific_Islander = 'Asian or Pacific Islander (%)'
		  Other = 'Other (%)'
		  Native_American = 'Native American (%)'
		  Invalid = 'Invalid (%)'
		  Unavailable = 'Unavailable (%)';
Run;

*** Generate GA * FEMALE Table;

Data BW_FEMALE_1;
	Set BW003;
	
	Length FEMALE001 $ 12;
	Label FEMALE001 = 'Gender';

	IF FEMALE = 0 Then FEMALE001 = 'Male';
	ELSE IF FEMALE = 1 Then FEMALE001 = 'Female';
	ELSE IF FEMALE = . Then FEMALE001 = 'Missing';
	ELSE IF FEMALE = .A Then FEMALE001 = 'Invalid';
	ELSE IF FEMALE = .C Then FEMALE001 = 'Inconsistent';
Run;

Proc Freq Data = BW_FEMALE_1;
	Tables BW*FEMALE001 / out = BW_FEMALE_freq1 nocol nopercent nocum list;
Run;

Data BWname(Drop = Percent);
	Set BWfreq;
	SubTotal = Count;
Run;

Data FEMALEname;
	Input FEMALE001 $ 12.;
Datalines;
Male
Female
Missing
Invalid
Inconsistent
;
Run;

Proc SQL;
	Create Table FEMALE_Merge1 As
		Select * From BWname
		Cross Join FEMALEname;
Quit;

Proc Sort Data = FEMALE_Merge1 Out = FEMALE_Merge2; By BW FEMALE001; Run;

Data FEMALE_Merge3;
	Set FEMALE_Merge2;
	Count = 0;
Run;

Data BW_FEMALE_freq2(Drop = Percent COUNT SubTotal);
	Merge FEMALE_Merge3 BW_FEMALE_freq1;
	By BW FEMALE001;
	Format Grouppct 6.3;
	Grouppct = (COUNT / SubTotal) * 100;
	Label Grouppct = 'Group Percentage (%)';
Run;

Proc Transpose Data = BW_FEMALE_freq2
			   Out = BW_FEMALE_TSP;
	By BW;
	ID FEMALE001;
Run;

Data BW_FEMALE_Table;
	Set BW_FEMALE_TSP(Drop = _NAME_ _LABEL_);
	Label BW = 'Birth Weight Group'
		  Male = 'Male (%)'
		  Female = 'Female (%)'
          Missing = 'Missing (%)'
		  Invalid = 'Invalid (%)'
		  Inconsistent = 'Inconsistent (%)';
Run;

*** Generate BW * DIED Table;
Data BW_DIED_1;
	Set BW003;
	
	Length DIED001 $ 12;
	Label DIED001 = 'DIED';

	IF DIED = 0 Then DIED001 = 'Did not die';
	ELSE IF DIED = 1 Then DIED001 = 'Died';
	ELSE IF DIED = . Then DIED001 = 'Missing';
	ELSE IF DIED = .A Then DIED001 = 'Invalid';
	ELSE IF DIED = .B Then DIED001 = 'Unavailable ';
Run;

Proc Freq Data = BW_DIED_1;
	Tables BW*DIED001 / out = BW_DIED_freq1 nocol nopercent nocum list;
Run;

Data BWname(Drop = Percent);
	Set BWfreq;
	SubTotal = Count;
Run;

Data DIEDname;
	Input DIED001 $ 12.;
Datalines;
Did not die
Died
Missing
Invalid
Unavailable
;
Run;

Proc SQL;
	Create Table DIED_Merge1 As
		Select * From BWname
		Cross Join DIEDname;
Quit;

Proc Sort Data = DIED_Merge1 Out = DIED_Merge2; By BW DIED001; Run;

Data DIED_Merge3;
	Set DIED_Merge2;
	Count = 0;
Run;

Data BW_DIED_freq2(Drop = Percent COUNT SubTotal);
	Merge DIED_Merge3 BW_DIED_freq1;
	By BW DIED001;
	Format Grouppct 6.3;
	Grouppct = (COUNT / SubTotal) * 100;
	Label Grouppct = 'Group Percentage (%)';
Run;

Proc Transpose Data = BW_DIED_freq2
			   Out = BW_DIED_TSP;
	By BW;
	ID DIED001;
Run;

Data BW_DIED_Table;
	Set BW_DIED_TSP(Drop = _NAME_ _LABEL_);
	Label BW = 'Birth Weight Group'
		  Did_not_die = 'Did not die (%)'
		  Died = 'Died (%)'
          Missing = 'Missing (%)'
		  Invalid = 'Invalid (%)'
		  Unavailable  = 'Unavailable (%)';
Run;


*** Include only Surviving;
*** Dataset for non-missing GA information ;
Data BW001; Set Core003; If BWC = 1; Run;
*** Dataset for 
1) non-missing TOTCHG 
2) non-missing LOS
3) non-missing RDS
information (sorted by GA);
Data BW002_Surviving; Set BW001; 
	If TOTCHG NE .;
	If LOS NE .;
	If DIED = 0;
	Array RespDS {15} DX1 DX2 DX3 DX4 DX5 DX6 DX7 DX8 DX9 DX10 DX11 DX12 DX13 DX14 DX15;
		Do RY = 1 to 15;
		IF RespDS{RY} = '769' Then RDS1 = 1;
	End;
	Drop RY;

	If RDS1 = 1 Then RDS = 1;
	Else RDS = 0;
Run;
Proc Sort Data = BW002_Surviving Out = BW003_Surviving; By BW; Run;

*** Calculate Frequencies by BW ;
Proc Freq Data = BW003_Surviving;
	Tables BW / out = BWfreq_Surviving nocol nopercent nocum list;
Run;

*** Calculate RDS percentage by BW;
Proc Freq Data = BW003_Surviving;
	Tables BW*RDS / out = BW_RDS1_Surviving nocol nopercent nocum list;
Run;

Data BW_RDS2_Surviving (Drop = RDS);
	Set BW_RDS1_Surviving (Rename = (Count = RDScount));
	If RDS = 1;
	Label RDScount = 'RDS cases';
Run;

Data BW_RDS3_Surviving (Drop = COUNT PERCENT RDScount);
	Merge BWfreq_Surviving BW_RDS2_Surviving;
	By BW;
	RDSpct = RDScount / Count;
	Label RDSpct = 'RDS (%)';
Run;

/* BW_RDS3 */

*** Calculate median, mean for TOTCHG by BW;
Proc Means Data = BW003_Surviving;
	Var TOTCHG;
	Class BW;
	Output Out = BWmeans_TOTCHG1_Surviving mean = mean median = median;
Run;

Data BWmeans_TOTCHG2_Surviving (Keep = BW _FREQ_ mean_totchg median_totchg);
	Set BWmeans_TOTCHG1_Surviving;
	If _TYPE_ = 1;
	mean_totchg = mean;
	median_totchg = median;
	Label mean_totchg = 'Mean Total Charge'
		  median_totchg = 'Median Total Charge'
		  _FREQ_ = 'N';
Run;

/* BWmeans_TOTCHG2 */

*** Calculate median, mean for TOTCHG by LOS;
Proc Means Data = BW003_Surviving;
	Var LOS;
	Class BW;
	Output Out = BWmeans_LOS1_Surviving mean = mean median = median;
Run;

Data BWmeans_LOS2_Surviving (Keep = BW _FREQ_ mean_los median_los);
	Set BWmeans_LOS1_Surviving;
	If _TYPE_ = 1;
	mean_los = mean;
	median_los = median;
	Label mean_los = 'Mean Length of Stay'
		  median_los = 'Median Length of Stay'
		  _FREQ_ = 'N';
Run;

/* BWmeans_LOS2 */

*** Combined ;

Data BW_Table1_Surviving(Drop = COUNT PERCENT);
	Merge BWfreq_Surviving BWmeans_TOTCHG2_Surviving;
	By BW;
Run;

Data BW_Table2_Surviving;
	Merge BW_Table1_Surviving BWmeans_LOS2_Surviving;
	By BW;
Run;

Data BW_Table3_Surviving;
	Merge BW_Table2_Surviving BW_RDS3_Surviving;
	By BW;
Run;

*** Generate BW * PAY1 Table;
Data BW_PAY1_1_Surviving;
	Set BW003_Surviving;
	
	Length PAY001 $ 18;
	Label PAY001 = 'Expected primary payer';

	IF PAY1 = 1 Then PAY001 = 'Medicare';
	ELSE IF PAY1 = 2 Then PAY001 = 'Medicaid';
	ELSE IF PAY1 = 3 Then PAY001 = 'Private insurance';
	ELSE IF PAY1 = 4 Then PAY001 = 'Self-pay';
	ELSE IF PAY1 = 5 Then PAY001 = 'No charge';
	ELSE IF PAY1 = 6 Then PAY001 = 'Other';
	ELSE IF PAY1 = . Then PAY001 = 'Missing';
	ELSE IF PAY1 = .A Then PAY001 = 'Invalid';
	ELSE IF PAY1 = .B Then PAY001 = 'Unavailable';
Run;

Proc Freq Data = BW_PAY1_1_Surviving;
	Tables BW*PAY001 / out = BW_PAY1_freq1_Surviving nocol nopercent nocum list;
Run;

Data BWname_Surviving(Drop = Percent);
	Set BWfreq_Surviving;
	SubTotal = Count;
Run;

Data PAY1name_Surviving;
	Input PAY001 $ 18.;
Datalines;
Medicare
Medicaid
Private insurance
Self-pay
No charge
Other
Missing
Invalid
Unavailable
;
Run;

Proc SQL;
	Create Table P1_Merge1_Surviving As
		Select * From BWname_Surviving
		Cross Join PAY1name_Surviving;
Quit;

Proc Sort Data = P1_Merge1_Surviving Out = P1_Merge2_Surviving; By BW PAY001; Run;

Data P1_Merge3_Surviving;
	Set P1_Merge2_Surviving;
	Count = 0;
Run;

Data BW_PAY1_freq2_Surviving(Drop = Percent COUNT SubTotal);
	Merge P1_Merge3_Surviving BW_PAY1_freq1_Surviving;
	By BW PAY001;
	Format Grouppct 6.3;
	Grouppct = (COUNT / SubTotal) * 100;
	Label Grouppct = 'Group Percentage (%)';
Run;

Proc Transpose Data = BW_PAY1_freq2_Surviving
			   Out = BW_PAY1_TSP_Surviving;
	By BW;
	ID PAY001;
Run;

Data BW_PAY1_Table_Surviving;
	Set BW_PAY1_TSP_Surviving(Drop = _NAME_ _LABEL_);
	Label BW = 'Birth Weight Group'
		  Invalid = 'Invalid (%)'
		  Medicaid = 'Medicaid (%)'
		  Medicare = 'Medicare (%)'
          Missing = 'Missing (%)'
		  No_charge = 'No Charge (%)'
		  Other = 'Other (%)'
		  Private_insurance = 'Private Insurance (%)'
		  Self_pay = 'Self-pay (%)'
		  Unavailable = 'Unavailable (%)';
Run;

*** Generate GA * RACE Table;

Data BW_RACE_1_Surviving;
	Set BW003_Surviving;
	
	Length RACE001 $ 26;
	Label RACE001 = 'Race';

	IF RACE = 1 Then RACE001 = 'White';
	ELSE IF RACE = 2 Then RACE001 = 'Black';
	ELSE IF RACE = 3 Then RACE001 = 'Hispanic';
	ELSE IF RACE = 4 Then RACE001 = 'Asian or Pacific Islander';
	ELSE IF RACE = 5 Then RACE001 = 'Native American';
	ELSE IF RACE = 6 Then RACE001 = 'Other';
	ELSE IF RACE = . Then RACE001 = 'Missing';
	ELSE IF RACE = .A Then RACE001 = 'Invalid';
	ELSE IF RACE = .B Then RACE001 = 'Unavailable';
Run;

Proc Freq Data = BW_RACE_1_Surviving;
	Tables BW*RACE001 / out = BW_RACE_freq1_Surviving nocol nopercent nocum list;
Run;

Data BWname_Surviving(Drop = Percent);
	Set BWfreq_Surviving;
	SubTotal = Count;
Run;

Data RACEname_Surviving;
	Input RACE001 $ 26.;
Datalines;
White
Black
Hispanic
Asian or Pacific Islander
Native American
Other
Missing
Invalid
Unavailable
;
Run;

Proc SQL;
	Create Table RACE_Merge1_Surviving As
		Select * From BWname_Surviving
		Cross Join RACEname_Surviving;
Quit;

Proc Sort Data = RACE_Merge1_Surviving Out = RACE_Merge2_Surviving; By BW RACE001; Run;

Data RACE_Merge3_Surviving;
	Set RACE_Merge2_Surviving;
	Count = 0;
Run;

Data BW_RACE_freq2_Surviving(Drop = Percent COUNT SubTotal);
	Merge RACE_Merge3_Surviving BW_RACE_freq1_Surviving;
	By BW RACE001;
	Format Grouppct 6.3;
	Grouppct = (COUNT / SubTotal) * 100;
	Label Grouppct = 'Group Percentage (%)';
Run;

Proc Transpose Data = BW_RACE_freq2_Surviving
			   Out = BW_RACE_TSP_Surviving;
	By BW;
	ID RACE001;
Run;

Data BW_RACE_Table_Surviving;
	Set BW_RACE_TSP_Surviving(Drop = _NAME_ _LABEL_);
	Label BW = 'Birth Weight Group'
		  White = 'White (%)'
		  Black = 'Black (%)'
		  Hispanic = 'Hispanic (%)'
          Missing = 'Missing (%)'
		  Asian_or_Pacific_Islander = 'Asian or Pacific Islander (%)'
		  Other = 'Other (%)'
		  Native_American = 'Native American (%)'
		  Invalid = 'Invalid (%)'
		  Unavailable = 'Unavailable (%)';
Run;

*** Generate BW * FEMALE Table;

Data BW_FEMALE_1_Surviving;
	Set BW003_Surviving;
	
	Length FEMALE001 $ 12;
	Label FEMALE001 = 'Gender';

	IF FEMALE = 0 Then FEMALE001 = 'Male';
	ELSE IF FEMALE = 1 Then FEMALE001 = 'Female';
	ELSE IF FEMALE = . Then FEMALE001 = 'Missing';
	ELSE IF FEMALE = .A Then FEMALE001 = 'Invalid';
	ELSE IF FEMALE = .C Then FEMALE001 = 'Inconsistent';
Run;

Proc Freq Data = BW_FEMALE_1_Surviving;
	Tables BW*FEMALE001 / out = BW_FEMALE_freq1_Surviving nocol nopercent nocum list;
Run;

Data BWname_Surviving(Drop = Percent);
	Set BWfreq_Surviving;
	SubTotal = Count;
Run;

Data FEMALEname_Surviving;
	Input FEMALE001 $ 12.;
Datalines;
Male
Female
Missing
Invalid
Inconsistent
;
Run;

Proc SQL;
	Create Table FEMALE_Merge1_Surviving As
		Select * From BWname_Surviving
		Cross Join FEMALEname_Surviving;
Quit;

Proc Sort Data = FEMALE_Merge1_Surviving Out = FEMALE_Merge2_Surviving; By BW FEMALE001; Run;

Data FEMALE_Merge3_Surviving;
	Set FEMALE_Merge2_Surviving;
	Count = 0;
Run;

Data BW_FEMALE_freq2_Surviving(Drop = Percent COUNT SubTotal);
	Merge FEMALE_Merge3_Surviving BW_FEMALE_freq1_Surviving;
	By BW FEMALE001;
	Format Grouppct 6.3;
	Grouppct = (COUNT / SubTotal) * 100;
	Label Grouppct = 'Group Percentage (%)';
Run;

Proc Transpose Data = BW_FEMALE_freq2_Surviving
			   Out = BW_FEMALE_TSP_Surviving;
	By BW;
	ID FEMALE001;
Run;

Data BW_FEMALE_Table_Surviving;
	Set BW_FEMALE_TSP_Surviving(Drop = _NAME_ _LABEL_);
	Label BW = 'Birth Weight Group'
		  Male = 'Male (%)'
		  Female = 'Female (%)'
          Missing = 'Missing (%)'
		  Invalid = 'Invalid (%)'
		  Inconsistent = 'Inconsistent (%)';
Run;

*** Merge Table;

Data BW_Table_Surviving;
	Merge BWmeans_los2_Surviving BWmeans_totchg2_Surviving;
	By BW;
Run;
