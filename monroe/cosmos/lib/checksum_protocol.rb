require 'cosmos/interfaces/protocols/protocol'

module Cosmos
 
  class ChecksumProtocol < Protocol

    def initialize(allow_empty_data = nil)

        super(allow_empty_data)
  
      end
 
    def write_packet(packet)
      packet.write('CCSDS_CHECKSUM', 0)
      data = packet.buffer
      checksum = 0xFF
      data.each_byte {|x| checksum = checksum ^ x}
      packet.write('CCSDS_CHECKSUM', checksum)
      return packet
    end # write_packet()
	   
  end # class
 
end # module
