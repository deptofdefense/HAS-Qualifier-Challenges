#include "xmrcv.h"

int xmrcv(long *bytes_rcvd, unsigned char *buf)
{
	int err = 0, x, i, packetno = 0;
	unsigned char ch, seq, cmpl_seq, cksum, their_cksum;
	unsigned char data[128];
	unsigned char *start_buf = buf;

	send_byte(NAK); /* signal ready for start */
	while (1) {
		if (receive_byte(&ch) < 0) { return -1; }
		if (ch == SOH) {
			/* Get a new packet. */
			packetno++;
			err = 0;

			/* Get sequence numbers for packet. */
			if (receive_byte(&seq) < 0) { return -1; }
			if (receive_byte(&cmpl_seq) < 0) { return -1; }

			/* Get data and calculate checksum for packet.
             * Then get the transmitter's checksum.
             */
			cksum = 0;
			for (x = 0; x < 128; x++) {
				if (receive_byte(&data[x]) < 0) { return -1; }
				cksum += data[x];
			}
			if (receive_byte(&their_cksum) < 0) { return -1; }

			/* Check the packet. */
			if (seq + cmpl_seq != 255) {
				/* printf("seq mismatch %d\n",packetno); */ err++;
			}
			if (their_cksum != cksum) {
				/* printf("cksum err %d\n",packetno); */ err++;
			}

			/* Respond to transmitter. */
			if (err) {
				send_byte(NAK);
			} else {
				send_byte(ACK);

				/* Save the data, since we think it's OK */
				for (i = 0; i < 128; i++) {
					*buf++ = data[i];
				}
			}
		} else if (ch == CAN) {
			/* Make sure the receiver is really cancelling, by checking
             * for a second CAN.
             */
			if (receive_byte(&ch) < 0) { return -1; }
			if (ch == CAN) {
				return -1;
			} else {
				continue; /* maybe a glitch */
			}
		} else if (ch == EOT) {
			/* File is done. We must acknowledge the EOT,
			 * and trim the XM_EOFs off the end of the file.
			 */
			send_byte(ACK);
			while (*--buf == XM_EOF);
			buf++;
			*bytes_rcvd = (buf - start_buf);
			return 0; /* success */
		}
	}
}

