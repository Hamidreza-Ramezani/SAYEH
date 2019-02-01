library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_unsigned.all;
use work.array_package.all;
library work;

ENTITY memory IS
	PORT (
	    address : IN std_logic_vector (15 DOWNTO 0);
	    data_in : IN std_logic_vector (15 DOWNTO 0);
	    data_out : OUT std_logic_vector (15 DOWNTO 0);
	    clk, read, write : IN std_logic );
END memory;

ARCHITECTURE dataflow OF memory IS
	SIGNAL MEM : regfile;
BEGIN
	PROCESS (clk)
	  VARIABLE add : integer;	
	BEGIN
		IF (clk = '1') THEN
		  MEM(0)  <= "0100000001000100";--inp,inp
		  MEM(1)  <= "1011010000011100";--add,mvr
		  MEM(2)  <= "0000100100001100";--brc12
		  MEM(14) <= "0000101000010111";--awp 23
		  MEM(15) <= "0000000100000000";--hlt
			IF (address(15) ='1') THEN
			  add := 1;
			ELSE
			  add := 0;
			END IF;
			add := add*2;
			IF (address(14) ='1') THEN
			  add := add + 1;
			END IF;
			add := add*2;
			IF (address(13) ='1') THEN
			  add := add + 1;
			END IF;
			add := add*2;
			IF (address(12) ='1') THEN
			  add := add + 1;
			END IF;
			add := add*2;
			IF (address(11) ='1') THEN
			  add := add + 1;
			END IF;
			add := add*2;
			IF (address(10) ='1') THEN
			  add := add + 1;
			END IF;
			add := add*2;
			IF (address(9) ='1') THEN
			  add := add + 1;
			END IF;
			add := add*2;
			IF (address(8) ='1') THEN
			  add := add + 1;
			END IF;
			add := add*2;
			IF (address(7) ='1') THEN
			  add := add + 1;
			END IF;
			add := add*2;
			IF (address(6) ='1') THEN
			  add := add + 1;
			END IF;
			add := add*2;
			IF (address(5) ='1') THEN
			  add := add + 1;
			END IF;
			add := add*2;
			IF (address(4) ='1') THEN
			  add := add + 1;
			END IF;
			add := add*2;
			IF (address(3) ='1') THEN
			  add := add + 1;
			END IF;
			add := add*2;
			IF (address(2) ='1') THEN
			  add := add + 1;
			END IF;
			add := add*2;
			IF (address(1) ='1') THEN
			  add := add + 1;
			END IF;
			add := add*2;
			IF (address(0) ='1') THEN
			  add := add + 1;
			END IF;
			IF (read = '1') THEN
				data_out <= MEM(add);
			ELSE IF (write = '1') THEN
				MEM(add) <= data_in;
				data_out <= "0000000000000000";
			ELSE
				data_out <= "0000000000000000";
			END IF;	
			END IF;		
		END IF;
	END PROCESS;
	
END dataflow;
