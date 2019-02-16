//
//  DGLinkProxy.h
//  DGWaveLoadingDemo
//
//  Created by 刘殿阁 on 2019/2/16.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGLinkProxy : NSProxy

+(instancetype)initWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
