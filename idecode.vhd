-- IDecode stage for pipelined version of MIPS processor
-- This module implements the register file for the MIPS computer
-- Author: Aurelio Morales
-- Course: Sistemas Digitales II
-- Universidad Nacional de Ingenieria
LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY IDecode IS
  PORT(	
		Instruction_id		: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		RegWrite 		: IN 	STD_LOGIC;
		read_data_1_id		: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		read_data_2_id		: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		Sign_extend_id 		: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		Opcode_id		: OUT	STD_LOGIC_VECTOR( 5 DOWNTO 0);
		write_register_rt_id	: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0);
		write_register_rd_id	: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0);
		read_register_rs_id	: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0); -- for FU
		read_register_rt_id	: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0); -- for FU
		write_data_id		: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		write_register_id	: IN	STD_LOGIC_VECTOR( 4 DOWNTO 0);
		jump_address_id		: OUT STD_LOGIC_VECTOR(25 DOWNTO 0); 
		clock			: IN	STD_LOGIC;
		reset			: IN 	STD_LOGIC
		);
END IDecode;

ARCHITECTURE behavior OF IDecode IS

	TYPE register_file IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL register_array			: register_file;
	SIGNAL read_register_1_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0);
	SIGNAL read_register_2_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0);
	--SIGNAL write_register_address_rt	: STD_LOGIC_VECTOR( 4 DOWNTO 0);
	SIGNAL write_register_address_rd	: STD_LOGIC_VECTOR( 4 DOWNTO 0);
	SIGNAL Instruction_immediate_value	: STD_LOGIC_VECTOR(15 DOWNTO 0);
-- you may need to add some signals if problem found at synthesizing this module

BEGIN
	read_register_1_address 	<= 	Instruction_id(25 DOWNTO 21);
	read_register_2_address 	<= 	Instruction_id(20 DOWNTO 16);
   	--write_register_address_rt 	<= 	Instruction_id(20 DOWNTO 16);
   	write_register_address_rd	<= 	Instruction_id(15 DOWNTO 11);
	Instruction_immediate_value	<=	Instruction_id(15 DOWNTO  0);
	Opcode_id			<=	Instruction_id(5 downto 0); -- complete
	write_register_rt_id		<= read_register_2_address; -- complete
	write_register_rd_id		<= write_register_address_rd; -- complete
	read_register_rs_id		<= read_register_1_address; -- complete
	read_register_rt_id		<= read_register_2_address; -- complete
	-- TODO: Read Register 1 Operation
	read_data_1_id 	<=	register_array(CONV_INTEGER( read_register_1_address) );
	-- TODO: Read Register 2 Operation		 
	read_data_2_id 	<= 	register_array(CONV_INTEGER( read_register_2_address) );
	-- TODO: Generate Sign_extend signal
	Sign_extend_id 	<=	X"0000" & Instruction_immediate_value	WHEN	Instruction_immediate_value(15) = '0'	ELSE 
				X"FFFF" & Instruction_immediate_value;
	--JUMp_address_id
	jump_address_id<=instruction_id(25 DOWNTO 0);
	-- TODO: Specify the process to update the register file
	PROCESS(clock, reset)
		BEGIN
			IF reset = '1' THEN
			--Initial register values on reset are register = 0
				FOR i IN 0 TO 31 LOOP
					register_array(i) <= (OTHERS =>'0');
				END LOOP;
			ELSIF clock'EVENT AND clock = '1' THEN
				IF RegWrite = '1' AND write_register_id /= 0 THEN
					register_array( CONV_INTEGER( write_register_id)) <= write_data_id;
				END IF;
			END IF;
	END PROCESS;
END behavior;
