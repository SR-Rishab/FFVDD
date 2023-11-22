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

