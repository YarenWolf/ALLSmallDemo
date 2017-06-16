
/*
 简单基本的sql语句
 (1) 数据记录筛选：
 sql="select * from 数据表 where 字段名=字段值 order by 字段名 [desc]"
 sql="select * from 数据表 where 字段名 like '%字段值%' order by 字段名 [desc]"
 sql="select top 10 * from 数据表 where 字段名=字段值 order by 字段名 [desc]"
 sql="select top 10 * from 数据表 order by 字段名 [desc]"
 sql="select * from 数据表 where 字段名 in ('值1','值2','值3')"
 sql="select * from 数据表 where 字段名 between 值1 and 值2"
 (2) 更新数据记录：
 sql="update 数据表 set 字段名=字段值 where 条件表达式"
 sql="update 数据表 set 字段1=值1,字段2=值2 …… 字段n=值n where 条件表达式"
 (3) 删除数据记录：
 sql="delete from 数据表 where 条件表达式"
 sql="delete from 数据表" (将数据表所有记录删除)
 (4) 添加数据记录：
 sql="insert into 数据表 (字段1,字段2,字段3 …) values (值1,值2,值3 …)"
 sql="insert into 目标数据表 select * from 源数据表" (把源数据表的记录添加到目标数据表)
 (5) 数据记录统计函数：
 AVG(字段名) 得出一个表格栏平均值
 COUNT(*;字段名) 对数据行数的统计或对某一栏有值的数据行数统计
 MAX(字段名) 取得一个表格栏最大的值
 MIN(字段名) 取得一个表格栏最小的值
 SUM(字段名) 把数据栏的值相加
 引用以上函数的方法：
 sql="select sum(字段名) as 别名 from 数据表 where 条件表达式"
 //set rs=conn.excute(sql)
 用 rs("别名") 获取统计的值，其它函数运用同上。
 查询去除重复值：select distinct * from table1
 (6) 数据表的建立和删除：
 　　CREATE TABLE 数据表名称(字段1 类型1(长度),字段2 类型2(长度) …… )
 */

#import <UIKit/UIKit.h>

@interface FMDBViewController : UIViewController

@end
