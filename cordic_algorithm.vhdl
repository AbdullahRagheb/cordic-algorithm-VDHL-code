library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cordic_algorithm is
  generic (
    ANGLE_WIDTH : integer := 16;  -- Example generic for angle width
    OUTPUT_WIDTH : integer := 16  -- Example generic for output width
  );
  port (
    clk    : in  std_logic;
    angle  : in  signed(ANGLE_WIDTH - 1 downto 0);
    sine   : out signed(OUTPUT_WIDTH - 1 downto 0);
    cosine : out signed(OUTPUT_WIDTH - 1 downto 0);
    reset  : in  std_logic
  );
end entity cordic_algorithm;

architecture behavioral of cordic_algorithm is
  signal iter_count : integer range 0 to 16 := 16;
  signal angle_temp : signed(ANGLE_WIDTH - 1 downto 0);
  signal updated_angle : signed(ANGLE_WIDTH - 1 downto 0);

begin
  -- CORDIC algorithm implementation
  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        sine   <= (others => '0');
        cosine <= (others => '0');
      else
        if iter_count > 0 then
          angle_temp <= angle;
          -- Pre-defined k values for 16 iterations (circular CORDIC)
          case iter_count is
            when 16 =>
              cosine <= cosine + sine;
              sine   <= sine - cosine;
              angle_temp <= angle_temp + resize(signed'("1"), ANGLE_WIDTH);
            when 14 | 12 | 10 | 8 | 6 | 4 | 2 =>
              cosine <= cosine + sine * resize(signed'("01"), OUTPUT_WIDTH);
              sine   <= sine - cosine * resize(signed'("01"), OUTPUT_WIDTH);
              angle_temp <= angle_temp + resize(signed'("1"), ANGLE_WIDTH) * (2 ** (iter_count - 2));
            when others =>
              cosine <= cosine - sine * resize(signed'("01"), OUTPUT_WIDTH);
              sine   <= sine + cosine * resize(signed'("01"), OUTPUT_WIDTH);
              angle_temp <= angle_temp - resize(signed'("1"), ANGLE_WIDTH) * (2 ** (iter_count - 2));
          end case;
          iter_count <= iter_count - 1;
        end if;
      end if;
    end if;
  end process;
  
  updated_angle <= angle_temp;

end architecture behavioral;