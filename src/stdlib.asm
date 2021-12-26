.setcpu		"65C02"
.smart		on
.autoimport	on


.include "io.inc65"
.include "macros_65C02.inc65"
.include "zeropage.inc65"



.segment "ZEROPAGE"
.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
.importzp tmpstack

.segment "CODE"
