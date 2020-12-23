****** Gestational Age ******;
Libname NIS 'D:\YH666\Dropbox\HCUP\Project\DATA\NIS_2014';
*** Include all Died and not Died ;
*** Dataset for non-missing GA information ;
Data GA001; Set NIS.CoreNB; If GAC = 1; Run;
*** Dataset for 
1) non-missing TOTCHG 
2) non-missing LOS
3) non-missing RDS
information (sorted by GA);
Data GA002; Set GA001; 
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
Proc Sort Data = GA002 Out = GA003; By GA; Run;

*** Calculate Frequencies by GA ;
Proc Freq Data = GA003;
	Tables GA / out = GAfreq nocol nopercent nocum list;
Run;

*** Calculate RDS percentage by GA;
Proc Freq Data = GA003;
	Tables GA*RDS / out = GA_RDS1 nocol nopercent nocum list;
Run;

Data GA_RDS2 (Drop = RDS);
	Set GA_RDS1 (Rename = (Count = RDScount));
	If RDS = 1;
	Label RDScount = 'RDS cases';
Run;

Data GA_RDS3 (Drop = COUNT PERCENT RDScount);
	Merge GAfreq GA_RDS2;
	By GA;
	RDSpct = RDScount / Count;
	Label RDSpct = 'RDS (%)';
Run;

/* GA_RDS3 */

*** Calculate median, mean for TOTCHG by GA;
Proc Means Data = GA003;
	Var TOTCHG;
	Class GA;
	Output Out = GAmeans_TOTCHG1 mean = mean median = median;
Run;

Data GAmeans_TOTCHG2 (Keep = GA _FREQ_ mean_totchg median_totchg);
	Set GAmeans_TOTCHG1;
	If _TYPE_ = 1;
	mean_totchg = mean;
	median_totchg = median;
	Label mean_totchg = 'Mean Total Charge'
		  median_totchg = 'Median Total Charge'
		  _FREQ_ = 'N';
Run;

/* GAmeans_TOTCHG2 */

*** Calculate median, mean for TOTCHG by LOS;
Proc Means Data = GA003;
	Var LOS;
	Class GA;
	Output Out = GAmeans_LOS1 mean = mean median = median;
Run;

Data GAmeans_LOS2 (Keep = GA _FREQ_ mean_los median_los);
	Set GAmeans_LOS1;
	If _TYPE_ = 1;
	mean_los = mean;
	median_los = median;
	Label mean_los = 'Mean Length of Stay'
		  median_los = 'Median Length of Stay'
		  _FREQ_ = 'N';
Run;

/* GAmeans_LOS2 */

*** Combined ;

Data GA_Table1(Drop = COUNT PERCENT);
	Merge GAfreq GAmeans_TOTCHG2;
	By GA;
Run;

Data GA_Table2;
	Merge GA_Table1 GAmeans_LOS2;
	By GA;
Run;

Data GA_Table3;
	Merge GA_Table2 GA_RDS3;
	By GA;
Run;

*** Generate GA * PAY1 Table;
Data GA_PAY1_1;
	Set GA003;
	
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

Proc Freq Data = GA_PAY1_1;
	Tables GA*PAY001 / out = GA_PAY1_freq1 nocol nopercent nocum list;
Run;

Data GAname(Drop = Percent);
	Set GAfreq;
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
		Select * From GAname
		Cross Join PAY1name;
Quit;

Proc Sort Data = P1_Merge1 Out = P1_Merge2; By GA PAY001; Run;

Data P1_Merge3;
	Set P1_Merge2;
	Count = 0;
Run;

Data GA_PAY1_freq2(Drop = Percent COUNT SubTotal);
	Merge P1_Merge3 GA_PAY1_freq1;
	By GA PAY001;
	Format Grouppct 6.3;
	Grouppct = (COUNT / SubTotal) * 100;
	Label Grouppct = 'Group Percentage (%)';
Run;

Proc Transpose Data = GA_PAY1_freq2
			   Out = GA_PAY1_TSP;
	By GA;
	ID PAY001;
Run;

Data GA_PAY1_Table;
	Set GA_PAY1_TSP(Drop = _NAME_ _LABEL_);
	Label GA = 'Gestational Age Group'
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

Data GA_RACE_1;
	Set GA003;
	
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

Proc Freq Data = GA_RACE_1;
	Tables GA*RACE001 / out = GA_RACE_freq1 nocol nopercent nocum list;
