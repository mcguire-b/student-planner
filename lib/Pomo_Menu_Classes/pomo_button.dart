import 'package:flutter/material.dart';
import 'pomo_timer.dart';

// This is a custom menu button widget For page navigation and eventually (TODO) pomodoro timer
class PomoButton extends StatefulWidget {
  // Class properties (variables specific to this widget)
  // List of menu items to be displayed in the dropdown
  final List<PomoMenu> menuItems;
  // Optional custom icon - the '?' means this can be null
  final IconData? customIcon;
  // Alignment of the menu on the screen
  final Alignment menuAlignment;
  final Function(bool)? visibilityChanged;

  // Constructor for the PomoButton
  const PomoButton({
    Key? key, // A key for identifying this widget uniquely
    required this.menuItems, // Must provide menu items
    this.customIcon, // Optional custom icon
    this.menuAlignment = Alignment.bottomRight, // Default alignment
    this.visibilityChanged,
  }) : super(key: key);

  @override
  State<PomoButton> createState() => _PomoButtonState();
}

class _PomoButtonState extends State<PomoButton> {
  // Controller for the MenuAnchor
  final MenuController _menuController = MenuController();
  //timer visibility tracker
  bool _isTimerVisible = false;

  //default menu options that will appear in every pomo menu
  List<PomoMenu> _getallMenuOptions(BuildContext context) {
    final List<PomoMenu> defaultItems = [
      //Pomodoro Timer Button 
      PomoMenu(
        value: 'Pomodoro Timer Toggle',
        label: _isTimerVisible ? 'Close Timer' : 'Open Timer',
        icon: Icons.access_alarm_rounded,
        onTap: () {
          setState(() {
            //changes boolean state to opposite state
            _isTimerVisible = !_isTimerVisible;
          });
        },
      ),
    ];

    return [...widget.menuItems, ...defaultItems];
  }

  @override
  Widget build(BuildContext context) {
    // get default items
    final allOptions = _getallMenuOptions(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        MenuAnchor(
          controller: _menuController,
          // Align the menu according to specified alignment
          alignmentOffset: const Offset(0, 50),

          // Builder for the menu button
          builder: (
            BuildContext context,
            MenuController controller,
            Widget? child,
          ) {
            return IconButton(
              // Use custom icon or default alarm icon
              icon: Icon(widget.customIcon ?? Icons.access_alarm_outlined),
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
            );
          },
          // Define menu style and items
          menuChildren:
              allOptions.map((PomoMenu item) {
                return MenuItemButton(
                  // Style the menu item TODO
                  // Handle menu item selection
                  onPressed: () {
                    // Close the menu
                    _menuController.close();
                    // Call the callback if provided
                    if (item.onTap != null) {
                      item.onTap!();
                    }
                  },
                  // Menu item content
                  child: Row(
                    children: [
                      // Add an icon to the menu item if one is provided
                      if (item.icon != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(item.icon, color: Colors.grey[700]),
                        ),
                      // Text label for the menu item
                      Text(item.label),
                    ],
                  ),
                );
              }).toList(),
        ),
        if (_isTimerVisible) PomoTimer(),
      ],
    );
  }
}

// A model class to define the structure of menu items
class PomoMenu {
  // Properties of a menu item
  final String value; // Unique identifier for the menu item
  final String label; // Text displayed for the menu item
  final IconData? icon; // Optional icon for the menu item
  final VoidCallback? onTap; // Function to call when item is tapped

  // Constructor for PomoMenu
  const PomoMenu({
    required this.value, // Must provide a value
    required this.label, // Must provide a label
    this.icon, // Optional icon
    this.onTap, // Optional tap handler
  });
}
