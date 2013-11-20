-- IFetch stage for pipelined version of MIPS processor
-- This module provides the PC and instruction memory for the MIPS computer
-- Author: Aurelio Morales
-- Course: Sistemas Digitales II
-- Universidad Nacional de Ingenieria
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY IFetch IS
  PORT( 
		PCSrc_if	: IN	STD_LOGIC; -- replaces "Branch AND Zero" (now in MEMory)
		PCwrite		: IN	STD_LOGIC;
		Jump_if		: IN	STD_LOGIC;
		jump_address_if	: IN	STD_LOGIC_VECTOR(25 DOWNTO 0);
		Add_result_if 	: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC_plus_4_if	: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC_out_if 	: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		Instruction_if 	: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		clock		: IN	STD_LOGIC;
		reset 		: IN 	STD_LOGIC
		);
END IFetch;

ARCHITECTURE behavior OF Ifetch IS
-- some convenient signals. You may need to add more signals
	SIGNAL PC, PC_plus_4, PCBranch	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Read_Address 		: STD_LOGIC_VECTOR( 9 DOWNTO 0);
	SIGNAL clock_int		: STD_LOGIC;
	
BEGIN
	--ROM for Instruction Memory
	inst_memory: altsyncram
	GENERIC MAP (
		operation_mode		=> "ROM",
		width_a			=> 32,
		widthad_a		=> 10,
		lpm_type		=> "altsyncram",
		outdata_reg_a		=> "UNREGISTERED",
		init_file		=> "program.mif",
		intended_device_family 	=> "Cyclone II",
		LPM_HINT 		=> "ENABLE_RUNTIME_MOD=YES,INSTANCE_NAME=inst")
	PORT MAP (
		clock0		=>	clock_int,
		address_a 	=> 	Read_Address, 
		q_a 		=> 	Instruction_if);
		PC_out_if	<=	PC;
		PC_plus_4_if	<= 	PC_plus_4;
		clock_int	<= 	NOT clock;
		Read_Address	<=	PC(11 DOWNTO 2) ; -- NOTE: address must be word aligned
	-- TODO: Specify how to obtain PC+4
		PC_plus_4	<=	PC+4;
	-- TODO: Specify how the PC is updated
		PCBranch 	<= 	PC_plus_4	WHEN	PCSrc_if='0'	ELSE
 		Add_result_if; 
		PC		<= 	Jump_address_if WHEN 	jump_if='1' 	ELSE
 		PCBranch;
	PROCESS(clock, reset)
		BEGIN
			IF(reset='1') THEN
					PC	<=	(OTHERS => '0');
			ELSIF(clock'event and clock='1')	THEN
				IF (PCWrite='1') THEN
					PC	<=	Next_PC;
				END IF;
			END IF;
	END PROCESS;
END behavior;
