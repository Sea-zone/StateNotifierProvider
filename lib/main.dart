import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(Text('Home Page')),
    );
  }
}

//expose the data to state notifier provider
final numbersProvider =
    StateNotifierProvider<NumberNotifier, List<String>>((ref) {
  return NumberNotifier();
});

class NumberNotifier extends StateNotifier<List<String>> {
  NumberNotifier() : super(['number10', 'number40']);

  void add(String number) {
    state = [...state, number];
  }

  void remove(String number) {
    state = [...state.where((element) => element != number)];
  }

  void update(String number, String updatedNumber) {
    final updatedList = <String>[];
    for (var i = 0; i < state.length; i++) {
      if (state[i] == number) {
        updatedList.add(updatedNumber);
      } else {
        updatedList.add(state[i]);
      }
    }
    state = updatedList;
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage(Text text, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numbers = ref.watch(numbersProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text('Riverpod'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              ref
                  .read(numbersProvider.notifier)
                  .add('number ${Random().nextInt(100)}');
            },
            child: const Icon(Icons.add),
          ),
          body: Center(
            child: Column(
              children: numbers
                  .map((e) => GestureDetector(
                        onLongPress: () {
                          ref.read(numbersProvider.notifier).update(
                              e, '${e}' + Random().nextInt(100).toString());
                        },
                        onTap: () {
                          ref.read(numbersProvider.notifier).remove(e);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(e),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
