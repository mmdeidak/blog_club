import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blog_club/data.dart';
import 'package:blog_club/carousel/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';

import 'gen/assets.gen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const defaultFontFamily = 'Avenir';

  @override
  Widget build(BuildContext context) {
    final primaryTextColor = Color(0xff2d253c);
    final secondaryTextColor = Color(0xff2d4379);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: defaultFontFamily,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Color(0xff376AED),
            textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        textTheme: TextTheme(
          titleMedium: TextStyle(
            color: secondaryTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          titleSmall: TextStyle(
            color: secondaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w200,
          ),
          headlineLarge: TextStyle(
            fontWeight: FontWeight.w700,
            color: primaryTextColor,
            fontSize: 24,
          ),
          headlineMedium: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
          bodyMedium: TextStyle(
            color: secondaryTextColor,
            fontSize: 12,
          ),
          bodySmall: TextStyle(
              color: Color(0xff7B8BB2),
              fontSize: 10,
              fontWeight: FontWeight.w700),
        ),
      ),
      home: Stack(
        children: [
          Positioned.fill(child: HomeScreen()),
          Positioned(bottom: 0, left: 0, right: 0, child: _BottomNavigation()),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final stories = AppDatabase.stories;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hi Jonathan!',
                      style: themeData.textTheme.titleMedium,
                    ),
                    Image.asset(
                      'assets/img/icons/notification.png',
                      height: 32,
                      width: 32,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 0, 16),
                child: Text(
                  'Explore today\'s',
                  style: themeData.textTheme.headlineLarge,
                ),
              ),
              _StoryList(stories: stories),
              SizedBox(height: 16),
              _CategoryList(),
              _PostList(),
              SizedBox(
                height: 32,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _StoryList extends StatelessWidget {
  const _StoryList({required this.stories});

  final List<StoryData> stories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: stories.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final story = stories[index];
            return _StoryItem(story: story);
          },
        ),
      ),
    );
  }
}

class _StoryItem extends StatelessWidget {
  const _StoryItem({required this.story});

  final StoryData story;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(4, 2, 4, 0),
      child: Column(
        children: [
          Stack(
            children: [
              story.isViewed
                  ? _ProfileImageVisited(story: story)
                  : _ProfileImageNormal(story: story),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  'assets/img/icons/${story.iconFileName}',
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(story.name),
        ],
      ),
    );
  }
}

class _ProfileImageNormal extends StatelessWidget {
  const _ProfileImageNormal({required this.story});

  final StoryData story;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff376AED), Color(0xff49B0E2), Color(0xff9CECFB)],
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: _ProfileImage(story: story),
        ),
      ),
    );
  }
}

class _ProfileImageVisited extends StatelessWidget {
  const _ProfileImageVisited({required this.story});

  final StoryData story;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      height: 68,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          strokeWidth: 2,
          color: Color(0xff7B8BB2),
          dashPattern: [8, 3],
          radius: Radius.circular(24),
          padding: EdgeInsets.all(6),
        ),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
          child: _ProfileImage(story: story),
        ),
      ),
    );
  }
}

class _ProfileImage extends StatelessWidget {
  const _ProfileImage({required this.story});

  final StoryData story;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(17),
      child: Image.asset('assets/img/stories/${story.imageFileName}'),
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList();

  @override
  Widget build(BuildContext context) {
    final categories = AppDatabase.categories;
    return CarouselSlider.builder(
      itemCount: categories.length,
      itemBuilder: (context, index, realIndex) {
        return _CategoryItem(
          left: realIndex == 0 ? 32 : 8,
          right: realIndex == categories.length - 1 ? 32 : 8,
          category: categories[realIndex],
        );
      },
      options: CarouselOptions(
          viewportFraction: 0.8,
          aspectRatio: 1.2,
          disableCenter: true,
          enableInfiniteScroll: false,
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.height,
          scrollPhysics: BouncingScrollPhysics()),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final Category category;
  final double left;
  final double right;

  const _CategoryItem({
    required this.category,
    required this.left,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(left, 0, right, 0),
      child: Stack(
        children: [
          Positioned.fill(
            top: 64,
            right: 64,
            left: 64,
            bottom: 24,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(blurRadius: 20, color: Color(0xaa0d253c))
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              margin: EdgeInsets.fromLTRB(8, 0, 8, 16),
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: LinearGradient(
                  colors: [Color(0xff0D253C), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Image.asset(
                  'assets/img/posts/large/${category.imageFileName}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 48,
            left: 40,
            child: Text(
              category.title,
              style: Theme.of(
                context,
              ).textTheme.headlineLarge!.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostList extends StatelessWidget {
  const _PostList();

  @override
  Widget build(BuildContext context) {
    final posts = AppDatabase.posts;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latest News',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextButton(
                onPressed: () {},
                child: Text('More'),
              ),
            ],
          ),
        ),
        ListView.builder(
            physics: ClampingScrollPhysics(),
            itemCount: posts.length,
            itemExtent: 140,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final post = posts[index];
              return _PostItem(post: post);
            })
      ],
    );
  }
}

class _PostItem extends StatelessWidget {
  const _PostItem({
    required this.post,
  });

  final PostData post;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(32, 8, 32, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Color(0x1a5282FF),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset('assets/img/posts/small/${post.imageFileName}'),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.caption,
                    style: TextStyle(
                      color: Color(0xff376AED),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    post.title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        CupertinoIcons.hand_thumbsup,
                        size: 16,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        post.likes,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Icon(
                        CupertinoIcons.clock,
                        size: 16,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        post.time,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            post.isBookmarked
                                ? CupertinoIcons.bookmark_fill
                                : CupertinoIcons.bookmark,
                            size: 16,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Color(0xff9B8487).withValues(alpha: 0.3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _BottomNavigationItem(
                      iconFileName: 'Home.png',
                      activeIconFileName: 'Home.png',
                      title: 'Home'),
                  _BottomNavigationItem(
                      iconFileName: 'Articles.png',
                      activeIconFileName: 'Articles.png',
                      title: 'Articles'),
                  SizedBox(
                    width: 4,
                  ),
                  _BottomNavigationItem(
                      iconFileName: 'Search.png',
                      activeIconFileName: 'Search.png',
                      title: 'Search'),
                  _BottomNavigationItem(
                      iconFileName: 'Menu.png',
                      activeIconFileName: 'Menu.png',
                      title: 'Menu')
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 4),
                borderRadius: BorderRadius.circular(32.5),
                color: Color(0xff376AED),
              ),
              child: Assets.img.icons.plus.image(),
            ),
          )
        ],
      ),
    );
  }
}

class _BottomNavigationItem extends StatelessWidget {
  const _BottomNavigationItem(
      {required this.iconFileName,
      required this.activeIconFileName,
      required this.title});

  final String iconFileName;
  final String activeIconFileName;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset('assets/img/icons/$iconFileName'),
          SizedBox(
            height: 4,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      ),
    );
  }
}
