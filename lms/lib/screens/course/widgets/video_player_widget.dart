import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import './vdo_player_widget.dart';
import '../utils/vdo_cipher_helper.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoId;

  const VideoPlayerWidget({super.key, required this.videoId});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  bool _isLoading = true;
  Map<String, dynamic>? _vdoCipherInfo;
  String? _error;
  String? _currentVideoId;

  @override
  void initState() {
    super.initState();
    _currentVideoId = widget.videoId;
    _loadVideoData();
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload video data if video ID changes
    if (oldWidget.videoId != widget.videoId) {
      setState(() {
        _isLoading = true;
        _error = null;
        _vdoCipherInfo = null;
        _currentVideoId = widget.videoId;
      });
      _loadVideoData();
    }
  }

  Future<void> _loadVideoData() async {
    if (!mounted) return;

    try {
      // Show emulator warning if running on Android emulator
      if (defaultTargetPlatform == TargetPlatform.android &&
          !kReleaseMode &&
          await VdoCipherHelper.isEmulator()) {
        setState(() {
          _error =
              'VdoCipher video playback is not supported on Android emulator. Please test on a real device.';
          _isLoading = false;
        });
        return;
      }

      if (widget.videoId.isEmpty) {
        setState(() {
          _error = 'No video ID provided';
          _isLoading = false;
        });
        return;
      }

      final vdoCipherData = await VdoCipherHelper.getVdoCipherOTP(
        widget.videoId,
      );
      if (!mounted) return;

      // Only update state if the video ID hasn't changed while loading
      if (_currentVideoId == widget.videoId) {
        setState(() {
          _vdoCipherInfo = vdoCipherData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      // Only update error if the video ID hasn't changed while loading
      if (_currentVideoId == widget.videoId) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.black87,
      child: Theme(
        data: Theme.of(context).copyWith(platform: TargetPlatform.android),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    // Show loading state
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    // Show error state
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            _error!,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Show VdoCipher player if we have valid data
    if (_vdoCipherInfo != null &&
        _vdoCipherInfo!['otp'] is String &&
        _vdoCipherInfo!['playbackInfo'] is String) {
      return VdoPlayerWidget(
        key: ValueKey(widget.videoId), // Add key to force widget recreation
        otp: _vdoCipherInfo!['otp'],
        playbackInfo: _vdoCipherInfo!['playbackInfo'],
      );
    }

    // Fallback error state
    return const Center(
      child: Text(
        'Unable to load video player',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
