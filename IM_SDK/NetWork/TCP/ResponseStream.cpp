#include "ResponseStream.h"

ResponseStream::ResponseStream(SocketManager* p_SocketMgr)
{
	mp_SocketMgr = p_SocketMgr;
    m_Buffer = nullptr;
    Init();
}

ResponseStream::~ResponseStream()
{
	m_Head = m_Tail = 0;
	if (m_Buffer)
	{
		delete[] m_Buffer;
		m_Buffer = 0;
	}
    
    mp_SocketMgr = nullptr;
}

void ResponseStream::Init()
{
    m_Head = m_Tail = 0;
    if (m_Buffer)
    {
        delete[] m_Buffer;
        m_Buffer = 0;
    }
    m_Buffer = new char[DEFAULTRESPONSEBUFFERSIZE];
    memset(m_Buffer,0,DEFAULTRESPONSEBUFFERSIZE);
    m_BufferLen = DEFAULTRESPONSEBUFFERSIZE;
    m_MaxBufferLen = MAXRESPONSEBUFFERSIZE;
}

void ResponseStream::Reset()
{
    m_Head = m_Tail = 0;
    memset(m_Buffer, 0, m_BufferLen);
}

unsigned int ResponseStream::Read(char* buffer,unsigned int len)
{
	if(len == 0 || len > GetLength())
		return 0;
	if (m_Head < m_Tail)
	{
		memcpy(buffer,&m_Buffer[m_Head],len);
	}
	else if(m_Head > m_Tail)
	{
		if(len <= m_BufferLen-m_Head)
		{
			memcpy(buffer,&m_Buffer[m_Head],len);
		}
		else
		{
			memcpy(buffer,&m_Buffer[m_Head], m_BufferLen-m_Head);
			memcpy(&buffer[m_BufferLen-m_Head],m_Buffer,len-m_BufferLen+m_Head);
		}
	}
	else
	{
		return 0;
	}
	m_Head = (m_Head+len)%m_BufferLen;
	return len;
}

