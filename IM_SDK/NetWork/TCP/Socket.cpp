#include "Socket.h"

//extern int errno;

SOCKET BASESOCKET::socketEx(int domain, int type, int protocol)
{
	SOCKET s = ::socket(domain,type	,protocol);
	if (s == INVALID_SOCKET)
	{
#ifndef WIN32
		switch ( errno ) 
		{
		case EPROTONOSUPPORT :
		case EMFILE : 
		case ENFILE : 
		case EACCES : 
		case ENOBUFS : 
		default : 
			{
				break;
			}
		}
#else
		int iErr = WSAGetLastError();
		switch ( iErr ) 
		{
		case WSANOTINITIALISED : 
		case WSAENETDOWN : 
		case WSAEAFNOSUPPORT : 
		case WSAEINPROGRESS : 
		case WSAEMFILE : 
		case WSAENOBUFS :  ;
		case WSAEPROTONOSUPPORT : 
		case WSAEPROTOTYPE : 
		case WSAESOCKTNOSUPPORT : 
		default : 
			{
				break ;
			};
		};
#endif
	}
	return s;
}

bool BASESOCKET::bindEx(SOCKET s, const struct sockaddr* name, unsigned int namelen)
{
	if (bind(s,name,namelen) == SOCKET_ERROR)
	{
#ifndef WIN32
		switch ( errno ) 
		{
		case EADDRINUSE :
		case EINVAL : 
		case EACCES : 
		case ENOTSOCK : 
		case EBADF : 
		case EROFS : 
		case EFAULT : 
		case ENAMETOOLONG : 
		case ENOENT : 
		case ENOMEM : 
		case ENOTDIR : 
		case ELOOP : 
		default :
			{
				break;
			}
		}
#else
		int iErr = WSAGetLastError();
		switch ( iErr ) 
		{
		case WSANOTINITIALISED : 
		case WSAENETDOWN : 
		case WSAEADDRINUSE : 
		case WSAEADDRNOTAVAIL : 
		case WSAEFAULT : 
		case WSAEINPROGRESS : 
		case WSAEINVAL : 
		case WSAENOBUFS : 
		case WSAENOTSOCK : 
		default :
			{
			};
		};
#endif
		return false;
	}

	return true;
}

bool BASESOCKET::connectEx(SOCKET s, const struct sockaddr* name, unsigned int namelen)
{
	if (connect(s,name,namelen) == SOCKET_ERROR)
	{
#ifndef WIN32
		switch ( errno ) {
		case EALREADY : 
		case EINPROGRESS : 
		case ECONNREFUSED : 
		case EISCONN : 
		case ETIMEDOUT : 
		case ENETUNREACH : 
		case EADDRINUSE : 
		case EBADF : 
		case EFAULT : 
		case ENOTSOCK : 
		default :
			{
				break;
			}
		}
#else
		int iErr = WSAGetLastError();
		switch ( iErr ) 
		{
		case WSANOTINITIALISED : 
		case WSAENETDOWN : 
		case WSAEADDRINUSE : 
		case WSAEINTR : 
		case WSAEINPROGRESS : 
		case WSAEALREADY : 
		case WSAEADDRNOTAVAIL : 
		case WSAEAFNOSUPPORT : 
		case WSAECONNREFUSED : 
		case WSAEFAULT : 
		case WSAEINVAL : 
		case WSAEISCONN : 
		case WSAENETUNREACH : 
		case WSAENOBUFS : 
		case WSAENOTSOCK : 
		case WSAETIMEDOUT : 
		case WSAEWOULDBLOCK  : 
		default :
			{
				break ;
			};
		};
#endif
		return false;
	}

	return true;
}

bool BASESOCKET::listenEx(SOCKET s, unsigned int backlog)
{
	if (listen(s,backlog) == SOCKET_ERROR)
	{
#ifndef WIN32
		switch ( errno ) 
		{
		case EBADF : 
		case ENOTSOCK :
		case EOPNOTSUPP :
		default :
			{
				break;
			}
		}
#else
		int iErr = WSAGetLastError() ;
		switch ( iErr ) 
		{
		case WSANOTINITIALISED : 
		case WSAENETDOWN : 
		case WSAEADDRINUSE : 
		case WSAEINPROGRESS : 
		case WSAEINVAL : 
		case WSAEISCONN : 
		case WSAEMFILE : 
		case WSAENOBUFS : 
		case WSAENOTSOCK : 
		case WSAEOPNOTSUPP : 
		default :
			{
				break ;
			};
		};
#endif
		return false;
	}
	return true;
}

