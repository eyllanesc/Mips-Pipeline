-- Forwarding Unit (FU) for for pipelined version of MIPS processor
-- Author: Aurelio Morales
-- Course: Sistemas Digitales II
-- Universidad Nacional de Ingenieria
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY FU IS
  PORT( 
		read_register_rs_ex	: IN	STD_LOGIC_VECTOR(4 DOWNTO 0);
		read_register_rt_ex	: IN	STD_LOGIC_VECTOR(4 DOWNTO 0);
		write_register_mem	: IN	STD_LOGIC_VECTOR(4 DOWNTO 0);
		write_register_wb		: IN	STD_LOGIC_VECTOR(4 DOWNTO 0);
		RegWrite_mem 			: IN 	STD_LOGIC;
		RegWrite_wb 			: IN 	STD_LOGIC;
		ForwardA					: OUT	STD_LOGIC_VECTOR(1 DOWNTO 0);
		ForwardB					: OUT	STD_LOGIC_VECTOR(1 DOWNTO 0)
		);
	END FU;

ARCHITECTURE behav OF FU IS

-- TODO: you may need to add convinient signals here

BEGIN

-- TODO: use concurrent assignments for signals and outputs
	
	ForwardA	<= "01"	WHEN RegWrite_mem and (write_register_mem/="00000") and (write_register_mem/= Read_register_rs_ex) ELSE --EX hazard
					"10"	WHEN RegWrite_wb 	and (write_register_mem/="00000") and not (RegWrite_mem and write_register_mem/="00000") and (write_register_mem=read_register_rs_ex) and (write_register_mem=read_register_rs_ex) ELSE
					"00"	WHEN others;
	ForwardB	<= "01"	WHEN RegWrite_mem and (write_register_mem/="00000") and (write_register_mem/= Read_register_rs_ex) ELSE
					"10"	WHEN RegWrite_wb 	and (write_register_mem/="00000") and not (RegWrite_mem and write_register_mem/="00000") and (write_register_mem=read_register_rt_ex) and (write_register_mem=read_register_rt_ex) ELSE	
					"00"	WHEN others;
-- According to Patterson & Hennessy's Book there is no WB hazard because it is
-- assumed that on the same clock cycle the Register File is updated and read with 
-- the correct data on the ID stage. If the Register File and all flip-flops are edge
-- triggered, there will be a hazard if a register is read on the ID stage and at the 
-- same time is written back on WB stage. 
-- You need to modify the ID stage to deliver the forwarded value from WB into ID/EX
		
END behav;