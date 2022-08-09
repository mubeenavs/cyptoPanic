import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'descriptionPage.dart';

import 'package:cryptoPanic/constants/constants.dart';
import 'package:cryptoPanic/home/bloc/home_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cryptoPanic/home/repository/repository.dart';

/// reusable widget for display the news
class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => HomeBloc(
              RepositoryProvider.of<HomeRepository>(context),
            )..add(LoadEvent()),
        child: Scaffold(
            body: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            Future.delayed(const Duration(seconds: 60), () {
              context.read<HomeBloc>().add(LoadEvent());
            });
          },
          builder: (contex, state) {
            if (state is LoadingState) {
              return Center(
                child: CircularProgressIndicator(
                  color: kCommonColor,
                ),
              );
            }
            if (state is LoadedState) {
              /// To refresh the page
              return ListView.builder(
                  itemCount: state.results!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          leading: Text(
                            timeago.format(
                                state.results![index].publishedAt
                                    .subtract(const Duration(minutes: 1)),
                                locale: 'en_short'),
                            style: kDomainStyle,
                          ),
                          title: Text(
                            /// list out the news title
                            '${state.results![index].slug}',
                            style: kCommonStyle,
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton.icon(
                                  icon: Icon(
                                    Icons.link_outlined,
                                    color: kColor,
                                    size: 15.0,
                                  ),
                                  onPressed: () {
                                    /// Navigate to Description page
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DescriptionPage(
                                                    index: index,
                                                    state: state)));
                                  },
                                  label: Text(
                                    /// display the Domain of the news
                                    '${state.results![index].domain}',
                                    style: kDomainStyle,
                                  )),

                              ///Display likes and dislikes
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
                          trailing: Text(
                            /// Display the currency of corresponding news
                            '${state.results![index].currencies?[0].code ?? ''}',
                            style: const TextStyle(
                              color: Colors.teal,
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                        )
                      ],
                    );
                  });
            }
            return Container();
          },
        )));
  }
}
