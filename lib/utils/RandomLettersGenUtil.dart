import 'dart:math';

class RandomLettersGenUtil {
  static int letterTotalCount = 100;
  static double specialLetterFactor = 0.12;
  static int specialLetterCount =
      letterTotalCount * specialLetterFactor.toInt();
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
  static List<String> feedLettersForAudio = const <String>[
    "B",
    "E",
    "I",
    "J",
    "K",
    "O",
    "R",
    "T",
    "U",
    "Y"
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

  static List<String> genRandomLetters(List<String> feedLetters,
      String firstSpecialLetter, String secondSpecialLetter, int totalCount) {
    letterTotalCount = totalCount;
    specialLetterCount = (letterTotalCount * specialLetterFactor).toInt();
    List<String> letters = new List<String>(letterTotalCount);
    var correctALettersIndexList = genRandomCorrectIndexForLetterA();
    var remainingIndexs = genListRemainingIndexs(correctALettersIndexList);
    var errorALettersIndexList = genRandomErrorIndexForLetterA(remainingIndexs);
    var fixIndexs =
        getFixIndexs(correctALettersIndexList, errorALettersIndexList);
    var unfixIndexs = genListRemainingIndexs(fixIndexs);
    var errorXLetterIndexs = genRandomErrorIndexForLetterX(unfixIndexs);
//    print(
//        "a indexs ${correctALettersIndexList.toString()},remaining indexs is ${remainingIndexs.toString()},error a is: ${errorALettersIndexList}");
    for (int i = 0; i < letterTotalCount;) {
      int randomFeedLettersIndex = new Random().nextInt(feedLetters.length);
      if (correctALettersIndexList.contains(i)) {
        letters[i] = firstSpecialLetter;
        letters[i + 1] = secondSpecialLetter;
        i = i + 2;
      } else if (errorALettersIndexList.contains(i)) {
        letters[i] = firstSpecialLetter;
        i++;
      } else if (errorXLetterIndexs.contains(i)) {
        letters[i] = secondSpecialLetter;
        i++;
      } else {
        letters[i] = (feedLetters[randomFeedLettersIndex]);
        i++;
      }
    }
//    print("letters is " + letters.toString() + "::${letters.length}");
    return letters;
  }

  static List<String> genRandomLettersForAudio() {
    List<String> letters = new List<String>(letterTotalCount);
    for (int i = 0; i < letterTotalCount; i++) {
      int randomFeedLettersIndex =
          new Random().nextInt(feedLettersForAudio.length);
      letters[i] = (feedLettersForAudio[randomFeedLettersIndex]);
    }
    return letters;
  }

  static List<int> genRandomCorrectIndexForLetterA() {
    List<int> aIndexList =
        new List<int>(specialLetterCount).toList();
    int count = 0;
    while (count < specialLetterCount) {
      int currentIndex = new Random().nextInt(letterTotalCount);
      if (!aIndexList.contains(currentIndex) &&
          !aIndexList.contains(currentIndex + 1) &&
          !aIndexList.contains(currentIndex - 1) &&
          currentIndex != letterTotalCount - 1) {
        aIndexList[count++] = (currentIndex);
      }
    }
    aIndexList.sort((a, b) => a.compareTo(b));
    return aIndexList;
  }

  static List<int> genRandomErrorIndexForLetterA(List<int> remainingIndex) {
    List<int> aIndexList = new List<int>(specialLetterCount).toList();
    int count = 0;
    while (count < specialLetterCount) {
      int currentIndex = new Random().nextInt(remainingIndex.length);
      if (!aIndexList.contains(remainingIndex[currentIndex])) {
        aIndexList[count++] = remainingIndex[currentIndex];
      }
    }
    aIndexList.sort((a, b) => a.compareTo(b));
    return aIndexList;
  }

  static List<int> genRandomErrorIndexForLetterX(List<int> remainingIndex) {
    List<int> aIndexList = new List<int>(specialLetterCount).toList();
    int count = 0;
    while (count < specialLetterCount) {
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
    for (int i = 0; i < letterTotalCount; i++) {
      if (!fixSourceList.toList().contains(i)) {
        remainingIndexs.add(i);
      }
    }
    return remainingIndexs;
  }
}
