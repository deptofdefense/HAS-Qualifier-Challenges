#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <strings.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <sys/time.h>
#include <errno.h>
#include <sys/poll.h>

#include <signal.h>

void error(char *msg) {
  perror(msg);
  exit(1);
}

void timeout_func(int signo) 
{
  exit(-1);
}

int setup_socket_server(int type, short port) {
  int server_fd;
  struct sockaddr_in serv_addr; 

  server_fd = socket(AF_INET, type, 0);
  if (server_fd < 0) 
    error("ERROR opening socket");
  
  bzero((char *) &serv_addr, sizeof(serv_addr));
  
  serv_addr.sin_family = AF_INET;
  serv_addr.sin_port = htons(port);
  serv_addr.sin_addr.s_addr = INADDR_ANY;
  
  int enable = 1;
  if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &enable, sizeof(int)) < 0)
      error("setsockopt(SO_REUSEADDR) failed");

  if (bind(server_fd, (struct sockaddr *) &serv_addr, sizeof(serv_addr)) < 0)
    error("ERROR on binding");

  return server_fd;
}

int setup_socket_udp(short port, struct sockaddr_in * client_addr) {
  int client_fd;

  client_fd = socket(AF_INET, SOCK_DGRAM, 0);
  if (client_fd < 0) 
    error("ERROR opening socket");
  
  bzero((char *)client_addr, sizeof(*client_addr));
  
  client_addr->sin_family = AF_INET;
  client_addr->sin_port = htons(port);
  client_addr->sin_addr.s_addr = INADDR_ANY;
  
  int enable = 1;
  if (setsockopt(client_fd, SOL_SOCKET, SO_REUSEADDR, &enable, sizeof(int)) < 0)
      error("setsockopt(SO_REUSEADDR) failed");

  return client_fd;
}



int main(int argc, char *argv[]) {
  struct pollfd fds[3];
  int nfds = 2;
  bzero(fds, sizeof(fds));

  int tcpserver_fd = setup_socket_server(SOCK_STREAM, 54321);
  listen(tcpserver_fd, 5);
  
  struct sockaddr_in tcp_addr;
  int tcplen = sizeof(tcp_addr);

  fds[0].fd     = tcpserver_fd;
  fds[0].events = POLLIN;

  // Data coming in from cFS
  int udp_in_fd = setup_socket_server(SOCK_DGRAM, 1235);

  fds[1].fd     = udp_in_fd;
  fds[1].events = POLLIN;

  fds[2].fd = -1;

  // Data going out to cFS
  struct sockaddr_in out_addr;
  int udp_out_fd = setup_socket_udp(1234, &out_addr);

  int running = 1;
  char buffer[512];
  bzero(buffer, sizeof(buffer));

  int timeout = 300;
  char *timeout_str = getenv("TIMEOUT");
  if (timeout_str) {
    timeout = atoi(timeout_str);
  }
  signal(SIGALRM, timeout_func);
  alarm(timeout+2);

  while (running)
  {
    if (0 > poll(fds, nfds, -1)) // no timeout
    { 
      error("Poll Failed");
    } 
    
    // Handle accepting the socket, replace the client socket if it exists
    if (fds[0].revents == POLLIN) {
      if (fds[2].fd != -1) {
        close(fds[2].fd);
        bzero(&fds[2], sizeof(struct pollfd));

        fds[2].fd = -1;
        nfds = 2;
      }

      fds[2].fd = accept(tcpserver_fd, (struct sockaddr *) &tcp_addr, &tcplen);
      if (fds[0].fd < 0) {
        error("ERROR on accept");
      }
      fds[2].events = POLLIN;
      nfds = 3;
    }
    else if (fds[0].revents != 0) {
      // This is unexpected, it's some other event
      error("Unexpected event on the TCP Listen socket");
    }

    // It's a client socket, time to recieve
    if (fds[2].revents == POLLIN) {
      int n = recv(fds[2].fd, buffer, sizeof(buffer), 0);
      if (n < 0) {
        error("ERROR Receiving on TCP");
      }
      else if (n == 0) {
        // End of File, socket is closed
        close(fds[2].fd);
        bzero(&fds[2], sizeof(struct pollfd));

        fds[2].fd = -1;
        nfds = 2;

      }
      else {
        // Send it out to the UDP Socket
        int total = n;
        int sent  = 0;
        while (sent < total) {
          n = sendto(udp_out_fd, buffer + sent, total - sent, 0,
              (const struct sockaddr *) &out_addr, sizeof(out_addr));
          if (n < 0) {
            running = 0; 
            error("ERROR failed sendto");
          }
          sent += n;
        }
      }
    }
    else if (fds[2].revents != 0) {
      // This is unexpected, it's some other event
      error("Unexpected event on the TCP Client socket");
    }

    // Receive from UDP
    if (fds[1].revents == POLLIN) {
      struct sockaddr_in udp_out_addr;
      int udp_out_len = 0;
      
      bzero(buffer,sizeof(buffer));
      
      int n = recvfrom(fds[1].fd, buffer, sizeof(buffer), 0,
          (struct sockaddr *)&udp_out_addr, &udp_out_len);

      if (n < 0) {
        error("ERROR on Receive from UDP");
      } 

      // If we have a destination, make sure to send it out
      else if (fds[2].fd != -1) {
        int sent = 0;
        int total = n;
        while (sent < total) {
          n = write(fds[2].fd, buffer + sent, total - sent);
          if (n == 0) {
            // Closed
            running = 0;
          }
          sent += n;
        }
      }
    }

  }

  close(fds[0].fd);
  close(fds[1].fd);
  if (fds[2].fd != -1)
    close(fds[2].fd);
}
