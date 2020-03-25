import 'package:banner_view/banner_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cn/net/Api.dart';
import 'package:flutter_cn/net/Http.dart';
import 'package:flutter_cn/bean/news_list_bean_entity.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewsListPage extends StatefulWidget {
  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  int _curPage = 1;
  var listData = [];
  var bannerData = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsList(_curPage);
    getBannerList();
  }

  @override
  Widget build(BuildContext context) {
    if (listData.length == 0) {
      return new Center(
        child: new CircularProgressIndicator(
          backgroundColor: Colors.green,
        ),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text(
              "文章",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
          body: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: WaterDropHeader(),
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Text("刷新完成");
                } else if (mode == LoadStatus.loading) {
                  body = CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Text("加载失败，点击重新加载");
                } else if (mode == LoadStatus.canLoading) {
                  body = Text("释放刷新");
                } else {
                  body = Text("没有更多数据");
                }
                return Container(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: ListView.builder(
              itemBuilder: (c, i) => renderRow(i),
              itemCount: listData.length,
            ),
          ));
    }
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    if (mounted)
      setState(() {
        _curPage = 1;
        getBannerList();
        getNewsList(_curPage);
      });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted)
      setState(() {
        _curPage++;
        getNewsList(_curPage);
      });
    _refreshController.loadComplete();
  }

  void getNewsList(int curPage) {
    var url = Api.HOME_ARTICLE + curPage.toString() + "/json";
    Http.get(url,saveCookie: false).then((data) {
      setState(() {
        NewsListBeanData resultDatas = NewsListBeanData.fromJson(data);
        if (curPage == 1) {
          listData.clear();
          listData.addAll(resultDatas.datas);
        } else {
          listData.addAll(resultDatas.datas);
        }
      });
    });
  }

  void getBannerList() {
    Http.get(Api.HOME_BANNER).then((data) {
      setState(() {
        bannerData.addAll(data);
      });
    });
  }

  // banner图片
  List<Widget> getBannerChild(BuildContext context, List slideData) {
    List<Widget> items = [];
    if (slideData != null && slideData.length > 0) {
      for (var i = 0; i < slideData.length; i++) {
        var item = slideData[i];
        var imgUrl = item['imagePath'];
        var title = item['title'];
        var detailUrl = item['url'];
        items.add(new GestureDetector(
          onTap: () {
            // 详情跳转
//              Navigator.of(context)
//                  .push(new MaterialPageRoute(builder: (context) {
//                return new NewsDetailPage(detailUrl, title);
//              }));
          },
          child: new Stack(
            children: <Widget>[
              new Image.network(imgUrl),
              new Container(
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0x50000000),
                  child: new Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new Text(title,
                        maxLines: 1,
                        style:
                            new TextStyle(color: Colors.white, fontSize: 15.0)),
                  )),
            ],
          ),
        ));
      }
      return items;
    }
  }

  renderRow(int i) {
    // 得到列表item的数据
    if (i == 0) {
      if (bannerData != null && bannerData.length > 0) {
        return new Container(
          alignment: Alignment.center,
          height: 200.0,
          child: new BannerView(getBannerChild(context, bannerData),
              intervalDuration: const Duration(seconds: 3),
              animationDuration: const Duration(milliseconds: 500)),
        );
      }
    }

    i -= 1;
    var itemData = listData[i];

    var titleRow = new Row(
      children: <Widget>[
        new Expanded(child: Text(itemData.title, style: titleTextStyle))
      ],
    );

    var timeRow = new Row(
      children: <Widget>[
        new Container(
          child: new Text(
            itemData.superChapterName,
            style: subtitleStyle,
          ),
        ),
        // 这是时间文本
        new Padding(
          padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
          child: new Text(
            itemData.niceDate,
            style: subtitleStyle,
          ),
        ),
        // 这是评论数，评论数由一个评论图标和具体的评论数构成，所以是一个Row组件
        new Expanded(
          flex: 1,
          child: new Row(
            // 为了让评论数显示在最右侧，所以需要外面的Expanded和这里的MainAxisAlignment.end
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Text("${itemData.zan}", style: subtitleStyle),
              new Padding(
                padding: new EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                child: new Image.asset(
                    itemData.collect
                        ? './images/ic_is_like.png'
                        : './images/ic_un_like.png',
                    width: 16.0,
                    height: 16.0),
              )
            ],
          ),
        )
      ],
    );

    var row = new Row(
      children: <Widget>[
        // 左边是标题，时间，评论数等信息
        new Expanded(
          flex: 1,
          child: new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Container(
                      child: Text("${itemData.shareUser}", style: authorStyle),
                      margin: new EdgeInsets.fromLTRB(0.0, 0.0, 2.0, 0.0),
                    ),
                    new Text(
                      '${itemData.author}',
                      style: authorStyle,
                    )
                  ],
                ),
                new Container(
                  margin: new EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 6.0),
                  child: titleRow,
                ),
                new Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                  child: timeRow,
                )
              ],
            ),
          ),
        ),
      ],
    );
    //InkWell实现点击出现水波纹的效果
    return new InkWell(
      child: row,
      onTap: () {},
    );
  }

  // 时间文本的样式
  TextStyle subtitleStyle =
      new TextStyle(color: const Color(0xFFB5BDC0), fontSize: 12.0);

  //  作者style
  TextStyle authorStyle =
      new TextStyle(color: const Color(0xFF000000), fontSize: 12.0);

  // 列表中资讯标题的样式
  TextStyle titleTextStyle = new TextStyle(fontSize: 15.0);
}