SOCKET BASESOCKET::acceptEx(SOCKET s, struct sockaddr* addr, unsigned int* addrlen)
{
#ifndef WIN32
	SOCKET client = accept(s,addr,addrlen);
#else
	SOCKET client = accept(s,addr,(int*)addrlen);
#endif

	if (client == INVALID_SOCKET)
	{
#ifndef WIN32
		switch ( errno ) 
		{

		case EWOULDBLOCK : 

		case ECONNRESET :
		case ECONNABORTED :
		case EPROTO :
		case EINTR :

		case EBADF : 
		case ENOTSOCK : 
		case EOPNOTSUPP : 
		case EFAULT : 

		default :
			{
				break;
			}
		}
#else
		int iErr = WSAGetLastError() ;
		switch ( iErr ) 
		{
		case WSANOTINITIALISED : 
		case WSAENETDOWN : 
		case WSAEFAULT : 
		case WSAEINTR : 
		case WSAEINPROGRESS : 
		case WSAEINVAL : 
		case WSAEMFILE : 
		case WSAENOBUFS : 
		case WSAENOTSOCK : 
		case WSAEOPNOTSUPP : 
		case WSAEWOULDBLOCK : 
		default :
			{
				break ;
			};
		};
#endif
	}
	return client;
}

unsigned int BASESOCKET::getsockoptEx(SOCKET s, int level, int optname, void* optval, unsigned int* optlen)
{
#ifndef WIN32
	int Ret = getsockopt(s,level,optname,optval,optlen);
#else
	int Ret = getsockopt(s,level,optname, (char*)optval , (int*)optlen );
#endif

	if (Ret == SOCKET_ERROR)
	{
#ifndef WIN32
		switch ( errno ) 
		{
		case EBADF : 
			return 1;
		case ENOTSOCK : 
			return 2;
		case ENOPROTOOPT : 
			return 3;
		case EFAULT : 
			return 4;
		default :
			return 5;
		}
#else
		int iErr = WSAGetLastError() ;
		switch ( iErr ) 
		{
		case WSANOTINITIALISED:
			return 1;
		case WSAENETDOWN:
			return 2;
		case WSAEFAULT:
			return 3;
		case WSAEINPROGRESS:
			return 4;
		case WSAEINVAL:
			return 5;
		case WSAENOPROTOOPT:
			return 6;
		case WSAENOTSOCK:
			return 7;
		default : 
			{
				return 8;
			};
		}
#endif
	}
	return 0;
}

bool BASESOCKET::setsockoptEx(SOCKET s, int level, int optname, const void* optval, unsigned int optlen)
{
#ifndef WIN32
	int Ret = setsockopt(s,level,optname,optval,optlen);
#else
	int Ret = setsockopt(s,level,optname, (char*)optval , optlen );
#endif

	if (Ret == SOCKET_ERROR)
	{
#ifndef WIN32
		switch ( errno ) 
		{
		case EBADF : 
		case ENOTSOCK : 
		case ENOPROTOOPT : 
		case EFAULT : 
		default :
			{
				break;
			}
		}
		return false ;
#else
		int iErr = WSAGetLastError() ;
		switch ( iErr ) 
		{
		case WSANOTINITIALISED : 
		case WSAENETDOWN : 
		case WSAEFAULT : 
		case WSAEINPROGRESS : 
		case WSAEINVAL : 
		case WSAENETRESET : 
		case WSAENOPROTOOPT : 
		case WSAENOTCONN : 
		case WSAENOTSOCK : 
		default :
			{
				break;
			};
		};
		return false ;
#endif
	}
	return true;
}

