//
//  CriticalSection.hpp
//  qbim
//
//  Created by shiyunjie on 17/3/3.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#ifndef CriticalSection_hpp
#define CriticalSection_hpp

#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

class CriticalSection
{
private:
    pthread_mutex_t m_mutex;
public:
    inline CriticalSection()
    {
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
        int result = pthread_mutex_init(&m_mutex, &attr);
        if(result != 0)
        {
            printf(" phread error %d \n\r", result);
        }
    }
    
    inline ~CriticalSection()
    {
        pthread_mutex_destroy(&m_mutex);
    }
    
    inline void Enter()
    {
        pthread_mutex_lock(&m_mutex);
    }
    
    inline void Leave()
    {
        pthread_mutex_unlock(&m_mutex);
    }
};

class CriticalSectionHelper
{
public:
    inline CriticalSectionHelper(CriticalSection& critical_section) : m_critical_section(critical_section)
    {
        m_critical_section.Enter();
    };
    inline ~CriticalSectionHelper()
    {
        m_critical_section.Leave();
    }
//    inline CriticalSectionHelper& operator=(const CriticalSectionHelper& rhs)
//    {
//        m_critical_section = rhs.m_critical_section;
//    }
private:
    CriticalSection& m_critical_section;
};

#define CRITICAL_SECTION_HELPER(T)\
CriticalSectionHelper c_helper(T)
#endif /* CriticalSection_hpp */
