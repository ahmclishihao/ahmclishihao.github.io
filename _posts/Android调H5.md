---
layout: post
title: "Android调H5"
date: 2016-11-07 02:21:05
categories: notes
---

# Android调H5

1.WebView

	可以加载链接，也可以加载本地网页
	加载assets文件夹中的网页：loadUrl("file:///android_asset/name")

2.java调js

	注意参数加‘’
	"javascript:jsName('"+params+"')"-->这是js的一种写法
	webView.loadUrl("javascript:jsName('"+params+"')");

3.js调java

	1.android
	声明js对应接口，webWiew.addJavascriptInterface(new Class(), "字段名")
	字段对应的android类中方法名需要添加注解@JavascriptInterface
	2.js
	window.字段名.方法名

# ScrollView结合ListView使用
	
结合使用会造成listview只显示一行，因为listview需要重新测量高度，两种方法进行测量。

1、重新测量每一项高度+divider的总高度最后得到精确值，
2、重写onMeasure方法，直接设置高度测量规则为，
	MeasureSpec.makeMeasureSpec(Integer.MAX_VALUE>>2,AT_MOST);
即给一个非常大的值让其自己适配
