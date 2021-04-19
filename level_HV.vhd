library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

-------------------------------------------------------------------------------

-- random std_logic_vector, len is length of vector
--levels is number of random base hypervectors we need? so 256 (based on totalPos in python file)
-- need base and level vectors? create HDVector by mutliplying base and level vectors
--so we need 256 base and level vectors

entity level_HV is
end level_HV;

architecture  behavior of level_HV is

	type slv_array is array (0 to 9) of std_logic_vector(9999 downto 0);
	signal levelHVs : slv_array;
	signal ival : integer;
	signal check : integer;

begin

	process
  	variable r : real;
	variable seed1 :positive;
	variable seed2 :positive;
	variable d : integer := 10000;
	variable m : integer := 10;
	variable toflip: integer := 0;
	variable flip: integer := 1;
	variable templevelHVs : slv_array;
	begin
	wait for 10ns;
	
  	L1: for i in 0 to (m-1) loop
		ival <= i;
		if (i = 0) then
			L2: for j in 0 to (d-1) loop
    				uniform(seed1, seed2, r);
  				if (r > 0.5) then templevelHVs(i)(j) := '1';
				else templevelHVs(i)(j) := '0';
				end if;
			end loop L2;	
		else
			check <= 1;
			toflip := d/(m-i+1);
			L3: for k in 0 to (d-1) loop
				templevelHVs(i)(k) := templevelHVs(i-1)(k);
			end loop L3;
			templevelHVs(i) := templevelHVs(i-1);
			L4: for l in 0 to toflip loop
				if(templevelHVs(i-1)(l) = '1') then templevelHVs(i)(l) := '0';
				else templevelHVs(i)(l) := '1';
				end if;
			end loop L4;

		end if;
  	end loop L1;
	levelHVs <= templevelHVs;
	end process;
end architecture;