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
    List<int> fixIndexList = [];
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
    List<String> letters = List.filled(letterTotalCount, "");
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
    List<String> letters = List.filled(letterTotalCount, "");
    for (int i = 0; i < letterTotalCount; i++) {
      int randomFeedLettersIndex =
          new Random().nextInt(feedLettersForAudio.length);
      letters[i] = (feedLettersForAudio[randomFeedLettersIndex]);
    }
    return letters;
  }

  static List<int> genRandomCorrectIndexForLetterA() {
    List<int> aIndexList = List.filled(specialLetterCount, 0);
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
    List<int> aIndexList = List.filled(specialLetterCount, 0);
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
    List<int> aIndexList = List.filled(specialLetterCount, 0);
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
    List<int> fixSourceList = [];
    for (int i = 0; i < source.length; i++) {
      fixSourceList.add(source[i]);
      fixSourceList.add(source[i] + 1);
    }
    List<int> remainingIndexs = <int>[];
    for (int i = 0; i < letterTotalCount; i++) {
      if (!fixSourceList.toList().contains(i)) {
        remainingIndexs.add(i);
      }
    }
    return remainingIndexs;
  }

  /**
   * 获取tDCS-3-back实验随机字母序列
   */
  static List<String> getRandomTDCS3BackLetters(
      List<String> source, int lettersLength, int backStep, double backRate) {
    List<String> showLetters = List.filled(lettersLength, "");
    for (int i = 0; i < lettersLength; i++) {
      var letter = getRandomLetterFromList(source);
      var preStepIndex = i - backStep;
      while (preStepIndex >= 0 && showLetters[preStepIndex] == letter) {
        letter = getRandomLetterFromList(source);
      }
      showLetters[i] = letter;
    }
    List<int> backIndexList = [];
    List<int> preBackIndexList = [];
    int backCount = (lettersLength * backRate).toInt();

    while (backIndexList.length < backCount) {
      int backIndex = new Random().nextInt(lettersLength);
      if (backIndex <= backStep ||
          backIndexList.contains(backIndex) ||
          preBackIndexList.contains(backIndex)) {
        continue;
      }
      var preBack = showLetters[backIndex - backStep];
      var nextBackIndex = backIndex + backStep;
      var nextBack = "";
      if (nextBackIndex < lettersLength) {
        nextBack = showLetters[nextBackIndex];
      }
      if (preBack != nextBack) {
        showLetters[backIndex] = preBack;
        backIndexList.add(backIndex);
        preBackIndexList.add(backIndex - backStep);
      }
    }
    return showLetters;
  }

  static String getRandomLetterFromList(List<String> source) {
    int randomIndex = new Random().nextInt(source.length);
    return source[randomIndex];
  }
}
