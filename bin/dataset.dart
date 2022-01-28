class Dataset {
  final List<dynamic> cho;
  final List<dynamic> jung;
  final List<dynamic> jong;
  final List<List<dynamic>> cj;
  final List<dynamic> han;
  final List<dynamic> englishUpper;
  final List<dynamic> englishLower;
  final List<dynamic> number;
  final List<dynamic> special;

  const Dataset(this.cho, this.jung, this.jong, this.cj, this.han,
      this.englishUpper, this.englishLower, this.number, this.special);

  //json을 객체로 변환
  factory Dataset.fromJson(Map<String, dynamic> json) {
    return Dataset(
        json['cho'] as List<dynamic>,
        json['jung'] as List<dynamic>,
        json['jong'] as List<dynamic>,
        json['cj'] as List<List<dynamic>>,
        json['han'] as List<dynamic>,
        json['englishUpper'] as List<dynamic>,
        json['englishLower'] as List<dynamic>,
        json['number'] as List<dynamic>,
        json['special'] as List<dynamic>);
  }

  //객체를 json으로 변환
  Map<String, dynamic> toJson() {
    return {
      'cho': cho,
      'jung': jung,
      'jong': jong,
      'cj': cj,
      'han': han,
      'englishUpper': englishUpper,
      'englishLower': englishLower,
      'number': number,
      'special': special
    };
  }
}

class Range {
  final RangeInfo completeHangul;
  final RangeInfo notCompleteHangul;
  final RangeInfo uppercase;
  final RangeInfo lowercase;
  final RangeInfo number;
  final List<int> special;

  const Range(this.completeHangul, this.notCompleteHangul, this.uppercase,
      this.lowercase, this.number, this.special);
}

class RangeInfo {
  final int start;
  final int end;

  const RangeInfo(this.start, this.end);
}
