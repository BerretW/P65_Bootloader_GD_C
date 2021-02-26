#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "utils.h"
#include "jumptable.h"
#include "ewoz.h"


void setup(){
  ACIAINIT();
  GDINIT();
  KBINIT();
}


void main(void) {
  char c;
  char i;
  int x ;
  setup();

  PRNTLN("APPARTUS PROJEKT65 Bootloader RAM");
  PRNTLN("w for start write to RAM");
  PRNTLN("m for start monitor");
  c = CHRIN();

  while(1){
    if (c == 'm'){
      GD_CLR_TXT();
      GD_CUR_SET(0,0);
      EWOZ();
    }
    if (c == 'w') {
      PRNTLN("Cekam na data pro zapis do RAM");
      write_to_RAM();
    }
    if (c == 't') {
      GD_BCK(i);
      for (x = 0; x <400; ++x) SHDLY();
      ++i;
      if (i >= 16) i = 0;
    }
    if (c == 'v') {
      via_test();
    }
    if (c == 'e') {
      echo_test();
    }
    if (c == 'r') {
      restart();
    }
    if (c == 's') {
      start_ram();
    }
    if (c == 'c') {
      GD_CLR_TXT();
      c = CHRIN();
    }
  }
}
