SET NOCOUNT ON

-- Declare the variables
DECLARE @ResultCurveId uniqueidentifier

-- Create a temporary table to store the results
CREATE TABLE #ResultsTable (ResultCurve_id varchar(50), n int, xtime float , xvalue float)

SELECT distinct resultcurve_id, OrderNo, Batch, unique_code as Sample_Code
INTO #Resultcurve_id_table
FROM ResultCurve
         JOIN vwResultDetail on ResultCurve.result_id = vwResultDetail.result_id
WHERE ResultCurve.variable_id = '8AE2CDE9-0986-47A7-8DC1-F9C56AD2C87B' --selectionner les courbes Torque
  and ResultCurve.result_id IN (select distinct result_id from vwResultDetail
                                where Test='MDR 200C' and Status != 'Ignored' and specification not like '7%'and OrderNo IN (N'REC112293', N'MX1240529116V01', N'REC111436', N'MX12406272Q001', N'MX1240522152C01', N'20240420WP1900', N'MX124012519VT01', N'MX1240205193K01', N'MX124050216P901', N'20240104WP1900', N'20240209WP0300', N'20240401WP0300', N'MX22401199LS01', N'MX124011914RA01', N'REC110087', N'MX1240530147I01', N'MX224012920QV01', N'MX32404296UN01', N'MX124032841401', N'MX123122916DC01', N'MX12403173SH01', N'MX1240527105H01', N'MX12403237X701', N'MX2240305105101', N'20240229WP2300', N'REC112675', N'MX22402049TE01', N'MX124021713BG01', N'MX324021913YB01', N'REC109727', N'MX224020917VM01', N'20240519WP2300', N'REC109703', N'MX1240527145N01', N'MX124052403C01', N'20240520WP0700', N'20240411WP1900', N'MX224051231B01', N'MX5240409115J01', N'MX12405018O401', N'MX124031721SY01', N'MX22401142J501', N'MX324061820HF01', N'LRC240203', N'MX124050317Q501', N'LRC240402', N'MX124030915NO01', N'20240129WP1500', N'MX224062213M501', N'MX12404273L601', N'MX32406042BG01', N'REC111910', N'MX12401084I301', N'MX124052614P01', N'20240619WP2300', N'REC111422', N'20240315WP0700', N'MX224012721PY01', N'MX324042313S101', N'MX32402018P601', N'MX12311065EJ01', N'2024/04/28WP1900', N'20240124WP2300', N'MX1240214179O01', N'MX324022214Z601', N'20240213WP1100', N'20240510WP1500', N'20240314WP2300', N'MX324020120PK01', N'20240224WP1500', N'REC110246', N'LRC240403', N'REC111111', N'REC110126', N'REC111130', N'MX124011711PC01', N'20240125WP1100', N'20240213WP0300', N'LRC240419', N'20240616WP0700', N'test', N'MX324050422XA01', N'MX12404183EP01', N'MX324050811Z401', N'REC110075', N'REC111314', N'MX1240525114B01', N'REC111713', N'MX52405144AE01', N'20240202WP1900', N'20240108', N'REC240218110101', N'MX123101522ZF01', N'20240623WP0300', N'MX12309304PC01', N'MX324012421LM01', N'20240228WP1500', N'MX324040111HQ01', N'MX3240518113P01', N'REC109701', N'MX12405034PP01', N'MX22401157JU01', N'20240207WP2300', N'MX324011615HC01', N'20240525WP0700', N'MX22404133NF01', N'MX4240314157201', N'MX324043018VE01', N'REC111276', N'MX3240529149301', N'20240111WP0700', N'LRC240108', N'MX12405124VF01', N'MX3240514131W01', N'20240502WP0700', N'MX12401313ZM01', N'MX324032212DB01', N'MX32401086CM01', N'MX22405092ZX01', N'MX12310315AQ01', N'20240313wp1500', N'REC109852', N'test20240406', N'20240109WP0700', N'20240407WP2300', N'20240322WP0700', N'20240205WP0300', N'20240419WP1900', N'20240618wp1900', N'MX524013116WL01', N'REC110584', N'MX3240311117O01', N'20240316WP1900', N'20240609WP1900', N'REC110420', N'REC110795', N'TMALRC ', N'MX124040837Q01', N'MX22404126MZ01', N'MX324012216KH01', N'20240131WP1100', N'MX32402016P201', N'20240210wp2300', N'REC111318', N'20240619WP0300', N'20240619WP1100', N'MX32402174XG01', N'20240315WP1900', N'20240204WP0700', N'MX32401268M401', N'REC112106', N'MX324032715FR01', N'REC111204', N'REC111539', N'20240307WP0700', N'MX124010312EX01', N'20240602WP2300', N'20240118WP2300', N'LRC240408', N'MX324012717MW01', N'20240219WP0700', N'REC109805', N'20240215WP0300', N'20240118WP0700', N'20240131wp0300', N'20240314WP0300', N'20240103WP1100', N'20240227WP0300', N'20240105WP2300', N'REC112674', N'MX32406284L901', N'20240208WP0700', N'20240526WP0700', N'MX22402130X901', N'20240617WP0300', N'20240505WP2300', N'REC111538', N'MX32401193IN01', N'20240509WP1100', N'20240217WP1900', N'01/07/2024', N'REC109660', N'LRC240326', N'20240512WP0700', N'MX3240305105801', N'REC111837', N'REC111084', N'20240327WP1500', N'20240612WP2300', N'20240206WP1500', N'20240108WP0700', N'20240428WP1100', N'20240323WP1900', N'20240525WP1500', N'20240503WP1900', N'20240527WP2300', N'20240519WP1100', N'REC110379', N'REC111173', N'20240302WP1900', N'20240203WP0700', N'REC111268', N'20240622WP2300', N'202402051500', N'20240124WP0700', N'20240604WP0300', N'20240417WP2300', N'20240129WP2300', N'CAL D2020-1', N'REC111767', N'20240228WP1900', N'MX123090517X01', N'20240403WP2300', N'20240506WP0700', N'REC112006', N'20240317WP2300', N'ORPH20240507104510897', N'REC110317', N'20240211WP1100', N'MX324010610BJ01', N'20240407WP0300', N'20240503WP2300', N'20240205WP2300', N'20240301WP0700', N'MX224041414O201', N'MX2240227182G01', N'REC110492', N'REC111765', N'MX32402062S801', N'20240614WP1900', N'MX223092856R01', N'20240226WP0700', N'20240524WP1900', N'MX124032522Z501', N'MX224031819BG01', N'MX1240328211Q01', N'REC111540', N'MX124041414C401', N'MX12403182T501', N'MX124061420I501', N'MX124011912R601', N'REC111128', N'MX124031220PT01', N'MX324052225G01', N'MX124050120OJ01', N'MX12405024OU01', N'MX324040513JF01', N'MX124032421YH01', N'MX124061917M201', N'MX124011716PN01', N'MX124012610WB01', N'MX12405043QG01', N'MX22401090GU01', N'MX22403186B201', N'MX32404044IV01', N'MX124012921YT01', N'MX124041711E601', N'MX22401175KT01', N'MX124042318J101', N'MX124011022KE01', N'MX124060423B501', N'MX12401227TC01', N'MX124061610JI01', N'MX12406081D301', N'REC111792', N'MX324041014LZ01', N'FIRESTONE POLY 0510', N'20231228WP2300', N'MX32404226RI01', N'MX124040405001', N'MX324041918QB01', N'MX3240511230R01', N'REC112364', N'MX124012121T201', N'MX124061412HW01', N'MX22405318B001', N'MX224042814V001', N'MX22402196ZH01', N'MX12403222WB01', N'MX124031021OM01', N'MX3240311117N01', N'MX324060812CP01', N'MX124031622SC01', N'MX12403158R901', N'MX124032320XR01', N'MX3231230149D01', N'MX323123159M01', N'MX3240514121V01', N'MX1240410239V01', N'MX124062615PT01', N'MX1240525234N01', N'20240418WP1100', N'MX224042211S001', N'MX124060511BK01', N'MX22401132IO01', N'MX124031511RC01', N'MX32404279TU01', N'MX124051321WD01', N'MX1240527115J01', N'MX32402034QH01', N'MX124061814LA01', N'MX124060914EB01', N'MX124022710GT01', N'MX324061516FU01', N'MX224031918C101', N'MX32404047IY01', N'MX1240529207301', N'MX124010315F301', N'MX224020617UH01', N'MX32404023I001', N'MX12405049QJ01', N'MX22401038E701', N'MX2240307175I01', N'MX3240510220A01', N'MX12406042AR01', N'MX2240528119B01', N'MX224032511ET01', N'MX224010811GH01', N'MX22402158YA01', N'MX32402034QF01', N'MX124012811XP01', N'MX224011119I701', N'MX1240526195301', N'MX12402229DX01', N'MX123122916DD01', N'MX224032016CG01', N'REC111898', N'MX224062710O501', N'20240403WP1900', N'MX12406125G301', N'MX22401145J801', N'MX1240406207001', N'MX32401193IO01', N'MX124042723LT01', N'MX124021812BZ01', N'MX2240312148C01', N'MX12405087SR01', N'MX1240602169M01', N'MX22403161A101', N'MX224060719EA01', N'MX224032818G901', N'MX324011223F401', N'MX324060521C401', N'MX12406088DA01', N'MX1240525144F01', N'MX123123010DZ01', N'MX224021421Y101', N'MX12405021OS01', N'MX12403023JE01', N'MX124032821101', N'MX12406180KO01', N'MX124020976701', N'REC112107', N'MX124032310XE01', N'MX1240208165O01', N'MX1240327160M01', N'MX124010823IX01', N'MX124042017GT01', N'MX224012622PI01', N'MX2240520135V01', N'MX12406222NR01', N'MX324011713HT01', N'MX324042323S901', N'MX224032020CK01', N'MX12404148BX01', N'MX22406110G101', N'ORPH20240130105738543', N'MX224041713PK01', N'MX1240207144U01', N'MX124051415WX01', N'REC109670', N'MX124052171J01', N'MX32401238KT01', N'MX224060822EX01', N'MX124061312H801', N'MX32403269F701', N'REC112174', N'MX224010620FR01', N'MX2240303184K01', N'MX2240312148B01', N'MX2240510100M01', N'MX124042016GQ01', N'MX124030321KO01', N'MX124042711LG01', N'MX22406158I601', N'REC112297', N'MX12406098E101', N'MX12404198FM01', N'20240506WP0300', N'MX124032220WY01', N'MX12403151R201', N'MX224052849901', N'MX124051715Z301', N'MX324010921DG01', N'MX124062721QR01', N'MX1240404135C01', N'MX224012222NN01', N'MX224051995E01', N'MX124051515XQ01', N'REC109700', N'MX2240514172O01', N'MX124011919RH01', N'MX22401301QZ01', N'MX224020514TS01', N'MX224021214X101', N'MX224012316NW01', N'MX22406221LU01', N'MX124051930401', N'REC112423', N'MX224020312T201', N'MX324032621FF01', N'MX123123021E801', N'MX22405305AF01', N'MX124060349Y01', N'MX324021310VY01', N'MX12405117UP01', N'MX124050821TA01', N'MX224060913FC01', N'MX22406224LX01', N'MX124052584801', N'std alpha', N'MX124030223K001', N'MX12404240J901', N'MX32401274MN01', N'MX12401080I101', N'MX124061921M401', N'MX2240225201S01', N'MX324010413AI01', N'MX124031016OG01', N'MX124020734I01', N'MX124031821TQ01', N'MX3231229199101', N'MX12403090N801', N'MX124051610YA01', N'MX124010815IM01', N'MX224062514MT01', N'MX224040222I401', N'MX32401093D301', N'MX224062611NF01', N'MX12405112UM01', N'MX324012023JL01', N'MX324052215F01', N'MX12401181PZ01', N'Vérif ajust 0123', N'MX32404259SX01', N'MX1240329122501', N'MX3240226121101', N'MX224060210BP01', N'REC111340', N'MX12402287HG01', N'MX22406044CI01', N'MX12404155CK01', N'MX224052286U01', N'20240223WP2300', N'MX2240516203W01', N'MX12405063RG01', N'MX324011610H901', N'MX124050220PF01', N'MX32402247ZY01', N'MX124052443I01', N'MX224012914QR01', N'MX124042419JQ01', N'MX12403168RW01', N'MX124060521BQ01', N'20240612WP1100', N'MX124060715CT01', N'MX124051517XS01', N'MX223122916D501', N'REC110956', N'MX124042020GX01', N'MX224031712AR01', N'MX1240528206H01', N'MX324040321IN01', N'MX1240520191801', N'MX1240405116101', N'MX124012410UZ01', N'MX324021611X601', N'MX124012113SV01', N'REC111980', N'cal alpha 0118', N'REC110388', N'MX224033122H501', N'MX124052514201', N'MX1240410179P01', N'MX1240401103B01', N'MX224031620AG01', N'MX124032623ZZ01', N'MX22401108HI01', N'MX124042618KZ01', N'MX224040314IF01', N'MX124032881901', N'20240414WP0300', N'MX224011517K201', N'MX12403058LL01', N'MX124051822ZX01', N'MX124020583901', N'MX12404152CG01', N'MX224032322DW01', N'MX124022112DI01', N'MX324021623XD01', N'MX2240305155A01', N'REC112747', N'MX124012714X801', N'MX124022914IA01', N'MX224032722FS01', N'MX224052809801', N'MX3240301123601', N'MX22401208MA01', N'REC111714', N'MX1240203152501', N'MX224010414EO01', N'MX22404047IR01', N'MX22403201C801', N'MX12406218N701', N'MX324012616MB01', N'MX124012522VW01', N'MX32406022AC01', N'MX224031817BE01', N'MX324021916YI01', N'MX224020614UD01', N'MX12401133M201', N'MX224042016R301', N'MX224012012ME01', N'MX32404028I301', N'MX124050616RX01', N'MX124012220TR01', N'MX224052969U01', N'MX1240527205V01', N'MX224012311NT01', N'MX22403236DO01', N'MX124030820N501', N'MX124032420YG01', N'MX12406191LI01', N'MX124060138O01', N'MX12401230TV01', N'MX2240315209V01', N'MX1240208105I01', N'20240203WP1900', N'MX32404159NY01', N'MX12406258OP01', N'MX124010510GC01', N'MX12403154R501', N'MX22404146NV01', N'MX124013015ZA01', N'MX2240312128701', N'MX3240229212W01', N'MX12402233EH01', N'MX2240521166B01', N'MX1240527105G01', N'MX224032111CR01', N'MX3240226191601', N'MX12401085I501', N'MX2240314179I01', N'MX124011110KO01', N'MX124051217VT01', N'MX1240531118301', N'MX124020744J01', N'MX124042510K301', N'MX123123111EO01', N'MX224040215HZ01', N'MX124011813QH01', N'MX124042311IT01', N'MX3240514161Y01', N'MX124061512IU01', N'MX12401078HM01', N'MX1240525184K01', N'MX224041414O101', N'MX124042619L001', N'MX524050348R01', N'MX124032519Z301', N'MX224031822BK01', N'MX12406275Q501', N'MX324041620OS01', N'MX2240524107R01', N'MX124050521RB01', N'MX324012717MX01', N'MX224011311IY01', N'MX12401048FJ01', N'MX324040623KB01', N'MX124010413FR01', N'MX224041521OU01', N'MX124061710K701', N'REC112004', N'MX124022512FV01', N'MX324062514JV01', N'MX324012620MF01', N'MX123122813CT01', N'MX22402062U201', N'MX324040715KM01', N'MX12406057BF01', N'MX12401278WZ01', N'MX1240526114U01', N'MX124010911JC01', N'MX1240206114301', N'MX124041120AD01', N'MX124053137Z01', N'MX12406167JE01', N'MX124020885H01', N'MX2240304154V01', N'MX12406133GX01', N'MX324030283M01', N'MX1240205233Q01', N'MX124041117AB01', N'MX124013011Z601', N'MX3240309206S01', N'MX224041819Q501', N'MX52401246VG01', N'MX124021616AV01', N'REC112042', N'MX324010420AP01', N'MX324061416FB01', N'MX22404120MW01', N'MX12404139BB01', N'MX124051113UY01', N'MX224062514MS01', N'MX12401237U301', N'MX124020845B01', N'MX224040715KI01', N'REC111364', N'MX22401107HH01', N'MX224020117SA01', N'MX224042116RN01', N'MX1240202161L01', N'MX32402095TZ01', N'MX224010720G601', N'MX12402159A201', N'MX224011112HZ01', N'MX324050914ZQ01', N'MX124050422QT01', N'MX224022112ZY01', N'MX12403038KA01', N'MX22402063U601', N'MX12405028OX01', N'MX324020719TB01', N'MX224062610NC01', N'MX1240407147G01', N'MX12405189ZK01', N'MX324032415ED01', N'MX12404227HX01', N'REC111838', N'MX32404041IR01', N'MX124051523XY01', N'MX224020521U001', N'MX32406176GK01', N'MX12401097J801', N'MX124011811QD01', N'MX124062620PX01', N'MX32403300H001', N'MX224050519YG01', N'REC111366', N'MX124061410HT01', N'MX124060723D201', N'MX12401157NU01', N'MX124022011D301', N'MX224020921VQ01', N'REC112735', N'MX324042011QS01', N'MX124062223OI01', N'MX124030313KF01', N'MX32404037II01', N'MX324042520T501', N'MX124032217WT01', N'MX1240401173J01', N'MX123122713BZ01', N'MX324040617K501', N'MX1240329172B01', N'MX324032721FW01', N'MX22405038XB01', N'MX12406257ON01', N'MX2240310217801', N'MX124041120AE01', N'MX2240313239501', N'MX22312304DE01', N'MX324010320A201', N'MX12401139MB01', N'MX224050322XJ01', N'MX124032119W001', N'MX324010716CC01', N'MX2240513132301', N'MX22405060YP01', N'MX223122916D401', N'MX124030514LX01', N'MX22406258MO01', N'MX12312317EI01', N'MX12403083MM01', N'MX124021137E01', N'REC111171', N'MX1240601168Z01', N'MX32405099ZK01', N'MX124050812SZ01', N'MX124010918JH01', N'MX124062723QU01', N'MX12402179BD01', N'MX324031921BX01', N'MX224061822KB01', N'MX12402198C901', N'MX1240528116601', N'MX12405161Y001', N'20240125WP2300', N'MX32404204QK01', N'MX22401176KU01', N'MX1240213148Z01', N'MX124041913FT01', N'MX124052272301', N'MX1240329102301', N'MX2240221180401', N'MX124041714EB01', N'MX224050613YU01', N'MX224051321Z01', N'MX22406232MI01', N'20240401wp1900', N'MX324031516A101', N'MX224031589O01', N'MX124031414QV01', N'MX124052000O01', N'REC111712', N'MX124022620GH01', N'MX224022922Z01', N'MX22404245ST01', N'MX124012514VO01', N'MX2240309186Q01', N'MX124052181K01', N'MX1240410129J01', N'MX124020683Y01', N'MX324011514GQ01', N'MX22401219MS01', N'MX324042619TJ01', N'MX12406062BX01', N'MX324060310AV01', N'MX32401290NJ01', N'MX324022942I01', N'MX224051784401', N'MX2240519115G01', N'MX12401263W301', N'MX224050217WX01', N'MX12404183EO01', N'MX124042311IS01', N'MX324011023E501', N'MX224060623DU01', N'MX1240330102T01', N'MX324060819CT01', N'MX2240526168S01', N'MX224061623J301', N'MX224050511YC01', N'REC112370', N'MX224040812KY01', N'MX1240201200U01', N'MX224050119WI01', N'202240423wp1500', N'MX1240528156A01', N'MX32406149F701', N'MX224060619DR01', N'REC112104', N'MX124042113HG01', N'MX324061210EN01', N'MX124041620DQ01', N'MX324062010IA01', N'MX124050111O901', N'MX124010516GL01', N'MX324010522BD01', N'MX2240518144Y01', N'MX12401318ZS01', N'MX324050720YQ01', N'MX124030123JB01', N'MX22404158OL01', N'ORPH20240424105558053', N'MX124042220ID01', N'MX124010621H901', N'MX124041823FA01', N'MX32406083CI01', N'MX32403223CZ01', N'MX2240523177J01', N'MX124030911NJ01', N'MX12401227TB01', N'MX1240401133F01', N'MX224041213N601', N'MX22405032X401', N'MX12401170OZ01', N'MX12404117A301', N'MX12406177K401', N'MX124041613DJ01', N'MX124011615OO01', N'MX224012123N401', N'MX32404237RY01', N'MX22404275UD01', N'MX224021219X401', N'REC111839', N'MX124012910YF01', N'MX12401242UR01', N'MX224021123WR01', N'MX1240408127Z01', N'MX124022220EC01', N'MX3240512161201', N'MX124031922UK01', N'MX1240201110N01', N'MX124011516O801', N'MX22401080GA01', N'MX224011411JE01', N'MX22401139IV01', N'MX224012723Q001', N'MX12401152NP01', N'MX124011917RE01', N'MX12406038A201', N'MX224051975701', N'MX124041911FO01', N'MX124041612DH01', N'MX124060314AF01', N'MX1240527135M01', N'MX124031120P801', N'MX224052367701', N'MX224021015W401', N'MX12402168AO01', N'MX224031187I01', N'MX124033002J01', N'MX224050521YK01', N'MX124012322UO01', N'MX12403223WE01', N'MX324011922IW01', N'MX324052366201', N'MX12406039A401', N'MX22406073E001', N'MX1240210106U01', N'MX124052705701', N'MX324031378T01', N'MX224012219NI01', N'MX124010312EV01', N'MX124061516IZ01', N'MX12401177P501', N'MX224020317T801', N'MX224062623NQ01', N'MX124030810MR01', N'MX1240409198W01', N'REC111057', N'MX224062719OD01', N'MX1240520100Z01', N'MX12404162D801', N'MX22402104VX01', N'MX224032313DT01', N'MX12406077CM01', N'MX324052768401', N'MX324041211MM01', N'MX12402246FB01', N'MX12406040AO01', N'REC111005', N'MX1240519140D01', N'20240528WP1500', N'MX12404304NC01', N'MX124060817DI01', N'MX324062515K201', N'REC109671', N'MX224030494R01', N'MX224020116S901', N'REC110558', N'MX12403138PX01', N'MX12406158IM01', N'MX324031914BQ01', N'20240115WP1900', N'MX2240221200501', N'MX1240525104A01', N'MX3240311137R01', N'MX12401203RR01', N'MX224031328M01', N'MX1240602239P01', N'MX1240524203Z01', N'MX124022313ES01', N'MX1240523112Y01', N'MX124022523G201', N'MX12406138H401', N'MX124041614DL01', N'MX124060620CD01', N'MX224041621PB01', N'MX3240302223Y01', N'MX224042719UM01', N'MX32403189BD01', N'MX124042411JG01', N'MX12406051B801', N'REC112097', N'MX124061120FT01', N'MX22401167KD01', N'MX12405051QV01', N'MX32404094LA01', N'MX324011117EC01', N'MX2240226222601', N'MX1240212108F01', N'MX124042121HM01', N'MX12403104NY01', N'MX124040243U01', N'MX32401051AT01', N'20240305WP0300', N'MX124042523KG01', N'MX32404271TN01', N'MX224042518TK01', N'MX124021559Z01', N'MX2240309146L01', N'MX124012015S501', N'MX124042515K601', N'MX2240522146X01', N'MX2240509180A01', N'MX224012923QY01', N'MX12403098NH01', N'MX324042412SI01', N'MX12404134B501', N'MX3240314209L01', N'MX1240519180J01', N'MX1240410159M01', N'MX124053007701', N'MX224010914H201', N'MX1240208235W01', N'MX124030516M001', N'MX224053022AS01', N'MX22405313AU01', N'MX324011021E101', N'MX324042919UY01', N'MX12402220DQ01', N'MX224020115S601', N'MX3240311167U01', N'MX1240402154B01', N'post test', N'MX224061119G701', N'MX12403114OR01', N'MX32401186I901', N'MX124060919EH01', N'MX224030916801', N'MX123122811CR01', N'MX12406128G701', N'REC110433', N'MX324011015DY01', N'MX324011123EG01', N'MX224013111RJ01', N'MX124011217LR01', N'MX22406059DA01', N'MX124051117V301', N'MX124021716BJ01', N'MX124011414N801', N'MX12403044KX01', N'MX32406094D101', N'MX324040519JQ01', N'MX32401048AB01', N'MX32402042QX01', N'MX12405081SM01', N'REC109855', N'MX324042318S501', N'MX1240328201O01', N'MX12406194LK01', N'REC110522', N'MX224040319IH01', N'MX324052627G01', N'MX2240528139C01', N'MX22406266NA01', N'MX32404255SU01', N'MX223122821CS01', N'MX12404129AS01', N'MX12401305YY01', N'MX124051123V701', N'MX124021177K01', N'MX22401094GY01', N'MX32406146F501', N'MX124010411FQ01', N'MX12402258FS01', N'MX224040917LN01', N'MX12405057QX01', N'MX3240527158C01', N'REC111168', N'MX3240313199501', N'MX224041417O501', N'MX124021523AI01', N'MX324011719HZ01', N'MX1240408178601', N'MX124041914FU01', N'MX3240314139G01', N'MX1240209116C01', N'MX324010916DD01', N'MX124043017NR01', N'MX1240407207K01', N'MX224012018MH01', N'MX12406223NU01', N'MX224041021MC01', N'REC112253', N'MX224052216M01', N'MX324031529R01', N'MX124011910R401', N'MX124012116SZ01', N'MX12405159XG01', N'MX124011420NH01', N'MX12401287XK01', N'MX12402170B301', N'MX124040787D01', N'MX124061714K901', N'MX224012123N301', N'MX12401219SP01', N'MX12402290I201', N'MX224061121G801'))
