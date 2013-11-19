-- IF/ID register for pipelined version of MIPS processor
-- Author: Aurelio Morales
-- Course: Sistemas Digitales II
-- Universidad Nacional de Ingenieria
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY if_id IS
	PORT(
		PC_plus_4_if	: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		Instruction_if	: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC_plus_4_id	: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		Instruction_id	: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		if_id_write	: IN	STD_LOGIC;
		if_flush	: IN	STD_LOGIC;
		clock		: IN	STD_LOGIC;
		reset		: IN 	STD_LOGIC
		);
END if_id;

-- TODO: Implement the behavioral description of IF/ID register
ARCHITECTURE behavior OF if_id IS
-- TODO: you may need to include signals for easier implementation
BEGIN
	PROCESS(clock, reset)
		BEGIN
			IF(reset='1') THEN
					PC_plus_4_id	<=	X"00000000";
			ELSIF(clock'event and clock='1')	THEN
				IF (if_id_write='1') THEN
						PC_plus_4_id	<=	PC_plus_4_if;
						IF(if_flush='0')	THEN
							Instruction_id	<=	Instruction_if;
						ELSE
							Instruction_id	<=	(others=>'0')
				END IF;
			END IF;
	END PROCESS;
-- TODO: use convenient concurent assignements here	
END behavior;
