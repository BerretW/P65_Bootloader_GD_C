#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "utils.h"
#include "jumptable.h"
#include "ewoz.h"


void setup(){
  ACIA_INIT();
  GD_INIT();
  KBINIT();
}


void main(void) {
  char c;
  setup();

  PRNTLN("APPARTUS PROJEKT65 Bootloader RAM");
  PRNTLN("w for start write to RAM");
  PRNTLN("m for start monitor");
  c = CHRIN();

  while(1){
    if (c == 'm'){
      GD_CLR();
      GD_SET_CUR(0,0);
      EWOZ();
    }
    if (c == 'w') {
      PRNTLN("Cekam na data pro zapis do RAM");
      write_to_RAM();
    }
  }
}
