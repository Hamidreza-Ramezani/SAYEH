library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_unsigned.all;
use work.array_package.all;
library work;

ENTITY CONTROLLER IS
	PORT (
	    External_Reset, Zout, Cout, clk : IN std_logic;
	    IRout : IN std_logic_vector (15 DOWNTO 0);
	    ZSet, ZReset, CSet, CReset, WPreset, RFright_on_OpndBus, B15to0, ALUout_on_Databus, 
	    RS_on_AddressUnitRside, ResetPC, PCplusI, PCplus1, RplusI, Rplus0, ReadMem, 
	    MemDataReady,WriteMem, AandB, AaddB, AorB, AmulB, AcmpB, NotB, ShrB, ShlB, AsubB, 
	    WPadd, RFLwrite, RFHwrite, EnablePC, RD_on_AddressUnitRside, Address_on_Databus, IRload,
	    regload, p_en : OUT std_logic;
	    Shadow, SRload : OUT std_logic 
	    );
END CONTROLLER;
ARCHITECTURE dataflow OF CONTROLLER IS
--SIGNAL IRout : std_logic_vector (15 DOWNTO 0):= "1111010011111111";
	CONSTANT Fetch  : std_logic_vector (3 DOWNTO 0)
		        := "0000";
	CONSTANT load  : std_logic_vector (3 DOWNTO 0)
		        := "0001";
	CONSTANT Decode1: std_logic_vector (3 DOWNTO 0)
		        := "0010";
	CONSTANT Decode2: std_logic_vector (3 DOWNTO 0)
		        := "0011";
	CONSTANT Halt   : std_logic_vector (3 DOWNTO 0)
		        := "0100";
	CONSTANT Nop1   : std_logic_vector (3 DOWNTO 0)
		        := "0101";
	CONSTANT Nop2   : std_logic_vector (3 DOWNTO 0)
		        := "0110";
	CONSTANT EXE1   : std_logic_vector (3 DOWNTO 0)
		        := "0111";
	CONSTANT EXE2   : std_logic_vector (3 DOWNTO 0)
		        := "1000";
	CONSTANT idle   : std_logic_vector (3 DOWNTO 0)
		        := "1001";
	--SIGNAL Nstate, Pstate : std_logic_vector(2 DOWNTO 0);
	Signal index : integer := 0;
	SIGNAL incr : std_logic := '0';

