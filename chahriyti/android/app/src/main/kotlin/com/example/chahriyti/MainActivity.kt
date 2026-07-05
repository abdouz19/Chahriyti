package com.example.chahriyti

import android.content.Intent
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.TimeZone

class MainActivity : FlutterActivity() {
    private val timezoneChannel = "com.example.chahriyti/timezone"
    private val oemChannel = "com.example.chahriyti/oem"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, timezoneChannel)
            .setMethodCallHandler { call, result ->
                if (call.method == "getTimezone") {
                    result.success(TimeZone.getDefault().id)
                } else {
                    result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, oemChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getManufacturer" -> result.success(Build.MANUFACTURER.lowercase())
                    "openAutoStartSettings" -> result.success(tryOpenAutoStart())
                    else -> result.notImplemented()
                }
            }
    }

    private fun tryOpenAutoStart(): Boolean {
        val manufacturer = Build.MANUFACTURER.lowercase()

        val intents: List<Intent> = when {
            manufacturer == "oppo" || manufacturer == "realme" -> listOf(
                Intent().setClassName(
                    "com.coloros.safecenter",
                    "com.coloros.safecenter.permission.PermissionManagerActivity"
                ),
                Intent().setClassName(
                    "com.oppo.safe",
                    "com.oppo.safe.permission.PermissionManagerActivity"
                ),
                Intent().setClassName(
                    "com.coloros.oppoguardelf",
                    "com.coloros.oppoguardelf.autostart.AutoStartManageActivity"
                ),
            )
            manufacturer == "xiaomi" || manufacturer == "redmi" -> listOf(
                Intent().setClassName(
                    "com.miui.securitycenter",
                    "com.miui.permcenter.autostart.AutoStartManagementActivity"
                ),
                Intent().setClassName(
                    "com.miui.securitycenter",
                    "com.miui.securitycenter.MainActivity"
                ),
            )
            manufacturer == "huawei" || manufacturer == "honor" -> listOf(
                Intent().setClassName(
                    "com.huawei.systemmanager",
                    "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity"
                ),
                Intent().setClassName(
                    "com.huawei.systemmanager",
                    "com.huawei.systemmanager.optimize.process.ProtectActivity"
                ),
            )
            manufacturer == "vivo" -> listOf(
                Intent().setClassName(
                    "com.vivo.permissionmanagement",
                    "com.vivo.permissionmanagement.tabcontrolview.TabControlActivity"
                ),
            )
            manufacturer == "oneplus" -> listOf(
                Intent().setClassName(
                    "com.coloros.safecenter",
                    "com.coloros.safecenter.permission.PermissionManagerActivity"
                ),
                Intent().setClassName(
                    "com.oneplus.security",
                    "com.oneplus.security.chainlaunch.view.ChainLaunchAppListActivity"
                ),
            )
            else -> emptyList()
        }

        for (intent in intents) {
            try {
                startActivity(intent)
                return true
            } catch (_: Exception) {
                // try next
            }
        }
        return false
    }
}
