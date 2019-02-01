library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_unsigned.all;
--use work.array_package.all;
--library work;

ENTITY WP IS
	PORT (
	    WPin : IN std_logic_vector (5 DOWNTO 0);
	    WPout : OUT std_logic_vector (5 DOWNTO 0);
	    clk, WPadd, WPreset : IN std_logic
	);
END WP;

ARCHITECTURE dataflow OF WP IS
	--SIGNAL WPdata : std_logic_vector (5 DOWNTO 0);
BEGIN
	PROCESS (clk) 
	VARIABLE WPdata : std_logic_vector (5 DOWNTO 0);
	 BEGIN
		IF (clk = '1') THEN
			IF (WPreset = '1') THEN
				WPout <= "000000"; 
				WPdata := "000000";
			ELSE
				IF (WPadd = '1') THEN
					WPdata := WPdata +WPin;
					WPout <= WPdata;
				END IF;
			END IF;
		END IF;
	END PROCESS;
	
END dataflow;
