// ÍTALO MATHEUS DE ARAÚJO RAMALHO
// Roteiro 03

parameter divide_by=100000000;  // divisor do clock de referência
// A frequencia do clock de referencia é 50 MHz.
// A frequencia de clk_2 será de  50 MHz / divide_by

parameter NBITS_INSTR = 32;
parameter NBITS_TOP = 8, NREGS_TOP = 32, NBITS_LCD = 64;
module top(input  logic clk_2,
           input  logic [NBITS_TOP-1:0] SWI,
           output logic [NBITS_TOP-1:0] LED,
           output logic [NBITS_TOP-1:0] SEG,
           output logic [NBITS_LCD-1:0] lcd_a, lcd_b,
           output logic [NBITS_INSTR-1:0] lcd_instruction,
           output logic [NBITS_TOP-1:0] lcd_registrador [0:NREGS_TOP-1],
           output logic [NBITS_TOP-1:0] lcd_pc, lcd_SrcA, lcd_SrcB,
             lcd_ALUResult, lcd_Result, lcd_WriteData, lcd_ReadData, 
           output logic lcd_MemWrite, lcd_Branch, lcd_MemtoReg, lcd_RegWrite);

  always_comb begin
    //SEG <= SWI;
    lcd_WriteData <= SWI;
    lcd_pc <= 'h12;
    lcd_instruction <= 'h34567890;
    lcd_SrcA <= 'hab;
    lcd_SrcB <= 'hcd;
    lcd_ALUResult <= 'hef;
    lcd_Result <= 'h11;
    lcd_ReadData <= 'h33;
    lcd_MemWrite <= SWI[0];
    lcd_Branch <= SWI[1];
    lcd_MemtoReg <= SWI[2];
    lcd_RegWrite <= SWI[3];
    for(int i=0; i<NREGS_TOP; i++)
       if(i != NREGS_TOP/2-1) lcd_registrador[i] <= i+i*16;
       else                   lcd_registrador[i] <= ~SWI;
    lcd_a <= {56'h1234567890ABCD, SWI};
    lcd_b <= {SWI, 56'hFEDCBA09876543};
  end


/* 

Ram r/w:
  SWI[1]: seleção de escrita (1) ou leitura (0);
  SWI[3:2]: endereço de entrada;
  SWI[7:4]: dados de entrada;
  LED[7:4]: exibição da saída.

*/

parameter ADDR_WIDTH = 2;
parameter DATA_WIDTH = 4;

logic [ADDR_WIDTH-1:0] addr;
logic [DATA_WIDTH-1:0] wdata;
logic [DATA_WIDTH-1:0] rdata;
logic [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH-1:0];
logic wr_en;

always_comb wr_en <= SWI[1];
always_comb addr <= SWI[3:2];
always_comb wdata <= SWI[7:4];

always_ff @( posedge clk_2 ) begin 
  if (wr_en) begin mem[addr] <= wdata; end
  else begin rdata <= mem[addr]; end
end

always_comb begin
  LED[0] = clk_2;
  LED[1] = wr_en;
  LED[7:4] = rdata;
end

endmodule