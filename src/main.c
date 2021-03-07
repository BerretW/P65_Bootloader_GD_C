#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "utils.h"
#include "jumptable.h"
#include "ewoz.h"
#include "pckybd.h"
#include "acia.h"
//#define KEYBOARD;
//#define GAMEDUINO;
#define FULL;
//#define SERIAL;

void setup(){
  init_vec();
  #if defined(SERIAL) || defined (FULL)
    ACIAINIT();
  #endif
  #if defined(KEYBOARD) || defined (FULL)
    KBINIT();
  #endif

  #if defined(GAMEDUINO) || defined (FULL)
    GDINIT();
    GD_BCK(5);
  #endif

  //


}


void main(void) {
  char c;
  char i;
  int x ;
  char *m0 = "APPARTUS PROJEKT65 Bootloader";
  char * m1 = "w for start write to RAM";
  char * m2 = "m for start monitor";
  INTDI();
  setup();
#if defined (FULL)
  PRNL();
  PRNTLN(m0);
  PRNTLN(m1);
  PRNTLN(m2);
#endif
#if defined (GAMEDUINO)
  GD_Print(m0);
  GD_NewLine();
  GD_Print(m1);
  GD_NewLine();
  GD_Print(m2);
  GD_NewLine();
#endif

#if defined (SERIAL)
acia_print_nl(m0);
acia_print_nl(m1);
acia_print_nl(m2);
#endif

  while(1){
    #if defined (KEYBOARD) || defined (FULL)
      c = CHRIN();
    #endif
    #if defined (SERIAL)
      c = acia_getc();
    #endif

    switch (c){
      case 'm':
      #if defined (GAMEDUINO) || defined (FULL)
        GD_CLR_TXT();
        GD_CUR_SET(0,0);
        GD_BCK(5);
      #endif
        EWOZ();
      break;

      case 'w':
      #if defined (GAMEDUINO) || defined (FULL)
        GD_BCK(2);
      #endif
      #if defined (FULL)
        PRNTLN("Cekam na data pro zapis do RAM");
      #endif
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
      #if defined (FULL)
        GD_CLR_TXT();
      #endif
      break;

      default:

      break;
    }


  }
}
