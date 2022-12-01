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

// CONTADOR HEXA

parameter NBITS_COUNT = 4;
logic [NBITS_COUNT-1:0] data_in, count;
logic reset, load, count_up, counter_on;

always_comb begin
  reset <= SWI[0];
  counter_on <= SWI[3];
  count_up <= SWI[1];
  load <= SWI[2];
  data_in <= SWI[7:4];
end

always_ff @(posedge reset or posedge clk_2) begin
  if (reset) begin
    count <= 0;
    SEG[7:0] = 7'b0111111;
    LED[3:0] = 4'b0000;
  end
  else if (load) begin
    count <= data_in;
    case (data_in)   
      4'b0001 :   SEG[7:0] = 7'b0000110; 
      4'b0010 :  	SEG[7:0] = 7'b1011011;
      4'b0011 : 	SEG[7:0] = 7'b1001111;
      4'b0100 :		SEG[7:0] = 7'b1100110;
      4'b0101 :		SEG[7:0] = 7'b1101101;
      4'b0110 :		SEG[7:0] = 7'b1111101;
      4'b0111 :		SEG[7:0] = 7'b0000111;
      4'b1000 :   SEG[7:0] = 7'b1111111;
      4'b1001 :   SEG[7:0] = 7'b1101111;
      4'b1010 :  	SEG[7:0] = 7'b1110111;
      4'b1011 : 	SEG[7:0] = 7'b1111100;
      4'b1100 :		SEG[7:0] = 7'b0111001;
      4'b1101 :		SEG[7:0] = 7'b1011110;
      4'b1110 :		SEG[7:0] = 7'b1111001;
      4'b1111 :		SEG[7:0] = 7'b1110001;
      default: SEG[7:0] = 7'b0111111;
    endcase
  end
  else if (counter_on) begin
    if (count_up)
      count <= count + 1;
    else count <= count -1;
    case (count)   
      4'b0001 :   SEG[7:0] = 7'b0000110; 
      4'b0010 :  	SEG[7:0] = 7'b1011011;
      4'b0011 : 	SEG[7:0] = 7'b1001111;
      4'b0100 :		SEG[7:0] = 7'b1100110;
      4'b0101 :		SEG[7:0] = 7'b1101101;
      4'b0110 :		SEG[7:0] = 7'b1111101;
      4'b0111 :		SEG[7:0] = 7'b0000111;
      4'b1000 :   SEG[7:0] = 7'b1111111;
      4'b1001 :   SEG[7:0] = 7'b1101111;
      4'b1010 :  	SEG[7:0] = 7'b1110111;
      4'b1011 : 	SEG[7:0] = 7'b1111100;
      4'b1100 :		SEG[7:0] = 7'b0111001;
      4'b1101 :		SEG[7:0] = 7'b1011110;
      4'b1110 :		SEG[7:0] = 7'b1111001;
      4'b1111 :		SEG[7:0] = 7'b1110001;
      default: SEG[7:0] = 7'b0111111;
    endcase
    LED[3:0] <= count;
  end
end

always_comb begin
  LED[6] <= count_up;
  LED[7] <= clk_2;
end

endmodule