import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whattheysee/components/fade_up.dart';
import 'package:whattheysee/model/mediaitem.dart';
import 'package:whattheysee/util/mediaproviders.dart';
import 'package:whattheysee/util/utils.dart';
import 'package:whattheysee/widgets/media_list/media_list_item.dart';

class MediaList extends StatefulWidget {
  const MediaList(this.provider, this.category, this.title, {Key? key})
      : super(key: key);

  final MediaProvider provider;
  final String? category;
  final String? title;

  @override
  MediaListState createState() => MediaListState();
}

class MediaListState extends State<MediaList> {
  final List<MediaItem> _movies = [];
  int _pageNumber = 1;
  LoadingState _loadingState = LoadingState.LOADING;
  bool _isLoading = false;

  _loadNextPage() async {
    _isLoading = true;
    try {
      var nextMovies =
          await widget.provider.loadMedia(widget.category!, page: _pageNumber);
      setState(() {
        _loadingState = LoadingState.DONE;
        _movies.addAll(nextMovies);
        _isLoading = false;
        _pageNumber++;
      });
    } catch (e) {
      _isLoading = false;
      if (_loadingState == LoadingState.LOADING) {
        setState(() => _loadingState = LoadingState.ERROR);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return widget.title == null
        ? Center(child: _getContentSection())
        : Scaffold(
            appBar: AppBar(
              systemOverlayStyle: Get.theme.appBarTheme.systemOverlayStyle,
              title: Text(widget.title!),
              centerTitle: true,
            ),
            body: Center(
              child: _getContentSection(),
            ),
          );
    //return Center(child: _getContentSection());
  }

  Widget _getContentSection() {
    switch (_loadingState) {
      case LoadingState.DONE:
        return ListView.builder(
            itemCount: _movies.length,
            itemBuilder: (BuildContext context, int index) {
              if (!_isLoading && index > (_movies.length * 0.7)) {
                _loadNextPage();
              }

              return FadeUp(
                0.6,
                MediaListItem(_movies[index], false),
              );
            });
      case LoadingState.ERROR:
        return const Text('Sorry, there was an error loading the data!');
      case LoadingState.LOADING:
        return const CircularProgressIndicator();
      default:
        return Container();
    }
  }
}
