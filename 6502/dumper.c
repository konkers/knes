#include <stdio.h>
#include <stdint.h>

#include <unistd.h>

void dump(uint8_t *buff, int len)
{
	int i;
	for (i = 0; i < len; i++) {
		if ((i % 16) == 0x0)
			printf("%04x:", i);
		printf(" %02x",buff[i]);
		if ((i % 16) == 0xf)
			printf("\n");
	}
	if ((i % 16) != 0xf)
		printf("\n");
}


int main(int argc, char *argv[])
{
	uint8_t buff[1024];
	int chr_size, prg_size;
	int i, j;

	read(STDIN_FILENO, buff, 16);

//	dump(buff, 16);

	prg_size = buff[4] * 16 * 1024;
	chr_size = buff[5] * 8 * 1024;

//	printf("prg_size: %d\n", prg_size);
//	printf("chr_size: %d\n", chr_size);
//	printf("total size: %d\n", prg_size + chr_size + 16);

	for (i = 0; i < prg_size; i += 1024) {
		read(STDIN_FILENO, buff, 1024);
		for(j = 0; j < 1024; j++)
			printf("%02X\t// $%04X\n", buff[j], i + j);
	}
}

