import 'dart:math';

import 'package:daily_dish/models/food.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoodListTile extends StatefulWidget {
  final Food food;
  final VoidCallback onDelete;

  const FoodListTile({super.key, required this.food, required this.onDelete});

  @override
  State<FoodListTile> createState() => _FoodListTileState();
}

class _FoodListTileState extends State<FoodListTile> with SingleTickerProviderStateMixin {
  bool isDeleteButtonVisible = false;
  bool isDatePickerVisible = false;

  late DateTime pickedDate;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticIn,
        reverseCurve: Curves.elasticOut,
      ),
    );
  }

  void _startShaking() {
    _controller.reset();
    _controller.forward();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isDeleteButtonVisible) {
              isDeleteButtonVisible = false;
            } else {
              isDatePickerVisible = !isDatePickerVisible;
            }
          });
        },
        onLongPress: () {
          if (!isDeleteButtonVisible) {
            _startShaking();
          }

          setState(() {
            isDeleteButtonVisible = !isDeleteButtonVisible;
          });
        },
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(sin(_animation.value * 2 * pi) * 10, 0),
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    color: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: isDatePickerVisible
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            )
                          : BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(widget.food.name),
                      leading: _getFoodTypeImage(),
                      subtitle: _getLastCoockedString(),
                      shape: RoundedRectangleBorder(
                        borderRadius: isDatePickerVisible
                            ? const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              )
                            : BorderRadius.circular(10),
                      ),
                      trailing: isDeleteButtonVisible
                          ? IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                widget.onDelete();
                                isDeleteButtonVisible = !isDeleteButtonVisible;
                              },
                            )
                          : null,
                    ),
                  ),
                );
              },
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: isDatePickerVisible ? 70 : 0,
              decoration: const BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 0,
                          color: Colors.white,
                          child: SizedBox(
                            height: 50,
                            child: Icon(Icons.calendar_month),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Card(
                        elevation: 0,
                        color: CupertinoColors.systemFill,
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(
                            Icons.add,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getFoodTypeImage() {
    Food food = widget.food;
    String asset = '';

    if (food is Soup) {
      if (food.soupType == SoupType.sweet) {
        asset = 'assets/sugar.png';
      } else {
        asset = 'assets/salt.png';
      }
    } else if (food is MainCourse) {
      if (food.mainCourseType == MainCourseType.meat) {
        asset = 'assets/steak.png';
      } else if (food.mainCourseType == MainCourseType.pasta) {
        asset = 'assets/pasta.png';
      } else if (food.mainCourseType == MainCourseType.sidedish) {
        asset = 'assets/french-fries.png';
      } else if (food.mainCourseType == MainCourseType.vegan) {
        asset = 'assets/vegetables.png';
      }
    } else if (food is Dessert) {
      if (food.dessertType == DessertType.sweet) {
        asset = 'assets/donuts.png';
      } else {
        asset = 'assets/pretzel.png';
      }
    }

    return Image.asset(asset, width: 45, height: 45);
  }

  Widget _getLastCoockedString() {
    String lastCoocked = 'Még nem volt elkészítve';

    if (widget.food.lastCoocked != null) {
      final difference = DateTime.now().difference(widget.food.lastCoocked!);
      if (difference.inDays < 30) {
        lastCoocked = '${difference.inDays} napja volt főzve';
      } else {
        final months = difference.inDays ~/ 30;
        final days = difference.inDays % 30;
        lastCoocked = '$months hónap és $days napja volt főzve';
      }
    }

    return Text(lastCoocked);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
