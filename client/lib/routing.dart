library open_snap_routing;

import 'package:angular/angular.dart';

void OpenSnapRouteInitializer(Router router, ViewFactory views) {
  
  views.configure({
    'signin': ngRoute(
      path: '/signin',
      defaultRoute: true,
      view: 'view/signin.html'),
    'photo': ngRoute(
      path: '/photo',
      view: 'view/photo.html'),
    'snaps': ngRoute(
      path: '/snaps',
      view: 'view/snaps.html')
  });
}