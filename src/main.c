#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "acia.h"
#include "utils.h"
#include "gameduino.h"
#include "spi.h"
#include "jumptable.h"
#include "gd.h"
#include "pckybd.h"



void setup(){
  acia_init();
  GD_Init();
  KBINIT();
}


void main(void) {
  setup();

  PRNTLN("Vita Vas Projekt65");
  PRNTLN("Produkt skupiny APPARTUS lůhlh jklh  jklůghjklůh jklh jklů jklhkjhg nmnm,b nm,bnm,bnm,b nm,gbhjkggzhjv ujtvzlh  zufghjklgvhjv zhjgfvh");
  echo_test();
  while(1){

  }
}
