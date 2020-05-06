import 'package:flutter/material.dart';


class _AnimationRange {
  final double start;
  final double end;

  _AnimationRange({
    this.start: 0,
    this.end: 0
  });
}

class _ChipData {
  final String label;
  bool selected;
  bool onTop;
  _AnimatedChip widget;

  _ChipData({
    this.label: '',
    this.selected: false,
    this.widget,
    this.onTop: false,
  });
}


class _AnimatedChip extends StatelessWidget {
  final double top;
  final String label;
  final AnimationController animationController;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final _AnimationRange animationInterval;
  final _AnimationRange postionRange;
  final GlobalKey chipKey = GlobalKey();
  final double elevation;

  _AnimatedChip(
    this.animationController,
    this.label,
    this.top,
    this.animationInterval,
    this.postionRange,
    {
      Key key,
      this.selected : false,
      this.onSelected,
      this.elevation: 0,
    }
  ):super(key: key);



  @override
  Widget build(BuildContext context) {
    print('CHIP[$label]: Interval ${animationInterval.start} - ${animationInterval.end}, Pos:${postionRange.start} - ${postionRange.end}');
    return SlideTransition(
      position: animationController.drive(
        CurveTween(
          curve: Interval(animationInterval.start, animationInterval.end, curve: Curves.ease)
        ),
      ).drive(
        Tween<Offset>(
          begin: Offset(postionRange.start, top),
          end: Offset(postionRange.end, top),
        )
      )
      ,
      child: ChoiceChip(
        key: chipKey,
        elevation: elevation,
        label: Text(label), 
        selected: selected,
        onSelected: (value) {
          onSelected(value);
        },
      ),
    );
  }

  Size get size
  {
    final RenderBox renderBoxRed = chipKey.currentContext.findRenderObject();
    return renderBoxRed.size;
  }

  double getXPosition(GlobalKey ancestorKey)
  {
    final RenderBox thisRenderBox = chipKey.currentContext.findRenderObject();
    final RenderBox ancestorRenderBox = ancestorKey.currentContext.findRenderObject();
    return thisRenderBox.localToGlobal(Offset.zero, ancestor: ancestorRenderBox).dx;
  }
}

enum _AnimationType {
  None,
  AnimationPrepare,
  DoAnimation,
}

class ChipSelect extends StatefulWidget {
  final List<String> initChipLabels;
  final double padding;
  final double chipElevation;

  ChipSelect({
    Key key,
    this.initChipLabels,
    this.padding,
    this.chipElevation: 0,
  }): super(key: key);

  @override
  _ChipSelectState createState() => _ChipSelectState();
}

class _ChipSelectState extends State<ChipSelect> with SingleTickerProviderStateMixin{
  AnimationController _controller;
  final GlobalKey stackKey = GlobalKey();
  _AnimationType _animation;
  List<_ChipData> _chipList;
  final double animationStartOffset = 0;
  final double animationSeconds = 0.5;
  double _width;
  double _height;
  double _absPadding;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );

    // _controller.addStatusListener(_animationStatusListener);
    // _controller.addListener(_animationListener);

    if (widget.initChipLabels != null) {
      _chipList = widget.initChipLabels.map(
        (c) => _ChipData(
          label: c,
          selected: false,
          onTop: false,
          widget: _newChip(c, false, _AnimationRange(), _AnimationRange())
        )
        
      ).toList();
    } else {
      _chipList = [];
    }
    _animation = _AnimationType.AnimationPrepare;

  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // void _animationStatusListener(AnimationStatus status) {
  //   print("Chip Status:$status");
  // }
  // void _animationListener() {
  //  print("Chip listener:-------------------------------");
  // }
  

  void afterBuild(_) {
    if (_height == null || _height == 0) {
      _height = _chipList[0].widget.size.height;
      _absPadding = widget.padding * _height;
      _height += (_absPadding * 2);
    }
    switch(_animation) {
      case _AnimationType.None:
        break;

      case _AnimationType.AnimationPrepare:
        doNewAnimation('', false);
        _animation = _AnimationType.DoAnimation;
        break;

      case _AnimationType.DoAnimation:
        _controller.forward();
        _animation = _AnimationType.None;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(afterBuild);
    List<_AnimatedChip> widgetList = [];
    _chipList.forEach((c) {
      if (c.selected == false && c.onTop == false) {
        widgetList.add(c.widget);
      }
    });
    
    _chipList.forEach((c) {
      if (c.selected == true && c.onTop == false) {
        widgetList.add(c.widget);
      }
    });
    
    _chipList.forEach((c) {
      if (c.onTop == true) {
        widgetList.add(c.widget);
      }
    });
    
    return Container(
          width: _width,
          height: _height,
          child: ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Container(
          width: _width,
          height: _height,
          child: Stack(
            key: stackKey,
            alignment: AlignmentDirectional.topStart,
            children:  widgetList,
          ),
        ),
      ]
    )
    );
  }

  void doNewAnimation(String label, bool value) {
    if (label != '') {
      var _filteredList = _chipList.where((c) => c.label == label).toList();
      assert(_filteredList.length == 1);
      _filteredList[0].selected = value;
      _filteredList[0].onTop = true;
    }

    double animationTotalLen = ((_chipList.length - 1) * animationStartOffset) + 1;
    int duration = (animationTotalLen * animationSeconds * 1000).toInt();
    _controller.duration = Duration(milliseconds: duration);
    double starOffset;
    double xPosition = 0;
    double currentPos;
    double currentWidth;

    int j = 0;
    for (var i = 0; i < 2; i++) {
      _chipList.forEach((c) {
        if (i == 0) {
          if (c.selected != true) return;
        } else {
          if (c.selected != false) return;
        }
        starOffset = j * animationStartOffset;
        currentPos = c.widget.getXPosition(stackKey);
        currentWidth = c.widget.size.width;
        c.widget = _newChip(
          c.label,
          c.selected,
          _AnimationRange(
            start: starOffset / animationTotalLen,
            end: (starOffset + 1) / animationTotalLen
          ),
          _AnimationRange(
            start: currentPos / currentWidth,
            end: xPosition / currentWidth,
          ),
        );

        xPosition += (currentWidth + _absPadding);
        j++;
      });
    }
    _width = xPosition;

    setState(() {
    });

  }

  _AnimatedChip _newChip(String label, bool selected, _AnimationRange interval, _AnimationRange positionRange) {
    return _AnimatedChip(
      _controller,
      label,
      widget.padding,
      interval,
      positionRange,
      selected: selected,
      elevation: widget.chipElevation,
      onSelected: (value) {
        _animation = _AnimationType.DoAnimation;
        _controller.reset();
        doNewAnimation(label, value);
      },
    );
  }

  void addChip(String label) {
//    _chipList.add(_newChip(label));
  }

}


class ChipSelectDemo extends StatefulWidget {
  @override
  _ChipSelectDemoState createState() => _ChipSelectDemoState();
}

class _ChipSelectDemoState extends State<ChipSelectDemo> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AnimatedPositioned Demo"),
      ),
      body: ChipSelect(
        initChipLabels: <String>['abc', 'def', 'English', 'excise', 'moring', 'llkjkdf', 'nihao', '成功', '失敗'],
        padding: 0.05,
        chipElevation: 3,
      )
    );

  }
}