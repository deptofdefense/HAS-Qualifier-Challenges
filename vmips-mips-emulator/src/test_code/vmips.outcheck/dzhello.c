struct dz_regs {
    unsigned short csr; /* csr(r/w) */
    unsigned short unused1, unused2, unused3;
    unsigned short lpr; /* rbuf(r)/lpr(w) */
    unsigned short unused4, unused5, unused6;
    unsigned short tcr; /* tcr(r/w) */
    unsigned short unused7, unused8, unused9;
    unsigned short tdr; /* msr(r)/tdr(w) */
};

#define DECSERIAL_ADDR 0xbfe00000

volatile struct dz_regs *dz = (struct dz_regs *)DECSERIAL_ADDR;

void dzinit(void)
{
    dz->csr = 0x20 | (3<<8);
    dz->tcr = 1<<3;
}

void dzputc(int ch)
{
    int timeout = 1 << 17;
    unsigned short tcr;

    while ((dz->csr & 0x8000) == 0)
	if (--timeout < 0)
	    break;

    dz->tdr = ch;

    while ((dz->csr & 0x8000) == 0)
	if (--timeout < 0)
	    break;
}

void dzputs(const char *s)
{
    while (*s != '\0') {
	dzputc(*s++);
    }
    dzputc('\n');
}

void entry(void)
{
    dzinit();
    dzputs("Hello, DEC serial device");
}

