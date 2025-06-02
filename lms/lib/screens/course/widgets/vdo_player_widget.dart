import 'package:flutter/material.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';

class VdoPlayerWidget extends StatefulWidget {
  final String otp;
  final String playbackInfo;
  final String? customPlayerId;

  const VdoPlayerWidget({
    super.key,
    required this.otp,
    required this.playbackInfo,
    this.customPlayerId,
  });

  @override
  State<VdoPlayerWidget> createState() => _VdoPlayerWidgetState();
}

class _VdoPlayerWidgetState extends State<VdoPlayerWidget> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    final embedInfo = EmbedInfo.streaming(
      otp: widget.otp,
      playbackInfo: widget.playbackInfo,
      embedInfoOptions: EmbedInfoOptions(
        autoplay: true,
        customPlayerId: widget.customPlayerId,
      ),
    );

    return Theme(
      data: Theme.of(context).copyWith(
        // Use AppCompat theme for VdoCipher player
        platform: TargetPlatform.android,
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.black,
          child: Stack(
            children: [
              VdoPlayer(
                embedInfo: embedInfo,
                onPlayerCreated: (controller) {
                  setState(() => _isLoading = false);
                },
                onError: (error) {
                  print('VdoCipher Error: ${error.message}');
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Video playback error: ${error.message}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                onFullscreenChange: (isFullscreen) {
                  print('Fullscreen changed: $isFullscreen');
                },
                controls: true,
              ),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
