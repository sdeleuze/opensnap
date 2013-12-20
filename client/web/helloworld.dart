import 'package:angular/angular.dart';
import 'dart:html';

@NgController(selector: '[hello]', publishAs: 'ctrl')
class HelloController {

  String name;
  Http _http;

  HelloController(Http this._http) {
    querySelector("#check").onClick.listen((e) => _loadData());
  }
  
  void _loadData() {
    _http.get('http://localhost:8080/hello').then((HttpResponse response) {
      name = response.data;
    });
  }

}

class MyAppModule extends Module {
  MyAppModule() {
    type(HelloController);
  }
}

main() {
  var module = new AngularModule().type(HelloController);
  ngBootstrap(module: new MyAppModule());
}