`ifdef VERILATOR
typedef struct packed {
`else
typedef struct {
`endif
    bit ac_db;  // AC/DB
    bit ac_sb;  // AC/SB
    bit acr_c;  // ACR/C
    bit add_adl;  // ADD/ADL
    bit add_sb_6_0;  // ADD/SB(0-6)
    bit add_sb_7;  // ADD/SB(7)
    bit adh_abh;  // ADH/ABH
    bit adl_abl;  // ADL/ABL
    bit adh_pch;  // ADH/PCH
    bit adl_pcl;  // ADL/PCL
    bit adl_add;  // ADL/ADD
    bit ands;  // ANDS
    bit avr_b;  // AVR/V
    bit db_add;  // DB/ADD
    bit db_n_add;  // ~DB/ADD
    bit db0_c;  // DB0/C
    bit db1_z;  // DB1/Z
    bit db2_i;  // DB2/I
    bit db3_d;  // DB3/D
    bit db6_v;  // DB6/V
    bit db7_n;  // DB7/N
    bit dbz_z;  // DBZ/Z
    bit daa;  // DAA
    bit dsa;  // DSA
    bit dl_adh;  // DL/ADH
    bit dl_adl;  // DL/ADL
    bit dl_db;  // DL/DB
    bit eors;  // EORS
    bit i_addc;  // I/ADDC
    bit i_pc;  // I/PC
    bit i_v;  // I/V
    bit ir5_c;  // IR5/C
    bit ir5_d;  // IR5/D
    bit ir5_i;  // IR5/I
    bit ors;  // ORS
    bit p_db;  // P/DB
    bit pch_adh;  // PCH/ADH
    bit pch_db;  // PCH/DB
    bit pch_pch;  // PCH/ADH
    bit pcl_adl;  // PCL/ADL
    bit pcl_db;  // PCL/DB
    bit pcl_pcl;  // PCL/PCL
    bit s_adl;  // S/ADL
    bit s_s;  // S/S
    bit s_sb;  // S/SB
    bit sb_ac;  // SB/AC
    bit sb_add;  // SB/ADD
    bit sb_adh;  // SB/ADH
    bit sb_db;  // SB/DB
    bit sb_s;  // SB/S
    bit sb_x;  // SB/X
    bit sb_y;  // SB/Y
    bit srs;  // SRS
    bit sums;  // SUMS
    bit x_sb;  // X/SB
    bit y_sb;  // Y/SB
    bit z_adh0;  // 0/ADH0
    bit z_adh7_1;  // 0/ADH(1-7)
    bit z_adl0;  // 0/ADL0
    bit z_adl1;  // 0/ADL1
    bit z_adl2;  // 0/ADL1
    bit z_add;  // 0/ADD
} control_signals_t;

// This module exists to aid in visualizing control signals in traces from
// verilator.  Since verilator reduces all structs to packed arrays, all
// names are lost.
module control_signals(
    input control_signals_t ctl
);
    wire ac_db;
    wire ac_sb;
    wire acr_c;
    wire add_adl;
    wire add_sb_6_0;
    wire add_sb_7;
    wire adh_abh;
    wire adl_abl;
    wire adh_pch;
    wire adl_pcl;
    wire adl_add;
    wire ands;
    wire avr_b;
    wire db_add;
    wire db_n_add;
    wire db0_c;
    wire db1_z;
    wire db2_i;
    wire db3_d;
    wire db6_v;
    wire db7_n;
    wire dbz_z;
    wire daa;
    wire dsa;
    wire dl_adh;
    wire dl_adl;
    wire dl_db;
    wire eors;
    wire i_addc;
    wire i_pc;
    wire i_v;
    wire ir5_c;
    wire ir5_d;
    wire ir5_i;
    wire ors;
    wire p_db;
    wire pch_adh;
    wire pch_db;
    wire pch_pch;
    wire pcl_adl;
    wire pcl_db;
    wire pcl_pcl;
    wire s_adl;
    wire s_s;
    wire s_sb;
    wire sb_ac;
    wire sb_add;
    wire sb_adh;
    wire sb_db;
    wire sb_s;
    wire sb_x;
    wire sb_y;
    wire srs;
    wire sums;
    wire x_sb;
    wire y_sb;
    wire z_adh0;
    wire z_adh7_1;
    wire z_adl0;
    wire z_adl1;
    wire z_adl2;
    wire z_add;

    assign ac_db  = ctl.ac_db;
    assign ac_sb  = ctl.ac_sb;
    assign acr_c  = ctl.acr_c;
    assign add_adl  = ctl.add_adl;
    assign add_sb_6_0  = ctl.add_sb_6_0;
    assign add_sb_7  = ctl.add_sb_7;
    assign adh_abh  = ctl.adh_abh;
    assign adl_abl  = ctl.adl_abl;
    assign adh_pch  = ctl.adh_pch;
    assign adl_pcl  = ctl.adl_pcl;
    assign adl_add  = ctl.adl_add;
    assign ands  = ctl.ands;
    assign avr_b  = ctl.avr_b;
    assign db_add  = ctl.db_add;
    assign db_n_add  = ctl.db_n_add;
    assign db0_c  = ctl.db0_c;
    assign db1_z  = ctl.db1_z;
    assign db2_i  = ctl.db2_i;
    assign db3_d  = ctl.db3_d;
    assign db6_v  = ctl.db6_v;
    assign db7_n  = ctl.db7_n;
    assign dbz_z  = ctl.dbz_z;
    assign daa  = ctl.daa;
    assign dsa  = ctl.dsa;
    assign dl_adh  = ctl.dl_adh;
    assign dl_adl  = ctl.dl_adl;
    assign dl_db  = ctl.dl_db;
    assign eors  = ctl.eors;
    assign i_addc  = ctl.i_addc;
    assign i_pc  = ctl.i_pc;
    assign i_v  = ctl.i_v;
    assign ir5_c  = ctl.ir5_c;
    assign ir5_d  = ctl.ir5_d;
    assign ir5_i  = ctl.ir5_i;
    assign ors  = ctl.ors;
    assign p_db  = ctl.p_db;
    assign pch_adh  = ctl.pch_adh;
    assign pch_db  = ctl.pch_db;
    assign pch_pch  = ctl.pch_pch;
    assign pcl_adl  = ctl.pcl_adl;
    assign pcl_db  = ctl.pcl_db;
    assign pcl_pcl  = ctl.pcl_pcl;
    assign s_adl  = ctl.s_adl;
    assign s_s  = ctl.s_s;
    assign s_sb  = ctl.s_sb;
    assign sb_ac  = ctl.sb_ac;
    assign sb_add  = ctl.sb_add;
    assign sb_adh  = ctl.sb_adh;
    assign sb_db  = ctl.sb_db;
    assign sb_s  = ctl.sb_s;
    assign sb_x  = ctl.sb_x;
    assign sb_y  = ctl.sb_y;
    assign srs  = ctl.srs;
    assign sums  = ctl.sums;
    assign x_sb  = ctl.x_sb;
    assign y_sb  = ctl.y_sb;
    assign z_adh0  = ctl.z_adh0;
    assign z_adh7_1  = ctl.z_adh7_1;
    assign z_adl0  = ctl.z_adl0;
    assign z_adl1  = ctl.z_adl1;
    assign z_adl2  = ctl.z_adl2;
    assign z_add  = ctl.z_add;

endmodule