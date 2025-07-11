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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MultiProvider(providers: [
        ChangeNotifierProvider<CountProvider>.value(value: CountProvider()),
        // Add other providers here if needed
      ],
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Provider Demo'),
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
      
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyCountPage extends StatelessWidget {
  const MyCountPage({super.key});

  @override
  Widget build(BuildContext context) {
    CountProvider _state = Provider.of<CountProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Change Notifier Example', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text('${_state.counterValue}', style: Theme.of(context).textTheme.displayMedium),
            OverflowBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.remove),
                  color: Colors.red,
                  onPressed: () => _state._decrementCount(),                 
                ),
                Consumer<CountProvider>(
                  builder: (context, value, child) {
                    return IconButton(
                  icon: const Icon(Icons.add),
                  color: Colors.green,
                  onPressed: () => _state._incrementCount(),
                  
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
  int _count = 0;

  int get counterValue => _count;

  void _incrementCount() {
    _count++;
    notifyListeners();
  }

  void _decrementCount() {
    if (_count > 0) {
      _count--;
      notifyListeners();
    }
  }
}




