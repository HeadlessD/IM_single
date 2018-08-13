#ifndef __RESPONSE_STREAM_H__
#define __RESPONSE_STREAM_H__
#include "SocketManager.h"

//DEFUALT缓存长度
#define DEFAULTRESPONSEBUFFERSIZE 8192
//最大可以允许的缓存长度
#define MAXRESPONSEBUFFERSIZE 1024*1024

#define PACKET_HEADER_SIZE sizeof(unsigned short)
#define PACKET_TYPE_SIZE sizeof(unsigned short)

class ResponseStream
{
public:
	ResponseStream(SocketManager* p_SocketMgr);
	virtual ~ResponseStream();

	unsigned int Read(char* buffer,unsigned int len);

	//不移动指针
	int		GetHeadInfo(char* buffer);

	unsigned int	RecvBuffer();

	void    Init();
    void    Reset();
    
	bool	Seek(unsigned int len);

	bool	Resize(int size);

	int     GetCapacity()const {return m_BufferLen;}

	unsigned int	GetLength() const{return m_Head <= m_Tail ? m_Tail-m_Head : m_BufferLen-m_Head+m_Tail;}

	char*	GetBuffer() const{return m_Buffer;}
	bool	isEmpty()const {return m_Head == m_Tail;}
	unsigned int GetBufferLen() const{return m_BufferLen;}
	unsigned int    GetHead(){return m_Head;}
	unsigned int    GetTail(){return m_Tail;}

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
