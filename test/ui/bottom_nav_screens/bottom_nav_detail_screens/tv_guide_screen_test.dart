import 'package:first_app/model/tv_guide_item.dart';
import 'package:first_app/utility/common_methods.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tvGuideItemListTest = [
    TvGuideDetails(movieName: "X-Men", rating: 3),
    TvGuideDetails(movieName: "Inception", rating: 5),
    TvGuideDetails(movieName: "Harry Potter", rating: 1),
  ];

  setUp(() => () {
        print("SETUP");
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
        print("##### ${list[0].movieName}");
        resultList = list;
      });
      expect(resultList[0].movieName?[0], "X");
    });

    test('Test Sorting function by movie name in ascending order', () {
      List<TvGuideDetails> resultList = [];

      CommonMethods.sorting(1, tvGuideItemListTest,
          (List<TvGuideDetails> list) {
        print("##### ${list[0].movieName}");
        resultList = list;
      });
      expect(resultList[0].movieName?[0], "H");
    });

    test('Test Searching function by movie name', () {
      List<TvGuideDetails> resultList = [];

      CommonMethods.runSearch("X-", tvGuideItemListTest,
          (List<TvGuideDetails> list) {
        print("##### ${list[0].movieName}");
        resultList = list;
      });
      expect(resultList[0].movieName?[0], "X");
    });
  });
}

/*
To get the widget state in unit test

   List<TvGuideDetails> resultList = [];
    final sut = TvGuideScreen();
    final element = sut.createElement();
    TvGuideScreenState state = element.state as TvGuideScreenState;
 */
