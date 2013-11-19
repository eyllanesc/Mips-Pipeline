-- ID/EX register for pipelined version of MIPS processor
-- Author: Aurelio Morales
-- Course: Sistemas Digitales II
-- Universidad Nacional de Ingenieria
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY id_ex IS
   PORT(
	Jump_id			: IN	STD_LOGIC;
	RegWrite_id 		: IN 	STD_LOGIC;
	MemtoReg_id 		: IN 	STD_LOGIC;
	Branch_id 		: IN 	STD_LOGIC;
	MemRead_id 		: IN 	STD_LOGIC;
	MemWrite_id 		: IN 	STD_LOGIC;
	RegDst_id 		: IN 	STD_LOGIC;
	ALUOp_id 		: IN 	STD_LOGIC_VECTOR(1 DOWNTO 0);
	ALUSrc_id 		: IN 	STD_LOGIC;
	Opcode_id		: IN	STD_LOGIC_VECTOR( 5 DOWNTO 0);
	PC_plus_4_id 		: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
	read_data_1_id		: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
	read_data_2_id		: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
	Sign_extend_id 		: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
	write_register_rt_id	: IN	STD_LOGIC_VECTOR( 4 DOWNTO 0);
	write_register_rd_id	: IN	STD_LOGIC_VECTOR( 4 DOWNTO 0);
	read_register_rs_id	: IN	STD_LOGIC_VECTOR( 4 DOWNTO 0); -- for FU
	read_register_rt_id	: IN	STD_LOGIC_VECTOR( 4 DOWNTO 0); -- for FU
	Jump_ex			: OUT	STD_LOGIC;
	RegWrite_ex 		: OUT 	STD_LOGIC;
	MemtoReg_ex 		: OUT 	STD_LOGIC;
	Branch_ex 		: OUT 	STD_LOGIC;
	MemRead_ex 		: OUT 	STD_LOGIC;
	MemWrite_ex 		: OUT 	STD_LOGIC;
	RegDst_ex 		: OUT 	STD_LOGIC;
	ALUOp_ex 		: OUT 	STD_LOGIC_VECTOR(1 DOWNTO 0);
	ALUSrc_ex 		: OUT 	STD_LOGIC;
	Opcode_ex		: OUT	STD_LOGIC_VECTOR( 5 DOWNTO 0);
	PC_plus_4_ex 		: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
	read_data_1_ex		: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
	read_data_2_ex		: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
	Sign_extend_ex 		: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
	write_register_rt_ex	: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0);
	write_register_rd_ex	: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0);
	read_register_rs_ex	: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0); -- for FU
	read_register_rt_ex	: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0); -- for FU
	clock			: IN	STD_LOGIC;
	reset			: IN 	STD_LOGIC
	   );
END id_ex;

ARCHITECTURE behavior OF id_ex IS

BEGIN           
	PROCESS(clock, reset)
		BEGIN
		IF(reset='1') THEN
			Jump_ex			<= 	(others=>'0');	
			RegWrite_ex		<=	(others=>'0');
			MemtoReg_ex		<=	(others=>'0');
			Branch_ex		<=	(others=>'0');
			MemRead_ex		<=	(others=>'0');
			MemWrite_ex		<=	(others=>'0');
			RegDst_ex		<=	(others=>'0');
			Aluop_ex		<=	(others=>'0');
			AluSrc_ex		<= 	(others=>'0');
			Opcode_ex		<= 	(others=>'0');
			PC_plus_4_ex		<= 	(others=>'0');
			read_data_1_ex		<= 	(others=>'0');
			read_data_2_ex		<=	(others=>'0');
			Sign_extend_ex		<=	(others=>'0');
			write_register_rt_ex	<=	(others=>'0');
			write_register_rd_ex	<=	(others=>'0');
			read_register_rs_ex	<=	(others=>'0');
			read_register_rt_ex	<=	(others=>'0');
		ELSIF(clock'event and clock='1')	THEN
			Jump_ex			<=	Jump_id;
			RegWrite_ex		<=	RegWrite_id;
			MemtoReg_ex		<=	MemtoReg_id;
			Branch_ex		<=	Branch_id;
			MemRead_ex		<=	MemRead_id;
			MemWrite_ex		<=	MemWrite_id;
			RegDst_ex		<=	RegDst_id;
			Aluop_ex		<=	AluOp_id;
			AluSrc_ex		<=	Opcode_id;
			Opcode_ex		<= 	Opcode_id;
			PC_plus_4_ex		<= 	PC_plus_4_id;
			read_data_1_ex		<=	read_data_1_id;
			read_data_2_ex		<=	read_data_2_id;
			Sign_extend_ex		<=	Sign_extend_id;
			write_register_rt_ex	<=	write_register_rt_id;
			write_register_rd_ex	<=	write_register_rd_id;
			read_register_rs_ex	<=	read_register_rs_id;
			read_register_rt_ex	<=	read_register_rt_id;
		END IF;
	END PROCESS;
END behavior;
