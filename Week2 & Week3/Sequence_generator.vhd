library ieee;
use ieee.std_logic_1164.all;
package Flipflops is
component dff_set is
							port(D,clock,set:in std_logic;
									Q:out std_logic);
end component dff_set;

component dff_reset is
							port(D,clock,reset:in std_logic;
									Q:out std_logic);
end component dff_reset;
end package Flipflops;

library ieee;
use ieee.std_logic_1164.all;
entity dff_set is
							port(D,clock,set:in std_logic;
									Q:out std_logic);
end entity dff_set;
architecture code of dff_set is
begin
dff_set_proc : process(clock,set)
begin 
if(set = '1') then
Q <= '1';
elsif(clock'event and (clock = '1')) then
Q <= D;
end if ;
end process dff_set_proc;
end code;

library ieee;
use ieee.std_logic_1164.all;
entity dff_reset is
							port(D,clock,reset:in std_logic;
									Q:out std_logic);
end entity dff_reset;
architecture code of dff_reset is
begin
dff_reset_proc : process(clock,reset)
begin 
if(reset = '1') then
Q <= '0';
elsif(clock'event and (clock = '1')) then
Q <= D;
end if ;
end process dff_reset_proc;
end code;

library ieee;
use ieee.std_logic_1164.all;
use work.Flipflops.all;
entity Sequence_generator_stru_dataflow is
										port (reset,clock: in std_logic;
												y:out std_logic);
end entity Sequence_generator_stru_dataflow;

architecture code of Sequence_generator_stru_dataflow is
signal D : std_logic_vector(2 downto 0);
signal Q : std_logic_vector(2 downto 0);
begin
    D(2) <= (not Q(2) and Q(1) and Q(0)) or (Q(2) and not Q(1)) or (Q(2) and not Q(0));
    D(1) <= Q(1) xor Q(0);
    D(0) <= (not Q(0)) or (Q(2) and Q(1));

    y <= Q(0);  

    -- Corrected flip-flop connections:
    DFF2: dff_reset port map(D(2), clock, reset, Q(2));  -- Reset to '0'
    DFF1: dff_reset port map(D(1), clock, reset, Q(1));  -- Reset to '0'
    DFF0: dff_set   port map(D(0), clock, reset, Q(0));  -- SET to '1' (reset signal drives set)
	 
end code;
