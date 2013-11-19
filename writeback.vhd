-- Writeback stage for pipelined version of MIPS processor	
-- Author: Aurelio Morales
-- Course: Sistemas Digitales II
-- Universidad Nacional de Ingenieria					
LIBRARY IEEE; 			
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY WriteBack IS
  PORT(	
		read_data_wb	: IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		ALU_result_wb	: IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		MemtoReg_wb	: IN  STD_LOGIC;
		write_data_wb	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	  );
END WriteBack;

ARCHITECTURE behavior OF WriteBack IS

BEGIN

	write_data_wb	<= read_data_wb when MemtoReg_wb='0' else ALU_result_wb; -- TODO: complete

END behavior;
