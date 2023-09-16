package com.example.demo_status

import android.content.ContentValues
import android.os.Build
import android.provider.MediaStore
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.IOException
import java.io.InputStream
import java.io.OutputStream

class MainActivity: FlutterActivity() {
    private val CHANNEL = "strory.task"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if(call.method == "saveToDocuments"){
                (call.arguments as String?)?.let {
                    result.success(saveToDocuments(it,"${filesDir}/${it}"))
                }
            } else if(call.method == "getVersion"){
                result.success(Build.VERSION.SDK_INT)
            }
        }
    }

    fun saveToDocuments(fileName : String, privatePath : String) : String?{
        if(Build.VERSION.SDK_INT>28){
            val documentCollection = MediaStore.Files.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
            val contentvalues = ContentValues().apply {
                put(MediaStore.Files.FileColumns.DISPLAY_NAME,fileName);
            }
            try {
                contentResolver.insert(documentCollection,contentvalues)?.also { uri ->
                    contentResolver.openOutputStream(uri)?.use { outputStream ->
                        val inputStream = FileInputStream(File(privatePath))
                        copy(inputStream,outputStream)
                        return "success"
                    }
                }
            } catch (e: IOException) {

            }
        }
        return null
    }

    @Throws(IOException::class)
    fun copy(input: InputStream?, output: OutputStream?): Int {
        val count = copyLarge(input!!, output!!)
        return if (count > Int.MAX_VALUE) {
            -1
        } else count.toInt()
    }


    private val DEFAULT_BUFFER_SIZE = 1024 * 4


    @Throws(IOException::class)
    fun copyLarge(input: InputStream, output: OutputStream): Long {
        val buffer = ByteArray(DEFAULT_BUFFER_SIZE)
        var count: Long = 0
        var n: Int
        while (-1 != input.read(buffer).also { n = it }) {
            output.write(buffer, 0, n)
            count += n.toLong()
        }
        return count
    }

}
