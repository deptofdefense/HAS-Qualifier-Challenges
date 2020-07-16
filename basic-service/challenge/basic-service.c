#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <limits.h>
#include <signal.h>
#include <unistd.h>
#include <errno.h>

#define DEFAULT_TIMEOUT 5

/*
 * Handles receiving the SIGALRM signal.
 */
void alarm_handler(int sig) {
    puts("Time's up!");
    exit(1);
}

/*
 * Performs the actual challenge logic.
 *
 * In this case, it's a simple random math question.
 */
bool run_challenge()
{
    // ask user a math problem
    unsigned int x = rand() & INT_MAX;
    unsigned int y = rand() & INT_MAX;
    printf("%d + %d = ?", x, y);
    fflush(stdout);

    // return whether the answer was right or not
    unsigned int z = 0;
    scanf("%d", &z);
    return x + y == z;
}

/*
 * Main function.
 */
int main(int argc, char **argv)
{
    (void)argc;
    (void)argv;
    unsigned int seed;
    char *flag;
    unsigned int timeout;
    bool success;

    // set flag from environment
    if (getenv("FLAG") == NULL) {
        puts("No flag present");
        exit(-1);
    }
    flag = getenv("FLAG");

    // set seed from environment
    if (getenv("SEED") == NULL) {
        puts("No seed present");
        return -1;
    }
    char *begin = getenv("SEED");
    char *end = begin + strlen(getenv("SEED"));
    seed = strtoul(begin, &end, 10);
    if (begin == end || errno == ERANGE || errno == EINVAL) {
        puts("Bad seed");
        return -1;
    }
    srand(seed);

    // set timeout from environment
    begin = getenv("TIMEOUT");
    if (begin != NULL) {
        end = begin + strlen(getenv("TIMEOUT"));
        timeout = strtoul(begin, &end, 10);
        if (begin == end || errno == ERANGE || errno == EINVAL) {
            timeout = DEFAULT_TIMEOUT;
        }
    } else {
        timeout = DEFAULT_TIMEOUT;
    }

    // set alarm
    signal(SIGALRM, alarm_handler);
    alarm(timeout);

    // run challenge
    success = run_challenge();

    // turn off alarm
    signal(SIGALRM, SIG_IGN);

    // check for success
    if (success) {
        printf("You got it!\nHere's your flag:\n");
        printf("%s\n", flag);
    } else {
        printf("Incorrect.\nBetter luck next time!\n");
    }

    return 0;
}
