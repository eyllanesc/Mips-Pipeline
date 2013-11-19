-- Top level structural model of MIPS RISC processor (pipelined version)
-- Author: Aurelio Morales
-- Course: Sistemas Digitales II
-- Universidad Nacional de Ingenieria
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY MIPS IS
  PORT( 
		reset					: IN	STD_LOGIC;
		clock					: IN 	STD_LOGIC; 
		PC						: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
     	Instruction_out	: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		read_data_1_out	: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		read_data_2_out	: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		ALU_result_out		: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		read_data_out		: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		Branch_out			: OUT	STD_LOGIC;
		Zero_out				: OUT	STD_LOGIC;
		Overflow_out		: OUT	STD_LOGIC;
		Memwrite_out		: OUT	STD_LOGIC; 
		Regwrite_out		: OUT 	STD_LOGIC);
END MIPS;

ARCHITECTURE structure OF MIPS IS

  COMPONENT IFetch
	PORT(
		PCSrc_if			: IN	STD_LOGIC; -- replaces "Branch AND Zero" (now in MEMory)
		PCwrite			: IN	STD_LOGIC;
		Jump_if			: IN	STD_LOGIC;
		jump_address_if: IN	STD_LOGIC_VECTOR(25 DOWNTO 0);
		Add_result_if 	: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC_plus_4_if	: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC_out_if 		: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		Instruction_if : OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		clock			: IN	STD_LOGIC;
		reset 			: IN 	STD_LOGIC);
  END COMPONENT; 

  COMPONENT IDecode
	PORT(Instruction_id			: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		 RegWrite 				: IN 	STD_LOGIC;
		 read_data_1_id			: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		 read_data_2_id			: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Sign_extend_id 		: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Opcode_id				: OUT	STD_LOGIC_VECTOR( 5 DOWNTO 0);
		 write_register_rt_id	: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0);
		 write_register_rd_id	: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0);
		 read_register_rs_id	: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0); -- for FU
		 read_register_rt_id	: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0); -- for FU
		 write_data_id			: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		 write_register_id		: IN	STD_LOGIC_VECTOR( 4 DOWNTO 0);
		 clock					: IN	STD_LOGIC;
		 reset					: IN 	STD_LOGIC);
  END COMPONENT;

  COMPONENT control
	PORT(Instruction_id : IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Jump_id		: OUT 	STD_LOGIC;
		 RegWrite_id	: OUT 	STD_LOGIC;
		 MemtoReg_id 	: OUT 	STD_LOGIC;
		 Branch_id		: OUT 	STD_LOGIC;
		 MemRead_id 	: OUT 	STD_LOGIC;
		 MemWrite_id	: OUT 	STD_LOGIC;
		 RegDst_id		: OUT 	STD_LOGIC;
		 ALUop_id 		: OUT 	STD_LOGIC_VECTOR(1 DOWNTO 0);
		 ALUSrc_id		: OUT 	STD_LOGIC;
		 bubble			: IN	STD_LOGIC; -- to stall the pipeline
		 id_flush		: IN	STD_LOGIC);-- to flush instructions
  END COMPONENT;

  COMPONENT EXEcute
	PORT(Opcode_ex 				: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0); -- for arithmetic/logic I-format instructions
		 RegDst_ex				: IN	STD_LOGIC;
		 ALUOp_ex 				: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0);
		 ALUSrc_ex 				: IN 	STD_LOGIC;
		 PC_plus_4_ex 			: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Read_data_1_ex			: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Read_data_2_ex			: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Sign_extend_ex			: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		 write_register_rt_ex	: IN	STD_LOGIC_VECTOR( 4 DOWNTO 0);
		 write_register_rd_ex	: IN	STD_LOGIC_VECTOR( 4 DOWNTO 0);
		 Zero_ex 				: OUT	STD_LOGIC;
		 Overflow_ex			: OUT	STD_LOGIC;
		 Add_Result_ex 			: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		 ALU_Result_ex 			: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		 write_data_ex			: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		 write_register_ex		: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0);
		 ForwardA				: IN	STD_LOGIC_VECTOR( 1 DOWNTO 0); -- for FU
		 ForwardB				: IN	STD_LOGIC_VECTOR( 1 DOWNTO 0); -- for FU
		 ALU_Result_mem 		: IN	STD_LOGIC_VECTOR(31 DOWNTO 0); -- forwarded from MEM
		 write_data_wb			: IN	STD_LOGIC_VECTOR(31 DOWNTO 0));-- forwarded from WB
  END COMPONENT;

  COMPONENT MEMory
	PORT(Branch_mem		: IN	STD_LOGIC;
		 Zero_mem		: IN	STD_LOGIC;
		 MemRead_mem	: IN	STD_LOGIC;
		 Memwrite_mem	: IN 	STD_LOGIC;
		 ALU_Result_mem	: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		 write_data_mem	: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		 PCSrc_mem		: OUT	STD_LOGIC;
		 branch_flush	: OUT	STD_LOGIC;
		 read_data_mem	: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		 clkd			: IN	STD_LOGIC);
  END COMPONENT;

  COMPONENT Writeback
	PORT(read_data_wb	: IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		 ALU_result_wb	: IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		 MemtoReg_wb	: IN  STD_LOGIC;
		 write_data_wb	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
  END COMPONENT;

  COMPONENT FU
	PORT(read_register_rs_ex	: IN	STD_LOGIC_VECTOR(4 DOWNTO 0);
		 read_register_rt_ex	: IN	STD_LOGIC_VECTOR(4 DOWNTO 0);
		 write_register_mem		: IN	STD_LOGIC_VECTOR(4 DOWNTO 0);
		 write_register_wb		: IN	STD_LOGIC_VECTOR(4 DOWNTO 0);
		 RegWrite_mem 			: IN 	STD_LOGIC;
		 RegWrite_wb 			: IN 	STD_LOGIC;
		 ForwardA				: OUT	STD_LOGIC_VECTOR(1 DOWNTO 0);
		 ForwardB				: OUT	STD_LOGIC_VECTOR(1 DOWNTO 0));
  END COMPONENT;
  
  COMPONENT HDU
	PORT(if_id_read_register_rs	: IN 	STD_LOGIC_VECTOR(4 DOWNTO 0);
		 if_id_read_register_rt	: IN 	STD_LOGIC_VECTOR(4 DOWNTO 0);
		 write_register_rt_ex	: IN	STD_LOGIC_VECTOR(4 DOWNTO 0);
		 MemRead_ex				: IN	STD_LOGIC;
		 bubble					: OUT	STD_LOGIC;
		 if_id_write			: OUT	STD_LOGIC;
		 PCwrite				: OUT	STD_LOGIC);
  END COMPONENT;
  
	-- TODO: declare signals used to connect VHDL components
signal PCSrc : std_logic;
BEGIN

	-- TODO: copy important signals to output pins 
	
	-- TODO: connect the MIPS components   
	IFE: IFetch
	PORT MAP(
		PCSrc_if		=> PCSrc,
		PCwrite			=> ,
		Jump_if			=> ,
		jump_address_if	=> ,
		Add_result_if 	=> ,
		PC_plus_4_if	=> ,
		PC_out_if 		=> ,
		Instruction_if	=> ,
		clock			=> clock,
		reset			=> reset
			);

	ID: IDecode
   	PORT MAP(
		Instruction_id			=> ,
		RegWrite 				=> ,
		read_data_1_id			=> ,
		read_data_2_id			=> ,
		Sign_extend_id 			=> ,
		Opcode_id				=> ,
		write_register_rt_id	=> ,
		write_register_rd_id	=> ,
		read_register_rs_id		=> ,
		read_register_rt_id		=> ,
		write_data_id			=> ,
		write_register_id		=> ,
		clock					=> clock,
		reset					=> reset
			);

	CTL: control
	PORT MAP(
		Instruction_id	=> ,
		Jump_id			=> ,
		RegWrite_id		=> ,
		MemtoReg_id 	=> ,
		Branch_id		=> ,
		MemRead_id 		=> ,
		MemWrite_id		=> ,
		RegDst_id		=> ,
		ALUop_id 		=> ,
		ALUSrc_id		=> ,
		bubble			=> ,
		id_flush		=> 
			);

	EXE: EXEcute
   	PORT MAP(
		Opcode_ex 				=> ,
		RegDst_ex				=> ,
		ALUOp_ex 				=> ,
		ALUSrc_ex 				=> ,
		PC_plus_4_ex 			=> ,
		Read_data_1_ex			=> ,
		Read_data_2_ex			=> ,
		Sign_extend_ex			=> ,
		write_register_rt_ex	=> ,
		write_register_rd_ex	=> ,
		Zero_ex 				=> ,
		Overflow_ex				=> ,
		Add_Result_ex 			=> ,
		ALU_Result_ex 			=> ,
		write_data_ex			=> ,
		write_register_ex		=> ,
		ForwardA				=> ,
		ForwardB				=> ,
		ALU_Result_mem 			=> ,
		write_data_wb			=> 
			);

	MEM: MEMory
	PORT MAP(
		Branch_mem		=> ,
		Zero_mem		=> ,
		MemRead_mem		=> ,
		Memwrite_mem	=> ,
		ALU_Result_mem	=> ,
		write_data_mem	=> ,
		PCSrc_mem		=>PCSrc ,
		branch_flush	=> ,
		read_data_mem	=> ,
		clkd			=> clock
			);
			
	WB: Writeback
	PORT MAP(
		read_data_wb	=> ,
		ALU_result_wb	=> ,
		MemtoReg_wb		=> ,
		write_data_wb	=> 
			);

	FWD: FU
	PORT MAP(
		read_register_rs_ex		=> ,
		read_register_rt_ex		=> ,
		write_register_mem		=> ,
		write_register_wb		=> ,
		RegWrite_mem 			=> ,
		RegWrite_wb 			=> ,
		ForwardA				=> ,
		ForwardB				=> 
			);

	HAZ: HDU
	PORT MAP(
		if_id_read_register_rs	=> ,
		if_id_read_register_rt	=> ,
		write_register_rt_ex	=> ,
		MemRead_ex				=> ,
		bubble					=> ,
		if_id_write				=> ,
		PCwrite					=> 
			);
			
END structure;

