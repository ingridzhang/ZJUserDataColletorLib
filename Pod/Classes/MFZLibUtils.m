//
//  MFZLibUtils.m
//  MaoKebing
//
//  Created by Mao on 8/30/15.
//  Copyright (c) 2015 Maokebing. All rights reserved.
//

#import "MFZLibUtils.h"
#import <zlib.h>

#define CHUNK 16384

@implementation MFZLibUtils


+ (NSData *)dataUseZLibDecompressWithData:(NSData *)data {
	int ret;
	unsigned have;
	z_stream strm;
	unsigned char in[CHUNK];
	unsigned char out[CHUNK];
	
	/* allocate inflate state */
	strm.zalloc = Z_NULL;
	strm.zfree = Z_NULL;
	strm.opaque = Z_NULL;
	strm.avail_in = 0;
	strm.next_in = Z_NULL;
	ret = inflateInit(&strm);
	if (ret != Z_OK)
		return nil;
	
	NSInteger pos = 0;
	NSInteger left = data.length;
	NSMutableData* outData = [NSMutableData data];
	
	
	/* decompress until deflate stream ends or end of file */
	do {
		NSInteger len = left > CHUNK ? CHUNK : left;
		[data getBytes:in range:NSMakeRange(pos, len)];
		pos += len;
		left -= len;
		
		strm.avail_in = (uInt)len;
		if (strm.avail_in == 0)
			break;
		strm.next_in = in;
		
		/* run inflate() on input until output buffer not full */
		do {
			strm.avail_out = CHUNK;
			strm.next_out = out;
			ret = inflate(&strm, Z_NO_FLUSH);
			assert(ret != Z_STREAM_ERROR);  /* state not clobbered */
			switch (ret) {
				case Z_NEED_DICT:
					ret = Z_DATA_ERROR;     /* and fall through */
				case Z_DATA_ERROR:
				case Z_MEM_ERROR:
					(void)inflateEnd(&strm);
					return nil;
			}
			have = CHUNK - strm.avail_out;
			[outData appendBytes:out length:have];
		} while (strm.avail_out == 0);
		
		/* done when inflate() says it's done */
	} while (ret != Z_STREAM_END);
	
	/* clean up and return */
	(void)inflateEnd(&strm);
	
	if (ret == Z_STREAM_END) {
		return [outData copy];
	}
	
	return nil;
}



+ (NSData *)dataUseZLibCompressWithData:(NSData *)data {
	int ret, flush;
	unsigned have;
	z_stream strm;
	unsigned char in[CHUNK];
	unsigned char out[CHUNK];
	
	/* allocate deflate state */
	strm.zalloc = Z_NULL;
	strm.zfree = Z_NULL;
	strm.opaque = Z_NULL;
	ret = deflateInit(&strm, Z_DEFAULT_COMPRESSION);
	if (ret != Z_OK)
		return nil;
	
	NSInteger pos = 0;
	NSInteger left = data.length;
	
	//output
	NSMutableData* outData = [NSMutableData data];
	
	/* compress until end of file */
	do {
		NSInteger len = left > CHUNK ? CHUNK : left;
		[data getBytes:in range:NSMakeRange(pos, len)];
		pos += len;
		left -= len;
		
		strm.avail_in = (uInt)len;
		flush = left == 0 ? Z_FINISH : Z_NO_FLUSH;
		strm.next_in = in;
		
		/* run deflate() on input until output buffer not full, finish
		 compression if all of source has been read in */
		do {
			strm.avail_out = CHUNK;
			strm.next_out = out;
			ret = deflate(&strm, flush);    /* no bad return value */
			assert(ret != Z_STREAM_ERROR);  /* state not clobbered */
			have = CHUNK - strm.avail_out;
			
			[outData appendBytes:out length:have];
		} while (strm.avail_out == 0);
		assert(strm.avail_in == 0);     /* all input will be used */
		
		/* done when last data in file processed */
	} while (flush != Z_FINISH);
	assert(ret == Z_STREAM_END);        /* stream will be complete */
	
	/* clean up and return */
	(void)deflateEnd(&strm);
	
	return [outData copy];
}


@end
