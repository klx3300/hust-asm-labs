#include <stdio.h>
#include <string.h>
typedef struct _Good{
    char name[10];
    short inprice;
    short sellprice;
    short stock;
    short sold;
    short profit;
}Good;

Good shop1[10]={{"pen",35,56,70,25,0},{"book",12,30,25,5,0}}
    ,shop2[10]={{"pen",12,28,20,15,0},{"book",35,50,30,24,0}};
Good* shop1top = shop1+sizeof(Good)*2,*shop2top = shop2+sizeof(Good)*2;

int main(void){
    printf("FUCK TC\n");
	return 0;
}
