//
//  BTAboutMeCellModel.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/16.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Myblock)();

@interface BTAboutMeCellModel : NSObject

@property(nonatomic, strong) JMSGUser *user;

//图标
@property (nonatomic,copy) NSString *icon;
//标题
@property (nonatomic,copy) NSString *title;
//子标题
@property (nonatomic,copy) NSString *detailTitle;
//存放图片的二进制
@property (nonatomic,strong) NSData *image;
//操作
@property (nonatomic,copy) Myblock option;

@property (nonatomic,strong) Class vcClass;

+(instancetype)itemWithIcon:(NSString*)icon title:(NSString*)title detailTitle:(NSString*)detailTitle vcClass:(Class)vcClass;

+(instancetype)itemWithUser:(JMSGUser *)user title:(NSString*)title detailTitle:(NSString*)detailTitle vcClass:(Class)vcClass;

@end
