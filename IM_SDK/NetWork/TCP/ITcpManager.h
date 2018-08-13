#ifndef ITcpManager_h
#define ITcpManager_h
#include "IProtocolCallBack.h"
//SAFE CREATE TCP
int CreateNetTCP(const char *class_name, void **interface);
class ITcpManager
{
public:
    // $_FUNCTION_BEGIN ******************************
    // NAME:    Connect
    // PARAM:   host,port,domain
    // RETURN:  bool true(success) false(fail)
    // DETAIL:  connect interface if domain host is domain name
    //          else is host ip
    // $_FUNCTION_END ********************************
    virtual bool Connect(const char *host, unsigned int port, bool domain) = 0;
    // $_FUNCTION_BEGIN ******************************
    // NAME：    Close
    // PARAM：   NONE
    // RETURN：  VOID
    // DETAIL：  client close connect initiative
    // $_FUNCTION_END ********************************
    virtual void Close() = 0;
    // $_FUNCTION_BEGIN ******************************
    // NAME：    Update
    // PARAM：   NONE
    // RETURN：  VOID
    // DETAIL：  network process function must excute in loop
    // $_FUNCTION_END ********************************
    virtual void Update() = 0;
    // $_FUNCTION_BEGIN ******************************
    // NAME：    SendPack
    // PARAM：   package_id,buff,len
    // RETURN：  int 1(success) -1(fail)
    // DETAIL：  send buffer function
    // $_FUNCTION_END ********************************
    virtual int SendPack(unsigned short package_id, char* buff, int len) = 0;
    // $_FUNCTION_BEGIN ******************************
    // NAME：    InitCallBack
    // PARAM：   IProtocolCallBack
    // RETURN：  VOID
    // DETAIL：  context communicate function
    // $_FUNCTION_END ********************************
    virtual void InitCallBack(IProtocolCallBack *callback) = 0;
    // $_FUNCTION_BEGIN ******************************
    // NAME：    EncryptBody
    // PARAM：   input, length
    // RETURN：  unsigned char*
    // DETAIL：  encrypt send data
    // $_FUNCTION_END ********************************
    virtual unsigned char* EncryptBody(unsigned char* input, unsigned long length) = 0;
    // $_FUNCTION_BEGIN ******************************
    // NAME：    EncryptCookie
    // PARAM：   input, length
    // RETURN：  unsigned char*
    // DETAIL：  encrypt cookie
    // $_FUNCTION_END ********************************
    virtual unsigned char* EncryptCookie(unsigned char* input, unsigned long length) = 0;
};
#endif /* ITcpManager_h */
