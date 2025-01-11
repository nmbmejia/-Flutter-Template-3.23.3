import 'package:Acorn/pages/games/introduction.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/go.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomepageDefault extends StatefulWidget {
  const HomepageDefault({super.key});

  @override
  State<HomepageDefault> createState() => _HomepageDefaultState();
}

class _HomepageDefaultState extends State<HomepageDefault> {
  Widget learningModule({required String image, required String name}) {
    double height = 80;
    return GestureDetector(
      onTap: () {
        Go.to(const GameIntroduction());
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            margin: const EdgeInsets.only(bottom: 7),
            alignment: Alignment.centerLeft,
            height: height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            margin: const EdgeInsets.only(bottom: 7),
            alignment: Alignment.centerLeft,
            height: height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Colors.black87, Colors.transparent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            height: height,
            width: MediaQuery.of(context).size.width,
            child: Custom.header3(name, color: Colors.white, isBold: false),
          ),
        ],
      ),
    );
  }

  Widget gamesAndChallengesModule(
      {required String image, required String name}) {
    return Container(
        margin: const EdgeInsets.only(right: 10),
        alignment: Alignment.centerLeft,
        height: 250,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.black87,
                ),
                child: Center(child: Custom.subheader1(name)),
              ),
            )
          ],
        ));
  }

  Widget leaderboardWidget() {
    return ListTile(
      leading: const Icon(
        CupertinoIcons.profile_circled,
        color: Colors.black87,
        size: 42,
      ),
      title: Custom.subheader1(
        'Neil',
        color: Colors.black87,
      ),
      trailing: Text(
        '1,218pts',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey[700], // Adjust as per the design
        ),
      ),
      onTap: () {
        // Add any functionality when the tile is tapped
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //? Learning Modules
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Custom.header2(
              'Learning Modules',
              color: Colors.black87,
            ),
            const Icon(
              CupertinoIcons.forward,
              size: 28,
              color: Colors.black87,
            )
          ],
        ),
        VertSpace.fifteen(),
        learningModule(
            image: 'assets/images/lm_fabric.png', name: 'Fabrics & Fiber'),
        learningModule(
            image: 'assets/images/lm_handstitch.png',
            name: 'Basic Hand Stitches'),
        learningModule(
            image: 'assets/images/lm_sewing.png', name: 'Sewing Tools'),
        VertSpace.fifteen(),

        //? Games & Challenges
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Custom.header2(
              'Games and Challenges',
              color: Colors.black87,
            ),
            const Icon(
              CupertinoIcons.forward,
              size: 28,
              color: Colors.black87,
            )
          ],
        ),
        VertSpace.fifteen(),
        SizedBox(
          height: 250,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return gamesAndChallengesModule(
                  image: 'assets/images/gc_fiber.png',
                  name: 'Fiber Quest ${index + 1}');
            },
          ),
        ),

        VertSpace.fifteen(),

        //? Leaderboards
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Custom.header2(
              'Leaderboards',
              color: Colors.black87,
            ),
            const Icon(
              CupertinoIcons.forward,
              size: 28,
              color: Colors.black87,
            )
          ],
        ),
        VertSpace.fifteen(),

        ListView.builder(
          itemCount: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return leaderboardWidget();
          },
        ),
        VertSpace.fifteen(),
      ],
    );
  }
}
