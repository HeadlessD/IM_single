//
//  Allpinyin.c
//  Qianbao
//
//  Created by liyan1 on 13-4-23.
//  Copyright (c) 2013年 qianwang365. All rights reserved.
//
#include "Allpinyin.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

#include "mpool.h"

#define PY_K                1024
#define PY_INDEX_BUF_SIZE   (PY_K/2 + PY_K*4*5 - 1)
#define PY_CODE_SPECIAL     (unsigned short)0x3007
#define PY_CODE_BASE        (unsigned short)0x4E00
#define PY_CODE_END         (unsigned short)0x9FA5
#define PY_BUF_SIZE         420

#define FILE_INDEX         "pinyin_index.txt"
#define FILE_PINYIN        "pinyin.txt"

typedef struct _pinyin_index {
    unsigned short *index_ptr_buf[PY_INDEX_BUF_SIZE];
    unsigned short *u3007_ptr;
    char *pinyin_ptr_buf[PY_BUF_SIZE];
} pinyin_index;

static unsigned int version = 1;
static pinyin_index *index_ptr;
static void *mpool;

static inline int arrlen(int buf[])
{
    int *p = buf;
    while (*p != -1)
    {
        p++;
    }
    return p - buf;
}

static inline void arrreset(int buf[], int size)
{
    while (size)
    {
        buf[--size] = -1;
    }
}

static inline void arrcpy(unsigned short *dst, int *src)
{
    while (*src != -1)
    {
        *dst++ = *src++;
    }
}

#define BUF_SIZE 8

int init_pinyin(const char *index_file_path, const char *pinyin_file_path)
{
    if(index_ptr != NULL)
        return 0;
    if (!index_file_path)
    {
        index_file_path = FILE_INDEX;
    }
    FILE *file_index = fopen(index_file_path, "r");
    if (!file_index)
    {
        return PY_INIT_ERROR_NO_INDEX_FILE;
    }
    if (!pinyin_file_path)
    {
        pinyin_file_path = FILE_PINYIN;
    }
    FILE *file_pinyin = fopen(pinyin_file_path, "r");
    if (!file_pinyin)
    {
        fclose(file_index);
        return PY_INIT_ERROR_NO_PINYIN_FILE;
    }
    int code;
    int len = 0;
    int p[BUF_SIZE];
    unsigned short *py_ptr;
    
    // init global variables
    index_ptr = (pinyin_index *)malloc(sizeof(pinyin_index));
    memset(index_ptr, 0, sizeof(pinyin_index));
    mpool = mpool_create();
    
    // get and set the first index
    arrreset(p,BUF_SIZE);
    if (fscanf(file_index, "%d:%d,%d,%d,%d,%d,%d,%d,%d",
                  &code, p, p+1, p+2, p+3, p+4, p+5, p+6, p+7) != -1) {
        assert(code == PY_CODE_SPECIAL);
        
        len = arrlen(p);
        
        py_ptr = mpool_alloc((len + 1)*sizeof(unsigned short), mpool);
        assert(py_ptr);
        index_ptr->u3007_ptr = py_ptr;
        
        *py_ptr = (unsigned short)len;
        arrcpy(++py_ptr, p);
        arrreset(p, len);
    }
    
    // get and set the others
    while (fscanf(file_index, "%d:%d,%d,%d,%d,%d,%d,%d,%d",
                  &code, p, p+1, p+2, p+3, p+4, p+5, p+6, p+7) != -1)
    {
        len = arrlen(p);
        
        py_ptr = mpool_alloc((len + 1)*sizeof(unsigned short), mpool);
        assert(py_ptr);
        index_ptr->index_ptr_buf[code - PY_CODE_BASE] = py_ptr;
        
        *py_ptr = (unsigned short)len;
        arrcpy(++py_ptr, p);
        arrreset(p, len);
    }
    fclose(file_index);
    
    // mpool_dump(mpool,stdout);
    
    // init pinyins
    char *buf = (char *)p;
    char *q = NULL;
    len = 0;
    while (fscanf(file_pinyin, "%s", buf) != -1)
    {
        q = (char *)mpool_alloc(strlen(buf) + 1, mpool);
        assert(q);
        index_ptr->pinyin_ptr_buf[len++] = q;
        strcpy(q, buf);
    }
    fclose(file_pinyin);
    
    // mpool_dump(mpool,stdout);
    
    return version;
}

void destroy_pinyin(void)
{
    free(index_ptr);
    mpool_destory(mpool);
    index_ptr = NULL;
    mpool = NULL;
}

const char * hanzi2pinyin(unsigned short hanzi)
{
    const char *pinyin_ptr = NULL;
    const unsigned short *py_ptr = hanzi2handle(hanzi);
    if (py_ptr)
    {
        pinyin_ptr = index_ptr->pinyin_ptr_buf[*(py_ptr + 1)];
    }
    return pinyin_ptr;
}

const unsigned short * hanzi2handle(unsigned short hanzi) {
    unsigned short *py_ptr = NULL;
    if (hanzi >= PY_CODE_BASE && hanzi <= PY_CODE_END) {
        py_ptr = index_ptr->index_ptr_buf[hanzi - PY_CODE_BASE];
    }
    else if (hanzi == PY_CODE_SPECIAL) {
        py_ptr = index_ptr->u3007_ptr;
    }
    return py_ptr;
}

const char * pinyin_at(unsigned short at, const unsigned short *handle) {
    const char *pinyin_ptr = NULL;
    if (handle && at < *handle) {
        pinyin_ptr = index_ptr->pinyin_ptr_buf[*(handle + 1 + at)];
    }
    return pinyin_ptr;
}
