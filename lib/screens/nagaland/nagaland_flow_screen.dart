import 'package:flutter/material.dart';
import '../../data/nagaland_data.dart';
import 'nagaland_home_screen.dart';
import 'district_detail_screen.dart';

class NagalandFlowScreen extends StatelessWidget {
  final ValueChanged<bool>? onHeaderVisibilityChanged;

  const NagalandFlowScreen({
    super.key,
    this.onHeaderVisibilityChanged,
  });

  void _selectDistrict(BuildContext context, DistrictInfo district) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DistrictDetailScreen(
          district: district,
          onBack: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NagalandHomeScreen(
      key: const ValueKey('nagaland_home_view'),
      onSelectDistrict: (district) => _selectDistrict(context, district),
    );
  }
}