unsigned int BASESOCKET::sendEx(SOCKET s, const void* buf, unsigned int len, unsigned int flags)
{
	int liSent = 0;
#ifndef WIN32
	liSent = (int)send(s,buf,len,flags);
#else
	liSent = send(s,(const CHAR *)buf,len,flags);
#endif

	if (liSent == SOCKET_ERROR)
	{
#ifndef WIN32
		switch ( errno ) 
		{

		case EWOULDBLOCK : 


		case ECONNRESET :
		case EPIPE :
		case EBADF : 
		case ENOTSOCK : 
		case EFAULT : 
		case EMSGSIZE : 
		case ENOBUFS : 
		default : 
			{
				break;
			}
		}
#else
		int iErr = WSAGetLastError() ;
		switch ( iErr ) 
		{
		case WSANOTINITIALISED : 
		case WSAENETDOWN : 
		case WSAEACCES : 
		case WSAEINTR : 
		case WSAEINPROGRESS : 
		case WSAEFAULT : 
		case WSAENETRESET : 
		case WSAENOBUFS : 
		case WSAENOTCONN : 
		case WSAENOTSOCK : 
		case WSAEOPNOTSUPP : 
		case WSAESHUTDOWN : 
		case WSAEWOULDBLOCK : 


		case WSAEMSGSIZE : ;
		case WSAEHOSTUNREACH : 
		case WSAEINVAL : 
		case WSAECONNABORTED : 
		case WSAECONNRESET : 
		case WSAETIMEDOUT : 
		default :
			{
				break ;
			};
		};
#endif
	}

	return liSent;
}

unsigned int BASESOCKET::sendtoEx(SOCKET s, const void* buf, int len, unsigned int flags, const struct sockaddr* to, int tolen)
{
	int liSent;
#ifndef WIN32
	liSent = (int)sendto(s,buf,len,flags,to,tolen);
#else
	liSent = sendto(s,(const CHAR *)buf,len,flags,to,tolen);
#endif

	if (liSent == SOCKET_ERROR)
	{
#ifndef WIN32
		switch ( errno ) 
		{

		case EWOULDBLOCK : 
			
		case ECONNRESET :
		case EPIPE :

		case EBADF : 
		case ENOTSOCK : 
		case EFAULT : 
		case EMSGSIZE : 
		case ENOBUFS : 

		default : 
			{
				break;
			}
		}	
#else
		int iErr = WSAGetLastError() ;
		//switch ( iErr ) 
		//{
		//default :
		//	{
		//		break ;
		//	};
		//};
#endif
	}
	return liSent;
}

unsigned int BASESOCKET::recvEx(SOCKET s, void* buf, unsigned int len, unsigned int flags)
{
	int liRecv = 0;
#ifndef WIN32
	liRecv = (int)recv(s,buf,len,flags);
#else
	liRecv = recv(s,(CHAR*)buf,len,flags);
#endif

	if (liRecv == SOCKET_ERROR)
	{
#ifndef WIN32
		switch ( errno ) 
		{

		case EWOULDBLOCK : 
		case ECONNRESET :
		case EPIPE :

		case EBADF : 
		case ENOTCONN : 
		case ENOTSOCK : 
		case EINTR : 
		case EFAULT : 

		default : 
			{
				break;
			}
		}

#else
		int iErr = WSAGetLastError() ;
		switch ( iErr ) 
		{
		case WSANOTINITIALISED : 
		case WSAENETDOWN : 
		case WSAEFAULT : 
		case WSAENOTCONN : 
		case WSAEINTR : 
		case WSAEINPROGRESS : 
		case WSAENETRESET : 
		case WSAENOTSOCK : 
		case WSAEOPNOTSUPP : 
		case WSAESHUTDOWN : 

		case WSAEWOULDBLOCK : 

			break ;
		case WSAEMSGSIZE : 
		case WSAEINVAL : 
		case WSAECONNABORTED : 
		case WSAETIMEDOUT : 
		case WSAECONNRESET : 
		default :
			{
				break ;
			};
		};
#endif
	}
	return liRecv;
}

unsigned int BASESOCKET::recvfromEx(SOCKET s, void* buf, int len, unsigned int flags, struct sockaddr* from, unsigned int* fromlen)
{
	int liReceived = 0;
#ifndef WIN32
	liReceived = (int)recvfrom(s,buf,len,flags,from,fromlen);

#else
	liReceived = recvfrom(s,(CHAR*)buf,len,flags,from,(int*)fromlen);
#endif

	if ( liReceived == SOCKET_ERROR ) 
	{
#ifndef WIN32
		switch ( errno ) 
		{

		case EWOULDBLOCK : 


		case ECONNRESET :
		case EPIPE :
		case EBADF : 
		case ENOTCONN : 
		case ENOTSOCK : 
		case EINTR : 
		case EFAULT : 

		default : 
			{
				break;
			}
		}
#else
#endif
	}

	return liReceived;
}

