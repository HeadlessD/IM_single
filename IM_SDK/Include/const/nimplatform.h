#ifndef __PLATFORM_H
#define __PLATFORM_H
//-----------------------------------------------------------------------------
// need this for _alloca
// need this for memset
#include <string.h>

#include <time.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/timeb.h>

#ifdef _WIN32
#include <crtdbg.h>
#include <windows.h>
#else
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <errno.h>

#include<stdlib.h>
#define __FUNCTION__ __PRETTY_FUNCTION__
#endif
#include <assert.h>


//////////////////////////////////////////////////////////////////////////
//linux
#ifndef TRUE
#define TRUE                (1)
#endif

#ifndef FALSE
#define FALSE               (0)
#endif
#ifndef NULL
#define NULL				(0)
#endif


#ifndef WIN32

typedef unsigned char       BYTE;
typedef BYTE*				LPBYTE;
typedef unsigned short      WORD;
typedef unsigned short      USHORT;
typedef short				SHORT;
typedef void				VOID;
typedef int					INT;
typedef unsigned int        UINT;
typedef long				LONG;
typedef unsigned long       ULONG;
typedef unsigned long       DWORD;

//typedef signed char	        BOOL;

typedef long long            __int64;
typedef unsigned long long	UINT64;


#if defined(_64BIT)
typedef __int64 INT_PTR, *PINT_PTR;
typedef unsigned __int64 UINT_PTR, *PUINT_PTR;
typedef __int64 LONG_PTR, *PLONG_PTR;
typedef unsigned __int64 ULONG_PTR, *PULONG_PTR;
#else
typedef int INT_PTR, *PINT_PTR;
typedef unsigned int UINT_PTR, *PUINT_PTR;

typedef long LONG_PTR, *PLONG_PTR;
typedef unsigned long ULONG_PTR, *PULONG_PTR;
#endif



typedef void* HANDLE;
typedef void* HMODULE;
typedef void * HINSTANCE;
typedef void* LPVOID;

typedef  long LONG_PTR, *PLONG_PTR;
typedef  unsigned long ULONG_PTR, *PULONG_PTR;

//typedef UINT_PTR	SOCKET;

typedef unsigned int        WPARAM;
typedef long				LPARAM;
typedef long				LRESULT;

typedef struct _GUID {
	unsigned int Data1;
	unsigned short Data2;
	unsigned short Data3;
	unsigned char  Data4[ 8 ];
} GUID;

#define IsEqualGUID(rguid1, rguid2) (!memcmp(rguid1, rguid2, sizeof(GUID)))

#ifdef __cplusplus
__inline int operator==(GUID guidOne, GUID guidOther)
{
	return IsEqualGUID(&guidOne,&guidOther);
}

__inline int operator!=(GUID guidOne, GUID guidOther)
{
	return !(guidOne == guidOther);
}
#endif



#ifndef INVALID_HANDLE_VALUE
#define INVALID_HANDLE_VALUE  ((HANDLE)((LONG_PTR)-1))
#endif  //INVALID_HANDLE_VALUE

#define INFINITE -1

#define SOCKADDR sockaddr

//#define HINSTANCE void*	

#ifndef ZeroMemory
#define ZeroMemory(p, t) memset(p,0,t)
#endif  //ZeroMemory


#endif  //WIN32


#ifndef ZeroGUID
#define ZeroGUID(p) memset(p,0,sizeof(GUID))
#endif

//////////////////////////////////////////////////////////////////////////

typedef signed char			int8;
typedef signed short		int16;
typedef signed int			int32;
typedef __int64				int64;

typedef unsigned char		uint8;
typedef unsigned short		uint16;
typedef unsigned int		uint32;
typedef UINT64				uint64;		

typedef float				float32;
typedef double				float64;

typedef unsigned int		uint;

typedef uint32				IPTYPE;
typedef __int64				INT64;

#ifndef WIN32
typedef int                INT;
typedef int32              INT32;
typedef int16              INT16;
typedef unsigned char      byte;
#endif


////hash_map
#ifndef  WIN32
#define u9_hash_map        __gnu_cxx::hash_map  
#else
#define u9_hash_map        stdext::hash_map
#endif


#ifndef __WINE_WINDEF_H
typedef long HRESULT;

#endif // __WINE_WINDEF_H 

typedef struct {
	int64 high;
	int64 low;
} int128;

typedef struct {
	uint64 high;
	uint64 low;
} uint128;

/* Try to get PRIx64 from inttypes.h, but if it's not defined, fall back to
* llx, which is the format string for "long long" - this is a 64-bit
* integral type on many systems. */
#ifndef PRIx64
#define PRIx64 "llx"
#endif  /* !PRIx64 */

