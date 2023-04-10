//
//  ZHEditInfoItem.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/26.
//

#import <UIKit/UIKit.h>
#import "ZHInsetLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZHEditInfoItem : UITableViewCell
@property (nonatomic, strong)ZHInsetLabel *cellTitle;
@property (nonatomic, strong)ZHInsetLabel *cellContent;
@end

NS_ASSUME_NONNULL_END
