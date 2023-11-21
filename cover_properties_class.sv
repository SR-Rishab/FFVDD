class cover_properties;

// States
cov_idle: cover property (@(posedge clk) state==IDLE); //Tests if idle state is reached
cov_wait_password: cover property (@(posedge clk) state==WAIT_PASSWORD); //Tests if wait password state is reached
cov_wrong_pass: cover property (@(posedge clk) state==WRONG_PASS);//Tests if wrong password state is reached
cov_right_pass: cover property (@(posedge clk) state==RIGHT_PASS);//Tests if right password state is reached
cov_stop: cover property (@(posedge clk) state==STOP);//Tests if stop state is reached

// Transitions
cov_idle_to_wait_password: cover property (@(posedge clk) state==IDLE ##1 state==WAIT_PASSWORD);
cov_wait_password_to_right_pass: cover property (@(posedge clk) state==WAIT_PASSWORD ##1 state==RIGHT_PASS);
cov_wait_password_to_wrong_pass: cover property (@(posedge clk) state==WAIT_PASSWORD ##1 state==WRONG_PASS);
cov_right_pass_to_stop: cover property (@(posedge(clk) state==RIGHT_PASS ##1 state==STOP);
cov_wrong_pass_to_right_pass: cover property (@(posedge(clk) state==WRONG_PASS ##1 state==RIGHT_PASS);
cov_wrong_pass_to_wrong_pass: cover property (@(posedge(clk) state==WRONG_PASS ##1 state==WRONG_PASS);
cov_right_pass_to_right_pass: cover property (@(posedge(clk) state==RIGHT_PASS ##1 state==RIGHT_PASS);
cov_right_stop_to_stop: cover property (@(posedge(clk) state==STOP ##1 state==STOP);

endclass