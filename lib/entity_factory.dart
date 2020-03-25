import 'package:flutter_cn/bean/banner_bean_entity.dart';
import 'package:flutter_cn/bean/news_list_bean_entity.dart';
import 'package:flutter_cn/bean/test_bean_entity.dart';
import 'package:flutter_cn/bean/tree_bean_entity.dart';
import 'package:flutter_cn/bean/wx_bean_entity.dart';
import 'package:flutter_cn/bean/wx_fragment_bean_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "BannerBeanEntity") {
      return BannerBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "NewsListBeanEntity") {
      return NewsListBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "TestBeanEntity") {
      return TestBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "TreeBeanEntity") {
      return TreeBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "WxBeanEntity") {
      return WxBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "WxFragmentBeanEntity") {
      return WxFragmentBeanEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}