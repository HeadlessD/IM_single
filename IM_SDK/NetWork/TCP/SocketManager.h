#ifndef __SOCKET_MANAGER_H__
#define __SOCKET_MANAGER_H__
#include "Socket.h"
#include "CriticalSection.h"
#ifdef IPV6
#define	MAX_IP_LENGTH 64
#else
#define MAX_IP_LENGTH 24
#endif
class SocketManager
{
public:
	SocketManager();
	virtual ~SocketManager();

	bool Create();
	void Close();
    bool Connect(const char *host_name,unsigned int port, bool is_domain);

	unsigned int Send(const void* buf, unsigned int len, unsigned int flags = 0);
	unsigned int Receive(void* buf, unsigned int len, unsigned int flags = 0);
	SOCKET Accept(struct sockaddr* addr, unsigned int* addrlen);

	bool bind();
	bool bind(unsigned int port);

	bool listen(int backlog);

	SOCKET getSocket() const;

	int setLinger(unsigned int lingerTime);
	unsigned int getLinger() const;
    
    bool setSendBufferLen(const unsigned long &buf_len);
    int  getSendBufferLen();
    bool setRecvBufferLen(const unsigned long &buf_len);
    int  getRecvBufferLen();
    
	bool isSocketError() const;

	bool isNonBlocking() const;
	bool setNonBlocking(bool flag = true);

	unsigned int getSocketRecvSize() const; 
protected:
private:
	SOCKET m_SocketID;

	SOCKADDR_IN m_SockAddrIn;

	char m_Host[MAX_IP_LENGTH];
    
	unsigned int m_Port;
};
#endif
