class assertions;

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

endclass
