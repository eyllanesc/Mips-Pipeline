-- EX/MEM register for pipelined version of MIPS processor
-- Author: Aurelio Morales
-- Course: Sistemas Digitales II
-- Universidad Nacional de Ingenieria
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ex_mem IS
   PORT(
		RegWrite_ex 		: IN 	STD_LOGIC;
		MemtoReg_ex 		: IN 	STD_LOGIC;
		Branch_ex 			: IN 	STD_LOGIC;
		MemRead_ex 			: IN 	STD_LOGIC;
		MemWrite_ex 		: IN 	STD_LOGIC;
		Add_Result_ex 		: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		Zero_ex				: IN	STD_LOGIC;
		ALU_Result_ex 		: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		write_data_ex		: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		write_register_ex	: IN	STD_LOGIC_VECTOR( 4 DOWNTO 0);
		RegWrite_mem 		: OUT STD_LOGIC;
		MemtoReg_mem 		: OUT	STD_LOGIC;
		Branch_mem 			: OUT STD_LOGIC;
		MemRead_mem 		: OUT STD_LOGIC;
		MemWrite_mem 		: OUT STD_LOGIC;
		Add_Result_mem 	: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		Zero_mem				: OUT	STD_LOGIC;
		ALU_Result_mem 	: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		write_data_mem		: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		write_register_mem: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0);
		clock					: IN	STD_LOGIC;
		reset					: IN 	STD_LOGIC
	   );
END ex_mem;

ARCHITECTURE behavior OF ex_mem IS

BEGIN           
	PROCESS(clock, reset) 
		BEGIN
			IF(reset='1') THEN
				RegWrite_mem		<= (others=>'0');
				MemtoReg_mem 		<=	(others=>'0');
				Branch_mem 			<=	(others=>'0');
				MemRead_mem 		<=	(others=>'0');
				MemWrite_mem 		<=	(others=>'0');
				Add_Result_mem 	<=	(others=>'0');
				Zero_mem				<=	(others=>'0');
				ALU_Result_mem 	<=	(others=>'0');
				write_data_mem		<=	(others=>'0');
				write_register_mem<=	(others=>'0');
			ELSIF(clock'event and clock='1')	THEN
				RegWrite_mem		<= RegWrite_ex;
				MemtoReg_mem 		<=	MemtoReg_ex;
				Branch_mem 			<=	Branch_ex;
				MemRead_mem 		<=	MemRead_ex;
				MemWrite_mem 		<=	MemWrite_ex;
				Add_Result_mem 	<=	Add_Result_ex;
				Zero_mem				<=	Zero_ex;
				ALU_Result_mem 	<=	ALU_Result_ex;
				write_data_mem		<=	write_data_ex;
				write_register_mem<=	write_register_ex;
			END IF;
	END PROCESS;
END behavior;