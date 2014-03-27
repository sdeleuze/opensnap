part of opensnap;

class Routes {
  
  Routes() {
    
  }
  
  void call(Router router, RouteViewFactory views)  {
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
  
}