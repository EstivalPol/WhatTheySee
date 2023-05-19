import 'package:flutter/material.dart';
import 'package:whattheysee/widgets/utilviews/toggle_theme_widget.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Favorites"),
          actions: const <Widget>[ToggleThemeButton()],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.movie),
              ),
              Tab(
                icon: Icon(Icons.tv),
              ),
            ],
          ),
        ),
        body: Container(),
        /*ScopedModelDescendant<AppModel>(
          builder: (context, child, AppModel model) => TabBarView(
            children: <Widget>[
              _FavoriteList(model.favoriteMovies),
              _FavoriteList(model.favoriteShows),
            ],
          ),
        ),*/
      ),
    );
  }
}
