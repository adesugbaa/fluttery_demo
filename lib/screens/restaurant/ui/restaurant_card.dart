import 'package:flutter/material.dart';



class RestaurantCard extends StatelessWidget {

  final String headImageAssetPath;
  final IconData icon;
  final Color iconBackgroundColor;
  final String title;
  final String subtitle;
  final int heartCount;

  const RestaurantCard({
    this.headImageAssetPath,
    this.icon,
    this.iconBackgroundColor,
    this.title,
    this.subtitle,
    this.heartCount,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
      child: Card(
        elevation: 10.0,
        child: Column(
          children: [
            Image.asset(
              headImageAssetPath,
              width: double.infinity,
              height: 150.0,
              fit: BoxFit.cover,
            ),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: iconBackgroundColor,
                      borderRadius: BorderRadius.all(const Radius.circular(15.0))
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                    ),
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'mermaid',
                          fontSize: 25.0,
                        ),
                      ),

                      Text(
                        subtitle,
                        style: TextStyle(
                          fontFamily: 'bebas-neue',
                          fontSize: 16.0,
                          letterSpacing: 1.0,
                          color: const Color(0xFFAAAAAA),
                        ),
                      )
                    ]
                  ),
                ),

                Container(
                  width: 2.0, 
                  height: 70.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.white,
                        const Color(0xFFAAAAAA)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                    )
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                      ),

                      Text(
                        '$heartCount',
                        style: TextStyle(
                          fontFamily: 'bebas-neue',
                          fontSize: 13.0,
                        ),
                      )
                    ]
                  ),
                )
              ]
            )
          ]
        ),
      ),
    );
  }
}
