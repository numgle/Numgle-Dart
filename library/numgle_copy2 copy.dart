import 'dart:convert';
import 'dart:ffi';

import 'dart:io';
import 'package:path/path.dart' as path;
import '../bin/dataset.dart';
import '../bin/lettertype.dart';
import 'package:charcode/charcode.dart';
import 'dart:core';
import 'dart:math' as Math;
import 'package:http/http.dart' as http;

class Numgle {
  late final Dataset dataset;
  //late final Map<String, dynamic> dataset;
  String str = "";
  /*
  //웹에서 로딩용
  final datasetFileUrl = http.get(
      //Uri.encodeFull("https://raw.githubusercontent.com/numgle/dataset/main/src/data.json"),
      Uri.parse(
          "https://raw.githubusercontent.com/numgle/dataset/main/src/data.json"),
      headers: {"Accept": "application/json"});*/
  final datasetFile =
      File(path.join(path.dirname(Platform.script.toFilePath()), 'data.json'));

  Numgle(this.str) {
    //print(jsonDecode(datasetFile.readAsStringSync()) is List<String>);
    //print(d)

    if (datasetFile.existsSync()) {
      dataset = jsonDecode(datasetFile.readAsStringSync());
    } else {
      print("file not found");
      exit(-1);
    }
  }

  String main() {
    return convertStringToNumgle(str);
  }

  String convertStringToNumgle(String input) {
    if (input.isEmpty) {
      return "";
    }
    List<String> arr = [];

    input.runes.forEach((element) {
      arr.add(convertCharToNumgle(String.fromCharCode(element)));
      //print(String.fromCharCode(element));
    });

    String output = arr.join("<br>");
    return output;
  }

  //LetterType letterType = LetterType.unknown;
  String convertCharToNumgle(String input) {
    //캐릭터 형식을 사용하는데, dart에는 없나봄.
    //그냥 string사용해야될듯

    String i = input[0];
    //String i = input.substring(0, 1);
    //print(i);
    String result = "";
    int charcode = input.codeUnitAt(0);
    LetterType letterType = getLetterType(i);
    print(charcode);

    switch (letterType) {
      case LetterType.Empty:
        result = "";
        break;
      case LetterType.CompleteHangle:
        result = completeHangul(i);
        break;
      case LetterType.NotCompleteHangule:
        result = dataset.han[charcode - 0x3131];
        break;
      case LetterType.englishUpper:
        result = dataset.englishUpper[charcode - 65];
        break;
      case LetterType.englishLower:
        result = dataset.englishLower[charcode - 97];
        break;
      case LetterType.number:
        result = dataset.number[charcode - 48];
        break;
      case LetterType.specialLetter:
        //indexOf(input)이 맞는건지, indexOf(i)가 맞는지 확인해봐야함.
        result = dataset.special["?!.^-".indexOf(i)];
        break;
      case LetterType.unknown:
        break;
      default:
        print("There is a letter not converted");
    }
    return result;
  }

  Map<String, int> separateHan(String han) {
    Map<String, int> map = {};
    int charcode = han.codeUnitAt(0);
    map["cho"] = ((charcode - 44032) / 28 / 21).floor();
    map["jung"] = ((charcode - 44032) / 28 % 21).floor();
    map["jong"] = ((charcode - 44032) % 28).floor();

    return map;
  }

  String completeHangul(String input) {
    //Map<String, int> separateHan = separateHan(input); 이런식으로 하니까 separateHan함수가 선언된 부분이 앞에 변수로 인식해버려서 에러가 출력되어버림.
    Map<String, int> separateHan1 = separateHan(input);

    if (!isInData(
        separateHan1["cho"]!, separateHan1["jung"]!, separateHan1["jong"]!)) {
      print("There is a letter not converted");
      return "";
    }
    if (separateHan1["jung"]! >= 8 && separateHan1["jung"] != 20) {
      return dataset.jong[separateHan1["jong"]!] +
          dataset.jung[separateHan1["jung"]! - 8] +
          dataset.cho[separateHan1["cho"]!];
    }

    return dataset.jong[separateHan1["jong"]!] +
        dataset.cj[Math.min(8, separateHan1["jung"]!)][separateHan1["cho"]!] +
        dataset.cho[separateHan1["cho"]!];
  }

  bool isInData(int cho_num, int jung_num, int jong_num) {
    if (jong_num != 0 && dataset.jong[jong_num] == "") return false;
    if (jung_num >= 8 && jung_num != 20) {
      return dataset.jung[jung_num - 8] != "";
    } else {
      return dataset.cj[Math.min(8, jung_num)][cho_num] != "";
    }
  }

  LetterType getLetterType(String letter) {
    String str = "?!.^-";
    int charcode = letter.codeUnitAt(0);
    if (charcode == 0 || charcode == 12 || charcode == 15) {
      return LetterType.Empty;
    } else if (charcode >= 44032 && charcode <= 55203) {
      return LetterType.CompleteHangle;
    } else if (charcode >= 0x3131 && charcode <= 0x3163) {
      return LetterType.NotCompleteHangule;
    } else if (charcode >= 65 && charcode <= 90) {
      return LetterType.englishUpper;
    } else if (charcode >= 97 && charcode <= 122) {
      return LetterType.englishLower;
    } else if (charcode >= 48 && charcode <= 57) {
      return LetterType.number;
    } else if (str.contains(letter[0])) {
      return LetterType.specialLetter;
    } else {
      return LetterType.unknown;
    }
  }
}
