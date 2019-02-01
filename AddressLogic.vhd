library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_unsigned.all;
--use work.array_package.all;
--library work;

ENTITY AddressLogic IS
	PORT (
	    PCside, Rside : IN std_logic_vector (15 DOWNTO 0);
	    Iside : IN std_logic_vector (7 DOWNTO 0);
	    ALout : OUT std_logic_vector (15 DOWNTO 0);
	    ResetPC, PCplusI, PCplus1, RplusI, Rplus0 : IN std_logic
	);
END AddressLogic;

ARCHITECTURE dataflow OF AddressLogic IS
	CONSTANT one   : std_logic_vector (4 DOWNTO 0)
		       := "10000";
	CONSTANT two   : std_logic_vector (4 DOWNTO 0)
		       := "01000";
	CONSTANT three : std_logic_vector (4 DOWNTO 0)
		       := "00100";
	CONSTANT four  : std_logic_vector (4 DOWNTO 0)
		       := "00010";
	CONSTANT five  : std_logic_vector (4 DOWNTO 0)
		       := "00001";
	
BEGIN
	PROCESS (PCside, Rside, Iside, ResetPC,
		PCplusI, PCplus1, RplusI, Rplus0)
	   VARIABLE temp : std_logic_vector (4 DOWNTO 0);
	BEGIN
	   temp := (ResetPC & PCplusI & PCplus1 & RplusI & Rplus0);
	   CASE temp IS 
		WHEN one => ALout <= "0000000000000000";
		WHEN two => ALout <= PCside + Iside;
		WHEN three => ALout <= PCside + 1;
		WHEN four => ALout <= Rside + Iside;
		WHEN five => ALout <= Rside;
		WHEN OTHERS => ALout <= PCside;
	   END CASE;
	END PROCESS;
END dataflow;
