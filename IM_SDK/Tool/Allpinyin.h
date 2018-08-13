//
//  Allpinyin.h
//  Qianbao
//
//  Created by liyan1 on 13-4-23.
//  Copyright (c) 2013年 qianwang365. All rights reserved.
//
#ifndef pinyin_pinyin_h
#define pinyin_pinyin_h

#define PY_INIT_ERROR_NO_INDEX_FILE  -1
#define PY_INIT_ERROR_NO_PINYIN_FILE -2

int init_pinyin(const char *index_file_path, const char *pinyin_file_path);

void destroy_pinyin(void);

const char * hanzi2pinyin(unsigned short hanzi);

const unsigned short * hanzi2handle(unsigned short hanzi);

const char * pinyin_at(unsigned short at, const unsigned short *handle);

#endif
