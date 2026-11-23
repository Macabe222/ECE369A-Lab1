`timescale 1ns/1ps

module ForwardingUnit(IDEX_Rt, IDEX_Rs, EXMEM_Rd, MEMWB_Rd, EXMEM_RegWrite, MEMWB_RegWrite, ForwardSrc1, ForwardSrc2);
    input [4:0] IDEX_Rt, IDEX_Rs, EXMEM_Rd, MEMWB_Rd;
    input EXMEM_RegWrite, MEMWB_RegWrite;
    output reg [1:0] ForwardSrc1, ForwardSrc2;

    always @ (*) begin
        if (EXMEM_RegWrite && (EXMEM_Rd != 5'd0) && (IDEX_Rs == EXMEM_Rd)) begin
            ForwardSrc1 = 2'b01;
        end
        else if (MEMWB_RegWrite && (MEMWB_Rd != 5'd0) && (IDEX_Rs == MEMWB_Rd)) begin
            ForwardSrc1 = 2'b10;
        end
        else begin
            ForwardSrc1 = 2'b00;
        end

        if (EXMEM_RegWrite && (EXMEM_Rd != 5'd0) && (IDEX_Rt == EXMEM_Rd)) begin
            ForwardSrc2 = 2'b01;
        end
        else if (MEMWB_RegWrite && (MEMWB_Rd != 5'd0) && (IDEX_Rt == MEMWB_Rd)) begin
            ForwardSrc2 = 2'b10;
        end
        else begin
            ForwardSrc2 = 2'b00;
        end
    end

endmodule
