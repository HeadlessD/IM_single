//
//  mpool.h
//  Qianbao
//
//  Created by liyan1 on 13-4-23.
//  Copyright (c) 2013年 qianwang365. All rights reserved.
//

#ifndef mpool_h
#define mpool_h

#include <stdio.h>

void *mpool_create(void);

void mpool_destory(void *mpool_ptr);

void *mpool_alloc(unsigned int length, void *mpool_ptr);

void mpool_dump(void *mpool_ptr, FILE *output);

#endif
