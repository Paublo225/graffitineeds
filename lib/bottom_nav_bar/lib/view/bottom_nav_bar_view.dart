part of bottom_nav_bar;

class TabBottomView extends StatefulWidget {
  final double? elevation;
  final BottomNavigationBarType? bottomNavigationBarType;
  final double? selectedFontSize;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;

  final double? unselectedFontSize;
  final EdgeInsets? bottomNavigationBarItemPadding;
  final double? height;
  late int? currentIndex;
  final Function(int)? onTap;
  final Color? backgroundColor;
  final double? iconSize;
  final IconThemeData? selectedIconTheme;
  final bool? showSelectedLabels;
  final bool? showUnselectedLabels;
  final bool? enableFeedback;
  final BottomNavigationBarLandscapeLayout? bottomNavigationBarLandscapeLayout;
  final MouseCursor? mouseCursor;
  final IconThemeData? unselectedIconTheme;
  final List<TabItem> items;

  final double? selectedIconSize;
  final double? unSelectedIconSize;

  TabBottomView({
    Key? key,
    this.elevation,
    this.bottomNavigationBarType,
    this.selectedFontSize,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.unselectedFontSize,
    this.bottomNavigationBarItemPadding,
    this.height,
    this.onTap,
    this.backgroundColor,
    this.iconSize,
    this.currentIndex,
    this.showSelectedLabels,
    this.showUnselectedLabels,
    this.selectedIconTheme,
    this.bottomNavigationBarLandscapeLayout,
    this.enableFeedback,
    this.mouseCursor,
    this.unselectedIconTheme,
    required this.items,
    this.selectedIconSize,
    this.unSelectedIconSize,
  }) : super(key: key);

  @override
  State<TabBottomView> createState() => _TabBottomViewState();
}

class _TabBottomViewState extends State<TabBottomView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: widget.items.length,
      vsync: this,
    );
    for (int i = 0; i < widget.items.length; i++) {
      final key =
          GlobalKey<NavigatorState>(debugLabel: '${widget.items[i].page}');
      TabConsts.navigatorKeys.add(key);
      if (widget.items[i].settings != null) {
        TabConsts.navigators.add(
          IndexedStackChild(
            child: Navigator(
              initialRoute: widget.items[i].initialRoute,
              key: key,
              onGenerateRoute: widget.items[i].settings,
            ),
          ),
        );
      } else {
        TabConsts.navigators.add(
          IndexedStackChild(
            child: Navigator(
              key: key,
              onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) => widget.items[i].page,
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? childz;
    TabConsts.bottomBarItemList = List.generate(widget.items.length, (index) {
      return BottomNavigationBarItem(
        icon: Container(
          height: widget.height ?? 40,
          padding: widget.bottomNavigationBarItemPadding ??
              const EdgeInsets.only(bottom: 4.0),
          child: widget.items[index].icon,
        ),
        label: widget.items[index].label,
      );
    });
    return WillPopScope(
      onWillPop: () => onWillPop(),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedIconTheme:
              IconThemeData(color: mainColor, size: widget.iconSize! + 2.0),
          elevation: widget.elevation ?? 12,
          type: widget.bottomNavigationBarType ?? BottomNavigationBarType.fixed,
          currentIndex: widget.currentIndex!,
          iconSize: widget.iconSize!,
          selectedFontSize: widget.selectedFontSize ?? 8,
          backgroundColor: widget.backgroundColor,
          selectedLabelStyle: widget.selectedLabelStyle ??
              const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
          unselectedLabelStyle: widget.unselectedLabelStyle ??
              const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
          unselectedItemColor:
              ThemaMode.isDarkMode ? Colors.grey : Colors.black,
          showUnselectedLabels: widget.showUnselectedLabels ?? true,
          showSelectedLabels: widget.showSelectedLabels ?? true,
          landscapeLayout: widget.bottomNavigationBarLandscapeLayout,
          unselectedFontSize: widget.unselectedFontSize ?? 8,
          enableFeedback: widget.enableFeedback,
          mouseCursor: widget.mouseCursor,
          unselectedIconTheme: IconThemeData(size: widget.iconSize),
          onTap: widget.onTap ?? changeIndex,
          items: TabConsts.bottomBarItemList,
        ),
        body: ProsteIndexedStack(
          index: widget.currentIndex!,
          children: TabConsts.navigators,
        ),
      ),
    );
  }

  Future<bool> onWillPop() async {
    setState(() {});
    var goBack = !await TabConsts
        .navigatorKeys[widget.currentIndex!].currentState!
        .maybePop();
    if (TabConsts.pageList.length == 1 && TabConsts.pageList.contains(0)) {
      if (goBack) {
        // if home page didn't go any page yet close app
        SystemNavigator.pop();
      }
    } else if (TabConsts.pageList.length == 1) {
      // if there is a tab without home page go home page
      widget.currentIndex = 0;
      TabConsts.pageList = [0];
    } else {
      if (goBack) {
        // remove last tab from list and go before tab
        TabConsts.pageList.removeLast();
        widget.currentIndex = TabConsts.pageList.last;
      }
    }
    return Future.value(false);
  }

  // change bottom bar index
  void changeIndex(int itemIndex) {
    setState(() {});
    if (itemIndex == widget.currentIndex) {
      TabConsts.navigatorKeys[widget.currentIndex!].currentState?.popUntil(
        (route) => route.isFirst,
      );
    } else {
      widget.currentIndex = itemIndex;
      if (TabConsts.pageList.length <= 2) {
        if (TabConsts.pageList.contains(widget.currentIndex)) {
          TabConsts.pageList.remove(widget.currentIndex);
          TabConsts.pageList.add(widget.currentIndex!);
        } else {
          TabConsts.pageList.add(widget.currentIndex!);
        }
      } else {
        TabConsts.pageList.removeAt(1);
        TabConsts.pageList.add(widget.currentIndex!);
      }
    }
  }
}
