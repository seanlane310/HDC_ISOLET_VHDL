library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
 
entity testing is
end testing;
 
architecture behave of testing is
 

	type slv_arrayclass is array (0 to 1) of std_logic_vector(9 downto 0); -- length of this array must be number of classes (letters) we are tested, vector length is dimensions used
	type testarray is array (0 to 4) of std_logic_vector(9 downto 0); --length of this array must be number of test inputs we are running
	type testactual is array (0 to 4) of integer; --length of this array must be number of test inputs we are running
	type samearray is array (0 to 1) of integer; --length of this array must be number of classes we are using
  	signal result : integer;
  	--signal total : integer;
  	--signal correct : integer;

  function classification(
    testinput : in std_logic_vector(9 downto 0);
    classes : in slv_arrayclass)
    return integer is
    variable closest: integer:= 0;
    variable numclasses: integer:= 2; --number of classes (letters) we are checking
    variable numdimensions: integer:= 10; --number of dimensions for HVs
    variable same: std_logic;
    variable amountsame : samearray := (0, 0); 
  begin

  	L1: for i in 0 to numclasses-1 loop
		L2: for j in 0 to numdimensions-1 loop
  			same := testinput(j) xnor classes(i)(j);
			if (same = '1') then
				amountsame(i) := amountsame(i) + 1;
			end if;
		end loop L2;
		if (amountsame(1) > amountsame(0)) then
			closest := 1;	
		end if;
  	end loop L1;
    return closest;
  end; 
   
begin
 
  process is
-- store classes in test class array 
-- store test inputs in test as an array of test inputs
-- store the actual value of the test (whether a,b,c,etc.) in testactual array
-- store number of tests you are conducting in numtests
-- loop will run tests with each of test inputs to find what class it most closely matches
-- it will return that index as result
-- if index matches the actual expected result index, correct counter is incremented
-- the total number of tests conducted is incremented regardless of correct or incorrect prediction
 	variable testclasses : slv_arrayclass := ("0000000000", "1111111111"); --two test class HVs, one is all ones and one all zeroes to easily check functionality
  	variable test : testarray := ("1111111111", "0000000000", "1101111011", "1011101111", "1100110011");  --this example should get 4/5 correct
  	variable actual : testactual := (1,0,1,0,1); -- this is an array of what should really be predicted (first test should be predicted as 1, second as 0, etc.)
	variable numtests : integer := 5; --number of test inputs we are using
	variable correct : integer := 0; --counts number of correct predictions
	variable total : integer:= 0; -- counts total number of predictions (i guess this is pointless, we already have number of tests we are running)
  begin
	for i in 0 to numtests-1 loop
    		result <= classification(test(i), testclasses);  -- calls function given a test input and the class HVs
		wait for 10 ns;
		if (result = actual(i)) then --checks if result from that function call is equal to the actual class of the test input
			correct := correct + 1;
			total := total + 1;
		else
			total := total + 1;
		end if;
	end loop;

    	wait for 10 ns;
    wait;
  end process;  
   
end behave;