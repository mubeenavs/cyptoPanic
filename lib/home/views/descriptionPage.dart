import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cryptoPanic/constants/constants.dart';

/// create a stateless widget to show the description of each news
class DescriptionPage extends StatelessWidget {
  const DescriptionPage({this.state, this.index});
  final state;
  final index;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlack,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  state.results[index].title,
                  style: kCommonStyle,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(
                        color: kBlue,
                        Icons.link_outlined,
                        size: 15.0,
                      ),

                      ///launching corresponding news site for detailed view
                      TextButton(
                          onPressed: () {
                            launchUrl(Uri.parse(
                                'https://${state.results![index].source?.domain}'));
                          },
                          child: Text(
                            '${state.results![index].domain}',
                            style: kDomainStyle,
                          )),
                    ],
                  ),
                  const Icon(
                    Icons.thumb_up,
                    color: kColor,
                    size: 10.0,
                  ),
                  Text(
                    '${state.results![index].votes.liked}',
                    style: kVoteStyle,
                  ),
                  const Icon(
                    Icons.thumb_down,
                    color: kColor,
                    size: 10.0,
                  ),
                  Text(
                    '${state.results![index].votes.disliked}',
                    style: kVoteStyle,
                  ),
                  const Icon(
                    Icons.emoji_emotions,
                    color: kColor,
                    size: 10.0,
                  ),
                  Text(
                    '${state.results![index].votes.lol}',
                    style: kVoteStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
