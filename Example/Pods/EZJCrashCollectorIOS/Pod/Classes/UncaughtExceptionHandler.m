//
//  UncaughtExceptionHandler.m
//  UncaughtExceptions
//
//  Created by Matt Gallagher on 2010/05/25.
//  Copyright 2010 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "UncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;

const NSInteger UncaughtExceptionHandlerSkipAddressCount = 0;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 9;

@implementation UncaughtExceptionHandler

+ (NSArray *)backtrace
{
	 void* callstack[128];
	 int frames = backtrace(callstack, 128);
	 char **strs = backtrace_symbols(callstack, frames);
	 
	 int i;
	 NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
	 for (
	 	i = UncaughtExceptionHandlerSkipAddressCount;
	 	i < UncaughtExceptionHandlerSkipAddressCount +
			UncaughtExceptionHandlerReportAddressCount;
		i++)
	 {
	 	[backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
	 }
	 free(strs);
	 
	 return backtrace;
}

//- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex
//{
//    NSLog(@"dddddd:=%ld",(long)anIndex);
////	if (anIndex == 0)
////	{
////		dismissed = YES;
////	}
//}

- (void)validateAndSaveCriticalApplicationData
{
    NSLog(@"要保存的数据");
}

- (void)handleException:(NSException *)exception
{
	[self validateAndSaveCriticalApplicationData];
    
    //NSArray *addresses =[exception callStackReturnAddresses];
   // NSArray * arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSDictionary *info = [exception userInfo];
    NSString *content = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:%@\ninfo:=%@",name,reason,info];
    
    
    NSNotification *notification =[NSNotification notificationWithName:@"crashCollectNotication" object:nil userInfo:@{@"name":name,@"reson":reason,@"info":info}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    NSLog(@"%s:%d %@", __FUNCTION__, __LINE__, content);
    
    //NSLog(@"heqin, Stack Trace: %@", [exception callStackSymbols]);
//	UIAlertView *alert =
//		[[[UIAlertView alloc]
//			initWithTitle:NSLocalizedString(@"未处理异常:", nil)
//			message:[NSString stringWithFormat:NSLocalizedString(
//				@"你可以尝试继续，但应用程序可能是不稳定的.\n\n"
//				@"调试细节:\n%@\n%@", nil),
//				[exception reason],
//				[[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]]
//			delegate:self
//			cancelButtonTitle:NSLocalizedString(@"Quit", nil)
//			otherButtonTitles:NSLocalizedString(@"Continue", nil), nil]
//		autorelease];
//	[alert show];
	
	CFRunLoopRef runLoop = CFRunLoopGetCurrent();
	CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
	
	while (!dismissed)
	{
		for (NSString *mode in (__bridge NSArray *)allModes)
		{
			CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
		}
	}
	
	CFRelease(allModes);

	NSSetUncaughtExceptionHandler(NULL);
	signal(SIGABRT, SIG_DFL);
	signal(SIGILL, SIG_DFL);
	signal(SIGSEGV, SIG_DFL);
	signal(SIGFPE, SIG_DFL);
	signal(SIGBUS, SIG_DFL);
	signal(SIGPIPE, SIG_DFL);
	
	if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName])
	{
		kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
	}
	else
	{
		[exception raise];
	}
}

@end

void HandleException(NSException *exception)
{
	int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
	if (exceptionCount > UncaughtExceptionMaximum)
	{
		return;
	}
	
	NSArray *callStack = [UncaughtExceptionHandler backtrace];
	NSMutableDictionary *userInfo =
		[NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
	[userInfo
		setObject:callStack
		forKey:UncaughtExceptionHandlerAddressesKey];
	
	[[[UncaughtExceptionHandler alloc] init]
		performSelectorOnMainThread:@selector(handleException:)
		withObject:
			[NSException
				exceptionWithName:[exception name]
				reason:[exception reason]
				userInfo:userInfo]
		waitUntilDone:YES];
}

void SignalHandler(int signal)
{
	int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
	if (exceptionCount > UncaughtExceptionMaximum)
	{
		return;
	}
	
	NSMutableDictionary *userInfo =
		[NSMutableDictionary
			dictionaryWithObject:[NSNumber numberWithInt:signal]
			forKey:UncaughtExceptionHandlerSignalKey];

	NSArray *callStack = [UncaughtExceptionHandler backtrace];
	[userInfo
		setObject:callStack
		forKey:UncaughtExceptionHandlerAddressesKey];
	
    [[[UncaughtExceptionHandler alloc] init]
	//[[[[UncaughtExceptionHandler alloc] init] autorelease]
		performSelectorOnMainThread:@selector(handleException:)
		withObject:
			[NSException
				exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
				reason:
					[NSString stringWithFormat:
						NSLocalizedString(@"信号 %d 被提出.", nil),
						signal]
				userInfo:
					[NSDictionary
						dictionaryWithObject:[NSNumber numberWithInt:signal]
						forKey:UncaughtExceptionHandlerSignalKey]]
		waitUntilDone:YES];
}

void InstallUncaughtExceptionHandler(void)
{
	NSSetUncaughtExceptionHandler(&HandleException);
	signal(SIGABRT, SignalHandler);
	signal(SIGILL, SignalHandler);
	signal(SIGSEGV, SignalHandler);
	signal(SIGFPE, SignalHandler);
	signal(SIGBUS, SignalHandler);
	signal(SIGPIPE, SignalHandler);
}

NSString* getAppInfo()
{
    NSString *appInfo = [NSString stringWithFormat:@"App :%@ %@ %@(%@)\nDevice : %@\nOS Version : %@ %@\nUDID :\n",
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                         [UIDevice currentDevice].model,
                         [UIDevice currentDevice].systemName,
                         [UIDevice currentDevice].systemVersion,
                         [UIDevice currentDevice].identifierForVendor];
    NSLog(@"Crash!!!! %@", appInfo);
    
    return appInfo;
    
}


