/// *****************************************************************
/// * Nombre del Archivo: multi_bloc_builder.dart
/// * Ruta: lib\src\Utils\Base\Cubit\multi_bloc_builder.dart
/// * Descripción:
/// * Define un widget personalizado que permite construir un árbol de widgets
/// * en función del estado de dos BLoCs o Cubits distintos, combinando sus estados en un único builder.
/// * Autores: Marcos Alejandro Collazos Marmolejo & Geraldine Perilla Valderrama
/// * Notas:
/// *      - Útil cuando se requiere reaccionar simultáneamente a dos estados.
/// *      - Permite usar filtros opcionales con ´buildWhen1´ y ´buildWhen2´.
/// *****************************************************************
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widget genérico que permite combinar dos [BlocBuilder] anidados para
/// observar y reaccionar a los estados de dos Cubits o BLoCs simultáneamente.
///
/// Los tipos genéricos C1 y C2 son los cubits o blocs, mientras que S1 y S2 son sus estados.
///
/// [builder] es una función que recibe el [BuildContext], el estado del primer cubit
/// y el estado del segundo cubit para construir la UI resultante.
///
/// Se pueden proporcionar opcionalmente [buildWhen1] y [buildWhen2] para optimizar las reconstrucciones.
class MultiBlocBuilder<
  C1 extends StateStreamable<S1>,
  S1,
  C2 extends StateStreamable<S2>,
  S2
>
    extends StatelessWidget {
  const MultiBlocBuilder({
    super.key,
    required this.builder,
    this.buildWhen1,
    this.buildWhen2,
  });

  /// Función constructora que combina ambos estados y construye la interfaz de usuario.
  final Widget Function(BuildContext, S1, S2) builder;

  /// Filtro opcional para evitar reconstrucciones innecesarias del primer bloc/cubit.
  final bool Function(S1 previous, S1 current)? buildWhen1;

  /// Filtro opcional para evitar reconstrucciones innecesarias del segundo bloc/cubit.
  final bool Function(S2 previous, S2 current)? buildWhen2;

  @override
  Widget build(final BuildContext context) => BlocBuilder<C1, S1>(
    buildWhen: buildWhen1,
    builder: (final context, final state1) => BlocBuilder<C2, S2>(
      buildWhen: buildWhen2,
      builder: (final context, final state2) =>
          builder(context, state1, state2),
    ),
  );
}
