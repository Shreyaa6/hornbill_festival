import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bottomInset = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom
        : MediaQuery.of(context).viewPadding.bottom;
    final double bottomMargin = bottomInset > 0 ? bottomInset + 10 : 16;

    return Positioned(
      left: screenWidth * 0.05,
      right: screenWidth * 0.05,
      bottom: bottomMargin,
      child: Container(
        height: 67,
        decoration: BoxDecoration(
          color: const Color(0xFF20B08D),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _buildTabItem(
                index: 0,
                iconAsset: 'assets/images/homepage.png',
                size: 25,
                activeSize: 24,
              ),
            ),
            Expanded(
              child: _buildTabItem(
                index: 1,
                iconAsset: 'assets/images/document.png',
                size: 25,
                activeSize: 24,
              ),
            ),
            Expanded(
              child: _buildCenterHornbillItem(),
            ),
            Expanded(
              child: _buildTabItem(
                index: 3,
                iconAsset: 'assets/images/nagaland_icon.png',
                size: 26,
                activeSize: 24,
              ),
            ),
            Expanded(
              child: _buildTabItem(
                index: 4,
                iconAsset: 'assets/images/user_white.png',
                size: 25,
                activeSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required String iconAsset,
    required double size,
    required double activeSize,
    EdgeInsets? customActivePadding,
  }) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: Container(
        height: 67,
        alignment: Alignment.center,
        child: isSelected
            ? Container(
                padding: customActivePadding ?? const EdgeInsets.all(11),
                decoration: const BoxDecoration(
                  color: Color(0xFF03314B),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  iconAsset,
                  height: activeSize,
                  width: activeSize,
                  color: Colors.white,
                ),
              )
            : Image.asset(
                iconAsset,
                height: size,
                width: size,
                color: Colors.white,
              ),
      ),
    );
  }

  Widget _buildCenterHornbillItem() {
    final bool isSelected = currentIndex == 2;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(2),
      child: Container(
        height: 67,
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.only(
            left: 9,
            right: 7,
            top: 7,
            bottom: 7,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isSelected ? 0.25 : 0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Image.asset(
            'assets/images/hornbill.png',
            height: 40,
            width: 40,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
