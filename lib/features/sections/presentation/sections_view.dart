import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/features/sections/presentation/managers/sections_contracts.dart';
import 'package:tracking_app/features/sections/presentation/managers/sections_cubit.dart';

import 'widgets/bottom_nav_bar.dart';

class SectionsView extends StatefulWidget {
  const SectionsView({super.key});

  @override
  State<SectionsView> createState() => _SectionsViewState();
}

class _SectionsViewState extends State<SectionsView> {
  List<Widget> get pages => [
    const Center(child: Text('Home')),
    const Center(child: Text('Orders')),
    const Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<SectionsCubit, SectionsViewState>(
        builder: (context, state) => Scaffold(
          body: pages[state.currentTab],
          bottomNavigationBar: BottomNavBar(
            currentIndex: state.currentTab,
            onTap: (index) => _onTap(index, state),
          ),
        ),
      );

  void _onTap(int index, SectionsViewState state) {
    context.read<SectionsCubit>().doIntent(switch (index) {
      0 => ViewOrdersIntent(),
      1 => ViewHistoryIntent(),
      _ => ViewProfileIntent(),
    });
  }
}
