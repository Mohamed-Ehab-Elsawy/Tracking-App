import 'package:flutter/widgets.dart';

extension SliverX on Widget {
  SliverToBoxAdapter get asSliver => SliverToBoxAdapter(child: this);
}
