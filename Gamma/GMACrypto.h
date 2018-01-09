//
//  GMACrypto.h
//  Gamma
//
//  Created by Dalton Claybrook on 1/8/18.
//  Copyright © 2018 Dalton Claybrook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GMACrypto : NSObject

+ (NSString *)sha256HashOfData:(const char *)data length:(unsigned int)length;

@end

NS_ASSUME_NONNULL_END
