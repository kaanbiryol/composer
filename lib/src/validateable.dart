typedef ValidateCallback = void Function(bool);

abstract class Validateable {
  bool validate();
}