Run;

Data GAname(Drop = Percent);
	Set GAfreq;
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
		Select * From GAname
		Cross Join RACEname;
Quit;

Proc Sort Data = RACE_Merge1 Out = RACE_Merge2; By GA RACE001; Run;

Data RACE_Merge3;
	Set RACE_Merge2;
	Count = 0;
Run;

Data GA_RACE_freq2(Drop = Percent COUNT SubTotal);
	Merge RACE_Merge3 GA_RACE_freq1;
	By GA RACE001;
	Format Grouppct 6.3;
	Grouppct = (COUNT / SubTotal) * 100;
	Label Grouppct = 'Group Percentage (%)';
Run;

Proc Transpose Data = GA_RACE_freq2
			   Out = GA_RACE_TSP;
	By GA;
	ID RACE001;
Run;

Data GA_RACE_Table;
	Set GA_RACE_TSP(Drop = _NAME_ _LABEL_);
	Label GA = 'Gestational Age Group'
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

Data GA_FEMALE_1;
	Set GA003;
	
	Length FEMALE001 $ 12;
	Label FEMALE001 = 'Gender';

	IF FEMALE = 0 Then FEMALE001 = 'Male';
	ELSE IF FEMALE = 1 Then FEMALE001 = 'Female';
	ELSE IF FEMALE = . Then FEMALE001 = 'Missing';
	ELSE IF FEMALE = .A Then FEMALE001 = 'Invalid';
	ELSE IF FEMALE = .C Then FEMALE001 = 'Inconsistent';
Run;

Proc Freq Data = GA_FEMALE_1;
	Tables GA*FEMALE001 / out = GA_FEMALE_freq1 nocol nopercent nocum list;
Run;

Data GAname(Drop = Percent);
	Set GAfreq;
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
		Select * From GAname
		Cross Join FEMALEname;
Quit;

Proc Sort Data = FEMALE_Merge1 Out = FEMALE_Merge2; By GA FEMALE001; Run;

Data FEMALE_Merge3;
	Set FEMALE_Merge2;
	Count = 0;
Run;

Data GA_FEMALE_freq2(Drop = Percent COUNT SubTotal);
	Merge FEMALE_Merge3 GA_FEMALE_freq1;
	By GA FEMALE001;
	Format Grouppct 6.3;
	Grouppct = (COUNT / SubTotal) * 100;
	Label Grouppct = 'Group Percentage (%)';
Run;

Proc Transpose Data = GA_FEMALE_freq2
			   Out = GA_FEMALE_TSP;
	By GA;
	ID FEMALE001;
Run;

Data GA_FEMALE_Table;
	Set GA_FEMALE_TSP(Drop = _NAME_ _LABEL_);
	Label GA = 'Gestational Age Group'
		  Male = 'Male (%)'
		  Female = 'Female (%)'
          Missing = 'Missing (%)'
		  Invalid = 'Invalid (%)'
		  Inconsistent = 'Inconsistent (%)';
Run;

*** Generate GA * DIED Table;
Data GA_DIED_1;
	Set GA003;
	
	Length DIED001 $ 12;
	Label DIED001 = 'DIED';

	IF DIED = 0 Then DIED001 = 'Did not die';
	ELSE IF DIED = 1 Then DIED001 = 'Died';
	ELSE IF DIED = . Then DIED001 = 'Missing';
	ELSE IF DIED = .A Then DIED001 = 'Invalid';
	ELSE IF DIED = .B Then DIED001 = 'Unavailable ';
Run;

Proc Freq Data = GA_DIED_1;
	Tables GA*DIED001 / out = GA_DIED_freq1 nocol nopercent nocum list;
Run;

Data GAname(Drop = Percent);
	Set GAfreq;
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
		Select * From GAname
		Cross Join DIEDname;
Quit;

Proc Sort Data = DIED_Merge1 Out = DIED_Merge2; By GA DIED001; Run;

Data DIED_Merge3;
	Set DIED_Merge2;
	Count = 0;
Run;

Data GA_DIED_freq2(Drop = Percent COUNT SubTotal);
	Merge DIED_Merge3 GA_DIED_freq1;
	By GA DIED001;
	Format Grouppct 6.3;
	Grouppct = (COUNT / SubTotal) * 100;
	Label Grouppct = 'Group Percentage (%)';
Run;

Proc Transpose Data = GA_DIED_freq2
			   Out = GA_DIED_TSP;
	By GA;
	ID DIED001;
