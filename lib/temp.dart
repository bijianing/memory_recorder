import 'package:flutter/material.dart';

class AnimatedPositionedDemo extends StatefulWidget {
  @override
  _AnimatedPositionedDemoState createState() => _AnimatedPositionedDemoState();
}

class _AnimatedPositionedDemoState extends State<AnimatedPositionedDemo> with SingleTickerProviderStateMixin {
  double _width;

  AnimationCurve dropDownValue;
  bool selected = false;
  double pos;
  GlobalKey chipKey = GlobalKey();
  Size chipSize = Size(0, 0);
  double chipPostion = 0;
  bool animateAfterBuild = false;
  double animateDirection = 1; 

  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  
  double get width
  {
    return _width;
  }

  @override
  void initState() {
    pos = 0;
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )
    //..repeat(reverse: true)
    ;

    _controller.addStatusListener(chipAnimationStatusListener);

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _getSize() {
    final RenderBox renderBoxRed = chipKey.currentContext.findRenderObject();
    chipSize = renderBoxRed.size;
    chipPostion = renderBoxRed.localToGlobal(Offset.zero).dx;
  }

  void afterBuild(_) {
    _getSize();
    if (animateAfterBuild) {
      animateAfterBuild = false;
      _controller.forward();
    }
    print("after build CHIP: SIZE: $chipSize, POSITION: $chipPostion");
  }

