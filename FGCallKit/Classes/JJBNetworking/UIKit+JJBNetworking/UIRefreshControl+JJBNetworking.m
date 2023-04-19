// UIRefreshControl+JJBNetworking.m
//
// Copyright (c) 2011–2016 Alamofire Software Foundation ( http://alamofire.org/ )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "UIRefreshControl+JJBNetworking.h"
#import <objc/runtime.h>

#if TARGET_OS_IOS

#import "JJBURLSessionManager.h"

@interface JJBRefreshControlNotificationObserver : NSObject
@property (readonly, nonatomic, weak) UIRefreshControl *refreshControl;
- (instancetype)initWithActivityRefreshControl:(UIRefreshControl *)refreshControl;

- (void)setRefreshingWithStateOfTask:(NSURLSessionTask *)task;

@end

@implementation UIRefreshControl (JJBNetworking)

- (JJBRefreshControlNotificationObserver *)JJB_notificationObserver {
    JJBRefreshControlNotificationObserver *notificationObserver = objc_getAssociatedObject(self, @selector(JJB_notificationObserver));
    if (notificationObserver == nil) {
        notificationObserver = [[JJBRefreshControlNotificationObserver alloc] initWithActivityRefreshControl:self];
        objc_setAssociatedObject(self, @selector(JJB_notificationObserver), notificationObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return notificationObserver;
}

- (void)setRefreshingWithStateOfTask:(NSURLSessionTask *)task {
    [[self JJB_notificationObserver] setRefreshingWithStateOfTask:task];
}

@end

@implementation JJBRefreshControlNotificationObserver

- (instancetype)initWithActivityRefreshControl:(UIRefreshControl *)refreshControl
{
    self = [super init];
    if (self) {
        _refreshControl = refreshControl;
    }
    return self;
}

- (void)setRefreshingWithStateOfTask:(NSURLSessionTask *)task {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

    [notificationCenter removeObserver:self name:JJBNetworkingTaskDidResumeNotification object:nil];
    [notificationCenter removeObserver:self name:JJBNetworkingTaskDidSuspendNotification object:nil];
    [notificationCenter removeObserver:self name:JJBNetworkingTaskDidCompleteNotification object:nil];

    if (task) {
        UIRefreshControl *refreshControl = self.refreshControl;
        if (task.state == NSURLSessionTaskStateRunning) {
            [refreshControl beginRefreshing];

            [notificationCenter addObserver:self selector:@selector(JJB_beginRefreshing) name:JJBNetworkingTaskDidResumeNotification object:task];
            [notificationCenter addObserver:self selector:@selector(JJB_endRefreshing) name:JJBNetworkingTaskDidCompleteNotification object:task];
            [notificationCenter addObserver:self selector:@selector(JJB_endRefreshing) name:JJBNetworkingTaskDidSuspendNotification object:task];
        } else {
            [refreshControl endRefreshing];
        }
    }
}

#pragma mark -

- (void)JJB_beginRefreshing {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refreshControl beginRefreshing];
    });
}

- (void)JJB_endRefreshing {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
    });
}

#pragma mark -

- (void)dealloc {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter removeObserver:self name:JJBNetworkingTaskDidCompleteNotification object:nil];
    [notificationCenter removeObserver:self name:JJBNetworkingTaskDidResumeNotification object:nil];
    [notificationCenter removeObserver:self name:JJBNetworkingTaskDidSuspendNotification object:nil];
}

@end

#endif
