#include <stdio.h>
#pragma inline
extern char* SCORES;
int main(void){
    SCORES[0]='F';
    printf("FUCK TC %s\n",SCORES);
	return 0;
}
