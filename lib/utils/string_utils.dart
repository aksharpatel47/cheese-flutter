extension StringExtraFunctions on String? {
  bool get hasValue => this != null && this?.trim() != "";
}
