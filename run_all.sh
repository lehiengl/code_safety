#!/bin/sh
# Chay toan bo cac lan kiem chung trong bao cao (Spin 6.5.2, gcc).
M=mcp_session.pml
FA="-DFIX_INIT -DFIX_ID -DFIX_SRV"
# --- Safety (pan -DSAFETY -DBFS) ---
./run.sh R0_goc   $M safety
./run.sh S1_init  $M safety -DFIX_ID -DFIX_SRV -DFIX_RETRY -DFIX_NOTIFY
./run.sh S3_tool  $M safety -DFIX_INIT -DFIX_ID -DFIX_RETRY -DFIX_NOTIFY
./run.sh S3_naive $M safety -DFIX_INIT -DFIX_ID -DFIX_SRV_NAIVE -DFIX_RETRY -DFIX_NOTIFY
./run.sh S2_id    $M safety -DFIX_INIT -DFIX_SRV -DFIX_RETRY -DFIX_NOTIFY
./run.sh SAFE_ok  $M safety -DFIX_INIT -DFIX_ID -DFIX_SRV -DFIX_RETRY -DFIX_NOTIFY
# --- Liveness L1 (pan -a, co/khong -f) ---
./run.sh L1_retry  $M ltlf $FA -DFIX_NOTIFY -DLIVE
./run.sh L1_flood  $M ltlf $FA -DFIX_RETRY -DLIVE
./run.sh L1_ok_nof $M ltl  $FA -DFIX_RETRY -DFIX_NOTIFY -DLIVE
./run.sh L1_ok_f   $M ltlf $FA -DFIX_RETRY -DFIX_NOTIFY -DLIVE
./run.sh W_ok      $M ltl  $FA -DFIX_RETRY -DFIX_NOTIFY -DWITNESS
# --- Fairness F1 (mcp_fair.pml) ---
./run.sh F1_nd_nof mcp_fair.pml ltl
./run.sh F1_nd_f   mcp_fair.pml ltlf
./run.sh F1_rr_nof mcp_fair.pml ltl  -DRR
./run.sh F1_rr_f   mcp_fair.pml ltlf -DRR