  void chipAnimationStatusListener(AnimationStatus status) {
    _getSize();
    print("Chip Status:$status CHIP: SIZE: $chipSize, POSITION: $chipPostion");

  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(afterBuild);
    return Scaffold(
      appBar: AppBar(
        title: Text("AnimatedPositioned Demo"),
      ),
      body: Stack(
        children: <Widget>[
//          getPositionAnimation(),
          Positioned(
            top: 200,
            // width: 100.0 ,
            // height: 100.0 ,
            child: ChoiceChip(
              label: Text('hehe$pos'), 
              selected: true,
              onSelected: (value) {
                setState(() {
                  this.selected = !this.selected;
                });
                print("selected: ${this.selected}, value:$value");
              },
            ),
          ),
          getSlideAnimation(),
          Positioned(
            top: 0,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  DropdownButton<AnimationCurve>(
                    value:
                        dropDownValue == null ? curveOptions[0] : dropDownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.blueAccent),
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                    onChanged: (AnimationCurve newValue) {
                      setState(() {
                        dropDownValue = newValue;
                      });
                    },
                    items: curveOptions.map<DropdownMenuItem<AnimationCurve>>(
                        (AnimationCurve value) {
                      return DropdownMenuItem<AnimationCurve>(
                        value: value,
                        child: Text(value.curveName),
                      );
                    }).toList(),
                  ),
                  SizedBox(width: 20,),
                  RaisedButton(
                    color: Colors.blueAccent,
                    child: Text("Animate"),
                    onPressed: () {
                      animateAfterBuild = true;
                      _controller.stop();
                      _controller.reset();
                      setState(() {
                        _getSize();
                      });



                      // pos = pos + 1;
                      // if (_controller.status == AnimationStatus.forward) {
                      //   redraw = true;
                      //   _controller.stop();
                        
                      //   setState(() {
                      //     _getSize();
                      //   });
                      // } else {
                      //   _controller.reset();
                      //   _controller.forward();
                      // }

                      //   _controller.stop();
                      //   _controller.forward();
                      // setState(() {
                      //   // selected = !selected;
                      // });
                      // pos = pos + 1;



                      // if (_controller.status == AnimationStatus.forward) {
                      //   _controller.animateTo(pos);
                      // } else {
                      //   _controller.forward();
                      //   _controller.animateTo(pos);
                      // }
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 100,
            child: Column(
              children: <Widget>[
                dropDownValue != null
                    ? Text(
                        dropDownValue.curveCubic.toString(),
                      )
                    : Text(Curves.linear.toString()),
                SizedBox(
                  height: 20,
                ),
                dropDownValue != null
                    ? Text(
                        dropDownValue.description,
                      )
                    : Text("linear"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getPositionAnimation() {
    return AnimatedPositioned(
      top: 200,
      // width: selected ? 100.0 : 400.0,
      // height: selected ? 100.0 : 400.0,
      width: 100,
      height: 100,
      left: pos * 100,
      duration: Duration(seconds: 2),
      curve: dropDownValue != null ? dropDownValue.curveCubic : Curves.linear,
      child: ChoiceChip(label: Text('hehe'), selected: false),
    );
  }

  Widget getSlideAnimation() {
    double currentPosOffset = chipSize.width == 0 ? 0 : chipPostion / chipSize.width;

    if (currentPosOffset > 5) animateDirection = -1;
    if (currentPosOffset <= 0) animateDirection = 1;
    return Positioned(
      top: 200,
      // width: 100.0 ,
      // height: 100.0 ,
      child: SlideTransition(
      position: _controller.drive(
        CurveTween(
          curve: dropDownValue != null ? dropDownValue.curveCubic : Curves.linear
        ),
      ).drive(
        Tween<Offset>(
          begin: Offset(currentPosOffset, 0),
          end: Offset(currentPosOffset + animateDirection, 0),
        )
      )
      ,
      child: ChoiceChip(
        key: chipKey,
        label: Text('hehe$pos'), 
        selected: this.selected,
        onSelected: (value) {
          setState(() {
            this.selected = !this.selected;
          });
          print("selected: ${this.selected}, value:$value");
        },
      ),
      ),
    );
  }
}

List<AnimationCurve> curveOptions = [
  AnimationCurve(Curves.linear, "linear", "A linear animation curve."),
  AnimationCurve(
      Curves.decelerate,
      "decelerate",
      "A curve where the rate of change starts out quickly and then decelerates. "
          "Upside-down `f(t) = t²` parabola."),
  AnimationCurve(
      Curves.fastLinearToSlowEaseIn,
      "fastLinearToSlowEaseIn",
      "A curve that is very steep and linear at the beginning, "
          "but quickly flattens out and very slowly eases in."),
  AnimationCurve(Curves.ease, "ease",
      "A cubic animation curve that speeds up quickly and ends slowly."),
  AnimationCurve(Curves.easeIn, "easeIn",
      "A cubic animation curve that starts slowly and ends quickly."),
  AnimationCurve(Curves.easeInToLinear, "easeInToLinear",
      "A cubic animation curve that starts starts slowly and ends linearly."),
  AnimationCurve(Curves.easeInSine, "easeInSine",
      "A cubic animation curve that starts slowly and ends quickly."),
  AnimationCurve(Curves.easeOutSine, "easeOutSine",
      "A cubic animation curve that starts quickly and ends slowly."),
  AnimationCurve(Curves.easeInOutSine, "easeInOutSine",
      "A cubic animation curve that starts slowly, speeds up, and then ends slowly."),
  AnimationCurve(
      Curves.easeInQuad,
      "easeInQuad",
      "A cubic animation curve that starts slowly and ends quickly. "
          "Based on a quadratic equation where `f(t) = t²`"),
  AnimationCurve(Curves.easeOutQuad, "easeOutQuad",
      "A cubic animation curve that starts quickly and ends slowly."),
  AnimationCurve(Curves.easeInOutQuad, "easeInOutQuad",
      "A cubic animation curve that starts slowly, speeds up, and then ends slowly."),
  AnimationCurve(
      Curves.easeInCubic,
      "easeInCubic",
      "A cubic animation curve that starts "
          "slowly and ends quickly. This curve is based on a cubic equation where `f(t) = t³`."),
  AnimationCurve(Curves.easeOutCubic, "easeOutCubic",
      " A cubic animation curve that starts quickly and ends slowly."),
  AnimationCurve(Curves.easeInOutCubic, "easeInOutCubic",
      "A cubic animation curve that starts slowly, speeds up, and then ends slowly."),
  AnimationCurve(
      Curves.easeInQuart,
      "easeInQuart",
      "A cubic animation curve that starts slowly and ends quickly. "
          "This curve is based on a quartic equation where `f(t) = t⁴`."),
  AnimationCurve(Curves.easeOutQuart, "easeOutQuart",
      "A cubic animation curve that starts quickly and ends slowly."),
  AnimationCurve(Curves.easeInOutQuart, "easeInOutQuart",
      "A cubic animation curve that starts slowly, speeds up, and then ends slowly."),
  AnimationCurve(
      Curves.easeInQuint,
      "easeInQuint",
      "A cubic animation curve that starts slowly and ends quickly. "
          "This curve is based on a quintic equation where `f(t) = t⁵`"),
  AnimationCurve(Curves.easeOutQuint, "easeOutQuint",
      "A cubic animation curve that starts quickly and ends slowly."),
  AnimationCurve(Curves.easeInOutQuart, "easeInOutQuart",
      "A cubic animation curve that starts slowly, speeds up, and then ends slowly."),
  AnimationCurve(
      Curves.easeInExpo,
      "easeInExpo",
      "A cubic animation curve that starts slowly and ends quickly. "
          "This curve is based on an exponential equation where `f(t) = 2¹⁰⁽ᵗ⁻¹⁾`."),
  AnimationCurve(Curves.easeOutExpo, "easeOutExpo",
      "A cubic animation curve that starts quickly and ends slowly."),
  AnimationCurve(Curves.easeInOutExpo, "easeInOutExpo",
      "A cubic animation curve that starts slowly, speeds up, and then ends slowly."),
  AnimationCurve(
      Curves.easeInCirc,
      "easeInCirc",
      "A cubic animation curve that starts slowly and ends quickly. "
          "This curve is effectively the bottom-right quarter of a circle."),
  AnimationCurve(Curves.easeOutCirc, "easeOutCirc",
      "A cubic animation curve that starts quickly and ends slowly. This curve is effectively the top-left quarter of a circle."),
  AnimationCurve(Curves.easeInOutCirc, "easeInOutCirc",
      "A cubic animation curve that starts slowly, speeds up, and then ends slowly."),
  AnimationCurve(Curves.easeInBack, "easeInBack",
      "A cubic animation curve that starts slowly and ends quickly."),
  AnimationCurve(Curves.easeOutBack, "easeOutBack",
      "A cubic animation curve that starts quickly and ends slowly."),
  AnimationCurve(Curves.easeInOutBack, "easeInOutBack",
      "A cubic animation curve that starts slowly, speeds up, and then ends slowly."),
  AnimationCurve(Curves.easeInOut, "easeInOut",
      "A cubic animation curve that starts quickly and ends slowly."),
  AnimationCurve(Curves.linearToEaseOut, "linearToEaseOut",
      "A cubic animation curve that starts linearly and ends slowly."),
  AnimationCurve(Curves.fastOutSlowIn, "fastOutSlowIn",
      "A curve that starts quickly and eases into its final position."),
  AnimationCurve(
      Curves.slowMiddle,
      "slowMiddle",
      "A cubic animation curve that starts quickly, slows down, "
          "and then ends quickly."),
  AnimationCurve(Curves.bounceIn, "bounceIn",
      "An oscillating curve that grows in magnitude."),
  AnimationCurve(Curves.bounceOut, "bounceOut",
      "An oscillating curve that first grows and then shrink in magnitude."),
  AnimationCurve(Curves.bounceInOut, "bounceInOut",
      "An oscillating curve that first grows and then shrink in magnitude."),
  AnimationCurve(Curves.elasticIn, "elasticeIn",
      "An oscillating curve that grows in magnitude while overshooting its bounds."),
  AnimationCurve(Curves.elasticOut, "elasticOut",
      "An oscillating curve that shrinks in magnitude while overshooting its bounds."),
  AnimationCurve(Curves.elasticInOut, "elasticInOut",
      "An oscillating curve that grows and then shrinks in magnitude while overshooting its bounds."),
];

class AnimationCurve {
  Curve curveCubic;
  String curveName;
  String description;

  AnimationCurve(Curve cubic, String name, String desc) {
    this.curveCubic = cubic;
    this.curveName = name;
    this.description = desc;
  }
}
