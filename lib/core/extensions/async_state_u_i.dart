import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moteelz/core/network/exceptions/network_exception.dart';
import 'package:signals/signals_flutter.dart';


extension AsyncStateUI<T> on AsyncState<T> {
  Widget buildWith({
    required Widget Function(T data) dataBuilder,
    Widget Function()? loadingBuilder,
    Widget Function(Object error, StackTrace stackTrace)? errorBuilder,
    Widget Function()? emptyBuilder,
    bool skipLoadingOnReload = false,
    bool skipLoadingOnRefresh = true,
    bool skipError = false,
    VoidCallback? onRetry, 
    Widget Function()? reloading,
    Widget Function()? refreshing
  }) {
    return map(
      
      loading: () => loadingBuilder?.call() ?? _defaultLoading(),
      error: (error, stack) => errorBuilder?.call(error, stack) ??
          _defaultError(error, onRetry: onRetry), 
      data: (data) {
        return dataBuilder(data);
      },
     refreshing: refreshing, 
     reloading: reloading
    );
  }

 
  Widget _defaultLoading() => const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CupertinoActivityIndicator(),
        ),
      );

 
  Widget _defaultError(Object error, {VoidCallback? onRetry}) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: 8),
              Text(
                'Error: ${error.toString()}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              if (error is NetworkException && onRetry != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CupertinoButton.filled(
                    onPressed: onRetry,
                    child: const Text('Retry'),
                  ),
                ),
            ],
          ),
        ),
      );
}