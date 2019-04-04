## 背景
provide是谷歌官方出品的一个状态管理框架 [flutter-provide](https://github.com/google/flutter-provide)，它允许在小部件树中传递数据，它被设计为ScopedModel的替代品，允许我们更加灵活地处理数据类型和数据

## 为什么需要状态管理
在进行项目的开发时，我们往往需要管理不同页面之间的数据共享，在页面功能复杂，状态达到几十个上百个的时候，我们会难以清楚的维护我们的数据状态，本文将以主题切换这个功能使用状态管理来讲解如何在Flutter中使用provide这个状态管理框架

## 为什么选择Provide
一开始项目使用的是ScopedModel，使用ScopedModel可以分离展示逻辑和业务逻辑，而且简单易用，但是ScopedModel有一些局限
* 如果模型较为复杂，当状态更新时，会有较多的不必要的更新

使用Provide
* 当状态发生变化时，widget树会更新指定的节点，不会进行整颗widget树的更新
* Provide有泛型的优势，相当于namespace的特性，使用过vuex的应该知道namespace的重要性，它将我们的状态分离开来
* Provide被设计为ScopedModel的替代品，同样也有和ScopedModel的易用性
* Provide提供了Provide.stream可以以处理流的方式处理数据，不过目前还存在一些问题

## 项目地址
[flutter-ui](https://github.com/efoxTeam/flutter-ui), 可参考项目中使用provide方法

## 效果
![紫色主题](https://user-gold-cdn.xitu.io/2019/4/4/169e7ac09147b12a?w=1080&h=2280&f=jpeg&s=52924)

![绿色主题](https://user-gold-cdn.xitu.io/2019/4/4/169e7abb3eb4184c?w=1080&h=2280&f=jpeg&s=53331)
## 如何使用
### 添加依赖
查看 [pub-install](https://pub.dartlang.org/packages/provide#-installing-tab-)
* 在pubspec.yaml中引入依赖
``` dart
dependencies:
    provide: ^1.0.2 #数据管理层
```
* 执行
``` dart
flutter packages get
```
* 在需要使用的页面中引入
``` dart
import 'package:provide/provide.dart'
```

### 创建model （这才第一步）
新建 lib/store/models/config_state_model.dart 文件
``` dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier

class ConfigInfo {
    String theme = 'red';
}
class ConfigModel extends ConfigInfo with ChangeNotifier {
    Future $setTheme(payload) async {
        theme = payload;
        notifyListeners();
    }
}
```
用法同ScopedModel差不多，不过不需要继承Model类，只需要混入ChangeNotifier，通过notifyListeners通知听众刷新
### 封装Store （没错，到这里已经要快完成所有步骤了）
新建 lib/store/index.dart 文件
``` dart
import 'package:flutter/material.dart'
import 'package:provide/provide.dart'
    show
        Providers
        Provider,
        Provide,
        ProviderNode;
import './models/config_state_model.dart' show ConfigModel;

class Store {
    //  我们将会在main.dart中runAPP实例化init
    static init({model, child, dispose = true}) {
        final providers = Providers()
            ..provide(Provider.value(ConfigModel()));
        return ProviderNode(
            child: child,
            providers: providers,
            dispose: dispose
        );
    }
    
    //  通过Provide小部件获取状态封装
    static connect<T>({builder, child, scope}) {
        return Provide<T>(
            builder: builder,
            child: child,
            scope: scope
        );
    }
    
    //  通过Provide.value<T>(context)获取封装
    static T value<T>(context, {scope}) {
        return Provide.value<T>(context, scoped: scoped);
    }
}
```
需要管理多个状态只需要

final providers = Providers()
            ..provide(Provider.value(ConfigModel()))
            ..provide(Provider.value(More()));


### 定义全局的Provide （倒数第二）
lib/main.dart 文件
``` dart
import 'package:flutter/material.dart';
import 'package:efox_flutter/store/index.dart'
    show Store, ConfigModel;

// 将状态放入到顶层
void main() => runApp(Store.init(child: MainApp()));
class MainApp extends StatefulWidget {
    @override
    MainAppState createState() => MainAppState();
}
class MainAppState extends State<MainApp> {
    @override
    Widget build(BuildContext context) {
        //  获取Provide状态
        return Store.connect<ConfigModel>(
            builder: (context, child, model) {
                return MaterialApp(
                    theme: ThemeData(
                        primaryColor: Color(model.theme)
                    )
                );
            }
        );
    }
}

```

### 改变主题状态 （完成）
``` dart
import 'package:flutter/material.dart';
import 'package:efox_flutter/store/index.dart'
    show ConfigModel, Store;

/**
* name: 颜色名称 如 red
* color：颜色值
* context： 上下文
*/
Widget Edage(name, color, context) {
    return GestrueDetector(
        onTap: () {
            // 修改主题状态
            Store.value<ConfigModel>(context).$setTheme(name)
        }
        child: Container(
            color: Color(color),
            height: 30,
            widtg: 30
        )
    );
}
```

## 最后
欢迎更多学习flutter的小伙伴加入QQ群 Flutter UI： 798874340

敬请关注我们正在开发的：[efoxTeam/flutter-ui](https://github.com/efoxTeam/flutter-ui)