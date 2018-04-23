#include <stdio.h>
#include <string.h>
#define static_assert(x) switch(x) case 0: case (x):
#define ADMIN if(!privlvl)
#define NOADMIN if(privlvl)
typedef struct _Good{
    char name[10];
    int inprice;
    int sellprice;
    int stock;
    int sold;
    int profit;
}Good;

Good shop1[10]={{"pen",35,56,70,25,0},{"book",12,30,25,5,0}}
    ,shop2[10]={{"pen",12,28,20,15,0},{"book",35,50,30,24,0}};
Good* shop1top = shop1+2,*shop2top = shop2+2;

int strfcmp(const char* stra,const char* strb);
void MODGOODS(Good* shop1begin,Good* shop1top,Good* shop2begin,Good* shop2top);
void CAPR(Good* shop1begin,Good* shop1top,Good* shop2begin,Good* shop2top);
void CPRR(Good* shop1begin,Good* shop1top,Good* shop2begin,Good* shop2top);
void PAG(Good* shop1begin,Good* shop1top,Good* shop2begin,Good* shop2top);

void menu(int privlvl);

const char* username = "HUTZHOU";
const char* password = "tstpasswd";

char globbuf[50];

int main(void){
    char buffer[50];
    char pswdbuf[50];
    buffer[0]='\0';
    pswdbuf[0]='\0';
    while(1){
        printf("Please Input User Name:");
        scanf("%s",buffer);
        if(!strfcmp("GUEST",buffer)){
            menu(3);
        }else if(!strfcmp("q",buffer)){
            return 0;
        }else{
            printf("Please Input Password:");
            scanf("%s",pswdbuf);
            if(!strfcmp(buffer,username) && !strfcmp(pswdbuf,password)){
                menu(0);
            }else{
                printf("Username and Password Mismatch!\n");
            }
        }
    }
	return 0;
}

void menu(int privlvl){
    int sel=0,stat=0,i=0;
    Good* shop1dstgood = NULL, *shop2dstgood = NULL;
    while(1){
        printf("1. Query Goods\n");
        ADMIN printf("2. Modify Goods\n");
        ADMIN printf("3. Calculate Average Profit Rate\n");
        ADMIN printf("4. Calculate Profit Rate Rank\n");
        ADMIN printf("5. Print All Goods\n");
        printf("6. Quit System\n");
        printf("Please select: (opcode)> ");
        if(!(stat = scanf("%d",&sel))){
            scanf("%s",globbuf);
            continue;
        }
        if(sel == 1){
            printf("Please input good name:");
            scanf("%s",globbuf);
            i = 0;
            for(i=0;shop1+i < shop1top;i++){
                if(!strfcmp(shop1[i].name,globbuf)){
                    shop1dstgood = &(shop1[i]);
                    break;
                }
            }
            if(shop1+i == shop1top){
                printf("Not found in shop1\n");
                continue;
            }
            i = 0;
            for(i=0;shop2+i < shop2top;i++){
                if(!strfcmp(shop2[i].name,globbuf)){
                    shop2dstgood = &(shop2[i]);
                    break;
                }
            }
            if(shop2+i == shop2top){
                printf("Not found in shop2\n");
                continue;
            }
            printf("shopname,goodname,price,stock,sold\n");
            printf("%s,%s,%d,%d,%d\n","shop1",shop1dstgood->name,shop1dstgood->sellprice,shop1dstgood->stock,shop1dstgood->sold);
            printf("%s,%s,%d,%d,%d\n","shop2",shop2dstgood->name,shop2dstgood->sellprice,shop2dstgood->stock,shop2dstgood->sold);
        }else if(sel == 2){
            NOADMIN {printf("Permission Denied!\n");continue;}
            MODGOODS(shop1,shop1top,shop2,shop2top);
        }else if(sel == 3){
            NOADMIN {printf("Permission Denied!\n");continue;}
            CAPR(shop1,shop1top,shop2,shop2top);
        }else if(sel == 4){
            NOADMIN {printf("Permission Denied!\n");continue;}
            CPRR(shop1,shop1top,shop2,shop2top);
        }else if(sel == 5){
            NOADMIN {printf("Permission Denied!\n");continue;}
            PAG(shop1,shop1top,shop2,shop2top);
        }else if(sel == 6){
            break;
        }else{continue;}
    }
}

int strfcmp(const char* stra,const char* strb){
    int fuck=0;
    if((fuck = strcmp(stra,strb))) return fuck;
    return strlen(stra)-strlen(strb);
}