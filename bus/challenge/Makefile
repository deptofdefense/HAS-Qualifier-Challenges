
hts_bus_challenge : main.o Eeprom.o Eps.o helpers.o \
	I2CBus.o I2CDevice.o Logging.o Obc.o
	g++ -o bin/hts_bus_challenge obj/main.o obj/Eeprom.o obj/Eps.o obj/helpers.o \
		obj/I2CBus.o obj/I2CDevice.o obj/Logging.o obj/Obc.o -lpthread

main.o : src/main.cpp src/common.h
	g++ -c src/main.cpp -o obj/main.o

Eeprom.o : src/Eeprom.cpp src/Eeprom.h src/I2CDevice.h
	g++ -c src/Eeprom.cpp -o obj/Eeprom.o

Eps.o : src/Eps.cpp src/Eps.h src/I2CDevice.h
	g++ -c src/Eps.cpp -o obj/Eps.o

helpers.o : src/helpers.cpp src/helpers.h
	g++ -c src/helpers.cpp -o obj/helpers.o

I2CBus.o : src/I2CBus.cpp src/I2CBus.h
	g++ -c src/I2CBus.cpp -o obj/I2CBus.o

I2CDevice.o : src/I2CDevice.cpp src/I2CDevice.h
	g++ -c src/I2CDevice.cpp -o obj/I2CDevice.o

Logging.o : src/Logging.cpp src/Logging.h
	g++ -c src/Logging.cpp -o obj/Logging.o

Obc.o : src/Obc.cpp src/Obc.h
	g++ -c src/Obc.cpp -o obj/Obc.o

clean :
	rm bin/hts_bus_challenge obj/main.o obj/Eeprom.o obj/Eps.o obj/helpers.o \
		obj/I2CBus.o obj/I2CDevice.o obj/Logging.o obj/Obc.o