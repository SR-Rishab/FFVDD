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
