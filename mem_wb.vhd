-- MEM/WB register for pipelined version of MIPS processor
-- Author: Aurelio Morales
-- Course: Sistemas Digitales II
-- Universidad Nacional de Ingenieria
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mem_wb IS
   PORT(
	RegWrite_mem 		: IN 	STD_LOGIC;
	MemtoReg_mem 		: IN	STD_LOGIC;
	read_data_mem		: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
	ALU_Result_mem 		: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
	write_register_mem	: IN	STD_LOGIC_VECTOR( 4 DOWNTO 0);
	RegWrite_wb 		: OUT 	STD_LOGIC;
	MemtoReg_wb 		: OUT	STD_LOGIC;
	read_data_wb		: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
	ALU_Result_wb 		: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
	write_register_wb	: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0);
	clock			: IN	STD_LOGIC;
	reset			: IN 	STD_LOGIC
	   );

END mem_wb;

ARCHITECTURE behavior OF mem_wb IS

BEGIN           
	PROCESS(clock, reset)
		BEGIN
			IF(reset='1')	THEN
				RegWrite_wb 		<=	(others=>'0');
				MemtoReg_wb 		<=	(others=>'0');
				read_data_wb		<=	(others=>'0');
				ALU_Result_wb 		<=	(others=>'0');
				write_register_wb	<=	(others=>'0');
			ELSIF	(clock'event and clock='1')	THEN
				RegWrite_wb 		<=	RegWrite_mem;
				MemtoReg_wb 		<=	MemtoReg_mem;
				read_data_wb		<=	read_data_mem;
				ALU_Result_wb 		<=	ALU_Result_mem;
				write_register_wb	<=	write_register_mem;
	END PROCESS;
END behavior;
