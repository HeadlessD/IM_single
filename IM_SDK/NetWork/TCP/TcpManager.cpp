#include "TcpManager.h"



TcpManager::TcpManager() : m_SocketManager(),
    m_RequestStream(&m_SocketManager),
	m_ReponseStream(&m_SocketManager)
{
	m_isBigEndian = false;
	unsigned short s = 0x1234;
	unsigned char* buff = (unsigned char*)&s;
	if (*buff == 0x12)
	{
		m_isBigEndian = true;
	}
    
    m_RecvBuf = new char[DEFAULTRESPONSEBUFFERSIZE];
    m_RecvBufLen = DEFAULTRESPONSEBUFFERSIZE;
    memset(m_RecvBuf, 0, m_RecvBufLen);
    
    m_SendBuf = new char[DEFAULTREQUESTBUFFERSIZE];
    m_SendBufLen = DEFAULTREQUESTBUFFERSIZE;
    memset(m_SendBuf, 0, m_SendBufLen);
    mp_ProtocolCallBack = NULL;
}

TcpManager::~TcpManager()
{
    if(m_RecvBuf)
    {
        delete []m_RecvBuf;
        m_RecvBuf = nullptr;
    }
    m_RecvBufLen = 0;
    
    if(m_SendBuf)
    {
        delete []m_SendBuf;
        m_SendBuf = nullptr;
    }
    m_SendBufLen = 0;
}

bool TcpManager::Select()
{
    int socket = m_SocketManager.getSocket();
    if(socket == INVALID_SOCKET)
    {
        return false;
    }
    
	FD_ZERO( &m_ReadFD ) ;
	FD_ZERO( &m_WriteFD ) ;
	FD_ZERO( &m_ExceptFD ) ;

	FD_SET( socket, &m_ReadFD ) ;
	FD_SET( socket, &m_WriteFD ) ;
	FD_SET( socket, &m_ExceptFD ) ;

	int maxfd = 0;
	maxfd = socket + 1;
	struct timeval Timeout;
	Timeout.tv_sec = 0 ;
	Timeout.tv_usec = 0 ;

	if(SOCKET_ERROR == BASESOCKET::selectEx(maxfd , 
		&m_ReadFD , 
		&m_WriteFD , 
		&m_ExceptFD , 
		&Timeout ) )
	{
		return false;
	}
	return true;
}

bool TcpManager::Connect(const char *host,unsigned int port, bool domain)
{
    ASYNC_EXCUTE_STRUCT async_excute_stru;
    async_excute_stru.excute_type = EXCUTE_CONNECT;
    async_excute_stru.host = host;
    async_excute_stru.port = port;
    async_excute_stru.domain = domain;
    m_excute_cs.Enter();
    m_excute_queue.push(async_excute_stru);
    m_excute_cs.Leave();
	return true;
}

bool TcpManager::Connect_impl(const char *host,unsigned int port, bool domain)
{
    if (!m_SocketManager.Connect(host, port, domain))
    {
        Close_impl(false);
        if(mp_ProtocolCallBack)
        {
            mp_ProtocolCallBack->OnConnectFailure(0);
        }
        return false;
    }
    
    m_SocketManager.setNonBlocking();
    m_SocketManager.setLinger(0);
    //kernel send buffer 256kb
    m_SocketManager.setSendBufferLen(1024 * 256);
    //kernel recv buffer 256kb
    m_SocketManager.setRecvBufferLen(1024 * 256);
    if(mp_ProtocolCallBack)
    {
        mp_ProtocolCallBack->OnConnected(m_SocketManager.getSocket());
    }
    return true;
}

int TcpManager::SendPack(unsigned short package_id, char* buff, int len)
{
	if(m_SocketManager.getSocket() == INVALID_SOCKET)
		return -1;

    unsigned short pack_len = len + PACKET_TYPE_SIZE + PACKET_HEADER_SIZE;
    if(pack_len > m_SendBufLen)
    {
        //too big
        if(m_SendBuf)
        {
            delete []m_SendBuf;
            m_SendBuf = nullptr;
        }
        
        m_SendBufLen = pack_len + 1;
        m_SendBuf = new char[m_SendBufLen];
    }
    
    pack_len = htons_ex(pack_len);
    package_id = htons_ex(package_id);
    memset(m_SendBuf, 0, m_SendBufLen);
    memcpy(m_SendBuf, &pack_len, PACKET_HEADER_SIZE);
    memcpy(&m_SendBuf[PACKET_HEADER_SIZE], &package_id, PACKET_TYPE_SIZE);
    if(buff && len > 0)
    {
        memcpy(&m_SendBuf[PACKET_HEADER_SIZE + PACKET_TYPE_SIZE], buff, len);
    }
    int ret = 0;
    m_request_cs.Enter();
	ret = m_RequestStream.Write(m_SendBuf, pack_len);
    m_request_cs.Leave();
	return ret;
}