-- Declare the cursor
DECLARE cur CURSOR FOR
SELECT resultcurve_id FROM #Resultcurve_id_table

-- Open the cursor
    OPEN cur

-- Fetch the first row
FETCH NEXT FROM cur INTO @ResultCurveId

-- Loop through the rows
    WHILE @@FETCH_STATUS = 0
BEGIN
        -- Execute the stored procedure for each ResultCurveId and insert the result into the temporary table
INSERT INTO #ResultsTable
    EXEC dbo.CurveData @ResultCurveId

        -- Fetch the next row
        FETCH NEXT FROM cur INTO @ResultCurveId
END

-- Close and deallocate the cursor
CLOSE cur
    DEALLOCATE cur;

-- Tables des ResultCurve_id de la commande
WITH T AS (
    SELECT Rit.OrderNo, #ResultsTable.ResultCurve_id, n, (xtime/60) AS xtime, (xvalue*10) AS xvalue, Batch, Sample_Code
    FROM #ResultsTable
             JOIN #Resultcurve_id_table Rit ON #ResultsTable.ResultCurve_id = Rit.resultcurve_id
    WHERE n != 0
    )
SELECT T.OrderNo, T.Batch, T.Sample_Code, T.xtime, T.xvalue, (T.xvalue - T2.xvalue)/(T.xtime - T2.xtime) AS slope
FROM T, T AS T2
WHERE T.ResultCurve_id = T2.ResultCurve_id AND T.n = T2.n + 1 and (T.xtime - T2.xtime) != 0


-- Drop the temporary table
DROP TABLE #ResultsTable
DROP TABLE #Resultcurve_id_table