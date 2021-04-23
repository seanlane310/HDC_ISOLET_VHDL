library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity testing is
end testing;
 
architecture behave of testing is
 

	type slv_arrayclass is array (0 to 1) of std_logic_vector(9 downto 0);
	type slv_arraylevels is array (0 to 9) of std_logic_vector(9 downto 0);
	type correctarray is array (0 to 1) of integer;
	type slv_arraybases is array (0 to 24) of std_logic_vector(9 downto 0);
 	--signal testclasses : slv_arrayclass := ("0000000000", "1111111111");
  	signal testlevels : slv_arraylevels := ("1000000000", "1100000000", "1110000000", "1111000000", "1111100000",
					"1111110000", "1111111000", "1111111100", "1111111110", "1111111111");
  	signal testbases : slv_arraybases := ("0100011000","0011011010","1010111101","1000010111","0110100001",
					"0100101101","1000000101","0100010111","1011010000","1000110010",
					"1011100011","1011001101","0011101011","0001110000","0100110011",
					"0110101110","0111111101","0001111101","0001000100","1000111001",
					"1000101000","0111100111","1111001100","0110010101","0100111100");
  	--signal test : std_logic_vector(9 downto 0) := "0101010101";
  	signal result : integer;

  function classification(
    testinput : in std_logic_vector(9 downto 0);
    classes : in slv_arrayclass)
    return integer is
    variable closest: integer:= 0;
    variable same: std_logic;
    variable amountcorrect : correctarray := (0, 0);
  begin

  	L1: for i in 0 to 1 loop
		L2: for j in 0 to 9 loop
  			same := testinput(j) xnor classes(i)(j);
			if (same = '1') then
				amountcorrect(i) := amountcorrect(i) + 1;
			end if;
		end loop L2;
		if (amountcorrect(1) > amountcorrect(0)) then
			closest := 1;	
		end if;
  	end loop L1;
    return closest;
  end; 
   
begin
 
  process is
 	variable testclasses : slv_arrayclass := ("0000000000", "1111111111");
  	variable test : std_logic_vector(9 downto 0) := "0101010111";
  begin

    	result  <= classification(test, testclasses);  -- function
    	wait for 10 ns;
     	--result <= tempresult;
    wait;
  end process;  
   
end behave;