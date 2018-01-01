---
title: 2017-2-13-Hibernate
date: 2017-2-13 19:59:3 
categories: Java EE
tags: [Hibernate]
layout: post
---
<!-- more -->


## Hibernate中的小知识

1、每一个线程的Session在事务提交的时候，会自动关闭并从当前线程删除。


2、HQL 每次都重新去查询（发送sql），而不是从一级缓存中获取

3、HQL 会将结果放入一级缓存中

4、persist和save方法的区别
	- persist将会完整的持久化bean对象，所以对应的主键不能自己配置（除非主键自增策略为assigned）
	- save方法中，每次都重新设置id


## 多表设计

外键：如果公共关键字在一个关系中是主关键字，那么这个公共关键字被称为另一个关系的外键。由此可见，外键表示了两个关系之间的相关联系。以另一个关系的外键作主关键字的表被称为主表，具有此外键的表被称为主表的从表。外键又称作外关键字。

### 控制权限 inverse

inverse表示 外键的维护权限是否反转。


### 级联操作 cascade


## 加载策略

### 类加载策略

get/load方法。。

默认：load方法是在对象的属性被调用的时候才发送语句查询，被称为懒加载(lazy)。
其配置属性为:

``` xml
<hibernate-mapping>
	<!-- 懒加载默认是开启的 -->
	<class name="Student" table="t_student" lazy="true" >
	
	</class>
</hibernate-mapping>
```

### 关联级别懒加载

默认：所关联的数据，在使用时才开始加载其数据。

关联级别的加载受两个属性控制：

	<set>
		lazy：是否使用懒加载
		fetch：加载集合使用的sql语句种类
			select ： 普通的select查询
			join：表链接语句
			subselect：子查询加载

### join语句的规则

其各有四条记录，其中有两条记录是相同的，如下所示：

|id| name|  id|  name|
|---|---|---|----|
|1|Tom| 1|Rutabaga|
|2|Jack| 2|Jerry|
|3|Rose| 3|Tom|
|4|Jerry |4|Ninja|

那么对应的join语句有如下五种情况：

| 语句 | sql结果 |图形表示|
|---|---|---|
|SELECT * FROM TableA INNER JOIN TableB ON TableA.name = TableB.name|| ![inner_join][1]|
|SELECT * FROM TableA FULL OUTER JOIN TableB ON TableA.name = TableB.name|| ![full_outer_join][2]|
|SELECT * FROM TableA LEFT OUTER JOIN TableB ON TableA.name = TableB.name|| ![left_outer_join][3]|
|SELECT * FROM TableA LEFT OUTER JOIN TableB ON TableA.name = TableB.nameWHERE TableB.id IS null|| ![left_outer_isnull][4]|
|SELECT * FROM TableA FULL OUTER JOIN TableB ON TableA.name = TableB.nameWHERE TableA.id IS null ORTableB.id IS null||![full_join_isnull][5]|


## HQL详解


## 使用C3P0的连接池
先导入c3p0的jar包，再更改hibernate.cfg中的：
``` xml
<property name="hibernate.connection.provider_class">org.hibernate.connection.C3P0ConnectionProvider</property>
```

同时还可以配置更多的C3P0的属性，如下：

#hibernate.c3p0.max_size 2
#hibernate.c3p0.min_size 2
#hibernate.c3p0.timeout 5000
#hibernate.c3p0.max_statements 100
#hibernate.c3p0.idle_test_period 3000
#hibernate.c3p0.acquire_increment 2
#hibernate.c3p0.validate false


## 数据库的锁

解决并发问题

悲观锁：
	读锁：select * from t_xxxx lock in share mode; (该锁可被所有人使用)
	写锁：select * from t_xxxx for update; (该锁会造成阻塞)

乐观锁：
	使用乐观锁时，每个table中都要添加version字段，用于hibernate每次commit校验。只有version值小于事物开启前的值方可进行提交。

## 一对一多表设计


## 二级缓存
二级缓存是进程级别的缓存。

1.一级缓存的主要优化手段是快照。

添加缓存的方式：
``` xml
	<!-- 启用二级缓存 -->
	<property name="hibernate.cache.use_second_level_cache">true</property>
	<!-- 缓存的提供类 ehcache -->
	<property name="hibernate.cache.provider_class">org.hibernate.cache.EhCacheProvider</property>
	<!-- 哪个类需要缓存 -->
	<class-cache usage="read-only" class="com.lsh.hibernate.domain.Student"/>
```

### 类缓存区

类缓存的方式：
类缓存并非将数据一对象的形式缓存，而是缓存成散列数据，在一级缓存中组装成对象。

### 集合缓存区

集合缓存的方式：
集合缓存会将集合中每个对象的id存放起来，在使用时去类缓存中查询，集合缓存，也必须声明缓存集合中的元素。

``` xml
	<class-cache usage="read-only" class="com.lsh.hibernate.domain.Course"/>
	<collection-cache usage="read-only" collection="com.lsh.hibernate.domain.Student.courses"/>
```

### 查询缓存区

对HQL语句进行缓存，通过`setCachable(true)`开启查询缓存。
查询缓存会将查询到的结果的id存储起来，再此查询的时候通过id到类缓存中查找。

查询缓存内部是将HQL语句所对应的SQL语句与要缓存的id一同存储起来，
所以“select c from Customer c”与"from Customer"会得到相同的结果。


## 小知识点

1、Hibernate中配置集合不一定只使用set，使用bag可以通过order-by参数添加排序方式
<bag name="replies" cascade="save-update" order-by="id asc">
			<key column="tid"></key>
			<one-to-many class="Reply" />
</bag>

2、Hibernate配置bean中的类型与sql中的类型
![类型对应][6]

  [1]: /img/2017-2-13-Hibernate/inner_join.png "inner_join.png"
  [2]: /img/2017-2-13-Hibernate/full_outer_join.png "full_outer_join.png"
  [3]: /img/2017-2-13-Hibernate/left_outer_join.png "left_outer_join.png"
  [4]: /img/2017-2-13-Hibernate/left_outer_isnull.png "left_outer_isnull.png"
  [5]: /img/2017-2-13-Hibernate/full_join_isnull.png "full_join_isnull.png"
  [6]: /img/2017-2-13-Hibernate/hibernate中属性的对应参数.png "hibernate中属性的对应参数.png"