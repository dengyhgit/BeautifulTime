//
//  JMSGContactModel.m
//  JMessageDemo
//
//  Created by xudong.rao on 16/7/26.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGContactModel.h"

@implementation JMSGContactModel


- (NSString *)name {
    if (_name) {
        return _name;
    }
    if (self.user.noteName && [self.user.noteName length] > 0) {
        return  self.user.noteName;
    }
    return self.user.username;
}
- (void)setUser:(JMSGUser *)user {
    if (user) {
        _user = user;
        _username = _user.username;
        _appkey = _user.appKey;
    }
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        if (aDecoder == nil) {
            return self;
        }
        _user = (JMSGUser *)[aDecoder decodeObjectForKey:@"user"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _username = [aDecoder decodeObjectForKey:@"username"];
        _appkey = [aDecoder decodeObjectForKey:@"appkey"];
        _dec = [aDecoder decodeObjectForKey:@"dec"];
        _dealWithType = (JMSGFriendInvitationType)[aDecoder decodeObjectForKey:@"dealWithType"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:(JMSGUser *)self.user forKey:@"user"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.appkey forKey:@"appkey"];
    [aCoder encodeObject:self.dec forKey:@"dec"];
    [aCoder encodeInteger:(JMSGFriendInvitationType)self.dealWithType forKey:@"dealWithType"];
}




@end
