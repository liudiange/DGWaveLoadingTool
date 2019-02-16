//
//  DGLinkProxy.m
//  DGWaveLoadingDemo
//
//  Created by 刘殿阁 on 2019/2/16.
//  Copyright © 2019 apple. All rights reserved.
//

#import "DGLinkProxy.h"

@interface DGLinkProxy ()
@property (nonatomic, weak) id target;

@end

@implementation DGLinkProxy
+(instancetype)initWithTarget:(id)target{
    DGLinkProxy *linkProxy = [DGLinkProxy alloc];
    linkProxy.target = target;
    return linkProxy;
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    return [self.target methodSignatureForSelector:sel];
}
-(void)forwardInvocation:(NSInvocation *)invocation{
    [invocation invokeWithTarget:self.target];
}

@end
