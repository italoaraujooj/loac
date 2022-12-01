// ÍTALO MATHEUS DE ARAÚJO RAMALHO
// ROTEIRO 01

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

// questão 1:
  logic[2:0] A, B;
  logic[1:0] F;

  always_comb begin
    F <= SWI[4:3];
    A <= SWI[7:5];
    B <= SWI[2:0];
  end

  logic[3:0] Y;

  always_comb LED[2:0] <= Y;
  
  always_comb begin
    case (F)
      'b00: Y <= A + B;
      'b01: Y <= A - B;
      'b10: Y <= A & B;
      'b11: Y <= A | B;
    endcase
      
    case (Y)
      'b0000: SEG[7:0] = 'b0111111;
      'b0001: SEG[7:0] = 'b0000110;
      'b0010: SEG[7:0] = 'b1011011;
      'b0011: SEG[7:0] = 'b1001111;
      'b0100: SEG[7:0] = 'b1100110;
      'b0101: SEG[7:0] = 'b1101101;
      'b0110: SEG[7:0] = 'b1111101;
      'b0111: SEG[7:0] = 'b0000111;
      default: SEG[7:0] = 'b10000000;
    endcase
    
  end


endmodule