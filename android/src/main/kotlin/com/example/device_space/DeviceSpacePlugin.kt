package com.example.device_space

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.os.StatFs
import android.os.Environment

public class DeviceSpacePlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var dataDirPath : String

  companion object {
      private const val CHANNEL_NAME = "device_space"
      private const val METHOD_GET_FREE_SPACE = "getFreeSpace"
      private const val METHOD_GET_TOTAL_SPACE = "getTotalSpace"
  }

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
    channel.setMethodCallHandler(this);
      dataDirPath = Environment.getDataDirectory().path;
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
      try {
          when (call.method) {
              METHOD_GET_FREE_SPACE -> {
                  val stat = StatFs(dataDirPath)
                  val bytesAvailable = stat.freeBytes
                  result.success(bytesAvailable)
              }

              METHOD_GET_TOTAL_SPACE -> {
                  val stat = StatFs(dataDirPath)
                  val bytesTotal = stat.totalBytes
                  result.success(bytesTotal)
              }

              else -> {
                  result.notImplemented()
              }
          }
      } catch (e: Exception) {
          result.error("ERROR", e.message, null)
      }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
