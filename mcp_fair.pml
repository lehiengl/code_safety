/*
 * mcp_fair.pml
 * Mot MCP server (Streamable HTTP) phuc vu hai phien bang mot luong xu ly.
 * Moi phien gui tung request mot va cho phan hoi.
 *
 * Co bien dich:
 *   RR   server phuc vu xoay vong (round-robin) thay vi chon tuy y
 *
 * Tinh chat:
 *   F1 (fairness) phien 1 da gui request thi cuoi cung duoc phuc vu
 */

#define N 2

chan req[N] = [1] of { byte };
chan rsp[N] = [1] of { byte };

bool waiting[N];
byte turn = 0;

proctype Session(byte me) {
  byte x, work = 0;
end:
  do
  :: work = 1 - work                         /* host xu ly cuc bo */
  :: atomic { waiting[me] = true; req[me]!me };
     rsp[me]?x;
     waiting[me] = false
  od
}

active proctype Server() {
  byte x;
end:
  do
#ifdef RR
  :: nempty(req[turn]) ->
     req[turn]?x; rsp[x]!x; turn = 1 - turn
  :: empty(req[turn]) && nempty(req[1 - turn]) ->
     req[1 - turn]?x; rsp[x]!x               /* luot van giu cho phien kia */
#else
  :: req[0]?x -> rsp[0]!x
  :: req[1]?x -> rsp[1]!x
#endif
  od
}

init { atomic { run Session(0); run Session(1) } }

ltl F1 { [] (waiting[1] -> <> !waiting[1]) }
