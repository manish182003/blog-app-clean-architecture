import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBlogs({required List<BlogModel> blogs});
  List<BlogModel> loadBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;
  BlogLocalDataSourceImpl(this.box);
  @override
  List<BlogModel> loadBlogs() {
    List<BlogModel> blogs = [];
    for (int i = 0; i < box.length; i++) {
      final Map<String, dynamic> blogMap =
          Map<String, dynamic>.from(box.get(i.toString()));
      blogs.add(BlogModel.fromMap(blogMap));
    }

    return blogs;
  }

  @override
  void uploadLocalBlogs({required List<BlogModel> blogs}) async {
    await box.clear();
    for (int i = 0; i < blogs.length; i++) {
      await box.put(i.toString(), blogs[i].toMap());
    }
  }
}
