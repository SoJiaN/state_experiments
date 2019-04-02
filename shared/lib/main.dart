import 'package:reactive_exploration/src/bloc/main.dart' as bloc;
import 'package:reactive_exploration/src/bloc_complex/main.dart'
    as bloc_complex;
import 'package:reactive_exploration/src/bloc_start/main.dart' as bloc_start;
import 'package:reactive_exploration/src/redux/main.dart' as redux;
import 'package:reactive_exploration/src/scoped/complete.dart' as scoped;
import 'package:reactive_exploration/src/singleton/main.dart' as singleton;
import 'package:reactive_exploration/src/start/main.dart' as start;
import 'package:reactive_exploration/src/start/main_blob.dart' as start_blob;
import 'package:reactive_exploration/src/value_notifier/main.dart'
    as value_notifier;
import 'package:reactive_exploration/src/vanilla/main.dart' as vanilla;

/// This rather unconventional main method allows us to switch to vastly
/// different implementations of the same app without confusing Flutter
/// and the IDE with many `main.dart` files in `lib/`.
///
/// All this main function does is run _another_ main function in one of
/// the imported files. When you're exploring a particular architecture,
/// just change the `flavor = ...` line below and (hot-)restart the app.
void main() {
  final flavor = Architecture.start;

  print("\n\n===== Running: $flavor =====\n\n");

  switch (flavor) {
    case Architecture.start:
      start.main(); /// 1.0  yes nothing added, Start
      return;
    case Architecture.startBlob:
      start_blob.main(); /// no
      return;
    case Architecture.singleton:
      singleton.main(); /// no
      return;
    case Architecture.vanilla:
      vanilla.main(); /// 使用传递函数的形式。来访问数据 no
      return;
    case Architecture.valueNotifier:
      value_notifier.main(); /// no 使用 cartObserver 不断传递 observer 对象，进行添加产品，和添加产品后的通知
      return;
    case Architecture.bloc:
      bloc.main(); /// 3.0 yes 最后的 business logic component
      return;
    case Architecture.blocComplex:
      bloc_complex.main(); /// yes 使用 InheritedWidget 完成，
      return;
    case Architecture.blocStart:
      bloc_start.main(); /// 2.0 yes 在讲解使用Stream之前 todoInherightWidget ,
      return;
    case Architecture.scoped:
      scoped.main(); /// yes 使用 ScopedModel 完成
      return;
    case Architecture.redux:
      redux.main(); /// no
      return;
  }
}

enum Architecture {
  bloc,
  blocComplex,
  blocStart,
  scoped,
  singleton,
  start,
  startBlob,
  vanilla,
  valueNotifier,
  redux,
}
