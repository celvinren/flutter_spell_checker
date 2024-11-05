package com.example.flutter_spell_checker

import android.content.Context
import android.view.textservice.SentenceSuggestionsInfo
import android.view.textservice.TextServicesManager
import android.view.textservice.SpellCheckerSession
import android.view.textservice.SpellCheckerSession.SpellCheckerSessionListener
import android.view.textservice.SuggestionsInfo
import android.view.textservice.TextInfo
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterSpellCheckerPlugin */
class FlutterSpellCheckerPlugin: FlutterPlugin, MethodCallHandler, SpellCheckerSessionListener {
    private lateinit var channel: MethodChannel
    private var spellCheckerSession: SpellCheckerSession? = null
    private lateinit var context: Context
    private var resultCallback: Result? = null
    private var suggestionsCallback: ((SuggestionsInfo) -> Unit)? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_spell_checker")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "checkSpelling" -> {
                val text = call.argument<String>("text")
                if (text != null) {
                    this.resultCallback = result
                    startSpellCheck(text)
                } else {
                    result.error("INVALID_ARGUMENT", "Text is required", null)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun startSpellCheck(text: String) {
        if (spellCheckerSession == null) {
            val tsm = context.getSystemService(Context.TEXT_SERVICES_MANAGER_SERVICE) as TextServicesManager
            spellCheckerSession = tsm.newSpellCheckerSession(null, null, this, true)
        }
        
        // Split the input text into words and check each word for suggestions
        val words = text.split(" ")
        val totalWords = words.size
        val suggestions = mutableListOf<Map<String, Any>>()
        var wordsProcessed = 0  // Track how many words have been processed
    
        words.forEach { word ->
            if (word.isNotBlank()) {
                val textInfo = TextInfo(word)
                spellCheckerSession?.getSuggestions(textInfo, 5)  // Requesting 5 suggestions for each word
            }
        }
        
        this.suggestionsCallback = { result: SuggestionsInfo ->
            val originalWord = words[wordsProcessed]  // Get the original word for the result
            wordsProcessed++     
            val suggestionCount = result.suggestionsCount
            val wordSuggestions = mutableListOf<String>()
            
            if (suggestionCount > 0) {
                for (i in 0 until suggestionCount) {
                    wordSuggestions.add(result.getSuggestionAt(i))
                }
                val suggestionInfo = mapOf(
                    "word" to originalWord,
                    "suggestions" to wordSuggestions
                )
                suggestions.add(suggestionInfo)
            }
            
            // When all words are processed, return the results
            if (wordsProcessed == totalWords) {
                resultCallback?.success(suggestions)
                resultCallback = null
            }
        }
    }
    
    override fun onGetSuggestions(results: Array<out SuggestionsInfo>?) {
        if (results == null) {
            resultCallback?.success(emptyList<Map<String, Any>>())  // Return empty list if no results
            resultCallback = null
            return
        }
        
        results.forEach { result ->
            suggestionsCallback?.invoke(result)  // Process each suggestion result
        }
    }
    

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        spellCheckerSession?.close()
        spellCheckerSession = null
    }

    override fun onGetSentenceSuggestions(p0: Array<out SentenceSuggestionsInfo>?) {
        // Handle sentence-level suggestions if needed
    }
}
