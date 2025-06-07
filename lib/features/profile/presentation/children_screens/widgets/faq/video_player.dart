import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:bpg_retail/core/widgets/base/base_loading.dart';
import 'package:video_player/video_player.dart';

class FAQVideoPlayer extends StatefulWidget {
  const FAQVideoPlayer({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<FAQVideoPlayer> createState() => _FAQVideoPlayerState();
}

class _FAQVideoPlayerState extends State<FAQVideoPlayer> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _controller.initialize().then(
          (_) => setState(
            () {
              _chewieController = ChewieController(
                videoPlayerController: _controller,
                aspectRatio: _controller.value.aspectRatio,
                autoInitialize: true,
                autoPlay: true,
                looping: false,
                errorBuilder: (context, errorMessage) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
                placeholder: Container(
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            },
          ),
        );
  }

  @override
  void dispose() {
    _chewieController.videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FAQVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Chewie(controller: _chewieController)
        : const BaseLoading();
  }
}