int TcpManager::RecvPack()
{
	if(m_SocketManager.getSocket() == INVALID_SOCKET)
		return -1;


	if(m_ReponseStream.isEmpty() || m_ReponseStream.GetLength() <= PACKET_HEADER_SIZE)
    {
		return -1;
    }
	char lsPackLen[PACKET_HEADER_SIZE+1] = {0};

	if(m_ReponseStream.GetHeadInfo(lsPackLen) == -1)
    {
        return -1;
    }

	unsigned short liPackLen;
	memcpy(&liPackLen, lsPackLen, PACKET_HEADER_SIZE);
	liPackLen = ntohs_ex(liPackLen);
    //先检测包长度够不够
    if(liPackLen == 0 || liPackLen > m_ReponseStream.GetLength())
    {
        return 0;
    }
    
    liPackLen -= PACKET_HEADER_SIZE;
    if(liPackLen > m_RecvBufLen)
    {
        //too big
        if(m_RecvBuf)
        {
            delete []m_RecvBuf;
            m_RecvBuf = nullptr;
        }
        
        m_RecvBufLen = liPackLen + 1;
        m_RecvBuf = new char[m_RecvBufLen];
    }
    
    memset(m_RecvBuf, 0, m_RecvBufLen);
    
    m_ReponseStream.Seek(PACKET_HEADER_SIZE);
    m_ReponseStream.Read(m_RecvBuf, liPackLen);
    
    unsigned short liPackType;
    memcpy(&liPackType, m_RecvBuf, PACKET_TYPE_SIZE);
    liPackType = ntohs_ex(liPackType);
    liPackLen -= PACKET_TYPE_SIZE;
    if(mp_ProtocolCallBack)
    {
        mp_ProtocolCallBack->OnRecvData(liPackType, m_SocketManager.getSocket(),
                                        (unsigned char*)&m_RecvBuf[PACKET_TYPE_SIZE], liPackLen);
    }

	return 1;
}

void TcpManager::Close()
{
    ASYNC_EXCUTE_STRUCT async_excute_stru;
    async_excute_stru.excute_type = EXCUTE_CLOSE;
    async_excute_stru.client_close = true;
    m_excute_cs.Enter();
    m_excute_queue.push(async_excute_stru);
    m_excute_cs.Leave();
}

void TcpManager::Close_impl(bool flag)
{
    int socket = m_SocketManager.getSocket();
    m_SocketManager.Close();
    if(mp_ProtocolCallBack)
    {
        mp_ProtocolCallBack->OnClose(socket, flag);
    }
    m_RequestStream.Reset();
    m_ReponseStream.Reset();
}

bool TcpManager::ProcessRequest()
{
    int socket = m_SocketManager.getSocket();
    if(socket == INVALID_SOCKET)
    {
        return false;
    }
	if( FD_ISSET( socket, &m_WriteFD ) )
	{
        m_request_cs.Enter();
		unsigned int ret = m_RequestStream.SendBuffer();
        m_request_cs.Leave();
        if(ret == 0)
        {
            return false;
        }
        
        if( (int)ret <= SOCKET_ERROR )
        {
            Close_impl(false);
            if(mp_ProtocolCallBack)
            {
                mp_ProtocolCallBack->OnError(ret);
            }
            return false;
        }
        
        return true;
	}
    
	return false;
}

bool TcpManager::ProcessResponse()
{
    int socket = m_SocketManager.getSocket();
    if(socket == INVALID_SOCKET)
    {
        return false;
    }
	if( FD_ISSET( socket, &m_ReadFD ) )
	{
		unsigned int ret = m_ReponseStream.RecvBuffer();
        
		if( (int)ret <= SOCKET_ERROR )
		{
			Close_impl(false);
            if(mp_ProtocolCallBack)
            {
                mp_ProtocolCallBack->OnError(ret);
            }
			return false;
		}
        
        return true;
	}
    
	return false;
}

bool TcpManager::ProcessExcept()
{
    int socket = m_SocketManager.getSocket();
    if(socket == INVALID_SOCKET)
    {
        return false;
    }
	if( FD_ISSET(socket, &m_ExceptFD ) )
	{
		Close_impl(false);
        if(mp_ProtocolCallBack)
        {
            mp_ProtocolCallBack->OnError(SOCKET_ERROR);
        }
		return false;
	}
	return true;
}

bool TcpManager::ProcessExcute()
{
    bool need_sleep = true;
    if(m_excute_queue.empty())
    {
        return need_sleep;
    }
    
    m_excute_cs.Enter();
    ASYNC_EXCUTE_STRUCT aes = m_excute_queue.front();
    m_excute_queue.pop();
    m_excute_cs.Leave();
    switch (aes.excute_type)
    {
        case EXCUTE_CONNECT:
            {
                Connect_impl(aes.host.c_str(), aes.port, aes.domain);
            }
            break;
        case EXCUTE_CLOSE:
            {
                Close_impl(aes.client_close);
            }
            break;
        default:
            break;
    }
    
    need_sleep = false;
    return need_sleep;
}

bool TcpManager::ProcessSocket()
{
    bool need_sleep = true;
    int socket = m_SocketManager.getSocket();
    if(socket == INVALID_SOCKET)
    {
        return need_sleep;
    }
    
    if(RecvPack() > 0)
    {
        need_sleep = false;
    }
    
    if(!Select())
    {
        return need_sleep;
    }
    
    if(!ProcessExcept())
    {
        need_sleep = true;

        return need_sleep;
    }
    
    if(ProcessResponse())
    {
        need_sleep = false;
    }
    
    if(ProcessRequest())
    {
        need_sleep = false;
    }
    
    return need_sleep;
}

void TcpManager::Update()
{
    bool need_sleep1 = ProcessExcute();
    bool need_sleep2 = ProcessSocket();
    if(need_sleep1 && need_sleep2)
    {
        //10ms
        usleep(10 * 1000);
        return;
    }
}


unsigned char* TcpManager::EncryptBody(unsigned char* input, unsigned long length)
{
    unsigned char key[] = "qianwang2017body";
    AES aes(key);
    aes.Cipher(input, length);
    return input;
}

unsigned char* TcpManager::EncryptCookie(unsigned char* input, unsigned long length)
{
    unsigned char key[] = "qianwang2017cook";
    AES aes(key);
    aes.Cipher(input, length);
    return input;

}
