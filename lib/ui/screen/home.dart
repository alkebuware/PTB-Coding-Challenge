import 'package:coding_challenge/bloc/ptbbloc_bloc.dart';
import 'package:coding_challenge/models/ptb.dart';
import 'package:coding_challenge/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: Container(
          color: Colors.black,
          height: 600,
          child: BlocBuilder<PTBBloc, PTBState>(
            builder: (context, state) {
              if (state is PTBErrorState) {
                return PTBError(state: state);
              } else if (state is PTBSuccessState) {
                return PTBSuccess(state: state);
              } else {
                return const PTBLoading();
              }
            },
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class PTBSuccess extends StatelessWidget {
  final PTBSuccessState state;

  const PTBSuccess({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
          child: Image.network(state.selectedItem.covers.first.url,
              fit: BoxFit.cover)),
      Positioned(
        bottom: 16,
        left: 16,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(state.selectedItem.label),
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(state.selectedItem.description)),
            PTBItemList(items: state.items, selectedItem: state.selectedItem)
          ],
        ),
      )
    ]);
  }
}

class PTBItemList extends StatelessWidget {
  final List<PTBItem> items;
  final PTBItem selectedItem;

  const PTBItemList({Key? key, required this.items, required this.selectedItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: 250, maxWidth: MediaQuery.of(context).size.width),
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (_, __) =>
              SizedBox.fromSize(size: const Size.fromWidth(16)),
          itemBuilder: (context, index) => PTBItemListIndex(
              item: items[index], selected: items[index] == selectedItem)),
    );
  }
}

class PTBItemListIndex extends StatelessWidget {
  final PTBItem item;
  final bool selected;

  const PTBItemListIndex({Key? key, required this.item, this.selected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SizedBox(
            width: 370,
            height: 200,
            child: Stack(
              children: [
                Positioned.fill(
                    child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child:
                      Image.network(item.covers.first.url, fit: BoxFit.cover),
                )),
                Positioned(
                    left: 8,
                    bottom: 16,
                    child: PTBBadgeIndicator(
                        badge: item.badge, highlight: selected)),
              ],
            ),
          ),
        ),
        Flexible(child: Text(item.label))
      ],
    );
  }
}

class PTBBadgeIndicator extends StatelessWidget {
  final PTBBadge badge;
  final bool highlight;

  const PTBBadgeIndicator(
      {Key? key, required this.badge, this.highlight = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = highlight ? badge.badgeBGFlutterColor : ptbGray;
    return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(7)),
        child: Text(badge.badgeText));
  }
}

class PTBLoading extends StatelessWidget {
  const PTBLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(color: Colors.white));
  }
}

class PTBError extends StatelessWidget {
  final PTBErrorState state;

  const PTBError({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Error loading, please try again"),
          ElevatedButton(
              onPressed: () =>
                  BlocProvider.of<PTBBloc>(context).add(PTBInitializeEvent()),
              child: const Text("Reload"))
        ]);
  }
}