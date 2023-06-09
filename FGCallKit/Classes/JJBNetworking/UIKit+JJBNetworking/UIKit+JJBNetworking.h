// UIKit+JJBNetworking.h
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

#import <TargetConditionals.h>

#ifndef _UIKIT_JJBNETWORKING_
    #define _UIKIT_JJBNETWORKING_

#if TARGET_OS_IOS || TARGET_OS_TV
    #import "JJBAutoPurgingImageCache.h"
    #import "JJBImageDownloader.h"
    #import "UIActivityIndicatorView+JJBNetworking.h"
    #import "UIButton+JJBNetworking.h"
    #import "UIImageView+JJBNetworking.h"
    #import "UIProgressView+JJBNetworking.h"
#endif

#if TARGET_OS_IOS
    #import "JJBNetworkActivityIndicatorManager.h"
    #import "UIRefreshControl+JJBNetworking.h"
    #import "WKWebView+JJBNetworking.h"
#endif

#endif /* _UIKIT_JJBNETWORKING_ */
