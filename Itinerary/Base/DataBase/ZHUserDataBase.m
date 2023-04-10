//
//  ZHUserDataBase.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/20.
//  管理用户表

#import "ZHUserDataBase.h"
#import <FMDB.h>

@implementation ZHUserDataBase
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
        NSLog(@"打开usertable数据库成功");
    }
    else{
        NSLog(@"打开数据库失败");
    }
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    ///  表名： userTable
    ///  param
    ///  0 - id  用户 id
    ///  1 - name  昵称
    ///  2 - password 用户密码
    ///  3 - email 用户邮箱
    ///  4 - role 用户角色
    ///  5 - image 用户头像
    ///  6 - tel 用户手机号
    ///  7 - sex 用户性别
    [_queue inDatabase:^(FMDatabase *db){
        NSString *createTableSqlString = @"CREATE TABLE IF NOT EXISTS userTable (id integer PRIMARY KEY, name text NOT NULL, password text NOT NULL, email text, role text, image integer NOT NULL, tel text NOT NULL, sex text)";
        [db executeUpdate:createTableSqlString];
    }];
}


/// 插入数据（仅注册时使用）
/// @param user  插入的对象
+(BOOL)insertData:(ZHUser *)user password:(NSString *)password{
    __block BOOL result = NO;
    [_queue inDatabase:^(FMDatabase *db){
        NSString *sql = @"insert into userTable (id, name, password, image, tel) values(?, ?, ?, ?, ?)";
        //  生成随机数做编号 10000 ~ 99999
        srand((unsigned int )time(NULL)); 
        int x = rand()%(99999 - 10000 + 1) + 10000;
        NSString *userID = [NSString stringWithFormat:@"%d",x];
        NSString *userName = @"旅行者";
        NSString *image = @"http://rpk88ant9.hn-bkt.clouddn.com/normal_avatar.jpeg";
        NSString *tel = user.tel;
        if([db executeUpdate:sql, userID, userName, password, image, tel]){
            NSLog(@"插入表 User_table 中记录 %@ 成功",userID);
            result = YES;
        }
        else{
            NSLog(@"插入表 User_table 中记录 %@ 失败",userID);
            result = NO;
        }
    }];
    return result;
}

///// 查询数据是否存在
//+(BOOL)dataExist:(NSString *)telphone{
////    __block BOOL isExist = NO;
////    [_queue inDatabase:^(FMDatabase * db) {
////        NSString *sql = @"select * FROM userTable WHERE tel = ?";
////        FMResultSet *rs = [db executeQuery:sql, telphone];
////        if([rs next]){
////            isExist = YES;
////            NSLog(@"查询表 userTable 中记录 %@ 成功",telphone);
////        }
////        [rs close];
////    }];
////    return isExist;
//}

/////  根据手机号查询对象
//+(ZHUser *)queryData:(NSString *)telphone{
//    ZHUser *aUser = [[ZHUser alloc]init];
//    [_queue inDatabase:^(FMDatabase * db) {
//        NSString *sql = @"select * FROM userTable WHERE tel = ?";
//        FMResultSet *rs = [db executeQuery:sql, telphone];
//        if([rs next]){
//            aUser.nickname = [rs stringForColumnIndex:1];
//            aUser.email = [rs stringForColumnIndex:3];
//            aUser.image = [rs stringForColumnIndex:5];
//            aUser.gender = [rs stringForColumnIndex:7];
//            NSLog(@"查询表 userTable 中记录 %@ 成功",telphone);
//        }
//        [rs close];
//    }];
//    return aUser;
//}


+(BOOL)checkLogin:(NSString *)telphone password:(NSString *)password{
    __block NSString *checkPassword = nil;
    [_queue inDatabase:^(FMDatabase * db) {
        NSString *sql = @"select * FROM userTable WHERE tel = ?";
        FMResultSet *rs = [db executeQuery:sql, telphone];
        if([rs next]){
            checkPassword = [rs stringForColumnIndex:2];
            NSLog(@"查询表 userTable 中记录 %@ 成功",telphone);
        }
        [rs close];
    }];
    if([password isEqualToString:checkPassword] ){
         //  密码一致
        return YES;
    }else{
        return NO;
    }
}





