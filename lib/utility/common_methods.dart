import '../model/tv_guide_item.dart';

class CommonMethods {
  static void rateFilter(
      int selectedFilter, List<TvGuideDetails> itemList, Function callback) {
    if (selectedFilter == 1) {
      itemList.sort((a, b) {
        return b.rating!.compareTo(a.rating!);
      });
      // Descending
      callback(itemList);
    } else {
      itemList.sort((a, b) {
        return a.rating!.compareTo(b.rating!);
      });
      // Ascending
      callback(itemList);
    }
  }

  static void sorting(
      int selectedFilter, List<TvGuideDetails> itemList, Function callback) {
    if (selectedFilter == 1) {
      itemList.sort((a, b) {
        //sorting in ascending order
        return a.movieName!.compareTo(b.movieName!);
      });
      callback(itemList);
    } else {
      itemList.sort((a, b) {
        //sorting in descending order
        return b.movieName!.toLowerCase().compareTo(a.movieName!.toLowerCase());
      });
      callback(itemList);
    }
  }

  static void runSearch(String enteredKeyword, List<TvGuideDetails> itemList,
      Function callback) {
    List<TvGuideDetails> resultList = [];

      resultList = itemList.where((obj) {
        final movieName = obj.movieName?.toLowerCase();
        final input = enteredKeyword.toLowerCase();

        return movieName!.contains(input);
      }).toList();
      callback(resultList);
  }
}
