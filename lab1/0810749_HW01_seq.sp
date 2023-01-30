***------------------------------------***
***          VLSI 2021 Lab1            ***
***         multiplexer w/ DFF         ***
***      student ID:    0810749        ***
***------------------------------------***
.title MUX_seq

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

.param wp=1.02u 
.param wn=0.12u 

***-----------------------***
***       simulation      *** 
***-----------------------***
.tran 0.1u 60u

***-----------------------***
***      power/input      ***
***-----------------------***
Vsupply VDD GND supply
Va A GND pulse(0 supply 1us 0.1ns 0.1ns 2.5us 5us)
Vb B GND pulse(0 supply 1us 0.1ns 0.1ns 5us 10us)
Vsel SEL GND pulse(0 supply 1us 0.1ns 0.1ns 10us 20us)
Ven EN GND pulse(0 supply 1us 0.1ns 0.1ns 20us 40us)
Vclock CLK GND pulse(0 supply 0ns 0.1ns 0.1ns 1.25us 2.5us)
***-----------------------***
***        circuit        ***
***-----------------------***
X_MUX_seq A B SEL EN CLK Y_D MUX_seq

***-----------------------***
***      sub-circuit      ***
***-----------------------***

.subckt MUX_seq A B SEL EN CLK Y_D
X_CLK CLK CLK_INV INV
X_MUX A B SEL EN Y MUX
X_DFF Y CLK_INV CLK Y_D Y_D_INV DFF
Cload  Y  GND  load
.ends

.subckt MUX A B SEL EN Y
X_SEL_INV SEL SEL_INV INV
X_EN_INV EN EN_INV INV
X_TRI1 A SEL SEL_INV OUT TRI
X_TRI2 B SEL_INV SEL OUT TRI
X_OUT_INV OUT OUT_INV INV
X_Y_NOISE OUT_INV EN_INV EN Y_NOISE TRI_INV
X_NODE1 Y_NOISE NODE1 INV
X_Y_NODE2 NODE1 Y INV

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

.subckt DFF D CLK CLK_INV Y_D Y_D_INV
X_D_MASTER D CLK CLK_INV node1 node2 D_latch
X_D_SLAVE node1 CLK_INV CLK Y_D Y_D_INV D_latch
.ends

.subckt D_latch D CLK CLK_INV Q Q_INV
X_TRI_INV_1 D CLK_INV CLK Q_INV_noise TRI_INV
X_Q_INV_noise Q_INV_noise Q INV
X_TRI_INV_2 Q CLK CLK_INV Q_INV_noise TRI_INV
X_Q_INV Q Q_INV INV
.ends
