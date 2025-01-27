import 'package:Acorn/pages/games/introduction.dart';
import 'package:Acorn/services/app_colors.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/go.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:Acorn/widgets/custom_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomepageDefault extends StatefulWidget {
  const HomepageDefault({super.key});

  @override
  State<HomepageDefault> createState() => _HomepageDefaultState();
}

class _HomepageDefaultState extends State<HomepageDefault> {
  Widget learningModule(dynamic module) {
    double height = 80;
    return GestureDetector(
      onTap: () {
        Go.to(GameIntroduction(module: module));
      },
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 7),
            height: height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: module['image'],
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 7),
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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            alignment: Alignment.centerLeft,
            height: height,
            width: MediaQuery.of(context).size.width,
            child: Custom.header3(module['title'],
                color: Colors.white, isBold: false),
          ),
        ],
      ),
    );
  }

  Widget gamesAndChallengesModule(dynamic module) {
    return GestureDetector(
      onTap: () {
        Go.to(GameIntroduction(module: module));
      },
      child: Container(
          margin: const EdgeInsets.only(right: 10),
          alignment: Alignment.centerLeft,
          height: 250,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: module['image'],
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                  ),
                  child: Center(child: Custom.subheader1(module['title'])),
                ),
              )
            ],
          )),
    );
  }

  Widget leaderboardWidget(
      {String user = 'User', int pts = 1, String game = 'Game 1'}) {
    return ListTile(
      leading: const Icon(
        CupertinoIcons.profile_circled,
        color: Colors.black87,
        size: 50,
      ),
      title: Custom.subheader1(
        game,
        color: Colors.black87,
        isBold: true,
      ),
      subtitle: Custom.body1(
        user,
        color: Colors.black.withOpacity(0.5),
      ),
      trailing: Text(
        '${pts}pts',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.greenColor, // Adjust as per the design
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
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('learning_modules')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.only(bottom: 7),
                  alignment: Alignment.centerLeft,
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[300], // Skeleton loader background color
                  ),
                  child: const Loader());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                  child: Text('No learning modules available.'));
            }

            final modules = snapshot.data!.docs;
            modules.sort((a, b) => a['title'].compareTo(b['title']));

            return ListView.builder(
              shrinkWrap: true,
              itemCount: modules.length,
              itemBuilder: (context, index) {
                final module = modules[index];
                return learningModule(module);
              },
            );
          },
        ),

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
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('games').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No games available.'));
              }

              final games = snapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: games.length,
                itemBuilder: (context, index) {
                  final game = games[index];
                  return gamesAndChallengesModule(game);
                },
              );
            },
          ),
        ),
        // SizedBox(
        //   height: 250,
        //   child: ListView.builder(
        //     shrinkWrap: true,
        //     scrollDirection: Axis.horizontal,
        //     itemCount: 10,
        //     itemBuilder: (context, index) {
        //       return gamesAndChallengesModule(
        //           image: 'assets/images/gc_fiber.png',
        //           name: 'Fiber Quest ${index + 1}');
        //     },
        //   ),
        // ),

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

        StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('games_scores').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            if (snapshot.hasError) {
              return Custom.body1('Error: ${snapshot.error}',
                  color: Colors.black87);
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Custom.body1('Empty leaderboard...',
                  color: Colors.black87);
            }

            // Create a map to hold the highest scores per game
            Map<String, Map<String, dynamic>> highestScores = {};

            for (var doc in snapshot.data!.docs) {
              final game = doc['game'];
              final score = doc['score'];
              final user = doc['user'];

              // Update the highest score for the game if necessary
              if (!highestScores.containsKey(game) ||
                  score > highestScores[game]!['score']) {
                highestScores[game] = {'score': score, 'user': user};
              }
            }

            List<Map<String, dynamic>> scoreboard = [];
            for (var entry in highestScores.entries) {
              scoreboard.add({
                'game': entry.key,
                'score': entry.value['score'],
                'user': entry.value['user']
              });
            }

            // Prepare the list of highest scores for display
            // List<Widget> scoreWidgets = highestScores.entries.map((entry) {
            //   return Custom.body1(
            //       '${entry.key}: ${entry.value['score']}pts by ${entry.value['user']}',
            //       color: Colors.black87);
            // }).toList();

            return Column(
              children: scoreboard
                  .map((score) => leaderboardWidget(
                      user: score['user'],
                      pts: score['score'],
                      game: score['game']))
                  .toList(),
            );
          },
        ),

        // ),
        VertSpace.fifteen(),
      ],
    );
  }
}
