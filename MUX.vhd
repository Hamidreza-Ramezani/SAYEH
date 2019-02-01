library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_unsigned.all;
--use work.array_package.all;
--library work;

ENTITY Mux IS
	PORT (
	    in1, in2 : IN std_logic_vector (3 DOWNTO 0);
	    Shadow : IN std_logic;
	    ShadowOut : OUT std_logic_vector (3 DOWNTO 0)
	   	);
END Mux;

ARCHITECTURE dataflow OF Mux IS
		
BEGIN
  PROCESS ( Shadow, in1, in2) 
  BEGIN
    IF (Shadow = '0' ) THEN
      ShadowOut <= in1;
    END IF;
    IF (Shadow = '1' ) THEN
      ShadowOut <= in2;
    END IF;
  END PROCESS;
END dataflow;
