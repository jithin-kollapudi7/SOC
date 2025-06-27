library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity word_detection is 
    port ( 
        reset, clock : in std_logic;        -- Changed to 'clock' for consistency
        input : in std_logic_vector(4 downto 0);
        output : out std_logic
    );
end word_detection;

architecture logic of word_detection is 
    type state is (rst, s1, s2, s3, s4);
    signal y1_present, y2_present, y3_present, y1_next, y2_next, y3_next : state := rst;
    signal output1, output2, output3 : std_logic;
begin 
    clock_proc : process(clock, reset)
    begin
        if ((clock'event) and (clock = '1')) then  -- Explicit edge detection with parentheses
            if (reset = '1') then
                y1_present <= rst;
                y2_present <= rst;
                y3_present <= rst;
            else 
                y1_present <= y1_next;
                y2_present <= y2_next;
                y3_present <= y3_next;
            end if;
        end if;
    end process;

    state_transition1 : process(input, y1_present)
    begin 
        case y1_present is 
            when rst =>
                if (input = "01101") then  -- m
                    y1_next <= s1;
                else
                    y1_next <= y1_present;
                end if;
                output1 <= '0';

            when s1 =>
                if (input = "10101") then  -- u
                    y1_next <= s2;
                else
                    y1_next <= y1_present;
                end if;
                output1 <= '0';

            when s2 =>
                if (input = "10011") then  -- s
                    y1_next <= s3;
                else
                    y1_next <= y1_present;
                end if;
                output1 <= '0';

            when s3 =>
                if (input = "10100") then  -- t 
                    y1_next <= s4;
                else
                    y1_next <= y1_present;
                end if;
                output1 <= '0';

            when s4 =>
                if (input = "11100") then  -- 1
                    y1_next <= rst;	
                    output1 <= '1';
                else
                    y1_next <= y1_present;
                    output1 <= '0';
                end if;
        end case;
    end process;

    state_transition2: process(input, y2_present)
    begin
        case y2_present is
            when rst =>
                if (input = "01100") then  -- l
                    y2_next <= s1;
                else
                    y2_next <= y2_present;
                end if;
                output2 <= '0';
            when s1 =>
                if (input = "01001") then  -- i
                    y2_next <= s2;
                else
                    y2_next <= y2_present;
                end if;
                output2 <= '0';
            when s2 =>
                if (input = "01111") then  -- o
                    y2_next <= s3;
                else
                    y2_next <= y2_present;
                end if;
                output2 <= '0';
            when s3 =>
                if (input = "01110") then  -- n
                    y2_next <= s4;
                else
                    y2_next <= y2_present;
                end if;
                output2 <= '0';
            when s4 =>
                if (input = "11101") then  -- 2
                    y2_next <= rst;
                    output2 <= '1';
                else
                    y2_next <= y2_present;
                    output2 <= '0';
                end if;
        end case;
    end process;

    state_transition3: process(input, y3_present)
    begin
        case y3_present is
            when rst =>
                if (input = "10010") then  -- r
                    y3_next <= s1;
                else
                    y3_next <= y3_present;
                end if;
                output3 <= '0';
            when s1 =>
                if (input = "01001") then  -- i
                    y3_next <= s2;
                else
                    y3_next <= y3_present;
                end if;
                output3 <= '0';
            when s2 =>
                if (input = "01110") then  -- n
                    y3_next <= s3;
                else
                    y3_next <= y3_present;
                end if;
                output3 <= '0';
            when s3 =>
                if (input = "00111") then  -- g
                    y3_next <= s4;
                else
                    y3_next <= y3_present;
                end if;
                output3 <= '0';
            when s4 =>
                if (input = "11110") then  -- 3
                    y3_next <= rst;
                    output3 <= '1';
                else
                    y3_next <= y3_present;
                    output3 <= '0';
                end if;
        end case;
    end process;
    
    output <= output1 or output2 or output3;
end architecture;