//////////////////////////////////////////////////////////////////////////
//类型定义
typedef uint64		SESSIONID;	//sessionID
typedef uint64		PASSPORTID;	//sessionID
typedef uint64		PHONEID;	//phone id
typedef uint64		USERID;		//user id
typedef uint64		TEXTMSGID;	//text msg id;
typedef uint64		CALLID;		//
typedef uint32		GROUPID;
typedef uint64		SERVERID;	//服务器ID
typedef uint32		TOKENID;	
//////////////////////////////////////////////////////////////////////////
//无效值
#define INVALID_TOKEN			(0xFFFFFFFF)
#define INVALID_GROUPID			(0xFFFFFFFF)
#define INVALID_TOKENID			(0xFFFFFFFF)	

#ifdef WIN32
#define INVALID_SESSIONID	 (0xFFFFFFFFFFFFFFF)
#define INVALID_PASSPORTID	 (0xFFFFFFFFFFFFFFF)
#define INVALID_PHONEID		 (0xFFFFFFFFFFFFFFF)
#define INVALID_USERID		 (0xFFFFFFFFFFFFFFF)
#define INVALID_SERVERID	 (0xFFFFFFFFFFFFFFF)
#else
#define INVALID_SESSIONID	 (0xFFFFFFFFFFFFFFFULL)
#define INVALID_PASSPORTID	 (0xFFFFFFFFFFFFFFFULL)
#define INVALID_PHONEID		 (0xFFFFFFFFFFFFFFFULL)
#define INVALID_USERID		 (0xFFFFFFFFFFFFFFFULL)
#define INVALID_SERVERID	 (0xFFFFFFFFFFFFFFFULL)
#endif 

//////////////////////////////////////////////////////////////////////////
// max_path
// portability / compiler settings
#if defined(_WIN32) && !defined(WINDED)

#if defined(_M_IX86)
#define __i386__	1
#endif

#else

#define _MAX_PATH PATH_MAX
#endif // defined(_WIN32) && !defined(WINDED) 

//return value flag define
enum ENUM_FUNCTION_RET
{
	RET_RESOURCE_LOW		= -4,   //系统资源不足
	RET_NULL				= -3,   //指针为空
	RET_EXIST               = -2,   //已经存在
	RET_NOT_FOUND           = -1,   //没找到
	RET_ERROR               =  0,   //普通错误
	RET_SUCCESSED             =  1,   //成功
	RET_PROCESSED           =  2,   //已经处理
};

// Defines MAX_PATH
#ifndef MAX_PATH
#define MAX_PATH  (255)
#endif


//////////////////////////////////////////////////////////////////////////
//DLL_EXPORT
#ifdef _WIN32
// Used for dll exporting and importing
#define  DLL_EXPORT   extern "C" __declspec( dllexport ) 
#define  DLL_IMPORT   extern "C" __declspec( dllimport )

// Can't use extern "C" when DLL exporting a class
#define  DLL_CLASS_EXPORT   __declspec( dllexport ) 
#define  DLL_CLASS_IMPORT   __declspec( dllimport )

// Can't use extern "C" when DLL exporting a global
#define  DLL_GLOBAL_EXPORT   extern __declspec( dllexport ) 
#define  DLL_GLOBAL_IMPORT   extern __declspec( dllimport )

#else


// Used for dll exporting and importing
#define  DLL_EXPORT   extern "C" 
#define  DLL_IMPORT   extern "C" 

// Can't use extern "C" when DLL exporting a class
#define  DLL_CLASS_EXPORT   
#define  DLL_CLASS_IMPORT  

// Can't use extern "C" when DLL exporting a global
#define  DLL_GLOBAL_EXPORT   extern
#define  DLL_GLOBAL_IMPORT   extern 

#define __cdecl


#endif //_WIN32


// C functions for external declarations that call the appropriate C++ methods
#ifndef EXPORT
#ifdef _WIN32
#define EXPORT	_declspec( dllexport )
#else 
#define EXPORT	/* */

#endif
#endif



//#include "fastlib/Debug_log.h"


#ifndef U9_ASSERT
//WANGGENG CHANGE NOTE assert
#define U9_ASSERT(f) if(!(f)){LOG_TRACE(1,false,__FUNCTION__," !Assert"<<__LINE__)};assert(f);

#ifdef WIN32
#define CHECKMEMORY  U9_ASSERT(_CrtCheckMemory())
#endif 
#endif //U9_ASSERT





#ifndef _OUT
#define _OUT             
#endif
#ifndef OUT
#define OUT
#endif

#ifdef WIN32
#define  GETSOCKET_ERRCODE()	WSAGetLastError()
#else
#define GETSOCKET_ERRCODE()		errno
#endif //WIN32
//////////////////////////////////////////////////////////////////////////
#ifndef SAFE_DELETE
#define SAFE_DELETE(p)       { if(p) { delete (p);     (p)=NULL; } }
#endif
#ifndef SAFE_RELEASE
#define SAFE_RELEASE(p)		 { if(p) { (p)->Release(); (p)=NULL; } }
#endif
#ifndef SAFE_DELETE_ARRAY
#define SAFE_DELETE_ARRAY(p) { if(p) { delete[] (p);   (p)=NULL; } }
#endif


