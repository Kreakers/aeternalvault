package com.aeternavault.aeternavault

import android.app.Activity
import android.content.Intent
import android.database.sqlite.SQLiteDatabase
import android.os.Build
import android.os.Bundle
import android.service.autofill.Dataset
import android.service.autofill.FillResponse
import android.util.Base64
import android.view.autofill.AutofillId
import android.view.autofill.AutofillManager
import android.view.autofill.AutofillValue
import android.widget.RemoteViews
import androidx.annotation.RequiresApi
import androidx.biometric.BiometricManager
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey
import org.json.JSONObject
import java.security.MessageDigest
import javax.crypto.Cipher
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec

@RequiresApi(Build.VERSION_CODES.O)
class AutofillAuthActivity : FragmentActivity() {

    companion object {
        const val EXTRA_ITEM_ID = "item_id"
        const val EXTRA_USERNAME_ID = "username_autofill_id"
        const val EXTRA_PASSWORD_ID = "password_autofill_id"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val itemId = intent.getIntExtra(EXTRA_ITEM_ID, -1)
        if (itemId == -1) {
            setResult(Activity.RESULT_CANCELED)
            finish()
            return
        }

        val usernameId: AutofillId? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra(EXTRA_USERNAME_ID, AutofillId::class.java)
        } else {
            @Suppress("DEPRECATION")
            intent.getParcelableExtra(EXTRA_USERNAME_ID)
        }

