#include "RequestStream.h"

RequestStream::RequestStream(SocketManager* p_SocketMgr)
{
	mp_SocketMgr = p_SocketMgr;
    m_Buffer = nullptr;
    Init();
}

RequestStream::~RequestStream()
{
	if (m_Buffer)
	{
		delete[] m_Buffer;
		m_Buffer = 0;
	}
    
    mp_SocketMgr = nullptr;
}

void RequestStream::Reset()
{
    m_Head = m_Tail = 0;
    memset(m_Buffer, 0, m_BufferLen);
}

unsigned int RequestStream::Write(const char* buffer,unsigned int len)
{
	unsigned int nFree = (m_Head > m_Tail) ? (m_Head-m_Tail-1) : (m_BufferLen-m_Tail+m_Head-1);
	if (len > nFree)
	{
		if (!Resize(len-nFree+1))
		{
			return 0;
		}
	}
	if (m_Head <= m_Tail)
	{
		if(m_Head == 0)
		{
			nFree = m_BufferLen-m_Tail+1;
			memcpy(&m_Buffer[m_Tail],buffer,len);
		}
		else
		{
			nFree = m_BufferLen-m_Tail;
			if (len>nFree)
			{
				memcpy(&m_Buffer[m_Tail],buffer,nFree);
				memcpy(m_Buffer,&buffer[nFree],len-nFree);
			}
			else
			{
				memcpy(&m_Buffer[m_Tail],buffer,len);
			}
		}
	}
	else
	{
		memcpy(&m_Buffer[m_Tail],buffer,len);
	}

	m_Tail = (m_Tail+len)%m_BufferLen;
	return len;
}

unsigned int RequestStream::SendBuffer()
{
	unsigned int liSent = 0;
	unsigned int liLeft = 0;
	unsigned int liSendBufferLen = 0;

	if (m_BufferLen > m_MaxBufferLen)
	{
		//缓存区BUFFER太大
		Init();
		return SOCKET_ERROR-1;
	}
	if (m_Head > m_Tail)
	{
		liLeft = m_BufferLen-m_Head;
		while(liLeft > 0)
		{
			liSent = mp_SocketMgr->Send(&m_Buffer[m_Head],liLeft,0);
			if(liSent == 0)
				return 0;
			if(liSent == SOCKET_ERROR)
				return SOCKET_ERROR-2;
			liSendBufferLen += liSent;
			liLeft -= liSent;
			m_Head += liSent;
		}
		m_Head = 0;
		liLeft = m_Tail;
		while(liLeft > 0)
		{
			liSent = mp_SocketMgr->Send(m_Buffer,liLeft,0);
			if(liSent == 0)
				return 0;
			if(liSent == SOCKET_ERROR)
				return SOCKET_ERROR-3;
			m_Head += liSent;
			liLeft -= liSent;
			liSendBufferLen += liSent;
		}
	}
	else if (m_Head < m_Tail)
	{
		liLeft = m_Tail - m_Head;
		while(liLeft > 0)
		{
			liSent = mp_SocketMgr->Send(&m_Buffer[m_Head],liLeft,0);
			if(liSent == 0)
				return 0;
			if(liSent == SOCKET_ERROR)
				return SOCKET_ERROR-4;
			liLeft -= liSent;
			liSendBufferLen += liSent;
			m_Head += liSent;
		}
	}

	m_Head = 0;
	m_Tail = 0;
	return liSendBufferLen;
}

void RequestStream::Init()
{
	m_Head = m_Tail = 0;
	if (m_Buffer)
	{
		delete[] m_Buffer;
		m_Buffer = 0;
	}

	m_Buffer = new char[DEFAULTREQUESTBUFFERSIZE];
	memset(m_Buffer,0,DEFAULTREQUESTBUFFERSIZE);
    m_BufferLen = DEFAULTREQUESTBUFFERSIZE;
    m_MaxBufferLen = MAXREQUESTBUFFERSIZE;
}

bool RequestStream::Resize(int size)
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
