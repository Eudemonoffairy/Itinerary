//
//  ZHSchemeViewController.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHSchemeViewController : UITableViewController
//  key:NSString  value:NSArray
@property (nonatomic, strong) NSMutableDictionary *sourceDic;
-(void)initData;
@end

NS_ASSUME_NONNULL_END
