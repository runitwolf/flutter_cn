import 'package:flutter/material.dart';
import 'package:flutter_cn/bean/tree_bean_entity.dart';
import 'package:flutter_cn/net/Http.dart';
import 'package:flutter_cn/net/Api.dart';

class TreePage extends StatefulWidget {
  @override
  _TreePageState createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> {
  var treeList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTreeData();
  }

  void _getTreeData() {
    Http.get(Api.HOME_Tree).then((res) {
      setState(() {
        treeList.addAll(res);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "体系",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),body: Container(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: treeList.length,
          itemBuilder: (c, i) => renderRow(i),
        )),
    );


  }

  renderRow(int i) {
    TreeBeanData datachild = TreeBeanData.fromJson(treeList[i]);
    Column column = Column(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(datachild.name,style: TextStyle(fontSize: 16),),
                  alignment: Alignment.centerLeft,
                ),
                new Container(
                  margin: new EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 1.0),
                  child: GridView(
                    scrollDirection: Axis.vertical,
                    // 滚动方向
                    cacheExtent: 40,
                    // 在超出边界指定值内，缓存item
                    shrinkWrap: true,
                    //为true可以解决子控件必须设置高度的问题
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(2),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        //主轴方向上，展示item的个数
                        mainAxisSpacing: 10,
                        // 主轴方向上，item之间间距  通过crossAxisCount和mainAxisSpacing就能确定主轴方向item的长度
                        crossAxisSpacing: 10,
                        // 纵轴方向上，item之间的距离
                        childAspectRatio: 1.5),
                    children: datachild.children
                        .map((item) => Container(
                      alignment: Alignment.center,
                              color: Colors.blue,
                              child: Text(
                                item.name,
                                style: TextStyle(fontSize: 12,color: Colors.white),
                              ),
                            ))
                        .toList(), //纵轴的高度=childAspectRatio*横轴的长度
                  ),
                ),
              ],
            ))
      ],
    );
//                  child: FlatButton(
//                      onPressed: () {},
//                      child: Text(_childStr(datachild.children))),
//                  color: Colors.blue,
//                  alignment: Alignment.centerLeft,
    return InkWell(
      child: column,
      onTap: () {},
    );
  }

  childRow(int i, List<TreeBeanDatachild> children) {
    Row childColum = Row(
      children: <Widget>[
        FlatButton(
          onPressed: () {},
          child: Text(children[i].name),
          color: Colors.blue,
        )
      ],
    );

    return InkWell(
      child: childColum,
      onTap: () {},
    );
  }
}
