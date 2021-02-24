#include "gameduino.h"
#include "spi.h"


char spr;
char _posx;
char _posy;



void CLR_scr(){
  int i = 0;
  _wstart(RAM_SPR);            // Hide sdfall sprites
  for (i = 0; i < 0x200; ++i) GD_xhide();
  _end();

  GD_fill(RAM_PIC, 0, 0x0FFF);  // Zero all character RAM
  GD_fill(RAM_SPRIMG, 0, 0x3FFF);   // Clear all sprite data
  GD_fill(RAM_SPRIMG, 0, 0x3FFF);   // Clear all sprite data
}



void GD_Init(){
  unsigned bg_colour;
  bg_colour = RGB(0, 0, 0);
spi_init();
GD_wr(J1_RESET, 1);
CLR_scr();
GD_res_cur();
GD_wr16(BG_COLOR, bg_colour);
GD_fill(RAM_SPRPAL, 0, 0x1FFF);    // Sprite palletes black
GD_fill(VOICES, 0, 0x100);         // Silence
GD_fill(PALETTE16A, 0, 0x80);     // Black 16-, 4-palletes and COMM


  GD_wr16(SCROLL_X, 0);
  GD_wr16(SCROLL_Y, 0);
  GD_wr(JK_MODE, 0);
  GD_wr(SPR_DISABLE, 0);
  GD_wr(SPR_PAGE, 0);
  GD_wr(IOMODE, 0);
  GD_wr16(BG_COLOR, 0);
  GD_wr16(SAMPLE_L, 0);
  GD_wr16(SAMPLE_R, 0);
  GD_wr16(SCREENSHOT_Y, 0);
  GD_wr(MODULATOR, 64);
}


char GD_rd(unsigned addr){
char r;
  _start(addr);
  r = spi_read(0);
  _end();
  return r;
}

void GD_wr(unsigned addr, char v)
{
  _wstart(addr);
  spi_write(v);
  _end();
}



void GD_wr16(unsigned addr, unsigned v)
{
  _wstart(addr);
  spi_write_16_data(v);
  _end();
}


unsigned char GD_rd16(unsigned addr){
  unsigned char r;

  _start(addr);
  r = spi_read(0);
  r |= (spi_read(0) << 8);
//  r = (c | spi_read << 8);
  _end();
  return r;
}

void _start(unsigned addr){
  spi_begin(14);
  spi_write_16_addr(addr);
}

void _wstart(unsigned addr) // start an SPI write transaction to addr
{
  _start(0x8000|addr);
}

void _end(){
  spi_end();
}

void GD_fill(unsigned addr, char v, unsigned count)
{
  _wstart(addr);
  while (count--)
    spi_write(v);
  _end();
}

void GD_res_cur(){
  _posx = 0;
  _posy = 0;
}

void GD_set_cur(char x, char y){
  _posx = x;
  _posy = y;
}

void GD_cursor_LEFT(){
  ++_posx;
  if (_posx >=49) {
    _posx = 0;
    ++_posy;
  }
  GD_cursor_DOWN();
}

void GD_cursor_UP(){

}

void GD_cursor_DOWN(){
  if (_posy >= 36){
    _posy = 0;
  }
}

void GD_prtchar(char x, char y, char c)
{
  _wstart((y << 6) + x);
    spi_write(c);
  _end();
}


void GD_Print_char(char c){
  if (c == 0x0D) GD_NewLine();
  GD_prtchar(_posx, _posy,c);

}



void GD_NewLine(){
  _posx = 0;
  ++_posy;

  if (_posy >= 36){
    _posy = 0;
  }
}

void GD_Printnl(const char *s){
  GD_Print(s);
  GD_NewLine();
}

void GD_Print(const char *s)
{
  while (*s){
    GD_Print_char(*s++);
    GD_cursor_LEFT();
  }

  _end();
}


void GD_sprite(char spr, int x, int y, char image, char palette, char rot, char jk)
{
//  CLR_scr();
  _wstart(RAM_SPR + (spr << 2));
  spi_write_16_data( (palette << 12) | (rot <<9) | x);
  spi_write_16_data((jk <<15) |(image << 9) |y);
  _end();
}



void GD_copy(unsigned addr, char *src, int count)
{ int i = 0;
  _wstart(addr);
  while (--count) {
    spi_write(src[i]);
    ++i;
  }
  _end();
}



void GD_setpal(char pal, unsigned rgb)
{
  GD_wr16(RAM_PAL + (pal << 1), rgb);
}



//sprites

void GD_xhide(){
  spi_write_16_data(0x190);
  ++spr;
}
