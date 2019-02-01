library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_unsigned.all;
use work.array_package.all;
library work;

ENTITY RegisterFile IS
	PORT (
	    Data : IN std_logic_vector (15 DOWNTO 0);
	    Left, Right : OUT std_logic_vector (15 DOWNTO 0);
	    WP : IN std_logic_vector (5 DOWNTO 0);
	    ShadowOut : IN std_logic_vector (3 DOWNTO 0);
	    clk, RFLwrite, RFHwrite, load : IN std_logic
	);
END RegisterFile;

ARCHITECTURE dataflow OF RegisterFile IS
	SIGNAL reg : regfile;
BEGIN
	PROCESS (clk)
		VARIABLE src1, dis1 : std_logic_vector(5 DOWNTO 0);
		VARIABLE src, dis : integer := 0;
	BEGIN
		IF (clk = '1') THEN
		 	src1 := WP + ShadowOut(1 DOWNTO 0);
			dis1 := WP + ShadowOut(3 DOWNTO 2);
			IF (src1(5) ='1') THEN
			  src := 32;
			ELSE 
			  src := 0;
			END IF;
			IF (src1(4) ='1') THEN
			  src := 16 +src;
			END IF;
			IF (src1(3) ='1') THEN
			  src := 8 +src;
			END IF;
			IF (src1(2) ='1') THEN
			  src := 4 +src;
			END IF;
			IF (src1(1) ='1') THEN
			  src := 2 +src;
			END IF;
			IF (src1(0) ='1') THEN
			  src := 1 +src;
			END IF;
			IF (dis1(5) ='1') THEN
			  dis := 32;
			ELSE
			  dis := 0;
			END IF;
			IF (dis1(4) ='1') THEN
			  dis := 16 +dis;
			END IF;
			IF (dis1(3) ='1') THEN
			  dis := 8 +dis;
			END IF;
			IF (dis1(2) ='1') THEN
			  dis := 4 +dis;
			END IF;
			IF (dis1(1) ='1') THEN
			  dis := 2 +dis;
			END IF;
			IF (dis1(0) ='1') THEN
			  dis := 1 +dis;
			END IF;
			    
			Left <= reg(src);
			Right <= reg(dis);
			IF (RFLwrite = '1') THEN
				reg(dis) <= "00000000"&Data(7 DOWNTO 0);
			END IF;
			IF (RFHwrite = '1') THEN
				reg(dis) <= Data(7 DOWNTO 0)&"00000000";
			END IF;
			IF (load = '1') THEN
				reg(dis) <= Data;
			END IF;
		END IF;

	END PROCESS;
	
	
END dataflow;
