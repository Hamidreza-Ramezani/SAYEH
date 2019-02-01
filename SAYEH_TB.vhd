library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_unsigned.all;

ENTITY SAYEH_TB IS
	END SAYEH_TB;

ARCHITECTURE dataflow OF SAYEH_TB IS
	COMPONENT SAYEH IS
	PORT (
	    clk, External_Reset : IN std_logic;
	    pin : IN std_logic_vector(15 DOWNTO 0);
	    pout : OUT std_logic_vector(15 DOWNTO 0)
	);
	END COMPONENT;
	
	---------------------------------------------------------------------------------------------------------

	SIGNAL clk: std_logic := '0';
	SIGNAL External_Reset : std_logic := '1';
	SIGNAL pout : std_logic_vector(15 DOWNTO 0);
	SIGNAL pin : std_logic_vector(15 DOWNTO 0):= "1101100011110000";

BEGIN
	clk <= not clk after 10 ns;
	External_Reset <= '0' after 15 ns;
	pin <= "1111011011111011" after 120 ns;
	U1  : SAYEH PORT MAP (clk, External_Reset, pin, pout);
END dataflow;
