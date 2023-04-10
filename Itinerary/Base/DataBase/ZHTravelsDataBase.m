//
//  ZHTravelsDataBase.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/22.
//

#import "ZHTravelsDataBase.h"
#import <FMDB.h>

static NSInteger traverseCount;
@interface nameZHTravelsDataBase
//@property (nonatomic, assign)NSInteger traverseCount;
@end


@implementation ZHTravelsDataBase
static FMDatabaseQueue *_queue;


/// 初始化
+ (void)initialize{
    //  获取数据库文件路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:@"Itinerary.sqlite"];
    NSLog(@"%@", path);
    //  创建数据库对象
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    //  打开数据库
    if([db open]){
        NSLog(@"打开Itinerary数据库成功");
    }
    else{
        NSLog(@"打开Itinerary数据库失败");
    }
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    ///  表名： userTable
    ///  param
    ///  0 - id  游记 ID
    ///  1 - userId  创建用户 手机号
    ///  2 - image 图片串列以 | 分隔
    ///  3 - title 游记标题
    ///  4 - content 游记内容
    ///  5 - time 建议游玩时间，单位 s
    ///  6 - money 花销
    ///  7 - grade 评分
    [_queue inDatabase:^(FMDatabase *db){
        NSString *createTableSqlString = @"CREATE TABLE IF NOT EXISTS travelTable (id integer PRIMARY KEY, userId text NOT NULL,image text, title text NOT NULL,content text NOT NULL, time integer NOT NULL, money float not NULL,grade float)";
        [db executeUpdate:createTableSqlString];
    }];
}

///  插入数据
+(BOOL)insertData:(ZHTravels *)travel{
        __block BOOL result = NO;
        [_queue inDatabase:^(FMDatabase *db){
            NSString *sql = @"insert into userTable (id, userId, image, title, content, time, money, grade) values(?, ?, ?, ?, ?, ?, ?, ?)";
            //  生成随机数做编号 10000 ~ 99999
//            srand((unsigned int )time(NULL));
//            int x = rand()%(99999 - 10000 + 1) + 10000;
            NSInteger travelId = [self tableCount] + 1;
            NSString *userId = travel.userID;
            NSString *image = travel.image;
            NSString *title = travel.title;
            NSString *content = travel.content;
            NSNumber *time = [NSNumber numberWithInteger:travel.time];
            NSNumber *money = [NSNumber numberWithInteger: travel.money];
            NSNumber *grade = [NSNumber numberWithDouble:travel.grade];
            if([db executeUpdate:sql, travelId, userId, image, title, content, time, money, grade]){
                NSLog(@"插入表 travels_table 中记录 %ld 成功",travelId);
                result = YES;
            }
            else{
                NSLog(@"插入表 travels_table 中记录 %ld 失败",travelId);
                result = NO;
            }
        }];
        return result;
}

///  根据手机号遍历 travelsTable
+(NSMutableArray *)traverseAllData:(NSString *)telphone {
    __block NSMutableArray *result = [NSMutableArray array];
    [_queue inDatabase:^(FMDatabase * db) {
        NSString *sql = @"select * FROM travelTable WHERE userId = ?";
        FMResultSet *rs = [db executeQuery:sql, telphone];
        while([rs next]){
            ZHTravels *aTravels = [[ZHTravels alloc]init];
            aTravels.travelID = [rs longForColumnIndex:0];
            aTravels.userID = [rs stringForColumnIndex:1];
            aTravels.image = [rs stringForColumnIndex:2];
            aTravels.title = [rs stringForColumnIndex:3];
            aTravels.content = [rs stringForColumnIndex:4];
            aTravels.time = [rs intForColumnIndex:5];
            aTravels.money = [rs intForColumnIndex:6];
            aTravels.grade = [rs doubleForColumnIndex:7];
            [result addObject:aTravels];
        }
        
        NSLog(@"遍历 travelsTable 成功！");
        NSLog(@"共 %ld 条记录", [result count]);
        [rs close];
    }];
     return result;
}
//  获取 10 条数据
+(NSMutableArray *)traverseTenData{
    __block NSMutableArray *result = [NSMutableArray array];
    //  记录当前获取多少条数据
    [_queue inDatabase:^(FMDatabase * db) {
        NSInteger nowCount = 0;
        NSString *sql = @"select * FROM travelTable WHERE userId > ?";
        FMResultSet *rs = [db executeQuery:sql, traverseCount];
        while([rs next]){
            nowCount ++;
            ZHTravels *aTravels = [[ZHTravels alloc]init];
            aTravels.travelID = [rs longForColumnIndex:0];
            aTravels.userID = [rs stringForColumnIndex:1];
            aTravels.image = [rs stringForColumnIndex:2];
            aTravels.title = [rs stringForColumnIndex:3];
            aTravels.content = [rs stringForColumnIndex:4];
            aTravels.time = [rs intForColumnIndex:5];
            aTravels.money = [rs intForColumnIndex:6];
            aTravels.grade = [rs doubleForColumnIndex:7];
            [result addObject:aTravels];
            if(nowCount == 10){
                break;
            }
        }
        traverseCount += nowCount;
        NSLog(@"遍历 BOOKSHELF_Table 成功！");
        NSLog(@"共 %ld 条记录", [result count]);
        [rs close];
    }];
     return result;
}


///  获取表中记录数
+(NSInteger )tableCount{
    __block NSInteger count = 0;
    [_queue inDatabase:^(FMDatabase * db) {
        NSString *sql = @"select id FROM travelTable";
        FMResultSet *rs = [db executeQuery:sql];
        while([rs next]){
            count ++;
        }
        NSLog(@"共 %ld 条记录",count);
        [rs close];
    }];

     return count;
}

//  删除 travelId 的记录
+(void)deleteData:(NSInteger)travelId{
//    NSNumber *bookIDObj = [NSNumber numberWithInteger:bookID];
    [_queue inDatabase:^(FMDatabase *  db) {
        NSString *sql = @"delete FROM travelTable WHERE bookID = ?";
        if([db executeUpdate:sql, travelId]){
            NSLog(@"删除表 BOOKSHELF_Table 记录成功， bookID = %ld",travelId);
        }
        else{
            NSLog(@"删除表 BOOKSHELF_Table 记录失败， bookID = %ld",travelId);
        }
    }];
}


@end
