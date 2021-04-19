library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

-------------------------------------------------------------------------------

-- random std_logic_vector, len is length of vector
--levels is number of random base hypervectors we need? so 256 (based on totalPos in python file)
-- need base and level vectors? create HDVector by mutliplying base and level vectors
--so we need 256 base and level vectors

entity base_HV is
end base_HV;

architecture  behavior of base_HV is

	type slv_array is array (0 to 616) of std_logic_vector(9999 downto 0);
	signal baseHVs : slv_array;
	signal ival : integer;
	signal check : integer;

begin

	process
  	variable r : real;
	variable seed1 :positive;
	variable seed2 :positive;
	variable d : integer := 10000;
	variable m : integer := 617;
	variable tempbaseHVs : slv_array;
	begin
	wait for 10ns;
	
  	L1: for i in 0 to (m-1) loop
		L2: for j in 0 to (d-1) loop
  			uniform(seed1, seed2, r);
  			if (r > 0.5) then tempbaseHVs(i)(j) := '1';
			else tempbaseHVs(i)(j) := '0';
			end if;
		end loop L2;	
  	end loop L1;
	baseHVs <= tempbaseHVs;
	end process;
end architecture;