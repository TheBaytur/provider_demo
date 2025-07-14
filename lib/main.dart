import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider Demo',
      
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MultiProvider(providers: [
        ChangeNotifierProvider<CountProvider>.value(value: CountProvider()),
        // Add other providers here if needed
        FutureProvider(create: (_) async => 
        UserProvider().loadUserData(),
        initialData: [],),
      ],
      child: DefaultTabController(
        length: 3,
        child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Provider Demo'),
            centerTitle: true,
            backgroundColor: Colors.blue,
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(icon: Icon(Icons.add)),
                Tab(icon: Icon(Icons.person)),
                Tab(icon: Icon(Icons.message)),
              ],
            ),
          ),
          body: const TabBarView(
            children: <Widget>[
              MyCountPage(),
              MyUserPage(),
              MyEventPage(),
            ],
          ),
        ),
      ),
      ), 

      
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}



class MyCountPage extends StatelessWidget {
  const MyCountPage({super.key});

  @override
  Widget build(BuildContext context) {
    CountProvider state = Provider.of<CountProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Change Notifier Example', style: TextStyle(fontSize: 24)),
            SizedBox(height: 50),
            Text('${state.counterValue}', 
            style: Theme.of(context).textTheme.headlineMedium),
            OverflowBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.remove),
                  color: Colors.red,
                  onPressed: () {
                    state._decrementCount();  

                    if (state.counterValue < 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Count cannot be negative!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },                 
                ),
                Consumer<CountProvider>(
                  builder: (context, value, child) {
                    return IconButton(
                  icon: const Icon(Icons.add),
                  color: Colors.green,
                  onPressed: () {
                    
                    value._incrementCount();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Count incremented!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  
                );
                  },
                ),
                
              ],
            )
          ]
          
        ),
      ),      
    );
  }  
}

class MyUserPage extends StatelessWidget {
  const MyUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.all(10.0),
        child: Text('User Page', style: TextStyle(fontSize: 14)),
        ),
        Consumer<List<User>>(
          builder: (context, users, _) {
            return Expanded(
              child: users == null
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 50,
                    color: Colors.blueAccent,
                    child: Center(
                      child: Text('User ${users[index].name} ${users[index].nickname} ${users[index].email}', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  );
                },
              ),
            );
          },
        ),
        
      ],
    );
  }
}

class MyEventPage extends StatelessWidget {
  const MyEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Event Page', style: TextStyle(fontSize: 24)),
    );
  }
}

class CountProvider extends ChangeNotifier {
  int count = 0;

  int get counterValue => count;

  void _incrementCount() {
    count++;
    notifyListeners();
  }

  void _decrementCount() {
    if (count > 0) {
      count--;
      notifyListeners();
    }
  }
}

class UserProvider{
  final String _dataPath = 'assets/users.json';

  late List<User> users;

  Future<String> loadAsset () async {
    return await Future.delayed( Duration(seconds: 2), () async{
      return await rootBundle.loadString(_dataPath);
    });
  }
  Future<List<User>> loadUserData() async {
    var dataString = await loadAsset();
    Map<String, dynamic> jsonUserData = jsonDecode(dataString);
    users = UserList.fromJson(jsonUserData['users']).users;
    print('Loaded users' + jsonEncode(users));
    return users;
  }
}

class User {
  final String name;
  final String nickname;
  final String email;

  User({required this.name, required this.nickname, required this.email});

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        nickname = json['nickname'],
        email = json['email'];
}

class UserList {
  final List<User> users;

  UserList({required this.users});

UserList.fromJson(List<dynamic> usersJson) 
       :   users = usersJson.map((user) => User.fromJson(user)).toList();

  
}


