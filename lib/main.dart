import 'package:flutter/material.dart';

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
              // MyUserPage(),
              // MyEventPage(),
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