        val passwordId: AutofillId? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra(EXTRA_PASSWORD_ID, AutofillId::class.java)
        } else {
            @Suppress("DEPRECATION")
            intent.getParcelableExtra(EXTRA_PASSWORD_ID)
        }

        showBiometricPrompt(itemId, usernameId, passwordId)
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Biometric
    // ──────────────────────────────────────────────────────────────────────────

    private fun showBiometricPrompt(itemId: Int, usernameId: AutofillId?, passwordId: AutofillId?) {
        val canAuth = BiometricManager.from(this).canAuthenticate(
            BiometricManager.Authenticators.BIOMETRIC_STRONG or
            BiometricManager.Authenticators.DEVICE_CREDENTIAL
        )

        if (canAuth != BiometricManager.BIOMETRIC_SUCCESS) {
            // No biometric available — proceed directly with stored master key
            performAutofill(itemId, usernameId, passwordId)
            return
        }

        val prompt = BiometricPrompt(
            this,
            ContextCompat.getMainExecutor(this),
            object : BiometricPrompt.AuthenticationCallback() {
                override fun onAuthenticationSucceeded(result: BiometricPrompt.AuthenticationResult) {
                    performAutofill(itemId, usernameId, passwordId)
                }

                override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                    setResult(Activity.RESULT_CANCELED)
                    finish()
                }

                override fun onAuthenticationFailed() {
                    // User's biometric was not recognized — they may retry; don't finish yet
                }
            }
        )

        prompt.authenticate(
            BiometricPrompt.PromptInfo.Builder()
                .setTitle("Aeterna Vault")
                .setSubtitle("Otomatik doldurma için kimlik doğrulama")
                .setAllowedAuthenticators(
                    BiometricManager.Authenticators.BIOMETRIC_STRONG or
                    BiometricManager.Authenticators.DEVICE_CREDENTIAL
                )
                .build()
        )
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Autofill fill
    // ──────────────────────────────────────────────────────────────────────────

    private fun performAutofill(itemId: Int, usernameId: AutofillId?, passwordId: AutofillId?) {
        try {
            val masterKey = readMasterKey() ?: run {
                setResult(Activity.RESULT_CANCELED)
                finish()
                return
            }
            val (encContent, itemTitle) = readEncryptedItem(itemId) ?: run {
                setResult(Activity.RESULT_CANCELED)
                finish()
                return
            }

            val decrypted = decryptAesCbc(encContent, masterKey)
            val json = JSONObject(decrypted)
            val username = json.optString("f1", "")
            val password = json.optString("f2", "")

            val datasetBuilder = Dataset.Builder()

            usernameId?.let { id ->
                val pres = RemoteViews(packageName, R.layout.autofill_list_item).apply {
                    setTextViewText(R.id.autofill_item_title, username.ifEmpty { itemTitle })
                    setTextViewText(R.id.autofill_item_subtitle, "Aeterna Vault")
                }
                datasetBuilder.setValue(id, AutofillValue.forText(username), pres)
            }

            passwordId?.let { id ->
                val pres = RemoteViews(packageName, R.layout.autofill_list_item).apply {
                    setTextViewText(R.id.autofill_item_title, "••••••••")
                    setTextViewText(R.id.autofill_item_subtitle, "Aeterna Vault")
                }
                datasetBuilder.setValue(id, AutofillValue.forText(password), pres)
            }

            val fillResponse = FillResponse.Builder()
                .addDataset(datasetBuilder.build())
                .build()

            setResult(
                Activity.RESULT_OK,
                Intent().putExtra(AutofillManager.EXTRA_AUTHENTICATION_RESULT, fillResponse)
            )
        } catch (_: Exception) {
            setResult(Activity.RESULT_CANCELED)
        }
        finish()
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Secure storage — reads master key written by flutter_secure_storage
    // ──────────────────────────────────────────────────────────────────────────

    private fun readMasterKey(): String? {
        return try {
            val masterKey = MasterKey.Builder(this)
                .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
                .build()
            EncryptedSharedPreferences.create(
                this,
                "FlutterSecureStorage",
                masterKey,
                EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
            ).getString("vault_master_key", null)
        } catch (_: Exception) {
            null
        }
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Database
    // ──────────────────────────────────────────────────────────────────────────

    private fun readEncryptedItem(itemId: Int): Pair<String, String>? {
        return try {
            val dbPath = getDatabasePath("aeterna_vault.db").absolutePath
            SQLiteDatabase.openDatabase(dbPath, null, SQLiteDatabase.OPEN_READONLY).use { db ->
                db.query(
                    "vault_items",
                    arrayOf("secretContent", "title"),
                    "id = ?",
                    arrayOf(itemId.toString()),
                    null, null, null
                ).use { cursor ->
                    if (cursor.moveToFirst()) {
                        Pair(cursor.getString(0) ?: "", cursor.getString(1) ?: "")
                    } else null
                }
            }
        } catch (_: Exception) {
            null
        }
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Decryption — mirrors EncryptionService in Dart:
    //   key  = SHA-256(masterKey)
    //   data = base64(iv) + ":" + base64(ciphertext)  [new format]
    //        | base64(ciphertext)                       [legacy, zero-IV]
    // ──────────────────────────────────────────────────────────────────────────

    private fun decryptAesCbc(encryptedText: String, masterKey: String): String {
        val keyBytes = MessageDigest.getInstance("SHA-256")
            .digest(masterKey.toByteArray(Charsets.UTF_8))
        val secretKey = SecretKeySpec(keyBytes, "AES")

        val colonIdx = encryptedText.indexOf(':')
        return if (colonIdx != -1) {
            // New format: base64(iv):base64(ciphertext)
            val ivBytes = Base64.decode(encryptedText.substring(0, colonIdx), Base64.DEFAULT)
            val cipherBytes = Base64.decode(encryptedText.substring(colonIdx + 1), Base64.DEFAULT)
            val cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")
            cipher.init(Cipher.DECRYPT_MODE, secretKey, IvParameterSpec(ivBytes))
            String(cipher.doFinal(cipherBytes), Charsets.UTF_8)
        } else {
            // Legacy format: base64(ciphertext) with zero IV
            val cipherBytes = Base64.decode(encryptedText, Base64.DEFAULT)
            val cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")
            cipher.init(Cipher.DECRYPT_MODE, secretKey, IvParameterSpec(ByteArray(16)))
            String(cipher.doFinal(cipherBytes), Charsets.UTF_8)
        }
    }
}
