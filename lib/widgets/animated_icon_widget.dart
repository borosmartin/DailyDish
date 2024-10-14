import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

class AnimatedIconWidget extends StatefulWidget {
  final String gifAsset;
  final String pngAsset;

  const AnimatedIconWidget({super.key, required this.gifAsset, required this.pngAsset});

  @override
  State<AnimatedIconWidget> createState() => _AnimatedIconWidgetState();
}

class _AnimatedIconWidgetState extends State<AnimatedIconWidget> with TickerProviderStateMixin {
  late GifController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GifController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: Gif(
        image: AssetImage(widget.gifAsset),
        controller: _controller,
        autostart: Autostart.loop,
        placeholder: (context) => SizedBox(height: 50, width: 50, child: Image.asset(widget.pngAsset)),
        onFetchCompleted: () {
          _controller.reset();
          _controller.forward();
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
