CREATE TABLE  "VALORES_DIARIOS" 
   (	"FECHA_REF" VARCHAR2(25), 
	"DIVISION" VARCHAR2(40), 
	"AREA" VARCHAR2(50), 
	"DISTRICT" VARCHAR2(50), 
	"STORE" VARCHAR2(146), 
	"INFS_VTA_ACTUAL" NUMBER(8,2), 
	"SYR_NET_SALES" NUMBER(8,2), 
	"SYR_NET_SALES_CMP_LY" NUMBER, 
	"SYR_NET_SALES_LW" NUMBER(6,0), 
	"SYR_NET_SALES_LY" NUMBER(6,0), 
	"SYR_NET_SALES_CMP_LY2" NUMBER, 
	"SYR_NET_SALES_LY2" NUMBER(6,0), 
	"SYR_TRANS" NUMBER(4,0), 
	"SYR_TRANS_CMP_LY" NUMBER, 
	"SYR_TRANS_LY" NUMBER(4,0), 
	"SYR_CREW_HR" NUMBER(6,2), 
	"SYR_MNGR_HR" NUMBER(6,2), 
	"SYR_GUID_HR" NUMBER(6,2), 
	"SYR_CASH_MM" NUMBER(7,0), 
	"SYR_SAL_PUW" NUMBER(6,0), 
	"SYR_LTN_SAL" NUMBER(6,0), 
	"SYR_EMPL_MEAL" NUMBER(5,2), 
	"SYR_MNGR_MEAL" NUMBER(6,2), 
	"SYR_LABOR" NUMBER(6,0), 
	"SYR_LABOR_SALES_REF" NUMBER, 
	"SYR_MNGR_VOID_QTY" NUMBER(4,0), 
	"SYR_MNGR_VOID_AMT" NUMBER(7,2), 
	"SYR_REG_VOID_QTY" NUMBER(4,0), 
	"SYR_REG_VOID_AMT" NUMBER(7,2), 
	"SYR_COUPONS" NUMBER(6,2), 
	"SYR_DISCOUNTS" NUMBER(6,2), 
	"SYR_SERVICE_TIME" NUMBER(6,2), 
	"SYR_NET_SALES_HR" NUMBER, 
	"SYR_TRANS_HR" NUMBER, 
	"SYR2_GROSS_SALES" NUMBER, 
	"SYR2_NET_SALES" NUMBER, 
	"UNO" NUMBER, 
	"TIE_GOAL_MNGR" NUMBER, 
	"TIE_GOAL_CREW" NUMBER, 
	"SYR3_GROSS_SALES" NUMBER, 
	"SYR3_GROSS_SALES_CMP" NUMBER, 
	"SYR3_GROSS_SAL_LY" NUMBER, 
	"SYR3_DIAS" NUMBER, 
	"SYR4_GROSS_SALES" NUMBER, 
	"SYR4_GROSS_SALES_CMP" NUMBER, 
	"SYR4_GROSS_SAL_LY" NUMBER, 
	"SYR4_DIAS" NUMBER, 
	"SYR5_GROSS_SALES" NUMBER, 
	"SYR5_GROSS_SAL_LY" NUMBER, 
	"SYR5_DIAS" NUMBER, 
	"SMG_OVERALL" NUMBER, 
	"SMG_COUNT" NUMBER(2,0), 
	"TIE_CARE_STATUS" VARCHAR2(20), 
	"SMG_DEF_ZONE" NUMBER, 
	"SYR_GROSS_SALES" NUMBER, 
	"BSC_FECHA" VARCHAR2(18), 
	"SYR4B_GROSS_SALES" NUMBER
   )
/
CREATE TABLE  "USUARIOS" 
   (	"LMUSR_USER" VARCHAR2(30), 
	"LMUSR_LEVEL" NUMBER(1,0), 
	"LMUSR_SCOPE" VARCHAR2(60)
   )
/
CREATE TABLE  "INDICADORES_DIARIOS" 
   (	"APPQD_CODIGO" VARCHAR2(2), 
	"APPQD_DESCRIPCION" VARCHAR2(50), 
	"APPQD_CALCULO" VARCHAR2(200), 
	"APPQD_VERDE" VARCHAR2(20), 
	"APPQD_AMARILLO" VARCHAR2(20), 
	"APPQD_CALCULO2" VARCHAR2(200), 
	"APPQD_GOAL" NUMBER, 
	"APPQD_MAIL_DM" VARCHAR2(1), 
	"APPQD_MAIL_AM" VARCHAR2(1), 
	"APPQD_ALERT_MSG" VARCHAR2(60)
   )
/
