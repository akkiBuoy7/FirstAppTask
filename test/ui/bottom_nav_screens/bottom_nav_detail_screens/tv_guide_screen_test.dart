import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:first_app/bloc/watchlist_bloc/tvguide_bloc.dart';
import 'package:first_app/model/tv_guide_item.dart';
import 'package:first_app/provider/NetworkProvider.dart';
import 'package:first_app/repository/tv_guide_repository.dart';
import 'package:first_app/ui/bottom_nav_screens/bottom_nav_detail_screens/tv_guide_screen.dart';
import 'package:first_app/utility/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRepository extends Mock implements TvGuideRepository {}

class MockNetworkProvider extends Mock implements NetworkProvider {}

late MockRepository mockRepository;
late TvGuideBloc tvGuideBloc;
late TvGuideRepository tvGuideRepository;

Future<void> main() async {
  final tvGuideItemListTest = [
    TvGuideDetails(movieName: "X-Men", rating: 3),
    TvGuideDetails(movieName: "Inception", rating: 5),
    TvGuideDetails(movieName: "Harry Potter", rating: 1),
  ];

  setUp(() {
    registerFallbackValue(TvGuideRepository());
    HttpOverrides.global = null;
    mockRepository = MockRepository();
    tvGuideBloc = TvGuideBloc(mockRepository);
    tvGuideRepository = TvGuideRepository();
  });

  group("Tv Guide Screen Methods", () {
    test('Test Filter function by rating in ascending order', () {
      List<TvGuideDetails> resultList = [];

      CommonMethods.rateFilter(2, tvGuideItemListTest,
          (List<TvGuideDetails> list) {
        print("##### ${list[0].rating}");
        resultList = list;
      });
      expect(resultList[0].rating, 1);
    });

    test('Test Filter function by rating in descending order', () {
      List<TvGuideDetails> resultList = [];

      CommonMethods.rateFilter(1, tvGuideItemListTest,
          (List<TvGuideDetails> list) {
        print("##### ${list[0].rating}");
        resultList = list;
      });
      expect(resultList[0].rating, 5);
    });

    test('Test Sorting function by movie name in descending order', () {
      List<TvGuideDetails> resultList = [];

      CommonMethods.sorting(2, tvGuideItemListTest,
          (List<TvGuideDetails> list) {
        print("1##### ${list[0].movieName}");
        resultList = list;
      });
      expect(resultList[0].movieName?[0], "X");
    });

    test('Test Sorting function by movie name in ascending order', () {
      List<TvGuideDetails> resultList = [];

      CommonMethods.sorting(1, tvGuideItemListTest,
          (List<TvGuideDetails> list) {
        print("2##### ${list[0].movieName}");
        resultList = list;
      });
      expect(resultList[0].movieName?[0], "H");
    });

    test('Test Searching function by movie name', () {
      List<TvGuideDetails> resultList = [];

      CommonMethods.runSearch("X-", tvGuideItemListTest,
          (List<TvGuideDetails> list) {
        print("3##### ${list[0].movieName}");
        resultList = list;
      });
      expect(resultList[0].movieName?[0], "X");
    });
  });

  group("tvGuideRepository test", () {
    test('Http call test for real repo', () async {
      HttpOverrides.global = null;
      List<TvGuideDetails>? resultList1 =
          await tvGuideRepository.fetchApiData();
      expect(resultList1.length, 20);
    });

    test('Http call test for fake repo', () async {
      HttpOverrides.global = null;
      when(() => mockRepository.fetchApiData())
          .thenAnswer((invocation) async => tvGuideItemListTest);
      var result = await mockRepository.fetchApiData();
      print(result.length);
      expect(result.length, 3);
    });
  });

  group("Bloc Test", () {
    void arrangeRepositoryReturnList() {
      when(() => mockRepository.fetchApiData())
          .thenAnswer((invocation) async => tvGuideItemListTest);
    }

    blocTest<TvGuideBloc, TvGuideState>('bloc test',
        setUp: arrangeRepositoryReturnList,
        build: () => tvGuideBloc,
        act: (bloc) => tvGuideBloc.add(TvGuideLoadedEvent()),
        expect: () => <TvGuideState>[
              TvGuideLoadingState(),

              TvGuideLoadedState(DateTime.now().minute, tvGuideItemListTest),
            ],
        verify: (_) async {
          verify((() => mockRepository.fetchApiData())).called(1);
        });
  });


  testWidgets('MyWidget has a title and message', (tester) async {
    await tester.pumpWidget( TvGuideScreen());


    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}



/*
To get the widget state in unit test

   List<TvGuideDetails> resultList = [];
    final sut = TvGuideScreen();
    final element = sut.createElement();
    TvGuideScreenState state = element.state as TvGuideScreenState;
 */
