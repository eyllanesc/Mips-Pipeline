-- Dmemory module for pipelined version of MIPS processor
-- This module implements the data memory for the MIPS computer
-- Author: Aurelio Morales
-- Course: Sistemas Digitales II
-- Universidad Nacional de Ingenieria
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY MEMory IS
  PORT(	
		Branch_mem		: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
		Zero_mem			: IN	STD_LOGIC;
		Overflow_mem	: IN	STD_LOGIC;
		Negative_mem	: IN 	STD_LOGIC;
		MemRead_mem		: IN	STD_LOGIC;
		Memwrite_mem	: IN 	STD_LOGIC;
		ALU_Result_mem	: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		write_data_mem	: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		PCSrc_mem		: OUT	STD_LOGIC;
		branch_flush	: OUT	STD_LOGIC;
		read_data_mem	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		clkd				: IN	STD_LOGIC
		);
END MEMory;

ARCHITECTURE behavior OF MEMory IS
	
	SIGNAL write_clock 	: STD_LOGIC;

BEGIN
	data_memory : altsyncram
	GENERIC MAP (
		operation_mode			=> "SINGLE_PORT",
		width_a 					=> 32,
		widthad_a 				=> 10,
		lpm_type 				=> "altsyncram",
		outdata_reg_a 			=> "UNREGISTERED",
		init_file 				=> "dmemory.mif",
		intended_device_family	=> "Cyclone II",
		LPM_HINT 				=> "ENABLE_RUNTIME_MOD=YES,INSTANCE_NAME=data")
	PORT MAP (
		wren_a 		=> Memwrite_mem,
		clock0 		=> write_clock,
		address_a 	=> ALU_Result_mem(11 DOWNTO 2), -- NOTE: must be word aligned address
		data_a 		=> write_data_mem,
		q_a 		=> read_data_mem);
		
	-- Load memory address register with write clock
	write_clock		<= NOT clkd;
	
	PCSrc_mem		<= Zero_mem 		WHEN Branch_mem="100" ELSE
							not Zero_mem 	WHEN Branch_mem="101" ELSE
							(Negative_mem and (not Overflow_mem))or((not Negative_mem) and Overflow_mem) WHEN Branch_mem="001" ELSE
							(Negative_mem and (not Overflow_mem))or((not Negative_mem) and Overflow_mem) or Zero_mem WHEN Branch_mem="110" ELSE
							(not Negative_mem) and ((not negative_mem and not Overflow_mem) or (Negative_mem and Overflow_mem)) WHEN Branch_mem="111" ELSE
							'0' WHEN others; -- only for beq
	branch_flush	<= ; -- only for beq
END behavior;