/*
 * test5.c
 * table gets filled with 0, 2, 4, ... 18
 *
 */

#define SIZE 10

char table[SIZE];

main()
{
	char i;
	
	for (i=0; (i<=(SIZE-1)); i++)
		table[i] = i*2;
}
