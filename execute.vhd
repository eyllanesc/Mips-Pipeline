-- EXEcute stage for pipelined version of MIPS processor
-- This module implements the data ALU and Branch Address Adder for the MIPS computer
-- Author: Aurelio Morales
-- Course: Sistemas Digitales II
-- Universidad Nacional de Ingenieria
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY EXEcute IS
  PORT(	
		Opcode_ex 		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0); -- for arithmetic/logic I-format instructions
		RegDst_ex		: IN	STD_LOGIC;
		ALUOp_ex 		: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0);
		ALUSrc_ex 		: IN 	STD_LOGIC;
		PC_plus_4_ex 		: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		Read_data_1_ex		: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		Read_data_2_ex		: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		Sign_extend_ex		: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		write_register_rt_ex	: IN	STD_LOGIC_VECTOR( 4 DOWNTO 0);
		write_register_rd_ex	: IN	STD_LOGIC_VECTOR( 4 DOWNTO 0);
		Zero_ex 		: OUT	STD_LOGIC;
		Overflow_ex		: OUT	STD_LOGIC;
		Negative_ex		: OUT STD_LOGIC;
		Add_Result_ex 		: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		write_data_ex		: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		write_register_ex	: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0);
		ForwardA		: IN	STD_LOGIC_VECTOR( 1 DOWNTO 0); -- for FU
		ForwardB		: IN	STD_LOGIC_VECTOR( 1 DOWNTO 0); -- for FU
		ALU_Result_mem 		: IN	STD_LOGIC_VECTOR(31 DOWNTO 0); -- forwarded from MEM
		write_data_wb		: IN	STD_LOGIC_VECTOR(31 DOWNTO 0)  -- forwarded from WB
		);
END EXEcute;

-- TODO: Implement the behavioral description of EXE stage
ARCHITECTURE behavior OF EXEcute IS
-- TODO: you may need to include more signals for easier implementation
	SIGNAL Func_opcode	: 	STD_LOGIC_VECTOR(5 DOWNTO 0);
	SIGNAL ALU_ctl		: 	STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Ainput,	Binput	:	STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ALU_output_mux	:	STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL pre_Binput	:	STD_LOGIC_VECTOR(31 DOWNTO 0);	
