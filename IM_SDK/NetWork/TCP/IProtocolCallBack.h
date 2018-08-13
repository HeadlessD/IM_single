#ifndef __IPROTOCOLCALLBACK_H__
#define __IPROTOCOLCALLBACK_H__
class IProtocolCallBack
{
public:
    // $_FUNCTION_BEGIN ******************************
    // NAME:    OnRecvData
    // PARAM:   packet_id,socket,buffer,buf_len
    // RETURN:  int 1(success) -1(fail)
    // DETAIL:  recv buffer callback
    // $_FUNCTION_END ********************************
    virtual int OnRecvData(unsigned short packet_id, int socket, unsigned char * buffer, unsigned short buf_len) = 0;
    // $_FUNCTION_BEGIN ******************************
    // NAME:    OnError
    // PARAM:   err_type
    // RETURN:  int 1(success) -1(fail)
    // DETAIL:  recv and send error callback
    // $_FUNCTION_END ********************************
    virtual int OnError(uint err_type) = 0;
    // $_FUNCTION_BEGIN ******************************
    // NAME:    OnClose
    // PARAM:   socket,client_closed
    // RETURN:  int 1(success) -1(fail)
    // DETAIL:  server closed connect if client_closed else client close socket
    // $_FUNCTION_END ********************************
    virtual int OnClose(int socket, bool client_closed) = 0;
    // $_FUNCTION_BEGIN ******************************
    // NAME:    OnConnected
    // PARAM:   socket
    // RETURN:  int 1(success) -1(fail)
    // DETAIL:  connect callback as soon as established
    // $_FUNCTION_END ********************************
    virtual int  OnConnected(int socket) = 0;
    // $_FUNCTION_BEGIN ******************************
    // NAME:    OnConnectFailure
    // PARAM:   socket(0)
    // RETURN:  int 1(success) -1(fail)
    // DETAIL:  connect establish failure callback
    // $_FUNCTION_END ********************************
    virtual int OnConnectFailure(int socket) = 0;
};
#endif
