import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class MenuBloc {
  final _repository = Repository();
  final _menuFetcher = PublishSubject<Map<dynamic, dynamic>>();
  final _cartFetcher = PublishSubject<List<Map<String, dynamic>>>();

  Observable<Map<dynamic, dynamic>> get menu => _menuFetcher.stream.asBroadcastStream();
  Observable<List<Map<String, dynamic>>> get cart => _cartFetcher.stream.asBroadcastStream();

  fetchMenu() async {
    Map<dynamic, dynamic> menu = await _repository.menu();
    // print('Got menu');
    // print(menu);
    _menuFetcher.sink.add(menu);
  }

  fetchCart() {
    _repository.cart().listen((item) {
      // print('Got cart');
      // print(item);

      _cartFetcher.sink.add(item);
    });
  }

  dispose() {
    _menuFetcher.close();
  }

  disposeCart() {
    _cartFetcher.close();
  }
}

final menuBloc = MenuBloc();