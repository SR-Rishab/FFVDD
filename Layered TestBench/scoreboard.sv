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
