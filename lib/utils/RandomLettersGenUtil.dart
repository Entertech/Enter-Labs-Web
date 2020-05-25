import 'dart:math';
class RandomLettersGenUtil {
  static List<String> feedLetters = const <String>[
    "E",
    "F",
    "H",
    "L",
    "N",
    "T",
    "V",
    "Y",
    "Z"
  ];

  static List<int> getFixIndexs(
      List<int> correctAIndexs, List<int> errorAIndexs) {
    List<int> fixIndexList = new List();
    for (int i = 0; i < correctAIndexs.length; i++) {
      fixIndexList.add(correctAIndexs[i]);
      fixIndexList.add(correctAIndexs[i] + 1);
    }

    for (int i = 0; i < errorAIndexs.length; i++) {
      fixIndexList.add(errorAIndexs[i]);
      if (!fixIndexList.contains(correctAIndexs[i] + 1)) {
        fixIndexList.add(errorAIndexs[i] + 1);
      }
    }
    fixIndexList.sort((a, b) => a.compareTo(b));
    return fixIndexList;
  }

  static List<String> genRandomLetters() {
    List<String> letters = new List<String>(100);
    var correctALettersIndexList = genRandomCorrectIndexForLetterA();
    var remainingIndexs = genListRemainingIndexs(correctALettersIndexList);
    var errorALettersIndexList = genRandomErrorIndexForLetterA(remainingIndexs);
    var fixIndexs =
        getFixIndexs(correctALettersIndexList, errorALettersIndexList);
    var unfixIndexs = genListRemainingIndexs(fixIndexs);
    var errorXLetterIndexs = genRandomErrorIndexForLetterX(unfixIndexs);
//    print(
//        "a indexs ${correctALettersIndexList.toString()},remaining indexs is ${remainingIndexs.toString()},error a is: ${errorALettersIndexList}");
    for (int i = 0; i < 100;) {
      int randomFeedLettersIndex = new Random().nextInt(9);
      if (correctALettersIndexList.contains(i)) {
        letters[i] = "A";
        letters[i + 1] = "X";
        i = i + 2;
      } else if (errorALettersIndexList.contains(i)) {
        letters[i] = "A";
        i++;
      } else if (errorXLetterIndexs.contains(i)) {
        letters[i] = "X";
        i++;
      } else {
        letters[i] = (feedLetters[randomFeedLettersIndex]);
        i++;
      }
    }
//    print("letters is " + letters.toString() + "::${letters.length}");
    return letters;
  }

  static List<int> genRandomCorrectIndexForLetterA() {
    List<int> aIndexList = new List<int>(12).toList();
    int count = 0;
    while (count < 12) {
      int currentIndex = new Random().nextInt(100);
      if (!aIndexList.contains(currentIndex) &&
          !aIndexList.contains(currentIndex + 1) &&
          !aIndexList.contains(currentIndex - 1) &&
          currentIndex != 99) {
        aIndexList[count++] = (currentIndex);
      }
    }
    aIndexList.sort((a, b) => a.compareTo(b));
    return aIndexList;
  }

  static List<int> genRandomErrorIndexForLetterA(List<int> remainingIndex) {
    List<int> aIndexList = new List<int>(12).toList();
    int count = 0;
    while (count < 12) {
      int currentIndex = new Random().nextInt(remainingIndex.length);
      if (!aIndexList.contains(remainingIndex[currentIndex])) {
        aIndexList[count++] = remainingIndex[currentIndex];
      }
    }
    aIndexList.sort((a, b) => a.compareTo(b));
    return aIndexList;
  }

  static List<int> genRandomErrorIndexForLetterX(List<int> remainingIndex) {
    List<int> aIndexList = new List<int>(12).toList();
    int count = 0;
    while (count < 12) {
      int currentIndex = new Random().nextInt(remainingIndex.length);
      if (!aIndexList.contains(remainingIndex[currentIndex])) {
        aIndexList[count++] = remainingIndex[currentIndex];
      }
    }
    aIndexList.sort((a, b) => a.compareTo(b));
    return aIndexList;
  }

  static List<int> genListRemainingIndexs(List<int> source) {
    List<int> fixSourceList = new List();
    for (int i = 0; i < source.length; i++) {
      fixSourceList.add(source[i]);
      fixSourceList.add(source[i] + 1);
    }
    List<int> remainingIndexs = new List<int>();
    for (int i = 0; i < 100; i++) {
      if (!fixSourceList.toList().contains(i)) {
        remainingIndexs.add(i);
      }
    }
    return remainingIndexs;
  }
}
