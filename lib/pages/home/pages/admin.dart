import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomepageAdmin extends StatefulWidget {
  const HomepageAdmin({super.key});

  @override
  State<HomepageAdmin> createState() => _HomepageAdminState();
}

class _HomepageAdminState extends State<HomepageAdmin> {
  Widget adminPanel({required String name, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 7),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9),
            border:
                Border.all(width: 1.5, color: Colors.grey.withOpacity(0.45))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Custom.subheader1(
              name,
              color: Colors.black87,
            ),
            const Icon(
              CupertinoIcons.forward,
              size: 28,
              color: Colors.black87,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VertSpace.fifteen(),

        //? Learning Modules
        adminPanel(
          name: 'List of Learning Modules',
          onTap: () {},
        ),

        //? Games & Challenges
        adminPanel(
          name: 'List of Games & Challenges',
          onTap: () {},
        ),

        //? Users
        adminPanel(
          name: 'List of Users',
          onTap: () {},
        ),

        //? Reports
        adminPanel(
          name: 'Reports',
          onTap: () {},
        ),
      ],
    );
  }
}
