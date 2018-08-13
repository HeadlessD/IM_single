//
//  NIMSingelton.h
//  qontact
//
//  Created by Carl Jahn on 18.06.12.
//  Copyright (c) 2012 NIDAG. All rights reserved.
//

#ifndef qontact_NIMSingelton_h
#define qontact_NIMSingelton_h

//http://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/nsobject_Class/Reference/Reference.html#//apple_ref/occ/clm/NSObject/initialize

#define SingletonInterface(Class) \
+ (Class *)sharedInstance;


#define SingletonImplementation(Class) \
static Class *__ ## sharedSingleton; \
\
\
+ (void)initialize \
{ \
static dispatch_once_t once;\
\
dispatch_once(&once, ^{\
\
__ ## sharedSingleton = [[Class alloc] init];\
});\
}\
\
\
+ (Class *)sharedInstance \
{ \
return __ ## sharedSingleton; \
} \
\

#endif
