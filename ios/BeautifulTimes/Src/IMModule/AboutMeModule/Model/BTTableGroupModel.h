//
//  BTTableGroupModel.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/16.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTTableGroupModel : NSObject

@property (nonatomic,copy) NSString *header;
@property (nonatomic,copy) NSString *footer;
@property (nonatomic,strong) NSArray *items; //里面存贮的是tableCellitem模型

@end
