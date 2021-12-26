#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <peekpoke.h>

#include "utils.h"
#include "jumptable.h"
#include "ewoz.h"
#include "acia.h"
#include "pckybd.h"
#include "saa1099.h"
#include "vdp.h"
#include "strings.h"
#include "lcd.h"






void tune_playnote (char chan, char note, char volume) {

  char noteAdr[12]= {5, 32, 60, 85, 110, 132, 153, 173, 192, 210, 227, 243};
  char octaveAdr[3] = {0x10, 0x11, 0x12}; //The 3 octave addresses (was 10, 11, 12)
  char channelAdr[6] = {0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D};
  char octave;
  char noteVal;
  char prevOctaves[6] = {0, 0, 0, 0, 0, 0};
  char data_to_write;
  //noteAdr[] = {5, 32, 60, 85, 110, 132, 153, 173, 192, 210, 227, 243}; // The 12 note-within-an-octave values for the SAA1099, starting at B
  //octaveAdr[] = {0x10, 0x11, 0x12}; //The 3 octave addresses (was 10, 11, 12)
  //channelAdr[] = {0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D}; //Addresses for the channel frequencies

  //Percussion code, in this version we're ignoring percussion.
  if (note > 127) { // Notes above 127 are percussion sounds.
	note = 60; //Set note to some random place
	volume = 0; //Then set it to 0 volume
  }



  //Shift the note down by 1, since MIDI octaves start at C, but octaves on the SAA1099 start at B
  note += 1;

  octave = (note / 12) - 1; //Some fancy math to get the correct octave
  noteVal = note - ((octave + 1) * 12); //More fancy math to get the correct note

  prevOctaves[chan] = octave; //Set this variable so we can remember /next/ time what octave was /last/ played on this channel

  //Octave addressing and setting code:
  //digitalWrite(AO, HIGH);
  //PORTD = octaveAdr[chan / 2];
  //writeAddress();
  saa_write_register(octaveAdr[chan / 2]);



  //digitalWrite(AO, LOW);
  if (chan == 0 || chan == 2 || chan == 4) {
    data_to_write = octave | (prevOctaves[chan + 1] << 4); //Do fancy math so that we don't overwrite what's already on the register, except in the area we want to.
  }

  if (chan == 1 || chan == 3 || chan == 5) {
    data_to_write = (octave << 4) | prevOctaves[chan - 1]; //Do fancy math so that we don't overwrite what's already on the register, except in the area we want to.
  }

  //writeAddress();
  saa_write_data(data_to_write);


  //Note addressing and playing code
  //Set address to the channel's address
  //digitalWrite(AO, HIGH);
  //PORTD = channelAdr[chan];
  //writeAddress();
  saa_write_register(channelAdr[chan]);

  //EXPERIEMNTAL WARBLE CODE
  //noteAdr[noteVal] += random(-2, 2); //a plus/minus value of 15 gives a really out of tune version


  //Write actual note data
  //digitalWrite(AO, LOW);
  //PORTD = noteAdr[noteVal];
  //writeAddress();
  saa_write_data(noteAdr[noteVal]);


  //Volume updating
  //Set the Address to the volume channel
  //digitalWrite(AO, HIGH);
  //PORTD = chan, HEX;
  //writeAddress();
  saa_write_register(chan);
  saa_write_data(volume);
}

void lcd_setup(){
  lcd_init();
  lcd_displayOn();
  lcd_cursorBlinkOn();
}



void setup(){
  lcd_setup();
  //vpoke(0x5004,0x55);
  init_vec();
  //print_byte(PEEK(0x5004));
  //test_3_var(1,3,6,255);
  init_vec();
  irq_init();
  nmi_init();

  vdp_init();
  vdp_print(m5);
  vdp_print_nl(m6);
  acia_print(m5);
  acia_print_nl(m6);



  acia_init();
  vdp_print(m3);
  vdp_print_nl(m6);
  acia_print(m3);
  acia_print_nl(m6);



  if (kb_check() == 0x00){
    kb_init();
    vdp_print(m4);
    vdp_print_nl(m6);
    acia_print(m4);
    acia_print_nl(m6);
  } else {
    vdp_print(m4);
    vdp_print_nl(m7);
    acia_print(m4);
    acia_print_nl(m7);

  }

  saa_init();
  acia_print_nl("SAA Initialised");
  //note = 0x6;
  //chan = 0x0;
  //volume = 0xFF;
  //saa_play_note();
  //tune_playnote(0,60,240);
  //spi_init();
  //SD_INIT();
}

void IRQ_Event(){
  acia_putc('I');
}
void NMI_Event(){
  acia_putc('N');
}

void main(void) {


  char c;
  char i;
  int x ;
  INTDI();
  setup();
  //INTDI();
  //INTEN();



acia_print_nl(m0);
vdp_print_nl(m0);
acia_print_nl(m1);
vdp_print_nl(m1);
acia_print_nl(m2);
vdp_print_nl(m2);


  while(1){

    c = get_input();

    switch (c){
      case 'm':
        EWOZ();
      break;

      case 'w':

      acia_print_nl("Cekam na data pro zapis do RAM");
      vdp_print_nl("Cekam na data pro zapis do RAM");
      write_to_RAM();
      break;


      case 'v':
        acia_print_nl("VIA test");
        vdp_print_nl("VIA test");
        via_test();
      break;

      case 'k':
      acia_print_nl("PS2 Keyboard test");
      vdp_print_nl("PS2 Keyboard test");
        while(1){
          c = kb_input();
          if (c != 0x0) {
            acia_putc(c);
            VDP_print_char(c);

            //GD_Print_char(c);
            //GD_cursor_RIGHT();
          }
        }
      break;


      case 'e':
      acia_print_nl("Echo test");
        echo_test();
      break;

      case 0x12:
        acia_print_nl("Restart");
        RST();
      break;

      case 's':
        acia_print_nl("Start program from $6000");
        vdp_print_nl("Start program from $6000");
        start_ram();
      break;

      case 0x03:
      break;

      default:

      break;
    }
  }
}
