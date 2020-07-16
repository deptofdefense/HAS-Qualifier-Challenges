#define SOH          0x01         /* Start Of Header */
#define EOT          0x04         /* End Of Transmission */
#define ACK          0x06         /* Acknowledge (positive) */
#define DLE          0x10         /* Data Link Escape */
#define XON          0x11         /* Transmit On */
#define XOFF         0x13         /* Transmit Off */
#define NAK          0x15         /* Negative Acknowledge */
#define SYN          0x16         /* Synchronous idle */
#define CAN          0x18         /* Cancel */
#define XM_EOF	     0x1a

extern int receive_byte(unsigned char *ch);
extern int send_byte(unsigned char ch);

int xmrcv(long *bytes_rcvd, unsigned char *buf);
