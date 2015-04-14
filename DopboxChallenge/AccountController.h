#import <Foundation/Foundation.h>
@class DBAccount, DBFilesystem, DBPath;
@protocol AccountController <NSObject>
- (id)initWithFilesystem:(DBFilesystem *)filesystem root:(DBPath *)root;

@property (nonatomic, readonly) DBAccount *account;

@end