/////  遍历 BOOKSHELF_Table
//+(NSMutableArray *)traverseAllData{
//    __block NSMutableArray *result = [NSMutableArray array];
//    [_queue inDatabase:^(FMDatabase * db) {
//        NSString *sql = @"select * FROM BOOKSHELF_Table";
//        NSUInteger tablejilu = 0;
//        FMResultSet *rs = [db executeQuery:sql];
//        while([rs next]){
//            WitBookModel *aBook = [[WitBookModel alloc]init];
//            aBook.bookID = [rs intForColumnIndex:0];
//            aBook.bookName = [rs stringForColumnIndex:1];
//            aBook.bookAuthor = [rs stringForColumnIndex:2];
//            aBook.bookCover = [rs stringForColumnIndex:3];
//            aBook.bookType = [rs stringForColumnIndex:4];
//            aBook.readedChapter = [rs intForColumnIndex:5];
//            aBook.chapterCount = [rs intForColumnIndex:6];
//            aBook.bookIntroUrl = [rs stringForColumnIndex:7];
//            [result addObject:aBook];
//            tablejilu ++;
//        }
//        NSLog(@"遍历 BOOKSHELF_Table 成功！");
//        NSLog(@"共 %ld 条记录",tablejilu);
//        [rs close];
//    }];
//
//     return result;
//}
//
//
//
//+(void)deleteData:(NSUInteger)bookID{
//    NSNumber *bookIDObj = [NSNumber numberWithInteger:bookID];
//    [_queue inDatabase:^(FMDatabase *  db) {
//        NSString *sql = @"delete FROM BOOKSHELF_Table WHERE bookID = ?";
//        if([db executeUpdate:sql, bookIDObj]){
//            NSLog(@"删除表 BOOKSHELF_Table 记录成功， bookID = %@",bookIDObj);
//        }
//        else{
//            NSLog(@"删除表 BOOKSHELF_Table 记录失败， bookID = %@",bookIDObj);
//        }
//    }];
//}
//
//+(void)updateData:(WitBookModel *)aBook{
//    [_queue inDatabase:^(FMDatabase * db) {
//        NSString *sql = @"update BOOKSHELF_Table set bookName = ?, bookAuthor = ?, bookCover = ?, bookType = ?, readedChapter = ?, chapterCount = ?, bookIntroUrl = ? where bookID = ?";
//        NSNumber *bookID = [NSNumber numberWithInteger:aBook.bookID];
//        NSString *bookName = aBook.bookName;
//        NSString *bookAuthor = aBook.bookAuthor;
//        NSString *bookCover = aBook.bookCover;
//        NSString *bookType = aBook.bookType;
//        NSNumber *readedChapter = [NSNumber numberWithInteger:aBook.readedChapter];
//        NSNumber *chapterCount = [NSNumber numberWithInteger:aBook.chapterCount];
//        NSString *bookIntroUrl = aBook.bookIntroUrl;
//        if([db executeUpdate:sql, bookName, bookAuthor, bookCover, bookType, readedChapter, chapterCount, bookIntroUrl, bookID]){
//            NSLog(@"更新表 BOOKSHELF_Table 成功， bookID = %@",bookID);
//        }
//        else{
//            NSLog(@"更新表 BOOKSHELF_Table 失败， bookID = %@",bookID);
//        }
//    }];
//}
//+(void)updateData:(NSUInteger)bookID Readedchapter:(NSUInteger)readedChapter{
//    [_queue inDatabase:^(FMDatabase * db) {
//        NSNumber *bookIDObj = [NSNumber numberWithInteger:bookID];
//        NSNumber *readedChapterObj = [NSNumber numberWithInteger:readedChapter];
//        NSString *sql = @"update BOOKSHELF_Table readedChapter = ? where bookID = ?";
//
//        if([db executeUpdate:sql,readedChapterObj, bookIDObj]){
//            NSLog(@"更新表 BOOKSHELF_Table 阅读进度 成功， bookID = %@",bookIDObj);
//        }
//        else{
//            NSLog(@"更新表 BOOKSHELF_Table 阅读进度 失败， bookID = %@",bookIDObj);
//        }
//    }];
//}
//+(void)updateData:(NSUInteger)bookID chapterCount:(NSUInteger)chapterCount{
//    [_queue inDatabase:^(FMDatabase * db) {
//        NSNumber *bookIDObj = [NSNumber numberWithInteger:bookID];
//        NSNumber *chapterCountObj = [NSNumber numberWithInteger:chapterCount];
//        NSString *sql = @"update BOOKSHELF_Table chapterCount = ? where bookID = ?";
//
//        if([db executeUpdate:sql, chapterCountObj, bookIDObj]){
//            NSLog(@"更新表 BOOKSHELF_Table 章节总数 成功， bookID = %@",bookIDObj);
//        }
//        else{
//            NSLog(@"更新表 BOOKSHELF_Table 章节总数 失败， bookID = %@",bookIDObj);
//        }
//    }];
//}
@end