BEGIN
	PROCESS (clk)
	 VARIABLE Nstate, Pstate : std_logic_vector(3 DOWNTO 0);
	BEGIN
		IF (clk = '1') THEN			
			IF (External_Reset = '1' ) THEN
				Nstate := Fetch;
				incr <= '0';
				ResetPC <= '1';
				EnablePC <= '1';
				WPreset <= '1';
				ZReset <= '1';
				CReset <= '1';
				ReadMem <= '0';
				IRload <= '0';
				ZSet <= '0';
				CSet <= '0';
				RFright_on_OpndBus <= '0';
			 	B15to0 <= '0';
				ALUout_on_Databus <= '0';
				RS_on_AddressUnitRside <= '0';
				PCplusI <= '0';
				PCplus1 <= '0';
				RplusI <= '0';
				Rplus0 <= '0';
				ReadMem <= '0';
				MemDataReady <= '0';
				WriteMem <= '0';
				AandB <= '0';
				AaddB <= '0';
				AorB <= '0';
				AmulB <= '0';
				AcmpB <= '0';
				NotB <= '0';
				ShrB <= '0';
				ShlB <= '0';
				AsubB <= '0';
				WPadd <= '0';
				RFLwrite <= '0';
				RFHwrite <= '0';
				RD_on_AddressUnitRside <= '0';
				Address_on_Databus <= '0';
				SRload <= '0';
				Shadow <= '1';
				index <= 0;
				regload <= '0';
				p_en <= '0';
			ELSE
				Pstate := Nstate;
				CASE Pstate IS 
				WHEN Fetch =>
					index <= 1;
					Nstate := load;
					ReadMem <= '1';
					IRload <= '0';
					ResetPC <= '0';
				  	EnablePC <= '0';
				  	WPreset <= '0';
					Shadow <= '1'; 
					RFLwrite <= '0';
					RFHwrite <= '0';
					Address_on_Databus <= '0';
					RS_on_AddressUnitRside <= '0';
					PCplus1 <= '0';
					ZReset <= '0';
					CReset <= '0';

					regload <= '0';
					p_en <= '0';
					
				WHEN load =>
					index <= 2;
				  	IRload <= '1';
					ReadMem <= '0';
					Shadow <= '1';
					Nstate := idle;--Decode1;
				WHEN idle =>
					index <= 3;
					IRload <= '0';
					Nstate := Decode1;
				WHEN Decode1 =>
					index <= 4;
					IF (IRout(15 DOWNTO 12) = "1111") THEN
						Nstate := EXE1;
						CASE IRout(9 DOWNTO 8) IS
						WHEN "00" => --mil
							RFLwrite <= '1';
							incr <= '1';
							regload <= '1';
						WHEN "01" => --mih
							RFHwrite <= '1';
							incr <= '1';
							regload <= '1';
						WHEN "10" => --spc
							regload <= '1';
							PCplusI <= '1';
							Address_on_Databus <= '1';
							incr <= '1';
						WHEN "11" => --jpa
							RplusI <= '1';
							EnablePC <= '1';
							incr <= '0';
							RS_on_AddressUnitRside <= '1';
						WHEN OTHERS =>
							incr <= '1';
						END CASE;
					
					ELSE IF (IRout(15 DOWNTO 8) = "00000111") THEN
						PCplusI <= '1';--jpr
						EnablePC <= '1';
						incr <= '0';
						Nstate := EXE1;
					ELSE IF (IRout(15 DOWNTO 10) = "000010") THEN
						Nstate := EXE1;
						CASE IRout(9 DOWNTO 8) IS
						WHEN "00" => --brz
							IF (Zout = '1') THEN
								PCplusI <= '1';
								EnablePC <= '1';
								incr <= '0';
							ELSE
								incr <= '1';
							END IF;
						WHEN "01" => --brc
							IF (Cout = '1') THEN
								PCplusI <= '1';
								EnablePC <= '1';
								incr <= '0';
							ELSE
								incr <= '1';
							END IF;
						WHEN "10" => --awp
							WPadd <= '1';
							incr <= '1';
						WHEN OTHERS =>
							Nstate := Fetch;
							incr <= '1';
	   					END CASE;
					ELSE IF (IRout(15 DOWNTO 8) = "00000000") THEN
						incr <= '1';
						Nstate := Nop1;
					ELSE IF (IRout(15 DOWNTO 8) = "00000001") THEN
						Nstate := Halt;
						
					ELSE
						Nstate := EXE2;
						incr <= '1';
						CASE IRout(15 DOWNTO 8) IS 
						WHEN "00000010" => 
				 			ZSet <= '1';--zfs
						WHEN "00000011" => 
				 			ZReset <= '1';--czf
						WHEN "00000100" => 
							CSet <= '1';--scf
						WHEN "00000101" => 
			 				CReset <= '1';--ccf
						WHEN "00000110" => 
							WPreset <= '1';--cwp
						WHEN OTHERS =>
						END CASE;
						CASE IRout(15 DOWNTO 12) IS
						WHEN "0001" =>  
							RFright_on_OpndBus <= '1';--mvr
							B15to0 <= '1';
							ALUout_on_Databus <= '1';
							regload <= '1';
						WHEN "0010" =>  --lda
							RS_on_AddressUnitRside <= '1';
							Rplus0 <= '1';
							ReadMem <= '1';
							MemDataReady <= '1';
							regload <= '1';
						WHEN "0011" =>  --sta
							RFright_on_OpndBus <= '1';
							B15to0 <= '1';
							ALUout_on_Databus <= '1';
							RD_on_AddressUnitRside <= '1';
							Rplus0 <= '1';
							WriteMem <= '1';
							MemDataReady <= '1';
							regload <= '1';
						WHEN "0100" =>  --inp
								regload <= '1';
								p_en <= '1';
						WHEN "0101" =>  --oup
								ALUout_on_Databus <= '1';
								RFright_on_OpndBus <= '1';
								B15to0 <= '1';
								p_en <= '0';
						WHEN "0110" =>  --and
							RFright_on_OpndBus <= '1';
							AandB <= '1';
							ALUout_on_Databus <= '1';
							regload <= '1';
						WHEN "0111" =>  --orr
							RFright_on_OpndBus <= '1';
							AorB <= '1';
							ALUout_on_Databus <= '1';
							regload <= '1';
						WHEN "1000" =>  --not
							RFright_on_OpndBus <= '1';
							NotB <= '1';
							ALUout_on_Databus <= '1';
							regload <= '1';
						WHEN "1001" =>  --shl
							RFright_on_OpndBus <= '1';
							ShlB <= '1';
							ALUout_on_Databus <= '1';
							regload <= '1';
						WHEN "1010" =>  --shr
							RFright_on_OpndBus <= '1';
							ShrB <= '1';
							ALUout_on_Databus <= '1';
							regload <= '1';
						WHEN "1011" =>  --add
							RFright_on_OpndBus <= '1';
							AaddB <= '1';
							SRload <= '1';
							ALUout_on_Databus <= '1';
							regload <= '1';
						WHEN "1100" =>  --sub
							RFright_on_OpndBus <= '1';
							AsubB <= '1';
							SRload <= '1';
							ALUout_on_Databus <= '1';
							regload <= '1';
						WHEN "1101" =>  --mul
							RFright_on_OpndBus <= '1';
							AmulB <= '1';
							SRload <= '1';
							ALUout_on_Databus <= '1';
							regload <= '1';
						WHEN "1110" =>  --cmp
							RFright_on_OpndBus <= '1';
							AcmpB <= '1';
							SRload <= '1';
							ALUout_on_Databus <= '1';
							regload <= '1';
						WHEN OTHERS =>
	   					END CASE;
						END IF;
          					END IF;
					END IF;
				END IF;
				END IF;
				WHEN Decode2 =>
					incr <= '0';
					regload <= '0';
					p_en <= '0';
					Shadow <= '0';
					index <= 5;
					PCplus1 <= '0';
					EnablePC <= '0';
					IF (IRout(7 DOWNTO 80) = "00000000") THEN
						Nstate := Nop2;
					ELSE IF (IRout(7 DOWNTO 0) = "00000001") THEN
						Nstate := Halt;
					ELSE
						Nstate := EXE1;
						CASE IRout(7 DOWNTO 0) IS 
						WHEN "00000010" => 
				 			ZSet <= '1';--zfs
						WHEN "00000011" => 
				 			ZReset <= '1';--czf
						WHEN "00000100" => 
							CSet <= '1';--scf
						WHEN "00000101" => 
			 				CReset <= '1';--ccf
						WHEN "00000110" => 
							WPreset <= '1';--cwp
						WHEN OTHERS =>
						END CASE;
						CASE IRout(7 DOWNTO 4) IS
						WHEN "0001" =>  
							RFright_on_OpndBus <= '1';--mvr
							B15to0 <= '1';
							ALUout_on_Databus <= '1';
							regload <= '1';
						WHEN "0010" =>  --lda
							RS_on_AddressUnitRside <= '1';
							Rplus0 <= '1';
							ReadMem <= '1';
							MemDataReady <= '1';
							regload <= '1';
						WHEN "0011" =>  --sta
							RFright_on_OpndBus <= '1';
							B15to0 <= '1';
							ALUout_on_Databus <= '1';
							RD_on_AddressUnitRside <= '1';
							Rplus0 <= '1';
							WriteMem <= '1';
							MemDataReady <= '1';
							regload <= '1';
						WHEN "0100" =>  --inp
								regload <= '1';
								p_en <= '1';
						WHEN "0101" =>  --oup
								ALUout_on_Databus <= '1';
								RFright_on_OpndBus <= '1';
								B15to0 <= '1';
								p_en <= '0';
						WHEN "0110" =>  --and
							RFright_on_OpndBus <= '1';
							AandB <= '1';
							ALUout_on_Databus <= '1';
							regload <= '1';
						WHEN "0111" =>  --orr
							RFright_on_OpndBus <= '1';
							AorB <= '1';
							ALUout_on_Databus <= '1';
							regload <= '1';
						WHEN "1000" =>  --not
							RFright_on_OpndBus <= '1';
							NotB <= '1';
							ALUout_on_Databus <= '1';
							regload <= '1';
						WHEN "1001" =>  --shl
							RFright_on_OpndBus <= '1';
							ShlB <= '1';
							ALUout_on_Databus <= '1';
							regload <= '1';
						WHEN "1010" =>  --shr
							RFright_on_OpndBus <= '1';
							ShrB <= '1';
							ALUout_on_Databus <= '1';
							regload <= '1';
						WHEN "1011" =>  --add
							RFright_on_OpndBus <= '1';
							AaddB <= '1';
							SRload <= '1';
							ALUout_on_Databus <= '1';
							regload <= '1';
						WHEN "1100" =>  --sub
							RFright_on_OpndBus <= '1';
							AsubB <= '1';
							SRload <= '1';
							ALUout_on_Databus <= '1';
							regload <= '1';
						WHEN "1101" =>  --mul
							RFright_on_OpndBus <= '1';
							AmulB <= '1';
							SRload <= '1';
							ALUout_on_Databus <= '1';
							regload <= '1';
						WHEN "1110" =>  --cmp
							RFright_on_OpndBus <= '1';
							AcmpB <= '1';
							SRload <= '1';
							ALUout_on_Databus <= '1';
							regload <= '1';
						WHEN OTHERS =>
	   					END CASE;
						END IF;
					END IF;
				WHEN Nop1 =>
					index <= 6;
					Nstate := Decode2;
					incr <= '0';
					PCplus1 <= '1';
					EnablePC <= '1';
				WHEN Nop2 =>
					index <= 7;
					Nstate := Fetch;
				WHEN Halt =>
					index <= 8;
					Nstate := Decode1;
				WHEN EXE1 =>
					index <= 9;
					p_en <= '0';
					regload <= '0';
					ZSet <= '0';
					ZReset <= '0'; 
					CSet <= '0'; 
			 		CReset <= '0'; 
					WPreset <= '0'; 
					RFright_on_OpndBus <= '0';
					B15to0 <= '0';
					ALUout_on_Databus <= '0';
					RS_on_AddressUnitRside <= '0';
					Rplus0 <= '0';
					ReadMem <= '0';
					MemDataReady <= '0';
					RD_on_AddressUnitRside <= '0';
					WriteMem <= '0';
					MemDataReady <= '0';
					AandB <= '0';
					AorB <= '0';
					NotB <= '0';
					ShlB <= '0';
					ShrB <= '0';
					AaddB <= '0';
					SRload <= '0';
					AsubB <= '0';
					AmulB <= '0';
					AcmpB <= '0';
					WPadd <= '0';
					PCplusI <= '0';
					EnablePC <= '0';
					Nstate := Fetch;
					IF ( incr = '1' ) THEN
						incr <= '0';
						PCplus1 <= '1';
						EnablePC <= '1';
					END IF;
				WHEN EXE2 =>
					index <= 10;
					regload <= '0';
					p_en <= '0';
					ZSet <= '0';
					ZReset <= '0'; 
					CSet <= '0'; 
			 		CReset <= '0'; 
					WPreset <= '0'; 
					RFright_on_OpndBus <= '0';
					B15to0 <= '0';
					ALUout_on_Databus <= '0';
					RS_on_AddressUnitRside <= '0';
					Rplus0 <= '0';
					ReadMem <= '0';
					MemDataReady <= '0';
					RD_on_AddressUnitRside <= '0';
					WriteMem <= '0';
					MemDataReady <= '0';
					AandB <= '0';
					AorB <= '0';
					NotB <= '0';
					ShlB <= '0';
					ShrB <= '0';
					AaddB <= '0';
					SRload <= '0';
					AsubB <= '0';
					AmulB <= '0';
					AcmpB <= '0';
					WPadd <= '0';
					Nstate := Decode2;
					IF ( incr = '1' ) THEN
						incr <= '0';
						PCplus1 <= '1';
						EnablePC <= '1';
					END IF;
				WHEN OTHERS =>
				END CASE;
			END IF;
		END IF;
	END PROCESS;
END dataflow;