#define TOUPPER(c) ((((c) >= 'a') && ((c) <= 'z')) ? (c)+'A'-'a' : (c))
#define TONIBBLE(c) ((((c) >= 'A')&&((c) <= 'F')) ? (((c)-'A')+10) : ((c)-'0'))
#define BYTES_TO_KBPS(n) (float)(((((float)n)*8.0f)/1024.0f))

#define isSJIS(a,b) ((a >= 0x81 && a <= 0x9f || a >= 0xe0 && a<=0xfc) && (b >= 0x40 && b <= 0x7e || b >= 0x80 && b<=0xfc))
#define isEUC(a) (a >= 0xa1 && a <= 0xfe)
#define isASCII(a) (a <= 0x7f) 
#define isPLAINASCII(a) (((a >= '0') && (a <= '9')) || ((a >= 'a') && (a <= 'z')) || ((a >= 'A') && (a <= 'Z')))
#define isUTF8(a,b) ((a & 0xc0) == 0xc0 && (b & 0x80) == 0x80 )
#define isESCAPE(a,b) ((a == '&') && (b == '#'))
#define isHTMLSPECIAL(a) ((a == '&') || (a == '\"') || (a == '\'') || (a == '<') || (a == '>'))

//////////////////////////////////////////////////////////////////////////
//大头小头
#define SWAP16(v) ( ((v&0xff)<<8) | ((v&0xff00)>>8) )
#define SWAP24(v) (((v&0xff)<<16) | ((v&0xff00)) | ((v&0xff0000)>>16) )
#define SWAP32(v) (((v&0xff)<<24) | ((v&0xff00)<<8) | ((v&0xff0000)>>8) | ((v&0xff000000)>>24))
#define SWAP64(v) ((SWAP4(v)|((uint64_t)SWAP4(v+4)<< 32)))


#if _BIG_ENDIAN
#define CHECK_ENDIAN16(v) v=SWAP16(v)
#define CHECK_ENDIAN24(v) v=SWAP24(v)
#define CHECK_ENDIAN32(v) v=SWAP32(v)
#define CHECK_ENDIAN64(v) v=SWAP64(v)
#else//!_BIG_ENDIAN
#define CHECK_ENDIAN16
#define CHECK_ENDIAN24
#define CHECK_ENDIAN32
#define CHECK_ENDIAN64
#endif //_BIG_ENDIAN

//////////////////////////////////////////////////////////////////////////
//u9 namespace
#define U9_BEGIN_NAMESPACE namespace U9 {
#define U9_END_NAMESPACE   }


//-----------------------------------------------------------------------------

/*
Definitions / prototypes of conversion functions 
Multi-Byte (ANSI) to WideChar (Unicode)

atow() converts from ANSI to widechar
wtoa() converts from widechar to ANSI
*/
#ifdef WIN32 
#define atow(strA,strW,lenW) \
	MultiByteToWideChar(CP_ACP,0,strA,-1,strW,lenW)

#define wtoa(strW,strA,lenA) \
	WideCharToMultiByte(CP_ACP,0,strW,-1,strA,lenA,NULL,NULL)
#endif


// 检查上传结果是成功还是失败
#define CHECK_HTTP_RESULT(adwResult)          (adwResult == 100)

// 构造成功的返回值
#define MAKE_SUCCESS_RESULT()           (0x80000000)
// 构造失败的返回值
#define MAKE_ERROR_RESULT(aiErrorCode)  ((uint32)aiErrorCode & 0x7FFFFFFF)

// 检查结果是成功还是失败
#define CHECK_RESULT(adwResult)          ((uint32)adwResult == 0x80000000)
//恢复好友
#define CHECK_getBackFD(adwResult)          ((uint32)adwResult == 0x24000013)
// 从结果中获得错误码
#define GET_ERROR_CODE(adwResult)        ((uint32)adwResult & 0x7FFFFFFF)

/////////////////////////////////////////////////////////////////////////


#if defined(_MSC_VER)

#pragma warning(push)
#pragma warning(disable : 4100)	// unreferenced formal parameter
#pragma warning(disable : 4127) // conditional expression is constant
#pragma warning(disable : 4201)	// nonstandard extension used : nameless struct/union
#pragma warning(disable : 4244) // type conversion warning.
#pragma warning(disable : 4251) //  needs to have dll-interface to be used by clients of class 'xxClass'

#endif //(_MSC_VER)



#ifdef WIN32 
//socket

#define CloseSocket(ahSocket) closesocket(ahSocket);
#else
#define SD_SEND		(SHUT_WR)
#define SD_RECEIVE	(SHUT_RD)
#define SD_BOTH		(SHUT_RDWR)

#define CloseSocket(ahSocket) close(ahSocket);
#endif 
#endif /* __PLATFORM_H_ */
