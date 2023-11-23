# FFVDD AHP
## CAR PARKING SYSTEM

### Introduction

This simple project is to implement a car parking system in Verilog. The Verilog code for the car parking system is fully presented.
In the entrance of the parking system, there is a sensor which is activated to detect a vehicle coming. Once the sensor is triggered, a password is requested to open the gate. If the entered password is correct, the gate would open to let the vehicle get in. Otherwise, the gate is still locked. If the current car is getting in the car park being detected by the exit sensor and another the car comes, the door will be locked and requires the coming car to enter passwords.

![image](https://github.com/ShashidharReddy01/FFVDD/assets/142148810/899e38f8-309d-4451-b9cf-fb4c76f3e77f)

<details>
<summary>Algorithm</summary>


1. Vehicle Detection:
   - When a vehicle approaches the entrance of the parking system, a sensor is activated to detect its presence.

2. Request for Password:
   - Once the sensor is triggered and a vehicle is detected, the system requests a password to open the gate. This is typically done via an input interface, such as a keypad or a mobile app.

3. Password Entry:
   - The driver or user of the vehicle enters the required password using the input interface.

4. Password Verification:
   - The entered password is compared to a pre-defined correct password or a database of authorized users. The system checks if the entered password is correct.

5. Gate Operation:
   - If the entered password is correct, the gate opens to allow the vehicle to enter the parking area.

6. Gate Locking:
   - If the entered password is incorrect, the gate remains locked. The vehicle is not granted access, and the driver may need to re-enter the correct password.

7. Exit Detection:
   - As a vehicle enters, it is detected by an entrance sensor. Simultaneously, the parking system keeps track of the vehicles within the parking area.

8. Preventing Multiple Entries:
   - If another vehicle approaches while the first vehicle is still in the process of entering and hasn't completely cleared the gate, the gate remains locked. The second vehicle will also need to enter the correct password.

9. Monitoring and Management:
   - The parking system may have monitoring and management capabilities, such as recording entry and exit times, managing access permissions, and providing data on parking availability.

This process ensures that only authorized vehicles with the correct password can enter the parking area. Additionally, it prevents multiple vehicles from entering simultaneously, maintaining security and control over access to the parking facility.
</details>

<details>
<summary>Design</summary>

```
module parking_system( 
                input clk,reset_n,
 input sensor_entrance, sensor_exit, 
 input [1:0] password_1, password_2,
 output wire GREEN_LED,RED_LED,
 output reg [6:0] HEX_1, HEX_2
    );
 parameter IDLE = 3'b000, WAIT_PASSWORD = 3'b001, WRONG_PASS = 3'b010, RIGHT_PASS = 3'b011,STOP = 3'b100;
 // Moore FSM : output just depends on the current state
 reg[2:0] current_state, next_state;
 reg[31:0] counter_wait;
 reg red_tmp,green_tmp;
 // Next state
 always @(posedge clk or negedge reset_n)
 begin
 if(~reset_n) 
 current_state = IDLE;
 else
 current_state = next_state;
 end
 // counter_wait
 always @(posedge clk or negedge reset_n) 
 begin
 if(~reset_n) 
 counter_wait <= 0;
 else if(current_state==WAIT_PASSWORD)
 counter_wait <= counter_wait + 1;
 else 
 counter_wait <= 0;
 end
 // change state
 always @(*)
 begin
 case(current_state)
 IDLE: begin
         if(sensor_entrance == 1)
 next_state = WAIT_PASSWORD;
 else
 next_state = IDLE;
 end
 WAIT_PASSWORD: begin
 if(counter_wait <= 3)
 next_state = WAIT_PASSWORD;
 else 
 begin
 if((password_1==2'b01)&&(password_2==2'b10))
 next_state = RIGHT_PASS;
 else
 next_state = WRONG_PASS;
 end
 end
 WRONG_PASS: begin
 if((password_1==2'b01)&&(password_2==2'b10))
 next_state = RIGHT_PASS;
 else
 next_state = WRONG_PASS;
 end
 RIGHT_PASS: begin
 if(sensor_entrance==1 && sensor_exit == 1)
 next_state = STOP;
 else if(sensor_exit == 1)
 next_state = IDLE;
 else
 next_state = RIGHT_PASS;
 end
 STOP: begin
 if((password_1==2'b01)&&(password_2==2'b10))
 next_state = RIGHT_PASS;
 else
 next_state = STOP;
 end
 default: next_state = IDLE;
 endcase
 end
 // LEDs and output, change the period of blinking LEDs here
 always @(posedge clk) begin 
 case(current_state)
 IDLE: begin
 green_tmp = 1'b0;
 red_tmp = 1'b0;
 HEX_1 = 7'b1111111; // off
 HEX_2 = 7'b1111111; // off
 end
 WAIT_PASSWORD: begin
 green_tmp = 1'b0;
 red_tmp = 1'b1;
 HEX_1 = 7'b000_0110; // E
 HEX_2 = 7'b010_1011; // n 
 end
 WRONG_PASS: begin
 green_tmp = 1'b0;
 red_tmp = ~red_tmp;
 HEX_1 = 7'b000_0110; // E
 HEX_2 = 7'b000_0110; // E 
 end
 RIGHT_PASS: begin
 green_tmp = ~green_tmp;
 red_tmp = 1'b0;
 HEX_1 = 7'b000_0010; // 6
 HEX_2 = 7'b100_0000; // 0 
 end
 STOP: begin
 green_tmp = 1'b0;
 red_tmp = ~red_tmp;
 HEX_1 = 7'b001_0010; // 5
 HEX_2 = 7'b000_1100; // P 
 end
 endcase
 end
 assign RED_LED = red_tmp  ;
 assign GREEN_LED = green_tmp;

endmodule
```
</details>
<details>
<summary>Testbench</summary>

```
module tb_parking_system;

  // Inputs
  reg clk;
  reg reset_n;
  reg sensor_entrance;
  reg sensor_exit;
  reg [1:0] password_1;
  reg [1:0] password_2;

  // Outputs
  wire GREEN_LED;
  wire RED_LED;
  wire [6:0] HEX_1;
  wire [6:0] HEX_2;
  // Instantiate the Unit Under Test (UUT)
  parking_system uut (
  .clk(clk), 
  .reset_n(reset_n), 
  .sensor_entrance(sensor_entrance), 
  .sensor_exit(sensor_exit), 
  .password_1(password_1), 
  .password_2(password_2), 
  .GREEN_LED(GREEN_LED), 
  .RED_LED(RED_LED), 
  .HEX_1(HEX_1), 
 .HEX_2(HEX_2)
 );
 initial begin
 clk = 0;
 forever #10 clk = ~clk;
 end
 initial begin
 // Initialize Inputs
 reset_n = 0;
 sensor_entrance = 0;
 sensor_exit = 0;
 password_1 = 0;
 password_2 = 0;
 // Wait 100 ns for global reset to finish
 #100;
      reset_n = 1;
 #20;
 sensor_entrance = 1;
 #1000;
 sensor_entrance = 0;
 password_1 = 1;
 password_2 = 2;
 #2000;
 sensor_exit =1;
 
 end
    
endmodule
```
</details>
<details>
<summary>Commands required to RUN-SIMULATE-CODE_COVERAGE</summary>
	
## Steps to start CADENCE on linux

&gt; create a folder in the desktop, with your srn/name

&gt; open the folder

&gt; right-click and create files for design and testbench,
eg. db_fsm.v and db_tb.v

&gt; right-click on the files and open them using gedit, save the design and
testbench codes in the respective files

&gt; right-click inside the folder and select open in terminal

&gt; enter the following commands in the terminal
`csh`

Enters the C-Shell

`source /home/&lt;install location`
&gt; `/cshrc`

&gt; Navigates to the Cadence Tools install path and starts the tool

Note: You can use the upper arrow in the terminal to navigate quickly to the already used paths/commands and use tab-key to auto-complete commands.

&gt; A new window appears that welcomes the user to the Cadence Design Suite,the following tools can be invoked in this window.

## Simulation Tool

&gt;To start reading the design and testbench files, to obtain a waveform in the Graphical User Interface (simvision), enter the following commands.
Note: No space between +access and +rw, but mandatory space between +rw and +gui. (make sure to follow all similar spacing patterns given in the tool reference)

&gt; ncverilog &lt;design&gt; &lt;testbench&gt; +access+rw +gui

eg. ncverilog db_fsm.v db_tb.v +access+rw +gui

Note: the +gui starts up the ncverilog GUI window.

&gt; navigate through the design hierarchy and select the signals you want to
analyze in the design browser (hold down ctrl-key while selecting), right-click
and select send to waveform

&gt; in the simvision window, select the play button, followed by the pause button
to start and stop the simulation. The simulation will end automatically if the
$finish statement is executed in the HDL.

&gt; select the ‘=’ symbol at the top right corner of the window, to fit the
waveform’s entirety in the same frame.

&gt; drag the red marker to the beginning of the waveform and select on the ‘+’
symbol on the top right corner, to magnify until the waveform pulses are
visible for verifying the functionality of the design.

## Code Coverage Check

&gt; ncverilog design.v tb.v +access+rw +gui +nccoverage+all

&gt; Check for the path of the file “cov_work” generated in the terminal then
type:

(Invoke Incisive Metrics Center)

&gt;enter the command ‘imc’ in the terminal which will launch the IMC GUI.

`imc`

&gt; In he IMC’s Graphical User Interface, you can navigate and select the file to
check the Code Coverage (block, branch, expression, toggle) and FSM
Coverage, represented in percentages.
</details>
<details>
<summary>Gate-Level-Simulation</summary>

![WhatsApp Image 2023-10-25 at 16 02 13_756b86be](https://github.com/ShashidharReddy01/FFVDD/assets/142148810/ba8b7af7-30aa-4c53-aa59-4524f9a23f38)

</details>
<details>
<summary>Code Coverage</summary>
  
![WhatsApp Image 2023-10-25 at 16 02 13_ab159753](https://github.com/ShashidharReddy01/FFVDD/assets/142148810/8fe49278-5036-461e-99bb-6288c754719a)

</details>

<details>
	<summary>Layered Testbench</summary>
<details>
<summary>Code Coverage</summary>

 ![WhatsApp Image 2023-11-22 at 17 39 12_43368b7d](https://github.com/ShashidharReddy01/FFVDD/assets/142148810/243d4ff5-3b00-449a-accb-5a9ed383ae46)

</details>
<details>
<summary>Simulation</summary>
	
![image](https://github.com/ShashidharReddy01/FFVDD/assets/142148810/b1f739e3-bcc8-43e5-a67a-7e201a1f8dc1)
</details>


<details>
<summary>Defines</summary>

 ```
`include "transaction.sv" 
`include "generator.sv"
`include "interface.sv"
`include "driver.sv"
`include "environment.sv"
`include "program.sv"
`include "parking_system.v"
`include "tb_top.sv"
```
</details>
<details>
<summary>Driver</summary>

 ```
class driver;
mailbox gen2driv;
virtual intf vif;
int no_transactions;
function new(virtual intf vif,mailbox gen2driv);
this.vif = vif;
this.gen2driv = gen2driv;
endfunction
task reset_n;
wait(vif.reset_n);
$display("reset_n started");
vif.sensor_entrance <= 0; 
vif.sensor_exit <= 0;
vif.password_1 <= 0;
vif.password_2 <= 0;
wait(!vif.reset_n);
$display("reset_n ended");
endtask

task main;
forever begin transaction trans; 
gen2driv.get(trans);
$display ("TRANSACTION NO = %0h", no_transactions) ;
vif.sensor_entrance <= trans.sensor_entrance;
vif.sensor_exit <= trans.sensor_exit;
vif.password_1 <= trans.password_1;
vif.password_2 <= trans.password_2; 
@(posedge vif.clk);
trans.GREEN_LED = vif.GREEN_LED;
trans.RED_LED = vif.RED_LED;
trans.HEX_1 = vif.HEX_1;
trans.HEX_2 = vif.HEX_2;
trans.display("OUTPUT");
@(posedge vif.clk);
no_transactions++;
end endtask
endclass

```
</details>
<details>
<summary>Environment</summary>

 ```
class environment;
generator gen; 
driver driv;
mailbox gen2driv;
virtual intf vif;
event ended;
function new(virtual intf vif);
this.vif = vif;
gen2driv = new();
gen = new(gen2driv, ended);
driv = new(vif,gen2driv);
endfunction
task pre_test; driv.reset_n();
endtask

task test;
fork gen.main();
driv.main();
join_any;
endtask
task post_test;
wait(ended.triggered);
wait (gen.repeat_count == driv.no_transactions);
endtask
task run;
pre_test();
test();
post_test();
$finish;
endtask
endclass
```
</details>
<details>
<summary>Interface</summary>

 ```
interface intf(input logic clk,reset_n);
logic sensor_entrance;
logic sensor_exit;
logic [1:0] password_1;
logic [1:0] password_2;
logic GREEN_LED;
logic RED_LED;
logic [6:0] HEX_1;
logic [6:0] HEX_2;

endinterface
```
</details>
<details>
<summary>Scoreboard</summary>

 ```
class scoreboard;

	virtual parkingsystem_intf intf;
	mailbox gen2bfm;
	int no_transactions;
	
	function new(virtual debounce_intf intf ,mailbox gen2bfm);
	this.intf=intf;
	this.gen2bfm=gen2bfm;
	endfunction
	
	task reset;
		wait(intf.reset);
		$display("Resetting is on");
		intf.bfm_cb.red_led<=0;
		//intf.bfm_cb.green_led<=0;
		wait(!intf.reset);
		$display("Reset done");
	endtask
	
	task main;
		forever begin
		transaction trans;
		gen2bfm.get(trans);
		$display("Transaction no=%0d",no_transactions);
		intf.bfm_cb.red_led<=trans.red_led;
		repeat(2)@(posedge intf.clk);
		trans.green_led=intf.bfm_cb.green_led;
		trans.display();
		no_transactions++;
		end 
	endtask
endclass 
```
</details>
<details>
<summary>tb_top</summary>

 ```
module tb_top;
bit clk;
bit reset_n;
intf vif(clk,reset_n);
test t1(vif);
parking_system dut(.clk(vif.clk),.reset_n(vif.reset_n),.sensor_entrance(vif.sensor_entrance),.sensor_exit(vif.sensor_exit),.password_1(vif.password_1),.password_2(vif.password_2),
.GREEN_LED(vif.GREEN_LED),
.RED_LED(vif.RED_LED),
.HEX_1(vif.HEX_1),
.HEX_2(vif.HEX_2)
);

always #5 clk = ~clk;
always #100 reset_n = ~reset_n;
initial begin
reset_n = 1;
end

cov_idle: cover property (@(posedge clk) (clk==1) ##1 (clk==0));
cov_something: cover property (@(posedge clk) (vif.sensor_entrance==1) ##1 (vif.GREEN_LED==1));
endmodule

/*
// States
cov_idle: cover property (@(posedge clk) (state==IDLE)); //Tests if idle state is reached
cov_wait_password: cover property (@(posedge clk) (state==WAIT_PASSWORD)); //Tests if wait password state is reached
cov_wrong_pass: cover property (@(posedge clk) (state==WRONG_PASS));//Tests if wrong password state is reached
cov_right_pass: cover property (@(posedge clk) (state==RIGHT_PASS));//Tests if right password state is reached
cov_stop: cover property (@(posedge clk) (state==STOP));//Tests if stop state is reached

// Transitions
cov_idle_to_wait_password: cover property (@(posedge clk) (state==IDLE) ##1 (state==WAIT_PASSWORD));
cov_wait_password_to_right_pass: cover property (@(posedge clk) (state==WAIT_PASSWORD) ##1 (state==RIGHT_PASS));
cov_wait_password_to_wrong_pass: cover property (@(posedge clk) (state==WAIT_PASSWORD) ##1 (state==WRONG_PASS));
cov_right_pass_to_stop: cover property (@(posedge clk) (state==RIGHT_PASS) ##1 (state==STOP));
cov_wrong_pass_to_right_pass: cover property (@(posedge clk) (state==WRONG_PASS) ##1 (state==RIGHT_PASS));
cov_wrong_pass_to_wrong_pass: cover property (@(posedge clk) (state==WRONG_PASS) ##1 (state==WRONG_PASS));
cov_right_pass_to_right_pass: cover property (@(posedge clk) (state==RIGHT_PASS) ##1 (state==RIGHT_PASS));
cov_right_stop_to_stop: cover property (@(posedge clk) (state==STOP) ##1 (state==STOP));
*/
```
</details>
<details>
<summary>Transaction</summary>

 ```
class transaction;
rand bit sensor_entrance;
rand bit sensor_exit;
rand bit [1:0] password_1;
rand bit [1:0] password_2;
bit GREEN_LED;
bit RED_LED;
bit [6:0] HEX_1;
bit [6:0] HEX_2;
function void display(string name);
$display("--------");
$display("\t sensor entrance = %0b, \t sensor exit = %0h, \t password 1 = %0h, \t password 1 = %0h",sensor_entrance,sensor_exit,password_1,password_2);
$display("\t GREEN_LED = %0b, \t RED_LED = %0b, HEX_1 = %0h, \t HEX_2 = %0h",GREEN_LED,RED_LED,HEX_1,HEX_2);
$display("--------");
endfunction
endclass
```
</details>
<details>
<summary>Assertions</summary>

 ```
module assertions;

//states
property p1;
@(posedge clk) (state==IDLE); //Tests if idle state is reached
endproperty
a1:assert property(p1);

property p2;
@(posedge clk) (state==WAIT_PASSWORD); //Tests if wait password state is reached
endproperty
a2:assert property(p2);

property p3;
@(posedge clk) (state==WRONG_PASS);//Tests if wrong password state is reached
endproperty
a3:assert property(p3);

property p4;
@(posedge clk) (state==RIGHT_PASS);//Tests if right password state is reached
endproperty
a4:assert property(p4);


property p5;
@(posedge clk) (state==STOP);//Tests if stop state is reached
endproperty
a5:assert property(p5);


//transitions
property p6;
@(posedge clk) (state==IDLE) ##1 (state==WAIT_PASSWORD);
endproperty
a6:assert property(p6);

property p7;
@(posedge clk) (state==WAIT_PASSWORD) ##1 (state==RIGHT_PASS);
endproperty
a7:assert property(p7);

property p8;
@(posedge clk) (state==WAIT_PASSWORD) ##1 (state==WRONG_PASS);
endproperty
a8:assert property(p8);

property p9;
@(posedge clk) (state==RIGHT_PASS) ##1 (state==STOP);
endproperty
a9:assert property(p9);

property p10;
@(posedge clk) (state==WRONG_PASS) ##1 (state==RIGHT_PASS);
endproperty
a10:assert property(p10);

property p11;
@(posedge clk) (state==WRONG_PASS) ##1 (state==WRONG_PASS);
endproperty
a11:assert property(p11);

property p12;
@(posedge clk) (state==RIGHT_PASS) ##1 (state==RIGHT_PASS);
endproperty
a12:assert property(p12);

property p13;
@(posedge clk) (state==STOP) ##1 (state==STOP);
endproperty
a13:assert property(p13);

endmodule
```
</details>
<details>
<summary>Cover Properties</summary>

 ```
module cover_properties;

// States
cov_idle: cover property (@(posedge clk) (state==IDLE); //Tests if idle state is reached
cov_wait_password: cover property (@(posedge clk) state==WAIT_PASSWORD); //Tests if wait password state is reached
cov_wrong_pass: cover property (@(posedge clk) state==WRONG_PASS);//Tests if wrong password state is reached
cov_right_pass: cover property (@(posedge clk) state==RIGHT_PASS);//Tests if right password state is reached
cov_stop: cover property (@(posedge clk) state==STOP);//Tests if stop state is reached

// Transitions
cov_idle_to_wait_password: cover property (@(posedge clk) (state==IDLE ##1 state==WAIT_PASSWORD));
cov_wait_password_to_right_pass: cover property (@(posedge clk) (state==WAIT_PASSWORD ##1 state==RIGHT_PASS));
cov_wait_password_to_wrong_pass: cover property (@(posedge clk) (state==WAIT_PASSWORD ##1 state==WRONG_PASS));
cov_right_pass_to_stop: cover property (@(posedge(clk) (state==RIGHT_PASS ##1 state==STOP));
cov_wrong_pass_to_right_pass: cover property (@(posedge clk) (state==WRONG_PASS ##1 state==RIGHT_PASS));
cov_wrong_pass_to_wrong_pass: cover property (@(posedge clk) (state==WRONG_PASS ##1 state==WRONG_PASS));
cov_right_pass_to_right_pass: cover property (@(posedge clk) (state==RIGHT_PASS ##1 state==RIGHT_PASS));
cov_right_stop_to_stop: cover property (@(posedge clk) (state==STOP ##1 state==STOP));

endmodule
```
</details>
<details>
<summary>Generator</summary>

 ```
class generator;
rand transaction trans; mailbox gen2driv; int repeat_count;
event ended;
function new(mailbox gen2driv, event ended);
this.gen2driv = gen2driv;
this.ended = ended;
endfunction
task main;
repeat (repeat_count) begin
trans = new();
if(!trans.randomize()) $fatal("Randomization Failed");
gen2driv.put (trans);
end
-> ended;
endtask
endclass
```
</details>

</details>
