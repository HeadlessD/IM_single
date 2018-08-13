#ifndef __REQUESTSTREAM_H__
#define __REQUESTSTREAM_H__
#include "SocketManager.h"

//DEFUALT发送缓存长度
#define DEFAULTREQUESTBUFFERSIZE 8192
//最大可以允许的缓存长度
#define MAXREQUESTBUFFERSIZE 1024*1024

class RequestStream
{
public:
	RequestStream(SocketManager* p_SocketMgr);
	virtual ~RequestStream();

	unsigned int	Write(const char* buffer,unsigned int len);

	unsigned int	SendBuffer();

	void    Init();
    void    Reset();
    
	bool	Resize(int size);

	int     GetCapacity()const {return m_BufferLen;}

	unsigned int	GetLength() const{return m_Head <= m_Tail ? m_Tail-m_Head : m_BufferLen-m_Head+m_Tail;}

	char*	GetBuffer() const{return m_Buffer;}
	bool	isEmpty()const {return m_Head == m_Tail;}
	unsigned int GetBufferLen() const{return m_BufferLen;}
protected:
	SocketManager*	mp_SocketMgr;
	char*		m_Buffer;
	unsigned int		m_BufferLen;
	unsigned int		m_MaxBufferLen;

	unsigned int		m_Head;
	unsigned int		m_Tail;
private:
};
#endif
