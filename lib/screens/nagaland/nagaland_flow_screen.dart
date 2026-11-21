import 'package:flutter/material.dart';
import '../../data/nagaland_data.dart';
import 'nagaland_home_screen.dart';
import 'district_detail_screen.dart';

class NagalandFlowScreen extends StatefulWidget {
  final ValueChanged<bool>? onHeaderVisibilityChanged;

  const NagalandFlowScreen({
    super.key,
    this.onHeaderVisibilityChanged,
  });

  @override
  State<NagalandFlowScreen> createState() => NagalandFlowScreenState();
}

class NagalandFlowScreenState extends State<NagalandFlowScreen> {
  DistrictInfo? _selectedDistrict;

  void selectDistrict(DistrictInfo district) {
    setState(() {
      _selectedDistrict = district;
    });
    widget.onHeaderVisibilityChanged?.call(false);
  }

  void goBackToHome() {
    setState(() {
      _selectedDistrict = null;
    });
    widget.onHeaderVisibilityChanged?.call(true);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedDistrict == null,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _selectedDistrict != null) {
          goBackToHome();
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _selectedDistrict == null
            ? NagalandHomeScreen(
                key: const ValueKey('nagaland_home_view'),
                onSelectDistrict: selectDistrict,
              )
            : DistrictDetailScreen(
                key: ValueKey('district_detail_${_selectedDistrict!.id}'),
                district: _selectedDistrict!,
                onBack: goBackToHome,
              ),
      ),
    );
  }
}
