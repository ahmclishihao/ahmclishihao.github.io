---
layout: post
title: "SurfaceView的使用"
date: 2016-11-13 02:12:08
categories: Android
tags: [Android]
---

SurfaceView的基本逻辑
<!-- more -->

## SurfaceView

主要的类：
> SurfaceView 展示内容的地方
> 
> ↓	getHolder()
> 
> SurfaceHolder 展示的内容
> 
> ↓	addCallback() → getSurface() 获取 surface
> 
> SurfaceHolder.Callback
> 
> ↓	线程需要在surfaceCreate时创建，surfaceDestroy停止
> 
> Thread 持续展示内容的工人

## Surface

> lockCanvas 锁定画布 保证线程安全
> 
> ↓ 开启线程
> 
> 绘制界面 
> 
> unlockCanvasAndPost 解锁画布
> 
> ↓ 关闭线程

## 绘制背景

`每次一个对象重新绘制位置的时候都会造成叠加的效果`，
如何解决：是通过不断重新绘制背景来覆盖原来的图片

## Rect 矩形类

android提供的范围类，可以检测是否包含某点

## Cocos2dx
CCGLSurfaceView surfaceview类

CCDirector 导演类 （单例的）CCDirector.sharedDirector

CCScene 场景类 CCScene.node() 展示节点的根节点

CCLayer 图层类 CCSense.addChild() 添加图层

CCSprite 精灵类

默认图片放在asset中

坐标都是左下角开始的正常坐标系，Sprite的默认锚点在中间点
默认从锚点绘制

director可以和activity生命周期绑定，手动绑定(在各个周期内绑定)

## layer处理触摸事件 

> 都是在子线程中进行的，不能进行UI操作，当然surfaceView可以

layer事件中开启
setIsTouchEnabled(true);触摸事件开关

ccTOuchedBegan(event);按下事件

andorid坐标系的点转换为cocos中的点converTouchToNodeSpace

## CCNode

获取单元的范围:CGRect rect = ccNode.getBoundingBox();

获取单元的大小：CGSize size = ccNode.getBoundingBox().size;

将Android的MotionEvent转换成 Cocos2d上的点
CGPoint cgPoint = convertTouchToNodeSpace(event);


## CCAction

动作

CCSequence `串行动作` CCSequence.action(xx,xx);
CCSpawn `并行动作` 

CCRepeatForever 重复的动作，用于包装Action

CCEaseIn 具备加速的动作，用于包装Action

CCLabel 专门显示文字的sprite

ccColor3B 颜色渐变的action cc3(r,g,b);

xxxBy 事件都重写了reserver 而 xxxTo都没有重写reserver会报异常。例如：CCTintTo CCRotateTo CCJumpTo