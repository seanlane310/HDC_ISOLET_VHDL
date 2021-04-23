-- Hypothetically encode the bin values into HVs using position and digit HV sets.
-- WARNING
-- Many errors due to use of math_real to try to account for floating point operations.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity encoder is
end encoder;

architecture behavior of encoder is

	type bin_array is array (0 to 99) of real;
	type dhv_array is array (0 to 9) of std_logic_vector(9999 downto 0);
	type phv_array is array (0 to 99) of std_logic_vector(9999 downto 0);
	type digit_array is array (0 to 4) of integer;
	type int_hv_array is array (0 to 9999) of integer;

	signal bins : bin_array;
	signal digit_HVs : dhv_array;
	signal position_HVs : phv_array;
	signal audio_HV : int_hv_array;

begin

	process

	variable phvs_length : integer := 100;
	variable temp_audio_HV : int_hv_array;

	variable bin_max : real := (-1);
	variable bin_temp : real := (-1);
	variable int_temp : integer := -1;
	variable scaled_bins : bin_array;

	variable level_HVs : phv_array;
	variable digit_rev : digit_array;
	variable perm_HV : std_logic_vector(9999 downto 0);
	variable product : std_logic_vector(9999 downto 0);

	begin
	wait for 10ns;

	L1 : for i in 0 to (phvs_length - 1) loop

		if (bins(i) > 0) then bin_temp := bins(i);
		else bin_temp := (-1 * bins(i));
		end if;

		if (bin_temp > bin_max) then bin_max := bin_temp;
		end if;

	end loop L1;

	L2 : for j in 0 to (phvs_length - 1) loop

		bin_temp := (bins(j) / bin_max);
		int_temp := (bin_temp * 10000);
		scaled_bins(j) := (int_temp / (10000 * (1.0000)));

	end loop L2;

	L3 : for a in 0 to (phvs_length - 1) loop

		int_temp := (scaled_bins(a) * 10000);

		L4 : for b in 0 to 4 loop

			digit_rev(b) := (int_temp mod 10);
			int_temp := (int_temp / 10);

		end loop L4;

		product := digit_HVs(digit_rev(4));
		L5 : for c in 3 downto 0 loop

			perm_HV := (digit_HVs(digit_rev(c)) rol (4 - c));
			L6 : for d in 9999 downto 0 loop

				product(d) := (product(d) * perm_HV(d));

			end loop L6;

		end loop L5;
		level_HVs(a) := product;

	end loop L3;

	L7 : for k in 0 to (phvs_length - 1) loop

		L8 : for m in 9999 downto 0 loop

			if (k = 0) then temp_audio_HV(m) := 0;
			end if;

			temp_audio_HV(m) := temp_audio_HV(m) + (level_HVs(k)(m) * position_HVs(k)(m));

		end loop L8;

	end loop L7;

	audio_HV <= temp_audio_HV;

	end process;

end architecture;