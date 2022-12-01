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
SWI[1:0]	Função:
00	registrador paralelo/serial de 4 bits
01 ou 11	memória RAM R/W 4x4
10	memória RAM ROM 4x4

Reg: 
  SWI[2]: switch de reset para "zerar" o registrador;
  SWI[3]: seleção da entrada serial (0) ou paralela (1);
  SWI[7:4] entrada paralela;
  SWI[7]: entrada serial (caso a função entrada serial seja selecionada);
  LED[7:4]: exibição da saída.

Ram r/w:
  SWI[1]: seleção de escrita (1) ou leitura (0);
  SWI[3:2]: endereço de entrada;
  SWI[7:4]: dados de entrada;
  LED[7:4]: exibição da saída.

Ram rom:
  SWI[3:2]: endereço de entrada;
  LED[7:4]: exibição da saída.
*/

// REGISTRADOR PARALELO/SERIAL DE 4 BITS

parameter NBITS_REG = 4;
parameter NUM_REG_RESET = 0;
logic entrada_serial, reset, select_sp;
logic[NBITS_REG-1:0] entrada_paralela;

always_comb begin
  entrada_serial <= SWI[7];
  entrada_paralela <= SWI[7:4];
  reset <= SWI[2]; 
  select_sp = SWI[3];

  SEG[7] = clk_2;
end

logic [NBITS_REG-1:0] registrador;
always_comb LED[7:4] <= registrador;

always_ff @( posedge reset or posedge clk_2 ) begin
  if(reset) begin registrador <= NUM_REG_RESET; end
  else begin
    if (select_sp == 0) begin
    registrador[3] <= entrada_serial;
    registrador[2] <= registrador[3];
    registrador[1] <= registrador[2];
    registrador[0] <= registrador[1];
    end else begin
      registrador <= entrada_paralela;  
    end
  end 
end

endmodule