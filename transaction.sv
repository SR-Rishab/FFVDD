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
