part of opensnap;

void opensnapRouteInitializer(Router router, RouteViewFactory view) {
  router.root
    ..addRoute(name: 'signin', path: '/signin', enter: view('view/signin.html'), defaultRoute: true)
    ..addRoute(name: 'photo', path: '/photo', enter: view('view/photo.html'))
    ..addRoute(name: 'received', path: '/received', enter: view('view/snaps_received.html'))
    ..addRoute(name: 'sent', path: '/sent', enter: view('view/snaps_sent.html'))
    ..addRoute(name: 'admin', path: '/admin', enter: view('view/admin.html'));
}
