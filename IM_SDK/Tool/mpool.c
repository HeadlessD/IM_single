//
//  mpool.c
//  Qianbao
//
//  Created by liyan1 on 13-4-23.
//  Copyright (c) 2013年 qianwang365. All rights reserved.
//
#include "mpool.h"

#include <stdlib.h>
#include <string.h>

//#define BLOCK_SIZE 1022
#define BLOCK_SIZE   2046
#define MPOOL_SCALAR 1020/4

typedef struct _mpool_block {
    unsigned short current;
    unsigned char buf[BLOCK_SIZE];
} mpool_block;

typedef struct _mpool {
    int current;
    mpool_block *blocks[MPOOL_SCALAR];
} mpool;

void *mpool_create(void) {
    mpool *mpool_ptr = (mpool *)malloc(sizeof(mpool));
    mpool_ptr->current = -1;
    return mpool_ptr;
}

void mpool_destory(void *mpool_ptr) {
    if (!mpool_ptr) {
        return;
    }
    mpool *mp_ptr = (mpool *)mpool_ptr;
    for (int i = mp_ptr->current; i >= 0; i--) {
        free(mp_ptr->blocks[i]);
    }
    free(mpool_ptr);
}

void *mpool_alloc(unsigned int length, void *mpool_ptr) {
    if (!mpool_ptr
        || length > BLOCK_SIZE) {
        return NULL;
    }
    mpool *mp_ptr = (mpool *)mpool_ptr;
    mpool_block *block = NULL;
    
    if (mp_ptr->current < 0
        || mp_ptr->blocks[mp_ptr->current]->current + length > BLOCK_SIZE) {
        
        if (mp_ptr->current == MPOOL_SCALAR - 1) {
            return NULL;
        }
        
        block = malloc(sizeof(mpool_block));
        block->current = 0;
        mp_ptr->blocks[++(mp_ptr->current)] = block;
    }
    else {
        block = mp_ptr->blocks[mp_ptr->current];
    }
    void *ptr = block->buf + block->current;
    block->current += length;
    return ptr;
}

void mpool_dump(void *mpool_ptr, FILE *output) {
    if (!mpool_ptr || !output) {
        return;
    }
    
    mpool *mp_ptr = (mpool *)mpool_ptr;
    mpool_block *block = NULL;
    int total = 0,used = 0;
    for (int i = 0; i <= mp_ptr->current; i++) {
        block = mp_ptr->blocks[i];
        fprintf(output,"%d:total = %d,used = %d\n", i, BLOCK_SIZE, block->current);
        total += BLOCK_SIZE;
        used += block->current;
    }
    printf("above all:total = %d,used = %d,ratio = %f%%\n", total, used, ((float)used/total)*100);
}
