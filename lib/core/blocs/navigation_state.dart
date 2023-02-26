enum NavItems { profile, exercises }

class NavigationState {
  NavItems _currentNavItem;

  NavigationState({currentNavItem}) : _currentNavItem = currentNavItem;
}
