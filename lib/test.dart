import 'package:fpdart/fpdart.dart';

typedef FutureEither = Future<Either<Failture, Success>>;
typedef Success = String;

abstract class ABC {
  FutureEither futureither;
}

class Failture {
  final String message;
  final StackTrace stacktrace;

  const Failture(this.message, this.stacktrace);
}
