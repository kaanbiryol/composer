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
