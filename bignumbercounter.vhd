library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity declarations is
	PORT( A : in  STD_LOGIC_VECTOR(31 downto 0);
		counta : out STD_LOGIC_VECTOR(15 downto 0));
end declarations;

architecture Counter of declarations is

begin 

process(A)
variable count : unsigned(15 downto 0) := "0000000000000000";
variable B : unsigned(999 downto 0) := "1011001101001111101111011001000100001110100000101000110011000111111010111011111101011010100100001110000111110001000001000010011011100110010011001011100110110001110000100011110101101100101010001011111100000100111001101100010110101110001111001101110101010000011101110001011111000100101110010011011101101110101110110110010010001100010010001100111100110101110011101111111100111101101010000011111000011110001100001011100010101001101100011010111110000110100011100111010101101000001000001111010111111110011101001010110100111101111111001001111000110101110011111001000010110100111001000010001110110100011100110110100000110010001010110111101111101001000100000111111110100001101010100110101010101101010101101010001111011001101011001000010110001111010000111001011100101110011010110100000101101011101110011010110000000101001100110100101010011110111100100001000111111110010110001111011100100011101111010010011011101100101010101101001001001101111000011010111101001100101011101001110111010111101101010001001100100011";
variable C : unsigned(999 downto 0) := "1111100001111000110011011111110110100000101101101010010100101100001011010010000111000101000011111001101011110000100010001011110101111111000000000101011000111101101100000010100100100111111011011110000010011101110000001100111001110010110110010010101101011111010001000000100011001110111001000100011100101001000101001101101001010100101101110100001010010011011011000011000001001010111100011000001010011101100000101111111101100110110001110101011010011101110110110100000100011111100101111111011101011001101010101010000010011110010001000101011110011000010100001001111111111111001010110100010101100010110011011011110001101111000000100010111110110111100010111011001111010101011001011001111110111001010101100111100110100110000001101100010111100110000001001011111011100101010110110000001110100101101110111011111010010110010001101011101001011001110001101101111100111111001110110011100011101010010011000000000001101000111010111111111001011100110001110100110000100111001011000000011011000101010010011110001001100001";
variable D : unsigned(999 downto 0);
begin
	count := "0000000000000000";
	D := B XOR C;
	for i in 0 to 999 loop
		if(D(i) = '1') then
			count := count + "1";
		end if;
	end loop;
	counta <= std_logic_vector(count);
end process;

end Counter;