Run;

Data GA_DIED_Table;
	Set GA_DIED_TSP(Drop = _NAME_ _LABEL_);
	Label GA = 'Gestational Age Group'
		  Did_not_die = 'Did not die (%)'
		  Died = 'Died (%)'
          Missing = 'Missing (%)'
		  Invalid = 'Invalid (%)'
		  Unavailable  = 'Unavailable (%)';
Run;


*** Include only Surviving;
*** Dataset for non-missing GA information ;
Data GA001; Set Core003; If GAC = 1; Run;
*** Dataset for 
1) non-missing TOTCHG 
2) non-missing LOS
3) non-missing RDS
information (sorted by GA);
Data GA002_Surviving; Set GA001; 
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
Proc Sort Data = GA002_Surviving Out = GA003_Surviving; By GA; Run;

*** Calculate Frequencies by GA ;
Proc Freq Data = GA003_Surviving;
	Tables GA / out = GAfreq_Surviving nocol nopercent nocum list;
Run;

*** Calculate RDS percentage by GA;
Proc Freq Data = GA003_Surviving;
	Tables GA*RDS / out = GA_RDS1_Surviving nocol nopercent nocum list;
Run;

Data GA_RDS2_Surviving (Drop = RDS);
	Set GA_RDS1_Surviving (Rename = (Count = RDScount));
	If RDS = 1;
	Label RDScount = 'RDS cases';
Run;

Data GA_RDS3_Surviving (Drop = COUNT PERCENT RDScount);
	Merge GAfreq_Surviving GA_RDS2_Surviving;
	By GA;
	RDSpct = RDScount / Count;
	Label RDSpct = 'RDS (%)';
Run;

/* GA_RDS3 */

*** Calculate median, mean for TOTCHG by GA;
Proc Means Data = GA003_Surviving;
	Var TOTCHG;
	Class GA;
	Output Out = GAmeans_TOTCHG1_Surviving mean = mean median = median;
Run;

Data GAmeans_TOTCHG2_Surviving (Keep = GA _FREQ_ mean_totchg median_totchg);
	Set GAmeans_TOTCHG1_Surviving;
	If _TYPE_ = 1;
	mean_totchg = mean;
	median_totchg = median;
	Label mean_totchg = 'Mean Total Charge'
		  median_totchg = 'Median Total Charge'
		  _FREQ_ = 'N';
Run;

/* GAmeans_TOTCHG2 */

*** Calculate median, mean for TOTCHG by LOS;
Proc Means Data = GA003_Surviving;
	Var LOS;
	Class GA;
	Output Out = GAmeans_LOS1_Surviving mean = mean median = median;
Run;

Data GAmeans_LOS2_Surviving (Keep = GA _FREQ_ mean_los median_los);
	Set GAmeans_LOS1_Surviving;
	If _TYPE_ = 1;
	mean_los = mean;
	median_los = median;
	Label mean_los = 'Mean Length of Stay'
		  median_los = 'Median Length of Stay'
		  _FREQ_ = 'N';
Run;

/* GAmeans_LOS2 */

*** Combined ;

Data GA_Table1_Surviving(Drop = COUNT PERCENT);
	Merge GAfreq_Surviving GAmeans_TOTCHG2_Surviving;
	By GA;
Run;

Data GA_Table2_Surviving;
	Merge GA_Table1_Surviving GAmeans_LOS2_Surviving;
	By GA;
Run;

Data GA_Table3_Surviving;
	Merge GA_Table2_Surviving GA_RDS3_Surviving;
	By GA;
Run;

*** Generate GA * PAY1 Table;
Data GA_PAY1_1_Surviving;
	Set GA003_Surviving;
	
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

Proc Freq Data = GA_PAY1_1_Surviving;
	Tables GA*PAY001 / out = GA_PAY1_freq1_Surviving nocol nopercent nocum list;
Run;

Data GAname_Surviving(Drop = Percent);
	Set GAfreq_Surviving;
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
		Select * From GAname_Surviving
		Cross Join PAY1name_Surviving;
Quit;

Proc Sort Data = P1_Merge1_Surviving Out = P1_Merge2_Surviving; By GA PAY001; Run;

Data P1_Merge3_Surviving;
	Set P1_Merge2_Surviving;
	Count = 0;
Run;

