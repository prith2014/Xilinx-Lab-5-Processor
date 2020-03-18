--Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2016.4 (win64) Build 1756540 Mon Jan 23 19:11:23 MST 2017
--Date        : Wed Nov 29 01:09:28 2017
--Host        : DESKTOP-CT1471N running 64-bit major release  (build 9200)
--Command     : generate_target top_level_design_wrapper.bd
--Design      : top_level_design_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity top_level_design_wrapper is
  port (
    B : out STD_LOGIC_VECTOR ( 4 downto 0 );
    CTS : out STD_LOGIC;
    G : out STD_LOGIC_VECTOR ( 5 downto 0 );
    R : out STD_LOGIC_VECTOR ( 4 downto 0 );
    RTS : in STD_LOGIC;
    btn : in STD_LOGIC;
    clk : in STD_LOGIC;
    hs : out STD_LOGIC;
    rx : in STD_LOGIC;
    tx : out STD_LOGIC;
    vs : out STD_LOGIC
  );
end top_level_design_wrapper;

architecture STRUCTURE of top_level_design_wrapper is
  component top_level_design is
  port (
    CTS : out STD_LOGIC;
    RTS : in STD_LOGIC;
    clk : in STD_LOGIC;
    btn : in STD_LOGIC;
    vs : out STD_LOGIC;
    hs : out STD_LOGIC;
    R : out STD_LOGIC_VECTOR ( 4 downto 0 );
    B : out STD_LOGIC_VECTOR ( 4 downto 0 );
    G : out STD_LOGIC_VECTOR ( 5 downto 0 );
    tx : out STD_LOGIC;
    rx : in STD_LOGIC
  );
  end component top_level_design;
begin
top_level_design_i: component top_level_design
     port map (
      B(4 downto 0) => B(4 downto 0),
      CTS => CTS,
      G(5 downto 0) => G(5 downto 0),
      R(4 downto 0) => R(4 downto 0),
      RTS => RTS,
      btn => btn,
      clk => clk,
      hs => hs,
      rx => rx,
      tx => tx,
      vs => vs
    );
end STRUCTURE;