bool BASESOCKET::closesocketEx(SOCKET s)
{
#ifndef WIN32
//	close(s);
    shutdownEx(s, SHUT_RDWR);
#else
	closesocket(s);
#endif
	return true;
}

bool BASESOCKET::ioctlsocketEx(SOCKET s, long cmd, unsigned long* argp)
{
#ifndef WIN32
#else
	if ( ioctlsocket(s,cmd,argp) == SOCKET_ERROR ) 
	{
		int iErr = WSAGetLastError() ;
		switch ( iErr ) 
		{
		case WSANOTINITIALISED : 
		case WSAENETDOWN : 
		case WSAEINPROGRESS : 
		case WSAENOTSOCK : 
		case WSAEFAULT : 
		default :
			{
				break ;
			};
		};
		return false ;
	}
#endif
	return true;
}

bool BASESOCKET::shutdownEx(SOCKET s, unsigned int how)
{
	if ( shutdown(s,how) < 0 ) 
	{
#ifndef WIN32
		switch ( errno ) {
		case EBADF : 
		case ENOTSOCK : 
		case ENOTCONN : 
		default : 
			{
				break;
			}
		}
#else
		int iErr = WSAGetLastError() ;
		switch ( iErr ) 
		{
		case WSANOTINITIALISED : 
		case WSAENETDOWN :
		case WSAEINVAL : 
		case WSAEINPROGRESS : 
		case WSAENOTCONN : 
		case WSAENOTSOCK : 
		default :
			{
				break ;
			};
		};
#endif
		return false;
	}
	return true;
}

int	BASESOCKET::selectEx(int maxfdp1, fd_set* readset, fd_set* writeset, fd_set* exceptset, struct timeval* timeout)
{
	int result;
	result = select(maxfdp1,readset,writeset,exceptset,timeout);
	if (result == SOCKET_ERROR)
	{
#ifndef WIN32
#else
		int iErr = WSAGetLastError() ;
		switch ( iErr ) 
		{
		case WSANOTINITIALISED : 
		case WSAEFAULT:
		case WSAENETDOWN:
		case WSAEINVAL:
		case WSAEINTR:
		case WSAEINPROGRESS:
		case WSAENOTSOCK:
		default :
			{
				break ;
			};
		};
#endif
	}
	return result;
}

bool BASESOCKET::setsocketnonblockEx(SOCKET s,bool on)
{
#ifndef WIN32
	int flags = fcntl(s,F_GETFL,0);
	if (on)
	{
		//nonblocking
		flags |= O_NONBLOCK;
	}
	else
	{
		//blocking
		flags &= ~O_NONBLOCK;
	}
	fcntl(s,F_GETFL,flags);
	return true;
#else
	ULONG argp = (on == true) ? 1 : 0;
	int result;
	result = ioctlsocket(s,FIONBIO,&argp);
	if (result == SOCKET_ERROR)
	{
		int iErr = WSAGetLastError() ;
		switch ( iErr ) 
		{
		case WSANOTINITIALISED :					//在使用此API之前应首先成功地调用WSAStartup()
		case WSAENETDOWN:							//WINDOWS套接口实现检测到网络子系统失效
		case WSAEINVAL:								//cmd为非法命令，或者argp所指参数不适用于该cmd命令，或者该命令不适用于此种类型的套接口。
		case WSAEINPROGRESS:						//一个阻塞的WINDOWS套接口调用正在运行中
		case WSAENOTSOCK:							//描述字不是一个套接口
		default :
			{
				break ;
			};
		};
		return false;
	}
	return true;
#endif
	return false;
}

bool BASESOCKET::getsocketisnonblockEx(SOCKET s)
{
#ifndef WIN32
	int flags = fcntl(s,F_GETFL,0);
	return flags | O_NONBLOCK;
#endif
	return false;
}

unsigned int BASESOCKET::getsocketrecvbufferEx(SOCKET s)
{
#ifndef WIN32
	unsigned int arg = 0;
	return ioctl(s,FIONREAD,&arg);
#else
	ULONG argp = 0;
	ioctlsocket(s,FIONREAD,&argp);
	return argp;
#endif
	return 0;
}
