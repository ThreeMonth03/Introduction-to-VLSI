***------------------------------------***
***          VLSI 2021 Lab1            ***
***            multiplexer             ***
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

.param wp=1.02u 
.param wn=0.12u 
***-----------------------***
***      measurements     ***
***-----------------------***
**measure power avg
.meas tran AVG_Pwr AVG power

**measure propagation delay
.meas tran tprop trig v(A) val='supply/2' rise=1
+targ v(Y) val='supply/2' rise=1

**measure rise time
.meas tran tr trig v(Y) val='supply*0.1' rise=1
+targ v(Y) val='supply*0.9' rise=1

**measure fall time
.meas tran tf trig v(Y) val='supply*0.9' fall=1
+targ v(Y) val='supply*0.1' fall=1


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
***-----------------------***
***        circuit        ***
***-----------------------***
X_MUX A B SEL EN Y MUX
Cload  Y  GND  load
***-----------------------***
***      sub-circuit      ***
***-----------------------***
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
***-----------------------***
***         alter         ***
***-----------------------***
*alter1
.alter
.param load=10fF
.param wp=0.51u 
.param wn=0.06u 
*alter2
.alter
.param load=10fF
.param wp=10.2u 
.param wn=1.2u 

*alter3
.alter
.param load = 10pF
.param wp=1.02u 
.param wn=0.12u 
*alter4
.alter
.param load = 10pF
.param wp=0.51u 
.param wn=0.06u 
*alter5
.alter
.param load = 10pF
.param wp=10.2u 
.param wn=1.2u 

*alter6
.alter
.param load = 100pF
.param wp=1.02u 
.param wn=0.12u
*alter7
.alter
.param load = 100pF
.param wp=0.51u 
.param wn=0.06u 
*alter8
.alter
.param load = 100pF
.param wp=10.2u 
.param wn=1.2u 

.end
