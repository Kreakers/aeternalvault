package com.aeternavault.aeternavault

import android.app.PendingIntent
import android.app.assist.AssistStructure
import android.content.Intent
import android.database.sqlite.SQLiteDatabase
import android.os.Build
import android.os.CancellationSignal
import android.service.autofill.AutofillService
import android.service.autofill.Dataset
import android.service.autofill.FillCallback
import android.service.autofill.FillRequest
import android.service.autofill.FillResponse
import android.service.autofill.SaveCallback
import android.service.autofill.SaveRequest
import android.view.autofill.AutofillId
import android.view.autofill.AutofillValue
import android.widget.RemoteViews
import androidx.annotation.RequiresApi

@RequiresApi(Build.VERSION_CODES.O)
class AeternaAutofillService : AutofillService() {

    override fun onFillRequest(
        request: FillRequest,
        cancellationSignal: CancellationSignal,
        callback: FillCallback
    ) {
        val fillContext = request.fillContexts.lastOrNull() ?: run {
            callback.onSuccess(null)
            return
        }

        val parsedFields = parseStructure(fillContext.structure)
        if (!parsedFields.hasLoginFields()) {
            callback.onSuccess(null)
            return
        }

        val items = getPasswordItems()
        if (items.isEmpty()) {
            callback.onSuccess(null)
            return
        }

        val responseBuilder = FillResponse.Builder()

        items.forEach { item ->
            val authIntent = Intent(this, AutofillAuthActivity::class.java).apply {
                putExtra(AutofillAuthActivity.EXTRA_ITEM_ID, item.id)
                putExtra(AutofillAuthActivity.EXTRA_USERNAME_ID, parsedFields.usernameId)
                putExtra(AutofillAuthActivity.EXTRA_PASSWORD_ID, parsedFields.passwordId)
            }
            val pendingIntent = PendingIntent.getActivity(
                this,
                item.id,
                authIntent,
                PendingIntent.FLAG_CANCEL_CURRENT or PendingIntent.FLAG_MUTABLE
            )

            val presentation = RemoteViews(packageName, R.layout.autofill_list_item).apply {
                setTextViewText(R.id.autofill_item_title, item.title)
                setTextViewText(R.id.autofill_item_subtitle, "Aeterna Vault")
            }

            val datasetBuilder = Dataset.Builder()
            parsedFields.usernameId?.let { id ->
                datasetBuilder.setValue(id, AutofillValue.forText(""), presentation)
            }
            parsedFields.passwordId?.let { id ->
                datasetBuilder.setValue(
                    id,
                    AutofillValue.forText(""),
                    RemoteViews(packageName, R.layout.autofill_list_item).apply {
                        setTextViewText(R.id.autofill_item_title, item.title)
                        setTextViewText(R.id.autofill_item_subtitle, "Aeterna Vault")
                    }
                )
            }
            datasetBuilder.setAuthentication(pendingIntent.intentSender)
            responseBuilder.addDataset(datasetBuilder.build())
        }

        callback.onSuccess(responseBuilder.build())
    }

    override fun onSaveRequest(request: SaveRequest, callback: SaveCallback) {
        callback.onSuccess()
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Structure parsing
    // ──────────────────────────────────────────────────────────────────────────

    private fun parseStructure(structure: AssistStructure): ParsedFields {
        val parsed = ParsedFields()
        for (i in 0 until structure.windowNodeCount) {
            traverseNode(structure.getWindowNodeAt(i).rootViewNode, parsed)
        }
        return parsed
    }

    private fun traverseNode(node: AssistStructure.ViewNode, parsed: ParsedFields) {
        val hints = node.autofillHints
        if (hints != null) {
            for (hint in hints) {
                when (hint) {
                    android.view.View.AUTOFILL_HINT_USERNAME,
                    android.view.View.AUTOFILL_HINT_EMAIL_ADDRESS -> {
                        if (parsed.usernameId == null) parsed.usernameId = node.autofillId
                    }
                    android.view.View.AUTOFILL_HINT_PASSWORD -> {
                        if (parsed.passwordId == null) parsed.passwordId = node.autofillId
                    }
                }
            }
        }

        // Heuristic fallback when autofill hints are missing
        if (parsed.usernameId == null && isUsernameField(node)) {
            parsed.usernameId = node.autofillId
        }
        if (parsed.passwordId == null && isPasswordField(node.inputType)) {
            parsed.passwordId = node.autofillId
        }

        for (i in 0 until node.childCount) {
            traverseNode(node.getChildAt(i), parsed)
        }
    }

    private fun isUsernameField(node: AssistStructure.ViewNode): Boolean {
        val hint = (node.hint ?: "").lowercase()
        val idEntry = (node.idEntry ?: "").lowercase()
        val keywords = listOf("user", "email", "login", "phone", "kullanici", "eposta", "mail", "username")
        return keywords.any { hint.contains(it) || idEntry.contains(it) }
    }

    private fun isPasswordField(inputType: Int): Boolean {
        val variation = inputType and android.text.InputType.TYPE_MASK_VARIATION
        return variation == android.text.InputType.TYPE_TEXT_VARIATION_PASSWORD ||
               variation == android.text.InputType.TYPE_TEXT_VARIATION_WEB_PASSWORD
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Database
    // ──────────────────────────────────────────────────────────────────────────

    private fun getPasswordItems(): List<VaultItemInfo> {
        val items = mutableListOf<VaultItemInfo>()
        try {
            val dbPath = getDatabasePath("aeterna_vault.db").absolutePath
            SQLiteDatabase.openDatabase(dbPath, null, SQLiteDatabase.OPEN_READONLY).use { db ->
                db.query(
                    "vault_items",
                    arrayOf("id", "title"),
                    "category = ?",
                    arrayOf("Şifre"),
                    null, null, "title ASC"
                ).use { cursor ->
                    while (cursor.moveToNext()) {
                        items.add(
                            VaultItemInfo(
                                id = cursor.getInt(0),
                                title = cursor.getString(1) ?: ""
                            )
                        )
                    }
                }
            }
        } catch (_: Exception) {
            // DB not accessible yet (vault not set up or first launch)
        }
        return items
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Data classes
    // ──────────────────────────────────────────────────────────────────────────

    data class ParsedFields(
        var usernameId: AutofillId? = null,
        var passwordId: AutofillId? = null
    ) {
        fun hasLoginFields() = usernameId != null || passwordId != null
    }

    data class VaultItemInfo(val id: Int, val title: String)
}
