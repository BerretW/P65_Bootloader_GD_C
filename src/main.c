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
  acia_init();
  GD_Init();
  KBINIT();
}


void main(void) {
  setup();

  PRNTLN("APPARTUS PROJEKT65 Bootloader");
  PRNTLN("w for start write to RAM");
  PRNTLN("m for start monitor");
  if (CHRIN() == 'm') EWOZ();
  while(1){

  }
}
