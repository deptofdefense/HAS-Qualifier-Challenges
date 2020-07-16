#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>

int readMsg(char *buff, int maxLen);
int hexWrite(char *buff, int len);
void hangup(char *msg);
