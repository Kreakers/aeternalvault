# CLAUDE.local.md Şablonu

Bu dosyayı kişisel geçersiz kılmalar için proje kök dizinine `CLAUDE.local.md` olarak kopyalayın.
Bu dosya gitignored'dır ve commit edilmez.

```markdown
# Kişisel Tercihler

## Model Tercihleri
- Karmaşık tasarım görevleri için Opus tercih edilir
- Hızlı aramalar ve basit düzenlemeler için Haiku kullanılır

## İş Akışı Tercihleri
- Kod değişikliklerinden sonra her zaman testleri çalıştır
- %60 kullanımda bağlamı proaktif olarak sıkıştır
- İlgisiz görevler arasında /clear kullan

## Yerel Ortam
- Python komutu: python (veya py / python3)
- Kabuk: Windows üzerinde Git Bash
- IDE: Claude Code eklentisi ile VS Code

## İletişim Stili
- Yanıtları kısa tut
- Tüm kod referanslarında dosya yollarını göster
- Mimari kararları kısaca açıkla

## Kişisel Kısayollar
- "review" dediğimde, son değiştirilen dosyalar üzerinde /code-review çalıştır
- "status" dediğimde, git durumu + sprint ilerleme durumunu göster
```

## Kurulum

1. Bu şablonu proje kök dizinine kopyalayın: `cp .claude/docs/CLAUDE-local-template.md CLAUDE.local.md`
2. Tercihlerinize göre düzenleyin
3. `CLAUDE.local.md` dosyasının `.gitignore` içinde yer aldığını doğrulayın (Claude Code bunu proje kök dizininden okur)
