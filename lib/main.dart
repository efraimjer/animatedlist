import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final listData = [
    UserModel(0, 'govind', 'dixit', false),
    UserModel(1, 'Greta', 'Stoll', false),
    UserModel(2, 'Monty', 'Carlo', false),
    UserModel(3, 'Petey', 'Cruiser', false),
    UserModel(4, 'Barry', 'Cade', true),
  ];

  final initialListSize = 5;

  void addUser() {
    setState(() {
      var index = listData.length;
      listData.add(UserModel(++_maxIdValue, 'New', 'Person', false));
      _listKey.currentState!
          .insertItem(index, duration: const Duration(milliseconds: 300));
    });
  }

  void deleteUser(int id) {
    setState(() {
      final index = listData.indexWhere((element) => element.id == id);
      var user = listData.removeAt(index);
      _listKey.currentState!.removeItem(index, (context, animation) {
        return FadeTransition(
          opacity: CurvedAnimation(
              parent: animation, curve: const Interval(0.5, 1.0)),
          child: SizeTransition(
            sizeFactor: CurvedAnimation(
                parent: animation, curve: const Interval(0.0, 1.0)),
            axisAlignment: 0.0,
            child: _buildItem(user),
          ),
        );
      }, duration: const Duration(milliseconds: 600));
    });
  }

  void checkUser(int id) {
    final index = listData.indexWhere((element) => element.id == id);

    setState(() {
      listData[index].checked
          ? listData[index].checked = false
          : listData[index].checked = true;
    });

    print(listData[index].checked);
  }

  Widget _buildItem(UserModel user) {
    return ListTile(
      // tileColor: user.checked ? Colors.green[300] : null,
      onTap: () => checkUser(user.id),
      key: ValueKey<UserModel>(user),
      title: Text(
        user.firstName,
        style: TextStyle(
            decoration:
                user.checked ? TextDecoration.lineThrough : TextDecoration.none,
            decorationColor: Colors.red,
            decorationThickness: 3),
      ),
      subtitle: Text(user.lastName),
      leading: const CircleAvatar(
        child: Icon(
          Icons.shopping_basket_outlined,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => deleteUser(user.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('AnimatedList'),
          actions: [
            IconButton(onPressed: addUser, icon: const Icon(Icons.add))
          ],
        ),
        body: SafeArea(
          child: AnimatedList(
              key: _listKey,
              initialItemCount: 5,
              itemBuilder: (context, index, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: _buildItem(listData[index]),
                );
              }), // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}

class UserModel {
  UserModel(this.id, this.firstName, this.lastName, this.checked);

  final int id;
  final String firstName;
  final String lastName;
  bool checked;
}

int _maxIdValue = 4;
