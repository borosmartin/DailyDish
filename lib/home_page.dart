import 'package:daily_dish/logic/food_list/food_list_cubit.dart';
import 'package:daily_dish/logic/food_list/food_list_state.dart';
import 'package:daily_dish/models/food.dart';
import 'package:daily_dish/widgets/animated_icon_widget.dart';
import 'package:daily_dish/widgets/food_filter_buttons.dart';
import 'package:daily_dish/widgets/food_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum SortOption { name, date, type }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FoodListCubit foodListCubit;

  FoodType selectedFoodType = FoodType.main;
  SortOption selectedSortOption = SortOption.name;

  FoodType newFoodType = FoodType.main;
  SoupType newSoupType = SoupType.sweet;
  MainCourseType newMainCourseType = MainCourseType.meat;
  DessertType newDessertType = DessertType.sweet;

  TextEditingController newFoodNameController = TextEditingController();
  late PageController _pageController;

  bool isSortPanelOpen = false;
  bool isAddingAnimationCompleted = false;
  bool isNewFoodDialogExpanded = false;
  bool showHeaderFilters = false;

  bool showSoupGif = false;
  bool showMainCourseGif = false;
  bool showDessertGif = false;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: 1);

    foodListCubit = context.read<FoodListCubit>();

    foodListCubit.getFoodList();

    showSoupGif = selectedFoodType == FoodType.soup;
    showMainCourseGif = selectedFoodType == FoodType.main;
    showDessertGif = selectedFoodType == FoodType.dessert;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isNewFoodDialogExpanded) {
          setState(() {
            isNewFoodDialogExpanded = false;
            newFoodNameController.clear();
            newFoodType = FoodType.main;
            newMainCourseType = MainCourseType.meat;
          });
        }
      },
      child: Stack(children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          left: isSortPanelOpen ? MediaQuery.of(context).size.width * 0.6 : 0,
          top: 0,
          right: isSortPanelOpen ? -MediaQuery.of(context).size.width * 0.6 : 0,
          bottom: 0,
          child: Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: _getAnimatedAddButton(),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            body: _getBodyContent(context),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          left: isSortPanelOpen ? 0 : -MediaQuery.of(context).size.width * 0.6,
          top: 0,
          bottom: 0,
          width: isSortPanelOpen ? MediaQuery.of(context).size.width * 0.61 : MediaQuery.of(context).size.width * 0.6,
          child: Stack(children: [
            Container(
              color: Colors.white,
            ),
            _getSortingSlidingPanel(),
          ]),
        ),
      ]),
    );
  }

  //---------------------------- BODY ---------------------------- //
  Widget _getSortingSlidingPanel() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.greenAccent,
        borderRadius: BorderRadius.only(topRight: Radius.circular(35), bottomRight: Radius.circular(35)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Rendezés", style: TextStyle(fontSize: 20, color: Colors.black, decoration: TextDecoration.none)),
            RadioMenuButton<SortOption>(
              groupValue: selectedSortOption,
              value: SortOption.name,
              style: const ButtonStyle(
                splashFactory: NoSplash.splashFactory,
              ),
              onChanged: (SortOption? value) {
                setState(() {
                  selectedSortOption = value!;
                });
              },
              child: const Text("Név szerint", style: TextStyle(fontSize: 20, color: Colors.black, decoration: TextDecoration.none)),
            ),
            RadioMenuButton<SortOption>(
              groupValue: selectedSortOption,
              value: SortOption.date,
              style: const ButtonStyle(
                splashFactory: NoSplash.splashFactory,
              ),
              onChanged: (SortOption? value) {
                setState(() {
                  selectedSortOption = value!;
                });
              },
              child: const Text("Idő szerint", style: TextStyle(fontSize: 20, color: Colors.black, decoration: TextDecoration.none)),
            ),
            RadioMenuButton<SortOption>(
              groupValue: selectedSortOption,
              value: SortOption.type,
              style: const ButtonStyle(
                splashFactory: NoSplash.splashFactory,
              ),
              onChanged: (SortOption? value) {
                setState(() {
                  selectedSortOption = value!;
                });
              },
              child: const Text("Típus szerint", style: TextStyle(fontSize: 20, color: Colors.black, decoration: TextDecoration.none)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getBodyContent(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _getHeader(),
            const SizedBox(height: 10),
            Expanded(child: _getFoodListView()),
          ],
        ),
      ),
    );
  }

  Widget _getFoodListView() {
    return BlocBuilder<FoodListCubit, FoodListState>(
      builder: (context, state) {
        if (state is FoodsUninitialized || state is FoodsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FoodsLoaded) {
          return PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                selectedFoodType = FoodType.values[index];
              });

              if (selectedFoodType == FoodType.soup) {
                Future.delayed(const Duration(milliseconds: 200), () {
                  setState(() {
                    showSoupGif = true;
                  });
                });
                showDessertGif = false;
                showMainCourseGif = false;
              } else if (selectedFoodType == FoodType.dessert) {
                Future.delayed(const Duration(milliseconds: 200), () {
                  setState(() {
                    showDessertGif = true;
                  });
                });
                showSoupGif = false;
                showMainCourseGif = false;
              } else if (selectedFoodType == FoodType.main) {
                Future.delayed(const Duration(milliseconds: 200), () {
                  setState(() {
                    showMainCourseGif = true;
                  });
                });
                showSoupGif = false;
                showDessertGif = false;
              }
            },
            children: [
              _buildFoodList(FoodType.soup, state.foodList),
              _buildFoodList(FoodType.main, state.foodList),
              _buildFoodList(FoodType.dessert, state.foodList),
            ],
          );
        } else if (state is FoodsError) {
          return Center(child: Text(state.message));
        } else {
          throw UnimplementedError();
        }
      },
    );
  }

  Widget _buildFoodList(FoodType foodType, List<Food> foodList) {
    List<Food> selectedFoodList = foodList.where((food) => food.foodType == foodType).toList();

    if (selectedFoodList.isEmpty) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.no_food, size: 100, color: Colors.grey),
          SizedBox(height: 10),
          Text('Nincs még ilyen étel!'),
          SizedBox(height: 80),
        ],
      );
    }

    List<Food> sortedFoodList = selectedFoodList;
    if (selectedSortOption == SortOption.date) {
      selectedFoodList.sort((a, b) {
        if (a.lastCoocked == null && b.lastCoocked == null) {
          return 0;
        } else if (a.lastCoocked == null) {
          return -1;
        } else if (b.lastCoocked == null) {
          return 1;
        } else {
          return b.lastCoocked!.compareTo(a.lastCoocked!);
        }
      });
    } else if (selectedSortOption == SortOption.name) {
      selectedFoodList.sort((a, b) => a.name.compareTo(b.name));
    }
    // todo type sort ha tudjuk milyen típusok lesznek

    return ListView.builder(
      itemCount: sortedFoodList.length,
      itemBuilder: (context, index) {
        return FoodListTile(
          food: sortedFoodList[index],
          onDelete: () {
            foodListCubit.removeFoodFromList(sortedFoodList[index]);
          },
        );
      },
    );
  }

  //--------------------------- HEADER-- ------------------------- //
  Widget _getHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      isSortPanelOpen = !isSortPanelOpen;
                    });
                  },
                  icon: Icon(
                    isSortPanelOpen ? Icons.close : Icons.sort,
                    color: isSortPanelOpen ? Colors.red : Colors.black,
                  )),
            ),
            CupertinoSlidingSegmentedControl<FoodType>(
              padding: const EdgeInsets.all(5),
              groupValue: selectedFoodType,
              onValueChanged: (value) {
                setState(() {
                  selectedFoodType = value!;
                });

                if (_pageController.hasClients) {
                  _pageController.jumpToPage(selectedFoodType.index);
                }

                if (selectedFoodType == FoodType.soup) {
                  Future.delayed(const Duration(milliseconds: 200), () {
                    setState(() {
                      showSoupGif = true;
                    });
                  });
                  showDessertGif = false;
                  showMainCourseGif = false;
                } else if (selectedFoodType == FoodType.dessert) {
                  Future.delayed(const Duration(milliseconds: 200), () {
                    setState(() {
                      showDessertGif = true;
                    });
                  });
                  showSoupGif = false;
                  showMainCourseGif = false;
                } else if (selectedFoodType == FoodType.main) {
                  Future.delayed(const Duration(milliseconds: 200), () {
                    setState(() {
                      showMainCourseGif = true;
                    });
                  });
                  showSoupGif = false;
                  showDessertGif = false;
                }
              },
              children: {
                FoodType.soup: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      showSoupGif
                          ? const AnimatedIconWidget(gifAsset: 'assets/stew.gif', pngAsset: 'assets/stew-nb.png')
                          : SizedBox(height: 50, width: 50, child: Image.asset('assets/stew-nb.png')),
                      const Text('Leves'),
                    ],
                  ),
                ),
                FoodType.main: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      showMainCourseGif
                          ? const AnimatedIconWidget(gifAsset: 'assets/roasted-turkey.gif', pngAsset: 'assets/roasted-turkey-nb.png')
                          : SizedBox(height: 50, width: 50, child: Image.asset('assets/roasted-turkey-nb.png')),
                      const Text('Főétel'),
                    ],
                  ),
                ),
                FoodType.dessert: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      showDessertGif
                          ? const AnimatedIconWidget(gifAsset: 'assets/cake.gif', pngAsset: 'assets/cake-nb.png')
                          : SizedBox(height: 50, width: 50, child: Image.asset('assets/cake-nb.png')),
                      const Text('Desszert'),
                    ],
                  ),
                ),
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    showHeaderFilters = !showHeaderFilters;
                  });
                },
                icon: Icon(
                  showHeaderFilters ? Icons.filter_alt_off_rounded : Icons.filter_alt_rounded,
                  color: showHeaderFilters ? Colors.red : Colors.black,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (showHeaderFilters) _getHeaderFilters(),
        const SizedBox(height: 10),
        Container(
          width: 70,
          height: 2.5,
          decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ],
    );
  }

  Widget _getHeaderFilters() {
    List<FoodFilterButton> filterButtons = [];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: filterButtons,
    );
  }

  //------------------------- ADD WIDGET ------------------------- //
  Widget _getAnimatedAddButton() {
    const fabSize = 56.0;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (!isNewFoodDialogExpanded) {
            isNewFoodDialogExpanded = true;
          } else {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        });
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isNewFoodDialogExpanded ? MediaQuery.of(context).size.width * 0.9 : fabSize,
            height: isNewFoodDialogExpanded ? 378 : fabSize,
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            onEnd: () {
              setState(() {
                isAddingAnimationCompleted = isNewFoodDialogExpanded;
              });
            },
            // todo lottie amíg tart az átmenet
            child: isNewFoodDialogExpanded && isAddingAnimationCompleted ? _getNewFoodExpandedWidget() : const Icon(Icons.add),
          ),
          if (isNewFoodDialogExpanded)
            Positioned(
              right: 5,
              top: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  setState(() {
                    isNewFoodDialogExpanded = false;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _getNewFoodExpandedWidget() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Étel hozzáadása', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 15),
          TextField(
            controller: newFoodNameController,
            decoration: const InputDecoration(
              hintText: 'Étel neve',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: CupertinoSlidingSegmentedControl<FoodType>(
              padding: const EdgeInsets.all(5),
              groupValue: newFoodType,
              onValueChanged: (value) {
                setState(() {
                  newFoodType = value!;
                });
              },
              children: const {
                FoodType.soup: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Leves'),
                ),
                FoodType.main: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Főétel'),
                ),
                FoodType.dessert: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Desszert'),
                ),
              },
            ),
          ),
          const SizedBox(height: 10),
          _getDialogFoodFilterRow(),
          const SizedBox(height: 15),
          _getDialogAddButton(),
        ],
      ),
    );
  }

  Widget _getDialogAddButton() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: newFoodNameController.text.isEmpty ? CupertinoColors.systemFill : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: newFoodNameController.text.isEmpty
                ? null
                : () {
                    if (newFoodType == FoodType.soup) {
                      foodListCubit.addFoodToList(Soup(name: newFoodNameController.text, soupType: newSoupType));
                    } else if (newFoodType == FoodType.main) {
                      foodListCubit.addFoodToList(MainCourse(name: newFoodNameController.text, mainCourseType: newMainCourseType));
                    } else if (newFoodType == FoodType.dessert) {
                      foodListCubit.addFoodToList(Dessert(name: newFoodNameController.text, dessertType: newDessertType));
                    }

                    setState(() {
                      isNewFoodDialogExpanded = false;
                    });

                    newFoodNameController.clear();
                    newFoodType = FoodType.main;
                    newMainCourseType = MainCourseType.meat;
                  },
            child: SizedBox(
              height: 45,
              child: Center(
                child: Text(
                  "Hozzáadás",
                  style: TextStyle(color: newFoodNameController.text.isNotEmpty ? Colors.black87 : Colors.black54),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getDialogFoodFilterRow() {
    List<FoodFilterButton> filterButtons = [];

    switch (newFoodType) {
      case FoodType.soup:
        filterButtons.addAll([
          FoodFilterButton(
            assetName: "assets/sugar.png",
            isSelected: newSoupType == SoupType.sweet,
            isPaddingApplied: true,
            title: 'Édes',
            onTap: () {
              setState(() {
                newSoupType = SoupType.sweet;
              });
            },
          ),
          FoodFilterButton(
            assetName: "assets/salt.png",
            isSelected: newSoupType == SoupType.savory,
            isPaddingApplied: false,
            title: 'Sós',
            onTap: () {
              setState(() {
                newSoupType = SoupType.savory;
              });
            },
          ),
        ]);
        break;
      case FoodType.main:
        filterButtons.addAll([
          FoodFilterButton(
            assetName: "assets/steak.png",
            isSelected: newMainCourseType == MainCourseType.meat,
            isPaddingApplied: true,
            title: 'Hús',
            onTap: () {
              setState(() {
                newMainCourseType = MainCourseType.meat;
              });
            },
          ),
          FoodFilterButton(
            assetName: "assets/pasta.png",
            isSelected: newMainCourseType == MainCourseType.pasta,
            isPaddingApplied: true,
            title: 'Tészta',
            onTap: () {
              setState(() {
                newMainCourseType = MainCourseType.pasta;
              });
            },
          ),
          FoodFilterButton(
            assetName: "assets/french-fries.png",
            isSelected: newMainCourseType == MainCourseType.sidedish,
            isPaddingApplied: true,
            title: 'Köret',
            onTap: () {
              setState(() {
                newMainCourseType = MainCourseType.sidedish;
              });
            },
          ),
          FoodFilterButton(
            assetName: "assets/vegetables.png",
            isSelected: newMainCourseType == MainCourseType.vegan,
            isPaddingApplied: false,
            title: 'Zöldség',
            onTap: () {
              setState(() {
                newMainCourseType = MainCourseType.vegan;
              });
            },
          ),
        ]);
        break;
      case FoodType.dessert:
        filterButtons.addAll([
          FoodFilterButton(
            assetName: "assets/donuts.png",
            isSelected: newDessertType == DessertType.sweet,
            isPaddingApplied: true,
            title: 'Édes',
            onTap: () {
              setState(() {
                newDessertType = DessertType.sweet;
              });
            },
          ),
          FoodFilterButton(
            assetName: "assets/pretzel.png",
            isSelected: newDessertType == DessertType.savory,
            isPaddingApplied: false,
            title: 'Sós',
            onTap: () {
              setState(() {
                newDessertType = DessertType.savory;
              });
            },
          ),
        ]);
        break;
    }

    return Row(children: filterButtons);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