Data GA_PAY1_freq2_Surviving(Drop = Percent COUNT SubTotal);
	Merge P1_Merge3_Surviving GA_PAY1_freq1_Surviving;
	By GA PAY001;
	Format Grouppct 6.3;
	Grouppct = (COUNT / SubTotal) * 100;
	Label Grouppct = 'Group Percentage (%)';
Run;

Proc Transpose Data = GA_PAY1_freq2_Surviving
			   Out = GA_PAY1_TSP_Surviving;
	By GA;
	ID PAY001;
Run;

Data GA_PAY1_Table_Surviving;
	Set GA_PAY1_TSP_Surviving(Drop = _NAME_ _LABEL_);
	Label GA = 'Gestational Age Group'
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

Data GA_RACE_1_Surviving;
	Set GA003_Surviving;
	
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

Proc Freq Data = GA_RACE_1_Surviving;
	Tables GA*RACE001 / out = GA_RACE_freq1_Surviving nocol nopercent nocum list;
Run;

Data GAname_Surviving(Drop = Percent);
	Set GAfreq_Surviving;
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
		Select * From GAname_Surviving
		Cross Join RACEname_Surviving;
Quit;

Proc Sort Data = RACE_Merge1_Surviving Out = RACE_Merge2_Surviving; By GA RACE001; Run;

Data RACE_Merge3_Surviving;
	Set RACE_Merge2_Surviving;
	Count = 0;
Run;

Data GA_RACE_freq2_Surviving(Drop = Percent COUNT SubTotal);
	Merge RACE_Merge3_Surviving GA_RACE_freq1_Surviving;
	By GA RACE001;
	Format Grouppct 6.3;
	Grouppct = (COUNT / SubTotal) * 100;
	Label Grouppct = 'Group Percentage (%)';
Run;

Proc Transpose Data = GA_RACE_freq2_Surviving
			   Out = GA_RACE_TSP_Surviving;
	By GA;
	ID RACE001;
Run;

Data GA_RACE_Table_Surviving;
	Set GA_RACE_TSP_Surviving(Drop = _NAME_ _LABEL_);
	Label GA = 'Gestational Age Group'
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

Data GA_FEMALE_1_Surviving;
	Set GA003_Surviving;
	
	Length FEMALE001 $ 12;
	Label FEMALE001 = 'Gender';

	IF FEMALE = 0 Then FEMALE001 = 'Male';
	ELSE IF FEMALE = 1 Then FEMALE001 = 'Female';
	ELSE IF FEMALE = . Then FEMALE001 = 'Missing';
	ELSE IF FEMALE = .A Then FEMALE001 = 'Invalid';
	ELSE IF FEMALE = .C Then FEMALE001 = 'Inconsistent';
Run;

Proc Freq Data = GA_FEMALE_1_Surviving;
	Tables GA*FEMALE001 / out = GA_FEMALE_freq1_Surviving nocol nopercent nocum list;
Run;

Data GAname_Surviving(Drop = Percent);
	Set GAfreq_Surviving;
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
		Select * From GAname_Surviving
		Cross Join FEMALEname_Surviving;
Quit;

Proc Sort Data = FEMALE_Merge1_Surviving Out = FEMALE_Merge2_Surviving; By GA FEMALE001; Run;

Data FEMALE_Merge3_Surviving;
	Set FEMALE_Merge2_Surviving;
	Count = 0;
Run;

Data GA_FEMALE_freq2_Surviving(Drop = Percent COUNT SubTotal);
	Merge FEMALE_Merge3_Surviving GA_FEMALE_freq1_Surviving;
	By GA FEMALE001;
	Format Grouppct 6.3;
	Grouppct = (COUNT / SubTotal) * 100;
	Label Grouppct = 'Group Percentage (%)';
Run;

Proc Transpose Data = GA_FEMALE_freq2_Surviving
			   Out = GA_FEMALE_TSP_Surviving;
	By GA;
	ID FEMALE001;
Run;

Data GA_FEMALE_Table_Surviving;
	Set GA_FEMALE_TSP_Surviving(Drop = _NAME_ _LABEL_);
	Label GA = 'Gestational Age Group'
		  Male = 'Male (%)'
		  Female = 'Female (%)'
          Missing = 'Missing (%)'
		  Invalid = 'Invalid (%)'
		  Inconsistent = 'Inconsistent (%)';
Run;

*** Merge Table;

Data GA_Table_Surviving;
	Merge GAmeans_los2_Surviving GAmeans_totchg2_Surviving;
	By GA;
Run;
