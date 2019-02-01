library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_unsigned.all;
--use work.array_package.all;
--library work;

ENTITY BUF8 IS
	PORT (
	    EnableBuf : IN std_logic;
	    InBuf : IN std_logic_vector(7 DOWNTO 0);
	    OutBuf : OUT std_logic_vector(7 DOWNTO 0)
	);
END BUF8;

ARCHITECTURE dataflow OF BUF8 IS
	
BEGIN
	PROCESS (EnableBuf, InBuf)
	BEGIN
	   IF (EnableBuf = '1') THEN
		   OutBuf <= InBuf;
		 ELSE
		   OutBuf <= "00000000";
	   END IF;
	END PROCESS;
END dataflow;
