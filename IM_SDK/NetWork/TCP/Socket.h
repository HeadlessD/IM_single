#ifndef __SOCKET_H__
#define __SOCKET_H__

#if defined WIN32
#include <WinSock.h>
#pragma comment(lib,"Ws2_32")
#endif

#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <sys/_select.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/_types/_timeval.h>
#include <netdb.h>
#include <unistd.h>
typedef		int		SOCKET;
#define     INVALID_SOCKET   -1
#define		SOCKET_ERROR	 -1

#include <string.h>//use memset

#ifndef MAX_SIZE
#define MAX_SIZE 256
#endif

typedef  struct fd_set stru_fd_set;

typedef struct sockaddr SOCKADDR;

#ifdef IPV6
typedef struct sockaddr_in6 SOCKADDR_IN;
#define AF_INET_EX AF_INET6
#else
typedef struct sockaddr_in SOCKADDR_IN;
#define AF_INET_EX AF_INET
#endif
namespace BASESOCKET
{
	SOCKET socketEx(int domain, int type, int protocol) ;

	bool bindEx(SOCKET s, const struct sockaddr* name, unsigned int namelen);

	bool connectEx(SOCKET s, const struct sockaddr* name, unsigned int namelen);

	bool listenEx(SOCKET s, unsigned int backlog);

	SOCKET acceptEx(SOCKET s, struct sockaddr* addr, unsigned int* addrlen);

	unsigned int getsockoptEx(SOCKET s, int level, int optname, void* optval, unsigned int* optlen);

	bool setsockoptEx(SOCKET s, int level, int optname, const void* optval, unsigned int optlen);

	unsigned int sendEx(SOCKET s, const void* buf, unsigned int len, unsigned int flags);

	unsigned int sendtoEx(SOCKET s, const void* buf, int len, unsigned int flags, const struct sockaddr* to, int tolen);

	unsigned int recvEx(SOCKET s, void* buf, unsigned int len, unsigned int flags);

	unsigned int recvfromEx(SOCKET s, void* buf, int len, unsigned int flags, struct sockaddr* from, unsigned int* fromlen);

	bool closesocketEx(SOCKET s);

	bool ioctlsocketEx(SOCKET s, long cmd, unsigned long* argp);

	bool shutdownEx(SOCKET s, unsigned int how);

	int selectEx(int maxfdp1, fd_set* readset, fd_set* writeset, fd_set* exceptset, struct timeval* timeout);

	bool setsocketnonblockEx(SOCKET s,bool on); //on 开启非阻塞

	bool getsocketisnonblockEx(SOCKET s);

	unsigned int getsocketrecvbufferEx(SOCKET s);
}


#endif //__SOCKET_H__
