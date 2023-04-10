//
//  ZHPlaceDataBase.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/22.
//

#import "ZHPlaceDataBase.h"

#import <FMDB.h>
@implementation ZHPlaceDataBase
static FMDatabaseQueue *_queue;
//
///// 初始化
//+ (void)initialize{
//    //  获取数据库文件路径
//    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *path = [docPath stringByAppendingPathComponent:@"Itinerary.sqlite"];
//    NSLog(@"%@", path);
//    //  创建数据库对象
//    FMDatabase *db = [FMDatabase databaseWithPath:path];
//    //  打开数据库
//    if([db open]){
//        NSLog(@"打开Itinerary数据库成功");
//    }
//    else{
//        NSLog(@"打开Itinerary数据库失败");
//    }
//    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
//    ///  表名： userTable
//    ///  param
//    ///  0 - id  景点 ID
//    ///  1 - placeName  景点名称
//    ///  2 - longitude  经度
//    ///  3 - latitude   纬度
//    [_queue inDatabase:^(FMDatabase *db){
//        NSString *createTableSqlString = @"CREATE TABLE IF NOT EXISTS placeTable (id integer PRIMARY KEY, placeName text, longitude float, latitude float)";
//        [db executeUpdate:createTableSqlString];
//    }];
//}
//
/////  插入数据
//+(BOOL)insertData:(ZHPlace *)place{
//        __block BOOL result = NO;
//        [_queue inDatabase:^(FMDatabase *db){
//            NSString *sql = @"insert into placeTable (id, placeName, longitude, latitude) values(?, ?, ?, ?)";
//            //  生成随机数做编号 10000 ~ 99999
//            srand((unsigned int )time(NULL));
//            int x = rand()%(99999 - 10000 + 1) + 10000;
//            NSInteger placeId = x;
//            NSString *placeName = place.placeName;
//            CGFloat longitude = place.longitude;
//            CGFloat latitude = place.latitude;
//            if([db executeUpdate:sql, placeId, placeName, longitude, latitude]){
//                NSLog(@"插入表 placeTable 中记录 %ld 成功",placeId);
//                result = YES;
//            }
//            else{
//                NSLog(@"插入表 placeTable 中记录 %ld 失败",placeId);
//                result = NO;
//            }
//        }];
//        return result;
//}
//
//
/////  遍历 placeTable
//+(NSMutableArray *)traverseAllData{
//    __block NSMutableArray *result = [NSMutableArray array];
//    [_queue inDatabase:^(FMDatabase * db) {
//        NSString *sql = @"select * FROM placeTable";
//        FMResultSet *rs = [db executeQuery:sql];
//        while([rs next]){
//            ZHPlace *aPlace = [[ZHPlace alloc]init];
//            aPlace.placeId = [rs intForColumnIndex:0];
//            aPlace.placeName = [rs stringForColumnIndex:1];
//            aPlace.longitude = [rs doubleForColumnIndex:2];
//            aPlace.latitude = [rs doubleForColumnIndex:3];
//            [result addObject:aPlace];
//        }
//        NSLog(@"遍历 placeTable 成功！");
//        NSLog(@"共 %ld 条记录",result.count);
//        [rs close];
//    }];
//
//     return result;
//}
@end
