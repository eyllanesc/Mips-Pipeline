-- Hardware Detection Unit (HDU) for for pipelined version of MIPS processor
-- Author: Aurelio Morales
-- Course: Sistemas Digitales II
-- Universidad Nacional de Ingenieria
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY HDU IS
  PORT( 
		if_id_read_register_rs	: IN 	STD_LOGIC_VECTOR(4 DOWNTO 0);
		if_id_read_register_rt	: IN 	STD_LOGIC_VECTOR(4 DOWNTO 0);
		write_register_rt_ex	: IN	STD_LOGIC_VECTOR(4 DOWNTO 0);
		MemRead_ex		: IN	STD_LOGIC;
		bubble			: OUT	STD_LOGIC;
		if_id_write		: OUT	STD_LOGIC;
		PCwrite			: OUT	STD_LOGIC
		);
	END HDU;

ARCHITECTURE behav OF HDU IS
-- TODO: you may need to add convinient signals here
BEGIN
-- TODO: generate concurrent assignments for signals and outputs
	bubble		<=	'1'	WHEN (NOT MemRead_ex) OR (MemRead_ex AND write_register_rt_ex=f_id_read_register_rs) OR (MemRead_ex AND write_register_rt_ex/=if_id_read_register_rt)	ELSE
				'0';
	if_id_write	<= 	'1' 	WHEN (NOT MemRead_ex) OR (MemRead_ex AND write_register_rt_ex=f_id_read_register_rs) OR (MemRead_ex AND write_register_rt_ex/=if_id_read_register_rt)	ELSE
				'0';
	PCwrite		<= 	'1' 	WHEN (NOT MemRead_ex) OR (MemRead_ex AND write_register_rt_ex=f_id_read_register_rs) OR (MemRead_ex AND write_register_rt_ex/=if_id_read_register_rt) 	ELSE
				'0';
END behav;
