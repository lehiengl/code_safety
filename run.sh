#!/bin/sh
# Cach dung: ./run.sh <ten> <tep.pml> <che_do> [co -D ...]
#   che_do: safety   pan -DSAFETY -DBFS (assertion + invalid end state)
#           ltl      pan -a  (chu trinh chap nhan, khong fairness)
#           ltlf     pan -a -f (co weak fairness)
# Ket qua ghi vao out/<ten>.txt, trail (neu co) ghi vao out/<ten>.trail.txt
set -e
NAME=$1; MODEL=$2; MODE=$3; shift 3
mkdir -p out work/$NAME
cp "$MODEL" work/$NAME/m.pml
cd work/$NAME
spin -a "$@" m.pml
case $MODE in
  safety) gcc -O2 -DSAFETY -DBFS -o pan pan.c; ./pan > ../../out/$NAME.txt || true ;;
  ltl)    gcc -O2 -o pan pan.c; ./pan -a -m100000 > ../../out/$NAME.txt || true ;;
  ltlf)   gcc -O2 -o pan pan.c; ./pan -a -f -m100000 > ../../out/$NAME.txt || true ;;
esac
if [ -f m.pml.trail ]; then
  spin -t -p -g -l -k m.pml.trail "$@" m.pml > ../../out/$NAME.trail.txt || true
fi
