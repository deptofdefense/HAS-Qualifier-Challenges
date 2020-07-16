import binascii
import sys

start_seq = '1101111010101101'          # DEAD
alt_start_seq = '0101111010101101'       # 5EAD
end_seq = 'BEEF'

def convert_bit_stream(bit_stream):
    bit_data = b''
    data = b''
    found = False
    for i in range(len(bit_stream)):

        if bit_stream[i] == b'\x00':
            bit_data += "0" 
        else:
            bit_data += "1"
    i = 0
    # scan for start sequence, when a start sequence is detected, extract the correct
    # start sequence, data, and end sequence
    while i < len(bit_data):
        if bit_data[i:i+len(start_seq)] == start_seq or \
                bit_data[i:i+len(alt_start_seq)] == alt_start_seq:
            # extract the internal data
            extracted_bin_data = bit_data[i+len(start_seq):i + len(start_seq) + 7 * 8]
            # if there is not enough data to form a packet, drop the packet
            if len(extracted_bin_data) < 7 * 8:
                break
            # recreate the correct CLTU packet
            data += "DEAD"      # start sequence
            # recreate the correct bytes from sequence of 0s and 1s
            for j in range(0, len(extracted_bin_data), 8):
                byte_value = int(extracted_bin_data[j:j+8],2)
                data += "{:02x}".format(byte_value)
            data += "FEBEEF"    # dummy parity + end sequence
            i += 12 * 8
        else:
            i += 1


    return binascii.unhexlify(data)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print "Usage: python2 convert.py [infile] [outfile]"
    with open(sys.argv[1], 'rb') as fh:
        data = fh.read()

    with open(sys.argv[2], 'wb') as fh:
        fh.write(convert_bit_stream(data))
