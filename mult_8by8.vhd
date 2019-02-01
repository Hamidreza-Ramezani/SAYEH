LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 

ENTITY m1x1 IS
   PORT (xi, yi, pi, ci : IN std_logic; 
      xo, yo, po, co : OUT std_logic);
END m1x1;
ARCHITECTURE bitwise OF m1x1 IS
SIGNAL xy : std_logic;
BEGIN
   xy <= xi AND yi;
   co <= (pi AND xy) OR (pi AND ci) OR (xy AND ci);
   po <= pi XOR xy XOR ci;
   xo <= xi;
   yo <= yi;
END bitwise;
--------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 

ENTITY mult_8by8 IS
   PORT (x, y : IN std_logic_vector (7 DOWNTO 0); 
       z : OUT std_logic_vector (15 DOWNTO 0));
END mult_8by8;   

ARCHITECTURE bitwise OF mult_8by8 IS 

COMPONENT m1x1 
   PORT (xi, yi, pi, ci : IN std_logic; 
   xo, yo, po, co : OUT std_logic); 
END COMPONENT; 

TYPE pair IS ARRAY (8 DOWNTO 0, 8 DOWNTO 0) OF std_logic;
SIGNAL xv, yv, cv, pv : pair;

BEGIN 
   
   rows : FOR i IN x'RANGE GENERATE
      cols : FOR j IN y'RANGE GENERATE
         cell : m1x1 PORT MAP (xv (i, j), yv (i, j), pv (i, j+1), cv (i, j), xv (i, j+1), yv (i+1, j), pv (i+1, j), cv (i, j+1));
      END GENERATE;
   END GENERATE; 
   
   sides : FOR i IN x'RANGE GENERATE
      xv (i, 0) <= x (i);
      cv (i, 0) <= '0';
      pv (0, i+1) <= '0';
      pv (i+1, x'LENGTH) <= cv (i, x'LENGTH);
      yv (0, i) <= y (i);
      z (i) <= pv (i+1, 0);
      z (i+x'LENGTH) <= pv (x'LENGTH, i+1);
   END GENERATE;    
   
END bitwise;