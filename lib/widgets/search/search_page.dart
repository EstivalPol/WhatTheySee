import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:get/get.dart';
import 'package:whattheysee/components/ob_homecontroller.dart';
import 'package:whattheysee/model/searchresult.dart';
import 'package:whattheysee/util/api_client.dart';
import 'package:whattheysee/util/utils.dart';
import 'package:whattheysee/widgets/search/search_item.dart';
import 'package:rxdart/rxdart.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchScreen> {
  final ApiClient _apiClient = ApiClient();
  List<SearchResult>? _resultList = [];
  SearchBar? searchBar;
  LoadingState _currentState = LoadingState.WAITING;
  PublishSubject<String> querySubject = PublishSubject();
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    searchBar = SearchBar(
      controller: textController,
      setState: setState,
      buildDefaultAppBar: _buildAppBar,
      onSubmitted: querySubject.add,
    );

    super.initState();

    textController.addListener(() {
      querySubject.add(textController.text);
    });

    querySubject.stream
        .where((query) => query.isNotEmpty)
        .debounceTime(const Duration(milliseconds: 250))
        .distinct()
        .switchMap(
            (query) => Stream.fromFuture(_apiClient.getSearchResults(query)))
        .listen(_setResults);

    Future.delayed(Duration.zero, () {
      ObHomeController.to.changeTheme(false);
    });
  }

  void _setResults(List<SearchResult> results) {
    setState(() {
      _resultList = results;
      _currentState = LoadingState.DONE;
    });
  }

  @override
  void dispose() {
    super.dispose();
    querySubject.close();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar!.build(context),
      body: _buildContentSection(),
    );
  }

  Widget _buildContentSection() {
    switch (_currentState) {
      case LoadingState.WAITING:
        return const Center(child: Text("Search for movies, shows and actors"));
      case LoadingState.ERROR:
        return const Center(child: Text("An error occured"));
      case LoadingState.LOADING:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case LoadingState.DONE:
        return (_resultList == null || _resultList!.isEmpty)
            ? const Center(
                child: Text("Unforunately there aren't any matching results!"))
            : ListView.builder(
                itemCount: _resultList!.length,
                itemBuilder: (BuildContext context, int index) =>
                    SearchItemCard(_resultList![index]));
      default:
        return Container();
    }
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      systemOverlayStyle: Get.theme.appBarTheme.systemOverlayStyle,
      elevation: 0.5,
      title: const Text('Search Movies'),
      backgroundColor: Get.theme.primaryColor,
      actions: [
        searchBar!.getSearchAction(context),
      ],
    );
  }
}
