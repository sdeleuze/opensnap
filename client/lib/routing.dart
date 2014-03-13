library open_snap_routing;

import 'package:angular/angular.dart';

class OpenSnapRouteInitializer implements RouteInitializer {
  
  init(Router router, ViewFactory view) {
    router.root
      ..addRoute(
          name: 'signin',
          defaultRoute: true,
          path: '/signin',
          enter: view('view/signin.html'))
      ..addRoute(
          name: 'photo',
          path: '/photo',
          enter: view('view/photo.html'))
      ..addRoute(
          name: 'snaps',
          path: '/snaps',
          enter: view('view/snaps.html'));
    
  }
}