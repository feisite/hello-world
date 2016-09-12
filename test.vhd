----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2016/09/11 20:16:39
-- Design Name: 
-- Module Name: test - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test is
Port ( 
    rst         : in    std_logic;
    clk         : in    std_logic;

    datain      : in    std_logic_vector(31 downto 0);
    dataout     : out   std_logic_vector(15 downto 0)
    
    );
end test;

architecture Behavioral of test is
signal datain_en : std_logic;
signal dataout_en : std_logic;
signal fifo_cnt : std_logic_vector(31 downto 0);
signal input_en,output_en : std_logic;
signal input_en_reg,output_en_reg : std_logic;

-------fifo_input--------
signal wr_clk : std_logic;
signal rd_clk : std_logic;
signal din : std_logic_vector(31 downto 0);
signal wr_en : std_logic;
signal rd_en : std_logic;
signal dout : std_logic_vector(31 downto 0);
signal full : std_logic;
signal empty : std_logic;

-------pll_clk1------
signal CLK_IN1 : std_logic;
signal CLK_OUT1 : std_logic;
signal RESET : std_logic;

-------模块映射--fifo_input------
component fifo_generator_v9_3_0 is
port(
    rst : IN STD_LOGIC;
    wr_clk : IN STD_LOGIC;
    rd_clk : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC
);
end component;

------映射模块--pll_clk1----------
component clk_wiz_v4_4_0 is
port(
    -- Clock in ports
    CLK_IN1 : in std_logic;
    -- Clock out ports
    CLK_OUT1 : out std_logic;
    -- Status and control signals
    RESET : in std_logic
);
end component;

begin

process(rst,clk)
begin
if rst = '0' then
    fifo_cnt <= x"00000000";
elsif clk'event and clk = '1' then
    fifo_cnt <= fifo_cnt + '1';
end if;
end process;

process(rst,clk)
begin
  if rst = '1' then
    input_en <= '0';
    output_en <= '0';
  else
    case fifo_cnt is
      when x"01010101" =>
        input_en <= '1';
      when x"10101010" =>
        output_en <= '1';
      when others =>
        input_en <= '0';
        output_en <= '0';
    end case;
  end if;
end process;

input_en_reg <= input_en and (not full);
output_en_reg <= output_en and (not empty);

fifo_input : fifo_generator_v9_3_0
port map
  (
    rst        => rst, 
    wr_clk     => clk,
    rd_clk     => CLK_OUT1,
    din        => datain,
    wr_en      => input_en,
    rd_en      => output_en,
    dout       => dataout,
    full       => input_en_reg,
    empty      => output_en_reg
    );

pll_clk :  clk_wiz_v4_4_0
  port map
  (
    CLK_IN1     => clk,
    CLK_OUT1    => CLK_OUT1,
    RESET       => rst
  );


end Behavioral;

