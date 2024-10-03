void
main()
{
	char c;
	int i;
	int j;
	char *video_memory = (char *) 0xb8000;
	
	for (c = 'X';;) {
		for (i = 0; i < 80 * 25 * 2; i += 2) {
			*(video_memory + i) = c;
			*(video_memory + i + 1) = 0x0f;
			for (j = 0; j < 100000; j += 1);
		}
		if (c == 'X') {
			c = '0';
		} else {
			c = 'X';
		}
	}
}
