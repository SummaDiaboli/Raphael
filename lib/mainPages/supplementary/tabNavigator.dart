/* import 'package:flutter/material.dart';
import 'package:yafe/mainPages/homePage.dart';
import 'package:yafe/mainPages/mapPage.dart';
import 'package:yafe/mainPages/postPage.dart';

import 'package:yafe/mainPages/detailPages/detailedArticles.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

enum TabItem { articles, map, posts }

class TabHelper {
  static TabItem item({int index}) {
    switch (index) {
      case 0:
        return TabItem.articles;
      case 1:
        return TabItem.map;
      case 2:
        return TabItem.posts;
    }
    return TabItem.articles;
  }

  static Widget page(TabItem tabItem) {
    switch (tabItem) {
      case TabItem.articles:
        return HomePage();
      case TabItem.map:
        return MapPage();
      case TabItem.posts:
        return PostPage();
    }
    return HomePage();
  }
}

class TabNavigator extends StatelessWidget {
  TabNavigator({this.navigatorKey, this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  void _push(BuildContext context, {int materialIndex: 500}) {
    var routeBuilders = _routeBuilders(context);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                routeBuilders[TabNavigatorRoutes.detail](context)));
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      TabNavigatorRoutes.root: (context) => DetailedArticle(
            onPush: _push(context),
          ),
      TabNavigatorRoutes.detail: (context) => ColorDetailPage(
            color: TabHelper.color(tabItem),
            title: TabHelper.description(tabItem),
            materialIndex: materialIndex,
          ),
    };
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    return Navigator(
        key: navigatorKey,
        initialRoute: TabNavigatorRoutes.root,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
              builder: (context) => routeBuilders[routeSettings.name](context));
        });
  }
}
 */