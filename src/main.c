#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "acia.h"
#include "utils.h"
#include "gameduino.h"
#include "spi.h"
#include "jumptable.h"
#include "pckybd.h"
#include "ewoz.h"


void setup(){
  ACIA_INIT();
  GD_Init();
  KBINIT();
}


void main(void) {
  char c;
  setup();

  PRNTLN("APPARTUS PROJEKT65 Bootloader");
  PRNTLN("w for start write to RAM");
  PRNTLN("m for start monitor");
  c = CHRIN();

  while(1){
    if (c == 'm') EWOZ();
    if (c == 'w') {
      PRNTLN("Cekam na data pro zapis do RAM");
      write_to_RAM();
    }
  }
}
