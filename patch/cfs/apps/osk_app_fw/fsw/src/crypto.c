#include "crypto.h"
#include <openssl/sha.h>
#include <time.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <strings.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>


static unsigned char key[32];
static unsigned char iv[16];

void sha256_string(char *string, char outputBuffer[65]){
    unsigned char hash[SHA256_DIGEST_LENGTH];
    SHA256_CTX sha256;
    SHA256_Init(&sha256);
    SHA256_Update(&sha256, string, strlen(string));
    SHA256_Final(hash, &sha256);
    int i = 0;
    for(i = 0; i < SHA256_DIGEST_LENGTH; i++)
    {
        sprintf(outputBuffer + (i * 2), "%02x", hash[i]);
    }
    outputBuffer[64] = 0;
}

void generate_random(char *seed, unsigned char *out, size_t len){
    static char hashBuff[65];  
    sha256_string(seed, hashBuff);
    CFE_PSP_MemCpy(out, hashBuff, len);
}

unsigned char* get_key(void) {
    char *seed = getenv("SEED");
    if (!seed) {
        seed = "DEFAULT";
    }
    generate_random(seed, key, sizeof(key));
    return (unsigned char *)"01234567890123456789012345678901";
}
unsigned char* get_iv(void) {
    char buff[128];
    bzero(buff, 128);
    int fd = open("/dev/urandom", O_RDONLY);
    read(fd, buff, 127);
    close(fd); 
    generate_random(buff, iv, sizeof(iv));
    return iv;
}
