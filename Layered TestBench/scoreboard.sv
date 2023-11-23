class scoreboard;

   virtual parkingsystem_intf intf;
   mailbox gen2bfm;
   int no_transactions;
   
   function new(virtual parkingsystem_intf intf ,mailbox gen2bfm);
   this.intf=intf;
   this.gen2bfm=gen2bfm;
   endfunction
   
   task reset;
   	wait(intf.reset);
   	$display("Resetting is on");
   	intf.bfm_cb.RED_LED<=0;
   	//intf.bfm_cb.GREEN_LED<=0;
   	wait(!intf.reset);
   	$display("Reset done");
   endtask
   
   task main;
   	forever begin
   	transaction trans;
   	gen2bfm.get(trans);
   	$display("Transaction no=%0d",no_transactions);
   	intf.bfm_cb.RED_LED<=trans.RED_LED;
   	repeat(2)@(posedge intf.clk);
   	trans.GREEN_LED=intf.bfm_cb.GREEN_LED;
   	trans.display();
   	no_transactions++;
   	end 
   endtask
endclass 
