abstract class Validateable {
  bool validate();
}

abstract class ViewModelValidateable {
  bool validate(List<Validator> validators);
}

abstract class Validator<T> {
  String errorText;
  bool validate(T value);
}

class EmptyValidator implements Validator<String> {
  EmptyValidator({String errorText}) {
    this.errorText = errorText ?? "This field cannot be left empty.";
  }

  @override
  bool validate(String value) {
    return value != null && value.isNotEmpty;
  }

  @override
  String errorText;
}

class MinMaxValidator implements Validator<String> {
  int _min = 0;
  int _max = 99999;

  MinMaxValidator(int min, int max, {String message}) {
    _min = min;
    _max = max;
    errorText = message != null
        ? message
        : "This field must be between $_min and $_max";
  }

  String errorText = "";

  @override
  bool validate(String value) {
    return value == null ? false : value.length >= _min && value.length <= _max;
  }
}