BEGIN
-- TODO: add necessary concurrent assignments
	write_register_ex 	<=	write_register_rt_ex	WHEN	RegDst_ex ='0'	ELSE
					write_register_rd_ex;
	write_data_ex		<=	pre_Binput;
	Add_Result_ex		<=	Sign_extend_ex(29 downto 0)&"00"+PC_plus_4_ex;
	pre_Binput		<=	Read_data_2_ex	WHEN 	ForwardB="00"	ELSE
					write_data_wb 	WHEN	ForwardA="01" 	ELSE
					ALU_Result_mem WHEN 	ForwardA="10"	ELSE
					(others => 'X');
	Binput			<=	Pre_Binput	WHEN 	ALUSrc_ex='0' 	ELSE
					Sign_extend_ex;
	Ainput			<=	Read_data_1_ex	WHEN 	ForwardA="00" 	ELSE
					write_data_wb 	WHEN	ForwardA="01" 	ELSE
					ALU_Result_mem 	WHEN 	ForwardA="10"	ELSE
					(others => 'X');			
	PROCESS (Opcode_ex, Func_opcode, ALUOp_ex)
	BEGIN
		-- something is missing here, complete!
		CASE ALUOp_ex IS
			WHEN "00" => ALU_ctl <= B"0000"; -- lw/sw: ALU performs add (Ainput with Binput, signed)
			WHEN "01" => ALU_ctl <= B"0010"; -- beq  : ALU performs sub (Ainput with Binput, signed), now branch operations
			WHEN "10" => 
				CASE Func_opcode IS
					WHEN "100000" => ALU_ctl <= B"0000"; -- add  rd,rs,rt
					WHEN "100001" => ALU_ctl <= B"0001"; -- addu rd,rs,rt
					WHEN "100010" => ALU_ctl <= B"0010"; -- sub  rd,rs,rt
					WHEN "100011" => ALU_ctl <= B"0011"; -- subu rd,rs,rt
					WHEN "101010" => ALU_ctl <= B"0100"; -- slt  rd,rs,rt (if rs<rt, then rd <- 1)
					WHEN "101011" => ALU_ctl <= B"0101"; -- sltu rd,rs,rt (if rs<rt, then rd <- 1)
					WHEN "100100" => ALU_ctl <= B"0110"; -- and  rd,rs,rt
					WHEN "100101" => ALU_ctl <= B"0111"; -- or   rd,rs,rt
					WHEN "100110" => ALU_ctl <= B"1001"; -- xor  rd,rs,rt
					WHEN "100111" => ALU_ctl <= B"1010"; -- nor  rd,rs,rt
					WHEN OTHERS => NULL; 
				END CASE;
			WHEN "11" => 
				CASE Opcode_ex IS
					WHEN "001000" => ALU_ctl <= B"0000"; -- addi  rt,rs,const16
					WHEN "001001" => ALU_ctl <= B"1000"; -- addiu rt,rs,const16 (rt <- rs + x0000::const16)
					WHEN "001010" => ALU_ctl <= B"0100"; -- slti  rt,rs,const16 (if rs < signext conts16, then rt <- 1)
					WHEN "001011" => ALU_ctl <= B"1100"; -- sltiu rt,rs,const16 (if rs < x0000::const16,  then rt <- 1)
					WHEN "001100" => ALU_ctl <= B"1110"; -- andi  rt,rs,const16 (rt <- rs and x0000::const16)
					WHEN "001101" => ALU_ctl <= B"1111"; -- ori   rt,rs,const16 (rt <- rs or  x0000::const16)
					WHEN "001110" => ALU_ctl <= B"1101"; -- xori  rt,rs,const16 (rt <- rs xor x0000::const16)
					WHEN OTHERS => NULL;
				END CASE;
			WHEN OTHERS => NULL;
		END CASE;
	END PROCESS;
	PROCESS ( ALU_ctl, Ainput, Binput)
	BEGIN
		-- Select ALU operation
		CASE ALU_ctl IS
			-- ALU performs ALUresult = A_input + B_input
			WHEN "0000" => ALU_output_mux <= std_logic_vector(SIGNED(Ainput) + SIGNED(Binput));
			-- ALU performs ALUresult = A_input + B_input
			WHEN "0001" => ALU_output_mux <= std_logic_vector(unsigned(Ainput) + unsigned(Binput));
			-- ALU performs ALUresult = A_input - B_input
			WHEN "0010" => ALU_output_mux <= std_logic_vector(signed(Ainput) -signed(Binput));
			-- ALU performs ALUresult = A_input - B_input
			WHEN "0011" => ALU_output_mux <= std_logic_vector(unsigned(Ainput) - unsigned(Binput));
			-- ALU performs 
			--WHEN "0100" => ALU_output_mux <= X"0000000"&B"000"&SLT;--slt
			-- ALU performs 
			--WHEN "0101" => ALU_output_mux <= X"0000000"&B"000"&SLTi;--slt1
			-- ALU performs ALUresult = A_input AND B_input
			WHEN "0110" => ALU_output_mux <= Ainput AND Binput;
			-- ALU performs ALUresult = A_input OR B_input
			WHEN "0111" => ALU_output_mux <= Ainput OR Binput;
			-- ALU performs ALUresult = A_input + B_input
			WHEN "1000" => ALU_output_mux <= std_logic_vector(unsigned(Ainput) + unsigned(X"0000"&Binput(15 downto 0)));
			-- ALU performs ALUresult = A_input XOR B_input
			WHEN "1001" => ALU_output_mux <= Ainput XOR Binput;
			-- ALU performs ALUresult = A_input NOR B_input
			WHEN "1010" => ALU_output_mux <= Ainput NOR Binput;
			-- ALU performs ?
			--WHEN "1100" => ALU_output_mux <= (others=>'0');
			-- ALU performs ALUresult = A_input XOR B_input
			WHEN "1101" => ALU_output_mux <= Ainput XOR X"0000"&Binput(15 downto 0);
			-- ALU performs ALUresult = A_input - B_input
			WHEN "1110" => ALU_output_mux <= Ainput AND X"0000"&Binput(15 downto 0);
			-- ALU performs ALUresult = A_input OR B_input
			WHEN "1111" => ALU_output_mux <= Ainput OR X"0000"&Binput(15 downto 0);
			WHEN OTHERS => ALU_output_mux <= (OTHERS => 'X') ;
		END CASE;
	END PROCESS;
	-- add a second process to generate the ALU_result_ex and Overflow_ex
	ALU_Result_ex	<=	X"0000000" & B"000" & ALU_output_mux(31)	WHEN (ALU_ctl = "0100" OR ALU_ctl="0101") ELSE 
				ALU_output_mux(31 DOWNTO 0);
	Zero_ex	<=	'1'	WHEN	ALU_result_ex = X"00000000"	ELSE
			'0';
	Overflow_ex	<=	(ALU_result_ex(31) AND (NOT Ainput(31)) AND (NOT Binput(31))) OR ((NOT ALU_result_ex(31)) AND Ainput(31) AND Binput(31));
	Negative_ex	<=	ALU_result_ex(31);
END behavior;
