import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoodFilterButton extends StatelessWidget {
  final String assetName;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isPaddingApplied;
  final String title;

  const FoodFilterButton({
    super.key,
    required this.assetName,
    required this.isSelected,
    required this.onTap,
    required this.isPaddingApplied,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: isPaddingApplied ? const EdgeInsets.only(right: 5) : EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 95,
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 0,
              color: !isSelected ? CupertinoColors.systemFill : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isSelected ? Colors.black54 : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Image.asset(assetName, width: 50, height: 50)),
                    Text(title, style: TextStyle(color: isSelected ? Colors.black : Colors.black54)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
