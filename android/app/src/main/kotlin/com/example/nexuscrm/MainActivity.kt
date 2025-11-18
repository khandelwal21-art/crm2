package com.example.nexuscrm

import android.Manifest
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import android.os.Build
import android.telephony.TelephonyCallback
import android.telephony.TelephonyManager
import android.telephony.TelephonyManager.CALL_STATE_OFFHOOK
import android.telephony.TelephonyManager.CALL_STATE_RINGING
import android.telephony.TelephonyManager.CALL_STATE_IDLE
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import android.util.Log


class MainActivity : FlutterActivity(){
    private val CHANNEL = "com.example.phone_state/events"
    private var eventSink:EventChannel.EventSink?=null
    private val TAG = "AutoDialerMainActivity"

    override  fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        Log.d(TAG, "configureFlutterEngine called, registering EventChannel")

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                @RequiresApi(Build.VERSION_CODES.S)
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    Log.d(TAG, "EventChannel  onListen called")

                    eventSink = events
                    startListeningPhoneState()
                }

                @RequiresApi(Build.VERSION_CODES.S)
                override fun onCancel(arguments: Any?) {
                    Log.d(TAG, "EventChannel onCancel called")

                    stopListeningPhoneState()
                    eventSink = null
                }
            }
        )

    }

    @RequiresApi(Build.VERSION_CODES.S)
    private fun startListeningPhoneState(){
        Log.d(TAG, "startListeningPhoneState called")

        val telephonyManager = getSystemService(TelephonyManager::class.java)
        // ✅ Check permission before registering callback
        if (ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.READ_PHONE_STATE
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            Log.w(TAG, "❌ Permission READ_PHONE_STATE not granted. Skipping listener registration.")
            return
        }

        telephonyManager.registerTelephonyCallback(mainExecutor,telephonyCallback)
        sendCallStateToFlutter(telephonyManager.callState)
    }

    @RequiresApi(Build.VERSION_CODES.S)
    private val telephonyCallback = object : TelephonyCallback(),TelephonyCallback.CallStateListener{
        override fun onCallStateChanged(state: Int) {
            val stateString = when(state) {
                CALL_STATE_IDLE -> "CALL_ENDED"
                CALL_STATE_OFFHOOK -> "CALL_STARTED"
                CALL_STATE_RINGING -> "CALL_RINGING"
                else -> "UNKNOWN"


            }
            Log.d(TAG, "Call state changed: $stateString")

            eventSink?.success(stateString);
        }

    }
    private fun sendCallStateToFlutter(state: Int) {
        val stateString = when (state) {
            TelephonyManager.CALL_STATE_IDLE -> "CALL_ENDED"
            TelephonyManager.CALL_STATE_OFFHOOK -> "CALL_STARTED"
            TelephonyManager.CALL_STATE_RINGING -> "CALL_RINGING"
            else -> "UNKNOWN"
        }
        eventSink?.success(stateString)
    }
    @RequiresApi(Build.VERSION_CODES.S)
    private fun stopListeningPhoneState(){
        val telephonyManager= getSystemService(TelephonyManager::class.java)
        telephonyManager.unregisterTelephonyCallback(telephonyCallback)    }

}