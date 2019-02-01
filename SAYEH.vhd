library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_unsigned.all;
--use work.array_package.all;
--library work;

ENTITY SAYEH IS
	PORT (
	    clk, External_Reset : IN std_logic;
	    pin : IN std_logic_vector(15 DOWNTO 0);
	    pout : OUT std_logic_vector(15 DOWNTO 0)
	);
END SAYEH;

ARCHITECTURE dataflow OF SAYEH IS
	COMPONENT AddressUnit IS
	PORT (
	    Rside : IN std_logic_vector (15 DOWNTO 0);
	    Iside : IN std_logic_vector (7 DOWNTO 0);
	    Address : OUT std_logic_vector (15 DOWNTO 0);
	    clk, ResetPC, PCplusI, PCplus1 : IN std_logic;
	    RplusI, Rplus0, EnablePC : IN std_logic
		);
	END COMPONENT;
	COMPONENT ArithmeticUnit IS
	PORT (
	    A, B : IN std_logic_vector (15 DOWNTO 0);
	    B15to0, AandB, AorB, NotB, AaddB, AsubB, AmulB, AcmpB,ShrB, ShlB : IN std_logic;
	    Cin, Zin : IN std_logic;
	    Cout, Zout : OUT std_logic;
	    ALUout : OUT std_logic_vector (15 DOWNTO 0)
	   	);
	END COMPONENT;
	COMPONENT CONTROLLER IS
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
	END COMPONENT;
	COMPONENT Flags IS
	PORT (
	    Cin, Zin, clk, CSet, CReset, ZSet, ZReset, SRload : IN std_logic;
	    Zout,Cout : OUT std_logic
	   	);
	END COMPONENT;
	COMPONENT IR IS
	PORT (
	    IRin : IN std_logic_vector (15 DOWNTO 0);
	    IRout : OUT std_logic_vector (15 DOWNTO 0);
	    clk, IRload : IN std_logic
	);
	END COMPONENT;
	COMPONENT Mux IS
	PORT (
	    in1, in2 : IN std_logic_vector (3 DOWNTO 0);
	    Shadow : IN std_logic;
	    ShadowOut : OUT std_logic_vector (3 DOWNTO 0)
	   	);
	END COMPONENT;
	COMPONENT RegisterFile IS
	PORT (
	    Data : IN std_logic_vector (15 DOWNTO 0);
	    Left, Right : OUT std_logic_vector (15 DOWNTO 0);
	    WP : IN std_logic_vector (5 DOWNTO 0);
	    ShadowOut : IN std_logic_vector (3 DOWNTO 0);
	    clk, RFLwrite, RFHwrite, load : IN std_logic
	);
	END COMPONENT;
	COMPONENT WP IS
	PORT (
	    WPin : IN std_logic_vector (5 DOWNTO 0);
	    WPout : OUT std_logic_vector (5 DOWNTO 0);
	    clk, WPadd, WPreset : IN std_logic
	);
	END COMPONENT;

	COMPONENT BUF8 IS
	PORT (
	    EnableBuf : IN std_logic;
	    InBuf : IN std_logic_vector(7 DOWNTO 0);
	    OutBuf : OUT std_logic_vector(7 DOWNTO 0)
	);
	END COMPONENT;
	COMPONENT BUF16 IS
	PORT (
	    EnableBuf : IN std_logic;
	    InBuf : IN std_logic_vector(15 DOWNTO 0);
	    OutBuf : OUT std_logic_vector(15 DOWNTO 0)
	);
	END COMPONENT;
	COMPONENT memory IS
	PORT (
	    address : IN std_logic_vector (15 DOWNTO 0);
	    data_in : IN std_logic_vector (15 DOWNTO 0);
	    data_out : OUT std_logic_vector (15 DOWNTO 0);
	    clk, read, write : IN std_logic );
	END COMPONENT;
---------------------------------------------------------------------------------------------------------

	SIGNAL SRload, Zout, Cout, ZSet, ZReset, CSet, CReset, WPreset, RFright_on_OpndBus, B15to0,ALUout_on_Databus, RS_on_AddressUnitRside, ResetPC, PCplusI, PCplus1, RplusI, Rplus0, ReadMem, MemDataReady,WriteMem, 
		AandB, AaddB, AorB, AmulB, AcmpB, NotB, ShrB, ShlB, AsubB, WPadd, RFLwrite, RFHwrite, EnablePC, RD_on_AddressUnitRside, Address_on_Databus, IRload, Shadow, Zin, Cin, regload, p_en: std_logic;
	SIGNAL IRout, ALUout : std_logic_vector (15 DOWNTO 0);	
	SIGNAL Databus, Databus1, Databus2, Databus3, pdata : std_logic_vector (15 DOWNTO 0);
	SIGNAL WPout : std_logic_vector (5 DOWNTO 0);
	SIGNAL ShadowOut : std_logic_vector (3 DOWNTO 0);
	SIGNAL Rs, Rd, B, AddressUnitRSideBus, Address : std_logic_vector (15 DOWNTO 0);

BEGIN

	U1  : CONTROLLER PORT  MAP (
	      External_Reset, Zin, Cin, clk, IRout, ZSet, ZReset, CSet, CReset, WPreset, RFright_on_OpndBus, B15to0,ALUout_on_Databus, RS_on_AddressUnitRside, ResetPC, PCplusI, PCplus1, RplusI, Rplus0, ReadMem, 
	      MemDataReady, WriteMem, AandB, AaddB, AorB, AmulB, AcmpB, NotB, ShrB, ShlB, AsubB, WPadd, RFLwrite, RFHwrite,EnablePC, RD_on_AddressUnitRside, Address_on_Databus, IRload, regload, p_en, Shadow, SRload);
	U2  : IR PORT MAP (Databus, IRout, clk, IRload);
	U3  : WP PORT MAP (IRout(5 DOWNTO 0), WPout, clk, WPadd, WPreset);
	U4  : Mux PORT MAP (IRout(3 DOWNTO 0), IRout(11 DOWNTO 8), Shadow, ShadowOut);
	U5  : RegisterFile PORT MAP (Databus, Rd, Rs, WPout, ShadowOut, clk, RFLwrite, RFHwrite, regload);
	U6  : BUF16 PORT MAP (RFright_on_OpndBus, Rs, B);
	U7  : ArithmeticUnit PORT MAP (Rd, B, B15to0, AandB, AorB, NotB, AaddB, AsubB, AmulB, AcmpB, ShrB, ShlB, Cin, Zin, 
	      Cout, Zout, ALUout);
	U8  : BUF16 PORT MAP (ALUout_on_Databus, ALUout, Databus1);
	U9  : Flags PORT MAP (Cout, Zout, clk, CSet, CReset, ZSet, ZReset, SRload, Zin, Cin);
	U10 : BUF16 PORT MAP (RD_on_AddressUnitRside, Rd, AddressUnitRSideBus);
	U11 : BUF16 PORT MAP (RS_on_AddressUnitRside, Rs, AddressUnitRSideBus);
	U12 : BUF16 PORT MAP (Address_on_Databus, Address, Databus2);
	U13 : AddressUnit PORT MAP ( AddressUnitRSideBus, IRout(7 DOWNTO 0), Address, clk, ResetPC, PCplusI, PCplus1,RplusI, Rplus0, EnablePC);
	U14 : memory PORT MAP (Address, Databus, Databus3, clk, ReadMem, WriteMem);
	U15 : BUF16 PORT MAP (p_en, pin, pdata);
	Databus <= Databus1 or Databus2 or Databus3 or pdata;
	pout <= Databus;
	
END dataflow;
