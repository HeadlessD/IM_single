#include "SocketManager.h"


SocketManager::SocketManager()
{
	m_SocketID = INVALID_SOCKET;
	memset(m_Host,0,MAX_IP_LENGTH);
	memset(&m_SockAddrIn,0,sizeof(SOCKADDR_IN));
	m_Port = 0;
}

SocketManager::~SocketManager()
{
	Close();
}

bool SocketManager::Create()
{
#ifdef WIN32
	WSADATA Ws;
	if (WSAStartup(MAKEWORD(2,2),&Ws) != 0)
	{
		return false;
	}
#endif

    m_SocketID = BASESOCKET::socketEx(AF_INET_EX, SOCK_STREAM, 0);
    
	if (m_SocketID != INVALID_SOCKET)
		return true;
	else
		return false;
}

void SocketManager::Close()
{
	if(m_SocketID != INVALID_SOCKET)
	{
		BASESOCKET::closesocketEx(m_SocketID);
	}
	m_SocketID = INVALID_SOCKET;
	memset(&m_SockAddrIn,0,sizeof(SOCKADDR_IN));
	memset(m_Host,0,MAX_IP_LENGTH);
	m_Port = 0;
#if WIN32
	WSACleanup();
#endif
}

bool SocketManager::Connect(const char *host_name,unsigned int port, bool is_domain)
{
    if(is_domain)
    {
        hostent *p_hostent = gethostbyname(host_name);
        if(nullptr == p_hostent)
        {
            return false;
        }
        
        struct in_addr *p_addr = ((struct in_addr *)p_hostent->h_addr);
#ifdef IPV6
        inet_ntop(AF_INET_EX, p_addr, m_Host, INET6_ADDRSTRLEN);
#else
        inet_ntop(AF_INET_EX, p_addr, m_Host, INET_ADDRSTRLEN);
#endif
    }
    else
    {
        strncpy(m_Host, host_name, MAX_IP_LENGTH-1);
    }
    
    m_Port = port;
    
    Create();
    
    memset(&m_SockAddrIn,0,sizeof(SOCKADDR_IN));
    
#ifdef IPV6
    m_SockAddrIn.sin6_family = AF_INET_EX;
    m_SockAddrIn.sin6_port = htons(m_Port);
    inet_pton(m_SockAddrIn.sin6_family, m_Host, (sockaddr *)&m_SockAddrIn.sin6_addr);
#else
    m_SockAddrIn.sin_family = AF_INET_EX;
    m_SockAddrIn.sin_port = htons(m_Port);
    inet_pton(m_SockAddrIn.sin_family, m_Host, (sockaddr *)&m_SockAddrIn.sin_addr);
    memset(&(m_SockAddrIn.sin_zero),0x00,8);
#endif
    
	bool result = BASESOCKET::connectEx(m_SocketID,(SOCKADDR*)&m_SockAddrIn,sizeof(SOCKADDR));
	
	return result;
}



unsigned int SocketManager::Send(const void* buf, unsigned int len, unsigned int flags /* = 0 */)
{
	return BASESOCKET::sendEx(m_SocketID,buf,len,flags);
}

unsigned int SocketManager::Receive(void* buf, unsigned int len, unsigned int flags /* = 0 */)
{
	return BASESOCKET::recvEx(m_SocketID,buf,len,flags);
}

SOCKET SocketManager::Accept(struct sockaddr* addr, unsigned int* addrlen)
{
	return BASESOCKET::acceptEx(m_SocketID,addr,addrlen);
}

bool SocketManager::bind()
{
#ifdef IPV6
    m_SockAddrIn.sin6_addr = in6addr_any;
    m_SockAddrIn.sin6_port = htons(m_Port);
#else
	m_SockAddrIn.sin_addr.s_addr = htonl(INADDR_ANY);
	m_SockAddrIn.sin_port = htons(m_Port);
#endif
	bool result = BASESOCKET::bindEx(m_SocketID,(SOCKADDR*)&m_SockAddrIn,sizeof(SOCKADDR));
	if(result)
		return true;
	else	
		return false;
	return true;
}

bool SocketManager::bind(unsigned int port)
{
	m_Port = port;
	return bind();
}

bool SocketManager::listen(int backlog)
{
	return BASESOCKET::listenEx(m_SocketID,backlog);
}

SOCKET SocketManager::getSocket() const
{
	return m_SocketID;
}

int	SocketManager::setLinger(unsigned int lingerTime)
{
	struct linger lg;
	lg.l_onoff = lingerTime > 0 ? 1 : 0;
	lg.l_linger = lingerTime > 0 ? lingerTime : 0;
	return BASESOCKET::setsockoptEx(m_SocketID,SOL_SOCKET,SO_LINGER,&lg,sizeof(struct linger));
}

unsigned int SocketManager::getLinger() const
{
	struct linger lg;
	unsigned int len = sizeof(struct linger);
	BASESOCKET::getsockoptEx(m_SocketID,SOL_SOCKET,SO_LINGER,&lg,&len);
	return lg.l_linger;
}

bool SocketManager::setSendBufferLen(const unsigned long &buf_len)
{
    return BASESOCKET::setsockoptEx(m_SocketID,SOL_SOCKET,SO_SNDBUF, &buf_len, sizeof(buf_len));
}

int  SocketManager::getSendBufferLen()
{
    int buf_len = 0;
    unsigned int size = sizeof(buf_len);
    BASESOCKET::getsockoptEx(m_SocketID,SOL_SOCKET,SO_SNDBUF,&buf_len,&size);
    return buf_len;
}

bool SocketManager::setRecvBufferLen(const unsigned long &buf_len)
{
    return BASESOCKET::setsockoptEx(m_SocketID,SOL_SOCKET,SO_RCVBUF, &buf_len, sizeof(buf_len));
}

int  SocketManager::getRecvBufferLen()
{
    int buf_len = 0;
    unsigned int size = sizeof(buf_len);
    BASESOCKET::getsockoptEx(m_SocketID,SOL_SOCKET,SO_RCVBUF,&buf_len,&size);
    return buf_len;
}

bool SocketManager::isSocketError() const
{
	int error;
	unsigned int len = sizeof(error);
	int result = BASESOCKET::getsockoptEx(m_SocketID,SOL_SOCKET,SO_ERROR,&error,&len);
	if (result == 0)
		return false;
	else
		return true;
}

bool SocketManager::isNonBlocking() const
{
	return BASESOCKET::getsocketisnonblockEx(m_SocketID);
}

bool SocketManager::setNonBlocking(bool flag /* = true */)
{
	return BASESOCKET::setsocketnonblockEx(m_SocketID,true);
}
 
unsigned int SocketManager::getSocketRecvSize() const
{
	return BASESOCKET::getsocketrecvbufferEx(m_SocketID);
}
