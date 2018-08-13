#include "TcpManager.h"

// $_FUNCTION_BEGIN ******************************
// NAME:     CreateNetTCP
// PARAM:    class_name, interface
// RETURN:   int 1(sucess) -1(fail) void** interface
// DETAIL:   safe create class TcpManager
//           DLLEXPORT used for lib future
// $_FUNCTION_END ********************************
///////////////////////////////////////////////////////////////////////
//DLLEXPORT
int CreateNetTCP(const char* class_name, void** interface)
{
    if(nullptr == class_name)
        return -1;
    
    if(nullptr == interface)
        return -1;
    
    ITcpManager *i_tcp_manager = NULL;
    if (strcmp(class_name, "TcpManager") == 0)
    {
        i_tcp_manager = new TcpManager();
        if (i_tcp_manager)
        {
            *interface = i_tcp_manager;
            return 1;
        }
        return 1;
    }
    
    return -2;
}

