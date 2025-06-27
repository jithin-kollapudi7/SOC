library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;
entity AND_NAND is 
			port ( A,B : in std_logic;
						Y : out std_logic);
end entity AND_NAND;
architecture code of AND_NAND is
			signal s : std_logic;
begin 
			okati : NAND2
						port map ( A => A , B => B , Y => s);
			rendu : NAND2
						port map( A => s , B => s , Y => Y);

end Struct;
