#ifndef __TCP_MANAGER_H__
#define __TCP_MANAGER_H__
#include "RequestStream.h"
#include "ResponseStream.h"
#include "SocketManager.h"
#include <string>
#include <queue>
#include <map>
#include "IProtocolCallBack.h"
#include "ITcpManager.h"
#include "encrypt/aes.h"
using namespace std;

typedef enum _ENUM_EXCUTE_TYPE
{
    EXCUTE_INVALID = -1,
    EXCUTE_CONNECT = 1,
    EXCUTE_CLOSE = 2
} ENUM_EXCUTE_TYPE;

typedef struct _ASYNC_EXCUTE_STRUCT
{
    int excute_type;
    std::string host;
    unsigned int port;
    bool domain;
    bool client_close;
    _ASYNC_EXCUTE_STRUCT()
    {
        excute_type = EXCUTE_INVALID;
        host = "";
        port = 0;
        domain = false;
        client_close = false;
    }
} ASYNC_EXCUTE_STRUCT;

class TcpManager : public ITcpManager
{
public:
	TcpManager();
	virtual ~TcpManager();
    virtual bool Connect(const char *host, unsigned int port, bool domain);
    virtual void Close();
    virtual void Update();
	virtual int SendPack(unsigned short package_id, char* buff, int len);
    virtual void InitCallBack(IProtocolCallBack *callback)
    {
        mp_ProtocolCallBack = callback;
    }
private:
	int RecvPack();
	bool ProcessRequest();
	bool ProcessResponse();
	bool ProcessExcept();
    bool ProcessExcute();
    bool ProcessSocket();
	bool Select();
	SocketManager &getSocketManager(){return m_SocketManager;}
	ResponseStream &getResponseStream(){return m_ReponseStream;}
    void Close_impl(bool flag);
    bool Connect_impl(const char *host, unsigned int port, bool domain);
    unsigned char* EncryptBody(unsigned char* input, unsigned long length);
    unsigned char* EncryptCookie(unsigned char* input, unsigned long length);
protected:

	///服务器信息
	string					m_ServerIp;
	unsigned int			m_ServerPort;

	stru_fd_set				m_ReadFD;
	stru_fd_set				m_WriteFD;
	stru_fd_set				m_ExceptFD;

	SocketManager			m_SocketManager;

	RequestStream			m_RequestStream;

    ResponseStream			m_ReponseStream;
    CriticalSection         m_request_cs;
    CriticalSection         m_excute_cs;
private:
	bool	m_isBigEndian;
    char    *m_RecvBuf;
    int     m_RecvBufLen;
    char    *m_SendBuf;
    int     m_SendBufLen;
    std::queue<ASYNC_EXCUTE_STRUCT> m_excute_queue;
public:
	IProtocolCallBack *mp_ProtocolCallBack;
public:
    
    //网络字序转本机字序(unsigned short)
    inline unsigned short ntohs_ex(unsigned short end_val)
    {
        //小头机不需要转换
        if (false == m_isBigEndian)
        {
            return end_val;
        }
        
        unsigned short bigend_value = 0;
        char *p_b_char = (char *)&bigend_value;
        char *p_l_char = (char *)&end_val;
        int len = sizeof(unsigned short);
        
        for (int i = 0; i < len; i++)
        {
            p_b_char[i] = p_l_char[len - i - 1];
        }
        return bigend_value;
    }
    
    //本机字序转网络字序(WORD)
    inline unsigned short htons_ex(unsigned short host_val)
    {
        if (false == m_isBigEndian)//小头机不需要转换
        {
            return host_val;
        }
        
        unsigned short l_host_val = 0;
        char *p_b_char = (char *)&host_val;
        char *p_l_char = (char *)&l_host_val;
        int len = sizeof(unsigned short);
        
        for (int i = 0; i < len; i++)
        {
            p_l_char[i] = p_b_char[len - i - 1];
        }
        return l_host_val;
    }
    
};

#endif
