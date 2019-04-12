import './menu-provider.dart';
import './order-provider.dart';

class Repository {
  final menuProvider = MenuProvider();
  final orderProvider = OrderProvider();

  menu() => menuProvider.menu();
  Stream<List<Map<String, dynamic>>> cart() => orderProvider.cart();
//  landmarksNearMe() => landmarksProvider.landmarksNearMe();
//  myTaxiRequests() => taxiProvider.myTaxiRequests();
//  myBuddies() => safetyNetworkProvider.safetyNetworkUsers();
}