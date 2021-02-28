#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "utils.h"
#include "jumptable.h"
#include "ewoz.h"
#include "pckybd.h"

void setup(){
  init_vec();
  ACIAINIT();
  GDINIT();
  KBINIT();
  GD_BCK(6);
  INTDI();
}


void main(void) {
  char c;
  char i;
  int x ;
  setup();

  PRNL();
  PRNTLN("APPARTUS PROJEKT65 Bootloader");
  PRNTLN("w for start write to RAM");
  PRNTLN("m for start monitor");


  while(1){
    c = CHRIN();

    switch (c){
      case 'm':
        GD_CLR_TXT();
        GD_CUR_SET(0,0);
        GD_BCK(5);
        EWOZ();
      break;
      case 'w':
        GD_BCK(2);
        PRNTLN("Cekam na data pro zapis do RAM");
        write_to_RAM();
      break;
      case 't':
        GD_BCK(i);
        ++i;
        if (i >= 16) i = 0;
      break;
      case 'v':
        via_test();
      break;
      case 'e':
        echo_test();
      break;
      case 0x12:
        restart();
      break;
      case 's':
        start_ram();
      break;
      case 0x03:
        GD_CLR_TXT();
      break;

      default:

      break;
    }


  }
}
