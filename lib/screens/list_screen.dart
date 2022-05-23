import 'package:demo_app/models/app_list.dart';
import 'package:demo_app/models/app_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:provider/provider.dart';

import 'common/offline_screen.dart';


// ignore: use_key_in_widget_constructors
class ListScreen extends StatefulWidget {
  static const routeName = '/listscreen';

  @override
  _AppsListScreenState createState() => _AppsListScreenState();
}

class _AppsListScreenState extends State<ListScreen> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _dataSource(int index) {
    switch(index) {
      case 0:
      // Requests
        return Consumer<AppList>(
          builder: (context, model, child) => _ProjectList(model.itemNames),);
      case 2:
      // Tasks
        return Consumer<AppList>(
          builder: (context, model, child) => _ProjectList(model.itemNames),);
      default:
      // Home
        return Consumer<AppList>(
          builder: (context, model, child) => _ProjectList(model.itemNames),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Demo App"),
            backgroundColor: Colors.blueGrey[900],
          ),
          body: OfflineBuilder(
            connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
                ) {
              if (connectivity == ConnectivityResult.none) {
                return const OfflineScreen();
              } else {
                return child;
              }
            },
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: RefreshIndicator(
                        onRefresh: () async {
                          return await Future.delayed(const Duration(seconds: 1));
                        },
                        child: _dataSource(_selectedIndex),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          extendBody: true,
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.import_export),
                label: 'Tab 1',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.task),
                label: 'Tab 2',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            onTap: _onItemTapped,
          ),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class _ProjectList extends StatefulWidget {
  final List<AppModel> list;
  const _ProjectList(this.list);

  @override
  State<_ProjectList> createState() => _ProjectListState();
}

class _ProjectListState extends State<_ProjectList> {
  @override
  Widget build(BuildContext context) {
    var itemNameStyle = Theme.of(context).textTheme.subtitle1;

    return ListView.builder(
      itemCount: widget.list.length,
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.apps, size: 20),
        title: Text(
          widget.list[index].title,
          style: itemNameStyle?.copyWith(fontSize: 15),
        ),
        onTap: () async {
          // move to selected screen
        },
      ),
    );
  }
}