unsigned int ResponseStream::RecvBuffer()
{
	unsigned int liRecvBuffer = 0;
	unsigned int liReceived = 0;
	unsigned int liFree= 0;

	if (m_Head <= m_Tail)
	{
		if (m_Head == 0)
		{
			liReceived = 0;
			liFree = m_BufferLen - m_Tail - 1;
			if(liFree > 0)
			{
				liReceived = mp_SocketMgr->Receive(&m_Buffer[m_Tail],liFree);
				if(liReceived == SOCKET_ERROR)
					return SOCKET_ERROR-1;
				if(liReceived == 0)
					return SOCKET_ERROR-2;

				m_Tail+=liReceived;
				liRecvBuffer+=liReceived;
			}

			if(liFree <= 0 || liReceived == liFree)
			{
				unsigned int socketRecvBuffer = mp_SocketMgr->getSocketRecvSize();
				if (socketRecvBuffer > 0)
				{
					if ((m_BufferLen+socketRecvBuffer+1) > m_MaxBufferLen)
					{
						Init();
						return SOCKET_ERROR-3;
					}
					if (!Resize(socketRecvBuffer+1))
					{
						return 0;
					}

					liReceived = mp_SocketMgr->Receive(&m_Buffer[m_Tail],socketRecvBuffer);
					if(liReceived == SOCKET_ERROR)
						return SOCKET_ERROR-4;
					if(liReceived == 0)
						return SOCKET_ERROR-5;
					m_Tail += liReceived;
					liRecvBuffer += liReceived;
				}
			}
		}
		else
		{
			liFree = m_BufferLen - m_Tail;
			liReceived = mp_SocketMgr->Receive(&m_Buffer[m_Tail],liFree);
			if(liReceived == SOCKET_ERROR)
				return SOCKET_ERROR-6;
			if (liReceived == 0)
				return SOCKET_ERROR-7;
			m_Tail = (m_Tail+liReceived)%m_BufferLen;
			liRecvBuffer += liReceived;

			if(liReceived == liFree)
			{
				liReceived = 0;
				liFree = m_Head - 1;
				if(liFree > 0)
				{
					liReceived = mp_SocketMgr->Receive(m_Buffer,liFree);
					if(liReceived == SOCKET_ERROR)
						 return SOCKET_ERROR-8;
					if(liReceived == 0)
						return SOCKET_ERROR-9;

					m_Tail+=liReceived;
					liRecvBuffer += liReceived;
				}

				if(liReceived == liFree)
				{
					unsigned int socketRecvBuffer = mp_SocketMgr->getSocketRecvSize();
					if (socketRecvBuffer > 0)
					{
						if ((m_BufferLen+socketRecvBuffer+1) > m_MaxBufferLen)
						{
							Init();
							return SOCKET_ERROR-10;
						}
						if (!Resize(socketRecvBuffer+1))
						{
							return 0;
						}

						liReceived = mp_SocketMgr->Receive(&m_Buffer[m_Tail],socketRecvBuffer);
						if(liReceived == SOCKET_ERROR)
							return SOCKET_ERROR-11;
						if(liReceived == 0)
							return SOCKET_ERROR-12;
						m_Tail += liReceived;
						liRecvBuffer += liReceived;
					}
				}
			}
		}
	}
	else
	{
		liReceived = 0;
		liFree = m_Head-m_Tail-1;
		if(liFree > 0)
		{
			liReceived = mp_SocketMgr->Receive(&m_Buffer[m_Tail],liFree);
			if(liReceived == SOCKET_ERROR)
				 return SOCKET_ERROR-13;
			if(liReceived == 0)
				return SOCKET_ERROR-14;
			m_Tail += liReceived;
			liRecvBuffer += liReceived;
		}
		if(liFree <= 0 || liFree == liReceived)
		{
			unsigned int socketRecvBuffer = mp_SocketMgr->getSocketRecvSize();
			if (socketRecvBuffer > 0)
			{
				if ((m_BufferLen+socketRecvBuffer+1) > m_MaxBufferLen)
				{
					Init();
					return SOCKET_ERROR-15;
				}
				if (!Resize(socketRecvBuffer+1))
				{
					return 0;
				}

				liReceived = mp_SocketMgr->Receive(&m_Buffer[m_Tail],socketRecvBuffer);
				if(liReceived == SOCKET_ERROR)
					return SOCKET_ERROR-16;
				if(liReceived == 0)
					return SOCKET_ERROR-17;
				m_Tail += liReceived;
				liRecvBuffer += liReceived;
			}
		}
	}
	return liRecvBuffer;
}

bool ResponseStream::Resize(int size)
{
	if(size < 0)
		return false;
	size = size > (m_BufferLen >> 1) ? size:(m_BufferLen >> 1);
	unsigned int newBufferLen = m_BufferLen+size;
	unsigned int len = GetLength();
	if(len > newBufferLen)
		return false;
	char* newBuffer = new char[newBufferLen];
	memset(newBuffer,0,newBufferLen);

	if (m_Head < m_Tail)
	{
		memcpy(newBuffer,&m_Buffer[m_Head],len);
	}
	else
	{
		memcpy(newBuffer,&m_Buffer[m_Head],m_BufferLen-m_Head);
		memcpy(&newBuffer[m_BufferLen-m_Head],m_Buffer,m_Tail);
	}
	delete[] m_Buffer;
	m_Buffer = newBuffer;
	m_BufferLen = newBufferLen;
	m_Head = 0;
	m_Tail = len;
	return true;
}

int ResponseStream::GetHeadInfo(char* buffer)
{
	if (PACKET_HEADER_SIZE >= GetLength())
	{
		return -1;
	}

	if (m_Head < m_Tail)
	{
		memcpy(buffer,&m_Buffer[m_Head],PACKET_HEADER_SIZE);
	}
	else
	{
		if (m_BufferLen-m_Head >= PACKET_HEADER_SIZE)
		{
			memcpy(buffer,&m_Buffer[m_Head],PACKET_HEADER_SIZE);
		}
		else
		{
			memcpy(buffer,&m_Buffer[m_Head],m_BufferLen-m_Head);
			memcpy(&buffer[m_BufferLen-m_Head],m_Buffer,PACKET_HEADER_SIZE-m_BufferLen+m_Head);
		}
	}
	return 0;
}

bool ResponseStream::Seek(unsigned int len)
{
	if(len == 0 || len > GetLength())
		return false;
	m_Head = (m_Head + len) % m_BufferLen;
	return true;
}
