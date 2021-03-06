import 'package:flutter/material.dart';
import 'dart:math' as Math;

class AnimacionesPage extends StatelessWidget {
  // const AnimacionesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CuadradoAnimado(),
      )
    );
  }
}

class CuadradoAnimado extends StatefulWidget {

  @override
  _CuadradoAnimadoState createState() => _CuadradoAnimadoState();
}

class _CuadradoAnimadoState extends State<CuadradoAnimado> with SingleTickerProviderStateMixin {
  
  AnimationController controller;
  Animation<double> rotacion;
  Animation<double> opacidad;
  Animation<double> opacidadOut;
  Animation<double> moverDerecha;
  Animation<double> agrandar;


  @override
  void initState() {
    
    controller = new AnimationController(
      vsync: this, duration: Duration( milliseconds: 4000 ) );

    rotacion = Tween(begin: 0.0, end: 2 * Math.pi ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut)
    );

    opacidad = Tween(begin: 0.1 , end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Interval(0.0 , 1.0, curve: Curves.easeOut))
    );

    opacidadOut = Tween(begin: 0.0 , end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Interval(0.75 , 1.0))
    );

    moverDerecha = Tween(begin: 0.0, end: 200.0 ).animate( controller );

    agrandar = Tween(begin: 0.0, end: 1.0 ).animate( controller );

    controller.addListener(() {
      
      // print('Status: ${ controller.status }');
      if ( controller.status == AnimationStatus.completed ) {
        controller.reset();
       // controller.forward();
      } 
    });


    super.initState();
  }

  @override
  void dispose() {
    
    controller.dispose();

    super.dispose();
  }
  
  
  @override
  Widget build(BuildContext context) {

    controller.forward(); // SI NO QUIERO QUE SE REPRODUZCA CASDA QUE GUARDO CAMBIOS LO PUEDO AGREGAR AL INITSTATE


    return AnimatedBuilder(
      animation: controller,
      child: _Rectangulo(),
      builder: (BuildContext context, Widget child) {

      // print('Opacidad: ${ opacidad.value }');

        return Transform.scale(
            scale: agrandar.value,
            child: Transform.translate(
            offset: Offset( moverDerecha.value, 0.0),
            child: Transform.rotate(
                angle: rotacion.value,
                child: Opacity(
                opacity: opacidad.value - opacidadOut.value,
                child: child,
                ) // esto es para que haga dos animaciones simultaneas
              ),
          ),
        );
      },
    );
  }
}



class _Rectangulo extends StatelessWidget {
  @override
  Widget build( BuildContext context ) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.blue
      ),
    );
  }
}