library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_unsigned.all;
--use work.array_package.all;
--library work;

ENTITY ArithmeticUnit IS
	PORT (
	    A, B : IN std_logic_vector (15 DOWNTO 0);
	    B15to0, AandB, AorB, NotB, AaddB, AsubB, AmulB, AcmpB,ShrB, ShlB,AxorB : IN std_logic;
	    Cin, Zin : IN std_logic;
	    Cout, Zout : OUT std_logic;
	    ALUout : OUT std_logic_vector (15 DOWNTO 0)
	   	);
END ArithmeticUnit;

ARCHITECTURE dataflow OF ArithmeticUnit IS
--SIGNAL temp : std_logic_vector ( 16 DOWNTO 0);
   COMPONENT mult 
      PORT (
         x, y : IN std_logic_vector (7 DOWNTO 0); 
         z : OUT std_logic_vector (15 DOWNTO 0)
      );
   END COMPONENT;
   FOR ALL : mult USE ENTITY work.mult_8by8 (bitwise);
	SIGNAL product : std_logic_vector (15 DOWNTO 0);

		
BEGIN
  PROCESS (A, B, B15to0, AandB, AorB, NotB, AaddB, AsubB, AmulB, AcmpB, ShrB, ShlB, Cin, Zin) 
	VARIABLE temp : std_logic_vector ( 16 DOWNTO 0);
  BEGIN
    IF (AandB = '1' ) THEN
      ALUout <= A and B;
    END IF;
    IF (AorB = '1' ) THEN
      ALUout <= A or B;
    END IF;
    IF (ShrB = '1' ) THEN
      ALUout <= '0'&B(15 DOWNTO 1);
    END IF;
    IF (ShlB = '1' ) THEN
      ALUout <= B(14 DOWNTO 0)&'0';
    END IF;
    IF (AcmpB = '1' ) THEN
	    IF (A = B) THEN
      		Zout <= '1';
	    ELSE
		IF ( A < B ) THEN
			Cout <= '1';
		ELSE
			Zout <= '0';
			Cout <= '0';
		END IF;
    	    END IF;
    END IF;
    IF (AaddB = '1' ) THEN
	temp := ('0'&A) + B + Cin;
	Cout <= temp (16);
	ALUout <= temp (15 DOWNTO 0);
    END IF;
    IF (AsubB = '1' ) THEN
	--ALUout <= A - B - Cin;
	temp := ('0'&A) - B - Cin;
	Cout <= temp (16);
	ALUout <= temp (15 DOWNTO 0);
    END IF;
	
    IF (AmulB = '1' ) THEN
		ALUout <= product;
    END IF;
	
	IF (AxorB = '1' ) THEN
      ALUout <= (A and (not(B)))or(not(A) and B);
    END IF;
	
    IF (B15to0 = '1' ) THEN
	ALUout <= B;
    END IF;
    IF (NotB = '1' ) THEN
	ALUout <= not B;
    END IF; 

----XOR,Div,SqrRoot,RNG,two's complement

  END PROCESS;
    l1 : mult PORT MAP (A (7 DOWNTO 0), B (7 DOWNTO 0), product);

END dataflow;
