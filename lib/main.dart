import 'package:blog_club/data.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

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
      home: HomeScreen(),
      theme: ThemeData(
        textTheme: TextTheme(
          titleMedium: TextStyle(
            fontFamily: defaultFontFamily,
            color: secondaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w200,
          ),
          headlineLarge: TextStyle(
            fontFamily: defaultFontFamily,
            fontWeight: FontWeight.w700,
            color: primaryTextColor,
            fontSize: 24,
          ),
          bodyMedium: TextStyle(
            fontFamily: defaultFontFamily,
            color: secondaryTextColor,
            fontSize: 12,
          ),
        ),
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
            return _Story(story: story);
          },
        ),
      ),
    );
  }
}

class _Story extends StatelessWidget {
  const _Story({required this.story});

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
