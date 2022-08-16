import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:superformula_flutter_test/blocs/restaurant_list/restaurant_list_bloc.dart';
import 'package:superformula_flutter_test/models/restaurant.dart';
import 'package:superformula_flutter_test/superformula_app.dart';
import 'package:superformula_flutter_test/widgets/no_data_found_widget.dart';
import 'utils/mock_network_provider.dart';

void main() {
  late MockNetworkProvider mockNetworkProvider;

  setUp(() {
    mockNetworkProvider = MockNetworkProvider();
  });

  testWidgets('All Restaurants list shows message when no data is found', (WidgetTester tester) async {
    final RestaurantResult mockRestaurantResult = RestaurantResult(total: 0, restaurants: []);

    when(() => mockNetworkProvider.fetchRestaurants()).thenAnswer((_) async => mockRestaurantResult);

    final RestaurantListBloc restaurantListBloc = RestaurantListBloc(mockNetworkProvider);

    await tester.pumpWidget(SuperformulaApp(restaurantListBloc: restaurantListBloc));

    restaurantListBloc.add(FetchRestaurants(0));

    await tester.pumpAndSettle();

    expect(find.text(NoDataFoundWidget.text), findsOneWidget);
  });

  testWidgets('loading indicator is displayed while waiting for restaurants', (WidgetTester tester) async {
    final RestaurantResult mockRestaurantResult = RestaurantResult(total: 0, restaurants: []);

    when(() => mockNetworkProvider.fetchRestaurants()).thenAnswer((_) async {
      await Future.delayed(Duration(seconds: 2));
      return mockRestaurantResult;
    });

    final RestaurantListBloc restaurantListBloc = RestaurantListBloc(mockNetworkProvider);

    await tester.pumpWidget(SuperformulaApp(restaurantListBloc: restaurantListBloc));

    restaurantListBloc.add(FetchRestaurants(0));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
  });
}
