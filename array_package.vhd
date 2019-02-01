library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_unsigned.all;


PACKAGE array_package IS
	TYPE regfile IS ARRAY (63 DOWNTO 0) OF std_logic_vector(15 DOWNTO 0);
END array_package;


PACKAGE BODY array_package IS
END PACKAGE BODY array_package;
