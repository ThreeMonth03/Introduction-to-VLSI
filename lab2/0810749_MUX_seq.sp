***------------------------------------***
***          VLSI 2021 Lab1            ***
***         multiplexer w/ DFF         ***
***      student ID:    0810749        ***
***------------------------------------***
.title MUX

***-----------------------***
***        setting        ***
***-----------------------***
.lib "umc018.l" L18U18V_TT 
.TEMP 25
.op
.options post

***-----------------------***
***      parameters       ***
***-----------------------***
.global VDD GND
.param supply=1.8v
.param load=10fF


.param wp=0.44u 
.param wn=0.44u 
.param wp_nand=0.44u 
.param wn_nand=0.44u 

***-----------------------***
***       simulation      *** 
***-----------------------***
.tran 0.1u 60u
**measurement
.meas tran avg_power avg power from=0ns to=30us
.meas TRAN Y_Trise_1 trig V(Y) val='Supply*0.1' rise=1
                       +targ V(Y) val='Supply*0.9' rise=1
.meas TRAN Y_Tfall_1 trig V(Y) val='Supply*0.9' fall=1
                       +targ V(Y) val='Supply*0.1' fall=1
.meas TRAN Y_Trise_2 trig V(Y) val='Supply*0.1' rise=2
                       +targ V(Y) val='Supply*0.9' rise=2
.meas TRAN Y_Tfall_2 trig V(Y) val='Supply*0.9' fall=2
                       +targ V(Y) val='Supply*0.1' fall=2
.meas TRAN Y_Trise_3 trig V(Y) val='Supply*0.1' rise=3
                       +targ V(Y) val='Supply*0.9' rise=3
.meas TRAN Y_Tfall_3 trig V(Y) val='Supply*0.9' fall=3
                       +targ V(Y) val='Supply*0.1' fall=3

.meas TRAN Y_delay_1  trig V(A)    val='Supply/2' rise=1
                       +targ V(Y)  val='Supply/2' rise=1                       
.meas TRAN Y_delay_2  trig V(A)    val='Supply/2' rise=2
                       +targ V(Y)  val='Supply/2' fall=1
.meas TRAN Y_delay_3  trig V(A)    val='Supply/2' rise=3
                       +targ V(Y)  val='Supply/2' rise=2
.meas TRAN Y_delay_4  trig V(A)    val='Supply/2' fall=3
                       +targ V(Y)  val='Supply/2' fall=2                       
.meas TRAN Y_delay_5  trig V(A)    val='Supply/2' rise=4
                       +targ V(Y)  val='Supply/2' rise=3   
.meas TRAN Y_delay_6  trig V(A)    val='Supply/2' fall=4
                       +targ V(Y)  val='Supply/2' fall=3

***-----------------------***
***      power/input      ***
***-----------------------***
Vsupply VDD GND supply
V1 A 0 pulse(0 1.8 1u 0.1n 0.1n 2.5u 5u)
V2 B 0 pulse(0 1.8 1u 0.1n 0.1n 5u 10u)
V3 SEL 0 pulse(0 1.8 1u 0.1n 0.1n 10u 20u)
V4 EN 0 pulse(0 1.8 1u 0.1n 0.1n 20u 40u)
V5 CLK 0 pulse(0 1.8 0.3u 0.1n 0.1n 0.5u 1u)
***-----------------------***
***        circuit        ***
***-----------------------***
X_MUX_seq A B SEL EN Y_D CLK MUX
Cload  Y_D  GND  load

***-----------------------***
***      sub-circuit      ***
***-----------------------***

.subckt MUX A B SEL EN Y_D CLK
X_CLK CLK CLK_INV INV
X_MUX A B SEL EN Y MUX_ONLY
X_DFF Y CLK CLK_INV Y_D DFF
.ends

.subckt MUX_ONLY A B SEL EN Y
X_SEL_INV SEL SEL_INV INV
X_NAND1 A SEL_INV OUT1 NAND
X_NAND2 B SEL OUT2 NAND
X_NAND3 OUT2 OUT1 OUT3_INV NAND
X_INV OUT3_INV OUT3 INV
X_EN_INV EN EN_INV INV
X_Y_NOISE OUT3 EN_INV EN Y TRI_INV

.ends

.subckt NAND A B OUT
mp1 OUT A VDD VDD P_18_G2 l=0.18u w=wp_nand
mp2 OUT B VDD VDD P_18_G2 l=0.18u w=wp_nand
mn1 N_1 A GND GND N_18_G2 l=0.18u w=wn_nand
mn2 OUT B N_1 GND N_18_G2 l=0.18u w=wn_nand
.ends

.subckt TRI IN EN_P EN_N OUT
mp IN EN_P OUT VDD P_18_G2 l=0.18u w=wp
mn IN EN_N OUT GND N_18_G2 l=0.18u w=wn
.ends

.subckt INV IN OUT
mp OUT IN VDD VDD P_18_G2 l=0.18u w=wp
mn OUT IN GND GND N_18_G2 l=0.18u w=wn
.ends


.subckt TRI_INV IN EN_P EN_N OUT
mp1 OUT EN_P mp1 VDD P_18_G2 l=0.18u w=wp
mp2 mp1 IN VDD VDD P_18_G2 l=0.18u w=wp
mn1 OUT EN_N mn1 GND N_18_G2 l=0.18u w=wn
mn2 mn1 IN GND GND N_18_G2 l=0.18u w=wn
.ends

.subckt DFF Y CLK CLK_INV Y_D
X_INV1 Y Y_INV INV 
X_D_MASTER Y_INV CLK_INV CLK node1 D_latch
X_D_SLAVE node1 CLK CLK_INV Y_D_INV D_latch
X_INV2 Y_D_INV Y_D INV 
.ends

.subckt D_latch D CLK CLK_INV Q
X_TRI D CLK_INV CLK Q_INV_noise TRI
X_Q_INV_noise Q_INV_noise Q INV
X_TRI_INV Q CLK CLK_INV Q_INV_noise TRI_INV
.ends