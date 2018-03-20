`ifdef VERILATOR
typedef struct packed {
`else
typedef struct {
`endif
    bit ac_db;
    bit ac_sb;
    bit add_adl;
    bit add_sb_6_0;
    bit add_sb_7;
    bit adh_abh;
    bit adl_abl;
    bit adh_pch;
    bit adl_pcl;
    bit adl_add;
    bit db_add;
    bit db_n_add;
    bit dl_adh;
    bit dl_adl;
    bit dl_db;
    bit i_pc;
    bit pch_adh;
    bit pch_db;
    bit pch_pch;
    bit pcl_adl;
    bit pcl_db;
    bit pcl_pcl;
    bit s_adl;
    bit s_s;
    bit s_sb;
    bit sb_ac;
    bit sb_add;
    bit sb_s;
    bit sb_x;
    bit sb_y;
    bit x_sb;
    bit y_sb;
    bit z_adh0;
    bit z_adh7_1;
    bit z_adl0;
    bit z_adl1;
    bit z_adl2;
    bit z_add;
} control_signals_t;

