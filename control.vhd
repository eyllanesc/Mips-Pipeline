-- Control Unit for pipelined version of MIPS processor
-- Author: Aurelio Morales
-- Course: Sistemas Digitales II
-- Universidad Nacional de Ingenieria
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY control IS
  PORT( 
		Instruction_id : IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		Jump_id			: OUT 	STD_LOGIC;
		RegWrite_id		: OUT 	STD_LOGIC;
		MemtoReg_id 	: OUT 	STD_LOGIC;
		Branch_id		: OUT 	STD_LOGIC_VECTOR(2 DOWNTO 0);
		MemRead_id 		: OUT 	STD_LOGIC;
		MemWrite_id		: OUT 	STD_LOGIC;
		RegDst_id		: OUT 	STD_LOGIC;
		ALUop_id 		: OUT 	STD_LOGIC_VECTOR(1 DOWNTO 0);
		ALUSrc_id		: OUT 	STD_LOGIC;
		bubble			: IN	STD_LOGIC; -- to stall the pipeline
		id_flush			: IN	STD_LOGIC  -- to flush instructions
		);
END control;

-- TODO: Implement the behavioral description of control unit
ARCHITECTURE behavior OF control IS
-- you may need to create some signals to generate the output signals
	SIGNAL Opcode : STD_LOGIC_VECTOR(5 DOWNTO 0);
	SIGNAL R_format, Lw, Sw, B, Ori, sel: STD_LOGIC;
BEGIN           
	R_format 	<= '1' WHEN Opcode = "000000" ELSE '0';
   Ori         <= '0' WHEN Opcode(3 downto 0) = "1111" ELSE '1';
	Lw 			<= '1' WHEN Opcode = "100011" ELSE '0';
	Sw 			<= '1' WHEN Opcode = "101011" ELSE '0';
	B 				<= '1' WHEN Opcode(5 downto 3) = "000" and opcode/="000000" ELSE '0';
	Opcode		<= Instruction_id (31 DOWNTO 26);
	sel			<=	id_flush	or bubble;
	-- TODO: Code to generate control signals using opcode bits
	RegWrite_id 	<= R_format OR Lw or Ori WHEN sel='0' ELSE '0';
	MemtoReg_id 	<= Lw WHEN sel='0' ELSE '0';
 	Branch_id		<= opcode(2 downto 0) when (opcode (5 downto 3)="000" and opcode(5 downto 2)/="0000" and opcode/= "000000" and sel='0') ELSE "000";
  	MemRead_id		<= Lw WHEN sel='0' ELSE '0';
   MemWrite_id 	<= Sw WHEN sel='0' ELSE '0';
  	RegDst_id    	<= R_format WHEN sel='0' ELSE '0';
	ALUOp_id(1) 	<= (R_format or Ori)and not B WHEN sel='0' ELSE '0';
	ALUOp_id(0) 	<= (ori or B) and not R_format WHEN sel='0' ELSE '0';
	ALUSrc_id  		<=  Lw OR Sw or Ori WHEN sel='0' ELSE '0';
	Jump_id			<=	'1'	WHEN (Opcode="000010" and sel='0')	ELSE '0';
END behavior;