---
title: 2017-1-31-Listener与Filter
date: 2017-1-31 14:25:24 
categories: Java EE
tags: [JavaEE]
layout: post
---

<!-- more -->
## jsonConfig

jsonConfig可以通过配置不需要的bean属性，在parse阶段过滤指定属性。

## 监听器Listener

实现对应的接口：

1、监听生命周期 （web.xml 配置listener）
HttpSessionListener

ServletContextListener

ServletRequestListener

2、监听属性添加 （web.xml 配置listener）
HttpSessionAttributeListener

ServletContextAttributeListener

ServletRequestAttributeListener

3、它是用于监听javaBean对象是否绑定到了session域，用于java bean实现接口得到通知
HttpSessionBindingListener

4、钝化和活化对象 bean实现 HttpSessionActivationListener

我们还需要个context.xml文件来配置钝化时存储的文件
在meta-inf目录下创建一个context.xml文件
``` xml
<Context>
	<Manager className="org.apache.catalina.session.PersistentManager" maxIdleSwap="1">
		<Store className="org.apache.catalina.session.FileStore" directory="存储的文件夹名"/>
	</Manager>
</Context>
```

## Filter 过滤器

Javaweb中的过滤器可以拦截所有访问web资源的请求或响应操作。

实现Filter后 需在web.xml中进行配置（类似servlet的配置）

``` java
	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		// 允许当前的request向下传递，不传递无法正常访问
		chain.doFilter(request, response);

	}
```

一个请求可以被多个Filter拦截，拦截的顺序是web.xml中的配置顺序，**第一个filter会在最后一个filter结束后结束**

生命周期：

在服务器启动时 init

在一个请求到来时 doFilter

在服务器结束时 destroy

### Filter拦截的配置

拦截指定的servlet(不用再写url-pattern)
``` xml
<filter-mapping>
		<filter-name>MyFilter2</filter-name>
		<servlet-name>xxxx</servlet-name>
</filter-mapping>
```


拦截一次request的转发和请求

filter会配置所拦截的所有方式
``` xml
<filter-mapping>
		<filter-name>MyFilter2</filter-name>
		<url-pattern>/*</url-pattern>
		<dispatcher>FORWARD</dispatcher>
		<dispatcher>REQUEST</dispatcher>
</filter-mapping>
```

## 编码方式

Java在其网络传输中使用的是iso-8859-1格式的编码。因为iso-8859-1是一种单字节只支持0-255的编码方式。

在JSP页面获取表单的值时会出现乱码，有两种解决方法：

1.post 在调用getParameter之前通过request.setCharacterEncoding设置字符编码

2.get 调用new String(str.getBytes("iso8859-1"), "UTF-8");编码后解码

``` java
// java判断是否可以解码
Charset.forName("UTF-8").newEncoder().canEncode(req.getParameter("id"))
```

**new String(str.getBytes("iso8859-1"), "UTF-8");该方法仅仅是在出现浏览器不以U8转换URL时才会使用到**

js中也可以将uri转换为u8格式的url

``` javascript
function enc(uri) {
	var u = encodeURI(uri);
	alert(u);
	location.href = u;
}
```

## 动态代理+aop

代理机制需要两个要素：1、被代理对象 2、代理对象

``` java
	public Object getPoxy() {
		// 被代理对象
		final MyFilter myFilter = new MyFilter();
		
		// 代理对象
		return Proxy.newProxyInstance(classLoader"被代理对象的加载器", interfaces[]“被代理对象所具有的接口对象”,invokeHandler“调用方法的处理类”);
	}
```

AOP 将对应的方法在调用前进行拦截，并穿插其他的信息，从而保证原调用方法不被改动
```java
	public Object getPoxy() {
		final MyFilter myFilter = new MyFilter();
		return Proxy.newProxyInstance(MyFilter.class.getClassLoader(), MyFilter.class.getInterfaces(),
				new InvocationHandler() {
					// 返回调用方法的结构
					public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
						...
						Object result = method.invoke(myFilter, args);
						...
						return result;
					}
				});
	}
```