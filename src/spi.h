//extern void __fastcall__ spi_write_to(char *address, char data);
extern void __fastcall__ spi_write_16_addr(char *data);
extern void __fastcall__ spi_write_16_data(char *data);
extern void __fastcall__ spi_write(char data);
extern void __fastcall__ spi_begin(char device);			//CS0 = 14, CS1=13, CS2=11, CS3=7
extern void __fastcall__ spi_end();
extern void __fastcall__ spi_init();
extern char __fastcall__ spi_read(char data);
