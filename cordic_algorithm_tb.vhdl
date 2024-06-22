library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cordic_algorithm_tb is
end entity cordic_algorithm_tb;

architecture behavioral of cordic_algorithm_tb is
  -- Constants
  constant ANGLE_WIDTH : integer := 16;
  constant OUTPUT_WIDTH : integer := 16;
  constant CLK_PERIOD : time := 10 ns;  -- Clock period
  
  -- Signals
  signal clk : std_logic := '0';
  signal angle : signed(ANGLE_WIDTH - 1 downto 0) := (others => '0');
  signal sine : signed(OUTPUT_WIDTH - 1 downto 0);
  signal cosine : signed(OUTPUT_WIDTH - 1 downto 0);
  signal reset : std_logic := '0';
  
begin
  -- Instantiate the DUT (Design Under Test)
  uut: entity work.cordic_algorithm
    generic map (
      ANGLE_WIDTH => ANGLE_WIDTH,
      OUTPUT_WIDTH => OUTPUT_WIDTH
    )
    port map (
      clk => clk,
      angle => angle,
      sine => sine,
      cosine => cosine,
      reset => reset
    );
  
  -- Clock generation process
  clk_process: process
  begin
    while now < 1000 ns loop
      clk <= '0';
      wait for CLK_PERIOD / 2;
      clk <= '1';
      wait for CLK_PERIOD / 2;
    end loop;
    wait;
  end process clk_process;
  
  -- Stimulus process
  stimulus_process: process
  begin
    -- Reset initially
    reset <= '1';
    wait for CLK_PERIOD;
    reset <= '0';
    
    -- Wait for a few clock cycles before providing inputs
    wait for 5 * CLK_PERIOD;
    
    -- Provide angle input
    angle <= to_signed(45, ANGLE_WIDTH);
    
    -- Wait for the algorithm to compute
    wait for 16 * CLK_PERIOD;
    
    -- Display the results
    report "Sine: " & to_string(sine);
    report "Cosine: " & to_string(cosine);
    
    -- End the simulation
    wait;
  end process stimulus_process;
  
end architecture behavioral;